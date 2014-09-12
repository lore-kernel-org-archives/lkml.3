Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaILOr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:47:57 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:50851 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaILOrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:47:55 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v2 3/9] block: move flush initialization to blk_flush_init
Date: Fri, 12 Sep 2014 22:47:27 +0800
Message-Id: <1410533253-8045-4-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410533253-8045-1-git-send-email-ming.lei@canonical.com>
References: <1410533253-8045-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These fields are always used with the flush request, so
initialize them together.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-core.c  |    3 ---
 block/blk-flush.c |    4 ++++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 0a9d172..222fe84 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -600,9 +600,6 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 #ifdef CONFIG_BLK_CGROUP
 	INIT_LIST_HEAD(&q->blkg_list);
 #endif
-	INIT_LIST_HEAD(&q->flush_queue[0]);
-	INIT_LIST_HEAD(&q->flush_queue[1]);
-	INIT_LIST_HEAD(&q->flush_data_in_flight);
 	INIT_DELAYED_WORK(&q->delay_work, blk_delay_work);
 
 	kobject_init(&q->kobj, &blk_queue_ktype);
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 6932ee8..a5b2a00 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -490,6 +490,10 @@ static int blk_mq_init_flush(struct request_queue *q)
 
 int blk_init_flush(struct request_queue *q)
 {
+	INIT_LIST_HEAD(&q->flush_queue[0]);
+	INIT_LIST_HEAD(&q->flush_queue[1]);
+	INIT_LIST_HEAD(&q->flush_data_in_flight);
+
 	if (q->mq_ops)
 		return blk_mq_init_flush(q);
 
-- 
1.7.9.5

