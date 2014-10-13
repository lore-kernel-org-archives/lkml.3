Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbaJMGxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 02:53:34 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:49032 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaJMGxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 02:53:32 -0400
Date: Mon, 13 Oct 2014 08:53:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf events tree changes for v3.18
Message-ID: <20141013065327.GA9849@gmail.com>
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

   # HEAD: cc6cd47e7395bc05c5077009808b820633eb3f18 perf/x86: Tone down kernel messages when the PMU check fails in a virtual environment

Kernel side updates:

 * Fix and enhance poll support (Jiri Olsa)

 * Re-enable inheritance optimization (Jiri Olsa)

 * Enhance Intel memory events support (Stephane Eranian)

 * Refactor the Intel uncore driver to be more maintainable 
   (Zheng Yan)

 * Enhance and fix Intel CPU and uncore PMU drivers
   (Peter Zijlstra, Andi Kleen)

 * [ plus various smaller fixes/cleanups ]

Tooling updates:

 User visible tooling changes:

  * Add +field argument support for --field option, so that one can add
    fields to the default list of fields to show, i.e. now one can just do:

     perf report --fields +pid

    And the pid will appear in addition to the default fields. (Jiri Olsa)

  * Add +field argument support for --sort option (Jiri Olsa)

  * Honour -w in the report tools (report, top), allowing to specify the widths
    for the histogram entries columns. (Namhyung Kim)

  * Properly show submicrosecond times in 'perf kvm stat' (Christian Borntraeger)

  * Add beautifier for mremap flags param in 'trace' (Alex Snast)

  * perf script: Allow callchains if any event samples them

  * Don't truncate Intel style addresses in 'annotate'. (Alex Converse)

  * Allow profiling when kptr_restrict == 1 for non root users,
    kernel samples will just remain unresolved (Andi Kleen)

  * Allow configuring default options for callchains in config file (Namhyung Kim)

  * Support operations for shared futexes. (Davidlohr Bueso)

  * "perf kvm stat report" improvements by Alexander Yarygin:

    -  Save pid string in opts.target.pid
    -  Enable the target.system_wide flag
    -  Unify the title bar output

  * [ plus lots of other fixes and small improvements. ]

 Tooling infrastructure changes:

  * Refactor unit and scale function parameters for PMU parsing routines. (Matt Fleming)

  * Improve DSO long names lookup with rbtree, resulting in great speedup for
    workloads with lots of DSOs. (Waiman Long)

  * We were not handling POLLHUP notifications for event file descriptors.

    Fix it by filtering entries in the events file descriptor array after
    poll() returns, refcounting mmaps so that when the last fd pointing to
    a perf mmap goes away we do the unmap. (Arnaldo Carvalho de Melo)

  * Intel PT prep work, from Adrian Hunter, including:

    - Let a user specify a PMU event without any config terms
    - Add perf-with-kcore script
    - Let default config be defined for a PMU
    - Add perf_pmu__scan_file()
    - Add a 'perf test' for tracking with sched_switch
    - Add 'flush' callback to scripting API

  * Use ring buffer consume method to look like other tools (Arnaldo Carvalho de Melo)

  * hists browser (used in top and report) refactorings, getting rid of unused
    variables and reducing source code size by handling similar cases in a
    fewer functions (Namhyung Kim).

  * Replace thread unsafe strerror() with strerror_r() accross the
    whole tools/perf/ tree (Masami Hiramatsu)

  * Rename ordered_samples to ordered_events and allow setting a queue
    size for ordering events (Jiri Olsa)

  * [ plus lots of fixes, cleanups and other improvements. ]

 Thanks,

	Ingo

