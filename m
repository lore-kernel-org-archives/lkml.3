Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab3DMPkv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 11:40:51 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:62916 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab3DMPkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 11:40:47 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, David Howells <dhowells@redhat.com>,
        Mark Salter <msalter@redhat.com>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-ia64@vger.kernel.org
Subject: [RFC PATCH v1 03/19] mm/IA64: prepare for killing free_all_bootmem_node()
Date: Sat, 13 Apr 2013 23:36:23 +0800
Message-Id: <1365867399-21323-4-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365867399-21323-1-git-send-email-jiang.liu@huawei.com>
References: <1365867399-21323-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for killing free_all_bootmem_node() by using
free_all_bootmem().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: linux-ia64@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/ia64/mm/init.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index d4382dc..26eeb74 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -584,7 +584,6 @@ __setup("nolwsys", nolwsys_setup);
 void __init
 mem_init (void)
 {
-	pg_data_t *pgdat;
 	int i;
 
 	BUG_ON(PTRS_PER_PGD * sizeof(pgd_t) != PAGE_SIZE);
@@ -602,15 +601,11 @@ mem_init (void)
 
 #ifdef CONFIG_FLATMEM
 	BUG_ON(!mem_map);
-	max_mapnr = max_low_pfn;
 #endif
 
+	set_max_mapnr(max_low_pfn);
 	high_memory = __va(max_low_pfn * PAGE_SIZE);
-
-	for_each_online_pgdat(pgdat)
-		if (pgdat->bdata->node_bootmem_map)
-			free_all_bootmem_node(pgdat);
-
+	free_all_bootmem();
 	mem_init_print_info(NULL);
 
 	/*
-- 
1.7.9.5

