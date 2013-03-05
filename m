Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab3CEPCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 10:02:52 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:50248 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109Ab3CEPCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 10:02:50 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Chris Clayton <chris2553@googlemail.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>
Subject: [RFC PATCH v1 26/33] mm/xtensa: use common help functions to free reserved pages
Date: Tue,  5 Mar 2013 22:55:09 +0800
Message-Id: <1362495317-32682-27-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362495317-32682-1-git-send-email-jiang.liu@huawei.com>
References: <1362495317-32682-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/mm/init.c |   21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/arch/xtensa/mm/init.c b/arch/xtensa/mm/init.c
index 7a5156f..bba125b 100644
--- a/arch/xtensa/mm/init.c
+++ b/arch/xtensa/mm/init.c
@@ -208,32 +208,17 @@ void __init mem_init(void)
 	       highmemsize >> 10);
 }
 
-void
-free_reserved_mem(void *start, void *end)
-{
-	for (; start < end; start += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(start));
-		init_page_count(virt_to_page(start));
-		free_page((unsigned long)start);
-		totalram_pages++;
-	}
-}
-
 #ifdef CONFIG_BLK_DEV_INITRD
 extern int initrd_is_mapped;
 
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	if (initrd_is_mapped) {
-		free_reserved_mem((void*)start, (void*)end);
-		printk ("Freeing initrd memory: %ldk freed\n",(end-start)>>10);
-	}
+	if (initrd_is_mapped)
+		free_reserved_area(start, end, 0, "initrd");
 }
 #endif
 
 void free_initmem(void)
 {
-	free_reserved_mem(__init_begin, __init_end);
-	printk("Freeing unused kernel memory: %zuk freed\n",
-	       (__init_end - __init_begin) >> 10);
+	free_initmem_default(0);
 }
-- 
1.7.9.5

