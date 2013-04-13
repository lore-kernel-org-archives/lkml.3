Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab3DMPlU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 11:41:20 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:40448 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156Ab3DMPlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 11:41:17 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, David Howells <dhowells@redhat.com>,
        Mark Salter <msalter@redhat.com>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, James Hogan <james.hogan@imgtec.com>
Subject: [RFC PATCH v1 06/19] mm/metag: prepare for killing free_all_bootmem_node()
Date: Sat, 13 Apr 2013 23:36:26 +0800
Message-Id: <1365867399-21323-7-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365867399-21323-1-git-send-email-jiang.liu@huawei.com>
References: <1365867399-21323-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for killing free_all_bootmem_node() by using
free_all_bootmem().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: linux-kernel@vger.kernel.org
---
 arch/metag/mm/init.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/arch/metag/mm/init.c b/arch/metag/mm/init.c
index e00586f..096d022 100644
--- a/arch/metag/mm/init.c
+++ b/arch/metag/mm/init.c
@@ -376,31 +376,21 @@ void __init paging_init(unsigned long mem_end)
 
 void __init mem_init(void)
 {
-	int nid;
-
 #ifdef CONFIG_HIGHMEM
 	unsigned long tmp;
 
 	/*
 	 * Explicitly reset zone->managed_pages because highmem pages are
-	 * freed before calling free_all_bootmem_node();
+	 * freed before calling free_all_bootmem();
 	 */
 	reset_all_zones_managed_pages();
 	for (tmp = highstart_pfn; tmp < highend_pfn; tmp++)
 		free_highmem_page(pfn_to_page(tmp));
 #endif /* CONFIG_HIGHMEM */
 
-	for_each_online_node(nid) {
-		pg_data_t *pgdat = NODE_DATA(nid);
-
-		if (pgdat->node_spanned_pages)
-			free_all_bootmem_node(pgdat);
-	}
-
+	free_all_bootmem();
 	mem_init_print_info(NULL);
 	show_mem(0);
-
-	return;
 }
 
 void free_initmem(void)
-- 
1.7.9.5

