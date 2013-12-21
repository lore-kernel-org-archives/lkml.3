Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab3LUWot (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 17:44:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:63767 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217Ab3LUWoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 17:44:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,529,1384329600"; 
   d="scan'208";a="456051039"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 1/3] tracing: Move tracing_alloc_snapshot() declaration to tracing.h
Date: Sat, 21 Dec 2013 16:44:00 -0600
Message-Id: <d7a0a7b99848c48e3a4abe50fc94390a1d0ca967.1387662969.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1387662969.git.tom.zanussi@linux.intel.com>
References: <cover.1387662969.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1387662969.git.tom.zanussi@linux.intel.com>
References: <cover.1387662969.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tracing_alloc_snapshot() is only used internally by
alloc_tracing_snapshot() and trace_event_triggers.c and doesn't need
to be in kernel.h.  Move it to trace.h, which is more appropriate and
both include.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 include/linux/kernel.h | 2 --
 kernel/trace/trace.h   | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d58541b..ecb8754 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -498,7 +498,6 @@ void tracing_on(void);
 void tracing_off(void);
 int tracing_is_on(void);
 void tracing_snapshot(void);
-int tracing_alloc_snapshot(void);
 void tracing_snapshot_alloc(void);
 
 extern void tracing_start(void);
@@ -646,7 +645,6 @@ static inline void tracing_on(void) { }
 static inline void tracing_off(void) { }
 static inline int tracing_is_on(void) { return 0; }
 static inline void tracing_snapshot(void) { }
-static inline int tracing_alloc_snapshot(void) { return -ENODEV; }
 static inline void tracing_snapshot_alloc(void) { }
 
 static inline __printf(1, 2)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 993f2fe..433bfc5 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1220,6 +1220,7 @@ struct event_command {
 
 extern int trace_event_enable_disable(struct ftrace_event_file *file,
 				      int enable, int soft_disable);
+extern int tracing_alloc_snapshot(void);
 
 extern const char *__start___trace_bprintk_fmt[];
 extern const char *__stop___trace_bprintk_fmt[];
-- 
1.8.3.1

