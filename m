Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179Ab3DLPrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 11:47:36 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:34687 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987Ab3DLPrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 11:47:33 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH v9 11/16] PCI/acpiphp: convert acpiphp as a builtin driver
Date: Fri, 12 Apr 2013 23:44:25 +0800
Message-Id: <1365781470-32379-12-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com>
References: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for coming bugfixes by converting acpiphp as a builtin driver.
This change has a drawback that user has no way to disable the acpiphp
driver anymore once it becomes a builtin driver. We may introduce a
kernel option to disable the acpiphp driver if needed.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/pci/hotplug/Kconfig        |    7 ++-----
 drivers/pci/hotplug/acpiphp_core.c |   10 ----------
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/hotplug/Kconfig b/drivers/pci/hotplug/Kconfig
index 13e9e63..9fcb87f 100644
--- a/drivers/pci/hotplug/Kconfig
+++ b/drivers/pci/hotplug/Kconfig
@@ -52,15 +52,12 @@ config HOTPLUG_PCI_IBM
 	  When in doubt, say N.
 
 config HOTPLUG_PCI_ACPI
-	tristate "ACPI PCI Hotplug driver"
-	depends on (!ACPI_DOCK && ACPI) || (ACPI_DOCK)
+	bool "ACPI PCI Hotplug driver"
+	depends on HOTPLUG_PCI=y && ((!ACPI_DOCK && ACPI) || (ACPI_DOCK))
 	help
 	  Say Y here if you have a system that supports PCI Hotplug using
 	  ACPI.
 
-	  To compile this driver as a module, choose M here: the
-	  module will be called acpiphp.
-
 	  When in doubt, say N.
 
 config HOTPLUG_PCI_ACPI_IBM
diff --git a/drivers/pci/hotplug/acpiphp_core.c b/drivers/pci/hotplug/acpiphp_core.c
index c2fd309..45312e5 100644
--- a/drivers/pci/hotplug/acpiphp_core.c
+++ b/drivers/pci/hotplug/acpiphp_core.c
@@ -364,14 +364,4 @@ static int __init acpiphp_init(void)
 }
 
 
-static void __exit acpiphp_exit(void)
-{
-	if (acpi_pci_disabled)
-		return;
-
-	/* deallocate internal data structures etc. */
-	acpiphp_glue_exit();
-}
-
 module_init(acpiphp_init);
-module_exit(acpiphp_exit);
-- 
1.7.9.5

