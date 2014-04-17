Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaDQPu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:50:27 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:43836 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbaDQPuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:50:07 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH next 3/4] blk-mq: user (1 << order) to implement order_to_size()
Date: Thu, 17 Apr 2014 23:49:37 +0800
Message-Id: <1397749778-14485-4-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397749778-14485-1-git-send-email-tom.leiming@gmail.com>
References: <1397749778-14485-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-mq.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index baff2d0..1eff3d9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1130,12 +1130,7 @@ static void blk_mq_free_rq_map(struct blk_mq_tag_set *set,
 
 static size_t order_to_size(unsigned int order)
 {
-	size_t ret = PAGE_SIZE;
-
-	while (order--)
-		ret *= 2;
-
-	return ret;
+	return (1 << order) * PAGE_SIZE;
 }
 
 static struct blk_mq_tags *blk_mq_init_rq_map(struct blk_mq_tag_set *set,
-- 
1.7.9.5

