Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbaLXDEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 22:04:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbaLXDEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 22:04:07 -0500
From: Jason Wang <jasowang@redhat.com>
To: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH net-next V2] virtio-net: don't do header check for dodgy gso packets
Date: Wed, 24 Dec 2014 11:03:52 +0800
Message-Id: <1419390232-14906-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to do header check for virtio-net since:

- Host sets dodgy for all gso packets from guest and check the header.
- Host should be prepared for all kinds of evil packets from guest, since
  malicious guest can send any kinds of packet.

So this patch sets NETIF_F_GSO_ROBUST for virtio-net to skip the check.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
Changes from V1:
- typo fixes
---
 drivers/net/virtio_net.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index b8bd719..45c6ce2 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1761,6 +1761,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_ECN))
 			dev->hw_features |= NETIF_F_TSO_ECN;
 
+		dev->features |= NETIF_F_GSO_ROBUST;
+
 		if (gso)
 			dev->features |= dev->hw_features & NETIF_F_ALL_TSO;
 		/* (!csum && gso) case will be fixed by register_netdev() */
-- 
1.9.1

