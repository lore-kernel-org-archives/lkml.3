Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458AbaCQNdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:33:53 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51824 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933305AbaCQNbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:31:37 -0400
Message-Id: <20140317133137.284157634@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 17 Mar 2014 06:28:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 38/39] blk-mq: make blk_mq_start_stopped_hw_queues run a queue even if not
 stopped
References: <20140317132733.789623766@bombadil.infradead.org>
Content-Disposition: inline; filename=0038-blk-mq-make-blk_mq_start_stopped_hw_queues-run-a-que.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need this as a workaround for the scsi midlayer, should be fixed in
a nicer way eventually.
---
 block/blk-mq.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4408c70..4950f8e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -677,10 +677,8 @@ void blk_mq_start_stopped_hw_queues(struct request_queue *q, bool async)
 	int i;
 
 	queue_for_each_hw_ctx(q, hctx, i) {
-		if (!test_bit(BLK_MQ_S_STOPPED, &hctx->state))
-			continue;
-
-		clear_bit(BLK_MQ_S_STOPPED, &hctx->state);
+		if (test_bit(BLK_MQ_S_STOPPED, &hctx->state))
+			clear_bit(BLK_MQ_S_STOPPED, &hctx->state);
 		blk_mq_run_hw_queue(hctx, async);
 	}
 }
-- 
1.7.10.4


