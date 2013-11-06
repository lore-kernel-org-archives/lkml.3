Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab3KFOw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:52:59 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:34091 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932134Ab3KFOw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:52:57 -0500
Message-Id: <20131106145041.904349372@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Nov 2013 09:50:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [for-next][PATCH 0/8] tracing: Updates for 3.12
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This includes a merge with Paul McKenney's tree to include the
rcu_is_watching() change that is required to fix a ftrace/perf bug.

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: d562aff93bfb530b0992141500a402d17081189d


Cody P Schafer (1):
      trace/trace_stat: use rbtree postorder iteration helper instead of opencoding

Jamie Iles (1):
      recordmcount.pl: Add support for __fentry__

Kevin Hao (1):
      ftrace/x86: skip over the breakpoint for ftrace caller

Paul E. McKenney (6):
      rcu: Remove redundant code from rcu_cleanup_after_idle()
      rcu: Throttle rcu_try_advance_all_cbs() execution
      rcu: Throttle invoke_rcu_core() invocations due to non-lazy callbacks
      rcu: Is it safe to enter an RCU read-side critical section?
      rcu: Change EXPORT_SYMBOL() to EXPORT_SYMBOL_GPL()
      rcu: Consistent rcu_is_watching() naming

Steven Rostedt (1):
      rcu: Do not trace rcu_is_watching() functions

Steven Rostedt (Red Hat) (2):
      Merge branch 'idle.2013.09.25a' of git://git.kernel.org/.../paulmck/linux-rcu into HEAD
      ftrace: Have control op function callback only trace when RCU is watching

Tom Zanussi (3):
      tracing: Update event filters for multibuffer
      tracing: Make register/unregister_ftrace_command __init
      tracing: Add support for SOFT_DISABLE to syscall events

----
 arch/x86/kernel/ftrace.c             |  14 ++-
 include/linux/ftrace.h               |   4 +-
 include/linux/ftrace_event.h         |  25 +++-
 include/linux/rcupdate.h             |  24 ++--
 include/linux/rcutiny.h              |  17 +++
 include/linux/rcutree.h              |   2 +
 include/linux/syscalls.h             |   4 +-
 include/trace/ftrace.h               |   7 +-
 kernel/lockdep.c                     |   4 +-
 kernel/rcupdate.c                    |   2 +-
 kernel/rcutiny.c                     |  10 +-
 kernel/rcutree.c                     |  23 +++-
 kernel/rcutree.h                     |   2 +
 kernel/rcutree_plugin.h              |  24 ++--
 kernel/trace/ftrace.c                |  21 +++-
 kernel/trace/trace.c                 |  44 +++++--
 kernel/trace/trace.h                 |  22 +---
 kernel/trace/trace_branch.c          |   2 +-
 kernel/trace/trace_events.c          |  23 ++--
 kernel/trace/trace_events_filter.c   | 218 ++++++++++++++++++++++++++++-------
 kernel/trace/trace_export.c          |   2 +-
 kernel/trace/trace_functions_graph.c |   4 +-
 kernel/trace/trace_kprobe.c          |   4 +-
 kernel/trace/trace_mmiotrace.c       |   4 +-
 kernel/trace/trace_sched_switch.c    |   4 +-
 kernel/trace/trace_stat.c            |  41 +------
 kernel/trace/trace_syscalls.c        |  42 +++++--
 kernel/trace/trace_uprobe.c          |   3 +-
 scripts/recordmcount.pl              |   4 +-
 29 files changed, 409 insertions(+), 191 deletions(-)
