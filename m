Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbaKZXLD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:11:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58357 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbaKZXLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:11:00 -0500
Date: Wed, 26 Nov 2014 15:10:04 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-bd3f1972356fc17e25f9cc98a94efe5d3535c831@git.kernel.org>
Cc: bp@alien8.de, wangyijing@huawei.com, joro@8bytes.org, tglx@linutronix.de,
        rafael.j.wysocki@intel.com, rdunlap@infradead.org,
        benh@kernel.crashing.org, hpa@zytor.com, gregkh@linuxfoundation.org,
        rjw@rjwysocki.net, jiang.liu@linux.intel.com, tony.luck@intel.com,
        konrad.wilk@oracle.com, mingo@kernel.org, bhelgaas@google.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org
Reply-To: rjw@rjwysocki.net, hpa@zytor.com, gregkh@linuxfoundation.org,
        tglx@linutronix.de, rafael.j.wysocki@intel.com, rdunlap@infradead.org,
        benh@kernel.crashing.org, bp@alien8.de, wangyijing@huawei.com,
        joro@8bytes.org, linux-kernel@vger.kernel.org, yinghai@kernel.org,
        bhelgaas@google.com, mingo@kernel.org, tony.luck@intel.com,
        jiang.liu@linux.intel.com, konrad.wilk@oracle.com
In-Reply-To: <1416894816-23245-18-git-send-email-jiang.liu@linux.intel.com>
References: <1416894816-23245-18-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: irq_remapping:
  Clean up unused MSI related code
Git-Commit-ID: bd3f1972356fc17e25f9cc98a94efe5d3535c831
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bd3f1972356fc17e25f9cc98a94efe5d3535c831
Gitweb:     http://git.kernel.org/tip/bd3f1972356fc17e25f9cc98a94efe5d3535c831
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 13:53:26 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 18:59:25 +0100

x86: irq_remapping: Clean up unused MSI related code

Now MSI interrupt has been converted to new hierarchy irqdomain
interfaces, so kill legacy MSI related code and interfaces.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: iommu@lists.linux-foundation.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Yijing Wang <wangyijing@huawei.com>
Link: http://lkml.kernel.org/r/1416894816-23245-18-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/irq_remapping.h |  13 ---
 arch/x86/include/asm/pci.h           |   5 --
 arch/x86/kernel/x86_init.c           |   2 -
 drivers/iommu/irq_remapping.c        | 151 -----------------------------------
 drivers/iommu/irq_remapping.h        |  14 ----
 5 files changed, 185 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 3b11f5a..9c39650 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -50,10 +50,6 @@ extern int setup_ioapic_remapped_entry(int irq,
 				       int vector,
 				       struct io_apic_irq_attr *attr);
 extern void free_remapped_irq(int irq);
