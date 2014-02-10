Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaBJNfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:35:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33398 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbaBJNeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:34:08 -0500
Date: Mon, 10 Feb 2014 05:32:46 -0800
From: tip-bot for Tim Chen <tipbot@zytor.com>
Message-ID: <tip-ddf1d169c0a489d498c1799a7043904a43b0c159@git.kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, dave.hansen@intel.com,
        peterz@infradead.org, peter@hurleysoftware.com, arnd@arndb.de,
        alex.shi@linaro.org, riel@redhat.com, akpm@linux-foundation.org,
        figo1802@gmail.com, matthew.r.wilcox@intel.com, aarcange@redhat.com,
        tglx@linutronix.de, scott.norton@hp.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, davidlohr.bueso@hp.com, andi@firstfloor.org,
        will.deacon@arm.com, waiman.long@hp.com, tim.c.chen@linux.intel.com,
        paulmck@linux.vnet.ibm.com, raghavendra.kt@linux.vnet.ibm.com,
        linux@horizon.com, walken@google.com, mingo@elte.hu, aswin@hp.com
Reply-To: mingo@kernel.org, dave.hansen@intel.com,
        torvalds@linux-foundation.org, peterz@infradead.org,
        peter@hurleysoftware.com, arnd@arndb.de, alex.shi@linaro.org,
        riel@redhat.com, figo1802@gmail.com, akpm@linux-foundation.org,
        aarcange@redhat.com, matthew.r.wilcox@intel.com, tglx@linutronix.de,
        scott.norton@hp.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        andi@firstfloor.org, davidlohr.bueso@hp.com, waiman.long@hp.com,
        will.deacon@arm.com, tim.c.chen@linux.intel.com,
        paulmck@linux.vnet.ibm.com, raghavendra.kt@linux.vnet.ibm.com,
        linux@horizon.com, walken@google.com, aswin@hp.com, mingo@elte.hu
In-Reply-To: <1390347382.3138.67.camel@schen9-DESK>
References: <1390347382.3138.67.camel@schen9-DESK>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking/mcs:
  Allow architecture specific asm files to be used for contended case
Git-Commit-ID: ddf1d169c0a489d498c1799a7043904a43b0c159
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 10 Feb 2014 05:32:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ddf1d169c0a489d498c1799a7043904a43b0c159
Gitweb:     http://git.kernel.org/tip/ddf1d169c0a489d498c1799a7043904a43b0c159
Author:     Tim Chen <tim.c.chen@linux.intel.com>
AuthorDate: Tue, 21 Jan 2014 15:36:22 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 9 Feb 2014 21:18:52 +0100

locking/mcs: Allow architecture specific asm files to be used for contended case

This patch allows each architecture to add its specific assembly optimized
arch_mcs_spin_lock_contended and arch_mcs_spinlock_uncontended for
MCS lock and unlock functions.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Scott J Norton <scott.norton@hp.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: AswinChandramouleeswaran <aswin@hp.com>
Cc: George Spelvin <linux@horizon.com>
Cc: Rik vanRiel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: MichelLespinasse <walken@google.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Alex Shi <alex.shi@linaro.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Figo.zhang" <figo1802@gmail.com>
Cc: "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Waiman Long <waiman.long@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew R Wilcox <matthew.r.wilcox@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1390347382.3138.67.camel@schen9-DESK
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
 include/asm-generic/mcs_spinlock.h | 13 +++++++++++++
 include/linux/mcs_spinlock.h       |  2 ++
 31 files changed, 44 insertions(+)

diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
index 55a2b039..7736f42 100644
--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -3,5 +3,6 @@
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += hash.h
+generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += trace_clock.h
diff --git a/arch/arc/include/asm/Kbuild b/arch/arc/include/asm/Kbuild
index 54ceb91..e76fd79 100644
--- a/arch/arc/include/asm/Kbuild
+++ b/arch/arc/include/asm/Kbuild
@@ -22,6 +22,7 @@ generic-y += kmap_types.h
 generic-y += kvm_para.h
 generic-y += local.h
 generic-y += local64.h
+generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += msgbuf.h
 generic-y += param.h
