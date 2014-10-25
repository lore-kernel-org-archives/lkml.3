Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaJYSZT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:25:19 -0400
Received: from smtp.citrix.com ([66.165.176.89]:58187 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbaJYSZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:25:16 -0400
X-IronPort-AV: E=Sophos;i="5.04,786,1406592000"; 
   d="scan'208";a="184886129"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <Stefano.Stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <catalin.marinas@arm.com>, <Will.Deacon@arm.com>
Subject: [PATCH v6 3/7] xen/arm: introduce is_dma_coherent
Date: Sat, 25 Oct 2014 14:57:18 +0100
Message-ID: <1414245442-4306-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1410251450180.22875@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1410251450180.22875@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a simple utility function that returns whether a device is dma
coherent based on device tree information.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: catalin.marinas@arm.com
CC: Will.Deacon@arm.com
---
 arch/arm/xen/mm32.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/xen/mm32.c b/arch/arm/xen/mm32.c
index 6153d61..2b259f1 100644
--- a/arch/arm/xen/mm32.c
+++ b/arch/arm/xen/mm32.c
@@ -2,10 +2,16 @@
 #include <linux/dma-mapping.h>
 #include <linux/gfp.h>
 #include <linux/highmem.h>
+#include <linux/of_address.h>
 
 #include <xen/features.h>
 
 
+static inline bool is_dma_coherent(struct device *dev)
+{
+	return of_dma_is_coherent(dev->of_node);
+}
+
 /* functions called by SWIOTLB */
 
 static void dma_cache_maint(dma_addr_t handle, unsigned long offset,
-- 
1.7.10.4

