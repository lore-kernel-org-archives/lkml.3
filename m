Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbbATDL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:11:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:10059 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbbATDLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:11:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="442529630"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Dimitri Sivanich <sivanich@sgi.com>,
        x86@kernel.org, Joerg Roedel <joro@8bytes.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        iommu@lists.linux-foundation.org
Subject: [Patch Part1 v7 28/38] irq_remapping: Kill unused function irq_remapping_print_chip()
Date: Tue, 20 Jan 2015 11:08:31 +0800
Message-Id: <1421723321-8386-29-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now there's no user of irq_remapping_print_chip(), so kill it.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/irq_remapping.h |    2 --
 drivers/iommu/irq_remapping.c        |   13 -------------
 2 files changed, 15 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 79f1a84e6a85..5622a4fc7cd6 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -59,7 +59,6 @@ extern struct irq_domain *
 irq_remapping_get_ir_irq_domain( struct irq_alloc_info *info);
 extern struct irq_domain *
 irq_remapping_get_irq_domain(struct irq_alloc_info *info);
-extern void irq_remapping_print_chip(struct irq_data *data, struct seq_file *p);
 
 /* Create PCI MSI/MSIx irqdomain, use @parent as the parent irqdomain. */
 extern struct irq_domain *arch_create_msi_irq_domain(struct irq_domain *parent);
@@ -115,6 +114,5 @@ irq_remapping_get_irq_domain(struct irq_alloc_info *info)
 	return NULL;
 }
 
-#define	irq_remapping_print_chip	NULL
 #endif /* CONFIG_IRQ_REMAP */
 #endif /* __X86_IRQ_REMAPPING_H */
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 3eaa822c30a9..558c804dbe11 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -204,19 +204,6 @@ static void ir_ack_apic_level(struct irq_data *data)
 	eoi_ioapic_irq(data->irq, irqd_cfg(data));
 }
 
-void irq_remapping_print_chip(struct irq_data *data, struct seq_file *p)
-{
-	/*
-	 * Assume interrupt is remapped if the parent irqdomain isn't the
-	 * vector domain, which is true for MSI, HPET and IOAPIC on x86
-	 * platforms.
-	 */
-	if (data->domain && data->domain->parent != arch_get_ir_parent_domain())
-		seq_printf(p, " IR-%s", data->chip->name);
-	else
-		seq_printf(p, " %s", data->chip->name);
-}
-
 static void ir_print_prefix(struct irq_data *data, struct seq_file *p)
 {
 	seq_printf(p, " IR-%s", data->chip->name);
-- 
1.7.10.4

