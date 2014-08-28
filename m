Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbaH1Sh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:37:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32894 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbaH1ShS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:37:18 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 89/97] mm: make copy_pte_range static again
Date: Thu, 28 Aug 2014 19:35:37 +0100
Message-Id: <1409250945-30874-90-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jerome Marchand <jmarchan@redhat.com>

commit 21bda264f4243f61dfcc485174055f12ad0530b4 upstream.

Commit 71e3aac0724f ("thp: transparent hugepage core") adds
copy_pte_range prototype to huge_mm.h.  I'm not sure why (or if) this
function have been used outside of memory.c, but it currently isn't.
This patch makes copy_pte_range() static again.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/huge_mm.h | 4 ----
 mm/memory.c             | 2 +-
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index a291552..aac671b 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -92,10 +92,6 @@ extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
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
index b870c9c..b590106 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -878,7 +878,7 @@ out_set_pte:
 	return 0;
 }
 
-int copy_pte_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
+static int copy_pte_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		   pmd_t *dst_pmd, pmd_t *src_pmd, struct vm_area_struct *vma,
 		   unsigned long addr, unsigned long end)
 {
-- 
1.8.4.5

