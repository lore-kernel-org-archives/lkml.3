Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933337AbaCQNjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:39:52 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51812 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933267AbaCQNbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:31:35 -0400
Message-Id: <20140317133135.398130517@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 17 Mar 2014 06:28:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 27/39] blk-mq: export blk_mq_insert_request
References: <20140317132733.789623766@bombadil.infradead.org>
Content-Disposition: inline; filename=0027-blk-mq-export-blk_mq_insert_request.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'll need this for now when scsi is built as a module.  Eventually
I hope to be able to move it to a higher level API intead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 6f04dda..4408c70 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -740,6 +740,7 @@ void blk_mq_insert_request(struct request *rq, bool at_head, bool run_queue,
 	if (run_queue)
 		blk_mq_run_hw_queue(hctx, async);
 }
+EXPORT_SYMBOL(blk_mq_insert_request);
 
 static void blk_mq_insert_requests(struct request_queue *q,
 				     struct blk_mq_ctx *ctx,
-- 
1.7.10.4


