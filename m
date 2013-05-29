Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966502Ab3E2N7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:59:31 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40231 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966483Ab3E2N7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:59:25 -0400
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
        Richard Kuo <rkuo@codeaurora.org>, linux-hexagon@vger.kernel.org
Subject: [PATCH v6, part4 21/41] mm/hexagon: prepare for removing num_physpages and simplify mem_init()
Date: Wed, 29 May 2013 21:57:39 +0800
Message-Id: <1369835879-23553-22-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
References: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-hexagon@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/hexagon/mm/init.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/hexagon/mm/init.c b/arch/hexagon/mm/init.c
index 0ab5b43..88977e4 100644
--- a/arch/hexagon/mm/init.c
+++ b/arch/hexagon/mm/init.c
@@ -71,9 +71,7 @@ void __init mem_init(void)
 {
 	/*  No idea where this is actually declared.  Seems to evade LXR.  */
 	free_all_bootmem();
-	num_physpages = bootmem_lastpg-ARCH_PFN_OFFSET;
-
-	printk(KERN_INFO "totalram_pages = %ld\n", totalram_pages);
+	mem_init_print_info(NULL);
 
 	/*
 	 *  To-Do:  someone somewhere should wipe out the bootmem map
-- 
1.8.1.2

