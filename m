Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbaKHSPq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:15:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:51546 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043AbaKHSPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:15:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="413533901"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [Patch Part3 v3 21/38] x86: irq_remapping: Clean up unused interfaces
Date: Sun,  9 Nov 2014 02:13:21 +0800
Message-Id: <1415470418-10874-22-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have converted to hierarchy irqdomain, so clean up unused
interfaces.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
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

