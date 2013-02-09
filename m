Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947499Ab3BIA1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 19:27:19 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:35669 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947333Ab3BIA1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 19:27:17 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 26-1/26] PCI, x86: Make ioapic hotplug support built-in
Date: Fri,  8 Feb 2013 16:26:43 -0800
Message-Id: <1360369606-8416-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <CAE9FiQVhmH_TGqEwxGPusKNn-6Q7QkS3UTitEriV3dX8sPbzFA@mail.gmail.com>
References: <CAE9FiQVhmH_TGqEwxGPusKNn-6Q7QkS3UTitEriV3dX8sPbzFA@mail.gmail.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioapic hotplug should be built-in by nature.

Also need to make it depends on X86_IO_APIC.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/Kconfig  |    3 ++-
 drivers/pci/ioapic.c |    7 -------
 2 files changed, 2 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/pci/Kconfig
===================================================================
--- linux-2.6.orig/drivers/pci/Kconfig
+++ linux-2.6/drivers/pci/Kconfig
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
Index: linux-2.6/drivers/pci/ioapic.c
===================================================================
--- linux-2.6.orig/drivers/pci/ioapic.c
+++ linux-2.6/drivers/pci/ioapic.c
@@ -130,13 +130,6 @@ static int __init ioapic_init(void)
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
