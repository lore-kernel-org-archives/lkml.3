Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab3IQMoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 08:44:05 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:35989 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab3IQMoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 08:44:01 -0400
From: Russ Dill <Russ.Dill@ti.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        mans@mansr.com, Shawn Guo <shawn.guo@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [RFC PATCH 04/11] asm-generic: fncpy: Add function copying macros
Date: Tue, 17 Sep 2013 05:43:30 -0700
Message-Id: <1379421817-15759-5-git-send-email-Russ.Dill@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1379421817-15759-1-git-send-email-Russ.Dill@ti.com>
References: <1379421817-15759-1-git-send-email-Russ.Dill@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under certain arches (ARM) function pointers cannot be
used naively. Specifically, for thumb functions, their 0 bit
is set, but they are contained on a word aligned address.

Add a fncpy macro to perform function copies correctly
along with two helpers, fnptr_to_address, and fnptr_translate.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
---
 arch/alpha/include/asm/fncpy.h      |   1 +
 arch/arc/include/asm/fncpy.h        |   1 +
 arch/arm/include/asm/fncpy.h        |  76 +++++++-------------------
 arch/arm/plat-omap/sram.c           |   2 +-
 arch/arm64/include/asm/fncpy.h      |   1 +
 arch/avr32/include/asm/fncpy.h      |   1 +
 arch/blackfin/include/asm/fncpy.h   |   1 +
 arch/c6x/include/asm/fncpy.h        |   1 +
 arch/cris/include/asm/fncpy.h       |   1 +
 arch/frv/include/asm/fncpy.h        |   1 +
 arch/h8300/include/asm/fncpy.h      |   1 +
 arch/hexagon/include/asm/fncpy.h    |   1 +
 arch/ia64/include/asm/fncpy.h       |   1 +
 arch/m32r/include/asm/fncpy.h       |   1 +
 arch/m68k/include/asm/fncpy.h       |   1 +
 arch/metag/include/asm/fncpy.h      |   1 +
 arch/microblaze/include/asm/fncpy.h |   1 +
 arch/mips/include/asm/fncpy.h       |   1 +
 arch/mn10300/include/asm/fncpy.h    |   1 +
 arch/openrisc/include/asm/fncpy.h   |   1 +
 arch/parisc/include/asm/fncpy.h     |   1 +
 arch/powerpc/include/asm/fncpy.h    |   1 +
 arch/s390/include/asm/fncpy.h       |   1 +
 arch/score/include/asm/fncpy.h      |   1 +
 arch/sh/include/asm/fncpy.h         |   1 +
 arch/sparc/include/asm/fncpy.h      |   1 +
 arch/tile/include/asm/fncpy.h       |   1 +
 arch/um/include/asm/fncpy.h         |   1 +
 arch/unicore32/include/asm/fncpy.h  |   1 +
 arch/x86/include/asm/fncpy.h        |   1 +
 arch/xtensa/include/asm/fncpy.h     |   1 +
 include/asm-generic/fncpy.h         | 104 ++++++++++++++++++++++++++++++++++++
 32 files changed, 154 insertions(+), 57 deletions(-)
 create mode 100644 arch/alpha/include/asm/fncpy.h
 create mode 100644 arch/arc/include/asm/fncpy.h
 create mode 100644 arch/arm64/include/asm/fncpy.h
 create mode 100644 arch/avr32/include/asm/fncpy.h
 create mode 100644 arch/blackfin/include/asm/fncpy.h
 create mode 100644 arch/c6x/include/asm/fncpy.h
 create mode 100644 arch/cris/include/asm/fncpy.h
 create mode 100644 arch/frv/include/asm/fncpy.h
 create mode 100644 arch/h8300/include/asm/fncpy.h
 create mode 100644 arch/hexagon/include/asm/fncpy.h
 create mode 100644 arch/ia64/include/asm/fncpy.h
 create mode 100644 arch/m32r/include/asm/fncpy.h
 create mode 100644 arch/m68k/include/asm/fncpy.h
 create mode 100644 arch/metag/include/asm/fncpy.h
 create mode 100644 arch/microblaze/include/asm/fncpy.h
 create mode 100644 arch/mips/include/asm/fncpy.h
 create mode 100644 arch/mn10300/include/asm/fncpy.h
 create mode 100644 arch/openrisc/include/asm/fncpy.h
 create mode 100644 arch/parisc/include/asm/fncpy.h
 create mode 100644 arch/powerpc/include/asm/fncpy.h
 create mode 100644 arch/s390/include/asm/fncpy.h
 create mode 100644 arch/score/include/asm/fncpy.h
 create mode 100644 arch/sh/include/asm/fncpy.h
 create mode 100644 arch/sparc/include/asm/fncpy.h
 create mode 100644 arch/tile/include/asm/fncpy.h
 create mode 100644 arch/um/include/asm/fncpy.h
 create mode 100644 arch/unicore32/include/asm/fncpy.h
 create mode 100644 arch/x86/include/asm/fncpy.h
 create mode 100644 arch/xtensa/include/asm/fncpy.h
 create mode 100644 include/asm-generic/fncpy.h

