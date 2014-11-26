Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbaKZXRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:17:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58761 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbaKZXRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:17:04 -0500
Date: Wed, 26 Nov 2014 15:16:02 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-4f767fa79edcf35dccf12eabd71bd1a796f471c7@git.kernel.org>
Cc: bp@alien8.de, grant.likely@linaro.org, joro@8bytes.org,
        konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        jiang.liu@linux.intel.com, benh@kernel.crashing.org,
        wangyijing@huawei.com, yinghai@kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, tony.luck@intel.com, rjw@rjwysocki.net,
        hpa@zytor.com, rdunlap@infradead.org, mingo@kernel.org,
        jroedel@suse.de, bhelgaas@google.com
Reply-To: gregkh@linuxfoundation.org, yinghai@kernel.org,
        wangyijing@huawei.com, benh@kernel.crashing.org,
        jiang.liu@linux.intel.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, joro@8bytes.org, bp@alien8.de,
        grant.likely@linaro.org, bhelgaas@google.com, rdunlap@infradead.org,
        jroedel@suse.de, mingo@kernel.org, hpa@zytor.com, rjw@rjwysocki.net,
        tony.luck@intel.com, tglx@linutronix.de
In-Reply-To: <1416901802-24211-14-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-14-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Kill x86_io_apic_ops.setup_entry and related interfaces
Git-Commit-ID: 4f767fa79edcf35dccf12eabd71bd1a796f471c7
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

Commit-ID:  4f767fa79edcf35dccf12eabd71bd1a796f471c7
Gitweb:     http://git.kernel.org/tip/4f767fa79edcf35dccf12eabd71bd1a796f471c7
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:37 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:47 +0100

x86, irq: Kill x86_io_apic_ops.setup_entry and related interfaces

Now there is no user of x86_io_apic_ops.setup_entry anymore, so kill it.

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
Cc: Yijing Wang <wangyijing@huawei.com>
Cc: Grant Likely <grant.likely@linaro.org>
Link: http://lkml.kernel.org/r/1416901802-24211-14-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/io_apic.h       |  4 ----
 arch/x86/include/asm/irq_remapping.h | 13 -------------
 arch/x86/include/asm/x86_init.h      |  3 ---
 arch/x86/kernel/apic/io_apic.c       | 24 ------------------------
 arch/x86/kernel/x86_init.c           |  1 -
 drivers/iommu/irq_remapping.c        | 13 -------------
 6 files changed, 58 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 8b4fc2d..0c66c47 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -150,9 +150,6 @@ struct irq_cfg;
 extern void ioapic_insert_resources(void);
 extern int arch_early_ioapic_init(void);
 
-extern int native_setup_ioapic_entry(int, struct IO_APIC_route_entry *,
-				     unsigned int, int,
-				     struct io_apic_irq_attr *);
 extern void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg);
 
 extern void native_eoi_ioapic_pin(int apic, int pin, int vector);
@@ -289,7 +286,6 @@ static inline void disable_ioapic_support(void) { }
 #define native_io_apic_modify		NULL
 #define native_disable_io_apic		NULL
 #define native_ioapic_set_affinity	NULL
-#define native_setup_ioapic_entry	NULL
 #define native_eoi_ioapic_pin		NULL
 #endif
 
diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 82507c5..de8470b 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -44,11 +44,6 @@ extern int irq_remapping_enable(void);
 extern void irq_remapping_disable(void);
 extern int irq_remapping_reenable(int);
 extern int irq_remap_enable_fault_handling(void);
