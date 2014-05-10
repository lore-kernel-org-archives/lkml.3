Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbaEJRCk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 13:02:40 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:47344 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055AbaEJRCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 13:02:37 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 4/5] blk-mq: bitmap tag: cleanup blk_mq_init_tags
Date: Sun, 11 May 2014 01:01:51 +0800
Message-Id: <1399741312-10453-5-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399741312-10453-1-git-send-email-tom.leiming@gmail.com>
References: <1399741312-10453-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both nr_cache and nr_tags arn't needed for bitmap tag anymore.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-mq-tag.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 77d2b18..6532aea 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -394,7 +394,6 @@ enomem:
 struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 				     unsigned int reserved_tags, int node)
 {
-	unsigned int nr_tags, nr_cache;
 	struct blk_mq_tags *tags;
 
 	if (total_tags > BLK_MQ_TAG_MAX) {
@@ -406,9 +405,6 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 	if (!tags)
 		return NULL;
 
-	nr_tags = total_tags - reserved_tags;
-	nr_cache = nr_tags / num_online_cpus();
-
 	tags->nr_tags = total_tags;
 	tags->nr_reserved_tags = reserved_tags;
 
-- 
1.7.9.5

