Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab3CSFPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 01:15:49 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46401 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228Ab3CSFPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 01:15:48 -0400
X-AuditID: 9c93016f-b7bfaae000003db8-53-5147f4823138
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Yinghai Lu <yinghai@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Jiang Liu <liuj97@gmail.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 1/3] mm, nobootmem: fix wrong usage of max_low_pfn
Date: Tue, 19 Mar 2013 14:15:59 +0900
Message-Id: <1363670161-9214-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

max_low_pfn reflect the number of _pages_ in the system,
not the maximum PFN. You can easily find that fact in init_bootmem().
So fix it.

Additionally, if 'start_pfn == end_pfn', we don't need to go futher,
so change range check.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 5e07d36..4711e91 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -110,9 +110,9 @@ static unsigned long __init __free_memory_core(phys_addr_t start,
 {
 	unsigned long start_pfn = PFN_UP(start);
 	unsigned long end_pfn = min_t(unsigned long,
-				      PFN_DOWN(end), max_low_pfn);
+				      PFN_DOWN(end), min_low_pfn);
 
-	if (start_pfn > end_pfn)
+	if (start_pfn >= end_pfn)
 		return 0;
 
 	__free_pages_memory(start_pfn, end_pfn);
-- 
1.7.9.5

