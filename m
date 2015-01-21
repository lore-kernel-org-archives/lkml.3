Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbbAUCe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 21:34:26 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:56091 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbbAUCc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 21:32:59 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Jiang Liu <jiang.liu@linux.intel.com>, <linux-pci@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, <linux-kernel@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Tony Luck <tony.luck@intel.com>,
        <linux-ia64@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Guan Xuetao" <gxt@mprc.pku.edu.cn>, <linux-alpha@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>, Liviu Dudau <liviu@dudau.co.uk>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Yijing Wang" <wangyijing@huawei.com>
Subject: [PATCH v2 28/30] PCI: Export find_pci_host_bridge()
Date: Wed, 21 Jan 2015 08:30:23 +0800
Message-ID: <1421800225-26230-29-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1421800225-26230-1-git-send-email-wangyijing@huawei.com>
References: <1421800225-26230-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export find_pci_host_bridge().

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/host-bridge.c |    2 +-
 include/linux/pci.h       |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
index 26cefce..288ac69 100644
--- a/drivers/pci/host-bridge.c
+++ b/drivers/pci/host-bridge.c
@@ -104,7 +104,7 @@ static struct pci_bus *find_pci_root_bus(struct pci_bus *bus)
 	return bus;
 }
 
-static struct pci_host_bridge *find_pci_host_bridge(struct pci_bus *bus)
+struct pci_host_bridge *find_pci_host_bridge(struct pci_bus *bus)
 {
 	struct pci_bus *root_bus = find_pci_root_bus(bus);
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 4d9d471..2f6b199 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -427,6 +427,7 @@ void pci_set_host_bridge_release(struct pci_host_bridge *bridge,
 struct pci_host_bridge *pci_create_host_bridge(
 		struct device *parent, u32 dombus, struct list_head *resources, 
 		void *sysdata, struct pci_host_bridge_ops *ops);
+struct pci_host_bridge *find_pci_host_bridge(struct pci_bus* bus);
 /*
  * The first PCI_BRIDGE_RESOURCE_NUM PCI bus resources (those that correspond
  * to P2P or CardBus bridge windows) go in a table.  Additional ones (for
-- 
1.7.1

