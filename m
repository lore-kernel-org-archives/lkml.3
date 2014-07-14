Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbaGNKEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:04:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:29926 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091AbaGNKEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:04:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,657,1400050800"; 
   d="scan'208";a="561434069"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 00/41] perf tools: Preparation for call graph from Intel BTS
Date: Mon, 14 Jul 2014 13:02:24 +0300
Message-Id: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

As we discussed here:

	http://marc.info/?l=linux-kernel&m=140509286032125&w=4

here are a selection of patches based on tip/perf/core.

They can also be found here:

	http://git.infradead.org/users/ahunter/linux-perf.git/shortlog/refs/heads/for-acme


Adrian Hunter (41):
      perf tools: Fix the value used for unknown pids
      perf tools: Fix map groups of threads with unknown pids
      perf script: Display PERF_RECORD_MISC_COMM_EXEC flag
      perf record: Select comm_exec flag if supported
      perf tools: Identify which comms are from exec
      perf tools: Add machine__thread_exec_comm()
      perf tools: Fix missing kernel map load
      perf tools: Fix missing label symbols
      perf tools: Fix missing GNU IFUNC symbols
      perf inject: Fix build id injection
      perf tools: Fix appending a callchain from a previous sample
      perf tools: Fix leak of 'struct thread' on error path
      perf tools: Add machine__kernel_ip()
      perf buildid-cache: Apply force option to copying kcore
      perf script: Improve srcline display for BTS
      perf script: Do not print dangling '=>' for BTS
      perf tools: Record whether a dso is 64-bit
      perf tools: Record whether a dso has data
      perf tools: Do not attempt to read data from kallsyms
      perf tools: Let a user specify a PMU event without any config terms
      perf tools: Let default config be defined for a PMU
      perf tools: Add perf_pmu__scan_file()
      perf tools: Add dsos__hit_all()
      perf tools: Add cpu to struct thread
      perf tools: Add ability to record the current tid for each cpu
      perf tools: Add ability to iterate over a dso's symbols
      perf session: Flag if the event stream is entirely in memory
      perf evlist: Pass mmap parameters in a struct
      perf tools: Add feature test for __sync_val_compare_and_swap
      perf tools: Add option macro OPT_CALLBACK_OPTARG
      perf evlist: Add perf_evlist__set_tracking_event()
      perf evsel: Add 'no_aux_samples' option
      perf evsel: Add 'immediate' option
      perf evlist: Add 'system_wide' option
      perf tools: Add id index
      perf pmu: Let pmu's with no events show up on perf list
      perf session: Add ability to skip 4GiB or more
      perf session: Add perf_session__deliver_synth_event()
      perf tools: Allow TSC conversion on any arch
      perf tools: Move rdtsc() function
      perf evlist: Add perf_evlist__enable_event_idx()

 tools/perf/Makefile.perf                           |   2 +
 tools/perf/arch/x86/util/tsc.c                     |  31 ++--
 tools/perf/arch/x86/util/tsc.h                     |   3 -
 tools/perf/builtin-buildid-cache.c                 |   8 +-
 tools/perf/builtin-inject.c                        |   4 +
 tools/perf/builtin-sched.c                         |  12 +-
 tools/perf/builtin-script.c                        |  26 ++-
 tools/perf/config/Makefile                         |   6 +
 tools/perf/config/feature-checks/Makefile          |   4 +
 tools/perf/config/feature-checks/test-all.c        |   5 +
 .../feature-checks/test-sync-compare-and-swap.c    |  14 ++
 tools/perf/tests/perf-time-to-tsc.c                |  12 +-
 tools/perf/tests/pmu.c                             |   2 +-
 tools/perf/util/callchain.c                        |   2 +-
 tools/perf/util/comm.c                             |   7 +-
 tools/perf/util/comm.h                             |   6 +-
 tools/perf/util/dso.c                              |   6 +-
 tools/perf/util/dso.h                              |   2 +
 tools/perf/util/event.c                            |  17 +-
 tools/perf/util/event.h                            |  15 ++
 tools/perf/util/evlist.c                           | 184 +++++++++++++++----
 tools/perf/util/evlist.h                           |   5 +
 tools/perf/util/evsel.c                            |  45 ++++-
 tools/perf/util/evsel.h                            |   6 +
 tools/perf/util/header.c                           |  41 +++++
 tools/perf/util/header.h                           |   2 +
 tools/perf/util/machine.c                          | 127 +++++++++++++-
 tools/perf/util/machine.h                          |  26 +++
 tools/perf/util/map.c                              |  14 ++
 tools/perf/util/map.h                              |   1 +
 tools/perf/util/parse-events.c                     |  13 +-
 tools/perf/util/parse-events.y                     |  10 ++
 tools/perf/util/parse-options.h                    |   5 +
 tools/perf/util/pmu.c                              |  92 ++++++++--
 tools/perf/util/pmu.h                              |  13 +-
 tools/perf/util/record.c                           |  18 +-
 tools/perf/util/session.c                          | 194 +++++++++++++++++++--
 tools/perf/util/session.h                          |  18 ++
 tools/perf/util/symbol-elf.c                       |   8 +-
 tools/perf/util/symbol-minimal.c                   |  22 +++
 tools/perf/util/symbol.c                           |  20 ++-
 tools/perf/util/symbol.h                           |   4 +
 tools/perf/util/thread.c                           |  68 +++++++-
 tools/perf/util/thread.h                           |  12 +-
 tools/perf/util/tool.h                             |   3 +-
 tools/perf/util/tsc.c                              |  30 ++++
 tools/perf/util/tsc.h                              |  12 ++
 47 files changed, 1020 insertions(+), 157 deletions(-)
 create mode 100644 tools/perf/config/feature-checks/test-sync-compare-and-swap.c
 create mode 100644 tools/perf/util/tsc.c
 create mode 100644 tools/perf/util/tsc.h

 
 Regards
 Adrian
