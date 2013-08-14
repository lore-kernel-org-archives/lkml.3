Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932Ab3HNNlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:41:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54875 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932836Ab3HNNfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:35:01 -0400
Message-Id: <20130814133142.725789730@chello.nl>
User-Agent: quilt/0.60-1
Date: Wed, 14 Aug 2013 15:15:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 3/5] sched, arch: Create asm/preempt.h
References: <20130814131539.790947874@chello.nl>
Content-Disposition: inline; filename=peterz-asm-preempt_count.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to prepare to per-arch implementations of preempt_count move
the required bits into an asm-generic header and use this for all
archs.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-svxlmlhaa58low5tko1itj2v@git.kernel.org
---
 arch/alpha/include/asm/Kbuild      |    1 +
 arch/arc/include/asm/Kbuild        |    1 +
 arch/arm/include/asm/Kbuild        |    1 +
 arch/arm64/include/asm/Kbuild      |    1 +
 arch/avr32/include/asm/Kbuild      |    1 +
 arch/blackfin/include/asm/Kbuild   |    1 +
 arch/c6x/include/asm/Kbuild        |    1 +
 arch/cris/include/asm/Kbuild       |    1 +
 arch/frv/include/asm/Kbuild        |    1 +
 arch/h8300/include/asm/Kbuild      |    1 +
 arch/hexagon/include/asm/Kbuild    |    1 +
 arch/ia64/include/asm/Kbuild       |    1 +
 arch/m32r/include/asm/Kbuild       |    1 +
 arch/m68k/include/asm/Kbuild       |    1 +
 arch/metag/include/asm/Kbuild      |    1 +
 arch/microblaze/include/asm/Kbuild |    1 +
 arch/mips/include/asm/Kbuild       |    1 +
 arch/mn10300/include/asm/Kbuild    |    1 +
 arch/openrisc/include/asm/Kbuild   |    1 +
 arch/parisc/include/asm/Kbuild     |    1 +
 arch/powerpc/include/asm/Kbuild    |    1 +
 arch/s390/include/asm/Kbuild       |    1 +
 arch/score/include/asm/Kbuild      |    1 +
 arch/sh/include/asm/Kbuild         |    1 +
 arch/sparc/include/asm/Kbuild      |    1 +
 arch/tile/include/asm/Kbuild       |    1 +
 arch/um/include/asm/Kbuild         |    1 +
 arch/unicore32/include/asm/Kbuild  |    1 +
 arch/x86/include/asm/Kbuild        |    1 +
 arch/xtensa/include/asm/Kbuild     |    1 +
 include/asm-generic/preempt.h      |   20 ++++++++++++++++++++
 include/linux/preempt.h            |   15 +--------------
 32 files changed, 51 insertions(+), 14 deletions(-)

--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -3,3 +3,4 @@ generic-y += clkdev.h
 
 generic-y += exec.h
 generic-y += trace_clock.h
+generic-y += preempt.h
--- a/arch/arc/include/asm/Kbuild
+++ b/arch/arc/include/asm/Kbuild
@@ -46,3 +46,4 @@ generic-y += ucontext.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
+generic-y += preempt.h
--- a/arch/arm/include/asm/Kbuild
+++ b/arch/arm/include/asm/Kbuild
@@ -33,3 +33,4 @@ generic-y += timex.h
 generic-y += trace_clock.h
 generic-y += types.h
 generic-y += unaligned.h
+generic-y += preempt.h
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -50,3 +50,4 @@ generic-y += unaligned.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
+generic-y += preempt.h
--- a/arch/avr32/include/asm/Kbuild
+++ b/arch/avr32/include/asm/Kbuild
@@ -3,3 +3,4 @@ generic-y	+= clkdev.h
 generic-y	+= exec.h
 generic-y	+= trace_clock.h
 generic-y	+= param.h
+generic-y += preempt.h
--- a/arch/blackfin/include/asm/Kbuild
+++ b/arch/blackfin/include/asm/Kbuild
@@ -44,3 +44,4 @@ generic-y += ucontext.h
 generic-y += unaligned.h
 generic-y += user.h
 generic-y += xor.h
