Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966664Ab3HHVIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 17:08:24 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:39097 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966542Ab3HHVIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 17:08:22 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Arnd Bergmann <arnd@arndb.de>, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 1/4] asm-generic: Make sure include guards contain the substring ASM_GENERIC
Date: Thu,  8 Aug 2013 21:06:59 +0000
Message-Id: <1375996022-8298-2-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375996022-8298-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1375996022-8298-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch ensures that the include guards used in various
include/asm-generic/*.h files contain the substring ASM_GENERIC. This
should reduce the risk of bugs arising from arch/*/asm/foo.h including
asm-generic/foo.h, while both use the same include guard. No such
instances exist, but two near-hits are:

arch/mn10300/include/asm/rtc.h uses _ASM_RTC_H and includes
asm-generic/rtc.h which uses __ASM_RTC_H__

arch/hexagon/include/asm/cacheflush.h uses _ASM_CACHEFLUSH_H and
includes asm-generic/cacheflush.h which uses __ASM_CACHEFLUSH_H

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/asm-generic/cacheflush.h            |    6 +++---
 include/asm-generic/clkdev.h                |    4 ++--
 include/asm-generic/dma-coherent.h          |    4 ++--
 include/asm-generic/dma-contiguous.h        |    4 ++--
 include/asm-generic/io-64-nonatomic-hi-lo.h |    6 +++---
 include/asm-generic/io-64-nonatomic-lo-hi.h |    6 +++---
 include/asm-generic/iomap.h                 |    4 ++--
 include/asm-generic/memory_model.h          |    4 ++--
 include/asm-generic/rtc.h                   |    6 +++---
 include/asm-generic/statfs.h                |    4 ++--
 include/asm-generic/syscall.h               |    6 +++---
 include/asm-generic/word-at-a-time.h        |    6 +++---
 12 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/include/asm-generic/cacheflush.h b/include/asm-generic/cacheflush.h
index 87bc536..c9717ba 100644
--- a/include/asm-generic/cacheflush.h
+++ b/include/asm-generic/cacheflush.h
@@ -1,5 +1,5 @@
-#ifndef __ASM_CACHEFLUSH_H
-#define __ASM_CACHEFLUSH_H
+#ifndef __ASM_GENERIC_CACHEFLUSH_H
+#define __ASM_GENERIC_CACHEFLUSH_H
 
 /* Keep includes the same across arches.  */
 #include <linux/mm.h>
@@ -31,4 +31,4 @@
 #define copy_from_user_page(vma, page, vaddr, dst, src, len) \
 	memcpy(dst, src, len)
 
-#endif /* __ASM_CACHEFLUSH_H */
+#endif /* __ASM_GENERIC_CACHEFLUSH_H */
diff --git a/include/asm-generic/clkdev.h b/include/asm-generic/clkdev.h
index 90a32a6..fb1cad9 100644
--- a/include/asm-generic/clkdev.h
+++ b/include/asm-generic/clkdev.h
@@ -10,8 +10,8 @@
  *
  * Helper for the clk API to assist looking up a struct clk.
  */
-#ifndef __ASM_CLKDEV_H
-#define __ASM_CLKDEV_H
+#ifndef __ASM_GENERIC_CLKDEV_H
+#define __ASM_GENERIC_CLKDEV_H
 
 #include <linux/slab.h>
 
diff --git a/include/asm-generic/dma-coherent.h b/include/asm-generic/dma-coherent.h
index 2be8a2d..33a971e 100644
--- a/include/asm-generic/dma-coherent.h
+++ b/include/asm-generic/dma-coherent.h
@@ -1,5 +1,5 @@
-#ifndef DMA_COHERENT_H
-#define DMA_COHERENT_H
+#ifndef _ASM_GENERIC_DMA_COHERENT_H
+#define _ASM_GENERIC_DMA_COHERENT_H
 
 #ifdef CONFIG_HAVE_GENERIC_DMA_COHERENT
 /*
diff --git a/include/asm-generic/dma-contiguous.h b/include/asm-generic/dma-contiguous.h
index 294b1e7..cedad6b 100644
--- a/include/asm-generic/dma-contiguous.h
+++ b/include/asm-generic/dma-contiguous.h
@@ -1,5 +1,5 @@
-#ifndef ASM_DMA_CONTIGUOUS_H
-#define ASM_DMA_CONTIGUOUS_H
+#ifndef _ASM_GENERIC_DMA_CONTIGUOUS_H
+#define _ASM_GENERIC_DMA_CONTIGUOUS_H
 
 #ifdef __KERNEL__
 #ifdef CONFIG_CMA
diff --git a/include/asm-generic/io-64-nonatomic-hi-lo.h b/include/asm-generic/io-64-nonatomic-hi-lo.h
index a6806a9..982cc29 100644
--- a/include/asm-generic/io-64-nonatomic-hi-lo.h
+++ b/include/asm-generic/io-64-nonatomic-hi-lo.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_IO_64_NONATOMIC_HI_LO_H_
-#define _ASM_IO_64_NONATOMIC_HI_LO_H_
+#ifndef _ASM_GENERIC_IO_64_NONATOMIC_HI_LO_H_
+#define _ASM_GENERIC_IO_64_NONATOMIC_HI_LO_H_
 
 #include <linux/io.h>
 #include <asm-generic/int-ll64.h>
@@ -25,4 +25,4 @@ static inline void writeq(__u64 val, volatile void __iomem *addr)
 }
 #endif
 
-#endif	/* _ASM_IO_64_NONATOMIC_HI_LO_H_ */
+#endif	/* _ASM_GENERIC_IO_64_NONATOMIC_HI_LO_H_ */
diff --git a/include/asm-generic/io-64-nonatomic-lo-hi.h b/include/asm-generic/io-64-nonatomic-lo-hi.h
index ca546b1..abb1549 100644
--- a/include/asm-generic/io-64-nonatomic-lo-hi.h
+++ b/include/asm-generic/io-64-nonatomic-lo-hi.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_IO_64_NONATOMIC_LO_HI_H_
-#define _ASM_IO_64_NONATOMIC_LO_HI_H_
+#ifndef _ASM_GENERIC_IO_64_NONATOMIC_LO_HI_H_
+#define _ASM_GENERIC_IO_64_NONATOMIC_LO_HI_H_
 
 #include <linux/io.h>
 #include <asm-generic/int-ll64.h>
