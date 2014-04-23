Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbaDWQHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:07:45 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:54806 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbaDWQHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:07:44 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] blk-mq: fix leak of set->tags
Date: Thu, 24 Apr 2014 00:07:34 +0800
Message-Id: <1398269254-14727-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set->tags should be freed in blk_mq_free_tag_set().

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-mq.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c26b3be..cea1bd8 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1562,6 +1562,7 @@ void blk_mq_free_tag_set(struct blk_mq_tag_set *set)
 
 	for (i = 0; i < set->nr_hw_queues; i++)
 		blk_mq_free_rq_map(set, set->tags[i], i);
+	kfree(set->tags);
 }
 EXPORT_SYMBOL(blk_mq_free_tag_set);
 
-- 
1.7.9.5

