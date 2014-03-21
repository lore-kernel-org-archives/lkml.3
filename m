Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761062AbaCUQvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 12:51:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:43735 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbaCUQvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 12:51:20 -0400
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] blk-mq: initialize resid_len
Date: Fri, 21 Mar 2014 17:30:58 +0100
Message-Id: <1395419460-28229-2-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1395419460-28229-1-git-send-email-hch@lst.de>
References: <1395419460-28229-1-git-send-email-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index b1bcc61..44f738e 100644
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

