Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968259Ab3DSKtr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 06:49:47 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:7068 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968140Ab3DSKsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 06:48:33 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 13/15] powerpc/85xx: add support for e6500 L1 cache operation
Date: Fri, 19 Apr 2013 18:47:46 +0800
Message-ID: <1366368468-29143-13-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1366368468-29143-1-git-send-email-chenhui.zhao@freescale.com>
References: <1366368468-29143-1-git-send-email-chenhui.zhao@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen-Hui Zhao <chenhui.zhao@freescale.com>

The L1 Data Cache of e6500 contains no modified data, no flush
is required.

Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
Signed-off-by: Li Yang <leoli@freescale.com>
Signed-off-by: Andy Fleming <afleming@freescale.com>
---
 arch/powerpc/kernel/fsl_booke_cache.S |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/fsl_booke_cache.S b/arch/powerpc/kernel/fsl_booke_cache.S
index 232c47b..24a52bb 100644
--- a/arch/powerpc/kernel/fsl_booke_cache.S
+++ b/arch/powerpc/kernel/fsl_booke_cache.S
@@ -65,13 +65,22 @@ _GLOBAL(flush_dcache_L1)
 
 	blr
 
+#define PVR_E6500	0x8040
+
 /* Flush L1 d-cache, invalidate and disable d-cache and i-cache */
 _GLOBAL(__flush_disable_L1)
+/* L1 Data Cache of e6500 contains no modified data, no flush is required */
+	mfspr	r3, SPRN_PVR
+	rlwinm	r4, r3, 16, 0xffff
+	lis	r5, 0
+	ori	r5, r5, PVR_E6500@l
+	cmpw	r4, r5
+	beq	2f
 	mflr	r10
 	bl	flush_dcache_L1	/* Flush L1 d-cache */
 	mtlr	r10
 
-	msync
+2:	msync
 	mfspr	r4, SPRN_L1CSR0	/* Invalidate and disable d-cache */
 	li	r5, 2
 	rlwimi	r4, r5, 0, 3
-- 
1.7.3


