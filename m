Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaCGPMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:12:06 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:56520 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751648AbaCGPMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:12:03 -0500
Message-Id: <20140307150920.881849073@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 07 Mar 2014 10:09:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 00/20] tracing: linux-next updates
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is mostly clean ups. There's code to shrink the foot print of
tracepoints quite a bit. Fixes for hard to hit error paths. Fixes
to TRACE_EVENT dynamic array handling for newer events coming.
Handling of trace module taint failure.


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 7f11f5ecf4ae09815dc2de267c5e04d1de01d862


Filipe Brandenburger (2):
      tracing: Correctly expand len expressions from __dynamic_array macro
      tracing: Evaluate len expression only once in __dynamic_array macro

Jiri Slaby (5):
      ftrace: Cleanup of global variables ftrace_new_pgs and ftrace_update_cnt
      ftrace: Inline the code from ftrace_dyn_table_alloc()
      ftrace: Pass retval through return in ftrace_dyn_arch_init()
      ftrace: Do not pass data to ftrace_dyn_arch_init
      ftrace: Remove freelist from struct dyn_ftrace

Petr Mladek (3):
      ftrace/x86: One more missing sync after fixup of function modification failure
      ftrace: Warn on error when modifying ftrace function
      ftrace/x86: BUG when ftrace recovery fails

Steven Rostedt (4):
      tracing: Move raw output code from macro to standalone function
      tracing: Move event storage for array from macro to standalone function
      tracing: Use helper functions in event assignment to shrink macro size
      tracing: Warn if a tracepoint is not set via debugfs

Steven Rostedt (Red Hat) (6):
      ftrace/x86: Run a sync after fixup on failure
      tracepoint: Do not waste memory on mods with no tracepoints
      ftrace/x86: Have ftrace_write() return -EPERM and clean up callers
      tracing: Fix event header writeback.h to include tracepoint.h
      tracing: Fix event header migrate.h to include tracepoint.h
      tracing/module: Replace include of tracepoint.h with jump_label.h in module.h

----
 Documentation/trace/ftrace-design.txt |  5 +--
 arch/arm/kernel/ftrace.c              |  4 +-
 arch/blackfin/kernel/ftrace.c         |  5 +--
 arch/ia64/kernel/ftrace.c             |  4 +-
 arch/metag/kernel/ftrace.c            |  5 +--
 arch/microblaze/kernel/ftrace.c       |  5 +--
 arch/mips/kernel/ftrace.c             |  5 +--
 arch/powerpc/kernel/ftrace.c          |  7 +---
 arch/s390/kernel/ftrace.c             |  3 +-
 arch/sh/kernel/ftrace.c               |  5 +--
 arch/sparc/kernel/ftrace.c            |  6 +--
 arch/tile/kernel/ftrace.c             |  4 +-
 arch/x86/kernel/ftrace.c              | 55 ++++++++++++------------
 include/linux/ftrace.h                |  9 ++--
 include/linux/ftrace_event.h          | 28 +++++++++++--
 include/linux/module.h                |  2 +-
 include/trace/events/migrate.h        |  2 +
 include/trace/events/writeback.h      |  1 +
 include/trace/ftrace.h                | 50 +++++++---------------
 kernel/trace/ftrace.c                 | 78 +++++++++++++----------------------
 kernel/trace/trace_events.c           | 36 +++++++++++++---
 kernel/trace/trace_export.c           | 12 ++----
 kernel/trace/trace_output.c           | 52 +++++++++++++++++++++++
 kernel/tracepoint.c                   | 17 +++++++-
 24 files changed, 216 insertions(+), 184 deletions(-)
