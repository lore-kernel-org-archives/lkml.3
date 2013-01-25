Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab3AYKUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:20:43 -0500
Received: from mail-vb0-f54.google.com ([209.85.212.54]:51771 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825Ab3AYKUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:20:42 -0500
MIME-Version: 1.0
Date: Fri, 25 Jan 2013 18:20:40 +0800
Message-ID: <CACV3sb+G1YnO6168JhY3dEadmJi58pA5-2cSZT8E0WVHJNFt9Q@mail.gmail.com>
Subject: [PATCH] tracing: fix twice trace iterator init
From: Jovi Zhang <bookjovi@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ac499cd340bf2ba47b3d1dd129a3bb7527c195ae Mon Sep 17 00:00:00 2001
From: Jovi Zhang <bookjovi@gmail.com>
Date: Fri, 25 Jan 2013 18:03:07 +0800
Subject: [PATCH] tracing: fix twice trace iterator init

trace iterator is already inited in trace_init_global_iter,
so there don't need to assign again.

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
---
 kernel/trace/trace.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e512567..8d99728 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5005,6 +5005,7 @@ __ftrace_dump(bool disable_tracing, enum
ftrace_dump_mode oops_dump_mode)
 	if (disable_tracing)
 		ftrace_kill();

+	/* Simulate the iterator */
 	trace_init_global_iter(&iter);

 	for_each_tracing_cpu(cpu) {
@@ -5016,10 +5017,6 @@ __ftrace_dump(bool disable_tracing, enum
ftrace_dump_mode oops_dump_mode)
 	/* don't look at user memory in panic mode */
 	trace_flags &= ~TRACE_ITER_SYM_USEROBJ;

-	/* Simulate the iterator */
-	iter.tr = &global_trace;
-	iter.trace = current_trace;
-
 	switch (oops_dump_mode) {
 	case DUMP_ALL:
 		iter.cpu_file = TRACE_PIPE_ALL_CPU;
-- 
1.7.9.7
