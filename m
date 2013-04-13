Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab3DMPla (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 11:41:30 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:41899 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156Ab3DMPl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 11:41:28 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, David Howells <dhowells@redhat.com>,
        Mark Salter <msalter@redhat.com>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org
Subject: [RFC PATCH v1 07/19] mm/MIPS: prepare for killing free_all_bootmem_node()
Date: Sat, 13 Apr 2013 23:36:27 +0800
Message-Id: <1365867399-21323-8-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365867399-21323-1-git-send-email-jiang.liu@huawei.com>
References: <1365867399-21323-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for killing free_all_bootmem_node() by using
free_all_bootmem().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
---
 arch/mips/sgi-ip27/ip27-memory.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/mips/sgi-ip27/ip27-memory.c b/arch/mips/sgi-ip27/ip27-memory.c
index d074680..0ebea6f 100644
--- a/arch/mips/sgi-ip27/ip27-memory.c
+++ b/arch/mips/sgi-ip27/ip27-memory.c
@@ -477,18 +477,8 @@ void __init paging_init(void)
 
 void __init mem_init(void)
 {
-	unsigned node;
-
 	high_memory = (void *) __va(get_num_physpages() << PAGE_SHIFT);
-
-	for_each_online_node(node) {
-		/*
-		 * This will free up the bootmem, ie, slot 0 memory.
-		 */
-		free_all_bootmem_node(NODE_DATA(node));
-	}
-
+	free_all_bootmem();
 	setup_zero_pages();	/* This comes from node 0 */
-
 	mem_init_print_info(NULL);
 }
-- 
1.7.9.5

