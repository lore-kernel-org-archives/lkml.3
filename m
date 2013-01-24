Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab3AXKyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:54:35 -0500
Received: from vaxjo.synopsys.com ([198.182.60.75]:47256 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab3AXKyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:54:20 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH v3 58/71] ARC: UAPI Disintegrate arch/arc/include/asm
Date: Thu, 24 Jan 2013 16:20:35 +0530
Message-ID: <1359024639-21915-22-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. ./genfilelist.pl arch/arc/include/asm/

2. Create arch/arc/include/uapi/asm/Kbuild as follows

	+# UAPI Header export list
	+include include/uapi/asm-generic/Kbuild.asm

3. ./disintegrate-one.pl arch/arc/include/{,uapi/}asm/<above-list>

4. Edit arch/arc/include/asm/Kbuild to remove ref to
	asm-generic/Kbuild.asm

To work around empty uapi/asm/setup.h added a placholder comment.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: David Howells <dhowells@redhat.com>
---
 arch/arc/include/asm/Kbuild            |    8 ---
 arch/arc/include/asm/byteorder.h       |   18 ------
 arch/arc/include/asm/cachectl.h        |   28 ---------
 arch/arc/include/asm/page.h            |   30 +---------
 arch/arc/include/asm/ptrace.h          |   37 +-----------
 arch/arc/include/asm/setup.h           |    3 +-
 arch/arc/include/asm/sigcontext.h      |   23 --------
 arch/arc/include/asm/signal.h          |   27 ---------
 arch/arc/include/asm/swab.h            |   98 --------------------------------
 arch/arc/include/asm/unistd.h          |   34 -----------
 arch/arc/include/uapi/asm/Kbuild       |   11 ++++
 arch/arc/include/uapi/asm/byteorder.h  |   18 ++++++
 arch/arc/include/uapi/asm/cachectl.h   |   28 +++++++++
 arch/arc/include/uapi/asm/page.h       |   39 +++++++++++++
 arch/arc/include/uapi/asm/ptrace.h     |   46 +++++++++++++++
 arch/arc/include/uapi/asm/setup.h      |    6 ++
 arch/arc/include/uapi/asm/sigcontext.h |   23 ++++++++
 arch/arc/include/uapi/asm/signal.h     |   27 +++++++++
 arch/arc/include/uapi/asm/swab.h       |   98 ++++++++++++++++++++++++++++++++
 arch/arc/include/uapi/asm/unistd.h     |   34 +++++++++++
 20 files changed, 335 insertions(+), 301 deletions(-)
 delete mode 100644 arch/arc/include/asm/byteorder.h
 delete mode 100644 arch/arc/include/asm/cachectl.h
 delete mode 100644 arch/arc/include/asm/sigcontext.h
 delete mode 100644 arch/arc/include/asm/signal.h
 delete mode 100644 arch/arc/include/asm/swab.h
 delete mode 100644 arch/arc/include/asm/unistd.h
 create mode 100644 arch/arc/include/uapi/asm/Kbuild
 create mode 100644 arch/arc/include/uapi/asm/byteorder.h
 create mode 100644 arch/arc/include/uapi/asm/cachectl.h
 create mode 100644 arch/arc/include/uapi/asm/page.h
 create mode 100644 arch/arc/include/uapi/asm/ptrace.h
 create mode 100644 arch/arc/include/uapi/asm/setup.h
 create mode 100644 arch/arc/include/uapi/asm/sigcontext.h
 create mode 100644 arch/arc/include/uapi/asm/signal.h
 create mode 100644 arch/arc/include/uapi/asm/swab.h
 create mode 100644 arch/arc/include/uapi/asm/unistd.h

diff --git a/arch/arc/include/asm/Kbuild b/arch/arc/include/asm/Kbuild
index b24089c..48af742 100644
--- a/arch/arc/include/asm/Kbuild
+++ b/arch/arc/include/asm/Kbuild
@@ -1,11 +1,3 @@
-include include/asm-generic/Kbuild.asm
-
-# 7-Oct-12: Jeremy Bennett <jeremy.bennett@embecosm.com>. Some of these
-# headers, beyond those specified in the generic set are needed by user code.
-
-header-y += page.h
-header-y += cachectl.h
-
 generic-y += auxvec.h
 generic-y += bugs.h
 generic-y += bitsperlong.h
