Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbbATKDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:03:40 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:40486 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308AbbATJ5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:57:38 -0500
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: [PATCH v2 06/11] powerpc/8xx: Remove duplicated code in set_context()
Message-Id: <20150120095734.E85D81A5E85@localhost.localdomain>
Date: Tue, 20 Jan 2015 10:57:34 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
v2: no change

 arch/powerpc/kernel/head_8xx.S | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index a485ad7..a1571b3 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -853,23 +853,21 @@ _GLOBAL(set_context)
 	 */
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
 	mtspr	SPRN_M_TW, r4		/* Update pointeur to level 1 table */
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
+	mtspr	SPRN_M_CASID, r3	/* Update context */
 	SYNC
 	blr
 
-- 
2.1.0

