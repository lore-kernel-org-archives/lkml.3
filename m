Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbaLSOHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:07:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46046 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbaLSOHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:07:20 -0500
Date: Fri, 19 Dec 2014 06:06:06 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-25d0d35ed7d4ded4ba90e6311c80f2eca65d12f0@git.kernel.org>
Cc: rdunlap@infradead.org, bp@alien8.de, ryan@desfo.org,
        konrad.wilk@oracle.com, yinghai@kernel.org, bhelgaas@google.com,
        lambert.quentin@gmail.com, benh@kernel.crashing.org, prarit@redhat.com,
        gregkh@linuxfoundation.org, hpa@zytor.com, jiang.liu@linux.intel.com,
        linux-kernel@vger.kernel.org, rjw@rjwysocki.net, tglx@linutronix.de,
        joro@8bytes.org, mingo@kernel.org, tony.luck@intel.com,
        grant.likely@linaro.org, rafael.j.wysocki@intel.com
Reply-To: jiang.liu@linux.intel.com, hpa@zytor.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, rjw@rjwysocki.net, tglx@linutronix.de,
        mingo@kernel.org, tony.luck@intel.com, grant.likely@linaro.org,
        joro@8bytes.org, rafael.j.wysocki@intel.com, bp@alien8.de,
        rdunlap@infradead.org, yinghai@kernel.org, konrad.wilk@oracle.com,
        ryan@desfo.org, benh@kernel.crashing.org, lambert.quentin@gmail.com,
        bhelgaas@google.com, prarit@redhat.com
In-Reply-To: <1414397531-28254-4-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-4-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Kill useless parameter 'irq_attr'
  of IO_APIC_get_PCI_irq_vector()
Git-Commit-ID: 25d0d35ed7d4ded4ba90e6311c80f2eca65d12f0
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

Commit-ID:  25d0d35ed7d4ded4ba90e6311c80f2eca65d12f0
Gitweb:     http://git.kernel.org/tip/25d0d35ed7d4ded4ba90e6311c80f2eca65d12f0
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 16:11:54 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 16 Dec 2014 14:08:16 +0100

x86, irq: Kill useless parameter 'irq_attr' of IO_APIC_get_PCI_irq_vector()

None of the callers requires irq_attr to be filled
in. IO_APIC_get_PCI_irq_vector() does not do anything useful with it
either.

Remove the parameter and fixup the call sites.

[ tglx: Massaged changelog ]

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Ryan Desfosses <ryan@desfo.org>
Cc: Quentin Lambert <lambert.quentin@gmail.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: http://lkml.kernel.org/r/1414397531-28254-4-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/include/asm/hw_irq.h     |  2 +-
 arch/x86/kernel/apic/io_apic.c    | 13 +++----------
 arch/x86/pci/irq.c                |  6 ++----
 drivers/pci/hotplug/ibmphp_core.c |  5 +----
 4 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 8dbe237..b12c45c 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -162,7 +162,7 @@ static inline void send_cleanup_vector(struct irq_cfg *c) { }
 struct irq_data;
 int __ioapic_set_affinity(struct irq_data *, const struct cpumask *,
 			  unsigned int *dest_id);
-extern int IO_APIC_get_PCI_irq_vector(int bus, int devfn, int pin, struct io_apic_irq_attr *irq_attr);
+extern int IO_APIC_get_PCI_irq_vector(int bus, int devfn, int pin);
 extern void setup_ioapic_dest(void);
 
 extern void enable_IO_APIC(void);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 1cedf41..447186a 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1179,8 +1179,7 @@ void mp_unmap_irq(int irq)
  * Find a specific PCI IRQ entry.
  * Not an __init, possibly needed by modules
  */
-int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
-				struct io_apic_irq_attr *irq_attr)
+int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin)
 {
 	int irq, i, best_ioapic = -1, best_idx = -1;
 
@@ -1234,14 +1233,8 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 		return -1;
 
 out:
-	irq = pin_2_irq(best_idx, best_ioapic, mp_irqs[best_idx].dstirq,
-			IOAPIC_MAP_ALLOC);
-	if (irq > 0)
-		set_io_apic_irq_attr(irq_attr, best_ioapic,
-				     mp_irqs[best_idx].dstirq,
-				     irq_trigger(best_idx),
-				     irq_polarity(best_idx));
-	return irq;
+	return pin_2_irq(best_idx, best_ioapic, mp_irqs[best_idx].dstirq,
+			 IOAPIC_MAP_ALLOC);
 }
 EXPORT_SYMBOL(IO_APIC_get_PCI_irq_vector);
 
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index 9988458..77148ec 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -1200,14 +1200,12 @@ static int pirq_enable_irq(struct pci_dev *dev)
 #ifdef CONFIG_X86_IO_APIC
 			struct pci_dev *temp_dev;
 			int irq;
-			struct io_apic_irq_attr irq_attr;
 
 			if (dev->irq_managed && dev->irq > 0)
 				return 0;
 
 			irq = IO_APIC_get_PCI_irq_vector(dev->bus->number,
-						PCI_SLOT(dev->devfn),
-						pin - 1, &irq_attr);
+						PCI_SLOT(dev->devfn), pin - 1);
 			/*
 			 * Busses behind bridges are typically not listed in the MP-table.
 			 * In this case we have to look up the IRQ based on the parent bus,
@@ -1221,7 +1219,7 @@ static int pirq_enable_irq(struct pci_dev *dev)
 				pin = pci_swizzle_interrupt_pin(dev, pin);
 				irq = IO_APIC_get_PCI_irq_vector(bridge->bus->number,
 						PCI_SLOT(bridge->devfn),
-						pin - 1, &irq_attr);
+						pin - 1);
 				if (irq >= 0)
 					dev_warn(&dev->dev, "using bridge %s "
 						 "INT %c to get IRQ %d\n",
diff --git a/drivers/pci/hotplug/ibmphp_core.c b/drivers/pci/hotplug/ibmphp_core.c
index 3efaf4c..d261e62 100644
--- a/drivers/pci/hotplug/ibmphp_core.c
+++ b/drivers/pci/hotplug/ibmphp_core.c
@@ -155,13 +155,10 @@ int ibmphp_init_devno(struct slot **cur_slot)
 	for (loop = 0; loop < len; loop++) {
 		if ((*cur_slot)->number == rtable->slots[loop].slot &&
 		    (*cur_slot)->bus == rtable->slots[loop].bus) {
-			struct io_apic_irq_attr irq_attr;
-
 			(*cur_slot)->device = PCI_SLOT(rtable->slots[loop].devfn);
 			for (i = 0; i < 4; i++)
 				(*cur_slot)->irq[i] = IO_APIC_get_PCI_irq_vector((int) (*cur_slot)->bus,
-						(int) (*cur_slot)->device, i,
-						&irq_attr);
+						(int) (*cur_slot)->device, i);
 
 			debug("(*cur_slot)->irq[0] = %x\n",
 					(*cur_slot)->irq[0]);
