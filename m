Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbaAUVZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:25:28 -0500
Received: from mail1.windriver.com ([147.11.146.13]:50693 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaAUVZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:00 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>, <linux-mips@linux-mips.org>
Subject: [PATCH 34/73] mips: delete non-required instances of include <linux/init.h>
Date: Tue, 21 Jan 2014 16:22:37 -0500
Message-ID: <1390339396-3479-35-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these files are actually using any __init type directives
and hence don't need to include <linux/init.h>.  Most are just a
left over from __devinit and __cpuinit removal, or simply due to
code getting copied from one driver to the next.

Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/mips/alchemy/common/power.c               | 1 -
 arch/mips/ath79/common.h                       | 1 -
 arch/mips/bcm47xx/nvram.c                      | 1 -
 arch/mips/bcm63xx/early_printk.c               | 1 -
 arch/mips/boot/compressed/dbg.c                | 1 -
 arch/mips/boot/compressed/uart-16550.c         | 1 -
 arch/mips/cavium-octeon/smp.c                  | 1 -
 arch/mips/fw/arc/file.c                        | 1 -
 arch/mips/include/asm/highmem.h                | 1 -
 arch/mips/include/asm/mach-ath79/ar71xx_regs.h | 1 -
 arch/mips/include/asm/mach-generic/floppy.h    | 1 -
 arch/mips/include/asm/mach-jazz/floppy.h       | 1 -
 arch/mips/jz4740/platform.c                    | 1 -
 arch/mips/kernel/bmips_vec.S                   | 1 -
 arch/mips/kernel/crash.c                       | 1 -
 arch/mips/kernel/spram.c                       | 1 -
 arch/mips/kernel/sync-r4k.c                    | 1 -
 arch/mips/kvm/kvm_tlb.c                        | 1 -
 arch/mips/lantiq/xway/clk.c                    | 1 -
 arch/mips/lasat/at93c.c                        | 1 -
 arch/mips/lasat/picvue.c                       | 1 -
 arch/mips/lib/uncached.c                       | 1 -
 arch/mips/loongson/lemote-2f/clock.c           | 1 -
 arch/mips/mm/c-octeon.c                        | 1 -
 arch/mips/mm/c-r3k.c                           | 1 -
 arch/mips/mm/cache.c                           | 1 -
 arch/mips/mm/cex-sb1.S                         | 1 -
 arch/mips/mm/hugetlbpage.c                     | 1 -
 arch/mips/mm/page.c                            | 1 -
 arch/mips/mm/sc-rm7k.c                         | 1 -
 arch/mips/mm/tlb-r3k.c                         | 1 -
 arch/mips/mm/tlb-r8k.c                         | 1 -
 arch/mips/mm/tlbex.c                           | 1 -
 arch/mips/mm/uasm-micromips.c                  | 1 -
 arch/mips/mm/uasm-mips.c                       | 1 -
 arch/mips/mti-malta/malta-amon.c               | 1 -
 arch/mips/mti-sead3/sead3-pic32-bus.c          | 1 -
 arch/mips/netlogic/common/reset.S              | 1 -
 arch/mips/netlogic/common/smpboot.S            | 1 -
 arch/mips/netlogic/xlp/wakeup.c                | 1 -
 arch/mips/netlogic/xlr/wakeup.c                | 1 -
 arch/mips/pci/fixup-rc32434.c                  | 1 -
 arch/mips/pci/fixup-sb1250.c                   | 1 -
 arch/mips/pci/ops-bcm63xx.c                    | 1 -
 arch/mips/pci/ops-bonito64.c                   | 1 -
 arch/mips/pci/ops-lantiq.c                     | 1 -
 arch/mips/pci/ops-loongson2.c                  | 1 -
 arch/mips/pci/ops-mace.c                       | 1 -
 arch/mips/pci/ops-msc.c                        | 1 -
 arch/mips/pci/ops-nile4.c                      | 1 -
 arch/mips/pci/ops-rc32434.c                    | 1 -
 arch/mips/pci/pci-ip27.c                       | 1 -
 arch/mips/sgi-ip27/ip27-console.c              | 1 -
 arch/mips/sgi-ip27/ip27-irq-pci.c              | 1 -
 arch/mips/sgi-ip27/ip27-klconfig.c             | 1 -
 arch/mips/sgi-ip27/ip27-xtalk.c                | 1 -
 56 files changed, 56 deletions(-)

diff --git a/arch/mips/alchemy/common/power.c b/arch/mips/alchemy/common/power.c
index 0c7fce2..bdb28dee 100644
--- a/arch/mips/alchemy/common/power.c
+++ b/arch/mips/alchemy/common/power.c
@@ -29,7 +29,6 @@
  *  675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/pm.h>
 #include <linux/sysctl.h>
 #include <linux/jiffies.h>
diff --git a/arch/mips/ath79/common.h b/arch/mips/ath79/common.h
index 648d2da..a312071 100644
--- a/arch/mips/ath79/common.h
+++ b/arch/mips/ath79/common.h
@@ -15,7 +15,6 @@
 #define __ATH79_COMMON_H
 
 #include <linux/types.h>
-#include <linux/init.h>
 
 #define ATH79_MEM_SIZE_MIN	(2 * 1024 * 1024)
 #define ATH79_MEM_SIZE_MAX	(128 * 1024 * 1024)
diff --git a/arch/mips/bcm47xx/nvram.c b/arch/mips/bcm47xx/nvram.c
index 085a3ee..6decb27 100644
--- a/arch/mips/bcm47xx/nvram.c
+++ b/arch/mips/bcm47xx/nvram.c
@@ -11,7 +11,6 @@
  * option) any later version.
  */
 
