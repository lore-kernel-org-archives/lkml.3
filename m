Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbaKTAPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 19:15:45 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:60926 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738AbaKTAPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 19:15:41 -0500
X-Original-SENDERIP: 10.177.226.38
X-Original-MAILFROM: byungchul.park@lge.com
From: byungchul.park@lge.com
To: rostedt@goodmis.org
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, seungho1.park@lge.com,
        jolsa@redhat.com, Byungchul Park <byungchul.park@lge.com>
Subject: [PATCH v5 1/2] tracing, function_graph: fix micro seconds notation in comment
Date: Thu, 20 Nov 2014 09:15:34 +0900
Message-Id: <1416442535-31188-2-git-send-email-byungchul.park@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1416442535-31188-1-git-send-email-byungchul.park@lge.com>
References: <1416442535-31188-1-git-send-email-byungchul.park@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Byungchul Park <byungchul.park@lge.com>

Usually, "msecs" notation means milli-seconds, and "usecs" notation
means micro-seconds. Since the unit used in the code is micro-seconds,
the notation should be replaced from msecs to usecs.

Signed-off-by: Byungchul Park <byungchul.park@lge.com>
---
 kernel/trace/trace_functions_graph.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index f0a0c98..cb33f46 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -759,19 +759,19 @@ trace_print_graph_duration(unsigned long long duration, struct trace_seq *s)
 {
 	unsigned long nsecs_rem = do_div(duration, 1000);
 	/* log10(ULONG_MAX) + '\0' */
-	char msecs_str[21];
+	char usecs_str[21];
 	char nsecs_str[5];
 	int ret, len;
 	int i;
 
-	sprintf(msecs_str, "%lu", (unsigned long) duration);
+	sprintf(usecs_str, "%lu", (unsigned long) duration);
 
 	/* Print msecs */
-	ret = trace_seq_printf(s, "%s", msecs_str);
+	ret = trace_seq_printf(s, "%s", usecs_str);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	len = strlen(msecs_str);
+	len = strlen(usecs_str);
 
 	/* Print nsecs (we don't want to exceed 7 numbers) */
 	if (len < 7) {
@@ -822,10 +822,10 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s,
 
 	/* Signal a overhead of time execution to the output */
 	if (flags & TRACE_GRAPH_PRINT_OVERHEAD) {
-		/* Duration exceeded 100 msecs */
+		/* Duration exceeded 100 usecs */
 		if (duration > 100000ULL)
 			ret = trace_seq_puts(s, "! ");
-		/* Duration exceeded 10 msecs */
+		/* Duration exceeded 10 usecs */
 		else if (duration > 10000ULL)
 			ret = trace_seq_puts(s, "+ ");
 	}
-- 
1.7.9.5

