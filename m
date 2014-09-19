Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbaISJCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 05:02:10 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:54844 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755980AbaISJCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 05:02:06 -0400
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        scottwood@freescale.com
Subject: [PATCH v4 10/21] powerpc/8xx: Duplicate two insns instead of branching
Message-Id: <20140919083608.6C7BA1AB03B@localhost.localdomain>
Date: Fri, 19 Sep 2014 10:36:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Branching takes two cycles on MPC8xx. Lets duplicate the two instructions
and avoid the branching.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
Changes in v2:
- None

Changes in v3:
- None

Changes in v4:
- None

 arch/powerpc/kernel/head_8xx.S |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index 5037420..4a49ff3 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -638,9 +638,11 @@ modified_instr:
 
 	/* special handling for r10,r11 since these are modified already */
 153:	mfspr	r11, SPRN_SPRG_SCRATCH1	/* load r11 from SPRN_SPRG_SCRATCH1 */
-	b	155f
+	add	r10, r10, r11	/* add it */
+	mfctr	r11		/* restore r11 */
+	b	151b
 154:	mfspr	r11, SPRN_SPRG_SCRATCH0	/* load r10 from SPRN_SPRG_SCRATCH0 */
-155:	add	r10, r10, r11	/* add it */
+	add	r10, r10, r11	/* add it */
 	mfctr	r11		/* restore r11 */
 	b	151b
 #endif
-- 
1.7.1

