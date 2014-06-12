Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbaFLO4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 10:56:20 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:58070 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbaFLO4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 10:56:18 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: Get rid of obsolete global_start_up variable
Date: Thu, 12 Jun 2014 23:56:12 +0900
Message-Id: <1402584972-17824-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems like it's a leftover from commit 4104d326b670 ("ftrace:
Remove global function list and call function directly").  As it
isn't updated at all, checking its value is meaningless.

Let's get rid of it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/ftrace.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index cc07b7fc4372..071908f58e7a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2053,7 +2053,6 @@ static void ftrace_run_update_code(int command)
 
 static ftrace_func_t saved_ftrace_func;
 static int ftrace_start_up;
-static int global_start_up;
 
 static void control_ops_free(struct ftrace_ops *ops)
 {
@@ -2117,8 +2116,7 @@ static int ftrace_shutdown(struct ftrace_ops *ops, int command)
 
 	ftrace_hash_rec_disable(ops, 1);
 
-	if (!global_start_up)
-		ops->flags &= ~FTRACE_OPS_FL_ENABLED;
+	ops->flags &= ~FTRACE_OPS_FL_ENABLED;
 
 	command |= FTRACE_UPDATE_CALLS;
 
-- 
1.7.9.2

