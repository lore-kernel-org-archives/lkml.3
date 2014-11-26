Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbaKZXSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:18:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58863 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbaKZXSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:18:18 -0500
Date: Wed, 26 Nov 2014 15:17:22 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-f505e06c6e0926999e3cdd4be496bb394ecb6dfd@git.kernel.org>
Cc: bp@alien8.de, rjw@rjwysocki.net, mingo@kernel.org, konrad.wilk@oracle.com,
        yinghai@kernel.org, gregkh@linuxfoundation.org,
        jiang.liu@linux.intel.com, rdunlap@infradead.org, hpa@zytor.com,
        joro@8bytes.org, bhelgaas@google.com, tony.luck@intel.com,
        jroedel@suse.de, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, tglx@linutronix.de
Reply-To: rjw@rjwysocki.net, bp@alien8.de, mingo@kernel.org,
        yinghai@kernel.org, konrad.wilk@oracle.com, jiang.liu@linux.intel.com,
        gregkh@linuxfoundation.org, rdunlap@infradead.org, hpa@zytor.com,
        joro@8bytes.org, bhelgaas@google.com, tony.luck@intel.com,
        jroedel@suse.de, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, tglx@linutronix.de
In-Reply-To: <1416901802-24211-19-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-19-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: irq_remapping: Clean up unsued code
Git-Commit-ID: f505e06c6e0926999e3cdd4be496bb394ecb6dfd
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

Commit-ID:  f505e06c6e0926999e3cdd4be496bb394ecb6dfd
Gitweb:     http://git.kernel.org/tip/f505e06c6e0926999e3cdd4be496bb394ecb6dfd
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:42 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:47 +0100

x86: irq_remapping: Clean up unsued code

Now we have converted to hierarchy irqdomain, so clean up unused code.

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
Link: http://lkml.kernel.org/r/1416901802-24211-19-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/irq_remapping.h | 23 -----------------------
 arch/x86/kernel/apic/vector.c        |  1 -
 drivers/iommu/irq_remapping.c        | 36 ------------------------------------
 3 files changed, 60 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index de8470b..6ba2431 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -26,12 +26,7 @@
 #include <asm/hw_irq.h>
 #include <asm/io_apic.h>
 
-struct IO_APIC_route_entry;
-struct io_apic_irq_attr;
-struct irq_chip;
 struct msi_msg;
-struct pci_dev;
-struct irq_cfg;
 struct irq_alloc_info;
 
 #ifdef CONFIG_IRQ_REMAP
@@ -44,13 +39,7 @@ extern int irq_remapping_enable(void);
 extern void irq_remapping_disable(void);
 extern int irq_remapping_reenable(int);
 extern int irq_remap_enable_fault_handling(void);
-extern void free_remapped_irq(int irq);
 extern void panic_if_irq_remap(const char *msg);
-extern bool setup_remapped_irq(int irq,
-			       struct irq_cfg *cfg,
-			       struct irq_chip *chip);
-
-void irq_remap_modify_chip_defaults(struct irq_chip *chip);
 
 extern struct irq_domain *
 irq_remapping_get_ir_irq_domain( struct irq_alloc_info *info);
@@ -77,23 +66,11 @@ static inline int irq_remapping_enable(void) { return -ENODEV; }
 static inline void irq_remapping_disable(void) { }
 static inline int irq_remapping_reenable(int eim) { return -ENODEV; }
 static inline int irq_remap_enable_fault_handling(void) { return -ENODEV; }
-static inline void free_remapped_irq(int irq) { }
 
 static inline void panic_if_irq_remap(const char *msg)
 {
 }
 
-static inline void irq_remap_modify_chip_defaults(struct irq_chip *chip)
-{
-}
-
-static inline bool setup_remapped_irq(int irq,
-				      struct irq_cfg *cfg,
-				      struct irq_chip *chip)
-{
-	return false;
-}
-
 static inline struct irq_domain *
 irq_remapping_get_ir_irq_domain(struct irq_alloc_info *info)
 {
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 31dc4a8..ca30365 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -283,7 +283,6 @@ static void x86_vector_free_irqs(struct irq_domain *domain,
 	for (i = 0; i < nr_irqs; i++) {
 		irq_data = irq_domain_get_irq_data(x86_vector_domain, virq + i);
 		if (irq_data && irq_data->chip_data) {
-			free_remapped_irq(virq);
 			clear_irq_vector(virq + i, irq_data->chip_data);
 			free_irq_cfg(irq_data->chip_data);
 #ifdef	CONFIG_X86_IO_APIC
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index d175d69..3c3da04d 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -26,11 +26,6 @@ int no_x2apic_optout;
 
 static struct irq_remap_ops *remap_ops;
 
-static bool irq_remapped(struct irq_cfg *cfg)
-{
-	return (cfg->remapped == 1);
-}
-
 static void irq_remapping_disable_io_apic(void)
 {
 	/*
@@ -160,17 +155,6 @@ int __init irq_remap_enable_fault_handling(void)
 	return remap_ops->enable_faulting();
 }
 
-void free_remapped_irq(int irq)
-{
-	struct irq_cfg *cfg = irq_cfg(irq);
-
-	if (!remap_ops || !remap_ops->free_irq)
-		return;
-
-	if (irq_remapped(cfg))
-		remap_ops->free_irq(irq);
-}
-
 void panic_if_irq_remap(const char *msg)
 {
 	if (irq_remapping_enabled)
@@ -195,26 +179,6 @@ void irq_remapping_print_chip(struct irq_data *data, struct seq_file *p)
 		seq_printf(p, " %s", data->chip->name);
 }
 
-static void ir_print_prefix(struct irq_data *data, struct seq_file *p)
-{
-	seq_printf(p, " IR-%s", data->chip->name);
-}
-
-void irq_remap_modify_chip_defaults(struct irq_chip *chip)
-{
-	chip->irq_print_chip = ir_print_prefix;
-	chip->irq_ack = ir_ack_apic_edge;
-}
-
-bool setup_remapped_irq(int irq, struct irq_cfg *cfg, struct irq_chip *chip)
-{
-	if (!irq_remapped(cfg))
-		return false;
-	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-	irq_remap_modify_chip_defaults(chip);
-	return true;
-}
-
 /**
  * irq_remapping_get_ir_irq_domain - Get the irqdomain associated with the IOMMU
  *				     device serving request @info
