Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163AbaLAQFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:05:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133AbaLAQFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:05:19 -0500
Date: Mon, 1 Dec 2014 18:05:00 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v8 27/50] virtio_net: disable mac write for virtio 1.0
Message-ID: <1417449619-24896-28-git-send-email-mst@redhat.com>
References: <1417449619-24896-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417449619-24896-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The spec states that mac in config space is only driver-writable in the
legacy case.  Fence writing it in virtnet_set_mac_address() in the
virtio 1.0 case.

Suggested-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
---
 drivers/net/virtio_net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index a0e64cf..b8bd719 100644
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

