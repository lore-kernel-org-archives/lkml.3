Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab3CJINo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 04:13:44 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:60272 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab3CJIJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 04:09:06 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2, part2 04/10] mm/metag: use free_highmem_page() to free highmem pages into buddy system
Date: Sun, 10 Mar 2013 16:01:04 +0800
Message-Id: <1362902470-25787-5-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362902470-25787-1-git-send-email-jiang.liu@huawei.com>
References: <1362902470-25787-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use helper function free_highmem_page() to free highmem pages into
the buddy system.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: linux-kernel@vger.kernel.org
---
 arch/metag/mm/init.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/metag/mm/init.c b/arch/metag/mm/init.c
index c6784fb..d05b845 100644
--- a/arch/metag/mm/init.c
+++ b/arch/metag/mm/init.c
@@ -380,14 +380,8 @@ void __init mem_init(void)
 
 #ifdef CONFIG_HIGHMEM
 	unsigned long tmp;
-	for (tmp = highstart_pfn; tmp < highend_pfn; tmp++) {
-		struct page *page = pfn_to_page(tmp);
-		ClearPageReserved(page);
-		init_page_count(page);
-		__free_page(page);
-		totalhigh_pages++;
-	}
-	totalram_pages += totalhigh_pages;
+	for (tmp = highstart_pfn; tmp < highend_pfn; tmp++)
+		free_highmem_page(pfn_to_page(tmp));
 	num_physpages += totalhigh_pages;
 #endif /* CONFIG_HIGHMEM */
 
-- 
1.7.9.5

