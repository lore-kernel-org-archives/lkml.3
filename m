Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab3KZBeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 20:34:05 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27749 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab3KZBeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 20:34:03 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 06/10] PCI: Add pcibios_bus_addr_to_res()
Date: Mon, 25 Nov 2013 17:28:06 -0800
Message-Id: <1385429290-25397-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385429290-25397-1-git-send-email-yinghai@kernel.org>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it takes addr and return converted address only.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/host-bridge.c | 14 ++++++++++++++
 include/linux/pci.h       |  2 ++
 2 files changed, 16 insertions(+)

diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
index 2e7288b..c911adb 100644
--- a/drivers/pci/host-bridge.c
+++ b/drivers/pci/host-bridge.c
@@ -102,3 +102,17 @@ void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
 	__pcibios_bus_to_resource(dev->bus, res, region);
 }
 EXPORT_SYMBOL(pcibios_bus_to_resource);
+
+resource_size_t pcibios_bus_addr_to_res(struct pci_bus *bus, int flags,
+					resource_size_t addr)
+{
+	struct pci_bus_region region;
+	struct resource r;
+
+	r.flags = flags;
+	region.start = addr;
+	region.end = addr;
+	__pcibios_bus_to_resource(bus, &r, &region);
+
+	return r.end;
+}
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 55ee90f..3c6e399 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -745,6 +745,8 @@ void pcibios_resource_to_bus(struct pci_dev *dev, struct pci_bus_region *region,
 			     struct resource *res);
 void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
 			     struct pci_bus_region *region);
+resource_size_t pcibios_bus_addr_to_res(struct pci_bus *bus, int flags,
+					resource_size_t addr);
 void pcibios_scan_specific_bus(int busn);
 struct pci_bus *pci_find_bus(int domain, int busnr);
 void pci_bus_add_devices(const struct pci_bus *bus);
-- 
1.8.1.4