------------------>
Adrian Hunter (22):
      perf tools: Fix CLOEXEC probe for perf_event_paranoid == 2
      perf tools: Fix one of the probe events to exclude kernel
      perf tools: Fix probing the kernel API with cpu-wide events
      perf tools: Prefer to use a cpu-wide event for probing CLOEXEC
      perf symbols: Fix missing label symbols
      perf evlist: Add 'system_wide' option
      perf evlist: Add perf_evlist__set_tracking_event()
      perf session: Add perf_session__peek_event()
      perf script: Allow callchains if any event samples them
      perf script python: Add helpers for calling Python objects
      perf tools: Identify which comms are from exec
      perf machine: Add machine__thread_exec_comm()
      perf tools: Add flags and insn_len to struct sample
      perf evlist: Add perf_evlist__enable_event_idx()
      perf tests: Add a test for tracking with sched_switch
      perf scripting: Add 'flush' callback to scripting API
      perf machine: Rename machine__get_kernel_start_addr() method
      perf tools: Add machine__kernel_ip()
      perf tools: Let a user specify a PMU event without any config terms
      perf tools: Add perf-with-kcore script
      perf tools: Let default config be defined for a PMU
      perf tools: Add perf_pmu__scan_file()

Alex Converse (1):
      perf annotate: Don't truncate Intel style addresses

Alex Snast (1):
      perf trace: Add beautifier for mremap flags param

Alexander Yarygin (3):
      perf kvm stat report: Save pid string in opts.target.pid
      perf kvm stat report: Enable the target.system_wide flag
      perf kvm stat report: Unify the title bar output

Andi Kleen (16):
      perf record: Honour --no-time command line option
      perf/x86: Use extended offcore mask on Haswell
      perf/x86: Fix :pp without LBR
      perf/x86: Revamp PEBS event selection
      perf/x86: Don't mark DataLA addresses as store
      perf/x86: Fix section mismatch in split uncore driver
      perf/x86/intel: Remove incorrect model number from Haswell perf
      perf/x86/intel: Document all Haswell models
      perf/x86/intel: Add Broadwell core support
      perf/x86: Add INST_RETIRED.ALL workarounds
      perf/x86/intel: Use Broadwell cache event list for Haswell
      perf/x86/intel/uncore: Add missing cbox filter flags on IvyBridge-EP uncore driver
      perf/x86/intel/uncore: Fix PCU filter setup for Sandy/Ivy/Haswell EP
      perf stat: Fix --per-core on multi socket systems
      perf tools: Fix perf record as non root with kptr_restrict == 1
      perf/x86/intel/uncore: Fix minor race in box set up

Andreea-Cristina Bernat (2):
      perf/callchain: Replace rcu_assign_pointer() with RCU_INIT_POINTER()
      perf/core: Replace rcu_assign_pointer() with RCU_INIT_POINTER()

Anton Blanchard (3):
      perf tools powerpc: Fix build issue when DWARF support is disabled
      perf symbols: Ignore stripped vmlinux and fallback to kallsyms
      perf symbols: Add path to Ubuntu kernel debuginfo file

Arnaldo Carvalho de Melo (21):
      perf evlist: Don't run workload if not told to
      perf symbols: Make sure --symfs usage includes the path separator
      perf top: Don't look for kernel idle symbols in all DSOs
      perf tools: Add cpu_startup_entry to the list of kernel idle symbols
      perf tools: Don't include sys/poll.h directly
      perf record: Use ring buffer consume method to look like other tools
      perf evlist: Introduce perf_evlist__filter_pollfd method
      perf tests: Add test for perf_evlist__filter_pollfd()
      perf evlist: Monitor POLLERR and POLLHUP events too
      perf evlist: We need to poll all event file descriptors
      perf evlist: Allow growing pollfd on add method
      perf tests: Add pollfd growing test
      perf kvm stat live: Use perf_evlist__add_pollfd() instead of local equivalent
      perf evlist: Introduce poll method for common code idiom
      tools lib api: Adopt fdarray class from perf's evlist
      perf evlist: Refcount mmaps
      tools lib fd array: Allow associating an integer cookie with each entry
      perf evlist: Unmap when all refcounts to fd are gone and events drained
      perf record: Filter out POLLHUP'ed file descriptors
      perf trace: Filter out POLLHUP'ed file descriptors
      perf record: Fix error message for --filter option not coming after tracepoint

Avi Kivity (1):
      perf tools: Disable kernel symbol demangling by default

Chang Hyun Park (1):
      perf trace: Fix mmap return address truncation to 32-bit

Chanho Park (1):
      perf tools: define _DEFAULT_SOURCE for glibc_2.20

Christian Borntraeger (1):
      perf kvm stat: Properly show submicrosecond times

