Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaKCLAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 06:00:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48199 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbaKCLAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 06:00:50 -0500
Date: Mon, 3 Nov 2014 02:59:30 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-9999a6756f064a1b11b5e2dfdbc2dc06b790bcb6@git.kernel.org>
Cc: benh@kernel.crashing.org, grant.likely@linaro.org,
        gregkh@linuxfoundation.org, prarit@redhat.com, bhelgaas@google.com,
        rdunlap@infradead.org, bp@alien8.de, mingo@kernel.org, joro@8bytes.org,
        jiang.liu@linux.intel.com, hpa@zytor.com, yinghai@kernel.org,
        konrad.wilk@oracle.com, rjw@rjwysocki.net, tony.luck@intel.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org
Reply-To: rdunlap@infradead.org, bp@alien8.de, mingo@kernel.org,
        jiang.liu@linux.intel.com, hpa@zytor.com, joro@8bytes.org,
        konrad.wilk@oracle.com, yinghai@kernel.org, tony.luck@intel.com,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        benh@kernel.crashing.org, grant.likely@linaro.org,
        gregkh@linuxfoundation.org, prarit@redhat.com, bhelgaas@google.com
In-Reply-To: <1414387308-27148-12-git-send-email-jiang.liu@linux.intel.com>
References: <1414387308-27148-12-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Remove __init marker for functions will be used by IOAPIC hotplug
Git-Commit-ID: 9999a6756f064a1b11b5e2dfdbc2dc06b790bcb6
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

Commit-ID:  9999a6756f064a1b11b5e2dfdbc2dc06b790bcb6
Gitweb:     http://git.kernel.org/tip/9999a6756f064a1b11b5e2dfdbc2dc06b790bcb6
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 13:21:41 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 3 Nov 2014 11:56:08 +0100

x86, irq: Remove __init marker for functions will be used by IOAPIC hotplug

Remove __init marker for functions which will be used by IOAPIC hotplug
at runtime.

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
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1414387308-27148-12-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/io_apic.h |  4 ++--
 arch/x86/kernel/apic/io_apic.c | 18 +++++++++---------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 1733ab4..a666dcd 100644
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
index 02212fb..19501ab 100644
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
 	union IO_APIC_reg_00 reg_00;
 	DECLARE_BITMAP(used, 256);
@@ -3636,7 +3636,7 @@ static u8 __init io_apic_unique_id(int idx, u8 id)
 }
 #endif
 
-static int __init io_apic_get_version(int ioapic)
+static int io_apic_get_version(int ioapic)
 {
 	union IO_APIC_reg_01	reg_01;
 	unsigned long flags;
@@ -3840,7 +3840,7 @@ int mp_find_ioapic_pin(int ioapic, u32 gsi)
 	return gsi - gsi_cfg->gsi_base;
 }
 
-static __init int bad_ioapic(unsigned long address)
+static int bad_ioapic(unsigned long address)
 {
 	if (nr_ioapics >= MAX_IO_APICS) {
 		pr_warn("WARNING: Max # of I/O APICs (%d) exceeded (found %d), skipping\n",
@@ -3854,7 +3854,7 @@ static __init int bad_ioapic(unsigned long address)
 	return 0;
 }
 
-static __init int bad_ioapic_register(int idx)
+static int bad_ioapic_register(int idx)
 {
 	union IO_APIC_reg_00 reg_00;
 	union IO_APIC_reg_01 reg_01;
@@ -3873,8 +3873,8 @@ static __init int bad_ioapic_register(int idx)
 	return 0;
 }
 
-void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
-			       struct ioapic_domain_cfg *cfg)
+void mp_register_ioapic(int id, u32 address, u32 gsi_base,
+			struct ioapic_domain_cfg *cfg)
 {
 	int idx = 0;
 	int entries;
