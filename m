Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab3LWVjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 16:39:19 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:44231 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758119Ab3LWVjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:39:16 -0500
Message-Id: <20131223213810.967436536@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 23 Dec 2013 16:38:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 00/10] tracing: Addition of trace event trigeers
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is Tom Zanussi's addition of trace event triggers.

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 05741e383228a79eeec83644181255d2171f9f7c


Steven Rostedt (Red Hat) (3):
      tracing: Move ftrace_event_file() out of DYNAMIC_FTRACE ifdef
      tracing: Add generic tracing_lseek() function
      tracing: Fix rcu handling of event_trigger_data filter field

Tom Zanussi (7):
      tracing: Add basic event trigger framework
      tracing: Add 'traceon' and 'traceoff' event trigger commands
      tracing: Add 'snapshot' event trigger command
      tracing: Add 'stacktrace' event trigger command
      tracing: Add 'enable_event' and 'disable_event' event trigger commands
      tracing: Add and use generic set_trigger_filter() implementation
      tracing: Add documentation for trace event triggers

----
 Documentation/trace/events.txt      |  207 +++++
 include/linux/ftrace.h              |    2 -
 include/linux/ftrace_event.h        |   22 +
 include/trace/ftrace.h              |   44 +-
 kernel/trace/Makefile               |    1 +
 kernel/trace/ftrace.c               |   25 +-
 kernel/trace/trace.c                |   47 +-
 kernel/trace/trace.h                |  193 +++++
 kernel/trace/trace_events.c         |   49 +-
 kernel/trace/trace_events_filter.c  |   12 +
 kernel/trace/trace_events_trigger.c | 1411 +++++++++++++++++++++++++++++++++++
 kernel/trace/trace_stack.c          |    2 +-
 kernel/trace/trace_syscalls.c       |   42 +-
 13 files changed, 1994 insertions(+), 63 deletions(-)