-#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/ssb/ssb.h>
diff --git a/arch/mips/bcm63xx/early_printk.c b/arch/mips/bcm63xx/early_printk.c
index f92f1a2..6092226 100644
--- a/arch/mips/bcm63xx/early_printk.c
+++ b/arch/mips/bcm63xx/early_printk.c
@@ -6,7 +6,6 @@
  * Copyright (C) 2008 Maxime Bizon <mbizon@freebox.fr>
  */
 
-#include <linux/init.h>
 #include <bcm63xx_io.h>
 #include <linux/serial_bcm63xx.h>
 
diff --git a/arch/mips/boot/compressed/dbg.c b/arch/mips/boot/compressed/dbg.c
index 134a616..06c6a5b 100644
--- a/arch/mips/boot/compressed/dbg.c
+++ b/arch/mips/boot/compressed/dbg.c
@@ -6,7 +6,6 @@
  * need to implement your own putc().
  */
 #include <linux/compiler.h>
-#include <linux/init.h>
 #include <linux/types.h>
 
 void __weak putc(char c)
diff --git a/arch/mips/boot/compressed/uart-16550.c b/arch/mips/boot/compressed/uart-16550.c
index 869172d..237494b 100644
--- a/arch/mips/boot/compressed/uart-16550.c
+++ b/arch/mips/boot/compressed/uart-16550.c
@@ -4,7 +4,6 @@
 
 #include <linux/types.h>
 #include <linux/serial_reg.h>
-#include <linux/init.h>
 
 #include <asm/addrspace.h>
 
diff --git a/arch/mips/cavium-octeon/smp.c b/arch/mips/cavium-octeon/smp.c
index 24a2167..67a078f 100644
--- a/arch/mips/cavium-octeon/smp.c
+++ b/arch/mips/cavium-octeon/smp.c
@@ -6,7 +6,6 @@
  * Copyright (C) 2004-2008, 2009, 2010 Cavium Networks
  */
 #include <linux/cpu.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/smp.h>
 #include <linux/interrupt.h>
diff --git a/arch/mips/fw/arc/file.c b/arch/mips/fw/arc/file.c
index a8b0803..49fd3ff 100644
--- a/arch/mips/fw/arc/file.c
+++ b/arch/mips/fw/arc/file.c
@@ -8,7 +8,6 @@
  * Copyright (C) 1994, 1995, 1996, 1999 Ralf Baechle
  * Copyright (C) 1999 Silicon Graphics, Inc.
  */
-#include <linux/init.h>
 
 #include <asm/fw/arc/types.h>
 #include <asm/sgialib.h>
