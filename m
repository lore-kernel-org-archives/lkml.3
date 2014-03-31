Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbaCaINa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 04:13:30 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:59863 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbaCaINW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 04:13:22 -0400
Date: Mon, 31 Mar 2014 10:13:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] locking changes for v3.15
Message-ID: <20140331081317.GA3053@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-locking-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-locking-for-linus

   # HEAD: 6f008e72cd111a119b5d8de8c5438d892aae99eb locking/mutex: Fix debug checks

The biggest change is the MCS spinlock generalization changes from Tim 
Chen, Peter Zijlstra, Jason Low et al. There's also lockdep 
fixes/enhancements from Oleg Nesterov, in particular a false negative 
fix related to lockdep_set_novalidate_class() usage.

 Thanks,

	Ingo

------------------>
Aaron Tomlin (1):
      hung_task/Documentation: Fix hung_task_warnings description

Finn Thain (1):
      m68k: Skip futex_atomic_cmpxchg_inatomic() test

Heiko Carstens (1):
      futex: Allow architectures to skip futex_atomic_cmpxchg_inatomic() test

Ingo Molnar (1):
      Revert "sched/wait: Suppress Sparse 'variable shadowing' warning"

Jason Low (4):
      locking/mcs: Micro-optimize the MCS code, add extra comments
      locking/mutexes: Return false if task need_resched() in mutex_can_spin_on_owner()
      locking/mutexes: Modify the way optimistic spinners are queued
      locking/mutexes: Unlock the mutex without the wait_lock

Johannes Berg (1):
      sched/wait: Suppress Sparse 'variable shadowing' warning

Oleg Nesterov (4):
      lockdep: Make held_lock->check and "int check" argument bool
      lockdep: Don't create the wrong dependency on hlock->check == 0
      lockdep: Change mark_held_locks() to check hlock->check instead of lockdep_no_validate
      lockdep: Change lockdep_set_novalidate_class() to use _and_name

Peter Zijlstra (4):
      locking: Move mcs_spinlock.h into kernel/locking/
      locking/mutexes: Introduce cancelable MCS lock for adaptive spinning
      locking/mutexes: Add extra reschedule point
      locking/mutex: Fix debug checks

Tim Chen (3):
      locking/mutexes/mcs: Restructure the MCS lock defines and locking code into its own file
      locking/mcs: Order the header files in Kbuild of each architecture in alphabetical order
      locking/mcs: Allow architecture specific asm files to be used for contended case

Waiman Long (1):
      locking/mutexes/mcs: Correct barrier usage

Will Deacon (1):
      locking/mcs: Allow architectures to hook in to contended paths


 Documentation/sysctl/kernel.txt    |   5 +-
 arch/alpha/include/asm/Kbuild      |   7 +-
 arch/arc/include/asm/Kbuild        |   7 +-
 arch/arm/include/asm/Kbuild        |   5 +-
 arch/arm64/include/asm/Kbuild      |   7 +-
 arch/avr32/include/asm/Kbuild      |  41 ++++-----
 arch/blackfin/include/asm/Kbuild   |   7 +-
 arch/c6x/include/asm/Kbuild        |   5 +-
 arch/cris/include/asm/Kbuild       |   3 +-
 arch/frv/include/asm/Kbuild        |   5 +-
 arch/hexagon/include/asm/Kbuild    |   7 +-
 arch/ia64/include/asm/Kbuild       |   5 +-
 arch/m32r/include/asm/Kbuild       |   5 +-
 arch/m68k/Kconfig                  |   1 +
 arch/m68k/include/asm/Kbuild       |   7 +-
 arch/metag/include/asm/Kbuild      |   5 +-
 arch/microblaze/include/asm/Kbuild |   5 +-
 arch/mips/include/asm/Kbuild       |   5 +-
 arch/mn10300/include/asm/Kbuild    |   3 +-
 arch/openrisc/include/asm/Kbuild   |  11 +--
 arch/parisc/include/asm/Kbuild     |  32 +++++--
 arch/powerpc/include/asm/Kbuild    |   5 +-
 arch/s390/Kconfig                  |   1 +
 arch/s390/include/asm/Kbuild       |   5 +-
 arch/score/include/asm/Kbuild      |   5 +-
 arch/sh/include/asm/Kbuild         |   9 +-
 arch/sparc/include/asm/Kbuild      |  11 +--
 arch/tile/include/asm/Kbuild       |   5 +-
 arch/um/include/asm/Kbuild         |  34 +++++--
 arch/unicore32/include/asm/Kbuild  |   5 +-
 arch/x86/include/asm/Kbuild        |   1 +
 arch/xtensa/include/asm/Kbuild     |   5 +-
 drivers/tty/tty_ldsem.c            |  15 +---
 include/asm-generic/mcs_spinlock.h |  13 +++
 include/linux/futex.h              |   4 +
 include/linux/lockdep.h            |  27 +++---
 include/linux/mutex.h              |   5 +-
 include/linux/rcupdate.h           |   2 +-
 init/Kconfig                       |   7 ++
 kernel/futex.c                     |  37 +++++---
 kernel/locking/Makefile            |   2 +-
 kernel/locking/lockdep.c           |  17 ++--
 kernel/locking/mcs_spinlock.c      | 178 +++++++++++++++++++++++++++++++++++++
 kernel/locking/mcs_spinlock.h      | 129 +++++++++++++++++++++++++++
 kernel/locking/mutex-debug.c       |   6 ++
 kernel/locking/mutex.c             |  94 +++++++-------------
 46 files changed, 586 insertions(+), 214 deletions(-)
 create mode 100644 include/asm-generic/mcs_spinlock.h
 create mode 100644 kernel/locking/mcs_spinlock.c
 create mode 100644 kernel/locking/mcs_spinlock.h

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index e55124e..e1d28fb 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -320,10 +320,11 @@ This file shows up if CONFIG_DETECT_HUNG_TASK is enabled.
 
 ==============================================================
 
-hung_task_warning:
+hung_task_warnings:
 
 The maximum number of warnings to report. During a check interval
-When this value is reached, no more the warnings will be reported.
+if a hung task is detected, this value is decreased by 1.
+When this value reaches 0, no more warnings will be reported.
 This file shows up if CONFIG_DETECT_HUNG_TASK is enabled.
 
 -1: report an infinite number of warnings.
diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
index a73a8e2..7736f42 100644
--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -1,7 +1,8 @@
 
-generic-y += clkdev.h
 
+generic-y += clkdev.h
 generic-y += exec.h
-generic-y += trace_clock.h
-generic-y += preempt.h
 generic-y += hash.h
+generic-y += mcs_spinlock.h
+generic-y += preempt.h
+generic-y += trace_clock.h
diff --git a/arch/arc/include/asm/Kbuild b/arch/arc/include/asm/Kbuild
index 0d33629..e76fd79 100644
--- a/arch/arc/include/asm/Kbuild
+++ b/arch/arc/include/asm/Kbuild
@@ -1,15 +1,15 @@
 generic-y += auxvec.h
 generic-y += barrier.h
-generic-y += bugs.h
 generic-y += bitsperlong.h
+generic-y += bugs.h
 generic-y += clkdev.h
 generic-y += cputime.h
 generic-y += device.h
 generic-y += div64.h
 generic-y += emergency-restart.h
 generic-y += errno.h
-generic-y += fcntl.h
 generic-y += fb.h
+generic-y += fcntl.h
 generic-y += ftrace.h
 generic-y += hardirq.h
 generic-y += hash.h
@@ -22,6 +22,7 @@ generic-y += kmap_types.h
 generic-y += kvm_para.h
 generic-y += local.h
 generic-y += local64.h
+generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += msgbuf.h
 generic-y += param.h
@@ -30,6 +31,7 @@ generic-y += pci.h
 generic-y += percpu.h
 generic-y += poll.h
 generic-y += posix_types.h
+generic-y += preempt.h
 generic-y += resource.h
 generic-y += scatterlist.h
 generic-y += sembuf.h
