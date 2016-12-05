#!/bin/bash

# build ZeroMQ stack and install to /usr/local/

die () {
    echo "FATAL: $@" >&2
    exit 1
}

touch /usr/local/_test || die "Make /usr/local accessible again (chmod a+rwx)"

rm /usr/local/_test

for repo in libzmq czmq malamute zyre; do
    if [[ -d "${repo}.git" ]]; then
        pushd "${repo}.git"
        git pull
        popd
    else
        git clone https://github.com/zeromq/${repo} "${repo}.git" || die "git clone failed"
    fi
    pushd "${repo}.git"
    ./autogen.sh
    ./configure
    make
    make check
    make install
    popd
done