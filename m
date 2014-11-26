Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbaKZXQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:16:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58697 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbaKZXQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:16:12 -0500
Date: Wed, 26 Nov 2014 15:15:15 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-cbe4a374ef233e97b164f4efdddef5b8b0e95245@git.kernel.org>
Cc: tony.luck@intel.com, tglx@linutronix.de, bp@alien8.de, yinghai@kernel.org,
        joro@8bytes.org, mingo@kernel.org, rjw@rjwysocki.net, hpa@zytor.com,
        rdunlap@infradead.org, benh@kernel.crashing.org, jroedel@suse.de,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        jiang.liu@linux.intel.com, konrad.wilk@oracle.com,
        gregkh@linuxfoundation.org, bhelgaas@google.com
Reply-To: gregkh@linuxfoundation.org, bhelgaas@google.com,
        rdunlap@infradead.org, benh@kernel.crashing.org, jroedel@suse.de,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        jiang.liu@linux.intel.com, konrad.wilk@oracle.com, joro@8bytes.org,
        mingo@kernel.org, rjw@rjwysocki.net, hpa@zytor.com,
        tony.luck@intel.com, tglx@linutronix.de, bp@alien8.de,
        yinghai@kernel.org
In-Reply-To: <1416901802-24211-11-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-11-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Kill unused old IOAPIC irqdomain interfaces
Git-Commit-ID: cbe4a374ef233e97b164f4efdddef5b8b0e95245
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

Commit-ID:  cbe4a374ef233e97b164f4efdddef5b8b0e95245
Gitweb:     http://git.kernel.org/tip/cbe4a374ef233e97b164f4efdddef5b8b0e95245
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:34 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:47 +0100

x86, irq: Kill unused old IOAPIC irqdomain interfaces

Now we have converted to hierarchy irqdomain, so kill unused old IOAPIC
irqdomain interfaces and code.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Grant Likely <grant.likely@linaro.org>
Link: http://lkml.kernel.org/r/1416901802-24211-11-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/io_apic.h |   4 -
 arch/x86/kernel/apic/io_apic.c | 202 +----------------------------------------
 2 files changed, 1 insertion(+), 205 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 073b9c7..3162a91f 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -204,9 +204,6 @@ extern int mp_register_ioapic(int id, u32 address, u32 gsi_base,
 			      struct ioapic_domain_cfg *cfg);
 extern int mp_unregister_ioapic(u32 gsi_base);
 extern int mp_ioapic_registered(u32 gsi_base);
-extern int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
-			    irq_hw_number_t hwirq);
-extern void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq);
 extern int mp_irqdomain_alloc(struct irq_domain *domain, unsigned int virq,
 			      unsigned int nr_irqs, void *arg);
 extern void mp_irqdomain_free(struct irq_domain *domain, unsigned int virq,
@@ -218,7 +215,6 @@ extern void mp_irqdomain_deactivate(struct irq_domain *domain,
 extern int mp_irqdomain_ioapic_idx(struct irq_domain *domain);
 extern void ioapic_set_alloc_attr(struct irq_alloc_info *info,
 				  int node, int trigger, int polarity);
-extern int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node);
 
 extern void mp_save_irq(struct mpc_intsrc *m);
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 02db604..993a030 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -91,7 +91,6 @@ struct mp_chip_data {
 struct mp_pin_info {
 	int trigger;
 	int polarity;
-	int node;
 	int set;
 	u32 count;
 };
@@ -1303,30 +1302,6 @@ static inline int IO_APIC_irq_trigger(int irq)
 }
 #endif
 
-static void ioapic_register_intr(unsigned int irq, struct irq_cfg *cfg,
-				 unsigned long trigger)
-{
-	struct irq_chip *chip = &ioapic_chip;
-	irq_flow_handler_t hdl;
-	bool fasteoi;
-
-	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
-	    trigger == IOAPIC_LEVEL) {
-		irq_set_status_flags(irq, IRQ_LEVEL);
-		fasteoi = true;
-	} else {
-		irq_clear_status_flags(irq, IRQ_LEVEL);
-		fasteoi = false;
-	}
-
-	if (setup_remapped_irq(irq, cfg, chip))
-		fasteoi = trigger != 0;
-
-	hdl = fasteoi ? handle_fasteoi_irq : handle_edge_irq;
-	irq_set_chip_and_handler_name(irq, chip, hdl,
-				      fasteoi ? "fasteoi" : "edge");
-}
-
 int native_setup_ioapic_entry(int irq, struct IO_APIC_route_entry *entry,
 			      unsigned int destination, int vector,
 			      struct io_apic_irq_attr *attr)
