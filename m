Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab3DLPrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 11:47:22 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:42417 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab3DLPrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 11:47:19 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH v9 09/16] PCI, x86: implement pcibios_{add|remove}_bus() hooks
Date: Fri, 12 Apr 2013 23:44:23 +0800
Message-Id: <1365781470-32379-10-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com>
References: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement pcibios_{add|remove}_bus() hooks for x86 platforms.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Myron Stowe <myron.stowe@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: x86@kernel.org
---
 arch/x86/pci/common.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 901177d..305c68b 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -6,6 +6,7 @@
 
 #include <linux/sched.h>
 #include <linux/pci.h>
+#include <linux/pci-acpi.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/dmi.h>
@@ -170,6 +171,16 @@ void pcibios_fixup_bus(struct pci_bus *b)
 		pcibios_fixup_device_resources(dev);
 }
 
+void pcibios_add_bus(struct pci_bus *bus)
+{
+	acpi_pci_add_bus(bus);
+}
+
+void pcibios_remove_bus(struct pci_bus *bus)
+{
+	acpi_pci_remove_bus(bus);
+}
+
 /*
  * Only use DMI information to set this if nothing was passed
  * on the kernel command line (which was parsed earlier).
-- 
1.7.9.5

