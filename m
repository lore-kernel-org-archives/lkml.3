Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296AbaKERSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:18:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41952 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170AbaKERSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:18:12 -0500
Date: Wed, 5 Nov 2014 09:16:23 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-1e83b8afb8c872d9aec37b7bcfbece301f927d26@git.kernel.org>
Cc: hpa@zytor.com, ryan@desfo.org, mingo@kernel.org, fenghua.yu@intel.com,
        joro@8bytes.org, aubrey.li@linux.intel.com, bp@alien8.de,
        hpa@linux.intel.com, benh@kernel.crashing.org, vgoyal@redhat.com,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        matt.fleming@intel.com, gregkh@linuxfoundation.org,
        konrad.wilk@oracle.com, jiang.liu@linux.intel.com,
        grant.likely@linaro.org, lambert.quentin@gmail.com, prarit@redhat.com,
        rdunlap@infradead.org, rafael.j.wysocki@intel.com, tglx@linutronix.de,
        bhe@redhat.com, tony.luck@intel.com, christian.gmeiner@gmail.com,
        bhelgaas@google.com, yinghai@kernel.org
Reply-To: rafael.j.wysocki@intel.com, rdunlap@infradead.org, prarit@redhat.com,
        lambert.quentin@gmail.com, tglx@linutronix.de, tony.luck@intel.com,
        bhe@redhat.com, bhelgaas@google.com, yinghai@kernel.org,
        christian.gmeiner@gmail.com, hpa@linux.intel.com, bp@alien8.de,
        aubrey.li@linux.intel.com, fenghua.yu@intel.com, joro@8bytes.org,
        hpa@zytor.com, ryan@desfo.org, mingo@kernel.org,
        matt.fleming@intel.com, linux-kernel@vger.kernel.org,
        rjw@rjwysocki.net, vgoyal@redhat.com, benh@kernel.crashing.org,
        jiang.liu@linux.intel.com, grant.likely@linaro.org,
        konrad.wilk@oracle.com, gregkh@linuxfoundation.org
In-Reply-To: <1414397531-28254-14-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-14-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Move IOAPIC related declarations from hw_irq.h into io_apic.h
Git-Commit-ID: 1e83b8afb8c872d9aec37b7bcfbece301f927d26
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

Commit-ID:  1e83b8afb8c872d9aec37b7bcfbece301f927d26
Gitweb:     http://git.kernel.org/tip/1e83b8afb8c872d9aec37b7bcfbece301f927d26
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 16:12:04 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 5 Nov 2014 18:10:47 +0100

x86, irq: Move IOAPIC related declarations from hw_irq.h into io_apic.h

Clean up code by moving IOAPIC related declarations from hw_irq.h into
io_apic.h.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: Aubrey <aubrey.li@linux.intel.com>
Cc: Ryan Desfosses <ryan@desfo.org>
Cc: Quentin Lambert <lambert.quentin@gmail.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: http://lkml.kernel.org/r/1414397531-28254-14-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/hw_irq.h      | 33 ---------------------------------
 arch/x86/include/asm/io_apic.h     | 20 +++++++++++++++++++-
 arch/x86/kernel/apic/io_apic.c     | 10 ++++++++++
 arch/x86/kernel/crash.c            |  1 +
 arch/x86/kernel/machine_kexec_32.c |  1 +
 arch/x86/kernel/machine_kexec_64.c |  1 +
 arch/x86/kernel/reboot.c           |  1 +
 drivers/pci/hotplug/ibmphp_core.c  |  1 +
 8 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index a723577..9662290 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -159,39 +159,6 @@ static inline void lock_vector_lock(void) {}
 static inline void unlock_vector_lock(void) {}
 #endif	/* CONFIG_X86_LOCAL_APIC */
 
-/* IOAPIC */
-#ifdef CONFIG_X86_IO_APIC
-struct io_apic_irq_attr {
-	int ioapic;
-	int ioapic_pin;
-	int trigger;
-	int polarity;
-};
-
-static inline void set_io_apic_irq_attr(struct io_apic_irq_attr *irq_attr,
-					int ioapic, int ioapic_pin,
-					int trigger, int polarity)
-{
-	irq_attr->ioapic	= ioapic;
-	irq_attr->ioapic_pin	= ioapic_pin;
-	irq_attr->trigger	= trigger;
-	irq_attr->polarity	= polarity;
-}
-
-extern void setup_IO_APIC(void);
-extern void enable_IO_APIC(void);
-extern void disable_IO_APIC(void);
-extern void setup_ioapic_dest(void);
-extern int IO_APIC_get_PCI_irq_vector(int bus, int devfn, int pin);
-extern void print_IO_APICs(void);
-
-extern unsigned long io_apic_irqs;
-#define IO_APIC_IRQ(x) (((x) >= NR_IRQS_LEGACY) || ((1 << (x)) & io_apic_irqs))
-#else	/* CONFIG_X86_IO_APIC */
-#define IO_APIC_IRQ(x)	0
-static inline void print_IO_APICs(void) {}
-#endif	/* CONFIG_X86_IO_APIC */
-
 /* Statistics */
 extern atomic_t irq_err_count;
 extern atomic_t irq_mis_count;
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index bdd45c2..b7f1499 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -132,6 +132,10 @@ extern int noioapicquirk;
 /* -1 if "noapic" boot option passed */
 extern int noioapicreroute;
 