diff --git a/arch/mips/include/asm/highmem.h b/arch/mips/include/asm/highmem.h
index b0dd0c8..572e63e 100644
--- a/arch/mips/include/asm/highmem.h
+++ b/arch/mips/include/asm/highmem.h
@@ -19,7 +19,6 @@
 
 #ifdef __KERNEL__
 
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/uaccess.h>
 #include <asm/kmap_types.h>
diff --git a/arch/mips/include/asm/mach-ath79/ar71xx_regs.h b/arch/mips/include/asm/mach-ath79/ar71xx_regs.h
index b86a125..cd41e93 100644
--- a/arch/mips/include/asm/mach-ath79/ar71xx_regs.h
+++ b/arch/mips/include/asm/mach-ath79/ar71xx_regs.h
@@ -16,7 +16,6 @@
 #define __ASM_MACH_AR71XX_REGS_H
 
 #include <linux/types.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/bitops.h>
 
diff --git a/arch/mips/include/asm/mach-generic/floppy.h b/arch/mips/include/asm/mach-generic/floppy.h
index 5b5cd68..e2561d9 100644
--- a/arch/mips/include/asm/mach-generic/floppy.h
+++ b/arch/mips/include/asm/mach-generic/floppy.h
@@ -9,7 +9,6 @@
 #define __ASM_MACH_GENERIC_FLOPPY_H
 
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/sched.h>
 #include <linux/linkage.h>
diff --git a/arch/mips/include/asm/mach-jazz/floppy.h b/arch/mips/include/asm/mach-jazz/floppy.h
index 62aa1e2..4b86c88 100644
--- a/arch/mips/include/asm/mach-jazz/floppy.h
+++ b/arch/mips/include/asm/mach-jazz/floppy.h
@@ -9,7 +9,6 @@
 #define __ASM_MACH_JAZZ_FLOPPY_H
 
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/linkage.h>
 #include <linux/types.h>
 #include <linux/mm.h>
diff --git a/arch/mips/jz4740/platform.c b/arch/mips/jz4740/platform.c
index 1be41e2..a447101 100644
--- a/arch/mips/jz4740/platform.c
+++ b/arch/mips/jz4740/platform.c
@@ -14,7 +14,6 @@
  */
 
 #include <linux/device.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/resource.h>
diff --git a/arch/mips/kernel/bmips_vec.S b/arch/mips/kernel/bmips_vec.S
index 122aa7f..a5bf73d 100644
--- a/arch/mips/kernel/bmips_vec.S
+++ b/arch/mips/kernel/bmips_vec.S
@@ -8,7 +8,6 @@
  * Reset/NMI/re-entry vectors for BMIPS processors
  */
 
-#include <linux/init.h>
 
 #include <asm/asm.h>
 #include <asm/asmmacro.h>
diff --git a/arch/mips/kernel/crash.c b/arch/mips/kernel/crash.c
index 93aa302..d212646 100644
--- a/arch/mips/kernel/crash.c
+++ b/arch/mips/kernel/crash.c
@@ -5,7 +5,6 @@
 #include <linux/bootmem.h>
 #include <linux/crash_dump.h>
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/types.h>
 #include <linux/sched.h>
diff --git a/arch/mips/kernel/spram.c b/arch/mips/kernel/spram.c
index dfed8a4..b242e2c 100644
--- a/arch/mips/kernel/spram.c
+++ b/arch/mips/kernel/spram.c
@@ -8,7 +8,6 @@
  *
  * Copyright (C) 2007, 2008 MIPS Technologies, Inc.
  */
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/ptrace.h>
 #include <linux/stddef.h>
diff --git a/arch/mips/kernel/sync-r4k.c b/arch/mips/kernel/sync-r4k.c
index 84536bf..c24ad5f 100644
--- a/arch/mips/kernel/sync-r4k.c
+++ b/arch/mips/kernel/sync-r4k.c
@@ -11,7 +11,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/irqflags.h>
 #include <linux/cpumask.h>
 
