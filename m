Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbaFCL6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:58:31 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39870 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbaFCL6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:58:19 -0400
Date: Tue, 3 Jun 2014 13:58:07 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf changes for v3.16
Message-ID: <20140603115806.GA23878@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-core-for-linus

   # HEAD: e450f90e8c7d0bf70519223c1b848446ae63f313 Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/core


Tooling changes, maintained by Jiri Olsa until Arnaldo is on vacation:

User visible changes:

  * Add -F option for specifying output fields (Namhyung Kim)

  * Propagate exit status of a command line workload for
    record command (Namhyung Kim)

  * Use tid for finding thread (Namhyung Kim)

  * Clarify the output of perf sched map plus small sched
    command fixies (Dongsheng Yang)

  * Wire up perf_regs and unwind support for ARM64 (Jean Pihet)

  * Factor hists statistics counts processing which in turn also
    fixes several bugs in TUI report command (Namhyung Kim)

  * Add --percentage option to control absolute/relative percentage output (Namhyung Kim)

  * Add --list-cmds to 'kmem', 'mem', 'lock' and 'sched', for use by completion scripts (Ramkumar Ramachandra)


Development/infrastructure changes and fixes:

  * Android related fixes for pager and map dso resolving (Michael Lentine)

  * Add libdw DWARF post unwind support for ARM (Jean Pihet)

  * Consolidate types.h for ARM and ARM64 (Jean Pihet)

  * Fix possible null pointer dereference in session.c (Masanari Iida)

  * Cleanup, remove unused variables in map_switch_event() (Dongsheng Yang)

  * Remove nr_state_machine_bugs in perf latency (Dongsheng Yang)

  * Remove usage of trace_sched_wakeup(.success) (Peter Zijlstra)

  * Cleanups for perf.h header (Jiri Olsa)

  * Consolidate types.h and export.h within tools (Borislav Petkov)

  * Move u64_swap union to its single user's header, evsel.h (Borislav Petkov)

  * Fix for s390 to properly parse tracepoints plus test code (Alexander Yarygin)

  * Handle EINTR error for readn/writen (Namhyung Kim)

  * Add a test case for hists filtering (Namhyung Kim)

  * Share map_groups among threads of the same group (Arnaldo Carvalho de Melo, Jiri Olsa)

  * Making some code (cpu node map and report parse callchain callback) global
    to be usable by upcomming changes (Don Zickus)

  * Fix pmu object compilation error (Jiri Olsa)


Kernel side changes:

  * intrusive uprobes fixes from Oleg Nesterov. Since the interface is 
    admin-only, and the bug only affects user-space ("any probed
    jmp/call can kill the application"), we queued these fixes via the
    development tree, as a special exception.

  * more fuzzer motivated race fixes and related 
    refactorings/robustization.

  * allow PMU drivers to be built as modules. (No actual module yet, 
    because the x86 Intel uncore module wasn't ready in time for 
    this.)


 Thanks,

	Ingo

------------------>
Alexander Yarygin (3):
      perf tools: Parse tracepoints with '-' in system name
      perf tests: Add numeric identifier to evlist_test
      perf tests: Add a test of kvm-390: trace event

Arnaldo Carvalho de Melo (2):
      perf tools: Allocate thread map_groups's dynamically
      perf tools: Reference count map_groups objects

Borislav Petkov (4):
      perf tools: Move u64_swap union
      tools: Unify export.h
      tools: Consolidate types.h
      perf/events/core: Drop unused variable after cleanup

Don Zickus (4):
      perf tools: Allow ability to map cpus to nodes easily
      perf tools: Use cpu/possible instead of cpu/kernel_max
      perf kmem: Utilize the new generic cpunode_map
      perf callchain: Add generic report parse callchain callback function

Dongsheng (3):
      perf tools: Add missing event for perf sched record.
      perf tools: Adapt the TASK_STATE_TO_CHAR_STR to new value in kernel space.
      perf tools: Clarify the output of perf sched map.

Dongsheng Yang (2):
      perf sched: Remove nr_state_machine_bugs in perf latency
      perf sched: Cleanup, remove unused variables in map_switch_event()

Jean Pihet (5):
      perf tools ARM64: Wire up perf_regs and unwind support
      perf tools: Consolidate types.h for ARM and ARM64
      perf tests: Introduce perf_regs_load function on ARM
      perf tests: Add dwarf unwind test on ARM
      perf tools: Add libdw DWARF post unwind support for ARM

Jiri Olsa (14):
      perf tools: Fix pmu object compilation error
      perf tests: Add thread maps lookup automated tests
      perf tools: Share map_groups among threads of the same group
      perf tests: Add map groups sharing with thread object test
      perf tools: Remove MAX_COUNTERS define from perf.h
      perf tools: Remove unlikely define from perf.h
      perf tools: Remove min define from perf.h
      perf tools: Remove asmlinkage define from perf.h
      perf tools: Remove PR_TASK_PERF_EVENTS_* from perf.h
      perf tools: Move sample data structures from perf.h
      perf tools: Move perf_call_graph_mode enum from perf.h
      perf tools: Move syscall and arch specific defines from perf.h
      perf tools: Move sys_perf_event_open function from perf.h
      perf tools: Move ACCESS_ONCE from perf.h header

Masanari Iida (1):
      perf session: Fix possible null pointer dereference in session.c

Michael Lentine (2):
      perf tools: Add cat as fallback pager
      perf tools: Add automatic remapping of Android libraries

Namhyung Kim (44):
      perf hists: Add support for showing relative percentage
      perf report: Add --percentage option
      perf top: Add --percentage option
      perf diff: Add --percentage option
      perf tools: Add hist.percentage config option
      perf ui/tui: Add 'F' hotkey to toggle percentage output
      perf tools: Show absolute percentage by default
      perf report: Count number of entries separately
      perf hists: Rename hists__inc_stats()
      perf hists: Move column length calculation out of hists__inc_stats()
      perf hists: Add a couple of hists stat helper functions
      perf hists: Collapse expanded callchains after filter is applied
      perf tools: Account entry stats when it's added to the output tree
      perf hists: Add missing update on filtered stats in hists__decay_entries()
      perf ui/tui: Fix off-by-one in hist_browser__update_nr_entries()
      perf ui/tui: Rename hist_browser__update_nr_entries()
      perf top/tui: Update nr_entries properly after a filter is applied
      perf hists/tui: Count callchain rows separately
      perf tests: Factor out fake_setup_machine()
      perf tests: Add a test case for hists filtering
      perf tools: Handle EINTR error for readn/writen
      perf record: Propagate exit status of a command line workload
      perf tools: Get rid of on_exit() feature test
      perf tools: Use tid for finding thread
      perf tools: Add ->cmp(), ->collapse() and ->sort() to perf_hpp_fmt
      perf tools: Convert sort entries to hpp formats
      perf tools: Use hpp formats to sort hist entries
      perf tools: Support event grouping in hpp ->sort()
      perf tools: Use hpp formats to sort final output
      perf tools: Consolidate output field handling to hpp format routines
      perf ui: Get rid of callback from __hpp__fmt()
      perf tools: Allow hpp fields to be sort keys
      perf tools: Consolidate management of default sort orders
      perf tools: Call perf_hpp__init() before setting up GUI browsers
      perf report: Add -F option to specify output fields
      perf tools: Add ->sort() member to struct sort_entry
      perf report/tui: Fix a bug when --fields/sort is given
      perf top: Add --fields option to specify output fields
      perf tools: Skip elided sort entries
      perf hists: Reset width of output fields with header length
      perf tools: Get rid of obsolete hist_entry__sort_list
      perf tools: Introduce reset_output_field()
      perf tests: Factor out print_hists_*()
      perf tests: Add a testcase for histogram output sorting

Oleg Nesterov (15):
      uprobes: Kill UPROBE_SKIP_SSTEP and can_skip_sstep()
      uprobes/x86: Fold prepare_fixups() into arch_uprobe_analyze_insn()
      uprobes/x86: Kill the "ia32_compat" check in handle_riprel_insn(), remove "mm" arg
      uprobes/x86: Gather "riprel" functions together
      uprobes/x86: move the UPROBE_FIX_{RIP,IP,CALL} code at the end of pre/post hooks
      uprobes/x86: Introduce uprobe_xol_ops and arch_uprobe->ops
      uprobes/x86: Conditionalize the usage of handle_riprel_insn()
      uprobes/x86: Send SIGILL if arch_uprobe_post_xol() fails
      uprobes/x86: Teach arch_uprobe_post_xol() to restart if possible
      uprobes/x86: Introduce sizeof_long(), cleanup adjust_ret_addr() and arch_uretprobe_hijack_return_addr()
      uprobes/x86: Emulate unconditional relative jmp's
      uprobes/x86: Emulate nop's using ops->emulate()
      uprobes/x86: Emulate relative call's
      uprobes/x86: Emulate relative conditional "short" jmp's
      uprobes/x86: Emulate relative conditional "near" jmp's

Peter Zijlstra (7):
      perf: Ensure consistent inherit state in groups
      perf: Always destroy groups on exit
      perf: Validate locking assumption
      perf: Rework free paths
      perf: Simplify perf_event_exit_task_context()
      perf tools: Remove usage of trace_sched_wakeup(.success)
      perf: Fix perf_event_open(.flags) test

Ramkumar Ramachandra (4):
      perf kmem: Introduce --list-cmds for use by scripts
      perf mem: Introduce --list-cmds for use by scripts
      perf lock: Introduce --list-cmds for use by scripts
      perf sched: Introduce --list-cmds for use by scripts

Stephane Eranian (1):
      fix Haswell precise store data source encoding

Yan, Zheng (3):
      perf: Allow building PMU drivers as modules
      hrtimer: Export __hrtimer_start_range_ns()
      perf/x86: Export perf_assign_events()


 arch/x86/include/asm/uprobes.h                     |  16 +-
 arch/x86/kernel/cpu/perf_event.c                   |   1 +
 arch/x86/kernel/cpu/perf_event_intel_ds.c          |  22 +-
 arch/x86/kernel/uprobes.c                          | 551 +++++++++++-------
 include/linux/perf_event.h                         |   1 +
 include/uapi/linux/perf_event.h                    |   8 +-
 kernel/events/core.c                               | 117 ++--
 kernel/events/uprobes.c                            |  31 +-
 kernel/hrtimer.c                                   |   1 +
 tools/include/linux/compiler.h                     |   2 +
 tools/{virtio => include}/linux/export.h           |   5 +
 .../lockdep/uinclude => include}/linux/types.h     |  29 +-
 tools/lib/lockdep/Makefile                         |   2 +-
 tools/lib/lockdep/uinclude/linux/export.h          |   7 -
 tools/perf/Documentation/perf-diff.txt             |  26 +-
 tools/perf/Documentation/perf-report.txt           |  43 +-
 tools/perf/Documentation/perf-top.txt              |  32 +-
 tools/perf/MANIFEST                                |   2 +
 tools/perf/Makefile.perf                           |  12 +-
 tools/perf/arch/arm/Makefile                       |   7 +
 tools/perf/arch/arm/include/perf_regs.h            |   7 +-
 tools/perf/arch/arm/tests/dwarf-unwind.c           |  60 ++
 tools/perf/arch/arm/tests/regs_load.S              |  58 ++
 tools/perf/arch/arm/util/unwind-libdw.c            |  36 ++
 tools/perf/arch/arm64/Makefile                     |   7 +
 tools/perf/arch/arm64/include/perf_regs.h          |  88 +++
 tools/perf/arch/arm64/util/dwarf-regs.c            |  80 +++
 tools/perf/arch/arm64/util/unwind-libunwind.c      |  82 +++
 tools/perf/arch/x86/include/perf_regs.h            |   2 +-
 tools/perf/arch/x86/tests/dwarf-unwind.c           |   2 +-
 tools/perf/arch/x86/util/tsc.c                     |   2 +-
 tools/perf/arch/x86/util/tsc.h                     |   2 +-
 tools/perf/builtin-annotate.c                      |   3 +-
 tools/perf/builtin-diff.c                          |  50 +-
 tools/perf/builtin-inject.c                        |   2 +-
 tools/perf/builtin-kmem.c                          |  88 +--
 tools/perf/builtin-lock.c                          |  10 +-
 tools/perf/builtin-mem.c                           |  15 +-
 tools/perf/builtin-record.c                        | 158 ++----
 tools/perf/builtin-report.c                        | 196 ++-----
 tools/perf/builtin-sched.c                         |  80 ++-
 tools/perf/builtin-top.c                           |  28 +-
 tools/perf/config/Makefile                         |  20 +-
 tools/perf/config/feature-checks/Makefile          |   4 -
 tools/perf/config/feature-checks/test-all.c        |   5 -
 tools/perf/config/feature-checks/test-on-exit.c    |  16 -
 tools/perf/perf-completion.sh                      |   4 +-
 tools/perf/perf-sys.h                              | 190 +++++++
 tools/perf/perf.h                                  | 248 +--------
 tools/perf/tests/attr.c                            |   7 -
 tools/perf/tests/builtin-test.c                    |  18 +-
 tools/perf/tests/code-reading.c                    |   5 +-
 tools/perf/tests/dso-data.c                        |   2 +-
 tools/perf/tests/dwarf-unwind.c                    |   2 +-
 tools/perf/tests/evsel-tp-sched.c                  |   3 -
 tools/perf/tests/hists_common.c                    | 205 +++++++
 tools/perf/tests/hists_common.h                    |  47 ++
 tools/perf/tests/hists_filter.c                    | 290 ++++++++++
 tools/perf/tests/hists_link.c                      | 173 +-----
 tools/perf/tests/hists_output.c                    | 618 +++++++++++++++++++++
 tools/perf/tests/keep-tracking.c                   |   2 +-
 tools/perf/tests/mmap-thread-lookup.c              | 233 ++++++++
 tools/perf/tests/parse-events.c                    | 142 +++--
 tools/perf/tests/parse-no-sample-id-all.c          |   2 +-
 tools/perf/tests/perf-time-to-tsc.c                |   3 +-
 tools/perf/tests/rdpmc.c                           |   2 +-
 tools/perf/tests/sample-parsing.c                  |   2 +-
 tools/perf/tests/tests.h                           |   6 +-
 tools/perf/tests/thread-mg-share.c                 |  90 +++
 tools/perf/ui/browser.h                            |   4 +-
 tools/perf/ui/browsers/hists.c                     | 233 ++++----
 tools/perf/ui/gtk/hists.c                          |  52 +-
 tools/perf/ui/hist.c                               | 252 +++++++--
 tools/perf/ui/progress.h                           |   2 +-
 tools/perf/ui/setup.c                              |   2 -
 tools/perf/ui/stdio/hist.c                         |  81 ++-
 tools/perf/util/annotate.h                         |   2 +-
 tools/perf/util/build-id.c                         |   2 +-
 tools/perf/util/build-id.h                         |   2 +-
 tools/perf/util/callchain.c                        |  78 +++
 tools/perf/util/callchain.h                        |   8 +
 tools/perf/util/config.c                           |   4 +
 tools/perf/util/cpumap.c                           | 160 ++++++
 tools/perf/util/cpumap.h                           |  35 ++
 tools/perf/util/dso.h                              |   2 +-
 tools/perf/util/event.c                            |   4 +-
 tools/perf/util/event.h                            |  24 +
 tools/perf/util/evsel.h                            |   9 +-
 tools/perf/util/header.h                           |   4 +-
 tools/perf/util/hist.c                             | 187 ++++---
 tools/perf/util/hist.h                             |  46 +-
 tools/perf/util/include/linux/bitmap.h             |   3 +
 tools/perf/util/include/linux/export.h             |   6 -
 tools/perf/util/include/linux/list.h               |   1 +
 tools/perf/util/include/linux/types.h              |  29 -
 tools/perf/util/machine.c                          |  11 +
 tools/perf/util/map.c                              | 118 +++-
 tools/perf/util/map.h                              |  14 +-
 tools/perf/util/pager.c                            |  12 +-
 tools/perf/util/parse-events.h                     |   3 +-
 tools/perf/util/parse-events.y                     |  14 +-
 tools/perf/util/perf_regs.h                        |   2 +-
 tools/perf/util/pmu.c                              |   6 +-
 tools/perf/util/pmu.h                              |   2 +-
 tools/perf/util/session.c                          |   5 +-
 tools/perf/util/sort.c                             | 436 ++++++++++++++-
 tools/perf/util/sort.h                             |   6 +
 tools/perf/util/stat.h                             |   2 +-
 tools/perf/util/svghelper.c                        |   2 +-
 tools/perf/util/svghelper.h                        |   2 +-
 tools/perf/util/symbol.h                           |   4 +-
 tools/perf/util/thread.c                           |  52 +-
 tools/perf/util/thread.h                           |   3 +-
 tools/perf/util/top.h                              |   2 +-
 tools/perf/util/types.h                            |  24 -
 tools/perf/util/unwind-libdw.c                     |   2 +-
 tools/perf/util/unwind.h                           |   2 +-
 tools/perf/util/util.c                             |   2 +
 tools/perf/util/util.h                             |   2 +-
 tools/perf/util/values.h                           |   2 +-
 tools/virtio/Makefile                              |   2 +-
 tools/virtio/linux/kernel.h                        |   7 -
 tools/virtio/linux/types.h                         |  28 -
 123 files changed, 4591 insertions(+), 1718 deletions(-)
 rename tools/{virtio => include}/linux/export.h (70%)
 rename tools/{lib/lockdep/uinclude => include}/linux/types.h (63%)
 delete mode 100644 tools/lib/lockdep/uinclude/linux/export.h
 create mode 100644 tools/perf/arch/arm/tests/dwarf-unwind.c
 create mode 100644 tools/perf/arch/arm/tests/regs_load.S
 create mode 100644 tools/perf/arch/arm/util/unwind-libdw.c
 create mode 100644 tools/perf/arch/arm64/Makefile
 create mode 100644 tools/perf/arch/arm64/include/perf_regs.h
 create mode 100644 tools/perf/arch/arm64/util/dwarf-regs.c
 create mode 100644 tools/perf/arch/arm64/util/unwind-libunwind.c
 delete mode 100644 tools/perf/config/feature-checks/test-on-exit.c
 create mode 100644 tools/perf/perf-sys.h
 create mode 100644 tools/perf/tests/hists_common.c
 create mode 100644 tools/perf/tests/hists_common.h
 create mode 100644 tools/perf/tests/hists_filter.c
 create mode 100644 tools/perf/tests/hists_output.c
 create mode 100644 tools/perf/tests/mmap-thread-lookup.c
 create mode 100644 tools/perf/tests/thread-mg-share.c
 delete mode 100644 tools/perf/util/include/linux/export.h
 delete mode 100644 tools/perf/util/include/linux/types.h
 delete mode 100644 tools/perf/util/types.h
 delete mode 100644 tools/virtio/linux/types.h

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index 3087ea9..93bee7b 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -33,15 +33,27 @@ typedef u8 uprobe_opcode_t;
 #define UPROBE_SWBP_INSN		0xcc
 #define UPROBE_SWBP_INSN_SIZE		   1
 
+struct uprobe_xol_ops;
+
 struct arch_uprobe {
-	u16				fixups;
 	union {
 		u8			insn[MAX_UINSN_BYTES];
 		u8			ixol[MAX_UINSN_BYTES];
 	};
+
+	u16				fixups;
+	const struct uprobe_xol_ops	*ops;
+
+	union {
 #ifdef CONFIG_X86_64
-	unsigned long			rip_rela_target_address;
+		unsigned long			rip_rela_target_address;
 #endif
+		struct {
+			s32	offs;
+			u8	ilen;
+			u8	opc1;
+		}				branch;
+	};
 };
 
 struct arch_uprobe_task {
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ae407f7..89f3b7c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -721,6 +721,7 @@ int perf_assign_events(struct perf_event **events, int n,
 
 	return sched.state.unassigned;
 }
+EXPORT_SYMBOL_GPL(perf_assign_events);
 
 int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 {
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index ae96cfa..980970c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -108,15 +108,31 @@ static u64 precise_store_data(u64 status)
 	return val;
 }
 
-static u64 precise_store_data_hsw(u64 status)
+static u64 precise_store_data_hsw(struct perf_event *event, u64 status)
 {
 	union perf_mem_data_src dse;
+	u64 cfg = event->hw.config & INTEL_ARCH_EVENT_MASK;
 
 	dse.val = 0;
 	dse.mem_op = PERF_MEM_OP_STORE;
 	dse.mem_lvl = PERF_MEM_LVL_NA;
+
+	/*
+	 * L1 info only valid for following events:
+	 *
+	 * MEM_UOPS_RETIRED.STLB_MISS_STORES
+	 * MEM_UOPS_RETIRED.LOCK_STORES
+	 * MEM_UOPS_RETIRED.SPLIT_STORES
+	 * MEM_UOPS_RETIRED.ALL_STORES
+	 */
+	if (cfg != 0x12d0 && cfg != 0x22d0 && cfg != 0x42d0 && cfg != 0x82d0)
+		return dse.mem_lvl;
+
 	if (status & 1)
-		dse.mem_lvl = PERF_MEM_LVL_L1;
+		dse.mem_lvl = PERF_MEM_LVL_L1 | PERF_MEM_LVL_HIT;
+	else
+		dse.mem_lvl = PERF_MEM_LVL_L1 | PERF_MEM_LVL_MISS;
+
 	/* Nothing else supported. Sorry. */
 	return dse.val;
 }
@@ -887,7 +903,7 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 				data.data_src.val = load_latency_data(pebs->dse);
 			else if (event->hw.flags & PERF_X86_EVENT_PEBS_ST_HSW)
 				data.data_src.val =
-					precise_store_data_hsw(pebs->dse);
+					precise_store_data_hsw(event, pebs->dse);
 			else
 				data.data_src.val = precise_store_data(pebs->dse);
 		}
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 2ed8459..ace2291 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -53,7 +53,7 @@
 #define OPCODE1(insn)		((insn)->opcode.bytes[0])
 #define OPCODE2(insn)		((insn)->opcode.bytes[1])
 #define OPCODE3(insn)		((insn)->opcode.bytes[2])
-#define MODRM_REG(insn)		X86_MODRM_REG(insn->modrm.value)
+#define MODRM_REG(insn)		X86_MODRM_REG((insn)->modrm.value)
 
 #define W(row, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)\
 	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
@@ -229,63 +229,6 @@ static int validate_insn_32bits(struct arch_uprobe *auprobe, struct insn *insn)
 	return -ENOTSUPP;
 }
 
-/*
- * Figure out which fixups arch_uprobe_post_xol() will need to perform, and
- * annotate arch_uprobe->fixups accordingly.  To start with,
- * arch_uprobe->fixups is either zero or it reflects rip-related fixups.
- */
-static void prepare_fixups(struct arch_uprobe *auprobe, struct insn *insn)
-{
-	bool fix_ip = true, fix_call = false;	/* defaults */
-	int reg;
-
-	insn_get_opcode(insn);	/* should be a nop */
-
-	switch (OPCODE1(insn)) {
-	case 0x9d:
-		/* popf */
-		auprobe->fixups |= UPROBE_FIX_SETF;
-		break;
-	case 0xc3:		/* ret/lret */
-	case 0xcb:
-	case 0xc2:
-	case 0xca:
-		/* ip is correct */
-		fix_ip = false;
-		break;
-	case 0xe8:		/* call relative - Fix return addr */
-		fix_call = true;
-		break;
-	case 0x9a:		/* call absolute - Fix return addr, not ip */
-		fix_call = true;
-		fix_ip = false;
-		break;
-	case 0xff:
-		insn_get_modrm(insn);
-		reg = MODRM_REG(insn);
-		if (reg == 2 || reg == 3) {
-			/* call or lcall, indirect */
-			/* Fix return addr; ip is correct. */
-			fix_call = true;
-			fix_ip = false;
-		} else if (reg == 4 || reg == 5) {
-			/* jmp or ljmp, indirect */
-			/* ip is correct. */
-			fix_ip = false;
-		}
-		break;
-	case 0xea:		/* jmp absolute -- ip is correct */
-		fix_ip = false;
-		break;
-	default:
-		break;
-	}
-	if (fix_ip)
-		auprobe->fixups |= UPROBE_FIX_IP;
-	if (fix_call)
-		auprobe->fixups |= UPROBE_FIX_CALL;
-}
-
 #ifdef CONFIG_X86_64
 /*
  * If arch_uprobe->insn doesn't use rip-relative addressing, return
@@ -310,15 +253,11 @@ static void prepare_fixups(struct arch_uprobe *auprobe, struct insn *insn)
  *  - The displacement is always 4 bytes.
  */
 static void
-handle_riprel_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, struct insn *insn)
+handle_riprel_insn(struct arch_uprobe *auprobe, struct insn *insn)
 {
 	u8 *cursor;
 	u8 reg;
 
-	if (mm->context.ia32_compat)
-		return;
-
-	auprobe->rip_rela_target_address = 0x0;
 	if (!insn_rip_relative(insn))
 		return;
 
@@ -372,7 +311,48 @@ handle_riprel_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, struct ins
 		cursor++;
 		memmove(cursor, cursor + insn->displacement.nbytes, insn->immediate.nbytes);
 	}
-	return;
+}
+
+/*
+ * If we're emulating a rip-relative instruction, save the contents
+ * of the scratch register and store the target address in that register.
+ */
+static void
+pre_xol_rip_insn(struct arch_uprobe *auprobe, struct pt_regs *regs,
+				struct arch_uprobe_task *autask)
+{
+	if (auprobe->fixups & UPROBE_FIX_RIP_AX) {
+		autask->saved_scratch_register = regs->ax;
+		regs->ax = current->utask->vaddr;
+		regs->ax += auprobe->rip_rela_target_address;
+	} else if (auprobe->fixups & UPROBE_FIX_RIP_CX) {
+		autask->saved_scratch_register = regs->cx;
+		regs->cx = current->utask->vaddr;
+		regs->cx += auprobe->rip_rela_target_address;
+	}
+}
+
+static void
+handle_riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs, long *correction)
+{
+	if (auprobe->fixups & (UPROBE_FIX_RIP_AX | UPROBE_FIX_RIP_CX)) {
+		struct arch_uprobe_task *autask;
+
+		autask = &current->utask->autask;
+		if (auprobe->fixups & UPROBE_FIX_RIP_AX)
+			regs->ax = autask->saved_scratch_register;
+		else
+			regs->cx = autask->saved_scratch_register;
+
+		/*
+		 * The original instruction includes a displacement, and so
+		 * is 4 bytes longer than what we've just single-stepped.
+		 * Caller may need to apply other fixups to handle stuff
+		 * like "jmpq *...(%rip)" and "callq *...(%rip)".
+		 */
+		if (correction)
+			*correction += 4;
+	}
 }
 
 static int validate_insn_64bits(struct arch_uprobe *auprobe, struct insn *insn)
@@ -401,9 +381,19 @@ static int validate_insn_bits(struct arch_uprobe *auprobe, struct mm_struct *mm,
 	return validate_insn_64bits(auprobe, insn);
 }
 #else /* 32-bit: */
-static void handle_riprel_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, struct insn *insn)
+/*
+ * No RIP-relative addressing on 32-bit
+ */
+static void handle_riprel_insn(struct arch_uprobe *auprobe, struct insn *insn)
+{
+}
+static void pre_xol_rip_insn(struct arch_uprobe *auprobe, struct pt_regs *regs,
+				struct arch_uprobe_task *autask)
+{
+}
+static void handle_riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs,
+					long *correction)
 {
-	/* No RIP-relative addressing on 32-bit */
 }
 
 static int validate_insn_bits(struct arch_uprobe *auprobe, struct mm_struct *mm,  struct insn *insn)
@@ -412,141 +402,311 @@ static int validate_insn_bits(struct arch_uprobe *auprobe, struct mm_struct *mm,
 }
 #endif /* CONFIG_X86_64 */
 
-/**
- * arch_uprobe_analyze_insn - instruction analysis including validity and fixups.
- * @mm: the probed address space.
- * @arch_uprobe: the probepoint information.
- * @addr: virtual address at which to install the probepoint
- * Return 0 on success or a -ve number on error.
+struct uprobe_xol_ops {
+	bool	(*emulate)(struct arch_uprobe *, struct pt_regs *);
+	int	(*pre_xol)(struct arch_uprobe *, struct pt_regs *);
+	int	(*post_xol)(struct arch_uprobe *, struct pt_regs *);
+};
+
+static inline int sizeof_long(void)
+{
+	return is_ia32_task() ? 4 : 8;
+}
+
+static int default_pre_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	pre_xol_rip_insn(auprobe, regs, &current->utask->autask);
+	return 0;
+}
+
+/*
+ * Adjust the return address pushed by a call insn executed out of line.
  */
-int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long addr)
+static int adjust_ret_addr(unsigned long sp, long correction)
 {
-	int ret;
-	struct insn insn;
+	int rasize = sizeof_long();
+	long ra;
 
-	auprobe->fixups = 0;
-	ret = validate_insn_bits(auprobe, mm, &insn);
-	if (ret != 0)
-		return ret;
+	if (copy_from_user(&ra, (void __user *)sp, rasize))
+		return -EFAULT;
 
-	handle_riprel_insn(auprobe, mm, &insn);
-	prepare_fixups(auprobe, &insn);
+	ra += correction;
+	if (copy_to_user((void __user *)sp, &ra, rasize))
+		return -EFAULT;
 
 	return 0;
 }
 
-#ifdef CONFIG_X86_64
-/*
- * If we're emulating a rip-relative instruction, save the contents
- * of the scratch register and store the target address in that register.
- */
-static void
-pre_xol_rip_insn(struct arch_uprobe *auprobe, struct pt_regs *regs,
-				struct arch_uprobe_task *autask)
+static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-	if (auprobe->fixups & UPROBE_FIX_RIP_AX) {
-		autask->saved_scratch_register = regs->ax;
-		regs->ax = current->utask->vaddr;
-		regs->ax += auprobe->rip_rela_target_address;
-	} else if (auprobe->fixups & UPROBE_FIX_RIP_CX) {
-		autask->saved_scratch_register = regs->cx;
-		regs->cx = current->utask->vaddr;
-		regs->cx += auprobe->rip_rela_target_address;
+	struct uprobe_task *utask = current->utask;
+	long correction = (long)(utask->vaddr - utask->xol_vaddr);
+
+	handle_riprel_post_xol(auprobe, regs, &correction);
+	if (auprobe->fixups & UPROBE_FIX_IP)
+		regs->ip += correction;
+
+	if (auprobe->fixups & UPROBE_FIX_CALL) {
+		if (adjust_ret_addr(regs->sp, correction)) {
+			regs->sp += sizeof_long();
+			return -ERESTART;
+		}
 	}
+
+	return 0;
 }
-#else
-static void
-pre_xol_rip_insn(struct arch_uprobe *auprobe, struct pt_regs *regs,
-				struct arch_uprobe_task *autask)
+
+static struct uprobe_xol_ops default_xol_ops = {
+	.pre_xol  = default_pre_xol_op,
+	.post_xol = default_post_xol_op,
+};
+
+static bool branch_is_call(struct arch_uprobe *auprobe)
 {
-	/* No RIP-relative addressing on 32-bit */
+	return auprobe->branch.opc1 == 0xe8;
 }
-#endif
 
-/*
- * arch_uprobe_pre_xol - prepare to execute out of line.
- * @auprobe: the probepoint information.
- * @regs: reflects the saved user state of current task.
- */
-int arch_uprobe_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
-{
-	struct arch_uprobe_task *autask;
+#define CASE_COND					\
+	COND(70, 71, XF(OF))				\
+	COND(72, 73, XF(CF))				\
+	COND(74, 75, XF(ZF))				\
+	COND(78, 79, XF(SF))				\
+	COND(7a, 7b, XF(PF))				\
+	COND(76, 77, XF(CF) || XF(ZF))			\
+	COND(7c, 7d, XF(SF) != XF(OF))			\
+	COND(7e, 7f, XF(ZF) || XF(SF) != XF(OF))
 
-	autask = &current->utask->autask;
-	autask->saved_trap_nr = current->thread.trap_nr;
-	current->thread.trap_nr = UPROBE_TRAP_NR;
-	regs->ip = current->utask->xol_vaddr;
-	pre_xol_rip_insn(auprobe, regs, autask);
+#define COND(op_y, op_n, expr)				\
+	case 0x ## op_y: DO((expr) != 0)		\
+	case 0x ## op_n: DO((expr) == 0)
 
-	autask->saved_tf = !!(regs->flags & X86_EFLAGS_TF);
-	regs->flags |= X86_EFLAGS_TF;
-	if (test_tsk_thread_flag(current, TIF_BLOCKSTEP))
-		set_task_blockstep(current, false);
+#define XF(xf)	(!!(flags & X86_EFLAGS_ ## xf))
 
-	return 0;
+static bool is_cond_jmp_opcode(u8 opcode)
+{
+	switch (opcode) {
+	#define DO(expr)	\
+		return true;
+	CASE_COND
+	#undef	DO
+
+	default:
+		return false;
+	}
 }
 
-/*
- * This function is called by arch_uprobe_post_xol() to adjust the return
- * address pushed by a call instruction executed out of line.
- */
-static int adjust_ret_addr(unsigned long sp, long correction)
+static bool check_jmp_cond(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-	int rasize, ncopied;
-	long ra = 0;
+	unsigned long flags = regs->flags;
 
-	if (is_ia32_task())
-		rasize = 4;
-	else
-		rasize = 8;
+	switch (auprobe->branch.opc1) {
+	#define DO(expr)	\
+		return expr;
+	CASE_COND
+	#undef	DO
 
-	ncopied = copy_from_user(&ra, (void __user *)sp, rasize);
-	if (unlikely(ncopied))
-		return -EFAULT;
+	default:	/* not a conditional jmp */
+		return true;
+	}
+}
 
-	ra += correction;
-	ncopied = copy_to_user((void __user *)sp, &ra, rasize);
-	if (unlikely(ncopied))
-		return -EFAULT;
+#undef	XF
+#undef	COND
+#undef	CASE_COND
 
-	return 0;
+static bool branch_emulate_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	unsigned long new_ip = regs->ip += auprobe->branch.ilen;
+	unsigned long offs = (long)auprobe->branch.offs;
+
+	if (branch_is_call(auprobe)) {
+		unsigned long new_sp = regs->sp - sizeof_long();
+		/*
+		 * If it fails we execute this (mangled, see the comment in
+		 * branch_clear_offset) insn out-of-line. In the likely case
+		 * this should trigger the trap, and the probed application
+		 * should die or restart the same insn after it handles the
+		 * signal, arch_uprobe_post_xol() won't be even called.
+		 *
+		 * But there is corner case, see the comment in ->post_xol().
+		 */
+		if (copy_to_user((void __user *)new_sp, &new_ip, sizeof_long()))
+			return false;
+		regs->sp = new_sp;
+	} else if (!check_jmp_cond(auprobe, regs)) {
+		offs = 0;
+	}
+
+	regs->ip = new_ip + offs;
+	return true;
 }
 
-#ifdef CONFIG_X86_64
-static bool is_riprel_insn(struct arch_uprobe *auprobe)
+static int branch_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-	return ((auprobe->fixups & (UPROBE_FIX_RIP_AX | UPROBE_FIX_RIP_CX)) != 0);
+	BUG_ON(!branch_is_call(auprobe));
+	/*
+	 * We can only get here if branch_emulate_op() failed to push the ret
+	 * address _and_ another thread expanded our stack before the (mangled)
+	 * "call" insn was executed out-of-line. Just restore ->sp and restart.
+	 * We could also restore ->ip and try to call branch_emulate_op() again.
+	 */
+	regs->sp += sizeof_long();
+	return -ERESTART;
 }
 
-static void
-handle_riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs, long *correction)
+static void branch_clear_offset(struct arch_uprobe *auprobe, struct insn *insn)
 {
-	if (is_riprel_insn(auprobe)) {
-		struct arch_uprobe_task *autask;
+	/*
+	 * Turn this insn into "call 1f; 1:", this is what we will execute
+	 * out-of-line if ->emulate() fails. We only need this to generate
+	 * a trap, so that the probed task receives the correct signal with
+	 * the properly filled siginfo.
+	 *
+	 * But see the comment in ->post_xol(), in the unlikely case it can
+	 * succeed. So we need to ensure that the new ->ip can not fall into
+	 * the non-canonical area and trigger #GP.
+	 *
+	 * We could turn it into (say) "pushf", but then we would need to
+	 * divorce ->insn[] and ->ixol[]. We need to preserve the 1st byte
+	 * of ->insn[] for set_orig_insn().
+	 */
+	memset(auprobe->insn + insn_offset_immediate(insn),
+		0, insn->immediate.nbytes);
+}
 
-		autask = &current->utask->autask;
-		if (auprobe->fixups & UPROBE_FIX_RIP_AX)
-			regs->ax = autask->saved_scratch_register;
-		else
-			regs->cx = autask->saved_scratch_register;
+static struct uprobe_xol_ops branch_xol_ops = {
+	.emulate  = branch_emulate_op,
+	.post_xol = branch_post_xol_op,
+};
+
+/* Returns -ENOSYS if branch_xol_ops doesn't handle this insn */
+static int branch_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
+{
+	u8 opc1 = OPCODE1(insn);
+
+	/* has the side-effect of processing the entire instruction */
+	insn_get_length(insn);
+	if (WARN_ON_ONCE(!insn_complete(insn)))
+		return -ENOEXEC;
+
+	switch (opc1) {
+	case 0xeb:	/* jmp 8 */
+	case 0xe9:	/* jmp 32 */
+	case 0x90:	/* prefix* + nop; same as jmp with .offs = 0 */
+		break;
+
+	case 0xe8:	/* call relative */
+		branch_clear_offset(auprobe, insn);
+		break;
 
+	case 0x0f:
+		if (insn->opcode.nbytes != 2)
+			return -ENOSYS;
 		/*
-		 * The original instruction includes a displacement, and so
-		 * is 4 bytes longer than what we've just single-stepped.
-		 * Fall through to handle stuff like "jmpq *...(%rip)" and
-		 * "callq *...(%rip)".
+		 * If it is a "near" conditional jmp, OPCODE2() - 0x10 matches
+		 * OPCODE1() of the "short" jmp which checks the same condition.
 		 */
-		if (correction)
-			*correction += 4;
+		opc1 = OPCODE2(insn) - 0x10;
+	default:
+		if (!is_cond_jmp_opcode(opc1))
+			return -ENOSYS;
 	}
+
+	auprobe->branch.opc1 = opc1;
+	auprobe->branch.ilen = insn->length;
+	auprobe->branch.offs = insn->immediate.value;
+
+	auprobe->ops = &branch_xol_ops;
+	return 0;
 }
-#else
-static void
-handle_riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs, long *correction)
+
+/**
+ * arch_uprobe_analyze_insn - instruction analysis including validity and fixups.
+ * @mm: the probed address space.
+ * @arch_uprobe: the probepoint information.
+ * @addr: virtual address at which to install the probepoint
+ * Return 0 on success or a -ve number on error.
+ */
+int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long addr)
+{
+	struct insn insn;
+	bool fix_ip = true, fix_call = false;
+	int ret;
+
+	ret = validate_insn_bits(auprobe, mm, &insn);
+	if (ret)
+		return ret;
+
+	ret = branch_setup_xol_ops(auprobe, &insn);
+	if (ret != -ENOSYS)
+		return ret;
+
+	/*
+	 * Figure out which fixups arch_uprobe_post_xol() will need to perform,
+	 * and annotate arch_uprobe->fixups accordingly. To start with, ->fixups
+	 * is either zero or it reflects rip-related fixups.
+	 */
+	switch (OPCODE1(&insn)) {
+	case 0x9d:		/* popf */
+		auprobe->fixups |= UPROBE_FIX_SETF;
+		break;
+	case 0xc3:		/* ret or lret -- ip is correct */
+	case 0xcb:
+	case 0xc2:
+	case 0xca:
+		fix_ip = false;
+		break;
+	case 0x9a:		/* call absolute - Fix return addr, not ip */
+		fix_call = true;
+		fix_ip = false;
+		break;
+	case 0xea:		/* jmp absolute -- ip is correct */
+		fix_ip = false;
+		break;
+	case 0xff:
+		insn_get_modrm(&insn);
+		switch (MODRM_REG(&insn)) {
+		case 2: case 3:			/* call or lcall, indirect */
+			fix_call = true;
+		case 4: case 5:			/* jmp or ljmp, indirect */
+			fix_ip = false;
+		}
+		/* fall through */
+	default:
+		handle_riprel_insn(auprobe, &insn);
+	}
+
+	if (fix_ip)
+		auprobe->fixups |= UPROBE_FIX_IP;
+	if (fix_call)
+		auprobe->fixups |= UPROBE_FIX_CALL;
+
+	auprobe->ops = &default_xol_ops;
+	return 0;
+}
+
+/*
+ * arch_uprobe_pre_xol - prepare to execute out of line.
+ * @auprobe: the probepoint information.
+ * @regs: reflects the saved user state of current task.
+ */
+int arch_uprobe_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-	/* No RIP-relative addressing on 32-bit */
+	struct uprobe_task *utask = current->utask;
+
+	regs->ip = utask->xol_vaddr;
+	utask->autask.saved_trap_nr = current->thread.trap_nr;
+	current->thread.trap_nr = UPROBE_TRAP_NR;
+
+	utask->autask.saved_tf = !!(regs->flags & X86_EFLAGS_TF);
+	regs->flags |= X86_EFLAGS_TF;
+	if (test_tsk_thread_flag(current, TIF_BLOCKSTEP))
+		set_task_blockstep(current, false);
+
+	if (auprobe->ops->pre_xol)
+		return auprobe->ops->pre_xol(auprobe, regs);
+	return 0;
 }
-#endif
 
 /*
  * If xol insn itself traps and generates a signal(Say,
@@ -592,22 +752,25 @@ bool arch_uprobe_xol_was_trapped(struct task_struct *t)
  */
 int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-	struct uprobe_task *utask;
-	long correction;
-	int result = 0;
+	struct uprobe_task *utask = current->utask;
 
 	WARN_ON_ONCE(current->thread.trap_nr != UPROBE_TRAP_NR);
 
-	utask = current->utask;
-	current->thread.trap_nr = utask->autask.saved_trap_nr;
-	correction = (long)(utask->vaddr - utask->xol_vaddr);
-	handle_riprel_post_xol(auprobe, regs, &correction);
-	if (auprobe->fixups & UPROBE_FIX_IP)
-		regs->ip += correction;
-
-	if (auprobe->fixups & UPROBE_FIX_CALL)
-		result = adjust_ret_addr(regs->sp, correction);
+	if (auprobe->ops->post_xol) {
+		int err = auprobe->ops->post_xol(auprobe, regs);
+		if (err) {
+			arch_uprobe_abort_xol(auprobe, regs);
+			/*
+			 * Restart the probed insn. ->post_xol() must ensure
+			 * this is really possible if it returns -ERESTART.
+			 */
+			if (err == -ERESTART)
+				return 0;
+			return err;
+		}
+	}
 
+	current->thread.trap_nr = utask->autask.saved_trap_nr;
 	/*
 	 * arch_uprobe_pre_xol() doesn't save the state of TIF_BLOCKSTEP
 	 * so we can get an extra SIGTRAP if we do not clear TF. We need
@@ -618,7 +781,7 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	else if (!(auprobe->fixups & UPROBE_FIX_SETF))
 		regs->flags &= ~X86_EFLAGS_TF;
 
-	return result;
+	return 0;
 }
 
 /* callback routine for handling exceptions. */
@@ -652,8 +815,9 @@ int arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val,
 
 /*
  * This function gets called when XOL instruction either gets trapped or
- * the thread has a fatal signal, so reset the instruction pointer to its
- * probed address.
+ * the thread has a fatal signal, or if arch_uprobe_post_xol() failed.
+ * Reset the instruction pointer to its probed address for the potential
+ * restart or for post mortem analysis.
  */
 void arch_uprobe_abort_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
@@ -668,25 +832,10 @@ void arch_uprobe_abort_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 		regs->flags &= ~X86_EFLAGS_TF;
 }
 
-/*
- * Skip these instructions as per the currently known x86 ISA.
- * rep=0x66*; nop=0x90
- */
 static bool __skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-	int i;
-
-	for (i = 0; i < MAX_UINSN_BYTES; i++) {
-		if (auprobe->insn[i] == 0x66)
-			continue;
-
-		if (auprobe->insn[i] == 0x90) {
-			regs->ip += i + 1;
-			return true;
-		}
-
-		break;
-	}
+	if (auprobe->ops->emulate)
+		return auprobe->ops->emulate(auprobe, regs);
 	return false;
 }
 
@@ -701,23 +850,21 @@ bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
 unsigned long
 arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs)
 {
-	int rasize, ncopied;
+	int rasize = sizeof_long(), nleft;
 	unsigned long orig_ret_vaddr = 0; /* clear high bits for 32-bit apps */
 
-	rasize = is_ia32_task() ? 4 : 8;
-	ncopied = copy_from_user(&orig_ret_vaddr, (void __user *)regs->sp, rasize);
-	if (unlikely(ncopied))
+	if (copy_from_user(&orig_ret_vaddr, (void __user *)regs->sp, rasize))
 		return -1;
 
 	/* check whether address has been already hijacked */
 	if (orig_ret_vaddr == trampoline_vaddr)
 		return orig_ret_vaddr;
 
-	ncopied = copy_to_user((void __user *)regs->sp, &trampoline_vaddr, rasize);
-	if (likely(!ncopied))
+	nleft = copy_to_user((void __user *)regs->sp, &trampoline_vaddr, rasize);
+	if (likely(!nleft))
 		return orig_ret_vaddr;
 
-	if (ncopied != rasize) {
+	if (nleft != rasize) {
 		pr_err("uprobe: return address clobbered: pid=%d, %%sp=%#lx, "
 			"%%ip=%#lx\n", current->pid, regs->sp, regs->ip);
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3356abc..af6dcf1 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -172,6 +172,7 @@ struct perf_event;
 struct pmu {
 	struct list_head		entry;
 
+	struct module			*module;
 	struct device			*dev;
 	const struct attribute_group	**attr_groups;
 	const char			*name;
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 853bc1c..e3fc8f0 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -722,10 +722,10 @@ enum perf_callchain_context {
 	PERF_CONTEXT_MAX		= (__u64)-4095,
 };
 
-#define PERF_FLAG_FD_NO_GROUP		(1U << 0)
-#define PERF_FLAG_FD_OUTPUT		(1U << 1)
-#define PERF_FLAG_PID_CGROUP		(1U << 2) /* pid=cgroup id, per-cpu mode only */
-#define PERF_FLAG_FD_CLOEXEC		(1U << 3) /* O_CLOEXEC */
+#define PERF_FLAG_FD_NO_GROUP		(1UL << 0)
+#define PERF_FLAG_FD_OUTPUT		(1UL << 1)
+#define PERF_FLAG_PID_CGROUP		(1UL << 2) /* pid=cgroup id, per-cpu mode only */
+#define PERF_FLAG_FD_CLOEXEC		(1UL << 3) /* O_CLOEXEC */
 
 union perf_mem_data_src {
 	__u64 val;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7123284..ed50b09 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -39,6 +39,7 @@
 #include <linux/hw_breakpoint.h>
 #include <linux/mm_types.h>
 #include <linux/cgroup.h>
+#include <linux/module.h>
 
 #include "internal.h"
 
@@ -1677,6 +1678,8 @@ event_sched_in(struct perf_event *event,
 	u64 tstamp = perf_event_time(event);
 	int ret = 0;
 
+	lockdep_assert_held(&ctx->lock);
+
 	if (event->state <= PERF_EVENT_STATE_OFF)
 		return 0;
 
@@ -3243,9 +3246,13 @@ static void __free_event(struct perf_event *event)
 	if (event->ctx)
 		put_ctx(event->ctx);
 
+	if (event->pmu)
+		module_put(event->pmu->module);
+
 	call_rcu(&event->rcu_head, free_event_rcu);
 }
-static void free_event(struct perf_event *event)
+
+static void _free_event(struct perf_event *event)
 {
 	irq_work_sync(&event->pending);
 
@@ -3273,42 +3280,31 @@ static void free_event(struct perf_event *event)
 	if (is_cgroup_event(event))
 		perf_detach_cgroup(event);
 
-
 	__free_event(event);
 }
 
-int perf_event_release_kernel(struct perf_event *event)
+/*
+ * Used to free events which have a known refcount of 1, such as in error paths
+ * where the event isn't exposed yet and inherited events.
+ */
+static void free_event(struct perf_event *event)
 {
-	struct perf_event_context *ctx = event->ctx;
-
-	WARN_ON_ONCE(ctx->parent_ctx);
-	/*
-	 * There are two ways this annotation is useful:
-	 *
-	 *  1) there is a lock recursion from perf_event_exit_task
-	 *     see the comment there.
-	 *
-	 *  2) there is a lock-inversion with mmap_sem through
-	 *     perf_event_read_group(), which takes faults while
-	 *     holding ctx->mutex, however this is called after
-	 *     the last filedesc died, so there is no possibility
-	 *     to trigger the AB-BA case.
-	 */
-	mutex_lock_nested(&ctx->mutex, SINGLE_DEPTH_NESTING);
-	perf_remove_from_context(event, true);
-	mutex_unlock(&ctx->mutex);
-
-	free_event(event);
+	if (WARN(atomic_long_cmpxchg(&event->refcount, 1, 0) != 1,
+				"unexpected event refcount: %ld; ptr=%p\n",
+				atomic_long_read(&event->refcount), event)) {
+		/* leak to avoid use-after-free */
+		return;
+	}
 
-	return 0;
+	_free_event(event);
 }
-EXPORT_SYMBOL_GPL(perf_event_release_kernel);
 
 /*
  * Called when the last reference to the file is gone.
  */
 static void put_event(struct perf_event *event)
 {
+	struct perf_event_context *ctx = event->ctx;
 	struct task_struct *owner;
 
 	if (!atomic_long_dec_and_test(&event->refcount))
@@ -3347,9 +3343,33 @@ static void put_event(struct perf_event *event)
 		put_task_struct(owner);
 	}
 
-	perf_event_release_kernel(event);
+	WARN_ON_ONCE(ctx->parent_ctx);
+	/*
+	 * There are two ways this annotation is useful:
+	 *
+	 *  1) there is a lock recursion from perf_event_exit_task
+	 *     see the comment there.
+	 *
+	 *  2) there is a lock-inversion with mmap_sem through
+	 *     perf_event_read_group(), which takes faults while
+	 *     holding ctx->mutex, however this is called after
+	 *     the last filedesc died, so there is no possibility
+	 *     to trigger the AB-BA case.
+	 */
+	mutex_lock_nested(&ctx->mutex, SINGLE_DEPTH_NESTING);
+	perf_remove_from_context(event, true);
+	mutex_unlock(&ctx->mutex);
+
+	_free_event(event);
 }
 
+int perf_event_release_kernel(struct perf_event *event)
+{
+	put_event(event);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(perf_event_release_kernel);
+
 static int perf_release(struct inode *inode, struct file *file)
 {
 	put_event(file->private_data);
@@ -6562,6 +6582,7 @@ free_pdc:
 	free_percpu(pmu->pmu_disable_count);
 	goto unlock;
 }
+EXPORT_SYMBOL_GPL(perf_pmu_register);
 
 void perf_pmu_unregister(struct pmu *pmu)
 {
@@ -6583,6 +6604,7 @@ void perf_pmu_unregister(struct pmu *pmu)
 	put_device(pmu->dev);
 	free_pmu_context(pmu);
 }
+EXPORT_SYMBOL_GPL(perf_pmu_unregister);
 
 struct pmu *perf_init_event(struct perf_event *event)
 {
@@ -6596,6 +6618,10 @@ struct pmu *perf_init_event(struct perf_event *event)
 	pmu = idr_find(&pmu_idr, event->attr.type);
 	rcu_read_unlock();
 	if (pmu) {
+		if (!try_module_get(pmu->module)) {
+			pmu = ERR_PTR(-ENODEV);
+			goto unlock;
+		}
 		event->pmu = pmu;
 		ret = pmu->event_init(event);
 		if (ret)
@@ -6604,6 +6630,10 @@ struct pmu *perf_init_event(struct perf_event *event)
 	}
 
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
+		if (!try_module_get(pmu->module)) {
+			pmu = ERR_PTR(-ENODEV);
+			goto unlock;
+		}
 		event->pmu = pmu;
 		ret = pmu->event_init(event);
 		if (!ret)
@@ -6782,6 +6812,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 err_pmu:
 	if (event->destroy)
 		event->destroy(event);
+	module_put(pmu->module);
 err_ns:
 	if (event->ns)
 		put_pid_ns(event->ns);
@@ -7066,20 +7097,26 @@ SYSCALL_DEFINE5(perf_event_open,
 		}
 	}
 
+	if (task && group_leader &&
+	    group_leader->attr.inherit != attr.inherit) {
+		err = -EINVAL;
+		goto err_task;
+	}
+
 	get_online_cpus();
 
 	event = perf_event_alloc(&attr, cpu, task, group_leader, NULL,
 				 NULL, NULL);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
-		goto err_task;
+		goto err_cpus;
 	}
 
 	if (flags & PERF_FLAG_PID_CGROUP) {
 		err = perf_cgroup_connect(pid, event, &attr, group_leader);
 		if (err) {
 			__free_event(event);
-			goto err_task;
+			goto err_cpus;
 		}
 	}
 
@@ -7241,8 +7278,9 @@ err_context:
 	put_ctx(ctx);
 err_alloc:
 	free_event(event);
-err_task:
+err_cpus:
 	put_online_cpus();
+err_task:
 	if (task)
 		put_task_struct(task);
 err_group_fd:
@@ -7378,7 +7416,7 @@ __perf_event_exit_task(struct perf_event *child_event,
 			 struct perf_event_context *child_ctx,
 			 struct task_struct *child)
 {
-	perf_remove_from_context(child_event, !!child_event->parent);
+	perf_remove_from_context(child_event, true);
 
 	/*
 	 * It can happen that the parent exits first, and has events
@@ -7393,7 +7431,7 @@ __perf_event_exit_task(struct perf_event *child_event,
 
 static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 {
-	struct perf_event *child_event, *tmp;
+	struct perf_event *child_event;
 	struct perf_event_context *child_ctx;
 	unsigned long flags;
 
@@ -7447,24 +7485,9 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 	 */
 	mutex_lock(&child_ctx->mutex);
 
-again:
-	list_for_each_entry_safe(child_event, tmp, &child_ctx->pinned_groups,
-				 group_entry)
-		__perf_event_exit_task(child_event, child_ctx, child);
-
-	list_for_each_entry_safe(child_event, tmp, &child_ctx->flexible_groups,
-				 group_entry)
+	list_for_each_entry_rcu(child_event, &child_ctx->event_list, event_entry)
 		__perf_event_exit_task(child_event, child_ctx, child);
 
-	/*
-	 * If the last event was a group event, it will have appended all
-	 * its siblings to the list, but we obtained 'tmp' before that which
-	 * will still point to the list head terminating the iteration.
-	 */
-	if (!list_empty(&child_ctx->pinned_groups) ||
-	    !list_empty(&child_ctx->flexible_groups))
-		goto again;
-
 	mutex_unlock(&child_ctx->mutex);
 
 	put_ctx(child_ctx);
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 04709b6..d1edc5e 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -60,8 +60,6 @@ static struct percpu_rw_semaphore dup_mmap_sem;
 
 /* Have a copy of original instruction */
 #define UPROBE_COPY_INSN	0
-/* Can skip singlestep */
-#define UPROBE_SKIP_SSTEP	1
 
 struct uprobe {
 	struct rb_node		rb_node;	/* node in the rb tree */
@@ -491,12 +489,9 @@ static struct uprobe *alloc_uprobe(struct inode *inode, loff_t offset)
 	uprobe->offset = offset;
 	init_rwsem(&uprobe->register_rwsem);
 	init_rwsem(&uprobe->consumer_rwsem);
-	/* For now assume that the instruction need not be single-stepped */
-	__set_bit(UPROBE_SKIP_SSTEP, &uprobe->flags);
 
 	/* add to uprobes_tree, sorted on inode:offset */
 	cur_uprobe = insert_uprobe(uprobe);
-
 	/* a uprobe exists for this inode:offset combination */
 	if (cur_uprobe) {
 		kfree(uprobe);
@@ -1628,20 +1623,6 @@ bool uprobe_deny_signal(void)
 	return true;
 }
 
-/*
- * Avoid singlestepping the original instruction if the original instruction
- * is a NOP or can be emulated.
- */
-static bool can_skip_sstep(struct uprobe *uprobe, struct pt_regs *regs)
-{
-	if (test_bit(UPROBE_SKIP_SSTEP, &uprobe->flags)) {
-		if (arch_uprobe_skip_sstep(&uprobe->arch, regs))
-			return true;
-		clear_bit(UPROBE_SKIP_SSTEP, &uprobe->flags);
-	}
-	return false;
-}
-
 static void mmf_recalc_uprobes(struct mm_struct *mm)
 {
 	struct vm_area_struct *vma;
@@ -1868,13 +1849,13 @@ static void handle_swbp(struct pt_regs *regs)
 
 	handler_chain(uprobe, regs);
 
-	if (can_skip_sstep(uprobe, regs))
+	if (arch_uprobe_skip_sstep(&uprobe->arch, regs))
 		goto out;
 
 	if (!pre_ssout(uprobe, regs, bp_vaddr))
 		return;
 
-	/* can_skip_sstep() succeeded, or restart if can't singlestep */
+	/* arch_uprobe_skip_sstep() succeeded, or restart if can't singlestep */
 out:
 	put_uprobe(uprobe);
 }
@@ -1886,10 +1867,11 @@ out:
 static void handle_singlestep(struct uprobe_task *utask, struct pt_regs *regs)
 {
 	struct uprobe *uprobe;
+	int err = 0;
 
 	uprobe = utask->active_uprobe;
 	if (utask->state == UTASK_SSTEP_ACK)
-		arch_uprobe_post_xol(&uprobe->arch, regs);
+		err = arch_uprobe_post_xol(&uprobe->arch, regs);
 	else if (utask->state == UTASK_SSTEP_TRAPPED)
 		arch_uprobe_abort_xol(&uprobe->arch, regs);
 	else
@@ -1903,6 +1885,11 @@ static void handle_singlestep(struct uprobe_task *utask, struct pt_regs *regs)
 	spin_lock_irq(&current->sighand->siglock);
 	recalc_sigpending(); /* see uprobe_deny_signal() */
 	spin_unlock_irq(&current->sighand->siglock);
+
+	if (unlikely(err)) {
+		uprobe_warn(current, "execute the probed insn, sending SIGILL.");
+		force_sig_info(SIGILL, SEND_SIG_FORCED, current);
+	}
 }
 
 /*
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 6b715c0..d10eba8 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1039,6 +1039,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(__hrtimer_start_range_ns);
 
 /**
  * hrtimer_start_range_ns - (re)start an hrtimer on the current CPU
diff --git a/tools/include/linux/compiler.h b/tools/include/linux/compiler.h
index fbc6665..88461f0 100644
--- a/tools/include/linux/compiler.h
+++ b/tools/include/linux/compiler.h
@@ -35,4 +35,6 @@
 # define unlikely(x)		__builtin_expect(!!(x), 0)
 #endif
 
+#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
+
 #endif /* _TOOLS_LINUX_COMPILER_H */
diff --git a/tools/virtio/linux/export.h b/tools/include/linux/export.h
similarity index 70%
rename from tools/virtio/linux/export.h
rename to tools/include/linux/export.h
index 7311d32..d07e586 100644
--- a/tools/virtio/linux/export.h
+++ b/tools/include/linux/export.h
@@ -1,5 +1,10 @@
+#ifndef _TOOLS_LINUX_EXPORT_H_
+#define _TOOLS_LINUX_EXPORT_H_
+
 #define EXPORT_SYMBOL(sym)
 #define EXPORT_SYMBOL_GPL(sym)
 #define EXPORT_SYMBOL_GPL_FUTURE(sym)
 #define EXPORT_UNUSED_SYMBOL(sym)
 #define EXPORT_UNUSED_SYMBOL_GPL(sym)
+
+#endif
diff --git a/tools/lib/lockdep/uinclude/linux/types.h b/tools/include/linux/types.h
similarity index 63%
rename from tools/lib/lockdep/uinclude/linux/types.h
rename to tools/include/linux/types.h
index 929938f..b5cf25e 100644
--- a/tools/lib/lockdep/uinclude/linux/types.h
+++ b/tools/include/linux/types.h
@@ -1,8 +1,9 @@
-#ifndef _LIBLOCKDEP_LINUX_TYPES_H_
-#define _LIBLOCKDEP_LINUX_TYPES_H_
+#ifndef _TOOLS_LINUX_TYPES_H_
+#define _TOOLS_LINUX_TYPES_H_
 
 #include <stdbool.h>
 #include <stddef.h>
+#include <stdint.h>
 
 #define __SANE_USERSPACE_TYPES__	/* For PPC64, to get LL64 types */
 #include <asm/types.h>
@@ -10,10 +11,22 @@
 struct page;
 struct kmem_cache;
 
-typedef unsigned gfp_t;
+typedef enum {
+	GFP_KERNEL,
+	GFP_ATOMIC,
+	__GFP_HIGHMEM,
+	__GFP_HIGH
+} gfp_t;
 
-typedef __u64 u64;
-typedef __s64 s64;
+/*
+ * We define u64 as uint64_t for every architecture
+ * so that we can print it with "%"PRIx64 without getting warnings.
+ *
+ * typedef __u64 u64;
+ * typedef __s64 s64;
+ */
+typedef uint64_t u64;
+typedef int64_t s64;
 
 typedef __u32 u32;
 typedef __s32 s32;
@@ -35,6 +48,10 @@ typedef __s8  s8;
 #define __bitwise
 #endif
 
+#define __force
+#define __user
+#define __must_check
+#define __cold
 
 typedef __u16 __bitwise __le16;
 typedef __u16 __bitwise __be16;
@@ -55,4 +72,4 @@ struct hlist_node {
 	struct hlist_node *next, **pprev;
 };
 
-#endif
+#endif /* _TOOLS_LINUX_TYPES_H_ */
diff --git a/tools/lib/lockdep/Makefile b/tools/lib/lockdep/Makefile
index cb09d3f..85ef05d 100644
--- a/tools/lib/lockdep/Makefile
+++ b/tools/lib/lockdep/Makefile
@@ -105,7 +105,7 @@ N		=
 
 export Q VERBOSE
 
-INCLUDES = -I. -I/usr/local/include -I./uinclude -I./include $(CONFIG_INCLUDES)
+INCLUDES = -I. -I/usr/local/include -I./uinclude -I./include -I../../include $(CONFIG_INCLUDES)
 
 # Set compile option CFLAGS if not set elsewhere
 CFLAGS ?= -g -DCONFIG_LOCKDEP -DCONFIG_STACKTRACE -DCONFIG_PROVE_LOCKING -DBITS_PER_LONG=__WORDSIZE -DLIBLOCKDEP_VERSION='"$(LIBLOCKDEP_VERSION)"' -rdynamic -O0 -g
diff --git a/tools/lib/lockdep/uinclude/linux/export.h b/tools/lib/lockdep/uinclude/linux/export.h
deleted file mode 100644
index 6bdf349..0000000
--- a/tools/lib/lockdep/uinclude/linux/export.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _LIBLOCKDEP_LINUX_EXPORT_H_
-#define _LIBLOCKDEP_LINUX_EXPORT_H_
-
-#define EXPORT_SYMBOL(sym)
-#define EXPORT_SYMBOL_GPL(sym)
-
-#endif
diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index fdfceee..b3b8aba 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -33,21 +33,25 @@ OPTIONS
 -d::
 --dsos=::
 	Only consider symbols in these dsos. CSV that understands
-	file://filename entries.
+	file://filename entries.  This option will affect the percentage
+	of the Baseline/Delta column.  See --percentage for more info.
 
 -C::
 --comms=::
 	Only consider symbols in these comms. CSV that understands
-	file://filename entries.
+	file://filename entries.  This option will affect the percentage
+	of the Baseline/Delta column.  See --percentage for more info.
 
 -S::
 --symbols=::
 	Only consider these symbols. CSV that understands
-	file://filename entries.
+	file://filename entries.  This option will affect the percentage
+	of the Baseline/Delta column.  See --percentage for more info.
 
 -s::
 --sort=::
-	Sort by key(s): pid, comm, dso, symbol.
+	Sort by key(s): pid, comm, dso, symbol, cpu, parent, srcline.
+	Please see description of --sort in the perf-report man page.
 
 -t::
 --field-separator=::
@@ -89,6 +93,14 @@ OPTIONS
 --order::
        Specify compute sorting column number.
 
+--percentage::
+	Determine how to display the overhead percentage of filtered entries.
+	Filters can be applied by --comms, --dsos and/or --symbols options.
+
+	"relative" means it's relative to filtered entries only so that the
+	sum of shown entries will be always 100%.  "absolute" means it retains
+	the original value before and after the filter is applied.
+
 COMPARISON
 ----------
 The comparison is governed by the baseline file. The baseline perf.data
@@ -157,6 +169,10 @@ with:
   - period_percent being the % of the hist entry period value within
     single data file
 
+  - with filtering by -C, -d and/or -S, period_percent might be changed
+    relative to how entries are filtered.  Use --percentage=absolute to
+    prevent such fluctuation.
+
 ratio
 ~~~~~
 If specified the 'Ratio' column is displayed with value 'r' computed as:
@@ -187,4 +203,4 @@ If specified the 'Weighted diff' column is displayed with value 'd' computed as:
 
 SEE ALSO
 --------
-linkperf:perf-record[1]
+linkperf:perf-record[1], linkperf:perf-report[1]
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 8eab8a4..a1b5185 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -25,10 +25,6 @@ OPTIONS
 --verbose::
         Be more verbose. (show symbol address, etc)
 
--d::
---dsos=::
-	Only consider symbols in these dsos. CSV that understands
-	file://filename entries.
 -n::
 --show-nr-samples::
 	Show the number of samples for each symbol
@@ -42,11 +38,18 @@ OPTIONS
 -c::
 --comms=::
 	Only consider symbols in these comms. CSV that understands
-	file://filename entries.
+	file://filename entries.  This option will affect the percentage of
+	the overhead column.  See --percentage for more info.
+-d::
+--dsos=::
+	Only consider symbols in these dsos. CSV that understands
+	file://filename entries.  This option will affect the percentage of
+	the overhead column.  See --percentage for more info.
 -S::
 --symbols=::
 	Only consider these symbols. CSV that understands
-	file://filename entries.
+	file://filename entries.  This option will affect the percentage of
+	the overhead column.  See --percentage for more info.
 
 --symbol-filter=::
 	Only show symbols that match (partially) with this filter.
@@ -76,6 +79,15 @@ OPTIONS
 	abort cost. This is the global weight.
 	- local_weight: Local weight version of the weight above.
 	- transaction: Transaction abort flags.
+	- overhead: Overhead percentage of sample
+	- overhead_sys: Overhead percentage of sample running in system mode
+	- overhead_us: Overhead percentage of sample running in user mode
+	- overhead_guest_sys: Overhead percentage of sample running in system mode
+	on guest machine
+	- overhead_guest_us: Overhead percentage of sample running in user mode on
+	guest machine
+	- sample: Number of sample
+	- period: Raw number of event count of sample
 
 	By default, comm, dso and symbol keys are used.
 	(i.e. --sort comm,dso,symbol)
@@ -95,6 +107,16 @@ OPTIONS
 	And default sort keys are changed to comm, dso_from, symbol_from, dso_to
 	and symbol_to, see '--branch-stack'.
 
+-F::
+--fields=::
+	Specify output field - multiple keys can be specified in CSV format.
+	Following fields are available:
+	overhead, overhead_sys, overhead_us, sample and period.
+	Also it can contain any sort key(s).
+
+	By default, every sort keys not specified in -F will be appended
+	automatically.
+
 -p::
 --parent=<regex>::
         A regex filter to identify parent. The parent is a caller of this
@@ -237,6 +259,15 @@ OPTIONS
 	Do not show entries which have an overhead under that percent.
 	(Default: 0).
 
+--percentage::
+	Determine how to display the overhead percentage of filtered entries.
+	Filters can be applied by --comms, --dsos and/or --symbols options and
+	Zoom operations on the TUI (thread, dso, etc).
+
+	"relative" means it's relative to filtered entries only so that the
+	sum of shown entries will be always 100%.  "absolute" means it retains
+	the original value before and after the filter is applied.
+
 --header::
 	Show header information in the perf.data file.  This includes
 	various information like hostname, OS and perf version, cpu/mem
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 976b00c..dcfa54c 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -113,7 +113,17 @@ Default is to monitor all CPUS.
 -s::
 --sort::
 	Sort by key(s): pid, comm, dso, symbol, parent, srcline, weight,
-	local_weight, abort, in_tx, transaction
+	local_weight, abort, in_tx, transaction, overhead, sample, period.
+	Please see description of --sort in the perf-report man page.
+
+--fields=::
+	Specify output field - multiple keys can be specified in CSV format.
+	Following fields are available:
+	overhead, overhead_sys, overhead_us, sample and period.
+	Also it can contain any sort key(s).
+
+	By default, every sort keys not specified in --field will be appended
+	automatically.
 
 -n::
 --show-nr-samples::
@@ -123,13 +133,16 @@ Default is to monitor all CPUS.
 	Show a column with the sum of periods.
 
 --dsos::
-	Only consider symbols in these dsos.
+	Only consider symbols in these dsos.  This option will affect the
+	percentage of the overhead column.  See --percentage for more info.
 
 --comms::
-	Only consider symbols in these comms.
+	Only consider symbols in these comms.  This option will affect the
+	percentage of the overhead column.  See --percentage for more info.
 
 --symbols::
-	Only consider these symbols.
+	Only consider these symbols.  This option will affect the
+	percentage of the overhead column.  See --percentage for more info.
 
 -M::
 --disassembler-style=:: Set disassembler style for objdump.
@@ -165,6 +178,15 @@ Default is to monitor all CPUS.
 	Do not show entries which have an overhead under that percent.
 	(Default: 0).
 
+--percentage::
+	Determine how to display the overhead percentage of filtered entries.
+	Filters can be applied by --comms, --dsos and/or --symbols options and
+	Zoom operations on the TUI (thread, dso, etc).
+
+	"relative" means it's relative to filtered entries only so that the
+	sum of shown entries will be always 100%. "absolute" means it retains
+	the original value before and after the filter is applied.
+
 INTERACTIVE PROMPTING KEYS
 --------------------------
 
@@ -200,4 +222,4 @@ Pressing any unmapped key displays a menu, and prompts for input.
 
 SEE ALSO
 --------
-linkperf:perf-stat[1], linkperf:perf-list[1]
+linkperf:perf-stat[1], linkperf:perf-list[1], linkperf:perf-report[1]
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index c0c87c8..45da209 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -7,6 +7,8 @@ tools/lib/symbol/kallsyms.h
 tools/include/asm/bug.h
 tools/include/linux/compiler.h
 tools/include/linux/hash.h
+tools/include/linux/export.h
+tools/include/linux/types.h
 include/linux/const.h
 include/linux/perf_event.h
 include/linux/rbtree.h
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 895edd3..02f0a4d 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -222,12 +222,12 @@ LIB_H += util/include/linux/const.h
 LIB_H += util/include/linux/ctype.h
 LIB_H += util/include/linux/kernel.h
 LIB_H += util/include/linux/list.h
-LIB_H += util/include/linux/export.h
+LIB_H += ../include/linux/export.h
 LIB_H += util/include/linux/poison.h
 LIB_H += util/include/linux/rbtree.h
 LIB_H += util/include/linux/rbtree_augmented.h
 LIB_H += util/include/linux/string.h
-LIB_H += util/include/linux/types.h
+LIB_H += ../include/linux/types.h
 LIB_H += util/include/linux/linkage.h
 LIB_H += util/include/asm/asm-offsets.h
 LIB_H += ../include/asm/bug.h
@@ -252,7 +252,6 @@ LIB_H += util/event.h
 LIB_H += util/evsel.h
 LIB_H += util/evlist.h
 LIB_H += util/exec_cmd.h
-LIB_H += util/types.h
 LIB_H += util/levenshtein.h
 LIB_H += util/machine.h
 LIB_H += util/map.h
@@ -397,7 +396,10 @@ LIB_OBJS += $(OUTPUT)tests/rdpmc.o
 LIB_OBJS += $(OUTPUT)tests/evsel-roundtrip-name.o
 LIB_OBJS += $(OUTPUT)tests/evsel-tp-sched.o
 LIB_OBJS += $(OUTPUT)tests/pmu.o
+LIB_OBJS += $(OUTPUT)tests/hists_common.o
 LIB_OBJS += $(OUTPUT)tests/hists_link.o
+LIB_OBJS += $(OUTPUT)tests/hists_filter.o
+LIB_OBJS += $(OUTPUT)tests/hists_output.o
 LIB_OBJS += $(OUTPUT)tests/python-use.o
 LIB_OBJS += $(OUTPUT)tests/bp_signal.o
 LIB_OBJS += $(OUTPUT)tests/bp_signal_overflow.o
@@ -410,10 +412,12 @@ LIB_OBJS += $(OUTPUT)tests/code-reading.o
 LIB_OBJS += $(OUTPUT)tests/sample-parsing.o
 LIB_OBJS += $(OUTPUT)tests/parse-no-sample-id-all.o
 ifndef NO_DWARF_UNWIND
-ifeq ($(ARCH),x86)
+ifeq ($(ARCH),$(filter $(ARCH),x86 arm))
 LIB_OBJS += $(OUTPUT)tests/dwarf-unwind.o
 endif
 endif
+LIB_OBJS += $(OUTPUT)tests/mmap-thread-lookup.o
+LIB_OBJS += $(OUTPUT)tests/thread-mg-share.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/arch/arm/Makefile b/tools/perf/arch/arm/Makefile
index 67e9b3d..09d6215 100644
--- a/tools/perf/arch/arm/Makefile
+++ b/tools/perf/arch/arm/Makefile
@@ -5,3 +5,10 @@ endif
 ifndef NO_LIBUNWIND
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libunwind.o
 endif
+ifndef NO_LIBDW_DWARF_UNWIND
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libdw.o
+endif
+ifndef NO_DWARF_UNWIND
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/regs_load.o
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/dwarf-unwind.o
+endif
diff --git a/tools/perf/arch/arm/include/perf_regs.h b/tools/perf/arch/arm/include/perf_regs.h
index 2a1cfde..f619c9c 100644
--- a/tools/perf/arch/arm/include/perf_regs.h
+++ b/tools/perf/arch/arm/include/perf_regs.h
@@ -2,10 +2,15 @@
 #define ARCH_PERF_REGS_H
 
 #include <stdlib.h>
-#include "../../util/types.h"
+#include <linux/types.h>
 #include <asm/perf_regs.h>
 
+void perf_regs_load(u64 *regs);
+
 #define PERF_REGS_MASK	((1ULL << PERF_REG_ARM_MAX) - 1)
+#define PERF_REGS_MAX	PERF_REG_ARM_MAX
+#define PERF_SAMPLE_REGS_ABI	PERF_SAMPLE_REGS_ABI_32
+
 #define PERF_REG_IP	PERF_REG_ARM_PC
 #define PERF_REG_SP	PERF_REG_ARM_SP
 
diff --git a/tools/perf/arch/arm/tests/dwarf-unwind.c b/tools/perf/arch/arm/tests/dwarf-unwind.c
new file mode 100644
index 0000000..9f870d2
--- /dev/null
+++ b/tools/perf/arch/arm/tests/dwarf-unwind.c
@@ -0,0 +1,60 @@
+#include <string.h>
+#include "perf_regs.h"
+#include "thread.h"
+#include "map.h"
+#include "event.h"
+#include "tests/tests.h"
+
+#define STACK_SIZE 8192
+
+static int sample_ustack(struct perf_sample *sample,
+			 struct thread *thread, u64 *regs)
+{
+	struct stack_dump *stack = &sample->user_stack;
+	struct map *map;
+	unsigned long sp;
+	u64 stack_size, *buf;
+
+	buf = malloc(STACK_SIZE);
+	if (!buf) {
+		pr_debug("failed to allocate sample uregs data\n");
+		return -1;
+	}
+
+	sp = (unsigned long) regs[PERF_REG_ARM_SP];
+
+	map = map_groups__find(thread->mg, MAP__VARIABLE, (u64) sp);
+	if (!map) {
+		pr_debug("failed to get stack map\n");
+		free(buf);
+		return -1;
+	}
+
+	stack_size = map->end - sp;
+	stack_size = stack_size > STACK_SIZE ? STACK_SIZE : stack_size;
+
+	memcpy(buf, (void *) sp, stack_size);
+	stack->data = (char *) buf;
+	stack->size = stack_size;
+	return 0;
+}
+
+int test__arch_unwind_sample(struct perf_sample *sample,
+			     struct thread *thread)
+{
+	struct regs_dump *regs = &sample->user_regs;
+	u64 *buf;
+
+	buf = calloc(1, sizeof(u64) * PERF_REGS_MAX);
+	if (!buf) {
+		pr_debug("failed to allocate sample uregs data\n");
+		return -1;
+	}
+
+	perf_regs_load(buf);
+	regs->abi  = PERF_SAMPLE_REGS_ABI;
+	regs->regs = buf;
+	regs->mask = PERF_REGS_MASK;
+
+	return sample_ustack(sample, thread, buf);
+}
diff --git a/tools/perf/arch/arm/tests/regs_load.S b/tools/perf/arch/arm/tests/regs_load.S
new file mode 100644
index 0000000..e09e983
--- /dev/null
+++ b/tools/perf/arch/arm/tests/regs_load.S
@@ -0,0 +1,58 @@
+#include <linux/linkage.h>
+
+#define R0 0x00
+#define R1 0x08
+#define R2 0x10
+#define R3 0x18
+#define R4 0x20
+#define R5 0x28
+#define R6 0x30
+#define R7 0x38
+#define R8 0x40
+#define R9 0x48
+#define SL 0x50
+#define FP 0x58
+#define IP 0x60
+#define SP 0x68
+#define LR 0x70
+#define PC 0x78
+
+/*
+ * Implementation of void perf_regs_load(u64 *regs);
+ *
+ * This functions fills in the 'regs' buffer from the actual registers values,
+ * in the way the perf built-in unwinding test expects them:
+ * - the PC at the time at the call to this function. Since this function
+ *   is called using a bl instruction, the PC value is taken from LR.
+ * The built-in unwinding test then unwinds the call stack from the dwarf
+ * information in unwind__get_entries.
+ *
+ * Notes:
+ * - the 8 bytes stride in the registers offsets comes from the fact
+ * that the registers are stored in an u64 array (u64 *regs),
+ * - the regs buffer needs to be zeroed before the call to this function,
+ * in this case using a calloc in dwarf-unwind.c.
+ */
+
+.text
+.type perf_regs_load,%function
+ENTRY(perf_regs_load)
+	str r0, [r0, #R0]
+	str r1, [r0, #R1]
+	str r2, [r0, #R2]
+	str r3, [r0, #R3]
+	str r4, [r0, #R4]
+	str r5, [r0, #R5]
+	str r6, [r0, #R6]
+	str r7, [r0, #R7]
+	str r8, [r0, #R8]
+	str r9, [r0, #R9]
+	str sl, [r0, #SL]
+	str fp, [r0, #FP]
+	str ip, [r0, #IP]
+	str sp, [r0, #SP]
+	str lr, [r0, #LR]
+	str lr, [r0, #PC]	// store pc as lr in order to skip the call
+	                        //  to this function
+	mov pc, lr
+ENDPROC(perf_regs_load)
diff --git a/tools/perf/arch/arm/util/unwind-libdw.c b/tools/perf/arch/arm/util/unwind-libdw.c
new file mode 100644
index 0000000..b4176c6
--- /dev/null
+++ b/tools/perf/arch/arm/util/unwind-libdw.c
@@ -0,0 +1,36 @@
+#include <elfutils/libdwfl.h>
+#include "../../util/unwind-libdw.h"
+#include "../../util/perf_regs.h"
+
+bool libdw__arch_set_initial_registers(Dwfl_Thread *thread, void *arg)
+{
+	struct unwind_info *ui = arg;
+	struct regs_dump *user_regs = &ui->sample->user_regs;
+	Dwarf_Word dwarf_regs[PERF_REG_ARM_MAX];
+
+#define REG(r) ({						\
+	Dwarf_Word val = 0;					\
+	perf_reg_value(&val, user_regs, PERF_REG_ARM_##r);	\
+	val;							\
+})
+
+	dwarf_regs[0]  = REG(R0);
+	dwarf_regs[1]  = REG(R1);
+	dwarf_regs[2]  = REG(R2);
+	dwarf_regs[3]  = REG(R3);
+	dwarf_regs[4]  = REG(R4);
+	dwarf_regs[5]  = REG(R5);
+	dwarf_regs[6]  = REG(R6);
+	dwarf_regs[7]  = REG(R7);
+	dwarf_regs[8]  = REG(R8);
+	dwarf_regs[9]  = REG(R9);
+	dwarf_regs[10] = REG(R10);
+	dwarf_regs[11] = REG(FP);
+	dwarf_regs[12] = REG(IP);
+	dwarf_regs[13] = REG(SP);
+	dwarf_regs[14] = REG(LR);
+	dwarf_regs[15] = REG(PC);
+
+	return dwfl_thread_state_registers(thread, 0, PERF_REG_ARM_MAX,
+					   dwarf_regs);
+}
diff --git a/tools/perf/arch/arm64/Makefile b/tools/perf/arch/arm64/Makefile
new file mode 100644
index 0000000..67e9b3d
--- /dev/null
+++ b/tools/perf/arch/arm64/Makefile
@@ -0,0 +1,7 @@
+ifndef NO_DWARF
+PERF_HAVE_DWARF_REGS := 1
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
+endif
+ifndef NO_LIBUNWIND
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libunwind.o
+endif
diff --git a/tools/perf/arch/arm64/include/perf_regs.h b/tools/perf/arch/arm64/include/perf_regs.h
new file mode 100644
index 0000000..e9441b9
--- /dev/null
+++ b/tools/perf/arch/arm64/include/perf_regs.h
@@ -0,0 +1,88 @@
+#ifndef ARCH_PERF_REGS_H
+#define ARCH_PERF_REGS_H
+
+#include <stdlib.h>
+#include <linux/types.h>
+#include <asm/perf_regs.h>
+
+#define PERF_REGS_MASK	((1ULL << PERF_REG_ARM64_MAX) - 1)
+#define PERF_REG_IP	PERF_REG_ARM64_PC
+#define PERF_REG_SP	PERF_REG_ARM64_SP
+
+static inline const char *perf_reg_name(int id)
+{
+	switch (id) {
+	case PERF_REG_ARM64_X0:
+		return "x0";
+	case PERF_REG_ARM64_X1:
+		return "x1";
+	case PERF_REG_ARM64_X2:
+		return "x2";
+	case PERF_REG_ARM64_X3:
+		return "x3";
+	case PERF_REG_ARM64_X4:
+		return "x4";
+	case PERF_REG_ARM64_X5:
+		return "x5";
+	case PERF_REG_ARM64_X6:
+		return "x6";
+	case PERF_REG_ARM64_X7:
+		return "x7";
+	case PERF_REG_ARM64_X8:
+		return "x8";
+	case PERF_REG_ARM64_X9:
+		return "x9";
+	case PERF_REG_ARM64_X10:
+		return "x10";
+	case PERF_REG_ARM64_X11:
+		return "x11";
+	case PERF_REG_ARM64_X12:
+		return "x12";
+	case PERF_REG_ARM64_X13:
+		return "x13";
+	case PERF_REG_ARM64_X14:
+		return "x14";
+	case PERF_REG_ARM64_X15:
+		return "x15";
+	case PERF_REG_ARM64_X16:
+		return "x16";
+	case PERF_REG_ARM64_X17:
+		return "x17";
+	case PERF_REG_ARM64_X18:
+		return "x18";
+	case PERF_REG_ARM64_X19:
+		return "x19";
+	case PERF_REG_ARM64_X20:
+		return "x20";
+	case PERF_REG_ARM64_X21:
+		return "x21";
+	case PERF_REG_ARM64_X22:
+		return "x22";
+	case PERF_REG_ARM64_X23:
+		return "x23";
+	case PERF_REG_ARM64_X24:
+		return "x24";
+	case PERF_REG_ARM64_X25:
+		return "x25";
+	case PERF_REG_ARM64_X26:
+		return "x26";
+	case PERF_REG_ARM64_X27:
+		return "x27";
+	case PERF_REG_ARM64_X28:
+		return "x28";
+	case PERF_REG_ARM64_X29:
+		return "x29";
+	case PERF_REG_ARM64_SP:
+		return "sp";
+	case PERF_REG_ARM64_LR:
+		return "lr";
+	case PERF_REG_ARM64_PC:
+		return "pc";
+	default:
+		return NULL;
+	}
+
+	return NULL;
+}
+
+#endif /* ARCH_PERF_REGS_H */
diff --git a/tools/perf/arch/arm64/util/dwarf-regs.c b/tools/perf/arch/arm64/util/dwarf-regs.c
new file mode 100644
index 0000000..d49efeb
--- /dev/null
+++ b/tools/perf/arch/arm64/util/dwarf-regs.c
@@ -0,0 +1,80 @@
+/*
+ * Mapping of DWARF debug register numbers into register names.
+ *
+ * Copyright (C) 2010 Will Deacon, ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <stddef.h>
+#include <dwarf-regs.h>
+
+struct pt_regs_dwarfnum {
+	const char *name;
+	unsigned int dwarfnum;
+};
+
+#define STR(s) #s
+#define REG_DWARFNUM_NAME(r, num) {.name = r, .dwarfnum = num}
+#define GPR_DWARFNUM_NAME(num) \
+	{.name = STR(%x##num), .dwarfnum = num}
+#define REG_DWARFNUM_END {.name = NULL, .dwarfnum = 0}
+
+/*
+ * Reference:
+ * http://infocenter.arm.com/help/topic/com.arm.doc.ihi0057b/IHI0057B_aadwarf64.pdf
+ */
+static const struct pt_regs_dwarfnum regdwarfnum_table[] = {
+	GPR_DWARFNUM_NAME(0),
+	GPR_DWARFNUM_NAME(1),
+	GPR_DWARFNUM_NAME(2),
+	GPR_DWARFNUM_NAME(3),
+	GPR_DWARFNUM_NAME(4),
+	GPR_DWARFNUM_NAME(5),
+	GPR_DWARFNUM_NAME(6),
+	GPR_DWARFNUM_NAME(7),
+	GPR_DWARFNUM_NAME(8),
+	GPR_DWARFNUM_NAME(9),
+	GPR_DWARFNUM_NAME(10),
+	GPR_DWARFNUM_NAME(11),
+	GPR_DWARFNUM_NAME(12),
+	GPR_DWARFNUM_NAME(13),
+	GPR_DWARFNUM_NAME(14),
+	GPR_DWARFNUM_NAME(15),
+	GPR_DWARFNUM_NAME(16),
+	GPR_DWARFNUM_NAME(17),
+	GPR_DWARFNUM_NAME(18),
+	GPR_DWARFNUM_NAME(19),
+	GPR_DWARFNUM_NAME(20),
+	GPR_DWARFNUM_NAME(21),
+	GPR_DWARFNUM_NAME(22),
+	GPR_DWARFNUM_NAME(23),
+	GPR_DWARFNUM_NAME(24),
+	GPR_DWARFNUM_NAME(25),
+	GPR_DWARFNUM_NAME(26),
+	GPR_DWARFNUM_NAME(27),
+	GPR_DWARFNUM_NAME(28),
+	GPR_DWARFNUM_NAME(29),
+	REG_DWARFNUM_NAME("%lr", 30),
+	REG_DWARFNUM_NAME("%sp", 31),
+	REG_DWARFNUM_END,
+};
+
+/**
+ * get_arch_regstr() - lookup register name from it's DWARF register number
+ * @n:	the DWARF register number
+ *
+ * get_arch_regstr() returns the name of the register in struct
+ * regdwarfnum_table from it's DWARF register number. If the register is not
+ * found in the table, this returns NULL;
+ */
+const char *get_arch_regstr(unsigned int n)
+{
+	const struct pt_regs_dwarfnum *roff;
+	for (roff = regdwarfnum_table; roff->name != NULL; roff++)
+		if (roff->dwarfnum == n)
+			return roff->name;
+	return NULL;
+}
diff --git a/tools/perf/arch/arm64/util/unwind-libunwind.c b/tools/perf/arch/arm64/util/unwind-libunwind.c
new file mode 100644
index 0000000..436ee43
--- /dev/null
+++ b/tools/perf/arch/arm64/util/unwind-libunwind.c
@@ -0,0 +1,82 @@
+
+#include <errno.h>
+#include <libunwind.h>
+#include "perf_regs.h"
+#include "../../util/unwind.h"
+
+int libunwind__arch_reg_id(int regnum)
+{
+	switch (regnum) {
+	case UNW_AARCH64_X0:
+		return PERF_REG_ARM64_X0;
+	case UNW_AARCH64_X1:
+		return PERF_REG_ARM64_X1;
+	case UNW_AARCH64_X2:
+		return PERF_REG_ARM64_X2;
+	case UNW_AARCH64_X3:
+		return PERF_REG_ARM64_X3;
+	case UNW_AARCH64_X4:
+		return PERF_REG_ARM64_X4;
+	case UNW_AARCH64_X5:
+		return PERF_REG_ARM64_X5;
+	case UNW_AARCH64_X6:
+		return PERF_REG_ARM64_X6;
+	case UNW_AARCH64_X7:
+		return PERF_REG_ARM64_X7;
+	case UNW_AARCH64_X8:
+		return PERF_REG_ARM64_X8;
+	case UNW_AARCH64_X9:
+		return PERF_REG_ARM64_X9;
+	case UNW_AARCH64_X10:
+		return PERF_REG_ARM64_X10;
+	case UNW_AARCH64_X11:
+		return PERF_REG_ARM64_X11;
+	case UNW_AARCH64_X12:
+		return PERF_REG_ARM64_X12;
+	case UNW_AARCH64_X13:
+		return PERF_REG_ARM64_X13;
+	case UNW_AARCH64_X14:
+		return PERF_REG_ARM64_X14;
+	case UNW_AARCH64_X15:
+		return PERF_REG_ARM64_X15;
+	case UNW_AARCH64_X16:
+		return PERF_REG_ARM64_X16;
+	case UNW_AARCH64_X17:
+		return PERF_REG_ARM64_X17;
+	case UNW_AARCH64_X18:
+		return PERF_REG_ARM64_X18;
+	case UNW_AARCH64_X19:
+		return PERF_REG_ARM64_X19;
+	case UNW_AARCH64_X20:
+		return PERF_REG_ARM64_X20;
+	case UNW_AARCH64_X21:
+		return PERF_REG_ARM64_X21;
+	case UNW_AARCH64_X22:
+		return PERF_REG_ARM64_X22;
+	case UNW_AARCH64_X23:
+		return PERF_REG_ARM64_X23;
+	case UNW_AARCH64_X24:
+		return PERF_REG_ARM64_X24;
+	case UNW_AARCH64_X25:
+		return PERF_REG_ARM64_X25;
+	case UNW_AARCH64_X26:
+		return PERF_REG_ARM64_X26;
+	case UNW_AARCH64_X27:
+		return PERF_REG_ARM64_X27;
+	case UNW_AARCH64_X28:
+		return PERF_REG_ARM64_X28;
+	case UNW_AARCH64_X29:
+		return PERF_REG_ARM64_X29;
+	case UNW_AARCH64_X30:
+		return PERF_REG_ARM64_LR;
+	case UNW_AARCH64_SP:
+		return PERF_REG_ARM64_SP;
+	case UNW_AARCH64_PC:
+		return PERF_REG_ARM64_PC;
+	default:
+		pr_err("unwind: invalid reg id %d\n", regnum);
+		return -EINVAL;
+	}
+
+	return -EINVAL;
+}
diff --git a/tools/perf/arch/x86/include/perf_regs.h b/tools/perf/arch/x86/include/perf_regs.h
index fc819ca..7df517a 100644
--- a/tools/perf/arch/x86/include/perf_regs.h
+++ b/tools/perf/arch/x86/include/perf_regs.h
@@ -2,7 +2,7 @@
 #define ARCH_PERF_REGS_H
 
 #include <stdlib.h>
-#include "../../util/types.h"
+#include <linux/types.h>
 #include <asm/perf_regs.h>
 
 void perf_regs_load(u64 *regs);
diff --git a/tools/perf/arch/x86/tests/dwarf-unwind.c b/tools/perf/arch/x86/tests/dwarf-unwind.c
index 83bc238..9f89f89 100644
--- a/tools/perf/arch/x86/tests/dwarf-unwind.c
+++ b/tools/perf/arch/x86/tests/dwarf-unwind.c
@@ -23,7 +23,7 @@ static int sample_ustack(struct perf_sample *sample,
 
 	sp = (unsigned long) regs[PERF_REG_X86_SP];
 
-	map = map_groups__find(&thread->mg, MAP__VARIABLE, (u64) sp);
+	map = map_groups__find(thread->mg, MAP__VARIABLE, (u64) sp);
 	if (!map) {
 		pr_debug("failed to get stack map\n");
 		free(buf);
diff --git a/tools/perf/arch/x86/util/tsc.c b/tools/perf/arch/x86/util/tsc.c
index b2519e4..40021fa 100644
--- a/tools/perf/arch/x86/util/tsc.c
+++ b/tools/perf/arch/x86/util/tsc.c
@@ -4,7 +4,7 @@
 #include <linux/perf_event.h>
 
 #include "../../perf.h"
-#include "../../util/types.h"
+#include <linux/types.h>
 #include "../../util/debug.h"
 #include "tsc.h"
 
diff --git a/tools/perf/arch/x86/util/tsc.h b/tools/perf/arch/x86/util/tsc.h
index a24dec8..2affe03 100644
--- a/tools/perf/arch/x86/util/tsc.h
+++ b/tools/perf/arch/x86/util/tsc.h
@@ -1,7 +1,7 @@
 #ifndef TOOLS_PERF_ARCH_X86_UTIL_TSC_H__
 #define TOOLS_PERF_ARCH_X86_UTIL_TSC_H__
 
-#include "../../util/types.h"
+#include <linux/types.h>
 
 struct perf_tsc_conversion {
 	u16 time_shift;
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 0da603b..d30d2c2 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -46,7 +46,7 @@ struct perf_annotate {
 };
 
 static int perf_evsel__add_sample(struct perf_evsel *evsel,
-				  struct perf_sample *sample,
+				  struct perf_sample *sample __maybe_unused,
 				  struct addr_location *al,
 				  struct perf_annotate *ann)
 {
@@ -70,7 +70,6 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 		return -ENOMEM;
 
 	ret = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
-	evsel->hists.stats.total_period += sample->period;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
 	return ret;
 }
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 204fffe..8bff543 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -60,7 +60,6 @@ static int data__files_cnt;
 #define data__for_each_file(i, d) data__for_each_file_start(i, d, 0)
 #define data__for_each_file_new(i, d) data__for_each_file_start(i, d, 1)
 
-static char diff__default_sort_order[] = "dso,symbol";
 static bool force;
 static bool show_period;
 static bool show_formula;
@@ -220,7 +219,8 @@ static int setup_compute(const struct option *opt, const char *str,
 
 static double period_percent(struct hist_entry *he, u64 period)
 {
-	u64 total = he->hists->stats.total_period;
+	u64 total = hists__total_period(he->hists);
+
 	return (period * 100.0) / total;
 }
 
@@ -259,11 +259,18 @@ static s64 compute_wdiff(struct hist_entry *he, struct hist_entry *pair)
 static int formula_delta(struct hist_entry *he, struct hist_entry *pair,
 			 char *buf, size_t size)
 {
+	u64 he_total = he->hists->stats.total_period;
+	u64 pair_total = pair->hists->stats.total_period;
+
+	if (symbol_conf.filter_relative) {
+		he_total = he->hists->stats.total_non_filtered_period;
+		pair_total = pair->hists->stats.total_non_filtered_period;
+	}
 	return scnprintf(buf, size,
 			 "(%" PRIu64 " * 100 / %" PRIu64 ") - "
 			 "(%" PRIu64 " * 100 / %" PRIu64 ")",
-			  pair->stat.period, pair->hists->stats.total_period,
-			  he->stat.period, he->hists->stats.total_period);
+			 pair->stat.period, pair_total,
+			 he->stat.period, he_total);
 }
 
 static int formula_ratio(struct hist_entry *he, struct hist_entry *pair,
@@ -327,16 +334,22 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
 		return -1;
 	}
 
-	if (al.filtered)
-		return 0;
-
 	if (hists__add_entry(&evsel->hists, &al, sample->period,
 			     sample->weight, sample->transaction)) {
 		pr_warning("problem incrementing symbol period, skipping event\n");
 		return -1;
 	}
 
+	/*
+	 * The total_period is updated here before going to the output
+	 * tree since normally only the baseline hists will call
+	 * hists__output_resort() and precompute needs the total
+	 * period in order to sort entries by percentage delta.
+	 */
 	evsel->hists.stats.total_period += sample->period;
+	if (!al.filtered)
+		evsel->hists.stats.total_non_filtered_period += sample->period;
+
 	return 0;
 }
 
@@ -564,8 +577,7 @@ static void hists__compute_resort(struct hists *hists)
 	hists->entries = RB_ROOT;
 	next = rb_first(root);
 
-	hists->nr_entries = 0;
-	hists->stats.total_period = 0;
+	hists__reset_stats(hists);
 	hists__reset_col_len(hists);
 
 	while (next != NULL) {
@@ -575,7 +587,10 @@ static void hists__compute_resort(struct hists *hists)
 		next = rb_next(&he->rb_node_in);
 
 		insert_hist_entry_by_compute(&hists->entries, he, compute);
-		hists__inc_nr_entries(hists, he);
+		hists__inc_stats(hists, he);
+
+		if (!he->filtered)
+			hists__calc_col_len(hists, he);
 	}
 }
 
@@ -725,20 +740,24 @@ static const struct option options[] = {
 	OPT_STRING('S', "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
 		   "only consider these symbols"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
-		   "sort by key(s): pid, comm, dso, symbol, parent"),
+		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline, ..."
+		   " Please refer the man page for the complete list."),
 	OPT_STRING('t', "field-separator", &symbol_conf.field_sep, "separator",
 		   "separator for columns, no spaces will be added between "
 		   "columns '.' is reserved."),
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
 	OPT_UINTEGER('o', "order", &sort_compute, "Specify compute sorting."),
+	OPT_CALLBACK(0, "percentage", NULL, "relative|absolute",
+		     "How to display percentage of filtered entries", parse_filter_percentage),
 	OPT_END()
 };
 
 static double baseline_percent(struct hist_entry *he)
 {
-	struct hists *hists = he->hists;
-	return 100.0 * he->stat.period / hists->stats.total_period;
+	u64 total = hists__total_period(he->hists);
+
+	return 100.0 * he->stat.period / total;
 }
 
 static int hpp__color_baseline(struct perf_hpp_fmt *fmt,
@@ -1120,7 +1139,8 @@ static int data_init(int argc, const char **argv)
 
 int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
 {
-	sort_order = diff__default_sort_order;
+	perf_config(perf_default_config, NULL);
+
 	argc = parse_options(argc, argv, options, diff_usage, 0);
 
 	if (symbol__init() < 0)
@@ -1131,6 +1151,8 @@ int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	ui_init();
 
+	sort__mode = SORT_MODE__DIFF;
+
 	if (setup_sorting() < 0)
 		usage_with_options(diff_usage, options);
 
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 3a73875..6a3af00 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -209,7 +209,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
 
 	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
-	thread = machine__findnew_thread(machine, sample->pid, sample->pid);
+	thread = machine__findnew_thread(machine, sample->pid, sample->tid);
 	if (thread == NULL) {
 		pr_err("problem processing %d event, skipping it.\n",
 		       event->header.type);
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 929462a..bef3376 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -14,6 +14,7 @@
 #include "util/parse-options.h"
 #include "util/trace-event.h"
 #include "util/data.h"
+#include "util/cpumap.h"
 
 #include "util/debug.h"
 
@@ -31,9 +32,6 @@ static int			caller_lines = -1;
 
 static bool			raw_ip;
 
-static int			*cpunode_map;
-static int			max_cpu_num;
-
 struct alloc_stat {
 	u64	call_site;
 	u64	ptr;
@@ -55,76 +53,6 @@ static struct rb_root root_caller_sorted;
 static unsigned long total_requested, total_allocated;
 static unsigned long nr_allocs, nr_cross_allocs;
 
-#define PATH_SYS_NODE	"/sys/devices/system/node"
-
-static int init_cpunode_map(void)
-{
-	FILE *fp;
-	int i, err = -1;
-
-	fp = fopen("/sys/devices/system/cpu/kernel_max", "r");
-	if (!fp) {
-		max_cpu_num = 4096;
-		return 0;
-	}
-
-	if (fscanf(fp, "%d", &max_cpu_num) < 1) {
-		pr_err("Failed to read 'kernel_max' from sysfs");
-		goto out_close;
-	}
-
-	max_cpu_num++;
-
-	cpunode_map = calloc(max_cpu_num, sizeof(int));
-	if (!cpunode_map) {
-		pr_err("%s: calloc failed\n", __func__);
-		goto out_close;
-	}
-
-	for (i = 0; i < max_cpu_num; i++)
-		cpunode_map[i] = -1;
-
-	err = 0;
-out_close:
-	fclose(fp);
-	return err;
-}
-
-static int setup_cpunode_map(void)
-{
-	struct dirent *dent1, *dent2;
-	DIR *dir1, *dir2;
-	unsigned int cpu, mem;
-	char buf[PATH_MAX];
-
-	if (init_cpunode_map())
-		return -1;
-
-	dir1 = opendir(PATH_SYS_NODE);
-	if (!dir1)
-		return 0;
-
-	while ((dent1 = readdir(dir1)) != NULL) {
-		if (dent1->d_type != DT_DIR ||
-		    sscanf(dent1->d_name, "node%u", &mem) < 1)
-			continue;
-
-		snprintf(buf, PATH_MAX, "%s/%s", PATH_SYS_NODE, dent1->d_name);
-		dir2 = opendir(buf);
-		if (!dir2)
-			continue;
-		while ((dent2 = readdir(dir2)) != NULL) {
-			if (dent2->d_type != DT_LNK ||
-			    sscanf(dent2->d_name, "cpu%u", &cpu) < 1)
-				continue;
-			cpunode_map[cpu] = mem;
-		}
-		closedir(dir2);
-	}
-	closedir(dir1);
-	return 0;
-}
-
 static int insert_alloc_stat(unsigned long call_site, unsigned long ptr,
 			     int bytes_req, int bytes_alloc, int cpu)
 {
@@ -235,7 +163,7 @@ static int perf_evsel__process_alloc_node_event(struct perf_evsel *evsel,
 	int ret = perf_evsel__process_alloc_event(evsel, sample);
 
 	if (!ret) {
-		int node1 = cpunode_map[sample->cpu],
+		int node1 = cpu__get_node(sample->cpu),
 		    node2 = perf_evsel__intval(evsel, sample, "node");
 
 		if (node1 != node2)
@@ -307,7 +235,7 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 				struct machine *machine)
 {
 	struct thread *thread = machine__findnew_thread(machine, sample->pid,
-							sample->pid);
+							sample->tid);
 
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
@@ -756,11 +684,13 @@ int cmd_kmem(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "raw-ip", &raw_ip, "show raw ip instead of symbol"),
 	OPT_END()
 	};
-	const char * const kmem_usage[] = {
-		"perf kmem [<options>] {record|stat}",
+	const char *const kmem_subcommands[] = { "record", "stat", NULL };
+	const char *kmem_usage[] = {
+		NULL,
 		NULL
 	};
-	argc = parse_options(argc, argv, kmem_options, kmem_usage, 0);
+	argc = parse_options_subcommand(argc, argv, kmem_options,
+					kmem_subcommands, kmem_usage, 0);
 
 	if (!argc)
 		usage_with_options(kmem_usage, kmem_options);
@@ -770,7 +700,7 @@ int cmd_kmem(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (!strncmp(argv[0], "rec", 3)) {
 		return __cmd_record(argc, argv);
 	} else if (!strcmp(argv[0], "stat")) {
-		if (setup_cpunode_map())
+		if (cpu__setup_cpunode_map())
 			return -1;
 
 		if (list_empty(&caller_sort))
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index c852c7a..6148afc 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -961,8 +961,10 @@ int cmd_lock(int argc, const char **argv, const char *prefix __maybe_unused)
 		"perf lock info [<options>]",
 		NULL
 	};
-	const char * const lock_usage[] = {
-		"perf lock [<options>] {record|report|script|info}",
+	const char *const lock_subcommands[] = { "record", "report", "script",
+						 "info", NULL };
+	const char *lock_usage[] = {
+		NULL,
 		NULL
 	};
 	const char * const report_usage[] = {
@@ -976,8 +978,8 @@ int cmd_lock(int argc, const char **argv, const char *prefix __maybe_unused)
 	for (i = 0; i < LOCKHASH_SIZE; i++)
 		INIT_LIST_HEAD(lockhash_table + i);
 
-	argc = parse_options(argc, argv, lock_options, lock_usage,
-			     PARSE_OPT_STOP_AT_NON_OPTION);
+	argc = parse_options_subcommand(argc, argv, lock_options, lock_subcommands,
+					lock_usage, PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc)
 		usage_with_options(lock_usage, lock_options);
 
diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index 2e3ade69..4a1a6c9 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -21,11 +21,6 @@ struct perf_mem {
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 };
 
-static const char * const mem_usage[] = {
-	"perf mem [<options>] {record <command> |report}",
-	NULL
-};
-
 static int __cmd_record(int argc, const char **argv)
 {
 	int rec_argc, i = 0, j;
@@ -220,9 +215,15 @@ int cmd_mem(int argc, const char **argv, const char *prefix __maybe_unused)
 		   " between columns '.' is reserved."),
 	OPT_END()
 	};
+	const char *const mem_subcommands[] = { "record", "report", NULL };
+	const char *mem_usage[] = {
+		NULL,
+		NULL
+	};
+
 
-	argc = parse_options(argc, argv, mem_options, mem_usage,
-			     PARSE_OPT_STOP_AT_NON_OPTION);
+	argc = parse_options_subcommand(argc, argv, mem_options, mem_subcommands,
+					mem_usage, PARSE_OPT_STOP_AT_NON_OPTION);
 
 	if (!argc || !(strncmp(argv[0], "rec", 3) || mem_operation))
 		usage_with_options(mem_usage, mem_options);
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 8ce62ef..e4c85b8 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -30,37 +30,6 @@
 #include <sched.h>
 #include <sys/mman.h>
 
-#ifndef HAVE_ON_EXIT_SUPPORT
-#ifndef ATEXIT_MAX
-#define ATEXIT_MAX 32
-#endif
-static int __on_exit_count = 0;
-typedef void (*on_exit_func_t) (int, void *);
-static on_exit_func_t __on_exit_funcs[ATEXIT_MAX];
-static void *__on_exit_args[ATEXIT_MAX];
-static int __exitcode = 0;
-static void __handle_on_exit_funcs(void);
-static int on_exit(on_exit_func_t function, void *arg);
-#define exit(x) (exit)(__exitcode = (x))
-
-static int on_exit(on_exit_func_t function, void *arg)
-{
-	if (__on_exit_count == ATEXIT_MAX)
-		return -ENOMEM;
-	else if (__on_exit_count == 0)
-		atexit(__handle_on_exit_funcs);
-	__on_exit_funcs[__on_exit_count] = function;
-	__on_exit_args[__on_exit_count++] = arg;
-	return 0;
-}
-
-static void __handle_on_exit_funcs(void)
-{
-	int i;
-	for (i = 0; i < __on_exit_count; i++)
-		__on_exit_funcs[i] (__exitcode, __on_exit_args[i]);
-}
-#endif
 
 struct record {
 	struct perf_tool	tool;
@@ -147,29 +116,19 @@ static void sig_handler(int sig)
 {
 	if (sig == SIGCHLD)
 		child_finished = 1;
+	else
+		signr = sig;
 
 	done = 1;
-	signr = sig;
 }
 
-static void record__sig_exit(int exit_status __maybe_unused, void *arg)
+static void record__sig_exit(void)
 {
-	struct record *rec = arg;
-	int status;
-
-	if (rec->evlist->workload.pid > 0) {
-		if (!child_finished)
-			kill(rec->evlist->workload.pid, SIGTERM);
-
-		wait(&status);
-		if (WIFSIGNALED(status))
-			psignal(WTERMSIG(status), rec->progname);
-	}
-
-	if (signr == -1 || signr == SIGUSR1)
+	if (signr == -1)
 		return;
 
 	signal(signr, SIG_DFL);
+	raise(signr);
 }
 
 static int record__open(struct record *rec)
@@ -243,27 +202,6 @@ static int process_buildids(struct record *rec)
 					      size, &build_id__mark_dso_hit_ops);
 }
 
-static void record__exit(int status, void *arg)
-{
-	struct record *rec = arg;
-	struct perf_data_file *file = &rec->file;
-
-	if (status != 0)
-		return;
-
-	if (!file->is_pipe) {
-		rec->session->header.data_size += rec->bytes_written;
-
-		if (!rec->no_buildid)
-			process_buildids(rec);
-		perf_session__write_header(rec->session, rec->evlist,
-					   file->fd, true);
-		perf_session__delete(rec->session);
-		perf_evlist__delete(rec->evlist);
-		symbol__exit();
-	}
-}
-
 static void perf_event__synthesize_guest_os(struct machine *machine, void *data)
 {
 	int err;
@@ -344,18 +282,19 @@ static volatile int workload_exec_errno;
  * if the fork fails, since we asked by setting its
  * want_signal to true.
  */
-static void workload_exec_failed_signal(int signo, siginfo_t *info,
+static void workload_exec_failed_signal(int signo __maybe_unused,
+					siginfo_t *info,
 					void *ucontext __maybe_unused)
 {
 	workload_exec_errno = info->si_value.sival_int;
 	done = 1;
-	signr = signo;
 	child_finished = 1;
 }
 
 static int __cmd_record(struct record *rec, int argc, const char **argv)
 {
 	int err;
+	int status = 0;
 	unsigned long waking = 0;
 	const bool forks = argc > 0;
 	struct machine *machine;
@@ -367,7 +306,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 
 	rec->progname = argv[0];
 
-	on_exit(record__sig_exit, rec);
+	atexit(record__sig_exit);
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
 	signal(SIGTERM, sig_handler);
@@ -388,32 +327,28 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 						    workload_exec_failed_signal);
 		if (err < 0) {
 			pr_err("Couldn't run the workload!\n");
+			status = err;
 			goto out_delete_session;
 		}
 	}
 
 	if (record__open(rec) != 0) {
 		err = -1;
-		goto out_delete_session;
+		goto out_child;
 	}
 
 	if (!rec->evlist->nr_groups)
 		perf_header__clear_feat(&session->header, HEADER_GROUP_DESC);
 
-	/*
-	 * perf_session__delete(session) will be called at record__exit()
-	 */
-	on_exit(record__exit, rec);
-
 	if (file->is_pipe) {
 		err = perf_header__write_pipe(file->fd);
 		if (err < 0)
-			goto out_delete_session;
+			goto out_child;
 	} else {
 		err = perf_session__write_header(session, rec->evlist,
 						 file->fd, false);
 		if (err < 0)
-			goto out_delete_session;
+			goto out_child;
 	}
 
 	if (!rec->no_buildid
@@ -421,7 +356,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		pr_err("Couldn't generate buildids. "
 		       "Use --no-buildid to profile anyway.\n");
 		err = -1;
-		goto out_delete_session;
+		goto out_child;
 	}
 
 	machine = &session->machines.host;
@@ -431,7 +366,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 						   process_synthesized_event);
 		if (err < 0) {
 			pr_err("Couldn't synthesize attrs.\n");
-			goto out_delete_session;
+			goto out_child;
 		}
 
 		if (have_tracepoints(&rec->evlist->entries)) {
@@ -447,7 +382,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 								  process_synthesized_event);
 			if (err <= 0) {
 				pr_err("Couldn't record tracing data.\n");
-				goto out_delete_session;
+				goto out_child;
 			}
 			rec->bytes_written += err;
 		}
@@ -475,7 +410,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 	err = __machine__synthesize_threads(machine, tool, &opts->target, rec->evlist->threads,
 					    process_synthesized_event, opts->sample_address);
 	if (err != 0)
-		goto out_delete_session;
+		goto out_child;
 
 	if (rec->realtime_prio) {
 		struct sched_param param;
@@ -484,7 +419,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		if (sched_setscheduler(0, SCHED_FIFO, &param)) {
 			pr_err("Could not set realtime priority.\n");
 			err = -1;
-			goto out_delete_session;
+			goto out_child;
 		}
 	}
 
@@ -512,13 +447,15 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 
 		if (record__mmap_read_all(rec) < 0) {
 			err = -1;
-			goto out_delete_session;
+			goto out_child;
 		}
 
 		if (hits == rec->samples) {
 			if (done)
 				break;
 			err = poll(rec->evlist->pollfd, rec->evlist->nr_fds, -1);
+			if (err < 0 && errno == EINTR)
+				err = 0;
 			waking++;
 		}
 
@@ -538,28 +475,52 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		const char *emsg = strerror_r(workload_exec_errno, msg, sizeof(msg));
 		pr_err("Workload failed: %s\n", emsg);
 		err = -1;
-		goto out_delete_session;
+		goto out_child;
 	}
 
-	if (quiet || signr == SIGUSR1)
-		return 0;
+	if (!quiet) {
+		fprintf(stderr, "[ perf record: Woken up %ld times to write data ]\n", waking);
 
-	fprintf(stderr, "[ perf record: Woken up %ld times to write data ]\n", waking);
+		/*
+		 * Approximate RIP event size: 24 bytes.
+		 */
+		fprintf(stderr,
+			"[ perf record: Captured and wrote %.3f MB %s (~%" PRIu64 " samples) ]\n",
+			(double)rec->bytes_written / 1024.0 / 1024.0,
+			file->path,
+			rec->bytes_written / 24);
+	}
 
-	/*
-	 * Approximate RIP event size: 24 bytes.
-	 */
-	fprintf(stderr,
-		"[ perf record: Captured and wrote %.3f MB %s (~%" PRIu64 " samples) ]\n",
-		(double)rec->bytes_written / 1024.0 / 1024.0,
-		file->path,
-		rec->bytes_written / 24);
+out_child:
+	if (forks) {
+		int exit_status;
 
-	return 0;
+		if (!child_finished)
+			kill(rec->evlist->workload.pid, SIGTERM);
+
+		wait(&exit_status);
+
+		if (err < 0)
+			status = err;
+		else if (WIFEXITED(exit_status))
+			status = WEXITSTATUS(exit_status);
+		else if (WIFSIGNALED(exit_status))
+			signr = WTERMSIG(exit_status);
+	} else
+		status = err;
+
+	if (!err && !file->is_pipe) {
+		rec->session->header.data_size += rec->bytes_written;
+
+		if (!rec->no_buildid)
+			process_buildids(rec);
+		perf_session__write_header(rec->session, rec->evlist,
+					   file->fd, true);
+	}
 
 out_delete_session:
 	perf_session__delete(session);
-	return err;
+	return status;
 }
 
 #define BRANCH_OPT(n, m) \
@@ -988,6 +949,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	err = __cmd_record(&record, argc, argv);
 out_symbol_exit:
+	perf_evlist__delete(rec->evlist);
 	symbol__exit();
 	return err;
 }
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index c8f2113..bc0eec1 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -57,6 +57,7 @@ struct report {
 	const char		*cpu_list;
 	const char		*symbol_filter_str;
 	float			min_percent;
+	u64			nr_entries;
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 };
 
@@ -75,6 +76,27 @@ static int report__config(const char *var, const char *value, void *cb)
 	return perf_default_config(var, value, cb);
 }
 
+static void report__inc_stats(struct report *rep, struct hist_entry *he)
+{
+	/*
+	 * The @he is either of a newly created one or an existing one
+	 * merging current sample.  We only want to count a new one so
+	 * checking ->nr_events being 1.
+	 */
+	if (he->stat.nr_events == 1)
+		rep->nr_entries++;
+
+	/*
+	 * Only counts number of samples at this stage as it's more
+	 * natural to do it here and non-sample events are also
+	 * counted in perf_session_deliver_event().  The dump_trace
+	 * requires this info is ready before going to the output tree.
+	 */
+	hists__inc_nr_events(he->hists, PERF_RECORD_SAMPLE);
+	if (!he->filtered)
+		he->hists->stats.nr_non_filtered_samples++;
+}
+
 static int report__add_mem_hist_entry(struct report *rep, struct addr_location *al,
 				      struct perf_sample *sample, struct perf_evsel *evsel)
 {
@@ -121,8 +143,8 @@ static int report__add_mem_hist_entry(struct report *rep, struct addr_location *
 			goto out;
 	}
 
-	evsel->hists.stats.total_period += cost;
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+	report__inc_stats(rep, he);
+
 	err = hist_entry__append_callchain(he, sample);
 out:
 	return err;
@@ -173,9 +195,7 @@ static int report__add_branch_hist_entry(struct report *rep, struct addr_locatio
 				if (err)
 					goto out;
 			}
-
-			evsel->hists.stats.total_period += 1;
-			hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+			report__inc_stats(rep, he);
 		} else
 			goto out;
 	}
@@ -208,8 +228,8 @@ static int report__add_hist_entry(struct report *rep, struct perf_evsel *evsel,
 	if (ui__has_annotation())
 		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
 
-	evsel->hists.stats.total_period += sample->period;
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+	report__inc_stats(rep, he);
+
 out:
 	return err;
 }
@@ -337,6 +357,11 @@ static size_t hists__fprintf_nr_sample_events(struct hists *hists, struct report
 	char buf[512];
 	size_t size = sizeof(buf);
 
+	if (symbol_conf.filter_relative) {
+		nr_samples = hists->stats.nr_non_filtered_samples;
+		nr_events = hists->stats.total_non_filtered_period;
+	}
+
 	if (perf_evsel__is_group_event(evsel)) {
 		struct perf_evsel *pos;
 
@@ -344,8 +369,13 @@ static size_t hists__fprintf_nr_sample_events(struct hists *hists, struct report
 		evname = buf;
 
 		for_each_group_member(pos, evsel) {
-			nr_samples += pos->hists.stats.nr_events[PERF_RECORD_SAMPLE];
-			nr_events += pos->hists.stats.total_period;
+			if (symbol_conf.filter_relative) {
+				nr_samples += pos->hists.stats.nr_non_filtered_samples;
+				nr_events += pos->hists.stats.total_non_filtered_period;
+			} else {
+				nr_samples += pos->hists.stats.nr_events[PERF_RECORD_SAMPLE];
+				nr_events += pos->hists.stats.total_period;
+			}
 		}
 	}
 
@@ -470,24 +500,12 @@ static int report__browse_hists(struct report *rep)
 	return ret;
 }
 
-static u64 report__collapse_hists(struct report *rep)
+static void report__collapse_hists(struct report *rep)
 {
 	struct ui_progress prog;
 	struct perf_evsel *pos;
-	u64 nr_samples = 0;
-	/*
- 	 * Count number of histogram entries to use when showing progress,
- 	 * reusing nr_samples variable.
- 	 */
-	evlist__for_each(rep->session->evlist, pos)
-		nr_samples += pos->hists.nr_entries;
 
-	ui_progress__init(&prog, nr_samples, "Merging related events...");
-	/*
-	 * Count total number of samples, will be used to check if this
- 	 * session had any.
- 	 */
-	nr_samples = 0;
+	ui_progress__init(&prog, rep->nr_entries, "Merging related events...");
 
 	evlist__for_each(rep->session->evlist, pos) {
 		struct hists *hists = &pos->hists;
@@ -496,7 +514,6 @@ static u64 report__collapse_hists(struct report *rep)
 			hists->symbol_filter_str = rep->symbol_filter_str;
 
 		hists__collapse_resort(hists, &prog);
-		nr_samples += hists->stats.nr_events[PERF_RECORD_SAMPLE];
 
 		/* Non-group events are considered as leader */
 		if (symbol_conf.event_group &&
@@ -509,14 +526,11 @@ static u64 report__collapse_hists(struct report *rep)
 	}
 
 	ui_progress__finish();
-
-	return nr_samples;
 }
 
 static int __cmd_report(struct report *rep)
 {
 	int ret;
-	u64 nr_samples;
 	struct perf_session *session = rep->session;
 	struct perf_evsel *pos;
 	struct perf_data_file *file = session->file;
@@ -556,12 +570,12 @@ static int __cmd_report(struct report *rep)
 		}
 	}
 
-	nr_samples = report__collapse_hists(rep);
+	report__collapse_hists(rep);
 
 	if (session_done())
 		return 0;
 
-	if (nr_samples == 0) {
+	if (rep->nr_entries == 0) {
 		ui__error("The %s file has no samples!\n", file->path);
 		return 0;
 	}
@@ -573,11 +587,9 @@ static int __cmd_report(struct report *rep)
 }
 
 static int
-parse_callchain_opt(const struct option *opt, const char *arg, int unset)
+report_parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 {
 	struct report *rep = (struct report *)opt->value;
-	char *tok, *tok2;
-	char *endptr;
 
 	/*
 	 * --no-call-graph
@@ -587,80 +599,7 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 		return 0;
 	}
 
-	symbol_conf.use_callchain = true;
-
-	if (!arg)
-		return 0;
-
-	tok = strtok((char *)arg, ",");
-	if (!tok)
-		return -1;
-
-	/* get the output mode */
-	if (!strncmp(tok, "graph", strlen(arg)))
-		callchain_param.mode = CHAIN_GRAPH_ABS;
-
-	else if (!strncmp(tok, "flat", strlen(arg)))
-		callchain_param.mode = CHAIN_FLAT;
-
-	else if (!strncmp(tok, "fractal", strlen(arg)))
-		callchain_param.mode = CHAIN_GRAPH_REL;
-
-	else if (!strncmp(tok, "none", strlen(arg))) {
-		callchain_param.mode = CHAIN_NONE;
-		symbol_conf.use_callchain = false;
-
-		return 0;
-	}
-
-	else
-		return -1;
-
-	/* get the min percentage */
-	tok = strtok(NULL, ",");
-	if (!tok)
-		goto setup;
-
-	callchain_param.min_percent = strtod(tok, &endptr);
-	if (tok == endptr)
-		return -1;
-
-	/* get the print limit */
-	tok2 = strtok(NULL, ",");
-	if (!tok2)
-		goto setup;
-
-	if (tok2[0] != 'c') {
-		callchain_param.print_limit = strtoul(tok2, &endptr, 0);
-		tok2 = strtok(NULL, ",");
-		if (!tok2)
-			goto setup;
-	}
-
-	/* get the call chain order */
-	if (!strncmp(tok2, "caller", strlen("caller")))
-		callchain_param.order = ORDER_CALLER;
-	else if (!strncmp(tok2, "callee", strlen("callee")))
-		callchain_param.order = ORDER_CALLEE;
-	else
-		return -1;
-
-	/* Get the sort key */
-	tok2 = strtok(NULL, ",");
-	if (!tok2)
-		goto setup;
-	if (!strncmp(tok2, "function", strlen("function")))
-		callchain_param.key = CCKEY_FUNCTION;
-	else if (!strncmp(tok2, "address", strlen("address")))
-		callchain_param.key = CCKEY_ADDRESS;
-	else
-		return -1;
-setup:
-	if (callchain_register_param(&callchain_param) < 0) {
-		pr_err("Can't register callchain params\n");
-		return -1;
-	}
-	return 0;
+	return parse_callchain_report_opt(arg);
 }
 
 int
@@ -760,10 +699,10 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "header-only", &report.header_only,
 		    "Show only data header."),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
-		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline,"
-		   " dso_to, dso_from, symbol_to, symbol_from, mispredict,"
-		   " weight, local_weight, mem, symbol_daddr, dso_daddr, tlb, "
-		   "snoop, locked, abort, in_tx, transaction"),
+		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline, ..."
+		   " Please refer the man page for the complete list."),
+	OPT_STRING('F', "fields", &field_order, "key[,keys...]",
+		   "output field(s): overhead, period, sample plus all of sort keys"),
 	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
 		    "Show sample percentage for different cpu modes"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
@@ -772,7 +711,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Only display entries with parent-match"),
 	OPT_CALLBACK_DEFAULT('g', "call-graph", &report, "output_type,min_percent[,print_limit],call_order",
 		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold, optional print limit, callchain order, key (function or address). "
-		     "Default: fractal,0.5,callee,function", &parse_callchain_opt, callchain_default_opt),
+		     "Default: fractal,0.5,callee,function", &report_parse_callchain_opt, callchain_default_opt),
 	OPT_INTEGER(0, "max-stack", &report.max_stack,
 		    "Set the maximum stack depth when parsing the callchain, "
 		    "anything beyond the specified depth will be ignored. "
@@ -823,6 +762,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "mem-mode", &report.mem_mode, "mem access profile"),
 	OPT_CALLBACK(0, "percent-limit", &report, "percent",
 		     "Don't show entries under that percent", parse_percent_limit),
+	OPT_CALLBACK(0, "percentage", NULL, "relative|absolute",
+		     "how to display percentage of filtered entries", parse_filter_percentage),
 	OPT_END()
 	};
 	struct perf_data_file file = {
@@ -866,52 +807,31 @@ repeat:
 	if (branch_mode == -1 && has_br_stack)
 		sort__mode = SORT_MODE__BRANCH;
 
-	/* sort__mode could be NORMAL if --no-branch-stack */
-	if (sort__mode == SORT_MODE__BRANCH) {
-		/*
-		 * if no sort_order is provided, then specify
-		 * branch-mode specific order
-		 */
-		if (sort_order == default_sort_order)
-			sort_order = "comm,dso_from,symbol_from,"
-				     "dso_to,symbol_to";
-
-	}
 	if (report.mem_mode) {
 		if (sort__mode == SORT_MODE__BRANCH) {
 			pr_err("branch and mem mode incompatible\n");
 			goto error;
 		}
 		sort__mode = SORT_MODE__MEMORY;
-
-		/*
-		 * if no sort_order is provided, then specify
-		 * branch-mode specific order
-		 */
-		if (sort_order == default_sort_order)
-			sort_order = "local_weight,mem,sym,dso,symbol_daddr,dso_daddr,snoop,tlb,locked";
 	}
 
 	if (setup_sorting() < 0) {
-		parse_options_usage(report_usage, options, "s", 1);
+		if (sort_order)
+			parse_options_usage(report_usage, options, "s", 1);
+		if (field_order)
+			parse_options_usage(sort_order ? NULL : report_usage,
+					    options, "F", 1);
 		goto error;
 	}
 
-	if (parent_pattern != default_parent_pattern) {
-		if (sort_dimension__add("parent") < 0)
-			goto error;
-	}
-
 	/* Force tty output for header output. */
 	if (report.header || report.header_only)
 		use_browser = 0;
 
 	if (strcmp(input_name, "-") != 0)
 		setup_browser(true);
-	else {
+	else
 		use_browser = 0;
-		perf_hpp__init();
-	}
 
 	if (report.header || report.header_only) {
 		perf_session__fprintf_info(session, stdout,
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 9ac0a49..d717683 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -66,7 +66,7 @@ struct sched_atom {
 	struct task_desc	*wakee;
 };
 
-#define TASK_STATE_TO_CHAR_STR "RSDTtZX"
+#define TASK_STATE_TO_CHAR_STR "RSDTtZXxKWP"
 
 enum thread_state {
 	THREAD_SLEEPING = 0,
@@ -149,7 +149,6 @@ struct perf_sched {
 	unsigned long	 nr_runs;
 	unsigned long	 nr_timestamps;
 	unsigned long	 nr_unordered_timestamps;
-	unsigned long	 nr_state_machine_bugs;
 	unsigned long	 nr_context_switch_bugs;
 	unsigned long	 nr_events;
 	unsigned long	 nr_lost_chunks;
@@ -1007,17 +1006,12 @@ static int latency_wakeup_event(struct perf_sched *sched,
 				struct perf_sample *sample,
 				struct machine *machine)
 {
-	const u32 pid	  = perf_evsel__intval(evsel, sample, "pid"),
-		  success = perf_evsel__intval(evsel, sample, "success");
+	const u32 pid	  = perf_evsel__intval(evsel, sample, "pid");
 	struct work_atoms *atoms;
 	struct work_atom *atom;
 	struct thread *wakee;
 	u64 timestamp = sample->time;
 
-	/* Note for later, it may be interesting to observe the failing cases */
-	if (!success)
-		return 0;
-
 	wakee = machine__findnew_thread(machine, 0, pid);
 	atoms = thread_atoms_search(&sched->atom_root, wakee, &sched->cmp_pid);
 	if (!atoms) {
@@ -1037,12 +1031,18 @@ static int latency_wakeup_event(struct perf_sched *sched,
 	atom = list_entry(atoms->work_list.prev, struct work_atom, list);
 
 	/*
+	 * As we do not guarantee the wakeup event happens when
+	 * task is out of run queue, also may happen when task is
+	 * on run queue and wakeup only change ->state to TASK_RUNNING,
+	 * then we should not set the ->wake_up_time when wake up a
+	 * task which is on run queue.
+	 *
 	 * You WILL be missing events if you've recorded only
 	 * one CPU, or are only looking at only one, so don't
-	 * make useless noise.
+	 * skip in this case.
 	 */
 	if (sched->profile_cpu == -1 && atom->state != THREAD_SLEEPING)
-		sched->nr_state_machine_bugs++;
+		return 0;
 
 	sched->nr_timestamps++;
 	if (atom->sched_out_time > timestamp) {
@@ -1266,9 +1266,8 @@ static int process_sched_wakeup_event(struct perf_tool *tool,
 static int map_switch_event(struct perf_sched *sched, struct perf_evsel *evsel,
 			    struct perf_sample *sample, struct machine *machine)
 {
-	const u32 prev_pid = perf_evsel__intval(evsel, sample, "prev_pid"),
-		  next_pid = perf_evsel__intval(evsel, sample, "next_pid");
-	struct thread *sched_out __maybe_unused, *sched_in;
+	const u32 next_pid = perf_evsel__intval(evsel, sample, "next_pid");
+	struct thread *sched_in;
 	int new_shortname;
 	u64 timestamp0, timestamp = sample->time;
 	s64 delta;
@@ -1291,7 +1290,6 @@ static int map_switch_event(struct perf_sched *sched, struct perf_evsel *evsel,
 		return -1;
 	}
 
-	sched_out = machine__findnew_thread(machine, 0, prev_pid);
 	sched_in = machine__findnew_thread(machine, 0, next_pid);
 
 	sched->curr_thread[this_cpu] = sched_in;
@@ -1300,17 +1298,25 @@ static int map_switch_event(struct perf_sched *sched, struct perf_evsel *evsel,
 
 	new_shortname = 0;
 	if (!sched_in->shortname[0]) {
-		sched_in->shortname[0] = sched->next_shortname1;
-		sched_in->shortname[1] = sched->next_shortname2;
-
-		if (sched->next_shortname1 < 'Z') {
-			sched->next_shortname1++;
+		if (!strcmp(thread__comm_str(sched_in), "swapper")) {
+			/*
+			 * Don't allocate a letter-number for swapper:0
+			 * as a shortname. Instead, we use '.' for it.
+			 */
+			sched_in->shortname[0] = '.';
+			sched_in->shortname[1] = ' ';
 		} else {
-			sched->next_shortname1='A';
-			if (sched->next_shortname2 < '9') {
-				sched->next_shortname2++;
+			sched_in->shortname[0] = sched->next_shortname1;
+			sched_in->shortname[1] = sched->next_shortname2;
+
+			if (sched->next_shortname1 < 'Z') {
+				sched->next_shortname1++;
 			} else {
-				sched->next_shortname2='0';
+				sched->next_shortname1 = 'A';
+				if (sched->next_shortname2 < '9')
+					sched->next_shortname2++;
+				else
+					sched->next_shortname2 = '0';
 			}
 		}
 		new_shortname = 1;
@@ -1322,12 +1328,9 @@ static int map_switch_event(struct perf_sched *sched, struct perf_evsel *evsel,
 		else
 			printf("*");
 
-		if (sched->curr_thread[cpu]) {
-			if (sched->curr_thread[cpu]->tid)
-				printf("%2s ", sched->curr_thread[cpu]->shortname);
-			else
-				printf(".  ");
-		} else
+		if (sched->curr_thread[cpu])
+			printf("%2s ", sched->curr_thread[cpu]->shortname);
+		else
 			printf("   ");
 	}
 
@@ -1496,14 +1499,6 @@ static void print_bad_events(struct perf_sched *sched)
 			(double)sched->nr_lost_events/(double)sched->nr_events * 100.0,
 			sched->nr_lost_events, sched->nr_events, sched->nr_lost_chunks);
 	}
-	if (sched->nr_state_machine_bugs && sched->nr_timestamps) {
-		printf("  INFO: %.3f%% state machine bugs (%ld out of %ld)",
-			(double)sched->nr_state_machine_bugs/(double)sched->nr_timestamps*100.0,
-			sched->nr_state_machine_bugs, sched->nr_timestamps);
-		if (sched->nr_lost_events)
-			printf(" (due to lost events?)");
-		printf("\n");
-	}
 	if (sched->nr_context_switch_bugs && sched->nr_timestamps) {
 		printf("  INFO: %.3f%% context switch bugs (%ld out of %ld)",
 			(double)sched->nr_context_switch_bugs/(double)sched->nr_timestamps*100.0,
@@ -1635,6 +1630,7 @@ static int __cmd_record(int argc, const char **argv)
 		"-e", "sched:sched_stat_runtime",
 		"-e", "sched:sched_process_fork",
 		"-e", "sched:sched_wakeup",
+		"-e", "sched:sched_wakeup_new",
 		"-e", "sched:sched_migrate_task",
 	};
 
@@ -1713,8 +1709,10 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 		"perf sched replay [<options>]",
 		NULL
 	};
-	const char * const sched_usage[] = {
-		"perf sched [<options>] {record|latency|map|replay|script}",
+	const char *const sched_subcommands[] = { "record", "latency", "map",
+						  "replay", "script", NULL };
+	const char *sched_usage[] = {
+		NULL,
 		NULL
 	};
 	struct trace_sched_handler lat_ops  = {
@@ -1736,8 +1734,8 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 	for (i = 0; i < ARRAY_SIZE(sched.curr_pid); i++)
 		sched.curr_pid[i] = -1;
 
-	argc = parse_options(argc, argv, sched_options, sched_usage,
-			     PARSE_OPT_STOP_AT_NON_OPTION);
+	argc = parse_options_subcommand(argc, argv, sched_options, sched_subcommands,
+					sched_usage, PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc)
 		usage_with_options(sched_usage, sched_options);
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 65aaa5b..5b389ce 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -253,6 +253,9 @@ static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 		return NULL;
 
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+	if (!he->filtered)
+		evsel->hists.stats.nr_non_filtered_samples++;
+
 	return he;
 }
 
@@ -694,8 +697,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
 	if (event->header.misc & PERF_RECORD_MISC_EXACT_IP)
 		top->exact_samples++;
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0 ||
-	    al.filtered)
+	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0)
 		return;
 
 	if (!top->kptr_restrict_warned &&
@@ -1081,8 +1083,10 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
-		   "sort by key(s): pid, comm, dso, symbol, parent, weight, local_weight,"
-		   " abort, in_tx, transaction"),
+		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline, ..."
+		   " Please refer the man page for the complete list."),
+	OPT_STRING(0, "fields", &field_order, "key[,keys...]",
+		   "output field(s): overhead, period, sample plus all of sort keys"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
 	OPT_CALLBACK_NOOPT('g', NULL, &top.record_opts,
@@ -1116,6 +1120,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_STRING('u', "uid", &target->uid_str, "user", "user to profile"),
 	OPT_CALLBACK(0, "percent-limit", &top, "percent",
 		     "Don't show entries under that percent", parse_percent_limit),
+	OPT_CALLBACK(0, "percentage", NULL, "relative|absolute",
+		     "How to display percentage of filtered entries", parse_filter_percentage),
 	OPT_END()
 	};
 	const char * const top_usage[] = {
@@ -1133,17 +1139,19 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (argc)
 		usage_with_options(top_usage, options);
 
-	if (sort_order == default_sort_order)
-		sort_order = "dso,symbol";
+	sort__mode = SORT_MODE__TOP;
+	/* display thread wants entries to be collapsed in a different tree */
+	sort__need_collapse = 1;
 
 	if (setup_sorting() < 0) {
-		parse_options_usage(top_usage, options, "s", 1);
+		if (sort_order)
+			parse_options_usage(top_usage, options, "s", 1);
+		if (field_order)
+			parse_options_usage(sort_order ? NULL : top_usage,
+					    options, "fields", 0);
 		goto out_delete_evlist;
 	}
 
-	/* display thread wants entries to be collapsed in a different tree */
-	sort__need_collapse = 1;
-
 	if (top.use_stdio)
 		use_browser = 0;
 	else if (top.use_tui)
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 802cf54..729bbdf 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -29,16 +29,22 @@ ifeq ($(ARCH),x86)
   endif
   NO_PERF_REGS := 0
 endif
+
 ifeq ($(ARCH),arm)
   NO_PERF_REGS := 0
   LIBUNWIND_LIBS = -lunwind -lunwind-arm
 endif
 
-# So far there's only x86 libdw unwind support merged in perf.
+ifeq ($(ARCH),arm64)
+  NO_PERF_REGS := 0
+  LIBUNWIND_LIBS = -lunwind -lunwind-aarch64
+endif
+
+# So far there's only x86 and arm libdw unwind support merged in perf.
 # Disable it on all other architectures in case libdw unwind
 # support is detected in system. Add supported architectures
 # to the check.
-ifneq ($(ARCH),x86)
+ifneq ($(ARCH),$(filter $(ARCH),x86 arm))
   NO_LIBDW_DWARF_UNWIND := 1
 endif
 
@@ -168,7 +174,6 @@ CORE_FEATURE_TESTS =			\
 	libpython-version		\
 	libslang			\
 	libunwind			\
-	on-exit				\
 	stackprotector-all		\
 	timerfd				\
 	libdw-dwarf-unwind
@@ -194,7 +199,6 @@ VF_FEATURE_TESTS =			\
 	libelf-getphdrnum		\
 	libelf-mmap			\
 	libpython-version		\
-	on-exit				\
 	stackprotector-all		\
 	timerfd				\
 	libunwind-debug-frame		\
@@ -370,7 +374,7 @@ else
 endif
 
 ifndef NO_LIBUNWIND
-  ifeq ($(ARCH),arm)
+  ifeq ($(ARCH),$(filter $(ARCH),arm arm64))
     $(call feature_check,libunwind-debug-frame)
     ifneq ($(feature-libunwind-debug-frame), 1)
       msg := $(warning No debug_frame support found in libunwind);
@@ -565,12 +569,6 @@ ifneq ($(filter -lbfd,$(EXTLIBS)),)
   CFLAGS += -DHAVE_LIBBFD_SUPPORT
 endif
 
-ifndef NO_ON_EXIT
-  ifeq ($(feature-on-exit), 1)
-    CFLAGS += -DHAVE_ON_EXIT_SUPPORT
-  endif
-endif
-
 ifndef NO_BACKTRACE
   ifeq ($(feature-backtrace), 1)
     CFLAGS += -DHAVE_BACKTRACE_SUPPORT
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 2da103c..64c84e5 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -24,7 +24,6 @@ FILES=					\
 	test-libslang.bin		\
 	test-libunwind.bin		\
 	test-libunwind-debug-frame.bin	\
-	test-on-exit.bin		\
 	test-stackprotector-all.bin	\
 	test-timerfd.bin		\
 	test-libdw-dwarf-unwind.bin
@@ -133,9 +132,6 @@ test-liberty-z.bin:
 test-cplus-demangle.bin:
 	$(BUILD) -liberty
 
-test-on-exit.bin:
-	$(BUILD)
-
 test-backtrace.bin:
 	$(BUILD)
 
diff --git a/tools/perf/config/feature-checks/test-all.c b/tools/perf/config/feature-checks/test-all.c
index fc37eb3..fe5c1e5 100644
--- a/tools/perf/config/feature-checks/test-all.c
+++ b/tools/perf/config/feature-checks/test-all.c
@@ -69,10 +69,6 @@
 # include "test-libbfd.c"
 #undef main
 
-#define main main_test_on_exit
-# include "test-on-exit.c"
-#undef main
-
 #define main main_test_backtrace
 # include "test-backtrace.c"
 #undef main
@@ -110,7 +106,6 @@ int main(int argc, char *argv[])
 	main_test_gtk2(argc, argv);
 	main_test_gtk2_infobar(argc, argv);
 	main_test_libbfd();
-	main_test_on_exit();
 	main_test_backtrace();
 	main_test_libnuma();
 	main_test_timerfd();
diff --git a/tools/perf/config/feature-checks/test-on-exit.c b/tools/perf/config/feature-checks/test-on-exit.c
deleted file mode 100644
index 8e88b16..0000000
--- a/tools/perf/config/feature-checks/test-on-exit.c
+++ /dev/null
@@ -1,16 +0,0 @@
-#include <stdio.h>
-#include <stdlib.h>
-
-static void exit_fn(int status, void *__data)
-{
-	printf("exit status: %d, data: %d\n", status, *(int *)__data);
-}
-
-static int data = 123;
-
-int main(void)
-{
-	on_exit(exit_fn, &data);
-
-	return 321;
-}
diff --git a/tools/perf/perf-completion.sh b/tools/perf/perf-completion.sh
index ae3a576..3356984 100644
--- a/tools/perf/perf-completion.sh
+++ b/tools/perf/perf-completion.sh
@@ -121,8 +121,8 @@ __perf_main ()
 	elif [[ $prev == "-e" && "${words[1]}" == @(record|stat|top) ]]; then
 		evts=$($cmd list --raw-dump)
 		__perfcomp_colon "$evts" "$cur"
-	# List subcommands for 'perf kvm'
-	elif [[ $prev == "kvm" ]]; then
+	# List subcommands for perf commands
+	elif [[ $prev == @(kvm|kmem|mem|lock|sched) ]]; then
 		subcmds=$($cmd $prev --list-cmds)
 		__perfcomp_colon "$subcmds" "$cur"
 	# List long option names
diff --git a/tools/perf/perf-sys.h b/tools/perf/perf-sys.h
new file mode 100644
index 0000000..5268a14
--- /dev/null
+++ b/tools/perf/perf-sys.h
@@ -0,0 +1,190 @@
+#ifndef _PERF_SYS_H
+#define _PERF_SYS_H
+
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/syscall.h>
+#include <linux/types.h>
+#include <linux/perf_event.h>
+#include <asm/unistd.h>
+
+#if defined(__i386__)
+#define mb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
+#define wmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
+#define rmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
+#define cpu_relax()	asm volatile("rep; nop" ::: "memory");
+#define CPUINFO_PROC	"model name"
+#ifndef __NR_perf_event_open
+# define __NR_perf_event_open 336
+#endif
+#ifndef __NR_futex
+# define __NR_futex 240
+#endif
+#ifndef __NR_gettid
+# define __NR_gettid 224
+#endif
+#endif
+
+#if defined(__x86_64__)
+#define mb()		asm volatile("mfence" ::: "memory")
+#define wmb()		asm volatile("sfence" ::: "memory")
+#define rmb()		asm volatile("lfence" ::: "memory")
+#define cpu_relax()	asm volatile("rep; nop" ::: "memory");
+#define CPUINFO_PROC	"model name"
+#ifndef __NR_perf_event_open
+# define __NR_perf_event_open 298
+#endif
+#ifndef __NR_futex
+# define __NR_futex 202
+#endif
+#ifndef __NR_gettid
+# define __NR_gettid 186
+#endif
+#endif
+
+#ifdef __powerpc__
+#include "../../arch/powerpc/include/uapi/asm/unistd.h"
+#define mb()		asm volatile ("sync" ::: "memory")
+#define wmb()		asm volatile ("sync" ::: "memory")
+#define rmb()		asm volatile ("sync" ::: "memory")
+#define CPUINFO_PROC	"cpu"
+#endif
+
+#ifdef __s390__
+#define mb()		asm volatile("bcr 15,0" ::: "memory")
+#define wmb()		asm volatile("bcr 15,0" ::: "memory")
+#define rmb()		asm volatile("bcr 15,0" ::: "memory")
+#endif
+
+#ifdef __sh__
+#if defined(__SH4A__) || defined(__SH5__)
+# define mb()		asm volatile("synco" ::: "memory")
+# define wmb()		asm volatile("synco" ::: "memory")
+# define rmb()		asm volatile("synco" ::: "memory")
+#else
+# define mb()		asm volatile("" ::: "memory")
+# define wmb()		asm volatile("" ::: "memory")
+# define rmb()		asm volatile("" ::: "memory")
+#endif
+#define CPUINFO_PROC	"cpu type"
+#endif
+
+#ifdef __hppa__
+#define mb()		asm volatile("" ::: "memory")
+#define wmb()		asm volatile("" ::: "memory")
+#define rmb()		asm volatile("" ::: "memory")
+#define CPUINFO_PROC	"cpu"
+#endif
+
+#ifdef __sparc__
+#ifdef __LP64__
+#define mb()		asm volatile("ba,pt %%xcc, 1f\n"	\
+				     "membar #StoreLoad\n"	\
+				     "1:\n":::"memory")
+#else
+#define mb()		asm volatile("":::"memory")
+#endif
+#define wmb()		asm volatile("":::"memory")
+#define rmb()		asm volatile("":::"memory")
+#define CPUINFO_PROC	"cpu"
+#endif
+
+#ifdef __alpha__
+#define mb()		asm volatile("mb" ::: "memory")
+#define wmb()		asm volatile("wmb" ::: "memory")
+#define rmb()		asm volatile("mb" ::: "memory")
+#define CPUINFO_PROC	"cpu model"
+#endif
+
+#ifdef __ia64__
+#define mb()		asm volatile ("mf" ::: "memory")
+#define wmb()		asm volatile ("mf" ::: "memory")
+#define rmb()		asm volatile ("mf" ::: "memory")
+#define cpu_relax()	asm volatile ("hint @pause" ::: "memory")
+#define CPUINFO_PROC	"model name"
+#endif
+
+#ifdef __arm__
+/*
+ * Use the __kuser_memory_barrier helper in the CPU helper page. See
+ * arch/arm/kernel/entry-armv.S in the kernel source for details.
+ */
+#define mb()		((void(*)(void))0xffff0fa0)()
+#define wmb()		((void(*)(void))0xffff0fa0)()
+#define rmb()		((void(*)(void))0xffff0fa0)()
+#define CPUINFO_PROC	"Processor"
+#endif
+
+#ifdef __aarch64__
+#define mb()		asm volatile("dmb ish" ::: "memory")
+#define wmb()		asm volatile("dmb ishst" ::: "memory")
+#define rmb()		asm volatile("dmb ishld" ::: "memory")
+#define cpu_relax()	asm volatile("yield" ::: "memory")
+#endif
+
+#ifdef __mips__
+#define mb()		asm volatile(					\
+				".set	mips2\n\t"			\
+				"sync\n\t"				\
+				".set	mips0"				\
+				: /* no output */			\
+				: /* no input */			\
+				: "memory")
+#define wmb()	mb()
+#define rmb()	mb()
+#define CPUINFO_PROC	"cpu model"
+#endif
+
+#ifdef __arc__
+#define mb()		asm volatile("" ::: "memory")
+#define wmb()		asm volatile("" ::: "memory")
+#define rmb()		asm volatile("" ::: "memory")
+#define CPUINFO_PROC	"Processor"
+#endif
+
+#ifdef __metag__
+#define mb()		asm volatile("" ::: "memory")
+#define wmb()		asm volatile("" ::: "memory")
+#define rmb()		asm volatile("" ::: "memory")
+#define CPUINFO_PROC	"CPU"
+#endif
+
+#ifdef __xtensa__
+#define mb()		asm volatile("memw" ::: "memory")
+#define wmb()		asm volatile("memw" ::: "memory")
+#define rmb()		asm volatile("" ::: "memory")
+#define CPUINFO_PROC	"core ID"
+#endif
+
+#ifdef __tile__
+#define mb()		asm volatile ("mf" ::: "memory")
+#define wmb()		asm volatile ("mf" ::: "memory")
+#define rmb()		asm volatile ("mf" ::: "memory")
+#define cpu_relax()	asm volatile ("mfspr zero, PASS" ::: "memory")
+#define CPUINFO_PROC    "model name"
+#endif
+
+#define barrier() asm volatile ("" ::: "memory")
+
+#ifndef cpu_relax
+#define cpu_relax() barrier()
+#endif
+
+static inline int
+sys_perf_event_open(struct perf_event_attr *attr,
+		      pid_t pid, int cpu, int group_fd,
+		      unsigned long flags)
+{
+	int fd;
+
+	fd = syscall(__NR_perf_event_open, attr, pid, cpu,
+		     group_fd, flags);
+
+#ifdef HAVE_ATTR_TEST
+	if (unlikely(test_attr__enabled))
+		test_attr__open(attr, pid, cpu, fd, group_fd, flags);
+#endif
+	return fd;
+}
+
+#endif /* _PERF_SYS_H */
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 5c11eca..510c65f 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -1,182 +1,18 @@
 #ifndef _PERF_PERF_H
 #define _PERF_PERF_H
 
-#include <asm/unistd.h>
-
-#if defined(__i386__)
-#define mb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
-#define wmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
-#define rmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
-#define cpu_relax()	asm volatile("rep; nop" ::: "memory");
-#define CPUINFO_PROC	"model name"
-#ifndef __NR_perf_event_open
-# define __NR_perf_event_open 336
-#endif
-#ifndef __NR_futex
-# define __NR_futex 240
-#endif
-#endif
-
-#if defined(__x86_64__)
-#define mb()		asm volatile("mfence" ::: "memory")
-#define wmb()		asm volatile("sfence" ::: "memory")
-#define rmb()		asm volatile("lfence" ::: "memory")
-#define cpu_relax()	asm volatile("rep; nop" ::: "memory");
-#define CPUINFO_PROC	"model name"
-#ifndef __NR_perf_event_open
-# define __NR_perf_event_open 298
-#endif
-#ifndef __NR_futex
-# define __NR_futex 202
-#endif
-#endif
-
-#ifdef __powerpc__
-#include "../../arch/powerpc/include/uapi/asm/unistd.h"
-#define mb()		asm volatile ("sync" ::: "memory")
-#define wmb()		asm volatile ("sync" ::: "memory")
-#define rmb()		asm volatile ("sync" ::: "memory")
-#define CPUINFO_PROC	"cpu"
-#endif
-
-#ifdef __s390__
-#define mb()		asm volatile("bcr 15,0" ::: "memory")
-#define wmb()		asm volatile("bcr 15,0" ::: "memory")
-#define rmb()		asm volatile("bcr 15,0" ::: "memory")
-#endif
-
-#ifdef __sh__
-#if defined(__SH4A__) || defined(__SH5__)
-# define mb()		asm volatile("synco" ::: "memory")
-# define wmb()		asm volatile("synco" ::: "memory")
-# define rmb()		asm volatile("synco" ::: "memory")
-#else
-# define mb()		asm volatile("" ::: "memory")
-# define wmb()		asm volatile("" ::: "memory")
-# define rmb()		asm volatile("" ::: "memory")
-#endif
-#define CPUINFO_PROC	"cpu type"
-#endif
-
-#ifdef __hppa__
-#define mb()		asm volatile("" ::: "memory")
-#define wmb()		asm volatile("" ::: "memory")
-#define rmb()		asm volatile("" ::: "memory")
-#define CPUINFO_PROC	"cpu"
-#endif
-
-#ifdef __sparc__
-#ifdef __LP64__
-#define mb()		asm volatile("ba,pt %%xcc, 1f\n"	\
-				     "membar #StoreLoad\n"	\
-				     "1:\n":::"memory")
-#else
-#define mb()		asm volatile("":::"memory")
-#endif
-#define wmb()		asm volatile("":::"memory")
-#define rmb()		asm volatile("":::"memory")
-#define CPUINFO_PROC	"cpu"
-#endif
-
-#ifdef __alpha__
-#define mb()		asm volatile("mb" ::: "memory")
-#define wmb()		asm volatile("wmb" ::: "memory")
-#define rmb()		asm volatile("mb" ::: "memory")
-#define CPUINFO_PROC	"cpu model"
-#endif
-
-#ifdef __ia64__
-#define mb()		asm volatile ("mf" ::: "memory")
-#define wmb()		asm volatile ("mf" ::: "memory")
-#define rmb()		asm volatile ("mf" ::: "memory")
-#define cpu_relax()	asm volatile ("hint @pause" ::: "memory")
-#define CPUINFO_PROC	"model name"
-#endif
-
-#ifdef __arm__
-/*
- * Use the __kuser_memory_barrier helper in the CPU helper page. See
- * arch/arm/kernel/entry-armv.S in the kernel source for details.
- */
-#define mb()		((void(*)(void))0xffff0fa0)()
-#define wmb()		((void(*)(void))0xffff0fa0)()
-#define rmb()		((void(*)(void))0xffff0fa0)()
-#define CPUINFO_PROC	"Processor"
-#endif
-
-#ifdef __aarch64__
-#define mb()		asm volatile("dmb ish" ::: "memory")
-#define wmb()		asm volatile("dmb ishst" ::: "memory")
-#define rmb()		asm volatile("dmb ishld" ::: "memory")
-#define cpu_relax()	asm volatile("yield" ::: "memory")
-#endif
-
-#ifdef __mips__
-#define mb()		asm volatile(					\
-				".set	mips2\n\t"			\
-				"sync\n\t"				\
-				".set	mips0"				\
-				: /* no output */			\
-				: /* no input */			\
-				: "memory")
-#define wmb()	mb()
-#define rmb()	mb()
-#define CPUINFO_PROC	"cpu model"
-#endif
-
-#ifdef __arc__
-#define mb()		asm volatile("" ::: "memory")
-#define wmb()		asm volatile("" ::: "memory")
-#define rmb()		asm volatile("" ::: "memory")
-#define CPUINFO_PROC	"Processor"
-#endif
-
-#ifdef __metag__
-#define mb()		asm volatile("" ::: "memory")
-#define wmb()		asm volatile("" ::: "memory")
-#define rmb()		asm volatile("" ::: "memory")
-#define CPUINFO_PROC	"CPU"
-#endif
-
-#ifdef __xtensa__
-#define mb()		asm volatile("memw" ::: "memory")
-#define wmb()		asm volatile("memw" ::: "memory")
-#define rmb()		asm volatile("" ::: "memory")
-#define CPUINFO_PROC	"core ID"
-#endif
-
-#ifdef __tile__
-#define mb()		asm volatile ("mf" ::: "memory")
-#define wmb()		asm volatile ("mf" ::: "memory")
-#define rmb()		asm volatile ("mf" ::: "memory")
-#define cpu_relax()	asm volatile ("mfspr zero, PASS" ::: "memory")
-#define CPUINFO_PROC    "model name"
-#endif
-
-#define barrier() asm volatile ("" ::: "memory")
-
-#ifndef cpu_relax
-#define cpu_relax() barrier()
-#endif
-
-#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
-
-
 #include <time.h>
-#include <unistd.h>
-#include <sys/types.h>
-#include <sys/syscall.h>
-
-#include <linux/perf_event.h>
-#include "util/types.h"
 #include <stdbool.h>
+#include <linux/types.h>
+#include <linux/perf_event.h>
 
-/*
- * prctl(PR_TASK_PERF_EVENTS_DISABLE) will (cheaply) disable all
- * counters in the current task.
- */
-#define PR_TASK_PERF_EVENTS_DISABLE   31
-#define PR_TASK_PERF_EVENTS_ENABLE    32
+extern bool test_attr__enabled;
+void test_attr__init(void);
+void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
+		     int fd, int group_fd, unsigned long flags);
+
+#define HAVE_ATTR_TEST
+#include "perf-sys.h"
 
 #ifndef NSEC_PER_SEC
 # define NSEC_PER_SEC			1000000000ULL
@@ -193,67 +29,8 @@ static inline unsigned long long rdclock(void)
 	return ts.tv_sec * 1000000000ULL + ts.tv_nsec;
 }
 
-/*
- * Pick up some kernel type conventions:
- */
-#define __user
-#define asmlinkage
-
-#define unlikely(x)	__builtin_expect(!!(x), 0)
-#define min(x, y) ({				\
-	typeof(x) _min1 = (x);			\
-	typeof(y) _min2 = (y);			\
-	(void) (&_min1 == &_min2);		\
-	_min1 < _min2 ? _min1 : _min2; })
-
-extern bool test_attr__enabled;
-void test_attr__init(void);
-void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
-		     int fd, int group_fd, unsigned long flags);
-
-static inline int
-sys_perf_event_open(struct perf_event_attr *attr,
-		      pid_t pid, int cpu, int group_fd,
-		      unsigned long flags)
-{
-	int fd;
-
-	fd = syscall(__NR_perf_event_open, attr, pid, cpu,
-		     group_fd, flags);
-
-	if (unlikely(test_attr__enabled))
-		test_attr__open(attr, pid, cpu, fd, group_fd, flags);
-
-	return fd;
-}
-
-#define MAX_COUNTERS			256
 #define MAX_NR_CPUS			256
 
-struct ip_callchain {
-	u64 nr;
-	u64 ips[0];
-};
-
-struct branch_flags {
-	u64 mispred:1;
-	u64 predicted:1;
-	u64 in_tx:1;
-	u64 abort:1;
-	u64 reserved:60;
-};
-
-struct branch_entry {
-	u64				from;
-	u64				to;
-	struct branch_flags flags;
-};
-
-struct branch_stack {
-	u64				nr;
-	struct branch_entry	entries[0];
-};
-
 extern const char *input_name;
 extern bool perf_host, perf_guest;
 extern const char perf_version_string[];
@@ -262,13 +39,6 @@ void pthread__unblock_sigwinch(void);
 
 #include "util/target.h"
 
-enum perf_call_graph_mode {
-	CALLCHAIN_NONE,
-	CALLCHAIN_FP,
-	CALLCHAIN_DWARF,
-	CALLCHAIN_MAX
-};
-
 struct record_opts {
 	struct target target;
 	int	     call_graph;
diff --git a/tools/perf/tests/attr.c b/tools/perf/tests/attr.c
index 00218f5..2dfc9ad 100644
--- a/tools/perf/tests/attr.c
+++ b/tools/perf/tests/attr.c
@@ -1,4 +1,3 @@
-
 /*
  * The struct perf_event_attr test support.
  *
@@ -19,14 +18,8 @@
  * permissions. All the event text files are stored there.
  */
 
-/*
- * Powerpc needs __SANE_USERSPACE_TYPES__ before <linux/types.h> to select
- * 'int-ll64.h' and avoid compile warnings when printing __u64 with %llu.
- */
-#define __SANE_USERSPACE_TYPES__
 #include <stdlib.h>
 #include <stdio.h>
-#include <inttypes.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include "../perf.h"
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index b11bf8a..831f52c 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -115,7 +115,7 @@ static struct test {
 		.desc = "Test parsing with no sample_id_all bit set",
 		.func = test__parse_no_sample_id_all,
 	},
-#if defined(__x86_64__) || defined(__i386__)
+#if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
 	{
 		.desc = "Test dwarf unwind",
@@ -124,6 +124,22 @@ static struct test {
 #endif
 #endif
 	{
+		.desc = "Test filtering hist entries",
+		.func = test__hists_filter,
+	},
+	{
+		.desc = "Test mmap thread lookup",
+		.func = test__mmap_thread_lookup,
+	},
+	{
+		.desc = "Test thread mg sharing",
+		.func = test__thread_mg_share,
+	},
+	{
+		.desc = "Test output sorting of hist entries",
+		.func = test__hists_output,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index bfb1869..67f2d63 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -1,8 +1,7 @@
-#include <sys/types.h>
+#include <linux/types.h>
 #include <stdlib.h>
 #include <unistd.h>
 #include <stdio.h>
-#include <inttypes.h>
 #include <ctype.h>
 #include <string.h>
 
@@ -257,7 +256,7 @@ static int process_sample_event(struct machine *machine,
 		return -1;
 	}
 
-	thread = machine__findnew_thread(machine, sample.pid, sample.pid);
+	thread = machine__findnew_thread(machine, sample.pid, sample.tid);
 	if (!thread) {
 		pr_debug("machine__findnew_thread failed\n");
 		return -1;
diff --git a/tools/perf/tests/dso-data.c b/tools/perf/tests/dso-data.c
index 9cc81a3..3e6cb17 100644
--- a/tools/perf/tests/dso-data.c
+++ b/tools/perf/tests/dso-data.c
@@ -1,7 +1,7 @@
 #include "util.h"
 
 #include <stdlib.h>
-#include <sys/types.h>
+#include <linux/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <string.h>
diff --git a/tools/perf/tests/dwarf-unwind.c b/tools/perf/tests/dwarf-unwind.c
index c059ee8..108f0cd 100644
--- a/tools/perf/tests/dwarf-unwind.c
+++ b/tools/perf/tests/dwarf-unwind.c
@@ -1,5 +1,5 @@
 #include <linux/compiler.h>
-#include <sys/types.h>
+#include <linux/types.h>
 #include <unistd.h>
 #include "tests.h"
 #include "debug.h"
diff --git a/tools/perf/tests/evsel-tp-sched.c b/tools/perf/tests/evsel-tp-sched.c
index 4774f7f..35d7fdb 100644
--- a/tools/perf/tests/evsel-tp-sched.c
+++ b/tools/perf/tests/evsel-tp-sched.c
@@ -74,9 +74,6 @@ int test__perf_evsel__tp_sched_test(void)
 	if (perf_evsel__test_field(evsel, "prio", 4, true))
 		ret = -1;
 
-	if (perf_evsel__test_field(evsel, "success", 4, true))
-		ret = -1;
-
 	if (perf_evsel__test_field(evsel, "target_cpu", 4, true))
 		ret = -1;
 
diff --git a/tools/perf/tests/hists_common.c b/tools/perf/tests/hists_common.c
new file mode 100644
index 0000000..e4e01aad
--- /dev/null
+++ b/tools/perf/tests/hists_common.c
@@ -0,0 +1,205 @@
+#include "perf.h"
+#include "util/debug.h"
+#include "util/symbol.h"
+#include "util/sort.h"
+#include "util/evsel.h"
+#include "util/evlist.h"
+#include "util/machine.h"
+#include "util/thread.h"
+#include "tests/hists_common.h"
+
+static struct {
+	u32 pid;
+	const char *comm;
+} fake_threads[] = {
+	{ 100, "perf" },
+	{ 200, "perf" },
+	{ 300, "bash" },
+};
+
+static struct {
+	u32 pid;
+	u64 start;
+	const char *filename;
+} fake_mmap_info[] = {
+	{ 100, 0x40000, "perf" },
+	{ 100, 0x50000, "libc" },
+	{ 100, 0xf0000, "[kernel]" },
+	{ 200, 0x40000, "perf" },
+	{ 200, 0x50000, "libc" },
+	{ 200, 0xf0000, "[kernel]" },
+	{ 300, 0x40000, "bash" },
+	{ 300, 0x50000, "libc" },
+	{ 300, 0xf0000, "[kernel]" },
+};
+
+struct fake_sym {
+	u64 start;
+	u64 length;
+	const char *name;
+};
+
+static struct fake_sym perf_syms[] = {
+	{ 700, 100, "main" },
+	{ 800, 100, "run_command" },
+	{ 900, 100, "cmd_record" },
+};
+
+static struct fake_sym bash_syms[] = {
+	{ 700, 100, "main" },
+	{ 800, 100, "xmalloc" },
+	{ 900, 100, "xfree" },
+};
+
+static struct fake_sym libc_syms[] = {
+	{ 700, 100, "malloc" },
+	{ 800, 100, "free" },
+	{ 900, 100, "realloc" },
+};
+
+static struct fake_sym kernel_syms[] = {
+	{ 700, 100, "schedule" },
+	{ 800, 100, "page_fault" },
+	{ 900, 100, "sys_perf_event_open" },
+};
+
+static struct {
+	const char *dso_name;
+	struct fake_sym *syms;
+	size_t nr_syms;
+} fake_symbols[] = {
+	{ "perf", perf_syms, ARRAY_SIZE(perf_syms) },
+	{ "bash", bash_syms, ARRAY_SIZE(bash_syms) },
+	{ "libc", libc_syms, ARRAY_SIZE(libc_syms) },
+	{ "[kernel]", kernel_syms, ARRAY_SIZE(kernel_syms) },
+};
+
+struct machine *setup_fake_machine(struct machines *machines)
+{
+	struct machine *machine = machines__find(machines, HOST_KERNEL_ID);
+	size_t i;
+
+	if (machine == NULL) {
+		pr_debug("Not enough memory for machine setup\n");
+		return NULL;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(fake_threads); i++) {
+		struct thread *thread;
+
+		thread = machine__findnew_thread(machine, fake_threads[i].pid,
+						 fake_threads[i].pid);
+		if (thread == NULL)
+			goto out;
+
+		thread__set_comm(thread, fake_threads[i].comm, 0);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(fake_mmap_info); i++) {
+		union perf_event fake_mmap_event = {
+			.mmap = {
+				.header = { .misc = PERF_RECORD_MISC_USER, },
+				.pid = fake_mmap_info[i].pid,
+				.tid = fake_mmap_info[i].pid,
+				.start = fake_mmap_info[i].start,
+				.len = 0x1000ULL,
+				.pgoff = 0ULL,
+			},
+		};
+
+		strcpy(fake_mmap_event.mmap.filename,
+		       fake_mmap_info[i].filename);
+
+		machine__process_mmap_event(machine, &fake_mmap_event, NULL);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(fake_symbols); i++) {
+		size_t k;
+		struct dso *dso;
+
+		dso = __dsos__findnew(&machine->user_dsos,
+				      fake_symbols[i].dso_name);
+		if (dso == NULL)
+			goto out;
+
+		/* emulate dso__load() */
+		dso__set_loaded(dso, MAP__FUNCTION);
+
+		for (k = 0; k < fake_symbols[i].nr_syms; k++) {
+			struct symbol *sym;
+			struct fake_sym *fsym = &fake_symbols[i].syms[k];
+
+			sym = symbol__new(fsym->start, fsym->length,
+					  STB_GLOBAL, fsym->name);
+			if (sym == NULL)
+				goto out;
+
+			symbols__insert(&dso->symbols[MAP__FUNCTION], sym);
+		}
+	}
+
+	return machine;
+
+out:
+	pr_debug("Not enough memory for machine setup\n");
+	machine__delete_threads(machine);
+	machine__delete(machine);
+	return NULL;
+}
+
+void print_hists_in(struct hists *hists)
+{
+	int i = 0;
+	struct rb_root *root;
+	struct rb_node *node;
+
+	if (sort__need_collapse)
+		root = &hists->entries_collapsed;
+	else
+		root = hists->entries_in;
+
+	pr_info("----- %s --------\n", __func__);
+	node = rb_first(root);
+	while (node) {
+		struct hist_entry *he;
+
+		he = rb_entry(node, struct hist_entry, rb_node_in);
+
+		if (!he->filtered) {
+			pr_info("%2d: entry: %-8s [%-8s] %20s: period = %"PRIu64"\n",
+				i, thread__comm_str(he->thread),
+				he->ms.map->dso->short_name,
+				he->ms.sym->name, he->stat.period);
+		}
+
+		i++;
+		node = rb_next(node);
+	}
+}
+
+void print_hists_out(struct hists *hists)
+{
+	int i = 0;
+	struct rb_root *root;
+	struct rb_node *node;
+
+	root = &hists->entries;
+
+	pr_info("----- %s --------\n", __func__);
+	node = rb_first(root);
+	while (node) {
+		struct hist_entry *he;
+
+		he = rb_entry(node, struct hist_entry, rb_node);
+
+		if (!he->filtered) {
+			pr_info("%2d: entry: %8s:%5d [%-8s] %20s: period = %"PRIu64"\n",
+				i, thread__comm_str(he->thread), he->thread->tid,
+				he->ms.map->dso->short_name,
+				he->ms.sym->name, he->stat.period);
+		}
+
+		i++;
+		node = rb_next(node);
+	}
+}
diff --git a/tools/perf/tests/hists_common.h b/tools/perf/tests/hists_common.h
new file mode 100644
index 0000000..1415ae6
--- /dev/null
+++ b/tools/perf/tests/hists_common.h
@@ -0,0 +1,47 @@
+#ifndef __PERF_TESTS__HISTS_COMMON_H__
+#define __PERF_TESTS__HISTS_COMMON_H__
+
+struct machine;
+struct machines;
+
+/*
+ * The setup_fake_machine() provides a test environment which consists
+ * of 3 processes that have 3 mappings and in turn, have 3 symbols
+ * respectively.  See below table:
+ *
+ * Command:  Pid  Shared Object               Symbol
+ * .............  .............  ...................
+ *    perf:  100           perf  main
+ *    perf:  100           perf  run_command
+ *    perf:  100           perf  comd_record
+ *    perf:  100           libc  malloc
+ *    perf:  100           libc  free
+ *    perf:  100           libc  realloc
+ *    perf:  100       [kernel]  schedule
+ *    perf:  100       [kernel]  page_fault
+ *    perf:  100       [kernel]  sys_perf_event_open
+ *    perf:  200           perf  main
+ *    perf:  200           perf  run_command
+ *    perf:  200           perf  comd_record
+ *    perf:  200           libc  malloc
+ *    perf:  200           libc  free
+ *    perf:  200           libc  realloc
+ *    perf:  200       [kernel]  schedule
+ *    perf:  200       [kernel]  page_fault
+ *    perf:  200       [kernel]  sys_perf_event_open
+ *    bash:  300           bash  main
+ *    bash:  300           bash  xmalloc
+ *    bash:  300           bash  xfree
+ *    bash:  300           libc  malloc
+ *    bash:  300           libc  free
+ *    bash:  300           libc  realloc
+ *    bash:  300       [kernel]  schedule
+ *    bash:  300       [kernel]  page_fault
+ *    bash:  300       [kernel]  sys_perf_event_open
+ */
+struct machine *setup_fake_machine(struct machines *machines);
+
+void print_hists_in(struct hists *hists);
+void print_hists_out(struct hists *hists);
+
+#endif /* __PERF_TESTS__HISTS_COMMON_H__ */
diff --git a/tools/perf/tests/hists_filter.c b/tools/perf/tests/hists_filter.c
new file mode 100644
index 0000000..c5ba924
--- /dev/null
+++ b/tools/perf/tests/hists_filter.c
@@ -0,0 +1,290 @@
+#include "perf.h"
+#include "util/debug.h"
+#include "util/symbol.h"
+#include "util/sort.h"
+#include "util/evsel.h"
+#include "util/evlist.h"
+#include "util/machine.h"
+#include "util/thread.h"
+#include "util/parse-events.h"
+#include "tests/tests.h"
+#include "tests/hists_common.h"
+
+struct sample {
+	u32 pid;
+	u64 ip;
+	struct thread *thread;
+	struct map *map;
+	struct symbol *sym;
+};
+
+/* For the numbers, see hists_common.c */
+static struct sample fake_samples[] = {
+	/* perf [kernel] schedule() */
+	{ .pid = 100, .ip = 0xf0000 + 700, },
+	/* perf [perf]   main() */
+	{ .pid = 100, .ip = 0x40000 + 700, },
+	/* perf [libc]   malloc() */
+	{ .pid = 100, .ip = 0x50000 + 700, },
+	/* perf [perf]   main() */
+	{ .pid = 200, .ip = 0x40000 + 700, }, /* will be merged */
+	/* perf [perf]   cmd_record() */
+	{ .pid = 200, .ip = 0x40000 + 900, },
+	/* perf [kernel] page_fault() */
+	{ .pid = 200, .ip = 0xf0000 + 800, },
+	/* bash [bash]   main() */
+	{ .pid = 300, .ip = 0x40000 + 700, },
+	/* bash [bash]   xmalloc() */
+	{ .pid = 300, .ip = 0x40000 + 800, },
+	/* bash [libc]   malloc() */
+	{ .pid = 300, .ip = 0x50000 + 700, },
+	/* bash [kernel] page_fault() */
+	{ .pid = 300, .ip = 0xf0000 + 800, },
+};
+
+static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
+{
+	struct perf_evsel *evsel;
+	struct addr_location al;
+	struct hist_entry *he;
+	struct perf_sample sample = { .cpu = 0, };
+	size_t i;
+
+	/*
+	 * each evsel will have 10 samples but the 4th sample
+	 * (perf [perf] main) will be collapsed to an existing entry
+	 * so total 9 entries will be in the tree.
+	 */
+	evlist__for_each(evlist, evsel) {
+		for (i = 0; i < ARRAY_SIZE(fake_samples); i++) {
+			const union perf_event event = {
+				.header = {
+					.misc = PERF_RECORD_MISC_USER,
+				},
+			};
+
+			/* make sure it has no filter at first */
+			evsel->hists.thread_filter = NULL;
+			evsel->hists.dso_filter = NULL;
+			evsel->hists.symbol_filter_str = NULL;
+
+			sample.pid = fake_samples[i].pid;
+			sample.tid = fake_samples[i].pid;
+			sample.ip = fake_samples[i].ip;
+
+			if (perf_event__preprocess_sample(&event, machine, &al,
+							  &sample) < 0)
+				goto out;
+
+			he = __hists__add_entry(&evsel->hists, &al, NULL,
+						NULL, NULL, 100, 1, 0);
+			if (he == NULL)
+				goto out;
+
+			fake_samples[i].thread = al.thread;
+			fake_samples[i].map = al.map;
+			fake_samples[i].sym = al.sym;
+
+			hists__inc_nr_events(he->hists, PERF_RECORD_SAMPLE);
+			if (!he->filtered)
+				he->hists->stats.nr_non_filtered_samples++;
+		}
+	}
+
+	return 0;
+
+out:
+	pr_debug("Not enough memory for adding a hist entry\n");
+	return TEST_FAIL;
+}
+
+int test__hists_filter(void)
+{
+	int err = TEST_FAIL;
+	struct machines machines;
+	struct machine *machine;
+	struct perf_evsel *evsel;
+	struct perf_evlist *evlist = perf_evlist__new();
+
+	TEST_ASSERT_VAL("No memory", evlist);
+
+	err = parse_events(evlist, "cpu-clock");
+	if (err)
+		goto out;
+	err = parse_events(evlist, "task-clock");
+	if (err)
+		goto out;
+
+	/* default sort order (comm,dso,sym) will be used */
+	if (setup_sorting() < 0)
+		goto out;
+
+	machines__init(&machines);
+
+	/* setup threads/dso/map/symbols also */
+	machine = setup_fake_machine(&machines);
+	if (!machine)
+		goto out;
+
+	if (verbose > 1)
+		machine__fprintf(machine, stderr);
+
+	/* process sample events */
+	err = add_hist_entries(evlist, machine);
+	if (err < 0)
+		goto out;
+
+	evlist__for_each(evlist, evsel) {
+		struct hists *hists = &evsel->hists;
+
+		hists__collapse_resort(hists, NULL);
+		hists__output_resort(hists);
+
+		if (verbose > 2) {
+			pr_info("Normal histogram\n");
+			print_hists_out(hists);
+		}
+
+		TEST_ASSERT_VAL("Invalid nr samples",
+				hists->stats.nr_events[PERF_RECORD_SAMPLE] == 10);
+		TEST_ASSERT_VAL("Invalid nr hist entries",
+				hists->nr_entries == 9);
+		TEST_ASSERT_VAL("Invalid total period",
+				hists->stats.total_period == 1000);
+		TEST_ASSERT_VAL("Unmatched nr samples",
+				hists->stats.nr_events[PERF_RECORD_SAMPLE] ==
+				hists->stats.nr_non_filtered_samples);
+		TEST_ASSERT_VAL("Unmatched nr hist entries",
+				hists->nr_entries == hists->nr_non_filtered_entries);
+		TEST_ASSERT_VAL("Unmatched total period",
+				hists->stats.total_period ==
+				hists->stats.total_non_filtered_period);
+
+		/* now applying thread filter for 'bash' */
+		evsel->hists.thread_filter = fake_samples[9].thread;
+		hists__filter_by_thread(hists);
+
+		if (verbose > 2) {
+			pr_info("Histogram for thread filter\n");
+			print_hists_out(hists);
+		}
+
+		/* normal stats should be invariant */
+		TEST_ASSERT_VAL("Invalid nr samples",
+				hists->stats.nr_events[PERF_RECORD_SAMPLE] == 10);
+		TEST_ASSERT_VAL("Invalid nr hist entries",
+				hists->nr_entries == 9);
+		TEST_ASSERT_VAL("Invalid total period",
+				hists->stats.total_period == 1000);
+
+		/* but filter stats are changed */
+		TEST_ASSERT_VAL("Unmatched nr samples for thread filter",
+				hists->stats.nr_non_filtered_samples == 4);
+		TEST_ASSERT_VAL("Unmatched nr hist entries for thread filter",
+				hists->nr_non_filtered_entries == 4);
+		TEST_ASSERT_VAL("Unmatched total period for thread filter",
+				hists->stats.total_non_filtered_period == 400);
+
+		/* remove thread filter first */
+		evsel->hists.thread_filter = NULL;
+		hists__filter_by_thread(hists);
+
+		/* now applying dso filter for 'kernel' */
+		evsel->hists.dso_filter = fake_samples[0].map->dso;
+		hists__filter_by_dso(hists);
+
+		if (verbose > 2) {
+			pr_info("Histogram for dso filter\n");
+			print_hists_out(hists);
+		}
+
+		/* normal stats should be invariant */
+		TEST_ASSERT_VAL("Invalid nr samples",
+				hists->stats.nr_events[PERF_RECORD_SAMPLE] == 10);
+		TEST_ASSERT_VAL("Invalid nr hist entries",
+				hists->nr_entries == 9);
+		TEST_ASSERT_VAL("Invalid total period",
+				hists->stats.total_period == 1000);
+
+		/* but filter stats are changed */
+		TEST_ASSERT_VAL("Unmatched nr samples for dso filter",
+				hists->stats.nr_non_filtered_samples == 3);
+		TEST_ASSERT_VAL("Unmatched nr hist entries for dso filter",
+				hists->nr_non_filtered_entries == 3);
+		TEST_ASSERT_VAL("Unmatched total period for dso filter",
+				hists->stats.total_non_filtered_period == 300);
+
+		/* remove dso filter first */
+		evsel->hists.dso_filter = NULL;
+		hists__filter_by_dso(hists);
+
+		/*
+		 * now applying symbol filter for 'main'.  Also note that
+		 * there's 3 samples that have 'main' symbol but the 4th
+		 * entry of fake_samples was collapsed already so it won't
+		 * be counted as a separate entry but the sample count and
+		 * total period will be remained.
+		 */
+		evsel->hists.symbol_filter_str = "main";
+		hists__filter_by_symbol(hists);
+
+		if (verbose > 2) {
+			pr_info("Histogram for symbol filter\n");
+			print_hists_out(hists);
+		}
+
+		/* normal stats should be invariant */
+		TEST_ASSERT_VAL("Invalid nr samples",
+				hists->stats.nr_events[PERF_RECORD_SAMPLE] == 10);
+		TEST_ASSERT_VAL("Invalid nr hist entries",
+				hists->nr_entries == 9);
+		TEST_ASSERT_VAL("Invalid total period",
+				hists->stats.total_period == 1000);
+
+		/* but filter stats are changed */
+		TEST_ASSERT_VAL("Unmatched nr samples for symbol filter",
+				hists->stats.nr_non_filtered_samples == 3);
+		TEST_ASSERT_VAL("Unmatched nr hist entries for symbol filter",
+				hists->nr_non_filtered_entries == 2);
+		TEST_ASSERT_VAL("Unmatched total period for symbol filter",
+				hists->stats.total_non_filtered_period == 300);
+
+		/* now applying all filters at once. */
+		evsel->hists.thread_filter = fake_samples[1].thread;
+		evsel->hists.dso_filter = fake_samples[1].map->dso;
+		hists__filter_by_thread(hists);
+		hists__filter_by_dso(hists);
+
+		if (verbose > 2) {
+			pr_info("Histogram for all filters\n");
+			print_hists_out(hists);
+		}
+
+		/* normal stats should be invariant */
+		TEST_ASSERT_VAL("Invalid nr samples",
+				hists->stats.nr_events[PERF_RECORD_SAMPLE] == 10);
+		TEST_ASSERT_VAL("Invalid nr hist entries",
+				hists->nr_entries == 9);
+		TEST_ASSERT_VAL("Invalid total period",
+				hists->stats.total_period == 1000);
+
+		/* but filter stats are changed */
+		TEST_ASSERT_VAL("Unmatched nr samples for all filter",
+				hists->stats.nr_non_filtered_samples == 2);
+		TEST_ASSERT_VAL("Unmatched nr hist entries for all filter",
+				hists->nr_non_filtered_entries == 1);
+		TEST_ASSERT_VAL("Unmatched total period for all filter",
+				hists->stats.total_non_filtered_period == 200);
+	}
+
+
+	err = TEST_OK;
+
+out:
+	/* tear down everything */
+	perf_evlist__delete(evlist);
+	reset_output_field();
+	machines__exit(&machines);
+
+	return err;
+}
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 7ccbc7b..5ffa2c3 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -8,145 +8,7 @@
 #include "machine.h"
 #include "thread.h"
 #include "parse-events.h"
-
-static struct {
-	u32 pid;
-	const char *comm;
-} fake_threads[] = {
-	{ 100, "perf" },
-	{ 200, "perf" },
-	{ 300, "bash" },
-};
-
-static struct {
-	u32 pid;
-	u64 start;
-	const char *filename;
-} fake_mmap_info[] = {
-	{ 100, 0x40000, "perf" },
-	{ 100, 0x50000, "libc" },
-	{ 100, 0xf0000, "[kernel]" },
-	{ 200, 0x40000, "perf" },
-	{ 200, 0x50000, "libc" },
-	{ 200, 0xf0000, "[kernel]" },
-	{ 300, 0x40000, "bash" },
-	{ 300, 0x50000, "libc" },
-	{ 300, 0xf0000, "[kernel]" },
-};
-
-struct fake_sym {
-	u64 start;
-	u64 length;
-	const char *name;
-};
-
-static struct fake_sym perf_syms[] = {
-	{ 700, 100, "main" },
-	{ 800, 100, "run_command" },
-	{ 900, 100, "cmd_record" },
-};
-
-static struct fake_sym bash_syms[] = {
-	{ 700, 100, "main" },
-	{ 800, 100, "xmalloc" },
-	{ 900, 100, "xfree" },
-};
-
-static struct fake_sym libc_syms[] = {
-	{ 700, 100, "malloc" },
-	{ 800, 100, "free" },
-	{ 900, 100, "realloc" },
-};
-
-static struct fake_sym kernel_syms[] = {
-	{ 700, 100, "schedule" },
-	{ 800, 100, "page_fault" },
-	{ 900, 100, "sys_perf_event_open" },
-};
-
-static struct {
-	const char *dso_name;
-	struct fake_sym *syms;
-	size_t nr_syms;
-} fake_symbols[] = {
-	{ "perf", perf_syms, ARRAY_SIZE(perf_syms) },
-	{ "bash", bash_syms, ARRAY_SIZE(bash_syms) },
-	{ "libc", libc_syms, ARRAY_SIZE(libc_syms) },
-	{ "[kernel]", kernel_syms, ARRAY_SIZE(kernel_syms) },
-};
-
-static struct machine *setup_fake_machine(struct machines *machines)
-{
-	struct machine *machine = machines__find(machines, HOST_KERNEL_ID);
-	size_t i;
-
-	if (machine == NULL) {
-		pr_debug("Not enough memory for machine setup\n");
-		return NULL;
-	}
-
-	for (i = 0; i < ARRAY_SIZE(fake_threads); i++) {
-		struct thread *thread;
-
-		thread = machine__findnew_thread(machine, fake_threads[i].pid,
-						 fake_threads[i].pid);
-		if (thread == NULL)
-			goto out;
-
-		thread__set_comm(thread, fake_threads[i].comm, 0);
-	}
-
-	for (i = 0; i < ARRAY_SIZE(fake_mmap_info); i++) {
-		union perf_event fake_mmap_event = {
-			.mmap = {
-				.header = { .misc = PERF_RECORD_MISC_USER, },
-				.pid = fake_mmap_info[i].pid,
-				.tid = fake_mmap_info[i].pid,
-				.start = fake_mmap_info[i].start,
-				.len = 0x1000ULL,
-				.pgoff = 0ULL,
-			},
-		};
-
-		strcpy(fake_mmap_event.mmap.filename,
-		       fake_mmap_info[i].filename);
-
-		machine__process_mmap_event(machine, &fake_mmap_event, NULL);
-	}
-
-	for (i = 0; i < ARRAY_SIZE(fake_symbols); i++) {
-		size_t k;
-		struct dso *dso;
-
-		dso = __dsos__findnew(&machine->user_dsos,
-				      fake_symbols[i].dso_name);
-		if (dso == NULL)
-			goto out;
-
-		/* emulate dso__load() */
-		dso__set_loaded(dso, MAP__FUNCTION);
-
-		for (k = 0; k < fake_symbols[i].nr_syms; k++) {
-			struct symbol *sym;
-			struct fake_sym *fsym = &fake_symbols[i].syms[k];
-
-			sym = symbol__new(fsym->start, fsym->length,
-					  STB_GLOBAL, fsym->name);
-			if (sym == NULL)
-				goto out;
-
-			symbols__insert(&dso->symbols[MAP__FUNCTION], sym);
-		}
-	}
-
-	return machine;
-
-out:
-	pr_debug("Not enough memory for machine setup\n");
-	machine__delete_threads(machine);
-	machine__delete(machine);
-	return NULL;
-}
+#include "hists_common.h"
 
 struct sample {
 	u32 pid;
@@ -156,6 +18,7 @@ struct sample {
 	struct symbol *sym;
 };
 
+/* For the numbers, see hists_common.c */
 static struct sample fake_common_samples[] = {
 	/* perf [kernel] schedule() */
 	{ .pid = 100, .ip = 0xf0000 + 700, },
@@ -218,6 +81,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 			};
 
 			sample.pid = fake_common_samples[k].pid;
+			sample.tid = fake_common_samples[k].pid;
 			sample.ip = fake_common_samples[k].ip;
 			if (perf_event__preprocess_sample(&event, machine, &al,
 							  &sample) < 0)
@@ -241,6 +105,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 			};
 
 			sample.pid = fake_samples[i][k].pid;
+			sample.tid = fake_samples[i][k].pid;
 			sample.ip = fake_samples[i][k].ip;
 			if (perf_event__preprocess_sample(&event, machine, &al,
 							  &sample) < 0)
@@ -403,33 +268,6 @@ static int validate_link(struct hists *leader, struct hists *other)
 	return __validate_link(leader, 0) || __validate_link(other, 1);
 }
 
-static void print_hists(struct hists *hists)
-{
-	int i = 0;
-	struct rb_root *root;
-	struct rb_node *node;
-
-	if (sort__need_collapse)
-		root = &hists->entries_collapsed;
-	else
-		root = hists->entries_in;
-
-	pr_info("----- %s --------\n", __func__);
-	node = rb_first(root);
-	while (node) {
-		struct hist_entry *he;
-
-		he = rb_entry(node, struct hist_entry, rb_node_in);
-
-		pr_info("%2d: entry: %-8s [%-8s] %20s: period = %"PRIu64"\n",
-			i, thread__comm_str(he->thread), he->ms.map->dso->short_name,
-			he->ms.sym->name, he->stat.period);
-
-		i++;
-		node = rb_next(node);
-	}
-}
-
 int test__hists_link(void)
 {
 	int err = -1;
@@ -471,7 +309,7 @@ int test__hists_link(void)
 		hists__collapse_resort(&evsel->hists, NULL);
 
 		if (verbose > 2)
-			print_hists(&evsel->hists);
+			print_hists_in(&evsel->hists);
 	}
 
 	first = perf_evlist__first(evlist);
@@ -494,6 +332,7 @@ int test__hists_link(void)
 out:
 	/* tear down everything */
 	perf_evlist__delete(evlist);
+	reset_output_field();
 	machines__exit(&machines);
 
 	return err;
diff --git a/tools/perf/tests/hists_output.c b/tools/perf/tests/hists_output.c
new file mode 100644
index 0000000..a168505
--- /dev/null
+++ b/tools/perf/tests/hists_output.c
@@ -0,0 +1,618 @@
+#include "perf.h"
+#include "util/debug.h"
+#include "util/symbol.h"
+#include "util/sort.h"
+#include "util/evsel.h"
+#include "util/evlist.h"
+#include "util/machine.h"
+#include "util/thread.h"
+#include "util/parse-events.h"
+#include "tests/tests.h"
+#include "tests/hists_common.h"
+
+struct sample {
+	u32 cpu;
+	u32 pid;
+	u64 ip;
+	struct thread *thread;
+	struct map *map;
+	struct symbol *sym;
+};
+
+/* For the numbers, see hists_common.c */
+static struct sample fake_samples[] = {
+	/* perf [kernel] schedule() */
+	{ .cpu = 0, .pid = 100, .ip = 0xf0000 + 700, },
+	/* perf [perf]   main() */
+	{ .cpu = 1, .pid = 100, .ip = 0x40000 + 700, },
+	/* perf [perf]   cmd_record() */
+	{ .cpu = 1, .pid = 100, .ip = 0x40000 + 900, },
+	/* perf [libc]   malloc() */
+	{ .cpu = 1, .pid = 100, .ip = 0x50000 + 700, },
+	/* perf [libc]   free() */
+	{ .cpu = 2, .pid = 100, .ip = 0x50000 + 800, },
+	/* perf [perf]   main() */
+	{ .cpu = 2, .pid = 200, .ip = 0x40000 + 700, },
+	/* perf [kernel] page_fault() */
+	{ .cpu = 2, .pid = 200, .ip = 0xf0000 + 800, },
+	/* bash [bash]   main() */
+	{ .cpu = 3, .pid = 300, .ip = 0x40000 + 700, },
+	/* bash [bash]   xmalloc() */
+	{ .cpu = 0, .pid = 300, .ip = 0x40000 + 800, },
+	/* bash [kernel] page_fault() */
+	{ .cpu = 1, .pid = 300, .ip = 0xf0000 + 800, },
+};
+
+static int add_hist_entries(struct hists *hists, struct machine *machine)
+{
+	struct addr_location al;
+	struct hist_entry *he;
+	struct perf_sample sample = { .period = 100, };
+	size_t i;
+
+	for (i = 0; i < ARRAY_SIZE(fake_samples); i++) {
+		const union perf_event event = {
+			.header = {
+				.misc = PERF_RECORD_MISC_USER,
+			},
+		};
+
+		sample.cpu = fake_samples[i].cpu;
+		sample.pid = fake_samples[i].pid;
+		sample.tid = fake_samples[i].pid;
+		sample.ip = fake_samples[i].ip;
+
+		if (perf_event__preprocess_sample(&event, machine, &al,
+						  &sample) < 0)
+			goto out;
+
+		he = __hists__add_entry(hists, &al, NULL, NULL, NULL,
+					sample.period, 1, 0);
+		if (he == NULL)
+			goto out;
+
+		fake_samples[i].thread = al.thread;
+		fake_samples[i].map = al.map;
+		fake_samples[i].sym = al.sym;
+	}
+
+	return TEST_OK;
+
+out:
+	pr_debug("Not enough memory for adding a hist entry\n");
+	return TEST_FAIL;
+}
+
+static void del_hist_entries(struct hists *hists)
+{
+	struct hist_entry *he;
+	struct rb_root *root_in;
+	struct rb_root *root_out;
+	struct rb_node *node;
+
+	if (sort__need_collapse)
+		root_in = &hists->entries_collapsed;
+	else
+		root_in = hists->entries_in;
+
+	root_out = &hists->entries;
+
+	while (!RB_EMPTY_ROOT(root_out)) {
+		node = rb_first(root_out);
+
+		he = rb_entry(node, struct hist_entry, rb_node);
+		rb_erase(node, root_out);
+		rb_erase(&he->rb_node_in, root_in);
+		hist_entry__free(he);
+	}
+}
+
+typedef int (*test_fn_t)(struct perf_evsel *, struct machine *);
+
+#define COMM(he)  (thread__comm_str(he->thread))
+#define DSO(he)   (he->ms.map->dso->short_name)
+#define SYM(he)   (he->ms.sym->name)
+#define CPU(he)   (he->cpu)
+#define PID(he)   (he->thread->tid)
+
+/* default sort keys (no field) */
+static int test1(struct perf_evsel *evsel, struct machine *machine)
+{
+	int err;
+	struct hists *hists = &evsel->hists;
+	struct hist_entry *he;
+	struct rb_root *root;
+	struct rb_node *node;
+
+	field_order = NULL;
+	sort_order = NULL; /* equivalent to sort_order = "comm,dso,sym" */
+
+	setup_sorting();
+
+	/*
+	 * expected output:
+	 *
+	 * Overhead  Command  Shared Object          Symbol
+	 * ========  =======  =============  ==============
+	 *   20.00%     perf  perf           [.] main
+	 *   10.00%     bash  [kernel]       [k] page_fault
+	 *   10.00%     bash  bash           [.] main
+	 *   10.00%     bash  bash           [.] xmalloc
+	 *   10.00%     perf  [kernel]       [k] page_fault
+	 *   10.00%     perf  [kernel]       [k] schedule
+	 *   10.00%     perf  libc           [.] free
+	 *   10.00%     perf  libc           [.] malloc
+	 *   10.00%     perf  perf           [.] cmd_record
+	 */
+	err = add_hist_entries(hists, machine);
+	if (err < 0)
+		goto out;
+
+	hists__collapse_resort(hists, NULL);
+	hists__output_resort(hists);
+
+	if (verbose > 2) {
+		pr_info("[fields = %s, sort = %s]\n", field_order, sort_order);
+		print_hists_out(hists);
+	}
+
+	root = &evsel->hists.entries;
+	node = rb_first(root);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "perf") &&
+			!strcmp(SYM(he), "main") && he->stat.period == 200);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "bash") && !strcmp(DSO(he), "[kernel]") &&
+			!strcmp(SYM(he), "page_fault") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "bash") && !strcmp(DSO(he), "bash") &&
+			!strcmp(SYM(he), "main") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "bash") && !strcmp(DSO(he), "bash") &&
+			!strcmp(SYM(he), "xmalloc") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "[kernel]") &&
+			!strcmp(SYM(he), "page_fault") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "[kernel]") &&
+			!strcmp(SYM(he), "schedule") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "libc") &&
+			!strcmp(SYM(he), "free") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "libc") &&
+			!strcmp(SYM(he), "malloc") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "perf") &&
+			!strcmp(SYM(he), "cmd_record") && he->stat.period == 100);
+
+out:
+	del_hist_entries(hists);
+	reset_output_field();
+	return err;
+}
+
+/* mixed fields and sort keys */
+static int test2(struct perf_evsel *evsel, struct machine *machine)
+{
+	int err;
+	struct hists *hists = &evsel->hists;
+	struct hist_entry *he;
+	struct rb_root *root;
+	struct rb_node *node;
+
+	field_order = "overhead,cpu";
+	sort_order = "pid";
+
+	setup_sorting();
+
+	/*
+	 * expected output:
+	 *
+	 * Overhead  CPU  Command:  Pid
+	 * ========  ===  =============
+	 *   30.00%    1  perf   :  100
+	 *   10.00%    0  perf   :  100
+	 *   10.00%    2  perf   :  100
+	 *   20.00%    2  perf   :  200
+	 *   10.00%    0  bash   :  300
+	 *   10.00%    1  bash   :  300
+	 *   10.00%    3  bash   :  300
+	 */
+	err = add_hist_entries(hists, machine);
+	if (err < 0)
+		goto out;
+
+	hists__collapse_resort(hists, NULL);
+	hists__output_resort(hists);
+
+	if (verbose > 2) {
+		pr_info("[fields = %s, sort = %s]\n", field_order, sort_order);
+		print_hists_out(hists);
+	}
+
+	root = &evsel->hists.entries;
+	node = rb_first(root);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			CPU(he) == 1 && PID(he) == 100 && he->stat.period == 300);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			CPU(he) == 0 && PID(he) == 100 && he->stat.period == 100);
+
+out:
+	del_hist_entries(hists);
+	reset_output_field();
+	return err;
+}
+
+/* fields only (no sort key) */
+static int test3(struct perf_evsel *evsel, struct machine *machine)
+{
+	int err;
+	struct hists *hists = &evsel->hists;
+	struct hist_entry *he;
+	struct rb_root *root;
+	struct rb_node *node;
+
+	field_order = "comm,overhead,dso";
+	sort_order = NULL;
+
+	setup_sorting();
+
+	/*
+	 * expected output:
+	 *
+	 * Command  Overhead  Shared Object
+	 * =======  ========  =============
+	 *    bash    20.00%  bash
+	 *    bash    10.00%  [kernel]
+	 *    perf    30.00%  perf
+	 *    perf    20.00%  [kernel]
+	 *    perf    20.00%  libc
+	 */
+	err = add_hist_entries(hists, machine);
+	if (err < 0)
+		goto out;
+
+	hists__collapse_resort(hists, NULL);
+	hists__output_resort(hists);
+
+	if (verbose > 2) {
+		pr_info("[fields = %s, sort = %s]\n", field_order, sort_order);
+		print_hists_out(hists);
+	}
+
+	root = &evsel->hists.entries;
+	node = rb_first(root);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "bash") && !strcmp(DSO(he), "bash") &&
+			he->stat.period == 200);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "bash") && !strcmp(DSO(he), "[kernel]") &&
+			he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "perf") &&
+			he->stat.period == 300);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "[kernel]") &&
+			he->stat.period == 200);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "libc") &&
+			he->stat.period == 200);
+
+out:
+	del_hist_entries(hists);
+	reset_output_field();
+	return err;
+}
+
+/* handle duplicate 'dso' field */
+static int test4(struct perf_evsel *evsel, struct machine *machine)
+{
+	int err;
+	struct hists *hists = &evsel->hists;
+	struct hist_entry *he;
+	struct rb_root *root;
+	struct rb_node *node;
+
+	field_order = "dso,sym,comm,overhead,dso";
+	sort_order = "sym";
+
+	setup_sorting();
+
+	/*
+	 * expected output:
+	 *
+	 * Shared Object          Symbol  Command  Overhead
+	 * =============  ==============  =======  ========
+	 *          perf  [.] cmd_record     perf    10.00%
+	 *          libc  [.] free           perf    10.00%
+	 *          bash  [.] main           bash    10.00%
+	 *          perf  [.] main           perf    20.00%
+	 *          libc  [.] malloc         perf    10.00%
+	 *      [kernel]  [k] page_fault     bash    10.00%
+	 *      [kernel]  [k] page_fault     perf    10.00%
+	 *      [kernel]  [k] schedule       perf    10.00%
+	 *          bash  [.] xmalloc        bash    10.00%
+	 */
+	err = add_hist_entries(hists, machine);
+	if (err < 0)
+		goto out;
+
+	hists__collapse_resort(hists, NULL);
+	hists__output_resort(hists);
+
+	if (verbose > 2) {
+		pr_info("[fields = %s, sort = %s]\n", field_order, sort_order);
+		print_hists_out(hists);
+	}
+
+	root = &evsel->hists.entries;
+	node = rb_first(root);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(DSO(he), "perf") && !strcmp(SYM(he), "cmd_record") &&
+			!strcmp(COMM(he), "perf") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(DSO(he), "libc") && !strcmp(SYM(he), "free") &&
+			!strcmp(COMM(he), "perf") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(DSO(he), "bash") && !strcmp(SYM(he), "main") &&
+			!strcmp(COMM(he), "bash") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(DSO(he), "perf") && !strcmp(SYM(he), "main") &&
+			!strcmp(COMM(he), "perf") && he->stat.period == 200);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(DSO(he), "libc") && !strcmp(SYM(he), "malloc") &&
+			!strcmp(COMM(he), "perf") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(DSO(he), "[kernel]") && !strcmp(SYM(he), "page_fault") &&
+			!strcmp(COMM(he), "bash") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(DSO(he), "[kernel]") && !strcmp(SYM(he), "page_fault") &&
+			!strcmp(COMM(he), "perf") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(DSO(he), "[kernel]") && !strcmp(SYM(he), "schedule") &&
+			!strcmp(COMM(he), "perf") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(DSO(he), "bash") && !strcmp(SYM(he), "xmalloc") &&
+			!strcmp(COMM(he), "bash") && he->stat.period == 100);
+
+out:
+	del_hist_entries(hists);
+	reset_output_field();
+	return err;
+}
+
+/* full sort keys w/o overhead field */
+static int test5(struct perf_evsel *evsel, struct machine *machine)
+{
+	int err;
+	struct hists *hists = &evsel->hists;
+	struct hist_entry *he;
+	struct rb_root *root;
+	struct rb_node *node;
+
+	field_order = "cpu,pid,comm,dso,sym";
+	sort_order = "dso,pid";
+
+	setup_sorting();
+
+	/*
+	 * expected output:
+	 *
+	 * CPU  Command:  Pid  Command  Shared Object          Symbol
+	 * ===  =============  =======  =============  ==============
+	 *   0     perf:  100     perf       [kernel]  [k] schedule
+	 *   2     perf:  200     perf       [kernel]  [k] page_fault
+	 *   1     bash:  300     bash       [kernel]  [k] page_fault
+	 *   0     bash:  300     bash           bash  [.] xmalloc
+	 *   3     bash:  300     bash           bash  [.] main
+	 *   1     perf:  100     perf           libc  [.] malloc
+	 *   2     perf:  100     perf           libc  [.] free
+	 *   1     perf:  100     perf           perf  [.] cmd_record
+	 *   1     perf:  100     perf           perf  [.] main
+	 *   2     perf:  200     perf           perf  [.] main
+	 */
+	err = add_hist_entries(hists, machine);
+	if (err < 0)
+		goto out;
+
+	hists__collapse_resort(hists, NULL);
+	hists__output_resort(hists);
+
+	if (verbose > 2) {
+		pr_info("[fields = %s, sort = %s]\n", field_order, sort_order);
+		print_hists_out(hists);
+	}
+
+	root = &evsel->hists.entries;
+	node = rb_first(root);
+	he = rb_entry(node, struct hist_entry, rb_node);
+
+	TEST_ASSERT_VAL("Invalid hist entry",
+			CPU(he) == 0 && PID(he) == 100 &&
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "[kernel]") &&
+			!strcmp(SYM(he), "schedule") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			CPU(he) == 2 && PID(he) == 200 &&
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "[kernel]") &&
+			!strcmp(SYM(he), "page_fault") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			CPU(he) == 1 && PID(he) == 300 &&
+			!strcmp(COMM(he), "bash") && !strcmp(DSO(he), "[kernel]") &&
+			!strcmp(SYM(he), "page_fault") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			CPU(he) == 0 && PID(he) == 300 &&
+			!strcmp(COMM(he), "bash") && !strcmp(DSO(he), "bash") &&
+			!strcmp(SYM(he), "xmalloc") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			CPU(he) == 3 && PID(he) == 300 &&
+			!strcmp(COMM(he), "bash") && !strcmp(DSO(he), "bash") &&
+			!strcmp(SYM(he), "main") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			CPU(he) == 1 && PID(he) == 100 &&
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "libc") &&
+			!strcmp(SYM(he), "malloc") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			CPU(he) == 2 && PID(he) == 100 &&
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "libc") &&
+			!strcmp(SYM(he), "free") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			CPU(he) == 1 && PID(he) == 100 &&
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "perf") &&
+			!strcmp(SYM(he), "cmd_record") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			CPU(he) == 1 && PID(he) == 100 &&
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "perf") &&
+			!strcmp(SYM(he), "main") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			CPU(he) == 2 && PID(he) == 200 &&
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "perf") &&
+			!strcmp(SYM(he), "main") && he->stat.period == 100);
+
+out:
+	del_hist_entries(hists);
+	reset_output_field();
+	return err;
+}
+
+int test__hists_output(void)
+{
+	int err = TEST_FAIL;
+	struct machines machines;
+	struct machine *machine;
+	struct perf_evsel *evsel;
+	struct perf_evlist *evlist = perf_evlist__new();
+	size_t i;
+	test_fn_t testcases[] = {
+		test1,
+		test2,
+		test3,
+		test4,
+		test5,
+	};
+
+	TEST_ASSERT_VAL("No memory", evlist);
+
+	err = parse_events(evlist, "cpu-clock");
+	if (err)
+		goto out;
+
+	machines__init(&machines);
+
+	/* setup threads/dso/map/symbols also */
+	machine = setup_fake_machine(&machines);
+	if (!machine)
+		goto out;
+
+	if (verbose > 1)
+		machine__fprintf(machine, stderr);
+
+	evsel = perf_evlist__first(evlist);
+
+	for (i = 0; i < ARRAY_SIZE(testcases); i++) {
+		err = testcases[i](evsel, machine);
+		if (err < 0)
+			break;
+	}
+
+out:
+	/* tear down everything */
+	perf_evlist__delete(evlist);
+	machines__exit(&machines);
+
+	return err;
+}
diff --git a/tools/perf/tests/keep-tracking.c b/tools/perf/tests/keep-tracking.c
index 497957f..7a5ab7b 100644
--- a/tools/perf/tests/keep-tracking.c
+++ b/tools/perf/tests/keep-tracking.c
@@ -1,4 +1,4 @@
-#include <sys/types.h>
+#include <linux/types.h>
 #include <unistd.h>
 #include <sys/prctl.h>
 
diff --git a/tools/perf/tests/mmap-thread-lookup.c b/tools/perf/tests/mmap-thread-lookup.c
new file mode 100644
index 0000000..4a456fe
--- /dev/null
+++ b/tools/perf/tests/mmap-thread-lookup.c
@@ -0,0 +1,233 @@
+#include <unistd.h>
+#include <sys/syscall.h>
+#include <sys/types.h>
+#include <sys/mman.h>
+#include <pthread.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include "debug.h"
+#include "tests.h"
+#include "machine.h"
+#include "thread_map.h"
+#include "symbol.h"
+#include "thread.h"
+
+#define THREADS 4
+
+static int go_away;
+
+struct thread_data {
+	pthread_t	pt;
+	pid_t		tid;
+	void		*map;
+	int		ready[2];
+};
+
+static struct thread_data threads[THREADS];
+
+static int thread_init(struct thread_data *td)
+{
+	void *map;
+
+	map = mmap(NULL, page_size,
+		   PROT_READ|PROT_WRITE|PROT_EXEC,
+		   MAP_SHARED|MAP_ANONYMOUS, -1, 0);
+
+	if (map == MAP_FAILED) {
+		perror("mmap failed");
+		return -1;
+	}
+
+	td->map = map;
+	td->tid = syscall(SYS_gettid);
+
+	pr_debug("tid = %d, map = %p\n", td->tid, map);
+	return 0;
+}
+
+static void *thread_fn(void *arg)
+{
+	struct thread_data *td = arg;
+	ssize_t ret;
+	int go;
+
+	if (thread_init(td))
+		return NULL;
+
+	/* Signal thread_create thread is initialized. */
+	ret = write(td->ready[1], &go, sizeof(int));
+	if (ret != sizeof(int)) {
+		pr_err("failed to notify\n");
+		return NULL;
+	}
+
+	while (!go_away) {
+		/* Waiting for main thread to kill us. */
+		usleep(100);
+	}
+
+	munmap(td->map, page_size);
+	return NULL;
+}
+
+static int thread_create(int i)
+{
+	struct thread_data *td = &threads[i];
+	int err, go;
+
+	if (pipe(td->ready))
+		return -1;
+
+	err = pthread_create(&td->pt, NULL, thread_fn, td);
+	if (!err) {
+		/* Wait for thread initialization. */
+		ssize_t ret = read(td->ready[0], &go, sizeof(int));
+		err = ret != sizeof(int);
+	}
+
+	close(td->ready[0]);
+	close(td->ready[1]);
+	return err;
+}
+
+static int threads_create(void)
+{
+	struct thread_data *td0 = &threads[0];
+	int i, err = 0;
+
+	go_away = 0;
+
+	/* 0 is main thread */
+	if (thread_init(td0))
+		return -1;
+
+	for (i = 1; !err && i < THREADS; i++)
+		err = thread_create(i);
+
+	return err;
+}
+
+static int threads_destroy(void)
+{
+	struct thread_data *td0 = &threads[0];
+	int i, err = 0;
+
+	/* cleanup the main thread */
+	munmap(td0->map, page_size);
+
+	go_away = 1;
+
+	for (i = 1; !err && i < THREADS; i++)
+		err = pthread_join(threads[i].pt, NULL);
+
+	return err;
+}
+
+typedef int (*synth_cb)(struct machine *machine);
+
+static int synth_all(struct machine *machine)
+{
+	return perf_event__synthesize_threads(NULL,
+					      perf_event__process,
+					      machine, 0);
+}
+
+static int synth_process(struct machine *machine)
+{
+	struct thread_map *map;
+	int err;
+
+	map = thread_map__new_by_pid(getpid());
+
+	err = perf_event__synthesize_thread_map(NULL, map,
+						perf_event__process,
+						machine, 0);
+
+	thread_map__delete(map);
+	return err;
+}
+
+static int mmap_events(synth_cb synth)
+{
+	struct machines machines;
+	struct machine *machine;
+	int err, i;
+
+	/*
+	 * The threads_create will not return before all threads
+	 * are spawned and all created memory map.
+	 *
+	 * They will loop until threads_destroy is called, so we
+	 * can safely run synthesizing function.
+	 */
+	TEST_ASSERT_VAL("failed to create threads", !threads_create());
+
+	machines__init(&machines);
+	machine = &machines.host;
+
+	dump_trace = verbose > 1 ? 1 : 0;
+
+	err = synth(machine);
+
+	dump_trace = 0;
+
+	TEST_ASSERT_VAL("failed to destroy threads", !threads_destroy());
+	TEST_ASSERT_VAL("failed to synthesize maps", !err);
+
+	/*
+	 * All data is synthesized, try to find map for each
+	 * thread object.
+	 */
+	for (i = 0; i < THREADS; i++) {
+		struct thread_data *td = &threads[i];
+		struct addr_location al;
+		struct thread *thread;
+
+		thread = machine__findnew_thread(machine, getpid(), td->tid);
+
+		pr_debug("looking for map %p\n", td->map);
+
+		thread__find_addr_map(thread, machine,
+				      PERF_RECORD_MISC_USER, MAP__FUNCTION,
+				      (unsigned long) (td->map + 1), &al);
+
+		if (!al.map) {
+			pr_debug("failed, couldn't find map\n");
+			err = -1;
+			break;
+		}
+
+		pr_debug("map %p, addr %" PRIx64 "\n", al.map, al.map->start);
+	}
+
+	machine__delete_threads(machine);
+	machines__exit(&machines);
+	return err;
+}
+
+/*
+ * This test creates 'THREADS' number of threads (including
+ * main thread) and each thread creates memory map.
+ *
+ * When threads are created, we synthesize them with both
+ * (separate tests):
+ *   perf_event__synthesize_thread_map (process based)
+ *   perf_event__synthesize_threads    (global)
+ *
+ * We test we can find all memory maps via:
+ *   thread__find_addr_map
+ *
+ * by using all thread objects.
+ */
+int test__mmap_thread_lookup(void)
+{
+	/* perf_event__synthesize_threads synthesize */
+	TEST_ASSERT_VAL("failed with sythesizing all",
+			!mmap_events(synth_all));
+
+	/* perf_event__synthesize_thread_map synthesize */
+	TEST_ASSERT_VAL("failed with sythesizing process",
+			!mmap_events(synth_process));
+
+	return 0;
+}
diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 8605ff5..deba669 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -1174,188 +1174,240 @@ static int test__all_tracepoints(struct perf_evlist *evlist)
 struct evlist_test {
 	const char *name;
 	__u32 type;
+	const int id;
 	int (*check)(struct perf_evlist *evlist);
 };
 
 static struct evlist_test test__events[] = {
-	[0] = {
+	{
 		.name  = "syscalls:sys_enter_open",
 		.check = test__checkevent_tracepoint,
+		.id    = 0,
 	},
-	[1] = {
+	{
 		.name  = "syscalls:*",
 		.check = test__checkevent_tracepoint_multi,
+		.id    = 1,
 	},
-	[2] = {
+	{
 		.name  = "r1a",
 		.check = test__checkevent_raw,
+		.id    = 2,
 	},
-	[3] = {
+	{
 		.name  = "1:1",
 		.check = test__checkevent_numeric,
+		.id    = 3,
 	},
-	[4] = {
+	{
 		.name  = "instructions",
 		.check = test__checkevent_symbolic_name,
+		.id    = 4,
 	},
-	[5] = {
+	{
 		.name  = "cycles/period=100000,config2/",
 		.check = test__checkevent_symbolic_name_config,
+		.id    = 5,
 	},
-	[6] = {
+	{
 		.name  = "faults",
 		.check = test__checkevent_symbolic_alias,
+		.id    = 6,
 	},
-	[7] = {
+	{
 		.name  = "L1-dcache-load-miss",
 		.check = test__checkevent_genhw,
+		.id    = 7,
 	},
-	[8] = {
+	{
 		.name  = "mem:0",
 		.check = test__checkevent_breakpoint,
+		.id    = 8,
 	},
-	[9] = {
+	{
 		.name  = "mem:0:x",
 		.check = test__checkevent_breakpoint_x,
+		.id    = 9,
 	},
-	[10] = {
+	{
 		.name  = "mem:0:r",
 		.check = test__checkevent_breakpoint_r,
+		.id    = 10,
 	},
-	[11] = {
+	{
 		.name  = "mem:0:w",
 		.check = test__checkevent_breakpoint_w,
+		.id    = 11,
 	},
-	[12] = {
+	{
 		.name  = "syscalls:sys_enter_open:k",
 		.check = test__checkevent_tracepoint_modifier,
+		.id    = 12,
 	},
-	[13] = {
+	{
 		.name  = "syscalls:*:u",
 		.check = test__checkevent_tracepoint_multi_modifier,
+		.id    = 13,
 	},
-	[14] = {
+	{
 		.name  = "r1a:kp",
 		.check = test__checkevent_raw_modifier,
+		.id    = 14,
 	},
-	[15] = {
+	{
 		.name  = "1:1:hp",
 		.check = test__checkevent_numeric_modifier,
+		.id    = 15,
 	},
-	[16] = {
+	{
 		.name  = "instructions:h",
 		.check = test__checkevent_symbolic_name_modifier,
+		.id    = 16,
 	},
-	[17] = {
+	{
 		.name  = "faults:u",
 		.check = test__checkevent_symbolic_alias_modifier,
+		.id    = 17,
 	},
-	[18] = {
+	{
 		.name  = "L1-dcache-load-miss:kp",
 		.check = test__checkevent_genhw_modifier,
+		.id    = 18,
 	},
-	[19] = {
+	{
 		.name  = "mem:0:u",
 		.check = test__checkevent_breakpoint_modifier,
+		.id    = 19,
 	},
-	[20] = {
+	{
 		.name  = "mem:0:x:k",
 		.check = test__checkevent_breakpoint_x_modifier,
+		.id    = 20,
 	},
-	[21] = {
+	{
 		.name  = "mem:0:r:hp",
 		.check = test__checkevent_breakpoint_r_modifier,
+		.id    = 21,
 	},
-	[22] = {
+	{
 		.name  = "mem:0:w:up",
 		.check = test__checkevent_breakpoint_w_modifier,
+		.id    = 22,
 	},
-	[23] = {
+	{
 		.name  = "r1,syscalls:sys_enter_open:k,1:1:hp",
 		.check = test__checkevent_list,
+		.id    = 23,
 	},
-	[24] = {
+	{
 		.name  = "instructions:G",
 		.check = test__checkevent_exclude_host_modifier,
+		.id    = 24,
 	},
-	[25] = {
+	{
 		.name  = "instructions:H",
 		.check = test__checkevent_exclude_guest_modifier,
+		.id    = 25,
 	},
-	[26] = {
+	{
 		.name  = "mem:0:rw",
 		.check = test__checkevent_breakpoint_rw,
+		.id    = 26,
 	},
-	[27] = {
+	{
 		.name  = "mem:0:rw:kp",
 		.check = test__checkevent_breakpoint_rw_modifier,
+		.id    = 27,
 	},
-	[28] = {
+	{
 		.name  = "{instructions:k,cycles:upp}",
 		.check = test__group1,
+		.id    = 28,
 	},
-	[29] = {
+	{
 		.name  = "{faults:k,cache-references}:u,cycles:k",
 		.check = test__group2,
+		.id    = 29,
 	},
-	[30] = {
+	{
 		.name  = "group1{syscalls:sys_enter_open:H,cycles:kppp},group2{cycles,1:3}:G,instructions:u",
 		.check = test__group3,
+		.id    = 30,
 	},
-	[31] = {
+	{
 		.name  = "{cycles:u,instructions:kp}:p",
 		.check = test__group4,
+		.id    = 31,
 	},
-	[32] = {
+	{
 		.name  = "{cycles,instructions}:G,{cycles:G,instructions:G},cycles",
 		.check = test__group5,
+		.id    = 32,
 	},
-	[33] = {
+	{
 		.name  = "*:*",
 		.check = test__all_tracepoints,
+		.id    = 33,
 	},
-	[34] = {
+	{
 		.name  = "{cycles,cache-misses:G}:H",
 		.check = test__group_gh1,
+		.id    = 34,
 	},
-	[35] = {
+	{
 		.name  = "{cycles,cache-misses:H}:G",
 		.check = test__group_gh2,
+		.id    = 35,
 	},
-	[36] = {
+	{
 		.name  = "{cycles:G,cache-misses:H}:u",
 		.check = test__group_gh3,
+		.id    = 36,
 	},
-	[37] = {
+	{
 		.name  = "{cycles:G,cache-misses:H}:uG",
 		.check = test__group_gh4,
+		.id    = 37,
 	},
-	[38] = {
+	{
 		.name  = "{cycles,cache-misses,branch-misses}:S",
 		.check = test__leader_sample1,
+		.id    = 38,
 	},
-	[39] = {
+	{
 		.name  = "{instructions,branch-misses}:Su",
 		.check = test__leader_sample2,
+		.id    = 39,
 	},
-	[40] = {
+	{
 		.name  = "instructions:uDp",
 		.check = test__checkevent_pinned_modifier,
+		.id    = 40,
 	},
-	[41] = {
+	{
 		.name  = "{cycles,cache-misses,branch-misses}:D",
 		.check = test__pinned_group,
+		.id    = 41,
+	},
+#if defined(__s390x__)
+	{
+		.name  = "kvm-s390:kvm_s390_create_vm",
+		.check = test__checkevent_tracepoint,
+		.id    = 100,
 	},
+#endif
 };
 
 static struct evlist_test test__events_pmu[] = {
-	[0] = {
+	{
 		.name  = "cpu/config=10,config1,config2=3,period=1000/u",
 		.check = test__checkevent_pmu,
+		.id    = 0,
 	},
-	[1] = {
+	{
 		.name  = "cpu/config=1,name=krava/u,cpu/config=2/u",
 		.check = test__checkevent_pmu_name,
+		.id    = 1,
 	},
 };
 
@@ -1402,7 +1454,7 @@ static int test_events(struct evlist_test *events, unsigned cnt)
 	for (i = 0; i < cnt; i++) {
 		struct evlist_test *e = &events[i];
 
-		pr_debug("running test %d '%s'\n", i, e->name);
+		pr_debug("running test %d '%s'\n", e->id, e->name);
 		ret1 = test_event(e);
 		if (ret1)
 			ret2 = ret1;
diff --git a/tools/perf/tests/parse-no-sample-id-all.c b/tools/perf/tests/parse-no-sample-id-all.c
index e117b6c..905019f 100644
--- a/tools/perf/tests/parse-no-sample-id-all.c
+++ b/tools/perf/tests/parse-no-sample-id-all.c
@@ -1,4 +1,4 @@
-#include <sys/types.h>
+#include <linux/types.h>
 #include <stddef.h>
 
 #include "tests.h"
diff --git a/tools/perf/tests/perf-time-to-tsc.c b/tools/perf/tests/perf-time-to-tsc.c
index 47146d3..3b7cd4d 100644
--- a/tools/perf/tests/perf-time-to-tsc.c
+++ b/tools/perf/tests/perf-time-to-tsc.c
@@ -1,7 +1,6 @@
 #include <stdio.h>
-#include <sys/types.h>
 #include <unistd.h>
-#include <inttypes.h>
+#include <linux/types.h>
 #include <sys/prctl.h>
 
 #include "parse-events.h"
diff --git a/tools/perf/tests/rdpmc.c b/tools/perf/tests/rdpmc.c
index 46649c2..e59143f 100644
--- a/tools/perf/tests/rdpmc.c
+++ b/tools/perf/tests/rdpmc.c
@@ -2,7 +2,7 @@
 #include <stdlib.h>
 #include <signal.h>
 #include <sys/mman.h>
-#include "types.h"
+#include <linux/types.h>
 #include "perf.h"
 #include "debug.h"
 #include "tests.h"
diff --git a/tools/perf/tests/sample-parsing.c b/tools/perf/tests/sample-parsing.c
index 0014d3c..7ae8d17 100644
--- a/tools/perf/tests/sample-parsing.c
+++ b/tools/perf/tests/sample-parsing.c
@@ -1,5 +1,5 @@
 #include <stdbool.h>
-#include <inttypes.h>
+#include <linux/types.h>
 
 #include "util.h"
 #include "event.h"
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index a24795c..d76c0e2 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -41,8 +41,12 @@ int test__sample_parsing(void);
 int test__keep_tracking(void);
 int test__parse_no_sample_id_all(void);
 int test__dwarf_unwind(void);
+int test__hists_filter(void);
+int test__mmap_thread_lookup(void);
+int test__thread_mg_share(void);
+int test__hists_output(void);
 
-#if defined(__x86_64__) || defined(__i386__)
+#if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
 struct thread;
 struct perf_sample;
diff --git a/tools/perf/tests/thread-mg-share.c b/tools/perf/tests/thread-mg-share.c
new file mode 100644
index 0000000..2b2e0db
--- /dev/null
+++ b/tools/perf/tests/thread-mg-share.c
@@ -0,0 +1,90 @@
+#include "tests.h"
+#include "machine.h"
+#include "thread.h"
+#include "map.h"
+
+int test__thread_mg_share(void)
+{
+	struct machines machines;
+	struct machine *machine;
+
+	/* thread group */
+	struct thread *leader;
+	struct thread *t1, *t2, *t3;
+	struct map_groups *mg;
+
+	/* other process */
+	struct thread *other, *other_leader;
+	struct map_groups *other_mg;
+
+	/*
+	 * This test create 2 processes abstractions (struct thread)
+	 * with several threads and checks they properly share and
+	 * maintain map groups info (struct map_groups).
+	 *
+	 * thread group (pid: 0, tids: 0, 1, 2, 3)
+	 * other  group (pid: 4, tids: 4, 5)
+	*/
+
+	machines__init(&machines);
+	machine = &machines.host;
+
+	/* create process with 4 threads */
+	leader = machine__findnew_thread(machine, 0, 0);
+	t1     = machine__findnew_thread(machine, 0, 1);
+	t2     = machine__findnew_thread(machine, 0, 2);
+	t3     = machine__findnew_thread(machine, 0, 3);
+
+	/* and create 1 separated process, without thread leader */
+	other  = machine__findnew_thread(machine, 4, 5);
+
+	TEST_ASSERT_VAL("failed to create threads",
+			leader && t1 && t2 && t3 && other);
+
+	mg = leader->mg;
+	TEST_ASSERT_VAL("wrong refcnt", mg->refcnt == 4);
+
+	/* test the map groups pointer is shared */
+	TEST_ASSERT_VAL("map groups don't match", mg == t1->mg);
+	TEST_ASSERT_VAL("map groups don't match", mg == t2->mg);
+	TEST_ASSERT_VAL("map groups don't match", mg == t3->mg);
+
+	/*
+	 * Verify the other leader was created by previous call.
+	 * It should have shared map groups with no change in
+	 * refcnt.
+	 */
+	other_leader = machine__find_thread(machine, 4, 4);
+	TEST_ASSERT_VAL("failed to find other leader", other_leader);
+
+	other_mg = other->mg;
+	TEST_ASSERT_VAL("wrong refcnt", other_mg->refcnt == 2);
+
+	TEST_ASSERT_VAL("map groups don't match", other_mg == other_leader->mg);
+
+	/* release thread group */
+	thread__delete(leader);
+	TEST_ASSERT_VAL("wrong refcnt", mg->refcnt == 3);
+
+	thread__delete(t1);
+	TEST_ASSERT_VAL("wrong refcnt", mg->refcnt == 2);
+
+	thread__delete(t2);
+	TEST_ASSERT_VAL("wrong refcnt", mg->refcnt == 1);
+
+	thread__delete(t3);
+
+	/* release other group  */
+	thread__delete(other_leader);
+	TEST_ASSERT_VAL("wrong refcnt", other_mg->refcnt == 1);
+
+	thread__delete(other);
+
+	/*
+	 * Cannot call machine__delete_threads(machine) now,
+	 * because we've already released all the threads.
+	 */
+
+	machines__exit(&machines);
+	return 0;
+}
diff --git a/tools/perf/ui/browser.h b/tools/perf/ui/browser.h
index 118cca2..03d4d62 100644
--- a/tools/perf/ui/browser.h
+++ b/tools/perf/ui/browser.h
@@ -1,9 +1,7 @@
 #ifndef _PERF_UI_BROWSER_H_
 #define _PERF_UI_BROWSER_H_ 1
 
-#include <stdbool.h>
-#include <sys/types.h>
-#include "../types.h"
+#include <linux/types.h>
 
 #define HE_COLORSET_TOP		50
 #define HE_COLORSET_MEDIUM	51
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 7ec871a..1c331b9 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -26,13 +26,36 @@ struct hist_browser {
 	int		     print_seq;
 	bool		     show_dso;
 	float		     min_pcnt;
-	u64		     nr_pcnt_entries;
+	u64		     nr_non_filtered_entries;
+	u64		     nr_callchain_rows;
 };
 
 extern void hist_browser__init_hpp(void);
 
 static int hists__browser_title(struct hists *hists, char *bf, size_t size,
 				const char *ev_name);
+static void hist_browser__update_nr_entries(struct hist_browser *hb);
+
+static struct rb_node *hists__filter_entries(struct rb_node *nd,
+					     struct hists *hists,
+					     float min_pcnt);
+
+static bool hist_browser__has_filter(struct hist_browser *hb)
+{
+	return hists__has_filter(hb->hists) || hb->min_pcnt;
+}
+
+static u32 hist_browser__nr_entries(struct hist_browser *hb)
+{
+	u32 nr_entries;
+
+	if (hist_browser__has_filter(hb))
+		nr_entries = hb->nr_non_filtered_entries;
+	else
+		nr_entries = hb->hists->nr_entries;
+
+	return nr_entries + hb->nr_callchain_rows;
+}
 
 static void hist_browser__refresh_dimensions(struct hist_browser *browser)
 {
@@ -43,7 +66,14 @@ static void hist_browser__refresh_dimensions(struct hist_browser *browser)
 
 static void hist_browser__reset(struct hist_browser *browser)
 {
-	browser->b.nr_entries = browser->hists->nr_entries;
+	/*
+	 * The hists__remove_entry_filter() already folds non-filtered
+	 * entries so we can assume it has 0 callchain rows.
+	 */
+	browser->nr_callchain_rows = 0;
+
+	hist_browser__update_nr_entries(browser);
+	browser->b.nr_entries = hist_browser__nr_entries(browser);
 	hist_browser__refresh_dimensions(browser);
 	ui_browser__reset_index(&browser->b);
 }
@@ -198,14 +228,16 @@ static bool hist_browser__toggle_fold(struct hist_browser *browser)
 		struct hist_entry *he = browser->he_selection;
 
 		hist_entry__init_have_children(he);
-		browser->hists->nr_entries -= he->nr_rows;
+		browser->b.nr_entries -= he->nr_rows;
+		browser->nr_callchain_rows -= he->nr_rows;
 
 		if (he->ms.unfolded)
 			he->nr_rows = callchain__count_rows(&he->sorted_chain);
 		else
 			he->nr_rows = 0;
-		browser->hists->nr_entries += he->nr_rows;
-		browser->b.nr_entries = browser->hists->nr_entries;
+
+		browser->b.nr_entries += he->nr_rows;
+		browser->nr_callchain_rows += he->nr_rows;
 
 		return true;
 	}
@@ -280,23 +312,27 @@ static void hist_entry__set_folding(struct hist_entry *he, bool unfold)
 		he->nr_rows = 0;
 }
 
-static void hists__set_folding(struct hists *hists, bool unfold)
+static void
+__hist_browser__set_folding(struct hist_browser *browser, bool unfold)
 {
 	struct rb_node *nd;
+	struct hists *hists = browser->hists;
 
-	hists->nr_entries = 0;
-
-	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&hists->entries);
+	     (nd = hists__filter_entries(nd, hists, browser->min_pcnt)) != NULL;
+	     nd = rb_next(nd)) {
 		struct hist_entry *he = rb_entry(nd, struct hist_entry, rb_node);
 		hist_entry__set_folding(he, unfold);
-		hists->nr_entries += 1 + he->nr_rows;
+		browser->nr_callchain_rows += he->nr_rows;
 	}
 }
 
 static void hist_browser__set_folding(struct hist_browser *browser, bool unfold)
 {
-	hists__set_folding(browser->hists, unfold);
-	browser->b.nr_entries = browser->hists->nr_entries;
+	browser->nr_callchain_rows = 0;
+	__hist_browser__set_folding(browser, unfold);
+
+	browser->b.nr_entries = hist_browser__nr_entries(browser);
 	/* Go to the start, we may be way after valid entries after a collapse */
 	ui_browser__reset_index(&browser->b);
 }
@@ -310,8 +346,6 @@ static void ui_browser__warn_lost_events(struct ui_browser *browser)
 		"Or reduce the sampling frequency.");
 }
 
-static void hist_browser__update_pcnt_entries(struct hist_browser *hb);
-
 static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 			     struct hist_browser_timer *hbt)
 {
@@ -320,9 +354,7 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 	int delay_secs = hbt ? hbt->refresh : 0;
 
 	browser->b.entries = &browser->hists->entries;
-	browser->b.nr_entries = browser->hists->nr_entries;
-	if (browser->min_pcnt)
-		browser->b.nr_entries = browser->nr_pcnt_entries;
+	browser->b.nr_entries = hist_browser__nr_entries(browser);
 
 	hist_browser__refresh_dimensions(browser);
 	hists__browser_title(browser->hists, title, sizeof(title), ev_name);
@@ -339,13 +371,10 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 			u64 nr_entries;
 			hbt->timer(hbt->arg);
 
-			if (browser->min_pcnt) {
-				hist_browser__update_pcnt_entries(browser);
-				nr_entries = browser->nr_pcnt_entries;
-			} else {
-				nr_entries = browser->hists->nr_entries;
-			}
+			if (hist_browser__has_filter(browser))
+				hist_browser__update_nr_entries(browser);
 
+			nr_entries = hist_browser__nr_entries(browser);
 			ui_browser__update_nr_entries(&browser->b, nr_entries);
 
 			if (browser->hists->stats.nr_lost_warned !=
@@ -587,35 +616,6 @@ struct hpp_arg {
 	bool current_entry;
 };
 
-static int __hpp__overhead_callback(struct perf_hpp *hpp, bool front)
-{
-	struct hpp_arg *arg = hpp->ptr;
-
-	if (arg->current_entry && arg->b->navkeypressed)
-		ui_browser__set_color(arg->b, HE_COLORSET_SELECTED);
-	else
-		ui_browser__set_color(arg->b, HE_COLORSET_NORMAL);
-
-	if (front) {
-		if (!symbol_conf.use_callchain)
-			return 0;
-
-		slsmg_printf("%c ", arg->folded_sign);
-		return 2;
-	}
-
-	return 0;
-}
-
-static int __hpp__color_callback(struct perf_hpp *hpp, bool front __maybe_unused)
-{
-	struct hpp_arg *arg = hpp->ptr;
-
-	if (!arg->current_entry || !arg->b->navkeypressed)
-		ui_browser__set_color(arg->b, HE_COLORSET_NORMAL);
-	return 0;
-}
-
 static int __hpp__slsmg_color_printf(struct perf_hpp *hpp, const char *fmt, ...)
 {
 	struct hpp_arg *arg = hpp->ptr;
@@ -636,7 +636,7 @@ static int __hpp__slsmg_color_printf(struct perf_hpp *hpp, const char *fmt, ...)
 	return ret;
 }
 
-#define __HPP_COLOR_PERCENT_FN(_type, _field, _cb)			\
+#define __HPP_COLOR_PERCENT_FN(_type, _field)				\
 static u64 __hpp_get_##_field(struct hist_entry *he)			\
 {									\
 	return he->stat._field;						\
@@ -647,22 +647,20 @@ hist_browser__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,\
 				struct perf_hpp *hpp,			\
 				struct hist_entry *he)			\
 {									\
-	return __hpp__fmt(hpp, he, __hpp_get_##_field, _cb, " %6.2f%%",	\
+	return __hpp__fmt(hpp, he, __hpp_get_##_field, " %6.2f%%",	\
 			  __hpp__slsmg_color_printf, true);		\
 }
 
-__HPP_COLOR_PERCENT_FN(overhead, period, __hpp__overhead_callback)
-__HPP_COLOR_PERCENT_FN(overhead_sys, period_sys, __hpp__color_callback)
-__HPP_COLOR_PERCENT_FN(overhead_us, period_us, __hpp__color_callback)
-__HPP_COLOR_PERCENT_FN(overhead_guest_sys, period_guest_sys, __hpp__color_callback)
-__HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us, __hpp__color_callback)
+__HPP_COLOR_PERCENT_FN(overhead, period)
+__HPP_COLOR_PERCENT_FN(overhead_sys, period_sys)
+__HPP_COLOR_PERCENT_FN(overhead_us, period_us)
+__HPP_COLOR_PERCENT_FN(overhead_guest_sys, period_guest_sys)
+__HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us)
 
 #undef __HPP_COLOR_PERCENT_FN
 
 void hist_browser__init_hpp(void)
 {
-	perf_hpp__init();
-
 	perf_hpp__format[PERF_HPP__OVERHEAD].color =
 				hist_browser__hpp_color_overhead;
 	perf_hpp__format[PERF_HPP__OVERHEAD_SYS].color =
@@ -700,7 +698,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 
 	if (row_offset == 0) {
 		struct hpp_arg arg = {
-			.b 		= &browser->b,
+			.b		= &browser->b,
 			.folded_sign	= folded_sign,
 			.current_entry	= current_entry,
 		};
@@ -713,11 +711,27 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 		ui_browser__gotorc(&browser->b, row, 0);
 
 		perf_hpp__for_each_format(fmt) {
-			if (!first) {
+			if (perf_hpp__should_skip(fmt))
+				continue;
+
+			if (current_entry && browser->b.navkeypressed) {
+				ui_browser__set_color(&browser->b,
+						      HE_COLORSET_SELECTED);
+			} else {
+				ui_browser__set_color(&browser->b,
+						      HE_COLORSET_NORMAL);
+			}
+
+			if (first) {
+				if (symbol_conf.use_callchain) {
+					slsmg_printf("%c ", folded_sign);
+					width -= 2;
+				}
+				first = false;
+			} else {
 				slsmg_printf("  ");
 				width -= 2;
 			}
-			first = false;
 
 			if (fmt->color) {
 				width -= fmt->color(fmt, &hpp, entry);
@@ -731,8 +745,8 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 		if (!browser->b.navkeypressed)
 			width += 1;
 
-		hist_entry__sort_snprintf(entry, s, sizeof(s), browser->hists);
-		slsmg_write_nstring(s, width);
+		slsmg_write_nstring("", width);
+
 		++row;
 		++printed;
 	} else
@@ -769,12 +783,15 @@ static unsigned int hist_browser__refresh(struct ui_browser *browser)
 
 	for (nd = browser->top; nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		float percent = h->stat.period * 100.0 /
-					hb->hists->stats.total_period;
+		u64 total = hists__total_period(h->hists);
+		float percent = 0.0;
 
 		if (h->filtered)
 			continue;
 
+		if (total)
+			percent = h->stat.period * 100.0 / total;
+
 		if (percent < hb->min_pcnt)
 			continue;
 
@@ -792,13 +809,13 @@ static struct rb_node *hists__filter_entries(struct rb_node *nd,
 {
 	while (nd != NULL) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		float percent = h->stat.period * 100.0 /
-					hists->stats.total_period;
+		u64 total = hists__total_period(hists);
+		float percent = 0.0;
 
-		if (percent < min_pcnt)
-			return NULL;
+		if (total)
+			percent = h->stat.period * 100.0 / total;
 
-		if (!h->filtered)
+		if (!h->filtered && percent >= min_pcnt)
 			return nd;
 
 		nd = rb_next(nd);
@@ -813,8 +830,11 @@ static struct rb_node *hists__filter_prev_entries(struct rb_node *nd,
 {
 	while (nd != NULL) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		float percent = h->stat.period * 100.0 /
-					hists->stats.total_period;
+		u64 total = hists__total_period(hists);
+		float percent = 0.0;
+
+		if (total)
+			percent = h->stat.period * 100.0 / total;
 
 		if (!h->filtered && percent >= min_pcnt)
 			return nd;
@@ -1066,27 +1086,35 @@ static int hist_browser__fprintf_entry(struct hist_browser *browser,
 				       struct hist_entry *he, FILE *fp)
 {
 	char s[8192];
-	double percent;
 	int printed = 0;
 	char folded_sign = ' ';
+	struct perf_hpp hpp = {
+		.buf = s,
+		.size = sizeof(s),
+	};
+	struct perf_hpp_fmt *fmt;
+	bool first = true;
+	int ret;
 
 	if (symbol_conf.use_callchain)
 		folded_sign = hist_entry__folded(he);
 
-	hist_entry__sort_snprintf(he, s, sizeof(s), browser->hists);
-	percent = (he->stat.period * 100.0) / browser->hists->stats.total_period;
-
 	if (symbol_conf.use_callchain)
 		printed += fprintf(fp, "%c ", folded_sign);
 
-	printed += fprintf(fp, " %5.2f%%", percent);
-
-	if (symbol_conf.show_nr_samples)
-		printed += fprintf(fp, " %11u", he->stat.nr_events);
+	perf_hpp__for_each_format(fmt) {
+		if (perf_hpp__should_skip(fmt))
+			continue;
 
-	if (symbol_conf.show_total_period)
-		printed += fprintf(fp, " %12" PRIu64, he->stat.period);
+		if (!first) {
+			ret = scnprintf(hpp.buf, hpp.size, "  ");
+			advance_hpp(&hpp, ret);
+		} else
+			first = false;
 
+		ret = fmt->entry(fmt, &hpp, he);
+		advance_hpp(&hpp, ret);
+	}
 	printed += fprintf(fp, "%s\n", rtrim(s));
 
 	if (folded_sign == '-')
@@ -1189,6 +1217,11 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size,
 	char buf[512];
 	size_t buflen = sizeof(buf);
 
+	if (symbol_conf.filter_relative) {
+		nr_samples = hists->stats.nr_non_filtered_samples;
+		nr_events = hists->stats.total_non_filtered_period;
+	}
+
 	if (perf_evsel__is_group_event(evsel)) {
 		struct perf_evsel *pos;
 
@@ -1196,8 +1229,13 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size,
 		ev_name = buf;
 
 		for_each_group_member(pos, evsel) {
-			nr_samples += pos->hists.stats.nr_events[PERF_RECORD_SAMPLE];
-			nr_events += pos->hists.stats.total_period;
+			if (symbol_conf.filter_relative) {
+				nr_samples += pos->hists.stats.nr_non_filtered_samples;
+				nr_events += pos->hists.stats.total_non_filtered_period;
+			} else {
+				nr_samples += pos->hists.stats.nr_events[PERF_RECORD_SAMPLE];
+				nr_events += pos->hists.stats.total_period;
+			}
 		}
 	}
 
@@ -1324,18 +1362,23 @@ close_file_and_continue:
 	return ret;
 }
 
-static void hist_browser__update_pcnt_entries(struct hist_browser *hb)
+static void hist_browser__update_nr_entries(struct hist_browser *hb)
 {
 	u64 nr_entries = 0;
 	struct rb_node *nd = rb_first(&hb->hists->entries);
 
-	while (nd) {
+	if (hb->min_pcnt == 0) {
+		hb->nr_non_filtered_entries = hb->hists->nr_non_filtered_entries;
+		return;
+	}
+
+	while ((nd = hists__filter_entries(nd, hb->hists,
+					   hb->min_pcnt)) != NULL) {
 		nr_entries++;
-		nd = hists__filter_entries(rb_next(nd), hb->hists,
-					   hb->min_pcnt);
+		nd = rb_next(nd);
 	}
 
-	hb->nr_pcnt_entries = nr_entries;
+	hb->nr_non_filtered_entries = nr_entries;
 }
 
 static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
@@ -1370,6 +1413,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	"C             Collapse all callchains\n"			\
 	"d             Zoom into current DSO\n"				\
 	"E             Expand all callchains\n"				\
+	"F             Toggle percentage of filtered entries\n"		\
 
 	/* help messages are sorted by lexical order of the hotkey */
 	const char report_help[] = HIST_BROWSER_HELP_COMMON
@@ -1391,7 +1435,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 
 	if (min_pcnt) {
 		browser->min_pcnt = min_pcnt;
-		hist_browser__update_pcnt_entries(browser);
+		hist_browser__update_nr_entries(browser);
 	}
 
 	fstack = pstack__new(2);
@@ -1475,6 +1519,9 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			if (env->arch)
 				tui__header_window(env);
 			continue;
+		case 'F':
+			symbol_conf.filter_relative ^= 1;
+			continue;
 		case K_F1:
 		case 'h':
 		case '?':
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index e395ef9..9d90683 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -43,7 +43,7 @@ static int perf_gtk__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,
 				       struct perf_hpp *hpp,			\
 				       struct hist_entry *he)			\
 {										\
-	return __hpp__fmt(hpp, he, he_get_##_field, NULL, " %6.2f%%",		\
+	return __hpp__fmt(hpp, he, he_get_##_field, " %6.2f%%",			\
 			  __percent_color_snprintf, true);			\
 }
 
@@ -58,8 +58,6 @@ __HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us)
 
 void perf_gtk__init_hpp(void)
 {
-	perf_hpp__init();
-
 	perf_hpp__format[PERF_HPP__OVERHEAD].color =
 				perf_gtk__hpp_color_overhead;
 	perf_hpp__format[PERF_HPP__OVERHEAD_SYS].color =
@@ -153,7 +151,6 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 	struct perf_hpp_fmt *fmt;
 	GType col_types[MAX_COLUMNS];
 	GtkCellRenderer *renderer;
-	struct sort_entry *se;
 	GtkTreeStore *store;
 	struct rb_node *nd;
 	GtkWidget *view;
@@ -172,16 +169,6 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 	perf_hpp__for_each_format(fmt)
 		col_types[nr_cols++] = G_TYPE_STRING;
 
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		if (se->elide)
-			continue;
-
-		if (se == &sort_sym)
-			sym_col = nr_cols;
-
-		col_types[nr_cols++] = G_TYPE_STRING;
-	}
-
 	store = gtk_tree_store_newv(nr_cols, col_types);
 
 	view = gtk_tree_view_new();
@@ -191,6 +178,9 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 	col_idx = 0;
 
 	perf_hpp__for_each_format(fmt) {
+		if (perf_hpp__should_skip(fmt))
+			continue;
+
 		fmt->header(fmt, &hpp, hists_to_evsel(hists));
 
 		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
@@ -199,16 +189,6 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 							    col_idx++, NULL);
 	}
 
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		if (se->elide)
-			continue;
-
-		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
-							    -1, se->se_header,
-							    renderer, "text",
-							    col_idx++, NULL);
-	}
-
 	for (col_idx = 0; col_idx < nr_cols; col_idx++) {
 		GtkTreeViewColumn *column;
 
@@ -228,12 +208,15 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 		GtkTreeIter iter;
-		float percent = h->stat.period * 100.0 /
-					hists->stats.total_period;
+		u64 total = hists__total_period(h->hists);
+		float percent = 0.0;
 
 		if (h->filtered)
 			continue;
 
+		if (total)
+			percent = h->stat.period * 100.0 / total;
+
 		if (percent < min_pcnt)
 			continue;
 
@@ -242,6 +225,9 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 		col_idx = 0;
 
 		perf_hpp__for_each_format(fmt) {
+			if (perf_hpp__should_skip(fmt))
+				continue;
+
 			if (fmt->color)
 				fmt->color(fmt, &hpp, h);
 			else
@@ -250,23 +236,9 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 			gtk_tree_store_set(store, &iter, col_idx++, s, -1);
 		}
 
-		list_for_each_entry(se, &hist_entry__sort_list, list) {
-			if (se->elide)
-				continue;
-
-			se->se_snprintf(h, s, ARRAY_SIZE(s),
-					hists__col_len(hists, se->se_width_idx));
-
-			gtk_tree_store_set(store, &iter, col_idx++, s, -1);
-		}
-
 		if (symbol_conf.use_callchain && sort__has_sym) {
-			u64 total;
-
 			if (callchain_param.mode == CHAIN_GRAPH_REL)
 				total = h->stat.period;
-			else
-				total = hists->stats.total_period;
 
 			perf_gtk__add_callchain(&h->sorted_chain, store, &iter,
 						sym_col, total);
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 0f403b8..4484f5b 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -16,30 +16,25 @@
 })
 
 int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
-	       hpp_field_fn get_field, hpp_callback_fn callback,
-	       const char *fmt, hpp_snprint_fn print_fn, bool fmt_percent)
+	       hpp_field_fn get_field, const char *fmt,
+	       hpp_snprint_fn print_fn, bool fmt_percent)
 {
-	int ret = 0;
+	int ret;
 	struct hists *hists = he->hists;
 	struct perf_evsel *evsel = hists_to_evsel(hists);
 	char *buf = hpp->buf;
 	size_t size = hpp->size;
 
-	if (callback) {
-		ret = callback(hpp, true);
-		advance_hpp(hpp, ret);
-	}
-
 	if (fmt_percent) {
 		double percent = 0.0;
+		u64 total = hists__total_period(hists);
 
-		if (hists->stats.total_period)
-			percent = 100.0 * get_field(he) /
-				  hists->stats.total_period;
+		if (total)
+			percent = 100.0 * get_field(he) / total;
 
-		ret += hpp__call_print_fn(hpp, print_fn, fmt, percent);
+		ret = hpp__call_print_fn(hpp, print_fn, fmt, percent);
 	} else
-		ret += hpp__call_print_fn(hpp, print_fn, fmt, get_field(he));
+		ret = hpp__call_print_fn(hpp, print_fn, fmt, get_field(he));
 
 	if (perf_evsel__is_group_event(evsel)) {
 		int prev_idx, idx_delta;
@@ -50,7 +45,7 @@ int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 
 		list_for_each_entry(pair, &he->pairs.head, pairs.node) {
 			u64 period = get_field(pair);
-			u64 total = pair->hists->stats.total_period;
+			u64 total = hists__total_period(pair->hists);
 
 			if (!total)
 				continue;
@@ -99,13 +94,6 @@ int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 		}
 	}
 
-	if (callback) {
-		int __ret = callback(hpp, false);
-
-		advance_hpp(hpp, __ret);
-		ret += __ret;
-	}
-
 	/*
 	 * Restore original buf and size as it's where caller expects
 	 * the result will be saved.
@@ -116,6 +104,62 @@ int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 	return ret;
 }
 
+static int field_cmp(u64 field_a, u64 field_b)
+{
+	if (field_a > field_b)
+		return 1;
+	if (field_a < field_b)
+		return -1;
+	return 0;
+}
+
+static int __hpp__sort(struct hist_entry *a, struct hist_entry *b,
+		       hpp_field_fn get_field)
+{
+	s64 ret;
+	int i, nr_members;
+	struct perf_evsel *evsel;
+	struct hist_entry *pair;
+	u64 *fields_a, *fields_b;
+
+	ret = field_cmp(get_field(a), get_field(b));
+	if (ret || !symbol_conf.event_group)
+		return ret;
+
+	evsel = hists_to_evsel(a->hists);
+	if (!perf_evsel__is_group_event(evsel))
+		return ret;
+
+	nr_members = evsel->nr_members;
+	fields_a = calloc(sizeof(*fields_a), nr_members);
+	fields_b = calloc(sizeof(*fields_b), nr_members);
+
+	if (!fields_a || !fields_b)
+		goto out;
+
+	list_for_each_entry(pair, &a->pairs.head, pairs.node) {
+		evsel = hists_to_evsel(pair->hists);
+		fields_a[perf_evsel__group_idx(evsel)] = get_field(pair);
+	}
+
+	list_for_each_entry(pair, &b->pairs.head, pairs.node) {
+		evsel = hists_to_evsel(pair->hists);
+		fields_b[perf_evsel__group_idx(evsel)] = get_field(pair);
+	}
+
+	for (i = 1; i < nr_members; i++) {
+		ret = field_cmp(fields_a[i], fields_b[i]);
+		if (ret)
+			break;
+	}
+
+out:
+	free(fields_a);
+	free(fields_b);
+
+	return ret;
+}
+
 #define __HPP_HEADER_FN(_type, _str, _min_width, _unit_width) 		\
 static int hpp__header_##_type(struct perf_hpp_fmt *fmt __maybe_unused,	\
 			       struct perf_hpp *hpp,			\
@@ -179,7 +223,7 @@ static u64 he_get_##_field(struct hist_entry *he)				\
 static int hpp__color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,		\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
-	return __hpp__fmt(hpp, he, he_get_##_field, NULL, " %6.2f%%",		\
+	return __hpp__fmt(hpp, he, he_get_##_field, " %6.2f%%",			\
 			  hpp_color_scnprintf, true);				\
 }
 
@@ -188,10 +232,16 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
 	const char *fmt = symbol_conf.field_sep ? " %.2f" : " %6.2f%%";		\
-	return __hpp__fmt(hpp, he, he_get_##_field, NULL, fmt,			\
+	return __hpp__fmt(hpp, he, he_get_##_field, fmt,			\
 			  hpp_entry_scnprintf, true);				\
 }
 
+#define __HPP_SORT_FN(_type, _field)						\
+static int64_t hpp__sort_##_type(struct hist_entry *a, struct hist_entry *b)	\
+{										\
+	return __hpp__sort(a, b, he_get_##_field);				\
+}
+
 #define __HPP_ENTRY_RAW_FN(_type, _field)					\
 static u64 he_get_raw_##_field(struct hist_entry *he)				\
 {										\
@@ -202,20 +252,29 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
 	const char *fmt = symbol_conf.field_sep ? " %"PRIu64 : " %11"PRIu64;	\
-	return __hpp__fmt(hpp, he, he_get_raw_##_field, NULL, fmt,		\
+	return __hpp__fmt(hpp, he, he_get_raw_##_field, fmt,			\
 			  hpp_entry_scnprintf, false);				\
 }
 
+#define __HPP_SORT_RAW_FN(_type, _field)					\
+static int64_t hpp__sort_##_type(struct hist_entry *a, struct hist_entry *b)	\
+{										\
+	return __hpp__sort(a, b, he_get_raw_##_field);				\
+}
+
+
 #define HPP_PERCENT_FNS(_type, _str, _field, _min_width, _unit_width)	\
 __HPP_HEADER_FN(_type, _str, _min_width, _unit_width)			\
 __HPP_WIDTH_FN(_type, _min_width, _unit_width)				\
 __HPP_COLOR_PERCENT_FN(_type, _field)					\
-__HPP_ENTRY_PERCENT_FN(_type, _field)
+__HPP_ENTRY_PERCENT_FN(_type, _field)					\
+__HPP_SORT_FN(_type, _field)
 
 #define HPP_RAW_FNS(_type, _str, _field, _min_width, _unit_width)	\
 __HPP_HEADER_FN(_type, _str, _min_width, _unit_width)			\
 __HPP_WIDTH_FN(_type, _min_width, _unit_width)				\
-__HPP_ENTRY_RAW_FN(_type, _field)
+__HPP_ENTRY_RAW_FN(_type, _field)					\
+__HPP_SORT_RAW_FN(_type, _field)
 
 
 HPP_PERCENT_FNS(overhead, "Overhead", period, 8, 8)
@@ -227,19 +286,31 @@ HPP_PERCENT_FNS(overhead_guest_us, "guest usr", period_guest_us, 9, 8)
 HPP_RAW_FNS(samples, "Samples", nr_events, 12, 12)
 HPP_RAW_FNS(period, "Period", period, 12, 12)
 
+static int64_t hpp__nop_cmp(struct hist_entry *a __maybe_unused,
+			    struct hist_entry *b __maybe_unused)
+{
+	return 0;
+}
+
 #define HPP__COLOR_PRINT_FNS(_name)			\
 	{						\
 		.header	= hpp__header_ ## _name,	\
 		.width	= hpp__width_ ## _name,		\
 		.color	= hpp__color_ ## _name,		\
-		.entry	= hpp__entry_ ## _name		\
+		.entry	= hpp__entry_ ## _name,		\
+		.cmp	= hpp__nop_cmp,			\
+		.collapse = hpp__nop_cmp,		\
+		.sort	= hpp__sort_ ## _name,		\
 	}
 
 #define HPP__PRINT_FNS(_name)				\
 	{						\
 		.header	= hpp__header_ ## _name,	\
 		.width	= hpp__width_ ## _name,		\
-		.entry	= hpp__entry_ ## _name		\
+		.entry	= hpp__entry_ ## _name,		\
+		.cmp	= hpp__nop_cmp,			\
+		.collapse = hpp__nop_cmp,		\
+		.sort	= hpp__sort_ ## _name,		\
 	}
 
 struct perf_hpp_fmt perf_hpp__format[] = {
@@ -253,6 +324,7 @@ struct perf_hpp_fmt perf_hpp__format[] = {
 };
 
 LIST_HEAD(perf_hpp__list);
+LIST_HEAD(perf_hpp__sort_list);
 
 
 #undef HPP__COLOR_PRINT_FNS
@@ -270,6 +342,25 @@ LIST_HEAD(perf_hpp__list);
 
 void perf_hpp__init(void)
 {
+	struct list_head *list;
+	int i;
+
+	for (i = 0; i < PERF_HPP__MAX_INDEX; i++) {
+		struct perf_hpp_fmt *fmt = &perf_hpp__format[i];
+
+		INIT_LIST_HEAD(&fmt->list);
+
+		/* sort_list may be linked by setup_sorting() */
+		if (fmt->sort_list.next == NULL)
+			INIT_LIST_HEAD(&fmt->sort_list);
+	}
+
+	/*
+	 * If user specified field order, no need to setup default fields.
+	 */
+	if (field_order)
+		return;
+
 	perf_hpp__column_enable(PERF_HPP__OVERHEAD);
 
 	if (symbol_conf.show_cpu_utilization) {
@@ -287,6 +378,11 @@ void perf_hpp__init(void)
 
 	if (symbol_conf.show_total_period)
 		perf_hpp__column_enable(PERF_HPP__PERIOD);
+
+	/* prepend overhead field for backward compatiblity.  */
+	list = &perf_hpp__format[PERF_HPP__OVERHEAD].sort_list;
+	if (list_empty(list))
+		list_add(list, &perf_hpp__sort_list);
 }
 
 void perf_hpp__column_register(struct perf_hpp_fmt *format)
@@ -294,29 +390,90 @@ void perf_hpp__column_register(struct perf_hpp_fmt *format)
 	list_add_tail(&format->list, &perf_hpp__list);
 }
 
+void perf_hpp__register_sort_field(struct perf_hpp_fmt *format)
+{
+	list_add_tail(&format->sort_list, &perf_hpp__sort_list);
+}
+
 void perf_hpp__column_enable(unsigned col)
 {
 	BUG_ON(col >= PERF_HPP__MAX_INDEX);
 	perf_hpp__column_register(&perf_hpp__format[col]);
 }
 
-int hist_entry__sort_snprintf(struct hist_entry *he, char *s, size_t size,
-			      struct hists *hists)
+void perf_hpp__setup_output_field(void)
 {
-	const char *sep = symbol_conf.field_sep;
-	struct sort_entry *se;
-	int ret = 0;
+	struct perf_hpp_fmt *fmt;
 
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		if (se->elide)
+	/* append sort keys to output field */
+	perf_hpp__for_each_sort_list(fmt) {
+		if (!list_empty(&fmt->list))
 			continue;
 
-		ret += scnprintf(s + ret, size - ret, "%s", sep ?: "  ");
-		ret += se->se_snprintf(he, s + ret, size - ret,
-				       hists__col_len(hists, se->se_width_idx));
+		/*
+		 * sort entry fields are dynamically created,
+		 * so they can share a same sort key even though
+		 * the list is empty.
+		 */
+		if (perf_hpp__is_sort_entry(fmt)) {
+			struct perf_hpp_fmt *pos;
+
+			perf_hpp__for_each_format(pos) {
+				if (perf_hpp__same_sort_entry(pos, fmt))
+					goto next;
+			}
+		}
+
+		perf_hpp__column_register(fmt);
+next:
+		continue;
 	}
+}
 
-	return ret;
+void perf_hpp__append_sort_keys(void)
+{
+	struct perf_hpp_fmt *fmt;
+
+	/* append output fields to sort keys */
+	perf_hpp__for_each_format(fmt) {
+		if (!list_empty(&fmt->sort_list))
+			continue;
+
+		/*
+		 * sort entry fields are dynamically created,
+		 * so they can share a same sort key even though
+		 * the list is empty.
+		 */
+		if (perf_hpp__is_sort_entry(fmt)) {
+			struct perf_hpp_fmt *pos;
+
+			perf_hpp__for_each_sort_list(pos) {
+				if (perf_hpp__same_sort_entry(pos, fmt))
+					goto next;
+			}
+		}
+
+		perf_hpp__register_sort_field(fmt);
+next:
+		continue;
+	}
+}
+
+void perf_hpp__reset_output_field(void)
+{
+	struct perf_hpp_fmt *fmt, *tmp;
+
+	/* reset output fields */
+	perf_hpp__for_each_format_safe(fmt, tmp) {
+		list_del_init(&fmt->list);
+		list_del_init(&fmt->sort_list);
+	}
+
+	/* reset sort keys */
+	perf_hpp__for_each_sort_list_safe(fmt, tmp) {
+		list_del_init(&fmt->list);
+		list_del_init(&fmt->sort_list);
+	}
 }
 
 /*
@@ -325,22 +482,23 @@ int hist_entry__sort_snprintf(struct hist_entry *he, char *s, size_t size,
 unsigned int hists__sort_list_width(struct hists *hists)
 {
 	struct perf_hpp_fmt *fmt;
-	struct sort_entry *se;
-	int i = 0, ret = 0;
+	int ret = 0;
+	bool first = true;
 	struct perf_hpp dummy_hpp;
 
 	perf_hpp__for_each_format(fmt) {
-		if (i)
+		if (perf_hpp__should_skip(fmt))
+			continue;
+
+		if (first)
+			first = false;
+		else
 			ret += 2;
 
 		ret += fmt->width(fmt, &dummy_hpp, hists_to_evsel(hists));
 	}
 
-	list_for_each_entry(se, &hist_entry__sort_list, list)
-		if (!se->elide)
-			ret += 2 + hists__col_len(hists, se->se_width_idx);
-
-	if (verbose) /* Addr + origin */
+	if (verbose && sort__has_sym) /* Addr + origin */
 		ret += 3 + BITS_PER_LONG / 4;
 
 	return ret;
diff --git a/tools/perf/ui/progress.h b/tools/perf/ui/progress.h
index 29ec8ef..f34f89e 100644
--- a/tools/perf/ui/progress.h
+++ b/tools/perf/ui/progress.h
@@ -1,7 +1,7 @@
 #ifndef _PERF_UI_PROGRESS_H_
 #define _PERF_UI_PROGRESS_H_ 1
 
-#include <../types.h>
+#include <linux/types.h>
 
 void ui_progress__finish(void);
  
diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index 5df5140..ba51fa8 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -86,8 +86,6 @@ void setup_browser(bool fallback_to_pager)
 		use_browser = 0;
 		if (fallback_to_pager)
 			setup_pager();
-
-		perf_hpp__init();
 		break;
 	}
 }
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index d59893e..9f57991 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -183,7 +183,8 @@ static size_t callchain__fprintf_graph(FILE *fp, struct rb_root *root,
 			 * the symbol. No need to print it otherwise it appears as
 			 * displayed twice.
 			 */
-			if (!i++ && sort__first_dimension == SORT_SYM)
+			if (!i++ && field_order == NULL &&
+			    sort_order && !prefixcmp(sort_order, "sym"))
 				continue;
 			if (!printed) {
 				ret += callchain__fprintf_left_margin(fp, left_margin);
@@ -296,18 +297,24 @@ static size_t hist_entry__callchain_fprintf(struct hist_entry *he,
 	int left_margin = 0;
 	u64 total_period = hists->stats.total_period;
 
-	if (sort__first_dimension == SORT_COMM) {
-		struct sort_entry *se = list_first_entry(&hist_entry__sort_list,
-							 typeof(*se), list);
-		left_margin = hists__col_len(hists, se->se_width_idx);
-		left_margin -= thread__comm_len(he->thread);
-	}
+	if (field_order == NULL && (sort_order == NULL ||
+				    !prefixcmp(sort_order, "comm"))) {
+		struct perf_hpp_fmt *fmt;
+
+		perf_hpp__for_each_format(fmt) {
+			if (!perf_hpp__is_sort_entry(fmt))
+				continue;
 
+			/* must be 'comm' sort entry */
+			left_margin = fmt->width(fmt, NULL, hists_to_evsel(hists));
+			left_margin -= thread__comm_len(he->thread);
+			break;
+		}
+	}
 	return hist_entry_callchain__fprintf(he, total_period, left_margin, fp);
 }
 
-static int hist_entry__period_snprintf(struct perf_hpp *hpp,
-				       struct hist_entry *he)
+static int hist_entry__snprintf(struct hist_entry *he, struct perf_hpp *hpp)
 {
 	const char *sep = symbol_conf.field_sep;
 	struct perf_hpp_fmt *fmt;
@@ -319,6 +326,9 @@ static int hist_entry__period_snprintf(struct perf_hpp *hpp,
 		return 0;
 
 	perf_hpp__for_each_format(fmt) {
+		if (perf_hpp__should_skip(fmt))
+			continue;
+
 		/*
 		 * If there's no field_sep, we still need
 		 * to display initial '  '.
@@ -353,8 +363,7 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 	if (size == 0 || size > bfsz)
 		size = hpp.size = bfsz;
 
-	ret = hist_entry__period_snprintf(&hpp, he);
-	hist_entry__sort_snprintf(he, bf + ret, size - ret, hists);
+	hist_entry__snprintf(he, &hpp);
 
 	ret = fprintf(fp, "%s\n", bf);
 
@@ -368,12 +377,10 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		      int max_cols, float min_pcnt, FILE *fp)
 {
 	struct perf_hpp_fmt *fmt;
-	struct sort_entry *se;
 	struct rb_node *nd;
 	size_t ret = 0;
 	unsigned int width;
 	const char *sep = symbol_conf.field_sep;
-	const char *col_width = symbol_conf.col_width_list_str;
 	int nr_rows = 0;
 	char bf[96];
 	struct perf_hpp dummy_hpp = {
@@ -386,12 +393,19 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 
 	init_rem_hits();
 
+
+	perf_hpp__for_each_format(fmt)
+		perf_hpp__reset_width(fmt, hists);
+
 	if (!show_header)
 		goto print_entries;
 
 	fprintf(fp, "# ");
 
 	perf_hpp__for_each_format(fmt) {
+		if (perf_hpp__should_skip(fmt))
+			continue;
+
 		if (!first)
 			fprintf(fp, "%s", sep ?: "  ");
 		else
@@ -401,28 +415,6 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		fprintf(fp, "%s", bf);
 	}
 
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		if (se->elide)
-			continue;
-		if (sep) {
-			fprintf(fp, "%c%s", *sep, se->se_header);
-			continue;
-		}
-		width = strlen(se->se_header);
-		if (symbol_conf.col_width_list_str) {
-			if (col_width) {
-				hists__set_col_len(hists, se->se_width_idx,
-						   atoi(col_width));
-				col_width = strchr(col_width, ',');
-				if (col_width)
-					++col_width;
-			}
-		}
-		if (!hists__new_col_len(hists, se->se_width_idx, width))
-			width = hists__col_len(hists, se->se_width_idx);
-		fprintf(fp, "  %*s", width, se->se_header);
-	}
-
 	fprintf(fp, "\n");
 	if (max_rows && ++nr_rows >= max_rows)
 		goto out;
@@ -437,6 +429,9 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 	perf_hpp__for_each_format(fmt) {
 		unsigned int i;
 
+		if (perf_hpp__should_skip(fmt))
+			continue;
+
 		if (!first)
 			fprintf(fp, "%s", sep ?: "  ");
 		else
@@ -447,20 +442,6 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 			fprintf(fp, ".");
 	}
 
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		unsigned int i;
-
-		if (se->elide)
-			continue;
-
-		fprintf(fp, "  ");
-		width = hists__col_len(hists, se->se_width_idx);
-		if (width == 0)
-			width = strlen(se->se_header);
-		for (i = 0; i < width; i++)
-			fprintf(fp, ".");
-	}
-
 	fprintf(fp, "\n");
 	if (max_rows && ++nr_rows >= max_rows)
 		goto out;
@@ -495,7 +476,7 @@ print_entries:
 			break;
 
 		if (h->ms.map == NULL && verbose > 1) {
-			__map_groups__fprintf_maps(&h->thread->mg,
+			__map_groups__fprintf_maps(h->thread->mg,
 						   MAP__FUNCTION, verbose, fp);
 			fprintf(fp, "%.10s end\n", graph_dotted_line);
 		}
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 56ad4f5..112d6e2 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -3,7 +3,7 @@
 
 #include <stdbool.h>
 #include <stdint.h>
-#include "types.h"
+#include <linux/types.h>
 #include "symbol.h"
 #include "hist.h"
 #include "sort.h"
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 6baabe6..a904a4c 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -25,7 +25,7 @@ int build_id__mark_dso_hit(struct perf_tool *tool __maybe_unused,
 	struct addr_location al;
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 	struct thread *thread = machine__findnew_thread(machine, sample->pid,
-							sample->pid);
+							sample->tid);
 
 	if (thread == NULL) {
 		pr_err("problem processing %d event, skipping it.\n",
diff --git a/tools/perf/util/build-id.h b/tools/perf/util/build-id.h
index 845ef86..ae39256 100644
--- a/tools/perf/util/build-id.h
+++ b/tools/perf/util/build-id.h
@@ -4,7 +4,7 @@
 #define BUILD_ID_SIZE 20
 
 #include "tool.h"
-#include "types.h"
+#include <linux/types.h>
 
 extern struct perf_tool build_id__mark_dso_hit_ops;
 struct dso;
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 8d9db45..9a42382 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -25,6 +25,84 @@
 
 __thread struct callchain_cursor callchain_cursor;
 
+int
+parse_callchain_report_opt(const char *arg)
+{
+	char *tok, *tok2;
+	char *endptr;
+
+	symbol_conf.use_callchain = true;
+
+	if (!arg)
+		return 0;
+
+	tok = strtok((char *)arg, ",");
+	if (!tok)
+		return -1;
+
+	/* get the output mode */
+	if (!strncmp(tok, "graph", strlen(arg))) {
+		callchain_param.mode = CHAIN_GRAPH_ABS;
+
+	} else if (!strncmp(tok, "flat", strlen(arg))) {
+		callchain_param.mode = CHAIN_FLAT;
+	} else if (!strncmp(tok, "fractal", strlen(arg))) {
+		callchain_param.mode = CHAIN_GRAPH_REL;
+	} else if (!strncmp(tok, "none", strlen(arg))) {
+		callchain_param.mode = CHAIN_NONE;
+		symbol_conf.use_callchain = false;
+		return 0;
+	} else {
+		return -1;
+	}
+
+	/* get the min percentage */
+	tok = strtok(NULL, ",");
+	if (!tok)
+		goto setup;
+
+	callchain_param.min_percent = strtod(tok, &endptr);
+	if (tok == endptr)
+		return -1;
+
+	/* get the print limit */
+	tok2 = strtok(NULL, ",");
+	if (!tok2)
+		goto setup;
+
+	if (tok2[0] != 'c') {
+		callchain_param.print_limit = strtoul(tok2, &endptr, 0);
+		tok2 = strtok(NULL, ",");
+		if (!tok2)
+			goto setup;
+	}
+
+	/* get the call chain order */
+	if (!strncmp(tok2, "caller", strlen("caller")))
+		callchain_param.order = ORDER_CALLER;
+	else if (!strncmp(tok2, "callee", strlen("callee")))
+		callchain_param.order = ORDER_CALLEE;
+	else
+		return -1;
+
+	/* Get the sort key */
+	tok2 = strtok(NULL, ",");
+	if (!tok2)
+		goto setup;
+	if (!strncmp(tok2, "function", strlen("function")))
+		callchain_param.key = CCKEY_FUNCTION;
+	else if (!strncmp(tok2, "address", strlen("address")))
+		callchain_param.key = CCKEY_ADDRESS;
+	else
+		return -1;
+setup:
+	if (callchain_register_param(&callchain_param) < 0) {
+		pr_err("Can't register callchain params\n");
+		return -1;
+	}
+	return 0;
+}
+
 static void
 rb_insert_callchain(struct rb_root *root, struct callchain_node *chain,
 		    enum chain_mode mode)
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 8ad97e9..bde2b0c 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -7,6 +7,13 @@
 #include "event.h"
 #include "symbol.h"
 
+enum perf_call_graph_mode {
+	CALLCHAIN_NONE,
+	CALLCHAIN_FP,
+	CALLCHAIN_DWARF,
+	CALLCHAIN_MAX
+};
+
 enum chain_mode {
 	CHAIN_NONE,
 	CHAIN_FLAT,
@@ -157,4 +164,5 @@ int sample__resolve_callchain(struct perf_sample *sample, struct symbol **parent
 int hist_entry__append_callchain(struct hist_entry *he, struct perf_sample *sample);
 
 extern const char record_callchain_help[];
+int parse_callchain_report_opt(const char *arg);
 #endif	/* __PERF_CALLCHAIN_H */
diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 3e0fdd3..24519e1 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -11,6 +11,7 @@
 #include "util.h"
 #include "cache.h"
 #include "exec_cmd.h"
+#include "util/hist.h"  /* perf_hist_config */
 
 #define MAXNAME (256)
 
@@ -355,6 +356,9 @@ int perf_default_config(const char *var, const char *value,
 	if (!prefixcmp(var, "core."))
 		return perf_default_core_config(var, value);
 
+	if (!prefixcmp(var, "hist."))
+		return perf_hist_config(var, value);
+
 	/* Add other config variables here. */
 	return 0;
 }
diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index 7fe4994..c4e55b7 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -317,3 +317,163 @@ int cpu_map__build_core_map(struct cpu_map *cpus, struct cpu_map **corep)
 {
 	return cpu_map__build_map(cpus, corep, cpu_map__get_core);
 }
+
+/* setup simple routines to easily access node numbers given a cpu number */
+static int get_max_num(char *path, int *max)
+{
+	size_t num;
+	char *buf;
+	int err = 0;
+
+	if (filename__read_str(path, &buf, &num))
+		return -1;
+
+	buf[num] = '\0';
+
+	/* start on the right, to find highest node num */
+	while (--num) {
+		if ((buf[num] == ',') || (buf[num] == '-')) {
+			num++;
+			break;
+		}
+	}
+	if (sscanf(&buf[num], "%d", max) < 1) {
+		err = -1;
+		goto out;
+	}
+
+	/* convert from 0-based to 1-based */
+	(*max)++;
+
+out:
+	free(buf);
+	return err;
+}
+
+/* Determine highest possible cpu in the system for sparse allocation */
+static void set_max_cpu_num(void)
+{
+	const char *mnt;
+	char path[PATH_MAX];
+	int ret = -1;
+
+	/* set up default */
+	max_cpu_num = 4096;
+
+	mnt = sysfs__mountpoint();
+	if (!mnt)
+		goto out;
+
+	/* get the highest possible cpu number for a sparse allocation */
+	ret = snprintf(path, PATH_MAX, "%s/devices/system/cpu/possible", mnt);
+	if (ret == PATH_MAX) {
+		pr_err("sysfs path crossed PATH_MAX(%d) size\n", PATH_MAX);
+		goto out;
+	}
+
+	ret = get_max_num(path, &max_cpu_num);
+
+out:
+	if (ret)
+		pr_err("Failed to read max cpus, using default of %d\n", max_cpu_num);
+}
+
+/* Determine highest possible node in the system for sparse allocation */
+static void set_max_node_num(void)
+{
+	const char *mnt;
+	char path[PATH_MAX];
+	int ret = -1;
+
+	/* set up default */
+	max_node_num = 8;
+
+	mnt = sysfs__mountpoint();
+	if (!mnt)
+		goto out;
+
+	/* get the highest possible cpu number for a sparse allocation */
+	ret = snprintf(path, PATH_MAX, "%s/devices/system/node/possible", mnt);
+	if (ret == PATH_MAX) {
+		pr_err("sysfs path crossed PATH_MAX(%d) size\n", PATH_MAX);
+		goto out;
+	}
+
+	ret = get_max_num(path, &max_node_num);
+
+out:
+	if (ret)
+		pr_err("Failed to read max nodes, using default of %d\n", max_node_num);
+}
+
+static int init_cpunode_map(void)
+{
+	int i;
+
+	set_max_cpu_num();
+	set_max_node_num();
+
+	cpunode_map = calloc(max_cpu_num, sizeof(int));
+	if (!cpunode_map) {
+		pr_err("%s: calloc failed\n", __func__);
+		return -1;
+	}
+
+	for (i = 0; i < max_cpu_num; i++)
+		cpunode_map[i] = -1;
+
+	return 0;
+}
+
+int cpu__setup_cpunode_map(void)
+{
+	struct dirent *dent1, *dent2;
+	DIR *dir1, *dir2;
+	unsigned int cpu, mem;
+	char buf[PATH_MAX];
+	char path[PATH_MAX];
+	const char *mnt;
+	int n;
+
+	/* initialize globals */
+	if (init_cpunode_map())
+		return -1;
+
+	mnt = sysfs__mountpoint();
+	if (!mnt)
+		return 0;
+
+	n = snprintf(path, PATH_MAX, "%s/devices/system/node", mnt);
+	if (n == PATH_MAX) {
+		pr_err("sysfs path crossed PATH_MAX(%d) size\n", PATH_MAX);
+		return -1;
+	}
+
+	dir1 = opendir(path);
+	if (!dir1)
+		return 0;
+
+	/* walk tree and setup map */
+	while ((dent1 = readdir(dir1)) != NULL) {
+		if (dent1->d_type != DT_DIR || sscanf(dent1->d_name, "node%u", &mem) < 1)
+			continue;
+
+		n = snprintf(buf, PATH_MAX, "%s/%s", path, dent1->d_name);
+		if (n == PATH_MAX) {
+			pr_err("sysfs path crossed PATH_MAX(%d) size\n", PATH_MAX);
+			continue;
+		}
+
+		dir2 = opendir(buf);
+		if (!dir2)
+			continue;
+		while ((dent2 = readdir(dir2)) != NULL) {
+			if (dent2->d_type != DT_LNK || sscanf(dent2->d_name, "cpu%u", &cpu) < 1)
+				continue;
+			cpunode_map[cpu] = mem;
+		}
+		closedir(dir2);
+	}
+	closedir(dir1);
+	return 0;
+}
diff --git a/tools/perf/util/cpumap.h b/tools/perf/util/cpumap.h
index b123bb9..61a6548 100644
--- a/tools/perf/util/cpumap.h
+++ b/tools/perf/util/cpumap.h
@@ -4,6 +4,9 @@
 #include <stdio.h>
 #include <stdbool.h>
 
+#include "perf.h"
+#include "util/debug.h"
+
 struct cpu_map {
 	int nr;
 	int map[];
@@ -46,4 +49,36 @@ static inline bool cpu_map__empty(const struct cpu_map *map)
 	return map ? map->map[0] == -1 : true;
 }
 
+int max_cpu_num;
+int max_node_num;
+int *cpunode_map;
+
+int cpu__setup_cpunode_map(void);
+
+static inline int cpu__max_node(void)
+{
+	if (unlikely(!max_node_num))
+		pr_debug("cpu_map not initialized\n");
+
+	return max_node_num;
+}
+
+static inline int cpu__max_cpu(void)
+{
+	if (unlikely(!max_cpu_num))
+		pr_debug("cpu_map not initialized\n");
+
+	return max_cpu_num;
+}
+
+static inline int cpu__get_node(int cpu)
+{
+	if (unlikely(cpunode_map == NULL)) {
+		pr_debug("cpu_map not initialized\n");
+		return -1;
+	}
+
+	return cpunode_map[cpu];
+}
+
 #endif /* __PERF_CPUMAP_H */
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index ab06f1c..38efe95 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -4,7 +4,7 @@
 #include <linux/types.h>
 #include <linux/rbtree.h>
 #include <stdbool.h>
-#include "types.h"
+#include <linux/types.h>
 #include "map.h"
 #include "build-id.h"
 
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 9d12aa6..65795b8 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -699,7 +699,7 @@ void thread__find_addr_map(struct thread *thread,
 			   enum map_type type, u64 addr,
 			   struct addr_location *al)
 {
-	struct map_groups *mg = &thread->mg;
+	struct map_groups *mg = thread->mg;
 	bool load_map = false;
 
 	al->machine = machine;
@@ -788,7 +788,7 @@ int perf_event__preprocess_sample(const union perf_event *event,
 {
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 	struct thread *thread = machine__findnew_thread(machine, sample->pid,
-							sample->pid);
+							sample->tid);
 
 	if (thread == NULL)
 		return -1;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 38457d4..d970232 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -112,6 +112,30 @@ struct sample_read {
 	};
 };
 
+struct ip_callchain {
+	u64 nr;
+	u64 ips[0];
+};
+
+struct branch_flags {
+	u64 mispred:1;
+	u64 predicted:1;
+	u64 in_tx:1;
+	u64 abort:1;
+	u64 reserved:60;
+};
+
+struct branch_entry {
+	u64			from;
+	u64			to;
+	struct branch_flags	flags;
+};
+
+struct branch_stack {
+	u64			nr;
+	struct branch_entry	entries[0];
+};
+
 struct perf_sample {
 	u64 ip;
 	u32 pid, tid;
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 0c9926c..a52e9a5 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -5,12 +5,12 @@
 #include <stdbool.h>
 #include <stddef.h>
 #include <linux/perf_event.h>
-#include "types.h"
+#include <linux/types.h>
 #include "xyarray.h"
 #include "cgroup.h"
 #include "hist.h"
 #include "symbol.h"
- 
+
 struct perf_counts_values {
 	union {
 		struct {
@@ -91,6 +91,11 @@ struct perf_evsel {
 	char			*group_name;
 };
 
+union u64_swap {
+	u64 val64;
+	u32 val32[2];
+};
+
 #define hists_to_evsel(h) container_of(h, struct perf_evsel, hists)
 
 struct cpu_map;
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index a2d047b..d08cfe4 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -4,10 +4,10 @@
 #include <linux/perf_event.h>
 #include <sys/types.h>
 #include <stdbool.h>
-#include "types.h"
+#include <linux/bitmap.h>
+#include <linux/types.h>
 #include "event.h"
 
-#include <linux/bitmap.h>
 
 enum {
 	HEADER_RESERVED		= 0,	/* always cleared */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index f38590d..b262b44 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -225,14 +225,18 @@ static void he_stat__decay(struct he_stat *he_stat)
 static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
 {
 	u64 prev_period = he->stat.period;
+	u64 diff;
 
 	if (prev_period == 0)
 		return true;
 
 	he_stat__decay(&he->stat);
 
+	diff = prev_period - he->stat.period;
+
+	hists->stats.total_period -= diff;
 	if (!he->filtered)
-		hists->stats.total_period -= prev_period - he->stat.period;
+		hists->stats.total_non_filtered_period -= diff;
 
 	return he->stat.period == 0;
 }
@@ -259,8 +263,11 @@ void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel)
 			if (sort__need_collapse)
 				rb_erase(&n->rb_node_in, &hists->entries_collapsed);
 
-			hist_entry__free(n);
 			--hists->nr_entries;
+			if (!n->filtered)
+				--hists->nr_non_filtered_entries;
+
+			hist_entry__free(n);
 		}
 	}
 }
@@ -317,15 +324,6 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 	return he;
 }
 
-void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
-{
-	if (!h->filtered) {
-		hists__calc_col_len(hists, h);
-		++hists->nr_entries;
-		hists->stats.total_period += h->stat.period;
-	}
-}
-
 static u8 symbol__parent_filter(const struct symbol *parent)
 {
 	if (symbol_conf.exclude_other && parent == NULL)
@@ -391,7 +389,6 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	if (!he)
 		return NULL;
 
-	hists->nr_entries++;
 	rb_link_node(&he->rb_node_in, parent, p);
 	rb_insert_color(&he->rb_node_in, hists->entries_in);
 out:
@@ -435,11 +432,14 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 int64_t
 hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	struct sort_entry *se;
+	struct perf_hpp_fmt *fmt;
 	int64_t cmp = 0;
 
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		cmp = se->se_cmp(left, right);
+	perf_hpp__for_each_sort_list(fmt) {
+		if (perf_hpp__should_skip(fmt))
+			continue;
+
+		cmp = fmt->cmp(left, right);
 		if (cmp)
 			break;
 	}
@@ -450,15 +450,14 @@ hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
 int64_t
 hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
 {
-	struct sort_entry *se;
+	struct perf_hpp_fmt *fmt;
 	int64_t cmp = 0;
 
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		int64_t (*f)(struct hist_entry *, struct hist_entry *);
-
-		f = se->se_collapse ?: se->se_cmp;
+	perf_hpp__for_each_sort_list(fmt) {
+		if (perf_hpp__should_skip(fmt))
+			continue;
 
-		cmp = f(left, right);
+		cmp = fmt->collapse(left, right);
 		if (cmp)
 			break;
 	}
@@ -571,64 +570,50 @@ void hists__collapse_resort(struct hists *hists, struct ui_progress *prog)
 	}
 }
 
-/*
- * reverse the map, sort on period.
- */
-
-static int period_cmp(u64 period_a, u64 period_b)
+static int hist_entry__sort(struct hist_entry *a, struct hist_entry *b)
 {
-	if (period_a > period_b)
-		return 1;
-	if (period_a < period_b)
-		return -1;
-	return 0;
-}
-
-static int hist_entry__sort_on_period(struct hist_entry *a,
-				      struct hist_entry *b)
-{
-	int ret;
-	int i, nr_members;
-	struct perf_evsel *evsel;
-	struct hist_entry *pair;
-	u64 *periods_a, *periods_b;
+	struct perf_hpp_fmt *fmt;
+	int64_t cmp = 0;
 
-	ret = period_cmp(a->stat.period, b->stat.period);
-	if (ret || !symbol_conf.event_group)
-		return ret;
+	perf_hpp__for_each_sort_list(fmt) {
+		if (perf_hpp__should_skip(fmt))
+			continue;
 
-	evsel = hists_to_evsel(a->hists);
-	nr_members = evsel->nr_members;
-	if (nr_members <= 1)
-		return ret;
+		cmp = fmt->sort(a, b);
+		if (cmp)
+			break;
+	}
 
-	periods_a = zalloc(sizeof(periods_a) * nr_members);
-	periods_b = zalloc(sizeof(periods_b) * nr_members);
+	return cmp;
+}
 
-	if (!periods_a || !periods_b)
-		goto out;
+static void hists__reset_filter_stats(struct hists *hists)
+{
+	hists->nr_non_filtered_entries = 0;
+	hists->stats.total_non_filtered_period = 0;
+}
 
-	list_for_each_entry(pair, &a->pairs.head, pairs.node) {
-		evsel = hists_to_evsel(pair->hists);
-		periods_a[perf_evsel__group_idx(evsel)] = pair->stat.period;
-	}
+void hists__reset_stats(struct hists *hists)
+{
+	hists->nr_entries = 0;
+	hists->stats.total_period = 0;
 
-	list_for_each_entry(pair, &b->pairs.head, pairs.node) {
-		evsel = hists_to_evsel(pair->hists);
-		periods_b[perf_evsel__group_idx(evsel)] = pair->stat.period;
-	}
+	hists__reset_filter_stats(hists);
+}
 
-	for (i = 1; i < nr_members; i++) {
-		ret = period_cmp(periods_a[i], periods_b[i]);
-		if (ret)
-			break;
-	}
+static void hists__inc_filter_stats(struct hists *hists, struct hist_entry *h)
+{
+	hists->nr_non_filtered_entries++;
+	hists->stats.total_non_filtered_period += h->stat.period;
+}
 
-out:
-	free(periods_a);
-	free(periods_b);
+void hists__inc_stats(struct hists *hists, struct hist_entry *h)
+{
+	if (!h->filtered)
+		hists__inc_filter_stats(hists, h);
 
-	return ret;
+	hists->nr_entries++;
+	hists->stats.total_period += h->stat.period;
 }
 
 static void __hists__insert_output_entry(struct rb_root *entries,
@@ -647,7 +632,7 @@ static void __hists__insert_output_entry(struct rb_root *entries,
 		parent = *p;
 		iter = rb_entry(parent, struct hist_entry, rb_node);
 
-		if (hist_entry__sort_on_period(he, iter) > 0)
+		if (hist_entry__sort(he, iter) > 0)
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
@@ -674,8 +659,7 @@ void hists__output_resort(struct hists *hists)
 	next = rb_first(root);
 	hists->entries = RB_ROOT;
 
-	hists->nr_entries = 0;
-	hists->stats.total_period = 0;
+	hists__reset_stats(hists);
 	hists__reset_col_len(hists);
 
 	while (next) {
@@ -683,7 +667,10 @@ void hists__output_resort(struct hists *hists)
 		next = rb_next(&n->rb_node_in);
 
 		__hists__insert_output_entry(&hists->entries, n, min_callchain_hits);
-		hists__inc_nr_entries(hists, n);
+		hists__inc_stats(hists, n);
+
+		if (!n->filtered)
+			hists__calc_col_len(hists, n);
 	}
 }
 
@@ -694,13 +681,13 @@ static void hists__remove_entry_filter(struct hists *hists, struct hist_entry *h
 	if (h->filtered)
 		return;
 
-	++hists->nr_entries;
-	if (h->ms.unfolded)
-		hists->nr_entries += h->nr_rows;
+	/* force fold unfiltered entry for simplicity */
+	h->ms.unfolded = false;
 	h->row_offset = 0;
-	hists->stats.total_period += h->stat.period;
-	hists->stats.nr_events[PERF_RECORD_SAMPLE] += h->stat.nr_events;
 
+	hists->stats.nr_non_filtered_samples += h->stat.nr_events;
+
+	hists__inc_filter_stats(hists, h);
 	hists__calc_col_len(hists, h);
 }
 
@@ -721,8 +708,9 @@ void hists__filter_by_dso(struct hists *hists)
 {
 	struct rb_node *nd;
 
-	hists->nr_entries = hists->stats.total_period = 0;
-	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
+	hists->stats.nr_non_filtered_samples = 0;
+
+	hists__reset_filter_stats(hists);
 	hists__reset_col_len(hists);
 
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
@@ -754,8 +742,9 @@ void hists__filter_by_thread(struct hists *hists)
 {
 	struct rb_node *nd;
 
-	hists->nr_entries = hists->stats.total_period = 0;
-	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
+	hists->stats.nr_non_filtered_samples = 0;
+
+	hists__reset_filter_stats(hists);
 	hists__reset_col_len(hists);
 
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
@@ -785,8 +774,9 @@ void hists__filter_by_symbol(struct hists *hists)
 {
 	struct rb_node *nd;
 
-	hists->nr_entries = hists->stats.total_period = 0;
-	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
+	hists->stats.nr_non_filtered_samples = 0;
+
+	hists__reset_filter_stats(hists);
 	hists__reset_col_len(hists);
 
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
@@ -847,7 +837,7 @@ static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
 		he->hists = hists;
 		rb_link_node(&he->rb_node_in, parent, p);
 		rb_insert_color(&he->rb_node_in, root);
-		hists__inc_nr_entries(hists, he);
+		hists__inc_stats(hists, he);
 		he->dummy = true;
 	}
 out:
@@ -931,3 +921,30 @@ int hists__link(struct hists *leader, struct hists *other)
 
 	return 0;
 }
+
+u64 hists__total_period(struct hists *hists)
+{
+	return symbol_conf.filter_relative ? hists->stats.total_non_filtered_period :
+		hists->stats.total_period;
+}
+
+int parse_filter_percentage(const struct option *opt __maybe_unused,
+			    const char *arg, int unset __maybe_unused)
+{
+	if (!strcmp(arg, "relative"))
+		symbol_conf.filter_relative = true;
+	else if (!strcmp(arg, "absolute"))
+		symbol_conf.filter_relative = false;
+	else
+		return -1;
+
+	return 0;
+}
+
+int perf_hist_config(const char *var, const char *value)
+{
+	if (!strcmp(var, "hist.percentage"))
+		return parse_filter_percentage(NULL, value, 0);
+
+	return 0;
+}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 1f1f513..a8418d1 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -37,9 +37,11 @@ enum hist_filter {
  */
 struct events_stats {
 	u64 total_period;
+	u64 total_non_filtered_period;
 	u64 total_lost;
 	u64 total_invalid_chains;
 	u32 nr_events[PERF_RECORD_HEADER_MAX];
+	u32 nr_non_filtered_samples;
 	u32 nr_lost_warned;
 	u32 nr_unknown_events;
 	u32 nr_invalid_chains;
@@ -83,6 +85,7 @@ struct hists {
 	struct rb_root		entries;
 	struct rb_root		entries_collapsed;
 	u64			nr_entries;
+	u64			nr_non_filtered_entries;
 	const struct thread	*thread_filter;
 	const struct dso	*dso_filter;
 	const char		*uid_filter_str;
@@ -112,7 +115,9 @@ void hists__collapse_resort(struct hists *hists, struct ui_progress *prog);
 void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel);
 void hists__output_recalc_col_len(struct hists *hists, int max_rows);
 
-void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h);
+u64 hists__total_period(struct hists *hists);
+void hists__reset_stats(struct hists *hists);
+void hists__inc_stats(struct hists *hists, struct hist_entry *h);
 void hists__inc_nr_events(struct hists *hists, u32 type);
 void events_stats__inc(struct events_stats *stats, u32 type);
 size_t events_stats__fprintf(struct events_stats *stats, FILE *fp);
@@ -124,6 +129,12 @@ void hists__filter_by_dso(struct hists *hists);
 void hists__filter_by_thread(struct hists *hists);
 void hists__filter_by_symbol(struct hists *hists);
 
+static inline bool hists__has_filter(struct hists *hists)
+{
+	return hists->thread_filter || hists->dso_filter ||
+		hists->symbol_filter_str;
+}
+
 u16 hists__col_len(struct hists *hists, enum hist_column col);
 void hists__set_col_len(struct hists *hists, enum hist_column col, u16 len);
 bool hists__new_col_len(struct hists *hists, enum hist_column col, u16 len);
@@ -149,15 +160,29 @@ struct perf_hpp_fmt {
 		     struct hist_entry *he);
 	int (*entry)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
 		     struct hist_entry *he);
+	int64_t (*cmp)(struct hist_entry *a, struct hist_entry *b);
+	int64_t (*collapse)(struct hist_entry *a, struct hist_entry *b);
+	int64_t (*sort)(struct hist_entry *a, struct hist_entry *b);
 
 	struct list_head list;
+	struct list_head sort_list;
 };
 
 extern struct list_head perf_hpp__list;
+extern struct list_head perf_hpp__sort_list;
 
 #define perf_hpp__for_each_format(format) \
 	list_for_each_entry(format, &perf_hpp__list, list)
 
+#define perf_hpp__for_each_format_safe(format, tmp)	\
+	list_for_each_entry_safe(format, tmp, &perf_hpp__list, list)
+
+#define perf_hpp__for_each_sort_list(format) \
+	list_for_each_entry(format, &perf_hpp__sort_list, sort_list)
+
+#define perf_hpp__for_each_sort_list_safe(format, tmp)	\
+	list_for_each_entry_safe(format, tmp, &perf_hpp__sort_list, sort_list)
+
 extern struct perf_hpp_fmt perf_hpp__format[];
 
 enum {
@@ -176,14 +201,23 @@ enum {
 void perf_hpp__init(void);
 void perf_hpp__column_register(struct perf_hpp_fmt *format);
 void perf_hpp__column_enable(unsigned col);
+void perf_hpp__register_sort_field(struct perf_hpp_fmt *format);
+void perf_hpp__setup_output_field(void);
+void perf_hpp__reset_output_field(void);
+void perf_hpp__append_sort_keys(void);
+
+bool perf_hpp__is_sort_entry(struct perf_hpp_fmt *format);
+bool perf_hpp__same_sort_entry(struct perf_hpp_fmt *a, struct perf_hpp_fmt *b);
+bool perf_hpp__should_skip(struct perf_hpp_fmt *format);
+void perf_hpp__reset_width(struct perf_hpp_fmt *fmt, struct hists *hists);
 
 typedef u64 (*hpp_field_fn)(struct hist_entry *he);
 typedef int (*hpp_callback_fn)(struct perf_hpp *hpp, bool front);
 typedef int (*hpp_snprint_fn)(struct perf_hpp *hpp, const char *fmt, ...);
 
 int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
-	       hpp_field_fn get_field, hpp_callback_fn callback,
-	       const char *fmt, hpp_snprint_fn print_fn, bool fmt_percent);
+	       hpp_field_fn get_field, const char *fmt,
+	       hpp_snprint_fn print_fn, bool fmt_percent);
 
 static inline void advance_hpp(struct perf_hpp *hpp, int inc)
 {
@@ -250,4 +284,10 @@ static inline int script_browse(const char *script_opt __maybe_unused)
 #endif
 
 unsigned int hists__sort_list_width(struct hists *hists);
+
+struct option;
+int parse_filter_percentage(const struct option *opt __maybe_unused,
+			    const char *arg, int unset __maybe_unused);
+int perf_hist_config(const char *var, const char *value);
+
 #endif	/* __PERF_HIST_H */
diff --git a/tools/perf/util/include/linux/bitmap.h b/tools/perf/util/include/linux/bitmap.h
index bb162e4..01ffd12 100644
--- a/tools/perf/util/include/linux/bitmap.h
+++ b/tools/perf/util/include/linux/bitmap.h
@@ -4,6 +4,9 @@
 #include <string.h>
 #include <linux/bitops.h>
 
+#define DECLARE_BITMAP(name,bits) \
+	unsigned long name[BITS_TO_LONGS(bits)]
+
 int __bitmap_weight(const unsigned long *bitmap, int bits);
 void __bitmap_or(unsigned long *dst, const unsigned long *bitmap1,
 		 const unsigned long *bitmap2, int bits);
diff --git a/tools/perf/util/include/linux/export.h b/tools/perf/util/include/linux/export.h
deleted file mode 100644
index b43e2dc..0000000
--- a/tools/perf/util/include/linux/export.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef PERF_LINUX_MODULE_H
-#define PERF_LINUX_MODULE_H
-
-#define EXPORT_SYMBOL(name)
-
-#endif
diff --git a/tools/perf/util/include/linux/list.h b/tools/perf/util/include/linux/list.h
index bfe0a2a..76ddbc7 100644
--- a/tools/perf/util/include/linux/list.h
+++ b/tools/perf/util/include/linux/list.h
@@ -1,4 +1,5 @@
 #include <linux/kernel.h>
+#include <linux/types.h>
 
 #include "../../../../include/linux/list.h"
 
diff --git a/tools/perf/util/include/linux/types.h b/tools/perf/util/include/linux/types.h
deleted file mode 100644
index eb46478..0000000
--- a/tools/perf/util/include/linux/types.h
+++ /dev/null
@@ -1,29 +0,0 @@
-#ifndef _PERF_LINUX_TYPES_H_
-#define _PERF_LINUX_TYPES_H_
-
-#include <asm/types.h>
-
-#ifndef __bitwise
-#define __bitwise
-#endif
-
-#ifndef __le32
-typedef __u32 __bitwise __le32;
-#endif
-
-#define DECLARE_BITMAP(name,bits) \
-	unsigned long name[BITS_TO_LONGS(bits)]
-
-struct list_head {
-	struct list_head *next, *prev;
-};
-
-struct hlist_head {
-	struct hlist_node *first;
-};
-
-struct hlist_node {
-	struct hlist_node *next, **pprev;
-};
-
-#endif
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 27c2a5e..7409ac8 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -316,6 +316,17 @@ static struct thread *__machine__findnew_thread(struct machine *machine,
 		rb_link_node(&th->rb_node, parent, p);
 		rb_insert_color(&th->rb_node, &machine->threads);
 		machine->last_match = th;
+
+		/*
+		 * We have to initialize map_groups separately
+		 * after rb tree is updated.
+		 *
+		 * The reason is that we call machine__findnew_thread
+		 * within thread__init_map_groups to find the thread
+		 * leader and that would screwed the rb tree.
+		 */
+		if (thread__init_map_groups(th, machine))
+			return NULL;
 	}
 
 	return th;
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 39cd2d0..8ccbb32 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -32,6 +32,93 @@ static inline int is_no_dso_memory(const char *filename)
 	       !strcmp(filename, "[heap]");
 }
 
+static inline int is_android_lib(const char *filename)
+{
+	return !strncmp(filename, "/data/app-lib", 13) ||
+	       !strncmp(filename, "/system/lib", 11);
+}
+
+static inline bool replace_android_lib(const char *filename, char *newfilename)
+{
+	const char *libname;
+	char *app_abi;
+	size_t app_abi_length, new_length;
+	size_t lib_length = 0;
+
+	libname  = strrchr(filename, '/');
+	if (libname)
+		lib_length = strlen(libname);
+
+	app_abi = getenv("APP_ABI");
+	if (!app_abi)
+		return false;
+
+	app_abi_length = strlen(app_abi);
+
+	if (!strncmp(filename, "/data/app-lib", 13)) {
+		char *apk_path;
+
+		if (!app_abi_length)
+			return false;
+
+		new_length = 7 + app_abi_length + lib_length;
+
+		apk_path = getenv("APK_PATH");
+		if (apk_path) {
+			new_length += strlen(apk_path) + 1;
+			if (new_length > PATH_MAX)
+				return false;
+			snprintf(newfilename, new_length,
+				 "%s/libs/%s/%s", apk_path, app_abi, libname);
+		} else {
+			if (new_length > PATH_MAX)
+				return false;
+			snprintf(newfilename, new_length,
+				 "libs/%s/%s", app_abi, libname);
+		}
+		return true;
+	}
+
+	if (!strncmp(filename, "/system/lib/", 11)) {
+		char *ndk, *app;
+		const char *arch;
+		size_t ndk_length;
+		size_t app_length;
+
+		ndk = getenv("NDK_ROOT");
+		app = getenv("APP_PLATFORM");
+
+		if (!(ndk && app))
+			return false;
+
+		ndk_length = strlen(ndk);
+		app_length = strlen(app);
+
+		if (!(ndk_length && app_length && app_abi_length))
+			return false;
+
+		arch = !strncmp(app_abi, "arm", 3) ? "arm" :
+		       !strncmp(app_abi, "mips", 4) ? "mips" :
+		       !strncmp(app_abi, "x86", 3) ? "x86" : NULL;
+
+		if (!arch)
+			return false;
+
+		new_length = 27 + ndk_length +
+			     app_length + lib_length
+			   + strlen(arch);
+
+		if (new_length > PATH_MAX)
+			return false;
+		snprintf(newfilename, new_length,
+			"%s/platforms/%s/arch-%s/usr/lib/%s",
+			ndk, app, arch, libname);
+
+		return true;
+	}
+	return false;
+}
+
 void map__init(struct map *map, enum map_type type,
 	       u64 start, u64 end, u64 pgoff, struct dso *dso)
 {
@@ -59,8 +146,9 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 	if (map != NULL) {
 		char newfilename[PATH_MAX];
 		struct dso *dso;
-		int anon, no_dso, vdso;
+		int anon, no_dso, vdso, android;
 
+		android = is_android_lib(filename);
 		anon = is_anon_memory(filename);
 		vdso = is_vdso_map(filename);
 		no_dso = is_no_dso_memory(filename);
@@ -75,6 +163,11 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 			filename = newfilename;
 		}
 
+		if (android) {
+			if (replace_android_lib(filename, newfilename))
+				filename = newfilename;
+		}
+
 		if (vdso) {
 			pgoff = 0;
 			dso = vdso__dso_findnew(dsos__list);
@@ -323,6 +416,7 @@ void map_groups__init(struct map_groups *mg)
 		INIT_LIST_HEAD(&mg->removed_maps[i]);
 	}
 	mg->machine = NULL;
+	mg->refcnt = 1;
 }
 
 static void maps__delete(struct rb_root *maps)
@@ -358,6 +452,28 @@ void map_groups__exit(struct map_groups *mg)
 	}
 }
 
+struct map_groups *map_groups__new(void)
+{
+	struct map_groups *mg = malloc(sizeof(*mg));
+
+	if (mg != NULL)
+		map_groups__init(mg);
+
+	return mg;
+}
+
+void map_groups__delete(struct map_groups *mg)
+{
+	map_groups__exit(mg);
+	free(mg);
+}
+
+void map_groups__put(struct map_groups *mg)
+{
+	if (--mg->refcnt == 0)
+		map_groups__delete(mg);
+}
+
 void map_groups__flush(struct map_groups *mg)
 {
 	int type;
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index f00f058..ae2d451 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -6,7 +6,7 @@
 #include <linux/rbtree.h>
 #include <stdio.h>
 #include <stdbool.h>
-#include "types.h"
+#include <linux/types.h>
 
 enum map_type {
 	MAP__FUNCTION = 0,
@@ -59,8 +59,20 @@ struct map_groups {
 	struct rb_root	 maps[MAP__NR_TYPES];
 	struct list_head removed_maps[MAP__NR_TYPES];
 	struct machine	 *machine;
+	int		 refcnt;
 };
 
+struct map_groups *map_groups__new(void);
+void map_groups__delete(struct map_groups *mg);
+
+static inline struct map_groups *map_groups__get(struct map_groups *mg)
+{
+	++mg->refcnt;
+	return mg;
+}
+
+void map_groups__put(struct map_groups *mg);
+
 static inline struct kmap *map__kmap(struct map *map)
 {
 	return (struct kmap *)(map + 1);
diff --git a/tools/perf/util/pager.c b/tools/perf/util/pager.c
index 3322b84..31ee02d 100644
--- a/tools/perf/util/pager.c
+++ b/tools/perf/util/pager.c
@@ -57,13 +57,13 @@ void setup_pager(void)
 	}
 	if (!pager)
 		pager = getenv("PAGER");
-	if (!pager) {
-		if (!access("/usr/bin/pager", X_OK))
-			pager = "/usr/bin/pager";
-	}
+	if (!(pager || access("/usr/bin/pager", X_OK)))
+		pager = "/usr/bin/pager";
+	if (!(pager || access("/usr/bin/less", X_OK)))
+		pager = "/usr/bin/less";
 	if (!pager)
-		pager = "less";
-	else if (!*pager || !strcmp(pager, "cat"))
+		pager = "cat";
+	if (!*pager || !strcmp(pager, "cat"))
 		return;
 
 	spawned_pager = 1; /* means we are emitting to terminal */
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index f1cb4c4..df094b4 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -6,9 +6,8 @@
 
 #include <linux/list.h>
 #include <stdbool.h>
-#include "types.h"
+#include <linux/types.h>
 #include <linux/perf_event.h>
-#include "types.h"
 
 struct list_head;
 struct perf_evsel;
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 4eb67ec..0bc87ba 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -9,7 +9,7 @@
 
 #include <linux/compiler.h>
 #include <linux/list.h>
-#include "types.h"
+#include <linux/types.h>
 #include "util.h"
 #include "parse-events.h"
 #include "parse-events-bison.h"
@@ -299,6 +299,18 @@ PE_PREFIX_MEM PE_VALUE sep_dc
 }
 
 event_legacy_tracepoint:
+PE_NAME '-' PE_NAME ':' PE_NAME
+{
+	struct parse_events_evlist *data = _data;
+	struct list_head *list;
+	char sys_name[128];
+	snprintf(&sys_name, 128, "%s-%s", $1, $3);
+
+	ALLOC_LIST(list);
+	ABORT_ON(parse_events_add_tracepoint(list, &data->idx, &sys_name, $5));
+	$$ = list;
+}
+|
 PE_NAME ':' PE_NAME
 {
 	struct parse_events_evlist *data = _data;
diff --git a/tools/perf/util/perf_regs.h b/tools/perf/util/perf_regs.h
index d6e8b6a..79c78f7 100644
--- a/tools/perf/util/perf_regs.h
+++ b/tools/perf/util/perf_regs.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_REGS_H
 #define __PERF_REGS_H
 
-#include "types.h"
+#include <linux/types.h>
 #include "event.h"
 
 #ifdef HAVE_PERF_REGS_SUPPORT
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 00a7dcb..7a811eb 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -284,17 +284,17 @@ static int pmu_aliases(const char *name, struct list_head *head)
 static int pmu_alias_terms(struct perf_pmu_alias *alias,
 			   struct list_head *terms)
 {
-	struct parse_events_term *term, *clone;
+	struct parse_events_term *term, *cloned;
 	LIST_HEAD(list);
 	int ret;
 
 	list_for_each_entry(term, &alias->terms, list) {
-		ret = parse_events_term__clone(&clone, term);
+		ret = parse_events_term__clone(&cloned, term);
 		if (ret) {
 			parse_events__free_terms(&list);
 			return ret;
 		}
-		list_add_tail(&clone->list, &list);
+		list_add_tail(&cloned->list, &list);
 	}
 	list_splice(&list, terms);
 	return 0;
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 8b64125..c14a543 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -1,7 +1,7 @@
 #ifndef __PMU_H
 #define __PMU_H
 
-#include <linux/bitops.h>
+#include <linux/bitmap.h>
 #include <linux/perf_event.h>
 #include <stdbool.h>
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 55960f2..64a186e 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1625,13 +1625,14 @@ out_delete_map:
 void perf_session__fprintf_info(struct perf_session *session, FILE *fp,
 				bool full)
 {
-	int fd = perf_data_file__fd(session->file);
 	struct stat st;
-	int ret;
+	int fd, ret;
 
 	if (session == NULL || fp == NULL)
 		return;
 
+	fd = perf_data_file__fd(session->file);
+
 	ret = fstat(fd, &st);
 	if (ret == -1)
 		return;
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 635cd8f..901b9be 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -2,12 +2,18 @@
 #include "hist.h"
 #include "comm.h"
 #include "symbol.h"
+#include "evsel.h"
 
 regex_t		parent_regex;
 const char	default_parent_pattern[] = "^sys_|^do_page_fault";
 const char	*parent_pattern = default_parent_pattern;
 const char	default_sort_order[] = "comm,dso,symbol";
-const char	*sort_order = default_sort_order;
+const char	default_branch_sort_order[] = "comm,dso_from,symbol_from,dso_to,symbol_to";
+const char	default_mem_sort_order[] = "local_weight,mem,sym,dso,symbol_daddr,dso_daddr,snoop,tlb,locked";
+const char	default_top_sort_order[] = "dso,symbol";
+const char	default_diff_sort_order[] = "dso,symbol";
+const char	*sort_order;
+const char	*field_order;
 regex_t		ignore_callees_regex;
 int		have_ignore_callees = 0;
 int		sort__need_collapse = 0;
@@ -16,9 +22,6 @@ int		sort__has_sym = 0;
 int		sort__has_dso = 0;
 enum sort_mode	sort__mode = SORT_MODE__NORMAL;
 
-enum sort_type	sort__first_dimension;
-
-LIST_HEAD(hist_entry__sort_list);
 
 static int repsep_snprintf(char *bf, size_t size, const char *fmt, ...)
 {
@@ -93,6 +96,12 @@ sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
 	return comm__str(right->comm) - comm__str(left->comm);
 }
 
+static int64_t
+sort__comm_sort(struct hist_entry *left, struct hist_entry *right)
+{
+	return strcmp(comm__str(right->comm), comm__str(left->comm));
+}
+
 static int hist_entry__comm_snprintf(struct hist_entry *he, char *bf,
 				     size_t size, unsigned int width)
 {
@@ -103,6 +112,7 @@ struct sort_entry sort_comm = {
 	.se_header	= "Command",
 	.se_cmp		= sort__comm_cmp,
 	.se_collapse	= sort__comm_collapse,
+	.se_sort	= sort__comm_sort,
 	.se_snprintf	= hist_entry__comm_snprintf,
 	.se_width_idx	= HISTC_COMM,
 };
@@ -116,7 +126,7 @@ static int64_t _sort__dso_cmp(struct map *map_l, struct map *map_r)
 	const char *dso_name_l, *dso_name_r;
 
 	if (!dso_l || !dso_r)
-		return cmp_null(dso_l, dso_r);
+		return cmp_null(dso_r, dso_l);
 
 	if (verbose) {
 		dso_name_l = dso_l->long_name;
@@ -132,7 +142,7 @@ static int64_t _sort__dso_cmp(struct map *map_l, struct map *map_r)
 static int64_t
 sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	return _sort__dso_cmp(left->ms.map, right->ms.map);
+	return _sort__dso_cmp(right->ms.map, left->ms.map);
 }
 
 static int _hist_entry__dso_snprintf(struct map *map, char *bf,
@@ -204,6 +214,15 @@ sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 	return _sort__sym_cmp(left->ms.sym, right->ms.sym);
 }
 
+static int64_t
+sort__sym_sort(struct hist_entry *left, struct hist_entry *right)
+{
+	if (!left->ms.sym || !right->ms.sym)
+		return cmp_null(left->ms.sym, right->ms.sym);
+
+	return strcmp(right->ms.sym->name, left->ms.sym->name);
+}
+
 static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
 				     u64 ip, char level, char *bf, size_t size,
 				     unsigned int width)
@@ -250,6 +269,7 @@ static int hist_entry__sym_snprintf(struct hist_entry *he, char *bf,
 struct sort_entry sort_sym = {
 	.se_header	= "Symbol",
 	.se_cmp		= sort__sym_cmp,
+	.se_sort	= sort__sym_sort,
 	.se_snprintf	= hist_entry__sym_snprintf,
 	.se_width_idx	= HISTC_SYMBOL,
 };
@@ -277,7 +297,7 @@ sort__srcline_cmp(struct hist_entry *left, struct hist_entry *right)
 					    map__rip_2objdump(map, right->ip));
 		}
 	}
-	return strcmp(left->srcline, right->srcline);
+	return strcmp(right->srcline, left->srcline);
 }
 
 static int hist_entry__srcline_snprintf(struct hist_entry *he, char *bf,
@@ -305,7 +325,7 @@ sort__parent_cmp(struct hist_entry *left, struct hist_entry *right)
 	if (!sym_l || !sym_r)
 		return cmp_null(sym_l, sym_r);
 
-	return strcmp(sym_l->name, sym_r->name);
+	return strcmp(sym_r->name, sym_l->name);
 }
 
 static int hist_entry__parent_snprintf(struct hist_entry *he, char *bf,
@@ -1027,19 +1047,192 @@ static struct sort_dimension memory_sort_dimensions[] = {
 
 #undef DIM
 
-static void __sort_dimension__add(struct sort_dimension *sd, enum sort_type idx)
+struct hpp_dimension {
+	const char		*name;
+	struct perf_hpp_fmt	*fmt;
+	int			taken;
+};
+
+#define DIM(d, n) { .name = n, .fmt = &perf_hpp__format[d], }
+
+static struct hpp_dimension hpp_sort_dimensions[] = {
+	DIM(PERF_HPP__OVERHEAD, "overhead"),
+	DIM(PERF_HPP__OVERHEAD_SYS, "overhead_sys"),
+	DIM(PERF_HPP__OVERHEAD_US, "overhead_us"),
+	DIM(PERF_HPP__OVERHEAD_GUEST_SYS, "overhead_guest_sys"),
+	DIM(PERF_HPP__OVERHEAD_GUEST_US, "overhead_guest_us"),
+	DIM(PERF_HPP__SAMPLES, "sample"),
+	DIM(PERF_HPP__PERIOD, "period"),
+};
+
+#undef DIM
+
+struct hpp_sort_entry {
+	struct perf_hpp_fmt hpp;
+	struct sort_entry *se;
+};
+
+bool perf_hpp__same_sort_entry(struct perf_hpp_fmt *a, struct perf_hpp_fmt *b)
 {
-	if (sd->taken)
+	struct hpp_sort_entry *hse_a;
+	struct hpp_sort_entry *hse_b;
+
+	if (!perf_hpp__is_sort_entry(a) || !perf_hpp__is_sort_entry(b))
+		return false;
+
+	hse_a = container_of(a, struct hpp_sort_entry, hpp);
+	hse_b = container_of(b, struct hpp_sort_entry, hpp);
+
+	return hse_a->se == hse_b->se;
+}
+
+void perf_hpp__reset_width(struct perf_hpp_fmt *fmt, struct hists *hists)
+{
+	struct hpp_sort_entry *hse;
+
+	if (!perf_hpp__is_sort_entry(fmt))
 		return;
 
+	hse = container_of(fmt, struct hpp_sort_entry, hpp);
+	hists__new_col_len(hists, hse->se->se_width_idx,
+			   strlen(hse->se->se_header));
+}
+
+static int __sort__hpp_header(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
+			      struct perf_evsel *evsel)
+{
+	struct hpp_sort_entry *hse;
+	size_t len;
+
+	hse = container_of(fmt, struct hpp_sort_entry, hpp);
+	len = hists__col_len(&evsel->hists, hse->se->se_width_idx);
+
+	return scnprintf(hpp->buf, hpp->size, "%*s", len, hse->se->se_header);
+}
+
+static int __sort__hpp_width(struct perf_hpp_fmt *fmt,
+			     struct perf_hpp *hpp __maybe_unused,
+			     struct perf_evsel *evsel)
+{
+	struct hpp_sort_entry *hse;
+
+	hse = container_of(fmt, struct hpp_sort_entry, hpp);
+
+	return hists__col_len(&evsel->hists, hse->se->se_width_idx);
+}
+
+static int __sort__hpp_entry(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
+			     struct hist_entry *he)
+{
+	struct hpp_sort_entry *hse;
+	size_t len;
+
+	hse = container_of(fmt, struct hpp_sort_entry, hpp);
+	len = hists__col_len(he->hists, hse->se->se_width_idx);
+
+	return hse->se->se_snprintf(he, hpp->buf, hpp->size, len);
+}
+
+static struct hpp_sort_entry *
+__sort_dimension__alloc_hpp(struct sort_dimension *sd)
+{
+	struct hpp_sort_entry *hse;
+
+	hse = malloc(sizeof(*hse));
+	if (hse == NULL) {
+		pr_err("Memory allocation failed\n");
+		return NULL;
+	}
+
+	hse->se = sd->entry;
+	hse->hpp.header = __sort__hpp_header;
+	hse->hpp.width = __sort__hpp_width;
+	hse->hpp.entry = __sort__hpp_entry;
+	hse->hpp.color = NULL;
+
+	hse->hpp.cmp = sd->entry->se_cmp;
+	hse->hpp.collapse = sd->entry->se_collapse ? : sd->entry->se_cmp;
+	hse->hpp.sort = sd->entry->se_sort ? : hse->hpp.collapse;
+
+	INIT_LIST_HEAD(&hse->hpp.list);
+	INIT_LIST_HEAD(&hse->hpp.sort_list);
+
+	return hse;
+}
+
+bool perf_hpp__is_sort_entry(struct perf_hpp_fmt *format)
+{
+	return format->header == __sort__hpp_header;
+}
+
+static int __sort_dimension__add_hpp_sort(struct sort_dimension *sd)
+{
+	struct hpp_sort_entry *hse = __sort_dimension__alloc_hpp(sd);
+
+	if (hse == NULL)
+		return -1;
+
+	perf_hpp__register_sort_field(&hse->hpp);
+	return 0;
+}
+
+static int __sort_dimension__add_hpp_output(struct sort_dimension *sd)
+{
+	struct hpp_sort_entry *hse = __sort_dimension__alloc_hpp(sd);
+
+	if (hse == NULL)
+		return -1;
+
+	perf_hpp__column_register(&hse->hpp);
+	return 0;
+}
+
+static int __sort_dimension__add(struct sort_dimension *sd)
+{
+	if (sd->taken)
+		return 0;
+
+	if (__sort_dimension__add_hpp_sort(sd) < 0)
+		return -1;
+
 	if (sd->entry->se_collapse)
 		sort__need_collapse = 1;
 
-	if (list_empty(&hist_entry__sort_list))
-		sort__first_dimension = idx;
+	sd->taken = 1;
+
+	return 0;
+}
+
+static int __hpp_dimension__add(struct hpp_dimension *hd)
+{
+	if (!hd->taken) {
+		hd->taken = 1;
+
+		perf_hpp__register_sort_field(hd->fmt);
+	}
+	return 0;
+}
+
+static int __sort_dimension__add_output(struct sort_dimension *sd)
+{
+	if (sd->taken)
+		return 0;
+
+	if (__sort_dimension__add_hpp_output(sd) < 0)
+		return -1;
 
-	list_add_tail(&sd->entry->list, &hist_entry__sort_list);
 	sd->taken = 1;
+	return 0;
+}
+
+static int __hpp_dimension__add_output(struct hpp_dimension *hd)
+{
+	if (!hd->taken) {
+		hd->taken = 1;
+
+		perf_hpp__column_register(hd->fmt);
+	}
+	return 0;
 }
 
 int sort_dimension__add(const char *tok)
@@ -1068,8 +1261,16 @@ int sort_dimension__add(const char *tok)
 			sort__has_dso = 1;
 		}
 
-		__sort_dimension__add(sd, i);
-		return 0;
+		return __sort_dimension__add(sd);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(hpp_sort_dimensions); i++) {
+		struct hpp_dimension *hd = &hpp_sort_dimensions[i];
+
+		if (strncasecmp(tok, hd->name, strlen(tok)))
+			continue;
+
+		return __hpp_dimension__add(hd);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(bstack_sort_dimensions); i++) {
@@ -1084,7 +1285,7 @@ int sort_dimension__add(const char *tok)
 		if (sd->entry == &sort_sym_from || sd->entry == &sort_sym_to)
 			sort__has_sym = 1;
 
-		__sort_dimension__add(sd, i + __SORT_BRANCH_STACK);
+		__sort_dimension__add(sd);
 		return 0;
 	}
 
@@ -1100,18 +1301,47 @@ int sort_dimension__add(const char *tok)
 		if (sd->entry == &sort_mem_daddr_sym)
 			sort__has_sym = 1;
 
-		__sort_dimension__add(sd, i + __SORT_MEMORY_MODE);
+		__sort_dimension__add(sd);
 		return 0;
 	}
 
 	return -ESRCH;
 }
 
-int setup_sorting(void)
+static const char *get_default_sort_order(void)
 {
-	char *tmp, *tok, *str = strdup(sort_order);
+	const char *default_sort_orders[] = {
+		default_sort_order,
+		default_branch_sort_order,
+		default_mem_sort_order,
+		default_top_sort_order,
+		default_diff_sort_order,
+	};
+
+	BUG_ON(sort__mode >= ARRAY_SIZE(default_sort_orders));
+
+	return default_sort_orders[sort__mode];
+}
+
+static int __setup_sorting(void)
+{
+	char *tmp, *tok, *str;
+	const char *sort_keys = sort_order;
 	int ret = 0;
 
+	if (sort_keys == NULL) {
+		if (field_order) {
+			/*
+			 * If user specified field order but no sort order,
+			 * we'll honor it and not add default sort orders.
+			 */
+			return 0;
+		}
+
+		sort_keys = get_default_sort_order();
+	}
+
+	str = strdup(sort_keys);
 	if (str == NULL) {
 		error("Not enough memory to setup sort keys");
 		return -ENOMEM;
@@ -1133,6 +1363,17 @@ int setup_sorting(void)
 	return ret;
 }
 
+bool perf_hpp__should_skip(struct perf_hpp_fmt *format)
+{
+	if (perf_hpp__is_sort_entry(format)) {
+		struct hpp_sort_entry *hse;
+
+		hse = container_of(format, struct hpp_sort_entry, hpp);
+		return hse->se->elide;
+	}
+	return false;
+}
+
 static void sort_entry__setup_elide(struct sort_entry *se,
 				    struct strlist *list,
 				    const char *list_name, FILE *fp)
@@ -1147,7 +1388,8 @@ static void sort_entry__setup_elide(struct sort_entry *se,
 
 void sort__setup_elide(FILE *output)
 {
-	struct sort_entry *se;
+	struct perf_hpp_fmt *fmt;
+	struct hpp_sort_entry *hse;
 
 	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
 				"dso", output);
@@ -1188,11 +1430,157 @@ void sort__setup_elide(FILE *output)
 	 * It makes no sense to elide all of sort entries.
 	 * Just revert them to show up again.
 	 */
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		if (!se->elide)
+	perf_hpp__for_each_format(fmt) {
+		if (!perf_hpp__is_sort_entry(fmt))
+			continue;
+
+		hse = container_of(fmt, struct hpp_sort_entry, hpp);
+		if (!hse->se->elide)
 			return;
 	}
 
-	list_for_each_entry(se, &hist_entry__sort_list, list)
-		se->elide = false;
+	perf_hpp__for_each_format(fmt) {
+		if (!perf_hpp__is_sort_entry(fmt))
+			continue;
+
+		hse = container_of(fmt, struct hpp_sort_entry, hpp);
+		hse->se->elide = false;
+	}
+}
+
+static int output_field_add(char *tok)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(common_sort_dimensions); i++) {
+		struct sort_dimension *sd = &common_sort_dimensions[i];
+
+		if (strncasecmp(tok, sd->name, strlen(tok)))
+			continue;
+
+		return __sort_dimension__add_output(sd);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(hpp_sort_dimensions); i++) {
+		struct hpp_dimension *hd = &hpp_sort_dimensions[i];
+
+		if (strncasecmp(tok, hd->name, strlen(tok)))
+			continue;
+
+		return __hpp_dimension__add_output(hd);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(bstack_sort_dimensions); i++) {
+		struct sort_dimension *sd = &bstack_sort_dimensions[i];
+
+		if (strncasecmp(tok, sd->name, strlen(tok)))
+			continue;
+
+		return __sort_dimension__add_output(sd);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(memory_sort_dimensions); i++) {
+		struct sort_dimension *sd = &memory_sort_dimensions[i];
+
+		if (strncasecmp(tok, sd->name, strlen(tok)))
+			continue;
+
+		return __sort_dimension__add_output(sd);
+	}
+
+	return -ESRCH;
+}
+
+static void reset_dimensions(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(common_sort_dimensions); i++)
+		common_sort_dimensions[i].taken = 0;
+
+	for (i = 0; i < ARRAY_SIZE(hpp_sort_dimensions); i++)
+		hpp_sort_dimensions[i].taken = 0;
+
+	for (i = 0; i < ARRAY_SIZE(bstack_sort_dimensions); i++)
+		bstack_sort_dimensions[i].taken = 0;
+
+	for (i = 0; i < ARRAY_SIZE(memory_sort_dimensions); i++)
+		memory_sort_dimensions[i].taken = 0;
+}
+
+static int __setup_output_field(void)
+{
+	char *tmp, *tok, *str;
+	int ret = 0;
+
+	if (field_order == NULL)
+		return 0;
+
+	reset_dimensions();
+
+	str = strdup(field_order);
+	if (str == NULL) {
+		error("Not enough memory to setup output fields");
+		return -ENOMEM;
+	}
+
+	for (tok = strtok_r(str, ", ", &tmp);
+			tok; tok = strtok_r(NULL, ", ", &tmp)) {
+		ret = output_field_add(tok);
+		if (ret == -EINVAL) {
+			error("Invalid --fields key: `%s'", tok);
+			break;
+		} else if (ret == -ESRCH) {
+			error("Unknown --fields key: `%s'", tok);
+			break;
+		}
+	}
+
+	free(str);
+	return ret;
+}
+
+int setup_sorting(void)
+{
+	int err;
+
+	err = __setup_sorting();
+	if (err < 0)
+		return err;
+
+	if (parent_pattern != default_parent_pattern) {
+		err = sort_dimension__add("parent");
+		if (err < 0)
+			return err;
+	}
+
+	reset_dimensions();
+
+	/*
+	 * perf diff doesn't use default hpp output fields.
+	 */
+	if (sort__mode != SORT_MODE__DIFF)
+		perf_hpp__init();
+
+	err = __setup_output_field();
+	if (err < 0)
+		return err;
+
+	/* copy sort keys to output fields */
+	perf_hpp__setup_output_field();
+	/* and then copy output fields to sort keys */
+	perf_hpp__append_sort_keys();
+
+	return 0;
+}
+
+void reset_output_field(void)
+{
+	sort__need_collapse = 0;
+	sort__has_parent = 0;
+	sort__has_sym = 0;
+	sort__has_dso = 0;
+
+	reset_dimensions();
+	perf_hpp__reset_output_field();
 }
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 43e5ff4..5f38d92 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -25,6 +25,7 @@
 
 extern regex_t parent_regex;
 extern const char *sort_order;
+extern const char *field_order;
 extern const char default_parent_pattern[];
 extern const char *parent_pattern;
 extern const char default_sort_order[];
@@ -133,6 +134,8 @@ enum sort_mode {
 	SORT_MODE__NORMAL,
 	SORT_MODE__BRANCH,
 	SORT_MODE__MEMORY,
+	SORT_MODE__TOP,
+	SORT_MODE__DIFF,
 };
 
 enum sort_type {
@@ -179,6 +182,7 @@ struct sort_entry {
 
 	int64_t (*se_cmp)(struct hist_entry *, struct hist_entry *);
 	int64_t (*se_collapse)(struct hist_entry *, struct hist_entry *);
+	int64_t	(*se_sort)(struct hist_entry *, struct hist_entry *);
 	int	(*se_snprintf)(struct hist_entry *he, char *bf, size_t size,
 			       unsigned int width);
 	u8	se_width_idx;
@@ -189,6 +193,8 @@ extern struct sort_entry sort_thread;
 extern struct list_head hist_entry__sort_list;
 
 int setup_sorting(void);
+int setup_output_field(void);
+void reset_output_field(void);
 extern int sort_dimension__add(const char *);
 void sort__setup_elide(FILE *fp);
 
diff --git a/tools/perf/util/stat.h b/tools/perf/util/stat.h
index ae8ccd7..5667fc3 100644
--- a/tools/perf/util/stat.h
+++ b/tools/perf/util/stat.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_STATS_H
 #define __PERF_STATS_H
 
-#include "types.h"
+#include <linux/types.h>
 
 struct stats
 {
diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index 43262b8..6a0a13d 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -17,7 +17,7 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <string.h>
-#include <linux/bitops.h>
+#include <linux/bitmap.h>
 
 #include "perf.h"
 #include "svghelper.h"
diff --git a/tools/perf/util/svghelper.h b/tools/perf/util/svghelper.h
index f7b4d6e..e3aff53 100644
--- a/tools/perf/util/svghelper.h
+++ b/tools/perf/util/svghelper.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_SVGHELPER_H
 #define __PERF_SVGHELPER_H
 
-#include "types.h"
+#include <linux/types.h>
 
 extern void open_svg(const char *filename, int cpus, int rows, u64 start, u64 end);
 extern void svg_box(int Yslot, u64 start, u64 end, const char *type);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 501e4e7..33ede53 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -12,6 +12,7 @@
 #include <byteswap.h>
 #include <libgen.h>
 #include "build-id.h"
+#include "event.h"
 
 #ifdef HAVE_LIBELF_SUPPORT
 #include <libelf.h>
@@ -115,7 +116,8 @@ struct symbol_conf {
 			annotate_asm_raw,
 			annotate_src,
 			event_group,
-			demangle;
+			demangle,
+			filter_relative;
 	const char	*vmlinux_name,
 			*kallsyms_name,
 			*source_prefix,
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 3ce0498..2fde0d5 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -8,6 +8,22 @@
 #include "debug.h"
 #include "comm.h"
 
+int thread__init_map_groups(struct thread *thread, struct machine *machine)
+{
+	struct thread *leader;
+	pid_t pid = thread->pid_;
+
+	if (pid == thread->tid) {
+		thread->mg = map_groups__new();
+	} else {
+		leader = machine__findnew_thread(machine, pid, pid);
+		if (leader)
+			thread->mg = map_groups__get(leader->mg);
+	}
+
+	return thread->mg ? 0 : -1;
+}
+
 struct thread *thread__new(pid_t pid, pid_t tid)
 {
 	char *comm_str;
@@ -15,7 +31,6 @@ struct thread *thread__new(pid_t pid, pid_t tid)
 	struct thread *thread = zalloc(sizeof(*thread));
 
 	if (thread != NULL) {
-		map_groups__init(&thread->mg);
 		thread->pid_ = pid;
 		thread->tid = tid;
 		thread->ppid = -1;
@@ -45,7 +60,8 @@ void thread__delete(struct thread *thread)
 {
 	struct comm *comm, *tmp;
 
-	map_groups__exit(&thread->mg);
+	map_groups__put(thread->mg);
+	thread->mg = NULL;
 	list_for_each_entry_safe(comm, tmp, &thread->comm_list, list) {
 		list_del(&comm->list);
 		comm__free(comm);
@@ -111,18 +127,35 @@ int thread__comm_len(struct thread *thread)
 size_t thread__fprintf(struct thread *thread, FILE *fp)
 {
 	return fprintf(fp, "Thread %d %s\n", thread->tid, thread__comm_str(thread)) +
-	       map_groups__fprintf(&thread->mg, verbose, fp);
+	       map_groups__fprintf(thread->mg, verbose, fp);
 }
 
 void thread__insert_map(struct thread *thread, struct map *map)
 {
-	map_groups__fixup_overlappings(&thread->mg, map, verbose, stderr);
-	map_groups__insert(&thread->mg, map);
+	map_groups__fixup_overlappings(thread->mg, map, verbose, stderr);
+	map_groups__insert(thread->mg, map);
+}
+
+static int thread__clone_map_groups(struct thread *thread,
+				    struct thread *parent)
+{
+	int i;
+
+	/* This is new thread, we share map groups for process. */
+	if (thread->pid_ == parent->pid_)
+		return 0;
+
+	/* But this one is new process, copy maps. */
+	for (i = 0; i < MAP__NR_TYPES; ++i)
+		if (map_groups__clone(thread->mg, parent->mg, i) < 0)
+			return -ENOMEM;
+
+	return 0;
 }
 
 int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp)
 {
-	int i, err;
+	int err;
 
 	if (parent->comm_set) {
 		const char *comm = thread__comm_str(parent);
@@ -134,13 +167,8 @@ int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp)
 		thread->comm_set = true;
 	}
 
-	for (i = 0; i < MAP__NR_TYPES; ++i)
-		if (map_groups__clone(&thread->mg, &parent->mg, i) < 0)
-			return -ENOMEM;
-
 	thread->ppid = parent->tid;
-
-	return 0;
+	return thread__clone_map_groups(thread, parent);
 }
 
 void thread__find_cpumode_addr_location(struct thread *thread,
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 9b29f08..3c0c272 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -13,7 +13,7 @@ struct thread {
 		struct rb_node	 rb_node;
 		struct list_head node;
 	};
-	struct map_groups	mg;
+	struct map_groups	*mg;
 	pid_t			pid_; /* Not all tools update this */
 	pid_t			tid;
 	pid_t			ppid;
@@ -30,6 +30,7 @@ struct machine;
 struct comm;
 
 struct thread *thread__new(pid_t pid, pid_t tid);
+int thread__init_map_groups(struct thread *thread, struct machine *machine);
 void thread__delete(struct thread *thread);
 static inline void thread__exited(struct thread *thread)
 {
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index dab14d0..f92c37a 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -2,7 +2,7 @@
 #define __PERF_TOP_H 1
 
 #include "tool.h"
-#include "types.h"
+#include <linux/types.h>
 #include <stddef.h>
 #include <stdbool.h>
 #include <termios.h>
diff --git a/tools/perf/util/types.h b/tools/perf/util/types.h
deleted file mode 100644
index c51fa6b..0000000
--- a/tools/perf/util/types.h
+++ /dev/null
@@ -1,24 +0,0 @@
-#ifndef __PERF_TYPES_H
-#define __PERF_TYPES_H
-
-#include <stdint.h>
-
-/*
- * We define u64 as uint64_t for every architecture
- * so that we can print it with "%"PRIx64 without getting warnings.
- */
-typedef uint64_t	   u64;
-typedef int64_t		   s64;
-typedef unsigned int	   u32;
-typedef signed int	   s32;
-typedef unsigned short	   u16;
-typedef signed short	   s16;
-typedef unsigned char	   u8;
-typedef signed char	   s8;
-
-union u64_swap {
-	u64 val64;
-	u32 val32[2];
-};
-
-#endif /* __PERF_TYPES_H */
diff --git a/tools/perf/util/unwind-libdw.c b/tools/perf/util/unwind-libdw.c
index 67db73e..5ec80a5 100644
--- a/tools/perf/util/unwind-libdw.c
+++ b/tools/perf/util/unwind-libdw.c
@@ -7,7 +7,7 @@
 #include "unwind-libdw.h"
 #include "machine.h"
 #include "thread.h"
-#include "types.h"
+#include <linux/types.h>
 #include "event.h"
 #include "perf_regs.h"
 
diff --git a/tools/perf/util/unwind.h b/tools/perf/util/unwind.h
index b031316..f030612 100644
--- a/tools/perf/util/unwind.h
+++ b/tools/perf/util/unwind.h
@@ -1,7 +1,7 @@
 #ifndef __UNWIND_H
 #define __UNWIND_H
 
-#include "types.h"
+#include <linux/types.h>
 #include "event.h"
 #include "symbol.h"
 
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 9f66549..7fff6be 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -166,6 +166,8 @@ static ssize_t ion(bool is_read, int fd, void *buf, size_t n)
 		ssize_t ret = is_read ? read(fd, buf, left) :
 					write(fd, buf, left);
 
+		if (ret < 0 && errno == EINTR)
+			continue;
 		if (ret <= 0)
 			return ret;
 
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 6995d66..b03da44 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -69,7 +69,7 @@
 #include <sys/ioctl.h>
 #include <inttypes.h>
 #include <linux/magic.h>
-#include "types.h"
+#include <linux/types.h>
 #include <sys/ttydefaults.h>
 #include <api/fs/debugfs.h>
 #include <termios.h>
diff --git a/tools/perf/util/values.h b/tools/perf/util/values.h
index 2fa967e..b21a80c 100644
--- a/tools/perf/util/values.h
+++ b/tools/perf/util/values.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_VALUES_H
 #define __PERF_VALUES_H
 
-#include "types.h"
+#include <linux/types.h>
 
 struct perf_read_values {
 	int threads;
diff --git a/tools/virtio/Makefile b/tools/virtio/Makefile
index 3187c62..9325f46 100644
--- a/tools/virtio/Makefile
+++ b/tools/virtio/Makefile
@@ -3,7 +3,7 @@ test: virtio_test vringh_test
 virtio_test: virtio_ring.o virtio_test.o
 vringh_test: vringh_test.o vringh.o virtio_ring.o
 
-CFLAGS += -g -O2 -Wall -I. -I ../../usr/include/ -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE
+CFLAGS += -g -O2 -Wall -I. -I../include/ -I ../../usr/include/ -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE
 vpath %.c ../../drivers/virtio ../../drivers/vhost
 mod:
 	${MAKE} -C `pwd`/../.. M=`pwd`/vhost_test
diff --git a/tools/virtio/linux/kernel.h b/tools/virtio/linux/kernel.h
index fba7059..1e8ce69 100644
--- a/tools/virtio/linux/kernel.h
+++ b/tools/virtio/linux/kernel.h
@@ -38,13 +38,6 @@ struct page {
 
 #define __printf(a,b) __attribute__((format(printf,a,b)))
 
-typedef enum {
-	GFP_KERNEL,
-	GFP_ATOMIC,
-	__GFP_HIGHMEM,
-	__GFP_HIGH
-} gfp_t;
-
 #define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))
 
 extern void *__kmalloc_fake, *__kfree_ignore_start, *__kfree_ignore_end;
diff --git a/tools/virtio/linux/types.h b/tools/virtio/linux/types.h
deleted file mode 100644
index f8ebb9a..0000000
--- a/tools/virtio/linux/types.h
+++ /dev/null
@@ -1,28 +0,0 @@
-#ifndef TYPES_H
-#define TYPES_H
-#include <stdint.h>
-
-#define __force
-#define __user
-#define __must_check
-#define __cold
-
-typedef uint64_t u64;
-typedef int64_t s64;
-typedef uint32_t u32;
-typedef int32_t s32;
-typedef uint16_t u16;
-typedef int16_t s16;
-typedef uint8_t u8;
-typedef int8_t s8;
-
-typedef uint64_t __u64;
-typedef int64_t __s64;
-typedef uint32_t __u32;
-typedef int32_t __s32;
-typedef uint16_t __u16;
-typedef int16_t __s16;
-typedef uint8_t __u8;
-typedef int8_t __s8;
-
-#endif /* TYPES_H */
