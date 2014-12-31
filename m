Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaLaNXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 08:23:12 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:61408 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbaLaNXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 08:23:10 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Robert Elliott <elliott@hp.com>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v3 1/5] blk-mq: export blk_mq_freeze_queue and blk_mq_unfreeze_queue
Date: Wed, 31 Dec 2014 13:22:56 +0000
Message-Id: <1420032180-30256-2-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420032180-30256-1-git-send-email-ming.lei@canonical.com>
References: <1420032180-30256-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is handy to use the two helpers for switching backend file
in loop driver, so export them.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-mq.c         |    4 +++-
 block/blk-mq.h         |    1 -
 include/linux/blk-mq.h |    2 ++
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index fbd7c7b..30d673a 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -135,8 +135,9 @@ void blk_mq_freeze_queue(struct request_queue *q)
 	blk_mq_freeze_queue_start(q);
 	blk_mq_freeze_queue_wait(q);
 }
+EXPORT_SYMBOL(blk_mq_freeze_queue);
 
-static void blk_mq_unfreeze_queue(struct request_queue *q)
+void blk_mq_unfreeze_queue(struct request_queue *q)
 {
 	bool wake;
 
@@ -149,6 +150,7 @@ static void blk_mq_unfreeze_queue(struct request_queue *q)
 		wake_up_all(&q->mq_freeze_wq);
 	}
 }
+EXPORT_SYMBOL(blk_mq_unfreeze_queue);
 
 bool blk_mq_can_queue(struct blk_mq_hw_ctx *hctx)
 {
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 206230e..1bc1be9 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -27,7 +27,6 @@ struct blk_mq_ctx {
 
 void __blk_mq_complete_request(struct request *rq);
 void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
-void blk_mq_freeze_queue(struct request_queue *q);
 void blk_mq_free_queue(struct request_queue *q);
 void blk_mq_clone_flush_request(struct request *flush_rq,
 		struct request *orig_rq);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 8aded9a..a855a69 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -212,6 +212,8 @@ void blk_mq_start_stopped_hw_queues(struct request_queue *q, bool async);
 void blk_mq_delay_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs);
 void blk_mq_tag_busy_iter(struct blk_mq_hw_ctx *hctx, busy_iter_fn *fn,
 		void *priv);
+void blk_mq_freeze_queue(struct request_queue *q);
+void blk_mq_unfreeze_queue(struct request_queue *q);
 
 /*
  * Driver command data is immediately after the request. So subtract request
-- 
1.7.9.5

