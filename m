Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab3EZXrY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 19:47:24 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:39381 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab3EZXrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 19:47:23 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v4 1/3] mm/hugetlb: use already exist interface huge_page_shift
Date: Mon, 27 May 2013 07:47:13 +0800
Message-Id: <1369612035-3430-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052623-1618-0000-0000-000003F5A159
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
 v1 -> v2:
	* update alloc_bootmem_huge_page in powerpc 
	* add Michal reviewed-by 

Use already exist interface huge_page_shift instead of h->order + PAGE_SHIFT.

Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 arch/powerpc/mm/hugetlbpage.c | 2 +-
 mm/hugetlb.c                  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/mm/hugetlbpage.c b/arch/powerpc/mm/hugetlbpage.c
index 237c8e5..cafec93 100644
--- a/arch/powerpc/mm/hugetlbpage.c
+++ b/arch/powerpc/mm/hugetlbpage.c
@@ -357,7 +357,7 @@ void add_gpage(u64 addr, u64 page_size, unsigned long number_of_pages)
 int alloc_bootmem_huge_page(struct hstate *hstate)
 {
 	struct huge_bootmem_page *m;
-	int idx = shift_to_mmu_psize(hstate->order + PAGE_SHIFT);
+	int idx = shift_to_mmu_psize(huge_page_shift(hstate));
 	int nr_gpages = gpage_freearray[idx].nr_gpages;
 
 	if (nr_gpages == 0)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f8feeec..b6ff0ee 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -319,7 +319,7 @@ unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
 
 	hstate = hstate_vma(vma);
 
-	return 1UL << (hstate->order + PAGE_SHIFT);
+	return 1UL << huge_page_shift(hstate);
 }
 EXPORT_SYMBOL_GPL(vma_kernel_pagesize);
 
-- 
1.8.1.2

