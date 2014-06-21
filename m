Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285AbaFUVNX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:13:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35727 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757398AbaFUVNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:13:18 -0400
Date: Sat, 21 Jun 2014 14:12:14 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-32f5ef5d8dd5ac3cc7ac12cdaf33023e2fbd33c1@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        hpa@zytor.com, jiang.liu@linux.intel.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, joro@8bytes.org,
        benh@kernel.crashing.org, bhelgaas@google.com, rjw@rjwysocki.net,
        paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        hpa@zytor.com, jiang.liu@linux.intel.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, joro@8bytes.org,
        benh@kernel.crashing.org, bhelgaas@google.com, rjw@rjwysocki.net,
        paul.gortmaker@windriver.com
In-Reply-To: <1402302011-23642-15-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-15-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, ioapic: Use irq_cfg()
  instead of irq_get_chip_data() for better readability
Git-Commit-ID: 32f5ef5d8dd5ac3cc7ac12cdaf33023e2fbd33c1
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

Commit-ID:  32f5ef5d8dd5ac3cc7ac12cdaf33023e2fbd33c1
Gitweb:     http://git.kernel.org/tip/32f5ef5d8dd5ac3cc7ac12cdaf33023e2fbd33c1
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 9 Jun 2014 16:19:43 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:05:41 +0200

x86, ioapic: Use irq_cfg() instead of irq_get_chip_data() for better readability

Use defined helper function irq_cfg() instead of irq_get_chip_data() for
better readability.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1402302011-23642-15-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 16b0247..446a931 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -230,7 +230,7 @@ int __init arch_early_irq_init(void)
 	return 0;
 }
 
-static struct irq_cfg *irq_cfg(unsigned int irq)
+static inline struct irq_cfg *irq_cfg(unsigned int irq)
 {
 	return irq_get_chip_data(irq);
 }
@@ -272,7 +272,7 @@ static struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node)
 	if (res < 0) {
 		if (res != -EEXIST)
 			return NULL;
-		cfg = irq_get_chip_data(at);
+		cfg = irq_cfg(at);
 		if (cfg)
 			return cfg;
 	}
@@ -1204,7 +1204,7 @@ void __setup_vector_irq(int cpu)
 	raw_spin_lock(&vector_lock);
 	/* Mark the inuse vectors */
 	for_each_active_irq(irq) {
-		cfg = irq_get_chip_data(irq);
+		cfg = irq_cfg(irq);
 		if (!cfg)
 			continue;
 
@@ -1612,7 +1612,7 @@ __apicdebuginit(void) print_IO_APICs(void)
 		if (chip != &ioapic_chip)
 			continue;
 
-		cfg = irq_get_chip_data(irq);
+		cfg = irq_cfg(irq);
 		if (!cfg)
 			continue;
 		entry = cfg->irq_2_pin;
@@ -2253,7 +2253,7 @@ static void irq_complete_move(struct irq_cfg *cfg)
 
 void irq_force_complete_move(int irq)
 {
-	struct irq_cfg *cfg = irq_get_chip_data(irq);
+	struct irq_cfg *cfg = irq_cfg(irq);
 
 	if (!cfg)
 		return;
@@ -2515,7 +2515,7 @@ static inline void init_IO_APIC_traps(void)
 	unsigned int irq;
 
 	for_each_active_irq(irq) {
-		cfg = irq_get_chip_data(irq);
+		cfg = irq_cfg(irq);
 		if (IO_APIC_IRQ(irq) && cfg && !cfg->vector) {
 			/*
 			 * Hmm.. We don't have an entry for this,
@@ -2648,7 +2648,7 @@ early_param("disable_timer_pin_1", disable_timer_pin_setup);
  */
 static inline void __init check_timer(void)
 {
-	struct irq_cfg *cfg = irq_get_chip_data(0);
+	struct irq_cfg *cfg = irq_cfg(0);
 	int node = cpu_to_node(0);
 	int apic1, pin1, apic2, pin2;
 	unsigned long flags;
@@ -2912,7 +2912,7 @@ int arch_setup_hwirq(unsigned int irq, int node)
 
 void arch_teardown_hwirq(unsigned int irq)
 {
-	struct irq_cfg *cfg = irq_get_chip_data(irq);
+	struct irq_cfg *cfg = irq_cfg(irq);
 	unsigned long flags;
 
 	free_remapped_irq(irq);
@@ -3039,7 +3039,7 @@ int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 	if (!irq_offset)
 		write_msi_msg(irq, &msg);
 
-	setup_remapped_irq(irq, irq_get_chip_data(irq), chip);
+	setup_remapped_irq(irq, irq_cfg(irq), chip);
 
 	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
 
@@ -3178,7 +3178,7 @@ int default_setup_hpet_msi(unsigned int irq, unsigned int id)
 
 	hpet_msi_write(irq_get_handler_data(irq), &msg);
 	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-	setup_remapped_irq(irq, irq_get_chip_data(irq), chip);
+	setup_remapped_irq(irq, irq_cfg(irq), chip);
 
 	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
 	return 0;
