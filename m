Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbbAPDrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 22:47:35 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:41178 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbbAPDra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 22:47:30 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Jiang Liu <jiang.liu@linux.intel.com>, <linux-pci@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, <linux-kernel@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        <linux-ia64@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Guan Xuetao" <gxt@mprc.pku.edu.cn>, <linux-alpha@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>, Liviu Dudau <liviu@dudau.co.uk>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Yijing Wang" <wangyijing@huawei.com>
Subject: [PATCH 17/28] PCI: Remove weak pcibios_root_bridge_prepare()
Date: Fri, 16 Jan 2015 09:44:15 +0800
Message-ID: <1421372666-12288-18-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1421372666-12288-1-git-send-email-wangyijing@huawei.com>
References: <1421372666-12288-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now no one use weak pcibios_root_bridge_prepare(),
we could remove it.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/probe.c |   15 ---------------
 include/linux/pci.h |    2 --
 2 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 51d69c3..30323ac 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1844,18 +1844,6 @@ unsigned int pci_scan_child_bus(struct pci_bus *bus)
 }
 EXPORT_SYMBOL_GPL(pci_scan_child_bus);
 
-/**
- * pcibios_root_bridge_prepare - Platform-specific host bridge setup.
- * @bridge: Host bridge to set up.
- *
- * Default empty implementation.  Replace with an architecture-specific setup
- * routine, if necessary.
- */
-int __weak pcibios_root_bridge_prepare(struct pci_host_bridge *bridge)
-{
-	return 0;
-}
-
 void __weak pcibios_add_bus(struct pci_bus *bus)
 {
 }
@@ -1890,9 +1878,6 @@ static struct pci_bus *__pci_create_root_bus(
 	b->bridge = get_device(&bridge->dev);
 	if (bridge->ops && bridge->ops->phb_set_root_bus_speed)
 		bridge->ops->phb_set_root_bus_speed(bridge);
-	error = pcibios_root_bridge_prepare(bridge);
-	if (error)
-		goto err_out;
 
 	device_enable_async_suspend(b->bridge);
 	pci_set_bus_of_node(b);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 5592737..da3a071 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -428,8 +428,6 @@ struct pci_host_bridge {
 void pci_set_host_bridge_release(struct pci_host_bridge *bridge,
 		     void (*release_fn)(struct pci_host_bridge *),
 		     void *release_data);
-
-int pcibios_root_bridge_prepare(struct pci_host_bridge *bridge);
 struct pci_host_bridge *pci_create_host_bridge(
 		struct device *parent, u32 dombus, struct list_head *resources, 
 		void *sysdata, struct pci_host_bridge_ops *ops);
-- 
1.7.1