-extern void compose_remapped_msi_msg(struct pci_dev *pdev,
-				     unsigned int irq, unsigned int dest,
-				     struct msi_msg *msg, u8 hpet_id);
-extern int setup_hpet_msi_remapped(unsigned int irq, unsigned int id);
 extern void panic_if_irq_remap(const char *msg);
 extern bool setup_remapped_irq(int irq,
 			       struct irq_cfg *cfg,
@@ -95,15 +91,6 @@ static inline int setup_ioapic_remapped_entry(int irq,
 	return -ENODEV;
 }
 static inline void free_remapped_irq(int irq) { }
-static inline void compose_remapped_msi_msg(struct pci_dev *pdev,
-					    unsigned int irq, unsigned int dest,
-					    struct msi_msg *msg, u8 hpet_id)
-{
-}
-static inline int setup_hpet_msi_remapped(unsigned int irq, unsigned int id)
-{
-	return -ENODEV;
-}
 
 static inline void panic_if_irq_remap(const char *msg)
 {
diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index 4e370a5..d8c80ff 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -96,15 +96,10 @@ extern void pci_iommu_alloc(void);
 #ifdef CONFIG_PCI_MSI
 /* implemented in arch/x86/kernel/apic/io_apic. */
 struct msi_desc;
-void native_compose_msi_msg(struct pci_dev *pdev, unsigned int irq,
-			    unsigned int dest, struct msi_msg *msg, u8 hpet_id);
 int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
 void native_teardown_msi_irq(unsigned int irq);
 void native_restore_msi_irqs(struct pci_dev *dev);
-int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
-		  unsigned int irq_base, unsigned int irq_offset);
 #else
-#define native_compose_msi_msg		NULL
 #define native_setup_msi_irqs		NULL
 #define native_teardown_msi_irq		NULL
 #endif
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 234b072..b094d69 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -111,11 +111,9 @@ EXPORT_SYMBOL_GPL(x86_platform);
 #if defined(CONFIG_PCI_MSI)
 struct x86_msi_ops x86_msi = {
 	.setup_msi_irqs		= native_setup_msi_irqs,
-	.compose_msi_msg	= native_compose_msi_msg,
 	.teardown_msi_irq	= native_teardown_msi_irq,
 	.teardown_msi_irqs	= default_teardown_msi_irqs,
 	.restore_msi_irqs	= default_restore_msi_irqs,
-	.setup_hpet_msi		= default_setup_hpet_msi,
 };
 
 /* MSI arch specific hooks */
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 6ec0099..7ece17e 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -26,9 +26,6 @@ int no_x2apic_optout;
 
 static struct irq_remap_ops *remap_ops;
 
-static int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec);
-static int msi_setup_remapped_irq(struct pci_dev *pdev, unsigned int irq,
-				  int index, int sub_handle);
 static int set_remapped_irq_affinity(struct irq_data *data,
 				     const struct cpumask *mask,
 				     bool force);
@@ -51,109 +48,6 @@ static void irq_remapping_disable_io_apic(void)
 		disconnect_bsp_APIC(0);
 }
 
