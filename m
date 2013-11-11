Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab3KKFEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 00:04:22 -0500
Received: from mga03.intel.com ([143.182.124.21]:61779 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab3KKFEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 00:04:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,675,1378882800"; 
   d="scan'208";a="425364391"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 2/2] tracing: Remove redundant destroy_call_preds() call
Date: Sun, 10 Nov 2013 23:03:46 -0600
Message-Id: <a8ce7c51137ff8770f3e6a0e19e019a5c99f131b.1384145701.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1384145701.git.tom.zanussi@linux.intel.com>
References: <cover.1384145701.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1384145701.git.tom.zanussi@linux.intel.com>
References: <cover.1384145701.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before calling destroy_call_preds(), __trace_remove_event_call() calls
event_remove(), which ends up calling destroy_call_preds() (via
destroy_preds()) if USE_CALL_FILTER is set.  That means the second
call is redundant and can be removed.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Reported-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index f919a2e..a14f6a1 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1708,7 +1708,6 @@ static void __trace_remove_event_call(struct ftrace_event_call *call)
 {
 	event_remove(call);
 	trace_destroy_fields(call);
-	destroy_call_preds(call);
 }
 
 static int probe_remove_event_call(struct ftrace_event_call *call)
-- 
1.8.3.1

