Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab3FGWbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 18:31:51 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51377 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757347Ab3FGWbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 18:31:45 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 24/27] PCI, x86: Make ioapic hotplug support built-in
Date: Fri,  7 Jun 2013 15:31:10 -0700
Message-Id: <1370644273-10495-25-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1370644273-10495-1-git-send-email-yinghai@kernel.org>
References: <1370644273-10495-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioapic hotplug should be built-in like pci root bus hotplug.

Also need to make it depends on X86_IO_APIC.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/Kconfig  | 3 ++-
 drivers/pci/ioapic.c | 7 -------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 6d51aa6..720989f 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -110,10 +110,11 @@ config PCI_PASID
 	  If unsure, say N.
 
 config PCI_IOAPIC
-	tristate "PCI IO-APIC hotplug support" if X86
+	bool "PCI IO-APIC hotplug support" if X86
 	depends on PCI
 	depends on ACPI
 	depends on HOTPLUG
+	depends on X86_IO_APIC
 	default !X86
 
 config PCI_LABEL
diff --git a/drivers/pci/ioapic.c b/drivers/pci/ioapic.c
index 3c6bbdd..7d6b157 100644
--- a/drivers/pci/ioapic.c
+++ b/drivers/pci/ioapic.c
@@ -117,13 +117,6 @@ static int __init ioapic_init(void)
 {
 	return pci_register_driver(&ioapic_driver);
 }
-
-static void __exit ioapic_exit(void)
-{
-	pci_unregister_driver(&ioapic_driver);
-}
-
 module_init(ioapic_init);
-module_exit(ioapic_exit);
 
 MODULE_LICENSE("GPL");
-- 
1.8.1.4

