Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbaELPMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:12:08 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:21054 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756181AbaELPMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:12:05 -0400
Message-Id: <20140512151130.345864843@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 12 May 2014 11:11:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 00/13] tracing: More updates for 3.16
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 1486eb859d525a8be763530c3318293b9b81abc0


Christoph Lameter (1):
      tracing: Replace __get_cpu_var uses with this_cpu_ptr

Frederic Weisbecker (1):
      tracing: Remove myself as a tracing maintainer

Steven Rostedt (1):
      ftrace/x86: Move the mcount/fentry code out of entry_64.S

Steven Rostedt (Red Hat) (10):
      ftrace: Have function graph tracer use global_ops for filtering
      tracing: Add trace_<tracepoint>_enabled() function
      tracing: Add __bitmask() macro to trace events to cpumasks and other bitmasks
      ftrace: Remove boolean of hash_enable and hash_disable
      ftrace: Write in missing comment from a very old commit
      ftrace: Always inline ftrace_hash_empty() helper function
      ftrace/x86: Get the current mcount addr for add_breakpoint()
      ftrace: Make get_ftrace_addr() and get_ftrace_addr_old() global
      ftrace: Use the ftrace_addr helper functions to find the ftrace_addr
      ftrace: Remove FTRACE_UPDATE_MODIFY_CALL_REGS flag

----
 Documentation/trace/tracepoints.txt |  24 ++++
 MAINTAINERS                         |   1 -
 arch/x86/kernel/Makefile            |   1 +
 arch/x86/kernel/entry_64.S          | 204 ---------------------------------
 arch/x86/kernel/ftrace.c            |  43 +------
 arch/x86/kernel/mcount_64.S         | 217 ++++++++++++++++++++++++++++++++++++
 include/linux/ftrace.h              |   4 +-
 include/linux/ftrace_event.h        |   3 +
 include/linux/kprobes.h             |   2 +-
 include/linux/trace_seq.h           |  10 ++
 include/linux/tracepoint.h          |  10 ++
 include/trace/ftrace.h              |  57 +++++++++-
 kernel/trace/ftrace.c               | 100 +++++++++++------
 kernel/trace/trace.c                |   2 +-
 kernel/trace/trace_output.c         |  41 +++++++
 15 files changed, 436 insertions(+), 283 deletions(-)
