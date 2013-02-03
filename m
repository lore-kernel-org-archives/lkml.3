Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab3BCTTg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 14:19:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50733 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab3BCTTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 14:19:33 -0500
Date: Sun, 3 Feb 2013 11:19:14 -0800
From: tip-bot for Jovi Zhang <bookjovi@gmail.com>
Message-ID: <tip-38dbe0b137bfe6ea92be495017885c0785179a02@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, bookjovi@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, bookjovi@gmail.com
In-Reply-To: <CACV3sb+G1YnO6168JhY3dEadmJi58pA5-2cSZT8E0WVHJNFt9Q@mail.gmail.com>
References: <CACV3sb+G1YnO6168JhY3dEadmJi58pA5-2cSZT8E0WVHJNFt9Q@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Remove second iterator initializer
Git-Commit-ID: 38dbe0b137bfe6ea92be495017885c0785179a02
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 03 Feb 2013 11:19:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  38dbe0b137bfe6ea92be495017885c0785179a02
Gitweb:     http://git.kernel.org/tip/38dbe0b137bfe6ea92be495017885c0785179a02
Author:     Jovi Zhang <bookjovi@gmail.com>
AuthorDate: Fri, 25 Jan 2013 18:03:07 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 29 Jan 2013 09:57:49 -0500

tracing: Remove second iterator initializer

The trace iterator is already initialized by trace_init_global_iter(),
so there is no need to initialize it again.

Link: http://lkml.kernel.org/r/CACV3sb+G1YnO6168JhY3dEadmJi58pA5-2cSZT8E0WVHJNFt9Q@mail.gmail.com

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 07888e1..d399592 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5030,6 +5030,7 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
 	if (disable_tracing)
 		ftrace_kill();
 
+	/* Simulate the iterator */
 	trace_init_global_iter(&iter);
 
 	for_each_tracing_cpu(cpu) {
@@ -5041,10 +5042,6 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
 	/* don't look at user memory in panic mode */
 	trace_flags &= ~TRACE_ITER_SYM_USEROBJ;
 
-	/* Simulate the iterator */
-	iter.tr = &global_trace;
-	iter.trace = current_trace;
-
 	switch (oops_dump_mode) {
 	case DUMP_ALL:
 		iter.cpu_file = TRACE_PIPE_ALL_CPU;
