Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322AbaFYLHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:07:19 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41077 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753055AbaFYLHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:07:16 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, pavel@ucw.cz, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH -repost 02/21] ftrace: Make ftrace_is_dead available globally
Date: Wed, 25 Jun 2014 13:06:56 +0200
Message-Id: <1403694435-3180-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
References: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
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
index c142816c2801..7ba30d4b4909 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -140,6 +140,8 @@ enum ftrace_tracing_type_t {
 /* Current tracing type, default is FTRACE_TYPE_ENTER */
 extern enum ftrace_tracing_type_t ftrace_tracing_type;
 
+extern int ftrace_is_dead(void);
+
 /**
  * ftrace_stop - stop function tracer.
  *
@@ -241,6 +243,7 @@ static inline int ftrace_nr_registered_ops(void)
 	return 0;
 }
 static inline void clear_ftrace_function(void) { }
+static inline int ftrace_is_dead(void) { return 0; }
 static inline void ftrace_kill(void) { }
 static inline void ftrace_stop(void) { }
 static inline void ftrace_start(void) { }
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9258f5a815db..0d96b8990a97 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -824,7 +824,6 @@ static inline int ftrace_trace_task(struct task_struct *task)
 
 	return test_tsk_trace_trace(task);
 }
-extern int ftrace_is_dead(void);
 int ftrace_create_function_files(struct trace_array *tr,
 				 struct dentry *parent);
 void ftrace_destroy_function_files(struct trace_array *tr);
@@ -837,7 +836,6 @@ static inline int ftrace_trace_task(struct task_struct *task)
 {
 	return 1;
 }
-static inline int ftrace_is_dead(void) { return 0; }
 static inline int
 ftrace_create_function_files(struct trace_array *tr,
 			     struct dentry *parent)
-- 
2.0.0

