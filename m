Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbaBUCxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:53:04 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:23983 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753270AbaBUCuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:50:06 -0500
Message-Id: <20140221025002.536759736@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 20 Feb 2014 21:49:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 10/18] ftrace: Pass in global_ops for use with filtering files
References: <20140221024906.901631810@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0010-ftrace-Pass-in-global_ops-for-use-with-filtering-fil.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

In preparation for having the function tracing instances be able to
filter on functions, the generic filter functions must first be
converted to take in the global_ops as a parameter.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 98ae4ed..2b3e239 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2870,7 +2870,9 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
 static int
 ftrace_filter_open(struct inode *inode, struct file *file)
 {
-	return ftrace_regex_open(&global_ops,
+	struct ftrace_ops *ops = inode->i_private;
+
+	return ftrace_regex_open(ops,
 			FTRACE_ITER_FILTER | FTRACE_ITER_DO_HASH,
 			inode, file);
 }
@@ -2878,7 +2880,9 @@ ftrace_filter_open(struct inode *inode, struct file *file)
 static int
 ftrace_notrace_open(struct inode *inode, struct file *file)
 {
-	return ftrace_regex_open(&global_ops, FTRACE_ITER_NOTRACE,
+	struct ftrace_ops *ops = inode->i_private;
+
+	return ftrace_regex_open(ops, FTRACE_ITER_NOTRACE,
 				 inode, file);
 }
 
@@ -4118,10 +4122,10 @@ static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
 			d_tracer, NULL, &ftrace_enabled_fops);
 
 	trace_create_file("set_ftrace_filter", 0644, d_tracer,
-			NULL, &ftrace_filter_fops);
+			&global_ops, &ftrace_filter_fops);
 
 	trace_create_file("set_ftrace_notrace", 0644, d_tracer,
-				    NULL, &ftrace_notrace_fops);
+				    &global_ops, &ftrace_notrace_fops);
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	trace_create_file("set_graph_function", 0444, d_tracer,
-- 
1.8.5.3


