Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbaELLwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 07:52:25 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:48523 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbaELLwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 07:52:24 -0400
X-Original-SENDERIP: 165.186.175.39
X-Original-MAILFROM: gioh.kim@lge.com
From: "gioh.kim" <gioh.kim@lge.com>
To: Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: gunho.lee@lge.com, gioh.kim@lge.com
Subject: [PATCH] Documentation/DMA-API-HOWTO.txt: update API descriptions
Date: Mon, 12 May 2014 20:45:52 +0900
Message-Id: <1399895153-29451-1-git-send-email-gioh.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "gioh.kim" <gioh.kim@lge.com>

update descriptions for dma_pool_create and dma_pool_alloc

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
---
 Documentation/DMA-API-HOWTO.txt |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
index 5e98303..e4251a3 100644
--- a/Documentation/DMA-API-HOWTO.txt
+++ b/Documentation/DMA-API-HOWTO.txt
@@ -373,13 +373,13 @@ Create a dma_pool like this:
 
 	struct dma_pool *pool;
 
-	pool = dma_pool_create(name, dev, size, align, alloc);
+	pool = dma_pool_create(name, dev, size, align, boundary);
 
 The "name" is for diagnostics (like a kmem_cache name); dev and size
 are as above.  The device's hardware alignment requirement for this
 type of data is "align" (which is expressed in bytes, and must be a
 power of two).  If your device has no boundary crossing restrictions,
-pass 0 for alloc; passing 4096 says memory allocated from this pool
+pass 0 for boundary; passing 4096 says memory allocated from this pool
 must not cross 4KByte boundaries (but at that time it may be better to
 go for dma_alloc_coherent directly instead).
 
@@ -387,8 +387,8 @@ Allocate memory from a dma pool like this:
 
 	cpu_addr = dma_pool_alloc(pool, flags, &dma_handle);
 
-flags are SLAB_KERNEL if blocking is permitted (not in_interrupt nor
-holding SMP locks), SLAB_ATOMIC otherwise.  Like dma_alloc_coherent,
+flags are GFP_KERNEL if blocking is permitted (not in_interrupt nor
+holding SMP locks), GFP_ATOMIC otherwise.  Like dma_alloc_coherent,
 this returns two values, cpu_addr and dma_handle.
 
 Free memory that was allocated from a dma_pool like this:
-- 
1.7.9.5

