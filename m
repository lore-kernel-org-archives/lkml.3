Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966679Ab3HHVI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 17:08:29 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:53924 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966542Ab3HHVI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 17:08:27 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Arnd Bergmann <arnd@arndb.de>, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 2/4] asm-generic: Use different include guards
Date: Thu,  8 Aug 2013 21:07:00 +0000
Message-Id: <1375996022-8298-3-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375996022-8298-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1375996022-8298-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For consistency, use different include guards in
include/asm-generic/dma-mapping-{broken,common}.h, even though it is
unlikely (if not outright a bug) to ever include both.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/asm-generic/dma-mapping-broken.h |    6 +++---
 include/asm-generic/dma-mapping-common.h |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/asm-generic/dma-mapping-broken.h b/include/asm-generic/dma-mapping-broken.h
index 6c32af9..34621ea 100644
--- a/include/asm-generic/dma-mapping-broken.h
+++ b/include/asm-generic/dma-mapping-broken.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_GENERIC_DMA_MAPPING_H
-#define _ASM_GENERIC_DMA_MAPPING_H
+#ifndef _ASM_GENERIC_DMA_MAPPING_BROKEN_H
+#define _ASM_GENERIC_DMA_MAPPING_BROKEN_H
 
 /* define the dma api to allow compilation but not linking of
  * dma dependent code.  Code that depends on the dma-mapping
@@ -92,4 +92,4 @@ extern void
 dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	       enum dma_data_direction direction);
 
-#endif /* _ASM_GENERIC_DMA_MAPPING_H */
+#endif /* _ASM_GENERIC_DMA_MAPPING_BROKEN_H */
diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-generic/dma-mapping-common.h
index de8bf89..2ae73e6 100644
--- a/include/asm-generic/dma-mapping-common.h
+++ b/include/asm-generic/dma-mapping-common.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_GENERIC_DMA_MAPPING_H
-#define _ASM_GENERIC_DMA_MAPPING_H
+#ifndef _ASM_GENERIC_DMA_MAPPING_COMMON_H
+#define _ASM_GENERIC_DMA_MAPPING_COMMON_H
 
 #include <linux/kmemcheck.h>
 #include <linux/bug.h>
-- 
1.7.9.5

