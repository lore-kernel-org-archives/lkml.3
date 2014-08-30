Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaH3MZB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 08:25:01 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:33918 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaH3MY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 08:24:59 -0400
From: matwey@sai.msu.ru
To: mohit.kumar@st.com, jg1.han@samsung.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        matwey.kornilov@gmail.com, "Matwey V. Kornilov" <matwey@sai.msu.ru>
Subject: [PATCH] Export functions from pcie-designware
Date: Sat, 30 Aug 2014 16:24:36 +0400
Message-Id: <1409401476-5002-1-git-send-email-matwey@sai.msu.ru>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Matwey V. Kornilov" <matwey@sai.msu.ru>

pcie-spear13xx when built as module requires the functions from pcie-designware.
Export them properly.

Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
---
 drivers/pci/host/pcie-designware.c |  7 +++++++
 drivers/pci/host/pcie-designware.h | 14 +++++++-------
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
index 52bd3a1..7914b92c 100644
--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -89,6 +89,7 @@ int dw_pcie_cfg_read(void __iomem *addr, int where, int size, u32 *val)
 
 	return PCIBIOS_SUCCESSFUL;
 }
+EXPORT_SYMBOL(dw_pcie_cfg_read);
 
 int dw_pcie_cfg_write(void __iomem *addr, int where, int size, u32 val)
 {
@@ -103,6 +104,7 @@ int dw_pcie_cfg_write(void __iomem *addr, int where, int size, u32 val)
 
 	return PCIBIOS_SUCCESSFUL;
 }
+EXPORT_SYMBOL(dw_pcie_cfg_write);
 
 static inline void dw_pcie_readl_rc(struct pcie_port *pp, u32 reg, u32 *val)
 {
@@ -183,6 +185,7 @@ irqreturn_t dw_handle_msi_irq(struct pcie_port *pp)
 
 	return ret;
 }
+EXPORT_SYMBOL(dw_handle_msi_irq);
 
 void dw_pcie_msi_init(struct pcie_port *pp)
 {
@@ -193,6 +196,7 @@ void dw_pcie_msi_init(struct pcie_port *pp)
 			virt_to_phys((void *)pp->msi_data));
 	dw_pcie_wr_own_conf(pp, PCIE_MSI_ADDR_HI, 4, 0);
 }
+EXPORT_SYMBOL(dw_pcie_msi_init);
 
 static int find_valid_pos0(struct pcie_port *pp, int msgvec, int pos, int *pos0)
 {
@@ -401,6 +405,7 @@ int dw_pcie_link_up(struct pcie_port *pp)
 	else
 		return 0;
 }
+EXPORT_SYMBOL(dw_pcie_link_up);
 
 static int dw_pcie_msi_map(struct irq_domain *domain, unsigned int irq,
 			irq_hw_number_t hwirq)
@@ -565,6 +570,7 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
 
 	return 0;
 }
+EXPORT_SYMBOL(dw_pcie_host_init);
 
 static void dw_pcie_prog_viewport_cfg0(struct pcie_port *pp, u32 busdev)
 {
@@ -899,6 +905,7 @@ void dw_pcie_setup_rc(struct pcie_port *pp)
 		PCI_COMMAND_MASTER | PCI_COMMAND_SERR;
 	dw_pcie_writel_rc(pp, val, PCI_COMMAND);
 }
+EXPORT_SYMBOL(dw_pcie_setup_rc);
 
 MODULE_AUTHOR("Jingoo Han <jg1.han@samsung.com>");
 MODULE_DESCRIPTION("Designware PCIe host controller driver");
diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
index daf81f9..6e4400b 100644
--- a/drivers/pci/host/pcie-designware.h
+++ b/drivers/pci/host/pcie-designware.h
@@ -76,12 +76,12 @@ struct pcie_host_ops {
 	u32 (*get_msi_data)(struct pcie_port *pp);
 };
 
-int dw_pcie_cfg_read(void __iomem *addr, int where, int size, u32 *val);
-int dw_pcie_cfg_write(void __iomem *addr, int where, int size, u32 val);
-irqreturn_t dw_handle_msi_irq(struct pcie_port *pp);
-void dw_pcie_msi_init(struct pcie_port *pp);
-int dw_pcie_link_up(struct pcie_port *pp);
-void dw_pcie_setup_rc(struct pcie_port *pp);
-int dw_pcie_host_init(struct pcie_port *pp);
+extern int dw_pcie_cfg_read(void __iomem *addr, int where, int size, u32 *val);
+extern int dw_pcie_cfg_write(void __iomem *addr, int where, int size, u32 val);
+extern irqreturn_t dw_handle_msi_irq(struct pcie_port *pp);
+extern void dw_pcie_msi_init(struct pcie_port *pp);
+extern int dw_pcie_link_up(struct pcie_port *pp);
+extern void dw_pcie_setup_rc(struct pcie_port *pp);
+extern int dw_pcie_host_init(struct pcie_port *pp);
 
 #endif /* _PCIE_DESIGNWARE_H */
-- 
1.8.1.4

