Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935738Ab3FTDgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 23:36:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32169 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935546Ab3FTDgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 23:36:39 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=DNHN-bC5VMQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=LAX8XD9Y1q8A:10 a=q-zO9UgPWf2GTEgsOIMA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130620033516.003166252@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Jun 2013 23:35:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 00/12] tracing: Updates and minor fixes for 3.11.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches are queued for 3.11.


Harsh Prateek Bora (1):
      tracing/trivial: Consolidate error return condition

Juri Lelli (1):
      ftrace: Fix stddev calculation in function profiler

Li Zefan (1):
      ftrace: Remove ftrace_regex_lseek()

Namhyung Kim (1):
      tracing: Do not call kmem_cache_free() on allocation failure

Steven Rostedt (2):
      ftrace: Use schedule_on_each_cpu() as a heavy synchronize_sched()
      tracing: Add binary '&' filter for events

Steven Rostedt (Red Hat) (4):
      tracing: Add function probe to trigger a ftrace dump to console
      tracing: Add function probe to trigger a ftrace dump of current CPU trace
      tracing: Update documentation on tracepoint glob matching
      tracing: Disable tracing on warning

Wang YanQing (1):
      tracing: Fix file mode of free_buffer

zhangwei(Jovi) (1):
      tracing/kprobes: Remove unnecessary checking of trace_probe_is_enabled

----
 Documentation/kernel-parameters.txt |   13 +++++
 Documentation/trace/events.txt      |   15 ++++-
 Documentation/trace/ftrace.txt      |   13 +++++
 include/linux/ftrace.h              |    9 +--
 kernel/panic.c                      |    3 +
 kernel/sysctl.c                     |    7 +++
 kernel/trace/ftrace.c               |   33 +++++++++--
 kernel/trace/trace.c                |   19 ++++++-
 kernel/trace/trace_events.c         |   12 +---
 kernel/trace/trace_events_filter.c  |    6 ++
 kernel/trace/trace_functions.c      |  103 +++++++++++++++++++++++++++++++++--
 kernel/trace/trace_kprobe.c         |    3 +-
 12 files changed, 207 insertions(+), 29 deletions(-)
