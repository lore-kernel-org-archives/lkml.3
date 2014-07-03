Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbaGCQQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:16:43 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:62039 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759196AbaGCQM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:12:28 -0400
Message-Id: <20140703161226.385648917@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 03 Jul 2014 12:05:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Fabian Frederick <fabf@skynet.be>
Subject: [for-next][PATCH 17/21] tracing: Convert pr_warning() to pr_warn() in trace_events.c
References: <20140703160503.006976702@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0017-tracing-Convert-pr_warning-to-pr_warn-in-trace_event.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

Convert pr_warning to standard pr_warn
Define pr_fmt(fmt) fmt to avoid any future default fmt definition

Link: http://lkml.kernel.org/p/1402141388-21144-1-git-send-email-fabf@skynet.be

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c | 56 ++++++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 29 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index f99e0b3bca8c..e7a814b3906b 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -8,6 +8,8 @@
  *
  */
 
+#define pr_fmt(fmt) fmt
+
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
 #include <linux/kthread.h>
@@ -1490,7 +1492,7 @@ event_subsystem_dir(struct trace_array *tr, const char *name,
 
 	dir->entry = debugfs_create_dir(name, parent);
 	if (!dir->entry) {
-		pr_warning("Failed to create system directory %s\n", name);
+		pr_warn("Failed to create system directory %s\n", name);
 		__put_system(system);
 		goto out_free;
 	}
@@ -1506,7 +1508,7 @@ event_subsystem_dir(struct trace_array *tr, const char *name,
 	if (!entry) {
 		kfree(system->filter);
 		system->filter = NULL;
-		pr_warning("Could not create debugfs '%s/filter' entry\n", name);
+		pr_warn("Could not create debugfs '%s/filter' entry\n", name);
 	}
 
 	trace_create_file("enable", 0644, dir->entry, dir,
@@ -1521,8 +1523,7 @@ event_subsystem_dir(struct trace_array *tr, const char *name,
  out_fail:
 	/* Only print this message if failed on memory allocation */
 	if (!dir || !system)
-		pr_warning("No memory to create event subsystem %s\n",
-			   name);
+		pr_warn("No memory to create event subsystem %s\n", name);
 	return NULL;
 }
 
@@ -1550,8 +1551,7 @@ event_create_dir(struct dentry *parent, struct ftrace_event_file *file)
 	name = ftrace_event_name(call);
 	file->dir = debugfs_create_dir(name, d_events);
 	if (!file->dir) {
-		pr_warning("Could not create debugfs '%s' directory\n",
-			   name);
+		pr_warn("Could not create debugfs '%s' directory\n", name);
 		return -1;
 	}
 
@@ -1574,8 +1574,8 @@ event_create_dir(struct dentry *parent, struct ftrace_event_file *file)
 	if (list_empty(head)) {
 		ret = call->class->define_fields(call);
 		if (ret < 0) {
-			pr_warning("Could not initialize trace point"
-				   " events/%s\n", name);
+			pr_warn("Could not initialize trace point events/%s\n",
+				name);
 			return -1;
 		}
 	}
@@ -1648,8 +1648,7 @@ static int event_init(struct ftrace_event_call *call)
 	if (call->class->raw_init) {
 		ret = call->class->raw_init(call);
 		if (ret < 0 && ret != -ENOSYS)
-			pr_warn("Could not initialize trace events/%s\n",
-				name);
+			pr_warn("Could not initialize trace events/%s\n", name);
 	}
 
 	return ret;
@@ -1894,8 +1893,8 @@ __trace_add_event_dirs(struct trace_array *tr)
 	list_for_each_entry(call, &ftrace_events, list) {
 		ret = __trace_add_new_event(call, tr);
 		if (ret < 0)
-			pr_warning("Could not create directory for event %s\n",
-				   ftrace_event_name(call));
+			pr_warn("Could not create directory for event %s\n",
+				ftrace_event_name(call));
 	}
 }
 
@@ -2207,8 +2206,8 @@ __trace_early_add_event_dirs(struct trace_array *tr)
 	list_for_each_entry(file, &tr->events, list) {
 		ret = event_create_dir(tr->event_dir, file);
 		if (ret < 0)
-			pr_warning("Could not create directory for event %s\n",
-				   ftrace_event_name(file->event_call));
+			pr_warn("Could not create directory for event %s\n",
+				ftrace_event_name(file->event_call));
 	}
 }
 
@@ -2231,8 +2230,8 @@ __trace_early_add_events(struct trace_array *tr)
 
 		ret = __trace_early_add_new_event(call, tr);
 		if (ret < 0)
-			pr_warning("Could not create early event %s\n",
-				   ftrace_event_name(call));
+			pr_warn("Could not create early event %s\n",
+				ftrace_event_name(call));
 	}
 }
 