diff --git a/arch/mips/kvm/kvm_tlb.c b/arch/mips/kvm/kvm_tlb.c
index c777dd3..26db6ba 100644
--- a/arch/mips/kvm/kvm_tlb.c
+++ b/arch/mips/kvm/kvm_tlb.c
@@ -10,7 +10,6 @@
 * Authors: Sanjay Lal <sanjayl@kymasys.com>
 */
 
-#include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
diff --git a/arch/mips/lantiq/xway/clk.c b/arch/mips/lantiq/xway/clk.c
index 1ab576d..8750dc0 100644
--- a/arch/mips/lantiq/xway/clk.c
+++ b/arch/mips/lantiq/xway/clk.c
@@ -8,7 +8,6 @@
 
 #include <linux/io.h>
 #include <linux/export.h>
-#include <linux/init.h>
 #include <linux/clk.h>
 
 #include <asm/time.h>
diff --git a/arch/mips/lasat/at93c.c b/arch/mips/lasat/at93c.c
index 793e234..942f32b 100644
--- a/arch/mips/lasat/at93c.c
+++ b/arch/mips/lasat/at93c.c
@@ -8,7 +8,6 @@
 #include <linux/delay.h>
 #include <asm/lasat/lasat.h>
 #include <linux/module.h>
-#include <linux/init.h>
 
 #include "at93c.h"
 
diff --git a/arch/mips/lasat/picvue.c b/arch/mips/lasat/picvue.c
index 7eb3348..d613b97 100644
--- a/arch/mips/lasat/picvue.c
+++ b/arch/mips/lasat/picvue.c
@@ -9,7 +9,6 @@
 #include <asm/bootinfo.h>
 #include <asm/lasat/lasat.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/string.h>
 
diff --git a/arch/mips/lib/uncached.c b/arch/mips/lib/uncached.c
index d8522f8..09d5dee 100644
--- a/arch/mips/lib/uncached.c
+++ b/arch/mips/lib/uncached.c
@@ -8,7 +8,6 @@
  *	Author: Maciej W. Rozycki <macro@mips.com>
  */
 
-#include <linux/init.h>
 
 #include <asm/addrspace.h>
 #include <asm/bug.h>
diff --git a/arch/mips/loongson/lemote-2f/clock.c b/arch/mips/loongson/lemote-2f/clock.c
index 4dc2f5f..aed32b8 100644
--- a/arch/mips/loongson/lemote-2f/clock.c
+++ b/arch/mips/loongson/lemote-2f/clock.c
@@ -10,7 +10,6 @@
 #include <linux/cpufreq.h>
 #include <linux/errno.h>
 #include <linux/export.h>
-#include <linux/init.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
diff --git a/arch/mips/mm/c-octeon.c b/arch/mips/mm/c-octeon.c
index c8efdb5..f41a5c5 100644
--- a/arch/mips/mm/c-octeon.c
+++ b/arch/mips/mm/c-octeon.c
@@ -6,7 +6,6 @@
  * Copyright (C) 2005-2007 Cavium Networks
  */
 #include <linux/export.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
diff --git a/arch/mips/mm/c-r3k.c b/arch/mips/mm/c-r3k.c
index 2fcde0c..135ec31 100644
--- a/arch/mips/mm/c-r3k.c
+++ b/arch/mips/mm/c-r3k.c
@@ -9,7 +9,6 @@
  * Copyright (C) 1998 Gleb Raiko & Vladimir Roganov
  * Copyright (C) 2001, 2004, 2007  Maciej W. Rozycki
  */
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
diff --git a/arch/mips/mm/cache.c b/arch/mips/mm/cache.c
index 15f813c..fde7e56 100644
--- a/arch/mips/mm/cache.c
+++ b/arch/mips/mm/cache.c
@@ -8,7 +8,6 @@
  */
 #include <linux/fs.h>
 #include <linux/fcntl.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/linkage.h>
 #include <linux/module.h>
diff --git a/arch/mips/mm/cex-sb1.S b/arch/mips/mm/cex-sb1.S
index 191cf6e..5d5f296 100644
--- a/arch/mips/mm/cex-sb1.S
+++ b/arch/mips/mm/cex-sb1.S
@@ -15,7 +15,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
  */
