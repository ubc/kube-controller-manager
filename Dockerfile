FROM debian:stretch

ARG KUBERNETES_VERSION=v1.20.14

ENV DEBIAN_FRONTEND=noninteractive \
    container=docker \
    KUBERNETES_DOWNLOAD_ROOT=https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_VERSION}/bin/linux/amd64 \
    KUBERNETES_COMPONENT=kube-controller-manager

RUN set -x \
    && apt-get update \
    && apt-get install -q -yy curl gnupg2 \
    && curl https://raw.githubusercontent.com/ceph/ceph/master/keys/release.asc | apt-key add - \
    && echo deb http://download.ceph.com/debian-jewel/ stretch main | tee /etc/apt/sources.list.d/ceph.list \
    && apt-get update -y \
    && apt-get install -q -yy ceph-common \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && curl -L ${KUBERNETES_DOWNLOAD_ROOT}/${KUBERNETES_COMPONENT} -o /usr/bin/${KUBERNETES_COMPONENT} \
    && chmod +x /usr/bin/${KUBERNETES_COMPONENT} \
    && apt-get purge -y --auto-remove \
        curl gnupg2 \
    && rm -rf /var/lib/apt/lists/*
