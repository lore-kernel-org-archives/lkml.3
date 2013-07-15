Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab3GOFCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 01:02:00 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:32668
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752399Ab3GOFB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 01:01:58 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1155h)
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <joro@8bytes.org>, <iommu@lists.linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <benh@kernel.crashing.org>, <galak@kernel.crashing.org>,
        <alex.williamson@redhat.com>, <stuart.yoder@freescale.com>,
        <scottwood@freescale.com>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 1/3] powerpc: Add iommu domain pointer to device archdata
Date: Mon, 15 Jul 2013 10:20:55 +0530
Message-ID: <1373863857-27239-1-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
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
- rebased patch to 3.11-rc1
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


