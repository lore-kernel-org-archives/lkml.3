Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbbAOP3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 10:29:11 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:10986 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751658AbbAOP3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 10:29:08 -0500
Message-Id: <20150115152906.914820125@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 15 Jan 2015 10:28:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Wang Nan <wangnan0@huawei.com>
Subject: [PATCH 4/5] tracing: Remove extra call to init_ftrace_syscalls()
References: <20150115152801.855110791@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0004-tracing-Remove-extra-call-to-init_ftrace_syscalls.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

trace_init() calls init_ftrace_syscalls() and then calls trace_event_init()
which also calls init_ftrace_syscalls(). It makes more sense to only
call it from trace_event_init().

Calling it twice wastes memory, as it allocates the syscall events twice,
and loses the first copy of it.

Link: http://lkml.kernel.org/r/54AF53BD.5070303@huawei.com
Link: http://lkml.kernel.org/r/20150115040505.930398632@goodmis.org

Reported-by: Wang Nan <wangnan0@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2e767972e99c..4a9079b9f082 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6918,7 +6918,6 @@ void __init trace_init(void)
 			tracepoint_printk = 0;
 	}
 	tracer_alloc_buffers();
-	init_ftrace_syscalls();
 	trace_event_init();	
 }
 
-- 
2.1.4


