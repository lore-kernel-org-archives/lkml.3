Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbaKZXIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:08:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58192 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbaKZXIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:08:53 -0500
Date: Wed, 26 Nov 2014 15:07:59 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-72110a7279426fd0cc544f8c8a06ec0f4129c788@git.kernel.org>
Cc: benh@kernel.crashing.org, bp@alien8.de, tony.luck@intel.com,
        rjw@rjwysocki.net, rdunlap@infradead.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com, bhelgaas@google.com,
        jiang.liu@linux.intel.com, gregkh@linuxfoundation.org,
        mingo@kernel.org, yinghai@kernel.org, jroedel@suse.de,
        konrad.wilk@oracle.com, joro@8bytes.org
Reply-To: bp@alien8.de, benh@kernel.crashing.org, rjw@rjwysocki.net,
        rdunlap@infradead.org, tony.luck@intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, bhelgaas@google.com,
        jiang.liu@linux.intel.com, gregkh@linuxfoundation.org,
        yinghai@kernel.org, mingo@kernel.org, jroedel@suse.de,
        konrad.wilk@oracle.com, joro@8bytes.org
In-Reply-To: <1416894816-23245-10-git-send-email-jiang.liu@linux.intel.com>
References: <1416894816-23245-10-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] iommu/vt-d:
  Change prototypes to prepare for enabling hierarchy irqdomain
Git-Commit-ID: 72110a7279426fd0cc544f8c8a06ec0f4129c788
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

Commit-ID:  72110a7279426fd0cc544f8c8a06ec0f4129c788
Gitweb:     http://git.kernel.org/tip/72110a7279426fd0cc544f8c8a06ec0f4129c788
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 13:53:18 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 18:59:24 +0100

iommu/vt-d: Change prototypes to prepare for enabling hierarchy irqdomain

Prepare for support hierarchy irqdomain by changing function prototypes,
should be no function changes.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Acked-by: Joerg Roedel <jroedel@suse.de>
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
Link: http://lkml.kernel.org/r/1416894816-23245-10-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/iommu/intel_irq_remapping.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index a55b207..8176b54 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -81,10 +81,10 @@ static int get_irte(int irq, struct irte *entry)
 	return 0;
 }
 
-static int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
+static int alloc_irte(struct intel_iommu *iommu, int irq,
+		      struct irq_2_iommu *irq_iommu, u16 count)
 {
 	struct ir_table *table = iommu->ir_table;
-	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
 	struct irq_cfg *cfg = irq_cfg(irq);
 	unsigned int mask = 0;
 	unsigned long flags;
@@ -172,9 +172,9 @@ static int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subha
 	return 0;
 }
 
-static int modify_irte(int irq, struct irte *irte_modified)
+static int modify_irte(struct irq_2_iommu *irq_iommu,
+		       struct irte *irte_modified)
 {
-	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
 	struct intel_iommu *iommu;
 	unsigned long flags;
 	struct irte *irte;
@@ -241,7 +241,7 @@ static int clear_entries(struct irq_2_iommu *irq_iommu)
 		return 0;
 
 	iommu = irq_iommu->iommu;
-	index = irq_iommu->irte_index + irq_iommu->sub_handle;
+	index = irq_iommu->irte_index;
 
 	start = iommu->ir_table->base + index;
 	end = start + (1 << irq_iommu->irte_mask);
@@ -979,7 +979,7 @@ static int intel_setup_ioapic_entry(int irq,
 		pr_warn("No mapping iommu for ioapic %d\n", ioapic_id);
 		index = -ENODEV;
 	} else {
-		index = alloc_irte(iommu, irq, 1);
+		index = alloc_irte(iommu, irq, irq_2_iommu(irq), 1);
 		if (index < 0) {
 			pr_warn("Failed to allocate IRTE for ioapic %d\n",
 				ioapic_id);
@@ -995,7 +995,7 @@ static int intel_setup_ioapic_entry(int irq,
 	/* Set source-id of interrupt request */
 	set_ioapic_sid(&irte, ioapic_id);
 
-	modify_irte(irq, &irte);
+	modify_irte(irq_2_iommu(irq), &irte);
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "IOAPIC[%d]: "
 		"Set IRTE entry (P:%d FPD:%d Dst_Mode:%d "
@@ -1082,7 +1082,7 @@ intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	 * Atomically updates the IRTE with the new destination, vector
 	 * and flushes the interrupt entry cache.
 	 */
-	modify_irte(irq, &irte);
+	modify_irte(irq_2_iommu(irq), &irte);
 
 	/*
 	 * After this point, all the interrupts will start arriving
@@ -1118,7 +1118,7 @@ static void intel_compose_msi_msg(struct pci_dev *pdev,
 	else
 		set_hpet_sid(&irte, hpet_id);
 
-	modify_irte(irq, &irte);
+	modify_irte(irq_2_iommu(irq), &irte);
 
 	msg->address_hi = MSI_ADDR_BASE_HI;
 	msg->data = sub_handle;
@@ -1145,7 +1145,7 @@ static int intel_msi_alloc_irq(struct pci_dev *dev, int irq, int nvec)
 		       "Unable to map PCI %s to iommu\n", pci_name(dev));
 		index = -ENOENT;
 	} else {
-		index = alloc_irte(iommu, irq, nvec);
+		index = alloc_irte(iommu, irq, irq_2_iommu(irq), nvec);
 		if (index < 0) {
 			printk(KERN_ERR
 			       "Unable to allocate %d IRTE for PCI %s\n",
@@ -1189,7 +1189,7 @@ static int intel_alloc_hpet_msi(unsigned int irq, unsigned int id)
 	down_read(&dmar_global_lock);
 	iommu = map_hpet_to_ir(id);
 	if (iommu) {
-		index = alloc_irte(iommu, irq, 1);
+		index = alloc_irte(iommu, irq, irq_2_iommu(irq), 1);
 		if (index >= 0)
 			ret = 0;
 	}
