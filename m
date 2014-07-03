Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbaGCQQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:16:57 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:3745 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759191AbaGCQM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:12:28 -0400
Message-Id: <20140703161225.961638982@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 03 Jul 2014 12:05:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 14/21] ftrace: Get rid of obsolete global_start_up variable
References: <20140703160503.006976702@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0014-ftrace-Get-rid-of-obsolete-global_start_up-variable.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

It seems like it's a leftover from commit 4104d326b670 ("ftrace:
Remove global function list and call function directly").  As it
isn't updated at all, checking its value is meaningless.

Let's get rid of it.

Link: http://lkml.kernel.org/p/1402584972-17824-1-git-send-email-namhyung@kernel.org

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8323082dbc21..39df3192e725 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2286,7 +2286,6 @@ static void ftrace_run_update_code(int command)
 
 static ftrace_func_t saved_ftrace_func;
 static int ftrace_start_up;
-static int global_start_up;
 
 static void control_ops_free(struct ftrace_ops *ops)
 {
@@ -2350,8 +2349,7 @@ static int ftrace_shutdown(struct ftrace_ops *ops, int command)
 
 	ftrace_hash_rec_disable(ops, 1);
 
-	if (!global_start_up)
-		ops->flags &= ~FTRACE_OPS_FL_ENABLED;
+	ops->flags &= ~FTRACE_OPS_FL_ENABLED;
 
 	command |= FTRACE_UPDATE_CALLS;
 
-- 
2.0.0


