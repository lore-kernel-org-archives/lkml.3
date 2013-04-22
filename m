Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705Ab3DVIX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 04:23:59 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:60980 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab3DVIX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 04:23:57 -0400
X-AuditID: 9c93016f-b7c87ae000002520-64-5174f39ad126
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Yinghai Lu <yinghai@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Jiang Liu <liuj97@gmail.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 1/2] mm, nobootmem: clean-up of free_low_memory_core_early()
Date: Mon, 22 Apr 2013 17:25:12 +0900
Message-Id: <1366619113-28017-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused argument and make function static,
because there is no user outside of nobootmem.c

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index cdc3bab..5f0b0e1 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -44,7 +44,6 @@ extern unsigned long init_bootmem_node(pg_data_t *pgdat,
 				       unsigned long endpfn);
 extern unsigned long init_bootmem(unsigned long addr, unsigned long memend);
 
-extern unsigned long free_low_memory_core_early(int nodeid);
 extern unsigned long free_all_bootmem_node(pg_data_t *pgdat);
 extern unsigned long free_all_bootmem(void);
 
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 5e07d36..a31be7a 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -120,7 +120,7 @@ static unsigned long __init __free_memory_core(phys_addr_t start,
 	return end_pfn - start_pfn;
 }
 
-unsigned long __init free_low_memory_core_early(int nodeid)
+static unsigned long __init free_low_memory_core_early(void)
 {
 	unsigned long count = 0;
 	phys_addr_t start, end, size;
@@ -170,7 +170,7 @@ unsigned long __init free_all_bootmem(void)
 	 *  because in some case like Node0 doesn't have RAM installed
 	 *  low ram will be on Node1
 	 */
-	return free_low_memory_core_early(MAX_NUMNODES);
+	return free_low_memory_core_early();
 }
 
 /**
-- 
1.7.9.5

