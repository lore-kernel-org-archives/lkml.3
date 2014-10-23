Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbaJWIS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 04:18:56 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:56527 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbaJWIRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:17:48 -0400
X-Original-SENDERIP: 10.177.226.38
X-Original-MAILFROM: byungchul.park@lge.com
From: byungchul.park@lge.com
To: rostedt@goodmis.org, mingo@redhat.com
Cc: jolsa@redhat.com, vanilla@blackduck.lge.com, linux-kernel@vger.kernel.org,
        Byungchul Park <byungchul.park@lge.com>
Subject: [PATCH 1/2] tracing, function_graph: fix micro seconds notation in comment
Date: Thu, 23 Oct 2014 17:17:21 +0900
Message-Id: <1414052242-9828-2-git-send-email-byungchul.park@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414052242-9828-1-git-send-email-byungchul.park@lge.com>
References: <1414052242-9828-1-git-send-email-byungchul.park@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Byungchul Park <byungchul.park@lge.com>

Usually, "msecs" notation means milli-seconds, and "usecs" notation
means micro-seconds. Since the unit used in the code is
micro-seconds, the notation should be replaced from msecs to usecs.
This confusing notation prevents us from understanding the code
correctly.

Signed-off-by: Byungchul Park <byungchul.park@lge.com>
---
 kernel/trace/trace_functions_graph.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index f0a0c98..c18a1e3 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
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

