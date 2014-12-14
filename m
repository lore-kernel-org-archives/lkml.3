Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaLNQsW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 11:48:22 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:28954 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751023AbaLNQsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 11:48:16 -0500
Message-Id: <20141214164104.307127356@goodmis.org>
User-Agent: quilt/0.61-1
Date: Sun, 14 Dec 2014 11:41:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 0/3] tracing: Enable tracepoints early and allow printk to use them
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the merge window is still open, and this code was not as complex
as I thought it might be. I'm thinking of pushing this in now.

This will allow Thomas to debug his irq work for 3.20.

This code is not that intrusive and I'm currently running it through
all my tests (which caught the call_rcu_sched issue()). But I like to
have some more eyes on this, as I don't like to push something into
mainline this quickly. I'm doing this only because the code is simple
enough and is useful for work coming in 3.20.

I also feel that I could handle the fall out of this work over the
holidays if need be.

Steven Rostedt (Red Hat) (3):
      tracepoints: Do not use call_rcu_sched() before early_initcall()
      tracing: Move enabling tracepoints to just after mm_init()
      tracing: Add tp_printk cmdline to have tracepoints go to printk()

----
 Documentation/kernel-parameters.txt | 18 ++++++++++++++++
 include/linux/ftrace.h              |  7 +++++++
 init/main.c                         |  3 +++
 kernel/sysctl.c                     |  7 +++++++
 kernel/trace/trace.c                | 25 +++++++++++++++++++++-
 kernel/trace/trace.h                | 14 +++++++++++++
 kernel/trace/trace_events.c         | 42 +++++++++++++++++++++++++++++++++++--
 kernel/trace/trace_syscalls.c       |  7 ++-----
 kernel/tracepoint.c                 | 27 +++++++++++++++++++++++-
 9 files changed, 141 insertions(+), 9 deletions(-)
