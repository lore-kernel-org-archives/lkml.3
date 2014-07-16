Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760921AbaGPD1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 23:27:11 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:33438 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759843AbaGPD0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 23:26:39 -0400
Message-Id: <20140716032455.761976900@goodmis.org>
User-Agent: quilt/0.63-1
Date: Tue, 15 Jul 2014 23:24:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/4] [GIT PULL] tracing: A few more fixes
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

A few more fixes for ftrace infrastructure.

I was cleaning out my INBOX and found two fixes from zhangwei from
a year ago that were lost in my mail. These fix an inconsistency between
trace_puts() and the way trace_printk() works. The reason this is
important to fix is because when trace_printk() doesn't have any
arguments, it turns into a trace_puts(). Not being able to enable a
stack trace against trace_printk() because it does not have any arguments
is quite confusing. Also, the fix is rather trivial and low risk.

While porting some changes to PowerPC I discovered that it still has
the function graph tracer filter bug that if you also enable stack tracing
the function graph tracer filter is ignored. I fixed that up.

Finally, Martin Lau, fixed a bug that would cause readers of the
ftrace ring buffer to block forever even though it was suppose to be
NONBLOCK.

This is based on top of the last pull request that I sent you earlier
today.

Please pull the latest trace-fixes-v3.16-rc5-v2 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.16-rc5-v2

Tag SHA1: 4932f1a76294c2e60930de9c3179e54fd95e3771
Head SHA1: 97b8ee845393701edc06e27ccec2876ff9596019


Martin Lau (1):
      ring-buffer: Fix polling on trace_pipe

Steven Rostedt (Red Hat) (1):
      tracing: Fix graph tracer with stack tracer on other archs

zhangwei(Jovi) (2):
      tracing: Add ftrace_trace_stack into __trace_puts/__trace_bputs
      tracing: Add TRACE_ITER_PRINTK flag check in __trace_puts/__trace_bputs

----
 kernel/trace/ftrace.c      |  4 ++--
 kernel/trace/ring_buffer.c |  4 ----
 kernel/trace/trace.c       | 18 ++++++++++++++++--
 3 files changed, 18 insertions(+), 8 deletions(-)
