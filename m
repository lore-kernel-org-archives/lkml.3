Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbaKEHS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 02:18:57 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:54823 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaKEHSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 02:18:53 -0500
X-Original-SENDERIP: 10.177.226.38
X-Original-MAILFROM: byungchul.park@lge.com
From: byungchul.park@lge.com
To: rostedt@goodmis.org, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, seungho1.park@lge.com, jolsa@redhat.com,
        Byungchul Park <byungchul.park@lge.com>
Subject: [PATCH v2 1/3] tracing, function_graph: fix micro seconds notation in comment
Date: Wed,  5 Nov 2014 16:18:44 +0900
Message-Id: <1415171926-9782-2-git-send-email-byungchul.park@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415171926-9782-1-git-send-email-byungchul.park@lge.com>
References: <1415171926-9782-1-git-send-email-byungchul.park@lge.com>
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

