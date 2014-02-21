Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaBUCuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:50:12 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:65361 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753193AbaBUCuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:50:04 -0500
Message-Id: <20140221025001.482236735@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 20 Feb 2014 21:49:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 04/18] tracing: Only let top level have option files
References: <20140221024906.901631810@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0004-tracing-Only-let-top-level-have-option-files.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Currently, only the top level instance can have tracing options.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 944cd02..da9543c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3968,9 +3968,11 @@ static int tracing_set_tracer(struct trace_array *tr, const char *buf)
 		free_snapshot(tr);
 	}
 #endif
-	destroy_trace_option_files(topts);
-
-	topts = create_trace_option_files(tr, t);
+	/* Currently, only the top instance has options */
+	if (tr->flags & TRACE_ARRAY_FL_GLOBAL) {
+		destroy_trace_option_files(topts);
+		topts = create_trace_option_files(tr, t);
+	}
 
 #ifdef CONFIG_TRACER_MAX_TRACE
 	if (t->use_max_tr && !had_max_tr) {
-- 
1.8.5.3