diff --git a/arch/arm/include/asm/Kbuild b/arch/arm/include/asm/Kbuild
index 3b20920..23e728e 100644
--- a/arch/arm/include/asm/Kbuild
+++ b/arch/arm/include/asm/Kbuild
@@ -14,6 +14,7 @@ generic-y += irq_regs.h
 generic-y += kdebug.h
 generic-y += local.h
 generic-y += local64.h
+generic-y += mcs_spinlock.h
 generic-y += msgbuf.h
 generic-y += param.h
 generic-y += parport.h
diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index 54038be..3bdfdda 100644
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -23,6 +23,7 @@ generic-y += kmap_types.h
 generic-y += kvm_para.h
 generic-y += local.h
 generic-y += local64.h
+generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += msgbuf.h
 generic-y += mutex.h
diff --git a/arch/avr32/include/asm/Kbuild b/arch/avr32/include/asm/Kbuild
index 064ca3c..8b398ff 100644
--- a/arch/avr32/include/asm/Kbuild
+++ b/arch/avr32/include/asm/Kbuild
@@ -11,6 +11,7 @@ generic-y += hash.h
 generic-y += irq_regs.h
 generic-y += local.h
 generic-y += local64.h
+generic-y += mcs_spinlock.h
 generic-y += param.h
 generic-y += percpu.h
 generic-y += preempt.h
diff --git a/arch/blackfin/include/asm/Kbuild b/arch/blackfin/include/asm/Kbuild
index ca30a3d..0d93b9a 100644
--- a/arch/blackfin/include/asm/Kbuild
+++ b/arch/blackfin/include/asm/Kbuild
@@ -20,6 +20,7 @@ generic-y += kmap_types.h
 generic-y += kvm_para.h
 generic-y += local.h
 generic-y += local64.h
+generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += msgbuf.h
 generic-y += mutex.h
diff --git a/arch/c6x/include/asm/Kbuild b/arch/c6x/include/asm/Kbuild
index dea0671..8dbdce8 100644
--- a/arch/c6x/include/asm/Kbuild
+++ b/arch/c6x/include/asm/Kbuild
@@ -25,6 +25,7 @@ generic-y += irq_regs.h
 generic-y += kdebug.h
 generic-y += kmap_types.h
 generic-y += local.h
+generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += mmu.h
 generic-y += mmu_context.h
diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index 7f8d1b1..056027f 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -9,6 +9,7 @@ generic-y += exec.h
 generic-y += hash.h
 generic-y += kvm_para.h
 generic-y += linkage.h
+generic-y += mcs_spinlock.h
 generic-y += module.h
 generic-y += preempt.h
 generic-y += trace_clock.h
diff --git a/arch/frv/include/asm/Kbuild b/arch/frv/include/asm/Kbuild
index 93428d0..babb933 100644
--- a/arch/frv/include/asm/Kbuild
+++ b/arch/frv/include/asm/Kbuild
@@ -2,5 +2,6 @@
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += hash.h
+generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += trace_clock.h
diff --git a/arch/hexagon/include/asm/Kbuild b/arch/hexagon/include/asm/Kbuild
index 9f0eda4..eadcc11 100644
--- a/arch/hexagon/include/asm/Kbuild
+++ b/arch/hexagon/include/asm/Kbuild
@@ -27,6 +27,7 @@ generic-y += kdebug.h
 generic-y += kmap_types.h
 generic-y += local.h
 generic-y += local64.h
+generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += msgbuf.h
 generic-y += pci.h
diff --git a/arch/ia64/include/asm/Kbuild b/arch/ia64/include/asm/Kbuild
index 81ebef7..0da4aa2 100644
--- a/arch/ia64/include/asm/Kbuild
+++ b/arch/ia64/include/asm/Kbuild
@@ -3,6 +3,7 @@ generic-y += clkdev.h
 generic-y += exec.h
 generic-y += hash.h
 generic-y += kvm_para.h
+generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += trace_clock.h
 generic-y += vtime.h
diff --git a/arch/m32r/include/asm/Kbuild b/arch/m32r/include/asm/Kbuild
index 8704221..5825a35 100644
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@ -2,6 +2,7 @@
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += hash.h
+generic-y += mcs_spinlock.h
 generic-y += module.h
 generic-y += preempt.h
 generic-y += trace_clock.h
diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
index f44ac8f..86b4c17 100644
--- a/arch/m68k/include/asm/Kbuild
+++ b/arch/m68k/include/asm/Kbuild
@@ -16,6 +16,7 @@ generic-y += kmap_types.h
 generic-y += kvm_para.h
 generic-y += local.h
 generic-y += local64.h
+generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += mutex.h
 generic-y += percpu.h
diff --git a/arch/metag/include/asm/Kbuild b/arch/metag/include/asm/Kbuild
index ac22144..c29ead8 100644
--- a/arch/metag/include/asm/Kbuild
+++ b/arch/metag/include/asm/Kbuild
@@ -24,6 +24,7 @@ generic-y += kmap_types.h
 generic-y += kvm_para.h
 generic-y += local.h
 generic-y += local64.h
+generic-y += mcs_spinlock.h
 generic-y += msgbuf.h
 generic-y += mutex.h
 generic-y += param.h
diff --git a/arch/microblaze/include/asm/Kbuild b/arch/microblaze/include/asm/Kbuild
index 4b5f122..1f590ab 100644
--- a/arch/microblaze/include/asm/Kbuild
+++ b/arch/microblaze/include/asm/Kbuild
@@ -3,6 +3,7 @@ generic-y += barrier.h
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += hash.h
+generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += syscalls.h
 generic-y += trace_clock.h
diff --git a/arch/mips/include/asm/Kbuild b/arch/mips/include/asm/Kbuild
index 82ee17a..0543918 100644
--- a/arch/mips/include/asm/Kbuild
+++ b/arch/mips/include/asm/Kbuild
@@ -4,6 +4,7 @@ generic-y += current.h
 generic-y += emergency-restart.h
 generic-y += hash.h
 generic-y += local64.h
+generic-y += mcs_spinlock.h
 generic-y += mutex.h
 generic-y += parport.h
 generic-y += percpu.h
diff --git a/arch/mn10300/include/asm/Kbuild b/arch/mn10300/include/asm/Kbuild
index da3b2f5..cbc6b9b 100644
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@ -3,5 +3,6 @@ generic-y += barrier.h
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += hash.h
+generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += trace_clock.h
diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/Kbuild
index f62a67a..480af0d 100644
--- a/arch/openrisc/include/asm/Kbuild
+++ b/arch/openrisc/include/asm/Kbuild
@@ -35,6 +35,7 @@ generic-y += kdebug.h
 generic-y += kmap_types.h
 generic-y += kvm_para.h
 generic-y += local.h
+generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += module.h
 generic-y += msgbuf.h
diff --git a/arch/parisc/include/asm/Kbuild b/arch/parisc/include/asm/Kbuild
index 958b79a..ecf25e6 100644
--- a/arch/parisc/include/asm/Kbuild
+++ b/arch/parisc/include/asm/Kbuild
@@ -14,6 +14,7 @@ generic-y += kdebug.h
 generic-y += kvm_para.h
 generic-y += local.h
 generic-y += local64.h
+generic-y += mcs_spinlock.h
 generic-y += mutex.h
 generic-y += param.h
 generic-y += percpu.h
diff --git a/arch/powerpc/include/asm/Kbuild b/arch/powerpc/include/asm/Kbuild
index b618c41..3fb1bc4 100644
--- a/arch/powerpc/include/asm/Kbuild
+++ b/arch/powerpc/include/asm/Kbuild
@@ -1,6 +1,7 @@
 
 generic-y += clkdev.h
 generic-y += hash.h
+generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += rwsem.h
 generic-y += trace_clock.h
diff --git a/arch/s390/include/asm/Kbuild b/arch/s390/include/asm/Kbuild
index 482f492..57892a8 100644
--- a/arch/s390/include/asm/Kbuild
+++ b/arch/s390/include/asm/Kbuild
@@ -2,5 +2,6 @@
 
 generic-y += clkdev.h
 generic-y += hash.h
+generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += trace_clock.h
diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
index e92319f..4630cf2 100644
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -5,6 +5,7 @@ header-y +=
 generic-y += barrier.h
 generic-y += clkdev.h
 generic-y += hash.h
+generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += trace_clock.h
 generic-y += xor.h
diff --git a/arch/sh/include/asm/Kbuild b/arch/sh/include/asm/Kbuild
index 85c214e..c19e47d 100644
--- a/arch/sh/include/asm/Kbuild
+++ b/arch/sh/include/asm/Kbuild
@@ -15,6 +15,7 @@ generic-y += irq_regs.h
 generic-y += kvm_para.h
 generic-y += local.h
 generic-y += local64.h
+generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += msgbuf.h
 generic-y += param.h
diff --git a/arch/sparc/include/asm/Kbuild b/arch/sparc/include/asm/Kbuild
index 8215028..a458218 100644
--- a/arch/sparc/include/asm/Kbuild
+++ b/arch/sparc/include/asm/Kbuild
@@ -11,6 +11,7 @@ generic-y += irq_regs.h
 generic-y += linkage.h
 generic-y += local.h
 generic-y += local64.h
+generic-y += mcs_spinlock.h
 generic-y += module.h
 generic-y += mutex.h
 generic-y += preempt.h
diff --git a/arch/tile/include/asm/Kbuild b/arch/tile/include/asm/Kbuild
index e0b1ed9..0aa5675 100644
--- a/arch/tile/include/asm/Kbuild
+++ b/arch/tile/include/asm/Kbuild
@@ -19,6 +19,7 @@ generic-y += ipcbuf.h
 generic-y += irq_regs.h
 generic-y += local.h
 generic-y += local64.h
+generic-y += mcs_spinlock.h
 generic-y += msgbuf.h
 generic-y += mutex.h
 generic-y += param.h
diff --git a/arch/um/include/asm/Kbuild b/arch/um/include/asm/Kbuild
index 215e05d..a5e4b60 100644
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -15,6 +15,7 @@ generic-y += hw_irq.h
 generic-y += io.h
 generic-y += irq_regs.h
 generic-y += kdebug.h
+generic-y += mcs_spinlock.h
 generic-y += mutex.h
 generic-y += param.h
 generic-y += pci.h
diff --git a/arch/unicore32/include/asm/Kbuild b/arch/unicore32/include/asm/Kbuild
index ad2c737..1e5fb87 100644
--- a/arch/unicore32/include/asm/Kbuild
+++ b/arch/unicore32/include/asm/Kbuild
@@ -25,6 +25,7 @@ generic-y += irq_regs.h
 generic-y += kdebug.h
 generic-y += kmap_types.h
 generic-y += local.h
+generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += module.h
 generic-y += msgbuf.h
diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index 7f66985..a8fee07 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -5,3 +5,4 @@ genhdr-y += unistd_64.h
 genhdr-y += unistd_x32.h
 
 generic-y += clkdev.h
+generic-y += mcs_spinlock.h
diff --git a/arch/xtensa/include/asm/Kbuild b/arch/xtensa/include/asm/Kbuild
index 223280d..c3d20ba 100644
--- a/arch/xtensa/include/asm/Kbuild
+++ b/arch/xtensa/include/asm/Kbuild
@@ -18,6 +18,7 @@ generic-y += kvm_para.h
 generic-y += linkage.h
 generic-y += local.h
 generic-y += local64.h
+generic-y += mcs_spinlock.h
 generic-y += percpu.h
 generic-y += preempt.h
 generic-y += resource.h
diff --git a/include/asm-generic/mcs_spinlock.h b/include/asm-generic/mcs_spinlock.h
new file mode 100644
index 0000000..10cd4ff
--- /dev/null
+++ b/include/asm-generic/mcs_spinlock.h
@@ -0,0 +1,13 @@
+#ifndef __ASM_MCS_SPINLOCK_H
+#define __ASM_MCS_SPINLOCK_H
+
+/*
+ * Architectures can define their own:
+ *
+ *   arch_mcs_spin_lock_contended(l)
+ *   arch_mcs_spin_unlock_contended(l)
+ *
+ * See kernel/locking/mcs_spinlock.c.
+ */
+
+#endif /* __ASM_MCS_SPINLOCK_H */
diff --git a/include/linux/mcs_spinlock.h b/include/linux/mcs_spinlock.h
index e9a4d74..f2a5c63 100644
--- a/include/linux/mcs_spinlock.h
+++ b/include/linux/mcs_spinlock.h
@@ -12,6 +12,8 @@
 #ifndef __LINUX_MCS_SPINLOCK_H
 #define __LINUX_MCS_SPINLOCK_H
 
+#include <asm/mcs_spinlock.h>
+
 struct mcs_spinlock {
 	struct mcs_spinlock *next;
 	int locked; /* 1 if lock acquired */
