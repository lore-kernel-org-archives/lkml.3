Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422913AbaKNXZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 18:25:10 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:59789 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935431AbaKNXY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 18:24:59 -0500
Message-Id: <20141114232453.064800582@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 14 Nov 2014 18:24:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [for-next][PATCH 7/9] trace: Replace single-character seq_puts with seq_putc
References: <20141114232401.493543108@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0007-trace-Replace-single-character-seq_puts-with-seq_put.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Printing a single character to a seqfile might as well be done with
seq_putc instead of seq_puts; this avoids a strlen() call and a memory
access. It also shaves another few bytes off the generated code.

Link: http://lkml.kernel.org/r/1415479332-25944-4-git-send-email-linux@rasmusvillemoes.dk

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_trigger.c  | 4 ++--
 kernel/trace/trace_functions_graph.c | 4 ++--
 kernel/trace/trace_kprobe.c          | 8 ++++----
 kernel/trace/trace_printk.c          | 2 +-
 kernel/trace/trace_uprobe.c          | 2 +-
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index 3d89ffc66740..8712df9decb4 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -383,7 +383,7 @@ event_trigger_print(const char *name, struct seq_file *m,
 	if (filter_str)
 		seq_printf(m, " if %s\n", filter_str);
 	else
-		seq_puts(m, "\n");
+		seq_putc(m, '\n');
 
 	return 0;
 }
@@ -1105,7 +1105,7 @@ event_enable_trigger_print(struct seq_file *m, struct event_trigger_ops *ops,
 	if (data->filter_str)
 		seq_printf(m, " if %s\n", data->filter_str);
 	else
-		seq_puts(m, "\n");
+		seq_putc(m, '\n');
 
 	return 0;
 }
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 29ba611e6f57..a82d1d3bd76d 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -1407,7 +1407,7 @@ static void __print_graph_headers_flags(struct seq_file *s, u32 flags)
 		print_lat_header(s, flags);
 
 	/* 1st line */
-	seq_puts(s, "#");
+	seq_putc(s, '#');
 	if (flags & TRACE_GRAPH_PRINT_ABS_TIME)
 		seq_puts(s, "     TIME       ");
 	if (flags & TRACE_GRAPH_PRINT_CPU)
@@ -1421,7 +1421,7 @@ static void __print_graph_headers_flags(struct seq_file *s, u32 flags)
 	seq_puts(s, "               FUNCTION CALLS\n");
 
 	/* 2nd line */
-	seq_puts(s, "#");
+	seq_putc(s, '#');
 	if (flags & TRACE_GRAPH_PRINT_ABS_TIME)
 		seq_puts(s, "      |         ");
 	if (flags & TRACE_GRAPH_PRINT_CPU)
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 240d27ddf82e..ef7e7f16ed1a 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1030,7 +1030,7 @@ print_kprobe_event(struct trace_iterator *iter, int flags,
 	if (!seq_print_ip_sym(s, field->ip, flags | TRACE_ITER_SYM_OFFSET))
 		goto partial;
 
-	if (!trace_seq_puts(s, ")"))
+	if (!trace_seq_putc(s, ')'))
 		goto partial;
 
 	data = (u8 *)&field[1];
@@ -1039,7 +1039,7 @@ print_kprobe_event(struct trace_iterator *iter, int flags,
 					     data + tp->args[i].offset, field))
 			goto partial;
 
-	if (!trace_seq_puts(s, "\n"))
+	if (!trace_seq_putc(s, '\n'))
 		goto partial;
 
 	return TRACE_TYPE_HANDLED;
@@ -1072,7 +1072,7 @@ print_kretprobe_event(struct trace_iterator *iter, int flags,
 	if (!seq_print_ip_sym(s, field->func, flags & ~TRACE_ITER_SYM_OFFSET))
 		goto partial;
 
-	if (!trace_seq_puts(s, ")"))
+	if (!trace_seq_putc(s, ')'))
 		goto partial;
 
 	data = (u8 *)&field[1];
@@ -1081,7 +1081,7 @@ print_kretprobe_event(struct trace_iterator *iter, int flags,
 					     data + tp->args[i].offset, field))
 			goto partial;
 
-	if (!trace_seq_puts(s, "\n"))
+	if (!trace_seq_putc(s, '\n'))
 		goto partial;
 
 	return TRACE_TYPE_HANDLED;
diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index 2900817ba65c..c4e70b6bd7fa 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -305,7 +305,7 @@ static int t_show(struct seq_file *m, void *v)
 			seq_puts(m, "\\t");
 			break;
 		case '\\':
-			seq_puts(m, "\\");
+			seq_putc(m, '\\');
 			break;
 		case '"':
 			seq_puts(m, "\\\"");
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index d22117beedd0..e35327c787f7 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -872,7 +872,7 @@ print_uprobe_event(struct trace_iterator *iter, int flags, struct trace_event *e
 			goto partial;
 	}
 
-	if (trace_seq_puts(s, "\n"))
+	if (trace_seq_putc(s, '\n'))
 		return TRACE_TYPE_HANDLED;
 
 partial:
-- 
2.1.1


