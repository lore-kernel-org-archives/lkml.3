Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbaISIhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 04:37:05 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:54500 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336AbaISIgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 04:36:19 -0400
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        scottwood@freescale.com
Subject: [PATCH v4 19/21] powerpc/8xx: Don't restore regs to save them again.
Message-Id: <20140919083610.7D8E01AB03E@localhost.localdomain>
Date: Fri, 19 Sep 2014 10:36:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is not need to restore r10, r11 and cr registers at this end of ITLBmiss
handler as they are saved again to the same place in ITLBError handler we are
jumping to.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
Changes in v2:
- None

Changes in v3:
- None

Changes in v4:
- None

 arch/powerpc/kernel/head_8xx.S | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index f372984..bcf0a43 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -383,8 +383,7 @@ InstructionTLBMiss:
 	lwz	r3, 8(r0)
 #endif
 	mfspr	r10, SPRN_SPRG_SCRATCH2
-	EXCEPTION_EPILOG_0
-	b	InstructionTLBError
+	b	InstructionTLBError1
 
 	. = 0x1200
 DataStoreTLBMiss:
@@ -473,7 +472,10 @@ DataStoreTLBMiss:
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
 	/* 0x400 is InstructionAccess exception, needed by bad_page_fault() */
-- 
2.1.0

