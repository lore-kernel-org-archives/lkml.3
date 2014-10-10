Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbaJJL4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 07:56:24 -0400
Received: from smtp.citrix.com ([66.165.176.89]:65433 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbaJJLyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 07:54:14 -0400
X-IronPort-AV: E=Sophos;i="5.04,691,1406592000"; 
   d="scan'208";a="180114186"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <Stefano.Stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <will.deacon@arm.com>
Subject: [PATCH v4 3/7] [RFC] arm/arm64: introduce is_dma_coherent
Date: Fri, 10 Oct 2014 12:51:44 +0100
Message-ID: <1412941908-5850-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1410101244090.17038@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1410101244090.17038@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a function to check whether a device is dma coherent.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: linux@arm.linux.org.uk
CC: catalin.marinas@arm.com
CC: will.deacon@arm.com
CC: linux-arm-kernel@lists.infradead.org
---
 arch/arm/include/asm/dma-mapping.h   |    6 ++++++
 arch/arm64/include/asm/dma-mapping.h |    5 +++++
 2 files changed, 11 insertions(+)

diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index c45b61a..bededbb 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -126,6 +126,12 @@ static inline int set_arch_dma_coherent_ops(struct device *dev)
 	set_dma_ops(dev, &arm_coherent_dma_ops);
 	return 0;
 }
+
+static inline bool is_dma_coherent(struct device *dev)
+{
+    return (__generic_dma_ops(dev) == &arm_coherent_dma_ops);
+}
+
 #define set_arch_dma_coherent_ops(dev)	set_arch_dma_coherent_ops(dev)
 
 static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
index dc82e52..d51d67e 100644
--- a/arch/arm64/include/asm/dma-mapping.h
+++ b/arch/arm64/include/asm/dma-mapping.h
@@ -52,6 +52,11 @@ static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
 	dev->archdata.dma_ops = ops;
 }
 
+static inline bool is_dma_coherent(struct device *dev)
+{
+    return (__generic_dma_ops(dev) == &coherent_swiotlb_dma_ops);
+}
+
 #include <asm-generic/dma-mapping-common.h>
 
 static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
-- 
1.7.10.4

