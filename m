Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbaH3QJV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 12:09:21 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34824 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaH3QJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 12:09:19 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>, Christoph Hellwig <hch@infradead.org>,
        Maxim Patlasov <mpatlasov@parallels.com>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v2 1/6] blk-mq: export blk_mq_freeze_queue and blk_mq_unfreeze_queue
Date: Sun, 31 Aug 2014 00:08:22 +0800
Message-Id: <1409414907-22238-2-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409414907-22238-1-git-send-email-ming.lei@canonical.com>
References: <1409414907-22238-1-git-send-email-ming.lei@canonical.com>
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
index 4aac826..3ad7524 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -124,8 +124,9 @@ void blk_mq_freeze_queue(struct request_queue *q)
 	}
 	wait_event(q->mq_freeze_wq, percpu_ref_is_zero(&q->mq_usage_counter));
 }
+EXPORT_SYMBOL(blk_mq_freeze_queue);
 
-static void blk_mq_unfreeze_queue(struct request_queue *q)
+void blk_mq_unfreeze_queue(struct request_queue *q)
 {
 	bool wake;
 
@@ -138,6 +139,7 @@ static void blk_mq_unfreeze_queue(struct request_queue *q)
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
index a1e31f2..c6b2bfa 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -174,6 +174,8 @@ void blk_mq_start_hw_queues(struct request_queue *q);
 void blk_mq_start_stopped_hw_queues(struct request_queue *q, bool async);
 void blk_mq_delay_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs);
 void blk_mq_tag_busy_iter(struct blk_mq_tags *tags, void (*fn)(void *data, unsigned long *), void *data);
+void blk_mq_freeze_queue(struct request_queue *q);
+void blk_mq_unfreeze_queue(struct request_queue *q);
 
 /*
  * Driver command data is immediately after the request. So subtract request
-- 
1.7.9.5

