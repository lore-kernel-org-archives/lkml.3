Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184AbaCQNTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:19:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51707 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283AbaCQNTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:19:41 -0400
Message-Id: <20140317131940.920764722@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 17 Mar 2014 06:18:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] blk-mq: fix blk_mq_end_io_partial
References: <20140317131827.793657833@bombadil.infradead.org>
Content-Disposition: inline; filename=0001-blk-mq-fix-blk_mq_end_io_partial.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to pass the actual nr_bytes instead of all bytes in the request.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 883f720..d81dc8b 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -285,7 +285,7 @@ void blk_mq_free_request(struct request *rq)
 
 bool blk_mq_end_io_partial(struct request *rq, int error, unsigned int nr_bytes)
 {
-	if (blk_update_request(rq, error, blk_rq_bytes(rq)))
+	if (blk_update_request(rq, error, nr_bytes))
 		return true;
 
 	blk_account_io_done(rq);
-- 
1.7.10.4


