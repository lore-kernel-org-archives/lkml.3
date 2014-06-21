Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965271AbaFUCcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 22:32:41 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:42044 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155AbaFUCck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 22:32:40 -0400
Message-ID: <53A4EEC5.7090801@gmail.com>
Date: Sat, 21 Jun 2014 10:32:37 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: mingo@redhat.com, rostedt@goodmis.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] include/trace/syscall.h: Use HAVE_SYSCALL_TRACEPOINTS instead
 of TRACEPOINTS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At present, most architectures can support TRACEPOINTS, but about 10/29
architectures support HAVE_SYSCALL_TRACEPOINTS.

TIF_SYSCALL_TRACEPOINT depends on HAVE_SYSCALL_TRACEPOINTS, not all
architectures which support TRACEPOINTS also must support
TIF_SYSCALL_TRACEPOINT.

So at present, need use HAVE_SYSCALL_TRACEPOINTS instead of TRACEPOINTS,
or can not pass compiling. The related error (allmodconfig under score):

    CC      init/main.o
  In file included from include/asm-generic/preempt.h:4:0,
                   from arch/score/include/generated/asm/preempt.h:1,
                   from include/linux/preempt.h:18,
                   from include/linux/spinlock.h:50,
                   from include/linux/seqlock.h:35,
                   from include/linux/time.h:5,
                   from include/linux/stat.h:18,
                   from include/linux/module.h:10,
                   from init/main.c:15:
  include/trace/syscall.h: In function 'syscall_tracepoint_update':
  include/trace/syscall.h:39:23: error: 'TIF_SYSCALL_TRACEPOINT' undeclared (first use in this function)
    if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
                         ^
  include/linux/thread_info.h:103:45: note: in definition of macro 'test_thread_flag'
    test_ti_thread_flag(current_thread_info(), flag)
                                               ^
  include/trace/syscall.h:39:23: note: each undeclared identifier is reported only once for each function it appears in
    if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
                         ^
  include/linux/thread_info.h:103:45: note: in definition of macro 'test_thread_flag'
    test_ti_thread_flag(current_thread_info(), flag)
                                               ^
  make[1]: *** [init/main.o] Error 1
  make: *** [init] Error 2


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 include/trace/syscall.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 291c282..a709cbd 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -33,7 +33,7 @@ struct syscall_metadata {
 	struct ftrace_event_call *exit_event;
 };
 
-#ifdef CONFIG_TRACEPOINTS
+#ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
 static inline void syscall_tracepoint_update(struct task_struct *p)
 {
 	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
-- 
1.9.2.459.g68773ac