-#ifndef CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
-static unsigned int irq_alloc_hwirqs(int cnt, int node)
-{
-	return irq_domain_alloc_irqs(NULL, -1, cnt, node, NULL);
-}
-
-static void irq_free_hwirqs(unsigned int from, int cnt)
-{
-	irq_domain_free_irqs(from, cnt);
-}
-#endif
-
-static int do_setup_msi_irqs(struct pci_dev *dev, int nvec)
-{
-	int ret, sub_handle, nvec_pow2, index = 0;
-	unsigned int irq;
-	struct msi_desc *msidesc;
-
-	msidesc = list_entry(dev->msi_list.next, struct msi_desc, list);
-
-	irq = irq_alloc_hwirqs(nvec, dev_to_node(&dev->dev));
-	if (irq == 0)
-		return -ENOSPC;
-
-	nvec_pow2 = __roundup_pow_of_two(nvec);
-	for (sub_handle = 0; sub_handle < nvec; sub_handle++) {
-		if (!sub_handle) {
-			index = msi_alloc_remapped_irq(dev, irq, nvec_pow2);
-			if (index < 0) {
-				ret = index;
-				goto error;
-			}
-		} else {
-			ret = msi_setup_remapped_irq(dev, irq + sub_handle,
-						     index, sub_handle);
-			if (ret < 0)
-				goto error;
-		}
-		ret = setup_msi_irq(dev, msidesc, irq, sub_handle);
-		if (ret < 0)
-			goto error;
-	}
-	return 0;
-
-error:
-	irq_free_hwirqs(irq, nvec);
-
-	/*
-	 * Restore altered MSI descriptor fields and prevent just destroyed
-	 * IRQs from tearing down again in default_teardown_msi_irqs()
-	 */
-	msidesc->irq = 0;
-
-	return ret;
-}
-
-static int do_setup_msix_irqs(struct pci_dev *dev, int nvec)
-{
-	int node, ret, sub_handle, index = 0;
-	struct msi_desc *msidesc;
-	unsigned int irq;
-
-	node		= dev_to_node(&dev->dev);
-	sub_handle	= 0;
-
-	list_for_each_entry(msidesc, &dev->msi_list, list) {
-
-		irq = irq_alloc_hwirqs(1, node);
-		if (irq == 0)
-			return -1;
-
-		if (sub_handle == 0)
-			ret = index = msi_alloc_remapped_irq(dev, irq, nvec);
-		else
-			ret = msi_setup_remapped_irq(dev, irq, index, sub_handle);
-
-		if (ret < 0)
-			goto error;
-
-		ret = setup_msi_irq(dev, msidesc, irq, 0);
-		if (ret < 0)
-			goto error;
-
-		sub_handle += 1;
-		irq        += 1;
-	}
-
-	return 0;
-
-error:
-	irq_free_hwirqs(irq, 1);
-	return ret;
-}
-
-static int irq_remapping_setup_msi_irqs(struct pci_dev *dev,
-					int nvec, int type)
-{
-	if (type == PCI_CAP_ID_MSI)
-		return do_setup_msi_irqs(dev, nvec);
-	else
-		return do_setup_msix_irqs(dev, nvec);
-}
-
 static void eoi_ioapic_pin_remapped(int apic, int pin, int vector)
 {
 	/*
@@ -171,8 +65,6 @@ static void __init irq_remapping_modify_x86_ops(void)
 	x86_io_apic_ops.set_affinity	= set_remapped_irq_affinity;
 	x86_io_apic_ops.setup_entry	= setup_ioapic_remapped_entry;
 	x86_io_apic_ops.eoi_ioapic_pin	= eoi_ioapic_pin_remapped;
-	x86_msi.setup_hpet_msi		= setup_hpet_msi_remapped;
-	x86_msi.compose_msi_msg		= compose_remapped_msi_msg;
 }
 
 static __init int setup_nointremap(char *str)
@@ -319,49 +211,6 @@ void free_remapped_irq(int irq)
 		remap_ops->free_irq(irq);
 }
 
-void compose_remapped_msi_msg(struct pci_dev *pdev,
-			      unsigned int irq, unsigned int dest,
-			      struct msi_msg *msg, u8 hpet_id)
-{
-	struct irq_cfg *cfg = irq_cfg(irq);
-
-	if (!irq_remapped(cfg))
-		native_compose_msi_msg(pdev, irq, dest, msg, hpet_id);
-	else if (remap_ops && remap_ops->compose_msi_msg)
-		remap_ops->compose_msi_msg(pdev, irq, dest, msg, hpet_id);
-}
-
-static int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec)
-{
-	if (!remap_ops || !remap_ops->msi_alloc_irq)
-		return -ENODEV;
-
-	return remap_ops->msi_alloc_irq(pdev, irq, nvec);
-}
-
-static int msi_setup_remapped_irq(struct pci_dev *pdev, unsigned int irq,
-				  int index, int sub_handle)
-{
-	if (!remap_ops || !remap_ops->msi_setup_irq)
-		return -ENODEV;
-
-	return remap_ops->msi_setup_irq(pdev, irq, index, sub_handle);
-}
-
-int setup_hpet_msi_remapped(unsigned int irq, unsigned int id)
-{
-	int ret;
-
-	if (!remap_ops || !remap_ops->alloc_hpet_msi)
-		return -ENODEV;
-
-	ret = remap_ops->alloc_hpet_msi(irq, id);
-	if (ret)
-		return -EINVAL;
-
-	return default_setup_hpet_msi(irq, id);
-}
-
 void panic_if_irq_remap(const char *msg)
 {
 	if (irq_remapping_enabled)
diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
index 8c159d6..95b19a6 100644
--- a/drivers/iommu/irq_remapping.h
+++ b/drivers/iommu/irq_remapping.h
@@ -70,20 +70,6 @@ struct irq_remap_ops {
 	/* Free an IRQ */
 	int (*free_irq)(int);
 
-	/* Create MSI msg to use for interrupt remapping */
-	void (*compose_msi_msg)(struct pci_dev *,
-				unsigned int, unsigned int,
-				struct msi_msg *, u8);
-
-	/* Allocate remapping resources for MSI */
-	int (*msi_alloc_irq)(struct pci_dev *, int, int);
-
-	/* Setup the remapped MSI irq */
-	int (*msi_setup_irq)(struct pci_dev *, unsigned int, int, int);
-
-	/* Setup interrupt remapping for an HPET MSI */
-	int (*alloc_hpet_msi)(unsigned int, unsigned int);
-
 	/* Get the irqdomain associated the IOMMU device */
 	struct irq_domain *(*get_ir_irq_domain)(struct irq_alloc_info *);
 
