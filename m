Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbaKLNnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:43:11 -0500
Received: from www.linutronix.de ([62.245.132.108]:41690 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbaKLNnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:43:09 -0500
Message-Id: <20141112134120.743969747@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 12 Nov 2014 13:43:08 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [patch 11/16] PCI/MSI: Remove unnecessary braces around single
 statements
References: <20141112133941.647950773@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=pci-msi-remove-unnecessary-braces-around-single-statements.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@linux.intel.com>

Per Documentation/CodingStyle, don't use braces around single statements.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/pci/msi.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

Index: tip/drivers/pci/msi.c
===================================================================
--- tip.orig/drivers/pci/msi.c
+++ tip/drivers/pci/msi.c
@@ -244,9 +244,8 @@ void default_restore_msi_irqs(struct pci
 {
 	struct msi_desc *entry;
 
-	list_for_each_entry(entry, &dev->msi_list, list) {
+	list_for_each_entry(entry, &dev->msi_list, list)
 		default_restore_msi_irq(dev, entry->irq);
-	}
 }
 
 void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
@@ -433,9 +432,8 @@ static void __pci_restore_msix_state(str
 				PCI_MSIX_FLAGS_ENABLE | PCI_MSIX_FLAGS_MASKALL);
 
 	arch_restore_msi_irqs(dev);
-	list_for_each_entry(entry, &dev->msi_list, list) {
+	list_for_each_entry(entry, &dev->msi_list, list)
 		msix_mask_irq(entry, entry->masked);
-	}
 
 	msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_MASKALL, 0);
 }
@@ -479,9 +477,8 @@ static int populate_msi_sysfs(struct pci
 	int count = 0;
 
 	/* Determine how many msi entries we have */
-	list_for_each_entry(entry, &pdev->msi_list, list) {
+	list_for_each_entry(entry, &pdev->msi_list, list)
 		++num_msi;
-	}
 	if (!num_msi)
 		return 0;
 