Cody P Schafer (1):
      perf tools: Annotate PMU related list_head members with type info

Davidlohr Bueso (2):
      perf bench futex: Support operations for shared futexes
      perf bench futex: Sanitize -q option in requeue

Don Zickus (2):
      perf symbols: Don't try to find DSOs in SYSV maps
      perf machine: Fallback to MAP__FUNCTION if daddr maps are NULL

Elliott Hughes (1):
      perf tools: Add arm64 triplets

Fengguang Wu (1):
      perf/x86/uncore: Fix coccinelle warnings

Ingo Molnar (1):
      jump_label: Fix small typos in the documentation

Jiri Olsa (35):
      perf tools: Rename ordered_samples bool to ordered_events
      perf tools: Rename ordered_samples struct to ordered_events
      perf tools: Rename ordered_events members
      perf tools: Add ordered_events__(new|delete) interface
      perf tools: Factor ordered_events__flush to be more generic
      perf tools: Limit ordered events queue size
      perf tools: Flush ordered events in case of allocation failure
      perf tools: Make perf_session__deliver_event global
      perf tools: Create ordered-events object
      perf tools: Use list_move in ordered_events_delete function
      perf tools: Add ordered_events__init function
      perf tools: Add ordered_events__free function
      perf tools: Add perf_config_u64 function
      perf tools: Add report.queue-size config file option
      perf tools: Add debug prints for ordered events queue
      perf tools: Allow out of order messages in forced flush
      perf tools: Show better error message in case we fail to open counters due to EBUSY error
      perf tools: Fix PERF_FLAG_FD_CLOEXEC flag probing event type open counters due to EBUSY error
      perf: Set owner pointer for kernel events
      perf: Add queued work to remove orphaned child events
      perf top: Join the display thread on exit
      perf tools: Introduce set_term_quiet_input helper function
      perf top: Setup signals for terminal output
      perf kvm: Fix stdin handling for 'kvm stat live' command
      perf: Fix perf_poll to return proper POLLHUP value
      perf: Add PERF_EVENT_STATE_EXIT state for events with exited task
      perf top: Use set_term_quiet() instead of open coded equivalent
      perf tools: Add +field argument support for --field option
      perf: Do not check PERF_EVENT_STATE_EXIT on syscall read path
      perf tools: Add +field argument support for --sort option
      perf tools: Allow to specify lib compile variable for spec usage
      perf: Do not POLLHUP event if it has children
      perf: Fix child event initial state setup
      Revert "perf: Do not allow optimized switch for non-cloned events"
      perf tools: Fix line number in the config file error message

John Spencer (1):
      perf tools: Fix GNU-only grep usage in Makefile

Mark Salter (1):
      perf tools: Fix arm64 build error

Masami Hiramatsu (18):
      perf probe: Fix --list option to show events only with uprobe events
      perf probe: Fix --del option to delete events only with uprobe events
      perf probe: Warn user to rebuild target with debuginfo
      perf probe: Don't use strerror if strlist__add failed
      perf: Use strerror_r instead of strerror
      perf probe: Make error messages thread-safe
      perf util: Replace strerror with strerror_r for thread-safety
      perf top: Use strerror_r instead of strerror
      perf trace: Use strerror_r instead of strerror
      perf record: Use strerror_r instead of strerror
      perf test: Use strerror_r instead of strerror
      perf sched: Use strerror_r instead of strerror
      perf buildid-cache: Use strerror_r instead of strerror
      perf kvm: Use strerror_r instead of strerror
      perf help: Use strerror_r instead of strerror
      perf stat: Use strerror_r instead of strerror
      perf probe: Do not access kallsyms when analyzing user binaries
      perf probe: Do not use dwfl_module_addrsym if dwarf_diename finds symbol name

Mathias Krause (1):
      perf/x86/intel: Mark initialization code as such

Matt Fleming (1):
      perf tools: Refactor unit and scale function parameters

