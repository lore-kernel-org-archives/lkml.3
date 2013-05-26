Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab3EZNlq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 09:41:46 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:41455 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab3EZNln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 09:41:43 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH v8, part3 05/14] mm/tile: use common help functions to free reserved pages
Date: Sun, 26 May 2013 21:38:33 +0800
Message-Id: <1369575522-26405-6-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369575522-26405-1-git-send-email-jiang.liu@huawei.com>
References: <1369575522-26405-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
---
 arch/tile/mm/init.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index 2749515..ccfeb3f 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -720,7 +720,7 @@ static void __init init_free_pfn_range(unsigned long start, unsigned long end)
 		}
 		init_page_count(page);
 		__free_pages(page, order);
-		totalram_pages += count;
+		adjust_managed_page_count(page, count);
 
 		page += count;
 		pfn += count;
@@ -1024,16 +1024,13 @@ static void free_init_pages(char *what, unsigned long begin, unsigned long end)
 			pte_clear(&init_mm, addr, ptep);
 			continue;
 		}
-		__ClearPageReserved(page);
-		init_page_count(page);
 		if (pte_huge(*ptep))
 			BUG_ON(!kdata_huge);
 		else
 			set_pte_at(&init_mm, addr, ptep,
 				   pfn_pte(pfn, PAGE_KERNEL));
 		memset((void *)addr, POISON_FREE_INITMEM, PAGE_SIZE);
-		free_page(addr);
-		totalram_pages++;
+		free_reserved_page(page);
 	}
 	pr_info("Freeing %s: %ldk freed\n", what, (end - begin) >> 10);
 }
-- 
1.8.1.2

