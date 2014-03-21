Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761043AbaCUQpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 12:45:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:41501 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbaCUQpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 12:45:39 -0400
X-Greylist: delayed 993 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Mar 2014 12:45:39 EDT
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] blk-mq: fix blk_mq_end_io_partial
Date: Fri, 21 Mar 2014 17:30:59 +0100
Message-Id: <1395419460-28229-3-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1395419460-28229-1-git-send-email-hch@lst.de>
References: <1395419460-28229-1-git-send-email-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
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
index 44f738e..4274ee0 100644
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

