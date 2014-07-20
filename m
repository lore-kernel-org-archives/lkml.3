Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaGTPTs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 11:19:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbaGTPTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 11:19:47 -0400
Date: Sun, 20 Jul 2014 17:18:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ftrace: kill global_start_up
Message-ID: <20140720151814.GA32439@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

global_start_up is read-only and always zero. It seems that 4104d326
"ftrace: Remove global function list and call function directly" simply
forgot to remove this no longer used variable.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/ftrace.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5b372e3..4586f8d 100644
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
1.5.5.1


