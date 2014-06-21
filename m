Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559AbaFUVP5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:15:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35927 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758542AbaFUVPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:15:55 -0400
Date: Sat, 21 Jun 2014 14:12:54 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-6084a6e23c971ef703229ee1aec68d01688578d6@git.kernel.org>
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
In-Reply-To: <1402302011-23642-18-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-18-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: ce4100, irq:
  Make CE4100 depend on CONFIG_X86_IO_APIC
Git-Commit-ID: 6084a6e23c971ef703229ee1aec68d01688578d6
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

Commit-ID:  6084a6e23c971ef703229ee1aec68d01688578d6
Gitweb:     http://git.kernel.org/tip/6084a6e23c971ef703229ee1aec68d01688578d6
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 9 Jun 2014 16:19:46 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:05:42 +0200

x86: ce4100, irq: Make CE4100 depend on CONFIG_X86_IO_APIC

Intel CE4100 platforms need IOAPIC support becasue some devices are
always connected to the second IOAPIC, so make CONFIG_CE depends on
CONFIG_X86_IO_APIC.

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
Link: http://lkml.kernel.org/r/1402302011-23642-18-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig                  | 1 +
 arch/x86/platform/ce4100/ce4100.c | 9 ++-------
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a8f749e..9df5c45 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -429,6 +429,7 @@ config X86_INTEL_CE
 	bool "CE4100 TV platform"
 	depends on PCI
 	depends on PCI_GODIRECT
+	depends on X86_IO_APIC
 	depends on X86_32
 	depends on X86_EXTENDED_PLATFORM
 	select X86_REBOOTFIXUPS
diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
index 8244f5e..0a54a58 100644
--- a/arch/x86/platform/ce4100/ce4100.c
+++ b/arch/x86/platform/ce4100/ce4100.c
@@ -135,14 +135,12 @@ static void __init sdv_arch_setup(void)
 	sdv_serial_fixup();
 }
 
-#ifdef CONFIG_X86_IO_APIC
 static void sdv_pci_init(void)
 {
 	x86_of_pci_init();
 	/* We can't set this earlier, because we need to calibrate the timer */
 	legacy_pic = &null_legacy_pic;
 }
-#endif
 
 /*
  * CE4100 specific x86_init function overrides and early setup
@@ -155,7 +153,9 @@ void __init x86_ce4100_early_setup(void)
 	x86_init.resources.probe_roms = x86_init_noop;
 	x86_init.mpparse.get_smp_config = x86_init_uint_noop;
 	x86_init.mpparse.find_smp_config = x86_init_noop;
+	x86_init.mpparse.setup_ioapic_ids = setup_ioapic_ids_from_mpc_nocheck;
 	x86_init.pci.init = ce4100_pci_init;
+	x86_init.pci.init_irq = sdv_pci_init;
 
 	/*
 	 * By default, the reboot method is ACPI which is supported by the
@@ -166,10 +166,5 @@ void __init x86_ce4100_early_setup(void)
 	 */
 	reboot_type = BOOT_KBD;
 
-#ifdef CONFIG_X86_IO_APIC
-	x86_init.pci.init_irq = sdv_pci_init;
-	x86_init.mpparse.setup_ioapic_ids = setup_ioapic_ids_from_mpc_nocheck;
-#endif
-
 	pm_power_off = ce4100_power_off;
 }
