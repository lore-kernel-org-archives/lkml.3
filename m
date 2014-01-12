Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbaALSo7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:44:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46360 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbaALSor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:44:47 -0500
Date: Sun, 12 Jan 2014 10:43:40 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-93ea02bb84354370e51de803a9405f171f3edf88@git.kernel.org>
Cc: mathieu.desnoyers@polymtl.ca, mingo@kernel.org,
        torvalds@linux-foundation.org, schwidefsky@de.ibm.com,
        peterz@infradead.org, tony.luck@intel.com, fweisbec@gmail.com,
        linux@arm.linux.org.uk, heiko.carstens@de.ibm.com, oleg@redhat.com,
        VICTORK@il.ibm.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        hpa@zytor.com, michael@ellerman.id.au, paulmck@linux.vnet.ibm.com,
        benh@kernel.crashing.org, geert@linux-m68k.org, mikey@neuling.org
Reply-To: mingo@kernel.org, mathieu.desnoyers@polymtl.ca,
        torvalds@linux-foundation.org, peterz@infradead.org,
        schwidefsky@de.ibm.com, tony.luck@intel.com, fweisbec@gmail.com,
        linux@arm.linux.org.uk, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        VICTORK@il.ibm.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, michael@ellerman.id.au, paulmck@linux.vnet.ibm.com,
        geert@linux-m68k.org, benh@kernel.crashing.org, mikey@neuling.org
In-Reply-To: <20131213150640.846368594@infradead.org>
References: <20131213150640.846368594@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] arch: Clean up asm/
 barrier.h implementations using asm-generic/barrier.h
Git-Commit-ID: 93ea02bb84354370e51de803a9405f171f3edf88
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:43:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  93ea02bb84354370e51de803a9405f171f3edf88
Gitweb:     http://git.kernel.org/tip/93ea02bb84354370e51de803a9405f171f3edf88
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 6 Nov 2013 14:57:36 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 12 Jan 2014 10:37:15 +0100

arch: Clean up asm/barrier.h implementations using asm-generic/barrier.h

We're going to be adding a few new barrier primitives, and in order to
avoid endless duplication make more agressive use of
asm-generic/barrier.h.

Change the asm-generic/barrier.h such that it allows partial barrier
definitions and fills out the rest with defaults.

There are a few architectures (m32r, m68k) that could probably
do away with their barrier.h file entirely but are kept for now due to
their unconventional nop() implementation.

Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Victor Kaplansky <VICTORK@il.ibm.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/20131213150640.846368594@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/alpha/include/asm/barrier.h      | 25 +++--------
 arch/arc/include/asm/Kbuild           |  1 +
 arch/avr32/include/asm/barrier.h      | 17 +++-----
 arch/blackfin/include/asm/barrier.h   | 18 +-------
 arch/cris/include/asm/Kbuild          |  1 +
 arch/cris/include/asm/barrier.h       | 25 -----------
 arch/frv/include/asm/barrier.h        |  8 +---
 arch/hexagon/include/asm/Kbuild       |  1 +
 arch/m32r/include/asm/barrier.h       | 80 +----------------------------------
 arch/m68k/include/asm/barrier.h       | 14 +-----
 arch/microblaze/include/asm/Kbuild    |  1 +
 arch/microblaze/include/asm/barrier.h | 27 ------------
 arch/mn10300/include/asm/Kbuild       |  1 +
 arch/mn10300/include/asm/barrier.h    | 37 ----------------
 arch/parisc/include/asm/Kbuild        |  1 +
 arch/parisc/include/asm/barrier.h     | 35 ---------------
 arch/score/include/asm/Kbuild         |  1 +
 arch/score/include/asm/barrier.h      | 16 -------
 arch/sh/include/asm/barrier.h         | 21 ++-------
 arch/sparc/include/asm/barrier_32.h   | 12 +-----
 arch/tile/include/asm/barrier.h       | 68 +----------------------------
 arch/unicore32/include/asm/barrier.h  | 11 +----
 arch/xtensa/include/asm/barrier.h     |  9 +---
 include/asm-generic/barrier.h         | 42 ++++++++++++------
 24 files changed, 58 insertions(+), 414 deletions(-)

