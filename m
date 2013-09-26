Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab3IZSwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:52:49 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:42734 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab3IZSvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:51:40 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anatolij Gustschin <agust@denx.de>,
        Kumar Gala <galak@kernel.crashing.org>,
        Olof Johansson <olof@lixom.net>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 19/21] powerpc: add explicit OF includes
Date: Thu, 26 Sep 2013 13:50:54 -0500
Message-Id: <1380221456-11192-20-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
References: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

When removing prom.h include by of.h, several OF headers will no longer
be implicitly included. Add explicit includes of of_*.h as needed.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anatolij Gustschin <agust@denx.de>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Olof Johansson <olof@lixom.net>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/kernel/epapr_paravirt.c             | 1 +
 arch/powerpc/platforms/512x/clock.c              | 1 +
 arch/powerpc/platforms/512x/pdm360ng.c           | 2 ++
 arch/powerpc/platforms/82xx/mpc8272_ads.c        | 2 ++
 arch/powerpc/platforms/82xx/pq2fads.c            | 2 ++
 arch/powerpc/platforms/83xx/suspend.c            | 2 ++
 arch/powerpc/platforms/86xx/pic.c                | 1 +
 arch/powerpc/platforms/embedded6xx/flipper-pic.c | 1 +
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c    | 2 ++
 arch/powerpc/platforms/pasemi/gpio_mdio.c        | 1 +
 arch/powerpc/platforms/powermac/pfunc_base.c     | 1 +
 arch/powerpc/platforms/powernv/opal-lpc.c        | 1 +
 arch/powerpc/platforms/powernv/opal.c            | 1 +
 arch/powerpc/platforms/powernv/setup.c           | 1 +
 arch/powerpc/platforms/pseries/hotplug-memory.c  | 2 ++
 arch/powerpc/sysdev/cpm_common.c                 | 1 +
 arch/powerpc/sysdev/fsl_gtm.c                    | 2 ++
 arch/powerpc/sysdev/fsl_pmc.c                    | 1 +
 arch/powerpc/sysdev/mpic.c                       | 8 ++++----
 arch/powerpc/sysdev/mpic_timer.c                 | 2 ++
 20 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/epapr_paravirt.c b/arch/powerpc/kernel/epapr_paravirt.c
index 6300c13..7898be9 100644
--- a/arch/powerpc/kernel/epapr_paravirt.c
+++ b/arch/powerpc/kernel/epapr_paravirt.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/of.h>
+#include <linux/of_fdt.h>
 #include <asm/epapr_hcalls.h>
 #include <asm/cacheflush.h>
 #include <asm/code-patching.h>
diff --git a/arch/powerpc/platforms/512x/clock.c b/arch/powerpc/platforms/512x/clock.c
index e504166..fd8a376 100644
--- a/arch/powerpc/platforms/512x/clock.c
+++ b/arch/powerpc/platforms/512x/clock.c
@@ -24,6 +24,7 @@
 #include <linux/mutex.h>
 #include <linux/io.h>
 
+#include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <asm/mpc5xxx.h>
 #include <asm/mpc5121.h>
diff --git a/arch/powerpc/platforms/512x/pdm360ng.c b/arch/powerpc/platforms/512x/pdm360ng.c
index 24b314d..116f2325 100644
--- a/arch/powerpc/platforms/512x/pdm360ng.c
+++ b/arch/powerpc/platforms/512x/pdm360ng.c
@@ -14,6 +14,8 @@
 
 #include <linux/kernel.h>
 #include <linux/io.h>
+#include <linux/of_address.h>
+#include <linux/of_fdt.h>
 #include <linux/of_platform.h>
 
 #include <asm/machdep.h>
diff --git a/arch/powerpc/platforms/82xx/mpc8272_ads.c b/arch/powerpc/platforms/82xx/mpc8272_ads.c
index 30394b4..6a14cf5 100644
--- a/arch/powerpc/platforms/82xx/mpc8272_ads.c
+++ b/arch/powerpc/platforms/82xx/mpc8272_ads.c
@@ -16,6 +16,8 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/fsl_devices.h>
+#include <linux/of_address.h>
+#include <linux/of_fdt.h>
 #include <linux/of_platform.h>
 #include <linux/io.h>
 
