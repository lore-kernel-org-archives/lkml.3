Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbaIXRTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:19:31 -0400
Received: from relay1.sgi.com ([192.48.180.66]:52289 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbaIXRTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:19:30 -0400
From: James Custer <jcuster@sgi.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Cc: James Custer <jcuster@sgi.com>
Subject: [PATCH] x86: Allow 1GB pages to be SPECIAL similar to 2MB
Date: Wed, 24 Sep 2014 12:19:03 -0500
Message-Id: <1411579143-10963-1-git-send-email-jcuster@sgi.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: James Custer <jcuster@sgi.com>
---
 arch/x86/mm/gup.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index dd74e46..12ca9cf 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -121,7 +121,6 @@ static noinline int gup_huge_pmd(pmd_t pmd, unsigned long addr,
 		mask |= _PAGE_RW;
 	if ((pte_flags(pte) & mask) != mask)
 		return 0;
-	/* hugepages are never "special" */
 	VM_BUG_ON(pte_flags(pte) & _PAGE_SPECIAL);
 	VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 
@@ -191,7 +190,6 @@ static noinline int gup_huge_pud(pud_t pud, unsigned long addr,
 		mask |= _PAGE_RW;
 	if ((pte_flags(pte) & mask) != mask)
 		return 0;
-	/* hugepages are never "special" */
 	VM_BUG_ON(pte_flags(pte) & _PAGE_SPECIAL);
 	VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 
@@ -223,7 +221,7 @@ static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
 		pud_t pud = *pudp;
 
 		next = pud_addr_end(addr, end);
-		if (pud_none(pud))
+		if (pud_none(pud) || (pud_val(pud) & _PAGE_SPECIAL))
 			return 0;
 		if (unlikely(pud_large(pud))) {
 			if (!gup_huge_pud(pud, addr, next, write, pages, nr))
-- 
1.8.2.1

