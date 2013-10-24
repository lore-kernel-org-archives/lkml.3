Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab3JXNeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 09:34:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:31910 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381Ab3JXNeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 09:34:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,562,1378882800"; 
   d="scan'208";a="422069796"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 0/3] tracing: add support for multibuffer event filters
Date: Thu, 24 Oct 2013 08:34:16 -0500
Message-Id: <cover.1382620672.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The three patches in this patchset are essentially the same patches
that have already been reviewed as part of the trace-event-triggers
patchset, but are separated out because they're actually completely
independent of that patchset and could presumably go into tracing-next
at this point.

In the original patchset, these patches came later in the series;
moving them up I had to fix up a few conflicts and assumptions from
their position in the previous patchset.  The only real difference is
that for patch 1 I added TRACE_EVENT_FL_USE_CALL_FILTER to the flags,
which patch 3 removes since it adds trace_event_files for syscalls.

Basically when ftrace multibuffer support was added, the event filters
were neglected and this patchset fixes that.  Also when soft-disable
was added, it didn't cover syscalls - this adds that and in the
process by virtue of using ftrace_event_files, also enables
multibuffer event filter support for syscalls as a nice side effect.

The following changes since commit 29ad23b00474c34e3b5040dda508c78d33a1a3eb:

  ftrace: Add set_graph_notrace filter (2013-10-18 22:23:16 -0400)

are available in the git repository at:

  git://git.yoctoproject.org/linux-yocto-contrib.git tzanussi/tracing-multibuffer-filters
  http://git.yoctoproject.org/cgit/cgit.cgi/linux-yocto-contrib/log/?h=tzanussi/tracing-multibuffer-filters

Tom Zanussi (3):
  tracing: Update event filters for multibuffer
  tracing: Make register/unregister_ftrace_command __init
  tracing: Add support for SOFT_DISABLE to syscall events

 include/linux/ftrace.h               |   4 +-
 include/linux/ftrace_event.h         |  25 +++-
 include/linux/syscalls.h             |   4 +-
 include/trace/ftrace.h               |   7 +-
 kernel/trace/ftrace.c                |  12 +-
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
 kernel/trace/trace_syscalls.c        |  42 +++++--
 kernel/trace/trace_uprobe.c          |   3 +-
 17 files changed, 308 insertions(+), 116 deletions(-)

-- 
1.8.3.1