+generic-y += preempt.h
--- a/arch/c6x/include/asm/Kbuild
+++ b/arch/c6x/include/asm/Kbuild
@@ -56,3 +56,4 @@ generic-y += ucontext.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
+generic-y += preempt.h
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -11,3 +11,4 @@ generic-y += module.h
 generic-y += trace_clock.h
 generic-y += vga.h
 generic-y += xor.h
+generic-y += preempt.h
--- a/arch/frv/include/asm/Kbuild
+++ b/arch/frv/include/asm/Kbuild
@@ -2,3 +2,4 @@
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += trace_clock.h
+generic-y += preempt.h
--- a/arch/h8300/include/asm/Kbuild
+++ b/arch/h8300/include/asm/Kbuild
@@ -6,3 +6,4 @@ generic-y += mmu.h
 generic-y += module.h
 generic-y += trace_clock.h
 generic-y += xor.h
+generic-y += preempt.h
--- a/arch/hexagon/include/asm/Kbuild
+++ b/arch/hexagon/include/asm/Kbuild
@@ -53,3 +53,4 @@ generic-y += types.h
 generic-y += ucontext.h
 generic-y += unaligned.h
 generic-y += xor.h
+generic-y += preempt.h
--- a/arch/ia64/include/asm/Kbuild
+++ b/arch/ia64/include/asm/Kbuild
@@ -3,3 +3,4 @@ generic-y += clkdev.h
 generic-y += exec.h
 generic-y += kvm_para.h
 generic-y += trace_clock.h
+generic-y += preempt.h
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@ -3,3 +3,4 @@ generic-y += clkdev.h
 generic-y += exec.h
 generic-y += module.h
 generic-y += trace_clock.h
+generic-y += preempt.h
--- a/arch/m68k/include/asm/Kbuild
+++ b/arch/m68k/include/asm/Kbuild
@@ -31,3 +31,4 @@ generic-y += trace_clock.h
 generic-y += types.h
 generic-y += word-at-a-time.h
 generic-y += xor.h
+generic-y += preempt.h
--- a/arch/metag/include/asm/Kbuild
+++ b/arch/metag/include/asm/Kbuild
@@ -52,3 +52,4 @@ generic-y += unaligned.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
+generic-y += preempt.h
--- a/arch/microblaze/include/asm/Kbuild
+++ b/arch/microblaze/include/asm/Kbuild
@@ -3,3 +3,4 @@ generic-y += clkdev.h
 generic-y += exec.h
 generic-y += trace_clock.h
 generic-y += syscalls.h
+generic-y += preempt.h
--- a/arch/mips/include/asm/Kbuild
+++ b/arch/mips/include/asm/Kbuild
@@ -1,2 +1,3 @@
 # MIPS headers
 generic-y += trace_clock.h
+generic-y += preempt.h
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@ -2,3 +2,4 @@
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += trace_clock.h
+generic-y += preempt.h
--- a/arch/openrisc/include/asm/Kbuild
+++ b/arch/openrisc/include/asm/Kbuild
@@ -67,3 +67,4 @@ generic-y += ucontext.h
 generic-y += user.h
 generic-y += word-at-a-time.h
 generic-y += xor.h
+generic-y += preempt.h
--- a/arch/parisc/include/asm/Kbuild
+++ b/arch/parisc/include/asm/Kbuild
@@ -4,3 +4,4 @@ generic-y += word-at-a-time.h auxvec.h u
 	  div64.h irq_regs.h kdebug.h kvm_para.h local64.h local.h param.h \
 	  poll.h xor.h clkdev.h exec.h
 generic-y += trace_clock.h
+generic-y += preempt.h
--- a/arch/powerpc/include/asm/Kbuild
+++ b/arch/powerpc/include/asm/Kbuild
@@ -2,3 +2,4 @@
 generic-y += clkdev.h
 generic-y += rwsem.h
 generic-y += trace_clock.h
