Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540Ab3DAInn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 04:43:43 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:19780 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737Ab3DAInm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 04:43:42 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Tony Luck <tony.luck@intel.com>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>, <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Shengzhou Liu <Shengzhou.Liu@freescale.com>
Subject: [PATCH 1/2] PCI: decrease pci_dev->enable_cnt when no pcie capability found
Date: Mon, 1 Apr 2013 16:42:54 +0800
Message-ID: <1364805775-12396-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should decrease dev->enable_cnt when no pcie port capability
found for balance.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Shengzhou Liu <Shengzhou.Liu@freescale.com>
---
 drivers/pci/pcie/portdrv_core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 31063ac..dd95d6f 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -369,8 +369,10 @@ int pcie_port_device_register(struct pci_dev *dev)
 
 	/* Get and check PCI Express port services */
 	capabilities = get_port_device_capability(dev);
-	if (!capabilities)
+	if (!capabilities) {
+		pci_disable_device(dev);
 		return 0;
+	}
 
 	pci_set_master(dev);
 	/*
-- 
1.7.1


