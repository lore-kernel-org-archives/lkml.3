Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbaFFWHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 18:07:38 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:7667
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752092AbaFFWHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 18:07:37 -0400
X-WSS-ID: 0N6RPGF-08-4Q2-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <catalin.marinas@arm.com>, <Will.Deacon@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <thomas.lendacky@amd.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH] arm64/dma: Removing ARCH_HAS_DMA_GET_REQUIRED_MASK macro
Date: Fri, 6 Jun 2014 17:07:16 -0500
Message-ID: <1402092436-2144-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428001)(199002)(189002)(19580405001)(87936001)(97736001)(88136002)(89996001)(44976005)(102836001)(19580395003)(83322001)(87286001)(53416003)(36756003)(68736004)(84676001)(77156001)(101416001)(77982001)(33646001)(99396002)(104166001)(76482001)(50226001)(4396001)(50466002)(21056001)(86152002)(92726001)(92566001)(48376002)(50986999)(83072002)(85852003)(31966008)(86362001)(93916002)(46102001)(74662001)(80022001)(74502001)(79102001)(64706001)(47776003)(20776003)(81542001)(81342001)(62966002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR02MB050;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 023495660C
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

Arm64 does not define dma_get_required_mask() function.
Therefore, it should not define the ARCH_HAS_DMA_GET_REQUIRED_MASK.
This causes build errors in some device drivers (e.g. mpt2sas)

Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
---
 arch/arm64/include/asm/dma-mapping.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
index 3a4572e..dc82e52 100644
--- a/arch/arm64/include/asm/dma-mapping.h
+++ b/arch/arm64/include/asm/dma-mapping.h
@@ -26,8 +26,6 @@
 #include <xen/xen.h>
 #include <asm/xen/hypervisor.h>
 
-#define ARCH_HAS_DMA_GET_REQUIRED_MASK
-
 #define DMA_ERROR_CODE	(~(dma_addr_t)0)
 extern struct dma_map_ops *dma_ops;
 extern struct dma_map_ops coherent_swiotlb_dma_ops;
-- 
1.9.0

