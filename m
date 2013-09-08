Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275Ab3IHTkP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 15:40:15 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:64502 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab3IHTkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 15:40:07 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, Jonas Bonn <jonas@southpole.se>,
        linux@openrisc.net
Subject: [PATCH] openrisc: clean-up prom.h
Date: Sun,  8 Sep 2013 14:39:36 -0500
Message-Id: <1378669176-32548-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Clean-up some copy/paste declarations that are not necessary. All the
functions either don't exist or are already declared in other headers.
This is needed in preparation of of_irq.h clean-up.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: linux@lists.openrisc.net
---
This is needed as part of of_irq.h clean-up done in this patch [1].

Rob

[1] http://www.spinics.net/lists/kernel/msg1597624.html

 arch/openrisc/include/asm/prom.h | 47 ----------------------------------------
 1 file changed, 47 deletions(-)

diff --git a/arch/openrisc/include/asm/prom.h b/arch/openrisc/include/asm/prom.h
index bbb34e5..93c9980 100644
--- a/arch/openrisc/include/asm/prom.h
+++ b/arch/openrisc/include/asm/prom.h
@@ -14,56 +14,9 @@
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  */
-
-#include <linux/of.h>	/* linux/of.h gets to determine #include ordering */
-
 #ifndef _ASM_OPENRISC_PROM_H
 #define _ASM_OPENRISC_PROM_H
-#ifdef __KERNEL__
-#ifndef __ASSEMBLY__
 
-#include <linux/types.h>
-#include <asm/irq.h>
-#include <linux/irqdomain.h>
-#include <linux/atomic.h>
-#include <linux/of_irq.h>
-#include <linux/of_fdt.h>
-#include <linux/of_address.h>
-#include <linux/proc_fs.h>
-#include <linux/platform_device.h>
 #define HAVE_ARCH_DEVTREE_FIXUPS
 
-/* Other Prototypes */
-extern int early_uartlite_console(void);
-
-/* Parse the ibm,dma-window property of an OF node into the busno, phys and
- * size parameters.
- */
-void of_parse_dma_window(struct device_node *dn, const void *dma_window_prop,
-		unsigned long *busno, unsigned long *phys, unsigned long *size);
-
-extern void kdump_move_device_tree(void);
-
-/* CPU OF node matching */
-struct device_node *of_get_cpu_node(int cpu, unsigned int *thread);
-
-/* Get the MAC address */
-extern const void *of_get_mac_address(struct device_node *np);
-
-/**
- * of_irq_map_pci - Resolve the interrupt for a PCI device
- * @pdev:	the device whose interrupt is to be resolved
- * @out_irq:	structure of_irq filled by this function
- *
- * This function resolves the PCI interrupt for a given PCI device. If a
- * device-node exists for a given pci_dev, it will use normal OF tree
- * walking. If not, it will implement standard swizzling and walk up the
- * PCI tree until an device-node is found, at which point it will finish
- * resolving using the OF tree walking.
- */
-struct pci_dev;
-extern int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
-
-#endif /* __ASSEMBLY__ */
-#endif /* __KERNEL__ */
 #endif /* _ASM_OPENRISC_PROM_H */
-- 
1.8.1.2

