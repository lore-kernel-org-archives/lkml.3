Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab3CJGag (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 01:30:36 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:43186 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab3CJGaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 01:30:20 -0500
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
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: [PATCH v2, part1 04/29] mm/avr32: use common help functions to free reserved pages
Date: Sun, 10 Mar 2013 14:26:47 +0800
Message-Id: <1362896833-21104-5-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362896833-21104-1-git-send-email-jiang.liu@huawei.com>
References: <1362896833-21104-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
---
 arch/avr32/mm/init.c |   24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/arch/avr32/mm/init.c b/arch/avr32/mm/init.c
index 2798c2d..e66e840 100644
--- a/arch/avr32/mm/init.c
+++ b/arch/avr32/mm/init.c
@@ -146,34 +146,14 @@ void __init mem_init(void)
 		initsize >> 10);
 }
 
-static inline void free_area(unsigned long addr, unsigned long end, char *s)
-{
-	unsigned int size = (end - addr) >> 10;
-
-	for (; addr < end; addr += PAGE_SIZE) {
-		struct page *page = virt_to_page(addr);
-		ClearPageReserved(page);
-		init_page_count(page);
-		free_page(addr);
-		totalram_pages++;
-	}
-
-	if (size && s)
-		printk(KERN_INFO "Freeing %s memory: %dK (%lx - %lx)\n",
-		       s, size, end - (size << 10), end);
-}
-
 void free_initmem(void)
 {
-	free_area((unsigned long)__init_begin, (unsigned long)__init_end,
-		  "init");
+	free_initmem_default(0);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
-
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_area(start, end, "initrd");
+	free_reserved_area(start, end, 0, "initrd");
 }
-
 #endif
-- 
1.7.9.5

