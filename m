Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab3KYQOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 11:14:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182Ab3KYQOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 11:14:17 -0500
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Salter <msalter@redhat.com>, linux-metag@vger.kernel.org
Subject: [PATCH v2 05/11] metag: use generic fixmap.h
Date: Mon, 25 Nov 2013 11:13:59 -0500
Message-Id: <1385396045-15852-6-git-send-email-msalter@redhat.com>
In-Reply-To: <1385396045-15852-1-git-send-email-msalter@redhat.com>
References: <1385396045-15852-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Salter <msalter@redhat.com>
Acked-by: James Hogan <james.hogan@imgtec.com>
CC: linux-metag@vger.kernel.org
---
 arch/metag/include/asm/fixmap.h | 32 +-------------------------------
 1 file changed, 1 insertion(+), 31 deletions(-)

diff --git a/arch/metag/include/asm/fixmap.h b/arch/metag/include/asm/fixmap.h
index 3331275..af621b0 100644
--- a/arch/metag/include/asm/fixmap.h
+++ b/arch/metag/include/asm/fixmap.h
@@ -51,37 +51,7 @@ enum fixed_addresses {
 #define FIXADDR_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
 #define FIXADDR_START	((FIXADDR_TOP - FIXADDR_SIZE) & PMD_MASK)
 
-#define __fix_to_virt(x)	(FIXADDR_TOP - ((x) << PAGE_SHIFT))
-#define __virt_to_fix(x)	((FIXADDR_TOP - ((x)&PAGE_MASK)) >> PAGE_SHIFT)
-
-extern void __this_fixmap_does_not_exist(void);
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
 
 #define kmap_get_fixmap_pte(vaddr) \
 	pte_offset_kernel( \
-- 
1.8.3.1