@@ -48,4 +50,3 @@ generic-y += ucontext.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
-generic-y += preempt.h
diff --git a/arch/arm/include/asm/Kbuild b/arch/arm/include/asm/Kbuild
index 3278afe..23e728e 100644
--- a/arch/arm/include/asm/Kbuild
+++ b/arch/arm/include/asm/Kbuild
@@ -7,16 +7,19 @@ generic-y += current.h
 generic-y += emergency-restart.h
 generic-y += errno.h
 generic-y += exec.h
+generic-y += hash.h
 generic-y += ioctl.h
 generic-y += ipcbuf.h
 generic-y += irq_regs.h
 generic-y += kdebug.h
 generic-y += local.h
 generic-y += local64.h
+generic-y += mcs_spinlock.h
 generic-y += msgbuf.h
 generic-y += param.h
 generic-y += parport.h
 generic-y += poll.h
+generic-y += preempt.h
 generic-y += resource.h
 generic-y += sections.h
 generic-y += segment.h
@@ -33,5 +36,3 @@ generic-y += termios.h
 generic-y += timex.h
 generic-y += trace_clock.h
 generic-y += unaligned.h
-generic-y += preempt.h
-generic-y += hash.h
diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index 71c53ec..3bdfdda 100644
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -12,6 +12,7 @@ generic-y += dma.h
 generic-y += emergency-restart.h
 generic-y += errno.h
 generic-y += ftrace.h
+generic-y += hash.h
 generic-y += hw_irq.h
 generic-y += ioctl.h
 generic-y += ioctls.h
@@ -22,12 +23,14 @@ generic-y += kmap_types.h
 generic-y += kvm_para.h
 generic-y += local.h
 generic-y += local64.h
+generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += msgbuf.h
 generic-y += mutex.h
 generic-y += pci.h
 generic-y += poll.h
 generic-y += posix_types.h
+generic-y += preempt.h
 generic-y += resource.h
 generic-y += scatterlist.h
 generic-y += sections.h
@@ -38,8 +41,8 @@ generic-y += shmbuf.h
 generic-y += sizes.h
 generic-y += socket.h
 generic-y += sockios.h
-generic-y += switch_to.h
 generic-y += swab.h
+generic-y += switch_to.h
 generic-y += termbits.h
 generic-y += termios.h
 generic-y += topology.h
@@ -49,5 +52,3 @@ generic-y += unaligned.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
-generic-y += preempt.h
-generic-y += hash.h
diff --git a/arch/avr32/include/asm/Kbuild b/arch/avr32/include/asm/Kbuild
index cfb9fe1..8b398ff 100644
--- a/arch/avr32/include/asm/Kbuild
+++ b/arch/avr32/include/asm/Kbuild
@@ -1,21 +1,22 @@
 
-generic-y	+= clkdev.h
-generic-y       += cputime.h
-generic-y       += delay.h
-generic-y       += device.h
-generic-y       += div64.h
-generic-y       += emergency-restart.h
-generic-y	+= exec.h
-generic-y       += futex.h
-generic-y	+= preempt.h
-generic-y       += irq_regs.h
-generic-y	+= param.h
-generic-y       += local.h
-generic-y       += local64.h
-generic-y       += percpu.h
-generic-y       += scatterlist.h
-generic-y       += sections.h
-generic-y       += topology.h
-generic-y	+= trace_clock.h
-generic-y       += xor.h
-generic-y	+= hash.h
+generic-y += clkdev.h
+generic-y += cputime.h
+generic-y += delay.h
+generic-y += device.h
+generic-y += div64.h
+generic-y += emergency-restart.h
+generic-y += exec.h
+generic-y += futex.h
+generic-y += hash.h
+generic-y += irq_regs.h
+generic-y += local.h
+generic-y += local64.h
+generic-y += mcs_spinlock.h
+generic-y += param.h
+generic-y += percpu.h
+generic-y += preempt.h
+generic-y += scatterlist.h
+generic-y += sections.h
+generic-y += topology.h
+generic-y += trace_clock.h
+generic-y += xor.h
diff --git a/arch/blackfin/include/asm/Kbuild b/arch/blackfin/include/asm/Kbuild
index 359d36f..0d93b9a 100644
--- a/arch/blackfin/include/asm/Kbuild
+++ b/arch/blackfin/include/asm/Kbuild
@@ -10,6 +10,7 @@ generic-y += emergency-restart.h
 generic-y += errno.h
 generic-y += fb.h
 generic-y += futex.h
+generic-y += hash.h
 generic-y += hw_irq.h
 generic-y += ioctl.h
 generic-y += ipcbuf.h
@@ -17,14 +18,16 @@ generic-y += irq_regs.h
 generic-y += kdebug.h
 generic-y += kmap_types.h
 generic-y += kvm_para.h
-generic-y += local64.h
 generic-y += local.h
+generic-y += local64.h
+generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += msgbuf.h
 generic-y += mutex.h
 generic-y += param.h
 generic-y += percpu.h
 generic-y += pgalloc.h
+generic-y += preempt.h
 generic-y += resource.h
 generic-y += scatterlist.h
 generic-y += sembuf.h
@@ -44,5 +47,3 @@ generic-y += ucontext.h
 generic-y += unaligned.h
 generic-y += user.h
 generic-y += xor.h
-generic-y += preempt.h
-generic-y += hash.h
diff --git a/arch/c6x/include/asm/Kbuild b/arch/c6x/include/asm/Kbuild
index d73bb85..8dbdce8 100644
--- a/arch/c6x/include/asm/Kbuild
+++ b/arch/c6x/include/asm/Kbuild
@@ -15,6 +15,7 @@ generic-y += exec.h
 generic-y += fb.h
 generic-y += fcntl.h
 generic-y += futex.h
+generic-y += hash.h
 generic-y += hw_irq.h
 generic-y += io.h
 generic-y += ioctl.h
@@ -24,6 +25,7 @@ generic-y += irq_regs.h
 generic-y += kdebug.h
 generic-y += kmap_types.h
 generic-y += local.h
+generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += mmu.h
 generic-y += mmu_context.h
@@ -34,6 +36,7 @@ generic-y += percpu.h
 generic-y += pgalloc.h
 generic-y += poll.h
 generic-y += posix_types.h
+generic-y += preempt.h
 generic-y += resource.h
 generic-y += scatterlist.h
 generic-y += segment.h
@@ -56,5 +59,3 @@ generic-y += ucontext.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
-generic-y += preempt.h
-generic-y += hash.h
diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index f3fd876..056027f 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -9,8 +9,9 @@ generic-y += exec.h
 generic-y += hash.h
 generic-y += kvm_para.h
 generic-y += linkage.h
+generic-y += mcs_spinlock.h
 generic-y += module.h
+generic-y += preempt.h
 generic-y += trace_clock.h
 generic-y += vga.h
 generic-y += xor.h
-generic-y += preempt.h
diff --git a/arch/frv/include/asm/Kbuild b/arch/frv/include/asm/Kbuild
index bc42f14..babb933 100644
--- a/arch/frv/include/asm/Kbuild
+++ b/arch/frv/include/asm/Kbuild
@@ -1,6 +1,7 @@
 
 generic-y += clkdev.h
 generic-y += exec.h
-generic-y += trace_clock.h
-generic-y += preempt.h
 generic-y += hash.h
+generic-y += mcs_spinlock.h
+generic-y += preempt.h
+generic-y += trace_clock.h
diff --git a/arch/hexagon/include/asm/Kbuild b/arch/hexagon/include/asm/Kbuild
index 38ca45d..eadcc11 100644
--- a/arch/hexagon/include/asm/Kbuild
+++ b/arch/hexagon/include/asm/Kbuild
@@ -25,14 +25,16 @@ generic-y += ipcbuf.h
 generic-y += irq_regs.h
 generic-y += kdebug.h
 generic-y += kmap_types.h
-generic-y += local64.h
 generic-y += local.h
+generic-y += local64.h
+generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += msgbuf.h
 generic-y += pci.h
 generic-y += percpu.h
 generic-y += poll.h
 generic-y += posix_types.h
+generic-y += preempt.h
 generic-y += resource.h
 generic-y += rwsem.h
 generic-y += scatterlist.h
