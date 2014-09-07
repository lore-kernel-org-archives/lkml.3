Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbaIGIj4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 04:39:56 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:63350 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbaIGIjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 04:39:53 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 6/6] blk-mq: don't copy pdu any more for flush req
Date: Sun,  7 Sep 2014 16:39:22 +0800
Message-Id: <1410079162-9872-7-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410079162-9872-1-git-send-email-ming.lei@canonical.com>
References: <1410079162-9872-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The in-tree drivers which need to handle flush request
have implemented init_flush_rq already, so don't
copy pdu any more for flush req.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-mq.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 113d58d..16f595f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -287,15 +287,8 @@ void blk_mq_free_request(struct request *rq)
 void blk_mq_clone_flush_request(struct request *flush_rq,
 		struct request *orig_rq)
 {
-	struct blk_mq_hw_ctx *hctx =
-		orig_rq->q->mq_ops->map_queue(orig_rq->q, orig_rq->mq_ctx->cpu);
-
 	flush_rq->mq_ctx = orig_rq->mq_ctx;
 	flush_rq->tag = orig_rq->tag;
-
-	if (!orig_rq->q->mq_ops->init_flush_rq)
-		memcpy(blk_mq_rq_to_pdu(flush_rq),
-			blk_mq_rq_to_pdu(orig_rq), hctx->cmd_size);
 }
 
 inline void __blk_mq_end_io(struct request *rq, int error)
-- 
1.7.9.5