@@ -2279,13 +2278,13 @@ create_event_toplevel_files(struct dentry *parent, struct trace_array *tr)
 	entry = debugfs_create_file("set_event", 0644, parent,
 				    tr, &ftrace_set_event_fops);
 	if (!entry) {
-		pr_warning("Could not create debugfs 'set_event' entry\n");
+		pr_warn("Could not create debugfs 'set_event' entry\n");
 		return -ENOMEM;
 	}
 
 	d_events = debugfs_create_dir("events", parent);
 	if (!d_events) {
-		pr_warning("Could not create debugfs 'events' directory\n");
+		pr_warn("Could not create debugfs 'events' directory\n");
 		return -ENOMEM;
 	}
 
@@ -2461,11 +2460,10 @@ static __init int event_trace_init(void)
 	entry = debugfs_create_file("available_events", 0444, d_tracer,
 				    tr, &ftrace_avail_fops);
 	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'available_events' entry\n");
+		pr_warn("Could not create debugfs 'available_events' entry\n");
 
 	if (trace_define_common_fields())
-		pr_warning("tracing: Failed to allocate common fields");
+		pr_warn("tracing: Failed to allocate common fields");
 
 	ret = early_event_add_tracer(d_tracer, tr);
 	if (ret)
@@ -2474,7 +2472,7 @@ static __init int event_trace_init(void)
 #ifdef CONFIG_MODULES
 	ret = register_module_notifier(&trace_module_nb);
 	if (ret)
-		pr_warning("Failed to register trace events module notifier\n");
+		pr_warn("Failed to register trace events module notifier\n");
 #endif
 	return 0;
 }
@@ -2578,7 +2576,7 @@ static __init void event_trace_self_tests(void)
 		 * it and the self test should not be on.
 		 */
 		if (file->flags & FTRACE_EVENT_FL_ENABLED) {
-			pr_warning("Enabled event during self test!\n");
+			pr_warn("Enabled event during self test!\n");
 			WARN_ON_ONCE(1);
 			continue;
 		}
@@ -2606,8 +2604,8 @@ static __init void event_trace_self_tests(void)
 
 		ret = __ftrace_set_clr_event(tr, NULL, system->name, NULL, 1);
 		if (WARN_ON_ONCE(ret)) {
-			pr_warning("error enabling system %s\n",
-				   system->name);
+			pr_warn("error enabling system %s\n",
+				system->name);
 			continue;
 		}
 
@@ -2615,8 +2613,8 @@ static __init void event_trace_self_tests(void)
 
 		ret = __ftrace_set_clr_event(tr, NULL, system->name, NULL, 0);
 		if (WARN_ON_ONCE(ret)) {
-			pr_warning("error disabling system %s\n",
-				   system->name);
+			pr_warn("error disabling system %s\n",
+				system->name);
 			continue;
 		}
 
@@ -2630,7 +2628,7 @@ static __init void event_trace_self_tests(void)
 
 	ret = __ftrace_set_clr_event(tr, NULL, NULL, NULL, 1);
 	if (WARN_ON_ONCE(ret)) {
-		pr_warning("error enabling all events\n");
+		pr_warn("error enabling all events\n");
 		return;
 	}
 
@@ -2639,7 +2637,7 @@ static __init void event_trace_self_tests(void)
 	/* reset sysname */
 	ret = __ftrace_set_clr_event(tr, NULL, NULL, NULL, 0);
 	if (WARN_ON_ONCE(ret)) {
-		pr_warning("error disabling all events\n");
+		pr_warn("error disabling all events\n");
 		return;
 	}
 
-- 
2.0.0


