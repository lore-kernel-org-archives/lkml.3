Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab3BSIDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:03:48 -0500
Received: from ozlabs.org ([203.10.76.45]:57636 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758264Ab3BSICt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:02:49 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Asias He <asias@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 13/16] caif_virtio: use simplified virtqueue accessors.
Date: Tue, 19 Feb 2013 18:26:31 +1030
Message-Id: <1361260594-601-14-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au>
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We never add buffers with input and output parts, so use the new accessors.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/net/caif/caif_virtio.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
index df832e7..9360055 100644
--- a/drivers/net/caif/caif_virtio.c
+++ b/drivers/net/caif/caif_virtio.c
@@ -364,8 +364,7 @@ static int cfv_netdev_tx(struct sk_buff *skb, struct net_device *netdev)
 	/* Add buffer to avail ring. Flow control below should ensure
 	 * that this always succeedes
 	 */
-	ret = virtqueue_add_buf(cfv->vq_tx, &sg, 1, 0,
-				buf_info, GFP_ATOMIC);
+	ret = virtqueue_add_outbuf(cfv->vq_tx, &sg, 1, buf_info, GFP_ATOMIC);
 
 	if (unlikely(WARN_ON(ret < 0))) {
 		kfree(buf_info);
-- 
1.7.10.4

