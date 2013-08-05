Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab3HEQbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:31:36 -0400
Received: from smtp.citrix.com ([66.165.176.89]:19601 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180Ab3HEQbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:31:34 -0400
X-IronPort-AV: E=Sophos;i="4.89,819,1367971200"; 
   d="scan'208";a="41429576"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <catalin.marinas@arm.com>, <will.deacon@arm.com>
Subject: [PATCH v3 05/10] arm64: do not initialize arm64_swiotlb if dma_ops is already set
Date: Mon, 5 Aug 2013 17:30:51 +0100
Message-ID: <1375720256-8014-5-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1308051503190.4893@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1308051503190.4893@kaball.uk.xensource.com>
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

