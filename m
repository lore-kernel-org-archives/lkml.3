Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab3KYQO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 11:14:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755773Ab3KYQOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 11:14:20 -0500
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Salter <msalter@redhat.com>, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH v2 06/11] microblaze: use generic fixmap.h
Date: Mon, 25 Nov 2013 11:14:00 -0500
Message-Id: <1385396045-15852-7-git-send-email-msalter@redhat.com>
In-Reply-To: <1385396045-15852-1-git-send-email-msalter@redhat.com>
References: <1385396045-15852-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Salter <msalter@redhat.com>
Tested-by: Michal Simek <monstr@monstr.eu>
CC: microblaze-uclinux@itee.uq.edu.au
---
 arch/microblaze/include/asm/fixmap.h | 44 ++----------------------------------
 1 file changed, 2 insertions(+), 42 deletions(-)

diff --git a/arch/microblaze/include/asm/fixmap.h b/arch/microblaze/include/asm/fixmap.h
index f2b312e..06c0e2b 100644
--- a/arch/microblaze/include/asm/fixmap.h
+++ b/arch/microblaze/include/asm/fixmap.h
@@ -58,52 +58,12 @@ enum fixed_addresses {
 extern void __set_fixmap(enum fixed_addresses idx,
 					phys_addr_t phys, pgprot_t flags);
 
-#define set_fixmap(idx, phys) \
-		__set_fixmap(idx, phys, PAGE_KERNEL)
-/*
- * Some hardware wants to get fixmapped without caching.
- */
-#define set_fixmap_nocache(idx, phys) \
-		__set_fixmap(idx, phys, PAGE_KERNEL_CI)
-
-#define clear_fixmap(idx) \
-		__set_fixmap(idx, 0, __pgprot(0))
-
 #define __FIXADDR_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
 #define FIXADDR_START		(FIXADDR_TOP - __FIXADDR_SIZE)
 
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
-static __always_inline unsigned long fix_to_virt(const unsigned int idx)
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
+#define FIXMAP_PAGE_NOCACHE PAGE_KERNEL_CI
 
-static inline unsigned long virt_to_fix(const unsigned long vaddr)
-{
-	BUG_ON(vaddr >= FIXADDR_TOP || vaddr < FIXADDR_START);
-	return __virt_to_fix(vaddr);
-}
+#include <asm-generic/fixmap.h>
 
 #endif /* !__ASSEMBLY__ */
 #endif
-- 
1.8.3.1

