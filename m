Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688AbaFJEwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 00:52:24 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:45411 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaFJEwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 00:52:23 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH] blk-mq: kick requeue list in blk_mq_requeue_request()
Date: Tue, 10 Jun 2014 12:52:05 +0800
Message-Id: <1402375925-21720-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_mq_requeue_request() should kick off the requeue list so
that the request can be scheduled to queue finally.

In nvme conversion patch, blk_mq_requeue_request() is called
to requeue failed request from completion handler, this patch
fixes the issue and makes the block API working as expected.

Cc: Matias Bjørling <m@bjorling.me>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-mq.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index cb4c785..4c78539 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -462,6 +462,7 @@ void blk_mq_requeue_request(struct request *rq)
 
 	BUG_ON(blk_queued_rq(rq));
 	blk_mq_add_to_requeue_list(rq, true);
+	blk_mq_kick_requeue_list(rq->q);
 }
 EXPORT_SYMBOL(blk_mq_requeue_request);
 
-- 
1.7.9.5

