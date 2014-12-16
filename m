Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaLPPDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 10:03:46 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:47085 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbaLPPDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 10:03:43 -0500
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: [PATCH 10/11] powerpc/8xx: Use SPRG2 instead of DAR for saving r3
Message-Id: <20141216150340.33BC31A5E04@localhost.localdomain>
Date: Tue, 16 Dec 2014 16:03:40 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now have SPRG2 available as in it not used anymore for saving CR, so we don't
need to crash DAR anymore for saving r3 for CPU6 ERRATA handling.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 arch/powerpc/kernel/head_8xx.S | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index a073918..dbe110e 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -310,7 +310,7 @@ SystemCall:
 InstructionTLBMiss:
 	EXCEPTION_PROLOG_0
 #ifdef CONFIG_8xx_CPU6
-	mtspr	SPRN_DAR, r3
+	mtspr	SPRN_SPRG_SCRATCH2, r3
 #endif
 
 	/* If we are faulting a kernel address, we have to use the
@@ -374,8 +374,7 @@ InstructionTLBMiss:
 
 	/* Restore registers */
 #ifdef CONFIG_8xx_CPU6
-	mfspr	r3, SPRN_DAR
-	mtspr	SPRN_DAR, r11	/* Tag DAR */
+	mfspr	r3, SPRN_SPRG_SCRATCH2
 #endif
 	EXCEPTION_EPILOG_0
 	rfi
@@ -388,7 +387,7 @@ DataStoreTLBMiss:
 	 * kernel page tables.
 	 */
 #ifdef CONFIG_8xx_CPU6
-	mtspr	SPRN_DAR, r3
+	mtspr	SPRN_SPRG_SCRATCH2, r3
 	mfcr	r3
 	mfspr	r10, SPRN_MD_EPN
 	andis.	r11, r10, 0x8000
@@ -461,7 +460,7 @@ DataStoreTLBMiss:
 
 	/* Restore registers */
 #ifdef CONFIG_8xx_CPU6
-	mfspr	r3, SPRN_DAR
+	mfspr	r3, SPRN_SPRG_SCRATCH2
 #endif
 	mtspr	SPRN_DAR, r11	/* Tag DAR */
 	EXCEPTION_EPILOG_0
-- 
2.1.0

