Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbaJBPuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:50:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38887 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175AbaJBPtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:49:41 -0400
From: Vlastimil Babka <vbabka@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Xishi Qiu <qiuxishi@huawei.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 3/4] mm, cma: drain single zone pcplists
Date: Thu,  2 Oct 2014 17:48:59 +0200
Message-Id: <1412264940-15738-4-git-send-email-vbabka@suse.cz>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1412264940-15738-1-git-send-email-vbabka@suse.cz>
References: <1412264940-15738-1-git-send-email-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CMA allocation drains pcplists so that pages can merge back to buddy allocator.
Since it operates on a single zone, we can reduce the pcplists drain to the
single zone, which is now possible.

The change should make CMA allocations faster and not disturbing unrelated
pcplists anymore.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bc3db3e..e758159 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6417,7 +6417,7 @@ int alloc_contig_range(unsigned long start, unsigned long end,
 	 */
 
 	lru_add_drain_all();
-	drain_all_pages(NULL);
+	drain_all_pages(cc.zone);
 
 	order = 0;
 	outer_start = start;
-- 
1.8.4.5

