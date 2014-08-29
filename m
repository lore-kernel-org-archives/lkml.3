Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbaH2JOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 05:14:47 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:36076 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975AbaH2JOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 05:14:43 -0400
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        scottwood@freescale.com
Subject: [PATCH v2 18/19] powerpc/8xx: _PMD_PRESENT already set in level 1 entries
Message-Id: <20140829091440.A2DD91ABD63@localhost.localdomain>
Date: Fri, 29 Aug 2014 11:14:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a PMD entry is valid, _PMD_PRESENT is set. Therefore, forcing that bit
during TLB loading is useless.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 arch/powerpc/kernel/head_8xx.S |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index 48d3de8..bb7c816 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -340,7 +340,6 @@ InstructionTLBMiss:
 	/* We have a pte table, so load the MI_TWC with the attributes
 	 * for this "segment."
 	 */
-	ori	r11,r11,1		/* Set valid bit */
 	MTSPR_CPU6(SPRN_MI_TWC, r11, r3)	/* Set segment attributes */
 	mfspr	r11, SPRN_SRR0	/* Get effective address of fault */
 	/* Extract level 2 index */
@@ -417,7 +416,6 @@ DataStoreTLBMiss:
 	rlwimi	r10, r11, 0, 0, 32 - PAGE_SHIFT - 1	/* Add level 2 base */
 	lwz	r10, 0(r10)	/* Get the pte */
 
-	ori	r11, r11, 1	/* Set valid bit in physical L2 page */
 	/* Insert the Guarded flag into the TWC from the Linux PTE.
 	 * It is bit 27 of both the Linux PTE and the TWC (at least
 	 * I got that right :-).  It will be better when we can put
-- 
1.7.1

