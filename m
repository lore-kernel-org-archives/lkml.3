Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbaBVODv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 09:03:51 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:37031 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbaBVODt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 09:03:49 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] sh: Prefix sh-specific "CCR" and "CCR2" by "SH_"
Date: Sat, 22 Feb 2014 15:03:39 +0100
Message-Id: <1393077819-18872-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit bcf24e1daa94f4c52ef7a3f657e43cc6bc50d46b ("mmc: omap_hsmmc: use the
generic config for omap2plus devices"), enabled the build for other
platforms for compile testing.

sh-allmodconfig now fails with:

    include/linux/omap-dma.h:171:8: error: expected identifier before numeric constant
    make[4]: *** [drivers/mmc/host/omap_hsmmc.o] Error 1

This happens because SuperH #defines "CCR", which is one of the enum values
in include/linux/omap-dma.h. There's a similar issue with "CCR2" on sh2a.

As "CCR" and "CCR2" are too generic names for global #defines, prefix them
with "SH_" to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/sh/include/cpu-sh2/cpu/cache.h  |    2 +-
 arch/sh/include/cpu-sh2a/cpu/cache.h |    4 ++--
 arch/sh/include/cpu-sh3/cpu/cache.h  |    2 +-
 arch/sh/include/cpu-sh4/cpu/cache.h  |    2 +-
 arch/sh/kernel/cpu/init.c            |    4 ++--
 arch/sh/mm/cache-debugfs.c           |    2 +-
 arch/sh/mm/cache-sh2.c               |    4 ++--
 arch/sh/mm/cache-sh2a.c              |    6 ++++--
 arch/sh/mm/cache-sh4.c               |    4 ++--
 arch/sh/mm/cache-shx3.c              |    4 ++--
 arch/sh/mm/cache.c                   |    4 ++--
 11 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/arch/sh/include/cpu-sh2/cpu/cache.h b/arch/sh/include/cpu-sh2/cpu/cache.h
index 673515bc4135..aa1b2b9088a7 100644
--- a/arch/sh/include/cpu-sh2/cpu/cache.h
+++ b/arch/sh/include/cpu-sh2/cpu/cache.h
@@ -18,7 +18,7 @@
 #define SH_CACHE_ASSOC		8
 
 #if defined(CONFIG_CPU_SUBTYPE_SH7619)
-#define CCR		0xffffffec
+#define SH_CCR		0xffffffec
 
 #define CCR_CACHE_CE	0x01	/* Cache enable */
 #define CCR_CACHE_WT	0x02    /* CCR[bit1=1,bit2=1] */
diff --git a/arch/sh/include/cpu-sh2a/cpu/cache.h b/arch/sh/include/cpu-sh2a/cpu/cache.h
index defb0baa5a06..b27ce92cb600 100644
--- a/arch/sh/include/cpu-sh2a/cpu/cache.h
+++ b/arch/sh/include/cpu-sh2a/cpu/cache.h
@@ -17,8 +17,8 @@
 #define SH_CACHE_COMBINED	4
 #define SH_CACHE_ASSOC		8
 
-#define CCR		0xfffc1000 /* CCR1 */
-#define CCR2		0xfffc1004
+#define SH_CCR		0xfffc1000 /* CCR1 */
+#define SH_CCR2		0xfffc1004
 
 /*
  * Most of the SH-2A CCR1 definitions resemble the SH-4 ones. All others not
diff --git a/arch/sh/include/cpu-sh3/cpu/cache.h b/arch/sh/include/cpu-sh3/cpu/cache.h
index bee2d81c56bf..29700fd88c75 100644
--- a/arch/sh/include/cpu-sh3/cpu/cache.h
+++ b/arch/sh/include/cpu-sh3/cpu/cache.h
@@ -17,7 +17,7 @@
 #define SH_CACHE_COMBINED	4
 #define SH_CACHE_ASSOC		8
 
-#define CCR		0xffffffec	/* Address of Cache Control Register */
+#define SH_CCR		0xffffffec	/* Address of Cache Control Register */
 
 #define CCR_CACHE_CE	0x01	/* Cache Enable */
 #define CCR_CACHE_WT	0x02	/* Write-Through (for P0,U0,P3) (else writeback) */
diff --git a/arch/sh/include/cpu-sh4/cpu/cache.h b/arch/sh/include/cpu-sh4/cpu/cache.h
index 7bfb9e8b069c..92c4cd119b66 100644
--- a/arch/sh/include/cpu-sh4/cpu/cache.h
+++ b/arch/sh/include/cpu-sh4/cpu/cache.h
@@ -17,7 +17,7 @@
 #define SH_CACHE_COMBINED	4
 #define SH_CACHE_ASSOC		8
 
-#define CCR		0xff00001c	/* Address of Cache Control Register */
+#define SH_CCR		0xff00001c	/* Address of Cache Control Register */
 #define CCR_CACHE_OCE	0x0001	/* Operand Cache Enable */
 #define CCR_CACHE_WT	0x0002	/* Write-Through (for P0,U0,P3) (else writeback)*/
 #define CCR_CACHE_CB	0x0004	/* Copy-Back (for P1) (else writethrough) */
diff --git a/arch/sh/kernel/cpu/init.c b/arch/sh/kernel/cpu/init.c
index ecf83cd158dc..0d7360d549c1 100644
--- a/arch/sh/kernel/cpu/init.c
+++ b/arch/sh/kernel/cpu/init.c
@@ -112,7 +112,7 @@ static void cache_init(void)
 	unsigned long ccr, flags;
 
 	jump_to_uncached();
-	ccr = __raw_readl(CCR);
+	ccr = __raw_readl(SH_CCR);
 
 	/*
 	 * At this point we don't know whether the cache is enabled or not - a
@@ -189,7 +189,7 @@ static void cache_init(void)
 
 	l2_cache_init();
 
-	__raw_writel(flags, CCR);
+	__raw_writel(flags, SH_CCR);
 	back_to_cached();
 }
 #else
diff --git a/arch/sh/mm/cache-debugfs.c b/arch/sh/mm/cache-debugfs.c
index 115725198038..777e50f33c00 100644
--- a/arch/sh/mm/cache-debugfs.c
+++ b/arch/sh/mm/cache-debugfs.c
@@ -36,7 +36,7 @@ static int cache_seq_show(struct seq_file *file, void *iter)
 	 */
 	jump_to_uncached();
 
-	ccr = __raw_readl(CCR);
+	ccr = __raw_readl(SH_CCR);
 	if ((ccr & CCR_CACHE_ENABLE) == 0) {
 		back_to_cached();
 
diff --git a/arch/sh/mm/cache-sh2.c b/arch/sh/mm/cache-sh2.c
index defcf719f2e8..a74259f2f981 100644
--- a/arch/sh/mm/cache-sh2.c
+++ b/arch/sh/mm/cache-sh2.c
@@ -63,9 +63,9 @@ static void sh2__flush_invalidate_region(void *start, int size)
 	local_irq_save(flags);
 	jump_to_uncached();
 
-	ccr = __raw_readl(CCR);
+	ccr = __raw_readl(SH_CCR);
 	ccr |= CCR_CACHE_INVALIDATE;
-	__raw_writel(ccr, CCR);
+	__raw_writel(ccr, SH_CCR);
 
 	back_to_cached();
 	local_irq_restore(flags);
diff --git a/arch/sh/mm/cache-sh2a.c b/arch/sh/mm/cache-sh2a.c
index 949e2d3138a0..ee87d081259b 100644
--- a/arch/sh/mm/cache-sh2a.c
+++ b/arch/sh/mm/cache-sh2a.c
@@ -134,7 +134,8 @@ static void sh2a__flush_invalidate_region(void *start, int size)
 
 	/* If there are too many pages then just blow the cache */
 	if (((end - begin) >> PAGE_SHIFT) >= MAX_OCACHE_PAGES) {
-		__raw_writel(__raw_readl(CCR) | CCR_OCACHE_INVALIDATE, CCR);
+		__raw_writel(__raw_readl(SH_CCR) | CCR_OCACHE_INVALIDATE,
+			     SH_CCR);
 	} else {
 		for (v = begin; v < end; v += L1_CACHE_BYTES)
 			sh2a_invalidate_line(CACHE_OC_ADDRESS_ARRAY, v);
@@ -167,7 +168,8 @@ static void sh2a_flush_icache_range(void *args)
 	/* I-Cache invalidate */
 	/* If there are too many pages then just blow the cache */
 	if (((end - start) >> PAGE_SHIFT) >= MAX_ICACHE_PAGES) {
-		__raw_writel(__raw_readl(CCR) | CCR_ICACHE_INVALIDATE, CCR);
+		__raw_writel(__raw_readl(SH_CCR) | CCR_ICACHE_INVALIDATE,
+			     SH_CCR);
 	} else {
 		for (v = start; v < end; v += L1_CACHE_BYTES)
 			sh2a_invalidate_line(CACHE_IC_ADDRESS_ARRAY, v);
diff --git a/arch/sh/mm/cache-sh4.c b/arch/sh/mm/cache-sh4.c
index 0e529285b28d..51d8f7f31d1d 100644
--- a/arch/sh/mm/cache-sh4.c
+++ b/arch/sh/mm/cache-sh4.c
@@ -133,9 +133,9 @@ static void flush_icache_all(void)
 	jump_to_uncached();
 
 	/* Flush I-cache */
-	ccr = __raw_readl(CCR);
+	ccr = __raw_readl(SH_CCR);
 	ccr |= CCR_CACHE_ICI;
-	__raw_writel(ccr, CCR);
+	__raw_writel(ccr, SH_CCR);
 
 	/*
 	 * back_to_cached() will take care of the barrier for us, don't add
diff --git a/arch/sh/mm/cache-shx3.c b/arch/sh/mm/cache-shx3.c
index c0adbee97b5f..24c58b7dc022 100644
--- a/arch/sh/mm/cache-shx3.c
+++ b/arch/sh/mm/cache-shx3.c
@@ -19,7 +19,7 @@ void __init shx3_cache_init(void)
 {
 	unsigned int ccr;
 
-	ccr = __raw_readl(CCR);
+	ccr = __raw_readl(SH_CCR);
 
 	/*
 	 * If we've got cache aliases, resolve them in hardware.
@@ -40,5 +40,5 @@ void __init shx3_cache_init(void)
 	ccr |= CCR_CACHE_IBE;
 #endif
 
-	writel_uncached(ccr, CCR);
+	writel_uncached(ccr, SH_CCR);
 }
diff --git a/arch/sh/mm/cache.c b/arch/sh/mm/cache.c
index 616966a96cba..097c2cdd117f 100644
--- a/arch/sh/mm/cache.c
+++ b/arch/sh/mm/cache.c
@@ -285,8 +285,8 @@ void __init cpu_cache_init(void)
 {
 	unsigned int cache_disabled = 0;
 
-#ifdef CCR
-	cache_disabled = !(__raw_readl(CCR) & CCR_CACHE_ENABLE);
+#ifdef SH_CCR
+	cache_disabled = !(__raw_readl(SH_CCR) & CCR_CACHE_ENABLE);
 #endif
 
 	compute_alias(&boot_cpu_data.icache);
-- 
1.7.9.5

