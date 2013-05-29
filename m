Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966683Ab3E2OEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 10:04:38 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36897 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966589Ab3E2OAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 10:00:08 -0400
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
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: [PATCH v6, part4 33/41] mm/score: prepare for removing num_physpages and simplify mem_init()
Date: Wed, 29 May 2013 21:57:51 +0800
Message-Id: <1369835879-23553-34-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
References: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: linux-kernel@vger.kernel.org
---
 arch/score/mm/init.c | 26 ++------------------------
 1 file changed, 2 insertions(+), 24 deletions(-)

diff --git a/arch/score/mm/init.c b/arch/score/mm/init.c
index c1601da..54dda1f 100644
--- a/arch/score/mm/init.c
+++ b/arch/score/mm/init.c
@@ -77,33 +77,11 @@ void __init paging_init(void)
 
 void __init mem_init(void)
 {
-	unsigned long codesize, reservedpages, datasize, initsize;
-	unsigned long tmp, ram = 0;
-
 	high_memory = (void *) __va(max_low_pfn << PAGE_SHIFT);
 	free_all_bootmem();
 	setup_zero_page();	/* Setup zeroed pages. */
-	reservedpages = 0;
-
-	for (tmp = 0; tmp < max_low_pfn; tmp++)
-		if (page_is_ram(tmp)) {
-			ram++;
-			if (PageReserved(pfn_to_page(tmp)))
-				reservedpages++;
-		}
-
-	num_physpages = ram;
-	codesize = (unsigned long) &_etext - (unsigned long) &_text;
-	datasize = (unsigned long) &_edata - (unsigned long) &_etext;
-	initsize = (unsigned long) &__init_end - (unsigned long) &__init_begin;
-
-	printk(KERN_INFO "Memory: %luk/%luk available (%ldk kernel code, "
-			"%ldk reserved, %ldk data, %ldk init, %ldk highmem)\n",
-			(unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
-			ram << (PAGE_SHIFT-10), codesize >> 10,
-			reservedpages << (PAGE_SHIFT-10), datasize >> 10,
-			initsize >> 10,
-			totalhigh_pages << (PAGE_SHIFT-10));
+
+	mem_init_print_info(NULL);
 }
 #endif /* !CONFIG_NEED_MULTIPLE_NODES */
 
-- 
1.8.1.2

