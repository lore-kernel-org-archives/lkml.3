Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933756AbbA1Bo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:44:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41752 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933366AbbA1Bii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jerome Marchand <jmarchan@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 3.14 67/77] mm: make copy_pte_range static again
Date: Tue, 27 Jan 2015 17:27:45 -0800
Message-Id: <20150128012747.976302843@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/huge_mm.h |    4 ----
 mm/memory.c             |    2 +-
 2 files changed, 1 insertion(+), 5 deletions(-)

--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -93,10 +93,6 @@ extern bool is_vma_temporary_stack(struc
 #endif /* CONFIG_DEBUG_VM */
 
 extern unsigned long transparent_hugepage_flags;
-extern int copy_pte_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-			  pmd_t *dst_pmd, pmd_t *src_pmd,
-			  struct vm_area_struct *vma,
-			  unsigned long addr, unsigned long end);
 extern int split_huge_page_to_list(struct page *page, struct list_head *list);
 static inline int split_huge_page(struct page *page)
 {
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


