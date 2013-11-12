Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab3KLN0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 08:26:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755250Ab3KLNX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 08:23:57 -0500
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Salter <msalter@redhat.com>, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org
Subject: [PATCH 07/11] mips: use generic fixmap.h
Date: Tue, 12 Nov 2013 08:22:21 -0500
Message-Id: <1384262545-20875-8-git-send-email-msalter@redhat.com>
In-Reply-To: <1384262545-20875-1-git-send-email-msalter@redhat.com>
References: <1384262545-20875-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Salter <msalter@redhat.com>
CC: Ralf Baechle <ralf@linux-mips.org>
CC: linux-mips@linux-mips.org
---
 arch/mips/include/asm/fixmap.h | 33 +--------------------------------
 1 file changed, 1 insertion(+), 32 deletions(-)

diff --git a/arch/mips/include/asm/fixmap.h b/arch/mips/include/asm/fixmap.h
index dfaaf49..8c012af 100644
--- a/arch/mips/include/asm/fixmap.h
+++ b/arch/mips/include/asm/fixmap.h
@@ -71,38 +71,7 @@ enum fixed_addresses {
 #define FIXADDR_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
 #define FIXADDR_START	(FIXADDR_TOP - FIXADDR_SIZE)
 
-#define __fix_to_virt(x)	(FIXADDR_TOP - ((x) << PAGE_SHIFT))
-#define __virt_to_fix(x)	((FIXADDR_TOP - ((x)&PAGE_MASK)) >> PAGE_SHIFT)
-
-extern void __this_fixmap_does_not_exist(void);
-
-/*
- * 'index to address' translation. If anyone tries to use the idx
- * directly without tranlation, we catch the bug with a NULL-deference
- * kernel oops. Illegal ranges of incoming indices are caught too.
- */
-static inline unsigned long fix_to_virt(const unsigned int idx)
-{
-	/*
-	 * this branch gets completely eliminated after inlining,
-	 * except when someone tries to use fixaddr indices in an
-	 * illegal way. (such as mixing up address types or using
-	 * out-of-range indices).
-	 *
-	 * If it doesn't get removed, the linker will complain
-	 * loudly with a reasonably clear error message..
-	 */
-	if (idx >= __end_of_fixed_addresses)
-		__this_fixmap_does_not_exist();
-
-	return __fix_to_virt(idx);
-}
-
-static inline unsigned long virt_to_fix(const unsigned long vaddr)
-{
-	BUG_ON(vaddr >= FIXADDR_TOP || vaddr < FIXADDR_START);
-	return __virt_to_fix(vaddr);
-}
+#include <asm-generic/fixmap.h>
 
 #define kmap_get_fixmap_pte(vaddr)					\
 	pte_offset_kernel(pmd_offset(pud_offset(pgd_offset_k(vaddr), (vaddr)), (vaddr)), (vaddr))
-- 
1.8.3.1

