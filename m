Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab3CJIKG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 04:10:06 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:35256 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab3CJIJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 04:09:55 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Cong Wang <amwang@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Attilio Rao <attilio.rao@citrix.com>, konrad.wilk@oracle.com
Subject: [PATCH v2, part2 10/10] mm/x86: use free_highmem_page() to free highmem pages into buddy system
Date: Sun, 10 Mar 2013 16:01:10 +0800
Message-Id: <1362902470-25787-11-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362902470-25787-1-git-send-email-jiang.liu@huawei.com>
References: <1362902470-25787-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use helper function free_highmem_page() to free highmem pages into
the buddy system.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Cong Wang <amwang@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Attilio Rao <attilio.rao@citrix.com>
Cc: konrad.wilk@oracle.com
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/mm/highmem_32.c |    1 -
 arch/x86/mm/init_32.c    |   10 +---------
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index 6f31ee5..252b8f5 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -137,5 +137,4 @@ void __init set_highmem_pages_init(void)
 		add_highpages_with_active_regions(nid, zone_start_pfn,
 				 zone_end_pfn);
 	}
-	totalram_pages += totalhigh_pages;
 }
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 2d19001..3ac7e31 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -427,14 +427,6 @@ static void __init permanent_kmaps_init(pgd_t *pgd_base)
 	pkmap_page_table = pte;
 }
 
-static void __init add_one_highpage_init(struct page *page)
-{
-	ClearPageReserved(page);
-	init_page_count(page);
-	__free_page(page);
-	totalhigh_pages++;
-}
-
 void __init add_highpages_with_active_regions(int nid,
 			 unsigned long start_pfn, unsigned long end_pfn)
 {
@@ -448,7 +440,7 @@ void __init add_highpages_with_active_regions(int nid,
 					      start_pfn, end_pfn);
 		for ( ; pfn < e_pfn; pfn++)
 			if (pfn_valid(pfn))
-				add_one_highpage_init(pfn_to_page(pfn));
+				free_highmem_page(pfn_to_page(pfn));
 	}
 }
 #else
-- 
1.7.9.5

