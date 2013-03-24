Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab3CXH3w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 03:29:52 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:57412 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab3CXH3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 03:29:47 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, linux-c6x-dev@linux-c6x.org
Subject: [RFC PATCH v2, part4 15/39] mm/c6x: prepare for removing num_physpages and simplify mem_init()
Date: Sun, 24 Mar 2013 15:24:47 +0800
Message-Id: <1364109934-7851-22-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364109934-7851-1-git-send-email-jiang.liu@huawei.com>
References: <1364109934-7851-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: linux-c6x-dev@linux-c6x.org
Cc: linux-kernel@vger.kernel.org
---
 arch/c6x/mm/init.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/arch/c6x/mm/init.c b/arch/c6x/mm/init.c
index 2c51474..066f75c 100644
--- a/arch/c6x/mm/init.c
+++ b/arch/c6x/mm/init.c
@@ -57,21 +57,12 @@ void __init paging_init(void)
 
 void __init mem_init(void)
 {
-	int codek, datak;
-	unsigned long tmp;
-	unsigned long len = memory_end - memory_start;
-
 	high_memory = (void *)(memory_end & PAGE_MASK);
 
 	/* this will put all memory onto the freelists */
 	free_all_bootmem();
 
-	codek = (_etext - _stext) >> 10;
-	datak = (_end - _sdata) >> 10;
-
-	tmp = nr_free_pages() << PAGE_SHIFT;
-	printk(KERN_INFO "Memory: %luk/%luk RAM (%dk kernel code, %dk data)\n",
-	       tmp >> 10, len >> 10, codek, datak);
+	mem_init_print_info(NULL);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
-- 
1.7.9.5