@@ -45,8 +47,8 @@ generic-y += siginfo.h
 generic-y += sizes.h
 generic-y += socket.h
 generic-y += sockios.h
-generic-y += statfs.h
 generic-y += stat.h
+generic-y += statfs.h
 generic-y += termbits.h
 generic-y += termios.h
 generic-y += topology.h
@@ -55,4 +57,3 @@ generic-y += types.h
 generic-y += ucontext.h
 generic-y += unaligned.h
 generic-y += xor.h
-generic-y += preempt.h
diff --git a/arch/ia64/include/asm/Kbuild b/arch/ia64/include/asm/Kbuild
index 283a831..0da4aa2 100644
--- a/arch/ia64/include/asm/Kbuild
+++ b/arch/ia64/include/asm/Kbuild
@@ -1,8 +1,9 @@
 
 generic-y += clkdev.h
 generic-y += exec.h
+generic-y += hash.h
 generic-y += kvm_para.h
-generic-y += trace_clock.h
+generic-y += mcs_spinlock.h
 generic-y += preempt.h
+generic-y += trace_clock.h
 generic-y += vtime.h
-generic-y += hash.h
diff --git a/arch/m32r/include/asm/Kbuild b/arch/m32r/include/asm/Kbuild
index 932435a..5825a35 100644
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@ -1,7 +1,8 @@
 
 generic-y += clkdev.h
 generic-y += exec.h
+generic-y += hash.h
+generic-y += mcs_spinlock.h
 generic-y += module.h
-generic-y += trace_clock.h
 generic-y += preempt.h
-generic-y += hash.h
+generic-y += trace_clock.h
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index dbdd223..b2e3229 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -17,6 +17,7 @@ config M68K
 	select FPU if MMU
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_USES_GETTIMEOFFSET if MMU && !COLDFIRE
+	select HAVE_FUTEX_CMPXCHG if MMU && FUTEX
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_REL
 	select MODULES_USE_ELF_RELA
diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
index 7cc8c36..86b4c17 100644
--- a/arch/m68k/include/asm/Kbuild
+++ b/arch/m68k/include/asm/Kbuild
@@ -6,6 +6,7 @@ generic-y += device.h
 generic-y += emergency-restart.h
 generic-y += errno.h
 generic-y += exec.h
+generic-y += hash.h
 generic-y += hw_irq.h
 generic-y += ioctl.h
 generic-y += ipcbuf.h
@@ -13,11 +14,13 @@ generic-y += irq_regs.h
 generic-y += kdebug.h
 generic-y += kmap_types.h
 generic-y += kvm_para.h
-generic-y += local64.h
 generic-y += local.h
+generic-y += local64.h
+generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += mutex.h
 generic-y += percpu.h
+generic-y += preempt.h
 generic-y += resource.h
 generic-y += scatterlist.h
 generic-y += sections.h
@@ -31,5 +34,3 @@ generic-y += trace_clock.h
 generic-y += types.h
 generic-y += word-at-a-time.h
 generic-y += xor.h
-generic-y += preempt.h
-generic-y += hash.h
diff --git a/arch/metag/include/asm/Kbuild b/arch/metag/include/asm/Kbuild
index b716d80..c29ead8 100644
--- a/arch/metag/include/asm/Kbuild
+++ b/arch/metag/include/asm/Kbuild
@@ -13,6 +13,7 @@ generic-y += fb.h
 generic-y += fcntl.h
 generic-y += futex.h
 generic-y += hardirq.h
+generic-y += hash.h
 generic-y += hw_irq.h
 generic-y += ioctl.h
 generic-y += ioctls.h
@@ -23,6 +24,7 @@ generic-y += kmap_types.h
 generic-y += kvm_para.h
 generic-y += local.h
 generic-y += local64.h
+generic-y += mcs_spinlock.h
 generic-y += msgbuf.h
 generic-y += mutex.h
 generic-y += param.h
@@ -30,6 +32,7 @@ generic-y += pci.h
 generic-y += percpu.h
 generic-y += poll.h
 generic-y += posix_types.h
+generic-y += preempt.h
 generic-y += scatterlist.h
 generic-y += sections.h
 generic-y += sembuf.h
@@ -52,5 +55,3 @@ generic-y += unaligned.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
-generic-y += preempt.h
-generic-y += hash.h
diff --git a/arch/microblaze/include/asm/Kbuild b/arch/microblaze/include/asm/Kbuild
index 2b98bc7..1f590ab 100644
--- a/arch/microblaze/include/asm/Kbuild
+++ b/arch/microblaze/include/asm/Kbuild
@@ -3,6 +3,7 @@ generic-y += barrier.h
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += hash.h
-generic-y += trace_clock.h
-generic-y += syscalls.h
+generic-y += mcs_spinlock.h
 generic-y += preempt.h
+generic-y += syscalls.h
+generic-y += trace_clock.h
diff --git a/arch/mips/include/asm/Kbuild b/arch/mips/include/asm/Kbuild
index 2d7f650..0543918 100644
--- a/arch/mips/include/asm/Kbuild
+++ b/arch/mips/include/asm/Kbuild
@@ -2,16 +2,17 @@
 generic-y += cputime.h
 generic-y += current.h
 generic-y += emergency-restart.h
+generic-y += hash.h
 generic-y += local64.h
+generic-y += mcs_spinlock.h
 generic-y += mutex.h
 generic-y += parport.h
 generic-y += percpu.h
+generic-y += preempt.h
 generic-y += scatterlist.h
 generic-y += sections.h
 generic-y += segment.h
 generic-y += serial.h
 generic-y += trace_clock.h
-generic-y += preempt.h
 generic-y += ucontext.h
 generic-y += xor.h
-generic-y += hash.h
diff --git a/arch/mn10300/include/asm/Kbuild b/arch/mn10300/include/asm/Kbuild
index 992e989..cbc6b9b 100644
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@ -3,5 +3,6 @@ generic-y += barrier.h
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += hash.h
-generic-y += trace_clock.h
+generic-y += mcs_spinlock.h
 generic-y += preempt.h
+generic-y += trace_clock.h
diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/Kbuild
index 2e40f1c..480af0d 100644
--- a/arch/openrisc/include/asm/Kbuild
+++ b/arch/openrisc/include/asm/Kbuild
@@ -10,8 +10,8 @@ generic-y += bugs.h
 generic-y += cacheflush.h
 generic-y += checksum.h
 generic-y += clkdev.h
-generic-y += cmpxchg.h
 generic-y += cmpxchg-local.h
+generic-y += cmpxchg.h
 generic-y += cputime.h
 generic-y += current.h
 generic-y += device.h
@@ -25,6 +25,7 @@ generic-y += fcntl.h
 generic-y += ftrace.h
 generic-y += futex.h
 generic-y += hardirq.h
+generic-y += hash.h
 generic-y += hw_irq.h
 generic-y += ioctl.h
 generic-y += ioctls.h
@@ -34,6 +35,7 @@ generic-y += kdebug.h
 generic-y += kmap_types.h
 generic-y += kvm_para.h
 generic-y += local.h
+generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += module.h
 generic-y += msgbuf.h
@@ -41,6 +43,7 @@ generic-y += pci.h
 generic-y += percpu.h
 generic-y += poll.h
 generic-y += posix_types.h
+generic-y += preempt.h
 generic-y += resource.h
 generic-y += scatterlist.h
 generic-y += sections.h
@@ -53,11 +56,11 @@ generic-y += siginfo.h
 generic-y += signal.h
 generic-y += socket.h
 generic-y += sockios.h
-generic-y += statfs.h
 generic-y += stat.h
+generic-y += statfs.h
 generic-y += string.h
-generic-y += switch_to.h
 generic-y += swab.h
+generic-y += switch_to.h
 generic-y += termbits.h
 generic-y += termios.h
 generic-y += topology.h
@@ -68,5 +71,3 @@ generic-y += user.h
 generic-y += vga.h
 generic-y += word-at-a-time.h
 generic-y += xor.h
