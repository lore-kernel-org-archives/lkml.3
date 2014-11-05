Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbaKERSK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:18:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41947 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbaKERSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:18:06 -0500
Date: Wed, 5 Nov 2014 09:16:54 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-bb46613f7099f70bc68c1c684cfa22d6863cd8eb@git.kernel.org>
Cc: mingo@kernel.org, rdunlap@infradead.org, konrad.wilk@oracle.com,
        joro@8bytes.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        rjw@rjwysocki.net, bhelgaas@google.com, gregkh@linuxfoundation.org,
        benh@kernel.crashing.org, yinghai@kernel.org,
        jiang.liu@linux.intel.com, tony.luck@intel.com, hpa@zytor.com,
        bp@alien8.de
Reply-To: rjw@rjwysocki.net, linux-kernel@vger.kernel.org, joro@8bytes.org,
        tglx@linutronix.de, konrad.wilk@oracle.com, rdunlap@infradead.org,
        mingo@kernel.org, bp@alien8.de, hpa@zytor.com,
        jiang.liu@linux.intel.com, tony.luck@intel.com, yinghai@kernel.org,
        benh@kernel.crashing.org, bhelgaas@google.com,
        gregkh@linuxfoundation.org
In-Reply-To: <1414397531-28254-16-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-16-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Make MSI and HT_IRQ indepenent of X86_IO_APIC
Git-Commit-ID: bb46613f7099f70bc68c1c684cfa22d6863cd8eb
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

Commit-ID:  bb46613f7099f70bc68c1c684cfa22d6863cd8eb
Gitweb:     http://git.kernel.org/tip/bb46613f7099f70bc68c1c684cfa22d6863cd8eb
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 16:12:06 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 5 Nov 2014 18:10:47 +0100

x86, irq: Make MSI and HT_IRQ indepenent of X86_IO_APIC

Now we have splitted functions to support MSI and HT_IRQ into vector.c,
and they have no dependency on IOAPIC any more. So change Kconfig files
to make MSI and HT_IRQ independent of X86_IO_APIC.

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
Link: http://lkml.kernel.org/r/1414397531-28254-16-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig    | 4 ++--
 drivers/pci/Kconfig | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8a739cf..8e3175b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -885,8 +885,8 @@ config X86_LOCAL_APIC
 	select GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
 
 config X86_IO_APIC
-	def_bool y
-	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_IOAPIC || PCI_MSI
+	def_bool X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_IOAPIC
+	depends on X86_LOCAL_APIC
 	select IRQ_DOMAIN
 
 config X86_REROUTE_FOR_BROKEN_BOOT_IRQS
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 39866d1..b9db0f2 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -61,7 +61,7 @@ config XEN_PCIDEV_FRONTEND
 config HT_IRQ
 	bool "Interrupts on hypertransport devices"
 	default y
-	depends on PCI && X86_LOCAL_APIC && X86_IO_APIC
+	depends on PCI && X86_LOCAL_APIC
 	help
 	   This allows native hypertransport devices to use interrupts.
 
