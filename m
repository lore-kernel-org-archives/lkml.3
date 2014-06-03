Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbaFCDY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 23:24:27 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:38098 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbaFCDY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 23:24:26 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] blk-mq: fix sparse warning on missed __percpu annotation
Date: Tue,  3 Jun 2014 11:24:06 +0800
Message-Id: <1401765846-28160-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'struct blk_mq_ctx' is  __percpu, so add the annotation 
and fix the sparse warning reported from Fengguang:

	[block:for-linus 2/3] block/blk-mq.h:75:16: sparse: incorrect
	type in initializer (different address spaces)

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-mq.c         |    2 +-
 include/linux/blkdev.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 43eb315..3bb4cfe 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1767,7 +1767,7 @@ static void blk_mq_add_queue_tag_set(struct blk_mq_tag_set *set,
 struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 {
 	struct blk_mq_hw_ctx **hctxs;
-	struct blk_mq_ctx *ctx;
+	struct blk_mq_ctx __percpu *ctx;
 	struct request_queue *q;
 	unsigned int *map;
 	int i;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2f3886e..3cd426e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -335,7 +335,7 @@ struct request_queue {
 	unsigned int		*mq_map;
 
 	/* sw queues */
-	struct blk_mq_ctx	*queue_ctx;
+	struct blk_mq_ctx __percpu	*queue_ctx;
 	unsigned int		nr_queues;
 
 	/* hw dispatch queues */
-- 
1.7.9.5

