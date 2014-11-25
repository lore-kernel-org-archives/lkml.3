Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaKYHva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 02:51:30 -0500
Received: from mga14.intel.com ([192.55.52.115]:42685 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbaKYHv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 02:51:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,454,1413270000"; 
   d="scan'208";a="627835590"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [Patch Part3 v4 21/38] x86: irq_remapping: Clean up unused interfaces
Date: Tue, 25 Nov 2014 15:49:45 +0800
Message-Id: <1416901802-24211-22-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1416901802-24211-1-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have converted to hierarchy irqdomain, so clean up unused
interfaces.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/irq_remapping.h |   16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
index 95b19a6ef16a..4bd791d72e5e 100644
--- a/drivers/iommu/irq_remapping.h
+++ b/drivers/iommu/irq_remapping.h
@@ -24,11 +24,7 @@
 
 #ifdef CONFIG_IRQ_REMAP
 
-struct IO_APIC_route_entry;
-struct io_apic_irq_attr;
 struct irq_data;
-struct cpumask;
-struct pci_dev;
 struct msi_msg;
 struct irq_domain;
 struct irq_alloc_info;
@@ -58,18 +54,6 @@ struct irq_remap_ops {
 	/* Enable fault handling */
 	int  (*enable_faulting)(void);
 
-	/* IO-APIC setup routine */
-	int (*setup_ioapic_entry)(int irq, struct IO_APIC_route_entry *,
-				  unsigned int, int,
-				  struct io_apic_irq_attr *);
-
-	/* Set the CPU affinity of a remapped interrupt */
-	int (*set_affinity)(struct irq_data *data, const struct cpumask *mask,
-			    bool force);
-
-	/* Free an IRQ */
-	int (*free_irq)(int);
-
 	/* Get the irqdomain associated the IOMMU device */
 	struct irq_domain *(*get_ir_irq_domain)(struct irq_alloc_info *);
 
-- 
1.7.10.4

