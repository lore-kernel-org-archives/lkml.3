Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936051Ab3DKJl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 05:41:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935568Ab3DKJl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 05:41:58 -0400
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [net-next PATCH 0/2] vlan TSO support for virtio-net
Date: Thu, 11 Apr 2013 17:32:20 +0800
Message-Id: <1365672742-42258-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series simply enable the vlan TSO support for virtio-net by just initialize
vlan_features for virtio-net and tun which allows vlan TSO packets to be
processed in both TX and RX path for virtio-net.

Netperf shows great improvements on stream tests:

Before:
Guest sending:   4162.35 10^6bits/sec
Guest receiving: 2786.67 10^6bit/sec

After:
Guest sending:   9365.42 10^6bits/sec
Guest receiving: 8085.49 10^6bit/sec

Jason Wang (2):
  virtio-net: initialize vlan_features
  tuntap: initialize vlan_features

 drivers/net/tun.c        |    1 +
 drivers/net/virtio_net.c |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

