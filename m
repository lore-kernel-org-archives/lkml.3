Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab3JLRP7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 13:15:59 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:48369 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab3JLRP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 13:15:58 -0400
Date: Sat, 12 Oct 2013 19:15:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20131012171553.GA17548@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   # HEAD: 8412da757776727796e9edd64ba94814cc08d536 x86/reboot: Add reboot quirk for Dell Latitude E5410

A build fix and a reboot quirk.

  out-of-topic modifications in x86-urgent-for-linus:
  -----------------------------------------------------
  drivers/iommu/Kconfig              # 0dbc607: x86, build, pci: Fix PCI_MSI buil

 Thanks,

	Ingo

------------------>
Thomas Petazzoni (1):
      x86, build, pci: Fix PCI_MSI build on !SMP

Ville Syrjälä (1):
      x86/reboot: Add reboot quirk for Dell Latitude E5410


 arch/x86/Kconfig         | 6 +++---
 arch/x86/kernel/reboot.c | 8 ++++++++
 drivers/iommu/Kconfig    | 2 +-
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ee2fb9d..145d703 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -860,7 +860,7 @@ source "kernel/Kconfig.preempt"
 
 config X86_UP_APIC
 	bool "Local APIC support on uniprocessors"
-	depends on X86_32 && !SMP && !X86_32_NON_STANDARD
+	depends on X86_32 && !SMP && !X86_32_NON_STANDARD && !PCI_MSI
 	---help---
 	  A local APIC (Advanced Programmable Interrupt Controller) is an
 	  integrated interrupt controller in the CPU. If you have a single-CPU
@@ -885,11 +885,11 @@ config X86_UP_IOAPIC
 
 config X86_LOCAL_APIC
 	def_bool y
-	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_APIC
+	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_APIC || PCI_MSI
 
 config X86_IO_APIC
 	def_bool y
-	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_IOAPIC
+	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_IOAPIC || PCI_MSI
 
 config X86_VISWS_APIC
 	def_bool y
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index e643e74..7e920bf 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -326,6 +326,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6320"),
 		},
 	},
+	{	/* Handle problems with rebooting on the Latitude E5410. */
+		.callback = set_pci_reboot,
+		.ident = "Dell Latitude E5410",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E5410"),
+		},
+	},
 	{	/* Handle problems with rebooting on the Latitude E5420. */
 		.callback = set_pci_reboot,
 		.ident = "Dell Latitude E5420",
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index fe302e3..c880eba 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -52,7 +52,7 @@ config AMD_IOMMU
 	select PCI_PRI
 	select PCI_PASID
 	select IOMMU_API
-	depends on X86_64 && PCI && ACPI && X86_IO_APIC
+	depends on X86_64 && PCI && ACPI
 	---help---
 	  With this option you can enable support for AMD IOMMU hardware in
 	  your system. An IOMMU is a hardware component which provides
