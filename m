Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965688Ab3CZQAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:00:13 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:53760 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933575Ab3CZQAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:00:08 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Kuo <rkuo@codeaurora.org>, linux-hexagon@vger.kernel.org
Subject: [PATCH v3, part4 19/39] mm/hexagon: prepare for removing num_physpages and simplify mem_init()
Date: Tue, 26 Mar 2013 23:54:38 +0800
Message-Id: <1364313298-17336-20-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364313298-17336-1-git-send-email-jiang.liu@huawei.com>
References: <1364313298-17336-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-hexagon@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
Hi all,
	Sorry for my mistake that my previous patch series has been screwed up.
So I regenerate a third version and also set up a git tree at:
	git://github.com/jiangliu/linux.git mem_init
	Any help to review and test are welcomed!

	Regards!
	Gerry
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

