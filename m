Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaH1SgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:36:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32830 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbaH1Sft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:35:49 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 01/97] mm: thp: cleanup: mv alloc_hugepage to better place
Date: Thu, 28 Aug 2014 19:34:09 +0100
Message-Id: <1409250945-30874-2-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Liu <lliubbo@gmail.com>

commit 10dc4155c7714f508fe2e4667164925ea971fb25 upstream.

Move alloc_hugepage() to a better place, no need for a seperate #ifndef
CONFIG_NUMA

Signed-off-by: Bob Liu <bob.liu@oracle.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Davidoff <davidoff@qedmf.net>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/huge_memory.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 389973f..738a57e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -758,14 +758,6 @@ static inline struct page *alloc_hugepage_vma(int defrag,
 			       HPAGE_PMD_ORDER, vma, haddr, nd);
 }
 
-#ifndef CONFIG_NUMA
-static inline struct page *alloc_hugepage(int defrag)
-{
-	return alloc_pages(alloc_hugepage_gfpmask(defrag, 0),
-			   HPAGE_PMD_ORDER);
-}
-#endif
-
 static bool set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long haddr, pmd_t *pmd,
 		struct page *zero_page)
@@ -2249,6 +2241,12 @@ static struct page
 	return *hpage;
 }
 #else
+static inline struct page *alloc_hugepage(int defrag)
+{
+	return alloc_pages(alloc_hugepage_gfpmask(defrag, 0),
+			   HPAGE_PMD_ORDER);
+}
+
 static struct page *khugepaged_alloc_hugepage(bool *wait)
 {
 	struct page *hpage;
-- 
1.8.4.5

