Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966514Ab3E2OIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 10:08:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56147 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966436Ab3E2N7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:59:11 -0400
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
        Aurelien Jacquiot <a-jacquiot@ti.com>, linux-c6x-dev@linux-c6x.org
Subject: [PATCH v6, part4 17/41] mm/c6x: prepare for removing num_physpages and simplify mem_init()
Date: Wed, 29 May 2013 21:57:35 +0800
Message-Id: <1369835879-23553-18-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
References: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: linux-c6x-dev@linux-c6x.org
Cc: linux-kernel@vger.kernel.org
---
 arch/c6x/mm/init.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/arch/c6x/mm/init.c b/arch/c6x/mm/init.c
index df3714b..e524fde 100644
--- a/arch/c6x/mm/init.c
+++ b/arch/c6x/mm/init.c
@@ -57,21 +57,12 @@ void __init paging_init(void)
 
 void __init mem_init(void)
 {
-	int codek, datak;
-	unsigned long tmp;
-	unsigned long len = memory_end - memory_start;
-
 	high_memory = (void *)(memory_end & PAGE_MASK);
 
 	/* this will put all memory onto the freelists */
 	free_all_bootmem();
 
-	codek = (_etext - _stext) >> 10;
-	datak = (_end - _sdata) >> 10;
-
-	tmp = nr_free_pages() << PAGE_SHIFT;
-	printk(KERN_INFO "Memory: %luk/%luk RAM (%dk kernel code, %dk data)\n",
-	       tmp >> 10, len >> 10, codek, datak);
+	mem_init_print_info(NULL);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
-- 
1.8.1.2