diff --git a/arch/alpha/include/asm/fncpy.h b/arch/alpha/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/alpha/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/arc/include/asm/fncpy.h b/arch/arc/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/arc/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/arm/include/asm/fncpy.h b/arch/arm/include/asm/fncpy.h
index de53547..f165f20 100644
--- a/arch/arm/include/asm/fncpy.h
+++ b/arch/arm/include/asm/fncpy.h
@@ -17,16 +17,12 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#ifndef __ASM_FNCPY_H
+#define __ASM_FNCPY_H
+
+#include <linux/types.h>
+
 /*
- * These macros are intended for use when there is a need to copy a low-level
- * function body into special memory.
- *
- * For example, when reconfiguring the SDRAM controller, the code doing the
- * reconfiguration may need to run from SRAM.
- *
- * NOTE: that the copied function body must be entirely self-contained and
- * position-independent in order for this to work properly.
- *
  * NOTE: in order for embedded literals and data to get referenced correctly,
  * the alignment of functions must be preserved when copying.  To ensure this,
  * the source and destination addresses for fncpy() must be aligned to a
@@ -34,61 +30,29 @@
  * You will typically need a ".align 3" directive in the assembler where the
  * function to be copied is defined, and ensure that your allocator for the
  * destination buffer returns 8-byte-aligned pointers.
- *
- * Typical usage example:
- *
- * extern int f(args);
- * extern uint32_t size_of_f;
- * int (*copied_f)(args);
- * void *sram_buffer;
- *
- * copied_f = fncpy(sram_buffer, &f, size_of_f);
- *
- * ... later, call the function: ...
- *
- * copied_f(args);
- *
- * The size of the function to be copied can't be determined from C:
- * this must be determined by other means, such as adding assmbler directives
- * in the file where f is defined.
- */
+*/
+#define ARCH_FNCPY_ALIGN	3
 
-#ifndef __ASM_FNCPY_H
-#define __ASM_FNCPY_H
-
-#include <linux/types.h>
-#include <linux/string.h>
-
-#include <asm/bug.h>
-#include <asm/cacheflush.h>
-
-/*
- * Minimum alignment requirement for the source and destination addresses
- * for function copying.
- */
-#define FNCPY_ALIGN 8
-
-#define fncpy(dest_buf, funcp, size) ({					\
+/* Clear the Thumb bit */
+#define fnptr_to_addr(funcp) ({						\
 	uintptr_t __funcp_address;					\
-	typeof(funcp) __result;						\
 									\
 	asm("" : "=r" (__funcp_address) : "0" (funcp));			\
+	__funcp_address & ~1;						\
+})
+
+/* Put the Thumb bit back */
+#define fnptr_translate(orig_funcp, new_addr) ({			\
+	uintptr_t __funcp_address;					\
+	typeof(orig_funcp) __result;					\
 									\
-	/*								\
-	 * Ensure alignment of source and destination addresses,	\
-	 * disregarding the function's Thumb bit:			\
-	 */								\
-	BUG_ON((uintptr_t)(dest_buf) & (FNCPY_ALIGN - 1) ||		\
-		(__funcp_address & ~(uintptr_t)1 & (FNCPY_ALIGN - 1)));	\
-									\
-	memcpy(dest_buf, (void const *)(__funcp_address & ~1), size);	\
-	flush_icache_range((unsigned long)(dest_buf),			\
-		(unsigned long)(dest_buf) + (size));			\
-									\
+	asm("" : "=r" (__funcp_address) : "0" (orig_funcp));		\
 	asm("" : "=r" (__result)					\
-		: "0" ((uintptr_t)(dest_buf) | (__funcp_address & 1)));	\
+		: "0" ((uintptr_t)(new_addr) | (__funcp_address & 1)));	\
 									\
 	__result;							\
 })
 
+#include <asm-generic/fncpy.h>
+
 #endif /* !__ASM_FNCPY_H */
diff --git a/arch/arm/plat-omap/sram.c b/arch/arm/plat-omap/sram.c
index a5bc92d..90ccd74 100644
--- a/arch/arm/plat-omap/sram.c
+++ b/arch/arm/plat-omap/sram.c
@@ -54,7 +54,7 @@ void *omap_sram_push_address(unsigned long size)
 	}
 
 	new_ceil -= size;
-	new_ceil = ROUND_DOWN(new_ceil, FNCPY_ALIGN);
+	new_ceil = ROUND_DOWN(new_ceil, 1 << ARCH_FNCPY_ALIGN);
 	omap_sram_ceil = IOMEM(new_ceil);
 
 	return (void *)omap_sram_ceil;