diff --git a/arch/powerpc/platforms/82xx/pq2fads.c b/arch/powerpc/platforms/82xx/pq2fads.c
index e1dceee..e5f82ec 100644
--- a/arch/powerpc/platforms/82xx/pq2fads.c
+++ b/arch/powerpc/platforms/82xx/pq2fads.c
@@ -15,6 +15,8 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/fsl_devices.h>
+#include <linux/of_address.h>
+#include <linux/of_fdt.h>
 #include <linux/of_platform.h>
 
 #include <asm/io.h>
diff --git a/arch/powerpc/platforms/83xx/suspend.c b/arch/powerpc/platforms/83xx/suspend.c
index 1d769a2..3d9716c 100644
--- a/arch/powerpc/platforms/83xx/suspend.c
+++ b/arch/powerpc/platforms/83xx/suspend.c
@@ -20,6 +20,8 @@
 #include <linux/freezer.h>
 #include <linux/suspend.h>
 #include <linux/fsl_devices.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/export.h>
 
diff --git a/arch/powerpc/platforms/86xx/pic.c b/arch/powerpc/platforms/86xx/pic.c
index 9982f57..d5b98c0 100644
--- a/arch/powerpc/platforms/86xx/pic.c
+++ b/arch/powerpc/platforms/86xx/pic.c
@@ -10,6 +10,7 @@
 #include <linux/stddef.h>
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
+#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 
 #include <asm/mpic.h>
diff --git a/arch/powerpc/platforms/embedded6xx/flipper-pic.c b/arch/powerpc/platforms/embedded6xx/flipper-pic.c
index 53d6eee0..4cde8e7 100644
--- a/arch/powerpc/platforms/embedded6xx/flipper-pic.c
+++ b/arch/powerpc/platforms/embedded6xx/flipper-pic.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <asm/io.h>
 
 #include "flipper-pic.h"
diff --git a/arch/powerpc/platforms/embedded6xx/hlwd-pic.c b/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
index 3006b51..7cab21d 100644
--- a/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
+++ b/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
@@ -18,6 +18,8 @@
 #include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <asm/io.h>
 
 #include "hlwd-pic.h"
diff --git a/arch/powerpc/platforms/pasemi/gpio_mdio.c b/arch/powerpc/platforms/pasemi/gpio_mdio.c
index 0237ab7..15adee5 100644
--- a/arch/powerpc/platforms/pasemi/gpio_mdio.c
+++ b/arch/powerpc/platforms/pasemi/gpio_mdio.c
@@ -30,6 +30,7 @@
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
 #include <linux/phy.h>
+#include <linux/of_address.h>
 #include <linux/of_mdio.h>
 #include <linux/of_platform.h>
 
diff --git a/arch/powerpc/platforms/powermac/pfunc_base.c b/arch/powerpc/platforms/powermac/pfunc_base.c
index f5e3cda..e49d07f 100644
--- a/arch/powerpc/platforms/powermac/pfunc_base.c
+++ b/arch/powerpc/platforms/powermac/pfunc_base.c
@@ -4,6 +4,7 @@
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
+#include <linux/of_irq.h>
 
 #include <asm/pmac_feature.h>
 #include <asm/pmac_pfunc.h>
diff --git a/arch/powerpc/platforms/powernv/opal-lpc.c b/arch/powerpc/platforms/powernv/opal-lpc.c
index a7614bb..e7e59e4 100644
--- a/arch/powerpc/platforms/powernv/opal-lpc.c
+++ b/arch/powerpc/platforms/powernv/opal-lpc.c
@@ -17,6 +17,7 @@
 #include <asm/firmware.h>
 #include <asm/xics.h>
 #include <asm/opal.h>
+#include <asm/prom.h>
 
 static int opal_lpc_chip_id = -1;
 
diff --git a/arch/powerpc/platforms/powernv/opal.c b/arch/powerpc/platforms/powernv/opal.c
index 2911abe..f36ff35 100644
--- a/arch/powerpc/platforms/powernv/opal.c
+++ b/arch/powerpc/platforms/powernv/opal.c
@@ -13,6 +13,7 @@
 
 #include <linux/types.h>
 #include <linux/of.h>
+#include <linux/of_fdt.h>
 #include <linux/of_platform.h>
 #include <linux/interrupt.h>
 #include <linux/notifier.h>
diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index e239dcf..19884b2 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -23,6 +23,7 @@
 #include <linux/irq.h>
 #include <linux/seq_file.h>
 #include <linux/of.h>
