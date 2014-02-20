Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbaBTXee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:34:34 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:58369 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaBTXdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:33:52 -0500
Message-Id: <20140220233352.290066735@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 20 Feb 2014 15:32:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 1/3] blk-mq: remove blk_mq_alloc_rq
References: <20140220233235.443299098@bombadil.infradead.org>
Content-Disposition: inline; filename=0001-blk-mq-remove-blk_mq_alloc_rq.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's only one caller, which is a straight wrapper and fits the naming
scheme of the related functions a lot better.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 1fa9dd1..1e585e3 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -73,8 +73,8 @@ static void blk_mq_hctx_mark_pending(struct blk_mq_hw_ctx *hctx,
 		set_bit(ctx->index_hw, hctx->ctx_map);
 }
 
-static struct request *blk_mq_alloc_rq(struct blk_mq_hw_ctx *hctx, gfp_t gfp,
-				       bool reserved)
+static struct request *__blk_mq_alloc_request(struct blk_mq_hw_ctx *hctx,
+					      gfp_t gfp, bool reserved)
 {
 	struct request *rq;
 	unsigned int tag;
@@ -193,12 +193,6 @@ static void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
 	ctx->rq_dispatched[rw_is_sync(rw_flags)]++;
 }
 
-static struct request *__blk_mq_alloc_request(struct blk_mq_hw_ctx *hctx,
-					      gfp_t gfp, bool reserved)
-{
-	return blk_mq_alloc_rq(hctx, gfp, reserved);
-}
-
 static struct request *blk_mq_alloc_request_pinned(struct request_queue *q,
 						   int rw, gfp_t gfp,
 						   bool reserved)
-- 
1.7.10.4