-#include <linux/init.h>
 
 #include <asm/asm.h>
 #include <asm/regdef.h>
diff --git a/arch/mips/mm/hugetlbpage.c b/arch/mips/mm/hugetlbpage.c
index 01fda44..77e0ae0 100644
--- a/arch/mips/mm/hugetlbpage.c
+++ b/arch/mips/mm/hugetlbpage.c
@@ -11,7 +11,6 @@
  * Copyright (C) 2008, 2009 Cavium Networks, Inc.
  */
 
-#include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
diff --git a/arch/mips/mm/page.c b/arch/mips/mm/page.c
index cbd81d1..58033c4 100644
--- a/arch/mips/mm/page.c
+++ b/arch/mips/mm/page.c
@@ -8,7 +8,6 @@
  * Copyright (C) 2008  Thiemo Seufer
  * Copyright (C) 2012  MIPS Technologies, Inc.
  */
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
diff --git a/arch/mips/mm/sc-rm7k.c b/arch/mips/mm/sc-rm7k.c
index aaffbba..9ac1efc 100644
--- a/arch/mips/mm/sc-rm7k.c
+++ b/arch/mips/mm/sc-rm7k.c
@@ -6,7 +6,6 @@
 
 #undef DEBUG
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/bitops.h>
diff --git a/arch/mips/mm/tlb-r3k.c b/arch/mips/mm/tlb-r3k.c
index 9aca109..d657493 100644
--- a/arch/mips/mm/tlb-r3k.c
+++ b/arch/mips/mm/tlb-r3k.c
@@ -10,7 +10,6 @@
  * Copyright (C) 2002  Ralf Baechle
  * Copyright (C) 2002  Maciej W. Rozycki
  */
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
diff --git a/arch/mips/mm/tlb-r8k.c b/arch/mips/mm/tlb-r8k.c
index 6a99733..138a2ec 100644
--- a/arch/mips/mm/tlb-r8k.c
+++ b/arch/mips/mm/tlb-r8k.c
@@ -8,7 +8,6 @@
  * Carsten Langgaard, carstenl@mips.com
  * Copyright (C) 2002 MIPS Technologies, Inc.  All rights reserved.
  */
-#include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
index 6fdfe1f..b234b1b 100644
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -26,7 +26,6 @@
 #include <linux/types.h>
 #include <linux/smp.h>
 #include <linux/string.h>
-#include <linux/init.h>
 #include <linux/cache.h>
 
 #include <asm/cacheflush.h>
diff --git a/arch/mips/mm/uasm-micromips.c b/arch/mips/mm/uasm-micromips.c
index 060000f..b8d580c 100644
--- a/arch/mips/mm/uasm-micromips.c
+++ b/arch/mips/mm/uasm-micromips.c
@@ -15,7 +15,6 @@
 
 #include <linux/kernel.h>
 #include <linux/types.h>
-#include <linux/init.h>
 
 #include <asm/inst.h>
 #include <asm/elf.h>
diff --git a/arch/mips/mm/uasm-mips.c b/arch/mips/mm/uasm-mips.c
index 0c72458..3abd609 100644
--- a/arch/mips/mm/uasm-mips.c
+++ b/arch/mips/mm/uasm-mips.c
@@ -15,7 +15,6 @@
 
 #include <linux/kernel.h>
 #include <linux/types.h>
-#include <linux/init.h>
 
 #include <asm/inst.h>
 #include <asm/elf.h>
diff --git a/arch/mips/mti-malta/malta-amon.c b/arch/mips/mti-malta/malta-amon.c
index 0319ad8..592ac04 100644
--- a/arch/mips/mti-malta/malta-amon.c
+++ b/arch/mips/mti-malta/malta-amon.c
@@ -9,7 +9,6 @@
  * Arbitrary Monitor Interface
  */
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/smp.h>
 
 #include <asm/addrspace.h>
diff --git a/arch/mips/mti-sead3/sead3-pic32-bus.c b/arch/mips/mti-sead3/sead3-pic32-bus.c
index eb2bf93..3b12aa5 100644
--- a/arch/mips/mti-sead3/sead3-pic32-bus.c
+++ b/arch/mips/mti-sead3/sead3-pic32-bus.c
@@ -8,7 +8,6 @@
 #include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/errno.h>
 
