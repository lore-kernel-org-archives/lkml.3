Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbaAGF1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 00:27:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49795 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbaAGF1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 00:27:38 -0500
Date: Mon, 6 Jan 2014 21:27:24 -0800
From: tip-bot for Paul Gortmaker <tipbot@zytor.com>
Message-ID: <tip-663b55b9b39fa9c848cca273ca4e12bf29b32c71@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, paul.gortmaker@windriver.com
In-Reply-To: <1389054026-12947-1-git-send-email-paul.gortmaker@windriver.com>
References: <1389054026-12947-1-git-send-email-paul.gortmaker@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86: Delete non-required instances of include 
 <linux/init.h>
Git-Commit-ID: 663b55b9b39fa9c848cca273ca4e12bf29b32c71
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 06 Jan 2014 21:27:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  663b55b9b39fa9c848cca273ca4e12bf29b32c71
Gitweb:     http://git.kernel.org/tip/663b55b9b39fa9c848cca273ca4e12bf29b32c71
Author:     Paul Gortmaker <paul.gortmaker@windriver.com>
AuthorDate: Mon, 6 Jan 2014 19:20:26 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 6 Jan 2014 21:25:18 -0800

x86: Delete non-required instances of include <linux/init.h>

None of these files are actually using any __init type directives
and hence don't need to include <linux/init.h>.  Most are just a
left over from __devinit and __cpuinit removal, or simply due to
code getting copied from one driver to the next.

[ hpa: undid incorrect removal from arch/x86/kernel/head_32.S ]

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Link: http://lkml.kernel.org/r/1389054026-12947-1-git-send-email-paul.gortmaker@windriver.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/mce.h                           | 1 -
 arch/x86/include/asm/mpspec.h                        | 1 -
 arch/x86/include/asm/processor.h                     | 1 -
 arch/x86/include/asm/ptrace.h                        | 1 -
 arch/x86/include/asm/smp.h                           | 1 -
 arch/x86/include/asm/timer.h                         | 1 -
 arch/x86/kernel/apic/apic_flat_64.c                  | 1 -
 arch/x86/kernel/apic/apic_noop.c                     | 1 -
 arch/x86/kernel/apic/ipi.c                           | 1 -
 arch/x86/kernel/apic/summit_32.c                     | 1 -
 arch/x86/kernel/apic/x2apic_cluster.c                | 1 -
 arch/x86/kernel/apic/x2apic_phys.c                   | 1 -
 arch/x86/kernel/cpu/amd.c                            | 1 -
 arch/x86/kernel/cpu/centaur.c                        | 1 -
 arch/x86/kernel/cpu/cyrix.c                          | 1 -
 arch/x86/kernel/cpu/intel.c                          | 1 -
 arch/x86/kernel/cpu/mcheck/mce_intel.c               | 1 -
 arch/x86/kernel/cpu/mcheck/p5.c                      | 1 -
 arch/x86/kernel/cpu/mcheck/winchip.c                 | 1 -
 arch/x86/kernel/cpu/transmeta.c                      | 1 -
 arch/x86/kernel/cpu/umc.c                            | 1 -
 arch/x86/kernel/crash.c                              | 1 -
 arch/x86/kernel/doublefault.c                        | 1 -
 arch/x86/kernel/hw_breakpoint.c                      | 1 -
 arch/x86/kernel/kgdb.c                               | 1 -
 arch/x86/kernel/machine_kexec_32.c                   | 1 -
 arch/x86/kernel/pci-nommu.c                          | 1 -
 arch/x86/kernel/process_32.c                         | 1 -
 arch/x86/kernel/tsc_sync.c                           | 1 -
 arch/x86/lib/delay.c                                 | 1 -
 arch/x86/mm/kmmio.c                                  | 1 -
 arch/x86/mm/pageattr-test.c                          | 1 -
 arch/x86/pci/fixup.c                                 | 1 -
 arch/x86/platform/intel-mid/early_printk_intel_mid.c | 1 -
 arch/x86/platform/iris/iris.c                        | 1 -
 arch/x86/realmode/rm/reboot.S                        | 1 -
 arch/x86/realmode/rm/trampoline_32.S                 | 1 -
 arch/x86/realmode/rm/trampoline_64.S                 | 1 -
 arch/x86/um/vdso/vdso.S                              | 1 -
 arch/x86/vdso/vdso.S                                 | 1 -
 arch/x86/vdso/vdsox32.S                              | 1 -
 41 files changed, 41 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index c696a86..6e4ce2d 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -118,7 +118,6 @@ extern void mce_register_decode_chain(struct notifier_block *nb);
 extern void mce_unregister_decode_chain(struct notifier_block *nb);
 
 #include <linux/percpu.h>