diff --git a/arch/arm64/include/asm/fncpy.h b/arch/arm64/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/arm64/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/avr32/include/asm/fncpy.h b/arch/avr32/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/avr32/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/blackfin/include/asm/fncpy.h b/arch/blackfin/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/blackfin/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/c6x/include/asm/fncpy.h b/arch/c6x/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/c6x/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/cris/include/asm/fncpy.h b/arch/cris/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/cris/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/frv/include/asm/fncpy.h b/arch/frv/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/frv/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/h8300/include/asm/fncpy.h b/arch/h8300/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/h8300/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/hexagon/include/asm/fncpy.h b/arch/hexagon/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/hexagon/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/ia64/include/asm/fncpy.h b/arch/ia64/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/ia64/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/m32r/include/asm/fncpy.h b/arch/m32r/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/m32r/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/m68k/include/asm/fncpy.h b/arch/m68k/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/m68k/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/metag/include/asm/fncpy.h b/arch/metag/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/metag/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/microblaze/include/asm/fncpy.h b/arch/microblaze/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/microblaze/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/mips/include/asm/fncpy.h b/arch/mips/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/mips/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/mn10300/include/asm/fncpy.h b/arch/mn10300/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/mn10300/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/openrisc/include/asm/fncpy.h b/arch/openrisc/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/openrisc/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/parisc/include/asm/fncpy.h b/arch/parisc/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/parisc/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/powerpc/include/asm/fncpy.h b/arch/powerpc/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/powerpc/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/s390/include/asm/fncpy.h b/arch/s390/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/s390/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/score/include/asm/fncpy.h b/arch/score/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/score/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/sh/include/asm/fncpy.h b/arch/sh/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/sh/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/sparc/include/asm/fncpy.h b/arch/sparc/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/sparc/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/tile/include/asm/fncpy.h b/arch/tile/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/tile/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/um/include/asm/fncpy.h b/arch/um/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/um/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/unicore32/include/asm/fncpy.h b/arch/unicore32/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/unicore32/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/x86/include/asm/fncpy.h b/arch/x86/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/x86/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/arch/xtensa/include/asm/fncpy.h b/arch/xtensa/include/asm/fncpy.h
new file mode 100644
index 0000000..ee4741c
--- /dev/null
+++ b/arch/xtensa/include/asm/fncpy.h
@@ -0,0 +1 @@
+#include <asm-generic/fncpy.h>
diff --git a/include/asm-generic/fncpy.h b/include/asm-generic/fncpy.h
new file mode 100644
index 0000000..1a25282
--- /dev/null
+++ b/include/asm-generic/fncpy.h
@@ -0,0 +1,104 @@
+/*
+ * include/asm-generic/fncpy.h - helper macros for function body copying
+ *
+ * Copyright (C) 2011 Linaro Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+/*
+ * These macros are intended for use when there is a need to copy a low-level
+ * function body into special memory.
+ *
+ * For example, when reconfiguring the SDRAM controller, the code doing the
+ * reconfiguration may need to run from SRAM.
+ *
+ * NOTE: that the copied function body must be entirely self-contained and
+ * position-independent in order for this to work properly.
+ *
+ * Typical usage example:
+ *
+ * extern int f(args);
+ * extern uint32_t size_of_f;
+ * int (*copied_f)(args);
+ * void *sram_buffer;
+ *
+ * copied_f = fncpy(sram_buffer, &f, size_of_f);
+ *
+ * ... later, call the function: ...
+ *
+ * copied_f(args);
+ *
+ * The size of the function to be copied can't be determined from C:
+ * this must be determined by other means, such as adding assmbler directives
+ * in the file where f is defined.
+ */
+
+#ifndef __ASM_GENERIC_FNCPY_H
+#define __ASM_GENERIC_FNCPY_H
+
+#include <linux/types.h>
+#include <linux/string.h>
+
+#include <asm/bug.h>
+#include <asm/cacheflush.h>
+
+/*
+ * Minimum alignment requirement for the source and destination addresses
+ * for function copying.
+ */
+#ifndef ARCH_FNCPY_ALIGN
+#define ARCH_FNCPY_ALIGN	0
+#endif
+
+#define ARCH_FNCPY_MASK		((1 << (ARCH_FNCPY_ALIGN)) - 1)
+
+#ifndef fnptr_to_addr
+#define fnptr_to_addr(funcp) ({						\
+	(uintptr_t) (funcp);						\
+})
+#endif
+
+#ifndef fnptr_translate
+#define fnptr_translate(orig_funcp, new_addr) ({			\
+	(typeof(orig_funcp)) (new_addr);				\
+})
+#endif
+
+/* Ensure alignment of source and destination addresses */
+#ifndef fn_dest_invalid
+#define fn_dest_invalid(funcp, dest_buf) ({				\
+	uintptr_t __funcp_address;					\
+									\
+	__funcp_address = fnptr_to_addr(funcp);				\
+									\
+	((uintptr_t)(dest_buf) & ARCH_FNCPY_MASK) ||			\
+		(__funcp_address & ARCH_FNCPY_MASK);			\
+})
+#endif
+
+#ifndef fncpy
+#define fncpy(dest_buf, funcp, size) ({					\
+	BUG_ON(fn_dest_invalid(funcp, dest_buf));			\
+									\
+	memcpy(dest_buf, (void const *)(funcp), size);			\
+	flush_icache_range((unsigned long)(dest_buf),			\
+		(unsigned long)(dest_buf) + (size));			\
+									\
+	fnptr_translate(funcp, dest_buf);				\
+})
+#endif
+
+#endif /* !__ASM_GENERIC_FNCPY_H */
+
-- 
1.8.3.2