Namhyung Kim (37):
      perf kmem: Do not ignore mmap events
      perf tools: Fix make PYTHON override
      perf tools: Left-align output contents
      perf tools: Make __hpp__fmt() receive an additional len argument
      perf tools: Save column length in perf_hpp_fmt
      perf report: Honor column width setting
      perf top: Add -w option for setting column width
      perf tools: Add name field into perf_hpp_fmt
      perf tools: Fix column alignment when headers aren't shown on TUI
      perf script: Fix possible memory leaks
      perf symbols: Fix a memory leak in vmlinux_path__init()
      perf annotate: Move session handling out of __cmd_annotate()
      perf buildid-cache: Move session handling into cmd_buildid_cache()
      perf inject: Move session handling out of __cmd_inject()
      perf kmem: Move session handling out of __cmd_kmem()
      perf kvm: Move call to symbol__init() after creating session
      perf lock: Move call to symbol__init() after creating session
      perf sched: Move call to symbol__init() after creating session
      perf script: Move call to symbol__init() after creating session
      perf timechart: Move call to symbol__init() after creating session
      perf trace: Move call to symbol__init() after creating session
      perf tools: Check recorded kernel version when finding vmlinux
      perf hists browser: Fix a small callchain display bug
      perf top: Fix -z option behavior
      perf top: Handle 'z' key for toggle zeroing samples in TUI
      perf symbols: Don't demangle parameters and such by default
      perf report: Relax -g option parsing not to limit the option order
      perf hists browser: Get rid of unused 'remaining' variable
      perf hists browser: Fix children overhead dump
      perf hists browser: Factor out hist_browser__show_callchain_entry()
      perf hists browser: Cleanup callchain print functions
      perf hists browser: Consolidate callchain print functions in TUI
      perf hists browser: Fix callchain print bug on TUI
      perf tools: Move callchain config from record_opts to callchain_param
      perf callchain: Move some parser functions to callchain.c
      perf tools: Introduce perf_callchain_config()
      perf tools: Convert {record,top}.call-graph option to call-graph.record-mode

Peter Zijlstra (2):
      perf/x86/intel: Update Intel models
      perf/x86/uncore: Rename IvyTown to IvyBridge-EP

Pranith Kumar (1):
      perf tools: Use ACCESS_ONCE() instead of volatile cast

Sebastian Andrzej Siewior (1):
      perf: Do poll_wait() before checking condition in perf_poll()

Stephane Eranian (5):
      perf/x86: Fix data source encoding issues for load latency/precise store
      perf/x86: Clean up __intel_pmu_pebs_event() code
      perf/x86/uncore: Export basic memory events for IVT IMC PMU
      perf tool: fix compilation for ARM
      perf/x86/intel/uncore: Update support for client uncore IMC PMU

Sukadev Bhattiprolu (1):
      perf tools powerpc: Explicitly include util/debug.h

Taeung Song (1):
      perf tools: Modify error code for when perf_session__new() fails

Thomas Ilsche (1):
      perf tools: Default to python version 2

Waiman Long (2):
      perf symbols: Encapsulate dsos list head into struct dsos
      perf symbols: Improve DSO long names lookup speed with rbtree

Wei Huang (1):
      perf/x86: Tone down kernel messages when the PMU check fails in a virtual environment

Will Deacon (1):
      perf tools: Fix build breakage on arm64 targets

Yan, Zheng (6):
      perf/x86/uncore: Declare some functions and variables
      perf/x86/uncore: Move NHM/SNB/IVB specific code to seperate file
      perf/x86/uncore: Move SNB/IVB-EP specific code to seperate file
      perf/x86/uncore: move NHM-EX/WSM-EX specific code to seperate file
      perf/x86/intel/uncore: Add Haswell-EP uncore support
      perf/x86/intel/uncore: Register the PMU only if the uncore pci device exists

