Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab3LEMFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 07:05:31 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:64568 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145Ab3LEMF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 07:05:26 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Russell King <linux@arm.linux.org.uk>
CC: <linux-pci@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Yijing Wang <wangyijing@huawei.com>,
        "Hanjun Guo" <guohanjun@huawei.com>
Subject: [PATCH 7/9] arm/pci: Use dev_is_pci() to check whether it is pci device
Date: Thu, 5 Dec 2013 20:02:23 +0800
Message-ID: <1386244943-31016-1-git-send-email-wangyijing@huawei.com>
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
 arch/arm/common/it8152.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/common/it8152.c b/arch/arm/common/it8152.c
index 001f491..5114b68 100644
--- a/arch/arm/common/it8152.c
+++ b/arch/arm/common/it8152.c
@@ -257,7 +257,7 @@ static int it8152_needs_bounce(struct device *dev, dma_addr_t dma_addr, size_t s
  */
 static int it8152_pci_platform_notify(struct device *dev)
 {
-	if (dev->bus == &pci_bus_type) {
+	if (dev_is_pci(dev)) {
 		if (dev->dma_mask)
 			*dev->dma_mask = (SZ_64M - 1) | PHYS_OFFSET;
 		dev->coherent_dma_mask = (SZ_64M - 1) | PHYS_OFFSET;
@@ -268,7 +268,7 @@ static int it8152_pci_platform_notify(struct device *dev)
 
 static int it8152_pci_platform_notify_remove(struct device *dev)
 {
-	if (dev->bus == &pci_bus_type)
+	if (dev_is_pci(dev))
 		dmabounce_unregister_dev(dev);
 
 	return 0;
-- 
1.7.1