@@ -1351,48 +1326,6 @@ int native_setup_ioapic_entry(int irq, struct IO_APIC_route_entry *entry,
 	return 0;
 }
 
-static void setup_ioapic_irq(unsigned int irq, struct irq_cfg *cfg,
-				struct io_apic_irq_attr *attr)
-{
-	struct IO_APIC_route_entry entry;
-	unsigned int dest;
-
-	if (!IO_APIC_IRQ(irq))
-		return;
-
-	if (assign_irq_vector(irq, cfg, apic->target_cpus()))
-		return;
-
-	if (apic->cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus(),
-					 &dest)) {
-		pr_warn("Failed to obtain apicid for ioapic %d, pin %d\n",
-			mpc_ioapic_id(attr->ioapic), attr->ioapic_pin);
-		clear_irq_vector(irq, cfg);
-
-		return;
-	}
-
-	apic_printk(APIC_VERBOSE,KERN_DEBUG
-		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> "
-		    "IRQ %d Mode:%i Active:%i Dest:%d)\n",
-		    attr->ioapic, mpc_ioapic_id(attr->ioapic), attr->ioapic_pin,
-		    cfg->vector, irq, attr->trigger, attr->polarity, dest);
-
-	if (x86_io_apic_ops.setup_entry(irq, &entry, dest, cfg->vector, attr)) {
-		pr_warn("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
-			mpc_ioapic_id(attr->ioapic), attr->ioapic_pin);
-		clear_irq_vector(irq, cfg);
-
-		return;
-	}
-
-	ioapic_register_intr(irq, cfg, attr->trigger);
-	if (irq < nr_legacy_irqs())
-		legacy_pic->mask(irq);
-
-	ioapic_write_entry(attr->ioapic, attr->ioapic_pin, entry);
-}
-
 static void __init setup_IO_APIC_irqs(void)
 {
 	unsigned int ioapic, pin;
@@ -1412,46 +1345,6 @@ static void __init setup_IO_APIC_irqs(void)
 	}
 }
 
