Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935414AbaKNXYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 18:24:55 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:5309 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935394AbaKNXYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 18:24:53 -0500
Message-Id: <20141114232401.493543108@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 14 Nov 2014 18:24:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/9] tracing: Some fixes and cleanups for 3.19
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 4526d0676a150dce7a93ad93e03bef7f77e7c906


Byungchul Park (1):
      function_graph: Fix micro seconds notations

Daniel Bristot de Oliveira (1):
      ftrace-graph: show latency-format on print_graph_irq()

Daniel Thompson (2):
      tracing: kdb: Fix kernel panic during ftdump
      tracing: kdb: Fix kernel livelock with empty buffers

Luis Claudio R. Goncalves (1):
      tracing: Fix traceoff_on_warning handling on boot command line

Rasmus Villemoes (3):
      tracing: Replace seq_printf by simpler equivalents
      tracing: Merge consecutive seq_puts calls
      trace: Replace single-character seq_puts with seq_putc

Steven Rostedt (Red Hat) (1):
      ftrace: Have the control_ops get a trampoline

----
 kernel/trace/ftrace.c                | 32 +++++++-------
 kernel/trace/trace.c                 | 83 ++++++++++++++++++------------------
 kernel/trace/trace_branch.c          | 32 +++++++-------
 kernel/trace/trace_events.c          |  4 +-
 kernel/trace/trace_events_trigger.c  |  6 +--
 kernel/trace/trace_functions.c       |  2 +-
 kernel/trace/trace_functions_graph.c | 49 ++++++++++++---------
 kernel/trace/trace_kdb.c             | 21 +++++----
 kernel/trace/trace_kprobe.c          | 12 +++---
 kernel/trace/trace_printk.c          |  2 +-
 kernel/trace/trace_uprobe.c          |  4 +-
 11 files changed, 132 insertions(+), 115 deletions(-)