+extern unsigned long io_apic_irqs;
+
+#define IO_APIC_IRQ(x) (((x) >= NR_IRQS_LEGACY) || ((1 << (x)) & io_apic_irqs))
+
 /*
  * If we use the IO-APIC for IRQ routing, disable automatic
  * assignment of PCI IRQ's.
@@ -139,7 +143,6 @@ extern int noioapicreroute;
 #define io_apic_assign_pci_irqs \
 	(mp_irq_entries && !skip_ioapic_setup && io_apic_irqs)
 
-struct io_apic_irq_attr;
 struct irq_cfg;
 extern void ioapic_insert_resources(void);
 
@@ -157,6 +160,13 @@ extern int restore_ioapic_entries(void);
 extern void setup_ioapic_ids_from_mpc(void);
 extern void setup_ioapic_ids_from_mpc_nocheck(void);
 
+struct io_apic_irq_attr {
+	int ioapic;
+	int ioapic_pin;
+	int trigger;
+	int polarity;
+};
+
 enum ioapic_domain_type {
 	IOAPIC_DOMAIN_INVALID,
 	IOAPIC_DOMAIN_LEGACY,
@@ -226,11 +236,19 @@ static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned
 
 extern void io_apic_eoi(unsigned int apic, unsigned int vector);
 
+extern void setup_IO_APIC(void);
+extern void enable_IO_APIC(void);
+extern void disable_IO_APIC(void);
+extern void setup_ioapic_dest(void);
+extern int IO_APIC_get_PCI_irq_vector(int bus, int devfn, int pin);
+extern void print_IO_APICs(void);
 #else  /* !CONFIG_X86_IO_APIC */
 
+#define IO_APIC_IRQ(x)		0
 #define io_apic_assign_pci_irqs 0
 #define setup_ioapic_ids_from_mpc x86_init_noop
 static inline void ioapic_insert_resources(void) { }
+static inline void print_IO_APICs(void) {}
 #define gsi_top (NR_IRQS_LEGACY)
 static inline int mp_find_ioapic(u32 gsi) { return 0; }
 static inline u32 mp_pin_to_gsi(int ioapic, int pin) { return UINT_MAX; }
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index b1acb68..8dcdb7b 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3023,6 +3023,16 @@ int mp_ioapic_registered(u32 gsi_base)
 	return 0;
 }
 
+static inline void set_io_apic_irq_attr(struct io_apic_irq_attr *irq_attr,
+					int ioapic, int ioapic_pin,
+					int trigger, int polarity)
+{
+	irq_attr->ioapic	= ioapic;
+	irq_attr->ioapic_pin	= ioapic_pin;
+	irq_attr->trigger	= trigger;
+	irq_attr->polarity	= polarity;
+}
+
 int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
 		     irq_hw_number_t hwirq)
 {
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index f5ab56d..aceb2f9 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -28,6 +28,7 @@
 #include <asm/nmi.h>
 #include <asm/hw_irq.h>
 #include <asm/apic.h>
+#include <asm/io_apic.h>
 #include <asm/hpet.h>
 #include <linux/kdebug.h>
 #include <asm/cpu.h>
diff --git a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
index 72e8e31..469b23d 100644
--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -20,6 +20,7 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include <asm/apic.h>
+#include <asm/io_apic.h>
 #include <asm/cpufeature.h>
 #include <asm/desc.h>
 #include <asm/cacheflush.h>
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 4859810..415480d 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -22,6 +22,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
+#include <asm/io_apic.h>
 #include <asm/debugreg.h>
 #include <asm/kexec-bzimage64.h>
 
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 17962e6..bae6c60 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -12,6 +12,7 @@
 #include <acpi/reboot.h>
 #include <asm/io.h>
 #include <asm/apic.h>
+#include <asm/io_apic.h>
 #include <asm/desc.h>
 #include <asm/hpet.h>
 #include <asm/pgtable.h>
diff --git a/drivers/pci/hotplug/ibmphp_core.c b/drivers/pci/hotplug/ibmphp_core.c
index d261e62..96c5c72 100644
--- a/drivers/pci/hotplug/ibmphp_core.c
+++ b/drivers/pci/hotplug/ibmphp_core.c
@@ -36,6 +36,7 @@
 #include <linux/wait.h>
 #include "../pci.h"
 #include <asm/pci_x86.h>		/* for struct irq_routing_table */
+#include <asm/io_apic.h>
 #include "ibmphp.h"
 
 #define attn_on(sl)  ibmphp_hpc_writeslot (sl, HPC_SLOT_ATTNON)
