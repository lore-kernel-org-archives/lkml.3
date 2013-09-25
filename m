Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab3IYQjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:39:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40205 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab3IYQjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:39:33 -0400
Date: Wed, 25 Sep 2013 09:38:49 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-h5j0c1r3e3fk015m30h8f1zx@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, arch: Create asm/preempt.h
Git-Commit-ID: a787870924dbd6f321661e06d4ec1c7a408c9ccf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 25 Sep 2013 09:38:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a787870924dbd6f321661e06d4ec1c7a408c9ccf
Gitweb:     http://git.kernel.org/tip/a787870924dbd6f321661e06d4ec1c7a408c9ccf
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 14 Aug 2013 14:55:40 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 25 Sep 2013 14:07:50 +0200

sched, arch: Create asm/preempt.h

In order to prepare to per-arch implementations of preempt_count move
the required bits into an asm-generic header and use this for all
archs.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-h5j0c1r3e3fk015m30h8f1zx@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/alpha/include/asm/Kbuild      |  1 +
 arch/arc/include/asm/Kbuild        |  1 +
 arch/arm/include/asm/Kbuild        |  1 +
 arch/arm64/include/asm/Kbuild      |  1 +
 arch/avr32/include/asm/Kbuild      |  1 +
 arch/blackfin/include/asm/Kbuild   |  1 +
 arch/c6x/include/asm/Kbuild        |  1 +
 arch/cris/include/asm/Kbuild       |  1 +
 arch/frv/include/asm/Kbuild        |  1 +
 arch/h8300/include/asm/Kbuild      |  1 +
 arch/hexagon/include/asm/Kbuild    |  1 +
 arch/ia64/include/asm/Kbuild       |  1 +
 arch/m32r/include/asm/Kbuild       |  1 +
 arch/m68k/include/asm/Kbuild       |  1 +
 arch/metag/include/asm/Kbuild      |  1 +
 arch/microblaze/include/asm/Kbuild |  1 +
 arch/mips/include/asm/Kbuild       |  1 +
 arch/mn10300/include/asm/Kbuild    |  1 +
 arch/openrisc/include/asm/Kbuild   |  1 +
 arch/parisc/include/asm/Kbuild     |  1 +
 arch/powerpc/include/asm/Kbuild    |  1 +
 arch/s390/include/asm/Kbuild       |  1 +
 arch/score/include/asm/Kbuild      |  1 +
 arch/sh/include/asm/Kbuild         |  1 +
 arch/sparc/include/asm/Kbuild      |  1 +
 arch/tile/include/asm/Kbuild       |  1 +
 arch/um/include/asm/Kbuild         |  1 +
 arch/unicore32/include/asm/Kbuild  |  1 +
 arch/x86/include/asm/Kbuild        |  1 +
 arch/xtensa/include/asm/Kbuild     |  1 +
 include/asm-generic/preempt.h      | 54 ++++++++++++++++++++++++++++++++++++++
 include/linux/preempt.h            | 49 +---------------------------------
 32 files changed, 85 insertions(+), 48 deletions(-)

diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
index a6e85f44..f01fb50 100644
--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -3,3 +3,4 @@ generic-y += clkdev.h
 
 generic-y += exec.h
 generic-y += trace_clock.h
+generic-y += preempt.h
diff --git a/arch/arc/include/asm/Kbuild b/arch/arc/include/asm/Kbuild
index d8dd660..5943f7f 100644
--- a/arch/arc/include/asm/Kbuild
+++ b/arch/arc/include/asm/Kbuild
@@ -46,3 +46,4 @@ generic-y += ucontext.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/arm/include/asm/Kbuild b/arch/arm/include/asm/Kbuild
index d3db398..4e6838d 100644
--- a/arch/arm/include/asm/Kbuild
+++ b/arch/arm/include/asm/Kbuild
@@ -33,3 +33,4 @@ generic-y += timex.h
 generic-y += trace_clock.h
 generic-y += types.h
 generic-y += unaligned.h
