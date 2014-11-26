Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbaKZXY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:24:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58937 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbaKZXS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:18:58 -0500
Date: Wed, 26 Nov 2014 15:18:07 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-f67c81a69eb96be3e1679785764a3df9bc1c5502@git.kernel.org>
Cc: yinghai@kernel.org, benh@kernel.crashing.org, bhelgaas@google.com,
        bp@alien8.de, rjw@rjwysocki.net, joro@8bytes.org,
        rdunlap@infradead.org, tglx@linutronix.de, tony.luck@intel.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, jiang.liu@linux.intel.com, jroedel@suse.de,
        konrad.wilk@oracle.com, mingo@kernel.org
Reply-To: bp@alien8.de, benh@kernel.crashing.org, bhelgaas@google.com,
        yinghai@kernel.org, jroedel@suse.de, konrad.wilk@oracle.com,
        mingo@kernel.org, jiang.liu@linux.intel.com,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, rdunlap@infradead.org, tony.luck@intel.com,
        hpa@zytor.com, rjw@rjwysocki.net, joro@8bytes.org
In-Reply-To: <1416901802-24211-22-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-22-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: irq_remapping: Clean up unused interfaces
Git-Commit-ID: f67c81a69eb96be3e1679785764a3df9bc1c5502
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

Commit-ID:  f67c81a69eb96be3e1679785764a3df9bc1c5502
Gitweb:     http://git.kernel.org/tip/f67c81a69eb96be3e1679785764a3df9bc1c5502
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:45 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:48 +0100

x86: irq_remapping: Clean up unused interfaces

Now we have converted to hierarchy irqdomain, so clean up unused
interfaces.

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
Link: http://lkml.kernel.org/r/1416901802-24211-22-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/irq_remapping.h | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
index 95b19a6..4bd791d 100644
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
 
