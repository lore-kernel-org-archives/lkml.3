Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab3HKCvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 22:51:21 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34907 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab3HKCth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 22:49:37 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v4 25/28] PCI, x86: Make ioapic hotplug support built-in
Date: Sat, 10 Aug 2013 19:48:11 -0700
Message-Id: <1376189294-32022-26-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
References: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioapic hotplug should be built-in like pci root bus hotplug.

Also need to make it depends on X86_IO_APIC.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/Kconfig  | 3 ++-
 drivers/pci/ioapic.c | 6 +++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 81944fb..6c9ede2 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -109,9 +109,10 @@ config PCI_PASID
 	  If unsure, say N.
 
 config PCI_IOAPIC
-	tristate "PCI IO-APIC hotplug support" if X86
+	bool "PCI IO-APIC hotplug support" if X86
 	depends on PCI
 	depends on ACPI
+	depends on X86_IO_APIC
 	default !X86
 
 config PCI_LABEL
diff --git a/drivers/pci/ioapic.c b/drivers/pci/ioapic.c
index 1b90579..7d6b157 100644
--- a/drivers/pci/ioapic.c
+++ b/drivers/pci/ioapic.c
@@ -113,6 +113,10 @@ static struct pci_driver ioapic_driver = {
 	.remove		= ioapic_remove,
 };
 
-module_pci_driver(ioapic_driver);
+static int __init ioapic_init(void)
+{
+	return pci_register_driver(&ioapic_driver);
+}
+module_init(ioapic_init);
 
 MODULE_LICENSE("GPL");
-- 
1.8.1.4

