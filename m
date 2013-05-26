Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab3EZF7a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 01:59:30 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:59862 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab3EZF7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 01:59:00 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v3 4/6] mm/hugetlb: use already exist interface huge_page_shift
Date: Sun, 26 May 2013 13:58:39 +0800
Message-Id: <1369547921-24264-4-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1369547921-24264-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1369547921-24264-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052605-2674-0000-0000-0000091CF83A
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

