Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab3BCTS7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 14:18:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50722 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab3BCTSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 14:18:55 -0500
Date: Sun, 3 Feb 2013 11:18:05 -0800
From: tip-bot for Shan Wei <davidshan@tencent.com>
Message-ID: <tip-821465295b36136998ef294fe176fba4e09c1cd9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        davidshan@tencent.com, rostedt@goodmis.org, cl@linux.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        davidshan@tencent.com, rostedt@goodmis.org, tglx@linutronix.de,
        cl@linux.com
In-Reply-To: <50A9C1BD.1060308@gmail.com>
References: <50A9C1BD.1060308@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Use __this_cpu_inc/
 dec operation instead of __get_cpu_var
Git-Commit-ID: 821465295b36136998ef294fe176fba4e09c1cd9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 03 Feb 2013 11:18:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  821465295b36136998ef294fe176fba4e09c1cd9
Gitweb:     http://git.kernel.org/tip/821465295b36136998ef294fe176fba4e09c1cd9
Author:     Shan Wei <davidshan@tencent.com>
AuthorDate: Mon, 19 Nov 2012 13:21:01 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 25 Jan 2013 20:36:54 -0500

tracing: Use __this_cpu_inc/dec operation instead of __get_cpu_var

__this_cpu_inc_return() or __this_cpu_dec generates a single instruction,
which is faster than __get_cpu_var operation.

Link: http://lkml.kernel.org/r/50A9C1BD.1060308@gmail.com

Reviewed-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Shan Wei <davidshan@tencent.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ca9b7df..07888e1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1344,7 +1344,7 @@ static void __ftrace_trace_stack(struct ring_buffer *buffer,
 	 */
 	preempt_disable_notrace();
 
-	use_stack = ++__get_cpu_var(ftrace_stack_reserve);
+	use_stack = __this_cpu_inc_return(ftrace_stack_reserve);
 	/*
 	 * We don't need any atomic variables, just a barrier.
 	 * If an interrupt comes in, we don't care, because it would
@@ -1398,7 +1398,7 @@ static void __ftrace_trace_stack(struct ring_buffer *buffer,
  out:
 	/* Again, don't let gcc optimize things here */
 	barrier();
-	__get_cpu_var(ftrace_stack_reserve)--;
+	__this_cpu_dec(ftrace_stack_reserve);
 	preempt_enable_notrace();
 
 }
