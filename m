Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbaFIIS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:18:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:2900 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021AbaFIISw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:18:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352320007"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Jiri Kosina <trivial@kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: [Patch V4 10/42] x86, irq, trivial: minor improvements of IRQ related code
Date: Mon,  9 Jun 2014 16:19:39 +0800
Message-Id: <1402302011-23642-11-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) Kill unused MAX_HARDIRQS_PER_CPU.
2) Improve function prototype declararions.
3) Simple typo fix, change "gsit" to "gsi".
4) Use macro VECTOR_UNDEFINED instead of hard-coded -1.
5) Kill redundant comments.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/hardirq.h |    3 ---
 arch/x86/include/asm/io_apic.h |   16 +++++++---------
 arch/x86/kernel/apic/io_apic.c |   21 +++++----------------
 3 files changed, 12 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 230853da4ec0..0f5fb6b6567e 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -40,9 +40,6 @@ typedef struct {
 
 DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
 
-/* We can have at most NR_VECTORS irqs routed to a cpu at a time */
-#define MAX_HARDIRQS_PER_CPU NR_VECTORS
-
 #define __ARCH_IRQ_STAT
 
 #define inc_irq_stat(member)	this_cpu_inc(irq_stat.member)
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 9121abbc8c8f..8dd1e13f2989 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -144,22 +144,20 @@ struct io_apic_irq_attr;
 struct irq_cfg;
 extern int io_apic_set_pci_routing(struct device *dev, int irq,
 		 struct io_apic_irq_attr *irq_attr);
-void setup_IO_APIC_irq_extra(u32 gsi);
+extern void setup_IO_APIC_irq_extra(u32 gsi);
 extern void ioapic_insert_resources(void);
 
 extern int native_setup_ioapic_entry(int, struct IO_APIC_route_entry *,
 				     unsigned int, int,
 				     struct io_apic_irq_attr *);
-extern int native_setup_ioapic_entry(int, struct IO_APIC_route_entry *,
-				     unsigned int, int,
-				     struct io_apic_irq_attr *);
 extern void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg);
 
 extern void native_compose_msi_msg(struct pci_dev *pdev,
 				   unsigned int irq, unsigned int dest,
 				   struct msi_msg *msg, u8 hpet_id);
 extern void native_eoi_ioapic_pin(int apic, int pin, int vector);
-int io_apic_setup_irq_pin_once(unsigned int irq, int node, struct io_apic_irq_attr *attr);
+extern int io_apic_setup_irq_pin_once(unsigned int irq, int node,
+				      struct io_apic_irq_attr *attr);
 
 extern int save_ioapic_entries(void);
 extern void mask_ioapic_entries(void);
@@ -172,11 +170,11 @@ struct mp_ioapic_gsi{
 	u32 gsi_base;
 	u32 gsi_end;
 };
-extern struct mp_ioapic_gsi  mp_gsi_routing[];
 extern u32 gsi_top;
-int mp_find_ioapic(u32 gsi);
-int mp_find_ioapic_pin(int ioapic, u32 gsi);
-void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
+
+extern int mp_find_ioapic(u32 gsi);
+extern int mp_find_ioapic_pin(int ioapic, u32 gsi);
+extern void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
 extern void __init pre_init_apic_IRQ0(void);
 
 extern void mp_save_irq(struct mpc_intsrc *m);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 2de992501a1b..d4aba16e6bbf 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1010,7 +1010,7 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 				break;
 
 		if (!test_bit(lbus, mp_bus_not_pci) &&
-		    !mp_irqs[i].irqtype &&
+		    mp_irqs[i].irqtype == mp_INT &&
 		    (bus == lbus) &&
 		    (slot == ((mp_irqs[i].srcbusirq >> 2) & 0x1f))) {
 			int irq = pin_2_irq(i, ioapic_idx, mp_irqs[i].dstirq);
@@ -1359,7 +1359,7 @@ static void __init __io_apic_setup_irqs(unsigned int ioapic_idx)
 
 		irq = pin_2_irq(idx, ioapic_idx, pin);
 
-		if ((ioapic_idx > 0) && (irq > 16))
+		if ((ioapic_idx > 0) && (irq > NR_IRQS_LEGACY))
 			continue;
 
 		/*
@@ -1388,7 +1388,7 @@ static void __init setup_IO_APIC_irqs(void)
 }
 
 /*
- * for the gsit that is not in first ioapic
+ * for the gsi that is not in first ioapic
  * but could not use acpi_register_gsi()
  * like some special sci in IBM x3330
  */
@@ -2225,7 +2225,7 @@ asmlinkage __visible void smp_irq_move_cleanup_interrupt(void)
 			apic->send_IPI_self(IRQ_MOVE_CLEANUP_VECTOR);
 			goto unlock;
 		}
-		__this_cpu_write(vector_irq[vector], -1);
+		__this_cpu_write(vector_irq[vector], VECTOR_UNDEFINED);
 unlock:
 		raw_spin_unlock(&desc->lock);
 	}
@@ -2514,17 +2514,6 @@ static inline void init_IO_APIC_traps(void)
 	struct irq_cfg *cfg;
 	unsigned int irq;
 
-	/*
-	 * NOTE! The local APIC isn't very good at handling
-	 * multiple interrupts at the same interrupt level.
-	 * As the interrupt level is determined by taking the
-	 * vector number and shifting that right by 4, we
-	 * want to spread these out a bit so that they don't
-	 * all fall in the same interrupt level.
-	 *
-	 * Also, we've got to be careful not to trash gate
-	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
-	 */
 	for_each_active_irq(irq) {
 		cfg = irq_get_chip_data(irq);
 		if (IO_APIC_IRQ(irq) && cfg && !cfg->vector) {
@@ -3546,7 +3535,7 @@ void __init setup_ioapic_dest(void)
 			continue;
 		irq = pin_2_irq(irq_entry, ioapic, pin);
 
-		if ((ioapic > 0) && (irq > 16))
+		if ((ioapic > 0) && (irq > NR_IRQS_LEGACY))
 			continue;
 
 		idata = irq_get_irq_data(irq);
-- 
1.7.10.4

