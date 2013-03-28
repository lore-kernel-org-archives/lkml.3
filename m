Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab3C1UCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 16:02:23 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:1367 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753283Ab3C1UCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 16:02:20 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <joro@8bytes.org>, <stuart.yoder@freescale.com>, <scottwood@freescale.com>,
        <iommu@lists.linux-foundation.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <galak@kernel.crashing.org>,
        <benh@kernel.crashing.org>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 2/5 v11] powerpc: Add iommu domain pointer to device archdata
Date: Fri, 29 Mar 2013 01:23:59 +0530
Message-ID: <1364500442-20927-3-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1364500442-20927-1-git-send-email-Varun.Sethi@freescale.com>
References: <1364500442-20927-1-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an iommu domain pointer to device (powerpc) archdata.  Devices
are attached to iommu domains and this pointer provides a mechanism
to correlate between a device and the associated iommu domain.  This
field is set when a device is attached to a domain.

Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
---
- no change in v11.
- no change in v10.
- Added CONFIG_IOMMU_API in v9.
 arch/powerpc/include/asm/device.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/device.h b/arch/powerpc/include/asm/device.h
index 77e97dd..2d5c1c5 100644
--- a/arch/powerpc/include/asm/device.h
+++ b/arch/powerpc/include/asm/device.h
@@ -28,6 +28,12 @@ struct dev_archdata {
 		void		*iommu_table_base;
 	} dma_data;
 
+	/* IOMMU domain information pointer. This would be set
+	 * when this device is attached to an iommu_domain.
+	 */
+#ifdef CONFIG_IOMMU_API
+	void			*iommu_domain;
+#endif
 #ifdef CONFIG_SWIOTLB
 	dma_addr_t		max_direct_dma_addr;
 #endif
-- 
1.7.4.1


