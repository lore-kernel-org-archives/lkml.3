Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299Ab3FRT1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 15:27:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391Ab3FRT1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 15:27:32 -0400
Date: Tue, 18 Jun 2013 21:21:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] tracing/perf: perf_trace_buf/perf_xxx hacks.
Message-ID: <20130618192147.GA19443@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On top of "PATCH 0/3] tracing: more list_empty(perf_events) checks"
series I sent yesterday.

Compile tested only, not for inclusion yet.

But I'll appreciate if you can take a look. I'll try to test this
tomorrow somehow and let you know. Right now I am looking at asm code,
looks correct...

I also compiled the kernel with the additional patch below, everything
compiles except sched/core.o as expected.

Oleg.

--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -664,6 +664,8 @@ perf_trace_##call(void *__data, proto)					\
 									\
 	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
 									\
+	BUILD_BUG_ON(!(__builtin_constant_p(!__task) && !__task));	\
+									\
 	head = this_cpu_ptr(event_call->perf_events);			\
 	if (__builtin_constant_p(!__task) && !__task &&			\
 				hlist_empty(head))			\