-#include <linux/init.h>
 #include <linux/atomic.h>
 
 extern int mce_p5_enabled;
diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 3142a94..3e6b492 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -1,7 +1,6 @@
 #ifndef _ASM_X86_MPSPEC_H
 #define _ASM_X86_MPSPEC_H
 
-#include <linux/init.h>
 
 #include <asm/mpspec_def.h>
 #include <asm/x86_init.h>
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 7b034a4..8ade617 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -27,7 +27,6 @@ struct mm_struct;
 #include <linux/cache.h>
 #include <linux/threads.h>
 #include <linux/math64.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/irqflags.h>
 
diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 942a086..14fd6fd 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -60,7 +60,6 @@ struct pt_regs {
 
 #endif /* !__i386__ */
 
-#include <linux/init.h>
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt_types.h>
 #endif
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 4137890..8cd27e0 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -2,7 +2,6 @@
 #define _ASM_X86_SMP_H
 #ifndef __ASSEMBLY__
 #include <linux/cpumask.h>
-#include <linux/init.h>
 #include <asm/percpu.h>
 
 /*
diff --git a/arch/x86/include/asm/timer.h b/arch/x86/include/asm/timer.h
index 34baa0e..a6f3e77 100644
--- a/arch/x86/include/asm/timer.h
+++ b/arch/x86/include/asm/timer.h
@@ -1,6 +1,5 @@
 #ifndef _ASM_X86_TIMER_H
 #define _ASM_X86_TIMER_H
-#include <linux/init.h>
 #include <linux/pm.h>
 #include <linux/percpu.h>
 #include <linux/interrupt.h>
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 00c77cf..5d5b9eb 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -14,7 +14,6 @@
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/ctype.h>
-#include <linux/init.h>
 #include <linux/hardirq.h>
 #include <linux/module.h>
 #include <asm/smp.h>
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index e145f28..191ce75 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -15,7 +15,6 @@
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/ctype.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <asm/fixmap.h>
 #include <asm/mpspec.h>
diff --git a/arch/x86/kernel/apic/ipi.c b/arch/x86/kernel/apic/ipi.c
index 7434d85..6207156 100644
--- a/arch/x86/kernel/apic/ipi.c
+++ b/arch/x86/kernel/apic/ipi.c
@@ -1,6 +1,5 @@
 #include <linux/cpumask.h>
 #include <linux/interrupt.h>
-#include <linux/init.h>
 
 #include <linux/mm.h>
 #include <linux/delay.h>
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 77c95c0..00146f9 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -29,7 +29,6 @@
 #define pr_fmt(fmt) "summit: %s: " fmt, __func__
 
 #include <linux/mm.h>
-#include <linux/init.h>
 #include <asm/io.h>
 #include <asm/bios_ebda.h>
 
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 140e29d..cac85ee 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -3,7 +3,6 @@
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/ctype.h>
-#include <linux/init.h>
 #include <linux/dmar.h>
 #include <linux/cpu.h>
 
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index 562a76d..de231e3 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -3,7 +3,6 @@
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/ctype.h>
-#include <linux/init.h>
 #include <linux/dmar.h>
 
 #include <asm/smp.h>
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index bca023b..39bc78d 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1,5 +1,4 @@
 #include <linux/export.h>
-#include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/elf.h>
 #include <linux/mm.h>
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index 8d5652d..8779eda 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -1,6 +1,5 @@
 #include <linux/bitops.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 
 #include <asm/processor.h>
 #include <asm/e820.h>
diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index d0969c7..aaf152e 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -1,4 +1,3 @@
-#include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index dc1ec0d..53f5d3c 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1,4 +1,3 @@
-#include <linux/init.h>
 #include <linux/kernel.h>
 
 #include <linux/string.h>
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 4cfe045..fb6156f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -6,7 +6,6 @@
  */
 
 #include <linux/gfp.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/percpu.h>
 #include <linux/sched.h>
diff --git a/arch/x86/kernel/cpu/mcheck/p5.c b/arch/x86/kernel/cpu/mcheck/p5.c
index 1c044b1..a304298 100644
--- a/arch/x86/kernel/cpu/mcheck/p5.c
+++ b/arch/x86/kernel/cpu/mcheck/p5.c
@@ -5,7 +5,6 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
-#include <linux/init.h>
 #include <linux/smp.h>
 
 #include <asm/processor.h>
diff --git a/arch/x86/kernel/cpu/mcheck/winchip.c b/arch/x86/kernel/cpu/mcheck/winchip.c
index e9a701a..7dc5564 100644
--- a/arch/x86/kernel/cpu/mcheck/winchip.c
+++ b/arch/x86/kernel/cpu/mcheck/winchip.c
@@ -5,7 +5,6 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
-#include <linux/init.h>
 
 #include <asm/processor.h>
 #include <asm/mce.h>
diff --git a/arch/x86/kernel/cpu/transmeta.c b/arch/x86/kernel/cpu/transmeta.c
index aa0430d..3fa0e5a 100644
--- a/arch/x86/kernel/cpu/transmeta.c
+++ b/arch/x86/kernel/cpu/transmeta.c
@@ -1,6 +1,5 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
-#include <linux/init.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
 #include "cpu.h"
diff --git a/arch/x86/kernel/cpu/umc.c b/arch/x86/kernel/cpu/umc.c
index 75c5ad5..ef9c2a0 100644
--- a/arch/x86/kernel/cpu/umc.c
+++ b/arch/x86/kernel/cpu/umc.c
@@ -1,5 +1,4 @@
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <asm/processor.h>
 #include "cpu.h"
 
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 18677a9..a57902e 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -7,7 +7,6 @@
  *
  */
 
-#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/smp.h>
diff --git a/arch/x86/kernel/doublefault.c b/arch/x86/kernel/doublefault.c
index 5d3fe8d..f6dfd93 100644
--- a/arch/x86/kernel/doublefault.c
+++ b/arch/x86/kernel/doublefault.c
@@ -1,6 +1,5 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
-#include <linux/init.h>
 #include <linux/init_task.h>
 #include <linux/fs.h>
 
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index f66ff16..a67b47c 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -38,7 +38,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/sched.h>
-#include <linux/init.h>
 #include <linux/smp.h>
 
 #include <asm/hw_breakpoint.h>
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 836f832..7ec1d5f 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -39,7 +39,6 @@
 #include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/kgdb.h>
-#include <linux/init.h>
 #include <linux/smp.h>
 #include <linux/nmi.h>
 #include <linux/hw_breakpoint.h>
diff --git a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
index 5b19e4d..1667b1d 100644
--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -9,7 +9,6 @@
 #include <linux/mm.h>
 #include <linux/kexec.h>
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/numa.h>
 #include <linux/ftrace.h>
 #include <linux/suspend.h>
diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index 871be4a..da15918 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -3,7 +3,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/scatterlist.h>
 #include <linux/string.h>
-#include <linux/init.h>
 #include <linux/gfp.h>
 #include <linux/pci.h>
 #include <linux/mm.h>
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 6f1236c..0de43e9 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -24,7 +24,6 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/reboot.h>
-#include <linux/init.h>
 #include <linux/mc146818rtc.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index adfdf56..2648848 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -16,7 +16,6 @@
  */
 #include <linux/spinlock.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/smp.h>
 #include <linux/nmi.h>
 #include <asm/tsc.h>
diff --git a/arch/x86/lib/delay.c b/arch/x86/lib/delay.c
index 7c3bee6..39d6a3d 100644
--- a/arch/x86/lib/delay.c
+++ b/arch/x86/lib/delay.c
@@ -16,7 +16,6 @@
 #include <linux/timex.h>
 #include <linux/preempt.h>
 #include <linux/delay.h>
-#include <linux/init.h>
 
 #include <asm/processor.h>
 #include <asm/delay.h>
diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index e5d5e2c..637ab34 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -11,7 +11,6 @@
 #include <linux/rculist.h>
 #include <linux/spinlock.h>
 #include <linux/hash.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/uaccess.h>
diff --git a/arch/x86/mm/pageattr-test.c b/arch/x86/mm/pageattr-test.c
index d0b1773..461bc82 100644
--- a/arch/x86/mm/pageattr-test.c
+++ b/arch/x86/mm/pageattr-test.c
@@ -8,7 +8,6 @@
 #include <linux/kthread.h>
 #include <linux/random.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/mm.h>
 
 #include <asm/cacheflush.h>
diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index b046e07..bca9e85 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -5,7 +5,6 @@
 #include <linux/delay.h>
 #include <linux/dmi.h>
 #include <linux/pci.h>
-#include <linux/init.h>
 #include <linux/vgaarb.h>
 #include <asm/pci_x86.h>
 
diff --git a/arch/x86/platform/intel-mid/early_printk_intel_mid.c b/arch/x86/platform/intel-mid/early_printk_intel_mid.c
index 4f702f5..e0bd082 100644
--- a/arch/x86/platform/intel-mid/early_printk_intel_mid.c
+++ b/arch/x86/platform/intel-mid/early_printk_intel_mid.c
@@ -22,7 +22,6 @@
 #include <linux/console.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/io.h>
 
 #include <asm/fixmap.h>
diff --git a/arch/x86/platform/iris/iris.c b/arch/x86/platform/iris/iris.c
index e6cb80f..4d171e8 100644
--- a/arch/x86/platform/iris/iris.c
+++ b/arch/x86/platform/iris/iris.c
@@ -27,7 +27,6 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/pm.h>
 #include <asm/io.h>
 
diff --git a/arch/x86/realmode/rm/reboot.S b/arch/x86/realmode/rm/reboot.S
index f932ea6..d66c607 100644
--- a/arch/x86/realmode/rm/reboot.S
+++ b/arch/x86/realmode/rm/reboot.S
@@ -1,5 +1,4 @@
 #include <linux/linkage.h>
-#include <linux/init.h>
 #include <asm/segment.h>
 #include <asm/page_types.h>
 #include <asm/processor-flags.h>
diff --git a/arch/x86/realmode/rm/trampoline_32.S b/arch/x86/realmode/rm/trampoline_32.S
index c1b2791..48ddd76 100644
--- a/arch/x86/realmode/rm/trampoline_32.S
+++ b/arch/x86/realmode/rm/trampoline_32.S
@@ -20,7 +20,6 @@
  */
 
 #include <linux/linkage.h>
-#include <linux/init.h>
 #include <asm/segment.h>
 #include <asm/page_types.h>
 #include "realmode.h"
diff --git a/arch/x86/realmode/rm/trampoline_64.S b/arch/x86/realmode/rm/trampoline_64.S
index bb360dc..dac7b20 100644
--- a/arch/x86/realmode/rm/trampoline_64.S
+++ b/arch/x86/realmode/rm/trampoline_64.S
@@ -25,7 +25,6 @@
  */
 
 #include <linux/linkage.h>
-#include <linux/init.h>
 #include <asm/pgtable_types.h>
 #include <asm/page_types.h>
 #include <asm/msr.h>
diff --git a/arch/x86/um/vdso/vdso.S b/arch/x86/um/vdso/vdso.S
index 1cb468a..4b4bd4c 100644
--- a/arch/x86/um/vdso/vdso.S
+++ b/arch/x86/um/vdso/vdso.S
@@ -1,4 +1,3 @@
-#include <linux/init.h>
 
 __INITDATA
 
diff --git a/arch/x86/vdso/vdso.S b/arch/x86/vdso/vdso.S
index 01f5e3b..1e13eb8 100644
--- a/arch/x86/vdso/vdso.S
+++ b/arch/x86/vdso/vdso.S
@@ -1,6 +1,5 @@
 #include <asm/page_types.h>
 #include <linux/linkage.h>
-#include <linux/init.h>
 
 __PAGE_ALIGNED_DATA
 
diff --git a/arch/x86/vdso/vdsox32.S b/arch/x86/vdso/vdsox32.S
index d6b9a7f..295f1c7 100644
--- a/arch/x86/vdso/vdsox32.S
+++ b/arch/x86/vdso/vdsox32.S
@@ -1,6 +1,5 @@
 #include <asm/page_types.h>
 #include <linux/linkage.h>
-#include <linux/init.h>
 
 __PAGE_ALIGNED_DATA
 
