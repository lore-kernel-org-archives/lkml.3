Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab3CJGb6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 01:31:58 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:34496 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3CJGb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 01:31:56 -0500
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
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: [PATCH v2, part1 15/29] mm/mn10300: use common help functions to free reserved pages
Date: Sun, 10 Mar 2013 14:26:58 +0800
Message-Id: <1362896833-21104-16-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362896833-21104-1-git-send-email-jiang.liu@huawei.com>
References: <1362896833-21104-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
---
 arch/mn10300/mm/init.c |   23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

diff --git a/arch/mn10300/mm/init.c b/arch/mn10300/mm/init.c
index e57e5bc..5a8ace6 100644
--- a/arch/mn10300/mm/init.c
+++ b/arch/mn10300/mm/init.c
@@ -139,30 +139,11 @@ void __init mem_init(void)
 }
 
 /*
- *
- */
-void free_init_pages(char *what, unsigned long begin, unsigned long end)
-{
-	unsigned long addr;
-
-	for (addr = begin; addr < end; addr += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(addr));
-		init_page_count(virt_to_page(addr));
-		memset((void *) addr, 0xcc, PAGE_SIZE);
-		free_page(addr);
-		totalram_pages++;
-	}
-	printk(KERN_INFO "Freeing %s: %ldk freed\n", what, (end - begin) >> 10);
-}
-
-/*
  * recycle memory containing stuff only required for initialisation
  */
 void free_initmem(void)
 {
-	free_init_pages("unused kernel memory",
-			(unsigned long) &__init_begin,
-			(unsigned long) &__init_end);
+	free_initmem_default(POISON_FREE_INITMEM);
 }
 
 /*
@@ -171,6 +152,6 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_init_pages("initrd memory", start, end);
+	free_reserved_area(start, end, POISON_FREE_INITMEM, "initrd");
 }
 #endif
-- 
1.7.9.5

