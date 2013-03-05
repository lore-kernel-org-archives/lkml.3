Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145Ab3CEPDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 10:03:06 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:33626 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916Ab3CEPDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 10:03:02 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Chris Clayton <chris2553@googlemail.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Eric Biederman <ebiederm@xmission.com>
Subject: [RFC PATCH v1 27/33] mm,kexec: use common help functions to free reserved pages
Date: Tue,  5 Mar 2013 22:55:10 +0800
Message-Id: <1362495317-32682-28-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362495317-32682-1-git-send-email-jiang.liu@huawei.com>
References: <1362495317-32682-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Eric Biederman <ebiederm@xmission.com>
---
 kernel/kexec.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index bddd3d7..be95397 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1118,12 +1118,8 @@ void __weak crash_free_reserved_phys_range(unsigned long begin,
 {
 	unsigned long addr;
 
-	for (addr = begin; addr < end; addr += PAGE_SIZE) {
-		ClearPageReserved(pfn_to_page(addr >> PAGE_SHIFT));
-		init_page_count(pfn_to_page(addr >> PAGE_SHIFT));
-		free_page((unsigned long)__va(addr));
-		totalram_pages++;
-	}
+	for (addr = begin; addr < end; addr += PAGE_SIZE)
+		free_reserved_page(pfn_to_page(addr >> PAGE_SHIFT));
 }
 
 int crash_shrink_memory(unsigned long new_size)
-- 
1.7.9.5