+generic-y += preempt.h
diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index 79a642d..519f89f 100644
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -50,3 +50,4 @@ generic-y += unaligned.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/avr32/include/asm/Kbuild b/arch/avr32/include/asm/Kbuild
index d22af85..b946080 100644
--- a/arch/avr32/include/asm/Kbuild
+++ b/arch/avr32/include/asm/Kbuild
@@ -3,3 +3,4 @@ generic-y	+= clkdev.h
 generic-y	+= exec.h
 generic-y	+= trace_clock.h
 generic-y	+= param.h
+generic-y += preempt.h
diff --git a/arch/blackfin/include/asm/Kbuild b/arch/blackfin/include/asm/Kbuild
index 127826f..f2b4347 100644
--- a/arch/blackfin/include/asm/Kbuild
+++ b/arch/blackfin/include/asm/Kbuild
@@ -44,3 +44,4 @@ generic-y += ucontext.h
 generic-y += unaligned.h
 generic-y += user.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/c6x/include/asm/Kbuild b/arch/c6x/include/asm/Kbuild
index e49f918..fc0b3c3 100644
--- a/arch/c6x/include/asm/Kbuild
+++ b/arch/c6x/include/asm/Kbuild
@@ -56,3 +56,4 @@ generic-y += ucontext.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index c832545..b06caf6 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -11,3 +11,4 @@ generic-y += module.h
 generic-y += trace_clock.h
 generic-y += vga.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/frv/include/asm/Kbuild b/arch/frv/include/asm/Kbuild
index c5d7670..74742dc 100644
--- a/arch/frv/include/asm/Kbuild
+++ b/arch/frv/include/asm/Kbuild
@@ -2,3 +2,4 @@
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += trace_clock.h
+generic-y += preempt.h
diff --git a/arch/h8300/include/asm/Kbuild b/arch/h8300/include/asm/Kbuild
index 8ada3cf..7e0e721 100644
--- a/arch/h8300/include/asm/Kbuild
+++ b/arch/h8300/include/asm/Kbuild
@@ -6,3 +6,4 @@ generic-y += mmu.h
 generic-y += module.h
 generic-y += trace_clock.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/hexagon/include/asm/Kbuild b/arch/hexagon/include/asm/Kbuild
index 1da17ca..67c3450 100644
--- a/arch/hexagon/include/asm/Kbuild
+++ b/arch/hexagon/include/asm/Kbuild
@@ -53,3 +53,4 @@ generic-y += types.h
 generic-y += ucontext.h
 generic-y += unaligned.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/ia64/include/asm/Kbuild b/arch/ia64/include/asm/Kbuild
index a3456f3..f93ee08 100644
--- a/arch/ia64/include/asm/Kbuild
+++ b/arch/ia64/include/asm/Kbuild
@@ -3,4 +3,5 @@ generic-y += clkdev.h
 generic-y += exec.h
 generic-y += kvm_para.h
 generic-y += trace_clock.h
+generic-y += preempt.h
 generic-y += vtime.h
\ No newline at end of file
diff --git a/arch/m32r/include/asm/Kbuild b/arch/m32r/include/asm/Kbuild
index bebdc36..2b58c5f 100644
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@ -3,3 +3,4 @@ generic-y += clkdev.h
 generic-y += exec.h
 generic-y += module.h
 generic-y += trace_clock.h
+generic-y += preempt.h
diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
index 09d77a8..a5d27f2 100644
--- a/arch/m68k/include/asm/Kbuild
+++ b/arch/m68k/include/asm/Kbuild
@@ -31,3 +31,4 @@ generic-y += trace_clock.h
 generic-y += types.h
 generic-y += word-at-a-time.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/metag/include/asm/Kbuild b/arch/metag/include/asm/Kbuild
index 6ae0ccb..84d0c1d 100644
--- a/arch/metag/include/asm/Kbuild
+++ b/arch/metag/include/asm/Kbuild
@@ -52,3 +52,4 @@ generic-y += unaligned.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/microblaze/include/asm/Kbuild b/arch/microblaze/include/asm/Kbuild
index d3c51a6..ce0bbf8 100644
--- a/arch/microblaze/include/asm/Kbuild
+++ b/arch/microblaze/include/asm/Kbuild
@@ -3,3 +3,4 @@ generic-y += clkdev.h
 generic-y += exec.h
 generic-y += trace_clock.h
 generic-y += syscalls.h