+generic-y += preempt.h
--- a/arch/s390/include/asm/Kbuild
+++ b/arch/s390/include/asm/Kbuild
@@ -2,3 +2,4 @@
 
 generic-y += clkdev.h
 generic-y += trace_clock.h
+generic-y += preempt.h
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -4,3 +4,4 @@ header-y +=
 generic-y += clkdev.h
 generic-y += trace_clock.h
 generic-y += xor.h
+generic-y += preempt.h
--- a/arch/sh/include/asm/Kbuild
+++ b/arch/sh/include/asm/Kbuild
@@ -34,3 +34,4 @@ generic-y += termios.h
 generic-y += trace_clock.h
 generic-y += ucontext.h
 generic-y += xor.h
+generic-y += preempt.h
--- a/arch/sparc/include/asm/Kbuild
+++ b/arch/sparc/include/asm/Kbuild
@@ -16,3 +16,4 @@ generic-y += serial.h
 generic-y += trace_clock.h
 generic-y += types.h
 generic-y += word-at-a-time.h
+generic-y += preempt.h
--- a/arch/tile/include/asm/Kbuild
+++ b/arch/tile/include/asm/Kbuild
@@ -37,3 +37,4 @@ generic-y += termios.h
 generic-y += trace_clock.h
 generic-y += types.h
 generic-y += xor.h
+generic-y += preempt.h
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -3,3 +3,4 @@ generic-y += hw_irq.h irq_regs.h kdebug.
 generic-y += ftrace.h pci.h io.h param.h delay.h mutex.h current.h exec.h
 generic-y += switch_to.h clkdev.h
 generic-y += trace_clock.h
+generic-y += preempt.h
--- a/arch/unicore32/include/asm/Kbuild
+++ b/arch/unicore32/include/asm/Kbuild
@@ -60,3 +60,4 @@ generic-y += unaligned.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
+generic-y += preempt.h
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -5,3 +5,4 @@ genhdr-y += unistd_64.h
 genhdr-y += unistd_x32.h
 
 generic-y += clkdev.h
+generic-y += preempt.h
--- a/arch/xtensa/include/asm/Kbuild
+++ b/arch/xtensa/include/asm/Kbuild
@@ -28,3 +28,4 @@ generic-y += termios.h
 generic-y += topology.h
 generic-y += trace_clock.h
 generic-y += xor.h
+generic-y += preempt.h
--- /dev/null
+++ b/include/asm-generic/preempt.h
@@ -0,0 +1,20 @@
+#ifndef __ASM_PREEMPT_H
+#define __ASM_PREEMPT_H
+
+#include <linux/thread_info.h>
+
+/*
+ * We mask the PREEMPT_NEED_RESCHED bit so as not to confuse all current users
+ * that think a non-zero value indicates we cannot preempt.
+ */
+static __always_inline int preempt_count(void)
+{
+	return current_thread_info()->preempt_count & ~PREEMPT_NEED_RESCHED;
+}
+
+static __always_inline int *preempt_count_ptr(void)
+{
+	return &current_thread_info()->preempt_count;
+}
+
+#endif /* __ASM_PREEMPT_H */
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -6,7 +6,6 @@
  * preempt_count (used for kernel preemption, interrupt count, etc.)
  */
 
-#include <linux/thread_info.h>
 #include <linux/linkage.h>
 #include <linux/list.h>
 
@@ -16,19 +15,7 @@
  */
 #define PREEMPT_NEED_RESCHED	0x80000000
 
-/*
- * We mask the PREEMPT_NEED_RESCHED bit so as not to confuse all current users
- * that think a non-zero value indicates we cannot preempt.
- */
-static __always_inline int preempt_count(void)
-{
-	return current_thread_info()->preempt_count & ~PREEMPT_NEED_RESCHED;
-}
-
-static __always_inline int *preempt_count_ptr(void)
-{
-	return &current_thread_info()->preempt_count;
-}
+#include <asm/preempt.h>
 
 /*
  * We fold the NEED_RESCHED bit into the preempt count such that