diff --git a/arch/arc/include/asm/byteorder.h b/arch/arc/include/asm/byteorder.h
deleted file mode 100644
index 9da71d4..0000000
--- a/arch/arc/include/asm/byteorder.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/*
- * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef __ASM_ARC_BYTEORDER_H
-#define __ASM_ARC_BYTEORDER_H
-
-#ifdef CONFIG_CPU_BIG_ENDIAN
-#include <linux/byteorder/big_endian.h>
-#else
-#include <linux/byteorder/little_endian.h>
-#endif
-
-#endif /* ASM_ARC_BYTEORDER_H */
diff --git a/arch/arc/include/asm/cachectl.h b/arch/arc/include/asm/cachectl.h
deleted file mode 100644
index 51c73f0..0000000
--- a/arch/arc/include/asm/cachectl.h
+++ /dev/null
@@ -1,28 +0,0 @@
-/*
- * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef __ARC_ASM_CACHECTL_H
-#define __ARC_ASM_CACHECTL_H
-
-/*
- * ARC ABI flags defined for Android's finegrained cacheflush requirements
- */
-#define CF_I_INV	0x0002
-#define CF_D_FLUSH	0x0010
-#define CF_D_FLUSH_INV	0x0020
-
-#define CF_DEFAULT	(CF_I_INV | CF_D_FLUSH)
-
-/*
- * Standard flags expected by cacheflush system call users
- */
-#define ICACHE	CF_I_INV
-#define DCACHE	CF_D_FLUSH
-#define BCACHE	(CF_I_INV | CF_D_FLUSH)
-
-#endif
diff --git a/arch/arc/include/asm/page.h b/arch/arc/include/asm/page.h
index d111d0c..dfe1f8a 100644
--- a/arch/arc/include/asm/page.h
+++ b/arch/arc/include/asm/page.h
@@ -5,37 +5,11 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-
 #ifndef __ASM_ARC_PAGE_H
 #define __ASM_ARC_PAGE_H
 
-/* PAGE_SHIFT determines the page size */
-#if defined(CONFIG_ARC_PAGE_SIZE_16K)
-#define PAGE_SHIFT 14
-#elif defined(CONFIG_ARC_PAGE_SIZE_4K)
-#define PAGE_SHIFT 12
-#else
-/*
- * Default 8k
- * done this way (instead of under CONFIG_ARC_PAGE_SIZE_8K) because adhoc
- * user code (busybox appletlib.h) expects PAGE_SHIFT to be defined w/o
- * using the correct uClibc header and in their build our autoconf.h is
- * not available
- */
-#define PAGE_SHIFT 13
-#endif
-
-#ifdef __ASSEMBLY__
-#define PAGE_SIZE	(1 << PAGE_SHIFT)
-#define PAGE_OFFSET	(0x80000000)
-#else
-#define PAGE_SIZE	(1UL << PAGE_SHIFT)	/* Default 8K */
-#define PAGE_OFFSET	(0x80000000UL)	/* Kernel starts at 2G onwards */
-#endif
+#include <uapi/asm/page.h>
 
-#define PAGE_MASK	(~(PAGE_SIZE-1))
-
-#ifdef __KERNEL__
 
 #ifndef __ASSEMBLY__
 
@@ -129,6 +103,4 @@ typedef unsigned long pgtable_t;
 
 #endif /* !__ASSEMBLY__ */
 
-#endif /* __KERNEL__ */
-
 #endif
diff --git a/arch/arc/include/asm/ptrace.h b/arch/arc/include/asm/ptrace.h
index 6ab65fa..95e633e 100644
--- a/arch/arc/include/asm/ptrace.h
+++ b/arch/arc/include/asm/ptrace.h
@@ -7,42 +7,11 @@
  *
  * Amit Bhor, Sameer Dhavale: Codito Technologies 2004
  */
-
 #ifndef __ASM_ARC_PTRACE_H
 #define __ASM_ARC_PTRACE_H
 
-/*
- * XXX: ABI hack.
- * The offset calc can be cleanly done in asm-offset.c, however gdb includes
- * this header directly.
- */
-#define PT_bta		4
-#define PT_lp_start	8
-#define PT_lp_end	12
-#define PT_lp_count	16
-#define PT_status32	20
-#define PT_ret		24
-#define PT_blink	28
-#define PT_fp		32
-#define PT_r26		36
-#define PT_r12		40
-#define PT_r11		44
-#define PT_r10		48
-#define PT_r9		52
-#define PT_r8		56
-#define PT_r7		60
-#define PT_r6		64
-#define PT_r5		68
-#define PT_r4		72
-#define PT_r3		76
-#define PT_r2		80
-#define PT_r1		84
-#define PT_r0		88
-#define PT_sp		92
-#define PT_orig_r0	96
-#define PT_orig_r8	100
-
-#ifdef __KERNEL__
+#include <uapi/asm/ptrace.h>
+
 
 #ifndef __ASSEMBLY__
 
