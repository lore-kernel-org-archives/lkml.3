Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab3LELdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 06:33:44 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:52373 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab3LELdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 06:33:41 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
CC: "David S. Miller" <davem@davemloft.net>, <dmaengine@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Yijing Wang <wangyijing@huawei.com>,
        "Hanjun Guo" <guohanjun@huawei.com>
Subject: [PATCH] ioat/dca: Use dev_is_pci() to check whether it is pci device
Date: Thu, 5 Dec 2013 19:31:18 +0800
Message-ID: <1386243078-27676-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI standard marco dev_is_pci() instead of directly compare
pci_bus_type to check whether it is pci device.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/dma/ioat/dca.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/ioat/dca.c b/drivers/dma/ioat/dca.c
index 9e84d5b..7900963 100644
--- a/drivers/dma/ioat/dca.c
+++ b/drivers/dma/ioat/dca.c
@@ -147,7 +147,7 @@ static int ioat_dca_add_requester(struct dca_provider *dca, struct device *dev)
 	u16 id;
 
 	/* This implementation only supports PCI-Express */
-	if (dev->bus != &pci_bus_type)
+	if (!dev_is_pci(dev))
 		return -ENODEV;
 	pdev = to_pci_dev(dev);
 	id = dcaid_from_pcidev(pdev);
@@ -179,7 +179,7 @@ static int ioat_dca_remove_requester(struct dca_provider *dca,
 	int i;
 
 	/* This implementation only supports PCI-Express */
-	if (dev->bus != &pci_bus_type)
+	if (!dev_is_pci(dev))
 		return -ENODEV;
 	pdev = to_pci_dev(dev);
 
@@ -320,7 +320,7 @@ static int ioat2_dca_add_requester(struct dca_provider *dca, struct device *dev)
 	u16 global_req_table;
 
 	/* This implementation only supports PCI-Express */
-	if (dev->bus != &pci_bus_type)
+	if (!dev_is_pci(dev))
 		return -ENODEV;
 	pdev = to_pci_dev(dev);
 	id = dcaid_from_pcidev(pdev);
@@ -354,7 +354,7 @@ static int ioat2_dca_remove_requester(struct dca_provider *dca,
 	u16 global_req_table;
 
 	/* This implementation only supports PCI-Express */
-	if (dev->bus != &pci_bus_type)
+	if (!dev_is_pci(dev))
 		return -ENODEV;
 	pdev = to_pci_dev(dev);
 
@@ -496,7 +496,7 @@ static int ioat3_dca_add_requester(struct dca_provider *dca, struct device *dev)
 	u16 global_req_table;
 
 	/* This implementation only supports PCI-Express */
-	if (dev->bus != &pci_bus_type)
+	if (!dev_is_pci(dev))
 		return -ENODEV;
 	pdev = to_pci_dev(dev);
 	id = dcaid_from_pcidev(pdev);
@@ -530,7 +530,7 @@ static int ioat3_dca_remove_requester(struct dca_provider *dca,
 	u16 global_req_table;
 
 	/* This implementation only supports PCI-Express */
-	if (dev->bus != &pci_bus_type)
+	if (!dev_is_pci(dev))
 		return -ENODEV;
 	pdev = to_pci_dev(dev);
 
-- 
1.7.1


