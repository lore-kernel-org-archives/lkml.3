Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290Ab3HNS1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:27:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34386 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760269Ab3HNSZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:25:33 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/21] perf/core improvements and fixes
Date: Wed, 14 Aug 2013 15:24:54 -0300
Message-Id: <1376504715-28107-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Hi Ingo,

	Please consider pulling,

	Flushing it out now before processing another batch.

- Arnaldo

The following changes since commit 0a3d23a2568ed5e73bd4fb532dc672fa9f03b1f1:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2013-08-12 10:14:47 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 2ae3a312c0ccd8ff615372f00aab1700aac27474:

  perf trace: Allow specifying which syscalls to trace (2013-08-14 11:44:21 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

. Allow specifying syscalls in 'perf trace', a la strace.

. Simplify symbol filtering by doing it at machine class level,
  from Adrian Hunter.

. Add option to 'perf kvm' to print only events that exceed a specified time
  duration, from David Ahern.

. 'perf sched' improvements, including removing some tracepoints that provide
  the same information as the PERF_RECORD_{FORK,EXIT} events.

. Improve stack trace printing, from David Ahern.

. Update documentation with live command, from David Ahern

. Fix 'perf test' compile failure on do_sort_something, from David Ahern.

. Improve robustness of topology parsing code, from Stephane Eranian.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Adrian Hunter (8):
      perf machine: Add symbol filter to struct machine
      perf top: Set the machines symbol filter
      perf report: Set the machines symbol filter
      perf mem: Remove unused symbol filter member
      perf annotate: Set the machines symbol filter
      perf tools: Remove filter parameter of perf_event__preprocess_sample()
      perf tools: Remove filter parameter of thread__find_addr_location()
      perf tools: Remove filter parameter of thread__find_addr_map()

Arnaldo Carvalho de Melo (1):
      perf trace: Allow specifying which syscalls to trace

David Ahern (11):
      perf kvm: Option to print events that exceed a duration
      perf kvm: Update documentation with live command
      perf sched: Simplify arguments to read_events
      perf sched: Remove thread lookup in sample handler
      perf sched: Remove sched_process_exit tracepoint
      perf sched: Remove sched_process_fork tracepoint
      perf tool: Simplify options to perf_evsel__print_ip
      perf evsel: Add option to print stack trace on single line
      perf evsel: Add option to limit stack depth in callchain dumps
      perf session: Change perf_session__has_traces to actually check for tracepoints
      perf tests: Fix compile failure on do_sort_something

Stephane Eranian (1):
      perf tools: Improve robustness of topology parsing code

 tools/perf/Documentation/perf-kvm.txt   | 46 +++++++++++++++-
 tools/perf/Documentation/perf-trace.txt |  4 ++
 tools/perf/builtin-annotate.c           |  5 +-
 tools/perf/builtin-diff.c               |  2 +-
 tools/perf/builtin-inject.c             |  2 +-
 tools/perf/builtin-kvm.c                | 25 +++++++--
 tools/perf/builtin-mem.c                |  4 +-
 tools/perf/builtin-report.c             |  7 ++-
 tools/perf/builtin-sched.c              | 94 ++++++++++++++-------------------
 tools/perf/builtin-script.c             | 35 +++++++++---
 tools/perf/builtin-top.c                |  5 +-
 tools/perf/builtin-trace.c              | 52 +++++++++++++++---
 tools/perf/perf.h                       |  3 ++
 tools/perf/tests/code-reading.c         | 13 +++--
 tools/perf/tests/hists_link.c           |  4 +-
 tools/perf/util/build-id.c              |  2 +-
 tools/perf/util/event.c                 | 20 +++----
 tools/perf/util/event.h                 |  3 +-
 tools/perf/util/header.c                | 11 ++--
 tools/perf/util/machine.c               | 28 ++++++++--
 tools/perf/util/machine.h               |  5 ++
 tools/perf/util/session.c               | 40 +++++++++-----
 tools/perf/util/session.h               |  8 ++-
 tools/perf/util/thread.h                |  5 +-
 tools/perf/util/unwind.c                |  6 +--
 25 files changed, 294 insertions(+), 135 deletions(-)
