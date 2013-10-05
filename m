Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab3JERbp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 13:31:45 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:46492 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab3JERbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 13:31:44 -0400
Message-ID: <52504CF8.6000708@gmail.com>
Date: Sun, 06 Oct 2013 01:31:36 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] mm/page_alloc.c: Implement an empty get_pfn_range_for_nid
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

Implement an empty get_pfn_range_for_nid for !CONFIG_HAVE_MEMBLOCK_NODE_MAP,
so that we could remove the #ifdef in free_area_init_node.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 mm/page_alloc.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index dd886fa..1fb13b6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4566,6 +4566,11 @@ static unsigned long __meminit zone_absent_pages_in_node(int nid,
 }
 
 #else /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
+void __meminit get_pfn_range_for_nid(unsigned int nid,
+			unsigned long *ignored, unsigned long *ignored)
+{
+}
+
 static inline unsigned long __meminit zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
 					unsigned long node_start_pfn,
@@ -4871,9 +4876,7 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
 	pgdat->node_id = nid;
 	pgdat->node_start_pfn = node_start_pfn;
 	init_zone_allows_reclaim(nid);
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
-#endif
 	calculate_node_totalpages(pgdat, start_pfn, end_pfn,
 				  zones_size, zholes_size);
 
-- 
1.7.1
