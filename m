Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab3EZXrm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 19:47:42 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:38580 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab3EZXr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 19:47:28 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v4 3/3] mm/hugetlb: remove hugetlb_prefault 
Date: Mon, 27 May 2013 07:47:15 +0800
Message-Id: <1369612035-3430-3-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1369612035-3430-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1369612035-3430-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052623-0260-0000-0000-0000030E8671
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
 v1 -> v2: 
	* add Michal reviewed-by 

hugetlb_prefault are not used any more, this patch remove it.

Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 include/linux/hugetlb.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 6b4890f..a811149 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -55,7 +55,6 @@ void __unmap_hugepage_range_final(struct mmu_gather *tlb,
 void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 				unsigned long start, unsigned long end,
 				struct page *ref_page);
-int hugetlb_prefault(struct address_space *, struct vm_area_struct *);
 void hugetlb_report_meminfo(struct seq_file *);
 int hugetlb_report_node_meminfo(int, char *);
 void hugetlb_show_meminfo(void);
@@ -110,7 +109,6 @@ static inline unsigned long hugetlb_total_pages(void)
 #define follow_hugetlb_page(m,v,p,vs,a,b,i,w)	({ BUG(); 0; })
 #define follow_huge_addr(mm, addr, write)	ERR_PTR(-EINVAL)
 #define copy_hugetlb_page_range(src, dst, vma)	({ BUG(); 0; })
-#define hugetlb_prefault(mapping, vma)		({ BUG(); 0; })
 static inline void hugetlb_report_meminfo(struct seq_file *m)
 {
 }
-- 
1.8.1.2

