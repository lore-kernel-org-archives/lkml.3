Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966601Ab3E2OGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 10:06:10 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:47463 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966515Ab3E2N7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:59:39 -0400
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
Subject: [PATCH v6, part4 25/41] mm/metag: prepare for removing num_physpages and simplify mem_init()
Date: Wed, 29 May 2013 21:57:43 +0800
Message-Id: <1369835879-23553-26-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
References: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 arch/metag/mm/init.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/metag/mm/init.c b/arch/metag/mm/init.c
index ce81d7c..e0862b7 100644
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
1.8.1.2

