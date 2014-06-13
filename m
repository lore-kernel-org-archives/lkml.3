Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbaFMRni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:43:38 -0400
Received: from verein.lst.de ([213.95.11.211]:48279 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669AbaFMRnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:43:37 -0400
Date: Fri, 13 Jun 2014 19:43:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] blk-mq: merge blk_mq_drain_queue and
	__blk_mq_drain_queue
Message-ID: <20140613174335.GA20387@lst.de>
References: <20140613174304.GA20317@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140613174304.GA20317@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 15b3ccd..a719340 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -109,7 +109,7 @@ static void blk_mq_queue_exit(struct request_queue *q)
 	__percpu_counter_add(&q->mq_usage_counter, -1, 1000000);
 }
 
-static void __blk_mq_drain_queue(struct request_queue *q)
+void blk_mq_drain_queue(struct request_queue *q)
 {
 	while (true) {
 		s64 count;
@@ -139,12 +139,7 @@ static void blk_mq_freeze_queue(struct request_queue *q)
 	spin_unlock_irq(q->queue_lock);
 
 	if (drain)
-		__blk_mq_drain_queue(q);
-}
-
-void blk_mq_drain_queue(struct request_queue *q)
-{
-	__blk_mq_drain_queue(q);
+		blk_mq_drain_queue(q);
 }
 
 static void blk_mq_unfreeze_queue(struct request_queue *q)
-- 
1.7.10.4

