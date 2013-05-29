Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966468Ab3E2Osc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 10:48:32 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:34411 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966384Ab3E2OpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 10:45:24 -0400
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
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, linux-ia64@vger.kernel.org
Subject: [PATCH, v2 03/13] mm/IA64: prepare for killing free_all_bootmem_node()
Date: Wed, 29 May 2013 22:44:42 +0800
Message-Id: <1369838692-26860-4-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369838692-26860-1-git-send-email-jiang.liu@huawei.com>
References: <1369838692-26860-1-git-send-email-jiang.liu@huawei.com>
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
 arch/ia64/mm/init.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index 2d372b4..b6f7f43 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -583,7 +583,6 @@ __setup("nolwsys", nolwsys_setup);
 void __init
 mem_init (void)
 {
-	pg_data_t *pgdat;
 	int i;
 
 	BUG_ON(PTRS_PER_PGD * sizeof(pgd_t) != PAGE_SIZE);
@@ -601,15 +600,11 @@ mem_init (void)
 
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
1.8.1.2

