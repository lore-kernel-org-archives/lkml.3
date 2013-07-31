Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760854Ab3GaT4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 15:56:11 -0400
Received: from smtp.citrix.com ([66.165.176.89]:46045 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760675Ab3GaTyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 15:54:31 -0400
X-IronPort-AV: E=Sophos;i="4.89,789,1367971200"; 
   d="scan'208";a="40581748"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <catalin.marinas@arm.com>, <will.deacon@arm.com>
Subject: [PATCH v2 RFC 3/8] arm64: do not initialize arm64_swiotlb if dma_ops is already set
Date: Wed, 31 Jul 2013 20:54:07 +0100
Message-ID: <1375300452-12545-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1307312048511.4893@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1307312048511.4893@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: catalin.marinas@arm.com
CC: will.deacon@arm.com
---
 arch/arm64/mm/dma-mapping.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/mm/dma-mapping.c b/arch/arm64/mm/dma-mapping.c
index 4bd7579..a006e84 100644
--- a/arch/arm64/mm/dma-mapping.c
+++ b/arch/arm64/mm/dma-mapping.c
@@ -63,6 +63,8 @@ static struct dma_map_ops arm64_swiotlb_dma_ops = {
 
 void __init arm64_swiotlb_init(void)
 {
+	if (dma_ops != NULL)
+		return;
 	dma_ops = &arm64_swiotlb_dma_ops;
 	swiotlb_init(1);
 }
-- 
1.7.2.5

