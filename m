Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422887AbaKNXZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 18:25:09 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:41666 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935435AbaKNXZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 18:25:00 -0500
Message-Id: <20141114232453.649074084@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 14 Nov 2014 18:24:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Byungchul Park <byungchul.park@lge.com>
Subject: [for-next][PATCH 9/9] function_graph: Fix micro seconds notations
References: <20141114232401.493543108@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0009-function_graph-Fix-micro-seconds-notations.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Byungchul Park <byungchul.park@lge.com>

Usually, "msecs" notation means milli-seconds, and "usecs" notation
means micro-seconds. Since the unit used in the code is micro-seconds,
the notation should be replaced from msecs to usecs.

Link: http://lkml.kernel.org/r/1415171926-9782-2-git-send-email-byungchul.park@lge.com

Signed-off-by: Byungchul Park <byungchul.park@lge.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions_graph.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 93ebba09622e..55bdf9d7f714 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -768,19 +768,19 @@ trace_print_graph_duration(unsigned long long duration, struct trace_seq *s)
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
@@ -831,10 +831,10 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s,
 
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
2.1.1