diff --git a/arch/alpha/include/asm/barrier.h b/arch/alpha/include/asm/barrier.h
index ce8860a..3832bdb 100644
--- a/arch/alpha/include/asm/barrier.h
+++ b/arch/alpha/include/asm/barrier.h
@@ -3,33 +3,18 @@
 
 #include <asm/compiler.h>
 
-#define mb() \
-__asm__ __volatile__("mb": : :"memory")
+#define mb()	__asm__ __volatile__("mb": : :"memory")
+#define rmb()	__asm__ __volatile__("mb": : :"memory")
+#define wmb()	__asm__ __volatile__("wmb": : :"memory")
 
-#define rmb() \
-__asm__ __volatile__("mb": : :"memory")
-
-#define wmb() \
-__asm__ __volatile__("wmb": : :"memory")
-
-#define read_barrier_depends() \
-__asm__ __volatile__("mb": : :"memory")
+#define read_barrier_depends() __asm__ __volatile__("mb": : :"memory")
 
 #ifdef CONFIG_SMP
 #define __ASM_SMP_MB	"\tmb\n"
-#define smp_mb()	mb()
-#define smp_rmb()	rmb()
-#define smp_wmb()	wmb()
-#define smp_read_barrier_depends()	read_barrier_depends()
 #else
 #define __ASM_SMP_MB
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define smp_read_barrier_depends()	do { } while (0)
 #endif
 
-#define set_mb(var, value) \
-do { var = value; mb(); } while (0)
+#include <asm-generic/barrier.h>
 
 #endif		/* __BARRIER_H */
diff --git a/arch/arc/include/asm/Kbuild b/arch/arc/include/asm/Kbuild
index 5943f7f..e07c786 100644
--- a/arch/arc/include/asm/Kbuild
+++ b/arch/arc/include/asm/Kbuild
@@ -47,3 +47,4 @@ generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
 generic-y += preempt.h
+generic-y += barrier.h
diff --git a/arch/avr32/include/asm/barrier.h b/arch/avr32/include/asm/barrier.h
index 0961275..7151007 100644
--- a/arch/avr32/include/asm/barrier.h
+++ b/arch/avr32/include/asm/barrier.h
@@ -8,22 +8,15 @@
 #ifndef __ASM_AVR32_BARRIER_H
 #define __ASM_AVR32_BARRIER_H
 
-#define nop()			asm volatile("nop")
-
-#define mb()			asm volatile("" : : : "memory")
-#define rmb()			mb()
-#define wmb()			asm volatile("sync 0" : : : "memory")
-#define read_barrier_depends()  do { } while(0)
-#define set_mb(var, value)      do { var = value; mb(); } while(0)
+/*
+ * Weirdest thing ever.. no full barrier, but it has a write barrier!
+ */
+#define wmb()	asm volatile("sync 0" : : : "memory")
 
 #ifdef CONFIG_SMP
 # error "The AVR32 port does not support SMP"
-#else
-# define smp_mb()		barrier()
-# define smp_rmb()		barrier()
-# define smp_wmb()		barrier()
-# define smp_read_barrier_depends() do { } while(0)
 #endif
 
+#include <asm-generic/barrier.h>
 
 #endif /* __ASM_AVR32_BARRIER_H */
diff --git a/arch/blackfin/include/asm/barrier.h b/arch/blackfin/include/asm/barrier.h
index ebb1895..19283a1 100644
--- a/arch/blackfin/include/asm/barrier.h
+++ b/arch/blackfin/include/asm/barrier.h
@@ -23,26 +23,10 @@
 # define rmb()	do { barrier(); smp_check_barrier(); } while (0)
 # define wmb()	do { barrier(); smp_mark_barrier(); } while (0)
 # define read_barrier_depends()	do { barrier(); smp_check_barrier(); } while (0)
