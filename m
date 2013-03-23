Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423227Ab3CWBaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:30:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:55320 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422847Ab3CWBZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:25:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="306338479"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 22/29] locking, tsx: Add a trace point for elision skipping
Date: Fri, 22 Mar 2013 18:25:16 -0700
Message-Id: <1364001923-10796-23-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

For tuning the adaptive locking algorithms it's useful to trace adaptive
elision skipping. Add a trace point for this case.

Used in followon patches

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/trace/events/elision.h |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/elision.h

diff --git a/include/trace/events/elision.h b/include/trace/events/elision.h
new file mode 100644
index 0000000..5d16d02
--- /dev/null
+++ b/include/trace/events/elision.h
@@ -0,0 +1,31 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM elision
+
+#if !defined(_TRACE_ELISION_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_ELISION_H
+
+#include <linux/lockdep.h>
+#include <linux/tracepoint.h>
+
+#ifdef CONFIG_RTM_LOCKS
+
+TRACE_EVENT(elision_skip_start,
+	    TP_PROTO(void *lock, u32 status),
+	    TP_ARGS(lock, status),
+	    TP_STRUCT__entry(
+		__field(void *, lock)
+		__field(u32, status)
+	    ),
+	    TP_fast_assign(
+		__entry->lock = lock;
+		__entry->status = status;
+	    ),
+	    TP_printk("%p %x", __entry->lock, __entry->status)
+);
+
+#endif
+
+#endif
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.7.6

