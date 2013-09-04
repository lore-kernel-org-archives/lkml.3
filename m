Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965142Ab3IDQu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 12:50:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756540Ab3IDQu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 12:50:28 -0400
Date: Wed, 04 Sep 2013 12:50:23 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Message-ID: <1378313423-9sbygyow-mutt-n-horiguchi@ah.jp.nec.com>
Subject: [PATCH] mm: remove obsolete comments about page table lock
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <1378312330-afoa3r2y-mutt-n-horiguchi@ah.jp.nec.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The callers of free_pgd_range() and hugetlb_free_pgd_range() don't hold
page table locks. The comments seems to be obsolete, so let's remove them.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 arch/powerpc/mm/hugetlbpage.c | 2 --
 mm/memory.c                   | 2 --
 2 files changed, 4 deletions(-)

diff --git a/arch/powerpc/mm/hugetlbpage.c b/arch/powerpc/mm/hugetlbpage.c
index 7e56cb7..31c20e2 100644
--- a/arch/powerpc/mm/hugetlbpage.c
+++ b/arch/powerpc/mm/hugetlbpage.c
@@ -635,8 +635,6 @@ static void hugetlb_free_pud_range(struct mmu_gather *tlb, pgd_t *pgd,
 
 /*
  * This function frees user-level page tables of a process.
- *
- * Must be called with pagetable lock held.
  */
 void hugetlb_free_pgd_range(struct mmu_gather *tlb,
 			    unsigned long addr, unsigned long end,
diff --git a/mm/memory.c b/mm/memory.c
index 6827a35..8c97ef0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -478,8 +478,6 @@ static inline void free_pud_range(struct mmu_gather *tlb, pgd_t *pgd,
 
 /*
  * This function frees user-level page tables of a process.
- *
- * Must be called with pagetable lock held.
  */
 void free_pgd_range(struct mmu_gather *tlb,
 			unsigned long addr, unsigned long end,
-- 
1.8.3.1
