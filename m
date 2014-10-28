Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbaJ1Ncp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:32:45 -0400
Received: from mail.kernel.org ([198.145.19.201]:50993 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698AbaJ1Ncn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:32:43 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, Anton Blanchard <anton@au1.ibm.com>,
        Arun Sharma <asharma@fb.com>, Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Waiman Long <Waiman.Long@hp.com>, Wang Nan <wangnan0@huawei.com>
Subject: [GIT PULL 00/32] perf/core improvements and fixes
Date: Tue, 28 Oct 2014 11:31:54 -0200
Message-Id: <1414503146-22789-1-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit e53f6124af6516cee3063a3072767ee2717ff343:

  Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2014-10-24 09:46:36 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo

for you to fetch changes up to 8eeeb304ea2714962b10873f72aa7c5e24f5265f:

  perf probe: Add --quiet option to suppress output result message (2014-10-27 17:16:34 -0200)

----------------------------------------------------------------
perf/core improvements and fixes:

User visible:

* 'perf probe' --demangle typo fix and a new --quiet option (Masami Hiramatsu)

* Fix report -F (abort, in_tx, mispredict, etc) segfaults for sample.data files
  without branch info (Jiri Olsa)

* Don't open the DWARF info multiple times, keeping instead a dwfl handle
  in struct dso, greatly speeding up 'perf report' on powerpc. (Sukadev Bhattiprolu)

* Add patch that should have went in a previous patchkit to use global cache
  provided by libunwind (Namhyung Kim)

* Make CPUINFO_PROC an array to support different kernels, problem
  detected when the information reported via /proc/cpuinfo changed on ARM (Wang Nan)

* Introduce PARSE_OPT_DISABLED option flag and use it to avoid showing
  undersired options in tools that provides frontends to 'perf record', like
  sched, kvm, etc (Namhyung Kim)

Infrastructure:

* More Intel PT work, including a facility to export sample data (comms,
  threads, symbol names, etc) in a database friendly way, with an script to use
 this to create a postgresql database. (Adrian Hunter)

* Use make sure that thread->mg->machine points to the machine where
  the thread exists (it was being set only for the kmaps kernel modules
  case, do it as well for the mmaps) and use it to shorten function
  signatures (Arnaldo Carvalho de Melo)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Adrian Hunter (7):
      perf pmu: Let pmu's with no events show up on perf list
      perf tools: Build programs to copy 32-bit compatibility
      perf tools: Add support for 32-bit compatibility VDSOs
      perf tools: Do not attempt to run perf-read-vdso32 if it wasn't built
      perf tools: Add facility to export data in database-friendly way
      perf scripting python: Extend interface to export data in a database-friendly way
      perf script: Add Python script to export to postgresql

Arnaldo Carvalho de Melo (7):
      perf tools: Set thread->mg.machine in all places
      perf tools: A thread's machine can be found via thread->mg->machine
      perf thread: Adopt resolve_callchain method from machine
      perf callchains: Use thread->mg->machine
      perf tests: Remove misplaced __maybe_unused
      perf tests: Use thread->mg->machine
      perf pmu: Add proper error handling to print_pmu_events()

Jiri Olsa (7):
      perf tools: Fix report -F abort for data without branch info
      perf tools: Fix report -F in_tx for data without branch info
      perf tools: Fix report -F mispredict for data without branch info
      perf tools: Fix report -F symbol_to for data without branch info
      perf tools: Fix report -F symbol_from for data without branch info
      perf tools: Fix report -F dso_to for data without branch info
      perf tools: Fix report -F dso_from for data without branch info

Masami Hiramatsu (2):
      perf probe: Trivial typo fix for --demangle
      perf probe: Add --quiet option to suppress output result message

Namhyung Kim (6):
      perf tools: Add PARSE_OPT_DISABLED flag
      perf tools: Export usage string and option table of perf record
      perf kvm: Print kvm specific --help output
      perf tools: Add support for exclusive option
      perf probe: Use PARSE_OPT_EXCLUSIVE flag
      perf callchain: Use global caching provided by libunwind

Sukadev Bhattiprolu (1):
      perf tools powerpc: Cache the DWARF debug info

Wang Nan (2):
      perf tools: Ensure return negative value when write header error
      perf tools: Make CPUINFO_PROC an array to support different kernel versions

 tools/perf/Makefile.perf                           |  40 ++-
 tools/perf/arch/powerpc/util/skip-callchain-idx.c  |  38 ++-
 tools/perf/builtin-inject.c                        |   3 +-
 tools/perf/builtin-kvm.c                           |  25 ++
 tools/perf/builtin-probe.c                         |  67 ++--
 tools/perf/builtin-record.c                        |   7 +-
 tools/perf/builtin-script.c                        |   8 +-
 tools/perf/builtin-timechart.c                     |   9 +-
 tools/perf/builtin-trace.c                         |   6 +-
 tools/perf/config/Makefile                         |  29 +-
 tools/perf/config/Makefile.arch                    |   8 +
 tools/perf/config/feature-checks/Makefile          |  10 +-
 tools/perf/config/feature-checks/test-compile.c    |   4 +
 tools/perf/perf-read-vdso.c                        |  34 ++
 tools/perf/perf-sys.h                              |  30 +-
 tools/perf/perf.h                                  |   3 +
 .../scripts/python/bin/export-to-postgresql-record |   8 +
 .../scripts/python/bin/export-to-postgresql-report |  24 ++
 tools/perf/scripts/python/export-to-postgresql.py  | 360 +++++++++++++++++++++
 tools/perf/tests/code-reading.c                    |  13 +-
 tools/perf/tests/dwarf-unwind.c                    |  18 +-
 tools/perf/tests/hists_filter.c                    |   2 +-
 tools/perf/tests/mmap-thread-lookup.c              |   2 +-
 tools/perf/util/build-id.c                         |   3 +-
 tools/perf/util/callchain.c                        |   4 +-
 tools/perf/util/callchain.h                        |   6 +-
 tools/perf/util/comm.h                             |   4 +
 tools/perf/util/db-export.c                        | 270 ++++++++++++++++
 tools/perf/util/db-export.h                        |  86 +++++
 tools/perf/util/dso.h                              |   6 +
 tools/perf/util/event.c                            |  19 +-
 tools/perf/util/event.h                            |   1 -
 tools/perf/util/evsel.h                            |   2 +
 tools/perf/util/find-vdso-map.c                    |  30 ++
 tools/perf/util/header.c                           |  34 +-
 tools/perf/util/machine.c                          |  55 ++--
 tools/perf/util/machine.h                          |  17 +-
 tools/perf/util/map.c                              |   8 +-
 tools/perf/util/map.h                              |   4 +-
 tools/perf/util/parse-options.c                    |  78 ++++-
 tools/perf/util/parse-options.h                    |   4 +
 tools/perf/util/pmu.c                              |  41 ++-
 tools/perf/util/pmu.h                              |   1 +
 tools/perf/util/probe-event.c                      |  18 +-
 .../util/scripting-engines/trace-event-python.c    | 292 ++++++++++++++++-
 tools/perf/util/session.c                          |   6 +-
 tools/perf/util/sort.c                             | 102 ++++--
 tools/perf/util/thread.c                           |   9 +-
 tools/perf/util/thread.h                           |   6 +-
 tools/perf/util/unwind-libdw.c                     |   8 +-
 tools/perf/util/unwind-libunwind.c                 |  29 +-
 tools/perf/util/unwind.h                           |   5 +-
 tools/perf/util/vdso.c                             | 217 +++++++++++--
 tools/perf/util/vdso.h                             |   4 +-
 54 files changed, 1808 insertions(+), 309 deletions(-)
 create mode 100644 tools/perf/config/feature-checks/test-compile.c
 create mode 100644 tools/perf/perf-read-vdso.c
 create mode 100644 tools/perf/scripts/python/bin/export-to-postgresql-record
 create mode 100644 tools/perf/scripts/python/bin/export-to-postgresql-report
 create mode 100644 tools/perf/scripts/python/export-to-postgresql.py
 create mode 100644 tools/perf/util/db-export.c
 create mode 100644 tools/perf/util/db-export.h
 create mode 100644 tools/perf/util/find-vdso-map.c
