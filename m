Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbaCJUpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:45:22 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:39456 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753913AbaCJUmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:42:16 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: rostedt@goodmis.org
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v2 6/6] ftrace: Fix compilation warning about control_ops_free
Date: Mon, 10 Mar 2014 21:42:11 +0100
Message-Id: <1394484131-5107-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140306153151.4f7ca9ca@gandalf.local.home>
References: <20140306153151.4f7ca9ca@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_DYNAMIC_FTRACE=n, I see a warning:
kernel/trace/ftrace.c:240:13: warning: 'control_ops_free' defined but not used
 static void control_ops_free(struct ftrace_ops *ops)
             ^
Move that function around to an already existing #ifdef
CONFIG_DYNAMIC_FTRACE block as the function is used solely from the
dynamic function tracing functions.

[v2]
* move the function to an existing block

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/ftrace.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5bd70e8b09b0..60346fb76664 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -237,11 +237,6 @@ static int control_ops_alloc(struct ftrace_ops *ops)
 	return 0;
 }
 
-static void control_ops_free(struct ftrace_ops *ops)
-{
-	free_percpu(ops->disabled);
-}
-
 static void update_global_ops(void)
 {
 	ftrace_func_t func = ftrace_global_list_func;
@@ -2093,6 +2088,11 @@ static ftrace_func_t saved_ftrace_func;
 static int ftrace_start_up;
 static int global_start_up;
 
+static void control_ops_free(struct ftrace_ops *ops)
+{
+	free_percpu(ops->disabled);
+}
+
 static void ftrace_startup_enable(int command)
 {
 	if (saved_ftrace_func != ftrace_trace_function) {
-- 
1.9.0