-#else
-# define mb()	barrier()
-# define rmb()	barrier()
-# define wmb()	barrier()
-# define read_barrier_depends()	do { } while (0)
 #endif
 
-#else /* !CONFIG_SMP */
-
-#define mb()	barrier()
-#define rmb()	barrier()
-#define wmb()	barrier()
-#define read_barrier_depends()	do { } while (0)
-
 #endif /* !CONFIG_SMP */
 
-#define smp_mb()  mb()
-#define smp_rmb() rmb()
-#define smp_wmb() wmb()
-#define set_mb(var, value) do { var = value; mb(); } while (0)
-#define smp_read_barrier_depends()	read_barrier_depends()
+#include <asm-generic/barrier.h>
 
 #endif /* _BLACKFIN_BARRIER_H */
diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index b06caf6..35ec2e5 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -12,3 +12,4 @@ generic-y += trace_clock.h
 generic-y += vga.h
 generic-y += xor.h
 generic-y += preempt.h
+generic-y += barrier.h
diff --git a/arch/cris/include/asm/barrier.h b/arch/cris/include/asm/barrier.h
deleted file mode 100644
index 198ad7f..0000000
--- a/arch/cris/include/asm/barrier.h
+++ /dev/null
@@ -1,25 +0,0 @@
-#ifndef __ASM_CRIS_BARRIER_H
-#define __ASM_CRIS_BARRIER_H
-
-#define nop() __asm__ __volatile__ ("nop");
-
-#define barrier() __asm__ __volatile__("": : :"memory")
-#define mb() barrier()
-#define rmb() mb()
-#define wmb() mb()
-#define read_barrier_depends() do { } while(0)
-#define set_mb(var, value)  do { var = value; mb(); } while (0)
-
-#ifdef CONFIG_SMP
-#define smp_mb()        mb()
-#define smp_rmb()       rmb()
-#define smp_wmb()       wmb()
-#define smp_read_barrier_depends()     read_barrier_depends()
-#else
-#define smp_mb()        barrier()
-#define smp_rmb()       barrier()
-#define smp_wmb()       barrier()
-#define smp_read_barrier_depends()     do { } while(0)
-#endif
-
-#endif /* __ASM_CRIS_BARRIER_H */
diff --git a/arch/frv/include/asm/barrier.h b/arch/frv/include/asm/barrier.h
index 06776ad..abbef47 100644
--- a/arch/frv/include/asm/barrier.h
+++ b/arch/frv/include/asm/barrier.h
@@ -17,13 +17,7 @@
 #define mb()			asm volatile ("membar" : : :"memory")
 #define rmb()			asm volatile ("membar" : : :"memory")
 #define wmb()			asm volatile ("membar" : : :"memory")
-#define read_barrier_depends()	do { } while (0)
 
-#define smp_mb()			barrier()
-#define smp_rmb()			barrier()
-#define smp_wmb()			barrier()
-#define smp_read_barrier_depends()	do {} while(0)
-#define set_mb(var, value) \
-	do { var = (value); barrier(); } while (0)
+#include <asm-generic/barrier.h>
 
 #endif /* _ASM_BARRIER_H */
diff --git a/arch/hexagon/include/asm/Kbuild b/arch/hexagon/include/asm/Kbuild
index 67c3450..a614ec9 100644
--- a/arch/hexagon/include/asm/Kbuild
+++ b/arch/hexagon/include/asm/Kbuild
@@ -54,3 +54,4 @@ generic-y += ucontext.h
 generic-y += unaligned.h
 generic-y += xor.h
 generic-y += preempt.h
+generic-y += barrier.h
diff --git a/arch/m32r/include/asm/barrier.h b/arch/m32r/include/asm/barrier.h
index 6976621..1a40265 100644
--- a/arch/m32r/include/asm/barrier.h
+++ b/arch/m32r/include/asm/barrier.h
@@ -11,84 +11,6 @@
 
 #define nop()  __asm__ __volatile__ ("nop" : : )
 