-generic-y += preempt.h
-generic-y += hash.h
diff --git a/arch/parisc/include/asm/Kbuild b/arch/parisc/include/asm/Kbuild
index 752c981..ecf25e6 100644
--- a/arch/parisc/include/asm/Kbuild
+++ b/arch/parisc/include/asm/Kbuild
@@ -1,9 +1,29 @@
 
+generic-y += auxvec.h
 generic-y += barrier.h
-generic-y += word-at-a-time.h auxvec.h user.h cputime.h emergency-restart.h \
-	  segment.h topology.h vga.h device.h percpu.h hw_irq.h mutex.h \
-	  div64.h irq_regs.h kdebug.h kvm_para.h local64.h local.h param.h \
-	  poll.h xor.h clkdev.h exec.h
-generic-y += trace_clock.h
-generic-y += preempt.h
+generic-y += clkdev.h
+generic-y += cputime.h
+generic-y += device.h
+generic-y += div64.h
+generic-y += emergency-restart.h
+generic-y += exec.h
 generic-y += hash.h
+generic-y += hw_irq.h
+generic-y += irq_regs.h
+generic-y += kdebug.h
+generic-y += kvm_para.h
+generic-y += local.h
+generic-y += local64.h
+generic-y += mcs_spinlock.h
+generic-y += mutex.h
+generic-y += param.h
+generic-y += percpu.h
+generic-y += poll.h
+generic-y += preempt.h
+generic-y += segment.h
+generic-y += topology.h
+generic-y += trace_clock.h
+generic-y += user.h
+generic-y += vga.h
+generic-y += word-at-a-time.h
+generic-y += xor.h
diff --git a/arch/powerpc/include/asm/Kbuild b/arch/powerpc/include/asm/Kbuild
index 6c0a955..3fb1bc4 100644
--- a/arch/powerpc/include/asm/Kbuild
+++ b/arch/powerpc/include/asm/Kbuild
@@ -1,7 +1,8 @@
 
 generic-y += clkdev.h
+generic-y += hash.h
+generic-y += mcs_spinlock.h
+generic-y += preempt.h
 generic-y += rwsem.h
 generic-y += trace_clock.h
-generic-y += preempt.h
 generic-y += vtime.h
-generic-y += hash.h
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 65a0775..bb74b21 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -117,6 +117,7 @@ config S390
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
+	select HAVE_FUTEX_CMPXCHG if FUTEX
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZ4
diff --git a/arch/s390/include/asm/Kbuild b/arch/s390/include/asm/Kbuild
index 8386a4a..57892a8 100644
--- a/arch/s390/include/asm/Kbuild
+++ b/arch/s390/include/asm/Kbuild
@@ -1,6 +1,7 @@
 
 
 generic-y += clkdev.h
-generic-y += trace_clock.h
-generic-y += preempt.h
 generic-y += hash.h
+generic-y += mcs_spinlock.h
+generic-y += preempt.h
+generic-y += trace_clock.h
diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
index 146b9d5..4630cf2 100644
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -1,10 +1,11 @@
 
 header-y +=
 
+
 generic-y += barrier.h
 generic-y += clkdev.h
 generic-y += hash.h
+generic-y += mcs_spinlock.h
+generic-y += preempt.h
 generic-y += trace_clock.h
 generic-y += xor.h
-generic-y += preempt.h
-
diff --git a/arch/sh/include/asm/Kbuild b/arch/sh/include/asm/Kbuild
index 0cd7198..c19e47d 100644
--- a/arch/sh/include/asm/Kbuild
+++ b/arch/sh/include/asm/Kbuild
@@ -8,18 +8,21 @@ generic-y += emergency-restart.h
 generic-y += errno.h
 generic-y += exec.h
 generic-y += fcntl.h
+generic-y += hash.h
 generic-y += ioctl.h
 generic-y += ipcbuf.h
 generic-y += irq_regs.h
 generic-y += kvm_para.h
 generic-y += local.h
 generic-y += local64.h
+generic-y += mcs_spinlock.h
+generic-y += mman.h
+generic-y += msgbuf.h
 generic-y += param.h
 generic-y += parport.h
 generic-y += percpu.h
 generic-y += poll.h
-generic-y += mman.h
-generic-y += msgbuf.h
+generic-y += preempt.h
 generic-y += resource.h
 generic-y += scatterlist.h
 generic-y += sembuf.h
@@ -34,5 +37,3 @@ generic-y += termios.h
 generic-y += trace_clock.h
 generic-y += ucontext.h
 generic-y += xor.h
-generic-y += preempt.h
-generic-y += hash.h
diff --git a/arch/sparc/include/asm/Kbuild b/arch/sparc/include/asm/Kbuild
index 4b60a0c..a458218 100644
--- a/arch/sparc/include/asm/Kbuild
+++ b/arch/sparc/include/asm/Kbuild
@@ -6,15 +6,16 @@ generic-y += cputime.h
 generic-y += div64.h
 generic-y += emergency-restart.h
 generic-y += exec.h
-generic-y += linkage.h
-generic-y += local64.h
-generic-y += mutex.h
+generic-y += hash.h
 generic-y += irq_regs.h
+generic-y += linkage.h
 generic-y += local.h
+generic-y += local64.h
+generic-y += mcs_spinlock.h
 generic-y += module.h
+generic-y += mutex.h
+generic-y += preempt.h
 generic-y += serial.h
 generic-y += trace_clock.h
 generic-y += types.h
 generic-y += word-at-a-time.h
-generic-y += preempt.h
-generic-y += hash.h
diff --git a/arch/tile/include/asm/Kbuild b/arch/tile/include/asm/Kbuild
index 3793c75..0aa5675 100644
--- a/arch/tile/include/asm/Kbuild
+++ b/arch/tile/include/asm/Kbuild
@@ -11,6 +11,7 @@ generic-y += errno.h
 generic-y += exec.h
 generic-y += fb.h
 generic-y += fcntl.h
+generic-y += hash.h
 generic-y += hw_irq.h
 generic-y += ioctl.h
 generic-y += ioctls.h
@@ -18,12 +19,14 @@ generic-y += ipcbuf.h
 generic-y += irq_regs.h
 generic-y += local.h
 generic-y += local64.h
+generic-y += mcs_spinlock.h
 generic-y += msgbuf.h
 generic-y += mutex.h
 generic-y += param.h
 generic-y += parport.h
 generic-y += poll.h
 generic-y += posix_types.h
+generic-y += preempt.h
 generic-y += resource.h
 generic-y += scatterlist.h
 generic-y += sembuf.h
@@ -38,5 +41,3 @@ generic-y += termios.h
 generic-y += trace_clock.h
 generic-y += types.h
 generic-y += xor.h
-generic-y += preempt.h
-generic-y += hash.h
diff --git a/arch/um/include/asm/Kbuild b/arch/um/include/asm/Kbuild
index 88a330d..a5e4b60 100644
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -1,8 +1,28 @@
-generic-y += bug.h cputime.h device.h emergency-restart.h futex.h hardirq.h
-generic-y += hw_irq.h irq_regs.h kdebug.h percpu.h sections.h topology.h xor.h
-generic-y += ftrace.h pci.h io.h param.h delay.h mutex.h current.h exec.h
-generic-y += switch_to.h clkdev.h
-generic-y += trace_clock.h
-generic-y += preempt.h
-generic-y += hash.h
 generic-y += barrier.h
+generic-y += bug.h
+generic-y += clkdev.h
+generic-y += cputime.h
+generic-y += current.h
+generic-y += delay.h
+generic-y += device.h
+generic-y += emergency-restart.h
+generic-y += exec.h
+generic-y += ftrace.h
+generic-y += futex.h
+generic-y += hardirq.h
+generic-y += hash.h
+generic-y += hw_irq.h
+generic-y += io.h
+generic-y += irq_regs.h
+generic-y += kdebug.h
+generic-y += mcs_spinlock.h
+generic-y += mutex.h
+generic-y += param.h
+generic-y += pci.h
+generic-y += percpu.h
+generic-y += preempt.h
+generic-y += sections.h
+generic-y += switch_to.h
+generic-y += topology.h
+generic-y += trace_clock.h
+generic-y += xor.h
diff --git a/arch/unicore32/include/asm/Kbuild b/arch/unicore32/include/asm/Kbuild
index 3ef4f9d..1e5fb87 100644
--- a/arch/unicore32/include/asm/Kbuild
+++ b/arch/unicore32/include/asm/Kbuild
@@ -16,6 +16,7 @@ generic-y += fcntl.h
 generic-y += ftrace.h
 generic-y += futex.h
 generic-y += hardirq.h
