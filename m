Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbaCTDAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 23:00:16 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:32013 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754654AbaCTDAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 23:00:12 -0400
Message-Id: <20140320030009.809627569@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 19 Mar 2014 22:58:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jiri Slaby <jslaby@suse.cz>, Ingo Molnar <mingo@redhat.com>
Subject: [for-next][PATCH 1/4] ftrace: Fix compilation warning about control_ops_free
References: <20140320025831.285817697@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0000-ftrace-Fix-compilation-warning-about-control_ops_fre.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

With CONFIG_DYNAMIC_FTRACE=n, I see a warning:
kernel/trace/ftrace.c:240:13: warning: 'control_ops_free' defined but not used
 static void control_ops_free(struct ftrace_ops *ops)
             ^
Move that function around to an already existing #ifdef
CONFIG_DYNAMIC_FTRACE block as the function is used solely from the
dynamic function tracing functions.

Link: http://lkml.kernel.org/r/1394484131-5107-1-git-send-email-jslaby@suse.cz

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0e48ff4..b4531b2 100644
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
@@ -2100,6 +2095,11 @@ static ftrace_func_t saved_ftrace_func;
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
1.8.5.3


