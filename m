Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbaFZREM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:04:12 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:26008 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757828AbaFZQ6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:58:53 -0400
Message-Id: <20140626165850.889732172@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 26 Jun 2014 12:52:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>
Subject: [RFA][PATCH 13/27] ftrace: Do no disable function tracing on enabling function tracing
References: <20140626165221.736847419@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0013-ftrace-Do-no-disable-function-tracing-on-enabling-fu.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When function tracing is being updated function_trace_stop is set to
keep from tracing the updates. This was fine when function tracing
was done from stop machine. But it is no longer done that way and
this can cause real tracing to be missed.

Remove it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 823984c20262..1e4e9bbb8dfa 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2260,11 +2260,6 @@ static void ftrace_run_update_code(int command)
 	FTRACE_WARN_ON(ret);
 	if (ret)
 		return;
-	/*
-	 * Do not call function tracer while we update the code.
-	 * We are in stop machine.
-	 */
-	function_trace_stop++;
 
 	/*
 	 * By default we use stop_machine() to modify the code.
@@ -2274,8 +2269,6 @@ static void ftrace_run_update_code(int command)
 	 */
 	arch_ftrace_update_code(command);
 
-	function_trace_stop--;
-
 	ret = ftrace_arch_code_modify_post_process();
 	FTRACE_WARN_ON(ret);
 
-- 
2.0.0


