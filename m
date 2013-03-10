Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab3CJIJN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 04:09:13 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:35269 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab3CJIIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 04:08:51 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2, part2 02/10] mm/ARM: use free_highmem_page() to free highmem pages into buddy system
Date: Sun, 10 Mar 2013 16:01:02 +0800
Message-Id: <1362902470-25787-3-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362902470-25787-1-git-send-email-jiang.liu@huawei.com>
References: <1362902470-25787-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use helper function free_highmem_page() to free highmem pages into
the buddy system.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>
cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mm/init.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 40a5bc2..687a114 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -519,10 +519,8 @@ static void __init free_unused_memmap(struct meminfo *mi)
 #ifdef CONFIG_HIGHMEM
 static inline void free_area_high(unsigned long pfn, unsigned long end)
 {
-	for (; pfn < end; pfn++) {
-		__free_reserved_page(pfn_to_page(pfn));
-		totalhigh_pages++;
-	}
+	for (; pfn < end; pfn++)
+		free_highmem_page(pfn_to_page(pfn));
 }
 #endif
 
@@ -571,7 +569,6 @@ static void __init free_highpages(void)
 		if (start < end)
 			free_area_high(start, end);
 	}
-	totalram_pages += totalhigh_pages;
 #endif
 }
 
-- 
1.7.9.5

