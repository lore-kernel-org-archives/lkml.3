Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326Ab3GMKwW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 06:52:22 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:57890 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab3GMKwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 06:52:21 -0400
From: Dragos Foianu <dragos.foianu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dragos Foianu <dragos.foianu@gmail.com>
Subject: [PATCH] i2o: replaced string duplication code with kstrdup
Date: Sat, 13 Jul 2013 13:52:10 +0100
Message-Id: <1373719930-12663-1-git-send-email-dragos.foianu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2o_pool_alloc now uses kstrdup instead of duplicating its implementation.

Found usinc coccinelle.

Signed-off-by: Dragos Foianu <dragos.foianu@gmail.com>
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
1.7.10.4