-/*
- * Memory barrier.
- *
- * mb() prevents loads and stores being reordered across this point.
- * rmb() prevents loads being reordered across this point.
- * wmb() prevents stores being reordered across this point.
- */
-#define mb()   barrier()
-#define rmb()  mb()
-#define wmb()  mb()
-
-/**
- * read_barrier_depends - Flush all pending reads that subsequents reads
- * depend on.
- *
- * No data-dependent reads from memory-like regions are ever reordered
- * over this barrier.  All reads preceding this primitive are guaranteed
- * to access memory (but not necessarily other CPUs' caches) before any
- * reads following this primitive that depend on the data return by
- * any of the preceding reads.  This primitive is much lighter weight than
- * rmb() on most CPUs, and is never heavier weight than is
- * rmb().
- *
- * These ordering constraints are respected by both the local CPU
- * and the compiler.
- *
- * Ordering is not guaranteed by anything other than these primitives,
- * not even by data dependencies.  See the documentation for
- * memory_barrier() for examples and URLs to more information.
- *
- * For example, the following code would force ordering (the initial
- * value of "a" is zero, "b" is one, and "p" is "&a"):
- *
- * <programlisting>
- *      CPU 0                           CPU 1
- *
- *      b = 2;
- *      memory_barrier();
- *      p = &b;                         q = p;
- *                                      read_barrier_depends();
- *                                      d = *q;
- * </programlisting>
- *
- *
- * because the read of "*q" depends on the read of "p" and these
- * two reads are separated by a read_barrier_depends().  However,
- * the following code, with the same initial values for "a" and "b":
- *
- * <programlisting>
- *      CPU 0                           CPU 1
- *
- *      a = 2;
- *      memory_barrier();
- *      b = 3;                          y = b;
- *                                      read_barrier_depends();
- *                                      x = a;
- * </programlisting>
- *
- * does not enforce ordering, since there is no data dependency between
- * the read of "a" and the read of "b".  Therefore, on some CPUs, such
- * as Alpha, "y" could be set to 3 and "x" to 0.  Use rmb()
- * in cases like this where there are no data dependencies.
- **/
-
-#define read_barrier_depends()	do { } while (0)
-
-#ifdef CONFIG_SMP
-#define smp_mb()	mb()
-#define smp_rmb()	rmb()
-#define smp_wmb()	wmb()
-#define smp_read_barrier_depends()	read_barrier_depends()
-#define set_mb(var, value) do { (void) xchg(&var, value); } while (0)
-#else
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define smp_read_barrier_depends()	do { } while (0)
-#define set_mb(var, value) do { var = value; barrier(); } while (0)
-#endif
+#include <asm-generic/barrier.h>
 
 #endif /* _ASM_M32R_BARRIER_H */
diff --git a/arch/m68k/include/asm/barrier.h b/arch/m68k/include/asm/barrier.h
index 445ce22..15c5f77 100644
--- a/arch/m68k/include/asm/barrier.h
+++ b/arch/m68k/include/asm/barrier.h
@@ -1,20 +1,8 @@
 #ifndef _M68K_BARRIER_H
 #define _M68K_BARRIER_H
 
-/*
- * Force strict CPU ordering.
- * Not really required on m68k...
- */
 #define nop()		do { asm volatile ("nop"); barrier(); } while (0)
-#define mb()		barrier()
-#define rmb()		barrier()
-#define wmb()		barrier()
-#define read_barrier_depends()	((void)0)
-#define set_mb(var, value)	({ (var) = (value); wmb(); })
 
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define smp_read_barrier_depends()	((void)0)
+#include <asm-generic/barrier.h>
 
 #endif /* _M68K_BARRIER_H */
diff --git a/arch/microblaze/include/asm/Kbuild b/arch/microblaze/include/asm/Kbuild
index ce0bbf8..f77fb66 100644
--- a/arch/microblaze/include/asm/Kbuild
+++ b/arch/microblaze/include/asm/Kbuild
@@ -4,3 +4,4 @@ generic-y += exec.h
 generic-y += trace_clock.h
 generic-y += syscalls.h
 generic-y += preempt.h