+generic-y += hash.h
 generic-y += hw_irq.h
 generic-y += ioctl.h
 generic-y += ioctls.h
@@ -24,6 +25,7 @@ generic-y += irq_regs.h
 generic-y += kdebug.h
 generic-y += kmap_types.h
 generic-y += local.h
+generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += module.h
 generic-y += msgbuf.h
@@ -32,6 +34,7 @@ generic-y += parport.h
 generic-y += percpu.h
 generic-y += poll.h
 generic-y += posix_types.h
+generic-y += preempt.h
 generic-y += resource.h
 generic-y += scatterlist.h
 generic-y += sections.h
@@ -60,5 +63,3 @@ generic-y += unaligned.h
 generic-y += user.h
 generic-y += vga.h
 generic-y += xor.h
-generic-y += preempt.h
-generic-y += hash.h
diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index 7f66985..a8fee07 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -5,3 +5,4 @@ genhdr-y += unistd_64.h
 genhdr-y += unistd_x32.h
 
 generic-y += clkdev.h
+generic-y += mcs_spinlock.h
diff --git a/arch/xtensa/include/asm/Kbuild b/arch/xtensa/include/asm/Kbuild
index 0a337e4..c3d20ba 100644
--- a/arch/xtensa/include/asm/Kbuild
+++ b/arch/xtensa/include/asm/Kbuild
@@ -9,6 +9,7 @@ generic-y += errno.h
 generic-y += exec.h
 generic-y += fcntl.h
 generic-y += hardirq.h
+generic-y += hash.h
 generic-y += ioctl.h
 generic-y += irq_regs.h
 generic-y += kdebug.h
@@ -17,7 +18,9 @@ generic-y += kvm_para.h
 generic-y += linkage.h
 generic-y += local.h
 generic-y += local64.h
+generic-y += mcs_spinlock.h
 generic-y += percpu.h
+generic-y += preempt.h
 generic-y += resource.h
 generic-y += scatterlist.h
 generic-y += sections.h
@@ -27,5 +30,3 @@ generic-y += termios.h
 generic-y += topology.h
 generic-y += trace_clock.h
 generic-y += xor.h
-generic-y += preempt.h
-generic-y += hash.h
diff --git a/drivers/tty/tty_ldsem.c b/drivers/tty/tty_ldsem.c
index d8a55e8..0ffb0cb 100644
--- a/drivers/tty/tty_ldsem.c
+++ b/drivers/tty/tty_ldsem.c
@@ -39,17 +39,10 @@
 				lock_acquire(&(l)->dep_map, s, t, r, c, n, i)
 # define __rel(l, n, i)				\
 				lock_release(&(l)->dep_map, n, i)
