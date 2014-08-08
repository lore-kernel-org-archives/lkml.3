Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbaHHHE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 03:04:58 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:45336 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756437AbaHHHEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 03:04:55 -0400
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        scottwood@freescale.com
Subject: [PATCH 20/20] powerpc/8xx: Don't restore regs to save them again.
Message-Id: <20140808070346.75C8D1ABD50@localhost.localdomain>
Date: Fri,  8 Aug 2014 09:03:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is not need to restore r10, r11 and cr registers at this end of ITLBmiss
handler as they are saved again to the same place in ITLBError handler we are
jumping to.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 arch/powerpc/kernel/head_8xx.S |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index 99438d8..102fe9f 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -380,8 +380,7 @@ InstructionTLBMiss:
 	lwz	r3, 8(r0)
 #endif
 	mfspr	r10, SPRN_SPRG_SCRATCH2
-	EXCEPTION_EPILOG_0
-	b	InstructionTLBError
+	b	InstructionTLBError1
 
 	. = 0x1200
 DataStoreTLBMiss:
@@ -470,7 +469,10 @@ DataStoreTLBMiss:
  */
 	. = 0x1300
 InstructionTLBError:
-	EXCEPTION_PROLOG
+	EXCEPTION_PROLOG_0
+InstructionTLBError1:
+	EXCEPTION_PROLOG_1
+	EXCEPTION_PROLOG_2
 	mr	r4,r12
 	mr	r5,r9
 	EXC_XFER_LITE(0x1300, handle_page_fault)
-- 
1.7.1