+generic-y += barrier.h
diff --git a/arch/microblaze/include/asm/barrier.h b/arch/microblaze/include/asm/barrier.h
deleted file mode 100644
index df5be3e8..0000000
--- a/arch/microblaze/include/asm/barrier.h
+++ /dev/null
@@ -1,27 +0,0 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_BARRIER_H
-#define _ASM_MICROBLAZE_BARRIER_H
-
-#define nop()                  asm volatile ("nop")
-
-#define smp_read_barrier_depends()	do {} while (0)
-#define read_barrier_depends()		do {} while (0)
-
-#define mb()			barrier()
-#define rmb()			mb()
-#define wmb()			mb()
-#define set_mb(var, value)	do { var = value; mb(); } while (0)
-#define set_wmb(var, value)	do { var = value; wmb(); } while (0)
-
-#define smp_mb()		mb()
-#define smp_rmb()		rmb()
-#define smp_wmb()		wmb()
-
-#endif /* _ASM_MICROBLAZE_BARRIER_H */
diff --git a/arch/mn10300/include/asm/Kbuild b/arch/mn10300/include/asm/Kbuild
index 74742dc..367ef39 100644
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@ -3,3 +3,4 @@ generic-y += clkdev.h
 generic-y += exec.h
 generic-y += trace_clock.h
 generic-y += preempt.h
+generic-y += barrier.h
diff --git a/arch/mn10300/include/asm/barrier.h b/arch/mn10300/include/asm/barrier.h
deleted file mode 100644
index 2bd97a5..0000000
--- a/arch/mn10300/include/asm/barrier.h
+++ /dev/null
@@ -1,37 +0,0 @@
-/* MN10300 memory barrier definitions
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#ifndef _ASM_BARRIER_H
-#define _ASM_BARRIER_H
-
-#define nop()	asm volatile ("nop")
-
-#define mb()	asm volatile ("": : :"memory")
-#define rmb()	mb()
-#define wmb()	asm volatile ("": : :"memory")
-
-#ifdef CONFIG_SMP
-#define smp_mb()	mb()
-#define smp_rmb()	rmb()
-#define smp_wmb()	wmb()
-#define set_mb(var, value)  do { xchg(&var, value); } while (0)
-#else  /* CONFIG_SMP */
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define set_mb(var, value)  do { var = value;  mb(); } while (0)
-#endif /* CONFIG_SMP */
-
-#define set_wmb(var, value) do { var = value; wmb(); } while (0)
-
-#define read_barrier_depends()		do {} while (0)
-#define smp_read_barrier_depends()	do {} while (0)
-
-#endif /* _ASM_BARRIER_H */
diff --git a/arch/parisc/include/asm/Kbuild b/arch/parisc/include/asm/Kbuild
index a603b9e..8df06d0 100644
--- a/arch/parisc/include/asm/Kbuild
+++ b/arch/parisc/include/asm/Kbuild
@@ -5,3 +5,4 @@ generic-y += word-at-a-time.h auxvec.h user.h cputime.h emergency-restart.h \
 	  poll.h xor.h clkdev.h exec.h
 generic-y += trace_clock.h
 generic-y += preempt.h
