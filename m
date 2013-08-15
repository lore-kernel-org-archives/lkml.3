Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab3HOLMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 07:12:43 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:32581 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab3HOLLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 07:11:05 -0400
X-IronPort-AV: E=Sophos;i="4.89,885,1367971200"; 
   d="scan'208";a="42396945"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <will.deacon@arm.com>, <linux@arm.linux.org.uk>
Subject: [PATCH v4 04/10] arm: introduce a global dma_ops pointer
Date: Thu, 15 Aug 2013 12:10:48 +0100
Message-ID: <1376565054-24153-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1308151200580.4470@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1308151200580.4470@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initially set dma_ops to arm_dma_ops.


Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: will.deacon@arm.com
CC: linux@arm.linux.org.uk


Changes in v3:
-  keep using arm_dma_ops in dmabounce.
---
 arch/arm/include/asm/dma-mapping.h |    3 ++-
 arch/arm/mm/dma-mapping.c          |    3 +++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index 5b8eef9..5c130bc 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -12,6 +12,7 @@
 #include <asm/memory.h>
 
 #define DMA_ERROR_CODE	(~0)
+extern struct dma_map_ops *dma_ops;
 extern struct dma_map_ops arm_dma_ops;
 extern struct dma_map_ops arm_coherent_dma_ops;
 
@@ -19,7 +20,7 @@ static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	if (dev && dev->archdata.dma_ops)
 		return dev->archdata.dma_ops;
-	return &arm_dma_ops;
+	return dma_ops;
 }
 
 static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 7f9b179..870b12c 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -141,6 +141,9 @@ struct dma_map_ops arm_dma_ops = {
 };
 EXPORT_SYMBOL(arm_dma_ops);
 
+struct dma_map_ops *dma_ops = &arm_dma_ops;
+EXPORT_SYMBOL(dma_ops);
+
 static void *arm_coherent_dma_alloc(struct device *dev, size_t size,
 	dma_addr_t *handle, gfp_t gfp, struct dma_attrs *attrs);
 static void arm_coherent_dma_free(struct device *dev, size_t size, void *cpu_addr,
-- 
1.7.2.5

