Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaFGLnU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 07:43:20 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:7313 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538AbaFGLnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 07:43:18 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmIOABX6klNXQ3Uj/2dsb2JhbABZgw2sGggBAQUBmRCBBBd1hDEvI4EaN4hGAbQemQYXhV2JD4RIBI9aikeLKIgdgz47
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Steven Rostedt <rostedt@goodmis.org>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/trace/trace_events.c: logging clean-up
Date: Sat,  7 Jun 2014 13:43:08 +0200
Message-Id: <1402141388-21144-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Convert pr_warning to standard pr_warn
-Define pr_fmt(fmt) fmt to avoid any future default fmt definition

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/trace/trace_events.c | 56 ++++++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 29 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 3ddfd8f..94ea008 100644
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
@@ -1487,7 +1489,7 @@ event_subsystem_dir(struct trace_array *tr, const char *name,
 
 	dir->entry = debugfs_create_dir(name, parent);
 	if (!dir->entry) {
-		pr_warning("Failed to create system directory %s\n", name);
+		pr_warn("Failed to create system directory %s\n", name);
 		__put_system(system);
 		goto out_free;
 	}
@@ -1503,7 +1505,7 @@ event_subsystem_dir(struct trace_array *tr, const char *name,
 	if (!entry) {
 		kfree(system->filter);
 		system->filter = NULL;
-		pr_warning("Could not create debugfs '%s/filter' entry\n", name);
+		pr_warn("Could not create debugfs '%s/filter' entry\n", name);
 	}
 
 	trace_create_file("enable", 0644, dir->entry, dir,
@@ -1518,8 +1520,7 @@ event_subsystem_dir(struct trace_array *tr, const char *name,
  out_fail:
 	/* Only print this message if failed on memory allocation */
 	if (!dir || !system)
-		pr_warning("No memory to create event subsystem %s\n",
-			   name);
+		pr_warn("No memory to create event subsystem %s\n", name);
 	return NULL;
 }
 
@@ -1547,8 +1548,7 @@ event_create_dir(struct dentry *parent, struct ftrace_event_file *file)
 	name = ftrace_event_name(call);
 	file->dir = debugfs_create_dir(name, d_events);
 	if (!file->dir) {
-		pr_warning("Could not create debugfs '%s' directory\n",
-			   name);
+		pr_warn("Could not create debugfs '%s' directory\n", name);
 		return -1;
 	}
 
@@ -1571,8 +1571,8 @@ event_create_dir(struct dentry *parent, struct ftrace_event_file *file)
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
@@ -1645,8 +1645,7 @@ static int event_init(struct ftrace_event_call *call)
 	if (call->class->raw_init) {
 		ret = call->class->raw_init(call);
 		if (ret < 0 && ret != -ENOSYS)
-			pr_warn("Could not initialize trace events/%s\n",
-				name);
+			pr_warn("Could not initialize trace events/%s\n", name);
 	}
 
 	return ret;
@@ -1891,8 +1890,8 @@ __trace_add_event_dirs(struct trace_array *tr)
 	list_for_each_entry(call, &ftrace_events, list) {
 		ret = __trace_add_new_event(call, tr);
 		if (ret < 0)
-			pr_warning("Could not create directory for event %s\n",
-				   ftrace_event_name(call));
+			pr_warn("Could not create directory for event %s\n",
+				ftrace_event_name(call));
 	}
 }
 
@@ -2201,8 +2200,8 @@ __trace_early_add_event_dirs(struct trace_array *tr)
 	list_for_each_entry(file, &tr->events, list) {
 		ret = event_create_dir(tr->event_dir, file);
 		if (ret < 0)
-			pr_warning("Could not create directory for event %s\n",
-				   ftrace_event_name(file->event_call));
+			pr_warn("Could not create directory for event %s\n",
+				ftrace_event_name(file->event_call));
 	}
 }
 
@@ -2225,8 +2224,8 @@ __trace_early_add_events(struct trace_array *tr)
 
 		ret = __trace_early_add_new_event(call, tr);
 		if (ret < 0)
-			pr_warning("Could not create early event %s\n",
-				   ftrace_event_name(call));
+			pr_warn("Could not create early event %s\n",
+				ftrace_event_name(call));
 	}
 }
 
@@ -2273,13 +2272,13 @@ create_event_toplevel_files(struct dentry *parent, struct trace_array *tr)
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
 
@@ -2450,11 +2449,10 @@ static __init int event_trace_init(void)
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
@@ -2463,7 +2461,7 @@ static __init int event_trace_init(void)
 #ifdef CONFIG_MODULES
 	ret = register_module_notifier(&trace_module_nb);
 	if (ret)
-		pr_warning("Failed to register trace events module notifier\n");
+		pr_warn("Failed to register trace events module notifier\n");
 #endif
 	return 0;
 }
@@ -2565,7 +2563,7 @@ static __init void event_trace_self_tests(void)
 		 * it and the self test should not be on.
 		 */
 		if (file->flags & FTRACE_EVENT_FL_ENABLED) {
-			pr_warning("Enabled event during self test!\n");
+			pr_warn("Enabled event during self test!\n");
 			WARN_ON_ONCE(1);
 			continue;
 		}
@@ -2593,8 +2591,8 @@ static __init void event_trace_self_tests(void)
 
 		ret = __ftrace_set_clr_event(tr, NULL, system->name, NULL, 1);
 		if (WARN_ON_ONCE(ret)) {
-			pr_warning("error enabling system %s\n",
-				   system->name);
+			pr_warn("error enabling system %s\n",
+				system->name);
 			continue;
 		}
 
@@ -2602,8 +2600,8 @@ static __init void event_trace_self_tests(void)
 
 		ret = __ftrace_set_clr_event(tr, NULL, system->name, NULL, 0);
 		if (WARN_ON_ONCE(ret)) {
-			pr_warning("error disabling system %s\n",
-				   system->name);
+			pr_warn("error disabling system %s\n",
+				system->name);
 			continue;
 		}
 
@@ -2617,7 +2615,7 @@ static __init void event_trace_self_tests(void)
 
 	ret = __ftrace_set_clr_event(tr, NULL, NULL, NULL, 1);
 	if (WARN_ON_ONCE(ret)) {
-		pr_warning("error enabling all events\n");
+		pr_warn("error enabling all events\n");
 		return;
 	}
 
@@ -2626,7 +2624,7 @@ static __init void event_trace_self_tests(void)
 	/* reset sysname */
 	ret = __ftrace_set_clr_event(tr, NULL, NULL, NULL, 0);
 	if (WARN_ON_ONCE(ret)) {
-		pr_warning("error disabling all events\n");
+		pr_warn("error disabling all events\n");
 		return;
 	}
 
-- 
1.9.1