+generic-y += barrier.h
diff --git a/arch/parisc/include/asm/barrier.h b/arch/parisc/include/asm/barrier.h
deleted file mode 100644
index e77d834..0000000
--- a/arch/parisc/include/asm/barrier.h
+++ /dev/null
@@ -1,35 +0,0 @@
-#ifndef __PARISC_BARRIER_H
-#define __PARISC_BARRIER_H
-
-/*
-** This is simply the barrier() macro from linux/kernel.h but when serial.c
-** uses tqueue.h uses smp_mb() defined using barrier(), linux/kernel.h
-** hasn't yet been included yet so it fails, thus repeating the macro here.
-**
-** PA-RISC architecture allows for weakly ordered memory accesses although
-** none of the processors use it. There is a strong ordered bit that is
-** set in the O-bit of the page directory entry. Operating systems that
-** can not tolerate out of order accesses should set this bit when mapping
-** pages. The O-bit of the PSW should also be set to 1 (I don't believe any
-** of the processor implemented the PSW O-bit). The PCX-W ERS states that
-** the TLB O-bit is not implemented so the page directory does not need to
-** have the O-bit set when mapping pages (section 3.1). This section also
-** states that the PSW Y, Z, G, and O bits are not implemented.
-** So it looks like nothing needs to be done for parisc-linux (yet).
-** (thanks to chada for the above comment -ggg)
-**
-** The __asm__ op below simple prevents gcc/ld from reordering
-** instructions across the mb() "call".
-*/
-#define mb()		__asm__ __volatile__("":::"memory")	/* barrier() */
-#define rmb()		mb()
-#define wmb()		mb()
-#define smp_mb()	mb()
-#define smp_rmb()	mb()
-#define smp_wmb()	mb()
-#define smp_read_barrier_depends()	do { } while(0)
-#define read_barrier_depends()		do { } while(0)
-
-#define set_mb(var, value)		do { var = value; mb(); } while (0)
-
-#endif /* __PARISC_BARRIER_H */
diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
index f3414ad..ee2993b 100644
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -5,3 +5,4 @@ generic-y += clkdev.h
 generic-y += trace_clock.h
 generic-y += xor.h
 generic-y += preempt.h
+generic-y += barrier.h
diff --git a/arch/score/include/asm/barrier.h b/arch/score/include/asm/barrier.h
deleted file mode 100644
index 0eacb64..0000000
--- a/arch/score/include/asm/barrier.h
+++ /dev/null
@@ -1,16 +0,0 @@
-#ifndef _ASM_SCORE_BARRIER_H
-#define _ASM_SCORE_BARRIER_H
-
-#define mb()		barrier()
-#define rmb()		barrier()
-#define wmb()		barrier()
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-
-#define read_barrier_depends()		do {} while (0)
-#define smp_read_barrier_depends()	do {} while (0)
-
-#define set_mb(var, value) 		do {var = value; wmb(); } while (0)
-
-#endif /* _ASM_SCORE_BARRIER_H */
diff --git a/arch/sh/include/asm/barrier.h b/arch/sh/include/asm/barrier.h
index 72c103d..4371530 100644
--- a/arch/sh/include/asm/barrier.h
+++ b/arch/sh/include/asm/barrier.h
@@ -26,29 +26,14 @@
 #if defined(CONFIG_CPU_SH4A) || defined(CONFIG_CPU_SH5)
 #define mb()		__asm__ __volatile__ ("synco": : :"memory")
 #define rmb()		mb()
-#define wmb()		__asm__ __volatile__ ("synco": : :"memory")
+#define wmb()		mb()
 #define ctrl_barrier()	__icbi(PAGE_OFFSET)
-#define read_barrier_depends()	do { } while(0)
 #else
-#define mb()		__asm__ __volatile__ ("": : :"memory")
-#define rmb()		mb()
-#define wmb()		__asm__ __volatile__ ("": : :"memory")
 #define ctrl_barrier()	__asm__ __volatile__ ("nop;nop;nop;nop;nop;nop;nop;nop")
-#define read_barrier_depends()	do { } while(0)
-#endif
-
-#ifdef CONFIG_SMP
-#define smp_mb()	mb()
-#define smp_rmb()	rmb()
-#define smp_wmb()	wmb()
-#define smp_read_barrier_depends()	read_barrier_depends()
-#else
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define smp_read_barrier_depends()	do { } while(0)
 #endif
 
 #define set_mb(var, value) do { (void)xchg(&var, value); } while (0)
 
+#include <asm-generic/barrier.h>
+
 #endif /* __ASM_SH_BARRIER_H */
diff --git a/arch/sparc/include/asm/barrier_32.h b/arch/sparc/include/asm/barrier_32.h
index c1b7665..ae69eda 100644
--- a/arch/sparc/include/asm/barrier_32.h
+++ b/arch/sparc/include/asm/barrier_32.h
@@ -1,15 +1,7 @@
 #ifndef __SPARC_BARRIER_H
 #define __SPARC_BARRIER_H
 
