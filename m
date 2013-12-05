Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab3LEIyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 03:54:09 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:43066 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3LEIyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 03:54:06 -0500
Message-ID: <52A03EE4.6030609@huawei.com>
Date: Thu, 5 Dec 2013 16:52:52 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan.kim@gmail.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        qiuxishi <qiuxishi@huawei.com>
Subject: [PATCH] mm: do_mincore() cleanup
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two cleanups:
1. remove redundant codes for hugetlb pages.
2. end = pmd_addr_end(addr, end) restricts [addr, end) within PMD_SIZE,
   this may increase do_mincore() calls, remove it.

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
---
 mm/mincore.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index da2be56..1016233 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -225,13 +225,6 @@ static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *v
 
 	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
 
-	if (is_vm_hugetlb_page(vma)) {
-		mincore_hugetlb_page_range(vma, addr, end, vec);
-		return (end - addr) >> PAGE_SHIFT;
-	}
-
-	end = pmd_addr_end(addr, end);
-
 	if (is_vm_hugetlb_page(vma))
 		mincore_hugetlb_page_range(vma, addr, end, vec);
 	else
-- 
1.7.1


