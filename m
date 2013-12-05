Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab3LEMGC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 07:06:02 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:64844 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab3LEMF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 07:05:58 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Russell King <linux@arm.linux.org.uk>,
        Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khc@pm.waw.pl>
CC: <linux-pci@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Yijing Wang <wangyijing@huawei.com>,
        "Hanjun Guo" <guohanjun@huawei.com>
Subject: [PATCH 8/9] arm/mach-ixp4xx: Use dev_is_pci() to check whether it is pci device
Date: Thu, 5 Dec 2013 20:03:25 +0800
Message-ID: <1386245005-32096-1-git-send-email-wangyijing@huawei.com>
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
 arch/arm/mach-ixp4xx/common-pci.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-ixp4xx/common-pci.c b/arch/arm/mach-ixp4xx/common-pci.c
index 6d6bde3..e45559a 100644
--- a/arch/arm/mach-ixp4xx/common-pci.c
+++ b/arch/arm/mach-ixp4xx/common-pci.c
@@ -326,7 +326,7 @@ static int ixp4xx_needs_bounce(struct device *dev, dma_addr_t dma_addr, size_t s
  */
 static int ixp4xx_pci_platform_notify(struct device *dev)
 {
-	if(dev->bus == &pci_bus_type) {
+	if (dev_is_pci(dev)) {
 		*dev->dma_mask =  SZ_64M - 1;
 		dev->coherent_dma_mask = SZ_64M - 1;
 		dmabounce_register_dev(dev, 2048, 4096, ixp4xx_needs_bounce);
@@ -336,9 +336,9 @@ static int ixp4xx_pci_platform_notify(struct device *dev)
 
 static int ixp4xx_pci_platform_notify_remove(struct device *dev)
 {
-	if(dev->bus == &pci_bus_type) {
+	if (dev_is_pci(dev))
 		dmabounce_unregister_dev(dev);
-	}
+
 	return 0;
 }
 
-- 
1.7.1


