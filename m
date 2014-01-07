Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbaAGAVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:21:36 -0500
Received: from mail.windriver.com ([147.11.1.11]:62081 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709AbaAGAVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 19:21:34 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] x86: delete non-required instances of include <linux/init.h>
Date: Mon, 6 Jan 2014 19:20:26 -0500
Message-ID: <1389054026-12947-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these files are actually using any __init type directives
and hence don't need to include <linux/init.h>.  Most are just a
left over from __devinit and __cpuinit removal, or simply due to
code getting copied from one driver to the next.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[build tested allyes/modconfig on x86/build from today's tip tree]

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
 arch/x86/kernel/head_32.S                            | 1 -
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
 42 files changed, 42 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index c696a8687567..6e4ce2df87cf 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -118,7 +118,6 @@ extern void mce_register_decode_chain(struct notifier_block *nb);
 extern void mce_unregister_decode_chain(struct notifier_block *nb);
 
 #include <linux/percpu.h>
-#include <linux/init.h>
 #include <linux/atomic.h>
 
 extern int mce_p5_enabled;
diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 3142a94c7b4b..3e6b4920ef5d 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -1,7 +1,6 @@
 #ifndef _ASM_X86_MPSPEC_H
 #define _ASM_X86_MPSPEC_H
 
-#include <linux/init.h>
 
 #include <asm/mpspec_def.h>
 #include <asm/x86_init.h>
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 7b034a4057f9..8ade61721ffb 100644
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
index 942a08623a1a..14fd6fd75a19 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -60,7 +60,6 @@ struct pt_regs {
 
 #endif /* !__i386__ */
 
-#include <linux/init.h>
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt_types.h>
 #endif
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 4137890e88e3..8cd27e08e23c 100644
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
index 34baa0eb5d0c..a6f3e776d2e4 100644
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
index 00c77cf78e9e..5d5b9eb2b7a4 100644
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
index e145f28b4099..191ce75c0e54 100644
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
index 7434d8556d09..62071569bd50 100644
--- a/arch/x86/kernel/apic/ipi.c
+++ b/arch/x86/kernel/apic/ipi.c
@@ -1,6 +1,5 @@
 #include <linux/cpumask.h>
 #include <linux/interrupt.h>
-#include <linux/init.h>
 
 #include <linux/mm.h>
 #include <linux/delay.h>
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 77c95c0e1bf7..00146f9b0254 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -29,7 +29,6 @@
 #define pr_fmt(fmt) "summit: %s: " fmt, __func__
 
 #include <linux/mm.h>
-#include <linux/init.h>
 #include <asm/io.h>
 #include <asm/bios_ebda.h>
 
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 140e29db478d..cac85ee6913f 100644
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
index 562a76d433c8..de231e328cae 100644
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
index bca023bdd6b2..39bc78dad377 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1,5 +1,4 @@
 #include <linux/export.h>
-#include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/elf.h>
 #include <linux/mm.h>
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index 8d5652dc99dd..8779edab684e 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -1,6 +1,5 @@
 #include <linux/bitops.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 
 #include <asm/processor.h>
 #include <asm/e820.h>
diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index d0969c75ab54..aaf152e79637 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -1,4 +1,3 @@
-#include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index ea04b342c026..e0d317e6c641 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1,4 +1,3 @@
-#include <linux/init.h>
 #include <linux/kernel.h>
 
 #include <linux/string.h>
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 4cfe0458ca66..fb6156fee6f7 100644
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
index 1c044b1ccc59..a3042989398c 100644
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
index e9a701aecaa1..7dc5564d0cdf 100644
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
index aa0430d69b90..3fa0e5ad86b4 100644
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
index 75c5ad5d35cc..ef9c2a0078bd 100644
--- a/arch/x86/kernel/cpu/umc.c
+++ b/arch/x86/kernel/cpu/umc.c
@@ -1,5 +1,4 @@
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <asm/processor.h>
 #include "cpu.h"
 
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 18677a90d6a3..a57902efe2d5 100644
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
index 5d3fe8d36e4a..f6dfd9334b67 100644
--- a/arch/x86/kernel/doublefault.c
+++ b/arch/x86/kernel/doublefault.c
@@ -1,6 +1,5 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
-#include <linux/init.h>
 #include <linux/init_task.h>
 #include <linux/fs.h>
 
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 81ba27679f18..d18be9c7d202 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -8,7 +8,6 @@
 
 .text
 #include <linux/threads.h>
-#include <linux/init.h>
 #include <linux/linkage.h>
 #include <asm/segment.h>
 #include <asm/page_types.h>
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index f66ff162dce8..a67b47c31314 100644
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
index 836f8322960e..7ec1d5f8d283 100644
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
index 5b19e4d78b00..1667b1de8d5d 100644
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
index 871be4a84c7d..da15918d1c81 100644
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
index 6f1236c29c4b..0de43e98ce08 100644
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
index adfdf56a3714..26488487bc61 100644
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
index 7c3bee636e2f..39d6a3db0b96 100644
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
index e5d5e2ce9f77..637ab34ed632 100644
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
index d0b1773d9d2e..461bc8289024 100644
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
index b046e070e088..bca9e85daaa5 100644
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
index 4f702f554f6e..e0bd082a80e0 100644
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
index e6cb80f620af..4d171e8640ef 100644
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
index f932ea61d1c8..d66c607bdc58 100644
--- a/arch/x86/realmode/rm/reboot.S
+++ b/arch/x86/realmode/rm/reboot.S
@@ -1,5 +1,4 @@
 #include <linux/linkage.h>
-#include <linux/init.h>
 #include <asm/segment.h>
 #include <asm/page_types.h>
 #include <asm/processor-flags.h>
diff --git a/arch/x86/realmode/rm/trampoline_32.S b/arch/x86/realmode/rm/trampoline_32.S
index c1b2791183e7..48ddd76bc4c3 100644
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
index bb360dc39d21..dac7b20d2f9d 100644
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
index 1cb468adacbb..4b4bd4cc06ab 100644
--- a/arch/x86/um/vdso/vdso.S
+++ b/arch/x86/um/vdso/vdso.S
@@ -1,4 +1,3 @@
-#include <linux/init.h>
 
 __INITDATA
 
diff --git a/arch/x86/vdso/vdso.S b/arch/x86/vdso/vdso.S
index 01f5e3b4613c..1e13eb8c9656 100644
--- a/arch/x86/vdso/vdso.S
+++ b/arch/x86/vdso/vdso.S
@@ -1,6 +1,5 @@
 #include <asm/page_types.h>
 #include <linux/linkage.h>
-#include <linux/init.h>
 
 __PAGE_ALIGNED_DATA
 
diff --git a/arch/x86/vdso/vdsox32.S b/arch/x86/vdso/vdsox32.S
index d6b9a7f42a8a..295f1c7543d8 100644
--- a/arch/x86/vdso/vdsox32.S
+++ b/arch/x86/vdso/vdsox32.S
@@ -1,6 +1,5 @@
 #include <asm/page_types.h>
 #include <linux/linkage.h>
-#include <linux/init.h>
 
 __PAGE_ALIGNED_DATA
 
-- 
1.8.5.2

