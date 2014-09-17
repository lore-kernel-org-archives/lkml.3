Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbaIQQkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:40:17 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:44152 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756186AbaIQQhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:37:21 -0400
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        scottwood@freescale.com
Subject: [PATCH v3 08/21] powerpc/8xx: No need to restore registers and save them again.
Message-Id: <20140917163658.515B61AB037@localhost.localdomain>
Date: Wed, 17 Sep 2014 18:36:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In DTLBError handler there is not need to restore r10, r11 and cr registers
after fixing DAR as they are saved again to the same place just after.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
Changes in v2:
- None

Changes in v3:
- None

 arch/powerpc/kernel/head_8xx.S |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index 5f04d5f..e5a250c 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -478,8 +478,8 @@ DataTLBError:
 	cmpwi	cr0, r11, 0x00f0
 	beq-	FixupDAR	/* must be a buggy dcbX, icbi insn. */
 DARFixed:/* Return from dcbx instruction bug workaround */
-	EXCEPTION_EPILOG_0
-	EXCEPTION_PROLOG
+	EXCEPTION_PROLOG_1
+	EXCEPTION_PROLOG_2
 	mfspr	r10,SPRN_DSISR
 	stw	r10,_DSISR(r11)
 	mr	r5,r10
-- 
1.7.1

