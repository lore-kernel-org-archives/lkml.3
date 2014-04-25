Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbaDYJVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:21:18 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:48860 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbaDYJT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:19:59 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, <linux-ia64@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <sparclinux@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, <x86@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 13/13] PCI, pciehp: Use new pci_is_bridge() to simplify code
Date: Fri, 25 Apr 2014 17:18:35 +0800
Message-ID: <1398417515-8740-14-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
In-Reply-To: <1398417515-8740-1-git-send-email-wangyijing@huawei.com>
References: <1398417515-8740-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we can use new pci_is_bridge() helper function
to simplify code.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/hotplug/pciehp_pci.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_pci.c b/drivers/pci/hotplug/pciehp_pci.c
index 1b53306..b6cb1df 100644
--- a/drivers/pci/hotplug/pciehp_pci.c
+++ b/drivers/pci/hotplug/pciehp_pci.c
@@ -62,8 +62,7 @@ int pciehp_configure_device(struct slot *p_slot)
 	}
 
 	list_for_each_entry(dev, &parent->devices, bus_list)
-		if ((dev->hdr_type == PCI_HEADER_TYPE_BRIDGE) ||
-				(dev->hdr_type == PCI_HEADER_TYPE_CARDBUS))
+		if (pci_is_bridge(dev))
 			pci_hp_add_bridge(dev);
 
 	pci_assign_unassigned_bridge_resources(bridge);
-- 
1.7.1


