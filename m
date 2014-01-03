Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaACL3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 06:29:25 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:57878 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaACL3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 06:29:16 -0500
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] block: blk-mq: fix initializing request's start time
Date: Fri,  3 Jan 2014 19:29:04 +0800
Message-Id: <1388748544-14156-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_rq_init() is called in req's complete handler to initialize
the request, so the members of start_time and start_time_ns might
become inaccurate when it is allocated in future.

The patch initializes the two members in blk_mq_rq_ctx_init() to
fix the problem.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-mq.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 0974a26..68734f87 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -188,6 +188,8 @@ static void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
 
 	rq->mq_ctx = ctx;
 	rq->cmd_flags = rw_flags;
+	rq->start_time = jiffies;
+	set_start_time_ns(rq);
 	ctx->rq_dispatched[rw_is_sync(rw_flags)]++;
 }
 
-- 
1.7.9.5