-extern int setup_ioapic_remapped_entry(int irq,
-				       struct IO_APIC_route_entry *entry,
-				       unsigned int destination,
-				       int vector,
-				       struct io_apic_irq_attr *attr);
 extern void free_remapped_irq(int irq);
 extern void panic_if_irq_remap(const char *msg);
 extern bool setup_remapped_irq(int irq,
@@ -82,14 +77,6 @@ static inline int irq_remapping_enable(void) { return -ENODEV; }
 static inline void irq_remapping_disable(void) { }
 static inline int irq_remapping_reenable(int eim) { return -ENODEV; }
 static inline int irq_remap_enable_fault_handling(void) { return -ENODEV; }
-static inline int setup_ioapic_remapped_entry(int irq,
-					      struct IO_APIC_route_entry *entry,
-					      unsigned int destination,
-					      int vector,
-					      struct io_apic_irq_attr *attr)
-{
-	return -ENODEV;
-}
 static inline void free_remapped_irq(int irq) { }
 
 static inline void panic_if_irq_remap(const char *msg)
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 2924bc8..0c69057 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -194,9 +194,6 @@ struct x86_io_apic_ops {
 	int		(*set_affinity)(struct irq_data *data,
 					const struct cpumask *mask,
 					bool force);
-	int		(*setup_entry)(int irq, struct IO_APIC_route_entry *entry,
-				       unsigned int destination, int vector,
-				       struct io_apic_irq_attr *attr);
 	void		(*eoi_ioapic_pin)(int apic, int pin, int vector);
 };
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 42dc3ee..c862f82 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1289,30 +1289,6 @@ static inline int IO_APIC_irq_trigger(int irq)
 }
 #endif
 
-int native_setup_ioapic_entry(int irq, struct IO_APIC_route_entry *entry,
-			      unsigned int destination, int vector,
-			      struct io_apic_irq_attr *attr)
-{
-	memset(entry, 0, sizeof(*entry));
-
-	entry->delivery_mode = apic->irq_delivery_mode;
-	entry->dest_mode     = apic->irq_dest_mode;
-	entry->dest	     = destination;
-	entry->vector	     = vector;
-	entry->mask	     = 0;			/* enable IRQ */
-	entry->trigger	     = attr->trigger;
-	entry->polarity	     = attr->polarity;
-
-	/*
-	 * Mask level triggered irqs.
-	 * Use IRQ_DELAYED_DISABLE for edge triggered irqs.
-	 */
-	if (attr->trigger)
-		entry->mask = 1;
-
-	return 0;
-}
-
 static void __init setup_IO_APIC_irqs(void)
 {
 	unsigned int ioapic, pin;
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index d6f36c7..066cdaa 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -145,6 +145,5 @@ struct x86_io_apic_ops x86_io_apic_ops = {
 	.modify			= native_io_apic_modify,
 	.disable		= native_disable_io_apic,
 	.set_affinity		= native_ioapic_set_affinity,
-	.setup_entry		= native_setup_ioapic_entry,
 	.eoi_ioapic_pin		= native_eoi_ioapic_pin,
 };
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 7ece17e..5768652 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -63,7 +63,6 @@ static void __init irq_remapping_modify_x86_ops(void)
 {
 	x86_io_apic_ops.disable		= irq_remapping_disable_io_apic;
 	x86_io_apic_ops.set_affinity	= set_remapped_irq_affinity;
-	x86_io_apic_ops.setup_entry	= setup_ioapic_remapped_entry;
 	x86_io_apic_ops.eoi_ioapic_pin	= eoi_ioapic_pin_remapped;
 }
 
@@ -178,18 +177,6 @@ int __init irq_remap_enable_fault_handling(void)
 	return remap_ops->enable_faulting();
 }
 
-int setup_ioapic_remapped_entry(int irq,
-				struct IO_APIC_route_entry *entry,
-				unsigned int destination, int vector,
-				struct io_apic_irq_attr *attr)
-{
-	if (!remap_ops || !remap_ops->setup_ioapic_entry)
-		return -ENODEV;
-
-	return remap_ops->setup_ioapic_entry(irq, entry, destination,
-					     vector, attr);
-}
-
 static int set_remapped_irq_affinity(struct irq_data *data,
 				     const struct cpumask *mask, bool force)
 {
