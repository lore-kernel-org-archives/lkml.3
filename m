Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbaCQNTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:19:45 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51710 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367AbaCQNTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:19:41 -0400
Message-Id: <20140317131941.107004487@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 17 Mar 2014 06:18:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] blk-mq: initialize resid_len
References: <20140317131827.793657833@bombadil.infradead.org>
Content-Disposition: inline; filename=0002-blk-mq-initialize-resid_len.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index d81dc8b..e3284f6 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -350,6 +350,8 @@ static void blk_mq_start_request(struct request *rq, bool last)
 
 	trace_block_rq_issue(q, rq);
 
+	rq->resid_len = blk_rq_bytes(rq);
+
 	/*
 	 * Just mark start time and set the started bit. Due to memory
 	 * ordering, we know we'll see the correct deadline as long as
-- 
1.7.10.4


