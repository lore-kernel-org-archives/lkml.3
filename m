Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933848AbaGWW4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 18:56:38 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:52935 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933641AbaGWW4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 18:56:37 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Benjamin LaHaise <bcrl@kvack.org>, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 1/9] blk-mq: export blk_mq_freeze_queue and blk_mq_unfreeze_queue
Date: Thu, 24 Jul 2014 06:55:22 +0800
Message-Id: <1406156130-15575-2-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406156130-15575-1-git-send-email-ming.lei@canonical.com>
References: <1406156130-15575-1-git-send-email-ming.lei@canonical.com>
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
index 5189cb1..07e1033 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -120,8 +120,9 @@ void blk_mq_freeze_queue(struct request_queue *q)
 	blk_mq_run_queues(q, false);
 	wait_event(q->mq_freeze_wq, percpu_ref_is_zero(&q->mq_usage_counter));
 }
+EXPORT_SYMBOL(blk_mq_freeze_queue);
 
-static void blk_mq_unfreeze_queue(struct request_queue *q)
+void blk_mq_unfreeze_queue(struct request_queue *q)
 {
 	bool wake = false;
 
@@ -134,6 +135,7 @@ static void blk_mq_unfreeze_queue(struct request_queue *q)
 		wake_up_all(&q->mq_freeze_wq);
 	}
 }
+EXPORT_SYMBOL(blk_mq_unfreeze_queue);
 
 bool blk_mq_can_queue(struct blk_mq_hw_ctx *hctx)
 {
diff --git a/block/blk-mq.h b/block/blk-mq.h
index ca4964a..3800316 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -28,7 +28,6 @@ struct blk_mq_ctx {
 void __blk_mq_complete_request(struct request *rq);
 void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
 void blk_mq_init_flush(struct request_queue *q);
-void blk_mq_freeze_queue(struct request_queue *q);
 void blk_mq_free_queue(struct request_queue *q);
 void blk_mq_clone_flush_request(struct request *flush_rq,
 		struct request *orig_rq);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index eb726b9..1cc1baa 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -175,6 +175,8 @@ void blk_mq_start_hw_queues(struct request_queue *q);
 void blk_mq_start_stopped_hw_queues(struct request_queue *q, bool async);
 void blk_mq_delay_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs);
 void blk_mq_tag_busy_iter(struct blk_mq_tags *tags, void (*fn)(void *data, unsigned long *), void *data);
+void blk_mq_freeze_queue(struct request_queue *q);
+void blk_mq_unfreeze_queue(struct request_queue *q);
 
 /*
  * Driver command data is immediately after the request. So subtract request
-- 
1.7.9.5

