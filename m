Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaH2JOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 05:14:40 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:36033 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbaH2JOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 05:14:39 -0400
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        scottwood@freescale.com
Subject: [PATCH v2 01/19] powerpc/8xx: Declare SPRG2 as a SCRATCH register
Message-Id: <20140829091437.44DE71ABD63@localhost.localdomain>
Date: Fri, 29 Aug 2014 11:14:37 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since coming 469d62be9263b92f2c3329540cbb1c076111f4f3, SPRG2 is used as a
scratch register just like SPRG0 and SPRG1. So Declare it as such and fix
the comment which is not valid anymore since that commit.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 arch/powerpc/include/asm/reg.h |    3 ++-
 arch/powerpc/kernel/head_8xx.S |   10 +++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index cb9c174..b6a7d62 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -888,7 +888,7 @@
  * 32-bit 8xx:
  *	- SPRG0 scratch for exception vectors
  *	- SPRG1 scratch for exception vectors
- *	- SPRG2 apparently unused but initialized
+ *	- SPRG2 scratch for exception vectors
  *
  */
 #ifdef CONFIG_PPC64
@@ -994,6 +994,7 @@
 #ifdef CONFIG_8xx
 #define SPRN_SPRG_SCRATCH0	SPRN_SPRG0
 #define SPRN_SPRG_SCRATCH1	SPRN_SPRG1
+#define SPRN_SPRG_SCRATCH2	SPRN_SPRG2
 #endif
 
 
diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index 55d12fb..1329c5a 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -301,7 +301,7 @@ InstructionTLBMiss:
 	stw	r11, 4(r0)
 #else
 	mtspr	SPRN_DAR, r10
-	mtspr	SPRN_SPRG2, r11
+	mtspr	SPRN_SPRG_SCRATCH2, r11
 #endif
 	mfspr	r10, SPRN_SRR0	/* Get effective address of fault */
 #ifdef CONFIG_8xx_CPU15
@@ -363,7 +363,7 @@ InstructionTLBMiss:
 	mfspr	r10, SPRN_DAR
 	mtcr	r10
 	mtspr	SPRN_DAR, r11	/* Tag DAR */
-	mfspr	r11, SPRN_SPRG2
+	mfspr	r11, SPRN_SPRG_SCRATCH2
 #else
 	lwz	r11, 0(r0)
 	mtcr	r11
@@ -386,7 +386,7 @@ InstructionTLBMiss:
 	mtcr	r10
 	li	r11, 0x00f0
 	mtspr	SPRN_DAR, r11	/* Tag DAR */
-	mfspr	r11, SPRN_SPRG2
+	mfspr	r11, SPRN_SPRG_SCRATCH2
 #else
 	lwz	r11, 0(r0)
 	mtcr	r11
@@ -409,7 +409,7 @@ DataStoreTLBMiss:
 	stw	r11, 4(r0)
 #else
 	mtspr	SPRN_DAR, r10
-	mtspr	SPRN_SPRG2, r11
+	mtspr	SPRN_SPRG_SCRATCH2, r11
 #endif
 	mfspr	r10, SPRN_M_TWB	/* Get level 1 table entry address */
 
@@ -487,7 +487,7 @@ DataStoreTLBMiss:
 	mfspr	r10, SPRN_DAR
 	mtcr	r10
 	mtspr	SPRN_DAR, r11	/* Tag DAR */
-	mfspr	r11, SPRN_SPRG2
+	mfspr	r11, SPRN_SPRG_SCRATCH2
 #else
 	mtspr	SPRN_DAR, r11	/* Tag DAR */
 	lwz	r11, 0(r0)
-- 
1.7.1

