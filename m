Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaDQPuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:50:11 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:55122 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbaDQPtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:49:55 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH next 1/4] blk-mq: free hctx->ctx_map when init failed
Date: Thu, 17 Apr 2014 23:49:35 +0800
Message-Id: <1397749778-14485-2-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397749778-14485-1-git-send-email-tom.leiming@gmail.com>
References: <1397749778-14485-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid memory leak in the failure path.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-mq.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index ee225cc..5fbbb22 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1289,6 +1289,7 @@ static int blk_mq_init_hw_queues(struct request_queue *q,
 
 		blk_mq_unregister_cpu_notifier(&hctx->cpu_notifier);
 		kfree(hctx->ctxs);
+		kfree(hctx->ctx_map);
 	}
 
 	return 1;
-- 
1.7.9.5

