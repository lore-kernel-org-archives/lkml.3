Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbaDQPxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:53:13 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:60348 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbaDQPuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:50:01 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH next 2/4] blk-mq: fix allocation of set->tags
Date: Thu, 17 Apr 2014 23:49:36 +0800
Message-Id: <1397749778-14485-3-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397749778-14485-1-git-send-email-tom.leiming@gmail.com>
References: <1397749778-14485-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

type of set->tags is struct blk_mq_tags **.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-mq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 5fbbb22..baff2d0 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1537,7 +1537,7 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 		return -EINVAL;
 
 
-	set->tags = kmalloc_node(set->nr_hw_queues * sizeof(struct blk_mq_tags),
+	set->tags = kmalloc_node(set->nr_hw_queues * sizeof(struct blk_mq_tags *),
 				 GFP_KERNEL, set->numa_node);
 	if (!set->tags)
 		goto out;
-- 
1.7.9.5

