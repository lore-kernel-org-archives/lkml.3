Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbaJWVYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 17:24:37 -0400
Received: from mail.kernel.org ([198.145.19.201]:51272 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbaJWVYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 17:24:34 -0400
Date: Fri, 24 Oct 2014 00:28:05 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: cornelia.huck@de.ibm.com, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH RFC 3/4] virtio_net: stricter short buffer length checks
Message-ID: <1414099656-28090-3-git-send-email-mst@redhat.com>
References: <1414099656-28090-1-git-send-email-mst@redhat.com>
 <1414099656-28090-2-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414099656-28090-2-git-send-email-mst@redhat.com>
X-Mailer: git-send-email 2.0.0.545.gd9cabeb
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our buffer length check is not strict enough for mergeable
buffers: buffer can still be shorter that header + address
by 2 bytes.

Fix that up.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/virtio_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index a795a23..9c6d50f 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -437,7 +437,7 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
 	struct sk_buff *skb;
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
 
-	if (unlikely(len < sizeof(struct virtio_net_hdr) + ETH_HLEN)) {
+	if (unlikely(len < vi->hdr_len + ETH_HLEN)) {
 		pr_debug("%s: short packet %i\n", dev->name, len);
 		dev->stats.rx_length_errors++;
 		if (vi->mergeable_rx_bufs) {
-- 
MST

