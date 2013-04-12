Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab3DLPqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 11:46:34 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:46846 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab3DLPq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 11:46:26 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Yijing Wang <wangyijing@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v9 03/16] PCI/acpiphp: use list_for_each_entry_safe() in acpiphp_sanitize_bus()
Date: Fri, 12 Apr 2013 23:44:17 +0800
Message-Id: <1365781470-32379-4-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com>
References: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yijing Wang <wangyijing@huawei.com>

Function acpiphp_sanitize_bus() may call pci_stop_and_remove_bus_device(),
which in turn may remove device from bus->devices list. So walk the
bus->devices list with list_for_each_entry_safe().

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pci/hotplug/acpiphp_glue.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 270fdba..7948bc9 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -1082,11 +1082,11 @@ static void acpiphp_set_hpp_values(struct pci_bus *bus)
  */
 static void acpiphp_sanitize_bus(struct pci_bus *bus)
 {
-	struct pci_dev *dev;
+	struct pci_dev *dev, *tmp;
 	int i;
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM;
 
-	list_for_each_entry(dev, &bus->devices, bus_list) {
+	list_for_each_entry_safe(dev, tmp, &bus->devices, bus_list) {
 		for (i=0; i<PCI_BRIDGE_RESOURCES; i++) {
 			struct resource *res = &dev->resource[i];
 			if ((res->flags & type_mask) && !res->start &&
-- 
1.7.9.5

