Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab3CSNLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 09:11:12 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:60660 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab3CSNLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 09:11:11 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] drivers: message: i2o: Use kstrdup function
Date: Tue, 19 Mar 2013 06:05:28 +0200
Message-Id: <1363665928-31354-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kstrdup instead kmalloc and strcpy.
Patch found using coccinelle

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 drivers/message/i2o/memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/message/i2o/memory.c b/drivers/message/i2o/memory.c
index 292b41e..1741a59 100644
--- a/drivers/message/i2o/memory.c
+++ b/drivers/message/i2o/memory.c
@@ -270,10 +270,9 @@ EXPORT_SYMBOL_GPL(i2o_dma_realloc);
 int i2o_pool_alloc(struct i2o_pool *pool, const char *name,
 				 size_t size, int min_nr)
 {
-	pool->name = kmalloc(strlen(name) + 1, GFP_KERNEL);
+	pool->name = kstrdup(name, GFP_KERNEL);
 	if (!pool->name)
 		goto exit;
-	strcpy(pool->name, name);
 
 	pool->slab =
 	    kmem_cache_create(pool->name, size, 0, SLAB_HWCACHE_ALIGN, NULL);
-- 
1.7.9.5

