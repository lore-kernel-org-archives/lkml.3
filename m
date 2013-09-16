Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab3IPMmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 08:42:10 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:10962 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab3IPMmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 08:42:07 -0400
Message-ID: <5236FC88.6050409@huawei.com>
Date: Mon, 16 Sep 2013 20:41:44 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm/ksm: return NULL when doesn't get mergeable page
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In get_mergeable_page() local variable page is not initialized,
it may hold a garbage value, when find_mergeable_vma() return NULL,
get_mergeable_page() may return a garbage value to the caller.

So initialize page as NULL.

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
---
 mm/ksm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index b6afe0c..87efbae 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -460,7 +460,7 @@ static struct page *get_mergeable_page(struct rmap_item *rmap_item)
 	struct mm_struct *mm = rmap_item->mm;
 	unsigned long addr = rmap_item->address;
 	struct vm_area_struct *vma;
-	struct page *page;
+	struct page *page = NULL;
 
 	down_read(&mm->mmap_sem);
 	vma = find_mergeable_vma(mm, addr);
-- 
1.7.1


