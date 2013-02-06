Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab3BFJAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 04:00:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:43009 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab3BFJAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 04:00:04 -0500
X-IronPort-AV: E=Sophos;i="4.84,614,1355068800"; 
   d="scan'208";a="6696183"
Message-ID: <5112138C.7040902@cn.fujitsu.com>
Date: Wed, 06 Feb 2013 16:25:48 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, mgorman@suse.de,
        minchan@kernel.org, kamezawa.hiroyu@jp.fujitsu.com
CC: Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: accurately document nr_free_*_pages functions with code
 comments
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/06 16:26:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/06 16:26:47,
	Serialize complete at 2013/02/06 16:26:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions nr_free_zone_pages, nr_free_buffer_pages and nr_free_pagecache_pages
are horribly badly named, so accurately document them with code comments
in case of the misuse of them.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 mm/page_alloc.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index df2022f..0790716 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2785,6 +2785,15 @@ void free_pages_exact(void *virt, size_t size)
 }
 EXPORT_SYMBOL(free_pages_exact);
 
+/**
+ * nr_free_zone_pages - get pages that is beyond high watermark
+ * @offset - The zone index of the highest zone
+ *
+ * The function counts pages which are beyond high watermark within
+ * all zones at or below a given zone index. For each zone, the
+ * amount of pages is calculated as:
+ *     present_pages - high_pages
+ */
 static unsigned int nr_free_zone_pages(int offset)
 {
 	struct zoneref *z;
@@ -2805,8 +2814,11 @@ static unsigned int nr_free_zone_pages(int offset)
 	return sum;
 }
 
-/*
- * Amount of free RAM allocatable within ZONE_DMA and ZONE_NORMAL
+/**
+ * nr_free_buffer_pages - get pages that is beyond high watermark
+ *
+ * The function counts pages which are beyond high watermark within
+ * ZONE_DMA and ZONE_NORMAL.
  */
 unsigned int nr_free_buffer_pages(void)
 {
@@ -2814,8 +2826,11 @@ unsigned int nr_free_buffer_pages(void)
 }
 EXPORT_SYMBOL_GPL(nr_free_buffer_pages);
 
-/*
- * Amount of free RAM allocatable within all zones
+/**
+ * nr_free_pagecache_pages - get pages that is beyond high watermark
+ *
+ * The function counts pages which are beyond high watermark within
+ * all zones.
  */
 unsigned int nr_free_pagecache_pages(void)
 {
-- 
1.7.1
