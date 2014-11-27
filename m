Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbaK0MdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:33:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755697AbaK0MdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:33:11 -0500
Date: Thu, 27 Nov 2014 14:32:49 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v5 33/45] virtio_net: disable mac write for virtio 1.0
Message-ID: <1417091078-24611-34-git-send-email-mst@redhat.com>
References: <1417091078-24611-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417091078-24611-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The spec states that mac in config space is only driver-writable in the
legacy case.  Fence writing it in virtnet_set_mac_address() in the
virtio 1.0 case.

Suggested-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/virtio_net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index c6a72d3..9ab3c50 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1030,7 +1030,8 @@ static int virtnet_set_mac_address(struct net_device *dev, void *p)
 				 "Failed to set mac address by vq command.\n");
 			return -EINVAL;
 		}
-	} else if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC)) {
+	} else if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC) &&
+		   !virtio_has_feature(vdev, VIRTIO_F_VERSION_1)) {
 		unsigned int i;
 
 		/* Naturally, this has an atomicity problem. */
-- 
MST

