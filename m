Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbaBGSYF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 13:24:05 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:35114 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbaBGSXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 13:23:20 -0500
Message-Id: <20140207182320.061227817@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Fri, 07 Feb 2014 10:22:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 4/4] blk-mq: initialize sg_reserved_size
References: <20140207182235.659185141@bombadil.infradead.org>
Content-Disposition: inline; filename=0004-blk-mq-initialize-sg_reserved_size.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To behave the same way as the old request path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 35800e1..f5fcd9a 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1373,6 +1373,8 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_reg *reg,
 	q->mq_ops = reg->ops;
 	q->queue_flags |= QUEUE_FLAG_MQ_DEFAULT;
 
+	q->sg_reserved_size = INT_MAX;
+
 	blk_queue_make_request(q, blk_mq_make_request);
 	blk_queue_rq_timed_out(q, reg->ops->timeout);
 	if (reg->timeout)
-- 
1.7.10.4


