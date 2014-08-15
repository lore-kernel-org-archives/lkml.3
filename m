Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbaHOTKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:10:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:34714 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbaHOTKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:10:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,872,1400050800"; 
   d="scan'208";a="588727707"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 00/24] perf tools: Still more preparation for Intel PT
Date: Fri, 15 Aug 2014 22:08:35 +0300
Message-Id: <1408129739-17368-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here is the next selection of patches.  That are based on top of
759e612bf96627b64fcafe4174b3f6f2dedf2c0d perf stat: Use strerror_r instead of strerror

They can also be found here:

	http://git.infradead.org/users/ahunter/linux-perf.git/shortlog/refs/heads/for-acme


Adrian Hunter (23):
      perf tools: Add a test for tracking with sched_switch
      perf scripting: Add 'flush' callback to scripting API
      perf tools: Rename machine__get_kernel_start_addr()
      perf tools: Add machine__kernel_ip()
      perf tools: Let a user specify a PMU event without any config terms
      perf tools: Let default config be defined for a PMU
      perf tools: Add perf_pmu__scan_file()
      perf tools: Add id index
      perf pmu: Let pmu's with no events show up on perf list
      perf session: Add perf_session__deliver_synth_event()
      perf tools: Add a thread stack for synthesizing call chains
      perf tools: Add facility to export data in database-friendly way
      perf tools: Extend Python script interface to export data in a database-friendly way
      perf tools: Add Python script to export to postgresql
      perf tools: Add branch type to db export
      perf tools: Add branch_type and in_tx to Python export
      perf tools: Enhance the thread stack to output call/return data
      perf tools: Add call information to the database export API
      perf tools: Add call information to Python export
      perf tools: Defer export of comms that were not 'set'
      perf tools: Add perf-with-kcore script
      perf tools: Build programs to copy 32-bit compatibility VDSOs
      perf tools: Add support for 32-bit compatibility VDSOs

Alexander Shishkin (1):
      perf tools: Add feature checks to .gitignore

 tools/perf/.gitignore                              |   2 +
 tools/perf/Makefile.perf                           |  48 +-
 tools/perf/builtin-inject.c                        |   1 +
 tools/perf/builtin-script.c                        |  13 +
 tools/perf/config/Makefile                         |  25 +-
 tools/perf/config/Makefile.arch                    |   8 +
 tools/perf/config/feature-checks/Makefile          |  10 +-
 tools/perf/config/feature-checks/test-compile.c    |   4 +
 tools/perf/perf-read-vdso.c                        |  34 +
 tools/perf/perf-with-kcore.sh                      | 259 ++++++++
 .../scripts/python/bin/export-to-postgresql-record |   8 +
 .../scripts/python/bin/export-to-postgresql-report |  29 +
 tools/perf/scripts/python/export-to-postgresql.py  | 444 +++++++++++++
 tools/perf/tests/builtin-test.c                    |   4 +
 tools/perf/tests/pmu.c                             |   2 +-
 tools/perf/tests/switch-tracking.c                 | 572 +++++++++++++++++
 tools/perf/tests/tests.h                           |   1 +
 tools/perf/util/comm.h                             |   1 +
 tools/perf/util/db-export.c                        | 426 +++++++++++++
 tools/perf/util/db-export.h                        | 107 ++++
 tools/perf/util/dso.h                              |   1 +
 tools/perf/util/event.c                            |   7 +-
 tools/perf/util/event.h                            |  41 ++
 tools/perf/util/evlist.c                           |  26 +-
 tools/perf/util/evsel.h                            |   4 +
 tools/perf/util/find-vdso-map.c                    |  30 +
 tools/perf/util/machine.c                          |  31 +-
 tools/perf/util/machine.h                          |  18 +
 tools/perf/util/parse-events.c                     |  13 +-
 tools/perf/util/parse-events.y                     |  10 +
 tools/perf/util/pmu.c                              |  92 ++-
 tools/perf/util/pmu.h                              |  13 +-
 .../perf/util/scripting-engines/trace-event-perl.c |   6 +
 .../util/scripting-engines/trace-event-python.c    | 399 +++++++++++-
 tools/perf/util/session.c                          | 136 ++++
 tools/perf/util/session.h                          |  15 +
 tools/perf/util/symbol.h                           |   1 +
 tools/perf/util/thread-stack.c                     | 690 +++++++++++++++++++++
 tools/perf/util/thread-stack.h                     |  79 +++
 tools/perf/util/thread.c                           |   3 +
 tools/perf/util/thread.h                           |   4 +
 tools/perf/util/tool.h                             |   3 +-
 tools/perf/util/trace-event-scripting.c            |   7 +
 tools/perf/util/trace-event.h                      |   1 +
 tools/perf/util/vdso.c                             | 207 ++++++-
 tools/perf/util/vdso.h                             |   4 +-
 46 files changed, 3765 insertions(+), 74 deletions(-)
 create mode 100644 tools/perf/config/feature-checks/test-compile.c
 create mode 100644 tools/perf/perf-read-vdso.c
 create mode 100644 tools/perf/perf-with-kcore.sh
 create mode 100644 tools/perf/scripts/python/bin/export-to-postgresql-record
 create mode 100644 tools/perf/scripts/python/bin/export-to-postgresql-report
 create mode 100644 tools/perf/scripts/python/export-to-postgresql.py
 create mode 100644 tools/perf/tests/switch-tracking.c
 create mode 100644 tools/perf/util/db-export.c
 create mode 100644 tools/perf/util/db-export.h
 create mode 100644 tools/perf/util/find-vdso-map.c
 create mode 100644 tools/perf/util/thread-stack.c
 create mode 100644 tools/perf/util/thread-stack.h

Regards
Adrian