-# ifdef CONFIG_PROVE_LOCKING
-#  define lockdep_acquire(l, s, t, i)		__acq(l, s, t, 0, 2, NULL, i)
-#  define lockdep_acquire_nest(l, s, t, n, i)	__acq(l, s, t, 0, 2, n, i)
-#  define lockdep_acquire_read(l, s, t, i)	__acq(l, s, t, 1, 2, NULL, i)
-#  define lockdep_release(l, n, i)		__rel(l, n, i)
-# else
-#  define lockdep_acquire(l, s, t, i)		__acq(l, s, t, 0, 1, NULL, i)
-#  define lockdep_acquire_nest(l, s, t, n, i)	__acq(l, s, t, 0, 1, n, i)
-#  define lockdep_acquire_read(l, s, t, i)	__acq(l, s, t, 1, 1, NULL, i)
-#  define lockdep_release(l, n, i)		__rel(l, n, i)
-# endif
+#define lockdep_acquire(l, s, t, i)		__acq(l, s, t, 0, 1, NULL, i)
+#define lockdep_acquire_nest(l, s, t, n, i)	__acq(l, s, t, 0, 1, n, i)
+#define lockdep_acquire_read(l, s, t, i)	__acq(l, s, t, 1, 1, NULL, i)
+#define lockdep_release(l, n, i)		__rel(l, n, i)
 #else
 # define lockdep_acquire(l, s, t, i)		do { } while (0)
 # define lockdep_acquire_nest(l, s, t, n, i)	do { } while (0)
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
diff --git a/include/linux/futex.h b/include/linux/futex.h
index b0d95ca..6435f46 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -55,7 +55,11 @@ union futex_key {
 #ifdef CONFIG_FUTEX
 extern void exit_robust_list(struct task_struct *curr);
 extern void exit_pi_state_list(struct task_struct *curr);
+#ifdef CONFIG_HAVE_FUTEX_CMPXCHG
+#define futex_cmpxchg_enabled 1
+#else
 extern int futex_cmpxchg_enabled;
+#endif
 #else
 static inline void exit_robust_list(struct task_struct *curr)
 {
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 92b1bfc..060e513 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -252,9 +252,9 @@ struct held_lock {
 	unsigned int trylock:1;						/* 16 bits */
 
 	unsigned int read:2;        /* see lock_acquire() comment */
-	unsigned int check:2;       /* see lock_acquire() comment */
+	unsigned int check:1;       /* see lock_acquire() comment */
 	unsigned int hardirqs_off:1;
-	unsigned int references:11;					/* 32 bits */
+	unsigned int references:12;					/* 32 bits */
 };
 
 /*
@@ -303,7 +303,7 @@ extern void lockdep_init_map(struct lockdep_map *lock, const char *name,
 				 (lock)->dep_map.key, sub)
 
 #define lockdep_set_novalidate_class(lock) \
-	lockdep_set_class(lock, &__lockdep_no_validate__)
+	lockdep_set_class_and_name(lock, &__lockdep_no_validate__, #lock)
 /*
  * Compare locking classes
  */
@@ -326,9 +326,8 @@ static inline int lockdep_match_key(struct lockdep_map *lock,
  *
  * Values for check:
  *
- *   0: disabled
- *   1: simple checks (freeing, held-at-exit-time, etc.)
- *   2: full validation
+ *   0: simple checks (freeing, held-at-exit-time, etc.)
+ *   1: full validation
  */
 extern void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 			 int trylock, int read, int check,
@@ -479,15 +478,9 @@ static inline void print_irqtrace_events(struct task_struct *curr)
  * on the per lock-class debug mode:
  */
 
-#ifdef CONFIG_PROVE_LOCKING
- #define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 2, n, i)
- #define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 2, n, i)
- #define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 2, n, i)
-#else
- #define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 1, n, i)
- #define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 1, n, i)
- #define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 1, n, i)
-#endif
+#define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 1, n, i)
+#define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 1, n, i)
+#define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 1, n, i)
 
 #define spin_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
 #define spin_acquire_nest(l, s, t, n, i)	lock_acquire_exclusive(l, s, t, n, i)
@@ -518,13 +511,13 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 # define might_lock(lock) 						\
 do {									\
 	typecheck(struct lockdep_map *, &(lock)->dep_map);		\
-	lock_acquire(&(lock)->dep_map, 0, 0, 0, 2, NULL, _THIS_IP_);	\
+	lock_acquire(&(lock)->dep_map, 0, 0, 0, 1, NULL, _THIS_IP_);	\
 	lock_release(&(lock)->dep_map, 0, _THIS_IP_);			\
 } while (0)
 # define might_lock_read(lock) 						\
 do {									\
 	typecheck(struct lockdep_map *, &(lock)->dep_map);		\
-	lock_acquire(&(lock)->dep_map, 0, 0, 1, 2, NULL, _THIS_IP_);	\
+	lock_acquire(&(lock)->dep_map, 0, 0, 1, 1, NULL, _THIS_IP_);	\
 	lock_release(&(lock)->dep_map, 0, _THIS_IP_);			\
 } while (0)
 #else
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index d318193..11692de 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -46,6 +46,7 @@
  * - detects multi-task circular deadlocks and prints out all affected
  *   locks and tasks (and only those tasks)
  */
+struct optimistic_spin_queue;
 struct mutex {
 	/* 1: unlocked, 0: locked, negative: locked, possible waiters */
 	atomic_t		count;
@@ -55,7 +56,7 @@ struct mutex {
 	struct task_struct	*owner;
 #endif
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
-	void			*spin_mlock;	/* Spinner MCS lock */
+	struct optimistic_spin_queue	*osq;	/* Spinner MCS lock */
 #endif
 #ifdef CONFIG_DEBUG_MUTEXES
 	const char 		*name;
@@ -179,4 +180,4 @@ extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
 # define arch_mutex_cpu_relax() cpu_relax()
 #endif
 
-#endif
+#endif /* __LINUX_MUTEX_H */
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 72bf3a0..adff3c9 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -314,7 +314,7 @@ static inline bool rcu_lockdep_current_cpu_online(void)
 
 static inline void rcu_lock_acquire(struct lockdep_map *map)
 {
-	lock_acquire(map, 0, 0, 2, 1, NULL, _THIS_IP_);
+	lock_acquire(map, 0, 0, 2, 0, NULL, _THIS_IP_);
 }
 
 static inline void rcu_lock_release(struct lockdep_map *map)
diff --git a/init/Kconfig b/init/Kconfig
index 009a797..d56cb03 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1387,6 +1387,13 @@ config FUTEX
 	  support for "fast userspace mutexes".  The resulting kernel may not
 	  run glibc-based applications correctly.
 
+config HAVE_FUTEX_CMPXCHG
+	bool
+	help
+	  Architectures should select this if futex_atomic_cmpxchg_inatomic()
+	  is implemented and always working. This removes a couple of runtime
+	  checks.
+
 config EPOLL
 	bool "Enable eventpoll support" if EXPERT
 	default y
diff --git a/kernel/futex.c b/kernel/futex.c
index 44a1261..5d17e3a 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -157,7 +157,9 @@
  * enqueue.
  */
 
+#ifndef CONFIG_HAVE_FUTEX_CMPXCHG
 int __read_mostly futex_cmpxchg_enabled;
+#endif
 
 /*
  * Futex flags used to encode options to functions and preserve them across
@@ -2843,9 +2845,28 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
 }
 
-static int __init futex_init(void)
+static void __init futex_detect_cmpxchg(void)
 {
+#ifndef CONFIG_HAVE_FUTEX_CMPXCHG
 	u32 curval;
+
+	/*
+	 * This will fail and we want it. Some arch implementations do
+	 * runtime detection of the futex_atomic_cmpxchg_inatomic()
+	 * functionality. We want to know that before we call in any
+	 * of the complex code paths. Also we want to prevent
+	 * registration of robust lists in that case. NULL is
+	 * guaranteed to fault and we get -EFAULT on functional
+	 * implementation, the non-functional ones will return
+	 * -ENOSYS.
+	 */
+	if (cmpxchg_futex_value_locked(&curval, NULL, 0, 0) == -EFAULT)
+		futex_cmpxchg_enabled = 1;
+#endif
+}
+
+static int __init futex_init(void)
+{
 	unsigned int futex_shift;
 	unsigned long i;
 
@@ -2861,18 +2882,8 @@ static int __init futex_init(void)
 					       &futex_shift, NULL,
 					       futex_hashsize, futex_hashsize);
 	futex_hashsize = 1UL << futex_shift;
-	/*
-	 * This will fail and we want it. Some arch implementations do
-	 * runtime detection of the futex_atomic_cmpxchg_inatomic()
-	 * functionality. We want to know that before we call in any
-	 * of the complex code paths. Also we want to prevent
-	 * registration of robust lists in that case. NULL is
-	 * guaranteed to fault and we get -EFAULT on functional
-	 * implementation, the non-functional ones will return
-	 * -ENOSYS.
-	 */
-	if (cmpxchg_futex_value_locked(&curval, NULL, 0, 0) == -EFAULT)
-		futex_cmpxchg_enabled = 1;
+
+	futex_detect_cmpxchg();
 
 	for (i = 0; i < futex_hashsize; i++) {
 		plist_head_init(&futex_queues[i].chain);
diff --git a/kernel/locking/Makefile b/kernel/locking/Makefile
index baab8e5..2a9ee96 100644
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -1,5 +1,5 @@
 
-obj-y += mutex.o semaphore.o rwsem.o lglock.o
+obj-y += mutex.o semaphore.o rwsem.o lglock.o mcs_spinlock.o
 
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_lockdep.o = -pg
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index eb8a547..bf0c6b0 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -1936,12 +1936,12 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
 
 	for (;;) {
 		int distance = curr->lockdep_depth - depth + 1;
-		hlock = curr->held_locks + depth-1;
+		hlock = curr->held_locks + depth - 1;
 		/*
 		 * Only non-recursive-read entries get new dependencies
 		 * added:
 		 */
-		if (hlock->read != 2) {
+		if (hlock->read != 2 && hlock->check) {
 			if (!check_prev_add(curr, hlock, next,
 						distance, trylock_loop))
 				return 0;
@@ -2098,7 +2098,7 @@ static int validate_chain(struct task_struct *curr, struct lockdep_map *lock,
 	 * (If lookup_chain_cache() returns with 1 it acquires
 	 * graph_lock for us)
 	 */
-	if (!hlock->trylock && (hlock->check == 2) &&
+	if (!hlock->trylock && hlock->check &&
 	    lookup_chain_cache(curr, hlock, chain_key)) {
 		/*
 		 * Check whether last held lock:
@@ -2517,7 +2517,7 @@ mark_held_locks(struct task_struct *curr, enum mark_type mark)
 
 		BUG_ON(usage_bit >= LOCK_USAGE_STATES);
 
-		if (hlock_class(hlock)->key == __lockdep_no_validate__.subkeys)
+		if (!hlock->check)
 			continue;
 
 		if (!mark_lock(curr, hlock, usage_bit))
@@ -3055,9 +3055,6 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	int class_idx;
 	u64 chain_key;
 
-	if (!prove_locking)
-		check = 1;
-
 	if (unlikely(!debug_locks))
 		return 0;
 
@@ -3069,8 +3066,8 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return 0;
 
-	if (lock->key == &__lockdep_no_validate__)
-		check = 1;
+	if (!prove_locking || lock->key == &__lockdep_no_validate__)
+		check = 0;
 
 	if (subclass < NR_LOCKDEP_CACHING_CLASSES)
 		class = lock->class_cache[subclass];
@@ -3138,7 +3135,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	hlock->holdtime_stamp = lockstat_clock();
 #endif
 
-	if (check == 2 && !mark_irqflags(curr, hlock))
+	if (check && !mark_irqflags(curr, hlock))
 		return 0;
 
 	/* mark it as used: */
diff --git a/kernel/locking/mcs_spinlock.c b/kernel/locking/mcs_spinlock.c
new file mode 100644
index 0000000..838dc9e
--- /dev/null
+++ b/kernel/locking/mcs_spinlock.c
@@ -0,0 +1,178 @@
+
+#include <linux/percpu.h>
+#include <linux/mutex.h>
+#include <linux/sched.h>
+#include "mcs_spinlock.h"
+
+#ifdef CONFIG_SMP
+
+/*
+ * An MCS like lock especially tailored for optimistic spinning for sleeping
+ * lock implementations (mutex, rwsem, etc).
+ *
+ * Using a single mcs node per CPU is safe because sleeping locks should not be
+ * called from interrupt context and we have preemption disabled while
+ * spinning.
+ */
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct optimistic_spin_queue, osq_node);
+
+/*
+ * Get a stable @node->next pointer, either for unlock() or unqueue() purposes.
+ * Can return NULL in case we were the last queued and we updated @lock instead.
+ */
+static inline struct optimistic_spin_queue *
+osq_wait_next(struct optimistic_spin_queue **lock,
+	      struct optimistic_spin_queue *node,
+	      struct optimistic_spin_queue *prev)
+{
+	struct optimistic_spin_queue *next = NULL;
+
+	for (;;) {
+		if (*lock == node && cmpxchg(lock, node, prev) == node) {
+			/*
+			 * We were the last queued, we moved @lock back. @prev
+			 * will now observe @lock and will complete its
+			 * unlock()/unqueue().
+			 */
+			break;
+		}
+
+		/*
+		 * We must xchg() the @node->next value, because if we were to
+		 * leave it in, a concurrent unlock()/unqueue() from
+		 * @node->next might complete Step-A and think its @prev is
+		 * still valid.
+		 *
+		 * If the concurrent unlock()/unqueue() wins the race, we'll
+		 * wait for either @lock to point to us, through its Step-B, or
+		 * wait for a new @node->next from its Step-C.
+		 */
+		if (node->next) {
+			next = xchg(&node->next, NULL);
+			if (next)
+				break;
+		}
+
+		arch_mutex_cpu_relax();
+	}
+
+	return next;
+}
+
+bool osq_lock(struct optimistic_spin_queue **lock)
+{
+	struct optimistic_spin_queue *node = this_cpu_ptr(&osq_node);
+	struct optimistic_spin_queue *prev, *next;
+
+	node->locked = 0;
+	node->next = NULL;
+
+	node->prev = prev = xchg(lock, node);
+	if (likely(prev == NULL))
+		return true;
+
+	ACCESS_ONCE(prev->next) = node;
+
+	/*
+	 * Normally @prev is untouchable after the above store; because at that
+	 * moment unlock can proceed and wipe the node element from stack.
+	 *
+	 * However, since our nodes are static per-cpu storage, we're
+	 * guaranteed their existence -- this allows us to apply
+	 * cmpxchg in an attempt to undo our queueing.
+	 */
+
+	while (!smp_load_acquire(&node->locked)) {
+		/*
+		 * If we need to reschedule bail... so we can block.
+		 */
+		if (need_resched())
+			goto unqueue;
+
+		arch_mutex_cpu_relax();
+	}
+	return true;
+
+unqueue:
+	/*
+	 * Step - A  -- stabilize @prev
+	 *
+	 * Undo our @prev->next assignment; this will make @prev's
+	 * unlock()/unqueue() wait for a next pointer since @lock points to us
+	 * (or later).
+	 */
+
+	for (;;) {
+		if (prev->next == node &&
+		    cmpxchg(&prev->next, node, NULL) == node)
+			break;
+
+		/*
+		 * We can only fail the cmpxchg() racing against an unlock(),
+		 * in which case we should observe @node->locked becomming
+		 * true.
+		 */
+		if (smp_load_acquire(&node->locked))
+			return true;
+
+		arch_mutex_cpu_relax();
+
+		/*
+		 * Or we race against a concurrent unqueue()'s step-B, in which
+		 * case its step-C will write us a new @node->prev pointer.
+		 */
+		prev = ACCESS_ONCE(node->prev);
+	}
+
+	/*
+	 * Step - B -- stabilize @next
+	 *
+	 * Similar to unlock(), wait for @node->next or move @lock from @node
+	 * back to @prev.
+	 */
+
+	next = osq_wait_next(lock, node, prev);
+	if (!next)
+		return false;
+
+	/*
+	 * Step - C -- unlink
+	 *
+	 * @prev is stable because its still waiting for a new @prev->next
+	 * pointer, @next is stable because our @node->next pointer is NULL and
+	 * it will wait in Step-A.
+	 */
+
+	ACCESS_ONCE(next->prev) = prev;
+	ACCESS_ONCE(prev->next) = next;
+
+	return false;
+}
+
+void osq_unlock(struct optimistic_spin_queue **lock)
+{
+	struct optimistic_spin_queue *node = this_cpu_ptr(&osq_node);
+	struct optimistic_spin_queue *next;
+
+	/*
+	 * Fast path for the uncontended case.
+	 */
+	if (likely(cmpxchg(lock, node, NULL) == node))
+		return;
+
+	/*
+	 * Second most likely case.
+	 */
+	next = xchg(&node->next, NULL);
+	if (next) {
+		ACCESS_ONCE(next->locked) = 1;
+		return;
+	}
+
+	next = osq_wait_next(lock, node, NULL);
+	if (next)
+		ACCESS_ONCE(next->locked) = 1;
+}
+
+#endif
+
diff --git a/kernel/locking/mcs_spinlock.h b/kernel/locking/mcs_spinlock.h
new file mode 100644
index 0000000..a2dbac4
--- /dev/null
+++ b/kernel/locking/mcs_spinlock.h
@@ -0,0 +1,129 @@
+/*
+ * MCS lock defines
+ *
+ * This file contains the main data structure and API definitions of MCS lock.
+ *
+ * The MCS lock (proposed by Mellor-Crummey and Scott) is a simple spin-lock
+ * with the desirable properties of being fair, and with each cpu trying
+ * to acquire the lock spinning on a local variable.
+ * It avoids expensive cache bouncings that common test-and-set spin-lock
+ * implementations incur.
+ */
+#ifndef __LINUX_MCS_SPINLOCK_H
+#define __LINUX_MCS_SPINLOCK_H
+
+#include <asm/mcs_spinlock.h>
+
+struct mcs_spinlock {
+	struct mcs_spinlock *next;
+	int locked; /* 1 if lock acquired */
+};
+
+#ifndef arch_mcs_spin_lock_contended
+/*
+ * Using smp_load_acquire() provides a memory barrier that ensures
+ * subsequent operations happen after the lock is acquired.
+ */
+#define arch_mcs_spin_lock_contended(l)					\
+do {									\
+	while (!(smp_load_acquire(l)))					\
+		arch_mutex_cpu_relax();					\
+} while (0)
+#endif
+
+#ifndef arch_mcs_spin_unlock_contended
+/*
+ * smp_store_release() provides a memory barrier to ensure all
+ * operations in the critical section has been completed before
+ * unlocking.
+ */
+#define arch_mcs_spin_unlock_contended(l)				\
+	smp_store_release((l), 1)
+#endif
+
+/*
+ * Note: the smp_load_acquire/smp_store_release pair is not
+ * sufficient to form a full memory barrier across
+ * cpus for many architectures (except x86) for mcs_unlock and mcs_lock.
+ * For applications that need a full barrier across multiple cpus
+ * with mcs_unlock and mcs_lock pair, smp_mb__after_unlock_lock() should be
+ * used after mcs_lock.
+ */
+
+/*
+ * In order to acquire the lock, the caller should declare a local node and
+ * pass a reference of the node to this function in addition to the lock.
+ * If the lock has already been acquired, then this will proceed to spin
+ * on this node->locked until the previous lock holder sets the node->locked
+ * in mcs_spin_unlock().
+ *
+ * We don't inline mcs_spin_lock() so that perf can correctly account for the
+ * time spent in this lock function.
+ */
+static inline
+void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
+{
+	struct mcs_spinlock *prev;
+
+	/* Init node */
+	node->locked = 0;
+	node->next   = NULL;
+
+	prev = xchg(lock, node);
+	if (likely(prev == NULL)) {
+		/*
+		 * Lock acquired, don't need to set node->locked to 1. Threads
+		 * only spin on its own node->locked value for lock acquisition.
+		 * However, since this thread can immediately acquire the lock
+		 * and does not proceed to spin on its own node->locked, this
+		 * value won't be used. If a debug mode is needed to
+		 * audit lock status, then set node->locked value here.
+		 */
+		return;
+	}
+	ACCESS_ONCE(prev->next) = node;
+
+	/* Wait until the lock holder passes the lock down. */
+	arch_mcs_spin_lock_contended(&node->locked);
+}
+
+/*
+ * Releases the lock. The caller should pass in the corresponding node that
+ * was used to acquire the lock.
+ */
+static inline
+void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
+{
+	struct mcs_spinlock *next = ACCESS_ONCE(node->next);
+
+	if (likely(!next)) {
+		/*
+		 * Release the lock by setting it to NULL
+		 */
+		if (likely(cmpxchg(lock, node, NULL) == node))
+			return;
+		/* Wait until the next pointer is set */
+		while (!(next = ACCESS_ONCE(node->next)))
+			arch_mutex_cpu_relax();
+	}
+
+	/* Pass lock to next waiter. */
+	arch_mcs_spin_unlock_contended(&next->locked);
+}
+
+/*
+ * Cancellable version of the MCS lock above.
+ *
+ * Intended for adaptive spinning of sleeping locks:
+ * mutex_lock()/rwsem_down_{read,write}() etc.
+ */
+
+struct optimistic_spin_queue {
+	struct optimistic_spin_queue *next, *prev;
+	int locked; /* 1 if lock acquired */
+};
+
+extern bool osq_lock(struct optimistic_spin_queue **lock);
+extern void osq_unlock(struct optimistic_spin_queue **lock);
+
+#endif /* __LINUX_MCS_SPINLOCK_H */
diff --git a/kernel/locking/mutex-debug.c b/kernel/locking/mutex-debug.c
index faf6f5b..e1191c9 100644
--- a/kernel/locking/mutex-debug.c
+++ b/kernel/locking/mutex-debug.c
@@ -83,6 +83,12 @@ void debug_mutex_unlock(struct mutex *lock)
 
 	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
 	mutex_clear_owner(lock);
+
+	/*
+	 * __mutex_slowpath_needs_to_unlock() is explicitly 0 for debug
+	 * mutexes so that we can do it here after we've verified state.
+	 */
+	atomic_set(&lock->count, 1);
 }
 
 void debug_mutex_init(struct mutex *lock, const char *name,
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 4dd6e4c..14fe72c 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -25,6 +25,7 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/debug_locks.h>
+#include "mcs_spinlock.h"
 
 /*
  * In the DEBUG case we are using the "NULL fastpath" for mutexes,
@@ -33,6 +34,13 @@
 #ifdef CONFIG_DEBUG_MUTEXES
 # include "mutex-debug.h"
 # include <asm-generic/mutex-null.h>
+/*
+ * Must be 0 for the debug case so we do not do the unlock outside of the
+ * wait_lock region. debug_mutex_unlock() will do the actual unlock in this
+ * case.
+ */
+# undef __mutex_slowpath_needs_to_unlock
+# define  __mutex_slowpath_needs_to_unlock()	0
 #else
 # include "mutex.h"
 # include <asm/mutex.h>
@@ -52,7 +60,7 @@ __mutex_init(struct mutex *lock, const char *name, struct lock_class_key *key)
 	INIT_LIST_HEAD(&lock->wait_list);
 	mutex_clear_owner(lock);
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
-	lock->spin_mlock = NULL;
+	lock->osq = NULL;
 #endif
 
 	debug_mutex_init(lock, name, key);
@@ -111,54 +119,7 @@ EXPORT_SYMBOL(mutex_lock);
  * more or less simultaneously, the spinners need to acquire a MCS lock
  * first before spinning on the owner field.
  *
- * We don't inline mspin_lock() so that perf can correctly account for the
- * time spent in this lock function.
  */
-struct mspin_node {
-	struct mspin_node *next ;
-	int		  locked;	/* 1 if lock acquired */
-};
-#define	MLOCK(mutex)	((struct mspin_node **)&((mutex)->spin_mlock))
-
-static noinline
-void mspin_lock(struct mspin_node **lock, struct mspin_node *node)
-{
-	struct mspin_node *prev;
-
-	/* Init node */
-	node->locked = 0;
-	node->next   = NULL;
-
-	prev = xchg(lock, node);
-	if (likely(prev == NULL)) {
-		/* Lock acquired */
-		node->locked = 1;
-		return;
-	}
-	ACCESS_ONCE(prev->next) = node;
-	smp_wmb();
-	/* Wait until the lock holder passes the lock down */
-	while (!ACCESS_ONCE(node->locked))
-		arch_mutex_cpu_relax();
-}
-
-static void mspin_unlock(struct mspin_node **lock, struct mspin_node *node)
-{
-	struct mspin_node *next = ACCESS_ONCE(node->next);
-
-	if (likely(!next)) {
-		/*
-		 * Release the lock by setting it to NULL
-		 */
-		if (cmpxchg(lock, node, NULL) == node)
-			return;
-		/* Wait until the next pointer is set */
-		while (!(next = ACCESS_ONCE(node->next)))
-			arch_mutex_cpu_relax();
-	}
-	ACCESS_ONCE(next->locked) = 1;
-	smp_wmb();
-}
 
 /*
  * Mutex spinning code migrated from kernel/sched/core.c
@@ -212,6 +173,9 @@ static inline int mutex_can_spin_on_owner(struct mutex *lock)
 	struct task_struct *owner;
 	int retval = 1;
 
+	if (need_resched())
+		return 0;
+
 	rcu_read_lock();
 	owner = ACCESS_ONCE(lock->owner);
 	if (owner)
@@ -446,9 +410,11 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	if (!mutex_can_spin_on_owner(lock))
 		goto slowpath;
 
+	if (!osq_lock(&lock->osq))
+		goto slowpath;
+
 	for (;;) {
 		struct task_struct *owner;
-		struct mspin_node  node;
 
 		if (use_ww_ctx && ww_ctx->acquired > 0) {
 			struct ww_mutex *ww;
@@ -463,19 +429,16 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 			 * performed the optimistic spinning cannot be done.
 			 */
 			if (ACCESS_ONCE(ww->ctx))
-				goto slowpath;
+				break;
 		}
 
 		/*
 		 * If there's an owner, wait for it to either
 		 * release the lock or go to sleep.
 		 */
-		mspin_lock(MLOCK(lock), &node);
 		owner = ACCESS_ONCE(lock->owner);
-		if (owner && !mutex_spin_on_owner(lock, owner)) {
-			mspin_unlock(MLOCK(lock), &node);
-			goto slowpath;
-		}
+		if (owner && !mutex_spin_on_owner(lock, owner))
+			break;
 
 		if ((atomic_read(&lock->count) == 1) &&
 		    (atomic_cmpxchg(&lock->count, 1, 0) == 1)) {
@@ -488,11 +451,10 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 			}
 
 			mutex_set_owner(lock);
-			mspin_unlock(MLOCK(lock), &node);
+			osq_unlock(&lock->osq);
 			preempt_enable();
 			return 0;
 		}
-		mspin_unlock(MLOCK(lock), &node);
 
 		/*
 		 * When there's no owner, we might have preempted between the
@@ -501,7 +463,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * the owner complete.
 		 */
 		if (!owner && (need_resched() || rt_task(task)))
-			goto slowpath;
+			break;
 
 		/*
 		 * The cpu_relax() call is a compiler barrier which forces
@@ -511,7 +473,15 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 */
 		arch_mutex_cpu_relax();
 	}
+	osq_unlock(&lock->osq);
 slowpath:
+	/*
+	 * If we fell out of the spin path because of need_resched(),
+	 * reschedule now, before we try-lock the mutex. This avoids getting
+	 * scheduled out right after we obtained the mutex.
+	 */
+	if (need_resched())
+		schedule_preempt_disabled();
 #endif
 	spin_lock_mutex(&lock->wait_lock, flags);
 
@@ -717,10 +687,6 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 	unsigned long flags;
 
-	spin_lock_mutex(&lock->wait_lock, flags);
-	mutex_release(&lock->dep_map, nested, _RET_IP_);
-	debug_mutex_unlock(lock);
-
 	/*
 	 * some architectures leave the lock unlocked in the fastpath failure
 	 * case, others need to leave it locked. In the later case we have to
@@ -729,6 +695,10 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
 	if (__mutex_slowpath_needs_to_unlock())
 		atomic_set(&lock->count, 1);
 
+	spin_lock_mutex(&lock->wait_lock, flags);
+	mutex_release(&lock->dep_map, nested, _RET_IP_);
+	debug_mutex_unlock(lock);
+
 	if (!list_empty(&lock->wait_list)) {
 		/* get the first entry from the wait-list: */
 		struct mutex_waiter *waiter =
