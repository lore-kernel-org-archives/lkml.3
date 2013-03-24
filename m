Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab3CXHgE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 03:36:04 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:46753 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab3CXHf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 03:35:56 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-xtensa@linux-xtensa.org
Subject: [RFC PATCH v2, part4 36/39] mm/xtensa: prepare for removing num_physpages and simplify mem_init()
Date: Sun, 24 Mar 2013 15:25:30 +0800
Message-Id: <1364109934-7851-65-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364109934-7851-1-git-send-email-jiang.liu@huawei.com>
References: <1364109934-7851-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-xtensa@linux-xtensa.org
Cc: linux-kernel@vger.kernel.org
---
 arch/xtensa/mm/init.c |   27 ++-------------------------
 1 file changed, 2 insertions(+), 25 deletions(-)

diff --git a/arch/xtensa/mm/init.c b/arch/xtensa/mm/init.c
index dc6e009..267428e 100644
--- a/arch/xtensa/mm/init.c
+++ b/arch/xtensa/mm/init.c
@@ -173,12 +173,8 @@ void __init zones_init(void)
 
 void __init mem_init(void)
 {
-	unsigned long codesize, reservedpages, datasize, initsize;
-	unsigned long highmemsize, tmp, ram;
-
-	max_mapnr = num_physpages = max_low_pfn - ARCH_PFN_OFFSET;
+	max_mapnr = max_low_pfn - ARCH_PFN_OFFSET;
 	high_memory = (void *) __va(max_low_pfn << PAGE_SHIFT);
-	highmemsize = 0;
 
 #ifdef CONFIG_HIGHMEM
 #error HIGHGMEM not implemented in init.c
@@ -186,26 +182,7 @@ void __init mem_init(void)
 
 	free_all_bootmem();
 
-	reservedpages = ram = 0;
-	for (tmp = 0; tmp < max_mapnr; tmp++) {
-		ram++;
-		if (PageReserved(mem_map+tmp))
-			reservedpages++;
-	}
-
-	codesize =  (unsigned long) _etext - (unsigned long) _stext;
-	datasize =  (unsigned long) _edata - (unsigned long) _sdata;
-	initsize =  (unsigned long) __init_end - (unsigned long) __init_begin;
-
-	printk("Memory: %luk/%luk available (%ldk kernel code, %ldk reserved, "
-	       "%ldk data, %ldk init %ldk highmem)\n",
-	       nr_free_pages() << (PAGE_SHIFT-10),
-	       ram << (PAGE_SHIFT-10),
-	       codesize >> 10,
-	       reservedpages << (PAGE_SHIFT-10),
-	       datasize >> 10,
-	       initsize >> 10,
-	       highmemsize >> 10);
+	mem_init_print_info(NULL);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
-- 
1.7.9.5