+generic-y += preempt.h
diff --git a/arch/mips/include/asm/Kbuild b/arch/mips/include/asm/Kbuild
index 454ddf9..1acbb8b 100644
--- a/arch/mips/include/asm/Kbuild
+++ b/arch/mips/include/asm/Kbuild
@@ -11,5 +11,6 @@ generic-y += sections.h
 generic-y += segment.h
 generic-y += serial.h
 generic-y += trace_clock.h
+generic-y += preempt.h
 generic-y += ucontext.h
 generic-y += xor.h
diff --git a/arch/mn10300/include/asm/Kbuild b/arch/mn10300/include/asm/Kbuild
index c5d7670..74742dc 100644
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@ -2,3 +2,4 @@
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += trace_clock.h
+generic-y += preempt.h
diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/Kbuild
index 195653e..7840562 100644
--- a/arch/openrisc/include/asm/Kbuild
+++ b/arch/openrisc/include/asm/Kbuild
@@ -67,3 +67,4 @@ generic-y += ucontext.h
 generic-y += user.h
 generic-y += word-at-a-time.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/parisc/include/asm/Kbuild b/arch/parisc/include/asm/Kbuild
index ff4c9fa..a603b9e 100644
--- a/arch/parisc/include/asm/Kbuild
+++ b/arch/parisc/include/asm/Kbuild
@@ -4,3 +4,4 @@ generic-y += word-at-a-time.h auxvec.h user.h cputime.h emergency-restart.h \
 	  div64.h irq_regs.h kdebug.h kvm_para.h local64.h local.h param.h \
 	  poll.h xor.h clkdev.h exec.h
 generic-y += trace_clock.h
+generic-y += preempt.h
diff --git a/arch/powerpc/include/asm/Kbuild b/arch/powerpc/include/asm/Kbuild
index 704e6f1..d8f9d2f 100644
--- a/arch/powerpc/include/asm/Kbuild
+++ b/arch/powerpc/include/asm/Kbuild
@@ -2,4 +2,5 @@
 generic-y += clkdev.h
 generic-y += rwsem.h
 generic-y += trace_clock.h
+generic-y += preempt.h
 generic-y += vtime.h
\ No newline at end of file
diff --git a/arch/s390/include/asm/Kbuild b/arch/s390/include/asm/Kbuild
index f313f9c..7a5288f 100644
--- a/arch/s390/include/asm/Kbuild
+++ b/arch/s390/include/asm/Kbuild
@@ -2,3 +2,4 @@
 
 generic-y += clkdev.h
 generic-y += trace_clock.h
+generic-y += preempt.h
diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
index e1c7bb9..f3414ad 100644
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -4,3 +4,4 @@ header-y +=
 generic-y += clkdev.h
 generic-y += trace_clock.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/sh/include/asm/Kbuild b/arch/sh/include/asm/Kbuild
index 280bea9..231efbb 100644
--- a/arch/sh/include/asm/Kbuild
+++ b/arch/sh/include/asm/Kbuild
@@ -34,3 +34,4 @@ generic-y += termios.h
 generic-y += trace_clock.h
 generic-y += ucontext.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/sparc/include/asm/Kbuild b/arch/sparc/include/asm/Kbuild
index 7e4a97f..bf39066 100644
--- a/arch/sparc/include/asm/Kbuild
+++ b/arch/sparc/include/asm/Kbuild
@@ -16,3 +16,4 @@ generic-y += serial.h
 generic-y += trace_clock.h
 generic-y += types.h
 generic-y += word-at-a-time.h
+generic-y += preempt.h
diff --git a/arch/tile/include/asm/Kbuild b/arch/tile/include/asm/Kbuild
index 664d6ad..22f3bd1 100644
--- a/arch/tile/include/asm/Kbuild
+++ b/arch/tile/include/asm/Kbuild
@@ -38,3 +38,4 @@ generic-y += termios.h
 generic-y += trace_clock.h
 generic-y += types.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/um/include/asm/Kbuild b/arch/um/include/asm/Kbuild
index b30f34a..fdde187 100644
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -3,3 +3,4 @@ generic-y += hw_irq.h irq_regs.h kdebug.h percpu.h sections.h topology.h xor.h
 generic-y += ftrace.h pci.h io.h param.h delay.h mutex.h current.h exec.h
 generic-y += switch_to.h clkdev.h
 generic-y += trace_clock.h
