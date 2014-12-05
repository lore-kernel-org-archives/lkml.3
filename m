Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbaLELU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 06:20:29 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:42975 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbaLELUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 06:20:25 -0500
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] powerpc32: fix warning from include/linux/mm.h
Message-Id: <20141205112020.640FA1A5D4F@localhost.localdomain>
Date: Fri,  5 Dec 2014 12:20:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/mm.h: In function 'is_vmalloc_addr':
include/linux/mm.h:367:14: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
  return addr >= VMALLOC_START && addr < VMALLOC_END;
              ^

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 arch/powerpc/include/asm/pgtable-ppc32.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/pgtable-ppc32.h b/arch/powerpc/include/asm/pgtable-ppc32.h
index 234e07c..543bb8e 100644
--- a/arch/powerpc/include/asm/pgtable-ppc32.h
+++ b/arch/powerpc/include/asm/pgtable-ppc32.h
@@ -92,7 +92,7 @@ extern int icache_44x_need_flush;
  * system.  This really does become a problem for machines with good amounts
  * of RAM.  -- Cort
  */
-#define VMALLOC_OFFSET (0x1000000) /* 16M */
+#define VMALLOC_OFFSET (0x1000000U) /* 16M */
 #ifdef PPC_PIN_SIZE
 #define VMALLOC_START (((_ALIGN((long)high_memory, PPC_PIN_SIZE) + VMALLOC_OFFSET) & ~(VMALLOC_OFFSET-1)))
 #else
-- 
2.1.0

