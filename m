Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbaKXLy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 06:54:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492AbaKXLyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 06:54:23 -0500
Date: Mon, 24 Nov 2014 13:54:08 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v3 21/41] virtio_net: stricter short buffer length checks
Message-ID: <1416829787-14252-22-git-send-email-mst@redhat.com>
References: <1416829787-14252-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416829787-14252-1-git-send-email-mst@redhat.com>
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
index 516f2cb..098f443 100644
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

