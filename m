Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbaELBoA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:44:00 -0400
Received: from 1wt.eu ([62.212.114.60]:34758 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391AbaELBn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:43:57 -0400
Message-Id: <20140512003204.918321765@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:43 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sridhar Samudrala <sri@us.ibm.com>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 103/143] virtio-net: alloc big buffers also when guest can receive UFO
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 0e7ede80d929ff0f830c44a543daa1acd590c749 ]

We should alloc big buffers also when guest can receive UFO
packets to let the big packets fit into guest rx buffer.

Fixes 5c5167515d80f78f6bb538492c423adcae31ad65
(virtio-net: Allow UFO feature to be set and advertised.)

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/virtio_net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index bf6d850..97a56f0 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -904,7 +904,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 	/* If we can receive ANY GSO packets, we must allocate large ones. */
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4)
 	    || virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6)
-	    || virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_ECN))
+	    || virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_ECN)
+	    || virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_UFO))
 		vi->big_packets = true;
 
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
-- 
1.7.12.2.21.g234cd45.dirty



