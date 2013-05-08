Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004Ab3EHP4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:56:08 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:49333 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab3EHP4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:56:03 -0400
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
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5, part4 25/41] mm/metag: prepare for removing num_physpages and simplify mem_init()
Date: Wed,  8 May 2013 23:51:22 +0800
Message-Id: <1368028298-7401-26-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368028298-7401-1-git-send-email-jiang.liu@huawei.com>
References: <1368028298-7401-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 arch/metag/mm/init.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/metag/mm/init.c b/arch/metag/mm/init.c
index 279d701..e00586f 100644
--- a/arch/metag/mm/init.c
+++ b/arch/metag/mm/init.c
@@ -388,22 +388,16 @@ void __init mem_init(void)
 	reset_all_zones_managed_pages();
 	for (tmp = highstart_pfn; tmp < highend_pfn; tmp++)
 		free_highmem_page(pfn_to_page(tmp));
-	num_physpages += totalhigh_pages;
 #endif /* CONFIG_HIGHMEM */
 
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
 
-		num_physpages += pgdat->node_present_pages;
-
 		if (pgdat->node_spanned_pages)
 			free_all_bootmem_node(pgdat);
 	}
 
-	pr_info("Memory: %luk/%luk available\n",
-		(unsigned long)nr_free_pages() << (PAGE_SHIFT - 10),
-		num_physpages << (PAGE_SHIFT - 10));
-
+	mem_init_print_info(NULL);
 	show_mem(0);
 
 	return;
-- 
1.7.9.5