-/*
- * Set up the timer pin, possibly with the 8259A-master behind.
- */
-static void __init setup_timer_IRQ0_pin(unsigned int ioapic_idx,
-					unsigned int pin, int vector)
-{
-	struct IO_APIC_route_entry entry;
-	unsigned int dest;
-
-	memset(&entry, 0, sizeof(entry));
-
-	/*
-	 * We use logical delivery to get the timer IRQ
-	 * to the first CPU.
-	 */
-	if (unlikely(apic->cpu_mask_to_apicid_and(apic->target_cpus(),
-						  apic->target_cpus(), &dest)))
-		dest = BAD_APICID;
-
-	entry.dest_mode = apic->irq_dest_mode;
-	entry.mask = 0;			/* don't mask IRQ for edge */
-	entry.dest = dest;
-	entry.delivery_mode = apic->irq_delivery_mode;
-	entry.polarity = 0;
-	entry.trigger = 0;
-	entry.vector = vector;
-
-	/*
-	 * The timer IRQ doesn't have to know that behind the
-	 * scene we may have a 8259A-master in AEOI mode ...
-	 */
-	irq_set_chip_and_handler_name(0, &ioapic_chip, handle_edge_irq,
-				      "edge");
-
-	/*
-	 * Add it to the IO-APIC irq-routing table:
-	 */
-	ioapic_write_entry(ioapic_idx, pin, entry);
-}
-
 void native_io_apic_print_entries(unsigned int apic, unsigned int nr_entries)
 {
 	int i;
@@ -2659,20 +2552,6 @@ static int __init ioapic_init_ops(void)
 
 device_initcall(ioapic_init_ops);
 
-static int
-io_apic_setup_irq_pin(unsigned int irq, int node, struct io_apic_irq_attr *attr)
-{
-	struct irq_cfg *cfg = alloc_irq_and_cfg_at(irq, node);
-	int ret;
-
-	if (!cfg)
-		return -EINVAL;
-	ret = __add_pin_to_irq_node(cfg, node, attr->ioapic, attr->ioapic_pin);
-	if (!ret)
-		setup_ioapic_irq(irq, cfg, attr);
-	return ret;
-}
-
 static int io_apic_get_redir_entries(int ioapic)
 {
 	union IO_APIC_reg_01	reg_01;
@@ -3229,58 +3108,8 @@ static inline void set_io_apic_irq_attr(struct io_apic_irq_attr *irq_attr,
 	irq_attr->polarity	= polarity;
 }
 
-int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
-		     irq_hw_number_t hwirq)
-{
-	int ioapic = mp_irqdomain_ioapic_idx(domain);
-	struct mp_pin_info *info = mp_pin_info(ioapic, hwirq);
-	struct io_apic_irq_attr attr;
-
-	/* Get default attribute if not set by caller yet */
-	if (!info->set) {
-		u32 gsi = mp_pin_to_gsi(ioapic, hwirq);
-
-		if (acpi_get_override_irq(gsi, &info->trigger,
-					  &info->polarity) < 0) {
-			/*
-			 * PCI interrupts are always polarity one level
-			 * triggered.
-			 */
-			info->trigger = 1;
-			info->polarity = 1;
-		}
-		info->node = NUMA_NO_NODE;
-
-		/*
-		 * setup_IO_APIC_irqs() programs all legacy IRQs with default
-		 * trigger and polarity attributes. Don't set the flag for that
-		 * case so the first legacy IRQ user could reprogram the pin
-		 * with real trigger and polarity attributes.
-		 */
-		if (virq >= nr_legacy_irqs() || info->count)
-			info->set = 1;
-	}
-	set_io_apic_irq_attr(&attr, ioapic, hwirq, info->trigger,
-			     info->polarity);
-
-	return io_apic_setup_irq_pin(virq, info->node, &attr);
-}
-
-void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq)
-{
-	struct irq_data *data = irq_get_irq_data(virq);
-	struct irq_cfg *cfg = irq_cfg(virq);
-	int ioapic = mp_irqdomain_ioapic_idx(domain);
-	int pin = (int)data->hwirq;
-
-	ioapic_mask_entry(ioapic, pin);
-	__remove_pin_from_irq(cfg, ioapic, pin);
-	WARN_ON(!list_empty(&cfg->irq_2_pin));
-	arch_teardown_hwirq(virq);
-}
-
 static void mp_irqdomain_get_attr(u32 gsi, struct mp_chip_data *data,
-				 struct irq_alloc_info *info)
+				  struct irq_alloc_info *info)
 {
 	if (info && info->ioapic_valid) {
 		data->trigger = info->ioapic_trigger;
@@ -3404,35 +3233,6 @@ void mp_irqdomain_deactivate(struct irq_domain *domain,
 			  (int)irq_data->hwirq);
 }
 
-int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node)
-{
-	int ret = 0;
-	int ioapic, pin;
-	struct mp_pin_info *info;
-
-	ioapic = mp_find_ioapic(gsi);
-	if (ioapic < 0)
-		return -ENODEV;
-
-	pin = mp_find_ioapic_pin(ioapic, gsi);
-	info = mp_pin_info(ioapic, pin);
-	trigger = trigger ? 1 : 0;
-	polarity = polarity ? 1 : 0;
-
-	mutex_lock(&ioapic_mutex);
-	if (!info->set) {
-		info->trigger = trigger;
-		info->polarity = polarity;
-		info->node = node;
-		info->set = 1;
-	} else if (info->trigger != trigger || info->polarity != polarity) {
-		ret = -EBUSY;
-	}
-	mutex_unlock(&ioapic_mutex);
-
-	return ret;
-}
-
 int mp_irqdomain_ioapic_idx(struct irq_domain *domain)
 {
 	return (int)(long)domain->host_data;
