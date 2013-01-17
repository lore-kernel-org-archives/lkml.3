Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab3AQWyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 17:54:40 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:47005 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab3AQWyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 17:54:37 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>, David Hansen <dave@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cody P Schafer <jmesmon@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 5/9] mmzone: add pgdat_{end_pfn,is_empty}() helpers & consolidate.
Date: Thu, 17 Jan 2013 14:52:57 -0800
Message-Id: <1358463181-17956-6-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1358463181-17956-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1358463181-17956-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011722-3620-0000-0000-000000ED08A3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <jmesmon@gmail.com>

Add pgdat_end_pfn() and pgdat_is_empty() helpers which match the similar
zone_*() functions.

Change node_end_pfn() to be a wrapper of pgdat_end_pfn().

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/mmzone.h | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 696cb7c..d7abff0 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -772,11 +772,17 @@ typedef struct pglist_data {
 #define nid_page_nr(nid, pagenr) 	pgdat_page_nr(NODE_DATA(nid),(pagenr))
 
 #define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
+#define node_end_pfn(nid) pgdat_end_pfn(NODE_DATA(nid))
 
-#define node_end_pfn(nid) ({\
-	pg_data_t *__pgdat = NODE_DATA(nid);\
-	__pgdat->node_start_pfn + __pgdat->node_spanned_pages;\
-})
+static inline unsigned long pgdat_end_pfn(pg_data_t *pgdat)
+{
+	return pgdat->node_start_pfn + pgdat->node_spanned_pages;
+}
+
+static inline bool pgdat_is_empty(pg_data_t *pgdat)
+{
+	return !pgdat->node_start_pfn && !pgdat->node_spanned_pages;
+}
 
 #include <linux/memory_hotplug.h>
 
-- 
1.8.0.3

