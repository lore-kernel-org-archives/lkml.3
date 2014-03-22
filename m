Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318AbaCVIZA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 04:25:00 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:42793 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaCVIY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 04:24:56 -0400
From: behanw@converseincode.com
To: linux@arm.linux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com
Cc: u.kleine-koenig@pengutronix.de, jonathan.austin@arm.com, gerg@uclinux.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, pageexec@freemail.hu,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH] ARM: LLVMLinux: Change "extern inline" to "static inline" in glue-cache.h
Date: Sat, 22 Mar 2014 01:24:51 -0700
Message-Id: <1395476691-23040-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

With compilers which follow the C99 standard (like modern versions of gcc and
clang), "extern inline" does the wrong thing (emits code for an externally
linkable version of the inline function). "static inline" is the correct choice
instead.

Author: Behan Webster <behanw@converseincode.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
Reviewed-by: Mark Charlebois <charlebm@gmail.com>
---
 arch/arm/include/asm/glue-cache.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm/include/asm/glue-cache.h b/arch/arm/include/asm/glue-cache.h
index c81adc0..a3c24cd 100644
--- a/arch/arm/include/asm/glue-cache.h
+++ b/arch/arm/include/asm/glue-cache.h
@@ -130,22 +130,22 @@
 #endif
 
 #ifndef __ASSEMBLER__
-extern inline void nop_flush_icache_all(void) { }
-extern inline void nop_flush_kern_cache_all(void) { }
-extern inline void nop_flush_kern_cache_louis(void) { }
-extern inline void nop_flush_user_cache_all(void) { }
-extern inline void nop_flush_user_cache_range(unsigned long a,
+static inline void nop_flush_icache_all(void) { }
+static inline void nop_flush_kern_cache_all(void) { }
+static inline void nop_flush_kern_cache_louis(void) { }
+static inline void nop_flush_user_cache_all(void) { }
+static inline void nop_flush_user_cache_range(unsigned long a,
 		unsigned long b, unsigned int c) { }
 
-extern inline void nop_coherent_kern_range(unsigned long a, unsigned long b) { }
-extern inline int nop_coherent_user_range(unsigned long a,
+static inline void nop_coherent_kern_range(unsigned long a, unsigned long b) { }
+static inline int nop_coherent_user_range(unsigned long a,
 		unsigned long b) { return 0; }
-extern inline void nop_flush_kern_dcache_area(void *a, size_t s) { }
+static inline void nop_flush_kern_dcache_area(void *a, size_t s) { }
 
-extern inline void nop_dma_flush_range(const void *a, const void *b) { }
+static inline void nop_dma_flush_range(const void *a, const void *b) { }
 
-extern inline void nop_dma_map_area(const void *s, size_t l, int f) { }
-extern inline void nop_dma_unmap_area(const void *s, size_t l, int f) { }
+static inline void nop_dma_map_area(const void *s, size_t l, int f) { }
+static inline void nop_dma_unmap_area(const void *s, size_t l, int f) { }
 #endif
 
 #ifndef MULTI_CACHE
-- 
1.8.3.2

