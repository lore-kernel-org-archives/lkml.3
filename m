Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbaGAISA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 04:18:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbaGAIR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 04:17:58 -0400
From: "Jerome Marchand" <jmarchan@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH] mm: make copy_pte_range static again
Date: Tue,  1 Jul 2014 10:17:54 +0200
Message-Id: <1404202674-11648-1-git-send-email-jmarchan@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 71e3aac (thp: transparent hugepage core) adds copy_pte_range
prototype to huge_mm.h. I'm not sure why (or if) this function have
been used outside of memory.c, but it currently isn't.
This patch makes copy_pte_range() static again.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 include/linux/huge_mm.h | 4 ----
 mm/memory.c             | 2 +-
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index b826239..63579cb 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -93,10 +93,6 @@ extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
 #endif /* CONFIG_DEBUG_VM */
 
 extern unsigned long transparent_hugepage_flags;
-extern int copy_pte_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-			  pmd_t *dst_pmd, pmd_t *src_pmd,
-			  struct vm_area_struct *vma,
-			  unsigned long addr, unsigned long end);
 extern int split_huge_page_to_list(struct page *page, struct list_head *list);
 static inline int split_huge_page(struct page *page)
 {
diff --git a/mm/memory.c b/mm/memory.c
index 09e2cd0..13141ae 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -884,7 +884,7 @@ out_set_pte:
 	return 0;
 }
 
-int copy_pte_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
+static int copy_pte_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		   pmd_t *dst_pmd, pmd_t *src_pmd, struct vm_area_struct *vma,
 		   unsigned long addr, unsigned long end)
 {
-- 
1.9.3

