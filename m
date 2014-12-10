Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760AbaLJSCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 13:02:09 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:18038 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932501AbaLJSBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 13:01:15 -0500
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 4/4] powerpc32/8xx: invert _PAGE_RW bit in PTE accessors
Message-Id: <20141210180046.9A8FA1A5D62@localhost.localdomain>
Date: Wed, 10 Dec 2014 19:00:46 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 8xx inverts _PAGE_RW. Lets to it in PTE accessors.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 arch/powerpc/include/asm/pte-8xx.h | 1 +
 arch/powerpc/kernel/head_8xx.S     | 3 ---
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/pte-8xx.h b/arch/powerpc/include/asm/pte-8xx.h
index daa4616..57bad0a 100644
--- a/arch/powerpc/include/asm/pte-8xx.h
+++ b/arch/powerpc/include/asm/pte-8xx.h
@@ -57,6 +57,7 @@
 #define _PMD_PAGE_8M	0x000c
 
 #define _PTE_NONE_MASK _PAGE_KNLRO
+#define _PTE_HW_INVERTED	_PAGE_RW
 
 /* Until my rework is finished, 8xx still needs atomic PTE updates */
 #define PTE_ATOMIC_UPDATES	1
diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index 3d4b8ee..807b0db 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -441,9 +441,6 @@ DataStoreTLBMiss:
 	and	r11, r11, r10
 	rlwimi	r10, r11, 0, _PAGE_PRESENT
 #endif
-	/* invert RW */
-	xori	r10, r10, _PAGE_RW
-
 	/* The Linux PTE won't go exactly into the MMU TLB.
 	 * Software indicator bits 22 and 28 must be clear.
 	 * Software indicator bits 24, 25, 26, and 27 must be
-- 
2.1.0

