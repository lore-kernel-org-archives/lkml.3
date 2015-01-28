Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760980AbbA2CFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:05:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:22774 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508AbbA2CE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:04:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="446378061"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 1/4] mm: move enum tlb_flush_reason into <trace/events/tlb.h>
Date: Wed, 28 Jan 2015 15:17:41 +0200
Message-Id: <1422451064-109023-2-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422451064-109023-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1422451064-109023-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only user of tlb_flush_reason is trace_tlb_flush*(). There's no
reason to define it in mm_types.h

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/mm_types.h   |  8 --------
 include/trace/events/tlb.h | 15 ++++++++++++---
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 199a03aab8dc..5dfdd5ed5254 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -527,14 +527,6 @@ struct vm_special_mapping
 	struct page **pages;
 };
 
-enum tlb_flush_reason {
-	TLB_FLUSH_ON_TASK_SWITCH,
-	TLB_REMOTE_SHOOTDOWN,
-	TLB_LOCAL_SHOOTDOWN,
-	TLB_LOCAL_MM_SHOOTDOWN,
-	NR_TLB_FLUSH_REASONS,
-};
-
  /*
   * A swap entry has to fit into a "unsigned long", as the entry is hidden
   * in the "index" field of the swapper address space.
diff --git a/include/trace/events/tlb.h b/include/trace/events/tlb.h
index 13391d288107..1f764ff60cf6 100644
--- a/include/trace/events/tlb.h
+++ b/include/trace/events/tlb.h
@@ -4,9 +4,18 @@
 #if !defined(_TRACE_TLB_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_TLB_H
 
-#include <linux/mm_types.h>
 #include <linux/tracepoint.h>
 
+#ifndef TRACE_HEADER_MULTI_READ
+enum tlb_flush_reason {
+	TLB_FLUSH_ON_TASK_SWITCH,
+	TLB_REMOTE_SHOOTDOWN,
+	TLB_LOCAL_SHOOTDOWN,
+	TLB_LOCAL_MM_SHOOTDOWN,
+	NR_TLB_FLUSH_REASONS,
+};
+#endif
+
 #define TLB_FLUSH_REASON	\
 	{ TLB_FLUSH_ON_TASK_SWITCH,	"flush on task switch" },	\
 	{ TLB_REMOTE_SHOOTDOWN,		"remote shootdown" },		\
@@ -15,11 +24,11 @@
 
 TRACE_EVENT(tlb_flush,
 
-	TP_PROTO(int reason, unsigned long pages),
+	TP_PROTO(enum tlb_flush_reason reason, unsigned long pages),
 	TP_ARGS(reason, pages),
 
 	TP_STRUCT__entry(
-		__field(	  int, reason)
+		__field(enum tlb_flush_reason, reason)
 		__field(unsigned long,  pages)
 	),
 
-- 
2.1.4

