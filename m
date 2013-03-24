Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab3CXHao (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 03:30:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52848 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab3CXHai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 03:30:38 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Richard Kuo <rkuo@codeaurora.org>, linux-hexagon@vger.kernel.org
Subject: [RFC PATCH v2, part4 18/39] mm/hexagon: prepare for removing num_physpages and simplify mem_init()
Date: Sun, 24 Mar 2013 15:24:54 +0800
Message-Id: <1364109934-7851-29-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364109934-7851-1-git-send-email-jiang.liu@huawei.com>
References: <1364109934-7851-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-hexagon@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/hexagon/mm/init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/hexagon/mm/init.c b/arch/hexagon/mm/init.c
index c048d06e..c0f0781 100644
--- a/arch/hexagon/mm/init.c
+++ b/arch/hexagon/mm/init.c
@@ -70,9 +70,8 @@ unsigned long long kmap_generation;
 void __init mem_init(void)
 {
 	free_all_bootmem();
-	num_physpages = bootmem_lastpg;	/*  seriously, what?  */
 
-	printk(KERN_INFO "totalram_pages = %ld\n", totalram_pages);
+	mem_init_print_info(NULL);
 
 	/*
 	 *  To-Do:  someone somewhere should wipe out the bootmem map
-- 
1.7.9.5

