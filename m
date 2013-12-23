Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab3LWVlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 16:41:00 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:7447 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758126Ab3LWVjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:39:18 -0500
Message-Id: <20131223213914.664469461@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 23 Dec 2013 16:38:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 06/10] tracing: Move ftrace_event_file() out of DYNAMIC_FTRACE ifdef
References: <20131223213810.967436536@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-Move-ftrace_event_file-out-of-DYNAMIC_FTRACE.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Now that event triggers use ftrace_event_file(), it needs to be outside
the #ifdef CONFIG_DYNAMIC_FTRACE, as it can now be used when that is
not defined.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 9a974bd..e71ffd4 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1855,19 +1855,6 @@ __trace_add_event_dirs(struct trace_array *tr)
 	}
 }
 
-#ifdef CONFIG_DYNAMIC_FTRACE
-
-/* Avoid typos */
-#define ENABLE_EVENT_STR	"enable_event"
-#define DISABLE_EVENT_STR	"disable_event"
-
-struct event_probe_data {
-	struct ftrace_event_file	*file;
-	unsigned long			count;
-	int				ref;
-	bool				enable;
-};
-
 struct ftrace_event_file *
 find_event_file(struct trace_array *tr, const char *system,  const char *event)
 {
@@ -1891,6 +1878,19 @@ find_event_file(struct trace_array *tr, const char *system,  const char *event)
 	return NULL;
 }
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+
+/* Avoid typos */
+#define ENABLE_EVENT_STR	"enable_event"
+#define DISABLE_EVENT_STR	"disable_event"
+
+struct event_probe_data {
+	struct ftrace_event_file	*file;
+	unsigned long			count;
+	int				ref;
+	bool				enable;
+};
+
 static void
 event_enable_probe(unsigned long ip, unsigned long parent_ip, void **_data)
 {
-- 
1.8.4.3


