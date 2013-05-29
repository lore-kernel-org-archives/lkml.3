Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966689Ab3E2OB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 10:01:28 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:44895 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966645Ab3E2OAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 10:00:33 -0400
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
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-xtensa@linux-xtensa.org
Subject: [PATCH v6, part4 40/41] mm/xtensa: prepare for removing num_physpages and simplify mem_init()
Date: Wed, 29 May 2013 21:57:58 +0800
Message-Id: <1369835879-23553-41-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
References: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
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
 arch/xtensa/mm/init.c | 27 ++-------------------------
 1 file changed, 2 insertions(+), 25 deletions(-)

diff --git a/arch/xtensa/mm/init.c b/arch/xtensa/mm/init.c
index 663c161..479d753 100644
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
1.8.1.2

