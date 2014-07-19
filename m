Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbaGSNQN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 09:16:13 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:62021 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753892AbaGSNQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 09:16:10 -0400
Message-Id: <20140719131524.009152325@goodmis.org>
User-Agent: quilt/0.63-1
Date: Sat, 19 Jul 2014 09:15:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 00/32] ftrace/tracing: Fixes and final removal of ftrace_start/stop()
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: ba1afef6a47c4133831fefcad4e0d7bf1d0ee99e


Corey Minyard (1):
      ring-buffer: Always run per-cpu ring buffer resize with schedule_work_on()

Heiko Carstens (1):
      s390/ftrace: remove check of obsolete variable function_trace_stop

Stanislav Fomichev (1):
      tracing: let user specify tracing_thresh after selecting function_graph

Steven Rostedt (Red Hat) (28):
      ftrace: Allow archs to specify if they need a separate function graph trampoline
      ftrace/x86: Have function graph tracer use its own trampoline
      x86, power, suspend: Annotate restore_processor_state() with notrace
      PM / Sleep: Remove ftrace_stop/start() from suspend and hibernate
      ftrace-graph: Remove dependency of ftrace_stop() from ftrace_graph_stop()
      ftrace/x86: Add call to ftrace_graph_is_dead() in function graph code
      microblaze: ftrace: Add call to ftrace_graph_is_dead() in function graph code
      MIPS: ftrace: Add call to ftrace_graph_is_dead() in function graph code
      parisc: ftrace: Add call to ftrace_graph_is_dead() in function graph code
      powerpc/ftrace: Add call to ftrace_graph_is_dead() in function graph code
      sh: ftrace: Add call to ftrace_graph_is_dead() in function graph code
      ftrace-graph: Remove usage of ftrace_stop() in ftrace_graph_stop()
      ftrace: Remove ftrace_start/stop()
      ftrace: Do no disable function tracing on enabling function tracing
      ftrace: Remove function_trace_stop check from list func
      ftrace: Remove check for HAVE_FUNCTION_TRACE_MCOUNT_TEST
      ftrace: x86: Remove check of obsolete variable function_trace_stop
      tile: ftrace: Remove check of obsolete variable function_trace_stop
      sparc64,ftrace: Remove check of obsolete variable function_trace_stop
      sh: ftrace: Remove check of obsolete variable function_trace_stop
      parisc: ftrace: Remove check of obsolete variable function_trace_stop
      MIPS: ftrace: Remove check of obsolete variable function_trace_stop
      microblaze: ftrace: Remove check of obsolete variable function_trace_stop
      metag: ftrace: Remove check of obsolete variable function_trace_stop
      Blackfin: ftrace: Remove check of obsolete variable function_trace_stop
      arm64, ftrace: Remove check of obsolete variable function_trace_stop
      tracing: Remove function_trace_stop and HAVE_FUNCTION_TRACE_MCOUNT_TEST
      tracing: Convert local function_graph functions to static

Wang Nan (1):
      ftrace: Do not copy old hash when resetting

----
 Documentation/trace/ftrace-design.txt | 26 --------------
 arch/arm64/kernel/entry-ftrace.S      |  5 ---
 arch/blackfin/Kconfig                 |  1 -
 arch/blackfin/kernel/ftrace-entry.S   | 18 ----------
 arch/metag/Kconfig                    |  1 -
 arch/metag/kernel/ftrace_stub.S       | 14 --------
 arch/microblaze/Kconfig               |  1 -
 arch/microblaze/kernel/ftrace.c       |  3 ++
 arch/microblaze/kernel/mcount.S       |  5 ---
 arch/mips/Kconfig                     |  1 -
 arch/mips/kernel/ftrace.c             |  3 ++
 arch/mips/kernel/mcount.S             |  7 ----
 arch/parisc/Kconfig                   |  1 -
 arch/parisc/kernel/ftrace.c           |  6 ++--
 arch/powerpc/kernel/ftrace.c          |  3 ++
 arch/s390/Kconfig                     |  1 -
 arch/s390/kernel/mcount.S             | 10 ++----
 arch/s390/kernel/mcount64.S           |  3 --
 arch/sh/Kconfig                       |  1 -
 arch/sh/kernel/ftrace.c               |  3 ++
 arch/sh/lib/mcount.S                  | 24 ++-----------
 arch/sparc/Kconfig                    |  1 -
 arch/sparc/lib/mcount.S               | 10 ++----
 arch/tile/Kconfig                     |  1 -
 arch/tile/kernel/mcount_64.S          | 18 ----------
 arch/x86/Kconfig                      |  1 -
 arch/x86/include/asm/ftrace.h         |  2 ++
 arch/x86/kernel/entry_32.S            |  9 -----
 arch/x86/kernel/ftrace.c              |  3 ++
 arch/x86/kernel/mcount_64.S           | 18 +---------
 arch/x86/power/cpu.c                  |  4 +--
 include/linux/ftrace.h                | 44 +++++++-----------------
 kernel/power/hibernate.c              |  6 ----
 kernel/power/suspend.c                |  2 --
 kernel/trace/Kconfig                  |  5 ---
 kernel/trace/ftrace.c                 | 44 ++++++------------------
 kernel/trace/ring_buffer.c            | 24 +++----------
 kernel/trace/trace.c                  | 65 +++++++++++++++++++++++++++++++----
 kernel/trace/trace.h                  |  2 ++
 kernel/trace/trace_functions_graph.c  | 43 +++++++++++++++++++++--
 40 files changed, 157 insertions(+), 282 deletions(-)
