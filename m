Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbaEJRCb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 13:02:31 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:60115 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055AbaEJRC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 13:02:29 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 3/5] blk-mq: bitmap tag: select random tag betweet 0 and (depth - 1)
Date: Sun, 11 May 2014 01:01:50 +0800
Message-Id: <1399741312-10453-4-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399741312-10453-1-git-send-email-tom.leiming@gmail.com>
References: <1399741312-10453-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The selected tag should be selected at random between 0 and
(depth - 1) with probability 1/depth, instead between 0 and
(depth - 2) with probability 1/(depth - 1).

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-mq-tag.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 777aad7..77d2b18 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -427,7 +427,7 @@ void blk_mq_tag_init_last_tag(struct blk_mq_tags *tags, unsigned int *tag)
 {
 	unsigned int depth = tags->nr_tags - tags->nr_reserved_tags;
 
-	*tag = prandom_u32() % (depth - 1);
+	*tag = prandom_u32() % depth;
 }
 
 ssize_t blk_mq_tag_sysfs_show(struct blk_mq_tags *tags, char *page)
-- 
1.7.9.5

