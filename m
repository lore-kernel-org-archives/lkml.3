Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbbATKlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:41:11 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:41117 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbbATKlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:41:08 -0500
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: [PATCH v2 10/11] powerpc/8xx: Use SPRG2 instead of DAR for saving r3
Message-Id: <20150120095736.2B0C11A5E85@localhost.localdomain>
Date: Tue, 20 Jan 2015 10:57:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now have SPRG2 available as in it not used anymore for saving CR, so we don't
need to crash DAR anymore for saving r3 for CPU6 ERRATA handling.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
v2: no change

 arch/powerpc/kernel/head_8xx.S | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index e803ad0..ead6448 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -309,7 +309,7 @@ SystemCall:
 
 InstructionTLBMiss:
 #ifdef CONFIG_8xx_CPU6
-	mtspr	SPRN_DAR, r3
+	mtspr	SPRN_SPRG_SCRATCH2, r3
 #endif
 	EXCEPTION_PROLOG_0
 
@@ -362,8 +362,7 @@ InstructionTLBMiss:
 
 	/* Restore registers */
 #ifdef CONFIG_8xx_CPU6
-	mfspr	r3, SPRN_DAR
-	mtspr	SPRN_DAR, r11	/* Tag DAR */
+	mfspr	r3, SPRN_SPRG_SCRATCH2
 #endif
 	EXCEPTION_EPILOG_0
 	rfi
@@ -371,7 +370,7 @@ InstructionTLBMiss:
 	. = 0x1200
 DataStoreTLBMiss:
 #ifdef CONFIG_8xx_CPU6
-	mtspr	SPRN_DAR, r3
+	mtspr	SPRN_SPRG_SCRATCH2, r3
 #endif
 	EXCEPTION_PROLOG_0
 	mfcr	r10
@@ -441,7 +440,7 @@ DataStoreTLBMiss:
 
 	/* Restore registers */
 #ifdef CONFIG_8xx_CPU6
-	mfspr	r3, SPRN_DAR
+	mfspr	r3, SPRN_SPRG_SCRATCH2
 #endif
 	mtspr	SPRN_DAR, r11	/* Tag DAR */
 	EXCEPTION_EPILOG_0
-- 
2.1.0

