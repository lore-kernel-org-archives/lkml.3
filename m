Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965805Ab3CZQDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:03:33 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:60442 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759835Ab3CZQDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:03:19 -0400
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
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH v3, part4 34/39] mm/um: prepare for removing num_physpages and simplify mem_init()
Date: Tue, 26 Mar 2013 23:54:53 +0800
Message-Id: <1364313298-17336-35-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364313298-17336-1-git-send-email-jiang.liu@huawei.com>
References: <1364313298-17336-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net
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
 arch/um/kernel/mem.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index a7dc6c1..819008f 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -70,10 +70,8 @@ void __init mem_init(void)
 #ifdef CONFIG_HIGHMEM
 	setup_highmem(end_iomem, highmem);
 #endif
-	num_physpages = totalram_pages;
 	max_pfn = totalram_pages;
-	printk(KERN_INFO "Memory: %luk available\n",
-	       nr_free_pages() << (PAGE_SHIFT-10));
+	mem_init_print_info(NULL);
 	kmalloc_ok = 1;
 }
 
-- 
1.7.9.5

