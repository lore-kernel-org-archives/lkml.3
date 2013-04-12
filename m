Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab3DLPrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 11:47:14 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:55444 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597Ab3DLPrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 11:47:10 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org
Subject: [PATCH v9 08/16] PCI, IA64: implement pcibios_{add|remove}_bus() hooks
Date: Fri, 12 Apr 2013 23:44:22 +0800
Message-Id: <1365781470-32379-9-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com>
References: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement pcibios_{add|remove}_bus() hooks for IA64 platforms.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/ia64/pci/pci.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index 60532ab..de1474f 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
+#include <linux/pci-acpi.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/slab.h>
@@ -458,6 +459,16 @@ void pcibios_fixup_bus(struct pci_bus *b)
 	platform_pci_fixup_bus(b);
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
 void pcibios_set_master (struct pci_dev *dev)
 {
 	/* No special bus mastering setup handling */
-- 
1.7.9.5

