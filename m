Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab3FEMPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 08:15:44 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:43345 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab3FEMPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 08:15:42 -0400
X-IronPort-AV: E=Sophos;i="4.87,806,1363132800"; 
   d="scan'208";a="27976484"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        <Stefano.Stabellini@eu.citrix.com>, <will.deacon@arm.com>,
        <catalin.marinas@arm.com>, <Ian.Campbell@citrix.com>,
        <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v3 3/6] arm64/xen: implement ioremap_cached on arm64
Date: Wed, 5 Jun 2013 13:15:27 +0100
Message-ID: <1370434530-22428-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1306041712100.4589@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1306041712100.4589@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm64/include/asm/io.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 2e12258..1d12f89 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -228,10 +228,12 @@ extern void __iounmap(volatile void __iomem *addr);
 #define PROT_DEFAULT		(PTE_TYPE_PAGE | PTE_AF | PTE_DIRTY)
 #define PROT_DEVICE_nGnRE	(PROT_DEFAULT | PTE_PXN | PTE_UXN | PTE_ATTRINDX(MT_DEVICE_nGnRE))
 #define PROT_NORMAL_NC		(PROT_DEFAULT | PTE_ATTRINDX(MT_NORMAL_NC))
+#define PROT_NORMAL		(PROT_DEFAULT | PTE_ATTRINDX(MT_NORMAL))
 
 #define ioremap(addr, size)		__ioremap((addr), (size), __pgprot(PROT_DEVICE_nGnRE))
 #define ioremap_nocache(addr, size)	__ioremap((addr), (size), __pgprot(PROT_DEVICE_nGnRE))
 #define ioremap_wc(addr, size)		__ioremap((addr), (size), __pgprot(PROT_NORMAL_NC))
+#define ioremap_cached(addr, size)	__ioremap((addr), (size), __pgprot(PROT_NORMAL))
 #define iounmap				__iounmap
 
 #define PROT_SECT_DEFAULT	(PMD_TYPE_SECT | PMD_SECT_AF)
-- 
1.7.2.5