diff --git a/arch/mips/netlogic/common/reset.S b/arch/mips/netlogic/common/reset.S
index dfbf94d..b231fe1 100644
--- a/arch/mips/netlogic/common/reset.S
+++ b/arch/mips/netlogic/common/reset.S
@@ -32,7 +32,6 @@
  * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
-#include <linux/init.h>
 
 #include <asm/asm.h>
 #include <asm/asm-offsets.h>
diff --git a/arch/mips/netlogic/common/smpboot.S b/arch/mips/netlogic/common/smpboot.S
index db3b894..8597657 100644
--- a/arch/mips/netlogic/common/smpboot.S
+++ b/arch/mips/netlogic/common/smpboot.S
@@ -32,7 +32,6 @@
  * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
-#include <linux/init.h>
 
 #include <asm/asm.h>
 #include <asm/asm-offsets.h>
diff --git a/arch/mips/netlogic/xlp/wakeup.c b/arch/mips/netlogic/xlp/wakeup.c
index 4eb7cdb..9a92617 100644
--- a/arch/mips/netlogic/xlp/wakeup.c
+++ b/arch/mips/netlogic/xlp/wakeup.c
@@ -32,7 +32,6 @@
  * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/threads.h>
 
diff --git a/arch/mips/netlogic/xlr/wakeup.c b/arch/mips/netlogic/xlr/wakeup.c
index ec60e71..d61cba1 100644
--- a/arch/mips/netlogic/xlr/wakeup.c
+++ b/arch/mips/netlogic/xlr/wakeup.c
@@ -32,7 +32,6 @@
  * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/threads.h>
 
diff --git a/arch/mips/pci/fixup-rc32434.c b/arch/mips/pci/fixup-rc32434.c
index d0f6ecb..7fcafd5 100644
--- a/arch/mips/pci/fixup-rc32434.c
+++ b/arch/mips/pci/fixup-rc32434.c
@@ -27,7 +27,6 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 
 #include <asm/mach-rc32434/rc32434.h>
 #include <asm/mach-rc32434/irq.h>
diff --git a/arch/mips/pci/fixup-sb1250.c b/arch/mips/pci/fixup-sb1250.c
index 1441bec..8feae91 100644
--- a/arch/mips/pci/fixup-sb1250.c
+++ b/arch/mips/pci/fixup-sb1250.c
@@ -8,7 +8,6 @@
  *	2 of the License, or (at your option) any later version.
  */
 
-#include <linux/init.h>
 #include <linux/pci.h>
 
 /*
diff --git a/arch/mips/pci/ops-bcm63xx.c b/arch/mips/pci/ops-bcm63xx.c
index 6144bb3..13eea69 100644
--- a/arch/mips/pci/ops-bcm63xx.c
+++ b/arch/mips/pci/ops-bcm63xx.c
@@ -9,7 +9,6 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/io.h>
 
diff --git a/arch/mips/pci/ops-bonito64.c b/arch/mips/pci/ops-bonito64.c
index 830352e..c06205a 100644
--- a/arch/mips/pci/ops-bonito64.c
+++ b/arch/mips/pci/ops-bonito64.c
@@ -22,7 +22,6 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 
 #include <asm/mips-boards/bonito64.h>
 
diff --git a/arch/mips/pci/ops-lantiq.c b/arch/mips/pci/ops-lantiq.c
index 16e7c25..e5738ee 100644
--- a/arch/mips/pci/ops-lantiq.c
+++ b/arch/mips/pci/ops-lantiq.c
@@ -9,7 +9,6 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/mm.h>
 #include <asm/addrspace.h>
diff --git a/arch/mips/pci/ops-loongson2.c b/arch/mips/pci/ops-loongson2.c
index 98254af..24138bb 100644
--- a/arch/mips/pci/ops-loongson2.c
+++ b/arch/mips/pci/ops-loongson2.c
@@ -14,7 +14,6 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/export.h>
 
 #include <loongson.h>
diff --git a/arch/mips/pci/ops-mace.c b/arch/mips/pci/ops-mace.c
index 1cfb558..6b5821f 100644
--- a/arch/mips/pci/ops-mace.c
+++ b/arch/mips/pci/ops-mace.c
@@ -6,7 +6,6 @@
  * Copyright (C) 2000, 2001 Keith M Wesolowski
  */
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/types.h>
 #include <asm/pci.h>