-/* XXX Change this if we ever use a PSO mode kernel. */
-#define mb()	__asm__ __volatile__ ("" : : : "memory")
-#define rmb()	mb()
-#define wmb()	mb()
-#define read_barrier_depends()	do { } while(0)
-#define set_mb(__var, __value)  do { __var = __value; mb(); } while(0)
-#define smp_mb()	__asm__ __volatile__("":::"memory")
-#define smp_rmb()	__asm__ __volatile__("":::"memory")
-#define smp_wmb()	__asm__ __volatile__("":::"memory")
-#define smp_read_barrier_depends()	do { } while(0)
+#include <asm/processor.h> /* for nop() */
+#include <asm-generic/barrier.h>
 
 #endif /* !(__SPARC_BARRIER_H) */
diff --git a/arch/tile/include/asm/barrier.h b/arch/tile/include/asm/barrier.h
index a9a73da..b5a05d0 100644
--- a/arch/tile/include/asm/barrier.h
+++ b/arch/tile/include/asm/barrier.h
@@ -22,59 +22,6 @@
 #include <arch/spr_def.h>
 #include <asm/timex.h>
 
-/*
- * read_barrier_depends - Flush all pending reads that subsequents reads
- * depend on.
- *
- * No data-dependent reads from memory-like regions are ever reordered
- * over this barrier.  All reads preceding this primitive are guaranteed
- * to access memory (but not necessarily other CPUs' caches) before any
- * reads following this primitive that depend on the data return by
- * any of the preceding reads.  This primitive is much lighter weight than
- * rmb() on most CPUs, and is never heavier weight than is
- * rmb().
- *
- * These ordering constraints are respected by both the local CPU
- * and the compiler.
- *
- * Ordering is not guaranteed by anything other than these primitives,
- * not even by data dependencies.  See the documentation for
- * memory_barrier() for examples and URLs to more information.
- *
- * For example, the following code would force ordering (the initial
- * value of "a" is zero, "b" is one, and "p" is "&a"):
- *
- * <programlisting>
- *	CPU 0				CPU 1
- *
- *	b = 2;
- *	memory_barrier();
- *	p = &b;				q = p;
- *					read_barrier_depends();
- *					d = *q;
- * </programlisting>
- *
- * because the read of "*q" depends on the read of "p" and these
- * two reads are separated by a read_barrier_depends().  However,
- * the following code, with the same initial values for "a" and "b":
- *
- * <programlisting>
- *	CPU 0				CPU 1
- *
- *	a = 2;
- *	memory_barrier();
- *	b = 3;				y = b;
- *					read_barrier_depends();
- *					x = a;
- * </programlisting>
- *
- * does not enforce ordering, since there is no data dependency between
- * the read of "a" and the read of "b".  Therefore, on some CPUs, such
- * as Alpha, "y" could be set to 3 and "x" to 0.  Use rmb()
- * in cases like this where there are no data dependencies.
- */
-#define read_barrier_depends()	do { } while (0)
-
 #define __sync()	__insn_mf()
 
 #include <hv/syscall_public.h>
@@ -125,20 +72,7 @@ mb_incoherent(void)
 #define mb()		fast_mb()
 #define iob()		fast_iob()
 
-#ifdef CONFIG_SMP
-#define smp_mb()	mb()
-#define smp_rmb()	rmb()
-#define smp_wmb()	wmb()
-#define smp_read_barrier_depends()	read_barrier_depends()
-#else
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define smp_read_barrier_depends()	do { } while (0)
-#endif
-
-#define set_mb(var, value) \
-	do { var = value; mb(); } while (0)
+#include <asm-generic/barrier.h>
 
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASM_TILE_BARRIER_H */
diff --git a/arch/unicore32/include/asm/barrier.h b/arch/unicore32/include/asm/barrier.h
index a6620e5..83d6a52 100644
--- a/arch/unicore32/include/asm/barrier.h
+++ b/arch/unicore32/include/asm/barrier.h
@@ -14,15 +14,6 @@
 #define dsb() __asm__ __volatile__ ("" : : : "memory")
 #define dmb() __asm__ __volatile__ ("" : : : "memory")
 