+generic-y += preempt.h
diff --git a/arch/unicore32/include/asm/Kbuild b/arch/unicore32/include/asm/Kbuild
index 89d8b6c..00045cb 100644
--- a/arch/unicore32/include/asm/Kbuild
+++ b/arch/unicore32/include/asm/Kbuild
@@ -60,3 +60,4 @@ generic-y += unaligned.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index 7f66985..eca2028 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -5,3 +5,4 @@ genhdr-y += unistd_64.h
 genhdr-y += unistd_x32.h
 
 generic-y += clkdev.h
+generic-y += preempt.h
diff --git a/arch/xtensa/include/asm/Kbuild b/arch/xtensa/include/asm/Kbuild
index 1b98264..228d6ae 100644
--- a/arch/xtensa/include/asm/Kbuild
+++ b/arch/xtensa/include/asm/Kbuild
@@ -28,3 +28,4 @@ generic-y += termios.h
 generic-y += topology.h
 generic-y += trace_clock.h
 generic-y += xor.h
+generic-y += preempt.h
diff --git a/include/asm-generic/preempt.h b/include/asm-generic/preempt.h
new file mode 100644
index 0000000..a1fc659
--- /dev/null
+++ b/include/asm-generic/preempt.h
@@ -0,0 +1,54 @@
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
+/*
+ * We now loose PREEMPT_NEED_RESCHED and cause an extra reschedule; however the
+ * alternative is loosing a reschedule. Better schedule too often -- also this
+ * should be a very rare operation.
+ */
+static __always_inline void preempt_count_set(int pc)
+{
+	*preempt_count_ptr() = pc;
+}
+
+/*
+ * We fold the NEED_RESCHED bit into the preempt count such that
+ * preempt_enable() can decrement and test for needing to reschedule with a
+ * single instruction.
+ *
+ * We invert the actual bit, so that when the decrement hits 0 we know we both
+ * need to resched (the bit is cleared) and can resched (no preempt count).
+ */
+
+static __always_inline void set_preempt_need_resched(void)
+{
+	*preempt_count_ptr() &= ~PREEMPT_NEED_RESCHED;
+}
+
+static __always_inline void clear_preempt_need_resched(void)
+{
+	*preempt_count_ptr() |= PREEMPT_NEED_RESCHED;
+}
+
+static __always_inline bool test_preempt_need_resched(void)
+{
+	return !(*preempt_count_ptr() & PREEMPT_NEED_RESCHED);
+}
+
+#endif /* __ASM_PREEMPT_H */
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 92e3418..df8e245 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -6,7 +6,6 @@
  * preempt_count (used for kernel preemption, interrupt count, etc.)
  */
 
-#include <linux/thread_info.h>
 #include <linux/linkage.h>
 #include <linux/list.h>
 
@@ -16,53 +15,7 @@
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
-
-/*
- * We now loose PREEMPT_NEED_RESCHED and cause an extra reschedule; however the
- * alternative is loosing a reschedule. Better schedule too often -- also this
- * should be a very rare operation.
- */
-static __always_inline void preempt_count_set(int pc)
-{
-	*preempt_count_ptr() = pc;
-}
-
-/*
- * We fold the NEED_RESCHED bit into the preempt count such that
- * preempt_enable() can decrement and test for needing to reschedule with a
- * single instruction.
- *
- * We invert the actual bit, so that when the decrement hits 0 we know we both
- * need to resched (the bit is cleared) and can resched (no preempt count).
- */
-
-static __always_inline void set_preempt_need_resched(void)
-{
-	*preempt_count_ptr() &= ~PREEMPT_NEED_RESCHED;
-}
-
-static __always_inline void clear_preempt_need_resched(void)
-{
-	*preempt_count_ptr() |= PREEMPT_NEED_RESCHED;
-}
-
-static __always_inline bool test_preempt_need_resched(void)
-{
-	return !(*preempt_count_ptr() & PREEMPT_NEED_RESCHED);
-}
+#include <asm/preempt.h>
 
 #if defined(CONFIG_DEBUG_PREEMPT) || defined(CONFIG_PREEMPT_TRACER)
   extern void add_preempt_count(int val);
