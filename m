Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934627AbaGPGWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 02:22:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932735AbaGPGV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 02:21:58 -0400
From: Jason Wang <jasowang@redhat.com>
To: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH net-next V2 0/3] rx busy polling support for virtio-net 
Date: Wed, 16 Jul 2014 14:21:44 +0800
Message-Id: <1405491707-22706-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all:

This series introduces the support for rx busy polling support. This
was useful for reduing the latency for a kvm guest. Patch 1-2
introduces helpers which is used for rx busy polling. Patch 3
implement the main function.

Test was done between a kvm guest and an external host. Two hosts were
connected through 40gb mlx4 cards. With both busy_poll and busy_read are
set to 50 in guest, 1 byte netperf tcp_rr shows 116% improvement:
transaction rate was increased from 9151.94 to 19787.37.

Changes from V1:
- split the patch info smaller ones
- add more details about test setup/configuration

Please review.

Jason Wang (3):
  virtio-net: introduce helpers to enable and disable all NAPIs
  virtio-net: introduce virtnet_receive()
  virtio-net: rx busy polling support

 drivers/net/virtio_net.c | 234 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 221 insertions(+), 13 deletions(-)

-- 
1.8.3.1

