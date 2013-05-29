Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966529Ab3E2Opq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 10:45:46 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:58643 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966482Ab3E2Opm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 10:45:42 -0400
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
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org
Subject: [PATCH, v2 08/13] mm/PARISC: prepare for killing free_all_bootmem_node()
Date: Wed, 29 May 2013 22:44:47 +0800
Message-Id: <1369838692-26860-9-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369838692-26860-1-git-send-email-jiang.liu@huawei.com>
References: <1369838692-26860-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for killing free_all_bootmem_node() by using
free_all_bootmem().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: linux-parisc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/parisc/mm/init.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index 3f31102..cf4ca13 100644
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -585,18 +585,8 @@ void __init mem_init(void)
 			> BITS_PER_LONG);
 
 	high_memory = __va((max_pfn << PAGE_SHIFT));
-
-#ifndef CONFIG_DISCONTIGMEM
-	max_mapnr = page_to_pfn(virt_to_page(high_memory - 1)) + 1;
+	set_max_mapnr(page_to_pfn(virt_to_page(high_memory - 1)) + 1);
 	free_all_bootmem();
-#else
-	{
-		int i;
-
-		for (i = 0; i < npmem_ranges; i++)
-			free_all_bootmem_node(NODE_DATA(i));
-	}
-#endif
 
 #ifdef CONFIG_PA11
 	if (hppa_dma_ops == &pcxl_dma_ops) {
-- 
1.8.1.2

