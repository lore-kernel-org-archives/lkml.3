Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab3CJIJR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 04:09:17 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:58661 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab3CJII5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 04:08:57 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v2, part2 03/10] mm/FRV: use free_highmem_page() to free highmem pages into buddy system
Date: Sun, 10 Mar 2013 16:01:03 +0800
Message-Id: <1362902470-25787-4-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362902470-25787-1-git-send-email-jiang.liu@huawei.com>
References: <1362902470-25787-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use helper function free_highmem_page() to free highmem pages into
the buddy system.

Also fix a bug that totalhigh_pages should be increased when freeing
a highmem page into the buddy system.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
---
 arch/frv/mm/init.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/frv/mm/init.c b/arch/frv/mm/init.c
index 21b9290..dee354f 100644
--- a/arch/frv/mm/init.c
+++ b/arch/frv/mm/init.c
@@ -131,10 +131,8 @@ void __init mem_init(void)
 			datapages++;
 
 #ifdef CONFIG_HIGHMEM
-	for (pfn = num_physpages - 1; pfn >= num_mappedpages; pfn--) {
-		__free_reserved_page(&mem_map[pfn]);
-		totalram_pages++;
-	}
+	for (pfn = num_physpages - 1; pfn >= num_mappedpages; pfn--)
+		free_highmem_page(&mem_map[pfn]);
 #endif
 
 	codek = ((unsigned long) &_etext - (unsigned long) &_stext) >> 10;
-- 
1.7.9.5