-#define mb()				barrier()
-#define rmb()				barrier()
-#define wmb()				barrier()
-#define smp_mb()			barrier()
-#define smp_rmb()			barrier()
-#define smp_wmb()			barrier()
-#define read_barrier_depends()		do { } while (0)
-#define smp_read_barrier_depends()	do { } while (0)
-
-#define set_mb(var, value)		do { var = value; smp_mb(); } while (0)
+#include <asm-generic/barrier.h>
 
 #endif /* __UNICORE_BARRIER_H__ */
diff --git a/arch/xtensa/include/asm/barrier.h b/arch/xtensa/include/asm/barrier.h
index ef02167..e1ee6b5 100644
--- a/arch/xtensa/include/asm/barrier.h
+++ b/arch/xtensa/include/asm/barrier.h
@@ -9,21 +9,14 @@
 #ifndef _XTENSA_SYSTEM_H
 #define _XTENSA_SYSTEM_H
 
-#define smp_read_barrier_depends() do { } while(0)
-#define read_barrier_depends() do { } while(0)
-
 #define mb()  ({ __asm__ __volatile__("memw" : : : "memory"); })
 #define rmb() barrier()
 #define wmb() mb()
 
 #ifdef CONFIG_SMP
 #error smp_* not defined
-#else
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
 #endif
 
-#define set_mb(var, value)	do { var = value; mb(); } while (0)
+#include <asm-generic/barrier.h>
 
 #endif /* _XTENSA_SYSTEM_H */
diff --git a/include/asm-generic/barrier.h b/include/asm-generic/barrier.h
index 639d7a4..d12a90f 100644
--- a/include/asm-generic/barrier.h
+++ b/include/asm-generic/barrier.h
@@ -1,4 +1,5 @@
-/* Generic barrier definitions, based on MN10300 definitions.
+/*
+ * Generic barrier definitions, originally based on MN10300 definitions.
  *
  * It should be possible to use these on really simple architectures,
  * but it serves more as a starting point for new ports.
@@ -16,35 +17,50 @@
 
 #ifndef __ASSEMBLY__
 
-#define nop() asm volatile ("nop")
+#include <linux/compiler.h>
+
+#ifndef nop
+#define nop()	asm volatile ("nop")
+#endif
 
 /*
- * Force strict CPU ordering.
- * And yes, this is required on UP too when we're talking
- * to devices.
+ * Force strict CPU ordering. And yes, this is required on UP too when we're
+ * talking to devices.
  *
- * This implementation only contains a compiler barrier.
+ * Fall back to compiler barriers if nothing better is provided.
  */
 
-#define mb()	asm volatile ("": : :"memory")
+#ifndef mb
+#define mb()	barrier()
+#endif
+
+#ifndef rmb
 #define rmb()	mb()
-#define wmb()	asm volatile ("": : :"memory")
+#endif
+
+#ifndef wmb
+#define wmb()	mb()
+#endif
+
+#ifndef read_barrier_depends
+#define read_barrier_depends()		do { } while (0)
+#endif
 
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
 #define smp_rmb()	rmb()
 #define smp_wmb()	wmb()
+#define smp_read_barrier_depends()	read_barrier_depends()
 #else
 #define smp_mb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
+#define smp_read_barrier_depends()	do { } while (0)
 #endif
 
-#define set_mb(var, value)  do { var = value;  mb(); } while (0)
-#define set_wmb(var, value) do { var = value; wmb(); } while (0)
-
-#define read_barrier_depends()		do {} while (0)
-#define smp_read_barrier_depends()	do {} while (0)
+#ifndef set_mb
+#define set_mb(var, value)  do { (var) = (value); mb(); } while (0)
+#endif
 
 #endif /* !__ASSEMBLY__ */
 #endif /* __ASM_GENERIC_BARRIER_H */
