Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbaLJGpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 01:45:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:52430 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107AbaLJGpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 01:45:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,550,1413270000"; 
   d="scan'208";a="645283445"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [RFC Patch V1 9/9] iommu/irq_remapping: Kill unused function irq_remapping_print_chip()
Date: Wed, 10 Dec 2014 14:47:51 +0800
Message-Id: <1418194071-13785-10-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1418194071-13785-1-git-send-email-jiang.liu@linux.intel.com>
References: <1418194071-13785-1-git-send-email-jiang.liu@linux.intel.com>
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
index f2f52a8bb14e..022cb635c294 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -43,7 +43,6 @@ extern struct irq_domain *
 irq_remapping_get_ir_irq_domain( struct irq_alloc_info *info);
 extern struct irq_domain *
 irq_remapping_get_irq_domain(struct irq_alloc_info *info);
-extern void irq_remapping_print_chip(struct irq_data *data, struct seq_file *p);
 
 /* Create PCI MSI/MSIx irqdomain, use @parent as the parent irqdomain. */
 extern struct irq_domain *arch_create_msi_irq_domain(struct irq_domain *parent);
@@ -79,6 +78,5 @@ irq_remapping_get_irq_domain(struct irq_alloc_info *info)
 	return NULL;
 }
 
-#define	irq_remapping_print_chip	NULL
 #endif /* CONFIG_IRQ_REMAP */
 #endif /* __X86_IRQ_REMAPPING_H */
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index c7ef51a2555a..981f068154de 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -146,19 +146,6 @@ void ir_ack_apic_edge(struct irq_data *data)
 	ack_APIC_irq();
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
 /**
  * irq_remapping_get_ir_irq_domain - Get the irqdomain associated with the IOMMU
  *				     device serving request @info
-- 
1.7.10.4

