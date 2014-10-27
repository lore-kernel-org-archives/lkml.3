Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbaJ0FVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:21:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:27125 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399AbaJ0FVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:21:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="406497850"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Prarit Bhargava <prarit@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: [Patch v7 11/18] x86, irq: Remove __init marker for functions will be used by IOAPIC hotplug
Date: Mon, 27 Oct 2014 13:21:41 +0800
Message-Id: <1414387308-27148-12-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414387308-27148-1-git-send-email-jiang.liu@linux.intel.com>
References: <1414387308-27148-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove __init marker for functions which will be used by IOAPIC hotplug
at runtime.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |    4 ++--
 arch/x86/kernel/apic/io_apic.c |   18 +++++++++---------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 1733ab49ac5e..a666dcdeea67 100644
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
index eaa7ea385600..581e51728871 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3459,7 +3459,7 @@ io_apic_setup_irq_pin(unsigned int irq, int node, struct io_apic_irq_attr *attr)
 	return ret;
 }
 
-static int __init io_apic_get_redir_entries(int ioapic)
+static int io_apic_get_redir_entries(int ioapic)
 {
 	union IO_APIC_reg_01	reg_01;
 	unsigned long flags;
@@ -3505,7 +3505,7 @@ int __init arch_probe_nr_irqs(void)
 }
 
 #ifdef CONFIG_X86_32
-static int __init io_apic_get_unique_id(int ioapic, int apic_id)
+static int io_apic_get_unique_id(int ioapic, int apic_id)
 {
 	union IO_APIC_reg_00 reg_00;
 	static physid_mask_t apic_id_map = PHYSID_MASK_NONE;
@@ -3580,7 +3580,7 @@ static int __init io_apic_get_unique_id(int ioapic, int apic_id)
 	return apic_id;
 }
 
-static u8 __init io_apic_unique_id(int idx, u8 id)
+static u8 io_apic_unique_id(int idx, u8 id)
 {
 	if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) &&
 	    !APIC_XAPIC(apic_version[boot_cpu_physical_apicid]))
@@ -3589,7 +3589,7 @@ static u8 __init io_apic_unique_id(int idx, u8 id)
 		return id;
 }
 #else
-static u8 __init io_apic_unique_id(int idx, u8 id)
+static u8 io_apic_unique_id(int idx, u8 id)
 {
 	int i;
 	u8 new_id;
@@ -3628,7 +3628,7 @@ static u8 __init io_apic_unique_id(int idx, u8 id)
 }
 #endif
 
-static int __init io_apic_get_version(int ioapic)
+static int io_apic_get_version(int ioapic)
 {
 	union IO_APIC_reg_01	reg_01;
 	unsigned long flags;
@@ -3832,7 +3832,7 @@ int mp_find_ioapic_pin(int ioapic, u32 gsi)
 	return gsi - gsi_cfg->gsi_base;
 }
 
-static __init int bad_ioapic(unsigned long address)
+static int bad_ioapic(unsigned long address)
 {
 	if (nr_ioapics >= MAX_IO_APICS) {
 		pr_warn("WARNING: Max # of I/O APICs (%d) exceeded (found %d), skipping\n",
@@ -3846,7 +3846,7 @@ static __init int bad_ioapic(unsigned long address)
 	return 0;
 }
 
-static __init int bad_ioapic_register(int idx)
+static int bad_ioapic_register(int idx)
 {
 	union IO_APIC_reg_00 reg_00;
 	union IO_APIC_reg_01 reg_01;
@@ -3865,8 +3865,8 @@ static __init int bad_ioapic_register(int idx)
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