+#include <linux/of_fdt.h>
 #include <linux/interrupt.h>
 #include <linux/bug.h>
 
diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/powerpc/platforms/pseries/hotplug-memory.c
index 9a432de..9590dbb 100644
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -10,12 +10,14 @@
  */
 
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/memblock.h>
 #include <linux/vmalloc.h>
 #include <linux/memory.h>
 
 #include <asm/firmware.h>
 #include <asm/machdep.h>
+#include <asm/prom.h>
 #include <asm/sparsemem.h>
 
 static unsigned long get_memblock_size(void)
diff --git a/arch/powerpc/sysdev/cpm_common.c b/arch/powerpc/sysdev/cpm_common.c
index 4dd5341..4f78695 100644
--- a/arch/powerpc/sysdev/cpm_common.c
+++ b/arch/powerpc/sysdev/cpm_common.c
@@ -22,6 +22,7 @@
 #include <linux/spinlock.h>
 #include <linux/export.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/slab.h>
 
 #include <asm/udbg.h>
diff --git a/arch/powerpc/sysdev/fsl_gtm.c b/arch/powerpc/sysdev/fsl_gtm.c
index 0eb871c..1b980ee 100644
--- a/arch/powerpc/sysdev/fsl_gtm.c
+++ b/arch/powerpc/sysdev/fsl_gtm.c
@@ -19,6 +19,8 @@
 #include <linux/list.h>
 #include <linux/io.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <linux/spinlock.h>
 #include <linux/bitops.h>
 #include <linux/slab.h>
diff --git a/arch/powerpc/sysdev/fsl_pmc.c b/arch/powerpc/sysdev/fsl_pmc.c
index 592a0f8..8cf4aa0 100644
--- a/arch/powerpc/sysdev/fsl_pmc.c
+++ b/arch/powerpc/sysdev/fsl_pmc.c
@@ -18,6 +18,7 @@
 #include <linux/suspend.h>
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/of_address.h>
 #include <linux/of_platform.h>
 
 struct pmc_regs {
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index 1be54fa..2d30eaf 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -535,7 +535,7 @@ static void __init mpic_scan_ht_pic(struct mpic *mpic, u8 __iomem *devbase,
 		mpic->fixups[irq].data = readl(base + 4) | 0x80000000;
 	}
 }
- 
+
 
 static void __init mpic_scan_ht_pics(struct mpic *mpic)
 {
@@ -1475,7 +1475,7 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	 * as a default instead of the value read from the HW.
 	 */
 	last_irq = (greg_feature & MPIC_GREG_FEATURE_LAST_SRC_MASK)
-				>> MPIC_GREG_FEATURE_LAST_SRC_SHIFT;	
+				>> MPIC_GREG_FEATURE_LAST_SRC_SHIFT;
 	if (isu_size)
 		last_irq = isu_size  * MPIC_MAX_ISU - 1;
 	of_property_read_u32(mpic->node, "last-interrupt-source", &last_irq);
@@ -1625,7 +1625,7 @@ void __init mpic_init(struct mpic *mpic)
 			/* start with vector = source number, and masked */
 			u32 vecpri = MPIC_VECPRI_MASK | i |
 				(8 << MPIC_VECPRI_PRIORITY_SHIFT);
-		
+
 			/* check if protected */
 			if (mpic->protected && test_bit(i, mpic->protected))
 				continue;
@@ -1634,7 +1634,7 @@ void __init mpic_init(struct mpic *mpic)
 			mpic_irq_write(i, MPIC_INFO(IRQ_DESTINATION), 1 << cpu);
 		}
 	}
-	
+
 	/* Init spurious vector */
 	mpic_write(mpic->gregs, MPIC_INFO(GREG_SPURIOUS), mpic->spurious_vec);
 
diff --git a/arch/powerpc/sysdev/mpic_timer.c b/arch/powerpc/sysdev/mpic_timer.c
index c06db92..22d7d57 100644
--- a/arch/powerpc/sysdev/mpic_timer.c
+++ b/arch/powerpc/sysdev/mpic_timer.c
@@ -19,7 +19,9 @@
 #include <linux/interrupt.h>
 #include <linux/slab.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/of_device.h>
+#include <linux/of_irq.h>
 #include <linux/syscore_ops.h>
 #include <sysdev/fsl_soc.h>
 #include <asm/io.h>
-- 
1.8.1.2

