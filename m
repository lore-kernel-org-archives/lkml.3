Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbaKZXRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:17:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58779 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbaKZXRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:17:20 -0500
Date: Wed, 26 Nov 2014 15:16:19 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-01133ac9d02b341443eb487deff3eb50fd4b5100@git.kernel.org>
Cc: mingo@kernel.org, yinghai@kernel.org, benh@kernel.crashing.org,
        konrad.wilk@oracle.com, joro@8bytes.org, linux-kernel@vger.kernel.org,
        tony.luck@intel.com, rdunlap@infradead.org, rjw@rjwysocki.net,
        gregkh@linuxfoundation.org, tglx@linutronix.de, wangyijing@huawei.com,
        jiang.liu@linux.intel.com, hpa@zytor.com, jroedel@suse.de,
        bhelgaas@google.com, bp@alien8.de, grant.likely@linaro.org
Reply-To: gregkh@linuxfoundation.org, tglx@linutronix.de,
        wangyijing@huawei.com, hpa@zytor.com, jiang.liu@linux.intel.com,
        grant.likely@linaro.org, bp@alien8.de, jroedel@suse.de,
        bhelgaas@google.com, mingo@kernel.org, yinghai@kernel.org,
        benh@kernel.crashing.org, konrad.wilk@oracle.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, tony.luck@intel.com,
        rdunlap@infradead.org, rjw@rjwysocki.net
In-Reply-To: <1416901802-24211-15-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-15-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Kill x86_io_apic_ops.set_affinity and related interfaces
Git-Commit-ID: 01133ac9d02b341443eb487deff3eb50fd4b5100
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

Commit-ID:  01133ac9d02b341443eb487deff3eb50fd4b5100
Gitweb:     http://git.kernel.org/tip/01133ac9d02b341443eb487deff3eb50fd4b5100
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:38 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:47 +0100

x86, irq: Kill x86_io_apic_ops.set_affinity and related interfaces

Now there is no user of x86_io_apic_ops.set_affinity anymore, so kill
it.

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
Link: http://lkml.kernel.org/r/1416901802-24211-15-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/io_apic.h  |  4 ----
 arch/x86/include/asm/x86_init.h |  3 ---
 arch/x86/kernel/apic/io_apic.c  | 25 +------------------------
 arch/x86/kernel/x86_init.c      |  1 -
 drivers/iommu/irq_remapping.c   | 16 ----------------
 5 files changed, 1 insertion(+), 48 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 0c66c47..5fba350 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -222,9 +222,6 @@ extern unsigned int native_io_apic_read(unsigned int apic, unsigned int reg);
 extern void native_io_apic_write(unsigned int apic, unsigned int reg, unsigned int val);
 extern void native_io_apic_modify(unsigned int apic, unsigned int reg, unsigned int val);
 extern void native_disable_io_apic(void);
-extern int native_ioapic_set_affinity(struct irq_data *,
-				      const struct cpumask *,
-				      bool);
 
 static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
 {
@@ -285,7 +282,6 @@ static inline void disable_ioapic_support(void) { }
 #define native_io_apic_write		NULL
 #define native_io_apic_modify		NULL
 #define native_disable_io_apic		NULL
-#define native_ioapic_set_affinity	NULL
 #define native_eoi_ioapic_pin		NULL
 #endif
 
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 0c69057..f9f83cf 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -191,9 +191,6 @@ struct x86_io_apic_ops {
 	void		(*write)  (unsigned int apic, unsigned int reg, unsigned int value);
 	void		(*modify) (unsigned int apic, unsigned int reg, unsigned int value);
 	void		(*disable)(void);
-	int		(*set_affinity)(struct irq_data *data,
-					const struct cpumask *mask,
-					bool force);
 	void		(*eoi_ioapic_pin)(int apic, int pin, int vector);
 };
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index c862f82..26fa504 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1777,29 +1777,6 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq
 	}
 }
 
-int native_ioapic_set_affinity(struct irq_data *data,
-			       const struct cpumask *mask,
-			       bool force)
-{
-	unsigned int dest, irq = data->irq;
-	unsigned long flags;
-	int ret;
-
-	if (!config_enabled(CONFIG_SMP))
-		return -EPERM;
-
-	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	ret = apic_set_affinity(data, mask, &dest);
-	if (!ret) {
-		/* Only the high 8 bits are valid. */
-		dest = SET_APIC_LOGICAL_ID(dest);
-		__target_IO_APIC_irq(irq, dest, irqd_cfg(data));
-		ret = IRQ_SET_MASK_OK_NOCOPY;
-	}
-	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-	return ret;
-}
-
 atomic_t irq_mis_count;
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
@@ -2676,7 +2653,7 @@ void __init setup_ioapic_dest(void)
 		else
 			mask = apic->target_cpus();
 
-		x86_io_apic_ops.set_affinity(idata, mask, false);
+		irq_set_affinity(irq, mask);
 	}
 
 }
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 066cdaa..f7e8eab 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -144,6 +144,5 @@ struct x86_io_apic_ops x86_io_apic_ops = {
 	.write			= native_io_apic_write,
 	.modify			= native_io_apic_modify,
 	.disable		= native_disable_io_apic,
-	.set_affinity		= native_ioapic_set_affinity,
 	.eoi_ioapic_pin		= native_eoi_ioapic_pin,
 };
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 5768652..13243ac 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -26,10 +26,6 @@ int no_x2apic_optout;
 
 static struct irq_remap_ops *remap_ops;
 
-static int set_remapped_irq_affinity(struct irq_data *data,
-				     const struct cpumask *mask,
-				     bool force);
-
 static bool irq_remapped(struct irq_cfg *cfg)
 {
 	return (cfg->remapped == 1);
@@ -62,7 +58,6 @@ static void eoi_ioapic_pin_remapped(int apic, int pin, int vector)
 static void __init irq_remapping_modify_x86_ops(void)
 {
 	x86_io_apic_ops.disable		= irq_remapping_disable_io_apic;
-	x86_io_apic_ops.set_affinity	= set_remapped_irq_affinity;
 	x86_io_apic_ops.eoi_ioapic_pin	= eoi_ioapic_pin_remapped;
 }
 
@@ -177,16 +172,6 @@ int __init irq_remap_enable_fault_handling(void)
 	return remap_ops->enable_faulting();
 }
 
-static int set_remapped_irq_affinity(struct irq_data *data,
-				     const struct cpumask *mask, bool force)
-{
-	if (!config_enabled(CONFIG_SMP) || !remap_ops ||
-	    !remap_ops->set_affinity)
-		return 0;
-
-	return remap_ops->set_affinity(data, mask, force);
-}
-
 void free_remapped_irq(int irq)
 {
 	struct irq_cfg *cfg = irq_cfg(irq);
@@ -238,7 +223,6 @@ void irq_remap_modify_chip_defaults(struct irq_chip *chip)
 	chip->irq_print_chip = ir_print_prefix;
 	chip->irq_ack = ir_ack_apic_edge;
 	chip->irq_eoi = ir_ack_apic_level;
-	chip->irq_set_affinity = x86_io_apic_ops.set_affinity;
 }
 
 bool setup_remapped_irq(int irq, struct irq_cfg *cfg, struct irq_chip *chip)
