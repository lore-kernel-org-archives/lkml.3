Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab3AUVZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:25:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10763 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab3AUVR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:17:29 -0500
X-Authority-Analysis: v=2.0 cv=W/m6pGqk c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Ct_QjbzOAfgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=wZsor_wAm5oA:10 a=VwQbUJbxAAAA:8 a=EWowKxTDecqCg0zHWx0A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130121211403.337052956@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 21 Jan 2013 16:14:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 00/13 -next] [For linux-next] tracing: Review of changes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm posting these as a generic review of the changes I'll be pushing
into linux-next and will be pushing this for 3.9.

These patches have passed a series of tests I've run on few machines
with several different configs and such.

You can find the patches here. I'll add these to linux-next tomorrow.

-- Steve

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core

Head SHA1: a701a1b03bf36d4e31c9fd036a96bde5a11cd5ce


Fengguang Wu (1):
      tracing/syscalls: Make local functions static

Hiraku Toyooka (1):
      tracing: Add checks if tr->buffer is NULL in tracing_reset{_online_cpus}

Jovi Zhang (1):
      tracing: Verify target file before registering a uprobe event

Masami Hiramatsu (3):
      ftrace: Move ARCH_SUPPORTS_FTRACE_SAVE_REGS in Kconfig
      kprobes/x86: Move ftrace-based kprobe code into kprobes-ftrace.c
      kprobes/x86: Move kprobes stuff under arch/x86/kernel/kprobes/

Shan Wei (1):
      tracing: Use this_cpu_ptr per-cpu helper

Steven Rostedt (6):
      tracing: Fix sparse warning with is_signed_type() macro
      ring-buffer: Remove unnecessary recusive call in rb_advance_iter()
      tracing: Remove unneeded check of max_tr->buffer before tracing_reset
      tracing/lockdep: Disable lockdep first in entering NMI
      tracing/fgraph: Add max_graph_depth to limit function_graph depth
      tracing: Remove the extra 4 bytes of padding in events

----
 arch/Kconfig                         |   12 +
 arch/x86/Kconfig                     |    2 +
 arch/x86/include/asm/ftrace.h        |    1 -
 arch/x86/kernel/Makefile             |    3 +-
 arch/x86/kernel/kprobes-common.h     |  102 ---
 arch/x86/kernel/kprobes-opt.c        |  512 ---------------
 arch/x86/kernel/kprobes.c            | 1130 ----------------------------------
 arch/x86/kernel/kprobes/Makefile     |    7 +
 arch/x86/kernel/kprobes/common.h     |  113 ++++
 arch/x86/kernel/kprobes/core.c       | 1064 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/kprobes/ftrace.c     |   93 +++
 arch/x86/kernel/kprobes/opt.c        |  512 +++++++++++++++
 include/linux/ftrace.h               |    6 +-
 include/linux/ftrace_event.h         |    3 +-
 include/linux/hardirq.h              |    4 +-
 include/linux/kprobes.h              |   12 +-
 kernel/kprobes.c                     |    8 +-
 kernel/trace/Kconfig                 |    8 +
 kernel/trace/blktrace.c              |    2 +-
 kernel/trace/ftrace.c                |    6 +-
 kernel/trace/ring_buffer.c           |    2 +-
 kernel/trace/trace.c                 |   15 +-
 kernel/trace/trace_events.c          |    1 -
 kernel/trace/trace_functions_graph.c |   60 +-
 kernel/trace/trace_selftest.c        |    2 +-
 kernel/trace/trace_syscalls.c        |   18 +-
 kernel/trace/trace_uprobe.c          |    6 +-
 27 files changed, 1909 insertions(+), 1795 deletions(-)
