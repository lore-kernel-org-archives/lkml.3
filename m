Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab3DLBOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 21:14:25 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47835 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797Ab3DLBOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 21:14:23 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v2 04/25] memory_hotplug: export ensure_zone_is_initialized() in mm/internal.h
Date: Thu, 11 Apr 2013 18:13:36 -0700
Message-Id: <1365729237-29711-5-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041201-7182-0000-0000-000006338DDC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export ensure_zone_is_initialized() so that it can be used to initialize
new zones within the dynamic numa code.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/internal.h       | 8 ++++++++
 mm/memory_hotplug.c | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/internal.h b/mm/internal.h
index 8562de0..b11e574 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -105,6 +105,14 @@ extern void prep_compound_page(struct page *page, unsigned long order);
 extern bool is_free_buddy_page(struct page *page);
 #endif
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+/*
+ * in mm/memory_hotplug.c
+ */
+extern int ensure_zone_is_initialized(struct zone *zone,
+			unsigned long start_pfn, unsigned long num_pages);
+#endif
+
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
 /*
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 8f4d8d3..df04c36 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -284,7 +284,7 @@ static void fix_zone_id(struct zone *zone, unsigned long start_pfn,
 
 /* Can fail with -ENOMEM from allocating a wait table with vmalloc() or
  * alloc_bootmem_node_nopanic() */
-static int __ref ensure_zone_is_initialized(struct zone *zone,
+int __ref ensure_zone_is_initialized(struct zone *zone,
 			unsigned long start_pfn, unsigned long num_pages)
 {
 	if (!zone_is_initialized(zone))
-- 
1.8.2.1

