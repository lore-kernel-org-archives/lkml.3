Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbaDNIbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:31:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:43802 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbaDNI2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:28:04 -0400
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Matias Bjorling <m@bjorling.me>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 1/7] blk-mq: initialize resid_len
Date: Mon, 14 Apr 2014 10:30:06 +0200
Message-Id: <1397464212-4454-2-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1397464212-4454-1-git-send-email-hch@lst.de>
References: <blk-mq updates>
 <1397464212-4454-1-git-send-email-hch@lst.de>
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
index 1d2a9bd..c1f4736 100644
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

