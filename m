Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbaBSMUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 07:20:41 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:59931 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaBSMUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 07:20:40 -0500
Date: Wed, 19 Feb 2014 20:20:21 +0800
From: Shaohua Li <shli@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk
Subject: [patch]blk-mq: add REQ_SYNC early
Message-ID: <20140219122021.GA17818@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add REQ_SYNC early, so rq_dispatched[] in blk_mq_rq_ctx_init is set correctly.

Signed-off-by: Shaohua Li<shli@fusionio.com>
---
 block/blk-mq.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/block/blk-mq.c
===================================================================
--- linux.orig/block/blk-mq.c	2014-02-19 17:10:02.000000000 +0800
+++ linux/block/blk-mq.c	2014-02-19 18:51:25.082774359 +0800
@@ -926,6 +926,8 @@ static void blk_mq_make_request(struct r
 	ctx = blk_mq_get_ctx(q);
 	hctx = q->mq_ops->map_queue(q, ctx->cpu);
 
+	if (is_sync)
+		rw |= REQ_SYNC;
 	trace_block_getrq(q, bio, rw);
 	rq = __blk_mq_alloc_request(hctx, GFP_ATOMIC, false);
 	if (likely(rq))
