Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab3LEMFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 07:05:15 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:20095 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab3LEMFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 07:05:11 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
CC: <linux-pci@vger.kernel.org>, <linux-alpha@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Yijing Wang <wangyijing@huawei.com>,
        "Hanjun Guo" <guohanjun@huawei.com>
Subject: [PATCH 9/9] alpha/pci: Use dev_is_pci() to check whether it is pci device
Date: Thu, 5 Dec 2013 20:04:41 +0800
Message-ID: <1386245081-27912-1-git-send-email-wangyijing@huawei.com>
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
 arch/alpha/kernel/pci_iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index a21d0ab..eddee77 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -325,7 +325,7 @@ pci_map_single_1(struct pci_dev *pdev, void *cpu_addr, size_t size,
 /* Helper for generic DMA-mapping functions. */
 static struct pci_dev *alpha_gendev_to_pci(struct device *dev)
 {
-	if (dev && dev->bus == &pci_bus_type)
+	if (dev && dev_is_pci(dev))
 		return to_pci_dev(dev);
 
 	/* Assume that non-PCI devices asking for DMA are either ISA or EISA,
-- 
1.7.1


