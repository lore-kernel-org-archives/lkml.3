Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab3EYNvR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 09:51:17 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42594 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447Ab3EYNvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 09:51:14 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3, part1 01/10] PCI: introduce pci_bus_{get|put}() to manage PCI bus reference count
Date: Sat, 25 May 2013 21:48:29 +0800
Message-Id: <1369489718-25869-2-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369489718-25869-1-git-send-email-jiang.liu@huawei.com>
References: <1369489718-25869-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce helper functions pci_bus_{get|put}() to manage PCI bus
reference count.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pci/bus.c   | 15 +++++++++++++++
 include/linux/pci.h |  2 ++
 2 files changed, 17 insertions(+)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 32e66a6..b1ff02a 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -283,6 +283,21 @@ void pci_walk_bus(struct pci_bus *top, int (*cb)(struct pci_dev *, void *),
 }
 EXPORT_SYMBOL_GPL(pci_walk_bus);
 
+struct pci_bus *pci_bus_get(struct pci_bus *bus)
+{
+	if (bus)
+		get_device(&bus->dev);
+	return bus;
+}
+EXPORT_SYMBOL(pci_bus_get);
+
+void pci_bus_put(struct pci_bus *bus)
+{
+	if (bus)
+		put_device(&bus->dev);
+}
+EXPORT_SYMBOL(pci_bus_put);
+
 EXPORT_SYMBOL(pci_bus_alloc_resource);
 EXPORT_SYMBOL_GPL(pci_bus_add_device);
 EXPORT_SYMBOL(pci_bus_add_devices);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 3a24e4f..7556c59 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1018,6 +1018,8 @@ int pci_request_selected_regions_exclusive(struct pci_dev *, int, const char *);
 void pci_release_selected_regions(struct pci_dev *, int);
 
 /* drivers/pci/bus.c */
+struct pci_bus *pci_bus_get(struct pci_bus *bus);
+void pci_bus_put(struct pci_bus *bus);
 void pci_add_resource(struct list_head *resources, struct resource *res);
 void pci_add_resource_offset(struct list_head *resources, struct resource *res,
 			     resource_size_t offset);
-- 
1.8.1.2

