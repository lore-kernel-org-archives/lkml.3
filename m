Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966674Ab3E2Op4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 10:45:56 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:38061 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966590Ab3E2Opw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 10:45:52 -0400
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
        Johannes Weiner <hannes@cmpxchg.org>,
        "David S. Miller" <davem@davemloft.net>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH, v2 11/13] mm: kill free_all_bootmem_node()
Date: Wed, 29 May 2013 22:44:50 +0800
Message-Id: <1369838692-26860-12-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369838692-26860-1-git-send-email-jiang.liu@huawei.com>
References: <1369838692-26860-1-git-send-email-jiang.liu@huawei.com>
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
 include/linux/bootmem.h |  1 -
 mm/bootmem.c            | 18 ------------------
 2 files changed, 19 deletions(-)

diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index 0e48c32..f1f07d3 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -44,7 +44,6 @@ extern unsigned long init_bootmem_node(pg_data_t *pgdat,
 				       unsigned long endpfn);
 extern unsigned long init_bootmem(unsigned long addr, unsigned long memend);
 
-extern unsigned long free_all_bootmem_node(pg_data_t *pgdat);
 extern unsigned long free_all_bootmem(void);
 extern void reset_all_zones_managed_pages(void);
 
diff --git a/mm/bootmem.c b/mm/bootmem.c
index 58609bb..6ab7744 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -264,24 +264,6 @@ void __init reset_all_zones_managed_pages(void)
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
1.8.1.2