@@ -163,6 +132,4 @@ static inline long regs_return_value(struct pt_regs *regs)
 #define orig_r8_IS_IRQ1			0x0010
 #define orig_r8_IS_IRQ2			0x0020
 
-#endif /* __KERNEL__ */
-
 #endif /* __ASM_PTRACE_H */
diff --git a/arch/arc/include/asm/setup.h b/arch/arc/include/asm/setup.h
index fc97411..229e506 100644
--- a/arch/arc/include/asm/setup.h
+++ b/arch/arc/include/asm/setup.h
@@ -5,11 +5,12 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-
 #ifndef __ASMARC_SETUP_H
 #define __ASMARC_SETUP_H
 
+
 #include <linux/types.h>
+#include <uapi/asm/setup.h>
 
 #define COMMAND_LINE_SIZE 256
 
diff --git a/arch/arc/include/asm/sigcontext.h b/arch/arc/include/asm/sigcontext.h
deleted file mode 100644
index f21b541..0000000
--- a/arch/arc/include/asm/sigcontext.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/*
- * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_ARC_SIGCONTEXT_H
-#define _ASM_ARC_SIGCONTEXT_H
-
-#include <asm/ptrace.h>
-
-/*
- * Signal context structure - contains all info to do with the state
- * before the signal handler was invoked.  Note: only add new entries
- * to the end of the structure.
- */
-struct sigcontext {
-	struct pt_regs regs;
-};
-
-#endif /* _ASM_ARC_SIGCONTEXT_H */
diff --git a/arch/arc/include/asm/signal.h b/arch/arc/include/asm/signal.h
deleted file mode 100644
index fad62f7..0000000
--- a/arch/arc/include/asm/signal.h
+++ /dev/null
@@ -1,27 +0,0 @@
-/*
- * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Amit Bhor, Sameer Dhavale: Codito Technologies 2004
- */
-
-#ifndef _ASM_ARC_SIGNAL_H
-#define _ASM_ARC_SIGNAL_H
-
-/*
- * This is much needed for ARC sigreturn optimization.
- * This allows uClibc to piggback the addr of a sigreturn stub in sigaction,
- * which allows sigreturn based re-entry into kernel after handling signal.
- * W/o this kernel needs to "synthesize" the sigreturn trampoline on user
- * mode stack which in turn forces the following:
- * -TLB Flush (after making the stack page executable)
- * -Cache line Flush (to make I/D Cache lines coherent)
- */
-#define SA_RESTORER	0x04000000
-
-#include <asm-generic/signal.h>
-
-#endif /* _ASM_ARC_SIGNAL_H */
diff --git a/arch/arc/include/asm/swab.h b/arch/arc/include/asm/swab.h
deleted file mode 100644
index 095599a..0000000
--- a/arch/arc/include/asm/swab.h
+++ /dev/null
@@ -1,98 +0,0 @@
-/*
- * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * vineetg: May 2011
- *  -Support single cycle endian-swap insn in ARC700 4.10
- *
- * vineetg: June 2009
- *  -Better htonl implementation (5 instead of 9 ALU instructions)
- *  -Hardware assisted single cycle bswap (Use Case of ARC custom instrn)
- */
-
-#ifndef __ASM_ARC_SWAB_H
-#define __ASM_ARC_SWAB_H
-
-#include <linux/types.h>
-
-/* Native single cycle endian swap insn */
-#ifdef CONFIG_ARC_HAS_SWAPE
-
-#define __arch_swab32(x)		\
-({					\
-	unsigned int tmp = x;		\
-	__asm__(			\
-	"	swape	%0, %1	\n"	\
-	: "=r" (tmp)			\
-	: "r" (tmp));			\
-	tmp;				\
-})
-
-#else
-
-/* Several ways of Endian-Swap Emulation for ARC
- * 0: kernel generic
- * 1: ARC optimised "C"
- * 2: ARC Custom instruction
- */
-#define ARC_BSWAP_TYPE	1
-
-#if (ARC_BSWAP_TYPE == 1)		/******* Software only ********/
-
-/* The kernel default implementation of htonl is
- *		return  x<<24 | x>>24 |
- *		 (x & (__u32)0x0000ff00UL)<<8 | (x & (__u32)0x00ff0000UL)>>8;
- *
- * This generates 9 instructions on ARC (excluding the ld/st)
- *
- * 8051fd8c:	ld     r3,[r7,20]	; Mem op : Get the value to be swapped
- * 8051fd98:	asl    r5,r3,24		; get  3rd Byte
- * 8051fd9c:	lsr    r2,r3,24		; get  0th Byte
- * 8051fda0:	and    r4,r3,0xff00
- * 8051fda8:	asl    r4,r4,8		; get 1st Byte
- * 8051fdac:	and    r3,r3,0x00ff0000
- * 8051fdb4:	or     r2,r2,r5		; combine 0th and 3rd Bytes
- * 8051fdb8:	lsr    r3,r3,8		; 2nd Byte at correct place in Dst Reg
- * 8051fdbc:	or     r2,r2,r4		; combine 0,3 Bytes with 1st Byte
- * 8051fdc0:	or     r2,r2,r3		; combine 0,3,1 Bytes with 2nd Byte
- * 8051fdc4:	st     r2,[r1,20]	; Mem op : save result back to mem
- *
- * Joern suggested a better "C" algorithm which is great since
- * (1) It is portable to any architecure
- * (2) At the same time it takes advantage of ARC ISA (rotate intrns)
- */
-
-#define __arch_swab32(x)					\
-({	unsigned long __in = (x), __tmp;			\
-	__tmp = __in << 8 | __in >> 24; /* ror tmp,in,24 */	\
-	__in = __in << 24 | __in >> 8; /* ror in,in,8 */	\
-	__tmp ^= __in;						\
-	__tmp &= 0xff00ff;					\
-	__tmp ^ __in;						\
-})
-
-#elif (ARC_BSWAP_TYPE == 2)	/* Custom single cycle bwap instruction */
-
-#define __arch_swab32(x)						\
-({									\
-	unsigned int tmp = x;						\
-	__asm__(							\
-	"	.extInstruction	bswap, 7, 0x00, SUFFIX_NONE, SYNTAX_2OP	\n"\
-	"	bswap  %0, %1						\n"\
-	: "=r" (tmp)							\
-	: "r" (tmp));							\
-	tmp;								\
-})
-
-#endif /* ARC_BSWAP_TYPE=zzz */
-
-#endif /* CONFIG_ARC_HAS_SWAPE */
-
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#define __SWAB_64_THRU_32__
-#endif
-
-#endif
diff --git a/arch/arc/include/asm/unistd.h b/arch/arc/include/asm/unistd.h
deleted file mode 100644
index 6f30484..0000000
--- a/arch/arc/include/asm/unistd.h
+++ /dev/null
@@ -1,34 +0,0 @@
-/*
- * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-/******** no-legacy-syscalls-ABI *******/
-
-#define __ARCH_WANT_SYS_EXECVE
-#define __ARCH_WANT_SYS_CLONE
-#define __ARCH_WANT_SYS_VFORK
-#define __ARCH_WANT_SYS_FORK
-
-#define sys_mmap2 sys_mmap_pgoff
-
-#include <asm-generic/unistd.h>
-
-#define NR_syscalls	__NR_syscalls
-
-/* ARC specific syscall */
-#define __NR_cacheflush		(__NR_arch_specific_syscall + 0)
-#define __NR_arc_settls		(__NR_arch_specific_syscall + 1)
-#define __NR_arc_gettls		(__NR_arch_specific_syscall + 2)
-
-__SYSCALL(__NR_cacheflush, sys_cacheflush)
-__SYSCALL(__NR_arc_settls, sys_arc_settls)
-__SYSCALL(__NR_arc_gettls, sys_arc_gettls)
-
-
-/* Generic syscall (fs/filesystems.c - lost in asm-generic/unistd.h */
-#define __NR_sysfs		(__NR_arch_specific_syscall + 3)
-__SYSCALL(__NR_sysfs, sys_sysfs)
diff --git a/arch/arc/include/uapi/asm/Kbuild b/arch/arc/include/uapi/asm/Kbuild
new file mode 100644
index 0000000..2736244
--- /dev/null
+++ b/arch/arc/include/uapi/asm/Kbuild
@@ -0,0 +1,11 @@
+# UAPI Header export list
+include include/uapi/asm-generic/Kbuild.asm
+header-y += page.h
+header-y += setup.h
+header-y += byteorder.h
+header-y += cachectl.h
+header-y += ptrace.h
+header-y += sigcontext.h
+header-y += signal.h
+header-y += swab.h
+header-y += unistd.h
diff --git a/arch/arc/include/uapi/asm/byteorder.h b/arch/arc/include/uapi/asm/byteorder.h
new file mode 100644
index 0000000..9da71d4
--- /dev/null
+++ b/arch/arc/include/uapi/asm/byteorder.h
@@ -0,0 +1,18 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_ARC_BYTEORDER_H
+#define __ASM_ARC_BYTEORDER_H
+
+#ifdef CONFIG_CPU_BIG_ENDIAN
+#include <linux/byteorder/big_endian.h>
+#else
+#include <linux/byteorder/little_endian.h>
+#endif
+
+#endif /* ASM_ARC_BYTEORDER_H */
diff --git a/arch/arc/include/uapi/asm/cachectl.h b/arch/arc/include/uapi/asm/cachectl.h
new file mode 100644
index 0000000..51c73f0
--- /dev/null
+++ b/arch/arc/include/uapi/asm/cachectl.h
@@ -0,0 +1,28 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ARC_ASM_CACHECTL_H
+#define __ARC_ASM_CACHECTL_H
+
+/*
+ * ARC ABI flags defined for Android's finegrained cacheflush requirements
+ */
+#define CF_I_INV	0x0002
+#define CF_D_FLUSH	0x0010
+#define CF_D_FLUSH_INV	0x0020
+
+#define CF_DEFAULT	(CF_I_INV | CF_D_FLUSH)
+
+/*
+ * Standard flags expected by cacheflush system call users
+ */
+#define ICACHE	CF_I_INV
+#define DCACHE	CF_D_FLUSH
+#define BCACHE	(CF_I_INV | CF_D_FLUSH)
+
+#endif
diff --git a/arch/arc/include/uapi/asm/page.h b/arch/arc/include/uapi/asm/page.h
new file mode 100644
index 0000000..e5d41e0
--- /dev/null
+++ b/arch/arc/include/uapi/asm/page.h
@@ -0,0 +1,39 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _UAPI__ASM_ARC_PAGE_H
+#define _UAPI__ASM_ARC_PAGE_H
+
+/* PAGE_SHIFT determines the page size */
+#if defined(CONFIG_ARC_PAGE_SIZE_16K)
+#define PAGE_SHIFT 14
+#elif defined(CONFIG_ARC_PAGE_SIZE_4K)
+#define PAGE_SHIFT 12
+#else
+/*
+ * Default 8k
+ * done this way (instead of under CONFIG_ARC_PAGE_SIZE_8K) because adhoc
+ * user code (busybox appletlib.h) expects PAGE_SHIFT to be defined w/o
+ * using the correct uClibc header and in their build our autoconf.h is
+ * not available
+ */
+#define PAGE_SHIFT 13
+#endif
+
+#ifdef __ASSEMBLY__
+#define PAGE_SIZE	(1 << PAGE_SHIFT)
+#define PAGE_OFFSET	(0x80000000)
+#else
+#define PAGE_SIZE	(1UL << PAGE_SHIFT)	/* Default 8K */
+#define PAGE_OFFSET	(0x80000000UL)	/* Kernel starts at 2G onwards */
+#endif
+
+#define PAGE_MASK	(~(PAGE_SIZE-1))
+
+
+#endif /* _UAPI__ASM_ARC_PAGE_H */
diff --git a/arch/arc/include/uapi/asm/ptrace.h b/arch/arc/include/uapi/asm/ptrace.h
new file mode 100644
index 0000000..bccf4ab
--- /dev/null
+++ b/arch/arc/include/uapi/asm/ptrace.h
@@ -0,0 +1,46 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Amit Bhor, Sameer Dhavale: Codito Technologies 2004
+ */
+
+#ifndef _UAPI__ASM_ARC_PTRACE_H
+#define _UAPI__ASM_ARC_PTRACE_H
+
+/*
+ * XXX: ABI hack.
+ * The offset calc can be cleanly done in asm-offset.c, however gdb includes
+ * this header directly.
+ */
+#define PT_bta		4
+#define PT_lp_start	8
+#define PT_lp_end	12
+#define PT_lp_count	16
+#define PT_status32	20
+#define PT_ret		24
+#define PT_blink	28
+#define PT_fp		32
+#define PT_r26		36
+#define PT_r12		40
+#define PT_r11		44
+#define PT_r10		48
+#define PT_r9		52
+#define PT_r8		56
+#define PT_r7		60
+#define PT_r6		64
+#define PT_r5		68
+#define PT_r4		72
+#define PT_r3		76
+#define PT_r2		80
+#define PT_r1		84
+#define PT_r0		88
+#define PT_sp		92
+#define PT_orig_r0	96
+#define PT_orig_r8	100
+
+
+#endif /* _UAPI__ASM_ARC_PTRACE_H */
diff --git a/arch/arc/include/uapi/asm/setup.h b/arch/arc/include/uapi/asm/setup.h
new file mode 100644
index 0000000..a6d4e44
--- /dev/null
+++ b/arch/arc/include/uapi/asm/setup.h
@@ -0,0 +1,6 @@
+/*
+ * setup.h is part of userspace header ABI so UAPI scripts have to generate it
+ * even if there's nothing to export - causing empty <uapi/asm/setup.h>
+ * However to prevent "patch" from discarding it we add this placeholder
+ * comment
+ */
diff --git a/arch/arc/include/uapi/asm/sigcontext.h b/arch/arc/include/uapi/asm/sigcontext.h
new file mode 100644
index 0000000..f21b541
--- /dev/null
+++ b/arch/arc/include/uapi/asm/sigcontext.h
@@ -0,0 +1,23 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ARC_SIGCONTEXT_H
+#define _ASM_ARC_SIGCONTEXT_H
+
+#include <asm/ptrace.h>
+
+/*
+ * Signal context structure - contains all info to do with the state
+ * before the signal handler was invoked.  Note: only add new entries
+ * to the end of the structure.
+ */
+struct sigcontext {
+	struct pt_regs regs;
+};
+
+#endif /* _ASM_ARC_SIGCONTEXT_H */
diff --git a/arch/arc/include/uapi/asm/signal.h b/arch/arc/include/uapi/asm/signal.h
new file mode 100644
index 0000000..fad62f7
--- /dev/null
+++ b/arch/arc/include/uapi/asm/signal.h
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Amit Bhor, Sameer Dhavale: Codito Technologies 2004
+ */
+
+#ifndef _ASM_ARC_SIGNAL_H
+#define _ASM_ARC_SIGNAL_H
+
+/*
+ * This is much needed for ARC sigreturn optimization.
+ * This allows uClibc to piggback the addr of a sigreturn stub in sigaction,
+ * which allows sigreturn based re-entry into kernel after handling signal.
+ * W/o this kernel needs to "synthesize" the sigreturn trampoline on user
+ * mode stack which in turn forces the following:
+ * -TLB Flush (after making the stack page executable)
+ * -Cache line Flush (to make I/D Cache lines coherent)
+ */
+#define SA_RESTORER	0x04000000
+
+#include <asm-generic/signal.h>
+
+#endif /* _ASM_ARC_SIGNAL_H */
diff --git a/arch/arc/include/uapi/asm/swab.h b/arch/arc/include/uapi/asm/swab.h
new file mode 100644
index 0000000..095599a
--- /dev/null
+++ b/arch/arc/include/uapi/asm/swab.h
@@ -0,0 +1,98 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * vineetg: May 2011
+ *  -Support single cycle endian-swap insn in ARC700 4.10
+ *
+ * vineetg: June 2009
+ *  -Better htonl implementation (5 instead of 9 ALU instructions)
+ *  -Hardware assisted single cycle bswap (Use Case of ARC custom instrn)
+ */
+
+#ifndef __ASM_ARC_SWAB_H
+#define __ASM_ARC_SWAB_H
+
+#include <linux/types.h>
+
+/* Native single cycle endian swap insn */
+#ifdef CONFIG_ARC_HAS_SWAPE
+
+#define __arch_swab32(x)		\
+({					\
+	unsigned int tmp = x;		\
+	__asm__(			\
+	"	swape	%0, %1	\n"	\
+	: "=r" (tmp)			\
+	: "r" (tmp));			\
+	tmp;				\
+})
+
+#else
+
+/* Several ways of Endian-Swap Emulation for ARC
+ * 0: kernel generic
+ * 1: ARC optimised "C"
+ * 2: ARC Custom instruction
+ */
+#define ARC_BSWAP_TYPE	1
+
+#if (ARC_BSWAP_TYPE == 1)		/******* Software only ********/
+
+/* The kernel default implementation of htonl is
+ *		return  x<<24 | x>>24 |
+ *		 (x & (__u32)0x0000ff00UL)<<8 | (x & (__u32)0x00ff0000UL)>>8;
+ *
+ * This generates 9 instructions on ARC (excluding the ld/st)
+ *
+ * 8051fd8c:	ld     r3,[r7,20]	; Mem op : Get the value to be swapped
+ * 8051fd98:	asl    r5,r3,24		; get  3rd Byte
+ * 8051fd9c:	lsr    r2,r3,24		; get  0th Byte
+ * 8051fda0:	and    r4,r3,0xff00
+ * 8051fda8:	asl    r4,r4,8		; get 1st Byte
+ * 8051fdac:	and    r3,r3,0x00ff0000
+ * 8051fdb4:	or     r2,r2,r5		; combine 0th and 3rd Bytes
+ * 8051fdb8:	lsr    r3,r3,8		; 2nd Byte at correct place in Dst Reg
+ * 8051fdbc:	or     r2,r2,r4		; combine 0,3 Bytes with 1st Byte
+ * 8051fdc0:	or     r2,r2,r3		; combine 0,3,1 Bytes with 2nd Byte
+ * 8051fdc4:	st     r2,[r1,20]	; Mem op : save result back to mem
+ *
+ * Joern suggested a better "C" algorithm which is great since
+ * (1) It is portable to any architecure
+ * (2) At the same time it takes advantage of ARC ISA (rotate intrns)
+ */
+
+#define __arch_swab32(x)					\
+({	unsigned long __in = (x), __tmp;			\
+	__tmp = __in << 8 | __in >> 24; /* ror tmp,in,24 */	\
+	__in = __in << 24 | __in >> 8; /* ror in,in,8 */	\
+	__tmp ^= __in;						\
+	__tmp &= 0xff00ff;					\
+	__tmp ^ __in;						\
+})
+
+#elif (ARC_BSWAP_TYPE == 2)	/* Custom single cycle bwap instruction */
+
+#define __arch_swab32(x)						\
+({									\
+	unsigned int tmp = x;						\
+	__asm__(							\
+	"	.extInstruction	bswap, 7, 0x00, SUFFIX_NONE, SYNTAX_2OP	\n"\
+	"	bswap  %0, %1						\n"\
+	: "=r" (tmp)							\
+	: "r" (tmp));							\
+	tmp;								\
+})
+
+#endif /* ARC_BSWAP_TYPE=zzz */
+
+#endif /* CONFIG_ARC_HAS_SWAPE */
+
+#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
+#define __SWAB_64_THRU_32__
+#endif
+
+#endif
diff --git a/arch/arc/include/uapi/asm/unistd.h b/arch/arc/include/uapi/asm/unistd.h
new file mode 100644
index 0000000..6f30484
--- /dev/null
+++ b/arch/arc/include/uapi/asm/unistd.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/******** no-legacy-syscalls-ABI *******/
+
+#define __ARCH_WANT_SYS_EXECVE
+#define __ARCH_WANT_SYS_CLONE
+#define __ARCH_WANT_SYS_VFORK
+#define __ARCH_WANT_SYS_FORK
+
+#define sys_mmap2 sys_mmap_pgoff
+
+#include <asm-generic/unistd.h>
+
+#define NR_syscalls	__NR_syscalls
+
+/* ARC specific syscall */
+#define __NR_cacheflush		(__NR_arch_specific_syscall + 0)
+#define __NR_arc_settls		(__NR_arch_specific_syscall + 1)
+#define __NR_arc_gettls		(__NR_arch_specific_syscall + 2)
+
+__SYSCALL(__NR_cacheflush, sys_cacheflush)
+__SYSCALL(__NR_arc_settls, sys_arc_settls)
+__SYSCALL(__NR_arc_gettls, sys_arc_gettls)
+
+
+/* Generic syscall (fs/filesystems.c - lost in asm-generic/unistd.h */
+#define __NR_sysfs		(__NR_arch_specific_syscall + 3)
+__SYSCALL(__NR_sysfs, sys_sysfs)
-- 
1.7.4.1

