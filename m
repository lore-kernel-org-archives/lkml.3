Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab3LELo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 06:44:26 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:56734 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200Ab3LELoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 06:44:25 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 1/3] iommu/amd: Use dev_is_pci() to check whether it is pci device
Date: Thu, 5 Dec 2013 19:42:41 +0800
Message-ID: <1386243761-27400-1-git-send-email-wangyijing@huawei.com>
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
 drivers/iommu/amd_iommu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 72531f0..faf0da4 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -248,8 +248,8 @@ static bool check_device(struct device *dev)
 	if (!dev || !dev->dma_mask)
 		return false;
 
-	/* No device or no PCI device */
-	if (dev->bus != &pci_bus_type)
+	/* No PCI device */
+	if (!dev_is_pci(dev))
 		return false;
 
 	devid = get_device_id(dev);
-- 
1.7.1


