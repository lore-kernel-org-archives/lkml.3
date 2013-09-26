Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab3IZSzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:55:42 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:35945 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab3IZSvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:51:25 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Michal Simek <monstr@monstr.eu>,
        microblaze-uclinux@itee.uq.edu.au, netdev@vger.kernel.org
Subject: [PATCH 09/21] microblaze: clean-up prom.h implicit includes
Date: Thu, 26 Sep 2013 13:50:44 -0500
Message-Id: <1380221456-11192-10-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
References: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

While powerpc is a mess of implicit includes by prom.h, microblaze just
copied this and is easily fixed. Add the necessary explicit includes and
remove unnecessary includes and other parts from prom.h

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au
Cc: netdev@vger.kernel.org
---
 arch/microblaze/include/asm/prom.h          | 28 +---------------------------
 arch/microblaze/kernel/prom.c               |  1 +
 arch/microblaze/kernel/setup.c              |  1 +
 arch/microblaze/kernel/timer.c              |  1 +
 arch/microblaze/pci/pci-common.c            |  1 +
 drivers/net/ethernet/xilinx/ll_temac_main.c |  1 +
 6 files changed, 6 insertions(+), 27 deletions(-)

diff --git a/arch/microblaze/include/asm/prom.h b/arch/microblaze/include/asm/prom.h
index 9977816..f05bedc 100644
--- a/arch/microblaze/include/asm/prom.h
+++ b/arch/microblaze/include/asm/prom.h
@@ -11,17 +11,10 @@
  * as published by the Free Software Foundation; either version
  * 2 of the License, or (at your option) any later version.
  */
-
-#include <linux/of.h>	/* linux/of.h gets to determine #include ordering */
-
 #ifndef _ASM_MICROBLAZE_PROM_H
 #define _ASM_MICROBLAZE_PROM_H
-#ifdef __KERNEL__
-#ifndef __ASSEMBLY__
 
-#include <linux/types.h>
-#include <asm/irq.h>
-#include <linux/atomic.h>
+#include <linux/of.h>
 
 #define HAVE_ARCH_DEVTREE_FIXUPS
 
@@ -42,23 +35,4 @@ extern unsigned long pci_address_to_pio(phys_addr_t address);
 #define pci_address_to_pio pci_address_to_pio
 #endif	/* CONFIG_PCI */
 
-/* Parse the ibm,dma-window property of an OF node into the busno, phys and
- * size parameters.
- */
-void of_parse_dma_window(struct device_node *dn, const void *dma_window_prop,
-		unsigned long *busno, unsigned long *phys, unsigned long *size);
-
-extern void kdump_move_device_tree(void);
-
-#endif /* __ASSEMBLY__ */
-#endif /* __KERNEL__ */
-
-/* These includes are put at the bottom because they may contain things
- * that are overridden by this file.  Ideally they shouldn't be included
- * by this file, but there are a bunch of .c files that currently depend
- * on it.  Eventually they will be cleaned up. */
-#include <linux/of_fdt.h>
-#include <linux/of_irq.h>
-#include <linux/platform_device.h>
-
 #endif /* _ASM_MICROBLAZE_PROM_H */
diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
index 0c4453f..8118f03 100644
--- a/arch/microblaze/kernel/prom.c
+++ b/arch/microblaze/kernel/prom.c
@@ -30,6 +30,7 @@
 #include <linux/debugfs.h>
 #include <linux/irq.h>
 #include <linux/memblock.h>
+#include <linux/of_fdt.h>
 
 #include <asm/prom.h>
 #include <asm/page.h>
diff --git a/arch/microblaze/kernel/setup.c b/arch/microblaze/kernel/setup.c
index 0775e03..15b4ab1 100644
--- a/arch/microblaze/kernel/setup.c
+++ b/arch/microblaze/kernel/setup.c
@@ -16,6 +16,7 @@
 #include <linux/initrd.h>
 #include <linux/console.h>
 #include <linux/debugfs.h>
+#include <linux/of_fdt.h>
 
 #include <asm/setup.h>
 #include <asm/sections.h>
diff --git a/arch/microblaze/kernel/timer.c b/arch/microblaze/kernel/timer.c
index e4b3f33..827df4d 100644
--- a/arch/microblaze/kernel/timer.c
+++ b/arch/microblaze/kernel/timer.c
@@ -15,6 +15,7 @@
 #include <linux/clk.h>
 #include <linux/clockchips.h>
 #include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <asm/cpuinfo.h>
 #include <linux/cnt32_to_63.h>
 
diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index 1b93bf0..7c8a352 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -29,6 +29,7 @@
 #include <linux/slab.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <linux/of_pci.h>
 #include <linux/export.h>
 
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index b88121f..22478d5 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -36,6 +36,7 @@
 #include <linux/netdevice.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/of_irq.h>
 #include <linux/of_mdio.h>
 #include <linux/of_platform.h>
 #include <linux/of_address.h>
-- 
1.8.1.2

