Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab3KYQQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 11:16:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756724Ab3KYQO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 11:14:27 -0500
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Salter <msalter@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: [PATCH v2 02/11] x86: use generic fixmap.h
Date: Mon, 25 Nov 2013 11:13:56 -0500
Message-Id: <1385396045-15852-3-git-send-email-msalter@redhat.com>
In-Reply-To: <1385396045-15852-1-git-send-email-msalter@redhat.com>
References: <1385396045-15852-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Salter <msalter@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org
---
 arch/x86/include/asm/fixmap.h | 59 +------------------------------------------
 1 file changed, 1 insertion(+), 58 deletions(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index e846225..7252cd3 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -175,64 +175,7 @@ static inline void __set_fixmap(enum fixed_addresses idx,
 }
 #endif
 
-#define set_fixmap(idx, phys)				\
-	__set_fixmap(idx, phys, PAGE_KERNEL)
-
-/*
- * Some hardware wants to get fixmapped without caching.
- */
-#define set_fixmap_nocache(idx, phys)			\
-	__set_fixmap(idx, phys, PAGE_KERNEL_NOCACHE)
-
-#define clear_fixmap(idx)			\
-	__set_fixmap(idx, 0, __pgprot(0))
-
-#define __fix_to_virt(x)	(FIXADDR_TOP - ((x) << PAGE_SHIFT))
-#define __virt_to_fix(x)	((FIXADDR_TOP - ((x)&PAGE_MASK)) >> PAGE_SHIFT)
-
-extern void __this_fixmap_does_not_exist(void);
-
-/*
- * 'index to address' translation. If anyone tries to use the idx
- * directly without translation, we catch the bug with a NULL-deference
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
-
-static inline unsigned long virt_to_fix(const unsigned long vaddr)
-{
-	BUG_ON(vaddr >= FIXADDR_TOP || vaddr < FIXADDR_START);
-	return __virt_to_fix(vaddr);
-}
-
-/* Return an pointer with offset calculated */
-static __always_inline unsigned long
-__set_fixmap_offset(enum fixed_addresses idx, phys_addr_t phys, pgprot_t flags)
-{
-	__set_fixmap(idx, phys, flags);
-	return fix_to_virt(idx) + (phys & (PAGE_SIZE - 1));
-}
-
-#define set_fixmap_offset(idx, phys)			\
-	__set_fixmap_offset(idx, phys, PAGE_KERNEL)
-
-#define set_fixmap_offset_nocache(idx, phys)			\
-	__set_fixmap_offset(idx, phys, PAGE_KERNEL_NOCACHE)
+#include <asm-generic/fixmap.h>
 
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASM_X86_FIXMAP_H */
-- 
1.8.3.1

