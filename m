Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965497Ab3FTQMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 12:12:00 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:48147
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161051Ab3FTQL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 12:11:59 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <joro@8bytes.org>, <iommu@lists.linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <benh@kernel.crashing.org>, <galak@kernel.crashing.org>,
        <stuart.yoder@freescale.com>, <scottwood@freescale.com>,
        <alex.williamson@redhat.com>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 1/3 v11] powerpc: Add iommu domain pointer to device archdata
Date: Thu, 20 Jun 2013 21:31:29 +0530
Message-ID: <1371744089-17780-3-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1371744089-17780-1-git-send-email-Varun.Sethi@freescale.com>
References: <1371744089-17780-1-git-send-email-Varun.Sethi@freescale.com>
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
Acked-by: Kumar Gala <galak@kernel.crashing.org>
---
- no change in v11.
- no change in v10.
- Added CONFIG_IOMMU_API in v9.
 arch/powerpc/include/asm/device.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/device.h b/arch/powerpc/include/asm/device.h
index 77e97dd..38faede 100644
--- a/arch/powerpc/include/asm/device.h
+++ b/arch/powerpc/include/asm/device.h
@@ -28,6 +28,9 @@ struct dev_archdata {
 		void		*iommu_table_base;
 	} dma_data;
 
+#ifdef CONFIG_IOMMU_API
+	void			*iommu_domain;
+#endif
 #ifdef CONFIG_SWIOTLB
 	dma_addr_t		max_direct_dma_addr;
 #endif
-- 
1.7.4.1