diff --git a/arch/mips/pci/ops-msc.c b/arch/mips/pci/ops-msc.c
index 92a8543..dbbf365 100644
--- a/arch/mips/pci/ops-msc.c
+++ b/arch/mips/pci/ops-msc.c
@@ -24,7 +24,6 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 
 #include <asm/mips-boards/msc01_pci.h>
 
diff --git a/arch/mips/pci/ops-nile4.c b/arch/mips/pci/ops-nile4.c
index 499e35c..a1a7c9f 100644
--- a/arch/mips/pci/ops-nile4.c
+++ b/arch/mips/pci/ops-nile4.c
@@ -1,5 +1,4 @@
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/pci.h>
 #include <asm/bootinfo.h>
 
diff --git a/arch/mips/pci/ops-rc32434.c b/arch/mips/pci/ops-rc32434.c
index 7c7182e..874ed6d 100644
--- a/arch/mips/pci/ops-rc32434.c
+++ b/arch/mips/pci/ops-rc32434.c
@@ -26,7 +26,6 @@
  *  675 Mass Ave, Cambridge, MA 02139, USA.
  */
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/pci.h>
 #include <linux/types.h>
diff --git a/arch/mips/pci/pci-ip27.c b/arch/mips/pci/pci-ip27.c
index 162b4cb..0f09eaf 100644
--- a/arch/mips/pci/pci-ip27.c
+++ b/arch/mips/pci/pci-ip27.c
@@ -7,7 +7,6 @@
  * Copyright (C) 1999, 2000, 04 Ralf Baechle (ralf@linux-mips.org)
  * Copyright (C) 1999, 2000 Silicon Graphics, Inc.
  */
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <linux/pci.h>
diff --git a/arch/mips/sgi-ip27/ip27-console.c b/arch/mips/sgi-ip27/ip27-console.c
index b952d5b..45fdfbc 100644
--- a/arch/mips/sgi-ip27/ip27-console.c
+++ b/arch/mips/sgi-ip27/ip27-console.c
@@ -5,7 +5,6 @@
  *
  * Copyright (C) 2001, 2002 Ralf Baechle
  */
-#include <linux/init.h>
 
 #include <asm/page.h>
 #include <asm/sn/addrs.h>
diff --git a/arch/mips/sgi-ip27/ip27-irq-pci.c b/arch/mips/sgi-ip27/ip27-irq-pci.c
index ec22ec5..2a1c407 100644
--- a/arch/mips/sgi-ip27/ip27-irq-pci.c
+++ b/arch/mips/sgi-ip27/ip27-irq-pci.c
@@ -8,7 +8,6 @@
 
 #undef DEBUG
 
-#include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/errno.h>
 #include <linux/signal.h>
diff --git a/arch/mips/sgi-ip27/ip27-klconfig.c b/arch/mips/sgi-ip27/ip27-klconfig.c
index 7afe146..c873d62 100644
--- a/arch/mips/sgi-ip27/ip27-klconfig.c
+++ b/arch/mips/sgi-ip27/ip27-klconfig.c
@@ -2,7 +2,6 @@
  * Copyright (C) 1999, 2000 Ralf Baechle (ralf@gnu.org)
  * Copyright (C) 1999, 2000 Silicon Graphics, Inc.
  */
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/interrupt.h>
diff --git a/arch/mips/sgi-ip27/ip27-xtalk.c b/arch/mips/sgi-ip27/ip27-xtalk.c
index d59b820..20f582a 100644
--- a/arch/mips/sgi-ip27/ip27-xtalk.c
+++ b/arch/mips/sgi-ip27/ip27-xtalk.c
@@ -7,7 +7,6 @@
  * Generic XTALK initialization code
  */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/smp.h>
 #include <asm/sn/types.h>
-- 
1.8.4.1

