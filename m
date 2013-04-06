Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423079Ab3DFN4p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 09:56:45 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:53569 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423033Ab3DFN4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 09:56:42 -0400
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
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: [PATCH v4, part3 07/15] mm, acornfb: use free_reserved_area() to simplify code
Date: Sat,  6 Apr 2013 21:55:01 +0800
Message-Id: <1365256509-29024-8-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365256509-29024-1-git-send-email-jiang.liu@huawei.com>
References: <1365256509-29024-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use common help function free_reserved_area() to simplify code.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/video/acornfb.c |   28 ++--------------------------
 1 file changed, 2 insertions(+), 26 deletions(-)

diff --git a/drivers/video/acornfb.c b/drivers/video/acornfb.c
index 6488a73..344f2bb 100644
--- a/drivers/video/acornfb.c
+++ b/drivers/video/acornfb.c
@@ -1188,32 +1188,8 @@ static int acornfb_detect_monitortype(void)
 static inline void
 free_unused_pages(unsigned int virtual_start, unsigned int virtual_end)
 {
-	int mb_freed = 0;
-
-	/*
-	 * Align addresses
-	 */
-	virtual_start = PAGE_ALIGN(virtual_start);
-	virtual_end = PAGE_ALIGN(virtual_end);
-
-	while (virtual_start < virtual_end) {
-		struct page *page;
-
-		/*
-		 * Clear page reserved bit,
-		 * set count to 1, and free
-		 * the page.
-		 */
-		page = virt_to_page(virtual_start);
-		ClearPageReserved(page);
-		init_page_count(page);
-		free_page(virtual_start);
-
-		virtual_start += PAGE_SIZE;
-		mb_freed += PAGE_SIZE / 1024;
-	}
-
-	printk("acornfb: freed %dK memory\n", mb_freed);
+	free_reserved_area(virtual_start, PAGE_ALIGN(virtual_end),
+			   -1, "acornfb");
 }
 
 static int acornfb_probe(struct platform_device *dev)
-- 
1.7.9.5

