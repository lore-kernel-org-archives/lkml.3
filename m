Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab3EYNvn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 09:51:43 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:53392 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756621Ab3EYNvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 09:51:38 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: [PATCH v3, part1 04/10] PCI: mark pci_scan_bus_parented() as __deprecated
Date: Sat, 25 May 2013 21:48:32 +0800
Message-Id: <1369489718-25869-5-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369489718-25869-1-git-send-email-jiang.liu@huawei.com>
References: <1369489718-25869-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark pci_scan_bus_parented() as __deprecated and clean up outdated
comments.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 arch/tile/kernel/pci.c | 3 ---
 include/linux/pci.h    | 4 ++--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
index 67237d3..936e087 100644
--- a/arch/tile/kernel/pci.c
+++ b/arch/tile/kernel/pci.c
@@ -309,9 +309,6 @@ int __init pcibios_init(void)
 			 *
 			 * It reads the PCI tree for this bus into the Linux
 			 * data structures.
-			 *
-			 * This is inlined in linux/pci.h and calls into
-			 * pci_scan_bus_parented() in probe.c.
 			 */
 			pci_add_resource(&resources, &ioport_resource);
 			pci_add_resource(&resources, &iomem_resource);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index b0f4a82..7b23fa0 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -720,8 +720,8 @@ void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
 void pcibios_scan_specific_bus(int busn);
 struct pci_bus *pci_find_bus(int domain, int busnr);
 void pci_bus_add_devices(const struct pci_bus *bus);
-struct pci_bus *pci_scan_bus_parented(struct device *parent, int bus,
-				      struct pci_ops *ops, void *sysdata);
+struct pci_bus * __deprecated pci_scan_bus_parented(struct device *parent,
+			int bus, struct pci_ops *ops, void *sysdata);
 struct pci_bus *pci_scan_bus(int bus, struct pci_ops *ops, void *sysdata);
 struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 				    struct pci_ops *ops, void *sysdata,
-- 
1.8.1.2

