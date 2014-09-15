Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbaIOWX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:23:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51355 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933114AbaIOWUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:20:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Chris J Arges <chris.j.arges@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 048/187] blk-mq: fix initializing request's start time
Date: Mon, 15 Sep 2014 15:07:38 -0700
Message-Id: <1410818997-9432-49-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <tom.leiming@gmail.com>

commit 0fec08b4ecfc36fd8a64432343b2964fb86d2675 upstream.

blk_rq_init() is called in req's complete handler to initialize
the request, so the members of start_time and start_time_ns might
become inaccurate when it is allocated in future.

The patch initializes the two members in blk_mq_rq_ctx_init() to
fix the problem.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Chris J Arges <chris.j.arges@canonical.com>
Cc: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 block/blk-mq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 7f9b1f6..2192cf4 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -179,6 +179,8 @@ static void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
 
 	rq->mq_ctx = ctx;
 	rq->cmd_flags = rw_flags;
+	rq->start_time = jiffies;
+	set_start_time_ns(rq);
 	ctx->rq_dispatched[rw_is_sync(rw_flags)]++;
 }
 
-- 
1.9.1

