Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760633Ab3GSOO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:14:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28808 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab3GSOOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:14:50 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=OtYG3TwmGo8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Jt5mE-_EwH0A:10 a=VwQbUJbxAAAA:8 a=bVhYIKo0QyJuZe5aPtoA:9 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130719141224.703522101@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 19 Jul 2013 10:12:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next-3.11][PATCH 00/12] tracing: Cleanups and fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are mostly cleanups and some minor fixes. Still working on
fixing a theoretical race with trace events.

-- Steve

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: cd458ba9d5a5592d37b5145e560071e91ea762ac


Alexander Z Lam (2):
      tracing: Fix error handling to ensure instances can always be removed
      tracing: Miscellaneous fixes for trace_array ref counting

Masami Hiramatsu (1):
      tracing/kprobe: Wait for disabling all running kprobe handlers

Oleg Nesterov (5):
      tracing/function: Avoid perf_trace_buf_*() if event_function.perf_events is empty
      tracing/syscall: Avoid perf_trace_buf_*() if sys_data->perf_events is empty
      tracing/perf: Move the PERF_MAX_TRACE_SIZE check into perf_trace_buf_prepare()
      tracing: Simplify the iteration logic in f_start/f_next
      tracing: Do not (ab)use trace_seq in event_id_read()

Steven Rostedt (Red Hat) (1):
      tracing: Add ref_data to function and fgraph tracer structs

zhangwei(Jovi) (3):
      tracing: Use correct config guard CONFIG_STACK_TRACER
      tracing: Use trace_seq_puts()/trace_seq_putc() where possible
      tracing: Typo fix on ring buffer comments

----
 include/trace/ftrace.h               |    4 --
 kernel/trace/ring_buffer.c           |   26 ++++-----
 kernel/trace/trace.c                 |   32 +++++++----
 kernel/trace/trace.h                 |    9 ++++
 kernel/trace/trace_event_perf.c      |   10 +++-
 kernel/trace/trace_events.c          |   98 ++++++++++++++++------------------
 kernel/trace/trace_events_filter.c   |    4 +-
 kernel/trace/trace_functions.c       |    2 +-
 kernel/trace/trace_functions_graph.c |   54 +++++++++----------
 kernel/trace/trace_kprobe.c          |   29 +++++-----
 kernel/trace/trace_mmiotrace.c       |    8 +--
 kernel/trace/trace_output.c          |   14 ++---
 kernel/trace/trace_syscalls.c        |   26 ++++-----
 kernel/trace/trace_uprobe.c          |    2 -
 14 files changed, 166 insertions(+), 152 deletions(-)
