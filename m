Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713Ab3IBPZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 11:25:26 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:34317 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab3IBPZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 11:25:25 -0400
From: Valentin Ilie <valentin.ilie@gmail.com>
To: linux@arm.linux.org.uk
Cc: swarren@nvidia.com, rmk+kernel@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Valentin Ilie <valentin.ilie@gmail.com>
Subject: [PATCH] ARM: mach-iop32x: iq31244: Replace if-then-else with a switch statement
Date: Mon,  2 Sep 2013 18:23:14 +0300
Message-Id: <1378135394-31092-1-git-send-email-valentin.ilie@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert a compound if-else blob to a switch statement.

Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
---
 arch/arm/mach-iop32x/iq31244.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/arch/arm/mach-iop32x/iq31244.c b/arch/arm/mach-iop32x/iq31244.c
index f2cd296..3415f11 100644
--- a/arch/arm/mach-iop32x/iq31244.c
+++ b/arch/arm/mach-iop32x/iq31244.c
@@ -101,28 +101,21 @@ void __init iq31244_map_io(void)
 static int __init
 ep80219_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
-	int irq;
-
-	if (slot == 0) {
-		/* CFlash */
-		irq = IRQ_IOP32X_XINT1;
-	} else if (slot == 1) {
-		/* 82551 Pro 100 */
-		irq = IRQ_IOP32X_XINT0;
-	} else if (slot == 2) {
-		/* PCI-X Slot */
-		irq = IRQ_IOP32X_XINT3;
-	} else if (slot == 3) {
-		/* SATA */
-		irq = IRQ_IOP32X_XINT2;
-	} else {
+	switch (slot) {
+	case 0: /* CFlash */
+		return IRQ_IOP32X_XINT1;
+	case 1: /* 82551 Pro 100 */
+		return IRQ_IOP32X_XINT0;
+	case 2: /* PCI-X Slot */
+		return IRQ_IOP32X_XINT3;
+	case 3: /* SATA */
+		return IRQ_IOP32X_XINT2;
+	default:
 		printk(KERN_ERR "ep80219_pci_map_irq() called for unknown "
 			"device PCI:%d:%d:%d\n", dev->bus->number,
 			PCI_SLOT(dev->devfn), PCI_FUNC(dev->devfn));
-		irq = -1;
+		return -1;
 	}
-
-	return irq;
 }
 
 static struct hw_pci ep80219_pci __initdata = {
-- 
1.8.1.2

