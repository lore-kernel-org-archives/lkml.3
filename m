Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaBUCuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:50:08 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:65361 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753183AbaBUCuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:50:03 -0500
Message-Id: <20140221024906.901631810@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 20 Feb 2014 21:49:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 00/18] tracing: Function tracing in instances, uprobe triggers and more
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the next queue for 3.15. This includes Namhyung's updates to
uprobes for event triggering, allowing function tracing to be done
by trace instances, and also some other updates.

This is based on 3.14-rc3.

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 1fcc155351f183e5044180eeb372a8ff47710855


Namhyung Kim (4):
      tracing/uprobes: Rename uprobe_{trace,perf}_print() functions
      tracing/uprobes: Move argument fetching to uprobe_dispatcher()
      tracing/uprobes: Support event triggering
      tracing/uprobes: Support mix of ftrace and perf

Steven Rostedt (1):
      tracing: Add trace_clock=<clock> kernel parameter

Steven Rostedt (Red Hat) (12):
      tracing: Pass trace_array to set_flag callback
      tracing: Pass trace_array to flag_changed callback
      tracing: Set up infrastructure to allow tracers for instances
      tracing: Only let top level have option files
      ftrace: Add private data to ftrace_ops
      ftrace: Copy ops private to global_ops private
      tracing: Disable tracers before deletion of instance
      tracing: Convert tracer->enabled to counter
      ftrace: Allow instances to use function tracing
      ftrace: Pass in global_ops for use with filtering files
      ftrace: Allow for function tracing instance to filter functions
      ftrace: Have static function trace clear ENABLED flag on unregister

zhangwei(Jovi) (1):
      tracing/uprobes: Support ftrace_event_file base multibuffer

----
 include/linux/ftrace.h               |  14 +++
 kernel/trace/blktrace.c              |   3 +-
 kernel/trace/ftrace.c                |  72 +++++++++----
 kernel/trace/trace.c                 | 187 +++++++++++++++++++++++++---------
 kernel/trace/trace.h                 |  38 ++++++-
 kernel/trace/trace_functions.c       | 143 ++++++++++++++++++--------
 kernel/trace/trace_functions_graph.c |   3 +-
 kernel/trace/trace_irqsoff.c         |  10 +-
 kernel/trace/trace_kprobe.c          |  17 ----
 kernel/trace/trace_nop.c             |   5 +-
 kernel/trace/trace_probe.h           |  17 ++++
 kernel/trace/trace_sched_wakeup.c    |  10 +-
 kernel/trace/trace_uprobe.c          | 191 ++++++++++++++++++++++++-----------
 13 files changed, 519 insertions(+), 191 deletions(-)
