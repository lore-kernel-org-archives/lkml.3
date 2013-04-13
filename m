Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817Ab3DMPlw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 11:41:52 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:42827 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156Ab3DMPls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 11:41:48 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, David Howells <dhowells@redhat.com>,
        Mark Salter <msalter@redhat.com>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH v1 09/19] mm/PPC: prepare for killing free_all_bootmem_node()
Date: Sat, 13 Apr 2013 23:36:29 +0800
Message-Id: <1365867399-21323-10-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365867399-21323-1-git-send-email-jiang.liu@huawei.com>
References: <1365867399-21323-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for killing free_all_bootmem_node() by using
free_all_bootmem().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Alexander Graf <agraf@suse.de>
Cc: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
---
 arch/powerpc/mm/mem.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 07663de..22e46db 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -305,22 +305,8 @@ void __init mem_init(void)
 #endif
 
 	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE);
-
-#ifdef CONFIG_NEED_MULTIPLE_NODES
-	{
-		pg_data_t *pgdat;
-
-		for_each_online_pgdat(pgdat)
-			if (pgdat->node_spanned_pages != 0) {
-				printk("freeing bootmem node %d\n",
-					pgdat->node_id);
-				free_all_bootmem_node(pgdat);
-			}
-	}
-#else
-	max_mapnr = max_pfn;
+	set_max_mapnr(max_pfn);
 	free_all_bootmem();
-#endif
 
 #ifdef CONFIG_HIGHMEM
 	{
-- 
1.7.9.5