naota@elisp.net (1):
      perf report: Set proper sort__mode for the branch option


 arch/x86/include/asm/perf_event.h                  |    8 +
 arch/x86/kernel/cpu/Makefile                       |    4 +-
 arch/x86/kernel/cpu/perf_event.c                   |   14 +-
 arch/x86/kernel/cpu/perf_event.h                   |   49 +-
 arch/x86/kernel/cpu/perf_event_intel.c             |  229 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c          |  185 +-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c         |    8 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c      | 3297 +-------------------
 arch/x86/kernel/cpu/perf_event_intel_uncore.h      |  439 +--
 .../x86/kernel/cpu/perf_event_intel_uncore_nhmex.c | 1221 ++++++++
 arch/x86/kernel/cpu/perf_event_intel_uncore_snb.c  |  636 ++++
 .../x86/kernel/cpu/perf_event_intel_uncore_snbep.c | 2258 ++++++++++++++
 include/linux/jump_label.h                         |   17 +-
 include/linux/pci_ids.h                            |    1 +
 include/linux/perf_event.h                         |   14 +-
 kernel/events/callchain.c                          |    2 +-
 kernel/events/core.c                               |  158 +-
 tools/lib/api/Makefile                             |    7 +-
 tools/lib/api/fd/array.c                           |  127 +
 tools/lib/api/fd/array.h                           |   46 +
 tools/perf/.gitignore                              |    1 +
 tools/perf/Documentation/perf-probe.txt            |    3 +
 tools/perf/Documentation/perf-report.txt           |    5 +-
 tools/perf/Documentation/perf-top.txt              |    9 +
 tools/perf/Makefile.perf                           |   11 +-
 tools/perf/arch/arm/tests/dwarf-unwind.c           |    1 +
 tools/perf/arch/arm/util/unwind-libunwind.c        |    1 +
 tools/perf/arch/arm64/include/perf_regs.h          |    2 +
 tools/perf/arch/arm64/util/unwind-libunwind.c      |    1 +
 tools/perf/arch/common.c                           |    9 +
 tools/perf/arch/powerpc/Makefile                   |    2 +-
 tools/perf/arch/powerpc/util/skip-callchain-idx.c  |    1 +
 tools/perf/bench/futex-hash.c                      |    7 +-
 tools/perf/bench/futex-requeue.c                   |   28 +-
 tools/perf/bench/futex-wake.c                      |   15 +-
 tools/perf/bench/sched-messaging.c                 |    2 +-
 tools/perf/builtin-annotate.c                      |   77 +-
 tools/perf/builtin-buildid-cache.c                 |   44 +-
 tools/perf/builtin-diff.c                          |    6 +-
 tools/perf/builtin-evlist.c                        |    2 +-
 tools/perf/builtin-help.c                          |   20 +-
 tools/perf/builtin-inject.c                        |   33 +-
 tools/perf/builtin-kmem.c                          |   56 +-
 tools/perf/builtin-kvm.c                           |   98 +-
 tools/perf/builtin-lock.c                          |    7 +-
 tools/perf/builtin-mem.c                           |    6 +-
 tools/perf/builtin-probe.c                         |   10 +-
 tools/perf/builtin-record.c                        |  146 +-
 tools/perf/builtin-report.c                        |   23 +-
 tools/perf/builtin-sched.c                         |    9 +-
 tools/perf/builtin-script.c                        |   74 +-
 tools/perf/builtin-stat.c                          |   11 +-
 tools/perf/builtin-timechart.c                     |    8 +-
 tools/perf/builtin-top.c                           |   87 +-
 tools/perf/builtin-trace.c                         |   57 +-
 tools/perf/config/Makefile                         |   52 +-
 tools/perf/config/feature-checks/Makefile          |   18 +-
 tools/perf/config/utilities.mak                    |    2 +-
 tools/perf/perf-with-kcore.sh                      |  259 ++
 tools/perf/perf.c                                  |   10 +-
 tools/perf/perf.h                                  |    3 -
 tools/perf/tests/builtin-test.c                    |   18 +-
 tools/perf/tests/fdarray.c                         |  174 ++
 tools/perf/tests/mmap-basic.c                      |    7 +-
 tools/perf/tests/open-syscall-all-cpus.c           |    5 +-
 tools/perf/tests/open-syscall-tp-fields.c          |    9 +-
 tools/perf/tests/open-syscall.c                    |    3 +-
 tools/perf/tests/perf-record.c                     |   15 +-
 tools/perf/tests/pmu.c                             |    2 +-
 tools/perf/tests/rdpmc.c                           |    6 +-
 tools/perf/tests/sw-clock.c                        |    6 +-
 tools/perf/tests/switch-tracking.c                 |  572 ++++
 tools/perf/tests/task-exit.c                       |    8 +-
 tools/perf/tests/tests.h                           |    3 +
 tools/perf/ui/browsers/hists.c                     |  384 +--
 tools/perf/ui/gtk/hists.c                          |   18 +-
 tools/perf/ui/hist.c                               |  284 +-
 tools/perf/ui/stdio/hist.c                         |    4 +-
 tools/perf/util/annotate.c                         |   21 +-
 tools/perf/util/cache.h                            |    1 +
 tools/perf/util/callchain.c                        |  240 +-
 tools/perf/util/callchain.h                        |    6 +-
 tools/perf/util/cloexec.c                          |   35 +-
 tools/perf/util/color.c                            |   16 +
 tools/perf/util/color.h                            |    1 +
 tools/perf/util/comm.c                             |    7 +-
 tools/perf/util/comm.h                             |    6 +-
 tools/perf/util/config.c                           |   40 +-
 tools/perf/util/data.c                             |    8 +-
 tools/perf/util/debug.c                            |   36 +-
 tools/perf/util/debug.h                            |   11 +
 tools/perf/util/dso.c                              |  121 +-
 tools/perf/util/dso.h                              |   16 +-
 tools/perf/util/event.c                            |   14 +-
 tools/perf/util/event.h                            |    2 +
 tools/perf/util/evlist.c                           |  236 +-
 tools/perf/util/evlist.h                           |   21 +-
 tools/perf/util/evsel.c                            |   67 +-
 tools/perf/util/evsel.h                            |    2 +
 tools/perf/util/header.c                           |   32 +-
 tools/perf/util/hist.c                             |   22 +
 tools/perf/util/hist.h                             |   18 +-
 tools/perf/util/kvm-stat.h                         |    1 -
 tools/perf/util/machine.c                          |   96 +-
 tools/perf/util/machine.h                          |   26 +-
 tools/perf/util/map.c                              |    1 +
 tools/perf/util/ordered-events.c                   |  245 ++
 tools/perf/util/ordered-events.h                   |   51 +
 tools/perf/util/parse-events.c                     |   29 +-
 tools/perf/util/parse-events.y                     |   10 +
 tools/perf/util/pmu.c                              |  121 +-
 tools/perf/util/pmu.h                              |   25 +-
 tools/perf/util/probe-event.c                      |  181 +-
 tools/perf/util/probe-event.h                      |    3 +-
 tools/perf/util/probe-finder.c                     |   23 +-
 tools/perf/util/python.c                           |    6 +-
 tools/perf/util/record.c                           |   40 +-
 tools/perf/util/run-command.c                      |    9 +-
 .../perf/util/scripting-engines/trace-event-perl.c |    6 +
 .../util/scripting-engines/trace-event-python.c    |  120 +-
 tools/perf/util/session.c                          |  300 +-
 tools/perf/util/session.h                          |   32 +-
 tools/perf/util/sort.c                             |  119 +-
 tools/perf/util/sort.h                             |    1 +
 tools/perf/util/symbol-elf.c                       |   31 +-
 tools/perf/util/symbol.c                           |   43 +-
 tools/perf/util/symbol.h                           |   14 +-
 tools/perf/util/thread.c                           |   24 +-
 tools/perf/util/thread.h                           |   10 +-
 tools/perf/util/tool.h                             |    2 +-
 tools/perf/util/trace-event-scripting.c            |    7 +
 tools/perf/util/trace-event.h                      |    1 +
 tools/perf/util/util.c                             |   54 +-
 tools/perf/util/util.h                             |   23 +-
 134 files changed, 8901 insertions(+), 5186 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_uncore_nhmex.c
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_uncore_snb.c
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
 create mode 100644 tools/lib/api/fd/array.c
 create mode 100644 tools/lib/api/fd/array.h
 create mode 100644 tools/perf/perf-with-kcore.sh
 create mode 100644 tools/perf/tests/fdarray.c
 create mode 100644 tools/perf/tests/switch-tracking.c
 create mode 100644 tools/perf/util/ordered-events.c
 create mode 100644 tools/perf/util/ordered-events.h

[ full diff omitted due to lkml mail size restrictions. ]
