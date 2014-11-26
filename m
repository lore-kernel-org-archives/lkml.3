Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbaKZXQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:16:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58741 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbaKZXQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:16:48 -0500
Date: Wed, 26 Nov 2014 15:15:46 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-49750862a592d9a02de328f6f21ed2037b12e2af@git.kernel.org>
Cc: konrad.wilk@oracle.com, tony.luck@intel.com, mingo@kernel.org,
        grant.likely@linaro.org, hpa@zytor.com, jiang.liu@linux.intel.com,
        linux-kernel@vger.kernel.org, bhelgaas@google.com, jroedel@suse.de,
        tglx@linutronix.de, bp@alien8.de, gregkh@linuxfoundation.org,
        rdunlap@infradead.org, joro@8bytes.org, yinghai@kernel.org,
        benh@kernel.crashing.org, rjw@rjwysocki.net, wangyijing@huawei.com
Reply-To: tglx@linutronix.de, bhelgaas@google.com, jroedel@suse.de,
        bp@alien8.de, hpa@zytor.com, grant.likely@linaro.org,
        jiang.liu@linux.intel.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, tony.luck@intel.com, konrad.wilk@oracle.com,
        rjw@rjwysocki.net, wangyijing@huawei.com, joro@8bytes.org,
        benh@kernel.crashing.org, yinghai@kernel.org,
        gregkh@linuxfoundation.org, rdunlap@infradead.org
In-Reply-To: <1416901802-24211-13-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-13-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Kill x86_io_apic_ops.print_entries and related interfaces
Git-Commit-ID: 49750862a592d9a02de328f6f21ed2037b12e2af
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

Commit-ID:  49750862a592d9a02de328f6f21ed2037b12e2af
Gitweb:     http://git.kernel.org/tip/49750862a592d9a02de328f6f21ed2037b12e2af
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:36 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:47 +0100

x86, irq: Kill x86_io_apic_ops.print_entries and related interfaces

Now there is no user of x86_io_apic_ops.print_entries anymore, so kill
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
Link: http://lkml.kernel.org/r/1416901802-24211-13-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/io_apic.h      |  3 --
 arch/x86/include/asm/x86_init.h     |  1 -
 arch/x86/kernel/apic/io_apic.c      | 55 -------------------------------------
 arch/x86/kernel/x86_init.c          |  1 -
 drivers/iommu/intel_irq_remapping.c |  7 -----
 5 files changed, 67 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 3162a91f..8b4fc2d 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -225,8 +225,6 @@ extern unsigned int native_io_apic_read(unsigned int apic, unsigned int reg);
 extern void native_io_apic_write(unsigned int apic, unsigned int reg, unsigned int val);
 extern void native_io_apic_modify(unsigned int apic, unsigned int reg, unsigned int val);
 extern void native_disable_io_apic(void);
-extern void native_io_apic_print_entries(unsigned int apic, unsigned int nr_entries);
-extern void intel_ir_io_apic_print_entries(unsigned int apic, unsigned int nr_entries);
 extern int native_ioapic_set_affinity(struct irq_data *,
 				      const struct cpumask *,
 				      bool);
@@ -290,7 +288,6 @@ static inline void disable_ioapic_support(void) { }
 #define native_io_apic_write		NULL
 #define native_io_apic_modify		NULL
 #define native_disable_io_apic		NULL
-#define native_io_apic_print_entries	NULL
 #define native_ioapic_set_affinity	NULL
 #define native_setup_ioapic_entry	NULL
 #define native_eoi_ioapic_pin		NULL
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 1649bb9..2924bc8 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -191,7 +191,6 @@ struct x86_io_apic_ops {
 	void		(*write)  (unsigned int apic, unsigned int reg, unsigned int value);
 	void		(*modify) (unsigned int apic, unsigned int reg, unsigned int value);
 	void		(*disable)(void);
-	void		(*print_entries)(unsigned int apic, unsigned int nr_entries);
 	int		(*set_affinity)(struct irq_data *data,
 					const struct cpumask *mask,
 					bool force);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 551108e..42dc3ee 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1332,61 +1332,6 @@ static void __init setup_IO_APIC_irqs(void)
 	}
 }
 
-void native_io_apic_print_entries(unsigned int apic, unsigned int nr_entries)
-{
-	int i;
-
-	pr_debug(" NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:\n");
-
-	for (i = 0; i <= nr_entries; i++) {
-		struct IO_APIC_route_entry entry;
-
-		entry = ioapic_read_entry(apic, i);
-
-		pr_debug(" %02x %02X  ", i, entry.dest);
-		pr_cont("%1d    %1d    %1d   %1d   %1d    "
-			"%1d    %1d    %02X\n",
-			entry.mask,
-			entry.trigger,
-			entry.irr,
-			entry.polarity,
-			entry.delivery_status,
-			entry.dest_mode,
-			entry.delivery_mode,
-			entry.vector);
-	}
-}
-
-void intel_ir_io_apic_print_entries(unsigned int apic,
-				    unsigned int nr_entries)
-{
-	int i;
-
-	pr_debug(" NR Indx Fmt Mask Trig IRR Pol Stat Indx2 Zero Vect:\n");
-
-	for (i = 0; i <= nr_entries; i++) {
-		struct IR_IO_APIC_route_entry *ir_entry;
-		struct IO_APIC_route_entry entry;
-
-		entry = ioapic_read_entry(apic, i);
-
-		ir_entry = (struct IR_IO_APIC_route_entry *)&entry;
-
-		pr_debug(" %02x %04X ", i, ir_entry->index);
-		pr_cont("%1d   %1d    %1d    %1d   %1d   "
-			"%1d    %1d     %X    %02X\n",
-			ir_entry->format,
-			ir_entry->mask,
-			ir_entry->trigger,
-			ir_entry->irr,
-			ir_entry->polarity,
-			ir_entry->delivery_status,
-			ir_entry->index2,
-			ir_entry->zero,
-			ir_entry->vector);
-	}
-}
-
 void ioapic_zap_locks(void)
 {
 	raw_spin_lock_init(&ioapic_lock);
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index b094d69..d6f36c7 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -144,7 +144,6 @@ struct x86_io_apic_ops x86_io_apic_ops = {
 	.write			= native_io_apic_write,
 	.modify			= native_io_apic_modify,
 	.disable		= native_disable_io_apic,
-	.print_entries		= native_io_apic_print_entries,
 	.set_affinity		= native_ioapic_set_affinity,
 	.setup_entry		= native_setup_ioapic_entry,
 	.eoi_ioapic_pin		= native_eoi_ioapic_pin,
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index cb00d6b..95c4482 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -681,13 +681,6 @@ static int __init intel_enable_irq_remapping(void)
 
 	irq_remapping_enabled = 1;
 
-	/*
-	 * VT-d has a different layout for IO-APIC entries when
-	 * interrupt remapping is enabled. So it needs a special routine
-	 * to print IO-APIC entries for debugging purposes too.
-	 */
-	x86_io_apic_ops.print_entries = intel_ir_io_apic_print_entries;
-
 	pr_info("Enabled IRQ remapping in %s mode\n", eim ? "x2apic" : "xapic");
 
 	return eim ? IRQ_REMAP_X2APIC_MODE : IRQ_REMAP_XAPIC_MODE;
