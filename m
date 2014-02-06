Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbaBFSLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 13:11:13 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:36360 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751885AbaBFSLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 13:11:11 -0500
Message-Id: <20140206173910.029355947@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 06 Feb 2014 12:39:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Li Zefan <lizefan@huawei.com>
Subject: [RFC][PATCH 0/4] tracing/perf: Use helper functions to help shrink kernel size
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I posted this a while ago (August 2012), and it seemed to have positive
feedback. But I forgot about it and it never went any further.

http://lkml.kernel.org/r/20120810034302.758092203@goodmis.org

It works to move the tracepoint code out of the macros and into reusable
functions that can save a whopping 73K from the kernel memory (with just the
modules I used compiled in).

There was some changes in mainline since I last posted this that helped
lower the tracepoint footprint, and that makes the first patch not as much
of an approvement that it was in the past.

Anyway, hopefully this can get into 3.15.

-- Steve


Steven Rostedt (4):
      tracing: Move raw output code from macro to standalone function
      tracing: Move event storage for array from macro to standalone function
      tracing: Use helper functions in event assignment to shrink macro size
      perf/events: Use helper functions in event assignment to shrink macro size

----
 include/linux/ftrace_event.h    | 46 +++++++++++++++++++++--
 include/trace/ftrace.h          | 75 ++++++++++++-------------------------
 kernel/trace/trace_event_perf.c | 51 +++++++++++++++++++++++++
 kernel/trace/trace_events.c     |  6 ---
 kernel/trace/trace_export.c     | 12 ++----
 kernel/trace/trace_output.c     | 83 +++++++++++++++++++++++++++++++++++++++++
 6 files changed, 203 insertions(+), 70 deletions(-)
