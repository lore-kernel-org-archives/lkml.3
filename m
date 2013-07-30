Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab3G3GtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 02:49:21 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:12137 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535Ab3G3GtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 02:49:20 -0400
Message-ID: <51F761E7.5090403@huawei.com>
Date: Tue, 30 Jul 2013 14:49:11 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm/hotplug: remove unnecessary BUG_ON in __offline_pages()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think we can remove "BUG_ON(start_pfn >= end_pfn)" in __offline_pages(),
because in memory_block_action() "nr_pages = PAGES_PER_SECTION * sections_per_block" 
is always greater than 0.

memory_block_action()
	offline_pages()
		__offline_pages()
			BUG_ON(start_pfn >= end_pfn)

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 mm/memory_hotplug.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index ca1dd3a..8e333f9 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1472,7 +1472,6 @@ static int __ref __offline_pages(unsigned long start_pfn,
 	struct zone *zone;
 	struct memory_notify arg;
 
-	BUG_ON(start_pfn >= end_pfn);
 	/* at least, alignment against pageblock is necessary */
 	if (!IS_ALIGNED(start_pfn, pageblock_nr_pages))
 		return -EINVAL;
-- 
1.8.2.2

