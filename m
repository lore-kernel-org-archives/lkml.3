Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966460Ab3E2Opg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 10:45:36 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:58729 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966381Ab3E2Opc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 10:45:32 -0400
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
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Ungerer <gerg@uclinux.org>, linux-m68k@vger.kernel.org
Subject: [PATCH, v2 05/13] mm/m68k: prepare for killing free_all_bootmem_node()
Date: Wed, 29 May 2013 22:44:44 +0800
Message-Id: <1369838692-26860-6-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369838692-26860-1-git-send-email-jiang.liu@huawei.com>
References: <1369838692-26860-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for killing free_all_bootmem_node() by using
free_all_bootmem().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: linux-m68k@lists.linux-m68k.org
Cc: linux-kernel@vger.kernel.org
---
 arch/m68k/mm/init.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/m68k/mm/init.c b/arch/m68k/mm/init.c
index 397a884..6e0a938 100644
--- a/arch/m68k/mm/init.c
+++ b/arch/m68k/mm/init.c
@@ -148,12 +148,10 @@ void __init print_memmap(void)
 
 void __init mem_init(void)
 {
-	pg_data_t *pgdat;
 	int i;
 
 	/* this will put all memory onto the freelists */
-	for_each_online_pgdat(pgdat)
-		free_all_bootmem_node(pgdat);
+	free_all_bootmem();
 
 #if defined(CONFIG_MMU) && !defined(CONFIG_SUN3) && !defined(CONFIG_COLDFIRE)
 	/* insert pointer tables allocated so far into the tablelist */
-- 
1.8.1.2

