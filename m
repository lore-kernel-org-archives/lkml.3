Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbaFUVLn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:11:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35584 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390AbaFUVLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:11:40 -0400
Date: Sat, 21 Jun 2014 14:10:42 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-e819813f5cb98030bab38569abffd9354a1c1a82@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        len.brown@intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        jiang.liu@linux.intel.com, grant.likely@linaro.org, trivial@kernel.org,
        yinghai@kernel.org, joro@8bytes.org, pavel@ucw.cz,
        benh@kernel.crashing.org, bhelgaas@google.com, rjw@rjwysocki.net,
        paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        len.brown@intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        jiang.liu@linux.intel.com, grant.likely@linaro.org, trivial@kernel.org,
        yinghai@kernel.org, joro@8bytes.org, pavel@ucw.cz, bhelgaas@google.com,
        benh@kernel.crashing.org, rjw@rjwysocki.net,
        paul.gortmaker@windriver.com
In-Reply-To: <1402302011-23642-8-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-8-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, ACPI, trivial: Minor improvements to arch/x86
 /kernel/acpi/boot.c
Git-Commit-ID: e819813f5cb98030bab38569abffd9354a1c1a82
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

Commit-ID:  e819813f5cb98030bab38569abffd9354a1c1a82
Gitweb:     http://git.kernel.org/tip/e819813f5cb98030bab38569abffd9354a1c1a82
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 9 Jun 2014 16:19:36 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:05:40 +0200

x86, ACPI, trivial: Minor improvements to arch/x86/kernel/acpi/boot.c

1) Remove out-of-date comment
2) Kill unused function acpi_set_irq_model_pic()
3) Use NR_IRQS_LEGACY instead of hard-coded 16
4) Trivial syntax improvements

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
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Jiri Kosina <trivial@kernel.org>
Link: http://lkml.kernel.org/r/1402302011-23642-8-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/acpi/boot.c | 50 +++++++++++++++------------------------------
 1 file changed, 16 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 0968276..392360c 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -483,11 +483,6 @@ static void __init acpi_sci_ioapic_setup(u8 bus_irq, u16 polarity, u16 trigger,
 	if (acpi_sci_flags & ACPI_MADT_POLARITY_MASK)
 		polarity = acpi_sci_flags & ACPI_MADT_POLARITY_MASK;
 
-	/*
-	 * mp_config_acpi_legacy_irqs() already setup IRQs < 16
-	 * If GSI is < 16, this will update its flags,
-	 * else it will create a new mp_irqs[] entry.
-	 */
 	mp_override_legacy_irq(bus_irq, polarity, trigger, gsi);
 
 	/*
@@ -686,14 +681,7 @@ void acpi_unregister_gsi(u32 gsi)
 }
 EXPORT_SYMBOL_GPL(acpi_unregister_gsi);
 
-void __init acpi_set_irq_model_pic(void)
-{
-	acpi_irq_model = ACPI_IRQ_MODEL_PIC;
-	__acpi_register_gsi = acpi_register_gsi_pic;
-	acpi_ioapic = 0;
-}
-
-void __init acpi_set_irq_model_ioapic(void)
+static void __init acpi_set_irq_model_ioapic(void)
 {
 	acpi_irq_model = ACPI_IRQ_MODEL_IOAPIC;
 	__acpi_register_gsi = acpi_register_gsi_ioapic;
@@ -932,9 +920,8 @@ static int __init early_acpi_parse_madt_lapic_addr_ovr(void)
 	 * and (optionally) overriden by a LAPIC_ADDR_OVR entry (64-bit value).
 	 */
 
-	count =
-	    acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC_OVERRIDE,
-				  acpi_parse_lapic_addr_ovr, 0);
+	count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC_OVERRIDE,
+				      acpi_parse_lapic_addr_ovr, 0);
 	if (count < 0) {
 		printk(KERN_ERR PREFIX
 		       "Error parsing LAPIC address override entry\n");
@@ -959,9 +946,8 @@ static int __init acpi_parse_madt_lapic_entries(void)
 	 * and (optionally) overriden by a LAPIC_ADDR_OVR entry (64-bit value).
 	 */
 
-	count =
-	    acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC_OVERRIDE,
-				  acpi_parse_lapic_addr_ovr, 0);
+	count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC_OVERRIDE,
+				      acpi_parse_lapic_addr_ovr, 0);
 	if (count < 0) {
 		printk(KERN_ERR PREFIX
 		       "Error parsing LAPIC address override entry\n");
@@ -989,11 +975,10 @@ static int __init acpi_parse_madt_lapic_entries(void)
 		return count;
 	}
 
-	x2count =
-	    acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_X2APIC_NMI,
-				  acpi_parse_x2apic_nmi, 0);
-	count =
-	    acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC_NMI, acpi_parse_lapic_nmi, 0);
+	x2count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_X2APIC_NMI,
+					acpi_parse_x2apic_nmi, 0);
+	count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC_NMI,
+				      acpi_parse_lapic_nmi, 0);
 	if (count < 0 || x2count < 0) {
 		printk(KERN_ERR PREFIX "Error parsing LAPIC NMI entry\n");
 		/* TBD: Cleanup to allow fallback to MPS */
@@ -1022,7 +1007,7 @@ static void __init mp_config_acpi_legacy_irqs(void)
 	 * Use the default configuration for the IRQs 0-15.  Unless
 	 * overridden by (MADT) interrupt source override entries.
 	 */
-	for (i = 0; i < 16; i++) {
+	for (i = 0; i < NR_IRQS_LEGACY; i++) {
 		int ioapic, pin;
 		unsigned int dstapic;
 		int idx;
@@ -1099,9 +1084,8 @@ static int __init acpi_parse_madt_ioapic_entries(void)
 		return -ENODEV;
 	}
 
-	count =
-	    acpi_table_parse_madt(ACPI_MADT_TYPE_IO_APIC, acpi_parse_ioapic,
-				  MAX_IO_APICS);
+	count = acpi_table_parse_madt(ACPI_MADT_TYPE_IO_APIC, acpi_parse_ioapic,
+				      MAX_IO_APICS);
 	if (!count) {
 		printk(KERN_ERR PREFIX "No IOAPIC entries present\n");
 		return -ENODEV;
@@ -1110,9 +1094,8 @@ static int __init acpi_parse_madt_ioapic_entries(void)
 		return count;
 	}
 
-	count =
-	    acpi_table_parse_madt(ACPI_MADT_TYPE_INTERRUPT_OVERRIDE, acpi_parse_int_src_ovr,
-				  nr_irqs);
+	count = acpi_table_parse_madt(ACPI_MADT_TYPE_INTERRUPT_OVERRIDE,
+				      acpi_parse_int_src_ovr, nr_irqs);
 	if (count < 0) {
 		printk(KERN_ERR PREFIX
 		       "Error parsing interrupt source overrides entry\n");
@@ -1131,9 +1114,8 @@ static int __init acpi_parse_madt_ioapic_entries(void)
 	/* Fill in identity legacy mappings where no override */
 	mp_config_acpi_legacy_irqs();
 
-	count =
-	    acpi_table_parse_madt(ACPI_MADT_TYPE_NMI_SOURCE, acpi_parse_nmi_src,
-				  nr_irqs);
+	count = acpi_table_parse_madt(ACPI_MADT_TYPE_NMI_SOURCE,
+				      acpi_parse_nmi_src, nr_irqs);
 	if (count < 0) {
 		printk(KERN_ERR PREFIX "Error parsing NMI SRC entry\n");
 		/* TBD: Cleanup to allow fallback to MPS */
