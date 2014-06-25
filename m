Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbaFYIjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 04:39:41 -0400
Received: from mga14.intel.com ([192.55.52.115]:23575 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603AbaFYIjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 04:39:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,544,1400050800"; 
   d="scan'208";a="552973865"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Prarit Bhargava <prarit@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: [Patch V3 09/16] x86, irq: Remove __init marker for functions will be used by IOAPIC hotplug
Date: Wed, 25 Jun 2014 16:40:40 +0800
Message-Id: <1403685648-10103-10-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403685648-10103-1-git-send-email-jiang.liu@linux.intel.com>
References: <1403685648-10103-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |    4 ++--
 arch/x86/kernel/apic/io_apic.c |   14 +++++++-------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 0aeed5ca356e..0b31aebd9405 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -188,8 +188,8 @@ extern int mp_find_ioapic_pin(int ioapic, u32 gsi);
 extern u32 mp_pin_to_gsi(int ioapic, int pin);
 extern int mp_map_gsi_to_irq(u32 gsi, unsigned int flags);
 extern void mp_unmap_irq(int irq);
-extern void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
-				      struct ioapic_domain_cfg *cfg);
+extern void mp_register_ioapic(int id, u32 address, u32 gsi_base,
+			       struct ioapic_domain_cfg *cfg);
 extern int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
 			    irq_hw_number_t hwirq);
 extern void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index a068bf558657..1510734d5cbb 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3449,7 +3449,7 @@ io_apic_setup_irq_pin(unsigned int irq, int node, struct io_apic_irq_attr *attr)
 	return ret;
 }
 
-static int __init io_apic_get_redir_entries(int ioapic)
+static int io_apic_get_redir_entries(int ioapic)
 {
 	union IO_APIC_reg_01	reg_01;
 	unsigned long flags;
@@ -3495,7 +3495,7 @@ int __init arch_probe_nr_irqs(void)
 }
 
 #ifdef CONFIG_X86_32
-static int __init io_apic_get_unique_id(int ioapic, int apic_id)
+static int io_apic_get_unique_id(int ioapic, int apic_id)
 {
 	union IO_APIC_reg_00 reg_00;
 	static physid_mask_t apic_id_map = PHYSID_MASK_NONE;
@@ -3621,7 +3621,7 @@ static u8 io_apic_unique_id(int idx, u8 id)
 }
 #endif
 
-static int __init io_apic_get_version(int ioapic)
+static int io_apic_get_version(int ioapic)
 {
 	union IO_APIC_reg_01	reg_01;
 	unsigned long flags;
@@ -3825,7 +3825,7 @@ int mp_find_ioapic_pin(int ioapic, u32 gsi)
 	return gsi - gsi_cfg->gsi_base;
 }
 
-static __init int bad_ioapic(unsigned long address)
+static int bad_ioapic(unsigned long address)
 {
 	if (nr_ioapics >= MAX_IO_APICS) {
 		pr_warn("WARNING: Max # of I/O APICs (%d) exceeded (found %d), skipping\n",
@@ -3839,7 +3839,7 @@ static __init int bad_ioapic(unsigned long address)
 	return 0;
 }
 
-static __init int bad_ioapic_register(int idx)
+static int bad_ioapic_register(int idx)
 {
 	union IO_APIC_reg_00 reg_00;
 	union IO_APIC_reg_01 reg_01;
@@ -3858,8 +3858,8 @@ static __init int bad_ioapic_register(int idx)
 	return 0;
 }
 
-void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
-			       struct ioapic_domain_cfg *cfg)
+void mp_register_ioapic(int id, u32 address, u32 gsi_base,
+			struct ioapic_domain_cfg *cfg)
 {
 	int idx = 0;
 	int entries;
-- 
1.7.10.4