@@ -25,4 +25,4 @@ static inline void writeq(__u64 val, volatile void __iomem *addr)
 }
 #endif
 
-#endif	/* _ASM_IO_64_NONATOMIC_LO_HI_H_ */
+#endif	/* _ASM_GENERIC_IO_64_NONATOMIC_LO_HI_H_ */
diff --git a/include/asm-generic/iomap.h b/include/asm-generic/iomap.h
index 6afd7d6..66b6798 100644
--- a/include/asm-generic/iomap.h
+++ b/include/asm-generic/iomap.h
@@ -1,5 +1,5 @@
-#ifndef __GENERIC_IO_H
-#define __GENERIC_IO_H
+#ifndef __ASM_GENERIC_IOMAP_H
+#define __ASM_GENERIC_IOMAP_H
 
 #include <linux/linkage.h>
 #include <asm/byteorder.h>
diff --git a/include/asm-generic/memory_model.h b/include/asm-generic/memory_model.h
index aea9e45..e40c952 100644
--- a/include/asm-generic/memory_model.h
+++ b/include/asm-generic/memory_model.h
@@ -1,5 +1,5 @@
-#ifndef __ASM_MEMORY_MODEL_H
-#define __ASM_MEMORY_MODEL_H
+#ifndef __ASM_GENERIC_MEMORY_MODEL_H
+#define __ASM_GENERIC_MEMORY_MODEL_H
 
 #ifndef __ASSEMBLY__
 
diff --git a/include/asm-generic/rtc.h b/include/asm-generic/rtc.h
index fa86f24..4b15696 100644
--- a/include/asm-generic/rtc.h
+++ b/include/asm-generic/rtc.h
@@ -9,8 +9,8 @@
  * Please read the COPYING file for all license details.
  */
 
-#ifndef __ASM_RTC_H__
-#define __ASM_RTC_H__
+#ifndef __ASM_GENERIC_RTC_H__
+#define __ASM_GENERIC_RTC_H__
 
 #include <linux/mc146818rtc.h>
 #include <linux/rtc.h>
@@ -215,4 +215,4 @@ static inline int set_rtc_pll(struct rtc_pll_info *pll)
 	return -EINVAL;
 }
 
-#endif /* __ASM_RTC_H__ */
+#endif /* __ASM_GENERIC_RTC_H__ */
diff --git a/include/asm-generic/statfs.h b/include/asm-generic/statfs.h
index 4b934e9..5493871 100644
--- a/include/asm-generic/statfs.h
+++ b/include/asm-generic/statfs.h
@@ -1,5 +1,5 @@
-#ifndef _GENERIC_STATFS_H
-#define _GENERIC_STATFS_H
+#ifndef _ASM_GENERIC_STATFS_H
+#define _ASM_GENERIC_STATFS_H
 
 #include <uapi/asm-generic/statfs.h>
 
diff --git a/include/asm-generic/syscall.h b/include/asm-generic/syscall.h
index 5b09392..1e1216b 100644
--- a/include/asm-generic/syscall.h
+++ b/include/asm-generic/syscall.h
@@ -16,8 +16,8 @@
  * cannot return to user mode while we are looking at it.
  */
 
-#ifndef _ASM_SYSCALL_H
-#define _ASM_SYSCALL_H	1
+#ifndef _ASM_GENERIC_SYSCALL_H
+#define _ASM_GENERIC_SYSCALL_H	1
 
 struct task_struct;
 struct pt_regs;
@@ -156,4 +156,4 @@ void syscall_set_arguments(struct task_struct *task, struct pt_regs *regs,
  * provide an implementation of this.
  */
 int syscall_get_arch(struct task_struct *task, struct pt_regs *regs);
-#endif	/* _ASM_SYSCALL_H */
+#endif	/* _ASM_GENERIC_SYSCALL_H */
diff --git a/include/asm-generic/word-at-a-time.h b/include/asm-generic/word-at-a-time.h
index 3f21f1b..541bd0c 100644
--- a/include/asm-generic/word-at-a-time.h
+++ b/include/asm-generic/word-at-a-time.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_WORD_AT_A_TIME_H
-#define _ASM_WORD_AT_A_TIME_H
+#ifndef _ASM_GENERIC_WORD_AT_A_TIME_H
+#define _ASM_GENERIC_WORD_AT_A_TIME_H
 
 /*
  * This says "generic", but it's actually big-endian only.
@@ -49,4 +49,4 @@ static inline bool has_zero(unsigned long val, unsigned long *data, const struct
 	return (val + c->high_bits) & ~rhs;
 }
 
-#endif /* _ASM_WORD_AT_A_TIME_H */
+#endif /* _ASM_GENERIC_WORD_AT_A_TIME_H */
-- 
1.7.9.5

