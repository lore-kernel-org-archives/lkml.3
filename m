Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaJWVYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 17:24:41 -0400
Received: from mail.kernel.org ([198.145.19.201]:51292 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbaJWVYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 17:24:38 -0400
Date: Fri, 24 Oct 2014 00:28:10 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: cornelia.huck@de.ibm.com, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH RFC 4/4] virtio_net: bigger header when VERSION_1 is set
Message-ID: <1414099656-28090-4-git-send-email-mst@redhat.com>
References: <1414099656-28090-1-git-send-email-mst@redhat.com>
 <1414099656-28090-2-git-send-email-mst@redhat.com>
 <1414099656-28090-3-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414099656-28090-3-git-send-email-mst@redhat.com>
X-Mailer: git-send-email 2.0.0.545.gd9cabeb
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With VERSION_1 virtio_net uses same header size
whether mergeable buffers are enabled or not.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/virtio_net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 9c6d50f..a2fe340 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1764,7 +1764,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
 		vi->mergeable_rx_bufs = true;
 
-	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF) ||
+	    virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
 		vi->hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
 	else
 		vi->hdr_len = sizeof(struct virtio_net_hdr);
-- 
MST

