Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266AbaD3Oay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:30:54 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52334 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758933AbaD3Oav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:30:51 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Michael Matz <matz@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [RFC 02/16] ftrace: Make ftrace_is_dead available globally
Date: Wed, 30 Apr 2014 16:30:35 +0200
Message-Id: <1398868249-26169-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kgr wants to test whether ftrace is OK with patching. If not, we just
bail out and will not initialize at all.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 include/linux/ftrace.h | 3 +++
 kernel/trace/trace.h   | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 8b447493b6a5..720b7be77615 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -144,6 +144,8 @@ enum ftrace_tracing_type_t {
 /* Current tracing type, default is FTRACE_TYPE_ENTER */
 extern enum ftrace_tracing_type_t ftrace_tracing_type;
 
+extern int ftrace_is_dead(void);
+
 /**
  * ftrace_stop - stop function tracer.
  *
@@ -245,6 +247,7 @@ static inline int ftrace_nr_registered_ops(void)
 	return 0;
 }
 static inline void clear_ftrace_function(void) { }
+static inline int ftrace_is_dead(void) { return 0; }
 static inline void ftrace_kill(void) { }
 static inline void ftrace_stop(void) { }
 static inline void ftrace_start(void) { }
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 2e29d7ba5a52..e3d867571ffc 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -819,7 +819,6 @@ static inline int ftrace_trace_task(struct task_struct *task)
 
 	return test_tsk_trace_trace(task);
 }
-extern int ftrace_is_dead(void);
 int ftrace_create_function_files(struct trace_array *tr,
 				 struct dentry *parent);
 void ftrace_destroy_function_files(struct trace_array *tr);
@@ -828,7 +827,6 @@ static inline int ftrace_trace_task(struct task_struct *task)
 {
 	return 1;
 }
-static inline int ftrace_is_dead(void) { return 0; }
 static inline int
 ftrace_create_function_files(struct trace_array *tr,
 			     struct dentry *parent)
-- 
1.9.2

