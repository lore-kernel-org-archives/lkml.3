Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab3CXHaH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 03:30:07 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:45644 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab3CXHaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 03:30:02 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: [RFC PATCH v2, part4 16/39] mm/cris: prepare for removing num_physpages and simplify mem_init()
Date: Sun, 24 Mar 2013 15:24:49 +0800
Message-Id: <1364109934-7851-24-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364109934-7851-1-git-send-email-jiang.liu@huawei.com>
References: <1364109934-7851-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com
Cc: linux-kernel@vger.kernel.org
---
 arch/cris/mm/init.c |   33 ++-------------------------------
 1 file changed, 2 insertions(+), 31 deletions(-)

diff --git a/arch/cris/mm/init.c b/arch/cris/mm/init.c
index 52b8b56..c81af5b 100644
--- a/arch/cris/mm/init.c
+++ b/arch/cris/mm/init.c
@@ -19,9 +19,6 @@ unsigned long empty_zero_page;
 void __init
 mem_init(void)
 {
-	int codesize, reservedpages, datasize, initsize;
-	unsigned long tmp;
-
 	BUG_ON(!mem_map);
 
 	/* max/min_low_pfn was set by setup.c
@@ -29,35 +26,9 @@ mem_init(void)
 	 *
 	 * high_memory was also set in setup.c
 	 */
-
-	max_mapnr = num_physpages = max_low_pfn - min_low_pfn;
- 
-	/* this will put all memory onto the freelists */
+	max_mapnr = max_low_pfn - min_low_pfn;
         free_all_bootmem();
-
-	reservedpages = 0;
-	for (tmp = 0; tmp < max_mapnr; tmp++) {
-		/*
-                 * Only count reserved RAM pages
-                 */
-		if (PageReserved(mem_map + tmp))
-			reservedpages++;
-	}
-
-	codesize =  (unsigned long) &_etext - (unsigned long) &_stext;
-        datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
-        initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
-	
-        printk(KERN_INFO
-               "Memory: %luk/%luk available (%dk kernel code, %dk reserved, %dk data, "
-	       "%dk init)\n" ,
-	       nr_free_pages() << (PAGE_SHIFT-10),
-	       max_mapnr << (PAGE_SHIFT-10),
-	       codesize >> 10,
-	       reservedpages << (PAGE_SHIFT-10),
-	       datasize >> 10,
-	       initsize >> 10
-               );
+	mem_init_print_info(NULL);
 }
 
 /* free the pages occupied by initialization code */
-- 
1.7.9.5

