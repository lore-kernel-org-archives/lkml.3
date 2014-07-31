Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbaGaGCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:02:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:44617 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbaGaGC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:02:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,770,1400050800"; 
   d="scan'208";a="569799608"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 00/31] perf tools: Yet more preparation for call graph from Intel BTS
Date: Thu, 31 Jul 2014 09:00:43 +0300
Message-Id: <1406786474-9306-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here is the next selection of patches based on tip/perf/core.

They can also be found here:

	http://git.infradead.org/users/ahunter/linux-perf.git/shortlog/refs/heads/for-acme


Adrian Hunter (31):
      perf tools: Identify which comms are from exec
      perf tools: Add machine__thread_exec_comm()
      perf tools: Fix missing label symbols
      perf tools: Add machine__kernel_ip()
      perf tools: Let a user specify a PMU event without any config terms
      perf tools: Let default config be defined for a PMU
      perf tools: Add perf_pmu__scan_file()
      perf evlist: Add 'system_wide' option
      perf evlist: Add perf_evlist__set_tracking_event()
      perf tools: Add id index
      perf pmu: Let pmu's with no events show up on perf list
      perf session: Add perf_session__deliver_synth_event()
      perf evlist: Add perf_evlist__enable_event_idx()
      perf session: Add perf_session__peek_event()
      perf tools: Add a thread stack for synthesizing call chains
      perf script: Allow callchains if any event samples them
      perf tools: Add facility to export data in database-friendly way
      perf tools: Add helpers for calling Python objects
      perf tools: Extend Python script interface to export data in a database-friendly way
      perf tools: Add Python script to export to postgresql
      perf tools: Add flags and insn_len to struct sample
      perf tools: Add branch type to db export
      perf tools: Add branch_type and in_tx to Python export
      perf tools: Enhance the thread stack to output call/return data
      perf tools: Add call information to the database export API
      perf tools: Add call information to Python export
      perf tools: Add 'flush' callback to scripting API
      perf tools: Defer export of comms that were not 'set'
      perf tools: Add perf-with-kcore script
      perf tools: Build programs to copy 32-bit compatibility VDSOs
      perf tools: Add support for 32-bit compatibility VDSOs

 tools/perf/.gitignore                              |   1 +
 tools/perf/Makefile.perf                           |  46 +-
 tools/perf/builtin-inject.c                        |   1 +
 tools/perf/builtin-script.c                        |  29 +-
 tools/perf/config/Makefile                         |  21 +
 tools/perf/config/Makefile.arch                    |   8 +
 tools/perf/perf-read-vdso.c                        |  59 ++
 tools/perf/perf-with-kcore.sh                      | 259 ++++++++
 .../scripts/python/bin/export-to-postgresql-record |   8 +
 .../scripts/python/bin/export-to-postgresql-report |  29 +
 tools/perf/scripts/python/export-to-postgresql.py  | 444 +++++++++++++
 tools/perf/tests/pmu.c                             |   2 +-
 tools/perf/util/comm.c                             |   7 +-
 tools/perf/util/comm.h                             |   7 +-
 tools/perf/util/db-export.c                        | 426 +++++++++++++
 tools/perf/util/db-export.h                        | 107 ++++
 tools/perf/util/dso.h                              |   1 +
 tools/perf/util/event.c                            |   7 +-
 tools/perf/util/event.h                            |  43 ++
 tools/perf/util/evlist.c                           | 135 +++-
 tools/perf/util/evlist.h                           |   5 +
 tools/perf/util/evsel.c                            |  34 +-
 tools/perf/util/evsel.h                            |   6 +
 tools/perf/util/machine.c                          |  53 +-
 tools/perf/util/machine.h                          |  22 +
 tools/perf/util/parse-events.c                     |  13 +-
 tools/perf/util/parse-events.y                     |  10 +
 tools/perf/util/pmu.c                              |  92 ++-
 tools/perf/util/pmu.h                              |  13 +-
 tools/perf/util/record.c                           |   2 +-
 .../perf/util/scripting-engines/trace-event-perl.c |   6 +
 .../util/scripting-engines/trace-event-python.c    | 511 +++++++++++++--
 tools/perf/util/session.c                          | 215 ++++++-
 tools/perf/util/session.h                          |  20 +
 tools/perf/util/symbol-elf.c                       |   2 +-
 tools/perf/util/symbol.h                           |   1 +
 tools/perf/util/thread-stack.c                     | 690 +++++++++++++++++++++
 tools/perf/util/thread-stack.h                     |  79 +++
 tools/perf/util/thread.c                           |  27 +-
 tools/perf/util/thread.h                           |  14 +-
 tools/perf/util/tool.h                             |   3 +-
 tools/perf/util/trace-event-scripting.c            |   7 +
 tools/perf/util/trace-event.h                      |   1 +
 tools/perf/util/vdso.c                             | 170 ++++-
 tools/perf/util/vdso.h                             |   4 +-
 45 files changed, 3505 insertions(+), 135 deletions(-)
 create mode 100644 tools/perf/perf-read-vdso.c
 create mode 100644 tools/perf/perf-with-kcore.sh
 create mode 100644 tools/perf/scripts/python/bin/export-to-postgresql-record
 create mode 100644 tools/perf/scripts/python/bin/export-to-postgresql-report
 create mode 100644 tools/perf/scripts/python/export-to-postgresql.py
 create mode 100644 tools/perf/util/db-export.c
 create mode 100644 tools/perf/util/db-export.h
 create mode 100644 tools/perf/util/thread-stack.c
 create mode 100644 tools/perf/util/thread-stack.h

 
 Regards
 Adrian
