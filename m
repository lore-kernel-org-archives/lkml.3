Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbaLPPDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 10:03:45 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:47075 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbaLPPDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 10:03:41 -0500
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: [PATCH 06/11] powerpc/8xx: Remove duplicated code in set_context()
Message-Id: <20141216150339.097E61A5E05@localhost.localdomain>
Date: Tue, 16 Dec 2014 16:03:39 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 arch/powerpc/kernel/head_8xx.S | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index aa45225..b227902e 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -848,23 +848,21 @@ _GLOBAL(set_context)
 
 	li	r5, (swapper_pg_dir-PAGE_OFFSET)@l
 	sub	r4, r4, r5
+	tophys	(r4, r4)
 #ifdef CONFIG_8xx_CPU6
 	lis	r6, cpu6_errata_word@h
 	ori	r6, r6, cpu6_errata_word@l
-	tophys	(r4, r4)
 	li	r7, 0x3f80
 	stw	r7, 12(r6)
 	lwz	r7, 12(r6)
+#endif
         mtspr   SPRN_M_TW, r4               /* Update MMU base address */
+#ifdef CONFIG_8xx_CPU6
 	li	r7, 0x3380
 	stw	r7, 12(r6)
 	lwz	r7, 12(r6)
-        mtspr   SPRN_M_CASID, r3             /* Update context */
-#else
-        mtspr   SPRN_M_CASID,r3		/* Update context */
-	tophys	(r4, r4)
-	mtspr	SPRN_M_TW, r4		/* and pgd */
 #endif
+        mtspr   SPRN_M_CASID, r3             /* Update context */
 	SYNC
 	blr
 
-- 
2.1.0

