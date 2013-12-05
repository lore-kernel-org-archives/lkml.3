Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab3LEMDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 07:03:08 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:63538 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393Ab3LEMDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 07:03:05 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: <linux-pci@vger.kernel.org>, Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, Yijing Wang <wangyijing@huawei.com>,
        "Hanjun Guo" <guohanjun@huawei.com>
Subject: [PATCH 6/9] powerpc/pci: Use dev_is_pci() to check whether it is pci device
Date: Thu, 5 Dec 2013 20:01:20 +0800
Message-ID: <1386244880-22300-1-git-send-email-wangyijing@huawei.com>
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
 arch/powerpc/sysdev/fsl_pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
index 4dfd61d..7066e52 100644
--- a/arch/powerpc/sysdev/fsl_pci.c
+++ b/arch/powerpc/sysdev/fsl_pci.c
@@ -122,7 +122,7 @@ static int fsl_pci_dma_set_mask(struct device *dev, u64 dma_mask)
 	 * address width of the SoC such that we can address any internal
 	 * SoC address from across PCI if needed
 	 */
-	if ((dev->bus == &pci_bus_type) &&
+	if ((dev_is_pci(dev)) &&
 	    dma_mask >= DMA_BIT_MASK(MAX_PHYS_ADDR_BITS)) {
 		set_dma_ops(dev, &dma_direct_ops);
 		set_dma_offset(dev, pci64_dma_offset);
-- 
1.7.1


