Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab3JKEL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 00:11:27 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:59068 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab3JKEL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 00:11:26 -0400
Date: Fri, 11 Oct 2013 12:11:05 +0800
From: Shaohua Li <shli@kernel.org>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: [PATCH] blk-mq: cache rq->q
Message-ID: <20131011041105.GA1692@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If a tag is freed, the request might be used very soon. There is a short window
rq->q is null, so cache it.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 block/blk-mq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: master/block/blk-mq.c
===================================================================
--- master.orig/block/blk-mq.c	2013-10-11 12:07:32.282133638 +0800
+++ master/block/blk-mq.c	2013-10-11 12:07:32.282133638 +0800
@@ -250,11 +250,12 @@ static void __blk_mq_free_request(struct
 				  struct blk_mq_ctx *ctx, struct request *rq)
 {
 	const int tag = rq->tag;
+	struct request_queue *q = rq->q;
 
 	blk_mq_rq_init(hctx, rq);
 	blk_mq_put_tag(hctx->tags, tag);
 
-	blk_mq_queue_exit(rq->q);
+	blk_mq_queue_exit(q);
 }
 
 void blk_mq_free_request(struct request *rq)
