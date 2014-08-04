Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaHDJ5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 05:57:54 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:50190 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaHDJ5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 05:57:48 -0400
Date: Mon, 4 Aug 2014 11:57:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf changes for v3.17
Message-ID: <20140804095734.GA23404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-core-for-linus

   # HEAD: f9b9f812235d53f774a083e88a5a23b517a69752 Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/core

Kernel side changes:

      * Consolidate the PMU interrupt-disabled code amongst architectures (Vince Weaver)

      * misc fixes

Tooling changes:

  - New features, user visible changes:
    
      * Add support for pagefault tracing in 'trace', please see multiple examples
        in the changeset messages (Stanislav Fomichev).
    
      * Add pagefault statistics in 'trace' (Stanislav Fomichev)
    
      * Add header for columns in 'top' and 'report' TUI browsers (Jiri Olsa)
    
      * Add pagefault statistics in 'trace' (Stanislav Fomichev)
    
      * Add IO mode into timechart command (Stanislav Fomichev)

      * Fallback to syscalls:* when raw_syscalls:* is not available in the perl and
        python perf scripts. (Daniel Bristot de Oliveira)
    
      * Add --repeat global option to 'perf bench' to be used in benchmarks
        such as the existing 'futex' one, that was modified to use it instead
        of a local option. (Davidlohr Bueso)
    
      * Fix fd -> pathname resolution in 'trace', be it using /proc or
        a vfs_getname probe point. (Arnaldo Carvalho de Melo)
    
      * Add suggestion of how to set perf_event_paranoid sysctl, to help
        non-root users trying tools like 'trace' to get a working environment.
        (Arnaldo Carvalho de Melo)
    
      * Updates from trace-cmd for traceevent plugin_kvm plus args cleanup (Steven Rostedt, Jan Kiszka)

      * Support S/390 in 'perf kvm stat' (Alexander Yarygin)
    
  - Infrastructure changes:

      * Allow reserving a row for header purposes in the hists browser (Arnaldo Carvalho de Melo)
    
      * Various fixes and prep work related to supporting Intel PT (Adrian Hunter)
    
      * Introduce multiple debug variables control (Jiri Olsa)
    
      * Add callchain and additional sample information for python scripts (Joseph Schuchart)
    
      * More prep work to support Intel PT: (Adrian Hunter)
         - Polishing 'script' BTS output
         - 'inject' can specify --kallsym
         - VDSO is per machine, not a global var
         - Expose data addr lookup functions previously private to 'script'
         - Large mmap fixes in events processing
    
      * Include standard stringify macros in power pc code (Sukadev Bhattiprolu)

  - Cleanups:
    
      * Convert open coded equivalents to asprintf() (Andy Shevchenko)
    
      * Remove needless reassignments in 'trace' (Arnaldo Carvalho de Melo)
    
      * Cache the is_exit syscall test in 'trace) (Arnaldo Carvalho de Melo)
    
      * No need to reimplement err() in 'perf bench sched-messaging', drop barf().
        (Davidlohr Bueso).
    
      * Remove ev_name argument from perf_evsel__hists_browse, can be obtained
        from the other parameters. (Jiri Olsa)
    
  - Fixes:
    
      * Fix memory leak in the 'sched-messaging' perf bench test. (Davidlohr Bueso)
    
      * The -o and -n 'perf bench mem' options are mutually exclusive, emit error
        when both are specified. (Davidlohr Bueso)
    
      * Fix scrollbar refresh row index in the ui browser, problem exposed now
        that headers will be added and will be allowed to be switched on/off.
        (Jiri Olsa)
    
      * Handle the num array type in python properly (Sebastian Andrzej Siewior)
    
      * Fix wrong condition for allocation failure (Jiri Olsa)
    
      * Adjust callchain based on DWARF debug info on powerpc (Sukadev Bhattiprolu)
    
      * Fix a risk for doing free on uninitialized pointer in traceevent lib (Rickard Strandqvist)
    
      * Update attr test with PERF_FLAG_FD_CLOEXEC flag (Jiri Olsa)
    
      * Enable close-on-exec flag on perf file descriptor (Yann Droneaud)
    
      * Fix build on gcc 4.4.7 (Arnaldo Carvalho de Melo)
    
      * Event ordering fixes (Jiri Olsa)
    
 Thanks,

	Ingo

------------------>
Adrian Hunter (43):
      perf machine: Fix the value used for unknown pids
      perf script: Display PERF_RECORD_MISC_COMM_EXEC flag
      perf record: Select comm_exec flag if supported
      perf tools: Fix missing kernel map load
      perf symbols: Fix missing GNU IFUNC symbols
      perf inject: Fix build id injection
      perf callchain: Fix appending a callchain from a previous sample
      perf buildid-cache: Apply force option to copying kcore
      perf symbols: Record whether a dso is 64-bit
      perf symbols: Do not attempt to read data from kallsyms
      perf symbols: Add ability to iterate over a dso's symbols
      perf session: Flag if the event stream is entirely in memory
      perf evlist: Pass mmap parameters in a struct
      perf tools: Add feature test for __sync_val_compare_and_swap
      perf tools: Add option macro OPT_CALLBACK_OPTARG
      perf evsel: Add 'no_aux_samples' option
      perf evsel: Add 'immediate' option
      perf machine: Fix map groups of threads with unknown pids
      perf thread: Allow deletion of a thread with no map groups
      perf machine: Fix leak of 'struct thread' on error path
      perf tools: Allow TSC conversion on any arch
      perf tools: Fix incorrect fd error comparison
      perf tools: Fix jump label always changing during tracing
      perf script: Improve srcline display for BTS
      perf script: Do not print dangling '=>' for BTS
      perf tools: Record whether a dso has data
      perf tools: Add dso__data_status_seen()
      perf tools: Add dsos__hit_all()
      perf tools: Add cpu to struct thread
      perf machine: Add ability to record the current tid for each cpu
      perf tools: Move rdtsc() function
      perf tools: Add dso__data_size()
      perf tools: Pass machine to vdso__dso_findnew()
      perf session: Add ability to 'skip' a non-piped event stream
      perf session: Add ability to skip 4GiB or more
      perf tools: Group VDSO global variables into a structure
      perf machine: Fix the lifetime of the VDSO temporary file
      perf tools: Add vdso__new()
      perf tools: Separate the VDSO map name from the VDSO dso name
      perf tools: Add dso__type()
      perf tools: Add thread parameter to vdso__dso_findnew()
      perf tools: Expose 'addr' functions so they can be reused
      perf inject: Add --kallsyms parameter

Alexander Yarygin (8):
      perf kvm: Introduce HAVE_KVM_STAT_SUPPORT flag
      perf kvm: Simplify exit reasons tables definitions
      perf kvm: Refactoring of cpu_isa_config()
      perf tools: Allow to use cpuinfo on s390
      perf kvm: Use defines of kvm events
      perf kvm: Move arch specific code into arch/
      perf kvm: Add skip_event() for --duration option
      perf kvm: Add stat support on s390

Andy Shevchenko (1):
      perf tools: Convert open coded equivalents to asprintf()

Arnaldo Carvalho de Melo (13):
      perf trace: Fix up fd -> pathname resolution
      perf evlist: Add suggestion of how to set perf_event_paranoid sysctl
      perf trace: Remove needless reassignments
      perf trace: Cache the is_exit syscall test
      perf ui browser: Add ->rows to disambiguate from ->height
      perf ui browser: Allow overriding refresh_dimensions method
      perf hists browser: Introduce gotorc method
      perf hists browser: Override ui_browser refresh_dimensions method
      perf hists browser: Add support for showing columns header
      perf hists browser: Left justify column headers
      perf tools: Suggest using -f to override perf.data file ownership message
      perf trace: Fix build on 32-bit systems
      perf tools: Fix build on gcc 4.4.7

Daniel Bristot de Oliveira (1):
      perf scripts: Fallback to syscalls:* when raw_syscalls:* is not available

Davidlohr Bueso (5):
      perf bench sched-messaging: Plug memleak
      perf bench: Add --repeat option
      perf bench futex: Use global --repeat option
      perf bench mem: The -o and -n options are mutually exclusive
      perf bench sched-messaging: Drop barf()

Jan Kiszka (3):
      tools lib traceevent: Report unknown VMX exit reasons with code
      tools lib traceevent: Factor out print_exit_reason in kvm plugin
      tools lib traceevent: Fix and cleanup kvm_nested_vmexit tracepoints

Jiri Olsa (19):
      perf hists browser: Remove ev_name argument from perf_evsel__hists_browse
      perf ui browser: Fix scrollbar refresh row index
      perf tools: Fix wrong condition for allocation failure
      perf: Make perf_event_init_context() function static
      perf hists browser: Display columns header text on 'H' press
      perf hists browser: Add ui.show-headers config file option
      perf: Add vm_ops->name call for mmap event name retrieval
      perf tools: Remove verbose from functions prototypes
      perf tools: Move pr_* debug macros into debug object
      perf tools: Factor eprintf to allow different debug variables
      perf tools: Add --debug optionto set debug variable
      perf tools: Remove needless getopt.h includes
      perf tests: Update attr test with PERF_FLAG_FD_CLOEXEC flag
      perf session: Fix accounting of ordered samples queue
      perf record: Always force PERF_RECORD_FINISHED_ROUND event
      perf record: Store PERF_RECORD_FINISHED_ROUND only for nonempty rounds
      perf: Check permission only for parent tracepoint event
      perf tools: Fix perf usage string leftover
      Revert "perf tools: Fix jump label always changing during tracing"

Joseph Schuchart (3):
      perf script: Add missing calls to Py_DECREF for return values
      perf script: Add callchain to generic and tracepoint events
      perf script: Provide additional sample information on generic events

Rasmus Villemoes (1):
      perf/x86: Micro-optimize nhmex_rbox_get_constraint()

Rickard Strandqvist (1):
      tools lib traceevent: Fix a risk for doing free on uninitialized pointer

Sebastian Andrzej Siewior (2):
      perf script: Move the number processing into its own function
      perf script: Handle the num array type in python properly

Stanislav Fomichev (9):
      perf trace: Add perf_event parameter to tracepoint_handler
      perf trace: Add support for pagefault tracing
      perf trace: Add pagefaults record and replay support
      perf trace: Add possibility to switch off syscall events
      perf trace: Add pagefault statistics
      perf timechart: Fix rendering in Firefox
      perf timechart: Implement IO mode
      perf timechart: Conditionally update start_time on fork
      perf timechart: Add more options to IO mode

Steven Rostedt (3):
      tools lib traceevent: Fix format in plugin_kvm
      tools lib traceevent: Clean up format of args in cfg80211 plugin
      tools lib traceevent: Clean up format of args in jbd2 plugin

Steven Rostedt (Red Hat) (1):
      tools lib traceevent: Add back in kvm plugins nested_vmexit events

Sukadev Bhattiprolu (2):
      perf tools powerpc: Adjust callchain based on DWARF debug info
      perf powerpc: Include util/util.h and remove stringify macros

Vince Weaver (6):
      arc, perf: Use common PMU interrupt disabled code
      blackfin, perf: Use common PMU interrupt disabled code
      metag, perf: Use common PMU interrupt disabled code
      s390, perf: Use common PMU interrupt disabled code
      sh, perf: Use common PMU interrupt disabled code
      powerpc, perf: Use common PMU interrupt disabled code

Yann Droneaud (1):
      perf tools: Enable close-on-exec flag on perf file descriptor

Zhouyi Zhou (1):
      perf/x86/amd: Try to fix some mem allocation failure handling


 arch/arc/kernel/perf_event.c                       |   7 +-
 arch/blackfin/kernel/perf_event.c                  |  15 +-
 arch/metag/kernel/perf/perf_event.c                |  19 +-
 arch/powerpc/perf/hv-24x7.c                        |   6 +-
 arch/powerpc/perf/hv-gpci.c                        |   6 +-
 arch/s390/include/uapi/asm/Kbuild                  |   1 +
 arch/s390/include/uapi/asm/kvm_perf.h              |  25 +
 arch/s390/kernel/perf_cpum_cf.c                    |  12 +-
 arch/sh/kernel/perf_event.c                        |  15 +-
 arch/x86/include/uapi/asm/Kbuild                   |   1 +
 arch/x86/include/uapi/asm/kvm_perf.h               |  16 +
 arch/x86/kernel/cpu/perf_event_amd_uncore.c        | 111 +++-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c      |   5 +-
 kernel/events/core.c                               |   8 +-
 kernel/trace/trace_event_perf.c                    |  12 +
 tools/lib/traceevent/event-parse.c                 |   6 +-
 tools/lib/traceevent/plugin_cfg80211.c             |   3 +-
 tools/lib/traceevent/plugin_jbd2.c                 |   6 +-
 tools/lib/traceevent/plugin_kvm.c                  |  64 +-
 tools/perf/Documentation/perf-bench.txt            |   4 +
 tools/perf/Documentation/perf-inject.txt           |   3 +
 tools/perf/Documentation/perf-kvm.txt              |  16 +-
 tools/perf/Documentation/perf-timechart.txt        |  38 +-
 tools/perf/Documentation/perf-trace.txt            |  46 ++
 tools/perf/Documentation/perf.txt                  |  10 +-
 tools/perf/MANIFEST                                |   3 +
 tools/perf/Makefile.perf                           |   4 +
 tools/perf/arch/powerpc/Makefile                   |   1 +
 tools/perf/arch/powerpc/util/header.c              |   4 +-
 tools/perf/arch/powerpc/util/skip-callchain-idx.c  | 266 ++++++++
 tools/perf/arch/s390/Makefile                      |   3 +
 tools/perf/arch/s390/util/header.c                 |  28 +
 tools/perf/arch/s390/util/kvm-stat.c               | 105 ++++
 tools/perf/arch/x86/Makefile                       |   2 +
 tools/perf/arch/x86/tests/dwarf-unwind.c           |   1 +
 tools/perf/arch/x86/util/kvm-stat.c                | 156 +++++
 tools/perf/arch/x86/util/tsc.c                     |  31 +-
 tools/perf/arch/x86/util/tsc.h                     |   3 -
 tools/perf/arch/x86/util/unwind-libunwind.c        |   1 +
 tools/perf/bench/bench.h                           |   1 +
 tools/perf/bench/futex-requeue.c                   |  10 +-
 tools/perf/bench/futex-wake.c                      |  12 +-
 tools/perf/bench/mem-memcpy.c                      |   9 +-
 tools/perf/bench/mem-memset.c                      |   9 +-
 tools/perf/bench/sched-messaging.c                 |  47 +-
 tools/perf/builtin-bench.c                         |   7 +
 tools/perf/builtin-buildid-cache.c                 |   8 +-
 tools/perf/builtin-evlist.c                        |   1 +
 tools/perf/builtin-help.c                          |   1 +
 tools/perf/builtin-inject.c                        |   5 +
 tools/perf/builtin-kvm.c                           | 414 ++++--------
 tools/perf/builtin-record.c                        |   7 +-
 tools/perf/builtin-sched.c                         |  16 +-
 tools/perf/builtin-script.c                        |  60 +-
 tools/perf/builtin-stat.c                          |   2 +-
 tools/perf/builtin-timechart.c                     | 694 ++++++++++++++++++++-
 tools/perf/builtin-trace.c                         | 266 ++++++--
 tools/perf/config/Makefile                         |  14 +
 tools/perf/config/feature-checks/Makefile          |   4 +
 tools/perf/config/feature-checks/test-all.c        |   5 +
 .../feature-checks/test-sync-compare-and-swap.c    |  14 +
 tools/perf/perf-sys.h                              |   1 +
 tools/perf/perf.c                                  |  13 +-
 tools/perf/scripts/perl/bin/failed-syscalls-record |   3 +-
 tools/perf/scripts/perl/failed-syscalls.pl         |   5 +
 .../python/Perf-Trace-Util/lib/Perf/Trace/Core.py  |   3 +-
 .../python/bin/failed-syscalls-by-pid-record       |   3 +-
 tools/perf/scripts/python/bin/sctop-record         |   3 +-
 .../python/bin/syscall-counts-by-pid-record        |   3 +-
 .../perf/scripts/python/bin/syscall-counts-record  |   3 +-
 tools/perf/scripts/python/check-perf-trace.py      |   4 +-
 .../perf/scripts/python/failed-syscalls-by-pid.py  |   7 +-
 tools/perf/scripts/python/futex-contention.py      |   4 +-
 tools/perf/scripts/python/net_dropmonitor.py       |   2 +-
 tools/perf/scripts/python/netdev-times.py          |  26 +-
 tools/perf/scripts/python/sched-migration.py       |  41 +-
 tools/perf/scripts/python/sctop.py                 |   7 +-
 tools/perf/scripts/python/syscall-counts-by-pid.py |   7 +-
 tools/perf/scripts/python/syscall-counts.py        |   7 +-
 tools/perf/tests/attr/base-record                  |   3 +-
 tools/perf/tests/attr/base-stat                    |   3 +-
 tools/perf/tests/bp_signal.c                       |   4 +-
 tools/perf/tests/bp_signal_overflow.c              |   4 +-
 tools/perf/tests/dso-data.c                        |   1 +
 tools/perf/tests/evsel-roundtrip-name.c            |   1 +
 tools/perf/tests/evsel-tp-sched.c                  |   1 +
 tools/perf/tests/open-syscall-tp-fields.c          |   1 +
 tools/perf/tests/parse-events.c                    |   1 +
 tools/perf/tests/parse-no-sample-id-all.c          |   1 +
 tools/perf/tests/perf-time-to-tsc.c                |  12 +-
 tools/perf/tests/rdpmc.c                           |   4 +-
 tools/perf/tests/sample-parsing.c                  |   1 +
 tools/perf/tests/thread-mg-share.c                 |   1 +
 tools/perf/ui/browser.c                            |  39 +-
 tools/perf/ui/browser.h                            |   3 +-
 tools/perf/ui/browsers/hists.c                     | 153 ++++-
 tools/perf/ui/stdio/hist.c                         |   2 +-
 tools/perf/util/callchain.c                        |   2 +-
 tools/perf/util/callchain.h                        |  13 +
 tools/perf/util/cloexec.c                          |  57 ++
 tools/perf/util/cloexec.h                          |   6 +
 tools/perf/util/config.c                           |  13 +
 tools/perf/util/data.c                             |   3 +-
 tools/perf/util/debug.c                            |  56 +-
 tools/perf/util/debug.h                            |  22 +
 tools/perf/util/dso.c                              |  71 ++-
 tools/perf/util/dso.h                              |  26 +
 tools/perf/util/event.c                            |  52 +-
 tools/perf/util/event.h                            |  10 +
 tools/perf/util/evlist.c                           |  51 +-
 tools/perf/util/evsel.c                            |  26 +-
 tools/perf/util/evsel.h                            |   2 +
 tools/perf/util/header.c                           |  51 +-
 tools/perf/util/header.h                           |   2 +
 tools/perf/util/include/linux/kernel.h             |  21 -
 tools/perf/util/kvm-stat.h                         | 140 +++++
 tools/perf/util/machine.c                          | 139 ++++-
 tools/perf/util/machine.h                          |   8 +
 tools/perf/util/map.c                              |  47 +-
 tools/perf/util/map.h                              |  15 +-
 tools/perf/util/parse-options.h                    |   5 +
 tools/perf/util/probe-finder.c                     |   1 -
 tools/perf/util/pstack.c                           |   1 +
 tools/perf/util/python.c                           |   4 +-
 tools/perf/util/record.c                           |  27 +-
 .../perf/util/scripting-engines/trace-event-perl.c |   1 +
 .../util/scripting-engines/trace-event-python.c    | 197 +++++-
 tools/perf/util/session.c                          |  39 +-
 tools/perf/util/session.h                          |   3 +
 tools/perf/util/sort.c                             |   2 +-
 tools/perf/util/svghelper.c                        | 168 +++--
 tools/perf/util/svghelper.h                        |   6 +-
 tools/perf/util/symbol-elf.c                       |  41 +-
 tools/perf/util/symbol-minimal.c                   |  43 ++
 tools/perf/util/symbol.c                           |  21 +-
 tools/perf/util/symbol.h                           |   9 +-
 tools/perf/util/thread.c                           |  13 +-
 tools/perf/util/thread.h                           |   1 +
 tools/perf/util/trace-event-info.c                 |  13 +-
 tools/perf/util/trace-event-read.c                 |   2 +-
 tools/perf/util/tsc.c                              |  30 +
 tools/perf/util/tsc.h                              |  12 +
 tools/perf/util/unwind-libdw.c                     |   1 +
 tools/perf/util/unwind-libunwind.c                 |   1 +
 tools/perf/util/util.c                             |  10 +-
 tools/perf/util/vdso.c                             |  97 ++-
 tools/perf/util/vdso.h                             |  13 +-
 147 files changed, 3699 insertions(+), 941 deletions(-)
 create mode 100644 arch/s390/include/uapi/asm/kvm_perf.h
 create mode 100644 arch/x86/include/uapi/asm/kvm_perf.h
 create mode 100644 tools/perf/arch/powerpc/util/skip-callchain-idx.c
 create mode 100644 tools/perf/arch/s390/util/header.c
 create mode 100644 tools/perf/arch/s390/util/kvm-stat.c
 create mode 100644 tools/perf/arch/x86/util/kvm-stat.c
 create mode 100644 tools/perf/config/feature-checks/test-sync-compare-and-swap.c
 create mode 100644 tools/perf/util/cloexec.c
 create mode 100644 tools/perf/util/cloexec.h
 create mode 100644 tools/perf/util/kvm-stat.h
 create mode 100644 tools/perf/util/tsc.c
 create mode 100644 tools/perf/util/tsc.h

diff --git a/arch/arc/kernel/perf_event.c b/arch/arc/kernel/perf_event.c
index 63177e4..b9a5685 100644
--- a/arch/arc/kernel/perf_event.c
+++ b/arch/arc/kernel/perf_event.c
@@ -99,10 +99,6 @@ static int arc_pmu_event_init(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	int ret;
 
-	/* ARC 700 PMU does not support sampling events */
-	if (is_sampling_event(event))
-		return -ENOENT;
-
 	switch (event->attr.type) {
 	case PERF_TYPE_HARDWARE:
 		if (event->attr.config >= PERF_COUNT_HW_MAX)
@@ -298,6 +294,9 @@ static int arc_pmu_device_probe(struct platform_device *pdev)
 		.read		= arc_pmu_read,
 	};
 
+	/* ARC 700 PMU does not support sampling events */
+	arc_pmu->pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
+
 	ret = perf_pmu_register(&arc_pmu->pmu, pdev->name, PERF_TYPE_RAW);
 
 	return ret;
diff --git a/arch/blackfin/kernel/perf_event.c b/arch/blackfin/kernel/perf_event.c
index 974e554..ea20320 100644
--- a/arch/blackfin/kernel/perf_event.c
+++ b/arch/blackfin/kernel/perf_event.c
@@ -389,14 +389,6 @@ static int bfin_pmu_event_init(struct perf_event *event)
 	if (attr->exclude_hv || attr->exclude_idle)
 		return -EPERM;
 
-	/*
-	 * All of the on-chip counters are "limited", in that they have
-	 * no interrupts, and are therefore unable to do sampling without
-	 * further work and timer assistance.
-	 */
-	if (hwc->sample_period)
-		return -EINVAL;
-
 	ret = 0;
 	switch (attr->type) {
 	case PERF_TYPE_RAW:
@@ -490,6 +482,13 @@ static int __init bfin_pmu_init(void)
 {
 	int ret;
 
+	/*
+	 * All of the on-chip counters are "limited", in that they have
+	 * no interrupts, and are therefore unable to do sampling without
+	 * further work and timer assistance.
+	 */
+	pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
+
 	ret = perf_pmu_register(&pmu, "cpu", PERF_TYPE_RAW);
 	if (!ret)
 		perf_cpu_notifier(bfin_pmu_notifier);
diff --git a/arch/metag/kernel/perf/perf_event.c b/arch/metag/kernel/perf/perf_event.c
index 5cc4d4d..02c0873 100644
--- a/arch/metag/kernel/perf/perf_event.c
+++ b/arch/metag/kernel/perf/perf_event.c
@@ -568,16 +568,6 @@ static int _hw_perf_event_init(struct perf_event *event)
 		return -EINVAL;
 
 	/*
-	 * Early cores have "limited" counters - they have no overflow
-	 * interrupts - and so are unable to do sampling without extra work
-	 * and timer assistance.
-	 */
-	if (metag_pmu->max_period == 0) {
-		if (hwc->sample_period)
-			return -EINVAL;
-	}
-
-	/*
 	 * Don't assign an index until the event is placed into the hardware.
 	 * -1 signifies that we're still deciding where to put it. On SMP
 	 * systems each core has its own set of counters, so we can't do any
@@ -866,6 +856,15 @@ static int __init init_hw_perf_events(void)
 	pr_info("enabled with %s PMU driver, %d counters available\n",
 			metag_pmu->name, metag_pmu->max_events);
 
+	/*
+	 * Early cores have "limited" counters - they have no overflow
+	 * interrupts - and so are unable to do sampling without extra work
+	 * and timer assistance.
+	 */
+	if (metag_pmu->max_period == 0) {
+		metag_pmu->pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
+	}
+
 	/* Initialise the active events and reservation mutex */
 	atomic_set(&metag_pmu->active_events, 0);
 	mutex_init(&metag_pmu->reserve_mutex);
diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
index e0766b8..66d0f17 100644
--- a/arch/powerpc/perf/hv-24x7.c
+++ b/arch/powerpc/perf/hv-24x7.c
@@ -387,8 +387,7 @@ static int h_24x7_event_init(struct perf_event *event)
 	    event->attr.exclude_hv     ||
 	    event->attr.exclude_idle   ||
 	    event->attr.exclude_host   ||
-	    event->attr.exclude_guest  ||
-	    is_sampling_event(event)) /* no sampling */
+	    event->attr.exclude_guest)
 		return -EINVAL;
 
 	/* no branch sampling */
@@ -513,6 +512,9 @@ static int hv_24x7_init(void)
 	if (!hv_page_cache)
 		return -ENOMEM;
 
+	/* sampling not supported */
+	h_24x7_pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
+
 	r = perf_pmu_register(&h_24x7_pmu, h_24x7_pmu.name, -1);
 	if (r)
 		return r;
diff --git a/arch/powerpc/perf/hv-gpci.c b/arch/powerpc/perf/hv-gpci.c
index c9d399a..15fc76c 100644
--- a/arch/powerpc/perf/hv-gpci.c
+++ b/arch/powerpc/perf/hv-gpci.c
@@ -210,8 +210,7 @@ static int h_gpci_event_init(struct perf_event *event)
 	    event->attr.exclude_hv     ||
 	    event->attr.exclude_idle   ||
 	    event->attr.exclude_host   ||
-	    event->attr.exclude_guest  ||
-	    is_sampling_event(event)) /* no sampling */
+	    event->attr.exclude_guest)
 		return -EINVAL;
 
 	/* no branch sampling */
@@ -284,6 +283,9 @@ static int hv_gpci_init(void)
 		return -ENODEV;
 	}
 
+	/* sampling not supported */
+	h_gpci_pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
+
 	r = perf_pmu_register(&h_gpci_pmu, h_gpci_pmu.name, -1);
 	if (r)
 		return r;
diff --git a/arch/s390/include/uapi/asm/Kbuild b/arch/s390/include/uapi/asm/Kbuild
index 7366373..08fe6da 100644
--- a/arch/s390/include/uapi/asm/Kbuild
+++ b/arch/s390/include/uapi/asm/Kbuild
@@ -16,6 +16,7 @@ header-y += ioctls.h
 header-y += ipcbuf.h
 header-y += kvm.h
 header-y += kvm_para.h
+header-y += kvm_perf.h
 header-y += kvm_virtio.h
 header-y += mman.h
 header-y += monwriter.h
diff --git a/arch/s390/include/uapi/asm/kvm_perf.h b/arch/s390/include/uapi/asm/kvm_perf.h
new file mode 100644
index 0000000..3972827
--- /dev/null
+++ b/arch/s390/include/uapi/asm/kvm_perf.h
@@ -0,0 +1,25 @@
+/*
+ * Definitions for perf-kvm on s390
+ *
+ * Copyright 2014 IBM Corp.
+ * Author(s): Alexander Yarygin <yarygin@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2 only)
+ * as published by the Free Software Foundation.
+ */
+
+#ifndef __LINUX_KVM_PERF_S390_H
+#define __LINUX_KVM_PERF_S390_H
+
+#include <asm/sie.h>
+
+#define DECODE_STR_LEN 40
+
+#define VCPU_ID "id"
+
+#define KVM_ENTRY_TRACE "kvm:kvm_s390_sie_enter"
+#define KVM_EXIT_TRACE "kvm:kvm_s390_sie_exit"
+#define KVM_EXIT_REASON "icptcode"
+
+#endif
diff --git a/arch/s390/kernel/perf_cpum_cf.c b/arch/s390/kernel/perf_cpum_cf.c
index ea75d01..d3194de 100644
--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -411,12 +411,6 @@ static int cpumf_pmu_event_init(struct perf_event *event)
 	case PERF_TYPE_HARDWARE:
 	case PERF_TYPE_HW_CACHE:
 	case PERF_TYPE_RAW:
-		/* The CPU measurement counter facility does not have overflow
-		 * interrupts to do sampling.  Sampling must be provided by
-		 * external means, for example, by timers.
-		 */
-		if (is_sampling_event(event))
-			return -ENOENT;
 		err = __hw_perf_event_init(event);
 		break;
 	default:
@@ -681,6 +675,12 @@ static int __init cpumf_pmu_init(void)
 		goto out;
 	}
 
+	/* The CPU measurement counter facility does not have overflow
+	 * interrupts to do sampling.  Sampling must be provided by
+	 * external means, for example, by timers.
+	 */
+	cpumf_pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
+
 	cpumf_pmu.attr_groups = cpumf_cf_event_group();
 	rc = perf_pmu_register(&cpumf_pmu, "cpum_cf", PERF_TYPE_RAW);
 	if (rc) {
diff --git a/arch/sh/kernel/perf_event.c b/arch/sh/kernel/perf_event.c
index 0233167..7cfd7f1 100644
--- a/arch/sh/kernel/perf_event.c
+++ b/arch/sh/kernel/perf_event.c
@@ -129,14 +129,6 @@ static int __hw_perf_event_init(struct perf_event *event)
 		return -ENODEV;
 
 	/*
-	 * All of the on-chip counters are "limited", in that they have
-	 * no interrupts, and are therefore unable to do sampling without
-	 * further work and timer assistance.
-	 */
-	if (hwc->sample_period)
-		return -EINVAL;
-
-	/*
 	 * See if we need to reserve the counter.
 	 *
 	 * If no events are currently in use, then we have to take a
@@ -392,6 +384,13 @@ int register_sh_pmu(struct sh_pmu *_pmu)
 
 	pr_info("Performance Events: %s support registered\n", _pmu->name);
 
+	/*
+	 * All of the on-chip counters are "limited", in that they have
+	 * no interrupts, and are therefore unable to do sampling without
+	 * further work and timer assistance.
+	 */
+	pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
+
 	WARN_ON(_pmu->num_events > MAX_HWEVENTS);
 
 	perf_pmu_register(&pmu, "cpu", PERF_TYPE_RAW);
diff --git a/arch/x86/include/uapi/asm/Kbuild b/arch/x86/include/uapi/asm/Kbuild
index 09409c4..3dec769 100644
--- a/arch/x86/include/uapi/asm/Kbuild
+++ b/arch/x86/include/uapi/asm/Kbuild
@@ -22,6 +22,7 @@ header-y += ipcbuf.h
 header-y += ist.h
 header-y += kvm.h
 header-y += kvm_para.h
+header-y += kvm_perf.h
 header-y += ldt.h
 header-y += mce.h
 header-y += mman.h
diff --git a/arch/x86/include/uapi/asm/kvm_perf.h b/arch/x86/include/uapi/asm/kvm_perf.h
new file mode 100644
index 0000000..3bb964f
--- /dev/null
+++ b/arch/x86/include/uapi/asm/kvm_perf.h
@@ -0,0 +1,16 @@
+#ifndef _ASM_X86_KVM_PERF_H
+#define _ASM_X86_KVM_PERF_H
+
+#include <asm/svm.h>
+#include <asm/vmx.h>
+#include <asm/kvm.h>
+
+#define DECODE_STR_LEN 20
+
+#define VCPU_ID "vcpu_id"
+
+#define KVM_ENTRY_TRACE "kvm:kvm_entry"
+#define KVM_EXIT_TRACE "kvm:kvm_exit"
+#define KVM_EXIT_REASON "exit_reason"
+
+#endif /* _ASM_X86_KVM_PERF_H */
diff --git a/arch/x86/kernel/cpu/perf_event_amd_uncore.c b/arch/x86/kernel/cpu/perf_event_amd_uncore.c
index 3bbdf4c..30790d7 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_uncore.c
@@ -294,31 +294,41 @@ static struct amd_uncore *amd_uncore_alloc(unsigned int cpu)
 			cpu_to_node(cpu));
 }
 
-static void amd_uncore_cpu_up_prepare(unsigned int cpu)
+static int amd_uncore_cpu_up_prepare(unsigned int cpu)
 {
-	struct amd_uncore *uncore;
+	struct amd_uncore *uncore_nb = NULL, *uncore_l2;
 
 	if (amd_uncore_nb) {
-		uncore = amd_uncore_alloc(cpu);
-		uncore->cpu = cpu;
-		uncore->num_counters = NUM_COUNTERS_NB;
-		uncore->rdpmc_base = RDPMC_BASE_NB;
-		uncore->msr_base = MSR_F15H_NB_PERF_CTL;
-		uncore->active_mask = &amd_nb_active_mask;
-		uncore->pmu = &amd_nb_pmu;
-		*per_cpu_ptr(amd_uncore_nb, cpu) = uncore;
+		uncore_nb = amd_uncore_alloc(cpu);
+		if (!uncore_nb)
+			goto fail;
+		uncore_nb->cpu = cpu;
+		uncore_nb->num_counters = NUM_COUNTERS_NB;
+		uncore_nb->rdpmc_base = RDPMC_BASE_NB;
+		uncore_nb->msr_base = MSR_F15H_NB_PERF_CTL;
+		uncore_nb->active_mask = &amd_nb_active_mask;
+		uncore_nb->pmu = &amd_nb_pmu;
+		*per_cpu_ptr(amd_uncore_nb, cpu) = uncore_nb;
 	}
 
 	if (amd_uncore_l2) {
-		uncore = amd_uncore_alloc(cpu);
-		uncore->cpu = cpu;
-		uncore->num_counters = NUM_COUNTERS_L2;
-		uncore->rdpmc_base = RDPMC_BASE_L2;
-		uncore->msr_base = MSR_F16H_L2I_PERF_CTL;
-		uncore->active_mask = &amd_l2_active_mask;
-		uncore->pmu = &amd_l2_pmu;
-		*per_cpu_ptr(amd_uncore_l2, cpu) = uncore;
+		uncore_l2 = amd_uncore_alloc(cpu);
+		if (!uncore_l2)
+			goto fail;
+		uncore_l2->cpu = cpu;
+		uncore_l2->num_counters = NUM_COUNTERS_L2;
+		uncore_l2->rdpmc_base = RDPMC_BASE_L2;
+		uncore_l2->msr_base = MSR_F16H_L2I_PERF_CTL;
+		uncore_l2->active_mask = &amd_l2_active_mask;
+		uncore_l2->pmu = &amd_l2_pmu;
+		*per_cpu_ptr(amd_uncore_l2, cpu) = uncore_l2;
 	}
+
+	return 0;
+
+fail:
+	kfree(uncore_nb);
+	return -ENOMEM;
 }
 
 static struct amd_uncore *
@@ -441,7 +451,7 @@ static void uncore_dead(unsigned int cpu, struct amd_uncore * __percpu *uncores)
 
 	if (!--uncore->refcnt)
 		kfree(uncore);
-	*per_cpu_ptr(amd_uncore_nb, cpu) = NULL;
+	*per_cpu_ptr(uncores, cpu) = NULL;
 }
 
 static void amd_uncore_cpu_dead(unsigned int cpu)
@@ -461,7 +471,8 @@ amd_uncore_cpu_notifier(struct notifier_block *self, unsigned long action,
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-		amd_uncore_cpu_up_prepare(cpu);
+		if (amd_uncore_cpu_up_prepare(cpu))
+			return notifier_from_errno(-ENOMEM);
 		break;
 
 	case CPU_STARTING:
@@ -501,20 +512,33 @@ static void __init init_cpu_already_online(void *dummy)
 	amd_uncore_cpu_online(cpu);
 }
 
+static void cleanup_cpu_online(void *dummy)
+{
+	unsigned int cpu = smp_processor_id();
+
+	amd_uncore_cpu_dead(cpu);
+}
+
 static int __init amd_uncore_init(void)
 {
-	unsigned int cpu;
+	unsigned int cpu, cpu2;
 	int ret = -ENODEV;
 
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
-		return -ENODEV;
+		goto fail_nodev;
 
 	if (!cpu_has_topoext)
-		return -ENODEV;
+		goto fail_nodev;
 
 	if (cpu_has_perfctr_nb) {
 		amd_uncore_nb = alloc_percpu(struct amd_uncore *);
-		perf_pmu_register(&amd_nb_pmu, amd_nb_pmu.name, -1);
+		if (!amd_uncore_nb) {
+			ret = -ENOMEM;
+			goto fail_nb;
+		}
+		ret = perf_pmu_register(&amd_nb_pmu, amd_nb_pmu.name, -1);
+		if (ret)
+			goto fail_nb;
 
 		printk(KERN_INFO "perf: AMD NB counters detected\n");
 		ret = 0;
@@ -522,20 +546,28 @@ static int __init amd_uncore_init(void)
 
 	if (cpu_has_perfctr_l2) {
 		amd_uncore_l2 = alloc_percpu(struct amd_uncore *);
-		perf_pmu_register(&amd_l2_pmu, amd_l2_pmu.name, -1);
+		if (!amd_uncore_l2) {
+			ret = -ENOMEM;
+			goto fail_l2;
+		}
+		ret = perf_pmu_register(&amd_l2_pmu, amd_l2_pmu.name, -1);
+		if (ret)
+			goto fail_l2;
 
 		printk(KERN_INFO "perf: AMD L2I counters detected\n");
 		ret = 0;
 	}
 
 	if (ret)
-		return -ENODEV;
+		goto fail_nodev;
 
 	cpu_notifier_register_begin();
 
 	/* init cpus already online before registering for hotplug notifier */
 	for_each_online_cpu(cpu) {
-		amd_uncore_cpu_up_prepare(cpu);
+		ret = amd_uncore_cpu_up_prepare(cpu);
+		if (ret)
+			goto fail_online;
 		smp_call_function_single(cpu, init_cpu_already_online, NULL, 1);
 	}
 
@@ -543,5 +575,30 @@ static int __init amd_uncore_init(void)
 	cpu_notifier_register_done();
 
 	return 0;
+
+
+fail_online:
+	for_each_online_cpu(cpu2) {
+		if (cpu2 == cpu)
+			break;
+		smp_call_function_single(cpu, cleanup_cpu_online, NULL, 1);
+	}
+	cpu_notifier_register_done();
+
+	/* amd_uncore_nb/l2 should have been freed by cleanup_cpu_online */
+	amd_uncore_nb = amd_uncore_l2 = NULL;
+	if (cpu_has_perfctr_l2)
+		perf_pmu_unregister(&amd_l2_pmu);
+fail_l2:
+	if (cpu_has_perfctr_nb)
+		perf_pmu_unregister(&amd_nb_pmu);
+	if (amd_uncore_l2)
+		free_percpu(amd_uncore_l2);
+fail_nb:
+	if (amd_uncore_nb)
+		free_percpu(amd_uncore_nb);
+
+fail_nodev:
+	return ret;
 }
 device_initcall(amd_uncore_init);
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index ae6552a..cfc6f9d 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2947,10 +2947,7 @@ again:
 		 * extra registers. If we failed to take an extra
 		 * register, try the alternative.
 		 */
-		if (idx % 2)
-			idx--;
-		else
-			idx++;
+		idx ^= 1;
 		if (idx != reg1->idx % 6) {
 			if (idx == 2)
 				config1 >>= 8;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 6b17ac1..1cf24b3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5266,6 +5266,12 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 
 		goto got_name;
 	} else {
+		if (vma->vm_ops && vma->vm_ops->name) {
+			name = (char *) vma->vm_ops->name(vma);
+			if (name)
+				goto cpy_name;
+		}
+
 		name = (char *)arch_vma_name(vma);
 		if (name)
 			goto cpy_name;
@@ -7804,7 +7810,7 @@ inherit_task_group(struct perf_event *event, struct task_struct *parent,
 /*
  * Initialize the perf_event context in task_struct
  */
-int perf_event_init_context(struct task_struct *child, int ctxn)
+static int perf_event_init_context(struct task_struct *child, int ctxn)
 {
 	struct perf_event_context *child_ctx, *parent_ctx;
 	struct perf_event_context *cloned_ctx;
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 5d12bb4..4b9c114 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -30,6 +30,18 @@ static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
 			return ret;
 	}
 
+	/*
+	 * We checked and allowed to create parent,
+	 * allow children without checking.
+	 */
+	if (p_event->parent)
+		return 0;
+
+	/*
+	 * It's ok to check current process (owner) permissions in here,
+	 * because code below is called only via perf_event_open syscall.
+	 */
+
 	/* The ftrace function trace is allowed only for root. */
 	if (ftrace_event_is_function(tp_event)) {
 		if (perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 93825a1..cf3a44b 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2395,7 +2395,7 @@ process_flags(struct event_format *event, struct print_arg *arg, char **tok)
 {
 	struct print_arg *field;
 	enum event_type type;
-	char *token;
+	char *token = NULL;
 
 	memset(arg, 0, sizeof(*arg));
 	arg->type = PRINT_FLAGS;
@@ -2448,7 +2448,7 @@ process_symbols(struct event_format *event, struct print_arg *arg, char **tok)
 {
 	struct print_arg *field;
 	enum event_type type;
-	char *token;
+	char *token = NULL;
 
 	memset(arg, 0, sizeof(*arg));
 	arg->type = PRINT_SYMBOL;
@@ -2487,7 +2487,7 @@ process_hex(struct event_format *event, struct print_arg *arg, char **tok)
 {
 	struct print_arg *field;
 	enum event_type type;
-	char *token;
+	char *token = NULL;
 
 	memset(arg, 0, sizeof(*arg));
 	arg->type = PRINT_HEX;
diff --git a/tools/lib/traceevent/plugin_cfg80211.c b/tools/lib/traceevent/plugin_cfg80211.c
index c066b25..4592d84 100644
--- a/tools/lib/traceevent/plugin_cfg80211.c
+++ b/tools/lib/traceevent/plugin_cfg80211.c
@@ -5,8 +5,7 @@
 #include "event-parse.h"
 
 static unsigned long long
-process___le16_to_cpup(struct trace_seq *s,
-		       unsigned long long *args)
+process___le16_to_cpup(struct trace_seq *s, unsigned long long *args)
 {
 	uint16_t *val = (uint16_t *) (unsigned long) args[0];
 	return val ? (long long) le16toh(*val) : 0;
diff --git a/tools/lib/traceevent/plugin_jbd2.c b/tools/lib/traceevent/plugin_jbd2.c
index 0db714c..5c23d5b 100644
--- a/tools/lib/traceevent/plugin_jbd2.c
+++ b/tools/lib/traceevent/plugin_jbd2.c
@@ -30,8 +30,7 @@
 #define MINOR(dev)	((unsigned int) ((dev) & MINORMASK))
 
 static unsigned long long
-process_jbd2_dev_to_name(struct trace_seq *s,
-			 unsigned long long *args)
+process_jbd2_dev_to_name(struct trace_seq *s, unsigned long long *args)
 {
 	unsigned int dev = args[0];
 
@@ -40,8 +39,7 @@ process_jbd2_dev_to_name(struct trace_seq *s,
 }
 
 static unsigned long long
-process_jiffies_to_msecs(struct trace_seq *s,
-			 unsigned long long *args)
+process_jiffies_to_msecs(struct trace_seq *s, unsigned long long *args)
 {
 	unsigned long long jiffies = args[0];
 
diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugin_kvm.c
index 9e0e8c6..88fe83d 100644
--- a/tools/lib/traceevent/plugin_kvm.c
+++ b/tools/lib/traceevent/plugin_kvm.c
@@ -240,25 +240,38 @@ static const char *find_exit_reason(unsigned isa, int val)
 	for (i = 0; strings[i].val >= 0; i++)
 		if (strings[i].val == val)
 			break;
-	if (strings[i].str)
-		return strings[i].str;
-	return "UNKNOWN";
+
+	return strings[i].str;
 }
 
-static int kvm_exit_handler(struct trace_seq *s, struct pevent_record *record,
-			    struct event_format *event, void *context)
+static int print_exit_reason(struct trace_seq *s, struct pevent_record *record,
+			     struct event_format *event, const char *field)
 {
 	unsigned long long isa;
 	unsigned long long val;
-	unsigned long long info1 = 0, info2 = 0;
+	const char *reason;
 
-	if (pevent_get_field_val(s, event, "exit_reason", record, &val, 1) < 0)
+	if (pevent_get_field_val(s, event, field, record, &val, 1) < 0)
 		return -1;
 
 	if (pevent_get_field_val(s, event, "isa", record, &isa, 0) < 0)
 		isa = 1;
 
-	trace_seq_printf(s, "reason %s", find_exit_reason(isa, val));
+	reason = find_exit_reason(isa, val);
+	if (reason)
+		trace_seq_printf(s, "reason %s", reason);
+	else
+		trace_seq_printf(s, "reason UNKNOWN (%llu)", val);
+	return 0;
+}
+
+static int kvm_exit_handler(struct trace_seq *s, struct pevent_record *record,
+			    struct event_format *event, void *context)
+{
+	unsigned long long info1 = 0, info2 = 0;
+
+	if (print_exit_reason(s, record, event, "exit_reason") < 0)
+		return -1;
 
 	pevent_print_num_field(s, " rip 0x%lx", event, "guest_rip", record, 1);
 
@@ -313,6 +326,29 @@ static int kvm_emulate_insn_handler(struct trace_seq *s,
 	return 0;
 }
 
+
+static int kvm_nested_vmexit_inject_handler(struct trace_seq *s, struct pevent_record *record,
+					    struct event_format *event, void *context)
+{
+	if (print_exit_reason(s, record, event, "exit_code") < 0)
+		return -1;
+
+	pevent_print_num_field(s, " info1 %llx", event, "exit_info1", record, 1);
+	pevent_print_num_field(s, " info2 %llx", event, "exit_info2", record, 1);
+	pevent_print_num_field(s, " int_info %llx", event, "exit_int_info", record, 1);
+	pevent_print_num_field(s, " int_info_err %llx", event, "exit_int_info_err", record, 1);
+
+	return 0;
+}
+
+static int kvm_nested_vmexit_handler(struct trace_seq *s, struct pevent_record *record,
+				     struct event_format *event, void *context)
+{
+	pevent_print_num_field(s, "rip %llx ", event, "rip", record, 1);
+
+	return kvm_nested_vmexit_inject_handler(s, record, event, context);
+}
+
 union kvm_mmu_page_role {
 	unsigned word;
 	struct {
@@ -409,6 +445,12 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
 	pevent_register_event_handler(pevent, -1, "kvm", "kvm_emulate_insn",
 				      kvm_emulate_insn_handler, NULL);
 
+	pevent_register_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit",
+				      kvm_nested_vmexit_handler, NULL);
+
+	pevent_register_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit_inject",
+				      kvm_nested_vmexit_inject_handler, NULL);
+
 	pevent_register_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_get_page",
 				      kvm_mmu_get_page_handler, NULL);
 
@@ -443,6 +485,12 @@ void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
 	pevent_unregister_event_handler(pevent, -1, "kvm", "kvm_emulate_insn",
 					kvm_emulate_insn_handler, NULL);
 
+	pevent_unregister_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit",
+					kvm_nested_vmexit_handler, NULL);
+
+	pevent_unregister_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit_inject",
+					kvm_nested_vmexit_inject_handler, NULL);
+
 	pevent_unregister_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_get_page",
 					kvm_mmu_get_page_handler, NULL);
 
diff --git a/tools/perf/Documentation/perf-bench.txt b/tools/perf/Documentation/perf-bench.txt
index 4464ad7..f6480cb 100644
--- a/tools/perf/Documentation/perf-bench.txt
+++ b/tools/perf/Documentation/perf-bench.txt
@@ -16,6 +16,10 @@ This 'perf bench' command is a general framework for benchmark suites.
 
 COMMON OPTIONS
 --------------
+-r::
+--repeat=::
+Specify amount of times to repeat the run (default 10).
+
 -f::
 --format=::
 Specify format style.
diff --git a/tools/perf/Documentation/perf-inject.txt b/tools/perf/Documentation/perf-inject.txt
index a00a342..dc7442c 100644
--- a/tools/perf/Documentation/perf-inject.txt
+++ b/tools/perf/Documentation/perf-inject.txt
@@ -41,6 +41,9 @@ OPTIONS
 	tasks slept. sched_switch contains a callchain where a task slept and
 	sched_stat contains a timeslice how long a task slept.
 
+--kallsyms=<file>::
+	kallsyms pathname
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-report[1], linkperf:perf-archive[1]
diff --git a/tools/perf/Documentation/perf-kvm.txt b/tools/perf/Documentation/perf-kvm.txt
index 52276a6..6e689dc 100644
--- a/tools/perf/Documentation/perf-kvm.txt
+++ b/tools/perf/Documentation/perf-kvm.txt
@@ -51,9 +51,9 @@ There are a couple of variants of perf kvm:
   'perf kvm stat <command>' to run a command and gather performance counter
   statistics.
   Especially, perf 'kvm stat record/report' generates a statistical analysis
-  of KVM events. Currently, vmexit, mmio and ioport events are supported.
-  'perf kvm stat record <command>' records kvm events and the events between
-  start and end <command>.
+  of KVM events. Currently, vmexit, mmio (x86 only) and ioport (x86 only)
+  events are supported. 'perf kvm stat record <command>' records kvm events
+  and the events between start and end <command>.
   And this command produces a file which contains tracing results of kvm
   events.
 
@@ -103,8 +103,8 @@ STAT REPORT OPTIONS
        analyze events which occures on this vcpu. (default: all vcpus)
 
 --event=<value>::
-       event to be analyzed. Possible values: vmexit, mmio, ioport.
-       (default: vmexit)
+       event to be analyzed. Possible values: vmexit, mmio (x86 only),
+       ioport (x86 only). (default: vmexit)
 -k::
 --key=<value>::
        Sorting key. Possible values: sample (default, sort by samples
@@ -138,7 +138,8 @@ STAT LIVE OPTIONS
 
 
 --event=<value>::
-       event to be analyzed. Possible values: vmexit, mmio, ioport.
+       event to be analyzed. Possible values: vmexit,
+       mmio (x86 only), ioport (x86 only).
        (default: vmexit)
 
 -k::
@@ -147,7 +148,8 @@ STAT LIVE OPTIONS
        number), time (sort by average time).
 
 --duration=<value>::
-       Show events other than HLT that take longer than duration usecs.
+       Show events other than HLT (x86 only) or Wait state (s390 only)
+       that take longer than duration usecs.
 
 SEE ALSO
 --------
diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
index 5e0f986..df98d1c 100644
--- a/tools/perf/Documentation/perf-timechart.txt
+++ b/tools/perf/Documentation/perf-timechart.txt
@@ -15,10 +15,20 @@ DESCRIPTION
 There are two variants of perf timechart:
 
   'perf timechart record <command>' to record the system level events
-  of an arbitrary workload.
+  of an arbitrary workload. By default timechart records only scheduler
+  and CPU events (task switches, running times, CPU power states, etc),
+  but it's possible to record IO (disk, network) activity using -I argument.
 
   'perf timechart' to turn a trace into a Scalable Vector Graphics file,
-  that can be viewed with popular SVG viewers such as 'Inkscape'.
+  that can be viewed with popular SVG viewers such as 'Inkscape'. Depending
+  on the events in the perf.data file, timechart will contain scheduler/cpu
+  events or IO events.
+
+  In IO mode, every bar has two charts: upper and lower.
+  Upper bar shows incoming events (disk reads, ingress network packets).
+  Lower bar shows outgoing events (disk writes, egress network packets).
+  There are also poll bars which show how much time application spent
+  in poll/epoll/select syscalls.
 
 TIMECHART OPTIONS
 -----------------
@@ -54,6 +64,19 @@ TIMECHART OPTIONS
 	duration or tasks with given name. If number is given it's interpreted
 	as number of nanoseconds. If non-numeric string is given it's
 	interpreted as task name.
+--io-skip-eagain::
+	Don't draw EAGAIN IO events.
+--io-min-time=<nsecs>::
+	Draw small events as if they lasted min-time. Useful when you need
+	to see very small and fast IO. It's possible to specify ms or us
+	suffix to specify time in milliseconds or microseconds.
+	Default value is 1ms.
+--io-merge-dist=<nsecs>::
+	Merge events that are merge-dist nanoseconds apart.
+	Reduces number of figures on the SVG and makes it more render-friendly.
+	It's possible to specify ms or us suffix to specify time in
+	milliseconds or microseconds.
+	Default value is 1us.
 
 RECORD OPTIONS
 --------------
@@ -63,6 +86,9 @@ RECORD OPTIONS
 -T::
 --tasks-only::
         Record only tasks-related events
+-I::
+--io-only::
+        Record only io-related events
 -g::
 --callchain::
         Do call-graph (stack chain/backtrace) recording
@@ -87,6 +113,14 @@ Record system-wide timechart:
 
   $ perf timechart --highlight gcc
 
+Record system-wide IO events:
+
+  $ perf timechart record -I
+
+  then generate timechart:
+
+  $ perf timechart
+
 SEE ALSO
 --------
 linkperf:perf-record[1]
diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index fae38d9..02aac83 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -107,6 +107,52 @@ the thread executes on the designated CPUs. Default is to monitor all CPUs.
 	Show tool stats such as number of times fd->pathname was discovered thru
 	hooking the open syscall return + vfs_getname or via reading /proc/pid/fd, etc.
 
+-F=[all|min|maj]::
+--pf=[all|min|maj]::
+	Trace pagefaults. Optionally, you can specify whether you want minor,
+	major or all pagefaults. Default value is maj.
+
+--syscalls::
+	Trace system calls. This options is enabled by default.
+
+PAGEFAULTS
+----------
+
+When tracing pagefaults, the format of the trace is as follows:
+
+<min|maj>fault [<ip.symbol>+<ip.offset>] => <addr.dso@addr.offset> (<map type><addr level>).
+
+- min/maj indicates whether fault event is minor or major;
+- ip.symbol shows symbol for instruction pointer (the code that generated the
+  fault); if no debug symbols available, perf trace will print raw IP;
+- addr.dso shows DSO for the faulted address;
+- map type is either 'd' for non-executable maps or 'x' for executable maps;
+- addr level is either 'k' for kernel dso or '.' for user dso.
+
+For symbols resolution you may need to install debugging symbols.
+
+Please be aware that duration is currently always 0 and doesn't reflect actual
+time it took for fault to be handled!
+
+When --verbose specified, perf trace tries to print all available information
+for both IP and fault address in the form of dso@symbol+offset.
+
+EXAMPLES
+--------
+
+Trace only major pagefaults:
+
+ $ perf trace --no-syscalls -F
+
+Trace syscalls, major and minor pagefaults:
+
+ $ perf trace -F all
+
+  1416.547 ( 0.000 ms): python/20235 majfault [CRYPTO_push_info_+0x0] => /lib/x86_64-linux-gnu/libcrypto.so.1.0.0@0x61be0 (x.)
+
+  As you can see, there was major pagefault in python process, from
+  CRYPTO_push_info_ routine which faulted somewhere in libcrypto.so.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script[1]
diff --git a/tools/perf/Documentation/perf.txt b/tools/perf/Documentation/perf.txt
index 0eeb247..d240bb2 100644
--- a/tools/perf/Documentation/perf.txt
+++ b/tools/perf/Documentation/perf.txt
@@ -8,7 +8,15 @@ perf - Performance analysis tools for Linux
 SYNOPSIS
 --------
 [verse]
-'perf' [--version] [--help] COMMAND [ARGS]
+'perf' [--version] [--help] [OPTIONS] COMMAND [ARGS]
+
+OPTIONS
+-------
+--debug::
+	Setup debug variable (just verbose for now) in value
+	range (0, 10). Use like:
+	  --debug verbose   # sets verbose = 1
+	  --debug verbose=2 # sets verbose = 2
 
 DESCRIPTION
 -----------
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 45da209..344c4d3 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -37,3 +37,6 @@ arch/x86/include/asm/kvm_host.h
 arch/x86/include/uapi/asm/svm.h
 arch/x86/include/uapi/asm/vmx.h
 arch/x86/include/uapi/asm/kvm.h
+arch/x86/include/uapi/asm/kvm_perf.h
+arch/s390/include/uapi/asm/sie.h
+arch/s390/include/uapi/asm/kvm_perf.h
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 9670a16..2240974 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -295,11 +295,13 @@ LIB_H += util/intlist.h
 LIB_H += util/perf_regs.h
 LIB_H += util/unwind.h
 LIB_H += util/vdso.h
+LIB_H += util/tsc.h
 LIB_H += ui/helpline.h
 LIB_H += ui/progress.h
 LIB_H += ui/util.h
 LIB_H += ui/ui.h
 LIB_H += util/data.h
+LIB_H += util/kvm-stat.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -373,6 +375,8 @@ LIB_OBJS += $(OUTPUT)util/stat.o
 LIB_OBJS += $(OUTPUT)util/record.o
 LIB_OBJS += $(OUTPUT)util/srcline.o
 LIB_OBJS += $(OUTPUT)util/data.o
+LIB_OBJS += $(OUTPUT)util/tsc.o
+LIB_OBJS += $(OUTPUT)util/cloexec.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
diff --git a/tools/perf/arch/powerpc/Makefile b/tools/perf/arch/powerpc/Makefile
index 744e629..b92219b 100644
--- a/tools/perf/arch/powerpc/Makefile
+++ b/tools/perf/arch/powerpc/Makefile
@@ -3,3 +3,4 @@ PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/skip-callchain-idx.o
diff --git a/tools/perf/arch/powerpc/util/header.c b/tools/perf/arch/powerpc/util/header.c
index 2f7073d..6c1b8a7 100644
--- a/tools/perf/arch/powerpc/util/header.c
+++ b/tools/perf/arch/powerpc/util/header.c
@@ -5,9 +5,7 @@
 #include <string.h>
 
 #include "../../util/header.h"
-
-#define __stringify_1(x)        #x
-#define __stringify(x)          __stringify_1(x)
+#include "../../util/util.h"
 
 #define mfspr(rn)       ({unsigned long rval; \
 			 asm volatile("mfspr %0," __stringify(rn) \
diff --git a/tools/perf/arch/powerpc/util/skip-callchain-idx.c b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
new file mode 100644
index 0000000..a7c23a4
--- /dev/null
+++ b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
@@ -0,0 +1,266 @@
+/*
+ * Use DWARF Debug information to skip unnecessary callchain entries.
+ *
+ * Copyright (C) 2014 Sukadev Bhattiprolu, IBM Corporation.
+ * Copyright (C) 2014 Ulrich Weigand, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <inttypes.h>
+#include <dwarf.h>
+#include <elfutils/libdwfl.h>
+
+#include "util/thread.h"
+#include "util/callchain.h"
+
+/*
+ * When saving the callchain on Power, the kernel conservatively saves
+ * excess entries in the callchain. A few of these entries are needed
+ * in some cases but not others. If the unnecessary entries are not
+ * ignored, we end up with duplicate arcs in the call-graphs. Use
+ * DWARF debug information to skip over any unnecessary callchain
+ * entries.
+ *
+ * See function header for arch_adjust_callchain() below for more details.
+ *
+ * The libdwfl code in this file is based on code from elfutils
+ * (libdwfl/argp-std.c, libdwfl/tests/addrcfi.c, etc).
+ */
+static char *debuginfo_path;
+
+static const Dwfl_Callbacks offline_callbacks = {
+	.debuginfo_path = &debuginfo_path,
+	.find_debuginfo = dwfl_standard_find_debuginfo,
+	.section_address = dwfl_offline_section_address,
+};
+
+
+/*
+ * Use the DWARF expression for the Call-frame-address and determine
+ * if return address is in LR and if a new frame was allocated.
+ */
+static int check_return_reg(int ra_regno, Dwarf_Frame *frame)
+{
+	Dwarf_Op ops_mem[2];
+	Dwarf_Op dummy;
+	Dwarf_Op *ops = &dummy;
+	size_t nops;
+	int result;
+
+	result = dwarf_frame_register(frame, ra_regno, ops_mem, &ops, &nops);
+	if (result < 0) {
+		pr_debug("dwarf_frame_register() %s\n", dwarf_errmsg(-1));
+		return -1;
+	}
+
+	/*
+	 * Check if return address is on the stack.
+	 */
+	if (nops != 0 || ops != NULL)
+		return 0;
+
+	/*
+	 * Return address is in LR. Check if a frame was allocated
+	 * but not-yet used.
+	 */
+	result = dwarf_frame_cfa(frame, &ops, &nops);
+	if (result < 0) {
+		pr_debug("dwarf_frame_cfa() returns %d, %s\n", result,
+					dwarf_errmsg(-1));
+		return -1;
+	}
+
+	/*
+	 * If call frame address is in r1, no new frame was allocated.
+	 */
+	if (nops == 1 && ops[0].atom == DW_OP_bregx && ops[0].number == 1 &&
+				ops[0].number2 == 0)
+		return 1;
+
+	/*
+	 * A new frame was allocated but has not yet been used.
+	 */
+	return 2;
+}
+
+/*
+ * Get the DWARF frame from the .eh_frame section.
+ */
+static Dwarf_Frame *get_eh_frame(Dwfl_Module *mod, Dwarf_Addr pc)
+{
+	int		result;
+	Dwarf_Addr	bias;
+	Dwarf_CFI	*cfi;
+	Dwarf_Frame	*frame;
+
+	cfi = dwfl_module_eh_cfi(mod, &bias);
+	if (!cfi) {
+		pr_debug("%s(): no CFI - %s\n", __func__, dwfl_errmsg(-1));
+		return NULL;
+	}
+
+	result = dwarf_cfi_addrframe(cfi, pc, &frame);
+	if (result) {
+		pr_debug("%s(): %s\n", __func__, dwfl_errmsg(-1));
+		return NULL;
+	}
+
+	return frame;
+}
+
+/*
+ * Get the DWARF frame from the .debug_frame section.
+ */
+static Dwarf_Frame *get_dwarf_frame(Dwfl_Module *mod, Dwarf_Addr pc)
+{
+	Dwarf_CFI       *cfi;
+	Dwarf_Addr      bias;
+	Dwarf_Frame     *frame;
+	int             result;
+
+	cfi = dwfl_module_dwarf_cfi(mod, &bias);
+	if (!cfi) {
+		pr_debug("%s(): no CFI - %s\n", __func__, dwfl_errmsg(-1));
+		return NULL;
+	}
+
+	result = dwarf_cfi_addrframe(cfi, pc, &frame);
+	if (result) {
+		pr_debug("%s(): %s\n", __func__, dwfl_errmsg(-1));
+		return NULL;
+	}
+
+	return frame;
+}
+
+/*
+ * Return:
+ *	0 if return address for the program counter @pc is on stack
+ *	1 if return address is in LR and no new stack frame was allocated
+ *	2 if return address is in LR and a new frame was allocated (but not
+ *		yet used)
+ *	-1 in case of errors
+ */
+static int check_return_addr(const char *exec_file, Dwarf_Addr pc)
+{
+	int		rc = -1;
+	Dwfl		*dwfl;
+	Dwfl_Module	*mod;
+	Dwarf_Frame	*frame;
+	int		ra_regno;
+	Dwarf_Addr	start = pc;
+	Dwarf_Addr	end = pc;
+	bool		signalp;
+
+	dwfl = dwfl_begin(&offline_callbacks);
+	if (!dwfl) {
+		pr_debug("dwfl_begin() failed: %s\n", dwarf_errmsg(-1));
+		return -1;
+	}
+
+	if (dwfl_report_offline(dwfl, "",  exec_file, -1) == NULL) {
+		pr_debug("dwfl_report_offline() failed %s\n", dwarf_errmsg(-1));
+		goto out;
+	}
+
+	mod = dwfl_addrmodule(dwfl, pc);
+	if (!mod) {
+		pr_debug("dwfl_addrmodule() failed, %s\n", dwarf_errmsg(-1));
+		goto out;
+	}
+
+	/*
+	 * To work with split debug info files (eg: glibc), check both
+	 * .eh_frame and .debug_frame sections of the ELF header.
+	 */
+	frame = get_eh_frame(mod, pc);
+	if (!frame) {
+		frame = get_dwarf_frame(mod, pc);
+		if (!frame)
+			goto out;
+	}
+
+	ra_regno = dwarf_frame_info(frame, &start, &end, &signalp);
+	if (ra_regno < 0) {
+		pr_debug("Return address register unavailable: %s\n",
+				dwarf_errmsg(-1));
+		goto out;
+	}
+
+	rc = check_return_reg(ra_regno, frame);
+
+out:
+	dwfl_end(dwfl);
+	return rc;
+}
+
+/*
+ * The callchain saved by the kernel always includes the link register (LR).
+ *
+ *	0:	PERF_CONTEXT_USER
+ *	1:	Program counter (Next instruction pointer)
+ *	2:	LR value
+ *	3:	Caller's caller
+ *	4:	...
+ *
+ * The value in LR is only needed when it holds a return address. If the
+ * return address is on the stack, we should ignore the LR value.
+ *
+ * Further, when the return address is in the LR, if a new frame was just
+ * allocated but the LR was not saved into it, then the LR contains the
+ * caller, slot 4: contains the caller's caller and the contents of slot 3:
+ * (chain->ips[3]) is undefined and must be ignored.
+ *
+ * Use DWARF debug information to determine if any entries need to be skipped.
+ *
+ * Return:
+ *	index:	of callchain entry that needs to be ignored (if any)
+ *	-1	if no entry needs to be ignored or in case of errors
+ */
+int arch_skip_callchain_idx(struct machine *machine, struct thread *thread,
+				struct ip_callchain *chain)
+{
+	struct addr_location al;
+	struct dso *dso = NULL;
+	int rc;
+	u64 ip;
+	u64 skip_slot = -1;
+
+	if (chain->nr < 3)
+		return skip_slot;
+
+	ip = chain->ips[2];
+
+	thread__find_addr_location(thread, machine, PERF_RECORD_MISC_USER,
+			MAP__FUNCTION, ip, &al);
+
+	if (al.map)
+		dso = al.map->dso;
+
+	if (!dso) {
+		pr_debug("%" PRIx64 " dso is NULL\n", ip);
+		return skip_slot;
+	}
+
+	rc = check_return_addr(dso->long_name, ip);
+
+	pr_debug("DSO %s, nr %" PRIx64 ", ip 0x%" PRIx64 "rc %d\n",
+				dso->long_name, chain->nr, ip, rc);
+
+	if (rc == 0) {
+		/*
+		 * Return address on stack. Ignore LR value in callchain
+		 */
+		skip_slot = 2;
+	} else if (rc == 2) {
+		/*
+		 * New frame allocated but return address still in LR.
+		 * Ignore the caller's caller entry in callchain.
+		 */
+		skip_slot = 3;
+	}
+	return skip_slot;
+}
diff --git a/tools/perf/arch/s390/Makefile b/tools/perf/arch/s390/Makefile
index 15130b5..798ac73 100644
--- a/tools/perf/arch/s390/Makefile
+++ b/tools/perf/arch/s390/Makefile
@@ -2,3 +2,6 @@ ifndef NO_DWARF
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
+HAVE_KVM_STAT_SUPPORT := 1
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/kvm-stat.o
diff --git a/tools/perf/arch/s390/util/header.c b/tools/perf/arch/s390/util/header.c
new file mode 100644
index 0000000..9fa6c3e
--- /dev/null
+++ b/tools/perf/arch/s390/util/header.c
@@ -0,0 +1,28 @@
+/*
+ * Implementation of get_cpuid().
+ *
+ * Copyright 2014 IBM Corp.
+ * Author(s): Alexander Yarygin <yarygin@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2 only)
+ * as published by the Free Software Foundation.
+ */
+
+#include <sys/types.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <string.h>
+
+#include "../../util/header.h"
+
+int get_cpuid(char *buffer, size_t sz)
+{
+	const char *cpuid = "IBM/S390";
+
+	if (strlen(cpuid) + 1 > sz)
+		return -1;
+
+	strcpy(buffer, cpuid);
+	return 0;
+}
diff --git a/tools/perf/arch/s390/util/kvm-stat.c b/tools/perf/arch/s390/util/kvm-stat.c
new file mode 100644
index 0000000..a5dbc07
--- /dev/null
+++ b/tools/perf/arch/s390/util/kvm-stat.c
@@ -0,0 +1,105 @@
+/*
+ * Arch specific functions for perf kvm stat.
+ *
+ * Copyright 2014 IBM Corp.
+ * Author(s): Alexander Yarygin <yarygin@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2 only)
+ * as published by the Free Software Foundation.
+ */
+
+#include "../../util/kvm-stat.h"
+#include <asm/kvm_perf.h>
+
+define_exit_reasons_table(sie_exit_reasons, sie_intercept_code);
+define_exit_reasons_table(sie_icpt_insn_codes, icpt_insn_codes);
+define_exit_reasons_table(sie_sigp_order_codes, sigp_order_codes);
+define_exit_reasons_table(sie_diagnose_codes, diagnose_codes);
+define_exit_reasons_table(sie_icpt_prog_codes, icpt_prog_codes);
+
+static void event_icpt_insn_get_key(struct perf_evsel *evsel,
+				    struct perf_sample *sample,
+				    struct event_key *key)
+{
+	unsigned long insn;
+
+	insn = perf_evsel__intval(evsel, sample, "instruction");
+	key->key = icpt_insn_decoder(insn);
+	key->exit_reasons = sie_icpt_insn_codes;
+}
+
+static void event_sigp_get_key(struct perf_evsel *evsel,
+			       struct perf_sample *sample,
+			       struct event_key *key)
+{
+	key->key = perf_evsel__intval(evsel, sample, "order_code");
+	key->exit_reasons = sie_sigp_order_codes;
+}
+
+static void event_diag_get_key(struct perf_evsel *evsel,
+			       struct perf_sample *sample,
+			       struct event_key *key)
+{
+	key->key = perf_evsel__intval(evsel, sample, "code");
+	key->exit_reasons = sie_diagnose_codes;
+}
+
+static void event_icpt_prog_get_key(struct perf_evsel *evsel,
+				    struct perf_sample *sample,
+				    struct event_key *key)
+{
+	key->key = perf_evsel__intval(evsel, sample, "code");
+	key->exit_reasons = sie_icpt_prog_codes;
+}
+
+static struct child_event_ops child_events[] = {
+	{ .name = "kvm:kvm_s390_intercept_instruction",
+	  .get_key = event_icpt_insn_get_key },
+	{ .name = "kvm:kvm_s390_handle_sigp",
+	  .get_key = event_sigp_get_key },
+	{ .name = "kvm:kvm_s390_handle_diag",
+	  .get_key = event_diag_get_key },
+	{ .name = "kvm:kvm_s390_intercept_prog",
+	  .get_key = event_icpt_prog_get_key },
+	{ NULL, NULL },
+};
+
+static struct kvm_events_ops exit_events = {
+	.is_begin_event = exit_event_begin,
+	.is_end_event = exit_event_end,
+	.child_ops = child_events,
+	.decode_key = exit_event_decode_key,
+	.name = "VM-EXIT"
+};
+
+const char * const kvm_events_tp[] = {
+	"kvm:kvm_s390_sie_enter",
+	"kvm:kvm_s390_sie_exit",
+	"kvm:kvm_s390_intercept_instruction",
+	"kvm:kvm_s390_handle_sigp",
+	"kvm:kvm_s390_handle_diag",
+	"kvm:kvm_s390_intercept_prog",
+	NULL,
+};
+
+struct kvm_reg_events_ops kvm_reg_events_ops[] = {
+	{ .name = "vmexit", .ops = &exit_events },
+	{ NULL, NULL },
+};
+
+const char * const kvm_skip_events[] = {
+	"Wait state",
+	NULL,
+};
+
+int cpu_isa_init(struct perf_kvm_stat *kvm, const char *cpuid)
+{
+	if (strstr(cpuid, "IBM/S390")) {
+		kvm->exit_reasons = sie_exit_reasons;
+		kvm->exit_reasons_isa = "SIE";
+	} else
+		return -ENOTSUP;
+
+	return 0;
+}
diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index 1641542..9b21881 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -15,3 +15,5 @@ endif
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/tsc.o
 LIB_H += arch/$(ARCH)/util/tsc.h
+HAVE_KVM_STAT_SUPPORT := 1
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/kvm-stat.o
diff --git a/tools/perf/arch/x86/tests/dwarf-unwind.c b/tools/perf/arch/x86/tests/dwarf-unwind.c
index 9f89f89..d8bbf7a 100644
--- a/tools/perf/arch/x86/tests/dwarf-unwind.c
+++ b/tools/perf/arch/x86/tests/dwarf-unwind.c
@@ -3,6 +3,7 @@
 #include "thread.h"
 #include "map.h"
 #include "event.h"
+#include "debug.h"
 #include "tests/tests.h"
 
 #define STACK_SIZE 8192
diff --git a/tools/perf/arch/x86/util/kvm-stat.c b/tools/perf/arch/x86/util/kvm-stat.c
new file mode 100644
index 0000000..14e4e66
--- /dev/null
+++ b/tools/perf/arch/x86/util/kvm-stat.c
@@ -0,0 +1,156 @@
+#include "../../util/kvm-stat.h"
+#include <asm/kvm_perf.h>
+
+define_exit_reasons_table(vmx_exit_reasons, VMX_EXIT_REASONS);
+define_exit_reasons_table(svm_exit_reasons, SVM_EXIT_REASONS);
+
+static struct kvm_events_ops exit_events = {
+	.is_begin_event = exit_event_begin,
+	.is_end_event = exit_event_end,
+	.decode_key = exit_event_decode_key,
+	.name = "VM-EXIT"
+};
+
+/*
+ * For the mmio events, we treat:
+ * the time of MMIO write: kvm_mmio(KVM_TRACE_MMIO_WRITE...) -> kvm_entry
+ * the time of MMIO read: kvm_exit -> kvm_mmio(KVM_TRACE_MMIO_READ...).
+ */
+static void mmio_event_get_key(struct perf_evsel *evsel, struct perf_sample *sample,
+			       struct event_key *key)
+{
+	key->key  = perf_evsel__intval(evsel, sample, "gpa");
+	key->info = perf_evsel__intval(evsel, sample, "type");
+}
+
+#define KVM_TRACE_MMIO_READ_UNSATISFIED 0
+#define KVM_TRACE_MMIO_READ 1
+#define KVM_TRACE_MMIO_WRITE 2
+
+static bool mmio_event_begin(struct perf_evsel *evsel,
+			     struct perf_sample *sample, struct event_key *key)
+{
+	/* MMIO read begin event in kernel. */
+	if (kvm_exit_event(evsel))
+		return true;
+
+	/* MMIO write begin event in kernel. */
+	if (!strcmp(evsel->name, "kvm:kvm_mmio") &&
+	    perf_evsel__intval(evsel, sample, "type") == KVM_TRACE_MMIO_WRITE) {
+		mmio_event_get_key(evsel, sample, key);
+		return true;
+	}
+
+	return false;
+}
+
+static bool mmio_event_end(struct perf_evsel *evsel, struct perf_sample *sample,
+			   struct event_key *key)
+{
+	/* MMIO write end event in kernel. */
+	if (kvm_entry_event(evsel))
+		return true;
+
+	/* MMIO read end event in kernel.*/
+	if (!strcmp(evsel->name, "kvm:kvm_mmio") &&
+	    perf_evsel__intval(evsel, sample, "type") == KVM_TRACE_MMIO_READ) {
+		mmio_event_get_key(evsel, sample, key);
+		return true;
+	}
+
+	return false;
+}
+
+static void mmio_event_decode_key(struct perf_kvm_stat *kvm __maybe_unused,
+				  struct event_key *key,
+				  char *decode)
+{
+	scnprintf(decode, DECODE_STR_LEN, "%#lx:%s",
+		  (unsigned long)key->key,
+		  key->info == KVM_TRACE_MMIO_WRITE ? "W" : "R");
+}
+
+static struct kvm_events_ops mmio_events = {
+	.is_begin_event = mmio_event_begin,
+	.is_end_event = mmio_event_end,
+	.decode_key = mmio_event_decode_key,
+	.name = "MMIO Access"
+};
+
+ /* The time of emulation pio access is from kvm_pio to kvm_entry. */
+static void ioport_event_get_key(struct perf_evsel *evsel,
+				 struct perf_sample *sample,
+				 struct event_key *key)
+{
+	key->key  = perf_evsel__intval(evsel, sample, "port");
+	key->info = perf_evsel__intval(evsel, sample, "rw");
+}
+
+static bool ioport_event_begin(struct perf_evsel *evsel,
+			       struct perf_sample *sample,
+			       struct event_key *key)
+{
+	if (!strcmp(evsel->name, "kvm:kvm_pio")) {
+		ioport_event_get_key(evsel, sample, key);
+		return true;
+	}
+
+	return false;
+}
+
+static bool ioport_event_end(struct perf_evsel *evsel,
+			     struct perf_sample *sample __maybe_unused,
+			     struct event_key *key __maybe_unused)
+{
+	return kvm_entry_event(evsel);
+}
+
+static void ioport_event_decode_key(struct perf_kvm_stat *kvm __maybe_unused,
+				    struct event_key *key,
+				    char *decode)
+{
+	scnprintf(decode, DECODE_STR_LEN, "%#llx:%s",
+		  (unsigned long long)key->key,
+		  key->info ? "POUT" : "PIN");
+}
+
+static struct kvm_events_ops ioport_events = {
+	.is_begin_event = ioport_event_begin,
+	.is_end_event = ioport_event_end,
+	.decode_key = ioport_event_decode_key,
+	.name = "IO Port Access"
+};
+
+const char * const kvm_events_tp[] = {
+	"kvm:kvm_entry",
+	"kvm:kvm_exit",
+	"kvm:kvm_mmio",
+	"kvm:kvm_pio",
+	NULL,
+};
+
+struct kvm_reg_events_ops kvm_reg_events_ops[] = {
+	{ .name = "vmexit", .ops = &exit_events },
+	{ .name = "mmio", .ops = &mmio_events },
+	{ .name = "ioport", .ops = &ioport_events },
+	{ NULL, NULL },
+};
+
+const char * const kvm_skip_events[] = {
+	"HLT",
+	NULL,
+};
+
+int cpu_isa_init(struct perf_kvm_stat *kvm, const char *cpuid)
+{
+	if (strstr(cpuid, "Intel")) {
+		kvm->exit_reasons = vmx_exit_reasons;
+		kvm->exit_reasons_isa = "VMX";
+	} else if (strstr(cpuid, "AMD")) {
+		kvm->exit_reasons = svm_exit_reasons;
+		kvm->exit_reasons_isa = "SVM";
+	} else
+		return -ENOTSUP;
+
+	return 0;
+}
diff --git a/tools/perf/arch/x86/util/tsc.c b/tools/perf/arch/x86/util/tsc.c
index 40021fa..fd28684 100644
--- a/tools/perf/arch/x86/util/tsc.c
+++ b/tools/perf/arch/x86/util/tsc.c
@@ -6,29 +6,9 @@
 #include "../../perf.h"
 #include <linux/types.h>
 #include "../../util/debug.h"
+#include "../../util/tsc.h"
 #include "tsc.h"
 
-u64 perf_time_to_tsc(u64 ns, struct perf_tsc_conversion *tc)
-{
-	u64 t, quot, rem;
-
-	t = ns - tc->time_zero;
-	quot = t / tc->time_mult;
-	rem  = t % tc->time_mult;
-	return (quot << tc->time_shift) +
-	       (rem << tc->time_shift) / tc->time_mult;
-}
-
-u64 tsc_to_perf_time(u64 cyc, struct perf_tsc_conversion *tc)
-{
-	u64 quot, rem;
-
-	quot = cyc >> tc->time_shift;
-	rem  = cyc & ((1 << tc->time_shift) - 1);
-	return tc->time_zero + quot * tc->time_mult +
-	       ((rem * tc->time_mult) >> tc->time_shift);
-}
-
 int perf_read_tsc_conversion(const struct perf_event_mmap_page *pc,
 			     struct perf_tsc_conversion *tc)
 {
@@ -57,3 +37,12 @@ int perf_read_tsc_conversion(const struct perf_event_mmap_page *pc,
 
 	return 0;
 }
+
+u64 rdtsc(void)
+{
+	unsigned int low, high;
+
+	asm volatile("rdtsc" : "=a" (low), "=d" (high));
+
+	return low | ((u64)high) << 32;
+}
diff --git a/tools/perf/arch/x86/util/tsc.h b/tools/perf/arch/x86/util/tsc.h
index 2affe03..2edc4d3 100644
--- a/tools/perf/arch/x86/util/tsc.h
+++ b/tools/perf/arch/x86/util/tsc.h
@@ -14,7 +14,4 @@ struct perf_event_mmap_page;
 int perf_read_tsc_conversion(const struct perf_event_mmap_page *pc,
 			     struct perf_tsc_conversion *tc);
 
-u64 perf_time_to_tsc(u64 ns, struct perf_tsc_conversion *tc);
-u64 tsc_to_perf_time(u64 cyc, struct perf_tsc_conversion *tc);
-
 #endif /* TOOLS_PERF_ARCH_X86_UTIL_TSC_H__ */
diff --git a/tools/perf/arch/x86/util/unwind-libunwind.c b/tools/perf/arch/x86/util/unwind-libunwind.c
index 3261f68..db25e93 100644
--- a/tools/perf/arch/x86/util/unwind-libunwind.c
+++ b/tools/perf/arch/x86/util/unwind-libunwind.c
@@ -3,6 +3,7 @@
 #include <libunwind.h>
 #include "perf_regs.h"
 #include "../../util/unwind.h"
+#include "../../util/debug.h"
 
 #ifdef HAVE_ARCH_X86_64_SUPPORT
 int libunwind__arch_reg_id(int regnum)
diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index eba4670..3c4dd44 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -43,5 +43,6 @@ extern int bench_futex_requeue(int argc, const char **argv, const char *prefix);
 #define BENCH_FORMAT_UNKNOWN		-1
 
 extern int bench_format;
+extern unsigned int bench_repeat;
 
 #endif
diff --git a/tools/perf/bench/futex-requeue.c b/tools/perf/bench/futex-requeue.c
index a1625587..732403b 100644
--- a/tools/perf/bench/futex-requeue.c
+++ b/tools/perf/bench/futex-requeue.c
@@ -29,13 +29,6 @@ static u_int32_t futex1 = 0, futex2 = 0;
  */
 static unsigned int nrequeue = 1;
 
-/*
- * There can be significant variance from run to run,
- * the more repeats, the more exact the overall avg and
- * the better idea of the futex latency.
- */
-static unsigned int repeat = 10;
-
 static pthread_t *worker;
 static bool done = 0, silent = 0;
 static pthread_mutex_t thread_lock;
@@ -46,7 +39,6 @@ static unsigned int ncpus, threads_starting, nthreads = 0;
 static const struct option options[] = {
 	OPT_UINTEGER('t', "threads",  &nthreads, "Specify amount of threads"),
 	OPT_UINTEGER('q', "nrequeue", &nrequeue, "Specify amount of threads to requeue at once"),
-	OPT_UINTEGER('r', "repeat",   &repeat,   "Specify amount of times to repeat the run"),
 	OPT_BOOLEAN( 's', "silent",   &silent,   "Silent mode: do not display data/details"),
 	OPT_END()
 };
@@ -146,7 +138,7 @@ int bench_futex_requeue(int argc, const char **argv,
 	pthread_cond_init(&thread_parent, NULL);
 	pthread_cond_init(&thread_worker, NULL);
 
-	for (j = 0; j < repeat && !done; j++) {
+	for (j = 0; j < bench_repeat && !done; j++) {
 		unsigned int nrequeued = 0;
 		struct timeval start, end, runtime;
 
diff --git a/tools/perf/bench/futex-wake.c b/tools/perf/bench/futex-wake.c
index d096169..50022cb 100644
--- a/tools/perf/bench/futex-wake.c
+++ b/tools/perf/bench/futex-wake.c
@@ -30,15 +30,8 @@ static u_int32_t futex1 = 0;
  */
 static unsigned int nwakes = 1;
 
-/*
- * There can be significant variance from run to run,
- * the more repeats, the more exact the overall avg and
- * the better idea of the futex latency.
- */
-static unsigned int repeat = 10;
-
 pthread_t *worker;
-static bool done = 0, silent = 0;
+static bool done = false, silent = false;
 static pthread_mutex_t thread_lock;
 static pthread_cond_t thread_parent, thread_worker;
 static struct stats waketime_stats, wakeup_stats;
@@ -47,7 +40,6 @@ static unsigned int ncpus, threads_starting, nthreads = 0;
 static const struct option options[] = {
 	OPT_UINTEGER('t', "threads", &nthreads, "Specify amount of threads"),
 	OPT_UINTEGER('w', "nwakes",  &nwakes,   "Specify amount of threads to wake at once"),
-	OPT_UINTEGER('r', "repeat",  &repeat,   "Specify amount of times to repeat the run"),
 	OPT_BOOLEAN( 's', "silent",  &silent,   "Silent mode: do not display data/details"),
 	OPT_END()
 };
@@ -149,7 +141,7 @@ int bench_futex_wake(int argc, const char **argv,
 	pthread_cond_init(&thread_parent, NULL);
 	pthread_cond_init(&thread_worker, NULL);
 
-	for (j = 0; j < repeat && !done; j++) {
+	for (j = 0; j < bench_repeat && !done; j++) {
 		unsigned int nwoken = 0;
 		struct timeval start, end, runtime;
 
diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 5ce71d3..2465141 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -10,6 +10,7 @@
 #include "../util/util.h"
 #include "../util/parse-options.h"
 #include "../util/header.h"
+#include "../util/cloexec.h"
 #include "bench.h"
 #include "mem-memcpy-arch.h"
 
@@ -83,7 +84,8 @@ static struct perf_event_attr cycle_attr = {
 
 static void init_cycle(void)
 {
-	cycle_fd = sys_perf_event_open(&cycle_attr, getpid(), -1, -1, 0);
+	cycle_fd = sys_perf_event_open(&cycle_attr, getpid(), -1, -1,
+				       perf_event_open_cloexec_flag());
 
 	if (cycle_fd < 0 && errno == ENOSYS)
 		die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
@@ -189,6 +191,11 @@ int bench_mem_memcpy(int argc, const char **argv,
 	argc = parse_options(argc, argv, options,
 			     bench_mem_memcpy_usage, 0);
 
+	if (no_prefault && only_prefault) {
+		fprintf(stderr, "Invalid options: -o and -n are mutually exclusive\n");
+		return 1;
+	}
+
 	if (use_cycle)
 		init_cycle();
 
diff --git a/tools/perf/bench/mem-memset.c b/tools/perf/bench/mem-memset.c
index 9af79d2..75fc3e6 100644
--- a/tools/perf/bench/mem-memset.c
+++ b/tools/perf/bench/mem-memset.c
@@ -10,6 +10,7 @@
 #include "../util/util.h"
 #include "../util/parse-options.h"
 #include "../util/header.h"
+#include "../util/cloexec.h"
 #include "bench.h"
 #include "mem-memset-arch.h"
 
@@ -83,7 +84,8 @@ static struct perf_event_attr cycle_attr = {
 
 static void init_cycle(void)
 {
-	cycle_fd = sys_perf_event_open(&cycle_attr, getpid(), -1, -1, 0);
+	cycle_fd = sys_perf_event_open(&cycle_attr, getpid(), -1, -1,
+				       perf_event_open_cloexec_flag());
 
 	if (cycle_fd < 0 && errno == ENOSYS)
 		die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
@@ -181,6 +183,11 @@ int bench_mem_memset(int argc, const char **argv,
 	argc = parse_options(argc, argv, options,
 			     bench_mem_memset_usage, 0);
 
+	if (no_prefault && only_prefault) {
+		fprintf(stderr, "Invalid options: -o and -n are mutually exclusive\n");
+		return 1;
+	}
+
 	if (use_cycle)
 		init_cycle();
 
diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
index cc1190a..52a5659 100644
--- a/tools/perf/bench/sched-messaging.c
+++ b/tools/perf/bench/sched-messaging.c
@@ -28,6 +28,7 @@
 #include <sys/time.h>
 #include <sys/poll.h>
 #include <limits.h>
+#include <err.h>
 
 #define DATASIZE 100
 
@@ -50,12 +51,6 @@ struct receiver_context {
 	int wakefd;
 };
 
-static void barf(const char *msg)
-{
-	fprintf(stderr, "%s (error: %s)\n", msg, strerror(errno));
-	exit(1);
-}
-
 static void fdpair(int fds[2])
 {
 	if (use_pipes) {
@@ -66,7 +61,7 @@ static void fdpair(int fds[2])
 			return;
 	}
 
-	barf(use_pipes ? "pipe()" : "socketpair()");
+	err(EXIT_FAILURE, use_pipes ? "pipe()" : "socketpair()");
 }
 
 /* Block until we're ready to go */
@@ -77,11 +72,11 @@ static void ready(int ready_out, int wakefd)
 
 	/* Tell them we're ready. */
 	if (write(ready_out, &dummy, 1) != 1)
-		barf("CLIENT: ready write");
+		err(EXIT_FAILURE, "CLIENT: ready write");
 
 	/* Wait for "GO" signal */
 	if (poll(&pollfd, 1, -1) != 1)
-		barf("poll");
+		err(EXIT_FAILURE, "poll");
 }
 
 /* Sender sprays loops messages down each file descriptor */
@@ -101,7 +96,7 @@ again:
 			ret = write(ctx->out_fds[j], data + done,
 				    sizeof(data)-done);
 			if (ret < 0)
-				barf("SENDER: write");
+				err(EXIT_FAILURE, "SENDER: write");
 			done += ret;
 			if (done < DATASIZE)
 				goto again;
@@ -131,7 +126,7 @@ static void *receiver(struct receiver_context* ctx)
 again:
 		ret = read(ctx->in_fds[0], data + done, DATASIZE - done);
 		if (ret < 0)
-			barf("SERVER: read");
+			err(EXIT_FAILURE, "SERVER: read");
 		done += ret;
 		if (done < DATASIZE)
 			goto again;
@@ -144,14 +139,14 @@ static pthread_t create_worker(void *ctx, void *(*func)(void *))
 {
 	pthread_attr_t attr;
 	pthread_t childid;
-	int err;
+	int ret;
 
 	if (!thread_mode) {
 		/* process mode */
 		/* Fork the receiver. */
 		switch (fork()) {
 		case -1:
-			barf("fork()");
+			err(EXIT_FAILURE, "fork()");
 			break;
 		case 0:
 			(*func) (ctx);
@@ -165,19 +160,17 @@ static pthread_t create_worker(void *ctx, void *(*func)(void *))
 	}
 
 	if (pthread_attr_init(&attr) != 0)
-		barf("pthread_attr_init:");
+		err(EXIT_FAILURE, "pthread_attr_init:");
 
 #ifndef __ia64__
 	if (pthread_attr_setstacksize(&attr, PTHREAD_STACK_MIN) != 0)
-		barf("pthread_attr_setstacksize");
+		err(EXIT_FAILURE, "pthread_attr_setstacksize");
 #endif
 
-	err = pthread_create(&childid, &attr, func, ctx);
-	if (err != 0) {
-		fprintf(stderr, "pthread_create failed: %s (%d)\n",
-			strerror(err), err);
-		exit(-1);
-	}
+	ret = pthread_create(&childid, &attr, func, ctx);
+	if (ret != 0)
+		err(EXIT_FAILURE, "pthread_create failed");
+
 	return childid;
 }
 
@@ -207,14 +200,14 @@ static unsigned int group(pthread_t *pth,
 			+ num_fds * sizeof(int));
 
 	if (!snd_ctx)
-		barf("malloc()");
+		err(EXIT_FAILURE, "malloc()");
 
 	for (i = 0; i < num_fds; i++) {
 		int fds[2];
 		struct receiver_context *ctx = malloc(sizeof(*ctx));
 
 		if (!ctx)
-			barf("malloc()");
+			err(EXIT_FAILURE, "malloc()");
 
 
 		/* Create the pipe between client and server */
@@ -281,7 +274,7 @@ int bench_sched_messaging(int argc, const char **argv,
 
 	pth_tab = malloc(num_fds * 2 * num_groups * sizeof(pthread_t));
 	if (!pth_tab)
-		barf("main:malloc()");
+		err(EXIT_FAILURE, "main:malloc()");
 
 	fdpair(readyfds);
 	fdpair(wakefds);
@@ -294,13 +287,13 @@ int bench_sched_messaging(int argc, const char **argv,
 	/* Wait for everyone to be ready */
 	for (i = 0; i < total_children; i++)
 		if (read(readyfds[0], &dummy, 1) != 1)
-			barf("Reading for readyfds");
+			err(EXIT_FAILURE, "Reading for readyfds");
 
 	gettimeofday(&start, NULL);
 
 	/* Kick them off */
 	if (write(wakefds[1], &dummy, 1) != 1)
-		barf("Writing to start them");
+		err(EXIT_FAILURE, "Writing to start them");
 
 	/* Reap them all */
 	for (i = 0; i < total_children; i++)
@@ -332,5 +325,7 @@ int bench_sched_messaging(int argc, const char **argv,
 		break;
 	}
 
+	free(pth_tab);
+
 	return 0;
 }
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index 1e6e777..b9a56fa 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -104,9 +104,11 @@ static const char *bench_format_str;
 
 /* Output/formatting style, exported to benchmark modules: */
 int bench_format = BENCH_FORMAT_DEFAULT;
+unsigned int bench_repeat = 10; /* default number of times to repeat the run */
 
 static const struct option bench_options[] = {
 	OPT_STRING('f', "format", &bench_format_str, "default", "Specify format style"),
+	OPT_UINTEGER('r', "repeat",  &bench_repeat,   "Specify amount of times to repeat the run"),
 	OPT_END()
 };
 
@@ -226,6 +228,11 @@ int cmd_bench(int argc, const char **argv, const char *prefix __maybe_unused)
 		goto end;
 	}
 
+	if (bench_repeat == 0) {
+		printf("Invalid repeat option: Must specify a positive value\n");
+		goto end;
+	}
+
 	if (argc < 1) {
 		print_usage();
 		goto end;
diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index b22dbb1..2a2c78f 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -125,7 +125,8 @@ static int build_id_cache__kcore_existing(const char *from_dir, char *to_dir,
 	return ret;
 }
 
-static int build_id_cache__add_kcore(const char *filename, const char *debugdir)
+static int build_id_cache__add_kcore(const char *filename, const char *debugdir,
+				     bool force)
 {
 	char dir[32], sbuildid[BUILD_ID_SIZE * 2 + 1];
 	char from_dir[PATH_MAX], to_dir[PATH_MAX];
@@ -144,7 +145,8 @@ static int build_id_cache__add_kcore(const char *filename, const char *debugdir)
 	scnprintf(to_dir, sizeof(to_dir), "%s/[kernel.kcore]/%s",
 		  debugdir, sbuildid);
 
-	if (!build_id_cache__kcore_existing(from_dir, to_dir, sizeof(to_dir))) {
+	if (!force &&
+	    !build_id_cache__kcore_existing(from_dir, to_dir, sizeof(to_dir))) {
 		pr_debug("same kcore found in %s\n", to_dir);
 		return 0;
 	}
@@ -389,7 +391,7 @@ int cmd_buildid_cache(int argc, const char **argv,
 	}
 
 	if (kcore_filename &&
-	    build_id_cache__add_kcore(kcore_filename, debugdir))
+	    build_id_cache__add_kcore(kcore_filename, debugdir, force))
 		pr_warning("Couldn't add %s\n", kcore_filename);
 
 	return ret;
diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
index c99e0de..66e12f5 100644
--- a/tools/perf/builtin-evlist.c
+++ b/tools/perf/builtin-evlist.c
@@ -15,6 +15,7 @@
 #include "util/parse-options.h"
 #include "util/session.h"
 #include "util/data.h"
+#include "util/debug.h"
 
 static int __cmd_evlist(const char *file_name, struct perf_attr_details *details)
 {
diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 178b88a..0384d93 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -11,6 +11,7 @@
 #include "util/parse-options.h"
 #include "util/run-command.h"
 #include "util/help.h"
+#include "util/debug.h"
 
 static struct man_viewer_list {
 	struct man_viewer_list *next;
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 16c7c11..9a02807 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -389,6 +389,9 @@ static int __cmd_inject(struct perf_inject *inject)
 	ret = perf_session__process_events(session, &inject->tool);
 
 	if (!file_out->is_pipe) {
+		if (inject->build_ids)
+			perf_header__set_feat(&session->header,
+					      HEADER_BUILD_ID);
 		session->header.data_size = inject->bytes_written;
 		perf_session__write_header(session, session->evlist, file_out->fd, true);
 	}
@@ -436,6 +439,8 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 			    "where and how long tasks slept"),
 		OPT_INCR('v', "verbose", &verbose,
 			 "be more verbose (show build ids, etc)"),
+		OPT_STRING(0, "kallsyms", &symbol_conf.kallsyms_name, "file",
+			   "kallsyms pathname"),
 		OPT_END()
 	};
 	const char * const inject_usage[] = {
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 0f1e5a2..43367eb 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -29,114 +29,25 @@
 #include <pthread.h>
 #include <math.h>
 
-#if defined(__i386__) || defined(__x86_64__)
-#include <asm/svm.h>
-#include <asm/vmx.h>
-#include <asm/kvm.h>
-
-struct event_key {
-	#define INVALID_KEY     (~0ULL)
-	u64 key;
-	int info;
-};
-
-struct kvm_event_stats {
-	u64 time;
-	struct stats stats;
-};
-
-struct kvm_event {
-	struct list_head hash_entry;
-	struct rb_node rb;
-
-	struct event_key key;
-
-	struct kvm_event_stats total;
-
-	#define DEFAULT_VCPU_NUM 8
-	int max_vcpu;
-	struct kvm_event_stats *vcpu;
-};
-
-typedef int (*key_cmp_fun)(struct kvm_event*, struct kvm_event*, int);
-
-struct kvm_event_key {
-	const char *name;
-	key_cmp_fun key;
-};
-
-
-struct perf_kvm_stat;
-
-struct kvm_events_ops {
-	bool (*is_begin_event)(struct perf_evsel *evsel,
-			       struct perf_sample *sample,
-			       struct event_key *key);
-	bool (*is_end_event)(struct perf_evsel *evsel,
-			     struct perf_sample *sample, struct event_key *key);
-	void (*decode_key)(struct perf_kvm_stat *kvm, struct event_key *key,
-			   char decode[20]);
-	const char *name;
-};
-
-struct exit_reasons_table {
-	unsigned long exit_code;
-	const char *reason;
-};
+#ifdef HAVE_KVM_STAT_SUPPORT
+#include <asm/kvm_perf.h>
+#include "util/kvm-stat.h"
 
-#define EVENTS_BITS		12
-#define EVENTS_CACHE_SIZE	(1UL << EVENTS_BITS)
-
-struct perf_kvm_stat {
-	struct perf_tool    tool;
-	struct record_opts  opts;
-	struct perf_evlist  *evlist;
-	struct perf_session *session;
-
-	const char *file_name;
-	const char *report_event;
-	const char *sort_key;
-	int trace_vcpu;
-
-	struct exit_reasons_table *exit_reasons;
-	int exit_reasons_size;
-	const char *exit_reasons_isa;
-
-	struct kvm_events_ops *events_ops;
-	key_cmp_fun compare;
-	struct list_head kvm_events_cache[EVENTS_CACHE_SIZE];
-
-	u64 total_time;
-	u64 total_count;
-	u64 lost_events;
-	u64 duration;
-
-	const char *pid_str;
-	struct intlist *pid_list;
-
-	struct rb_root result;
-
-	int timerfd;
-	unsigned int display_time;
-	bool live;
-};
-
-
-static void exit_event_get_key(struct perf_evsel *evsel,
-			       struct perf_sample *sample,
-			       struct event_key *key)
+void exit_event_get_key(struct perf_evsel *evsel,
+			struct perf_sample *sample,
+			struct event_key *key)
 {
 	key->info = 0;
-	key->key = perf_evsel__intval(evsel, sample, "exit_reason");
+	key->key = perf_evsel__intval(evsel, sample, KVM_EXIT_REASON);
 }
 
-static bool kvm_exit_event(struct perf_evsel *evsel)
+bool kvm_exit_event(struct perf_evsel *evsel)
 {
-	return !strcmp(evsel->name, "kvm:kvm_exit");
+	return !strcmp(evsel->name, KVM_EXIT_TRACE);
 }
 
-static bool exit_event_begin(struct perf_evsel *evsel,
-			     struct perf_sample *sample, struct event_key *key)
+bool exit_event_begin(struct perf_evsel *evsel,
+		      struct perf_sample *sample, struct event_key *key)
 {
 	if (kvm_exit_event(evsel)) {
 		exit_event_get_key(evsel, sample, key);
@@ -146,32 +57,23 @@ static bool exit_event_begin(struct perf_evsel *evsel,
 	return false;
 }
 
-static bool kvm_entry_event(struct perf_evsel *evsel)
+bool kvm_entry_event(struct perf_evsel *evsel)
 {
-	return !strcmp(evsel->name, "kvm:kvm_entry");
+	return !strcmp(evsel->name, KVM_ENTRY_TRACE);
 }
 
-static bool exit_event_end(struct perf_evsel *evsel,
-			   struct perf_sample *sample __maybe_unused,
-			   struct event_key *key __maybe_unused)
+bool exit_event_end(struct perf_evsel *evsel,
+		    struct perf_sample *sample __maybe_unused,
+		    struct event_key *key __maybe_unused)
 {
 	return kvm_entry_event(evsel);
 }
 
-static struct exit_reasons_table vmx_exit_reasons[] = {
-	VMX_EXIT_REASONS
-};
-
-static struct exit_reasons_table svm_exit_reasons[] = {
-	SVM_EXIT_REASONS
-};
-
-static const char *get_exit_reason(struct perf_kvm_stat *kvm, u64 exit_code)
+static const char *get_exit_reason(struct perf_kvm_stat *kvm,
+				   struct exit_reasons_table *tbl,
+				   u64 exit_code)
 {
-	int i = kvm->exit_reasons_size;
-	struct exit_reasons_table *tbl = kvm->exit_reasons;
-
-	while (i--) {
+	while (tbl->reason != NULL) {
 		if (tbl->exit_code == exit_code)
 			return tbl->reason;
 		tbl++;
@@ -182,148 +84,30 @@ static const char *get_exit_reason(struct perf_kvm_stat *kvm, u64 exit_code)
 	return "UNKNOWN";
 }
 
-static void exit_event_decode_key(struct perf_kvm_stat *kvm,
-				  struct event_key *key,
-				  char decode[20])
+void exit_event_decode_key(struct perf_kvm_stat *kvm,
+			   struct event_key *key,
+			   char *decode)
 {
-	const char *exit_reason = get_exit_reason(kvm, key->key);
+	const char *exit_reason = get_exit_reason(kvm, key->exit_reasons,
+						  key->key);
 
-	scnprintf(decode, 20, "%s", exit_reason);
+	scnprintf(decode, DECODE_STR_LEN, "%s", exit_reason);
 }
 
-static struct kvm_events_ops exit_events = {
-	.is_begin_event = exit_event_begin,
-	.is_end_event = exit_event_end,
-	.decode_key = exit_event_decode_key,
-	.name = "VM-EXIT"
-};
-
-/*
- * For the mmio events, we treat:
- * the time of MMIO write: kvm_mmio(KVM_TRACE_MMIO_WRITE...) -> kvm_entry
- * the time of MMIO read: kvm_exit -> kvm_mmio(KVM_TRACE_MMIO_READ...).
- */
-static void mmio_event_get_key(struct perf_evsel *evsel, struct perf_sample *sample,
-			       struct event_key *key)
-{
-	key->key  = perf_evsel__intval(evsel, sample, "gpa");
-	key->info = perf_evsel__intval(evsel, sample, "type");
-}
-
-#define KVM_TRACE_MMIO_READ_UNSATISFIED 0
-#define KVM_TRACE_MMIO_READ 1
-#define KVM_TRACE_MMIO_WRITE 2
-
-static bool mmio_event_begin(struct perf_evsel *evsel,
-			     struct perf_sample *sample, struct event_key *key)
-{
-	/* MMIO read begin event in kernel. */
-	if (kvm_exit_event(evsel))
-		return true;
-
-	/* MMIO write begin event in kernel. */
-	if (!strcmp(evsel->name, "kvm:kvm_mmio") &&
-	    perf_evsel__intval(evsel, sample, "type") == KVM_TRACE_MMIO_WRITE) {
-		mmio_event_get_key(evsel, sample, key);
-		return true;
-	}
-
-	return false;
-}
-
-static bool mmio_event_end(struct perf_evsel *evsel, struct perf_sample *sample,
-			   struct event_key *key)
-{
-	/* MMIO write end event in kernel. */
-	if (kvm_entry_event(evsel))
-		return true;
-
-	/* MMIO read end event in kernel.*/
-	if (!strcmp(evsel->name, "kvm:kvm_mmio") &&
-	    perf_evsel__intval(evsel, sample, "type") == KVM_TRACE_MMIO_READ) {
-		mmio_event_get_key(evsel, sample, key);
-		return true;
-	}
-
-	return false;
-}
-
-static void mmio_event_decode_key(struct perf_kvm_stat *kvm __maybe_unused,
-				  struct event_key *key,
-				  char decode[20])
-{
-	scnprintf(decode, 20, "%#lx:%s", (unsigned long)key->key,
-				key->info == KVM_TRACE_MMIO_WRITE ? "W" : "R");
-}
-
-static struct kvm_events_ops mmio_events = {
-	.is_begin_event = mmio_event_begin,
-	.is_end_event = mmio_event_end,
-	.decode_key = mmio_event_decode_key,
-	.name = "MMIO Access"
-};
-
- /* The time of emulation pio access is from kvm_pio to kvm_entry. */
-static void ioport_event_get_key(struct perf_evsel *evsel,
-				 struct perf_sample *sample,
-				 struct event_key *key)
+static bool register_kvm_events_ops(struct perf_kvm_stat *kvm)
 {
-	key->key  = perf_evsel__intval(evsel, sample, "port");
-	key->info = perf_evsel__intval(evsel, sample, "rw");
-}
+	struct kvm_reg_events_ops *events_ops = kvm_reg_events_ops;
 
-static bool ioport_event_begin(struct perf_evsel *evsel,
-			       struct perf_sample *sample,
-			       struct event_key *key)
-{
-	if (!strcmp(evsel->name, "kvm:kvm_pio")) {
-		ioport_event_get_key(evsel, sample, key);
-		return true;
+	for (events_ops = kvm_reg_events_ops; events_ops->name; events_ops++) {
+		if (!strcmp(events_ops->name, kvm->report_event)) {
+			kvm->events_ops = events_ops->ops;
+			return true;
+		}
 	}
 
 	return false;
 }
 
-static bool ioport_event_end(struct perf_evsel *evsel,
-			     struct perf_sample *sample __maybe_unused,
-			     struct event_key *key __maybe_unused)
-{
-	return kvm_entry_event(evsel);
-}
-
-static void ioport_event_decode_key(struct perf_kvm_stat *kvm __maybe_unused,
-				    struct event_key *key,
-				    char decode[20])
-{
-	scnprintf(decode, 20, "%#llx:%s", (unsigned long long)key->key,
-				key->info ? "POUT" : "PIN");
-}
-
-static struct kvm_events_ops ioport_events = {
-	.is_begin_event = ioport_event_begin,
-	.is_end_event = ioport_event_end,
-	.decode_key = ioport_event_decode_key,
-	.name = "IO Port Access"
-};
-
-static bool register_kvm_events_ops(struct perf_kvm_stat *kvm)
-{
-	bool ret = true;
-
-	if (!strcmp(kvm->report_event, "vmexit"))
-		kvm->events_ops = &exit_events;
-	else if (!strcmp(kvm->report_event, "mmio"))
-		kvm->events_ops = &mmio_events;
-	else if (!strcmp(kvm->report_event, "ioport"))
-		kvm->events_ops = &ioport_events;
-	else {
-		pr_err("Unknown report event:%s\n", kvm->report_event);
-		ret = false;
-	}
-
-	return ret;
-}
-
 struct vcpu_event_record {
 	int vcpu_id;
 	u64 start_time;
@@ -477,6 +261,54 @@ static bool update_kvm_event(struct kvm_event *event, int vcpu_id,
 	return true;
 }
 
+static bool is_child_event(struct perf_kvm_stat *kvm,
+			   struct perf_evsel *evsel,
+			   struct perf_sample *sample,
+			   struct event_key *key)
+{
+	struct child_event_ops *child_ops;
+
+	child_ops = kvm->events_ops->child_ops;
+
+	if (!child_ops)
+		return false;
+
+	for (; child_ops->name; child_ops++) {
+		if (!strcmp(evsel->name, child_ops->name)) {
+			child_ops->get_key(evsel, sample, key);
+			return true;
+		}
+	}
+
+	return false;
+}
+
+static bool handle_child_event(struct perf_kvm_stat *kvm,
+			       struct vcpu_event_record *vcpu_record,
+			       struct event_key *key,
+			       struct perf_sample *sample __maybe_unused)
+{
+	struct kvm_event *event = NULL;
+
+	if (key->key != INVALID_KEY)
+		event = find_create_kvm_event(kvm, key);
+
+	vcpu_record->last_event = event;
+
+	return true;
+}
+
+static bool skip_event(const char *event)
+{
+	const char * const *skip_events;
+
+	for (skip_events = kvm_skip_events; *skip_events; skip_events++)
+		if (!strcmp(event, *skip_events))
+			return true;
+
+	return false;
+}
+
 static bool handle_end_event(struct perf_kvm_stat *kvm,
 			     struct vcpu_event_record *vcpu_record,
 			     struct event_key *key,
@@ -525,10 +357,10 @@ static bool handle_end_event(struct perf_kvm_stat *kvm,
 	time_diff = sample->time - time_begin;
 
 	if (kvm->duration && time_diff > kvm->duration) {
-		char decode[32];
+		char decode[DECODE_STR_LEN];
 
 		kvm->events_ops->decode_key(kvm, &event->key, decode);
-		if (strcmp(decode, "HLT")) {
+		if (!skip_event(decode)) {
 			pr_info("%" PRIu64 " VM %d, vcpu %d: %s event took %" PRIu64 "usec\n",
 				 sample->time, sample->pid, vcpu_record->vcpu_id,
 				 decode, time_diff/1000);
@@ -553,7 +385,7 @@ struct vcpu_event_record *per_vcpu_record(struct thread *thread,
 			return NULL;
 		}
 
-		vcpu_record->vcpu_id = perf_evsel__intval(evsel, sample, "vcpu_id");
+		vcpu_record->vcpu_id = perf_evsel__intval(evsel, sample, VCPU_ID);
 		thread->priv = vcpu_record;
 	}
 
@@ -566,7 +398,8 @@ static bool handle_kvm_event(struct perf_kvm_stat *kvm,
 			     struct perf_sample *sample)
 {
 	struct vcpu_event_record *vcpu_record;
-	struct event_key key = {.key = INVALID_KEY};
+	struct event_key key = { .key = INVALID_KEY,
+				 .exit_reasons = kvm->exit_reasons };
 
 	vcpu_record = per_vcpu_record(thread, evsel, sample);
 	if (!vcpu_record)
@@ -580,6 +413,9 @@ static bool handle_kvm_event(struct perf_kvm_stat *kvm,
 	if (kvm->events_ops->is_begin_event(evsel, sample, &key))
 		return handle_begin_event(kvm, vcpu_record, &key, sample->time);
 
+	if (is_child_event(kvm, evsel, sample, &key))
+		return handle_child_event(kvm, vcpu_record, &key, sample);
+
 	if (kvm->events_ops->is_end_event(evsel, sample, &key))
 		return handle_end_event(kvm, vcpu_record, &key, sample);
 
@@ -740,7 +576,7 @@ static void show_timeofday(void)
 
 static void print_result(struct perf_kvm_stat *kvm)
 {
-	char decode[20];
+	char decode[DECODE_STR_LEN];
 	struct kvm_event *event;
 	int vcpu = kvm->trace_vcpu;
 
@@ -751,7 +587,7 @@ static void print_result(struct perf_kvm_stat *kvm)
 
 	pr_info("\n\n");
 	print_vcpu_info(kvm);
-	pr_info("%20s ", kvm->events_ops->name);
+	pr_info("%*s ", DECODE_STR_LEN, kvm->events_ops->name);
 	pr_info("%10s ", "Samples");
 	pr_info("%9s ", "Samples%");
 
@@ -770,7 +606,7 @@ static void print_result(struct perf_kvm_stat *kvm)
 		min = get_event_min(event, vcpu);
 
 		kvm->events_ops->decode_key(kvm, &event->key, decode);
-		pr_info("%20s ", decode);
+		pr_info("%*s ", DECODE_STR_LEN, decode);
 		pr_info("%10llu ", (unsigned long long)ecount);
 		pr_info("%8.2f%% ", (double)ecount / kvm->total_count * 100);
 		pr_info("%8.2f%% ", (double)etime / kvm->total_time * 100);
@@ -839,34 +675,28 @@ static int process_sample_event(struct perf_tool *tool,
 static int cpu_isa_config(struct perf_kvm_stat *kvm)
 {
 	char buf[64], *cpuid;
-	int err, isa;
+	int err;
 
 	if (kvm->live) {
 		err = get_cpuid(buf, sizeof(buf));
 		if (err != 0) {
-			pr_err("Failed to look up CPU type (Intel or AMD)\n");
+			pr_err("Failed to look up CPU type\n");
 			return err;
 		}
 		cpuid = buf;
 	} else
 		cpuid = kvm->session->header.env.cpuid;
 
-	if (strstr(cpuid, "Intel"))
-		isa = 1;
-	else if (strstr(cpuid, "AMD"))
-		isa = 0;
-	else {
-		pr_err("CPU %s is not supported.\n", cpuid);
-		return -ENOTSUP;
+	if (!cpuid) {
+		pr_err("Failed to look up CPU type\n");
+		return -EINVAL;
 	}
 
-	if (isa == 1) {
-		kvm->exit_reasons = vmx_exit_reasons;
-		kvm->exit_reasons_size = ARRAY_SIZE(vmx_exit_reasons);
-		kvm->exit_reasons_isa = "VMX";
-	}
+	err = cpu_isa_init(kvm, cpuid);
+	if (err == -ENOTSUP)
+		pr_err("CPU %s is not supported.\n", cpuid);
 
-	return 0;
+	return err;
 }
 
 static bool verify_vcpu(int vcpu)
@@ -1300,13 +1130,6 @@ exit:
 	return ret;
 }
 
-static const char * const kvm_events_tp[] = {
-	"kvm:kvm_entry",
-	"kvm:kvm_exit",
-	"kvm:kvm_mmio",
-	"kvm:kvm_pio",
-};
-
 #define STRDUP_FAIL_EXIT(s)		\
 	({	char *_p;		\
 	_p = strdup(s);		\
@@ -1318,7 +1141,7 @@ static const char * const kvm_events_tp[] = {
 static int
 kvm_events_record(struct perf_kvm_stat *kvm, int argc, const char **argv)
 {
-	unsigned int rec_argc, i, j;
+	unsigned int rec_argc, i, j, events_tp_size;
 	const char **rec_argv;
 	const char * const record_args[] = {
 		"record",
@@ -1326,9 +1149,14 @@ kvm_events_record(struct perf_kvm_stat *kvm, int argc, const char **argv)
 		"-m", "1024",
 		"-c", "1",
 	};
+	const char * const *events_tp;
+	events_tp_size = 0;
+
+	for (events_tp = kvm_events_tp; *events_tp; events_tp++)
+		events_tp_size++;
 
 	rec_argc = ARRAY_SIZE(record_args) + argc + 2 +
-		   2 * ARRAY_SIZE(kvm_events_tp);
+		   2 * events_tp_size;
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 
 	if (rec_argv == NULL)
@@ -1337,7 +1165,7 @@ kvm_events_record(struct perf_kvm_stat *kvm, int argc, const char **argv)
 	for (i = 0; i < ARRAY_SIZE(record_args); i++)
 		rec_argv[i] = STRDUP_FAIL_EXIT(record_args[i]);
 
-	for (j = 0; j < ARRAY_SIZE(kvm_events_tp); j++) {
+	for (j = 0; j < events_tp_size; j++) {
 		rec_argv[i++] = "-e";
 		rec_argv[i++] = STRDUP_FAIL_EXIT(kvm_events_tp[j]);
 	}
@@ -1356,7 +1184,8 @@ kvm_events_report(struct perf_kvm_stat *kvm, int argc, const char **argv)
 {
 	const struct option kvm_events_report_options[] = {
 		OPT_STRING(0, "event", &kvm->report_event, "report event",
-			    "event for reporting: vmexit, mmio, ioport"),
+			   "event for reporting: vmexit, "
+			   "mmio (x86 only), ioport (x86 only)"),
 		OPT_INTEGER(0, "vcpu", &kvm->trace_vcpu,
 			    "vcpu id to report"),
 		OPT_STRING('k', "key", &kvm->sort_key, "sort-key",
@@ -1391,16 +1220,16 @@ static struct perf_evlist *kvm_live_event_list(void)
 {
 	struct perf_evlist *evlist;
 	char *tp, *name, *sys;
-	unsigned int j;
 	int err = -1;
+	const char * const *events_tp;
 
 	evlist = perf_evlist__new();
 	if (evlist == NULL)
 		return NULL;
 
-	for (j = 0; j < ARRAY_SIZE(kvm_events_tp); j++) {
+	for (events_tp = kvm_events_tp; *events_tp; events_tp++) {
 
-		tp = strdup(kvm_events_tp[j]);
+		tp = strdup(*events_tp);
 		if (tp == NULL)
 			goto out;
 
@@ -1409,7 +1238,7 @@ static struct perf_evlist *kvm_live_event_list(void)
 		name = strchr(tp, ':');
 		if (name == NULL) {
 			pr_err("Error parsing %s tracepoint: subsystem delimiter not found\n",
-				kvm_events_tp[j]);
+			       *events_tp);
 			free(tp);
 			goto out;
 		}
@@ -1417,7 +1246,7 @@ static struct perf_evlist *kvm_live_event_list(void)
 		name++;
 
 		if (perf_evlist__add_newtp(evlist, sys, name, NULL)) {
-			pr_err("Failed to add %s tracepoint to the list\n", kvm_events_tp[j]);
+			pr_err("Failed to add %s tracepoint to the list\n", *events_tp);
 			free(tp);
 			goto out;
 		}
@@ -1462,7 +1291,9 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
 			"key for sorting: sample(sort by samples number)"
 			" time (sort by avg time)"),
 		OPT_U64(0, "duration", &kvm->duration,
-		    "show events other than HALT that take longer than duration usecs"),
+			"show events other than"
+			" HLT (x86 only) or Wait state (s390 only)"
+			" that take longer than duration usecs"),
 		OPT_END()
 	};
 	const char * const live_usage[] = {
@@ -1585,9 +1416,6 @@ static int kvm_cmd_stat(const char *file_name, int argc, const char **argv)
 		.report_event	= "vmexit",
 		.sort_key	= "sample",
 
-		.exit_reasons = svm_exit_reasons,
-		.exit_reasons_size = ARRAY_SIZE(svm_exit_reasons),
-		.exit_reasons_isa = "SVM",
 	};
 
 	if (argc == 1) {
@@ -1609,7 +1437,7 @@ static int kvm_cmd_stat(const char *file_name, int argc, const char **argv)
 perf_stat:
 	return cmd_stat(argc, argv, NULL);
 }
-#endif
+#endif /* HAVE_KVM_STAT_SUPPORT */
 
 static int __cmd_record(const char *file_name, int argc, const char **argv)
 {
@@ -1726,7 +1554,7 @@ int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 		return cmd_top(argc, argv, NULL);
 	else if (!strncmp(argv[0], "buildid-list", 12))
 		return __cmd_buildid_list(file_name, argc, argv);
-#if defined(__i386__) || defined(__x86_64__)
+#ifdef HAVE_KVM_STAT_SUPPORT
 	else if (!strncmp(argv[0], "stat", 4))
 		return kvm_cmd_stat(file_name, argc, argv);
 #endif
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 378b85b..4869050 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -238,6 +238,7 @@ static struct perf_event_header finished_round_event = {
 
 static int record__mmap_read_all(struct record *rec)
 {
+	u64 bytes_written = rec->bytes_written;
 	int i;
 	int rc = 0;
 
@@ -250,7 +251,11 @@ static int record__mmap_read_all(struct record *rec)
 		}
 	}
 
-	if (perf_header__has_feat(&rec->session->header, HEADER_TRACING_DATA))
+	/*
+	 * Mark the round finished in case we wrote
+	 * at least one event.
+	 */
+	if (bytes_written != rec->bytes_written)
 		rc = record__write(rec, &finished_round_event, sizeof(finished_round_event));
 
 out:
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index c38d06c..f83c08c 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -10,6 +10,7 @@
 #include "util/header.h"
 #include "util/session.h"
 #include "util/tool.h"
+#include "util/cloexec.h"
 
 #include "util/parse-options.h"
 #include "util/trace-event.h"
@@ -434,7 +435,8 @@ static int self_open_counters(void)
 	attr.type = PERF_TYPE_SOFTWARE;
 	attr.config = PERF_COUNT_SW_TASK_CLOCK;
 
-	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
+	fd = sys_perf_event_open(&attr, 0, -1, -1,
+				 perf_event_open_cloexec_flag());
 
 	if (fd < 0)
 		pr_err("Error: sys_perf_event_open() syscall returned "
@@ -935,8 +937,8 @@ static int latency_switch_event(struct perf_sched *sched,
 		return -1;
 	}
 
-	sched_out = machine__findnew_thread(machine, 0, prev_pid);
-	sched_in = machine__findnew_thread(machine, 0, next_pid);
+	sched_out = machine__findnew_thread(machine, -1, prev_pid);
+	sched_in = machine__findnew_thread(machine, -1, next_pid);
 
 	out_events = thread_atoms_search(&sched->atom_root, sched_out, &sched->cmp_pid);
 	if (!out_events) {
@@ -979,7 +981,7 @@ static int latency_runtime_event(struct perf_sched *sched,
 {
 	const u32 pid	   = perf_evsel__intval(evsel, sample, "pid");
 	const u64 runtime  = perf_evsel__intval(evsel, sample, "runtime");
-	struct thread *thread = machine__findnew_thread(machine, 0, pid);
+	struct thread *thread = machine__findnew_thread(machine, -1, pid);
 	struct work_atoms *atoms = thread_atoms_search(&sched->atom_root, thread, &sched->cmp_pid);
 	u64 timestamp = sample->time;
 	int cpu = sample->cpu;
@@ -1012,7 +1014,7 @@ static int latency_wakeup_event(struct perf_sched *sched,
 	struct thread *wakee;
 	u64 timestamp = sample->time;
 
-	wakee = machine__findnew_thread(machine, 0, pid);
+	wakee = machine__findnew_thread(machine, -1, pid);
 	atoms = thread_atoms_search(&sched->atom_root, wakee, &sched->cmp_pid);
 	if (!atoms) {
 		if (thread_atoms_insert(sched, wakee))
@@ -1072,7 +1074,7 @@ static int latency_migrate_task_event(struct perf_sched *sched,
 	if (sched->profile_cpu == -1)
 		return 0;
 
-	migrant = machine__findnew_thread(machine, 0, pid);
+	migrant = machine__findnew_thread(machine, -1, pid);
 	atoms = thread_atoms_search(&sched->atom_root, migrant, &sched->cmp_pid);
 	if (!atoms) {
 		if (thread_atoms_insert(sched, migrant))
@@ -1290,7 +1292,7 @@ static int map_switch_event(struct perf_sched *sched, struct perf_evsel *evsel,
 		return -1;
 	}
 
-	sched_in = machine__findnew_thread(machine, 0, next_pid);
+	sched_in = machine__findnew_thread(machine, -1, next_pid);
 
 	sched->curr_thread[this_cpu] = sched_in;
 
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 9e9c91f..f57035b 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -358,27 +358,6 @@ static void print_sample_start(struct perf_sample *sample,
 	}
 }
 
-static bool is_bts_event(struct perf_event_attr *attr)
-{
-	return ((attr->type == PERF_TYPE_HARDWARE) &&
-		(attr->config & PERF_COUNT_HW_BRANCH_INSTRUCTIONS) &&
-		(attr->sample_period == 1));
-}
-
-static bool sample_addr_correlates_sym(struct perf_event_attr *attr)
-{
-	if ((attr->type == PERF_TYPE_SOFTWARE) &&
-	    ((attr->config == PERF_COUNT_SW_PAGE_FAULTS) ||
-	     (attr->config == PERF_COUNT_SW_PAGE_FAULTS_MIN) ||
-	     (attr->config == PERF_COUNT_SW_PAGE_FAULTS_MAJ)))
-		return true;
-
-	if (is_bts_event(attr))
-		return true;
-
-	return false;
-}
-
 static void print_sample_addr(union perf_event *event,
 			  struct perf_sample *sample,
 			  struct machine *machine,
@@ -386,24 +365,13 @@ static void print_sample_addr(union perf_event *event,
 			  struct perf_event_attr *attr)
 {
 	struct addr_location al;
-	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
 	printf("%16" PRIx64, sample->addr);
 
 	if (!sample_addr_correlates_sym(attr))
 		return;
 
-	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
-			      sample->addr, &al);
-	if (!al.map)
-		thread__find_addr_map(thread, machine, cpumode, MAP__VARIABLE,
-				      sample->addr, &al);
-
-	al.cpu = sample->cpu;
-	al.sym = NULL;
-
-	if (al.map)
-		al.sym = map__find_symbol(al.map, al.addr, NULL);
+	perf_event__preprocess_sample_addr(event, sample, machine, thread, &al);
 
 	if (PRINT_FIELD(SYM)) {
 		printf(" ");
@@ -427,25 +395,35 @@ static void print_sample_bts(union perf_event *event,
 			     struct addr_location *al)
 {
 	struct perf_event_attr *attr = &evsel->attr;
+	bool print_srcline_last = false;
 
 	/* print branch_from information */
 	if (PRINT_FIELD(IP)) {
-		if (!symbol_conf.use_callchain)
-			printf(" ");
-		else
+		unsigned int print_opts = output[attr->type].print_ip_opts;
+
+		if (symbol_conf.use_callchain && sample->callchain) {
 			printf("\n");
-		perf_evsel__print_ip(evsel, sample, al,
-				     output[attr->type].print_ip_opts,
+		} else {
+			printf(" ");
+			if (print_opts & PRINT_IP_OPT_SRCLINE) {
+				print_srcline_last = true;
+				print_opts &= ~PRINT_IP_OPT_SRCLINE;
+			}
+		}
+		perf_evsel__print_ip(evsel, sample, al, print_opts,
 				     PERF_MAX_STACK_DEPTH);
 	}
 
-	printf(" => ");
-
 	/* print branch_to information */
 	if (PRINT_FIELD(ADDR) ||
 	    ((evsel->attr.sample_type & PERF_SAMPLE_ADDR) &&
-	     !output[attr->type].user_set))
+	     !output[attr->type].user_set)) {
+		printf(" => ");
 		print_sample_addr(event, sample, al->machine, thread, attr);
+	}
+
+	if (print_srcline_last)
+		map__fprintf_srcline(al->map, al->addr, "\n  ", stdout);
 
 	printf("\n");
 }
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 65a151e..3e80aa1 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -184,7 +184,7 @@ static void perf_evsel__reset_stat_priv(struct perf_evsel *evsel)
 static int perf_evsel__alloc_stat_priv(struct perf_evsel *evsel)
 {
 	evsel->priv = zalloc(sizeof(struct perf_stat));
-	if (evsel == NULL)
+	if (evsel->priv == NULL)
 		return -ENOMEM;
 	perf_evsel__reset_stat_priv(evsel);
 	return 0;
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 74db256..2f1a522 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -37,6 +37,7 @@
 #include "util/svghelper.h"
 #include "util/tool.h"
 #include "util/data.h"
+#include "util/debug.h"
 
 #define SUPPORT_OLD_POWER_EVENTS 1
 #define PWR_EVENT_EXIT -1
@@ -60,10 +61,17 @@ struct timechart {
 				tasks_only,
 				with_backtrace,
 				topology;
+	/* IO related settings */
+	u64			io_events;
+	bool			io_only,
+				skip_eagain;
+	u64			min_time,
+				merge_dist;
 };
 
 struct per_pidcomm;
 struct cpu_sample;
+struct io_sample;
 
 /*
  * Datastructure layout:
@@ -84,6 +92,7 @@ struct per_pid {
 	u64		start_time;
 	u64		end_time;
 	u64		total_time;
+	u64		total_bytes;
 	int		display;
 
 	struct per_pidcomm *all;
@@ -97,6 +106,8 @@ struct per_pidcomm {
 	u64		start_time;
 	u64		end_time;
 	u64		total_time;
+	u64		max_bytes;
+	u64		total_bytes;
 
 	int		Y;
 	int		display;
@@ -107,6 +118,7 @@ struct per_pidcomm {
 	char		*comm;
 
 	struct cpu_sample *samples;
+	struct io_sample  *io_samples;
 };
 
 struct sample_wrapper {
@@ -131,6 +143,27 @@ struct cpu_sample {
 	const char *backtrace;
 };
 
+enum {
+	IOTYPE_READ,
+	IOTYPE_WRITE,
+	IOTYPE_SYNC,
+	IOTYPE_TX,
+	IOTYPE_RX,
+	IOTYPE_POLL,
+};
+
+struct io_sample {
+	struct io_sample *next;
+
+	u64 start_time;
+	u64 end_time;
+	u64 bytes;
+	int type;
+	int fd;
+	int err;
+	int merges;
+};
+
 #define CSTATE 1
 #define PSTATE 2
 
@@ -213,7 +246,7 @@ static void pid_fork(struct timechart *tchart, int pid, int ppid, u64 timestamp)
 		pid_set_comm(tchart, pid, pp->current->comm);
 
 	p->start_time = timestamp;
-	if (p->current) {
+	if (p->current && !p->current->start_time) {
 		p->current->start_time = timestamp;
 		p->current->state_since = timestamp;
 	}
@@ -682,6 +715,249 @@ static void end_sample_processing(struct timechart *tchart)
 	}
 }
 
+static int pid_begin_io_sample(struct timechart *tchart, int pid, int type,
+			       u64 start, int fd)
+{
+	struct per_pid *p = find_create_pid(tchart, pid);
+	struct per_pidcomm *c = p->current;
+	struct io_sample *sample;
+	struct io_sample *prev;
+
+	if (!c) {
+		c = zalloc(sizeof(*c));
+		if (!c)
+			return -ENOMEM;
+		p->current = c;
+		c->next = p->all;
+		p->all = c;
+	}
+
+	prev = c->io_samples;
+
+	if (prev && prev->start_time && !prev->end_time) {
+		pr_warning("Skip invalid start event: "
+			   "previous event already started!\n");
+
+		/* remove previous event that has been started,
+		 * we are not sure we will ever get an end for it */
+		c->io_samples = prev->next;
+		free(prev);
+		return 0;
+	}
+
+	sample = zalloc(sizeof(*sample));
+	if (!sample)
+		return -ENOMEM;
+	sample->start_time = start;
+	sample->type = type;
+	sample->fd = fd;
+	sample->next = c->io_samples;
+	c->io_samples = sample;
+
+	if (c->start_time == 0 || c->start_time > start)
+		c->start_time = start;
+
+	return 0;
+}
+
+static int pid_end_io_sample(struct timechart *tchart, int pid, int type,
+			     u64 end, long ret)
+{
+	struct per_pid *p = find_create_pid(tchart, pid);
+	struct per_pidcomm *c = p->current;
+	struct io_sample *sample, *prev;
+
+	if (!c) {
+		pr_warning("Invalid pidcomm!\n");
+		return -1;
+	}
+
+	sample = c->io_samples;
+
+	if (!sample) /* skip partially captured events */
+		return 0;
+
+	if (sample->end_time) {
+		pr_warning("Skip invalid end event: "
+			   "previous event already ended!\n");
+		return 0;
+	}
+
+	if (sample->type != type) {
+		pr_warning("Skip invalid end event: invalid event type!\n");
+		return 0;
+	}
+
+	sample->end_time = end;
+	prev = sample->next;
+
+	/* we want to be able to see small and fast transfers, so make them
+	 * at least min_time long, but don't overlap them */
+	if (sample->end_time - sample->start_time < tchart->min_time)
+		sample->end_time = sample->start_time + tchart->min_time;
+	if (prev && sample->start_time < prev->end_time) {
+		if (prev->err) /* try to make errors more visible */
+			sample->start_time = prev->end_time;
+		else
+			prev->end_time = sample->start_time;
+	}
+
+	if (ret < 0) {
+		sample->err = ret;
+	} else if (type == IOTYPE_READ || type == IOTYPE_WRITE ||
+		   type == IOTYPE_TX || type == IOTYPE_RX) {
+
+		if ((u64)ret > c->max_bytes)
+			c->max_bytes = ret;
+
+		c->total_bytes += ret;
+		p->total_bytes += ret;
+		sample->bytes = ret;
+	}
+
+	/* merge two requests to make svg smaller and render-friendly */
+	if (prev &&
+	    prev->type == sample->type &&
+	    prev->err == sample->err &&
+	    prev->fd == sample->fd &&
+	    prev->end_time + tchart->merge_dist >= sample->start_time) {
+
+		sample->bytes += prev->bytes;
+		sample->merges += prev->merges + 1;
+
+		sample->start_time = prev->start_time;
+		sample->next = prev->next;
+		free(prev);
+
+		if (!sample->err && sample->bytes > c->max_bytes)
+			c->max_bytes = sample->bytes;
+	}
+
+	tchart->io_events++;
+
+	return 0;
+}
+
+static int
+process_enter_read(struct timechart *tchart,
+		   struct perf_evsel *evsel,
+		   struct perf_sample *sample)
+{
+	long fd = perf_evsel__intval(evsel, sample, "fd");
+	return pid_begin_io_sample(tchart, sample->tid, IOTYPE_READ,
+				   sample->time, fd);
+}
+
+static int
+process_exit_read(struct timechart *tchart,
+		  struct perf_evsel *evsel,
+		  struct perf_sample *sample)
+{
+	long ret = perf_evsel__intval(evsel, sample, "ret");
+	return pid_end_io_sample(tchart, sample->tid, IOTYPE_READ,
+				 sample->time, ret);
+}
+
+static int
+process_enter_write(struct timechart *tchart,
+		    struct perf_evsel *evsel,
+		    struct perf_sample *sample)
+{
+	long fd = perf_evsel__intval(evsel, sample, "fd");
+	return pid_begin_io_sample(tchart, sample->tid, IOTYPE_WRITE,
+				   sample->time, fd);
+}
+
+static int
+process_exit_write(struct timechart *tchart,
+		   struct perf_evsel *evsel,
+		   struct perf_sample *sample)
+{
+	long ret = perf_evsel__intval(evsel, sample, "ret");
+	return pid_end_io_sample(tchart, sample->tid, IOTYPE_WRITE,
+				 sample->time, ret);
+}
+
+static int
+process_enter_sync(struct timechart *tchart,
+		   struct perf_evsel *evsel,
+		   struct perf_sample *sample)
+{
+	long fd = perf_evsel__intval(evsel, sample, "fd");
+	return pid_begin_io_sample(tchart, sample->tid, IOTYPE_SYNC,
+				   sample->time, fd);
+}
+
+static int
+process_exit_sync(struct timechart *tchart,
+		  struct perf_evsel *evsel,
+		  struct perf_sample *sample)
+{
+	long ret = perf_evsel__intval(evsel, sample, "ret");
+	return pid_end_io_sample(tchart, sample->tid, IOTYPE_SYNC,
+				 sample->time, ret);
+}
+
+static int
+process_enter_tx(struct timechart *tchart,
+		 struct perf_evsel *evsel,
+		 struct perf_sample *sample)
+{
+	long fd = perf_evsel__intval(evsel, sample, "fd");
+	return pid_begin_io_sample(tchart, sample->tid, IOTYPE_TX,
+				   sample->time, fd);
+}
+
+static int
+process_exit_tx(struct timechart *tchart,
+		struct perf_evsel *evsel,
+		struct perf_sample *sample)
+{
+	long ret = perf_evsel__intval(evsel, sample, "ret");
+	return pid_end_io_sample(tchart, sample->tid, IOTYPE_TX,
+				 sample->time, ret);
+}
+
+static int
+process_enter_rx(struct timechart *tchart,
+		 struct perf_evsel *evsel,
+		 struct perf_sample *sample)
+{
+	long fd = perf_evsel__intval(evsel, sample, "fd");
+	return pid_begin_io_sample(tchart, sample->tid, IOTYPE_RX,
+				   sample->time, fd);
+}
+
+static int
+process_exit_rx(struct timechart *tchart,
+		struct perf_evsel *evsel,
+		struct perf_sample *sample)
+{
+	long ret = perf_evsel__intval(evsel, sample, "ret");
+	return pid_end_io_sample(tchart, sample->tid, IOTYPE_RX,
+				 sample->time, ret);
+}
+
+static int
+process_enter_poll(struct timechart *tchart,
+		   struct perf_evsel *evsel,
+		   struct perf_sample *sample)
+{
+	long fd = perf_evsel__intval(evsel, sample, "fd");
+	return pid_begin_io_sample(tchart, sample->tid, IOTYPE_POLL,
+				   sample->time, fd);
+}
+
+static int
+process_exit_poll(struct timechart *tchart,
+		  struct perf_evsel *evsel,
+		  struct perf_sample *sample)
+{
+	long ret = perf_evsel__intval(evsel, sample, "ret");
+	return pid_end_io_sample(tchart, sample->tid, IOTYPE_POLL,
+				 sample->time, ret);
+}
+
 /*
  * Sort the pid datastructure
  */
@@ -852,6 +1128,121 @@ static void draw_cpu_usage(struct timechart *tchart)
 	}
 }
 
+static void draw_io_bars(struct timechart *tchart)
+{
+	const char *suf;
+	double bytes;
+	char comm[256];
+	struct per_pid *p;
+	struct per_pidcomm *c;
+	struct io_sample *sample;
+	int Y = 1;
+
+	p = tchart->all_data;
+	while (p) {
+		c = p->all;
+		while (c) {
+			if (!c->display) {
+				c->Y = 0;
+				c = c->next;
+				continue;
+			}
+
+			svg_box(Y, c->start_time, c->end_time, "process3");
+			sample = c->io_samples;
+			for (sample = c->io_samples; sample; sample = sample->next) {
+				double h = (double)sample->bytes / c->max_bytes;
+
+				if (tchart->skip_eagain &&
+				    sample->err == -EAGAIN)
+					continue;
+
+				if (sample->err)
+					h = 1;
+
+				if (sample->type == IOTYPE_SYNC)
+					svg_fbox(Y,
+						sample->start_time,
+						sample->end_time,
+						1,
+						sample->err ? "error" : "sync",
+						sample->fd,
+						sample->err,
+						sample->merges);
+				else if (sample->type == IOTYPE_POLL)
+					svg_fbox(Y,
+						sample->start_time,
+						sample->end_time,
+						1,
+						sample->err ? "error" : "poll",
+						sample->fd,
+						sample->err,
+						sample->merges);
+				else if (sample->type == IOTYPE_READ)
+					svg_ubox(Y,
+						sample->start_time,
+						sample->end_time,
+						h,
+						sample->err ? "error" : "disk",
+						sample->fd,
+						sample->err,
+						sample->merges);
+				else if (sample->type == IOTYPE_WRITE)
+					svg_lbox(Y,
+						sample->start_time,
+						sample->end_time,
+						h,
+						sample->err ? "error" : "disk",
+						sample->fd,
+						sample->err,
+						sample->merges);
+				else if (sample->type == IOTYPE_RX)
+					svg_ubox(Y,
+						sample->start_time,
+						sample->end_time,
+						h,
+						sample->err ? "error" : "net",
+						sample->fd,
+						sample->err,
+						sample->merges);
+				else if (sample->type == IOTYPE_TX)
+					svg_lbox(Y,
+						sample->start_time,
+						sample->end_time,
+						h,
+						sample->err ? "error" : "net",
+						sample->fd,
+						sample->err,
+						sample->merges);
+			}
+
+			suf = "";
+			bytes = c->total_bytes;
+			if (bytes > 1024) {
+				bytes = bytes / 1024;
+				suf = "K";
+			}
+			if (bytes > 1024) {
+				bytes = bytes / 1024;
+				suf = "M";
+			}
+			if (bytes > 1024) {
+				bytes = bytes / 1024;
+				suf = "G";
+			}
+
+
+			sprintf(comm, "%s:%i (%3.1f %sbytes)", c->comm ?: "", p->pid, bytes, suf);
+			svg_text(Y, c->start_time, comm);
+
+			c->Y = Y;
+			Y++;
+			c = c->next;
+		}
+		p = p->next;
+	}
+}
+
 static void draw_process_bars(struct timechart *tchart)
 {
 	struct per_pid *p;
@@ -987,9 +1378,6 @@ static int determine_display_tasks(struct timechart *tchart, u64 threshold)
 	struct per_pidcomm *c;
 	int count = 0;
 
-	if (process_filter)
-		return determine_display_tasks_filtered(tchart);
-
 	p = tchart->all_data;
 	while (p) {
 		p->display = 0;
@@ -1025,15 +1413,46 @@ static int determine_display_tasks(struct timechart *tchart, u64 threshold)
 	return count;
 }
 
+static int determine_display_io_tasks(struct timechart *timechart, u64 threshold)
+{
+	struct per_pid *p;
+	struct per_pidcomm *c;
+	int count = 0;
+
+	p = timechart->all_data;
+	while (p) {
+		/* no exit marker, task kept running to the end */
+		if (p->end_time == 0)
+			p->end_time = timechart->last_time;
 
+		c = p->all;
 
+		while (c) {
+			c->display = 0;
+
+			if (c->total_bytes >= threshold) {
+				c->display = 1;
+				count++;
+			}
+
+			if (c->end_time == 0)
+				c->end_time = timechart->last_time;
+
+			c = c->next;
+		}
+		p = p->next;
+	}
+	return count;
+}
+
+#define BYTES_THRESH (1 * 1024 * 1024)
 #define TIME_THRESH 10000000
 
 static void write_svg_file(struct timechart *tchart, const char *filename)
 {
 	u64 i;
 	int count;
-	int thresh = TIME_THRESH;
+	int thresh = tchart->io_events ? BYTES_THRESH : TIME_THRESH;
 
 	if (tchart->power_only)
 		tchart->proc_num = 0;
@@ -1041,28 +1460,43 @@ static void write_svg_file(struct timechart *tchart, const char *filename)
 	/* We'd like to show at least proc_num tasks;
 	 * be less picky if we have fewer */
 	do {
-		count = determine_display_tasks(tchart, thresh);
+		if (process_filter)
+			count = determine_display_tasks_filtered(tchart);
+		else if (tchart->io_events)
+			count = determine_display_io_tasks(tchart, thresh);
+		else
+			count = determine_display_tasks(tchart, thresh);
 		thresh /= 10;
 	} while (!process_filter && thresh && count < tchart->proc_num);
 
 	if (!tchart->proc_num)
 		count = 0;
 
-	open_svg(filename, tchart->numcpus, count, tchart->first_time, tchart->last_time);
+	if (tchart->io_events) {
+		open_svg(filename, 0, count, tchart->first_time, tchart->last_time);
 
-	svg_time_grid();
-	svg_legenda();
+		svg_time_grid(0.5);
+		svg_io_legenda();
+
+		draw_io_bars(tchart);
+	} else {
+		open_svg(filename, tchart->numcpus, count, tchart->first_time, tchart->last_time);
 
-	for (i = 0; i < tchart->numcpus; i++)
-		svg_cpu_box(i, tchart->max_freq, tchart->turbo_frequency);
+		svg_time_grid(0);
 
-	draw_cpu_usage(tchart);
-	if (tchart->proc_num)
-		draw_process_bars(tchart);
-	if (!tchart->tasks_only)
-		draw_c_p_states(tchart);
-	if (tchart->proc_num)
-		draw_wakeups(tchart);
+		svg_legenda();
+
+		for (i = 0; i < tchart->numcpus; i++)
+			svg_cpu_box(i, tchart->max_freq, tchart->turbo_frequency);
+
+		draw_cpu_usage(tchart);
+		if (tchart->proc_num)
+			draw_process_bars(tchart);
+		if (!tchart->tasks_only)
+			draw_c_p_states(tchart);
+		if (tchart->proc_num)
+			draw_wakeups(tchart);
+	}
 
 	svg_close();
 }
@@ -1110,6 +1544,56 @@ static int __cmd_timechart(struct timechart *tchart, const char *output_name)
 		{ "power:power_end",		process_sample_power_end },
 		{ "power:power_frequency",	process_sample_power_frequency },
 #endif
+
+		{ "syscalls:sys_enter_read",		process_enter_read },
+		{ "syscalls:sys_enter_pread64",		process_enter_read },
+		{ "syscalls:sys_enter_readv",		process_enter_read },
+		{ "syscalls:sys_enter_preadv",		process_enter_read },
+		{ "syscalls:sys_enter_write",		process_enter_write },
+		{ "syscalls:sys_enter_pwrite64",	process_enter_write },
+		{ "syscalls:sys_enter_writev",		process_enter_write },
+		{ "syscalls:sys_enter_pwritev",		process_enter_write },
+		{ "syscalls:sys_enter_sync",		process_enter_sync },
+		{ "syscalls:sys_enter_sync_file_range",	process_enter_sync },
+		{ "syscalls:sys_enter_fsync",		process_enter_sync },
+		{ "syscalls:sys_enter_msync",		process_enter_sync },
+		{ "syscalls:sys_enter_recvfrom",	process_enter_rx },
+		{ "syscalls:sys_enter_recvmmsg",	process_enter_rx },
+		{ "syscalls:sys_enter_recvmsg",		process_enter_rx },
+		{ "syscalls:sys_enter_sendto",		process_enter_tx },
+		{ "syscalls:sys_enter_sendmsg",		process_enter_tx },
+		{ "syscalls:sys_enter_sendmmsg",	process_enter_tx },
+		{ "syscalls:sys_enter_epoll_pwait",	process_enter_poll },
+		{ "syscalls:sys_enter_epoll_wait",	process_enter_poll },
+		{ "syscalls:sys_enter_poll",		process_enter_poll },
+		{ "syscalls:sys_enter_ppoll",		process_enter_poll },
+		{ "syscalls:sys_enter_pselect6",	process_enter_poll },
+		{ "syscalls:sys_enter_select",		process_enter_poll },
+
+		{ "syscalls:sys_exit_read",		process_exit_read },
+		{ "syscalls:sys_exit_pread64",		process_exit_read },
+		{ "syscalls:sys_exit_readv",		process_exit_read },
+		{ "syscalls:sys_exit_preadv",		process_exit_read },
+		{ "syscalls:sys_exit_write",		process_exit_write },
+		{ "syscalls:sys_exit_pwrite64",		process_exit_write },
+		{ "syscalls:sys_exit_writev",		process_exit_write },
+		{ "syscalls:sys_exit_pwritev",		process_exit_write },
+		{ "syscalls:sys_exit_sync",		process_exit_sync },
+		{ "syscalls:sys_exit_sync_file_range",	process_exit_sync },
+		{ "syscalls:sys_exit_fsync",		process_exit_sync },
+		{ "syscalls:sys_exit_msync",		process_exit_sync },
+		{ "syscalls:sys_exit_recvfrom",		process_exit_rx },
+		{ "syscalls:sys_exit_recvmmsg",		process_exit_rx },
+		{ "syscalls:sys_exit_recvmsg",		process_exit_rx },
+		{ "syscalls:sys_exit_sendto",		process_exit_tx },
+		{ "syscalls:sys_exit_sendmsg",		process_exit_tx },
+		{ "syscalls:sys_exit_sendmmsg",		process_exit_tx },
+		{ "syscalls:sys_exit_epoll_pwait",	process_exit_poll },
+		{ "syscalls:sys_exit_epoll_wait",	process_exit_poll },
+		{ "syscalls:sys_exit_poll",		process_exit_poll },
+		{ "syscalls:sys_exit_ppoll",		process_exit_poll },
+		{ "syscalls:sys_exit_pselect6",		process_exit_poll },
+		{ "syscalls:sys_exit_select",		process_exit_poll },
 	};
 	struct perf_data_file file = {
 		.path = input_name,
@@ -1154,6 +1638,139 @@ out_delete:
 	return ret;
 }
 
+static int timechart__io_record(int argc, const char **argv)
+{
+	unsigned int rec_argc, i;
+	const char **rec_argv;
+	const char **p;
+	char *filter = NULL;
+
+	const char * const common_args[] = {
+		"record", "-a", "-R", "-c", "1",
+	};
+	unsigned int common_args_nr = ARRAY_SIZE(common_args);
+
+	const char * const disk_events[] = {
+		"syscalls:sys_enter_read",
+		"syscalls:sys_enter_pread64",
+		"syscalls:sys_enter_readv",
+		"syscalls:sys_enter_preadv",
+		"syscalls:sys_enter_write",
+		"syscalls:sys_enter_pwrite64",
+		"syscalls:sys_enter_writev",
+		"syscalls:sys_enter_pwritev",
+		"syscalls:sys_enter_sync",
+		"syscalls:sys_enter_sync_file_range",
+		"syscalls:sys_enter_fsync",
+		"syscalls:sys_enter_msync",
+
+		"syscalls:sys_exit_read",
+		"syscalls:sys_exit_pread64",
+		"syscalls:sys_exit_readv",
+		"syscalls:sys_exit_preadv",
+		"syscalls:sys_exit_write",
+		"syscalls:sys_exit_pwrite64",
+		"syscalls:sys_exit_writev",
+		"syscalls:sys_exit_pwritev",
+		"syscalls:sys_exit_sync",
+		"syscalls:sys_exit_sync_file_range",
+		"syscalls:sys_exit_fsync",
+		"syscalls:sys_exit_msync",
+	};
+	unsigned int disk_events_nr = ARRAY_SIZE(disk_events);
+
+	const char * const net_events[] = {
+		"syscalls:sys_enter_recvfrom",
+		"syscalls:sys_enter_recvmmsg",
+		"syscalls:sys_enter_recvmsg",
+		"syscalls:sys_enter_sendto",
+		"syscalls:sys_enter_sendmsg",
+		"syscalls:sys_enter_sendmmsg",
+
+		"syscalls:sys_exit_recvfrom",
+		"syscalls:sys_exit_recvmmsg",
+		"syscalls:sys_exit_recvmsg",
+		"syscalls:sys_exit_sendto",
+		"syscalls:sys_exit_sendmsg",
+		"syscalls:sys_exit_sendmmsg",
+	};
+	unsigned int net_events_nr = ARRAY_SIZE(net_events);
+
+	const char * const poll_events[] = {
+		"syscalls:sys_enter_epoll_pwait",
+		"syscalls:sys_enter_epoll_wait",
+		"syscalls:sys_enter_poll",
+		"syscalls:sys_enter_ppoll",
+		"syscalls:sys_enter_pselect6",
+		"syscalls:sys_enter_select",
+
+		"syscalls:sys_exit_epoll_pwait",
+		"syscalls:sys_exit_epoll_wait",
+		"syscalls:sys_exit_poll",
+		"syscalls:sys_exit_ppoll",
+		"syscalls:sys_exit_pselect6",
+		"syscalls:sys_exit_select",
+	};
+	unsigned int poll_events_nr = ARRAY_SIZE(poll_events);
+
+	rec_argc = common_args_nr +
+		disk_events_nr * 4 +
+		net_events_nr * 4 +
+		poll_events_nr * 4 +
+		argc;
+	rec_argv = calloc(rec_argc + 1, sizeof(char *));
+
+	if (rec_argv == NULL)
+		return -ENOMEM;
+
+	if (asprintf(&filter, "common_pid != %d", getpid()) < 0)
+		return -ENOMEM;
+
+	p = rec_argv;
+	for (i = 0; i < common_args_nr; i++)
+		*p++ = strdup(common_args[i]);
+
+	for (i = 0; i < disk_events_nr; i++) {
+		if (!is_valid_tracepoint(disk_events[i])) {
+			rec_argc -= 4;
+			continue;
+		}
+
+		*p++ = "-e";
+		*p++ = strdup(disk_events[i]);
+		*p++ = "--filter";
+		*p++ = filter;
+	}
+	for (i = 0; i < net_events_nr; i++) {
+		if (!is_valid_tracepoint(net_events[i])) {
+			rec_argc -= 4;
+			continue;
+		}
+
+		*p++ = "-e";
+		*p++ = strdup(net_events[i]);
+		*p++ = "--filter";
+		*p++ = filter;
+	}
+	for (i = 0; i < poll_events_nr; i++) {
+		if (!is_valid_tracepoint(poll_events[i])) {
+			rec_argc -= 4;
+			continue;
+		}
+
+		*p++ = "-e";
+		*p++ = strdup(poll_events[i]);
+		*p++ = "--filter";
+		*p++ = filter;
+	}
+
+	for (i = 0; i < (unsigned int)argc; i++)
+		*p++ = argv[i];
+
+	return cmd_record(rec_argc, rec_argv, NULL);
+}
+
+
 static int timechart__record(struct timechart *tchart, int argc, const char **argv)
 {
 	unsigned int rec_argc, i, j;
@@ -1270,6 +1887,30 @@ parse_highlight(const struct option *opt __maybe_unused, const char *arg,
 	return 0;
 }
 
+static int
+parse_time(const struct option *opt, const char *arg, int __maybe_unused unset)
+{
+	char unit = 'n';
+	u64 *value = opt->value;
+
+	if (sscanf(arg, "%" PRIu64 "%cs", value, &unit) > 0) {
+		switch (unit) {
+		case 'm':
+			*value *= 1000000;
+			break;
+		case 'u':
+			*value *= 1000;
+			break;
+		case 'n':
+			break;
+		default:
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
 int cmd_timechart(int argc, const char **argv,
 		  const char *prefix __maybe_unused)
 {
@@ -1282,6 +1923,8 @@ int cmd_timechart(int argc, const char **argv,
 			.ordered_samples = true,
 		},
 		.proc_num = 15,
+		.min_time = 1000000,
+		.merge_dist = 1000,
 	};
 	const char *output_name = "output.svg";
 	const struct option timechart_options[] = {
@@ -1303,6 +1946,14 @@ int cmd_timechart(int argc, const char **argv,
 		    "min. number of tasks to print"),
 	OPT_BOOLEAN('t', "topology", &tchart.topology,
 		    "sort CPUs according to topology"),
+	OPT_BOOLEAN(0, "io-skip-eagain", &tchart.skip_eagain,
+		    "skip EAGAIN errors"),
+	OPT_CALLBACK(0, "io-min-time", &tchart.min_time, "time",
+		     "all IO faster than min-time will visually appear longer",
+		     parse_time),
+	OPT_CALLBACK(0, "io-merge-dist", &tchart.merge_dist, "time",
+		     "merge events that are merge-dist us apart",
+		     parse_time),
 	OPT_END()
 	};
 	const char * const timechart_usage[] = {
@@ -1314,6 +1965,8 @@ int cmd_timechart(int argc, const char **argv,
 	OPT_BOOLEAN('P', "power-only", &tchart.power_only, "output power data only"),
 	OPT_BOOLEAN('T', "tasks-only", &tchart.tasks_only,
 		    "output processes data only"),
+	OPT_BOOLEAN('I', "io-only", &tchart.io_only,
+		    "record only IO data"),
 	OPT_BOOLEAN('g', "callchain", &tchart.with_backtrace, "record callchain"),
 	OPT_END()
 	};
@@ -1340,7 +1993,10 @@ int cmd_timechart(int argc, const char **argv,
 			return -1;
 		}
 
-		return timechart__record(&tchart, argc, argv);
+		if (tchart.io_only)
+			return timechart__io_record(argc, argv);
+		else
+			return timechart__record(&tchart, argc, argv);
 	} else if (argc)
 		usage_with_options(timechart_usage, timechart_options);
 
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f954c26..a6c3752 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1108,6 +1108,7 @@ struct syscall {
 	struct event_format *tp_format;
 	const char	    *name;
 	bool		    filtered;
+	bool		    is_exit;
 	struct syscall_fmt  *fmt;
 	size_t		    (**arg_scnprintf)(char *bf, size_t size, struct syscall_arg *arg);
 	void		    **arg_parm;
@@ -1132,6 +1133,7 @@ struct thread_trace {
 	u64		  exit_time;
 	bool		  entry_pending;
 	unsigned long	  nr_events;
+	unsigned long	  pfmaj, pfmin;
 	char		  *entry_str;
 	double		  runtime_ms;
 	struct {
@@ -1177,6 +1179,9 @@ fail:
 	return NULL;
 }
 
+#define TRACE_PFMAJ		(1 << 0)
+#define TRACE_PFMIN		(1 << 1)
+
 struct trace {
 	struct perf_tool	tool;
 	struct {
@@ -1211,6 +1216,8 @@ struct trace {
 	bool			summary_only;
 	bool			show_comm;
 	bool			show_tool_stats;
+	bool			trace_syscalls;
+	int			trace_pgfaults;
 };
 
 static int trace__set_fd_pathname(struct thread *thread, int fd, const char *pathname)
@@ -1276,11 +1283,11 @@ static const char *thread__fd_path(struct thread *thread, int fd,
 	if (fd < 0)
 		return NULL;
 
-	if ((fd > ttrace->paths.max || ttrace->paths.table[fd] == NULL))
+	if ((fd > ttrace->paths.max || ttrace->paths.table[fd] == NULL)) {
 		if (!trace->live)
 			return NULL;
 		++trace->stats.proc_getname;
-		if (thread__read_fd_path(thread, fd)) {
+		if (thread__read_fd_path(thread, fd))
 			return NULL;
 	}
 
@@ -1473,6 +1480,8 @@ static int trace__read_syscall_info(struct trace *trace, int id)
 	if (sc->tp_format == NULL)
 		return -1;
 
+	sc->is_exit = !strcmp(name, "exit_group") || !strcmp(name, "exit");
+
 	return syscall__set_arg_fmts(sc);
 }
 
@@ -1535,6 +1544,7 @@ static size_t syscall__scnprintf_args(struct syscall *sc, char *bf, size_t size,
 }
 
 typedef int (*tracepoint_handler)(struct trace *trace, struct perf_evsel *evsel,
+				  union perf_event *event,
 				  struct perf_sample *sample);
 
 static struct syscall *trace__syscall_info(struct trace *trace,
@@ -1607,6 +1617,7 @@ static void thread__update_stats(struct thread_trace *ttrace,
 }
 
 static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
+			    union perf_event *event __maybe_unused,
 			    struct perf_sample *sample)
 {
 	char *msg;
@@ -1629,7 +1640,6 @@ static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 		return -1;
 
 	args = perf_evsel__sc_tp_ptr(evsel, args, sample);
-	ttrace = thread->priv;
 
 	if (ttrace->entry_str == NULL) {
 		ttrace->entry_str = malloc(1024);
@@ -1644,7 +1654,7 @@ static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 	printed += syscall__scnprintf_args(sc, msg + printed, 1024 - printed,
 					   args, trace, thread);
 
-	if (!strcmp(sc->name, "exit_group") || !strcmp(sc->name, "exit")) {
+	if (sc->is_exit) {
 		if (!trace->duration_filter && !trace->summary_only) {
 			trace__fprintf_entry_head(trace, thread, 1, sample->time, trace->output);
 			fprintf(trace->output, "%-70s\n", ttrace->entry_str);
@@ -1656,6 +1666,7 @@ static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 }
 
 static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
+			   union perf_event *event __maybe_unused,
 			   struct perf_sample *sample)
 {
 	int ret;
@@ -1687,8 +1698,6 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 		++trace->stats.vfs_getname;
 	}
 
-	ttrace = thread->priv;
-
 	ttrace->exit_time = sample->time;
 
 	if (ttrace->entry_time) {
@@ -1735,6 +1744,7 @@ out:
 }
 
 static int trace__vfs_getname(struct trace *trace, struct perf_evsel *evsel,
+			      union perf_event *event __maybe_unused,
 			      struct perf_sample *sample)
 {
 	trace->last_vfs_getname = perf_evsel__rawptr(evsel, sample, "pathname");
@@ -1742,6 +1752,7 @@ static int trace__vfs_getname(struct trace *trace, struct perf_evsel *evsel,
 }
 
 static int trace__sched_stat_runtime(struct trace *trace, struct perf_evsel *evsel,
+				     union perf_event *event __maybe_unused,
 				     struct perf_sample *sample)
 {
         u64 runtime = perf_evsel__intval(evsel, sample, "runtime");
@@ -1768,6 +1779,80 @@ out_dump:
 	return 0;
 }
 
+static void print_location(FILE *f, struct perf_sample *sample,
+			   struct addr_location *al,
+			   bool print_dso, bool print_sym)
+{
+
+	if ((verbose || print_dso) && al->map)
+		fprintf(f, "%s@", al->map->dso->long_name);
+
+	if ((verbose || print_sym) && al->sym)
+		fprintf(f, "%s+0x%" PRIx64, al->sym->name,
+			al->addr - al->sym->start);
+	else if (al->map)
+		fprintf(f, "0x%" PRIx64, al->addr);
+	else
+		fprintf(f, "0x%" PRIx64, sample->addr);
+}
+
+static int trace__pgfault(struct trace *trace,
+			  struct perf_evsel *evsel,
+			  union perf_event *event,
+			  struct perf_sample *sample)
+{
+	struct thread *thread;
+	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+	struct addr_location al;
+	char map_type = 'd';
+	struct thread_trace *ttrace;
+
+	thread = machine__findnew_thread(trace->host, sample->pid, sample->tid);
+	ttrace = thread__trace(thread, trace->output);
+	if (ttrace == NULL)
+		return -1;
+
+	if (evsel->attr.config == PERF_COUNT_SW_PAGE_FAULTS_MAJ)
+		ttrace->pfmaj++;
+	else
+		ttrace->pfmin++;
+
+	if (trace->summary_only)
+		return 0;
+
+	thread__find_addr_location(thread, trace->host, cpumode, MAP__FUNCTION,
+			      sample->ip, &al);
+
+	trace__fprintf_entry_head(trace, thread, 0, sample->time, trace->output);
+
+	fprintf(trace->output, "%sfault [",
+		evsel->attr.config == PERF_COUNT_SW_PAGE_FAULTS_MAJ ?
+		"maj" : "min");
+
+	print_location(trace->output, sample, &al, false, true);
+
+	fprintf(trace->output, "] => ");
+
+	thread__find_addr_location(thread, trace->host, cpumode, MAP__VARIABLE,
+				   sample->addr, &al);
+
+	if (!al.map) {
+		thread__find_addr_location(thread, trace->host, cpumode,
+					   MAP__FUNCTION, sample->addr, &al);
+
+		if (al.map)
+			map_type = 'x';
+		else
+			map_type = '?';
+	}
+
+	print_location(trace->output, sample, &al, true, false);
+
+	fprintf(trace->output, " (%c%c)\n", map_type, al.level);
+
+	return 0;
+}
+
 static bool skip_sample(struct trace *trace, struct perf_sample *sample)
 {
 	if ((trace->pid_list && intlist__find(trace->pid_list, sample->pid)) ||
@@ -1781,7 +1866,7 @@ static bool skip_sample(struct trace *trace, struct perf_sample *sample)
 }
 
 static int trace__process_sample(struct perf_tool *tool,
-				 union perf_event *event __maybe_unused,
+				 union perf_event *event,
 				 struct perf_sample *sample,
 				 struct perf_evsel *evsel,
 				 struct machine *machine __maybe_unused)
@@ -1799,7 +1884,7 @@ static int trace__process_sample(struct perf_tool *tool,
 
 	if (handler) {
 		++trace->nr_events;
-		handler(trace, evsel, sample);
+		handler(trace, evsel, event, sample);
 	}
 
 	return err;
@@ -1826,7 +1911,7 @@ static int parse_target_str(struct trace *trace)
 	return 0;
 }
 
-static int trace__record(int argc, const char **argv)
+static int trace__record(struct trace *trace, int argc, const char **argv)
 {
 	unsigned int rec_argc, i, j;
 	const char **rec_argv;
@@ -1835,34 +1920,54 @@ static int trace__record(int argc, const char **argv)
 		"-R",
 		"-m", "1024",
 		"-c", "1",
-		"-e",
 	};
 
+	const char * const sc_args[] = { "-e", };
+	unsigned int sc_args_nr = ARRAY_SIZE(sc_args);
+	const char * const majpf_args[] = { "-e", "major-faults" };
+	unsigned int majpf_args_nr = ARRAY_SIZE(majpf_args);
+	const char * const minpf_args[] = { "-e", "minor-faults" };
+	unsigned int minpf_args_nr = ARRAY_SIZE(minpf_args);
+
 	/* +1 is for the event string below */
-	rec_argc = ARRAY_SIZE(record_args) + 1 + argc;
+	rec_argc = ARRAY_SIZE(record_args) + sc_args_nr + 1 +
+		majpf_args_nr + minpf_args_nr + argc;
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 
 	if (rec_argv == NULL)
 		return -ENOMEM;
 
+	j = 0;
 	for (i = 0; i < ARRAY_SIZE(record_args); i++)
-		rec_argv[i] = record_args[i];
-
-	/* event string may be different for older kernels - e.g., RHEL6 */
-	if (is_valid_tracepoint("raw_syscalls:sys_enter"))
-		rec_argv[i] = "raw_syscalls:sys_enter,raw_syscalls:sys_exit";
-	else if (is_valid_tracepoint("syscalls:sys_enter"))
-		rec_argv[i] = "syscalls:sys_enter,syscalls:sys_exit";
-	else {
-		pr_err("Neither raw_syscalls nor syscalls events exist.\n");
-		return -1;
+		rec_argv[j++] = record_args[i];
+
+	if (trace->trace_syscalls) {
+		for (i = 0; i < sc_args_nr; i++)
+			rec_argv[j++] = sc_args[i];
+
+		/* event string may be different for older kernels - e.g., RHEL6 */
+		if (is_valid_tracepoint("raw_syscalls:sys_enter"))
+			rec_argv[j++] = "raw_syscalls:sys_enter,raw_syscalls:sys_exit";
+		else if (is_valid_tracepoint("syscalls:sys_enter"))
+			rec_argv[j++] = "syscalls:sys_enter,syscalls:sys_exit";
+		else {
+			pr_err("Neither raw_syscalls nor syscalls events exist.\n");
+			return -1;
+		}
 	}
-	i++;
 
-	for (j = 0; j < (unsigned int)argc; j++, i++)
-		rec_argv[i] = argv[j];
+	if (trace->trace_pgfaults & TRACE_PFMAJ)
+		for (i = 0; i < majpf_args_nr; i++)
+			rec_argv[j++] = majpf_args[i];
+
+	if (trace->trace_pgfaults & TRACE_PFMIN)
+		for (i = 0; i < minpf_args_nr; i++)
+			rec_argv[j++] = minpf_args[i];
+
+	for (i = 0; i < (unsigned int)argc; i++)
+		rec_argv[j++] = argv[i];
 
-	return cmd_record(i, rec_argv, NULL);
+	return cmd_record(j, rec_argv, NULL);
 }
 
 static size_t trace__fprintf_thread_summary(struct trace *trace, FILE *fp);
@@ -1882,6 +1987,30 @@ static void perf_evlist__add_vfs_getname(struct perf_evlist *evlist)
 	perf_evlist__add(evlist, evsel);
 }
 
+static int perf_evlist__add_pgfault(struct perf_evlist *evlist,
+				    u64 config)
+{
+	struct perf_evsel *evsel;
+	struct perf_event_attr attr = {
+		.type = PERF_TYPE_SOFTWARE,
+		.mmap_data = 1,
+	};
+
+	attr.config = config;
+	attr.sample_period = 1;
+
+	event_attr_init(&attr);
+
+	evsel = perf_evsel__new(&attr);
+	if (!evsel)
+		return -ENOMEM;
+
+	evsel->handler = trace__pgfault;
+	perf_evlist__add(evlist, evsel);
+
+	return 0;
+}
+
 static int trace__run(struct trace *trace, int argc, const char **argv)
 {
 	struct perf_evlist *evlist = perf_evlist__new();
@@ -1897,10 +2026,21 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 		goto out;
 	}
 
-	if (perf_evlist__add_syscall_newtp(evlist, trace__sys_enter, trace__sys_exit))
+	if (trace->trace_syscalls &&
+	    perf_evlist__add_syscall_newtp(evlist, trace__sys_enter,
+					   trace__sys_exit))
 		goto out_error_tp;
 
-	perf_evlist__add_vfs_getname(evlist);
+	if (trace->trace_syscalls)
+		perf_evlist__add_vfs_getname(evlist);
+
+	if ((trace->trace_pgfaults & TRACE_PFMAJ) &&
+	    perf_evlist__add_pgfault(evlist, PERF_COUNT_SW_PAGE_FAULTS_MAJ))
+		goto out_error_tp;
+
+	if ((trace->trace_pgfaults & TRACE_PFMIN) &&
+	    perf_evlist__add_pgfault(evlist, PERF_COUNT_SW_PAGE_FAULTS_MIN))
+		goto out_error_tp;
 
 	if (trace->sched &&
 		perf_evlist__add_newtp(evlist, "sched", "sched_stat_runtime",
@@ -1982,7 +2122,8 @@ again:
 				goto next_event;
 			}
 
-			if (sample.raw_data == NULL) {
+			if (evsel->attr.type == PERF_TYPE_TRACEPOINT &&
+			    sample.raw_data == NULL) {
 				fprintf(trace->output, "%s sample with no payload for tid: %d, cpu %d, raw_size=%d, skipping...\n",
 				       perf_evsel__name(evsel), sample.tid,
 				       sample.cpu, sample.raw_size);
@@ -1990,7 +2131,7 @@ again:
 			}
 
 			handler = evsel->handler;
-			handler(trace, evsel, &sample);
+			handler(trace, evsel, event, &sample);
 next_event:
 			perf_evlist__mmap_consume(evlist, i);
 
@@ -2093,13 +2234,10 @@ static int trace__replay(struct trace *trace)
 	if (evsel == NULL)
 		evsel = perf_evlist__find_tracepoint_by_name(session->evlist,
 							     "syscalls:sys_enter");
-	if (evsel == NULL) {
-		pr_err("Data file does not have raw_syscalls:sys_enter event\n");
-		goto out;
-	}
 
-	if (perf_evsel__init_syscall_tp(evsel, trace__sys_enter) < 0 ||
-	    perf_evsel__init_sc_tp_ptr_field(evsel, args)) {
+	if (evsel &&
+	    (perf_evsel__init_syscall_tp(evsel, trace__sys_enter) < 0 ||
+	    perf_evsel__init_sc_tp_ptr_field(evsel, args))) {
 		pr_err("Error during initialize raw_syscalls:sys_enter event\n");
 		goto out;
 	}
@@ -2109,15 +2247,19 @@ static int trace__replay(struct trace *trace)
 	if (evsel == NULL)
 		evsel = perf_evlist__find_tracepoint_by_name(session->evlist,
 							     "syscalls:sys_exit");
-	if (evsel == NULL) {
-		pr_err("Data file does not have raw_syscalls:sys_exit event\n");
+	if (evsel &&
+	    (perf_evsel__init_syscall_tp(evsel, trace__sys_exit) < 0 ||
+	    perf_evsel__init_sc_tp_uint_field(evsel, ret))) {
+		pr_err("Error during initialize raw_syscalls:sys_exit event\n");
 		goto out;
 	}
 
-	if (perf_evsel__init_syscall_tp(evsel, trace__sys_exit) < 0 ||
-	    perf_evsel__init_sc_tp_uint_field(evsel, ret)) {
-		pr_err("Error during initialize raw_syscalls:sys_exit event\n");
-		goto out;
+	evlist__for_each(session->evlist, evsel) {
+		if (evsel->attr.type == PERF_TYPE_SOFTWARE &&
+		    (evsel->attr.config == PERF_COUNT_SW_PAGE_FAULTS_MAJ ||
+		     evsel->attr.config == PERF_COUNT_SW_PAGE_FAULTS_MIN ||
+		     evsel->attr.config == PERF_COUNT_SW_PAGE_FAULTS))
+			evsel->handler = trace__pgfault;
 	}
 
 	err = parse_target_str(trace);
@@ -2217,6 +2359,10 @@ static int trace__fprintf_one_thread(struct thread *thread, void *priv)
 	printed += fprintf(fp, " %s (%d), ", thread__comm_str(thread), thread->tid);
 	printed += fprintf(fp, "%lu events, ", ttrace->nr_events);
 	printed += fprintf(fp, "%.1f%%", ratio);
+	if (ttrace->pfmaj)
+		printed += fprintf(fp, ", %lu majfaults", ttrace->pfmaj);
+	if (ttrace->pfmin)
+		printed += fprintf(fp, ", %lu minfaults", ttrace->pfmin);
 	printed += fprintf(fp, ", %.3f msec\n", ttrace->runtime_ms);
 	printed += thread__dump_stats(ttrace, trace, fp);
 
@@ -2264,6 +2410,23 @@ static int trace__open_output(struct trace *trace, const char *filename)
 	return trace->output == NULL ? -errno : 0;
 }
 
+static int parse_pagefaults(const struct option *opt, const char *str,
+			    int unset __maybe_unused)
+{
+	int *trace_pgfaults = opt->value;
+
+	if (strcmp(str, "all") == 0)
+		*trace_pgfaults |= TRACE_PFMAJ | TRACE_PFMIN;
+	else if (strcmp(str, "maj") == 0)
+		*trace_pgfaults |= TRACE_PFMAJ;
+	else if (strcmp(str, "min") == 0)
+		*trace_pgfaults |= TRACE_PFMIN;
+	else
+		return -1;
+
+	return 0;
+}
+
 int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	const char * const trace_usage[] = {
@@ -2293,6 +2456,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 		},
 		.output = stdout,
 		.show_comm = true,
+		.trace_syscalls = true,
 	};
 	const char *output_name = NULL;
 	const char *ev_qualifier_str = NULL;
@@ -2330,20 +2494,34 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Show only syscall summary with statistics"),
 	OPT_BOOLEAN('S', "with-summary", &trace.summary,
 		    "Show all syscalls and summary with statistics"),
+	OPT_CALLBACK_DEFAULT('F', "pf", &trace.trace_pgfaults, "all|maj|min",
+		     "Trace pagefaults", parse_pagefaults, "maj"),
+	OPT_BOOLEAN(0, "syscalls", &trace.trace_syscalls, "Trace syscalls"),
 	OPT_END()
 	};
 	int err;
 	char bf[BUFSIZ];
 
-	if ((argc > 1) && (strcmp(argv[1], "record") == 0))
-		return trace__record(argc-2, &argv[2]);
+	argc = parse_options(argc, argv, trace_options, trace_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
 
-	argc = parse_options(argc, argv, trace_options, trace_usage, 0);
+	if (trace.trace_pgfaults) {
+		trace.opts.sample_address = true;
+		trace.opts.sample_time = true;
+	}
+
+	if ((argc >= 1) && (strcmp(argv[0], "record") == 0))
+		return trace__record(&trace, argc-1, &argv[1]);
 
 	/* summary_only implies summary option, but don't overwrite summary if set */
 	if (trace.summary_only)
 		trace.summary = trace.summary_only;
 
+	if (!trace.trace_syscalls && !trace.trace_pgfaults) {
+		pr_err("Please specify something to trace.\n");
+		return -1;
+	}
+
 	if (output_name != NULL) {
 		err = trace__open_output(&trace, output_name);
 		if (err < 0) {
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index f30ac5e..1f67aa0 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -48,6 +48,10 @@ ifneq ($(ARCH),$(filter $(ARCH),x86 arm))
   NO_LIBDW_DWARF_UNWIND := 1
 endif
 
+ifeq ($(ARCH),powerpc)
+  CFLAGS += -DHAVE_SKIP_CALLCHAIN_IDX
+endif
+
 ifeq ($(LIBUNWIND_LIBS),)
   NO_LIBUNWIND := 1
 else
@@ -160,6 +164,7 @@ CORE_FEATURE_TESTS =			\
 	backtrace			\
 	dwarf				\
 	fortify-source			\
+	sync-compare-and-swap		\
 	glibc				\
 	gtk2				\
 	gtk2-infobar			\
@@ -195,6 +200,7 @@ LIB_FEATURE_TESTS =			\
 VF_FEATURE_TESTS =			\
 	backtrace			\
 	fortify-source			\
+	sync-compare-and-swap		\
 	gtk2-infobar			\
 	libelf-getphdrnum		\
 	libelf-mmap			\
@@ -268,6 +274,10 @@ CFLAGS += -I$(LIB_INCLUDE)
 
 CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 
+ifeq ($(feature-sync-compare-and-swap), 1)
+  CFLAGS += -DHAVE_SYNC_COMPARE_AND_SWAP_SUPPORT
+endif
+
 ifndef NO_BIONIC
   $(call feature_check,bionic)
   ifeq ($(feature-bionic), 1)
@@ -590,6 +600,10 @@ ifndef NO_LIBNUMA
   endif
 endif
 
+ifdef HAVE_KVM_STAT_SUPPORT
+    CFLAGS += -DHAVE_KVM_STAT_SUPPORT
+endif
+
 # Among the variables below, these:
 #   perfexecdir
 #   template_dir
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 64c84e5..6088f8d 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -5,6 +5,7 @@ FILES=					\
 	test-bionic.bin			\
 	test-dwarf.bin			\
 	test-fortify-source.bin		\
+	test-sync-compare-and-swap.bin	\
 	test-glibc.bin			\
 	test-gtk2.bin			\
 	test-gtk2-infobar.bin		\
@@ -141,6 +142,9 @@ test-timerfd.bin:
 test-libdw-dwarf-unwind.bin:
 	$(BUILD)
 
+test-sync-compare-and-swap.bin:
+	$(BUILD) -Werror
+
 -include *.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-all.c b/tools/perf/config/feature-checks/test-all.c
index fe5c1e5..a7d022e 100644
--- a/tools/perf/config/feature-checks/test-all.c
+++ b/tools/perf/config/feature-checks/test-all.c
@@ -89,6 +89,10 @@
 # include "test-libdw-dwarf-unwind.c"
 #undef main
 
+#define main main_test_sync_compare_and_swap
+# include "test-sync-compare-and-swap.c"
+#undef main
+
 int main(int argc, char *argv[])
 {
 	main_test_libpython();
@@ -111,6 +115,7 @@ int main(int argc, char *argv[])
 	main_test_timerfd();
 	main_test_stackprotector_all();
 	main_test_libdw_dwarf_unwind();
+	main_test_sync_compare_and_swap(argc, argv);
 
 	return 0;
 }
diff --git a/tools/perf/config/feature-checks/test-sync-compare-and-swap.c b/tools/perf/config/feature-checks/test-sync-compare-and-swap.c
new file mode 100644
index 0000000..c34d4ca
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-sync-compare-and-swap.c
@@ -0,0 +1,14 @@
+#include <stdint.h>
+
+volatile uint64_t x;
+
+int main(int argc, char *argv[])
+{
+	uint64_t old, new = argc;
+
+	argv = argv;
+	do {
+		old = __sync_val_compare_and_swap(&x, 0, 0);
+	} while (!__sync_bool_compare_and_swap(&x, old, new));
+	return old == new;
+}
diff --git a/tools/perf/perf-sys.h b/tools/perf/perf-sys.h
index 5268a14..937e432 100644
--- a/tools/perf/perf-sys.h
+++ b/tools/perf/perf-sys.h
@@ -54,6 +54,7 @@
 #define mb()		asm volatile("bcr 15,0" ::: "memory")
 #define wmb()		asm volatile("bcr 15,0" ::: "memory")
 #define rmb()		asm volatile("bcr 15,0" ::: "memory")
+#define CPUINFO_PROC	"vendor_id"
 #endif
 
 #ifdef __sh__
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 95c58fc..2282d41 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -13,11 +13,12 @@
 #include "util/quote.h"
 #include "util/run-command.h"
 #include "util/parse-events.h"
+#include "util/debug.h"
 #include <api/fs/debugfs.h>
 #include <pthread.h>
 
 const char perf_usage_string[] =
-	"perf [--version] [--help] COMMAND [ARGS]";
+	"perf [--version] [--help] [OPTIONS] COMMAND [ARGS]";
 
 const char perf_more_info_string[] =
 	"See 'perf help COMMAND' for more information on a specific command.";
@@ -212,6 +213,16 @@ static int handle_options(const char ***argv, int *argc, int *envchanged)
 				printf("%s ", p->cmd);
 			}
 			exit(0);
+		} else if (!strcmp(cmd, "--debug")) {
+			if (*argc < 2) {
+				fprintf(stderr, "No variable specified for --debug.\n");
+				usage(perf_usage_string);
+			}
+			if (perf_debug_option((*argv)[1]))
+				usage(perf_usage_string);
+
+			(*argv)++;
+			(*argc)--;
 		} else {
 			fprintf(stderr, "Unknown option: %s\n", cmd);
 			usage(perf_usage_string);
diff --git a/tools/perf/scripts/perl/bin/failed-syscalls-record b/tools/perf/scripts/perl/bin/failed-syscalls-record
index 8104895..74685f3 100644
--- a/tools/perf/scripts/perl/bin/failed-syscalls-record
+++ b/tools/perf/scripts/perl/bin/failed-syscalls-record
@@ -1,2 +1,3 @@
 #!/bin/bash
-perf record -e raw_syscalls:sys_exit $@
+(perf record -e raw_syscalls:sys_exit $@ || \
+ perf record -e syscalls:sys_exit $@) 2> /dev/null
diff --git a/tools/perf/scripts/perl/failed-syscalls.pl b/tools/perf/scripts/perl/failed-syscalls.pl
index 94bc25a..55e7ae4 100644
--- a/tools/perf/scripts/perl/failed-syscalls.pl
+++ b/tools/perf/scripts/perl/failed-syscalls.pl
@@ -26,6 +26,11 @@ sub raw_syscalls::sys_exit
 	}
 }
 
+sub syscalls::sys_exit
+{
+	raw_syscalls::sys_exit(@_)
+}
+
 sub trace_end
 {
     printf("\nfailed syscalls by comm:\n\n");
diff --git a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py
index de7211e..38dfb72 100644
--- a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py
+++ b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py
@@ -107,12 +107,13 @@ def taskState(state):
 
 class EventHeaders:
 	def __init__(self, common_cpu, common_secs, common_nsecs,
-		     common_pid, common_comm):
+		     common_pid, common_comm, common_callchain):
 		self.cpu = common_cpu
 		self.secs = common_secs
 		self.nsecs = common_nsecs
 		self.pid = common_pid
 		self.comm = common_comm
+		self.callchain = common_callchain
 
 	def ts(self):
 		return (self.secs * (10 ** 9)) + self.nsecs
diff --git a/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record
index 8104895..74685f3 100644
--- a/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record
+++ b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record
@@ -1,2 +1,3 @@
 #!/bin/bash
-perf record -e raw_syscalls:sys_exit $@
+(perf record -e raw_syscalls:sys_exit $@ || \
+ perf record -e syscalls:sys_exit $@) 2> /dev/null
diff --git a/tools/perf/scripts/python/bin/sctop-record b/tools/perf/scripts/python/bin/sctop-record
index 4efbfaa..d694084 100644
--- a/tools/perf/scripts/python/bin/sctop-record
+++ b/tools/perf/scripts/python/bin/sctop-record
@@ -1,2 +1,3 @@
 #!/bin/bash
-perf record -e raw_syscalls:sys_enter $@
+(perf record -e raw_syscalls:sys_enter $@ || \
+ perf record -e syscalls:sys_enter $@) 2> /dev/null
diff --git a/tools/perf/scripts/python/bin/syscall-counts-by-pid-record b/tools/perf/scripts/python/bin/syscall-counts-by-pid-record
index 4efbfaa..d694084 100644
--- a/tools/perf/scripts/python/bin/syscall-counts-by-pid-record
+++ b/tools/perf/scripts/python/bin/syscall-counts-by-pid-record
@@ -1,2 +1,3 @@
 #!/bin/bash
-perf record -e raw_syscalls:sys_enter $@
+(perf record -e raw_syscalls:sys_enter $@ || \
+ perf record -e syscalls:sys_enter $@) 2> /dev/null
diff --git a/tools/perf/scripts/python/bin/syscall-counts-record b/tools/perf/scripts/python/bin/syscall-counts-record
index 4efbfaa..d694084 100644
--- a/tools/perf/scripts/python/bin/syscall-counts-record
+++ b/tools/perf/scripts/python/bin/syscall-counts-record
@@ -1,2 +1,3 @@
 #!/bin/bash
-perf record -e raw_syscalls:sys_enter $@
+(perf record -e raw_syscalls:sys_enter $@ || \
+ perf record -e syscalls:sys_enter $@) 2> /dev/null
diff --git a/tools/perf/scripts/python/check-perf-trace.py b/tools/perf/scripts/python/check-perf-trace.py
index 4647a76..334599c 100644
--- a/tools/perf/scripts/python/check-perf-trace.py
+++ b/tools/perf/scripts/python/check-perf-trace.py
@@ -27,7 +27,7 @@ def trace_end():
 
 def irq__softirq_entry(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	vec):
+	common_callchain, vec):
 		print_header(event_name, common_cpu, common_secs, common_nsecs,
 			common_pid, common_comm)
 
@@ -38,7 +38,7 @@ def irq__softirq_entry(event_name, context, common_cpu,
 
 def kmem__kmalloc(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	call_site, ptr, bytes_req, bytes_alloc,
+	common_callchain, call_site, ptr, bytes_req, bytes_alloc,
 	gfp_flags):
 		print_header(event_name, common_cpu, common_secs, common_nsecs,
 			common_pid, common_comm)
diff --git a/tools/perf/scripts/python/failed-syscalls-by-pid.py b/tools/perf/scripts/python/failed-syscalls-by-pid.py
index 85805fa..cafeff3 100644
--- a/tools/perf/scripts/python/failed-syscalls-by-pid.py
+++ b/tools/perf/scripts/python/failed-syscalls-by-pid.py
@@ -39,7 +39,7 @@ def trace_end():
 
 def raw_syscalls__sys_exit(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	id, ret):
+	common_callchain, id, ret):
 	if (for_comm and common_comm != for_comm) or \
 	   (for_pid  and common_pid  != for_pid ):
 		return
@@ -50,6 +50,11 @@ def raw_syscalls__sys_exit(event_name, context, common_cpu,
 		except TypeError:
 			syscalls[common_comm][common_pid][id][ret] = 1
 
+def syscalls__sys_exit(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	id, ret):
+	raw_syscalls__sys_exit(**locals())
+
 def print_error_totals():
     if for_comm is not None:
 	    print "\nsyscall errors for %s:\n\n" % (for_comm),
diff --git a/tools/perf/scripts/python/futex-contention.py b/tools/perf/scripts/python/futex-contention.py
index 11e70a3..0f5cf43 100644
--- a/tools/perf/scripts/python/futex-contention.py
+++ b/tools/perf/scripts/python/futex-contention.py
@@ -21,7 +21,7 @@ thread_blocktime = {}
 lock_waits = {} # long-lived stats on (tid,lock) blockage elapsed time
 process_names = {} # long-lived pid-to-execname mapping
 
-def syscalls__sys_enter_futex(event, ctxt, cpu, s, ns, tid, comm,
+def syscalls__sys_enter_futex(event, ctxt, cpu, s, ns, tid, comm, callchain,
 			      nr, uaddr, op, val, utime, uaddr2, val3):
 	cmd = op & FUTEX_CMD_MASK
 	if cmd != FUTEX_WAIT:
@@ -31,7 +31,7 @@ def syscalls__sys_enter_futex(event, ctxt, cpu, s, ns, tid, comm,
 	thread_thislock[tid] = uaddr
 	thread_blocktime[tid] = nsecs(s, ns)
 
-def syscalls__sys_exit_futex(event, ctxt, cpu, s, ns, tid, comm,
+def syscalls__sys_exit_futex(event, ctxt, cpu, s, ns, tid, comm, callchain,
 			     nr, ret):
 	if thread_blocktime.has_key(tid):
 		elapsed = nsecs(s, ns) - thread_blocktime[tid]
diff --git a/tools/perf/scripts/python/net_dropmonitor.py b/tools/perf/scripts/python/net_dropmonitor.py
index b574059..0b6ce8c 100755
--- a/tools/perf/scripts/python/net_dropmonitor.py
+++ b/tools/perf/scripts/python/net_dropmonitor.py
@@ -66,7 +66,7 @@ def trace_end():
 	print_drop_table()
 
 # called from perf, when it finds a correspoinding event
-def skb__kfree_skb(name, context, cpu, sec, nsec, pid, comm,
+def skb__kfree_skb(name, context, cpu, sec, nsec, pid, comm, callchain,
 		   skbaddr, location, protocol):
 	slocation = str(location)
 	try:
diff --git a/tools/perf/scripts/python/netdev-times.py b/tools/perf/scripts/python/netdev-times.py
index 9aa0a32..4d21ef2 100644
--- a/tools/perf/scripts/python/netdev-times.py
+++ b/tools/perf/scripts/python/netdev-times.py
@@ -224,75 +224,75 @@ def trace_end():
 			(len(rx_skb_list), of_count_rx_skb_list)
 
 # called from perf, when it finds a correspoinding event
-def irq__softirq_entry(name, context, cpu, sec, nsec, pid, comm, vec):
+def irq__softirq_entry(name, context, cpu, sec, nsec, pid, comm, callchain, vec):
 	if symbol_str("irq__softirq_entry", "vec", vec) != "NET_RX":
 		return
 	event_info = (name, context, cpu, nsecs(sec, nsec), pid, comm, vec)
 	all_event_list.append(event_info)
 
-def irq__softirq_exit(name, context, cpu, sec, nsec, pid, comm, vec):
+def irq__softirq_exit(name, context, cpu, sec, nsec, pid, comm, callchain, vec):
 	if symbol_str("irq__softirq_entry", "vec", vec) != "NET_RX":
 		return
 	event_info = (name, context, cpu, nsecs(sec, nsec), pid, comm, vec)
 	all_event_list.append(event_info)
 
-def irq__softirq_raise(name, context, cpu, sec, nsec, pid, comm, vec):
+def irq__softirq_raise(name, context, cpu, sec, nsec, pid, comm, callchain, vec):
 	if symbol_str("irq__softirq_entry", "vec", vec) != "NET_RX":
 		return
 	event_info = (name, context, cpu, nsecs(sec, nsec), pid, comm, vec)
 	all_event_list.append(event_info)
 
 def irq__irq_handler_entry(name, context, cpu, sec, nsec, pid, comm,
-			irq, irq_name):
+			callchain, irq, irq_name):
 	event_info = (name, context, cpu, nsecs(sec, nsec), pid, comm,
 			irq, irq_name)
 	all_event_list.append(event_info)
 
-def irq__irq_handler_exit(name, context, cpu, sec, nsec, pid, comm, irq, ret):
+def irq__irq_handler_exit(name, context, cpu, sec, nsec, pid, comm, callchain, irq, ret):
 	event_info = (name, context, cpu, nsecs(sec, nsec), pid, comm, irq, ret)
 	all_event_list.append(event_info)
 
-def napi__napi_poll(name, context, cpu, sec, nsec, pid, comm, napi, dev_name):
+def napi__napi_poll(name, context, cpu, sec, nsec, pid, comm, callchain, napi, dev_name):
 	event_info = (name, context, cpu, nsecs(sec, nsec), pid, comm,
 			napi, dev_name)
 	all_event_list.append(event_info)
 
-def net__netif_receive_skb(name, context, cpu, sec, nsec, pid, comm, skbaddr,
+def net__netif_receive_skb(name, context, cpu, sec, nsec, pid, comm, callchain, skbaddr,
 			skblen, dev_name):
 	event_info = (name, context, cpu, nsecs(sec, nsec), pid, comm,
 			skbaddr, skblen, dev_name)
 	all_event_list.append(event_info)
 
-def net__netif_rx(name, context, cpu, sec, nsec, pid, comm, skbaddr,
+def net__netif_rx(name, context, cpu, sec, nsec, pid, comm, callchain, skbaddr,
 			skblen, dev_name):
 	event_info = (name, context, cpu, nsecs(sec, nsec), pid, comm,
 			skbaddr, skblen, dev_name)
 	all_event_list.append(event_info)
 
-def net__net_dev_queue(name, context, cpu, sec, nsec, pid, comm,
+def net__net_dev_queue(name, context, cpu, sec, nsec, pid, comm, callchain,
 			skbaddr, skblen, dev_name):
 	event_info = (name, context, cpu, nsecs(sec, nsec), pid, comm,
 			skbaddr, skblen, dev_name)
 	all_event_list.append(event_info)
 
-def net__net_dev_xmit(name, context, cpu, sec, nsec, pid, comm,
+def net__net_dev_xmit(name, context, cpu, sec, nsec, pid, comm, callchain,
 			skbaddr, skblen, rc, dev_name):
 	event_info = (name, context, cpu, nsecs(sec, nsec), pid, comm,
 			skbaddr, skblen, rc ,dev_name)
 	all_event_list.append(event_info)
 
-def skb__kfree_skb(name, context, cpu, sec, nsec, pid, comm,
+def skb__kfree_skb(name, context, cpu, sec, nsec, pid, comm, callchain,
 			skbaddr, protocol, location):
 	event_info = (name, context, cpu, nsecs(sec, nsec), pid, comm,
 			skbaddr, protocol, location)
 	all_event_list.append(event_info)
 
-def skb__consume_skb(name, context, cpu, sec, nsec, pid, comm, skbaddr):
+def skb__consume_skb(name, context, cpu, sec, nsec, pid, comm, callchain, skbaddr):
 	event_info = (name, context, cpu, nsecs(sec, nsec), pid, comm,
 			skbaddr)
 	all_event_list.append(event_info)
 
-def skb__skb_copy_datagram_iovec(name, context, cpu, sec, nsec, pid, comm,
+def skb__skb_copy_datagram_iovec(name, context, cpu, sec, nsec, pid, comm, callchain,
 	skbaddr, skblen):
 	event_info = (name, context, cpu, nsecs(sec, nsec), pid, comm,
 			skbaddr, skblen)
diff --git a/tools/perf/scripts/python/sched-migration.py b/tools/perf/scripts/python/sched-migration.py
index 74d55ec..de66cb3 100644
--- a/tools/perf/scripts/python/sched-migration.py
+++ b/tools/perf/scripts/python/sched-migration.py
@@ -369,93 +369,92 @@ def trace_end():
 
 def sched__sched_stat_runtime(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	comm, pid, runtime, vruntime):
+	common_callchain, comm, pid, runtime, vruntime):
 	pass
 
 def sched__sched_stat_iowait(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	comm, pid, delay):
+	common_callchain, comm, pid, delay):
 	pass
 
 def sched__sched_stat_sleep(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	comm, pid, delay):
+	common_callchain, comm, pid, delay):
 	pass
 
 def sched__sched_stat_wait(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	comm, pid, delay):
+	common_callchain, comm, pid, delay):
 	pass
 
 def sched__sched_process_fork(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	parent_comm, parent_pid, child_comm, child_pid):
+	common_callchain, parent_comm, parent_pid, child_comm, child_pid):
 	pass
 
 def sched__sched_process_wait(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	comm, pid, prio):
+	common_callchain, comm, pid, prio):
 	pass
 
 def sched__sched_process_exit(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	comm, pid, prio):
+	common_callchain, comm, pid, prio):
 	pass
 
 def sched__sched_process_free(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	comm, pid, prio):
+	common_callchain, comm, pid, prio):
 	pass
 
 def sched__sched_migrate_task(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	comm, pid, prio, orig_cpu,
+	common_callchain, comm, pid, prio, orig_cpu,
 	dest_cpu):
 	headers = EventHeaders(common_cpu, common_secs, common_nsecs,
-				common_pid, common_comm)
+				common_pid, common_comm, common_callchain)
 	parser.migrate(headers, pid, prio, orig_cpu, dest_cpu)
 
 def sched__sched_switch(event_name, context, common_cpu,
-	common_secs, common_nsecs, common_pid, common_comm,
+	common_secs, common_nsecs, common_pid, common_comm, common_callchain,
 	prev_comm, prev_pid, prev_prio, prev_state,
 	next_comm, next_pid, next_prio):
 
 	headers = EventHeaders(common_cpu, common_secs, common_nsecs,
-				common_pid, common_comm)
+				common_pid, common_comm, common_callchain)
 	parser.sched_switch(headers, prev_comm, prev_pid, prev_prio, prev_state,
 			 next_comm, next_pid, next_prio)
 
 def sched__sched_wakeup_new(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	comm, pid, prio, success,
+	common_callchain, comm, pid, prio, success,
 	target_cpu):
 	headers = EventHeaders(common_cpu, common_secs, common_nsecs,
-				common_pid, common_comm)
+				common_pid, common_comm, common_callchain)
 	parser.wake_up(headers, comm, pid, success, target_cpu, 1)
 
 def sched__sched_wakeup(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	comm, pid, prio, success,
+	common_callchain, comm, pid, prio, success,
 	target_cpu):
 	headers = EventHeaders(common_cpu, common_secs, common_nsecs,
-				common_pid, common_comm)
+				common_pid, common_comm, common_callchain)
 	parser.wake_up(headers, comm, pid, success, target_cpu, 0)
 
 def sched__sched_wait_task(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	comm, pid, prio):
+	common_callchain, comm, pid, prio):
 	pass
 
 def sched__sched_kthread_stop_ret(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	ret):
+	common_callchain, ret):
 	pass
 
 def sched__sched_kthread_stop(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	comm, pid):
+	common_callchain, comm, pid):
 	pass
 
-def trace_unhandled(event_name, context, common_cpu, common_secs, common_nsecs,
-		common_pid, common_comm):
+def trace_unhandled(event_name, context, event_fields_dict):
 	pass
diff --git a/tools/perf/scripts/python/sctop.py b/tools/perf/scripts/python/sctop.py
index 42c267e..61621b9 100644
--- a/tools/perf/scripts/python/sctop.py
+++ b/tools/perf/scripts/python/sctop.py
@@ -44,7 +44,7 @@ def trace_begin():
 
 def raw_syscalls__sys_enter(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	id, args):
+	common_callchain, id, args):
 	if for_comm is not None:
 		if common_comm != for_comm:
 			return
@@ -53,6 +53,11 @@ def raw_syscalls__sys_enter(event_name, context, common_cpu,
 	except TypeError:
 		syscalls[id] = 1
 
+def syscalls__sys_enter(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	id, args):
+	raw_syscalls__sys_enter(**locals())
+
 def print_syscall_totals(interval):
 	while 1:
 		clear_term()
diff --git a/tools/perf/scripts/python/syscall-counts-by-pid.py b/tools/perf/scripts/python/syscall-counts-by-pid.py
index c64d1c5..daf314c 100644
--- a/tools/perf/scripts/python/syscall-counts-by-pid.py
+++ b/tools/perf/scripts/python/syscall-counts-by-pid.py
@@ -38,7 +38,7 @@ def trace_end():
 
 def raw_syscalls__sys_enter(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	id, args):
+	common_callchain, id, args):
 
 	if (for_comm and common_comm != for_comm) or \
 	   (for_pid  and common_pid  != for_pid ):
@@ -48,6 +48,11 @@ def raw_syscalls__sys_enter(event_name, context, common_cpu,
 	except TypeError:
 		syscalls[common_comm][common_pid][id] = 1
 
+def syscalls__sys_enter(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	id, args):
+	raw_syscalls__sys_enter(**locals())
+
 def print_syscall_totals():
     if for_comm is not None:
 	    print "\nsyscall events for %s:\n\n" % (for_comm),
diff --git a/tools/perf/scripts/python/syscall-counts.py b/tools/perf/scripts/python/syscall-counts.py
index b435d3f..e66a773 100644
--- a/tools/perf/scripts/python/syscall-counts.py
+++ b/tools/perf/scripts/python/syscall-counts.py
@@ -35,7 +35,7 @@ def trace_end():
 
 def raw_syscalls__sys_enter(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
-	id, args):
+	common_callchain, id, args):
 	if for_comm is not None:
 		if common_comm != for_comm:
 			return
@@ -44,6 +44,11 @@ def raw_syscalls__sys_enter(event_name, context, common_cpu,
 	except TypeError:
 		syscalls[id] = 1
 
+def syscalls__sys_enter(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	id, args):
+	raw_syscalls__sys_enter(**locals())
+
 def print_syscall_totals():
     if for_comm is not None:
 	    print "\nsyscall events for %s:\n\n" % (for_comm),
diff --git a/tools/perf/tests/attr/base-record b/tools/perf/tests/attr/base-record
index e9bd639..f710b92 100644
--- a/tools/perf/tests/attr/base-record
+++ b/tools/perf/tests/attr/base-record
@@ -1,7 +1,8 @@
 [event]
 fd=1
 group_fd=-1
-flags=0
+# 0 or PERF_FLAG_FD_CLOEXEC flag
+flags=0|8
 cpu=*
 type=0|1
 size=96
diff --git a/tools/perf/tests/attr/base-stat b/tools/perf/tests/attr/base-stat
index 91cd48b..dc3ada2 100644
--- a/tools/perf/tests/attr/base-stat
+++ b/tools/perf/tests/attr/base-stat
@@ -1,7 +1,8 @@
 [event]
 fd=1
 group_fd=-1
-flags=0
+# 0 or PERF_FLAG_FD_CLOEXEC flag
+flags=0|8
 cpu=*
 type=0
 size=96
diff --git a/tools/perf/tests/bp_signal.c b/tools/perf/tests/bp_signal.c
index aba0954..a02b035 100644
--- a/tools/perf/tests/bp_signal.c
+++ b/tools/perf/tests/bp_signal.c
@@ -25,6 +25,7 @@
 #include "tests.h"
 #include "debug.h"
 #include "perf.h"
+#include "cloexec.h"
 
 static int fd1;
 static int fd2;
@@ -78,7 +79,8 @@ static int bp_event(void *fn, int setup_signal)
 	pe.exclude_kernel = 1;
 	pe.exclude_hv = 1;
 
-	fd = sys_perf_event_open(&pe, 0, -1, -1, 0);
+	fd = sys_perf_event_open(&pe, 0, -1, -1,
+				 perf_event_open_cloexec_flag());
 	if (fd < 0) {
 		pr_debug("failed opening event %llx\n", pe.config);
 		return TEST_FAIL;
diff --git a/tools/perf/tests/bp_signal_overflow.c b/tools/perf/tests/bp_signal_overflow.c
index 44ac821..e765377 100644
--- a/tools/perf/tests/bp_signal_overflow.c
+++ b/tools/perf/tests/bp_signal_overflow.c
@@ -24,6 +24,7 @@
 #include "tests.h"
 #include "debug.h"
 #include "perf.h"
+#include "cloexec.h"
 
 static int overflows;
 
@@ -91,7 +92,8 @@ int test__bp_signal_overflow(void)
 	pe.exclude_kernel = 1;
 	pe.exclude_hv = 1;
 
-	fd = sys_perf_event_open(&pe, 0, -1, -1, 0);
+	fd = sys_perf_event_open(&pe, 0, -1, -1,
+				 perf_event_open_cloexec_flag());
 	if (fd < 0) {
 		pr_debug("failed opening event %llx\n", pe.config);
 		return TEST_FAIL;
diff --git a/tools/perf/tests/dso-data.c b/tools/perf/tests/dso-data.c
index 630808c..caaf37f 100644
--- a/tools/perf/tests/dso-data.c
+++ b/tools/perf/tests/dso-data.c
@@ -10,6 +10,7 @@
 #include "machine.h"
 #include "symbol.h"
 #include "tests.h"
+#include "debug.h"
 
 static char *test_file(int size)
 {
diff --git a/tools/perf/tests/evsel-roundtrip-name.c b/tools/perf/tests/evsel-roundtrip-name.c
index 465cdbc..b8d8341 100644
--- a/tools/perf/tests/evsel-roundtrip-name.c
+++ b/tools/perf/tests/evsel-roundtrip-name.c
@@ -2,6 +2,7 @@
 #include "evsel.h"
 #include "parse-events.h"
 #include "tests.h"
+#include "debug.h"
 
 static int perf_evsel__roundtrip_cache_name_test(void)
 {
diff --git a/tools/perf/tests/evsel-tp-sched.c b/tools/perf/tests/evsel-tp-sched.c
index 35d7fdb..5216242 100644
--- a/tools/perf/tests/evsel-tp-sched.c
+++ b/tools/perf/tests/evsel-tp-sched.c
@@ -1,6 +1,7 @@
 #include <traceevent/event-parse.h>
 #include "evsel.h"
 #include "tests.h"
+#include "debug.h"
 
 static int perf_evsel__test_field(struct perf_evsel *evsel, const char *name,
 				  int size, bool should_be_signed)
diff --git a/tools/perf/tests/open-syscall-tp-fields.c b/tools/perf/tests/open-syscall-tp-fields.c
index c505ef2..0785b64 100644
--- a/tools/perf/tests/open-syscall-tp-fields.c
+++ b/tools/perf/tests/open-syscall-tp-fields.c
@@ -3,6 +3,7 @@
 #include "evsel.h"
 #include "thread_map.h"
 #include "tests.h"
+#include "debug.h"
 
 int test__syscall_open_tp_fields(void)
 {
diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index deba669..5941927 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -5,6 +5,7 @@
 #include <api/fs/fs.h>
 #include <api/fs/debugfs.h>
 #include "tests.h"
+#include "debug.h"
 #include <linux/hw_breakpoint.h>
 
 #define PERF_TP_SAMPLE_TYPE (PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | \
diff --git a/tools/perf/tests/parse-no-sample-id-all.c b/tools/perf/tests/parse-no-sample-id-all.c
index 905019f..2c63ea6 100644
--- a/tools/perf/tests/parse-no-sample-id-all.c
+++ b/tools/perf/tests/parse-no-sample-id-all.c
@@ -7,6 +7,7 @@
 #include "evlist.h"
 #include "header.h"
 #include "util.h"
+#include "debug.h"
 
 static int process_event(struct perf_evlist **pevlist, union perf_event *event)
 {
diff --git a/tools/perf/tests/perf-time-to-tsc.c b/tools/perf/tests/perf-time-to-tsc.c
index 3b7cd4d..f238442 100644
--- a/tools/perf/tests/perf-time-to-tsc.c
+++ b/tools/perf/tests/perf-time-to-tsc.c
@@ -8,10 +8,9 @@
 #include "evsel.h"
 #include "thread_map.h"
 #include "cpumap.h"
+#include "tsc.h"
 #include "tests.h"
 
-#include "../arch/x86/util/tsc.h"
-
 #define CHECK__(x) {				\
 	while ((x) < 0) {			\
 		pr_debug(#x " failed!\n");	\
@@ -26,15 +25,6 @@
 	}					\
 }
 
-static u64 rdtsc(void)
-{
-	unsigned int low, high;
-
-	asm volatile("rdtsc" : "=a" (low), "=d" (high));
-
-	return low | ((u64)high) << 32;
-}
-
 /**
  * test__perf_time_to_tsc - test converting perf time to TSC.
  *
diff --git a/tools/perf/tests/rdpmc.c b/tools/perf/tests/rdpmc.c
index e59143f..c04d1f2 100644
--- a/tools/perf/tests/rdpmc.c
+++ b/tools/perf/tests/rdpmc.c
@@ -6,6 +6,7 @@
 #include "perf.h"
 #include "debug.h"
 #include "tests.h"
+#include "cloexec.h"
 
 #if defined(__x86_64__) || defined(__i386__)
 
@@ -104,7 +105,8 @@ static int __test__rdpmc(void)
 	sa.sa_sigaction = segfault_handler;
 	sigaction(SIGSEGV, &sa, NULL);
 
-	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
+	fd = sys_perf_event_open(&attr, 0, -1, -1,
+				 perf_event_open_cloexec_flag());
 	if (fd < 0) {
 		pr_err("Error: sys_perf_event_open() syscall returned "
 		       "with %d (%s)\n", fd, strerror(errno));
diff --git a/tools/perf/tests/sample-parsing.c b/tools/perf/tests/sample-parsing.c
index 7ae8d17..ca292f9 100644
--- a/tools/perf/tests/sample-parsing.c
+++ b/tools/perf/tests/sample-parsing.c
@@ -4,6 +4,7 @@
 #include "util.h"
 #include "event.h"
 #include "evsel.h"
+#include "debug.h"
 
 #include "tests.h"
 
diff --git a/tools/perf/tests/thread-mg-share.c b/tools/perf/tests/thread-mg-share.c
index 2b2e0db..b028499 100644
--- a/tools/perf/tests/thread-mg-share.c
+++ b/tools/perf/tests/thread-mg-share.c
@@ -2,6 +2,7 @@
 #include "machine.h"
 #include "thread.h"
 #include "map.h"
+#include "debug.h"
 
 int test__thread_mg_share(void)
 {
diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index 3ccf6e1..6680fa5 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -150,7 +150,7 @@ unsigned int ui_browser__rb_tree_refresh(struct ui_browser *browser)
 	while (nd != NULL) {
 		ui_browser__gotorc(browser, row, 0);
 		browser->write(browser, nd, row);
-		if (++row == browser->height)
+		if (++row == browser->rows)
 			break;
 		nd = rb_next(nd);
 	}
@@ -166,7 +166,7 @@ bool ui_browser__is_current_entry(struct ui_browser *browser, unsigned row)
 void ui_browser__refresh_dimensions(struct ui_browser *browser)
 {
 	browser->width = SLtt_Screen_Cols - 1;
-	browser->height = SLtt_Screen_Rows - 2;
+	browser->height = browser->rows = SLtt_Screen_Rows - 2;
 	browser->y = 1;
 	browser->x = 0;
 }
@@ -250,7 +250,10 @@ int ui_browser__show(struct ui_browser *browser, const char *title,
 	int err;
 	va_list ap;
 
-	ui_browser__refresh_dimensions(browser);
+	if (browser->refresh_dimensions == NULL)
+		browser->refresh_dimensions = ui_browser__refresh_dimensions;
+
+	browser->refresh_dimensions(browser);
 
 	pthread_mutex_lock(&ui__lock);
 	__ui_browser__show_title(browser, title);
@@ -279,7 +282,7 @@ static void ui_browser__scrollbar_set(struct ui_browser *browser)
 {
 	int height = browser->height, h = 0, pct = 0,
 	    col = browser->width,
-	    row = browser->y - 1;
+	    row = 0;
 
 	if (browser->nr_entries > 1) {
 		pct = ((browser->index * (browser->height - 1)) /
@@ -367,7 +370,7 @@ int ui_browser__run(struct ui_browser *browser, int delay_secs)
 
 		if (key == K_RESIZE) {
 			ui__refresh_dimensions(false);
-			ui_browser__refresh_dimensions(browser);
+			browser->refresh_dimensions(browser);
 			__ui_browser__show_title(browser, browser->title);
 			ui_helpline__puts(browser->helpline);
 			continue;
@@ -389,7 +392,7 @@ int ui_browser__run(struct ui_browser *browser, int delay_secs)
 			if (browser->index == browser->nr_entries - 1)
 				break;
 			++browser->index;
-			if (browser->index == browser->top_idx + browser->height) {
+			if (browser->index == browser->top_idx + browser->rows) {
 				++browser->top_idx;
 				browser->seek(browser, +1, SEEK_CUR);
 			}
@@ -405,10 +408,10 @@ int ui_browser__run(struct ui_browser *browser, int delay_secs)
 			break;
 		case K_PGDN:
 		case ' ':
-			if (browser->top_idx + browser->height > browser->nr_entries - 1)
+			if (browser->top_idx + browser->rows > browser->nr_entries - 1)
 				break;
 
-			offset = browser->height;
+			offset = browser->rows;
 			if (browser->index + offset > browser->nr_entries - 1)
 				offset = browser->nr_entries - 1 - browser->index;
 			browser->index += offset;
@@ -419,10 +422,10 @@ int ui_browser__run(struct ui_browser *browser, int delay_secs)
 			if (browser->top_idx == 0)
 				break;
 
-			if (browser->top_idx < browser->height)
+			if (browser->top_idx < browser->rows)
 				offset = browser->top_idx;
 			else
-				offset = browser->height;
+				offset = browser->rows;
 
 			browser->index -= offset;
 			browser->top_idx -= offset;
@@ -432,7 +435,7 @@ int ui_browser__run(struct ui_browser *browser, int delay_secs)
 			ui_browser__reset_index(browser);
 			break;
 		case K_END:
-			offset = browser->height - 1;
+			offset = browser->rows - 1;
 			if (offset >= browser->nr_entries)
 				offset = browser->nr_entries - 1;
 
@@ -462,7 +465,7 @@ unsigned int ui_browser__list_head_refresh(struct ui_browser *browser)
 		if (!browser->filter || !browser->filter(browser, pos)) {
 			ui_browser__gotorc(browser, row, 0);
 			browser->write(browser, pos, row);
-			if (++row == browser->height)
+			if (++row == browser->rows)
 				break;
 		}
 	}
@@ -587,7 +590,7 @@ unsigned int ui_browser__argv_refresh(struct ui_browser *browser)
 		if (!browser->filter || !browser->filter(browser, *pos)) {
 			ui_browser__gotorc(browser, row, 0);
 			browser->write(browser, pos, row);
-			if (++row == browser->height)
+			if (++row == browser->rows)
 				break;
 		}
 
@@ -623,7 +626,7 @@ static void __ui_browser__line_arrow_up(struct ui_browser *browser,
 
 	SLsmg_set_char_set(1);
 
-	if (start < browser->top_idx + browser->height) {
+	if (start < browser->top_idx + browser->rows) {
 		row = start - browser->top_idx;
 		ui_browser__gotorc(browser, row, column);
 		SLsmg_write_char(SLSMG_LLCORN_CHAR);
@@ -633,7 +636,7 @@ static void __ui_browser__line_arrow_up(struct ui_browser *browser,
 		if (row-- == 0)
 			goto out;
 	} else
-		row = browser->height - 1;
+		row = browser->rows - 1;
 
 	if (end > browser->top_idx)
 		end_row = end - browser->top_idx;
@@ -675,8 +678,8 @@ static void __ui_browser__line_arrow_down(struct ui_browser *browser,
 	} else
 		row = 0;
 
-	if (end >= browser->top_idx + browser->height)
-		end_row = browser->height - 1;
+	if (end >= browser->top_idx + browser->rows)
+		end_row = browser->rows - 1;
 	else
 		end_row = end - browser->top_idx;
 
@@ -684,7 +687,7 @@ static void __ui_browser__line_arrow_down(struct ui_browser *browser,
 	SLsmg_draw_vline(end_row - row + 1);
 
 	ui_browser__gotorc(browser, end_row, column);
-	if (end < browser->top_idx + browser->height) {
+	if (end < browser->top_idx + browser->rows) {
 		SLsmg_write_char(SLSMG_LLCORN_CHAR);
 		ui_browser__gotorc(browser, end_row, column + 1);
 		SLsmg_write_char(SLSMG_HLINE_CHAR);
diff --git a/tools/perf/ui/browser.h b/tools/perf/ui/browser.h
index 03d4d62..92ae721 100644
--- a/tools/perf/ui/browser.h
+++ b/tools/perf/ui/browser.h
@@ -14,11 +14,12 @@
 struct ui_browser {
 	u64	      index, top_idx;
 	void	      *top, *entries;
-	u16	      y, x, width, height;
+	u16	      y, x, width, height, rows;
 	int	      current_color;
 	void	      *priv;
 	const char    *title;
 	char	      *helpline;
+	void 	      (*refresh_dimensions)(struct ui_browser *browser);
 	unsigned int  (*refresh)(struct ui_browser *browser);
 	void	      (*write)(struct ui_browser *browser, void *entry, int row);
 	void	      (*seek)(struct ui_browser *browser, off_t offset, int whence);
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 04a229a..a94b11f 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -26,6 +26,7 @@ struct hist_browser {
 	struct map_symbol   *selection;
 	int		     print_seq;
 	bool		     show_dso;
+	bool		     show_headers;
 	float		     min_pcnt;
 	u64		     nr_non_filtered_entries;
 	u64		     nr_callchain_rows;
@@ -33,8 +34,7 @@ struct hist_browser {
 
 extern void hist_browser__init_hpp(void);
 
-static int hists__browser_title(struct hists *hists, char *bf, size_t size,
-				const char *ev_name);
+static int hists__browser_title(struct hists *hists, char *bf, size_t size);
 static void hist_browser__update_nr_entries(struct hist_browser *hb);
 
 static struct rb_node *hists__filter_entries(struct rb_node *nd,
@@ -57,11 +57,42 @@ static u32 hist_browser__nr_entries(struct hist_browser *hb)
 	return nr_entries + hb->nr_callchain_rows;
 }
 
-static void hist_browser__refresh_dimensions(struct hist_browser *browser)
+static void hist_browser__update_rows(struct hist_browser *hb)
 {
+	struct ui_browser *browser = &hb->b;
+	u16 header_offset = hb->show_headers ? 1 : 0, index_row;
+
+	browser->rows = browser->height - header_offset;
+	/*
+	 * Verify if we were at the last line and that line isn't
+	 * visibe because we now show the header line(s).
+	 */
+	index_row = browser->index - browser->top_idx;
+	if (index_row >= browser->rows)
+		browser->index -= index_row - browser->rows + 1;
+}
+
+static void hist_browser__refresh_dimensions(struct ui_browser *browser)
+{
+	struct hist_browser *hb = container_of(browser, struct hist_browser, b);
+
 	/* 3 == +/- toggle symbol before actual hist_entry rendering */
-	browser->b.width = 3 + (hists__sort_list_width(browser->hists) +
-			     sizeof("[k]"));
+	browser->width = 3 + (hists__sort_list_width(hb->hists) + sizeof("[k]"));
+	/*
+ 	 * FIXME: Just keeping existing behaviour, but this really should be
+ 	 *	  before updating browser->width, as it will invalidate the
+ 	 *	  calculation above. Fix this and the fallout in another
+ 	 *	  changeset.
+ 	 */
+	ui_browser__refresh_dimensions(browser);
+	hist_browser__update_rows(hb);
+}
+
+static void hist_browser__gotorc(struct hist_browser *browser, int row, int column)
+{
+	u16 header_offset = browser->show_headers ? 1 : 0;
+
+	ui_browser__gotorc(&browser->b, row + header_offset, column);
 }
 
 static void hist_browser__reset(struct hist_browser *browser)
@@ -74,7 +105,7 @@ static void hist_browser__reset(struct hist_browser *browser)
 
 	hist_browser__update_nr_entries(browser);
 	browser->b.nr_entries = hist_browser__nr_entries(browser);
-	hist_browser__refresh_dimensions(browser);
+	hist_browser__refresh_dimensions(&browser->b);
 	ui_browser__reset_index(&browser->b);
 }
 
@@ -346,7 +377,7 @@ static void ui_browser__warn_lost_events(struct ui_browser *browser)
 		"Or reduce the sampling frequency.");
 }
 
-static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
+static int hist_browser__run(struct hist_browser *browser,
 			     struct hist_browser_timer *hbt)
 {
 	int key;
@@ -356,8 +387,7 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 	browser->b.entries = &browser->hists->entries;
 	browser->b.nr_entries = hist_browser__nr_entries(browser);
 
-	hist_browser__refresh_dimensions(browser);
-	hists__browser_title(browser->hists, title, sizeof(title), ev_name);
+	hists__browser_title(browser->hists, title, sizeof(title));
 
 	if (ui_browser__show(&browser->b, title,
 			     "Press '?' for help on key bindings") < 0)
@@ -384,7 +414,7 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 				ui_browser__warn_lost_events(&browser->b);
 			}
 
-			hists__browser_title(browser->hists, title, sizeof(title), ev_name);
+			hists__browser_title(browser->hists, title, sizeof(title));
 			ui_browser__show_title(&browser->b, title);
 			continue;
 		}
@@ -393,10 +423,10 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 			struct hist_entry *h = rb_entry(browser->b.top,
 							struct hist_entry, rb_node);
 			ui_helpline__pop();
-			ui_helpline__fpush("%d: nr_ent=(%d,%d), height=%d, idx=%d, fve: idx=%d, row_off=%d, nrows=%d",
+			ui_helpline__fpush("%d: nr_ent=(%d,%d), rows=%d, idx=%d, fve: idx=%d, row_off=%d, nrows=%d",
 					   seq++, browser->b.nr_entries,
 					   browser->hists->nr_entries,
-					   browser->b.height,
+					   browser->b.rows,
 					   browser->b.index,
 					   browser->b.top_idx,
 					   h->row_offset, h->nr_rows);
@@ -410,6 +440,10 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 			/* Expand the whole world. */
 			hist_browser__set_folding(browser, true);
 			break;
+		case 'H':
+			browser->show_headers = !browser->show_headers;
+			hist_browser__update_rows(browser);
+			break;
 		case K_ENTER:
 			if (hist_browser__toggle_fold(browser))
 				break;
@@ -509,13 +543,13 @@ static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *browse
 			}
 
 			ui_browser__set_color(&browser->b, color);
-			ui_browser__gotorc(&browser->b, row, 0);
+			hist_browser__gotorc(browser, row, 0);
 			slsmg_write_nstring(" ", offset + extra_offset);
 			slsmg_printf("%c ", folded_sign);
 			slsmg_write_nstring(str, width);
 			free(alloc_str);
 
-			if (++row == browser->b.height)
+			if (++row == browser->b.rows)
 				goto out;
 do_next:
 			if (folded_sign == '+')
@@ -528,7 +562,7 @@ do_next:
 									 new_level, row, row_offset,
 									 is_current_entry);
 		}
-		if (row == browser->b.height)
+		if (row == browser->b.rows)
 			goto out;
 		node = next;
 	}
@@ -568,13 +602,13 @@ static int hist_browser__show_callchain_node(struct hist_browser *browser,
 
 		s = callchain_list__sym_name(chain, bf, sizeof(bf),
 					     browser->show_dso);
-		ui_browser__gotorc(&browser->b, row, 0);
+		hist_browser__gotorc(browser, row, 0);
 		ui_browser__set_color(&browser->b, color);
 		slsmg_write_nstring(" ", offset);
 		slsmg_printf("%c ", folded_sign);
 		slsmg_write_nstring(s, width - 2);
 
-		if (++row == browser->b.height)
+		if (++row == browser->b.rows)
 			goto out;
 	}
 
@@ -603,7 +637,7 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
 		row += hist_browser__show_callchain_node(browser, node, level,
 							 row, row_offset,
 							 is_current_entry);
-		if (row == browser->b.height)
+		if (row == browser->b.rows)
 			break;
 	}
 
@@ -733,7 +767,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 			.ptr		= &arg,
 		};
 
-		ui_browser__gotorc(&browser->b, row, 0);
+		hist_browser__gotorc(browser, row, 0);
 
 		perf_hpp__for_each_format(fmt) {
 			if (perf_hpp__should_skip(fmt))
@@ -777,7 +811,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 	} else
 		--row_offset;
 
-	if (folded_sign == '-' && row != browser->b.height) {
+	if (folded_sign == '-' && row != browser->b.rows) {
 		printed += hist_browser__show_callchain(browser, &entry->sorted_chain,
 							1, row, &row_offset,
 							&current_entry);
@@ -788,6 +822,56 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 	return printed;
 }
 
+static int advance_hpp_check(struct perf_hpp *hpp, int inc)
+{
+	advance_hpp(hpp, inc);
+	return hpp->size <= 0;
+}
+
+static int hists__scnprintf_headers(char *buf, size_t size, struct hists *hists)
+{
+	struct perf_hpp dummy_hpp = {
+		.buf    = buf,
+		.size   = size,
+	};
+	struct perf_hpp_fmt *fmt;
+	size_t ret = 0;
+
+	if (symbol_conf.use_callchain) {
+		ret = scnprintf(buf, size, "  ");
+		if (advance_hpp_check(&dummy_hpp, ret))
+			return ret;
+	}
+
+	perf_hpp__for_each_format(fmt) {
+		if (perf_hpp__should_skip(fmt))
+			continue;
+
+		/* We need to add the length of the columns header. */
+		perf_hpp__reset_width(fmt, hists);
+
+		ret = fmt->header(fmt, &dummy_hpp, hists_to_evsel(hists));
+		if (advance_hpp_check(&dummy_hpp, ret))
+			break;
+
+		ret = scnprintf(dummy_hpp.buf, dummy_hpp.size, "  ");
+		if (advance_hpp_check(&dummy_hpp, ret))
+			break;
+	}
+
+	return ret;
+}
+
+static void hist_browser__show_headers(struct hist_browser *browser)
+{
+	char headers[1024];
+
+	hists__scnprintf_headers(headers, sizeof(headers), browser->hists);
+	ui_browser__gotorc(&browser->b, 0, 0);
+	ui_browser__set_color(&browser->b, HE_COLORSET_ROOT);
+	slsmg_write_nstring(headers, browser->b.width + 1);
+}
+
 static void ui_browser__hists_init_top(struct ui_browser *browser)
 {
 	if (browser->top == NULL) {
@@ -801,9 +885,15 @@ static void ui_browser__hists_init_top(struct ui_browser *browser)
 static unsigned int hist_browser__refresh(struct ui_browser *browser)
 {
 	unsigned row = 0;
+	u16 header_offset = 0;
 	struct rb_node *nd;
 	struct hist_browser *hb = container_of(browser, struct hist_browser, b);
 
+	if (hb->show_headers) {
+		hist_browser__show_headers(hb);
+		header_offset = 1;
+	}
+
 	ui_browser__hists_init_top(browser);
 
 	for (nd = browser->top; nd; nd = rb_next(nd)) {
@@ -818,11 +908,11 @@ static unsigned int hist_browser__refresh(struct ui_browser *browser)
 			continue;
 
 		row += hist_browser__show_entry(hb, h, row);
-		if (row == browser->height)
+		if (row == browser->rows)
 			break;
 	}
 
-	return row;
+	return row + header_offset;
 }
 
 static struct rb_node *hists__filter_entries(struct rb_node *nd,
@@ -1191,8 +1281,10 @@ static struct hist_browser *hist_browser__new(struct hists *hists)
 	if (browser) {
 		browser->hists = hists;
 		browser->b.refresh = hist_browser__refresh;
+		browser->b.refresh_dimensions = hist_browser__refresh_dimensions;
 		browser->b.seek = ui_browser__hists_seek;
 		browser->b.use_navkeypressed = true;
+		browser->show_headers = symbol_conf.show_hist_headers;
 	}
 
 	return browser;
@@ -1213,8 +1305,7 @@ static struct thread *hist_browser__selected_thread(struct hist_browser *browser
 	return browser->he_selection->thread;
 }
 
-static int hists__browser_title(struct hists *hists, char *bf, size_t size,
-				const char *ev_name)
+static int hists__browser_title(struct hists *hists, char *bf, size_t size)
 {
 	char unit;
 	int printed;
@@ -1223,6 +1314,7 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size,
 	unsigned long nr_samples = hists->stats.nr_events[PERF_RECORD_SAMPLE];
 	u64 nr_events = hists->stats.total_period;
 	struct perf_evsel *evsel = hists_to_evsel(hists);
+	const char *ev_name = perf_evsel__name(evsel);
 	char buf[512];
 	size_t buflen = sizeof(buf);
 
@@ -1390,7 +1482,7 @@ static void hist_browser__update_nr_entries(struct hist_browser *hb)
 }
 
 static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
-				    const char *helpline, const char *ev_name,
+				    const char *helpline,
 				    bool left_exits,
 				    struct hist_browser_timer *hbt,
 				    float min_pcnt,
@@ -1422,6 +1514,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	"d             Zoom into current DSO\n"				\
 	"E             Expand all callchains\n"				\
 	"F             Toggle percentage of filtered entries\n"		\
+	"H             Display column headers\n"			\
 
 	/* help messages are sorted by lexical order of the hotkey */
 	const char report_help[] = HIST_BROWSER_HELP_COMMON
@@ -1465,7 +1558,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 
 		nr_options = 0;
 
-		key = hist_browser__run(browser, ev_name, hbt);
+		key = hist_browser__run(browser, hbt);
 
 		if (browser->he_selection != NULL) {
 			thread = hist_browser__selected_thread(browser);
@@ -1843,7 +1936,7 @@ static int perf_evsel_menu__run(struct perf_evsel_menu *menu,
 {
 	struct perf_evlist *evlist = menu->b.priv;
 	struct perf_evsel *pos;
-	const char *ev_name, *title = "Available samples";
+	const char *title = "Available samples";
 	int delay_secs = hbt ? hbt->refresh : 0;
 	int key;
 
@@ -1876,9 +1969,8 @@ browse_hists:
 			 */
 			if (hbt)
 				hbt->timer(hbt->arg);
-			ev_name = perf_evsel__name(pos);
 			key = perf_evsel__hists_browse(pos, nr_events, help,
-						       ev_name, true, hbt,
+						       true, hbt,
 						       menu->min_pcnt,
 						       menu->env);
 			ui_browser__show_title(&menu->b, title);
@@ -1982,10 +2074,9 @@ int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
 single_entry:
 	if (nr_entries == 1) {
 		struct perf_evsel *first = perf_evlist__first(evlist);
-		const char *ev_name = perf_evsel__name(first);
 
 		return perf_evsel__hists_browse(first, nr_entries, help,
-						ev_name, false, hbt, min_pcnt,
+						false, hbt, min_pcnt,
 						env);
 	}
 
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 90122ab..40af0ac 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -479,7 +479,7 @@ print_entries:
 
 		if (h->ms.map == NULL && verbose > 1) {
 			__map_groups__fprintf_maps(h->thread->mg,
-						   MAP__FUNCTION, verbose, fp);
+						   MAP__FUNCTION, fp);
 			fprintf(fp, "%.10s end\n", graph_dotted_line);
 		}
 	}
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 48b6d3f..437ee09 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -626,7 +626,7 @@ int sample__resolve_callchain(struct perf_sample *sample, struct symbol **parent
 
 int hist_entry__append_callchain(struct hist_entry *he, struct perf_sample *sample)
 {
-	if (!symbol_conf.use_callchain)
+	if (!symbol_conf.use_callchain || sample->callchain == NULL)
 		return 0;
 	return callchain_append(he->callchain, &callchain_cursor, sample->period);
 }
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 8f84423..da43619 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -176,4 +176,17 @@ static inline void callchain_cursor_snapshot(struct callchain_cursor *dest,
 	dest->first = src->curr;
 	dest->nr -= src->pos;
 }
+
+#ifdef HAVE_SKIP_CALLCHAIN_IDX
+extern int arch_skip_callchain_idx(struct machine *machine,
+			struct thread *thread, struct ip_callchain *chain);
+#else
+static inline int arch_skip_callchain_idx(struct machine *machine __maybe_unused,
+			struct thread *thread __maybe_unused,
+			struct ip_callchain *chain __maybe_unused)
+{
+	return -1;
+}
+#endif
+
 #endif	/* __PERF_CALLCHAIN_H */
diff --git a/tools/perf/util/cloexec.c b/tools/perf/util/cloexec.c
new file mode 100644
index 0000000..c5d05ec
--- /dev/null
+++ b/tools/perf/util/cloexec.c
@@ -0,0 +1,57 @@
+#include "util.h"
+#include "../perf.h"
+#include "cloexec.h"
+#include "asm/bug.h"
+
+static unsigned long flag = PERF_FLAG_FD_CLOEXEC;
+
+static int perf_flag_probe(void)
+{
+	/* use 'safest' configuration as used in perf_evsel__fallback() */
+	struct perf_event_attr attr = {
+		.type = PERF_COUNT_SW_CPU_CLOCK,
+		.config = PERF_COUNT_SW_CPU_CLOCK,
+	};
+	int fd;
+	int err;
+
+	/* check cloexec flag */
+	fd = sys_perf_event_open(&attr, 0, -1, -1,
+				 PERF_FLAG_FD_CLOEXEC);
+	err = errno;
+
+	if (fd >= 0) {
+		close(fd);
+		return 1;
+	}
+
+	WARN_ONCE(err != EINVAL,
+		  "perf_event_open(..., PERF_FLAG_FD_CLOEXEC) failed with unexpected error %d (%s)\n",
+		  err, strerror(err));
+
+	/* not supported, confirm error related to PERF_FLAG_FD_CLOEXEC */
+	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
+	err = errno;
+
+	if (WARN_ONCE(fd < 0,
+		      "perf_event_open(..., 0) failed unexpectedly with error %d (%s)\n",
+		      err, strerror(err)))
+		return -1;
+
+	close(fd);
+
+	return 0;
+}
+
+unsigned long perf_event_open_cloexec_flag(void)
+{
+	static bool probed;
+
+	if (!probed) {
+		if (perf_flag_probe() <= 0)
+			flag = 0;
+		probed = true;
+	}
+
+	return flag;
+}
diff --git a/tools/perf/util/cloexec.h b/tools/perf/util/cloexec.h
new file mode 100644
index 0000000..94a5a7d
--- /dev/null
+++ b/tools/perf/util/cloexec.h
@@ -0,0 +1,6 @@
+#ifndef __PERF_CLOEXEC_H
+#define __PERF_CLOEXEC_H
+
+unsigned long perf_event_open_cloexec_flag(void);
+
+#endif /* __PERF_CLOEXEC_H */
diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 24519e1..1e5e2e5 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -350,6 +350,16 @@ static int perf_default_core_config(const char *var __maybe_unused,
 	return 0;
 }
 
+static int perf_ui_config(const char *var, const char *value)
+{
+	/* Add other config variables here. */
+	if (!strcmp(var, "ui.show-headers")) {
+		symbol_conf.show_hist_headers = perf_config_bool(var, value);
+		return 0;
+	}
+	return 0;
+}
+
 int perf_default_config(const char *var, const char *value,
 			void *dummy __maybe_unused)
 {
@@ -359,6 +369,9 @@ int perf_default_config(const char *var, const char *value,
 	if (!prefixcmp(var, "hist."))
 		return perf_hist_config(var, value);
 
+	if (!prefixcmp(var, "ui."))
+		return perf_ui_config(var, value);
+
 	/* Add other config variables here. */
 	return 0;
 }
diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
index 55de44e..29d720c 100644
--- a/tools/perf/util/data.c
+++ b/tools/perf/util/data.c
@@ -7,6 +7,7 @@
 
 #include "data.h"
 #include "util.h"
+#include "debug.h"
 
 static bool check_pipe(struct perf_data_file *file)
 {
@@ -65,7 +66,7 @@ static int open_file_read(struct perf_data_file *file)
 		goto out_close;
 
 	if (!file->force && st.st_uid && (st.st_uid != geteuid())) {
-		pr_err("file %s not owned by current user or root\n",
+		pr_err("File %s not owned by current user or root (use -f to override)\n",
 		       file->path);
 		goto out_close;
 	}
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 299b555..71d4193 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -16,11 +16,11 @@
 int verbose;
 bool dump_trace = false, quiet = false;
 
-static int _eprintf(int level, const char *fmt, va_list args)
+static int _eprintf(int level, int var, const char *fmt, va_list args)
 {
 	int ret = 0;
 
-	if (verbose >= level) {
+	if (var >= level) {
 		if (use_browser >= 1)
 			ui_helpline__vshow(fmt, args);
 		else
@@ -30,13 +30,13 @@ static int _eprintf(int level, const char *fmt, va_list args)
 	return ret;
 }
 
-int eprintf(int level, const char *fmt, ...)
+int eprintf(int level, int var, const char *fmt, ...)
 {
 	va_list args;
 	int ret;
 
 	va_start(args, fmt);
-	ret = _eprintf(level, fmt, args);
+	ret = _eprintf(level, var, fmt, args);
 	va_end(args);
 
 	return ret;
@@ -51,9 +51,9 @@ void pr_stat(const char *fmt, ...)
 	va_list args;
 
 	va_start(args, fmt);
-	_eprintf(1, fmt, args);
+	_eprintf(1, verbose, fmt, args);
 	va_end(args);
-	eprintf(1, "\n");
+	eprintf(1, verbose, "\n");
 }
 
 int dump_printf(const char *fmt, ...)
@@ -105,3 +105,47 @@ void trace_event(union perf_event *event)
 	}
 	printf(".\n");
 }
+
+static struct debug_variable {
+	const char *name;
+	int *ptr;
+} debug_variables[] = {
+	{ .name = "verbose", .ptr = &verbose },
+	{ .name = NULL, }
+};
+
+int perf_debug_option(const char *str)
+{
+	struct debug_variable *var = &debug_variables[0];
+	char *vstr, *s = strdup(str);
+	int v = 1;
+
+	vstr = strchr(s, '=');
+	if (vstr)
+		*vstr++ = 0;
+
+	while (var->name) {
+		if (!strcmp(s, var->name))
+			break;
+		var++;
+	}
+
+	if (!var->name) {
+		pr_err("Unknown debug variable name '%s'\n", s);
+		free(s);
+		return -1;
+	}
+
+	if (vstr) {
+		v = atoi(vstr);
+		/*
+		 * Allow only values in range (0, 10),
+		 * otherwise set 0.
+		 */
+		v = (v < 0) || (v > 10) ? 0 : v;
+	}
+
+	*var->ptr = v;
+	free(s);
+	return 0;
+}
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 443694c..89fb6b0 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -11,6 +11,24 @@
 extern int verbose;
 extern bool quiet, dump_trace;
 
+#ifndef pr_fmt
+#define pr_fmt(fmt) fmt
+#endif
+
+#define pr_err(fmt, ...) \
+	eprintf(0, verbose, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warning(fmt, ...) \
+	eprintf(0, verbose, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_info(fmt, ...) \
+	eprintf(0, verbose, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debug(fmt, ...) \
+	eprintf(1, verbose, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debugN(n, fmt, ...) \
+	eprintf(n, verbose, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debug2(fmt, ...) pr_debugN(2, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debug3(fmt, ...) pr_debugN(3, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debug4(fmt, ...) pr_debugN(4, pr_fmt(fmt), ##__VA_ARGS__)
+
 int dump_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
 void trace_event(union perf_event *event);
 
@@ -19,4 +37,8 @@ int ui__warning(const char *format, ...) __attribute__((format(printf, 1, 2)));
 
 void pr_stat(const char *fmt, ...);
 
+int eprintf(int level, int var, const char *fmt, ...) __attribute__((format(printf, 3, 4)));
+
+int perf_debug_option(const char *str);
+
 #endif	/* __PERF_DEBUG_H */
diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 819f104..90d02c66 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -216,7 +216,7 @@ static int open_dso(struct dso *dso, struct machine *machine)
 {
 	int fd = __open_dso(dso, machine);
 
-	if (fd > 0) {
+	if (fd >= 0) {
 		dso__list_add(dso);
 		/*
 		 * Check if we crossed the allowed number
@@ -331,26 +331,44 @@ int dso__data_fd(struct dso *dso, struct machine *machine)
 	};
 	int i = 0;
 
+	if (dso->data.status == DSO_DATA_STATUS_ERROR)
+		return -1;
+
 	if (dso->data.fd >= 0)
-		return dso->data.fd;
+		goto out;
 
 	if (dso->binary_type != DSO_BINARY_TYPE__NOT_FOUND) {
 		dso->data.fd = open_dso(dso, machine);
-		return dso->data.fd;
+		goto out;
 	}
 
 	do {
-		int fd;
-
 		dso->binary_type = binary_type_data[i++];
 
-		fd = open_dso(dso, machine);
-		if (fd >= 0)
-			return dso->data.fd = fd;
+		dso->data.fd = open_dso(dso, machine);
+		if (dso->data.fd >= 0)
+			goto out;
 
 	} while (dso->binary_type != DSO_BINARY_TYPE__NOT_FOUND);
+out:
+	if (dso->data.fd >= 0)
+		dso->data.status = DSO_DATA_STATUS_OK;
+	else
+		dso->data.status = DSO_DATA_STATUS_ERROR;
 
-	return -EINVAL;
+	return dso->data.fd;
+}
+
+bool dso__data_status_seen(struct dso *dso, enum dso_data_status_seen by)
+{
+	u32 flag = 1 << by;
+
+	if (dso->data.status_seen & flag)
+		return true;
+
+	dso->data.status_seen |= flag;
+
+	return false;
 }
 
 static void
@@ -526,6 +544,28 @@ static int data_file_size(struct dso *dso)
 	return 0;
 }
 
+/**
+ * dso__data_size - Return dso data size
+ * @dso: dso object
+ * @machine: machine object
+ *
+ * Return: dso data size
+ */
+off_t dso__data_size(struct dso *dso, struct machine *machine)
+{
+	int fd;
+
+	fd = dso__data_fd(dso, machine);
+	if (fd < 0)
+		return fd;
+
+	if (data_file_size(dso))
+		return -1;
+
+	/* For now just estimate dso data size is close to file size */
+	return dso->data.file_size;
+}
+
 static ssize_t data_read_offset(struct dso *dso, u64 offset,
 				u8 *data, ssize_t size)
 {
@@ -701,8 +741,10 @@ struct dso *dso__new(const char *name)
 			dso->symbols[i] = dso->symbol_names[i] = RB_ROOT;
 		dso->data.cache = RB_ROOT;
 		dso->data.fd = -1;
+		dso->data.status = DSO_DATA_STATUS_UNKNOWN;
 		dso->symtab_type = DSO_BINARY_TYPE__NOT_FOUND;
 		dso->binary_type = DSO_BINARY_TYPE__NOT_FOUND;
+		dso->is_64_bit = (sizeof(void *) == 8);
 		dso->loaded = 0;
 		dso->rel = 0;
 		dso->sorted_by_name = 0;
@@ -898,3 +940,14 @@ size_t dso__fprintf(struct dso *dso, enum map_type type, FILE *fp)
 
 	return ret;
 }
+
+enum dso_type dso__type(struct dso *dso, struct machine *machine)
+{
+	int fd;
+
+	fd = dso__data_fd(dso, machine);
+	if (fd < 0)
+		return DSO__TYPE_UNKNOWN;
+
+	return dso__type_fd(fd);
+}
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index ad553ba..5e463c0 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -5,6 +5,7 @@
 #include <linux/rbtree.h>
 #include <stdbool.h>
 #include <linux/types.h>
+#include <linux/bitops.h>
 #include "map.h"
 #include "build-id.h"
 
@@ -40,6 +41,23 @@ enum dso_swap_type {
 	DSO_SWAP__YES,
 };
 
+enum dso_data_status {
+	DSO_DATA_STATUS_ERROR	= -1,
+	DSO_DATA_STATUS_UNKNOWN	= 0,
+	DSO_DATA_STATUS_OK	= 1,
+};
+
+enum dso_data_status_seen {
+	DSO_DATA_STATUS_SEEN_ITRACE,
+};
+
+enum dso_type {
+	DSO__TYPE_UNKNOWN,
+	DSO__TYPE_64BIT,
+	DSO__TYPE_32BIT,
+	DSO__TYPE_X32BIT,
+};
+
 #define DSO__SWAP(dso, type, val)			\
 ({							\
 	type ____r = val;				\
@@ -90,6 +108,7 @@ struct dso {
 	u8		 annotate_warned:1;
 	u8		 short_name_allocated:1;
 	u8		 long_name_allocated:1;
+	u8		 is_64_bit:1;
 	u8		 sorted_by_name;
 	u8		 loaded;
 	u8		 rel;
@@ -103,6 +122,8 @@ struct dso {
 	struct {
 		struct rb_root	 cache;
 		int		 fd;
+		int		 status;
+		u32		 status_seen;
 		size_t		 file_size;
 		struct list_head open_entry;
 	} data;
@@ -153,6 +174,7 @@ int dso__read_binary_type_filename(const struct dso *dso, enum dso_binary_type t
  * The dso__data_* external interface provides following functions:
  *   dso__data_fd
  *   dso__data_close
+ *   dso__data_size
  *   dso__data_read_offset
  *   dso__data_read_addr
  *
@@ -190,11 +212,13 @@ int dso__read_binary_type_filename(const struct dso *dso, enum dso_binary_type t
 int dso__data_fd(struct dso *dso, struct machine *machine);
 void dso__data_close(struct dso *dso);
 
+off_t dso__data_size(struct dso *dso, struct machine *machine);
 ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
 			      u64 offset, u8 *data, ssize_t size);
 ssize_t dso__data_read_addr(struct dso *dso, struct map *map,
 			    struct machine *machine, u64 addr,
 			    u8 *data, ssize_t size);
+bool dso__data_status_seen(struct dso *dso, enum dso_data_status_seen by);
 
 struct map *dso__new_map(const char *name);
 struct dso *dso__kernel_findnew(struct machine *machine, const char *name,
@@ -229,4 +253,6 @@ static inline bool dso__is_kcore(struct dso *dso)
 
 void dso__free_a2l(struct dso *dso);
 
+enum dso_type dso__type(struct dso *dso, struct machine *machine);
+
 #endif /* __PERF_DSO */
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index d0281bd..1398c83 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -603,7 +603,14 @@ int perf_event__synthesize_kernel_mmap(struct perf_tool *tool,
 
 size_t perf_event__fprintf_comm(union perf_event *event, FILE *fp)
 {
-	return fprintf(fp, ": %s:%d\n", event->comm.comm, event->comm.tid);
+	const char *s;
+
+	if (event->header.misc & PERF_RECORD_MISC_COMM_EXEC)
+		s = " exec";
+	else
+		s = "";
+
+	return fprintf(fp, "%s: %s:%d\n", s, event->comm.comm, event->comm.tid);
 }
 
 int perf_event__process_comm(struct perf_tool *tool __maybe_unused,
@@ -781,6 +788,7 @@ try_again:
 		    cpumode == PERF_RECORD_MISC_USER &&
 		    machine && mg != &machine->kmaps) {
 			mg = &machine->kmaps;
+			load_map = true;
 			goto try_again;
 		}
 	} else {
@@ -866,3 +874,45 @@ int perf_event__preprocess_sample(const union perf_event *event,
 
 	return 0;
 }
+
+bool is_bts_event(struct perf_event_attr *attr)
+{
+	return attr->type == PERF_TYPE_HARDWARE &&
+	       (attr->config & PERF_COUNT_HW_BRANCH_INSTRUCTIONS) &&
+	       attr->sample_period == 1;
+}
+
+bool sample_addr_correlates_sym(struct perf_event_attr *attr)
+{
+	if (attr->type == PERF_TYPE_SOFTWARE &&
+	    (attr->config == PERF_COUNT_SW_PAGE_FAULTS ||
+	     attr->config == PERF_COUNT_SW_PAGE_FAULTS_MIN ||
+	     attr->config == PERF_COUNT_SW_PAGE_FAULTS_MAJ))
+		return true;
+
+	if (is_bts_event(attr))
+		return true;
+
+	return false;
+}
+
+void perf_event__preprocess_sample_addr(union perf_event *event,
+					struct perf_sample *sample,
+					struct machine *machine,
+					struct thread *thread,
+					struct addr_location *al)
+{
+	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+
+	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
+			      sample->addr, al);
+	if (!al->map)
+		thread__find_addr_map(thread, machine, cpumode, MAP__VARIABLE,
+				      sample->addr, al);
+
+	al->cpu = sample->cpu;
+	al->sym = NULL;
+
+	if (al->map)
+		al->sym = map__find_symbol(al->map, al->addr, NULL);
+}
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index e5dd40a..94d6976 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -288,6 +288,16 @@ int perf_event__preprocess_sample(const union perf_event *event,
 				  struct addr_location *al,
 				  struct perf_sample *sample);
 
+struct thread;
+
+bool is_bts_event(struct perf_event_attr *attr);
+bool sample_addr_correlates_sym(struct perf_event_attr *attr);
+void perf_event__preprocess_sample_addr(union perf_event *event,
+					struct perf_sample *sample,
+					struct machine *machine,
+					struct thread *thread,
+					struct addr_location *al);
+
 const char *perf_event__name(unsigned int id);
 
 size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 59ef280..814e954 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -606,12 +606,17 @@ static int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
 	return evlist->mmap != NULL ? 0 : -ENOMEM;
 }
 
-static int __perf_evlist__mmap(struct perf_evlist *evlist,
-			       int idx, int prot, int mask, int fd)
+struct mmap_params {
+	int prot;
+	int mask;
+};
+
+static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx,
+			       struct mmap_params *mp, int fd)
 {
 	evlist->mmap[idx].prev = 0;
-	evlist->mmap[idx].mask = mask;
-	evlist->mmap[idx].base = mmap(NULL, evlist->mmap_len, prot,
+	evlist->mmap[idx].mask = mp->mask;
+	evlist->mmap[idx].base = mmap(NULL, evlist->mmap_len, mp->prot,
 				      MAP_SHARED, fd, 0);
 	if (evlist->mmap[idx].base == MAP_FAILED) {
 		pr_debug2("failed to mmap perf event ring buffer, error %d\n",
@@ -625,8 +630,8 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist,
 }
 
 static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
-				       int prot, int mask, int cpu, int thread,
-				       int *output)
+				       struct mmap_params *mp, int cpu,
+				       int thread, int *output)
 {
 	struct perf_evsel *evsel;
 
@@ -635,8 +640,7 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
 
 		if (*output == -1) {
 			*output = fd;
-			if (__perf_evlist__mmap(evlist, idx, prot, mask,
-						*output) < 0)
+			if (__perf_evlist__mmap(evlist, idx, mp, *output) < 0)
 				return -1;
 		} else {
 			if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, *output) != 0)
@@ -651,8 +655,8 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
 	return 0;
 }
 
-static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot,
-				     int mask)
+static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist,
+				     struct mmap_params *mp)
 {
 	int cpu, thread;
 	int nr_cpus = cpu_map__nr(evlist->cpus);
@@ -663,8 +667,8 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot,
 		int output = -1;
 
 		for (thread = 0; thread < nr_threads; thread++) {
-			if (perf_evlist__mmap_per_evsel(evlist, cpu, prot, mask,
-							cpu, thread, &output))
+			if (perf_evlist__mmap_per_evsel(evlist, cpu, mp, cpu,
+							thread, &output))
 				goto out_unmap;
 		}
 	}
@@ -677,8 +681,8 @@ out_unmap:
 	return -1;
 }
 
-static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot,
-					int mask)
+static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist,
+					struct mmap_params *mp)
 {
 	int thread;
 	int nr_threads = thread_map__nr(evlist->threads);
@@ -687,8 +691,8 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot,
 	for (thread = 0; thread < nr_threads; thread++) {
 		int output = -1;
 
-		if (perf_evlist__mmap_per_evsel(evlist, thread, prot, mask, 0,
-						thread, &output))
+		if (perf_evlist__mmap_per_evsel(evlist, thread, mp, 0, thread,
+						&output))
 			goto out_unmap;
 	}
 
@@ -793,7 +797,9 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 	struct perf_evsel *evsel;
 	const struct cpu_map *cpus = evlist->cpus;
 	const struct thread_map *threads = evlist->threads;
-	int prot = PROT_READ | (overwrite ? 0 : PROT_WRITE), mask;
+	struct mmap_params mp = {
+		.prot = PROT_READ | (overwrite ? 0 : PROT_WRITE),
+	};
 
 	if (evlist->mmap == NULL && perf_evlist__alloc_mmap(evlist) < 0)
 		return -ENOMEM;
@@ -804,7 +810,7 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 	evlist->overwrite = overwrite;
 	evlist->mmap_len = perf_evlist__mmap_size(pages);
 	pr_debug("mmap size %zuB\n", evlist->mmap_len);
-	mask = evlist->mmap_len - page_size - 1;
+	mp.mask = evlist->mmap_len - page_size - 1;
 
 	evlist__for_each(evlist, evsel) {
 		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
@@ -814,9 +820,9 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 	}
 
 	if (cpu_map__empty(cpus))
-		return perf_evlist__mmap_per_thread(evlist, prot, mask);
+		return perf_evlist__mmap_per_thread(evlist, &mp);
 
-	return perf_evlist__mmap_per_cpu(evlist, prot, mask);
+	return perf_evlist__mmap_per_cpu(evlist, &mp);
 }
 
 int perf_evlist__create_maps(struct perf_evlist *evlist, struct target *target)
@@ -1214,10 +1220,11 @@ int perf_evlist__strerror_open(struct perf_evlist *evlist __maybe_unused,
 					     "For your workloads it needs to be <= 1\nHint:\t");
 		}
 		printed += scnprintf(buf + printed, size - printed,
-				     "For system wide tracing it needs to be set to -1");
+				     "For system wide tracing it needs to be set to -1.\n");
 
 		printed += scnprintf(buf + printed, size - printed,
-				    ".\nHint:\tThe current value is %d.", value);
+				    "Hint:\tTry: 'sudo sh -c \"echo -1 > /proc/sys/kernel/perf_event_paranoid\"'\n"
+				    "Hint:\tThe current value is %d.", value);
 		break;
 	default:
 		scnprintf(buf, size, "%s", emsg);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 8606175..21a373e 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -29,6 +29,7 @@ static struct {
 	bool sample_id_all;
 	bool exclude_guest;
 	bool mmap2;
+	bool cloexec;
 } perf_missing_features;
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
@@ -623,7 +624,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 		attr->mmap_data = track;
 	}
 
-	if (opts->call_graph_enabled)
+	if (opts->call_graph_enabled && !evsel->no_aux_samples)
 		perf_evsel__config_callgraph(evsel, opts);
 
 	if (target__has_cpu(&opts->target))
@@ -637,7 +638,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 	     target__has_cpu(&opts->target) || per_cpu))
 		perf_evsel__set_sample_bit(evsel, TIME);
 
-	if (opts->raw_samples) {
+	if (opts->raw_samples && !evsel->no_aux_samples) {
 		perf_evsel__set_sample_bit(evsel, TIME);
 		perf_evsel__set_sample_bit(evsel, RAW);
 		perf_evsel__set_sample_bit(evsel, CPU);
@@ -650,7 +651,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 		attr->watermark = 0;
 		attr->wakeup_events = 1;
 	}
-	if (opts->branch_stack) {
+	if (opts->branch_stack && !evsel->no_aux_samples) {
 		perf_evsel__set_sample_bit(evsel, BRANCH_STACK);
 		attr->branch_sample_type = opts->branch_stack;
 	}
@@ -681,6 +682,11 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 	if (target__none(&opts->target) && perf_evsel__is_group_leader(evsel) &&
 		!opts->initial_delay)
 		attr->enable_on_exec = 1;
+
+	if (evsel->immediate) {
+		attr->disabled = 0;
+		attr->enable_on_exec = 0;
+	}
 }
 
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
@@ -960,6 +966,7 @@ static size_t perf_event_attr__fprintf(struct perf_event_attr *attr, FILE *fp)
 	ret += PRINT_ATTR2(exclude_user, exclude_kernel);
 	ret += PRINT_ATTR2(exclude_hv, exclude_idle);
 	ret += PRINT_ATTR2(mmap, comm);
+	ret += PRINT_ATTR2(mmap2, comm_exec);
 	ret += PRINT_ATTR2(freq, inherit_stat);
 	ret += PRINT_ATTR2(enable_on_exec, task);
 	ret += PRINT_ATTR2(watermark, precise_ip);
@@ -967,7 +974,6 @@ static size_t perf_event_attr__fprintf(struct perf_event_attr *attr, FILE *fp)
 	ret += PRINT_ATTR2(exclude_host, exclude_guest);
 	ret += PRINT_ATTR2N("excl.callchain_kern", exclude_callchain_kernel,
 			    "excl.callchain_user", exclude_callchain_user);
-	ret += PRINT_ATTR_U32(mmap2);
 
 	ret += PRINT_ATTR_U32(wakeup_events);
 	ret += PRINT_ATTR_U32(wakeup_watermark);
@@ -989,7 +995,7 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 			      struct thread_map *threads)
 {
 	int cpu, thread;
-	unsigned long flags = 0;
+	unsigned long flags = PERF_FLAG_FD_CLOEXEC;
 	int pid = -1, err;
 	enum { NO_CHANGE, SET_TO_MAX, INCREASED_MAX } set_rlimit = NO_CHANGE;
 
@@ -998,11 +1004,13 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 		return -ENOMEM;
 
 	if (evsel->cgrp) {
-		flags = PERF_FLAG_PID_CGROUP;
+		flags |= PERF_FLAG_PID_CGROUP;
 		pid = evsel->cgrp->fd;
 	}
 
 fallback_missing_features:
+	if (perf_missing_features.cloexec)
+		flags &= ~(unsigned long)PERF_FLAG_FD_CLOEXEC;
 	if (perf_missing_features.mmap2)
 		evsel->attr.mmap2 = 0;
 	if (perf_missing_features.exclude_guest)
@@ -1071,7 +1079,10 @@ try_fallback:
 	if (err != -EINVAL || cpu > 0 || thread > 0)
 		goto out_close;
 
-	if (!perf_missing_features.mmap2 && evsel->attr.mmap2) {
+	if (!perf_missing_features.cloexec && (flags & PERF_FLAG_FD_CLOEXEC)) {
+		perf_missing_features.cloexec = true;
+		goto fallback_missing_features;
+	} else if (!perf_missing_features.mmap2 && evsel->attr.mmap2) {
 		perf_missing_features.mmap2 = true;
 		goto fallback_missing_features;
 	} else if (!perf_missing_features.exclude_guest &&
@@ -1940,6 +1951,7 @@ int perf_evsel__fprintf(struct perf_evsel *evsel,
 		if_print(mmap);
 		if_print(mmap2);
 		if_print(comm);
+		if_print(comm_exec);
 		if_print(freq);
 		if_print(inherit_stat);
 		if_print(enable_on_exec);
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index a52e9a5..d7f93ce 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -83,6 +83,8 @@ struct perf_evsel {
 	int			is_pos;
 	bool 			supported;
 	bool 			needs_swap;
+	bool			no_aux_samples;
+	bool			immediate;
 	/* parse modifier helper */
 	int			exclude_GH;
 	int			nr_members;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 893f8e2..158c787 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -200,6 +200,47 @@ static int write_buildid(const char *name, size_t name_len, u8 *build_id,
 	return write_padded(fd, name, name_len + 1, len);
 }
 
+static int __dsos__hit_all(struct list_head *head)
+{
+	struct dso *pos;
+
+	list_for_each_entry(pos, head, node)
+		pos->hit = true;
+
+	return 0;
+}
+
+static int machine__hit_all_dsos(struct machine *machine)
+{
+	int err;
+
+	err = __dsos__hit_all(&machine->kernel_dsos);
+	if (err)
+		return err;
+
+	return __dsos__hit_all(&machine->user_dsos);
+}
+
+int dsos__hit_all(struct perf_session *session)
+{
+	struct rb_node *nd;
+	int err;
+
+	err = machine__hit_all_dsos(&session->machines.host);
+	if (err)
+		return err;
+
+	for (nd = rb_first(&session->machines.guests); nd; nd = rb_next(nd)) {
+		struct machine *pos = rb_entry(nd, struct machine, rb_node);
+
+		err = machine__hit_all_dsos(pos);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 static int __dsos__write_buildid_table(struct list_head *head,
 				       struct machine *machine,
 				       pid_t pid, u16 misc, int fd)
@@ -215,9 +256,9 @@ static int __dsos__write_buildid_table(struct list_head *head,
 		if (!pos->hit)
 			continue;
 
-		if (is_vdso_map(pos->short_name)) {
-			name = (char *) VDSO__MAP_NAME;
-			name_len = sizeof(VDSO__MAP_NAME) + 1;
+		if (dso__is_vdso(pos)) {
+			name = pos->short_name;
+			name_len = pos->short_name_len + 1;
 		} else if (dso__is_kcore(pos)) {
 			machine__mmap_name(machine, nm, sizeof(nm));
 			name = nm;
@@ -298,7 +339,7 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 
 	len = scnprintf(filename, size, "%s%s%s",
 		       debugdir, slash ? "/" : "",
-		       is_vdso ? VDSO__MAP_NAME : realname);
+		       is_vdso ? DSO__NAME_VDSO : realname);
 	if (mkdir_p(filename, 0755))
 		goto out_free;
 
@@ -386,7 +427,7 @@ static int dso__cache_build_id(struct dso *dso, struct machine *machine,
 			       const char *debugdir)
 {
 	bool is_kallsyms = dso->kernel && dso->long_name[0] != '/';
-	bool is_vdso = is_vdso_map(dso->short_name);
+	bool is_vdso = dso__is_vdso(dso);
 	const char *name = dso->long_name;
 	char nm[PATH_MAX];
 
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index d08cfe4..8f5cbae 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -151,6 +151,8 @@ int perf_event__process_build_id(struct perf_tool *tool,
 				 struct perf_session *session);
 bool is_perf_magic(u64 magic);
 
+int dsos__hit_all(struct perf_session *session);
+
 /*
  * arch specific callback
  */
diff --git a/tools/perf/util/include/linux/kernel.h b/tools/perf/util/include/linux/kernel.h
index 9844c31..09e8e7a 100644
--- a/tools/perf/util/include/linux/kernel.h
+++ b/tools/perf/util/include/linux/kernel.h
@@ -94,27 +94,6 @@ static inline int scnprintf(char * buf, size_t size, const char * fmt, ...)
 	return (i >= ssize) ? (ssize - 1) : i;
 }
 
-int eprintf(int level,
-	    const char *fmt, ...) __attribute__((format(printf, 2, 3)));
-
-#ifndef pr_fmt
-#define pr_fmt(fmt) fmt
-#endif
-
-#define pr_err(fmt, ...) \
-	eprintf(0, pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_warning(fmt, ...) \
-	eprintf(0, pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_info(fmt, ...) \
-	eprintf(0, pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_debug(fmt, ...) \
-	eprintf(1, pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_debugN(n, fmt, ...) \
-	eprintf(n, pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_debug2(fmt, ...) pr_debugN(2, pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_debug3(fmt, ...) pr_debugN(3, pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_debug4(fmt, ...) pr_debugN(4, pr_fmt(fmt), ##__VA_ARGS__)
-
 /*
  * This looks more complex than it should be. But we need to
  * get the type for the ~ right in round_down (it needs to be
diff --git a/tools/perf/util/kvm-stat.h b/tools/perf/util/kvm-stat.h
new file mode 100644
index 0000000..0b5a8cd
--- /dev/null
+++ b/tools/perf/util/kvm-stat.h
@@ -0,0 +1,140 @@
+#ifndef __PERF_KVM_STAT_H
+#define __PERF_KVM_STAT_H
+
+#include "../perf.h"
+#include "evsel.h"
+#include "evlist.h"
+#include "session.h"
+#include "tool.h"
+#include "stat.h"
+
+struct event_key {
+	#define INVALID_KEY     (~0ULL)
+	u64 key;
+	int info;
+	struct exit_reasons_table *exit_reasons;
+};
+
+struct kvm_event_stats {
+	u64 time;
+	struct stats stats;
+};
+
+struct kvm_event {
+	struct list_head hash_entry;
+	struct rb_node rb;
+
+	struct event_key key;
+
+	struct kvm_event_stats total;
+
+	#define DEFAULT_VCPU_NUM 8
+	int max_vcpu;
+	struct kvm_event_stats *vcpu;
+};
+
+typedef int (*key_cmp_fun)(struct kvm_event*, struct kvm_event*, int);
+
+struct kvm_event_key {
+	const char *name;
+	key_cmp_fun key;
+};
+
+struct perf_kvm_stat;
+
+struct child_event_ops {
+	void (*get_key)(struct perf_evsel *evsel,
+			struct perf_sample *sample,
+			struct event_key *key);
+	const char *name;
+};
+
+struct kvm_events_ops {
+	bool (*is_begin_event)(struct perf_evsel *evsel,
+			       struct perf_sample *sample,
+			       struct event_key *key);
+	bool (*is_end_event)(struct perf_evsel *evsel,
+			     struct perf_sample *sample, struct event_key *key);
+	struct child_event_ops *child_ops;
+	void (*decode_key)(struct perf_kvm_stat *kvm, struct event_key *key,
+			   char *decode);
+	const char *name;
+};
+
+struct exit_reasons_table {
+	unsigned long exit_code;
+	const char *reason;
+};
+
+#define EVENTS_BITS		12
+#define EVENTS_CACHE_SIZE	(1UL << EVENTS_BITS)
+
+struct perf_kvm_stat {
+	struct perf_tool    tool;
+	struct record_opts  opts;
+	struct perf_evlist  *evlist;
+	struct perf_session *session;
+
+	const char *file_name;
+	const char *report_event;
+	const char *sort_key;
+	int trace_vcpu;
+
+	struct exit_reasons_table *exit_reasons;
+	const char *exit_reasons_isa;
+
+	struct kvm_events_ops *events_ops;
+	key_cmp_fun compare;
+	struct list_head kvm_events_cache[EVENTS_CACHE_SIZE];
+
+	u64 total_time;
+	u64 total_count;
+	u64 lost_events;
+	u64 duration;
+
+	const char *pid_str;
+	struct intlist *pid_list;
+
+	struct rb_root result;
+
+	int timerfd;
+	unsigned int display_time;
+	bool live;
+};
+
+struct kvm_reg_events_ops {
+	const char *name;
+	struct kvm_events_ops *ops;
+};
+
+void exit_event_get_key(struct perf_evsel *evsel,
+			struct perf_sample *sample,
+			struct event_key *key);
+bool exit_event_begin(struct perf_evsel *evsel,
+		      struct perf_sample *sample,
+		      struct event_key *key);
+bool exit_event_end(struct perf_evsel *evsel,
+		    struct perf_sample *sample,
+		    struct event_key *key);
+void exit_event_decode_key(struct perf_kvm_stat *kvm,
+			   struct event_key *key,
+			   char *decode);
+
+bool kvm_exit_event(struct perf_evsel *evsel);
+bool kvm_entry_event(struct perf_evsel *evsel);
+
+#define define_exit_reasons_table(name, symbols)	\
+	static struct exit_reasons_table name[] = {	\
+		symbols, { -1, NULL }			\
+	}
+
+/*
+ * arch specific callbacks and data structures
+ */
+int cpu_isa_init(struct perf_kvm_stat *kvm, const char *cpuid);
+
+extern const char * const kvm_events_tp[];
+extern struct kvm_reg_events_ops kvm_reg_events_ops[];
+extern const char * const kvm_skip_events[];
+
+#endif /* __PERF_KVM_STAT_H */
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index c73e1fc..16bba9f 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -8,6 +8,7 @@
 #include "sort.h"
 #include "strlist.h"
 #include "thread.h"
+#include "vdso.h"
 #include <stdbool.h>
 #include <symbol/kallsyms.h>
 #include "unwind.h"
@@ -23,6 +24,8 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 	INIT_LIST_HEAD(&machine->dead_threads);
 	machine->last_match = NULL;
 
+	machine->vdso_info = NULL;
+
 	machine->kmaps.machine = machine;
 	machine->pid = pid;
 
@@ -34,7 +37,7 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 		return -ENOMEM;
 
 	if (pid != HOST_KERNEL_ID) {
-		struct thread *thread = machine__findnew_thread(machine, 0,
+		struct thread *thread = machine__findnew_thread(machine, -1,
 								pid);
 		char comm[64];
 
@@ -45,6 +48,8 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 		thread__set_comm(thread, comm, 0);
 	}
 
+	machine->current_tid = NULL;
+
 	return 0;
 }
 
@@ -103,7 +108,9 @@ void machine__exit(struct machine *machine)
 	map_groups__exit(&machine->kmaps);
 	dsos__delete(&machine->user_dsos);
 	dsos__delete(&machine->kernel_dsos);
+	vdso__exit(machine);
 	zfree(&machine->root_dir);
+	zfree(&machine->current_tid);
 }
 
 void machine__delete(struct machine *machine)
@@ -272,6 +279,52 @@ void machines__set_id_hdr_size(struct machines *machines, u16 id_hdr_size)
 	return;
 }
 
+static void machine__update_thread_pid(struct machine *machine,
+				       struct thread *th, pid_t pid)
+{
+	struct thread *leader;
+
+	if (pid == th->pid_ || pid == -1 || th->pid_ != -1)
+		return;
+
+	th->pid_ = pid;
+
+	if (th->pid_ == th->tid)
+		return;
+
+	leader = machine__findnew_thread(machine, th->pid_, th->pid_);
+	if (!leader)
+		goto out_err;
+
+	if (!leader->mg)
+		leader->mg = map_groups__new();
+
+	if (!leader->mg)
+		goto out_err;
+
+	if (th->mg == leader->mg)
+		return;
+
+	if (th->mg) {
+		/*
+		 * Maps are created from MMAP events which provide the pid and
+		 * tid.  Consequently there never should be any maps on a thread
+		 * with an unknown pid.  Just print an error if there are.
+		 */
+		if (!map_groups__empty(th->mg))
+			pr_err("Discarding thread maps for %d:%d\n",
+			       th->pid_, th->tid);
+		map_groups__delete(th->mg);
+	}
+
+	th->mg = map_groups__get(leader->mg);
+
+	return;
+
+out_err:
+	pr_err("Failed to join map groups for %d:%d\n", th->pid_, th->tid);
+}
+
 static struct thread *__machine__findnew_thread(struct machine *machine,
 						pid_t pid, pid_t tid,
 						bool create)
@@ -285,10 +338,10 @@ static struct thread *__machine__findnew_thread(struct machine *machine,
 	 * so most of the time we dont have to look up
 	 * the full rbtree:
 	 */
-	if (machine->last_match && machine->last_match->tid == tid) {
-		if (pid && pid != machine->last_match->pid_)
-			machine->last_match->pid_ = pid;
-		return machine->last_match;
+	th = machine->last_match;
+	if (th && th->tid == tid) {
+		machine__update_thread_pid(machine, th, pid);
+		return th;
 	}
 
 	while (*p != NULL) {
@@ -297,8 +350,7 @@ static struct thread *__machine__findnew_thread(struct machine *machine,
 
 		if (th->tid == tid) {
 			machine->last_match = th;
-			if (pid && pid != th->pid_)
-				th->pid_ = pid;
+			machine__update_thread_pid(machine, th, pid);
 			return th;
 		}
 
@@ -325,8 +377,10 @@ static struct thread *__machine__findnew_thread(struct machine *machine,
 		 * within thread__init_map_groups to find the thread
 		 * leader and that would screwed the rb tree.
 		 */
-		if (thread__init_map_groups(th, machine))
+		if (thread__init_map_groups(th, machine)) {
+			thread__delete(th);
 			return NULL;
+		}
 	}
 
 	return th;
@@ -1045,14 +1099,14 @@ int machine__process_mmap2_event(struct machine *machine,
 	else
 		type = MAP__FUNCTION;
 
-	map = map__new(&machine->user_dsos, event->mmap2.start,
+	map = map__new(machine, event->mmap2.start,
 			event->mmap2.len, event->mmap2.pgoff,
 			event->mmap2.pid, event->mmap2.maj,
 			event->mmap2.min, event->mmap2.ino,
 			event->mmap2.ino_generation,
 			event->mmap2.prot,
 			event->mmap2.flags,
-			event->mmap2.filename, type);
+			event->mmap2.filename, type, thread);
 
 	if (map == NULL)
 		goto out_problem;
@@ -1095,11 +1149,11 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 	else
 		type = MAP__FUNCTION;
 
-	map = map__new(&machine->user_dsos, event->mmap.start,
+	map = map__new(machine, event->mmap.start,
 			event->mmap.len, event->mmap.pgoff,
 			event->mmap.pid, 0, 0, 0, 0, 0, 0,
 			event->mmap.filename,
-			type);
+			type, thread);
 
 	if (map == NULL)
 		goto out_problem;
@@ -1281,7 +1335,9 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 	u8 cpumode = PERF_RECORD_MISC_USER;
 	int chain_nr = min(max_stack, (int)chain->nr);
 	int i;
+	int j;
 	int err;
+	int skip_idx __maybe_unused;
 
 	callchain_cursor_reset(&callchain_cursor);
 
@@ -1290,14 +1346,26 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 		return 0;
 	}
 
+	/*
+	 * Based on DWARF debug information, some architectures skip
+	 * a callchain entry saved by the kernel.
+	 */
+	skip_idx = arch_skip_callchain_idx(machine, thread, chain);
+
 	for (i = 0; i < chain_nr; i++) {
 		u64 ip;
 		struct addr_location al;
 
 		if (callchain_param.order == ORDER_CALLEE)
-			ip = chain->ips[i];
+			j = i;
 		else
-			ip = chain->ips[chain->nr - i - 1];
+			j = chain->nr - i - 1;
+
+#ifdef HAVE_SKIP_CALLCHAIN_IDX
+		if (j == skip_idx)
+			continue;
+#endif
+		ip = chain->ips[j];
 
 		if (ip >= PERF_CONTEXT_MAX) {
 			switch (ip) {
@@ -1420,3 +1488,46 @@ int __machine__synthesize_threads(struct machine *machine, struct perf_tool *too
 	/* command specified */
 	return 0;
 }
+
+pid_t machine__get_current_tid(struct machine *machine, int cpu)
+{
+	if (cpu < 0 || cpu >= MAX_NR_CPUS || !machine->current_tid)
+		return -1;
+
+	return machine->current_tid[cpu];
+}
+
+int machine__set_current_tid(struct machine *machine, int cpu, pid_t pid,
+			     pid_t tid)
+{
+	struct thread *thread;
+
+	if (cpu < 0)
+		return -EINVAL;
+
+	if (!machine->current_tid) {
+		int i;
+
+		machine->current_tid = calloc(MAX_NR_CPUS, sizeof(pid_t));
+		if (!machine->current_tid)
+			return -ENOMEM;
+		for (i = 0; i < MAX_NR_CPUS; i++)
+			machine->current_tid[i] = -1;
+	}
+
+	if (cpu >= MAX_NR_CPUS) {
+		pr_err("Requested CPU %d too large. ", cpu);
+		pr_err("Consider raising MAX_NR_CPUS\n");
+		return -EINVAL;
+	}
+
+	machine->current_tid[cpu] = tid;
+
+	thread = machine__findnew_thread(machine, pid, tid);
+	if (!thread)
+		return -ENOMEM;
+
+	thread->cpu = cpu;
+
+	return 0;
+}
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index c8c74a1..b972824 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -20,6 +20,8 @@ union perf_event;
 
 extern const char *ref_reloc_sym_names[];
 
+struct vdso_info;
+
 struct machine {
 	struct rb_node	  rb_node;
 	pid_t		  pid;
@@ -28,11 +30,13 @@ struct machine {
 	struct rb_root	  threads;
 	struct list_head  dead_threads;
 	struct thread	  *last_match;
+	struct vdso_info  *vdso_info;
 	struct list_head  user_dsos;
 	struct list_head  kernel_dsos;
 	struct map_groups kmaps;
 	struct map	  *vmlinux_maps[MAP__NR_TYPES];
 	symbol_filter_t	  symbol_filter;
+	pid_t		  *current_tid;
 };
 
 static inline
@@ -191,4 +195,8 @@ int machine__synthesize_threads(struct machine *machine, struct target *target,
 					     perf_event__process, data_mmap);
 }
 
+pid_t machine__get_current_tid(struct machine *machine, int cpu);
+int machine__set_current_tid(struct machine *machine, int cpu, pid_t pid,
+			     pid_t tid);
+
 #endif /* __PERF_MACHINE_H */
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 25c571f..31b8905 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -12,6 +12,8 @@
 #include "vdso.h"
 #include "build-id.h"
 #include "util.h"
+#include "debug.h"
+#include "machine.h"
 #include <linux/string.h>
 
 const char *map_type__name[MAP__NR_TYPES] = {
@@ -136,10 +138,10 @@ void map__init(struct map *map, enum map_type type,
 	map->erange_warned = false;
 }
 
-struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
+struct map *map__new(struct machine *machine, u64 start, u64 len,
 		     u64 pgoff, u32 pid, u32 d_maj, u32 d_min, u64 ino,
 		     u64 ino_gen, u32 prot, u32 flags, char *filename,
-		     enum map_type type)
+		     enum map_type type, struct thread *thread)
 {
 	struct map *map = malloc(sizeof(*map));
 
@@ -172,9 +174,9 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 
 		if (vdso) {
 			pgoff = 0;
-			dso = vdso__dso_findnew(dsos__list);
+			dso = vdso__dso_findnew(machine, thread);
 		} else
-			dso = __dsos__findnew(dsos__list, filename);
+			dso = __dsos__findnew(&machine->user_dsos, filename);
 
 		if (dso == NULL)
 			goto out_delete;
@@ -454,6 +456,20 @@ void map_groups__exit(struct map_groups *mg)
 	}
 }
 
+bool map_groups__empty(struct map_groups *mg)
+{
+	int i;
+
+	for (i = 0; i < MAP__NR_TYPES; ++i) {
+		if (maps__first(&mg->maps[i]))
+			return false;
+		if (!list_empty(&mg->removed_maps[i]))
+			return false;
+	}
+
+	return true;
+}
+
 struct map_groups *map_groups__new(void)
 {
 	struct map_groups *mg = malloc(sizeof(*mg));
@@ -554,8 +570,8 @@ int map_groups__find_ams(struct addr_map_symbol *ams, symbol_filter_t filter)
 	return ams->sym ? 0 : -1;
 }
 
-size_t __map_groups__fprintf_maps(struct map_groups *mg,
-				  enum map_type type, int verbose, FILE *fp)
+size_t __map_groups__fprintf_maps(struct map_groups *mg, enum map_type type,
+				  FILE *fp)
 {
 	size_t printed = fprintf(fp, "%s:\n", map_type__name[type]);
 	struct rb_node *nd;
@@ -573,17 +589,16 @@ size_t __map_groups__fprintf_maps(struct map_groups *mg,
 	return printed;
 }
 
-size_t map_groups__fprintf_maps(struct map_groups *mg, int verbose, FILE *fp)
+static size_t map_groups__fprintf_maps(struct map_groups *mg, FILE *fp)
 {
 	size_t printed = 0, i;
 	for (i = 0; i < MAP__NR_TYPES; ++i)
-		printed += __map_groups__fprintf_maps(mg, i, verbose, fp);
+		printed += __map_groups__fprintf_maps(mg, i, fp);
 	return printed;
 }
 
 static size_t __map_groups__fprintf_removed_maps(struct map_groups *mg,
-						 enum map_type type,
-						 int verbose, FILE *fp)
+						 enum map_type type, FILE *fp)
 {
 	struct map *pos;
 	size_t printed = 0;
@@ -600,23 +615,23 @@ static size_t __map_groups__fprintf_removed_maps(struct map_groups *mg,
 }
 
 static size_t map_groups__fprintf_removed_maps(struct map_groups *mg,
-					       int verbose, FILE *fp)
+					       FILE *fp)
 {
 	size_t printed = 0, i;
 	for (i = 0; i < MAP__NR_TYPES; ++i)
-		printed += __map_groups__fprintf_removed_maps(mg, i, verbose, fp);
+		printed += __map_groups__fprintf_removed_maps(mg, i, fp);
 	return printed;
 }
 
-size_t map_groups__fprintf(struct map_groups *mg, int verbose, FILE *fp)
+size_t map_groups__fprintf(struct map_groups *mg, FILE *fp)
 {
-	size_t printed = map_groups__fprintf_maps(mg, verbose, fp);
+	size_t printed = map_groups__fprintf_maps(mg, fp);
 	printed += fprintf(fp, "Removed maps:\n");
-	return printed + map_groups__fprintf_removed_maps(mg, verbose, fp);
+	return printed + map_groups__fprintf_removed_maps(mg, fp);
 }
 
 int map_groups__fixup_overlappings(struct map_groups *mg, struct map *map,
-				   int verbose, FILE *fp)
+				   FILE *fp)
 {
 	struct rb_root *root = &mg->maps[map->type];
 	struct rb_node *next = rb_first(root);
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 7758c72..2f83954 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -66,6 +66,7 @@ struct map_groups {
 
 struct map_groups *map_groups__new(void);
 void map_groups__delete(struct map_groups *mg);
+bool map_groups__empty(struct map_groups *mg);
 
 static inline struct map_groups *map_groups__get(struct map_groups *mg)
 {
@@ -103,6 +104,7 @@ u64 map__rip_2objdump(struct map *map, u64 rip);
 u64 map__objdump_2mem(struct map *map, u64 ip);
 
 struct symbol;
+struct thread;
 
 /* map__for_each_symbol - iterate over the symbols in the given map
  *
@@ -118,10 +120,10 @@ typedef int (*symbol_filter_t)(struct map *map, struct symbol *sym);
 
 void map__init(struct map *map, enum map_type type,
 	       u64 start, u64 end, u64 pgoff, struct dso *dso);
-struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
+struct map *map__new(struct machine *machine, u64 start, u64 len,
 		     u64 pgoff, u32 pid, u32 d_maj, u32 d_min, u64 ino,
 		     u64 ino_gen, u32 prot, u32 flags,
-		     char *filename, enum map_type type);
+		     char *filename, enum map_type type, struct thread *thread);
 struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
 void map__delete(struct map *map);
 struct map *map__clone(struct map *map);
@@ -141,8 +143,8 @@ void map__fixup_end(struct map *map);
 
 void map__reloc_vmlinux(struct map *map);
 
-size_t __map_groups__fprintf_maps(struct map_groups *mg,
-				  enum map_type type, int verbose, FILE *fp);
+size_t __map_groups__fprintf_maps(struct map_groups *mg, enum map_type type,
+				  FILE *fp);
 void maps__insert(struct rb_root *maps, struct map *map);
 void maps__remove(struct rb_root *maps, struct map *map);
 struct map *maps__find(struct rb_root *maps, u64 addr);
@@ -152,8 +154,7 @@ void map_groups__init(struct map_groups *mg);
 void map_groups__exit(struct map_groups *mg);
 int map_groups__clone(struct map_groups *mg,
 		      struct map_groups *parent, enum map_type type);
-size_t map_groups__fprintf(struct map_groups *mg, int verbose, FILE *fp);
-size_t map_groups__fprintf_maps(struct map_groups *mg, int verbose, FILE *fp);
+size_t map_groups__fprintf(struct map_groups *mg, FILE *fp);
 
 int maps__set_kallsyms_ref_reloc_sym(struct map **maps, const char *symbol_name,
 				     u64 addr);
@@ -210,7 +211,7 @@ struct symbol *map_groups__find_function_by_name(struct map_groups *mg,
 }
 
 int map_groups__fixup_overlappings(struct map_groups *mg, struct map *map,
-				   int verbose, FILE *fp);
+				   FILE *fp);
 
 struct map *map_groups__find_by_name(struct map_groups *mg,
 				     enum map_type type, const char *name);
diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index d8dac8a..b59ba85 100644
--- a/tools/perf/util/parse-options.h
+++ b/tools/perf/util/parse-options.h
@@ -98,6 +98,7 @@ struct option {
 	parse_opt_cb *callback;
 	intptr_t defval;
 	bool *set;
+	void *data;
 };
 
 #define check_vtype(v, type) ( BUILD_BUG_ON_ZERO(!__builtin_types_compatible_p(typeof(v), type)) + v )
@@ -131,6 +132,10 @@ struct option {
 	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l),\
 	.value = (v), (a), .help = (h), .callback = (f), .defval = (intptr_t)d,\
 	.flags = PARSE_OPT_LASTARG_DEFAULT | PARSE_OPT_NOARG}
+#define OPT_CALLBACK_OPTARG(s, l, v, d, a, h, f) \
+	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), \
+	  .value = (v), (a), .help = (h), .callback = (f), \
+	  .flags = PARSE_OPT_OPTARG, .data = (d) }
 
 /* parse_options() will filter out the processed options and leave the
  * non-option argments in argv[].
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 98e3047..dca9145 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -26,7 +26,6 @@
 #include <errno.h>
 #include <stdio.h>
 #include <unistd.h>
-#include <getopt.h>
 #include <stdlib.h>
 #include <string.h>
 #include <stdarg.h>
diff --git a/tools/perf/util/pstack.c b/tools/perf/util/pstack.c
index daa17ae..a126e6c 100644
--- a/tools/perf/util/pstack.c
+++ b/tools/perf/util/pstack.c
@@ -6,6 +6,7 @@
 
 #include "util.h"
 #include "pstack.h"
+#include "debug.h"
 #include <linux/kernel.h>
 #include <stdlib.h>
 
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 122669c..12aa9b0 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -14,12 +14,12 @@
  */
 int verbose;
 
-int eprintf(int level, const char *fmt, ...)
+int eprintf(int level, int var, const char *fmt, ...)
 {
 	va_list args;
 	int ret = 0;
 
-	if (verbose >= level) {
+	if (var >= level) {
 		va_start(args, fmt);
 		ret = vfprintf(stderr, fmt, args);
 		va_end(args);
diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index 049e0a0..fe8079e 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -4,6 +4,7 @@
 #include "parse-events.h"
 #include <api/fs/fs.h>
 #include "util.h"
+#include "cloexec.h"
 
 typedef void (*setup_probe_fn_t)(struct perf_evsel *evsel);
 
@@ -11,6 +12,7 @@ static int perf_do_probe_api(setup_probe_fn_t fn, int cpu, const char *str)
 {
 	struct perf_evlist *evlist;
 	struct perf_evsel *evsel;
+	unsigned long flags = perf_event_open_cloexec_flag();
 	int err = -EAGAIN, fd;
 
 	evlist = perf_evlist__new();
@@ -22,14 +24,14 @@ static int perf_do_probe_api(setup_probe_fn_t fn, int cpu, const char *str)
 
 	evsel = perf_evlist__first(evlist);
 
-	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, 0);
+	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, flags);
 	if (fd < 0)
 		goto out_delete;
 	close(fd);
 
 	fn(evsel);
 
-	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, 0);
+	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, flags);
 	if (fd < 0) {
 		if (errno == EINVAL)
 			err = -EINVAL;
@@ -69,15 +71,26 @@ static void perf_probe_sample_identifier(struct perf_evsel *evsel)
 	evsel->attr.sample_type |= PERF_SAMPLE_IDENTIFIER;
 }
 
+static void perf_probe_comm_exec(struct perf_evsel *evsel)
+{
+	evsel->attr.comm_exec = 1;
+}
+
 bool perf_can_sample_identifier(void)
 {
 	return perf_probe_api(perf_probe_sample_identifier);
 }
 
+static bool perf_can_comm_exec(void)
+{
+	return perf_probe_api(perf_probe_comm_exec);
+}
+
 void perf_evlist__config(struct perf_evlist *evlist, struct record_opts *opts)
 {
 	struct perf_evsel *evsel;
 	bool use_sample_identifier = false;
+	bool use_comm_exec;
 
 	/*
 	 * Set the evsel leader links before we configure attributes,
@@ -89,8 +102,13 @@ void perf_evlist__config(struct perf_evlist *evlist, struct record_opts *opts)
 	if (evlist->cpus->map[0] < 0)
 		opts->no_inherit = true;
 
-	evlist__for_each(evlist, evsel)
+	use_comm_exec = perf_can_comm_exec();
+
+	evlist__for_each(evlist, evsel) {
 		perf_evsel__config(evsel, opts);
+		if (!evsel->idx && use_comm_exec)
+			evsel->attr.comm_exec = 1;
+	}
 
 	if (evlist->nr_entries > 1) {
 		struct perf_evsel *first = perf_evlist__first(evlist);
@@ -203,7 +221,8 @@ bool perf_evlist__can_select_event(struct perf_evlist *evlist, const char *str)
 		cpu = evlist->cpus->map[0];
 	}
 
-	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, 0);
+	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1,
+				 perf_event_open_cloexec_flag());
 	if (fd >= 0) {
 		close(fd);
 		ret = true;
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index af7da56..b2dba9c 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -34,6 +34,7 @@
 #include "../event.h"
 #include "../trace-event.h"
 #include "../evsel.h"
+#include "../debug.h"
 
 void boot_Perf__Trace__Context(pTHX_ CV *cv);
 void boot_DynaLoader(pTHX_ CV *cv);
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 1c41932..cbce254 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -27,11 +27,13 @@
 #include <errno.h>
 
 #include "../../perf.h"
+#include "../debug.h"
 #include "../evsel.h"
 #include "../util.h"
 #include "../event.h"
 #include "../thread.h"
 #include "../trace-event.h"
+#include "../machine.h"
 
 PyMODINIT_FUNC initperf_trace_context(void);
 
@@ -50,10 +52,14 @@ static int zero_flag_atom;
 
 static PyObject *main_module, *main_dict;
 
+static void handler_call_die(const char *handler_name) NORETURN;
 static void handler_call_die(const char *handler_name)
 {
 	PyErr_Print();
 	Py_FatalError("problem in Python trace event handler");
+	// Py_FatalError does not return
+	// but we have to make the compiler happy
+	abort();
 }
 
 /*
@@ -97,6 +103,7 @@ static void define_value(enum print_arg_type field_type,
 		retval = PyObject_CallObject(handler, t);
 		if (retval == NULL)
 			handler_call_die(handler_name);
+		Py_DECREF(retval);
 	}
 
 	Py_DECREF(t);
@@ -143,6 +150,7 @@ static void define_field(enum print_arg_type field_type,
 		retval = PyObject_CallObject(handler, t);
 		if (retval == NULL)
 			handler_call_die(handler_name);
+		Py_DECREF(retval);
 	}
 
 	Py_DECREF(t);
@@ -231,15 +239,133 @@ static inline struct event_format *find_cache_event(struct perf_evsel *evsel)
 	return event;
 }
 
+static PyObject *get_field_numeric_entry(struct event_format *event,
+		struct format_field *field, void *data)
+{
+	bool is_array = field->flags & FIELD_IS_ARRAY;
+	PyObject *obj, *list = NULL;
+	unsigned long long val;
+	unsigned int item_size, n_items, i;
+
+	if (is_array) {
+		list = PyList_New(field->arraylen);
+		item_size = field->size / field->arraylen;
+		n_items = field->arraylen;
+	} else {
+		item_size = field->size;
+		n_items = 1;
+	}
+
+	for (i = 0; i < n_items; i++) {
+
+		val = read_size(event, data + field->offset + i * item_size,
+				item_size);
+		if (field->flags & FIELD_IS_SIGNED) {
+			if ((long long)val >= LONG_MIN &&
+					(long long)val <= LONG_MAX)
+				obj = PyInt_FromLong(val);
+			else
+				obj = PyLong_FromLongLong(val);
+		} else {
+			if (val <= LONG_MAX)
+				obj = PyInt_FromLong(val);
+			else
+				obj = PyLong_FromUnsignedLongLong(val);
+		}
+		if (is_array)
+			PyList_SET_ITEM(list, i, obj);
+	}
+	if (is_array)
+		obj = list;
+	return obj;
+}
+
+
+static PyObject *python_process_callchain(struct perf_sample *sample,
+					 struct perf_evsel *evsel,
+					 struct addr_location *al)
+{
+	PyObject *pylist;
+
+	pylist = PyList_New(0);
+	if (!pylist)
+		Py_FatalError("couldn't create Python list");
+
+	if (!symbol_conf.use_callchain || !sample->callchain)
+		goto exit;
+
+	if (machine__resolve_callchain(al->machine, evsel, al->thread,
+					   sample, NULL, NULL,
+					   PERF_MAX_STACK_DEPTH) != 0) {
+		pr_err("Failed to resolve callchain. Skipping\n");
+		goto exit;
+	}
+	callchain_cursor_commit(&callchain_cursor);
+
+
+	while (1) {
+		PyObject *pyelem;
+		struct callchain_cursor_node *node;
+		node = callchain_cursor_current(&callchain_cursor);
+		if (!node)
+			break;
+
+		pyelem = PyDict_New();
+		if (!pyelem)
+			Py_FatalError("couldn't create Python dictionary");
+
+
+		pydict_set_item_string_decref(pyelem, "ip",
+				PyLong_FromUnsignedLongLong(node->ip));
+
+		if (node->sym) {
+			PyObject *pysym  = PyDict_New();
+			if (!pysym)
+				Py_FatalError("couldn't create Python dictionary");
+			pydict_set_item_string_decref(pysym, "start",
+					PyLong_FromUnsignedLongLong(node->sym->start));
+			pydict_set_item_string_decref(pysym, "end",
+					PyLong_FromUnsignedLongLong(node->sym->end));
+			pydict_set_item_string_decref(pysym, "binding",
+					PyInt_FromLong(node->sym->binding));
+			pydict_set_item_string_decref(pysym, "name",
+					PyString_FromStringAndSize(node->sym->name,
+							node->sym->namelen));
+			pydict_set_item_string_decref(pyelem, "sym", pysym);
+		}
+
+		if (node->map) {
+			struct map *map = node->map;
+			const char *dsoname = "[unknown]";
+			if (map && map->dso && (map->dso->name || map->dso->long_name)) {
+				if (symbol_conf.show_kernel_path && map->dso->long_name)
+					dsoname = map->dso->long_name;
+				else if (map->dso->name)
+					dsoname = map->dso->name;
+			}
+			pydict_set_item_string_decref(pyelem, "dso",
+					PyString_FromString(dsoname));
+		}
+
+		callchain_cursor_advance(&callchain_cursor);
+		PyList_Append(pylist, pyelem);
+		Py_DECREF(pyelem);
+	}
+
+exit:
+	return pylist;
+}
+
+
 static void python_process_tracepoint(struct perf_sample *sample,
 				      struct perf_evsel *evsel,
 				      struct thread *thread,
 				      struct addr_location *al)
 {
-	PyObject *handler, *retval, *context, *t, *obj, *dict = NULL;
+	PyObject *handler, *retval, *context, *t, *obj, *callchain;
+	PyObject *dict = NULL;
 	static char handler_name[256];
 	struct format_field *field;
-	unsigned long long val;
 	unsigned long s, ns;
 	struct event_format *event;
 	unsigned n = 0;
@@ -280,18 +406,23 @@ static void python_process_tracepoint(struct perf_sample *sample,
 	PyTuple_SetItem(t, n++, PyString_FromString(handler_name));
 	PyTuple_SetItem(t, n++, context);
 
+	/* ip unwinding */
+	callchain = python_process_callchain(sample, evsel, al);
+
 	if (handler) {
 		PyTuple_SetItem(t, n++, PyInt_FromLong(cpu));
 		PyTuple_SetItem(t, n++, PyInt_FromLong(s));
 		PyTuple_SetItem(t, n++, PyInt_FromLong(ns));
 		PyTuple_SetItem(t, n++, PyInt_FromLong(pid));
 		PyTuple_SetItem(t, n++, PyString_FromString(comm));
+		PyTuple_SetItem(t, n++, callchain);
 	} else {
 		pydict_set_item_string_decref(dict, "common_cpu", PyInt_FromLong(cpu));
 		pydict_set_item_string_decref(dict, "common_s", PyInt_FromLong(s));
 		pydict_set_item_string_decref(dict, "common_ns", PyInt_FromLong(ns));
 		pydict_set_item_string_decref(dict, "common_pid", PyInt_FromLong(pid));
 		pydict_set_item_string_decref(dict, "common_comm", PyString_FromString(comm));
+		pydict_set_item_string_decref(dict, "common_callchain", callchain);
 	}
 	for (field = event->format.fields; field; field = field->next) {
 		if (field->flags & FIELD_IS_STRING) {
@@ -303,20 +434,7 @@ static void python_process_tracepoint(struct perf_sample *sample,
 				offset = field->offset;
 			obj = PyString_FromString((char *)data + offset);
 		} else { /* FIELD_IS_NUMERIC */
-			val = read_size(event, data + field->offset,
-					field->size);
-			if (field->flags & FIELD_IS_SIGNED) {
-				if ((long long)val >= LONG_MIN &&
-				    (long long)val <= LONG_MAX)
-					obj = PyInt_FromLong(val);
-				else
-					obj = PyLong_FromLongLong(val);
-			} else {
-				if (val <= LONG_MAX)
-					obj = PyInt_FromLong(val);
-				else
-					obj = PyLong_FromUnsignedLongLong(val);
-			}
+			obj = get_field_numeric_entry(event, field, data);
 		}
 		if (handler)
 			PyTuple_SetItem(t, n++, obj);
@@ -324,6 +442,7 @@ static void python_process_tracepoint(struct perf_sample *sample,
 			pydict_set_item_string_decref(dict, field->name, obj);
 
 	}
+
 	if (!handler)
 		PyTuple_SetItem(t, n++, dict);
 
@@ -334,6 +453,7 @@ static void python_process_tracepoint(struct perf_sample *sample,
 		retval = PyObject_CallObject(handler, t);
 		if (retval == NULL)
 			handler_call_die(handler_name);
+		Py_DECREF(retval);
 	} else {
 		handler = PyDict_GetItemString(main_dict, "trace_unhandled");
 		if (handler && PyCallable_Check(handler)) {
@@ -341,6 +461,7 @@ static void python_process_tracepoint(struct perf_sample *sample,
 			retval = PyObject_CallObject(handler, t);
 			if (retval == NULL)
 				handler_call_die("trace_unhandled");
+			Py_DECREF(retval);
 		}
 		Py_DECREF(dict);
 	}
@@ -353,7 +474,7 @@ static void python_process_general_event(struct perf_sample *sample,
 					 struct thread *thread,
 					 struct addr_location *al)
 {
-	PyObject *handler, *retval, *t, *dict;
+	PyObject *handler, *retval, *t, *dict, *callchain, *dict_sample;
 	static char handler_name[64];
 	unsigned n = 0;
 
@@ -369,6 +490,10 @@ static void python_process_general_event(struct perf_sample *sample,
 	if (!dict)
 		Py_FatalError("couldn't create Python dictionary");
 
+	dict_sample = PyDict_New();
+	if (!dict_sample)
+		Py_FatalError("couldn't create Python dictionary");
+
 	snprintf(handler_name, sizeof(handler_name), "%s", "process_event");
 
 	handler = PyDict_GetItemString(main_dict, handler_name);
@@ -378,8 +503,21 @@ static void python_process_general_event(struct perf_sample *sample,
 	pydict_set_item_string_decref(dict, "ev_name", PyString_FromString(perf_evsel__name(evsel)));
 	pydict_set_item_string_decref(dict, "attr", PyString_FromStringAndSize(
 			(const char *)&evsel->attr, sizeof(evsel->attr)));
-	pydict_set_item_string_decref(dict, "sample", PyString_FromStringAndSize(
-			(const char *)sample, sizeof(*sample)));
+
+	pydict_set_item_string_decref(dict_sample, "pid",
+			PyInt_FromLong(sample->pid));
+	pydict_set_item_string_decref(dict_sample, "tid",
+			PyInt_FromLong(sample->tid));
+	pydict_set_item_string_decref(dict_sample, "cpu",
+			PyInt_FromLong(sample->cpu));
+	pydict_set_item_string_decref(dict_sample, "ip",
+			PyLong_FromUnsignedLongLong(sample->ip));
+	pydict_set_item_string_decref(dict_sample, "time",
+			PyLong_FromUnsignedLongLong(sample->time));
+	pydict_set_item_string_decref(dict_sample, "period",
+			PyLong_FromUnsignedLongLong(sample->period));
+	pydict_set_item_string_decref(dict, "sample", dict_sample);
+
 	pydict_set_item_string_decref(dict, "raw_buf", PyString_FromStringAndSize(
 			(const char *)sample->raw_data, sample->raw_size));
 	pydict_set_item_string_decref(dict, "comm",
@@ -393,6 +531,10 @@ static void python_process_general_event(struct perf_sample *sample,
 			PyString_FromString(al->sym->name));
 	}
 
+	/* ip unwinding */
+	callchain = python_process_callchain(sample, evsel, al);
+	pydict_set_item_string_decref(dict, "callchain", callchain);
+
 	PyTuple_SetItem(t, n++, dict);
 	if (_PyTuple_Resize(&t, n) == -1)
 		Py_FatalError("error resizing Python tuple");
@@ -400,6 +542,7 @@ static void python_process_general_event(struct perf_sample *sample,
 	retval = PyObject_CallObject(handler, t);
 	if (retval == NULL)
 		handler_call_die(handler_name);
+	Py_DECREF(retval);
 exit:
 	Py_DECREF(dict);
 	Py_DECREF(t);
@@ -521,8 +664,7 @@ static int python_stop_script(void)
 	retval = PyObject_CallObject(handler, NULL);
 	if (retval == NULL)
 		handler_call_die("trace_end");
-	else
-		Py_DECREF(retval);
+	Py_DECREF(retval);
 out:
 	Py_XDECREF(main_dict);
 	Py_XDECREF(main_module);
@@ -589,6 +731,7 @@ static int python_generate_script(struct pevent *pevent, const char *outfile)
 		fprintf(ofp, "common_nsecs, ");
 		fprintf(ofp, "common_pid, ");
 		fprintf(ofp, "common_comm,\n\t");
+		fprintf(ofp, "common_callchain, ");
 
 		not_first = 0;
 		count = 0;
@@ -632,7 +775,7 @@ static int python_generate_script(struct pevent *pevent, const char *outfile)
 				fprintf(ofp, "%%u");
 		}
 
-		fprintf(ofp, "\\n\" %% \\\n\t\t(");
+		fprintf(ofp, "\" %% \\\n\t\t(");
 
 		not_first = 0;
 		count = 0;
@@ -668,7 +811,15 @@ static int python_generate_script(struct pevent *pevent, const char *outfile)
 				fprintf(ofp, "%s", f->name);
 		}
 
-		fprintf(ofp, "),\n\n");
+		fprintf(ofp, ")\n\n");
+
+		fprintf(ofp, "\t\tfor node in common_callchain:");
+		fprintf(ofp, "\n\t\t\tif 'sym' in node:");
+		fprintf(ofp, "\n\t\t\t\tprint \"\\t[%%x] %%s\" %% (node['ip'], node['sym']['name'])");
+		fprintf(ofp, "\n\t\t\telse:");
+		fprintf(ofp, "\n\t\t\t\tprint \"\t[%%x]\" %% (node['ip'])\n\n");
+		fprintf(ofp, "\t\tprint \"\\n\"\n\n");
+
 	}
 
 	fprintf(ofp, "def trace_unhandled(event_name, context, "
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 64a186e..88dfef7 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -14,7 +14,6 @@
 #include "util.h"
 #include "cpumap.h"
 #include "perf_regs.h"
-#include "vdso.h"
 
 static int perf_session__open(struct perf_session *session)
 {
@@ -156,7 +155,6 @@ void perf_session__delete(struct perf_session *session)
 	if (session->file)
 		perf_data_file__close(session->file);
 	free(session);
-	vdso__exit();
 }
 
 static int process_event_synth_tracing_data_stub(struct perf_tool *tool
@@ -511,6 +509,7 @@ static int flush_sample_queue(struct perf_session *s,
 		os->last_flush = iter->timestamp;
 		list_del(&iter->list);
 		list_add(&iter->list, &os->sample_cache);
+		os->nr_samples--;
 
 		if (show_progress)
 			ui_progress__update(&prog, 1);
@@ -523,8 +522,6 @@ static int flush_sample_queue(struct perf_session *s,
 			list_entry(head->prev, struct sample_queue, list);
 	}
 
-	os->nr_samples = 0;
-
 	return 0;
 }
 
@@ -994,8 +991,10 @@ static int perf_session_deliver_event(struct perf_session *session,
 	}
 }
 
-static int perf_session__process_user_event(struct perf_session *session, union perf_event *event,
-					    struct perf_tool *tool, u64 file_offset)
+static s64 perf_session__process_user_event(struct perf_session *session,
+					    union perf_event *event,
+					    struct perf_tool *tool,
+					    u64 file_offset)
 {
 	int fd = perf_data_file__fd(session->file);
 	int err;
@@ -1037,7 +1036,7 @@ static void event_swap(union perf_event *event, bool sample_id_all)
 		swap(event, sample_id_all);
 }
 
-static int perf_session__process_event(struct perf_session *session,
+static s64 perf_session__process_event(struct perf_session *session,
 				       union perf_event *event,
 				       struct perf_tool *tool,
 				       u64 file_offset)
@@ -1083,13 +1082,14 @@ void perf_event_header__bswap(struct perf_event_header *hdr)
 
 struct thread *perf_session__findnew(struct perf_session *session, pid_t pid)
 {
-	return machine__findnew_thread(&session->machines.host, 0, pid);
+	return machine__findnew_thread(&session->machines.host, -1, pid);
 }
 
 static struct thread *perf_session__register_idle_thread(struct perf_session *session)
 {
-	struct thread *thread = perf_session__findnew(session, 0);
+	struct thread *thread;
 
+	thread = machine__findnew_thread(&session->machines.host, 0, 0);
 	if (thread == NULL || thread__set_comm(thread, "swapper", 0)) {
 		pr_err("problem inserting idle task.\n");
 		thread = NULL;
@@ -1147,7 +1147,7 @@ static int __perf_session__process_pipe_events(struct perf_session *session,
 	union perf_event *event;
 	uint32_t size, cur_size = 0;
 	void *buf = NULL;
-	int skip = 0;
+	s64 skip = 0;
 	u64 head;
 	ssize_t err;
 	void *p;
@@ -1276,13 +1276,13 @@ int __perf_session__process_events(struct perf_session *session,
 				   u64 file_size, struct perf_tool *tool)
 {
 	int fd = perf_data_file__fd(session->file);
-	u64 head, page_offset, file_offset, file_pos;
+	u64 head, page_offset, file_offset, file_pos, size;
 	int err, mmap_prot, mmap_flags, map_idx = 0;
 	size_t	mmap_size;
 	char *buf, *mmaps[NUM_MMAPS];
 	union perf_event *event;
-	uint32_t size;
 	struct ui_progress prog;
+	s64 skip;
 
 	perf_tool__fill_defaults(tool);
 
@@ -1296,8 +1296,10 @@ int __perf_session__process_events(struct perf_session *session,
 	ui_progress__init(&prog, file_size, "Processing events...");
 
 	mmap_size = MMAP_SIZE;
-	if (mmap_size > file_size)
+	if (mmap_size > file_size) {
 		mmap_size = file_size;
+		session->one_mmap = true;
+	}
 
 	memset(mmaps, 0, sizeof(mmaps));
 
@@ -1319,6 +1321,10 @@ remap:
 	mmaps[map_idx] = buf;
 	map_idx = (map_idx + 1) & (ARRAY_SIZE(mmaps) - 1);
 	file_pos = file_offset + head;
+	if (session->one_mmap) {
+		session->one_mmap_addr = buf;
+		session->one_mmap_offset = file_offset;
+	}
 
 more:
 	event = fetch_mmaped_event(session, head, mmap_size, buf);
@@ -1337,7 +1343,8 @@ more:
 	size = event->header.size;
 
 	if (size < sizeof(struct perf_event_header) ||
-	    perf_session__process_event(session, event, tool, file_pos) < 0) {
+	    (skip = perf_session__process_event(session, event, tool, file_pos))
+									< 0) {
 		pr_err("%#" PRIx64 " [%#x]: failed to process type: %d\n",
 		       file_offset + head, event->header.size,
 		       event->header.type);
@@ -1345,6 +1352,9 @@ more:
 		goto out_err;
 	}
 
+	if (skip)
+		size += skip;
+
 	head += size;
 	file_pos += size;
 
@@ -1364,6 +1374,7 @@ out_err:
 	ui_progress__finish();
 	perf_session__warn_about_errors(session, tool);
 	perf_session_free_sample_buffers(session);
+	session->one_mmap = false;
 	return err;
 }
 
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 3140f8a..0321013 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -36,6 +36,9 @@ struct perf_session {
 	struct trace_event	tevent;
 	struct events_stats	stats;
 	bool			repipe;
+	bool			one_mmap;
+	void			*one_mmap_addr;
+	u64			one_mmap_offset;
 	struct ordered_samples	ordered_samples;
 	struct perf_data_file	*file;
 };
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 1ec57dd..14e5a03 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1215,7 +1215,7 @@ static int __sort__hpp_header(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
 	hse = container_of(fmt, struct hpp_sort_entry, hpp);
 	len = hists__col_len(&evsel->hists, hse->se->se_width_idx);
 
-	return scnprintf(hpp->buf, hpp->size, "%*s", len, hse->se->se_header);
+	return scnprintf(hpp->buf, hpp->size, "%-*s", len, hse->se->se_header);
 }
 
 static int __sort__hpp_width(struct perf_hpp_fmt *fmt,
diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index 6a0a13d..283d3e7 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -30,6 +30,7 @@ static u64 turbo_frequency, max_freq;
 
 #define SLOT_MULT 30.0
 #define SLOT_HEIGHT 25.0
+#define SLOT_HALF (SLOT_HEIGHT / 2)
 
 int svg_page_width = 1000;
 u64 svg_highlight;
@@ -114,8 +115,14 @@ void open_svg(const char *filename, int cpus, int rows, u64 start, u64 end)
 	fprintf(svgfile, "      rect          { stroke-width: 1; }\n");
 	fprintf(svgfile, "      rect.process  { fill:rgb(180,180,180); fill-opacity:0.9; stroke-width:1;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.process2 { fill:rgb(180,180,180); fill-opacity:0.9; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.process3 { fill:rgb(180,180,180); fill-opacity:0.5; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.sample   { fill:rgb(  0,  0,255); fill-opacity:0.8; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.sample_hi{ fill:rgb(255,128,  0); fill-opacity:0.8; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.error    { fill:rgb(255,  0,  0); fill-opacity:0.5; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.net      { fill:rgb(  0,128,  0); fill-opacity:0.5; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.disk     { fill:rgb(  0,  0,255); fill-opacity:0.5; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.sync     { fill:rgb(128,128,  0); fill-opacity:0.5; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.poll     { fill:rgb(  0,128,128); fill-opacity:0.2; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.blocked  { fill:rgb(255,  0,  0); fill-opacity:0.5; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.waiting  { fill:rgb(224,214,  0); fill-opacity:0.8; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.WAITING  { fill:rgb(255,214, 48); fill-opacity:0.6; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
@@ -132,12 +139,81 @@ void open_svg(const char *filename, int cpus, int rows, u64 start, u64 end)
 	fprintf(svgfile, "    ]]>\n   </style>\n</defs>\n");
 }
 
+static double normalize_height(double height)
+{
+	if (height < 0.25)
+		return 0.25;
+	else if (height < 0.50)
+		return 0.50;
+	else if (height < 0.75)
+		return 0.75;
+	else
+		return 0.100;
+}
+
+void svg_ubox(int Yslot, u64 start, u64 end, double height, const char *type, int fd, int err, int merges)
+{
+	double w = time2pixels(end) - time2pixels(start);
+	height = normalize_height(height);
+
+	if (!svgfile)
+		return;
+
+	fprintf(svgfile, "<g>\n");
+	fprintf(svgfile, "<title>fd=%d error=%d merges=%d</title>\n", fd, err, merges);
+	fprintf(svgfile, "<rect x=\"%.8f\" width=\"%.8f\" y=\"%.1f\" height=\"%.1f\" class=\"%s\"/>\n",
+		time2pixels(start),
+		w,
+		Yslot * SLOT_MULT,
+		SLOT_HALF * height,
+		type);
+	fprintf(svgfile, "</g>\n");
+}
+
+void svg_lbox(int Yslot, u64 start, u64 end, double height, const char *type, int fd, int err, int merges)
+{
+	double w = time2pixels(end) - time2pixels(start);
+	height = normalize_height(height);
+
+	if (!svgfile)
+		return;
+
+	fprintf(svgfile, "<g>\n");
+	fprintf(svgfile, "<title>fd=%d error=%d merges=%d</title>\n", fd, err, merges);
+	fprintf(svgfile, "<rect x=\"%.8f\" width=\"%.8f\" y=\"%.1f\" height=\"%.1f\" class=\"%s\"/>\n",
+		time2pixels(start),
+		w,
+		Yslot * SLOT_MULT + SLOT_HEIGHT - SLOT_HALF * height,
+		SLOT_HALF * height,
+		type);
+	fprintf(svgfile, "</g>\n");
+}
+
+void svg_fbox(int Yslot, u64 start, u64 end, double height, const char *type, int fd, int err, int merges)
+{
+	double w = time2pixels(end) - time2pixels(start);
+	height = normalize_height(height);
+
+	if (!svgfile)
+		return;
+
+	fprintf(svgfile, "<g>\n");
+	fprintf(svgfile, "<title>fd=%d error=%d merges=%d</title>\n", fd, err, merges);
+	fprintf(svgfile, "<rect x=\"%.8f\" width=\"%.8f\" y=\"%.1f\" height=\"%.1f\" class=\"%s\"/>\n",
+		time2pixels(start),
+		w,
+		Yslot * SLOT_MULT + SLOT_HEIGHT - SLOT_HEIGHT * height,
+		SLOT_HEIGHT * height,
+		type);
+	fprintf(svgfile, "</g>\n");
+}
+
 void svg_box(int Yslot, u64 start, u64 end, const char *type)
 {
 	if (!svgfile)
 		return;
 
-	fprintf(svgfile, "<rect x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\" class=\"%s\"/>\n",
+	fprintf(svgfile, "<rect x=\"%.8f\" width=\"%.8f\" y=\"%.1f\" height=\"%.1f\" class=\"%s\"/>\n",
 		time2pixels(start), time2pixels(end)-time2pixels(start), Yslot * SLOT_MULT, SLOT_HEIGHT, type);
 }
 
@@ -174,7 +250,7 @@ void svg_running(int Yslot, int cpu, u64 start, u64 end, const char *backtrace)
 		cpu, time_to_string(end - start));
 	if (backtrace)
 		fprintf(svgfile, "<desc>Switched because:\n%s</desc>\n", backtrace);
-	fprintf(svgfile, "<rect x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\" class=\"%s\"/>\n",
+	fprintf(svgfile, "<rect x=\"%.8f\" width=\"%.8f\" y=\"%.1f\" height=\"%.1f\" class=\"%s\"/>\n",
 		time2pixels(start), time2pixels(end)-time2pixels(start), Yslot * SLOT_MULT, SLOT_HEIGHT,
 		type);
 
@@ -186,7 +262,7 @@ void svg_running(int Yslot, int cpu, u64 start, u64 end, const char *backtrace)
 	text_size = round_text_size(text_size);
 
 	if (text_size > MIN_TEXT_SIZE)
-		fprintf(svgfile, "<text x=\"%1.8f\" y=\"%1.8f\" font-size=\"%1.8fpt\">%i</text>\n",
+		fprintf(svgfile, "<text x=\"%.8f\" y=\"%.8f\" font-size=\"%.8fpt\">%i</text>\n",
 			time2pixels(start), Yslot *  SLOT_MULT + SLOT_HEIGHT - 1, text_size,  cpu + 1);
 
 	fprintf(svgfile, "</g>\n");
@@ -202,10 +278,10 @@ static char *time_to_string(u64 duration)
 		return text;
 
 	if (duration < 1000 * 1000) { /* less than 1 msec */
-		sprintf(text, "%4.1f us", duration / 1000.0);
+		sprintf(text, "%.1f us", duration / 1000.0);
 		return text;
 	}
-	sprintf(text, "%4.1f ms", duration / 1000.0 / 1000);
+	sprintf(text, "%.1f ms", duration / 1000.0 / 1000);
 
 	return text;
 }
@@ -233,14 +309,14 @@ void svg_waiting(int Yslot, int cpu, u64 start, u64 end, const char *backtrace)
 
 	font_size = round_text_size(font_size);
 
-	fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\">\n", time2pixels(start), Yslot * SLOT_MULT);
+	fprintf(svgfile, "<g transform=\"translate(%.8f,%.8f)\">\n", time2pixels(start), Yslot * SLOT_MULT);
 	fprintf(svgfile, "<title>#%d waiting %s</title>\n", cpu, time_to_string(end - start));
 	if (backtrace)
 		fprintf(svgfile, "<desc>Waiting on:\n%s</desc>\n", backtrace);
-	fprintf(svgfile, "<rect x=\"0\" width=\"%4.8f\" y=\"0\" height=\"%4.1f\" class=\"%s\"/>\n",
+	fprintf(svgfile, "<rect x=\"0\" width=\"%.8f\" y=\"0\" height=\"%.1f\" class=\"%s\"/>\n",
 		time2pixels(end)-time2pixels(start), SLOT_HEIGHT, style);
 	if (font_size > MIN_TEXT_SIZE)
-		fprintf(svgfile, "<text transform=\"rotate(90)\" font-size=\"%1.8fpt\"> %s</text>\n",
+		fprintf(svgfile, "<text transform=\"rotate(90)\" font-size=\"%.8fpt\"> %s</text>\n",
 			font_size, text);
 	fprintf(svgfile, "</g>\n");
 }
@@ -289,16 +365,16 @@ void svg_cpu_box(int cpu, u64 __max_freq, u64 __turbo_freq)
 
 	fprintf(svgfile, "<g>\n");
 
-	fprintf(svgfile, "<rect x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\" class=\"cpu\"/>\n",
+	fprintf(svgfile, "<rect x=\"%.8f\" width=\"%.8f\" y=\"%.1f\" height=\"%.1f\" class=\"cpu\"/>\n",
 		time2pixels(first_time),
 		time2pixels(last_time)-time2pixels(first_time),
 		cpu2y(cpu), SLOT_MULT+SLOT_HEIGHT);
 
 	sprintf(cpu_string, "CPU %i", (int)cpu);
-	fprintf(svgfile, "<text x=\"%4.8f\" y=\"%4.8f\">%s</text>\n",
+	fprintf(svgfile, "<text x=\"%.8f\" y=\"%.8f\">%s</text>\n",
 		10+time2pixels(first_time), cpu2y(cpu) + SLOT_HEIGHT/2, cpu_string);
 
-	fprintf(svgfile, "<text transform=\"translate(%4.8f,%4.8f)\" font-size=\"1.25pt\">%s</text>\n",
+	fprintf(svgfile, "<text transform=\"translate(%.8f,%.8f)\" font-size=\"1.25pt\">%s</text>\n",
 		10+time2pixels(first_time), cpu2y(cpu) + SLOT_MULT + SLOT_HEIGHT - 4, cpu_model());
 
 	fprintf(svgfile, "</g>\n");
@@ -319,11 +395,11 @@ void svg_process(int cpu, u64 start, u64 end, int pid, const char *name, const c
 	else
 		type = "sample";
 
-	fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\">\n", time2pixels(start), cpu2y(cpu));
+	fprintf(svgfile, "<g transform=\"translate(%.8f,%.8f)\">\n", time2pixels(start), cpu2y(cpu));
 	fprintf(svgfile, "<title>%d %s running %s</title>\n", pid, name, time_to_string(end - start));
 	if (backtrace)
 		fprintf(svgfile, "<desc>Switched because:\n%s</desc>\n", backtrace);
-	fprintf(svgfile, "<rect x=\"0\" width=\"%4.8f\" y=\"0\" height=\"%4.1f\" class=\"%s\"/>\n",
+	fprintf(svgfile, "<rect x=\"0\" width=\"%.8f\" y=\"0\" height=\"%.1f\" class=\"%s\"/>\n",
 		time2pixels(end)-time2pixels(start), SLOT_MULT+SLOT_HEIGHT, type);
 	width = time2pixels(end)-time2pixels(start);
 	if (width > 6)
@@ -332,7 +408,7 @@ void svg_process(int cpu, u64 start, u64 end, int pid, const char *name, const c
 	width = round_text_size(width);
 
 	if (width > MIN_TEXT_SIZE)
-		fprintf(svgfile, "<text transform=\"rotate(90)\" font-size=\"%3.8fpt\">%s</text>\n",
+		fprintf(svgfile, "<text transform=\"rotate(90)\" font-size=\"%.8fpt\">%s</text>\n",
 			width, name);
 
 	fprintf(svgfile, "</g>\n");
@@ -353,7 +429,7 @@ void svg_cstate(int cpu, u64 start, u64 end, int type)
 		type = 6;
 	sprintf(style, "c%i", type);
 
-	fprintf(svgfile, "<rect class=\"%s\" x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\"/>\n",
+	fprintf(svgfile, "<rect class=\"%s\" x=\"%.8f\" width=\"%.8f\" y=\"%.1f\" height=\"%.1f\"/>\n",
 		style,
 		time2pixels(start), time2pixels(end)-time2pixels(start),
 		cpu2y(cpu), SLOT_MULT+SLOT_HEIGHT);
@@ -365,7 +441,7 @@ void svg_cstate(int cpu, u64 start, u64 end, int type)
 	width = round_text_size(width);
 
 	if (width > MIN_TEXT_SIZE)
-		fprintf(svgfile, "<text x=\"%4.8f\" y=\"%4.8f\" font-size=\"%3.8fpt\">C%i</text>\n",
+		fprintf(svgfile, "<text x=\"%.8f\" y=\"%.8f\" font-size=\"%.8fpt\">C%i</text>\n",
 			time2pixels(start), cpu2y(cpu)+width, width, type);
 
 	fprintf(svgfile, "</g>\n");
@@ -407,9 +483,9 @@ void svg_pstate(int cpu, u64 start, u64 end, u64 freq)
 	if (max_freq)
 		height = freq * 1.0 / max_freq * (SLOT_HEIGHT + SLOT_MULT);
 	height = 1 + cpu2y(cpu) + SLOT_MULT + SLOT_HEIGHT - height;
-	fprintf(svgfile, "<line x1=\"%4.8f\" x2=\"%4.8f\" y1=\"%4.1f\" y2=\"%4.1f\" class=\"pstate\"/>\n",
+	fprintf(svgfile, "<line x1=\"%.8f\" x2=\"%.8f\" y1=\"%.1f\" y2=\"%.1f\" class=\"pstate\"/>\n",
 		time2pixels(start), time2pixels(end), height, height);
-	fprintf(svgfile, "<text x=\"%4.8f\" y=\"%4.8f\" font-size=\"0.25pt\">%s</text>\n",
+	fprintf(svgfile, "<text x=\"%.8f\" y=\"%.8f\" font-size=\"0.25pt\">%s</text>\n",
 		time2pixels(start), height+0.9, HzToHuman(freq));
 
 	fprintf(svgfile, "</g>\n");
@@ -435,32 +511,32 @@ void svg_partial_wakeline(u64 start, int row1, char *desc1, int row2, char *desc
 
 	if (row1 < row2) {
 		if (row1) {
-			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
+			fprintf(svgfile, "<line x1=\"%.8f\" y1=\"%.2f\" x2=\"%.8f\" y2=\"%.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
 				time2pixels(start), row1 * SLOT_MULT + SLOT_HEIGHT,  time2pixels(start), row1 * SLOT_MULT + SLOT_HEIGHT + SLOT_MULT/32);
 			if (desc2)
-				fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\"><text transform=\"rotate(90)\" font-size=\"0.02pt\">%s &gt;</text></g>\n",
+				fprintf(svgfile, "<g transform=\"translate(%.8f,%.8f)\"><text transform=\"rotate(90)\" font-size=\"0.02pt\">%s &gt;</text></g>\n",
 					time2pixels(start), row1 * SLOT_MULT + SLOT_HEIGHT + SLOT_HEIGHT/48, desc2);
 		}
 		if (row2) {
-			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
+			fprintf(svgfile, "<line x1=\"%.8f\" y1=\"%.2f\" x2=\"%.8f\" y2=\"%.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
 				time2pixels(start), row2 * SLOT_MULT - SLOT_MULT/32,  time2pixels(start), row2 * SLOT_MULT);
 			if (desc1)
-				fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\"><text transform=\"rotate(90)\" font-size=\"0.02pt\">%s &gt;</text></g>\n",
+				fprintf(svgfile, "<g transform=\"translate(%.8f,%.8f)\"><text transform=\"rotate(90)\" font-size=\"0.02pt\">%s &gt;</text></g>\n",
 					time2pixels(start), row2 * SLOT_MULT - SLOT_MULT/32, desc1);
 		}
 	} else {
 		if (row2) {
-			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
+			fprintf(svgfile, "<line x1=\"%.8f\" y1=\"%.2f\" x2=\"%.8f\" y2=\"%.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
 				time2pixels(start), row2 * SLOT_MULT + SLOT_HEIGHT,  time2pixels(start), row2 * SLOT_MULT + SLOT_HEIGHT + SLOT_MULT/32);
 			if (desc1)
-				fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\"><text transform=\"rotate(90)\" font-size=\"0.02pt\">%s &lt;</text></g>\n",
+				fprintf(svgfile, "<g transform=\"translate(%.8f,%.8f)\"><text transform=\"rotate(90)\" font-size=\"0.02pt\">%s &lt;</text></g>\n",
 					time2pixels(start), row2 * SLOT_MULT + SLOT_HEIGHT + SLOT_MULT/48, desc1);
 		}
 		if (row1) {
-			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
+			fprintf(svgfile, "<line x1=\"%.8f\" y1=\"%.2f\" x2=\"%.8f\" y2=\"%.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
 				time2pixels(start), row1 * SLOT_MULT - SLOT_MULT/32,  time2pixels(start), row1 * SLOT_MULT);
 			if (desc2)
-				fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\"><text transform=\"rotate(90)\" font-size=\"0.02pt\">%s &lt;</text></g>\n",
+				fprintf(svgfile, "<g transform=\"translate(%.8f,%.8f)\"><text transform=\"rotate(90)\" font-size=\"0.02pt\">%s &lt;</text></g>\n",
 					time2pixels(start), row1 * SLOT_MULT - SLOT_HEIGHT/32, desc2);
 		}
 	}
@@ -468,7 +544,7 @@ void svg_partial_wakeline(u64 start, int row1, char *desc1, int row2, char *desc
 	if (row2 > row1)
 		height += SLOT_HEIGHT;
 	if (row1)
-		fprintf(svgfile, "<circle  cx=\"%4.8f\" cy=\"%4.2f\" r = \"0.01\"  style=\"fill:rgb(32,255,32)\"/>\n",
+		fprintf(svgfile, "<circle  cx=\"%.8f\" cy=\"%.2f\" r = \"0.01\"  style=\"fill:rgb(32,255,32)\"/>\n",
 			time2pixels(start), height);
 
 	fprintf(svgfile, "</g>\n");
@@ -488,16 +564,16 @@ void svg_wakeline(u64 start, int row1, int row2, const char *backtrace)
 		fprintf(svgfile, "<desc>%s</desc>\n", backtrace);
 
 	if (row1 < row2)
-		fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
+		fprintf(svgfile, "<line x1=\"%.8f\" y1=\"%.2f\" x2=\"%.8f\" y2=\"%.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
 			time2pixels(start), row1 * SLOT_MULT + SLOT_HEIGHT,  time2pixels(start), row2 * SLOT_MULT);
 	else
-		fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
+		fprintf(svgfile, "<line x1=\"%.8f\" y1=\"%.2f\" x2=\"%.8f\" y2=\"%.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
 			time2pixels(start), row2 * SLOT_MULT + SLOT_HEIGHT,  time2pixels(start), row1 * SLOT_MULT);
 
 	height = row1 * SLOT_MULT;
 	if (row2 > row1)
 		height += SLOT_HEIGHT;
-	fprintf(svgfile, "<circle  cx=\"%4.8f\" cy=\"%4.2f\" r = \"0.01\"  style=\"fill:rgb(32,255,32)\"/>\n",
+	fprintf(svgfile, "<circle  cx=\"%.8f\" cy=\"%.2f\" r = \"0.01\"  style=\"fill:rgb(32,255,32)\"/>\n",
 			time2pixels(start), height);
 
 	fprintf(svgfile, "</g>\n");
@@ -515,9 +591,9 @@ void svg_interrupt(u64 start, int row, const char *backtrace)
 	if (backtrace)
 		fprintf(svgfile, "<desc>%s</desc>\n", backtrace);
 
-	fprintf(svgfile, "<circle  cx=\"%4.8f\" cy=\"%4.2f\" r = \"0.01\"  style=\"fill:rgb(255,128,128)\"/>\n",
+	fprintf(svgfile, "<circle  cx=\"%.8f\" cy=\"%.2f\" r = \"0.01\"  style=\"fill:rgb(255,128,128)\"/>\n",
 			time2pixels(start), row * SLOT_MULT);
-	fprintf(svgfile, "<circle  cx=\"%4.8f\" cy=\"%4.2f\" r = \"0.01\"  style=\"fill:rgb(255,128,128)\"/>\n",
+	fprintf(svgfile, "<circle  cx=\"%.8f\" cy=\"%.2f\" r = \"0.01\"  style=\"fill:rgb(255,128,128)\"/>\n",
 			time2pixels(start), row * SLOT_MULT + SLOT_HEIGHT);
 
 	fprintf(svgfile, "</g>\n");
@@ -528,7 +604,7 @@ void svg_text(int Yslot, u64 start, const char *text)
 	if (!svgfile)
 		return;
 
-	fprintf(svgfile, "<text x=\"%4.8f\" y=\"%4.8f\">%s</text>\n",
+	fprintf(svgfile, "<text x=\"%.8f\" y=\"%.8f\">%s</text>\n",
 		time2pixels(start), Yslot * SLOT_MULT+SLOT_HEIGHT/2, text);
 }
 
@@ -537,12 +613,26 @@ static void svg_legenda_box(int X, const char *text, const char *style)
 	double boxsize;
 	boxsize = SLOT_HEIGHT / 2;
 
-	fprintf(svgfile, "<rect x=\"%i\" width=\"%4.8f\" y=\"0\" height=\"%4.1f\" class=\"%s\"/>\n",
+	fprintf(svgfile, "<rect x=\"%i\" width=\"%.8f\" y=\"0\" height=\"%.1f\" class=\"%s\"/>\n",
 		X, boxsize, boxsize, style);
-	fprintf(svgfile, "<text transform=\"translate(%4.8f, %4.8f)\" font-size=\"%4.8fpt\">%s</text>\n",
+	fprintf(svgfile, "<text transform=\"translate(%.8f, %.8f)\" font-size=\"%.8fpt\">%s</text>\n",
 		X + boxsize + 5, boxsize, 0.8 * boxsize, text);
 }
 
+void svg_io_legenda(void)
+{
+	if (!svgfile)
+		return;
+
+	fprintf(svgfile, "<g>\n");
+	svg_legenda_box(0,	"Disk", "disk");
+	svg_legenda_box(100,	"Network", "net");
+	svg_legenda_box(200,	"Sync", "sync");
+	svg_legenda_box(300,	"Poll", "poll");
+	svg_legenda_box(400,	"Error", "error");
+	fprintf(svgfile, "</g>\n");
+}
+
 void svg_legenda(void)
 {
 	if (!svgfile)
@@ -559,7 +649,7 @@ void svg_legenda(void)
 	fprintf(svgfile, "</g>\n");
 }
 
-void svg_time_grid(void)
+void svg_time_grid(double min_thickness)
 {
 	u64 i;
 
@@ -579,8 +669,10 @@ void svg_time_grid(void)
 			color = 128;
 		}
 
-		fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%" PRIu64 "\" style=\"stroke:rgb(%i,%i,%i);stroke-width:%1.3f\"/>\n",
-			time2pixels(i), SLOT_MULT/2, time2pixels(i), total_height, color, color, color, thickness);
+		if (thickness >= min_thickness)
+			fprintf(svgfile, "<line x1=\"%.8f\" y1=\"%.2f\" x2=\"%.8f\" y2=\"%" PRIu64 "\" style=\"stroke:rgb(%i,%i,%i);stroke-width:%.3f\"/>\n",
+				time2pixels(i), SLOT_MULT/2, time2pixels(i),
+				total_height, color, color, color, thickness);
 
 		i += 10000000;
 	}
diff --git a/tools/perf/util/svghelper.h b/tools/perf/util/svghelper.h
index e3aff53..9292a52 100644
--- a/tools/perf/util/svghelper.h
+++ b/tools/perf/util/svghelper.h
@@ -4,6 +4,9 @@
 #include <linux/types.h>
 
 extern void open_svg(const char *filename, int cpus, int rows, u64 start, u64 end);
+extern void svg_ubox(int Yslot, u64 start, u64 end, double height, const char *type, int fd, int err, int merges);
+extern void svg_lbox(int Yslot, u64 start, u64 end, double height, const char *type, int fd, int err, int merges);
+extern void svg_fbox(int Yslot, u64 start, u64 end, double height, const char *type, int fd, int err, int merges);
 extern void svg_box(int Yslot, u64 start, u64 end, const char *type);
 extern void svg_blocked(int Yslot, int cpu, u64 start, u64 end, const char *backtrace);
 extern void svg_running(int Yslot, int cpu, u64 start, u64 end, const char *backtrace);
@@ -16,7 +19,8 @@ extern void svg_cstate(int cpu, u64 start, u64 end, int type);
 extern void svg_pstate(int cpu, u64 start, u64 end, u64 freq);
 
 
-extern void svg_time_grid(void);
+extern void svg_time_grid(double min_thickness);
+extern void svg_io_legenda(void);
 extern void svg_legenda(void);
 extern void svg_wakeline(u64 start, int row1, int row2, const char *backtrace);
 extern void svg_partial_wakeline(u64 start, int row1, char *desc1, int row2, char *desc2, const char *backtrace);
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 6864661..d753499 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -49,7 +49,8 @@ static inline uint8_t elf_sym__type(const GElf_Sym *sym)
 
 static inline int elf_sym__is_function(const GElf_Sym *sym)
 {
-	return elf_sym__type(sym) == STT_FUNC &&
+	return (elf_sym__type(sym) == STT_FUNC ||
+		elf_sym__type(sym) == STT_GNU_IFUNC) &&
 	       sym->st_name != 0 &&
 	       sym->st_shndx != SHN_UNDEF;
 }
@@ -598,6 +599,8 @@ int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
 			goto out_elf_end;
 	}
 
+	ss->is_64_bit = (gelf_getclass(elf) == ELFCLASS64);
+
 	ss->symtab = elf_section_by_name(elf, &ehdr, &ss->symshdr, ".symtab",
 			NULL);
 	if (ss->symshdr.sh_type != SHT_SYMTAB)
@@ -619,7 +622,7 @@ int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
 		GElf_Shdr shdr;
 		ss->adjust_symbols = (ehdr.e_type == ET_EXEC ||
 				ehdr.e_type == ET_REL ||
-				is_vdso_map(dso->short_name) ||
+				dso__is_vdso(dso) ||
 				elf_section_by_name(elf, &ehdr, &shdr,
 						     ".gnu.prelink_undo",
 						     NULL) != NULL);
@@ -698,6 +701,7 @@ int dso__load_sym(struct dso *dso, struct map *map,
 	bool remap_kernel = false, adjust_kernel_syms = false;
 
 	dso->symtab_type = syms_ss->type;
+	dso->is_64_bit = syms_ss->is_64_bit;
 	dso->rel = syms_ss->ehdr.e_type == ET_REL;
 
 	/*
@@ -1024,6 +1028,39 @@ int file__read_maps(int fd, bool exe, mapfn_t mapfn, void *data,
 	return err;
 }
 
+enum dso_type dso__type_fd(int fd)
+{
+	enum dso_type dso_type = DSO__TYPE_UNKNOWN;
+	GElf_Ehdr ehdr;
+	Elf_Kind ek;
+	Elf *elf;
+
+	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
+	if (elf == NULL)
+		goto out;
+
+	ek = elf_kind(elf);
+	if (ek != ELF_K_ELF)
+		goto out_end;
+
+	if (gelf_getclass(elf) == ELFCLASS64) {
+		dso_type = DSO__TYPE_64BIT;
+		goto out_end;
+	}
+
+	if (gelf_getehdr(elf, &ehdr) == NULL)
+		goto out_end;
+
+	if (ehdr.e_machine == EM_X86_64)
+		dso_type = DSO__TYPE_X32BIT;
+	else
+		dso_type = DSO__TYPE_32BIT;
+out_end:
+	elf_end(elf);
+out:
+	return dso_type;
+}
+
 static int copy_bytes(int from, off_t from_offs, int to, off_t to_offs, u64 len)
 {
 	ssize_t r;
diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index bd15f49..c9541fe 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -288,6 +288,44 @@ int dso__synthesize_plt_symbols(struct dso *dso __maybe_unused,
 	return 0;
 }
 
+static int fd__is_64_bit(int fd)
+{
+	u8 e_ident[EI_NIDENT];
+
+	if (lseek(fd, 0, SEEK_SET))
+		return -1;
+
+	if (readn(fd, e_ident, sizeof(e_ident)) != sizeof(e_ident))
+		return -1;
+
+	if (memcmp(e_ident, ELFMAG, SELFMAG) ||
+	    e_ident[EI_VERSION] != EV_CURRENT)
+		return -1;
+
+	return e_ident[EI_CLASS] == ELFCLASS64;
+}
+
+enum dso_type dso__type_fd(int fd)
+{
+	Elf64_Ehdr ehdr;
+	int ret;
+
+	ret = fd__is_64_bit(fd);
+	if (ret < 0)
+		return DSO__TYPE_UNKNOWN;
+
+	if (ret)
+		return DSO__TYPE_64BIT;
+
+	if (readn(fd, &ehdr, sizeof(ehdr)) != sizeof(ehdr))
+		return DSO__TYPE_UNKNOWN;
+
+	if (ehdr.e_machine == EM_X86_64)
+		return DSO__TYPE_X32BIT;
+
+	return DSO__TYPE_32BIT;
+}
+
 int dso__load_sym(struct dso *dso, struct map *map __maybe_unused,
 		  struct symsrc *ss,
 		  struct symsrc *runtime_ss __maybe_unused,
@@ -295,6 +333,11 @@ int dso__load_sym(struct dso *dso, struct map *map __maybe_unused,
 		  int kmodule __maybe_unused)
 {
 	unsigned char *build_id[BUILD_ID_SIZE];
+	int ret;
+
+	ret = fd__is_64_bit(ss->fd);
+	if (ret >= 0)
+		dso->is_64_bit = ret;
 
 	if (filename__read_build_id(ss->name, build_id, BUILD_ID_SIZE) > 0) {
 		dso__set_build_id(dso, build_id);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 7b9096f..eb06746 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -34,6 +34,7 @@ struct symbol_conf symbol_conf = {
 	.annotate_src		= true,
 	.demangle		= true,
 	.cumulate_callchain	= true,
+	.show_hist_headers	= true,
 	.symfs			= "",
 };
 
@@ -341,6 +342,16 @@ static struct symbol *symbols__first(struct rb_root *symbols)
 	return NULL;
 }
 
+static struct symbol *symbols__next(struct symbol *sym)
+{
+	struct rb_node *n = rb_next(&sym->rb_node);
+
+	if (n)
+		return rb_entry(n, struct symbol, rb_node);
+
+	return NULL;
+}
+
 struct symbol_name_rb_node {
 	struct rb_node	rb_node;
 	struct symbol	sym;
@@ -411,11 +422,16 @@ struct symbol *dso__find_symbol(struct dso *dso,
 	return symbols__find(&dso->symbols[type], addr);
 }
 
-static struct symbol *dso__first_symbol(struct dso *dso, enum map_type type)
+struct symbol *dso__first_symbol(struct dso *dso, enum map_type type)
 {
 	return symbols__first(&dso->symbols[type]);
 }
 
+struct symbol *dso__next_symbol(struct symbol *sym)
+{
+	return symbols__next(sym);
+}
+
 struct symbol *dso__find_symbol_by_name(struct dso *dso, enum map_type type,
 					const char *name)
 {
@@ -1064,6 +1080,7 @@ static int dso__load_kcore(struct dso *dso, struct map *map,
 			      &is_64_bit);
 	if (err)
 		goto out_err;
+	dso->is_64_bit = is_64_bit;
 
 	if (list_empty(&md.maps)) {
 		err = -EINVAL;
@@ -1662,6 +1679,7 @@ do_kallsyms:
 	free(kallsyms_allocated_filename);
 
 	if (err > 0 && !dso__is_kcore(dso)) {
+		dso->binary_type = DSO_BINARY_TYPE__KALLSYMS;
 		dso__set_long_name(dso, "[kernel.kallsyms]", false);
 		map__fixup_start(map);
 		map__fixup_end(map);
@@ -1709,6 +1727,7 @@ static int dso__load_guest_kernel_sym(struct dso *dso, struct map *map,
 	if (err > 0)
 		pr_debug("Using %s for symbols\n", kallsyms_filename);
 	if (err > 0 && !dso__is_kcore(dso)) {
+		dso->binary_type = DSO_BINARY_TYPE__GUEST_KALLSYMS;
 		machine__mmap_name(machine, path, sizeof(path));
 		dso__set_long_name(dso, strdup(path), true);
 		map__fixup_start(map);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 615c752..e7295e9 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -118,7 +118,8 @@ struct symbol_conf {
 			annotate_src,
 			event_group,
 			demangle,
-			filter_relative;
+			filter_relative,
+			show_hist_headers;
 	const char	*vmlinux_name,
 			*kallsyms_name,
 			*source_prefix,
@@ -215,6 +216,7 @@ struct symsrc {
 	GElf_Shdr dynshdr;
 
 	bool adjust_symbols;
+	bool is_64_bit;
 #endif
 };
 
@@ -238,6 +240,11 @@ struct symbol *dso__find_symbol(struct dso *dso, enum map_type type,
 struct symbol *dso__find_symbol_by_name(struct dso *dso, enum map_type type,
 					const char *name);
 
+struct symbol *dso__first_symbol(struct dso *dso, enum map_type type);
+struct symbol *dso__next_symbol(struct symbol *sym);
+
+enum dso_type dso__type_fd(int fd);
+
 int filename__read_build_id(const char *filename, void *bf, size_t size);
 int sysfs__read_build_id(const char *filename, void *bf, size_t size);
 int modules__parse(const char *filename, void *arg,
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 2fde0d5..12c7a25 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -13,7 +13,7 @@ int thread__init_map_groups(struct thread *thread, struct machine *machine)
 	struct thread *leader;
 	pid_t pid = thread->pid_;
 
-	if (pid == thread->tid) {
+	if (pid == thread->tid || pid == -1) {
 		thread->mg = map_groups__new();
 	} else {
 		leader = machine__findnew_thread(machine, pid, pid);
@@ -34,6 +34,7 @@ struct thread *thread__new(pid_t pid, pid_t tid)
 		thread->pid_ = pid;
 		thread->tid = tid;
 		thread->ppid = -1;
+		thread->cpu = -1;
 		INIT_LIST_HEAD(&thread->comm_list);
 
 		comm_str = malloc(32);
@@ -60,8 +61,10 @@ void thread__delete(struct thread *thread)
 {
 	struct comm *comm, *tmp;
 
-	map_groups__put(thread->mg);
-	thread->mg = NULL;
+	if (thread->mg) {
+		map_groups__put(thread->mg);
+		thread->mg = NULL;
+	}
 	list_for_each_entry_safe(comm, tmp, &thread->comm_list, list) {
 		list_del(&comm->list);
 		comm__free(comm);
@@ -127,12 +130,12 @@ int thread__comm_len(struct thread *thread)
 size_t thread__fprintf(struct thread *thread, FILE *fp)
 {
 	return fprintf(fp, "Thread %d %s\n", thread->tid, thread__comm_str(thread)) +
-	       map_groups__fprintf(thread->mg, verbose, fp);
+	       map_groups__fprintf(thread->mg, fp);
 }
 
 void thread__insert_map(struct thread *thread, struct map *map)
 {
-	map_groups__fixup_overlappings(thread->mg, map, verbose, stderr);
+	map_groups__fixup_overlappings(thread->mg, map, stderr);
 	map_groups__insert(thread->mg, map);
 }
 
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 3c0c272..716b772 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -17,6 +17,7 @@ struct thread {
 	pid_t			pid_; /* Not all tools update this */
 	pid_t			tid;
 	pid_t			ppid;
+	int			cpu;
 	char			shortname[3];
 	bool			comm_set;
 	bool			dead; /* if set thread has exited */
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 7e6fcfe..eb72716 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -40,6 +40,7 @@
 #include "trace-event.h"
 #include <api/fs/debugfs.h>
 #include "evsel.h"
+#include "debug.h"
 
 #define VERSION "0.5"
 
@@ -191,12 +192,10 @@ static int copy_event_system(const char *sys, struct tracepoint_path *tps)
 		    strcmp(dent->d_name, "..") == 0 ||
 		    !name_in_tp_list(dent->d_name, tps))
 			continue;
-		format = malloc(strlen(sys) + strlen(dent->d_name) + 10);
-		if (!format) {
+		if (asprintf(&format, "%s/%s/format", sys, dent->d_name) < 0) {
 			err = -ENOMEM;
 			goto out;
 		}
-		sprintf(format, "%s/%s/format", sys, dent->d_name);
 		ret = stat(format, &st);
 		free(format);
 		if (ret < 0)
@@ -217,12 +216,10 @@ static int copy_event_system(const char *sys, struct tracepoint_path *tps)
 		    strcmp(dent->d_name, "..") == 0 ||
 		    !name_in_tp_list(dent->d_name, tps))
 			continue;
-		format = malloc(strlen(sys) + strlen(dent->d_name) + 10);
-		if (!format) {
+		if (asprintf(&format, "%s/%s/format", sys, dent->d_name) < 0) {
 			err = -ENOMEM;
 			goto out;
 		}
-		sprintf(format, "%s/%s/format", sys, dent->d_name);
 		ret = stat(format, &st);
 
 		if (ret >= 0) {
@@ -317,12 +314,10 @@ static int record_event_files(struct tracepoint_path *tps)
 		    strcmp(dent->d_name, "ftrace") == 0 ||
 		    !system_in_tp_list(dent->d_name, tps))
 			continue;
-		sys = malloc(strlen(path) + strlen(dent->d_name) + 2);
-		if (!sys) {
+		if (asprintf(&sys, "%s/%s", path, dent->d_name) < 0) {
 			err = -ENOMEM;
 			goto out;
 		}
-		sprintf(sys, "%s/%s", path, dent->d_name);
 		ret = stat(sys, &st);
 		if (ret >= 0) {
 			ssize_t size = strlen(dent->d_name) + 1;
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index e113e18..54d9e9b 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -22,7 +22,6 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <getopt.h>
 #include <stdarg.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -36,6 +35,7 @@
 #include "../perf.h"
 #include "util.h"
 #include "trace-event.h"
+#include "debug.h"
 
 static int input_fd;
 
diff --git a/tools/perf/util/tsc.c b/tools/perf/util/tsc.c
new file mode 100644
index 0000000..4d4210d
--- /dev/null
+++ b/tools/perf/util/tsc.c
@@ -0,0 +1,30 @@
+#include <linux/compiler.h>
+#include <linux/types.h>
+
+#include "tsc.h"
+
+u64 perf_time_to_tsc(u64 ns, struct perf_tsc_conversion *tc)
+{
+	u64 t, quot, rem;
+
+	t = ns - tc->time_zero;
+	quot = t / tc->time_mult;
+	rem  = t % tc->time_mult;
+	return (quot << tc->time_shift) +
+	       (rem << tc->time_shift) / tc->time_mult;
+}
+
+u64 tsc_to_perf_time(u64 cyc, struct perf_tsc_conversion *tc)
+{
+	u64 quot, rem;
+
+	quot = cyc >> tc->time_shift;
+	rem  = cyc & ((1 << tc->time_shift) - 1);
+	return tc->time_zero + quot * tc->time_mult +
+	       ((rem * tc->time_mult) >> tc->time_shift);
+}
+
+u64 __weak rdtsc(void)
+{
+	return 0;
+}
diff --git a/tools/perf/util/tsc.h b/tools/perf/util/tsc.h
new file mode 100644
index 0000000..a8b78f1
--- /dev/null
+++ b/tools/perf/util/tsc.h
@@ -0,0 +1,12 @@
+#ifndef __PERF_TSC_H
+#define __PERF_TSC_H
+
+#include <linux/types.h>
+
+#include "../arch/x86/util/tsc.h"
+
+u64 perf_time_to_tsc(u64 ns, struct perf_tsc_conversion *tc);
+u64 tsc_to_perf_time(u64 cyc, struct perf_tsc_conversion *tc);
+u64 rdtsc(void);
+
+#endif
diff --git a/tools/perf/util/unwind-libdw.c b/tools/perf/util/unwind-libdw.c
index 5ec80a5..7419768 100644
--- a/tools/perf/util/unwind-libdw.c
+++ b/tools/perf/util/unwind-libdw.c
@@ -3,6 +3,7 @@
 #include <elfutils/libdwfl.h>
 #include <inttypes.h>
 #include <errno.h>
+#include "debug.h"
 #include "unwind.h"
 #include "unwind-libdw.h"
 #include "machine.h"
diff --git a/tools/perf/util/unwind-libunwind.c b/tools/perf/util/unwind-libunwind.c
index 25578b9..92b56db 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -30,6 +30,7 @@
 #include "unwind.h"
 #include "symbol.h"
 #include "util.h"
+#include "debug.h"
 
 extern int
 UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 95aefa7..e52e746 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -1,5 +1,6 @@
 #include "../perf.h"
 #include "util.h"
+#include "debug.h"
 #include <api/fs/fs.h>
 #include <sys/mman.h>
 #ifdef HAVE_BACKTRACE_SUPPORT
@@ -333,12 +334,9 @@ const char *find_tracing_dir(void)
 	if (!debugfs)
 		return NULL;
 
-	tracing = malloc(strlen(debugfs) + 9);
-	if (!tracing)
+	if (asprintf(&tracing, "%s/tracing", debugfs) < 0)
 		return NULL;
 
-	sprintf(tracing, "%s/tracing", debugfs);
-
 	tracing_found = 1;
 	return tracing;
 }
@@ -352,11 +350,9 @@ char *get_tracing_file(const char *name)
 	if (!tracing)
 		return NULL;
 
-	file = malloc(strlen(tracing) + strlen(name) + 2);
-	if (!file)
+	if (asprintf(&file, "%s/%s", tracing, name) < 0)
 		return NULL;
 
-	sprintf(file, "%s/%s", tracing, name);
 	return file;
 }
 
diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
index 0ddb3b8..adca693 100644
--- a/tools/perf/util/vdso.c
+++ b/tools/perf/util/vdso.c
@@ -11,10 +11,34 @@
 #include "vdso.h"
 #include "util.h"
 #include "symbol.h"
+#include "machine.h"
 #include "linux/string.h"
+#include "debug.h"
 
-static bool vdso_found;
-static char vdso_file[] = "/tmp/perf-vdso.so-XXXXXX";
+#define VDSO__TEMP_FILE_NAME "/tmp/perf-vdso.so-XXXXXX"
+
+struct vdso_file {
+	bool found;
+	bool error;
+	char temp_file_name[sizeof(VDSO__TEMP_FILE_NAME)];
+	const char *dso_name;
+};
+
+struct vdso_info {
+	struct vdso_file vdso;
+};
+
+static struct vdso_info *vdso_info__new(void)
+{
+	static const struct vdso_info vdso_info_init = {
+		.vdso    = {
+			.temp_file_name = VDSO__TEMP_FILE_NAME,
+			.dso_name = DSO__NAME_VDSO,
+		},
+	};
+
+	return memdup(&vdso_info_init, sizeof(vdso_info_init));
+}
 
 static int find_vdso_map(void **start, void **end)
 {
@@ -47,7 +71,7 @@ static int find_vdso_map(void **start, void **end)
 	return !found;
 }
 
-static char *get_file(void)
+static char *get_file(struct vdso_file *vdso_file)
 {
 	char *vdso = NULL;
 	char *buf = NULL;
@@ -55,10 +79,10 @@ static char *get_file(void)
 	size_t size;
 	int fd;
 
-	if (vdso_found)
-		return vdso_file;
+	if (vdso_file->found)
+		return vdso_file->temp_file_name;
 
-	if (find_vdso_map(&start, &end))
+	if (vdso_file->error || find_vdso_map(&start, &end))
 		return NULL;
 
 	size = end - start;
@@ -67,45 +91,78 @@ static char *get_file(void)
 	if (!buf)
 		return NULL;
 
-	fd = mkstemp(vdso_file);
+	fd = mkstemp(vdso_file->temp_file_name);
 	if (fd < 0)
 		goto out;
 
 	if (size == (size_t) write(fd, buf, size))
-		vdso = vdso_file;
+		vdso = vdso_file->temp_file_name;
 
 	close(fd);
 
  out:
 	free(buf);
 
-	vdso_found = (vdso != NULL);
+	vdso_file->found = (vdso != NULL);
+	vdso_file->error = !vdso_file->found;
 	return vdso;
 }
 
-void vdso__exit(void)
+void vdso__exit(struct machine *machine)
 {
-	if (vdso_found)
-		unlink(vdso_file);
+	struct vdso_info *vdso_info = machine->vdso_info;
+
+	if (!vdso_info)
+		return;
+
+	if (vdso_info->vdso.found)
+		unlink(vdso_info->vdso.temp_file_name);
+
+	zfree(&machine->vdso_info);
 }
 
-struct dso *vdso__dso_findnew(struct list_head *head)
+static struct dso *vdso__new(struct machine *machine, const char *short_name,
+			     const char *long_name)
 {
-	struct dso *dso = dsos__find(head, VDSO__MAP_NAME, true);
+	struct dso *dso;
 
+	dso = dso__new(short_name);
+	if (dso != NULL) {
+		dsos__add(&machine->user_dsos, dso);
+		dso__set_long_name(dso, long_name, false);
+	}
+
+	return dso;
+}
+
+struct dso *vdso__dso_findnew(struct machine *machine,
+			      struct thread *thread __maybe_unused)
+{
+	struct vdso_info *vdso_info;
+	struct dso *dso;
+
+	if (!machine->vdso_info)
+		machine->vdso_info = vdso_info__new();
+
+	vdso_info = machine->vdso_info;
+	if (!vdso_info)
+		return NULL;
+
+	dso = dsos__find(&machine->user_dsos, DSO__NAME_VDSO, true);
 	if (!dso) {
 		char *file;
 
-		file = get_file();
+		file = get_file(&vdso_info->vdso);
 		if (!file)
 			return NULL;
 
-		dso = dso__new(VDSO__MAP_NAME);
-		if (dso != NULL) {
-			dsos__add(head, dso);
-			dso__set_long_name(dso, file, false);
-		}
+		dso = vdso__new(machine, DSO__NAME_VDSO, file);
 	}
 
 	return dso;
 }
+
+bool dso__is_vdso(struct dso *dso)
+{
+	return !strcmp(dso->short_name, DSO__NAME_VDSO);
+}
diff --git a/tools/perf/util/vdso.h b/tools/perf/util/vdso.h
index 0f76e7c..af9d692 100644
--- a/tools/perf/util/vdso.h
+++ b/tools/perf/util/vdso.h
@@ -7,12 +7,21 @@
 
 #define VDSO__MAP_NAME "[vdso]"
 
+#define DSO__NAME_VDSO "[vdso]"
+
 static inline bool is_vdso_map(const char *filename)
 {
 	return !strcmp(filename, VDSO__MAP_NAME);
 }
 
-struct dso *vdso__dso_findnew(struct list_head *head);
-void vdso__exit(void);
+struct dso;
+
+bool dso__is_vdso(struct dso *dso);
+
+struct machine;
+struct thread;
+
+struct dso *vdso__dso_findnew(struct machine *machine, struct thread *thread);
+void vdso__exit(struct machine *machine);
 
 #endif /* __PERF_VDSO__ */
