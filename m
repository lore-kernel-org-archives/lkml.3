Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981AbaKSX1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:27:15 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:38185 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754289AbaKSX1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:27:11 -0500
Message-Id: <20141119232632.737569526@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 19 Nov 2014 18:26:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 00/18] tracing: Fixes and trace-seq updates
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 8e2e095cbecad21078332cd83ae7e61ecfe12c59


Steven Rostedt (Red Hat) (18):
      tracing: Fix race of function probes counting
      ftrace/x86: Add frames pointers to trampoline as necessary
      ftrace/x86/extable: Add is_ftrace_trampoline() function
      x86/kvm/tracing: Use helper function trace_seq_buffer_ptr()
      RAS/tracing: Use trace_seq_buffer_ptr() helper instead of open coded
      tracing: Fix trace_seq_bitmask() to start at current position
      tracing: Add trace_seq_has_overflowed() and trace_handle_return()
      blktrace/tracing: Use trace_seq_has_overflowed() helper function
      ring-buffer: Remove check of trace_seq_{puts,printf}() return values
      tracing: Have branch tracer use trace_handle_return() helper function
      tracing: Have function_graph use trace_seq_has_overflowed()
      kprobes/tracing: Use trace_seq_has_overflowed() for overflow checks
      tracing: Do not check return values of trace_seq_p*() for mmio tracer
      tracing/probes: Do not use return value of trace_seq_printf()
      tracing/uprobes: Do not use return values of trace_seq_printf()
      tracing: Do not use return values of trace_seq_printf() in syscall tracing
      tracing: Remove return values of most trace_seq_*() functions
      tracing: Fix return value of ftrace_raw_output_prep()

----
 arch/x86/kernel/ftrace.c             |   9 +-
 arch/x86/kernel/mcount_64.S          |  41 ++++
 arch/x86/kvm/mmutrace.h              |   4 +-
 drivers/firmware/efi/cper.c          |   2 +-
 include/linux/ftrace.h               |   8 +
 include/linux/ftrace_event.h         |  11 +
 include/linux/trace_seq.h            |  49 ++--
 include/trace/ftrace.h               |   8 +-
 kernel/extable.c                     |   7 +-
 kernel/trace/blktrace.c              | 148 ++++++-------
 kernel/trace/ftrace.c                |  38 ++++
 kernel/trace/ring_buffer.c           |  75 +++----
 kernel/trace/trace.c                 |  69 +++---
 kernel/trace/trace.h                 |   3 +-
 kernel/trace/trace_branch.c          |  15 +-
 kernel/trace/trace_functions.c       | 117 ++++++++--
 kernel/trace/trace_functions_graph.c | 382 ++++++++++----------------------
 kernel/trace/trace_kprobe.c          |  42 ++--
 kernel/trace/trace_mmiotrace.c       |  52 ++---
 kernel/trace/trace_output.c          | 417 ++++++++++++++---------------------
 kernel/trace/trace_output.h          |  16 +-
 kernel/trace/trace_probe.c           |  10 +-
 kernel/trace/trace_seq.c             |  86 ++------
 kernel/trace/trace_syscalls.c        |  47 ++--
 kernel/trace/trace_uprobe.c          |  23 +-
 25 files changed, 768 insertions(+), 911 deletions(-)
