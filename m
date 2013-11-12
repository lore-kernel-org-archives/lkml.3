Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3KLNX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 08:23:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724Ab3KLNXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 08:23:55 -0500
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Salter <msalter@redhat.com>, Richard Kuo <rkuo@codeaurora.org>,
        linux-hexagon@vger.kernel.org
Subject: [PATCH 04/11] hexagon: use generic fixmap.h
Date: Tue, 12 Nov 2013 08:22:18 -0500
Message-Id: <1384262545-20875-5-git-send-email-msalter@redhat.com>
In-Reply-To: <1384262545-20875-1-git-send-email-msalter@redhat.com>
References: <1384262545-20875-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Salter <msalter@redhat.com>
CC: Richard Kuo <rkuo@codeaurora.org>
CC: linux-hexagon@vger.kernel.org
---
 arch/hexagon/include/asm/fixmap.h | 40 +--------------------------------------
 1 file changed, 1 insertion(+), 39 deletions(-)

diff --git a/arch/hexagon/include/asm/fixmap.h b/arch/hexagon/include/asm/fixmap.h
index b75b6bf..1387f84 100644
--- a/arch/hexagon/include/asm/fixmap.h
+++ b/arch/hexagon/include/asm/fixmap.h
@@ -26,45 +26,7 @@
  */
 #include <asm/mem-layout.h>
 
-/*
- * Full fixmap support involves set_fixmap() functions, but
- * these may not be needed if all we're after is an area for
- * highmem kernel mappings.
- */
-#define	__fix_to_virt(x)	(FIXADDR_TOP - ((x) << PAGE_SHIFT))
-#define	__virt_to_fix(x)	((FIXADDR_TOP - ((x)&PAGE_MASK)) >> PAGE_SHIFT)
-
-extern void __this_fixmap_does_not_exist(void);
-
-/**
- * fix_to_virt -- "index to address" translation.
- *
- * If anyone tries to use the idx directly without translation,
- * we catch the bug with a NULL-deference kernel oops. Illegal
- * ranges of incoming indices are caught too.
- */
-static inline unsigned long fix_to_virt(const unsigned int idx)
-{
-	/*
-	 * This branch gets completely eliminated after inlining,
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
 
 #define kmap_get_fixmap_pte(vaddr) \
 	pte_offset_kernel(pmd_offset(pud_offset(pgd_offset_k(vaddr), \
-- 
1.8.3.1

