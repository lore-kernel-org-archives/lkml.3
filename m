Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610Ab3DAJX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:23:27 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:27879 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408Ab3DAJX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:23:26 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
CC: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Rafael <rjw@sisk.pl>, Hanjun Guo <guohanjun@huawei.com>,
        <jiang.liu@huawei.com>, Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3/3] PCI, pciehp: remove check for configure display devices
Date: Mon, 1 Apr 2013 17:22:08 +0800
Message-ID: <1364808128-12792-3-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
In-Reply-To: <1364808128-12792-1-git-send-email-wangyijing@huawei.com>
References: <1364808128-12792-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ac81860 removed unnecessary check for hotplug of display
device. Currently pciehp is allowd to hotplug display device,
So we also configure display device when hot added.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/hotplug/pciehp_pci.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_pci.c b/drivers/pci/hotplug/pciehp_pci.c
index aac7a40..c9d2df3 100644
--- a/drivers/pci/hotplug/pciehp_pci.c
+++ b/drivers/pci/hotplug/pciehp_pci.c
@@ -64,12 +64,8 @@ int pciehp_configure_device(struct slot *p_slot)
 
 	pci_assign_unassigned_bridge_resources(bridge);
 
-	list_for_each_entry(dev, &parent->devices, bus_list) {
-		if ((dev->class >> 16) == PCI_BASE_CLASS_DISPLAY)
-			continue;
-
+	list_for_each_entry(dev, &parent->devices, bus_list)
 		pci_configure_slot(dev);
-	}
 
 	pci_bus_add_devices(parent);
 
-- 
1.7.1


