Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaDSKBq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 06:01:46 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33525 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbaDSKAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 06:00:40 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v1 next 2/4] blk-mq: fix allocation of set->tags
Date: Sat, 19 Apr 2014 18:00:17 +0800
Message-Id: <1397901619-27226-3-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397901619-27226-1-git-send-email-tom.leiming@gmail.com>
References: <1397901619-27226-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

type of set->tags is struct blk_mq_tags **.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-mq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 5fbbb22..c277797 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1537,7 +1537,8 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 		return -EINVAL;
 
 
-	set->tags = kmalloc_node(set->nr_hw_queues * sizeof(struct blk_mq_tags),
+	set->tags = kmalloc_node(set->nr_hw_queues *
+				 sizeof(struct blk_mq_tags *),
 				 GFP_KERNEL, set->numa_node);
 	if (!set->tags)
 		goto out;
-- 
1.7.9.5

