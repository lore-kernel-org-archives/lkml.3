Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab3EVJ3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:29:54 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:59470 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766Ab3EVJ3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:29:48 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 3/4] mm/hugetlb: remove hugetlb_prefault 
Date: Wed, 22 May 2013 17:29:29 +0800
Message-Id: <1369214970-1526-3-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1369214970-1526-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1369214970-1526-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052209-5140-0000-0000-0000033FA7F5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hugetlb_prefault are not used any more, this patch remove it.

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

