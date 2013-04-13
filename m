Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933126Ab3DMPmN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 11:42:13 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:47279 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607Ab3DMPmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 11:42:09 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, David Howells <dhowells@redhat.com>,
        Mark Salter <msalter@redhat.com>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>
Subject: [RFC PATCH v1 11/19] mm: kill free_all_bootmem_node()
Date: Sat, 13 Apr 2013 23:36:31 +0800
Message-Id: <1365867399-21323-12-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365867399-21323-1-git-send-email-jiang.liu@huawei.com>
References: <1365867399-21323-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now nobody makes use of free_all_bootmem_node(), kill it.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 include/linux/bootmem.h |    1 -
 mm/bootmem.c            |   18 ------------------
 2 files changed, 19 deletions(-)

diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index b585f57..a8866c5 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -45,7 +45,6 @@ extern unsigned long init_bootmem_node(pg_data_t *pgdat,
 extern unsigned long init_bootmem(unsigned long addr, unsigned long memend);
 
 extern unsigned long free_low_memory_core_early(int nodeid);
-extern unsigned long free_all_bootmem_node(pg_data_t *pgdat);
 extern unsigned long free_all_bootmem(void);
 extern void reset_all_zones_managed_pages(void);
 
diff --git a/mm/bootmem.c b/mm/bootmem.c
index a19404b..fab8f63 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -265,24 +265,6 @@ void __init reset_all_zones_managed_pages(void)
 }
 
 /**
- * free_all_bootmem_node - release a node's free pages to the buddy allocator
- * @pgdat: node to be released
- *
- * Returns the number of pages actually released.
- */
-unsigned long __init free_all_bootmem_node(pg_data_t *pgdat)
-{
-	unsigned long pages;
-
-	register_page_bootmem_info_node(pgdat);
-	reset_node_managed_pages(pgdat);
-	pages = free_all_bootmem_core(pgdat->bdata);
-	totalram_pages += pages;
-
-	return pages;
-}
-
-/**
  * free_all_bootmem - release free pages to the buddy allocator
  *
  * Returns the number of pages actually released.
-- 
1.7.9.5

