Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbaCaKfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 06:35:38 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:61592 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbaCaKf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 06:35:29 -0400
Date: Mon, 31 Mar 2014 12:35:23 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf changes for v3.15
Message-ID: <20140331103523.GA5154@gmail.com>
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

   # HEAD: 538592ff0b008237ae88f5ce5fb1247127dc3ce5 Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core

Main changes:

  Kernel side changes:

      * Add SNB/IVB/HSW client uncore memory controller support (Stephane Eranian)

      * Fix various x86/P4 PMU driver bugs (Don Zickus)

  Tooling, user visible changes:

      * Add several futex 'perf bench' microbenchmarks (Davidlohr Bueso)

      * Speed up thread map generation (Don Zickus)

      * Introduce 'perf kvm --list-cmds' command line option for use by
        scripts (Ramkumar Ramachandra)

      * Print the evsel name in the annotate stdio output, prep to fix support
        outputting annotation for multiple events, not just for the first one
        (Arnaldo Carvalho de Melo)

      * Allow setting preferred callchain method in .perfconfig (Jiri Olsa)

      * Show in what binaries/modules 'perf probe's are set (Masami Hiramatsu)

      * Support distro-style debuginfo for uprobe in 'perf probe' (Masami Hiramatsu)

  Tooling, internal changes and fixes:

      * Use tid in mmap/mmap2 events to find maps (Don Zickus)

      * Record the reason for filtering an address_location (Namhyung Kim)

      * Apply all filters to an addr_location (Namhyung Kim)

      * Merge al->filtered with hist_entry->filtered in report/hists (Namhyung Kim)

      * Fix memory leak when synthesizing thread records (Namhyung Kim)

      * Use ui__has_annotation() in 'report' (Namhyung Kim)

      * hists browser refactorings to reuse code accross UIs (Namhyung Kim)

      * Add support for the new DWARF unwinder library in elfutils (Jiri Olsa)

      * Fix build race in the generation of bison files (Jiri Olsa)

      * Further streamline the feature detection display, trimming it a bit to
        show just the libraries detected, using VF=1 gets a more verbose output,
        showing the less interesting feature checks as well (Jiri Olsa).

      * Check compatible symtab type before loading dso (Namhyung Kim)

      * Check return value of filename__read_debuglink() (Stephane Eranian)

      * Move some hashing and fs related code from tools/perf/util/
        to tools/lib/ so that it can be used by more tools/ living
        utilities (Borislav Petkov)

      * Prepare DWARF unwinding code for using an elfutils alternative
        unwinding library (Jiri Olsa)

      * Fix DWARF unwind max_stack processing (Jiri Olsa)

      * Add dwarf unwind 'perf test' entry (Jiri Olsa)

      * 'perf probe' improvements including memory leak fixes,
        sharing the intlist class with other tools, uprobes/kprobes
        code sharing and use of ref_reloc_sym (Masami Hiramatsu)

      * Shorten sample symbol resolving by adding cpumode to
        struct addr_location (Arnaldo Carvalho de Melo)

      * Fix synthesizing mmaps for threads (Don Zickus)

      * Fix invalid output on event group stdio report  (Namhyung Kim)

      * Fixup header alignment in 'perf sched latency' output (Ramkumar Ramachandra)

      * Fix off-by-one error in 'perf timechart record' argv handling (Ramkumar Ramachandra)

  Tooling, cleanups:

      * Remove unused thread__find_map function (Jiri Olsa)

      * Remove unused simple_strtoul() function (Ramkumar Ramachandra)

  Tooling, documentation updates:

      * Update function names in debug messages (Ramkumar Ramachandra)

      * Update some code references in design.txt (Ramkumar Ramachandra)

      * Clarify load-latency information in the 'perf mem' docs (Andi Kleen)

      * Clarify x86 register naming in 'perf probe' docs (Andi Kleen)

Thanks,

	Ingo

------------------>
Andi Kleen (2):
      perf mem: Clarify load-latency in documentation
      perf probe: Clarify x86 register naming for perf probe

Arnaldo Carvalho de Melo (8):
      perf report: Use al->cpumode where applicable
      perf tools: Shorten sample symbol resolving function signature
      perf tools: Shorten sample symbol resolving function signature
      perf report: Remove some needless container_of usage
      perf symbols: No need to export dso__first_symbol
      perf tools: Warn the user about how to enable libunwind support
      perf symbols: Introduce thread__find_cpumode_addr_location
      perf annotate: Print the evsel name in the stdio output

Borislav Petkov (3):
      perf tools: Move fs.* to lib/api/fs/
      perf tools: Move hash.h header
      perf tools: Drop prefetch.h

Davidlohr Bueso (3):
      perf bench: Add futex-hash microbenchmark
      perf bench: Add futex-wake microbenchmark
      perf bench: Add futex-requeue microbenchmark

Don Zickus (6):
      perf/x86/p4: Fix counter corruption when using lots of perf groups
      perf/x86/p4: Block PMIs on init to prevent a stream of unkown NMIs
      perf tools: Fix synthesizing mmaps for threads
      perf session: Change header.misc dump from decimal to hex
      perf tools: Speed up thread map generation
      perf tools: Use tid in mmap/mmap2 events to find maps

Dongsheng Yang (1):
      perf/x86/uncore: Add __init for uncore_cpumask_init()

Jiri Olsa (27):
      perf tools: Put proper period for for samples without PERIOD sample_type
      perf tools: Add call-graph option support into .perfconfig
      perf record: Add readable output for callchain debug
      perf tools: Fix memory leak in event_format__print function
      perf tests x86: Introduce perf_regs_load function
      perf tests x86: Add dwarf unwind test
      perf tools: Fix dwarf unwind max_stack processing
      perf callchain: Do not report zero address in unwind
      perf callchain: Add mask into struct regs_dump
      perf callchain: Separate libunwind code to special object
      perf callchain: Rename unwind__arch_reg_id into libunwind__arch_reg_id
      perf callchain: Introduce HAVE_DWARF_UNWIND_SUPPORT macro
      perf callchain: Separate perf_reg_value function in perf_regs object
      perf tests: Fix *.o make tests
      perf tests: Add pmu-bison.o make test
      perf tools: Fix bison OUTPUT directories dependency
      perf tools: Factor features display code
      perf tools: Add variable display for VF make output
      perf tools: Add feature check for libdw dwarf unwind
      perf tools: Add libdw DWARF post unwind support
      perf tools: Setup default dwarf post unwinder
      perf tests: Add NO_LIBDW_DWARF_UNWIND make test
      perf: Disallow user-space callchains for function trace events
      perf: Disallow user-space stack dumps for function trace events
      perf tools: Disable user-space callchain/stack dumps for function trace events
      perf machine: Factor machine__find_thread to take tid argument
      perf tools: Remove thread__find_map function

Mark Rutland (2):
      perf: Fix prototype of find_pmu_context()
      perf: Remove redundant PMU assignment

Masami Hiramatsu (11):
      perf probe: Fix to do exit call for symbol maps
      perf probe: Remove incorrect symbol check for --list
      perf probe: Replace line_list with intlist
      perf probe: Unify show_available_functions for uprobes/kprobes
      perf probe: Show in what binaries/modules probes are set
      perf probe: Use ref_reloc_sym based address instead of the symbol name
      perf probe: Find given address from offline dwarf
      perf probe: Show appropriate symbol for ref_reloc_sym based kprobes
      perf probe: Show source-level or symbol-level info for uprobes
      perf probe: Allow to add events on the local functions
      perf probe: Support distro-style debuginfo for uprobe

Namhyung Kim (11):
      perf symbols: Check compatible symtab type before loading dso
      perf ui/stdio: Fix invalid output on event group report
      perf ui/gtk: Reuse generic __hpp__fmt() code
      perf ui/hists: Pass struct hpp to print functions
      perf ui/tui: Reuse generic __hpp__fmt() code
      perf ui hists: Pass evsel to hpp->header/width functions explicitly
      perf symbols: Record the reason for filtering an address_location
      perf symbols: Apply all filters to an addr_location
      perf report: Merge al->filtered with hist_entry->filtered
      perf tools: Fix memory leak when synthesizing thread records
      perf report: Use ui__has_annotation()

Peter Zijlstra (5):
      perf/x86: Push the duration-logging printk() to IRQ context
      x86/nmi: Push duration printk() to irq context
      perf/x86: Warn to early_printk() in case irq_work is too slow
      perf/x86: Add a few more comments
      perf: Optimize group_sched_in()

Ramkumar Ramachandra (6):
      perf kvm: introduce --list-cmds for use by scripts
      perf timechart: Fix off-by-one error in 'record' argv handling
      perf sched: Fixup header alignment in 'latency' output
      perf evsel: Update function names in debug messages
      perf tools: Update some code references in design.txt
      perf tools: Remove unused simple_strtoul() function

Stephane Eranian (11):
      perf/x86/uncore: fix initialization of cpumask
      perf/x86/uncore: add ability to customize pmu callbacks
      perf/x86/uncore: add PCI ids for SNB/IVB/HSW IMC
      perf/x86/uncore: make hrtimer timeout configurable per box
      perf/x86/uncore: move uncore_event_to_box() and uncore_pmu_to_box()
      perf/x86/uncore: add SNB/IVB/HSW client uncore memory controller support
      perf/x86/uncore: add hrtimer to SNB uncore IMC PMU
      perf/x86/uncore: use MiB unit for events for SNB/IVB/HSW IMC
      perf symbols: Check return value of filename__read_debuglink()
      perf/x86/uncore: Fix compilation warning in snb_uncore_imc_init_box()
      perf/x86/uncore: Fix missing end markers for SNB/IVB/HSW IMC PMU


 arch/x86/include/asm/nmi.h                         |   3 +
 arch/x86/kernel/cpu/perf_event.c                   |  47 +-
 arch/x86/kernel/cpu/perf_event.h                   |   8 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c      | 544 +++++++++++--
 arch/x86/kernel/cpu/perf_event_intel_uncore.h      |   5 +
 arch/x86/kernel/cpu/perf_event_p4.c                |  34 +-
 arch/x86/kernel/nmi.c                              |  37 +-
 include/linux/irq_work.h                           |   4 +-
 include/linux/pci_ids.h                            |   3 +
 kernel/events/core.c                               |  39 +-
 kernel/irq_work.c                                  |   6 +-
 kernel/trace/trace_event_perf.c                    |  22 +-
 tools/include/linux/hash.h                         |   5 +
 tools/lib/api/Makefile                             |   2 +
 tools/{perf/util => lib/api/fs}/fs.c               |  11 +-
 .../util/include/linux/magic.h => lib/api/fs/fs.h} |  12 +-
 tools/perf/Documentation/perf-mem.txt              |   4 +
 tools/perf/Documentation/perf-probe.txt            |   2 +
 tools/perf/MANIFEST                                |   1 +
 tools/perf/Makefile.perf                           |  42 +-
 tools/perf/arch/arm/Makefile                       |   2 +-
 .../arch/arm/util/{unwind.c => unwind-libunwind.c} |   2 +-
 tools/perf/arch/x86/Makefile                       |   9 +-
 tools/perf/arch/x86/include/perf_regs.h            |   6 +
 tools/perf/arch/x86/tests/dwarf-unwind.c           |  59 ++
 tools/perf/arch/x86/tests/regs_load.S              |  92 +++
 tools/perf/arch/x86/util/unwind-libdw.c            |  51 ++
 .../arch/x86/util/{unwind.c => unwind-libunwind.c} |   4 +-
 tools/perf/bench/bench.h                           |   3 +
 tools/perf/bench/futex-hash.c                      | 212 +++++
 tools/perf/bench/futex-requeue.c                   | 211 +++++
 tools/perf/bench/futex-wake.c                      | 201 +++++
 tools/perf/bench/futex.h                           |  71 ++
 tools/perf/builtin-bench.c                         |  12 +-
 tools/perf/builtin-diff.c                          |   7 +-
 tools/perf/builtin-inject.c                        |   1 -
 tools/perf/builtin-kvm.c                           |  12 +-
 tools/perf/builtin-probe.c                         |  12 +-
 tools/perf/builtin-record.c                        |  30 +-
 tools/perf/builtin-report.c                        |  28 +-
 tools/perf/builtin-sched.c                         |  10 +-
 tools/perf/builtin-timechart.c                     |   4 +-
 tools/perf/builtin-top.c                           |  12 +
 tools/perf/config/Makefile                         | 232 ++++--
 tools/perf/config/feature-checks/Makefile          |   6 +-
 tools/perf/config/feature-checks/test-all.c        |   5 +
 .../feature-checks/test-libdw-dwarf-unwind.c       |  13 +
 tools/perf/design.txt                              |  12 +-
 tools/perf/perf-completion.sh                      |   2 +-
 tools/perf/perf.h                                  |  10 +-
 tools/perf/tests/builtin-test.c                    |   8 +
 tools/perf/tests/dwarf-unwind.c                    | 144 ++++
 tools/perf/tests/hists_link.c                      |   1 +
 tools/perf/tests/make                              |  25 +-
 tools/perf/tests/parse-events.c                    |   2 +-
 tools/perf/tests/sample-parsing.c                  |  17 +-
 tools/perf/tests/tests.h                           |   9 +
 tools/perf/ui/browsers/hists.c                     | 122 +--
 tools/perf/ui/gtk/hists.c                          |  78 +-
 tools/perf/ui/hist.c                               | 138 +++-
 tools/perf/ui/stdio/hist.c                         |  11 +-
 tools/perf/util/annotate.c                         |  14 +-
 tools/perf/util/cpumap.c                           |   2 +-
 tools/perf/util/dso.c                              |   4 +-
 tools/perf/util/dso.h                              |  10 +
 tools/perf/util/event.c                            | 188 +++--
 tools/perf/util/event.h                            |   5 +-
 tools/perf/util/evsel.c                            |  60 +-
 tools/perf/util/evsel.h                            |  18 +
 tools/perf/util/fs.h                               |   7 -
 tools/perf/util/hist.c                             |  13 +-
 tools/perf/util/hist.h                             |  29 +-
 tools/perf/util/include/linux/hash.h               |   5 -
 tools/perf/util/include/linux/kernel.h             |   6 -
 tools/perf/util/include/linux/list.h               |   1 -
 tools/perf/util/include/linux/prefetch.h           |   6 -
 tools/perf/util/machine.c                          |  79 +-
 tools/perf/util/machine.h                          |  13 +-
 tools/perf/util/map.h                              |  10 +
 tools/perf/util/parse-options.c                    |  37 +-
 tools/perf/util/parse-options.h                    |   8 +-
 tools/perf/util/perf_regs.c                        |  19 +
 tools/perf/util/perf_regs.h                        |  13 +
 tools/perf/util/pmu.c                              |   2 +-
 tools/perf/util/probe-event.c                      | 863 ++++++++++++---------
 tools/perf/util/probe-event.h                      |  12 +-
 tools/perf/util/probe-finder.c                     | 198 ++---
 tools/perf/util/probe-finder.h                     |   5 +-
 tools/perf/util/python-ext-sources                 |   2 +-
 tools/perf/util/record.c                           |   2 +-
 tools/perf/util/session.c                          |   7 +-
 tools/perf/util/symbol-elf.c                       |   2 +
 tools/perf/util/symbol.c                           |  63 +-
 tools/perf/util/symbol.h                           |  14 +-
 tools/perf/util/thread.c                           |  21 +
 tools/perf/util/thread.h                           |  11 +-
 tools/perf/util/trace-event-parse.c                |   1 +
 tools/perf/util/unwind-libdw.c                     | 210 +++++
 tools/perf/util/unwind-libdw.h                     |  21 +
 tools/perf/util/{unwind.c => unwind-libunwind.c}   |  50 +-
 tools/perf/util/unwind.h                           |  11 +-
 tools/perf/util/util.c                             |   2 +-
 102 files changed, 3472 insertions(+), 1289 deletions(-)
 create mode 100644 tools/include/linux/hash.h
 rename tools/{perf/util => lib/api/fs}/fs.c (91%)
 rename tools/{perf/util/include/linux/magic.h => lib/api/fs/fs.h} (50%)
 rename tools/perf/arch/arm/util/{unwind.c => unwind-libunwind.c} (95%)
 create mode 100644 tools/perf/arch/x86/tests/dwarf-unwind.c
 create mode 100644 tools/perf/arch/x86/tests/regs_load.S
 create mode 100644 tools/perf/arch/x86/util/unwind-libdw.c
 rename tools/perf/arch/x86/util/{unwind.c => unwind-libunwind.c} (95%)
 create mode 100644 tools/perf/bench/futex-hash.c
 create mode 100644 tools/perf/bench/futex-requeue.c
 create mode 100644 tools/perf/bench/futex-wake.c
 create mode 100644 tools/perf/bench/futex.h
 create mode 100644 tools/perf/config/feature-checks/test-libdw-dwarf-unwind.c
 create mode 100644 tools/perf/tests/dwarf-unwind.c
 delete mode 100644 tools/perf/util/fs.h
 delete mode 100644 tools/perf/util/include/linux/hash.h
 delete mode 100644 tools/perf/util/include/linux/prefetch.h
 create mode 100644 tools/perf/util/perf_regs.c
 create mode 100644 tools/perf/util/unwind-libdw.c
 create mode 100644 tools/perf/util/unwind-libdw.h
 rename tools/perf/util/{unwind.c => unwind-libunwind.c} (92%)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 86f9301..5f2fc44 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_X86_NMI_H
 #define _ASM_X86_NMI_H
 
+#include <linux/irq_work.h>
 #include <linux/pm.h>
 #include <asm/irq.h>
 #include <asm/io.h>
@@ -38,6 +39,8 @@ typedef int (*nmi_handler_t)(unsigned int, struct pt_regs *);
 struct nmiaction {
 	struct list_head	list;
 	nmi_handler_t		handler;
+	u64			max_duration;
+	struct irq_work		irq_work;
 	unsigned long		flags;
 	const char		*name;
 };
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 79f9f84..ae407f7 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -892,7 +892,6 @@ static void x86_pmu_enable(struct pmu *pmu)
 		 * hw_perf_group_sched_in() or x86_pmu_enable()
 		 *
 		 * step1: save events moving to new counters
-		 * step2: reprogram moved events into new counters
 		 */
 		for (i = 0; i < n_running; i++) {
 			event = cpuc->event_list[i];
@@ -918,6 +917,9 @@ static void x86_pmu_enable(struct pmu *pmu)
 			x86_pmu_stop(event, PERF_EF_UPDATE);
 		}
 
+		/*
+		 * step2: reprogram moved events into new counters
+		 */
 		for (i = 0; i < cpuc->n_events; i++) {
 			event = cpuc->event_list[i];
 			hwc = &event->hw;
@@ -1043,7 +1045,7 @@ static int x86_pmu_add(struct perf_event *event, int flags)
 	/*
 	 * If group events scheduling transaction was started,
 	 * skip the schedulability test here, it will be performed
-	 * at commit time (->commit_txn) as a whole
+	 * at commit time (->commit_txn) as a whole.
 	 */
 	if (cpuc->group_flag & PERF_EVENT_TXN)
 		goto done_collect;
@@ -1058,6 +1060,10 @@ static int x86_pmu_add(struct perf_event *event, int flags)
 	memcpy(cpuc->assign, assign, n*sizeof(int));
 
 done_collect:
+	/*
+	 * Commit the collect_events() state. See x86_pmu_del() and
+	 * x86_pmu_*_txn().
+	 */
 	cpuc->n_events = n;
 	cpuc->n_added += n - n0;
 	cpuc->n_txn += n - n0;
@@ -1183,28 +1189,38 @@ static void x86_pmu_del(struct perf_event *event, int flags)
 	 * If we're called during a txn, we don't need to do anything.
 	 * The events never got scheduled and ->cancel_txn will truncate
 	 * the event_list.
+	 *
+	 * XXX assumes any ->del() called during a TXN will only be on
+	 * an event added during that same TXN.
 	 */
 	if (cpuc->group_flag & PERF_EVENT_TXN)
 		return;
 
+	/*
+	 * Not a TXN, therefore cleanup properly.
+	 */
 	x86_pmu_stop(event, PERF_EF_UPDATE);
 
 	for (i = 0; i < cpuc->n_events; i++) {
-		if (event == cpuc->event_list[i]) {
+		if (event == cpuc->event_list[i])
+			break;
+	}
 
-			if (i >= cpuc->n_events - cpuc->n_added)
-				--cpuc->n_added;
+	if (WARN_ON_ONCE(i == cpuc->n_events)) /* called ->del() without ->add() ? */
+		return;
 
-			if (x86_pmu.put_event_constraints)
-				x86_pmu.put_event_constraints(cpuc, event);
+	/* If we have a newly added event; make sure to decrease n_added. */
+	if (i >= cpuc->n_events - cpuc->n_added)
+		--cpuc->n_added;
 
-			while (++i < cpuc->n_events)
-				cpuc->event_list[i-1] = cpuc->event_list[i];
+	if (x86_pmu.put_event_constraints)
+		x86_pmu.put_event_constraints(cpuc, event);
+
+	/* Delete the array entry. */
+	while (++i < cpuc->n_events)
+		cpuc->event_list[i-1] = cpuc->event_list[i];
+	--cpuc->n_events;
 
-			--cpuc->n_events;
-			break;
-		}
-	}
 	perf_event_update_userpage(event);
 }
 
@@ -1598,7 +1614,8 @@ static void x86_pmu_cancel_txn(struct pmu *pmu)
 {
 	__this_cpu_and(cpu_hw_events.group_flag, ~PERF_EVENT_TXN);
 	/*
-	 * Truncate the collected events.
+	 * Truncate collected array by the number of events added in this
+	 * transaction. See x86_pmu_add() and x86_pmu_*_txn().
 	 */
 	__this_cpu_sub(cpu_hw_events.n_added, __this_cpu_read(cpu_hw_events.n_txn));
 	__this_cpu_sub(cpu_hw_events.n_events, __this_cpu_read(cpu_hw_events.n_txn));
@@ -1609,6 +1626,8 @@ static void x86_pmu_cancel_txn(struct pmu *pmu)
  * Commit group events scheduling transaction
  * Perform the group schedulability test as a whole
  * Return 0 if success
+ *
+ * Does not cancel the transaction on failure; expects the caller to do this.
  */
 static int x86_pmu_commit_txn(struct pmu *pmu)
 {
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 4972c24..3b2f9bd 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -130,9 +130,11 @@ struct cpu_hw_events {
 	unsigned long		running[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	int			enabled;
 
-	int			n_events;
-	int			n_added;
-	int			n_txn;
+	int			n_events; /* the # of events in the below arrays */
+	int			n_added;  /* the # last events in the below arrays;
+					     they've never been enabled yet */
+	int			n_txn;    /* the # last events in the below arrays;
+					     added in the current transaction */
 	int			assign[X86_PMC_IDX_MAX]; /* event to counter assignment */
 	u64			tags[X86_PMC_IDX_MAX];
 	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in enabled order */
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index c88f7f4..618d502 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -66,6 +66,47 @@ DEFINE_UNCORE_FORMAT_ATTR(mask_vnw, mask_vnw, "config2:3-4");
 DEFINE_UNCORE_FORMAT_ATTR(mask0, mask0, "config2:0-31");
 DEFINE_UNCORE_FORMAT_ATTR(mask1, mask1, "config2:32-63");
 
+static void uncore_pmu_start_hrtimer(struct intel_uncore_box *box);
+static void uncore_pmu_cancel_hrtimer(struct intel_uncore_box *box);
+static void uncore_perf_event_update(struct intel_uncore_box *box, struct perf_event *event);
+static void uncore_pmu_event_read(struct perf_event *event);
+
+static struct intel_uncore_pmu *uncore_event_to_pmu(struct perf_event *event)
+{
+	return container_of(event->pmu, struct intel_uncore_pmu, pmu);
+}
+
+static struct intel_uncore_box *
+uncore_pmu_to_box(struct intel_uncore_pmu *pmu, int cpu)
+{
+	struct intel_uncore_box *box;
+
+	box = *per_cpu_ptr(pmu->box, cpu);
+	if (box)
+		return box;
+
+	raw_spin_lock(&uncore_box_lock);
+	list_for_each_entry(box, &pmu->box_list, list) {
+		if (box->phys_id == topology_physical_package_id(cpu)) {
+			atomic_inc(&box->refcnt);
+			*per_cpu_ptr(pmu->box, cpu) = box;
+			break;
+		}
+	}
+	raw_spin_unlock(&uncore_box_lock);
+
+	return *per_cpu_ptr(pmu->box, cpu);
+}
+
+static struct intel_uncore_box *uncore_event_to_box(struct perf_event *event)
+{
+	/*
+	 * perf core schedules event on the basis of cpu, uncore events are
+	 * collected by one of the cpus inside a physical package.
+	 */
+	return uncore_pmu_to_box(uncore_event_to_pmu(event), smp_processor_id());
+}
+
 static u64 uncore_msr_read_counter(struct intel_uncore_box *box, struct perf_event *event)
 {
 	u64 count;
@@ -1639,6 +1680,349 @@ static struct intel_uncore_type *snb_msr_uncores[] = {
 	&snb_uncore_cbox,
 	NULL,
 };
+
+enum {
+	SNB_PCI_UNCORE_IMC,
+};
+
+static struct uncore_event_desc snb_uncore_imc_events[] = {
+	INTEL_UNCORE_EVENT_DESC(data_reads,  "event=0x01"),
+	INTEL_UNCORE_EVENT_DESC(data_reads.scale, "6.103515625e-5"),
+	INTEL_UNCORE_EVENT_DESC(data_reads.unit, "MiB"),
+
+	INTEL_UNCORE_EVENT_DESC(data_writes, "event=0x02"),
+	INTEL_UNCORE_EVENT_DESC(data_writes.scale, "6.103515625e-5"),
+	INTEL_UNCORE_EVENT_DESC(data_writes.unit, "MiB"),
+
+	{ /* end: all zeroes */ },
+};
+
+#define SNB_UNCORE_PCI_IMC_EVENT_MASK		0xff
+#define SNB_UNCORE_PCI_IMC_BAR_OFFSET		0x48
+
+/* page size multiple covering all config regs */
+#define SNB_UNCORE_PCI_IMC_MAP_SIZE		0x6000
+
+#define SNB_UNCORE_PCI_IMC_DATA_READS		0x1
+#define SNB_UNCORE_PCI_IMC_DATA_READS_BASE	0x5050
+#define SNB_UNCORE_PCI_IMC_DATA_WRITES		0x2
+#define SNB_UNCORE_PCI_IMC_DATA_WRITES_BASE	0x5054
+#define SNB_UNCORE_PCI_IMC_CTR_BASE		SNB_UNCORE_PCI_IMC_DATA_READS_BASE
+
+static struct attribute *snb_uncore_imc_formats_attr[] = {
+	&format_attr_event.attr,
+	NULL,
+};
+
+static struct attribute_group snb_uncore_imc_format_group = {
+	.name = "format",
+	.attrs = snb_uncore_imc_formats_attr,
+};
+
+static void snb_uncore_imc_init_box(struct intel_uncore_box *box)
+{
+	struct pci_dev *pdev = box->pci_dev;
+	int where = SNB_UNCORE_PCI_IMC_BAR_OFFSET;
+	resource_size_t addr;
+	u32 pci_dword;
+
+	pci_read_config_dword(pdev, where, &pci_dword);
+	addr = pci_dword;
+
+#ifdef CONFIG_PHYS_ADDR_T_64BIT
+	pci_read_config_dword(pdev, where + 4, &pci_dword);
+	addr |= ((resource_size_t)pci_dword << 32);
+#endif
+
+	addr &= ~(PAGE_SIZE - 1);
+
+	box->io_addr = ioremap(addr, SNB_UNCORE_PCI_IMC_MAP_SIZE);
+	box->hrtimer_duration = UNCORE_SNB_IMC_HRTIMER_INTERVAL;
+}
+
+static void snb_uncore_imc_enable_box(struct intel_uncore_box *box)
+{}
+
+static void snb_uncore_imc_disable_box(struct intel_uncore_box *box)
+{}
+
+static void snb_uncore_imc_enable_event(struct intel_uncore_box *box, struct perf_event *event)
+{}
+
+static void snb_uncore_imc_disable_event(struct intel_uncore_box *box, struct perf_event *event)
+{}
+
+static u64 snb_uncore_imc_read_counter(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	return (u64)*(unsigned int *)(box->io_addr + hwc->event_base);
+}
+
+/*
+ * custom event_init() function because we define our own fixed, free
+ * running counters, so we do not want to conflict with generic uncore
+ * logic. Also simplifies processing
+ */
+static int snb_uncore_imc_event_init(struct perf_event *event)
+{
+	struct intel_uncore_pmu *pmu;
+	struct intel_uncore_box *box;
+	struct hw_perf_event *hwc = &event->hw;
+	u64 cfg = event->attr.config & SNB_UNCORE_PCI_IMC_EVENT_MASK;
+	int idx, base;
+
+	if (event->attr.type != event->pmu->type)
+		return -ENOENT;
+
+	pmu = uncore_event_to_pmu(event);
+	/* no device found for this pmu */
+	if (pmu->func_id < 0)
+		return -ENOENT;
+
+	/* Sampling not supported yet */
+	if (hwc->sample_period)
+		return -EINVAL;
+
+	/* unsupported modes and filters */
+	if (event->attr.exclude_user   ||
+	    event->attr.exclude_kernel ||
+	    event->attr.exclude_hv     ||
+	    event->attr.exclude_idle   ||
+	    event->attr.exclude_host   ||
+	    event->attr.exclude_guest  ||
+	    event->attr.sample_period) /* no sampling */
+		return -EINVAL;
+
+	/*
+	 * Place all uncore events for a particular physical package
+	 * onto a single cpu
+	 */
+	if (event->cpu < 0)
+		return -EINVAL;
+
+	/* check only supported bits are set */
+	if (event->attr.config & ~SNB_UNCORE_PCI_IMC_EVENT_MASK)
+		return -EINVAL;
+
+	box = uncore_pmu_to_box(pmu, event->cpu);
+	if (!box || box->cpu < 0)
+		return -EINVAL;
+
+	event->cpu = box->cpu;
+
+	event->hw.idx = -1;
+	event->hw.last_tag = ~0ULL;
+	event->hw.extra_reg.idx = EXTRA_REG_NONE;
+	event->hw.branch_reg.idx = EXTRA_REG_NONE;
+	/*
+	 * check event is known (whitelist, determines counter)
+	 */
+	switch (cfg) {
+	case SNB_UNCORE_PCI_IMC_DATA_READS:
+		base = SNB_UNCORE_PCI_IMC_DATA_READS_BASE;
+		idx = UNCORE_PMC_IDX_FIXED;
+		break;
+	case SNB_UNCORE_PCI_IMC_DATA_WRITES:
+		base = SNB_UNCORE_PCI_IMC_DATA_WRITES_BASE;
+		idx = UNCORE_PMC_IDX_FIXED + 1;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* must be done before validate_group */
+	event->hw.event_base = base;
+	event->hw.config = cfg;
+	event->hw.idx = idx;
+
+	/* no group validation needed, we have free running counters */
+
+	return 0;
+}
+
+static int snb_uncore_imc_hw_config(struct intel_uncore_box *box, struct perf_event *event)
+{
+	return 0;
+}
+
+static void snb_uncore_imc_event_start(struct perf_event *event, int flags)
+{
+	struct intel_uncore_box *box = uncore_event_to_box(event);
+	u64 count;
+
+	if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
+		return;
+
+	event->hw.state = 0;
+	box->n_active++;
+
+	list_add_tail(&event->active_entry, &box->active_list);
+
+	count = snb_uncore_imc_read_counter(box, event);
+	local64_set(&event->hw.prev_count, count);
+
+	if (box->n_active == 1)
+		uncore_pmu_start_hrtimer(box);
+}
+
+static void snb_uncore_imc_event_stop(struct perf_event *event, int flags)
+{
+	struct intel_uncore_box *box = uncore_event_to_box(event);
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (!(hwc->state & PERF_HES_STOPPED)) {
+		box->n_active--;
+
+		WARN_ON_ONCE(hwc->state & PERF_HES_STOPPED);
+		hwc->state |= PERF_HES_STOPPED;
+
+		list_del(&event->active_entry);
+
+		if (box->n_active == 0)
+			uncore_pmu_cancel_hrtimer(box);
+	}
+
+	if ((flags & PERF_EF_UPDATE) && !(hwc->state & PERF_HES_UPTODATE)) {
+		/*
+		 * Drain the remaining delta count out of a event
+		 * that we are disabling:
+		 */
+		uncore_perf_event_update(box, event);
+		hwc->state |= PERF_HES_UPTODATE;
+	}
+}
+
+static int snb_uncore_imc_event_add(struct perf_event *event, int flags)
+{
+	struct intel_uncore_box *box = uncore_event_to_box(event);
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (!box)
+		return -ENODEV;
+
+	hwc->state = PERF_HES_UPTODATE | PERF_HES_STOPPED;
+	if (!(flags & PERF_EF_START))
+		hwc->state |= PERF_HES_ARCH;
+
+	snb_uncore_imc_event_start(event, 0);
+
+	box->n_events++;
+
+	return 0;
+}
+
+static void snb_uncore_imc_event_del(struct perf_event *event, int flags)
+{
+	struct intel_uncore_box *box = uncore_event_to_box(event);
+	int i;
+
+	snb_uncore_imc_event_stop(event, PERF_EF_UPDATE);
+
+	for (i = 0; i < box->n_events; i++) {
+		if (event == box->event_list[i]) {
+			--box->n_events;
+			break;
+		}
+	}
+}
+
+static int snb_pci2phy_map_init(int devid)
+{
+	struct pci_dev *dev = NULL;
+	int bus;
+
+	dev = pci_get_device(PCI_VENDOR_ID_INTEL, devid, dev);
+	if (!dev)
+		return -ENOTTY;
+
+	bus = dev->bus->number;
+
+	pcibus_to_physid[bus] = 0;
+
+	pci_dev_put(dev);
+
+	return 0;
+}
+
+static struct pmu snb_uncore_imc_pmu = {
+	.task_ctx_nr	= perf_invalid_context,
+	.event_init	= snb_uncore_imc_event_init,
+	.add		= snb_uncore_imc_event_add,
+	.del		= snb_uncore_imc_event_del,
+	.start		= snb_uncore_imc_event_start,
+	.stop		= snb_uncore_imc_event_stop,
+	.read		= uncore_pmu_event_read,
+};
+
+static struct intel_uncore_ops snb_uncore_imc_ops = {
+	.init_box	= snb_uncore_imc_init_box,
+	.enable_box	= snb_uncore_imc_enable_box,
+	.disable_box	= snb_uncore_imc_disable_box,
+	.disable_event	= snb_uncore_imc_disable_event,
+	.enable_event	= snb_uncore_imc_enable_event,
+	.hw_config	= snb_uncore_imc_hw_config,
+	.read_counter	= snb_uncore_imc_read_counter,
+};
+
+static struct intel_uncore_type snb_uncore_imc = {
+	.name		= "imc",
+	.num_counters   = 2,
+	.num_boxes	= 1,
+	.fixed_ctr_bits	= 32,
+	.fixed_ctr	= SNB_UNCORE_PCI_IMC_CTR_BASE,
+	.event_descs	= snb_uncore_imc_events,
+	.format_group	= &snb_uncore_imc_format_group,
+	.perf_ctr	= SNB_UNCORE_PCI_IMC_DATA_READS_BASE,
+	.event_mask	= SNB_UNCORE_PCI_IMC_EVENT_MASK,
+	.ops		= &snb_uncore_imc_ops,
+	.pmu		= &snb_uncore_imc_pmu,
+};
+
+static struct intel_uncore_type *snb_pci_uncores[] = {
+	[SNB_PCI_UNCORE_IMC]	= &snb_uncore_imc,
+	NULL,
+};
+
+static DEFINE_PCI_DEVICE_TABLE(snb_uncore_pci_ids) = {
+	{ /* IMC */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SNB_IMC),
+		.driver_data = UNCORE_PCI_DEV_DATA(SNB_PCI_UNCORE_IMC, 0),
+	},
+	{ /* end: all zeroes */ },
+};
+
+static DEFINE_PCI_DEVICE_TABLE(ivb_uncore_pci_ids) = {
+	{ /* IMC */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IVB_IMC),
+		.driver_data = UNCORE_PCI_DEV_DATA(SNB_PCI_UNCORE_IMC, 0),
+	},
+	{ /* end: all zeroes */ },
+};
+
+static DEFINE_PCI_DEVICE_TABLE(hsw_uncore_pci_ids) = {
+	{ /* IMC */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_HSW_IMC),
+		.driver_data = UNCORE_PCI_DEV_DATA(SNB_PCI_UNCORE_IMC, 0),
+	},
+	{ /* end: all zeroes */ },
+};
+
+static struct pci_driver snb_uncore_pci_driver = {
+	.name		= "snb_uncore",
+	.id_table	= snb_uncore_pci_ids,
+};
+
+static struct pci_driver ivb_uncore_pci_driver = {
+	.name		= "ivb_uncore",
+	.id_table	= ivb_uncore_pci_ids,
+};
+
+static struct pci_driver hsw_uncore_pci_driver = {
+	.name		= "hsw_uncore",
+	.id_table	= hsw_uncore_pci_ids,
+};
+
 /* end of Sandy Bridge uncore support */
 
 /* Nehalem uncore support */
@@ -2789,6 +3173,7 @@ again:
 static enum hrtimer_restart uncore_pmu_hrtimer(struct hrtimer *hrtimer)
 {
 	struct intel_uncore_box *box;
+	struct perf_event *event;
 	unsigned long flags;
 	int bit;
 
@@ -2801,19 +3186,27 @@ static enum hrtimer_restart uncore_pmu_hrtimer(struct hrtimer *hrtimer)
 	 */
 	local_irq_save(flags);
 
+	/*
+	 * handle boxes with an active event list as opposed to active
+	 * counters
+	 */
+	list_for_each_entry(event, &box->active_list, active_entry) {
+		uncore_perf_event_update(box, event);
+	}
+
 	for_each_set_bit(bit, box->active_mask, UNCORE_PMC_IDX_MAX)
 		uncore_perf_event_update(box, box->events[bit]);
 
 	local_irq_restore(flags);
 
-	hrtimer_forward_now(hrtimer, ns_to_ktime(UNCORE_PMU_HRTIMER_INTERVAL));
+	hrtimer_forward_now(hrtimer, ns_to_ktime(box->hrtimer_duration));
 	return HRTIMER_RESTART;
 }
 
 static void uncore_pmu_start_hrtimer(struct intel_uncore_box *box)
 {
 	__hrtimer_start_range_ns(&box->hrtimer,
-			ns_to_ktime(UNCORE_PMU_HRTIMER_INTERVAL), 0,
+			ns_to_ktime(box->hrtimer_duration), 0,
 			HRTIMER_MODE_REL_PINNED, 0);
 }
 
@@ -2847,43 +3240,12 @@ static struct intel_uncore_box *uncore_alloc_box(struct intel_uncore_type *type,
 	box->cpu = -1;
 	box->phys_id = -1;
 
-	return box;
-}
+	/* set default hrtimer timeout */
+	box->hrtimer_duration = UNCORE_PMU_HRTIMER_INTERVAL;
 
-static struct intel_uncore_box *
-uncore_pmu_to_box(struct intel_uncore_pmu *pmu, int cpu)
-{
-	struct intel_uncore_box *box;
+	INIT_LIST_HEAD(&box->active_list);
 
-	box = *per_cpu_ptr(pmu->box, cpu);
-	if (box)
-		return box;
-
-	raw_spin_lock(&uncore_box_lock);
-	list_for_each_entry(box, &pmu->box_list, list) {
-		if (box->phys_id == topology_physical_package_id(cpu)) {
-			atomic_inc(&box->refcnt);
-			*per_cpu_ptr(pmu->box, cpu) = box;
-			break;
-		}
-	}
-	raw_spin_unlock(&uncore_box_lock);
-
-	return *per_cpu_ptr(pmu->box, cpu);
-}
-
-static struct intel_uncore_pmu *uncore_event_to_pmu(struct perf_event *event)
-{
-	return container_of(event->pmu, struct intel_uncore_pmu, pmu);
-}
-
-static struct intel_uncore_box *uncore_event_to_box(struct perf_event *event)
-{
-	/*
-	 * perf core schedules event on the basis of cpu, uncore events are
-	 * collected by one of the cpus inside a physical package.
-	 */
-	return uncore_pmu_to_box(uncore_event_to_pmu(event), smp_processor_id());
+	return box;
 }
 
 static int
@@ -3279,16 +3641,21 @@ static int __init uncore_pmu_register(struct intel_uncore_pmu *pmu)
 {
 	int ret;
 
-	pmu->pmu = (struct pmu) {
-		.attr_groups	= pmu->type->attr_groups,
-		.task_ctx_nr	= perf_invalid_context,
-		.event_init	= uncore_pmu_event_init,
-		.add		= uncore_pmu_event_add,
-		.del		= uncore_pmu_event_del,
-		.start		= uncore_pmu_event_start,
-		.stop		= uncore_pmu_event_stop,
-		.read		= uncore_pmu_event_read,
-	};
+	if (!pmu->type->pmu) {
+		pmu->pmu = (struct pmu) {
+			.attr_groups	= pmu->type->attr_groups,
+			.task_ctx_nr	= perf_invalid_context,
+			.event_init	= uncore_pmu_event_init,
+			.add		= uncore_pmu_event_add,
+			.del		= uncore_pmu_event_del,
+			.start		= uncore_pmu_event_start,
+			.stop		= uncore_pmu_event_stop,
+			.read		= uncore_pmu_event_read,
+		};
+	} else {
+		pmu->pmu = *pmu->type->pmu;
+		pmu->pmu.attr_groups = pmu->type->attr_groups;
+	}
 
 	if (pmu->type->num_boxes == 1) {
 		if (strlen(pmu->type->name) > 0)
@@ -3501,6 +3868,28 @@ static int __init uncore_pci_init(void)
 		pci_uncores = ivt_pci_uncores;
 		uncore_pci_driver = &ivt_uncore_pci_driver;
 		break;
+	case 42: /* Sandy Bridge */
+		ret = snb_pci2phy_map_init(PCI_DEVICE_ID_INTEL_SNB_IMC);
+		if (ret)
+			return ret;
+		pci_uncores = snb_pci_uncores;
+		uncore_pci_driver = &snb_uncore_pci_driver;
+		break;
+	case 58: /* Ivy Bridge */
+		ret = snb_pci2phy_map_init(PCI_DEVICE_ID_INTEL_IVB_IMC);
+		if (ret)
+			return ret;
+		pci_uncores = snb_pci_uncores;
+		uncore_pci_driver = &ivb_uncore_pci_driver;
+		break;
+	case 60: /* Haswell */
+	case 69: /* Haswell Celeron */
+		ret = snb_pci2phy_map_init(PCI_DEVICE_ID_INTEL_HSW_IMC);
+		if (ret)
+			return ret;
+		pci_uncores = snb_pci_uncores;
+		uncore_pci_driver = &hsw_uncore_pci_driver;
+		break;
 	default:
 		return 0;
 	}
@@ -3772,7 +4161,7 @@ static void __init uncore_cpu_setup(void *dummy)
 
 static int __init uncore_cpu_init(void)
 {
-	int ret, cpu, max_cores;
+	int ret, max_cores;
 
 	max_cores = boot_cpu_data.x86_max_cores;
 	switch (boot_cpu_data.x86_model) {
@@ -3816,29 +4205,6 @@ static int __init uncore_cpu_init(void)
 	if (ret)
 		return ret;
 
-	get_online_cpus();
-
-	for_each_online_cpu(cpu) {
-		int i, phys_id = topology_physical_package_id(cpu);
-
-		for_each_cpu(i, &uncore_cpu_mask) {
-			if (phys_id == topology_physical_package_id(i)) {
-				phys_id = -1;
-				break;
-			}
-		}
-		if (phys_id < 0)
-			continue;
-
-		uncore_cpu_prepare(cpu, phys_id);
-		uncore_event_init_cpu(cpu);
-	}
-	on_each_cpu(uncore_cpu_setup, NULL, 1);
-
-	register_cpu_notifier(&uncore_cpu_nb);
-
-	put_online_cpus();
-
 	return 0;
 }
 
@@ -3867,6 +4233,41 @@ static int __init uncore_pmus_register(void)
 	return 0;
 }
 
+static void __init uncore_cpumask_init(void)
+{
+	int cpu;
+
+	/*
+	 * ony invoke once from msr or pci init code
+	 */
+	if (!cpumask_empty(&uncore_cpu_mask))
+		return;
+
+	get_online_cpus();
+
+	for_each_online_cpu(cpu) {
+		int i, phys_id = topology_physical_package_id(cpu);
+
+		for_each_cpu(i, &uncore_cpu_mask) {
+			if (phys_id == topology_physical_package_id(i)) {
+				phys_id = -1;
+				break;
+			}
+		}
+		if (phys_id < 0)
+			continue;
+
+		uncore_cpu_prepare(cpu, phys_id);
+		uncore_event_init_cpu(cpu);
+	}
+	on_each_cpu(uncore_cpu_setup, NULL, 1);
+
+	register_cpu_notifier(&uncore_cpu_nb);
+
+	put_online_cpus();
+}
+
+
 static int __init intel_uncore_init(void)
 {
 	int ret;
@@ -3885,6 +4286,7 @@ static int __init intel_uncore_init(void)
 		uncore_pci_exit();
 		goto fail;
 	}
+	uncore_cpumask_init();
 
 	uncore_pmus_register();
 	return 0;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index a80ab71..90236f0 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -6,6 +6,7 @@
 
 #define UNCORE_PMU_NAME_LEN		32
 #define UNCORE_PMU_HRTIMER_INTERVAL	(60LL * NSEC_PER_SEC)
+#define UNCORE_SNB_IMC_HRTIMER_INTERVAL (5ULL * NSEC_PER_SEC)
 
 #define UNCORE_FIXED_EVENT		0xff
 #define UNCORE_PMC_IDX_MAX_GENERIC	8
@@ -440,6 +441,7 @@ struct intel_uncore_type {
 	struct intel_uncore_ops *ops;
 	struct uncore_event_desc *event_descs;
 	const struct attribute_group *attr_groups[4];
+	struct pmu *pmu; /* for custom pmu ops */
 };
 
 #define pmu_group attr_groups[0]
@@ -488,8 +490,11 @@ struct intel_uncore_box {
 	u64 tags[UNCORE_PMC_IDX_MAX];
 	struct pci_dev *pci_dev;
 	struct intel_uncore_pmu *pmu;
+	u64 hrtimer_duration; /* hrtimer timeout for this box */
 	struct hrtimer hrtimer;
 	struct list_head list;
+	struct list_head active_list;
+	void *io_addr;
 	struct intel_uncore_extra_reg shared_regs[0];
 };
 
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 3486e66..5d466b7 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -1257,7 +1257,24 @@ again:
 			pass++;
 			goto again;
 		}
-
+		/*
+		 * Perf does test runs to see if a whole group can be assigned
+		 * together succesfully.  There can be multiple rounds of this.
+		 * Unfortunately, p4_pmu_swap_config_ts touches the hwc->config
+		 * bits, such that the next round of group assignments will
+		 * cause the above p4_should_swap_ts to pass instead of fail.
+		 * This leads to counters exclusive to thread0 being used by
+		 * thread1.
+		 *
+		 * Solve this with a cheap hack, reset the idx back to -1 to
+		 * force a new lookup (p4_next_cntr) to get the right counter
+		 * for the right thread.
+		 *
+		 * This probably doesn't comply with the general spirit of how
+		 * perf wants to work, but P4 is special. :-(
+		 */
+		if (p4_should_swap_ts(hwc->config, cpu))
+			hwc->idx = -1;
 		p4_pmu_swap_config_ts(hwc, cpu);
 		if (assign)
 			assign[i] = cntr_idx;
@@ -1322,6 +1339,7 @@ static __initconst const struct x86_pmu p4_pmu = {
 __init int p4_pmu_init(void)
 {
 	unsigned int low, high;
+	int i, reg;
 
 	/* If we get stripped -- indexing fails */
 	BUILD_BUG_ON(ARCH_P4_MAX_CCCR > INTEL_PMC_MAX_GENERIC);
@@ -1340,5 +1358,19 @@ __init int p4_pmu_init(void)
 
 	x86_pmu = p4_pmu;
 
+	/*
+	 * Even though the counters are configured to interrupt a particular
+	 * logical processor when an overflow happens, testing has shown that
+	 * on kdump kernels (which uses a single cpu), thread1's counter
+	 * continues to run and will report an NMI on thread0.  Due to the
+	 * overflow bug, this leads to a stream of unknown NMIs.
+	 *
+	 * Solve this by zero'ing out the registers to mimic a reset.
+	 */
+	for (i = 0; i < x86_pmu.num_counters; i++) {
+		reg = x86_pmu_config_addr(i);
+		wrmsrl_safe(reg, 0ULL);
+	}
+
 	return 0;
 }
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 6fcb49c..b4872b9 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -87,6 +87,7 @@ __setup("unknown_nmi_panic", setup_unknown_nmi_panic);
 #define nmi_to_desc(type) (&nmi_desc[type])
 
 static u64 nmi_longest_ns = 1 * NSEC_PER_MSEC;
+
 static int __init nmi_warning_debugfs(void)
 {
 	debugfs_create_u64("nmi_longest_ns", 0644,
@@ -95,6 +96,20 @@ static int __init nmi_warning_debugfs(void)
 }
 fs_initcall(nmi_warning_debugfs);
 
+static void nmi_max_handler(struct irq_work *w)
+{
+	struct nmiaction *a = container_of(w, struct nmiaction, irq_work);
+	int remainder_ns, decimal_msecs;
+	u64 whole_msecs = ACCESS_ONCE(a->max_duration);
+
+	remainder_ns = do_div(whole_msecs, (1000 * 1000));
+	decimal_msecs = remainder_ns / 1000;
+
+	printk_ratelimited(KERN_INFO
+		"INFO: NMI handler (%ps) took too long to run: %lld.%03d msecs\n",
+		a->handler, whole_msecs, decimal_msecs);
+}
+
 static int __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2b)
 {
 	struct nmi_desc *desc = nmi_to_desc(type);
@@ -110,26 +125,20 @@ static int __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2
 	 * to handle those situations.
 	 */
 	list_for_each_entry_rcu(a, &desc->head, list) {
-		u64 before, delta, whole_msecs;
-		int remainder_ns, decimal_msecs, thishandled;
+		int thishandled;
+		u64 delta;
 
-		before = sched_clock();
+		delta = sched_clock();
 		thishandled = a->handler(type, regs);
 		handled += thishandled;
-		delta = sched_clock() - before;
+		delta = sched_clock() - delta;
 		trace_nmi_handler(a->handler, (int)delta, thishandled);
 
-		if (delta < nmi_longest_ns)
+		if (delta < nmi_longest_ns || delta < a->max_duration)
 			continue;
 
-		nmi_longest_ns = delta;
-		whole_msecs = delta;
-		remainder_ns = do_div(whole_msecs, (1000 * 1000));
-		decimal_msecs = remainder_ns / 1000;
-		printk_ratelimited(KERN_INFO
-			"INFO: NMI handler (%ps) took too long to run: "
-			"%lld.%03d msecs\n", a->handler, whole_msecs,
-			decimal_msecs);
+		a->max_duration = delta;
+		irq_work_queue(&a->irq_work);
 	}
 
 	rcu_read_unlock();
@@ -146,6 +155,8 @@ int __register_nmi_handler(unsigned int type, struct nmiaction *action)
 	if (!action->handler)
 		return -EINVAL;
 
+	init_irq_work(&action->irq_work, nmi_max_handler);
+
 	spin_lock_irqsave(&desc->lock, flags);
 
 	/*
diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index 6601702..19ae05d 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -30,7 +30,9 @@ void init_irq_work(struct irq_work *work, void (*func)(struct irq_work *))
 	work->func = func;
 }
 
-void irq_work_queue(struct irq_work *work);
+#define DEFINE_IRQ_WORK(name, _f) struct irq_work name = { .func = (_f), }
+
+bool irq_work_queue(struct irq_work *work);
 void irq_work_run(void);
 void irq_work_sync(struct irq_work *work);
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 97fbecd..7399e6a 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2531,6 +2531,9 @@
 
 #define PCI_VENDOR_ID_INTEL		0x8086
 #define PCI_DEVICE_ID_INTEL_EESSC	0x0008
+#define PCI_DEVICE_ID_INTEL_SNB_IMC	0x0100
+#define PCI_DEVICE_ID_INTEL_IVB_IMC	0x0154
+#define PCI_DEVICE_ID_INTEL_HSW_IMC	0x0c00
 #define PCI_DEVICE_ID_INTEL_PXHD_0	0x0320
 #define PCI_DEVICE_ID_INTEL_PXHD_1	0x0321
 #define PCI_DEVICE_ID_INTEL_PXH_0	0x0329
diff --git a/kernel/events/core.c b/kernel/events/core.c
index fa0b2d4..661951a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -231,11 +231,29 @@ int perf_cpu_time_max_percent_handler(struct ctl_table *table, int write,
 #define NR_ACCUMULATED_SAMPLES 128
 static DEFINE_PER_CPU(u64, running_sample_length);
 
-void perf_sample_event_took(u64 sample_len_ns)
+static void perf_duration_warn(struct irq_work *w)
 {
+	u64 allowed_ns = ACCESS_ONCE(perf_sample_allowed_ns);
 	u64 avg_local_sample_len;
 	u64 local_samples_len;
+
+	local_samples_len = __get_cpu_var(running_sample_length);
+	avg_local_sample_len = local_samples_len/NR_ACCUMULATED_SAMPLES;
+
+	printk_ratelimited(KERN_WARNING
+			"perf interrupt took too long (%lld > %lld), lowering "
+			"kernel.perf_event_max_sample_rate to %d\n",
+			avg_local_sample_len, allowed_ns >> 1,
+			sysctl_perf_event_sample_rate);
+}
+
+static DEFINE_IRQ_WORK(perf_duration_work, perf_duration_warn);
+
+void perf_sample_event_took(u64 sample_len_ns)
+{
 	u64 allowed_ns = ACCESS_ONCE(perf_sample_allowed_ns);
+	u64 avg_local_sample_len;
+	u64 local_samples_len;
 
 	if (allowed_ns == 0)
 		return;
@@ -263,13 +281,14 @@ void perf_sample_event_took(u64 sample_len_ns)
 	sysctl_perf_event_sample_rate = max_samples_per_tick * HZ;
 	perf_sample_period_ns = NSEC_PER_SEC / sysctl_perf_event_sample_rate;
 
-	printk_ratelimited(KERN_WARNING
-			"perf samples too long (%lld > %lld), lowering "
-			"kernel.perf_event_max_sample_rate to %d\n",
-			avg_local_sample_len, allowed_ns,
-			sysctl_perf_event_sample_rate);
-
 	update_perf_cpu_limits();
+
+	if (!irq_work_queue(&perf_duration_work)) {
+		early_printk("perf interrupt took too long (%lld > %lld), lowering "
+			     "kernel.perf_event_max_sample_rate to %d\n",
+			     avg_local_sample_len, allowed_ns >> 1,
+			     sysctl_perf_event_sample_rate);
+	}
 }
 
 static atomic64_t perf_event_id;
@@ -1714,7 +1733,7 @@ group_sched_in(struct perf_event *group_event,
 	       struct perf_event_context *ctx)
 {
 	struct perf_event *event, *partial_group = NULL;
-	struct pmu *pmu = group_event->pmu;
+	struct pmu *pmu = ctx->pmu;
 	u64 now = ctx->time;
 	bool simulate = false;
 
@@ -2563,8 +2582,6 @@ static void perf_branch_stack_sched_in(struct task_struct *prev,
 		if (cpuctx->ctx.nr_branch_stack > 0
 		    && pmu->flush_branch_stack) {
 
-			pmu = cpuctx->ctx.pmu;
-
 			perf_ctx_lock(cpuctx, cpuctx->task_ctx);
 
 			perf_pmu_disable(pmu);
@@ -6294,7 +6311,7 @@ static int perf_event_idx_default(struct perf_event *event)
  * Ensures all contexts with the same task_ctx_nr have the same
  * pmu_cpu_context too.
  */
-static void *find_pmu_context(int ctxn)
+static struct perf_cpu_context __percpu *find_pmu_context(int ctxn)
 {
 	struct pmu *pmu;
 
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 55fcce6..a82170e 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -61,11 +61,11 @@ void __weak arch_irq_work_raise(void)
  *
  * Can be re-enqueued while the callback is still in progress.
  */
-void irq_work_queue(struct irq_work *work)
+bool irq_work_queue(struct irq_work *work)
 {
 	/* Only queue if not already pending */
 	if (!irq_work_claim(work))
-		return;
+		return false;
 
 	/* Queue the entry and raise the IPI if needed. */
 	preempt_disable();
@@ -83,6 +83,8 @@ void irq_work_queue(struct irq_work *work)
 	}
 
 	preempt_enable();
+
+	return true;
 }
 EXPORT_SYMBOL_GPL(irq_work_queue);
 
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index e854f42..c894614 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -31,9 +31,25 @@ static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
 	}
 
 	/* The ftrace function trace is allowed only for root. */
-	if (ftrace_event_is_function(tp_event) &&
-	    perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))
-		return -EPERM;
+	if (ftrace_event_is_function(tp_event)) {
+		if (perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		/*
+		 * We don't allow user space callchains for  function trace
+		 * event, due to issues with page faults while tracing page
+		 * fault handler and its overall trickiness nature.
+		 */
+		if (!p_event->attr.exclude_callchain_user)
+			return -EINVAL;
+
+		/*
+		 * Same reason to disable user stack dump as for user space
+		 * callchains above.
+		 */
+		if (p_event->attr.sample_type & PERF_SAMPLE_STACK_USER)
+			return -EINVAL;
+	}
 
 	/* No tracing, just counting, so no obvious leak */
 	if (!(p_event->attr.sample_type & PERF_SAMPLE_RAW))
diff --git a/tools/include/linux/hash.h b/tools/include/linux/hash.h
new file mode 100644
index 0000000..d026c65
--- /dev/null
+++ b/tools/include/linux/hash.h
@@ -0,0 +1,5 @@
+#include "../../../include/linux/hash.h"
+
+#ifndef _TOOLS_LINUX_HASH_H
+#define _TOOLS_LINUX_HASH_H
+#endif
diff --git a/tools/lib/api/Makefile b/tools/lib/api/Makefile
index ed2f51e..ce00f7e 100644
--- a/tools/lib/api/Makefile
+++ b/tools/lib/api/Makefile
@@ -9,8 +9,10 @@ LIB_H=
 LIB_OBJS=
 
 LIB_H += fs/debugfs.h
+LIB_H += fs/fs.h
 
 LIB_OBJS += $(OUTPUT)fs/debugfs.o
+LIB_OBJS += $(OUTPUT)fs/fs.o
 
 LIBFILE = libapikfs.a
 
diff --git a/tools/perf/util/fs.c b/tools/lib/api/fs/fs.c
similarity index 91%
rename from tools/perf/util/fs.c
rename to tools/lib/api/fs/fs.c
index f5be1f2..5b5eb78 100644
--- a/tools/perf/util/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -1,8 +1,13 @@
+/* TODO merge/factor in debugfs.c here */
 
-/* TODO merge/factor into tools/lib/lk/debugfs.c */
+#include <errno.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/vfs.h>
 
-#include "util.h"
-#include "util/fs.h"
+#include "debugfs.h"
+#include "fs.h"
 
 static const char * const sysfs__fs_known_mountpoints[] = {
 	"/sys",
diff --git a/tools/perf/util/include/linux/magic.h b/tools/lib/api/fs/fs.h
similarity index 50%
rename from tools/perf/util/include/linux/magic.h
rename to tools/lib/api/fs/fs.h
index 07d63cf..cb70495 100644
--- a/tools/perf/util/include/linux/magic.h
+++ b/tools/lib/api/fs/fs.h
@@ -1,9 +1,5 @@
-#ifndef _PERF_LINUX_MAGIC_H_
-#define _PERF_LINUX_MAGIC_H_
-
-#ifndef DEBUGFS_MAGIC
-#define DEBUGFS_MAGIC          0x64626720
-#endif
+#ifndef __API_FS__
+#define __API_FS__
 
 #ifndef SYSFS_MAGIC
 #define SYSFS_MAGIC            0x62656572
@@ -13,4 +9,6 @@
 #define PROC_SUPER_MAGIC       0x9fa0
 #endif
 
-#endif
+const char *sysfs__mountpoint(void);
+const char *procfs__mountpoint(void);
+#endif /* __API_FS__ */
diff --git a/tools/perf/Documentation/perf-mem.txt b/tools/perf/Documentation/perf-mem.txt
index 888d511..1d78a40 100644
--- a/tools/perf/Documentation/perf-mem.txt
+++ b/tools/perf/Documentation/perf-mem.txt
@@ -18,6 +18,10 @@ from it, into perf.data. Perf record options are accepted and are passed through
 "perf mem -t <TYPE> report" displays the result. It invokes perf report with the
 right set of options to display a memory access profile.
 
+Note that on Intel systems the memory latency reported is the use-latency,
+not the pure load (or store latency). Use latency includes any pipeline
+queueing delays in addition to the memory subsystem latency.
+
 OPTIONS
 -------
 <command>...::
diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index b715cb7..1513935 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -136,6 +136,8 @@ Each probe argument follows below syntax.
 'NAME' specifies the name of this argument (optional). You can use the name of local variable, local data structure member (e.g. var->field, var.field2), local array with fixed index (e.g. array[1], var->array[0], var->pointer[2]), or kprobe-tracer argument format (e.g. $retval, %ax, etc). Note that the name of this argument will be set as the last member name if you specify a local data structure member (e.g. field2 for 'var->field1.field2'.)
 'TYPE' casts the type of this argument (optional). If omitted, perf probe automatically set the type based on debuginfo. You can specify 'string' type only for the local variable or structure member which is an array of or a pointer to 'char' or 'unsigned char' type.
 
+On x86 systems %REG is always the short form of the register: for example %AX. %RAX or %EAX is not valid.
+
 LINE SYNTAX
 -----------
 Line range is described by following syntax.
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index f41572d..c0c87c8 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -6,6 +6,7 @@ tools/lib/symbol/kallsyms.c
 tools/lib/symbol/kallsyms.h
 tools/include/asm/bug.h
 tools/include/linux/compiler.h
+tools/include/linux/hash.h
 include/linux/const.h
 include/linux/perf_event.h
 include/linux/rbtree.h
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 7257e7e..50d875d 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -7,6 +7,8 @@ include config/utilities.mak
 
 # Define V to have a more verbose compile.
 #
+# Define VF to have a more verbose feature check output.
+#
 # Define O to save output files in a separate directory.
 #
 # Define ARCH as name of target architecture if you want cross-builds.
@@ -55,6 +57,9 @@ include config/utilities.mak
 # Define NO_LIBAUDIT if you do not want libaudit support
 #
 # Define NO_LIBBIONIC if you do not want bionic support
+#
+# Define NO_LIBDW_DWARF_UNWIND if you do not want libdw support
+# for dwarf backtrace post unwind.
 
 ifeq ($(srctree),)
 srctree := $(patsubst %/,%,$(dir $(shell pwd)))
@@ -208,7 +213,7 @@ LIB_H += ../../include/uapi/linux/perf_event.h
 LIB_H += ../../include/linux/rbtree.h
 LIB_H += ../../include/linux/list.h
 LIB_H += ../../include/uapi/linux/const.h
-LIB_H += ../../include/linux/hash.h
+LIB_H += ../include/linux/hash.h
 LIB_H += ../../include/linux/stringify.h
 LIB_H += util/include/linux/bitmap.h
 LIB_H += util/include/linux/bitops.h
@@ -218,9 +223,7 @@ LIB_H += util/include/linux/ctype.h
 LIB_H += util/include/linux/kernel.h
 LIB_H += util/include/linux/list.h
 LIB_H += util/include/linux/export.h
-LIB_H += util/include/linux/magic.h
 LIB_H += util/include/linux/poison.h
-LIB_H += util/include/linux/prefetch.h
 LIB_H += util/include/linux/rbtree.h
 LIB_H += util/include/linux/rbtree_augmented.h
 LIB_H += util/include/linux/string.h
@@ -244,7 +247,6 @@ LIB_H += util/cache.h
 LIB_H += util/callchain.h
 LIB_H += util/build-id.h
 LIB_H += util/debug.h
-LIB_H += util/fs.h
 LIB_H += util/pmu.h
 LIB_H += util/event.h
 LIB_H += util/evsel.h
@@ -306,7 +308,6 @@ LIB_OBJS += $(OUTPUT)util/annotate.o
 LIB_OBJS += $(OUTPUT)util/build-id.o
 LIB_OBJS += $(OUTPUT)util/config.o
 LIB_OBJS += $(OUTPUT)util/ctype.o
-LIB_OBJS += $(OUTPUT)util/fs.o
 LIB_OBJS += $(OUTPUT)util/pmu.o
 LIB_OBJS += $(OUTPUT)util/environment.o
 LIB_OBJS += $(OUTPUT)util/event.o
@@ -408,6 +409,11 @@ endif
 LIB_OBJS += $(OUTPUT)tests/code-reading.o
 LIB_OBJS += $(OUTPUT)tests/sample-parsing.o
 LIB_OBJS += $(OUTPUT)tests/parse-no-sample-id-all.o
+ifndef NO_DWARF_UNWIND
+ifeq ($(ARCH),x86)
+LIB_OBJS += $(OUTPUT)tests/dwarf-unwind.o
+endif
+endif
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
@@ -420,6 +426,9 @@ BUILTIN_OBJS += $(OUTPUT)bench/mem-memset-x86-64-asm.o
 endif
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memset.o
+BUILTIN_OBJS += $(OUTPUT)bench/futex-hash.o
+BUILTIN_OBJS += $(OUTPUT)bench/futex-wake.o
+BUILTIN_OBJS += $(OUTPUT)bench/futex-requeue.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-diff.o
 BUILTIN_OBJS += $(OUTPUT)builtin-evlist.o
@@ -475,8 +484,13 @@ ifndef NO_DWARF
 endif # NO_DWARF
 endif # NO_LIBELF
 
+ifndef NO_LIBDW_DWARF_UNWIND
+  LIB_OBJS += $(OUTPUT)util/unwind-libdw.o
+  LIB_H += util/unwind-libdw.h
+endif
+
 ifndef NO_LIBUNWIND
-  LIB_OBJS += $(OUTPUT)util/unwind.o
+  LIB_OBJS += $(OUTPUT)util/unwind-libunwind.o
 endif
 LIB_OBJS += $(OUTPUT)tests/keep-tracking.o
 
@@ -533,6 +547,7 @@ ifeq ($(NO_PERF_REGS),0)
   ifeq ($(ARCH),x86)
     LIB_H += arch/x86/include/perf_regs.h
   endif
+  LIB_OBJS += $(OUTPUT)util/perf_regs.o
 endif
 
 ifndef NO_LIBNUMA
@@ -655,6 +670,9 @@ $(OUTPUT)tests/python-use.o: tests/python-use.c $(OUTPUT)PERF-CFLAGS
 		-DPYTHON='"$(PYTHON_WORD)"' \
 		$<
 
+$(OUTPUT)tests/dwarf-unwind.o: tests/dwarf-unwind.c
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -fno-optimize-sibling-calls $<
+
 $(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
@@ -707,9 +725,15 @@ $(patsubst perf-%,%.o,$(PROGRAMS)): $(LIB_H) $(wildcard */*.h)
 # we depend the various files onto their directories.
 DIRECTORY_DEPS = $(LIB_OBJS) $(BUILTIN_OBJS) $(GTK_OBJS)
 DIRECTORY_DEPS += $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h
-$(DIRECTORY_DEPS): | $(sort $(dir $(DIRECTORY_DEPS)))
+# no need to add flex objects, because they depend on bison ones
+DIRECTORY_DEPS += $(OUTPUT)util/parse-events-bison.c
+DIRECTORY_DEPS += $(OUTPUT)util/pmu-bison.c
+
+OUTPUT_DIRECTORIES := $(sort $(dir $(DIRECTORY_DEPS)))
+
+$(DIRECTORY_DEPS): | $(OUTPUT_DIRECTORIES)
 # In the second step, we make a rule to actually create these directories
-$(sort $(dir $(DIRECTORY_DEPS))):
+$(OUTPUT_DIRECTORIES):
 	$(QUIET_MKDIR)$(MKDIR) -p $@ 2>/dev/null
 
 $(LIB_FILE): $(LIB_OBJS)
@@ -886,7 +910,7 @@ config-clean:
 clean: $(LIBTRACEEVENT)-clean $(LIBAPIKFS)-clean config-clean
 	$(call QUIET_CLEAN, core-objs)  $(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS) $(GTK_OBJS)
 	$(call QUIET_CLEAN, core-progs) $(RM) $(ALL_PROGRAMS) perf
-	$(call QUIET_CLEAN, core-gen)   $(RM)  *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope* $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS $(OUTPUT)util/*-bison* $(OUTPUT)util/*-flex*
+	$(call QUIET_CLEAN, core-gen)   $(RM)  *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope* $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS $(OUTPUT)PERF-FEATURES $(OUTPUT)util/*-bison* $(OUTPUT)util/*-flex*
 	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) clean
 	$(python-clean)
 
diff --git a/tools/perf/arch/arm/Makefile b/tools/perf/arch/arm/Makefile
index fe9b61e..67e9b3d 100644
--- a/tools/perf/arch/arm/Makefile
+++ b/tools/perf/arch/arm/Makefile
@@ -3,5 +3,5 @@ PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
 ifndef NO_LIBUNWIND
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind.o
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libunwind.o
 endif
diff --git a/tools/perf/arch/arm/util/unwind.c b/tools/perf/arch/arm/util/unwind-libunwind.c
similarity index 95%
rename from tools/perf/arch/arm/util/unwind.c
rename to tools/perf/arch/arm/util/unwind-libunwind.c
index da3dc95..729ed69 100644
--- a/tools/perf/arch/arm/util/unwind.c
+++ b/tools/perf/arch/arm/util/unwind-libunwind.c
@@ -4,7 +4,7 @@
 #include "perf_regs.h"
 #include "../../util/unwind.h"
 
-int unwind__arch_reg_id(int regnum)
+int libunwind__arch_reg_id(int regnum)
 {
 	switch (regnum) {
 	case UNW_ARM_R0:
diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index 8801fe0..1641542 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -3,7 +3,14 @@ PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
 ifndef NO_LIBUNWIND
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind.o
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libunwind.o
+endif
+ifndef NO_LIBDW_DWARF_UNWIND
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libdw.o
+endif
+ifndef NO_DWARF_UNWIND
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/regs_load.o
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/dwarf-unwind.o
 endif
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/tsc.o
diff --git a/tools/perf/arch/x86/include/perf_regs.h b/tools/perf/arch/x86/include/perf_regs.h
index e84ca76..fc819ca 100644
--- a/tools/perf/arch/x86/include/perf_regs.h
+++ b/tools/perf/arch/x86/include/perf_regs.h
@@ -5,14 +5,20 @@
 #include "../../util/types.h"
 #include <asm/perf_regs.h>
 
+void perf_regs_load(u64 *regs);
+
 #ifndef HAVE_ARCH_X86_64_SUPPORT
 #define PERF_REGS_MASK ((1ULL << PERF_REG_X86_32_MAX) - 1)
+#define PERF_REGS_MAX PERF_REG_X86_32_MAX
+#define PERF_SAMPLE_REGS_ABI PERF_SAMPLE_REGS_ABI_32
 #else
 #define REG_NOSUPPORT ((1ULL << PERF_REG_X86_DS) | \
 		       (1ULL << PERF_REG_X86_ES) | \
 		       (1ULL << PERF_REG_X86_FS) | \
 		       (1ULL << PERF_REG_X86_GS))
 #define PERF_REGS_MASK (((1ULL << PERF_REG_X86_64_MAX) - 1) & ~REG_NOSUPPORT)
+#define PERF_REGS_MAX PERF_REG_X86_64_MAX
+#define PERF_SAMPLE_REGS_ABI PERF_SAMPLE_REGS_ABI_64
 #endif
 #define PERF_REG_IP PERF_REG_X86_IP
 #define PERF_REG_SP PERF_REG_X86_SP
diff --git a/tools/perf/arch/x86/tests/dwarf-unwind.c b/tools/perf/arch/x86/tests/dwarf-unwind.c
new file mode 100644
index 0000000..b602ad9
--- /dev/null
+++ b/tools/perf/arch/x86/tests/dwarf-unwind.c
@@ -0,0 +1,59 @@
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
+	sp = (unsigned long) regs[PERF_REG_X86_SP];
+
+	map = map_groups__find(&thread->mg, MAP__FUNCTION, (u64) sp);
+	if (!map) {
+		pr_debug("failed to get stack map\n");
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
+	buf = malloc(sizeof(u64) * PERF_REGS_MAX);
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
diff --git a/tools/perf/arch/x86/tests/regs_load.S b/tools/perf/arch/x86/tests/regs_load.S
new file mode 100644
index 0000000..99167bf
--- /dev/null
+++ b/tools/perf/arch/x86/tests/regs_load.S
@@ -0,0 +1,92 @@
+
+#include <linux/linkage.h>
+
+#define AX	 0
+#define BX	 1 * 8
+#define CX	 2 * 8
+#define DX	 3 * 8
+#define SI	 4 * 8
+#define DI	 5 * 8
+#define BP	 6 * 8
+#define SP	 7 * 8
+#define IP	 8 * 8
+#define FLAGS	 9 * 8
+#define CS	10 * 8
+#define SS	11 * 8
+#define DS	12 * 8
+#define ES	13 * 8
+#define FS	14 * 8
+#define GS	15 * 8
+#define R8	16 * 8
+#define R9	17 * 8
+#define R10	18 * 8
+#define R11	19 * 8
+#define R12	20 * 8
+#define R13	21 * 8
+#define R14	22 * 8
+#define R15	23 * 8
+
+.text
+#ifdef HAVE_ARCH_X86_64_SUPPORT
+ENTRY(perf_regs_load)
+	movq %rax, AX(%rdi)
+	movq %rbx, BX(%rdi)
+	movq %rcx, CX(%rdi)
+	movq %rdx, DX(%rdi)
+	movq %rsi, SI(%rdi)
+	movq %rdi, DI(%rdi)
+	movq %rbp, BP(%rdi)
+
+	leaq 8(%rsp), %rax /* exclude this call.  */
+	movq %rax, SP(%rdi)
+
+	movq 0(%rsp), %rax
+	movq %rax, IP(%rdi)
+
+	movq $0, FLAGS(%rdi)
+	movq $0, CS(%rdi)
+	movq $0, SS(%rdi)
+	movq $0, DS(%rdi)
+	movq $0, ES(%rdi)
+	movq $0, FS(%rdi)
+	movq $0, GS(%rdi)
+
+	movq %r8,  R8(%rdi)
+	movq %r9,  R9(%rdi)
+	movq %r10, R10(%rdi)
+	movq %r11, R11(%rdi)
+	movq %r12, R12(%rdi)
+	movq %r13, R13(%rdi)
+	movq %r14, R14(%rdi)
+	movq %r15, R15(%rdi)
+	ret
+ENDPROC(perf_regs_load)
+#else
+ENTRY(perf_regs_load)
+	push %edi
+	movl 8(%esp), %edi
+	movl %eax, AX(%edi)
+	movl %ebx, BX(%edi)
+	movl %ecx, CX(%edi)
+	movl %edx, DX(%edi)
+	movl %esi, SI(%edi)
+	pop %eax
+	movl %eax, DI(%edi)
+	movl %ebp, BP(%edi)
+
+	leal 4(%esp), %eax /* exclude this call.  */
+	movl %eax, SP(%edi)
+
+	movl 0(%esp), %eax
+	movl %eax, IP(%edi)
+
+	movl $0, FLAGS(%edi)
+	movl $0, CS(%edi)
+	movl $0, SS(%edi)
+	movl $0, DS(%edi)
+	movl $0, ES(%edi)
+	movl $0, FS(%edi)
+	movl $0, GS(%edi)
+	ret
+ENDPROC(perf_regs_load)
+#endif
diff --git a/tools/perf/arch/x86/util/unwind-libdw.c b/tools/perf/arch/x86/util/unwind-libdw.c
new file mode 100644
index 0000000..c4b7217
--- /dev/null
+++ b/tools/perf/arch/x86/util/unwind-libdw.c
@@ -0,0 +1,51 @@
+#include <elfutils/libdwfl.h>
+#include "../../util/unwind-libdw.h"
+#include "../../util/perf_regs.h"
+
+bool libdw__arch_set_initial_registers(Dwfl_Thread *thread, void *arg)
+{
+	struct unwind_info *ui = arg;
+	struct regs_dump *user_regs = &ui->sample->user_regs;
+	Dwarf_Word dwarf_regs[17];
+	unsigned nregs;
+
+#define REG(r) ({						\
+	Dwarf_Word val = 0;					\
+	perf_reg_value(&val, user_regs, PERF_REG_X86_##r);	\
+	val;							\
+})
+
+	if (user_regs->abi == PERF_SAMPLE_REGS_ABI_32) {
+		dwarf_regs[0] = REG(AX);
+		dwarf_regs[1] = REG(CX);
+		dwarf_regs[2] = REG(DX);
+		dwarf_regs[3] = REG(BX);
+		dwarf_regs[4] = REG(SP);
+		dwarf_regs[5] = REG(BP);
+		dwarf_regs[6] = REG(SI);
+		dwarf_regs[7] = REG(DI);
+		dwarf_regs[8] = REG(IP);
+		nregs = 9;
+	} else {
+		dwarf_regs[0]  = REG(AX);
+		dwarf_regs[1]  = REG(DX);
+		dwarf_regs[2]  = REG(CX);
+		dwarf_regs[3]  = REG(BX);
+		dwarf_regs[4]  = REG(SI);
+		dwarf_regs[5]  = REG(DI);
+		dwarf_regs[6]  = REG(BP);
+		dwarf_regs[7]  = REG(SP);
+		dwarf_regs[8]  = REG(R8);
+		dwarf_regs[9]  = REG(R9);
+		dwarf_regs[10] = REG(R10);
+		dwarf_regs[11] = REG(R11);
+		dwarf_regs[12] = REG(R12);
+		dwarf_regs[13] = REG(R13);
+		dwarf_regs[14] = REG(R14);
+		dwarf_regs[15] = REG(R15);
+		dwarf_regs[16] = REG(IP);
+		nregs = 17;
+	}
+
+	return dwfl_thread_state_registers(thread, 0, nregs, dwarf_regs);
+}
diff --git a/tools/perf/arch/x86/util/unwind.c b/tools/perf/arch/x86/util/unwind-libunwind.c
similarity index 95%
rename from tools/perf/arch/x86/util/unwind.c
rename to tools/perf/arch/x86/util/unwind-libunwind.c
index 456a88c..3261f68 100644
--- a/tools/perf/arch/x86/util/unwind.c
+++ b/tools/perf/arch/x86/util/unwind-libunwind.c
@@ -5,7 +5,7 @@
 #include "../../util/unwind.h"
 
 #ifdef HAVE_ARCH_X86_64_SUPPORT
-int unwind__arch_reg_id(int regnum)
+int libunwind__arch_reg_id(int regnum)
 {
 	int id;
 
@@ -69,7 +69,7 @@ int unwind__arch_reg_id(int regnum)
 	return id;
 }
 #else
-int unwind__arch_reg_id(int regnum)
+int libunwind__arch_reg_id(int regnum)
 {
 	int id;
 
diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index 0fdc852..eba4670 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -31,6 +31,9 @@ extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
 extern int bench_mem_memcpy(int argc, const char **argv,
 			    const char *prefix __maybe_unused);
 extern int bench_mem_memset(int argc, const char **argv, const char *prefix);
+extern int bench_futex_hash(int argc, const char **argv, const char *prefix);
+extern int bench_futex_wake(int argc, const char **argv, const char *prefix);
+extern int bench_futex_requeue(int argc, const char **argv, const char *prefix);
 
 #define BENCH_FORMAT_DEFAULT_STR	"default"
 #define BENCH_FORMAT_DEFAULT		0
diff --git a/tools/perf/bench/futex-hash.c b/tools/perf/bench/futex-hash.c
new file mode 100644
index 0000000..a84206e
--- /dev/null
+++ b/tools/perf/bench/futex-hash.c
@@ -0,0 +1,212 @@
+/*
+ * Copyright (C) 2013  Davidlohr Bueso <davidlohr@hp.com>
+ *
+ * futex-hash: Stress the hell out of the Linux kernel futex uaddr hashing.
+ *
+ * This program is particularly useful for measuring the kernel's futex hash
+ * table/function implementation. In order for it to make sense, use with as
+ * many threads and futexes as possible.
+ */
+
+#include "../perf.h"
+#include "../util/util.h"
+#include "../util/stat.h"
+#include "../util/parse-options.h"
+#include "../util/header.h"
+#include "bench.h"
+#include "futex.h"
+
+#include <err.h>
+#include <stdlib.h>
+#include <sys/time.h>
+#include <pthread.h>
+
+static unsigned int nthreads = 0;
+static unsigned int nsecs    = 10;
+/* amount of futexes per thread */
+static unsigned int nfutexes = 1024;
+static bool fshared = false, done = false, silent = false;
+
+struct timeval start, end, runtime;
+static pthread_mutex_t thread_lock;
+static unsigned int threads_starting;
+static struct stats throughput_stats;
+static pthread_cond_t thread_parent, thread_worker;
+
+struct worker {
+	int tid;
+	u_int32_t *futex;
+	pthread_t thread;
+	unsigned long ops;
+};
+
+static const struct option options[] = {
+	OPT_UINTEGER('t', "threads", &nthreads, "Specify amount of threads"),
+	OPT_UINTEGER('r', "runtime", &nsecs,    "Specify runtime (in seconds)"),
+	OPT_UINTEGER('f', "futexes", &nfutexes, "Specify amount of futexes per threads"),
+	OPT_BOOLEAN( 's', "silent",  &silent,   "Silent mode: do not display data/details"),
+	OPT_BOOLEAN( 'S', "shared",  &fshared,  "Use shared futexes instead of private ones"),
+	OPT_END()
+};
+
+static const char * const bench_futex_hash_usage[] = {
+	"perf bench futex hash <options>",
+	NULL
+};
+
+static void *workerfn(void *arg)
+{
+	int ret;
+	unsigned int i;
+	struct worker *w = (struct worker *) arg;
+
+	pthread_mutex_lock(&thread_lock);
+	threads_starting--;
+	if (!threads_starting)
+		pthread_cond_signal(&thread_parent);
+	pthread_cond_wait(&thread_worker, &thread_lock);
+	pthread_mutex_unlock(&thread_lock);
+
+	do {
+		for (i = 0; i < nfutexes; i++, w->ops++) {
+			/*
+			 * We want the futex calls to fail in order to stress
+			 * the hashing of uaddr and not measure other steps,
+			 * such as internal waitqueue handling, thus enlarging
+			 * the critical region protected by hb->lock.
+			 */
+			ret = futex_wait(&w->futex[i], 1234, NULL,
+					 fshared ? 0 : FUTEX_PRIVATE_FLAG);
+			if (!silent &&
+			    (!ret || errno != EAGAIN || errno != EWOULDBLOCK))
+				warn("Non-expected futex return call");
+		}
+	}  while (!done);
+
+	return NULL;
+}
+
+static void toggle_done(int sig __maybe_unused,
+			siginfo_t *info __maybe_unused,
+			void *uc __maybe_unused)
+{
+	/* inform all threads that we're done for the day */
+	done = true;
+	gettimeofday(&end, NULL);
+	timersub(&end, &start, &runtime);
+}
+
+static void print_summary(void)
+{
+	unsigned long avg = avg_stats(&throughput_stats);
+	double stddev = stddev_stats(&throughput_stats);
+
+	printf("%sAveraged %ld operations/sec (+- %.2f%%), total secs = %d\n",
+	       !silent ? "\n" : "", avg, rel_stddev_stats(stddev, avg),
+	       (int) runtime.tv_sec);
+}
+
+int bench_futex_hash(int argc, const char **argv,
+		     const char *prefix __maybe_unused)
+{
+	int ret = 0;
+	cpu_set_t cpu;
+	struct sigaction act;
+	unsigned int i, ncpus;
+	pthread_attr_t thread_attr;
+	struct worker *worker = NULL;
+
+	argc = parse_options(argc, argv, options, bench_futex_hash_usage, 0);
+	if (argc) {
+		usage_with_options(bench_futex_hash_usage, options);
+		exit(EXIT_FAILURE);
+	}
+
+	ncpus = sysconf(_SC_NPROCESSORS_ONLN);
+
+	sigfillset(&act.sa_mask);
+	act.sa_sigaction = toggle_done;
+	sigaction(SIGINT, &act, NULL);
+
+	if (!nthreads) /* default to the number of CPUs */
+		nthreads = ncpus;
+
+	worker = calloc(nthreads, sizeof(*worker));
+	if (!worker)
+		goto errmem;
+
+	printf("Run summary [PID %d]: %d threads, each operating on %d [%s] futexes for %d secs.\n\n",
+	       getpid(), nthreads, nfutexes, fshared ? "shared":"private", nsecs);
+
+	init_stats(&throughput_stats);
+	pthread_mutex_init(&thread_lock, NULL);
+	pthread_cond_init(&thread_parent, NULL);
+	pthread_cond_init(&thread_worker, NULL);
+
+	threads_starting = nthreads;
+	pthread_attr_init(&thread_attr);
+	gettimeofday(&start, NULL);
+	for (i = 0; i < nthreads; i++) {
+		worker[i].tid = i;
+		worker[i].futex = calloc(nfutexes, sizeof(*worker[i].futex));
+		if (!worker[i].futex)
+			goto errmem;
+
+		CPU_ZERO(&cpu);
+		CPU_SET(i % ncpus, &cpu);
+
+		ret = pthread_attr_setaffinity_np(&thread_attr, sizeof(cpu_set_t), &cpu);
+		if (ret)
+			err(EXIT_FAILURE, "pthread_attr_setaffinity_np");
+
+		ret = pthread_create(&worker[i].thread, &thread_attr, workerfn,
+				     (void *)(struct worker *) &worker[i]);
+		if (ret)
+			err(EXIT_FAILURE, "pthread_create");
+
+	}
+	pthread_attr_destroy(&thread_attr);
+
+	pthread_mutex_lock(&thread_lock);
+	while (threads_starting)
+		pthread_cond_wait(&thread_parent, &thread_lock);
+	pthread_cond_broadcast(&thread_worker);
+	pthread_mutex_unlock(&thread_lock);
+
+	sleep(nsecs);
+	toggle_done(0, NULL, NULL);
+
+	for (i = 0; i < nthreads; i++) {
+		ret = pthread_join(worker[i].thread, NULL);
+		if (ret)
+			err(EXIT_FAILURE, "pthread_join");
+	}
+
+	/* cleanup & report results */
+	pthread_cond_destroy(&thread_parent);
+	pthread_cond_destroy(&thread_worker);
+	pthread_mutex_destroy(&thread_lock);
+
+	for (i = 0; i < nthreads; i++) {
+		unsigned long t = worker[i].ops/runtime.tv_sec;
+		update_stats(&throughput_stats, t);
+		if (!silent) {
+			if (nfutexes == 1)
+				printf("[thread %2d] futex: %p [ %ld ops/sec ]\n",
+				       worker[i].tid, &worker[i].futex[0], t);
+			else
+				printf("[thread %2d] futexes: %p ... %p [ %ld ops/sec ]\n",
+				       worker[i].tid, &worker[i].futex[0],
+				       &worker[i].futex[nfutexes-1], t);
+		}
+
+		free(worker[i].futex);
+	}
+
+	print_summary();
+
+	free(worker);
+	return ret;
+errmem:
+	err(EXIT_FAILURE, "calloc");
+}
diff --git a/tools/perf/bench/futex-requeue.c b/tools/perf/bench/futex-requeue.c
new file mode 100644
index 0000000..a1625587
--- /dev/null
+++ b/tools/perf/bench/futex-requeue.c
@@ -0,0 +1,211 @@
+/*
+ * Copyright (C) 2013  Davidlohr Bueso <davidlohr@hp.com>
+ *
+ * futex-requeue: Block a bunch of threads on futex1 and requeue them
+ *                on futex2, N at a time.
+ *
+ * This program is particularly useful to measure the latency of nthread
+ * requeues without waking up any tasks -- thus mimicking a regular futex_wait.
+ */
+
+#include "../perf.h"
+#include "../util/util.h"
+#include "../util/stat.h"
+#include "../util/parse-options.h"
+#include "../util/header.h"
+#include "bench.h"
+#include "futex.h"
+
+#include <err.h>
+#include <stdlib.h>
+#include <sys/time.h>
+#include <pthread.h>
+
+static u_int32_t futex1 = 0, futex2 = 0;
+
+/*
+ * How many tasks to requeue at a time.
+ * Default to 1 in order to make the kernel work more.
+ */
+static unsigned int nrequeue = 1;
+
+/*
+ * There can be significant variance from run to run,
+ * the more repeats, the more exact the overall avg and
+ * the better idea of the futex latency.
+ */
+static unsigned int repeat = 10;
+
+static pthread_t *worker;
+static bool done = 0, silent = 0;
+static pthread_mutex_t thread_lock;
+static pthread_cond_t thread_parent, thread_worker;
+static struct stats requeuetime_stats, requeued_stats;
+static unsigned int ncpus, threads_starting, nthreads = 0;
+
+static const struct option options[] = {
+	OPT_UINTEGER('t', "threads",  &nthreads, "Specify amount of threads"),
+	OPT_UINTEGER('q', "nrequeue", &nrequeue, "Specify amount of threads to requeue at once"),
+	OPT_UINTEGER('r', "repeat",   &repeat,   "Specify amount of times to repeat the run"),
+	OPT_BOOLEAN( 's', "silent",   &silent,   "Silent mode: do not display data/details"),
+	OPT_END()
+};
+
+static const char * const bench_futex_requeue_usage[] = {
+	"perf bench futex requeue <options>",
+	NULL
+};
+
+static void print_summary(void)
+{
+	double requeuetime_avg = avg_stats(&requeuetime_stats);
+	double requeuetime_stddev = stddev_stats(&requeuetime_stats);
+	unsigned int requeued_avg = avg_stats(&requeued_stats);
+
+	printf("Requeued %d of %d threads in %.4f ms (+-%.2f%%)\n",
+	       requeued_avg,
+	       nthreads,
+	       requeuetime_avg/1e3,
+	       rel_stddev_stats(requeuetime_stddev, requeuetime_avg));
+}
+
+static void *workerfn(void *arg __maybe_unused)
+{
+	pthread_mutex_lock(&thread_lock);
+	threads_starting--;
+	if (!threads_starting)
+		pthread_cond_signal(&thread_parent);
+	pthread_cond_wait(&thread_worker, &thread_lock);
+	pthread_mutex_unlock(&thread_lock);
+
+	futex_wait(&futex1, 0, NULL, FUTEX_PRIVATE_FLAG);
+	return NULL;
+}
+
+static void block_threads(pthread_t *w,
+			  pthread_attr_t thread_attr)
+{
+	cpu_set_t cpu;
+	unsigned int i;
+
+	threads_starting = nthreads;
+
+	/* create and block all threads */
+	for (i = 0; i < nthreads; i++) {
+		CPU_ZERO(&cpu);
+		CPU_SET(i % ncpus, &cpu);
+
+		if (pthread_attr_setaffinity_np(&thread_attr, sizeof(cpu_set_t), &cpu))
+			err(EXIT_FAILURE, "pthread_attr_setaffinity_np");
+
+		if (pthread_create(&w[i], &thread_attr, workerfn, NULL))
+			err(EXIT_FAILURE, "pthread_create");
+	}
+}
+
+static void toggle_done(int sig __maybe_unused,
+			siginfo_t *info __maybe_unused,
+			void *uc __maybe_unused)
+{
+	done = true;
+}
+
+int bench_futex_requeue(int argc, const char **argv,
+			const char *prefix __maybe_unused)
+{
+	int ret = 0;
+	unsigned int i, j;
+	struct sigaction act;
+	pthread_attr_t thread_attr;
+
+	argc = parse_options(argc, argv, options, bench_futex_requeue_usage, 0);
+	if (argc)
+		goto err;
+
+	ncpus = sysconf(_SC_NPROCESSORS_ONLN);
+
+	sigfillset(&act.sa_mask);
+	act.sa_sigaction = toggle_done;
+	sigaction(SIGINT, &act, NULL);
+
+	if (!nthreads)
+		nthreads = ncpus;
+
+	worker = calloc(nthreads, sizeof(*worker));
+	if (!worker)
+		err(EXIT_FAILURE, "calloc");
+
+	printf("Run summary [PID %d]: Requeuing %d threads (from %p to %p), "
+	       "%d at a time.\n\n",
+	       getpid(), nthreads, &futex1, &futex2, nrequeue);
+
+	init_stats(&requeued_stats);
+	init_stats(&requeuetime_stats);
+	pthread_attr_init(&thread_attr);
+	pthread_mutex_init(&thread_lock, NULL);
+	pthread_cond_init(&thread_parent, NULL);
+	pthread_cond_init(&thread_worker, NULL);
+
+	for (j = 0; j < repeat && !done; j++) {
+		unsigned int nrequeued = 0;
+		struct timeval start, end, runtime;
+
+		/* create, launch & block all threads */
+		block_threads(worker, thread_attr);
+
+		/* make sure all threads are already blocked */
+		pthread_mutex_lock(&thread_lock);
+		while (threads_starting)
+			pthread_cond_wait(&thread_parent, &thread_lock);
+		pthread_cond_broadcast(&thread_worker);
+		pthread_mutex_unlock(&thread_lock);
+
+		usleep(100000);
+
+		/* Ok, all threads are patiently blocked, start requeueing */
+		gettimeofday(&start, NULL);
+		for (nrequeued = 0; nrequeued < nthreads; nrequeued += nrequeue)
+			/*
+			 * Do not wakeup any tasks blocked on futex1, allowing
+			 * us to really measure futex_wait functionality.
+			 */
+			futex_cmp_requeue(&futex1, 0, &futex2, 0, nrequeue,
+					  FUTEX_PRIVATE_FLAG);
+		gettimeofday(&end, NULL);
+		timersub(&end, &start, &runtime);
+
+		update_stats(&requeued_stats, nrequeued);
+		update_stats(&requeuetime_stats, runtime.tv_usec);
+
+		if (!silent) {
+			printf("[Run %d]: Requeued %d of %d threads in %.4f ms\n",
+			       j + 1, nrequeued, nthreads, runtime.tv_usec/1e3);
+		}
+
+		/* everybody should be blocked on futex2, wake'em up */
+		nrequeued = futex_wake(&futex2, nthreads, FUTEX_PRIVATE_FLAG);
+		if (nthreads != nrequeued)
+			warnx("couldn't wakeup all tasks (%d/%d)", nrequeued, nthreads);
+
+		for (i = 0; i < nthreads; i++) {
+			ret = pthread_join(worker[i], NULL);
+			if (ret)
+				err(EXIT_FAILURE, "pthread_join");
+		}
+
+	}
+
+	/* cleanup & report results */
+	pthread_cond_destroy(&thread_parent);
+	pthread_cond_destroy(&thread_worker);
+	pthread_mutex_destroy(&thread_lock);
+	pthread_attr_destroy(&thread_attr);
+
+	print_summary();
+
+	free(worker);
+	return ret;
+err:
+	usage_with_options(bench_futex_requeue_usage, options);
+	exit(EXIT_FAILURE);
+}
diff --git a/tools/perf/bench/futex-wake.c b/tools/perf/bench/futex-wake.c
new file mode 100644
index 0000000..d096169
--- /dev/null
+++ b/tools/perf/bench/futex-wake.c
@@ -0,0 +1,201 @@
+/*
+ * Copyright (C) 2013  Davidlohr Bueso <davidlohr@hp.com>
+ *
+ * futex-wake: Block a bunch of threads on a futex and wake'em up, N at a time.
+ *
+ * This program is particularly useful to measure the latency of nthread wakeups
+ * in non-error situations:  all waiters are queued and all wake calls wakeup
+ * one or more tasks, and thus the waitqueue is never empty.
+ */
+
+#include "../perf.h"
+#include "../util/util.h"
+#include "../util/stat.h"
+#include "../util/parse-options.h"
+#include "../util/header.h"
+#include "bench.h"
+#include "futex.h"
+
+#include <err.h>
+#include <stdlib.h>
+#include <sys/time.h>
+#include <pthread.h>
+
+/* all threads will block on the same futex */
+static u_int32_t futex1 = 0;
+
+/*
+ * How many wakeups to do at a time.
+ * Default to 1 in order to make the kernel work more.
+ */
+static unsigned int nwakes = 1;
+
+/*
+ * There can be significant variance from run to run,
+ * the more repeats, the more exact the overall avg and
+ * the better idea of the futex latency.
+ */
+static unsigned int repeat = 10;
+
+pthread_t *worker;
+static bool done = 0, silent = 0;
+static pthread_mutex_t thread_lock;
+static pthread_cond_t thread_parent, thread_worker;
+static struct stats waketime_stats, wakeup_stats;
+static unsigned int ncpus, threads_starting, nthreads = 0;
+
+static const struct option options[] = {
+	OPT_UINTEGER('t', "threads", &nthreads, "Specify amount of threads"),
+	OPT_UINTEGER('w', "nwakes",  &nwakes,   "Specify amount of threads to wake at once"),
+	OPT_UINTEGER('r', "repeat",  &repeat,   "Specify amount of times to repeat the run"),
+	OPT_BOOLEAN( 's', "silent",  &silent,   "Silent mode: do not display data/details"),
+	OPT_END()
+};
+
+static const char * const bench_futex_wake_usage[] = {
+	"perf bench futex wake <options>",
+	NULL
+};
+
+static void *workerfn(void *arg __maybe_unused)
+{
+	pthread_mutex_lock(&thread_lock);
+	threads_starting--;
+	if (!threads_starting)
+		pthread_cond_signal(&thread_parent);
+	pthread_cond_wait(&thread_worker, &thread_lock);
+	pthread_mutex_unlock(&thread_lock);
+
+	futex_wait(&futex1, 0, NULL, FUTEX_PRIVATE_FLAG);
+	return NULL;
+}
+
+static void print_summary(void)
+{
+	double waketime_avg = avg_stats(&waketime_stats);
+	double waketime_stddev = stddev_stats(&waketime_stats);
+	unsigned int wakeup_avg = avg_stats(&wakeup_stats);
+
+	printf("Wokeup %d of %d threads in %.4f ms (+-%.2f%%)\n",
+	       wakeup_avg,
+	       nthreads,
+	       waketime_avg/1e3,
+	       rel_stddev_stats(waketime_stddev, waketime_avg));
+}
+
+static void block_threads(pthread_t *w,
+			  pthread_attr_t thread_attr)
+{
+	cpu_set_t cpu;
+	unsigned int i;
+
+	threads_starting = nthreads;
+
+	/* create and block all threads */
+	for (i = 0; i < nthreads; i++) {
+		CPU_ZERO(&cpu);
+		CPU_SET(i % ncpus, &cpu);
+
+		if (pthread_attr_setaffinity_np(&thread_attr, sizeof(cpu_set_t), &cpu))
+			err(EXIT_FAILURE, "pthread_attr_setaffinity_np");
+
+		if (pthread_create(&w[i], &thread_attr, workerfn, NULL))
+			err(EXIT_FAILURE, "pthread_create");
+	}
+}
+
+static void toggle_done(int sig __maybe_unused,
+			siginfo_t *info __maybe_unused,
+			void *uc __maybe_unused)
+{
+	done = true;
+}
+
+int bench_futex_wake(int argc, const char **argv,
+		     const char *prefix __maybe_unused)
+{
+	int ret = 0;
+	unsigned int i, j;
+	struct sigaction act;
+	pthread_attr_t thread_attr;
+
+	argc = parse_options(argc, argv, options, bench_futex_wake_usage, 0);
+	if (argc) {
+		usage_with_options(bench_futex_wake_usage, options);
+		exit(EXIT_FAILURE);
+	}
+
+	ncpus = sysconf(_SC_NPROCESSORS_ONLN);
+
+	sigfillset(&act.sa_mask);
+	act.sa_sigaction = toggle_done;
+	sigaction(SIGINT, &act, NULL);
+
+	if (!nthreads)
+		nthreads = ncpus;
+
+	worker = calloc(nthreads, sizeof(*worker));
+	if (!worker)
+		err(EXIT_FAILURE, "calloc");
+
+	printf("Run summary [PID %d]: blocking on %d threads (at futex %p), "
+	       "waking up %d at a time.\n\n",
+	       getpid(), nthreads, &futex1, nwakes);
+
+	init_stats(&wakeup_stats);
+	init_stats(&waketime_stats);
+	pthread_attr_init(&thread_attr);
+	pthread_mutex_init(&thread_lock, NULL);
+	pthread_cond_init(&thread_parent, NULL);
+	pthread_cond_init(&thread_worker, NULL);
+
+	for (j = 0; j < repeat && !done; j++) {
+		unsigned int nwoken = 0;
+		struct timeval start, end, runtime;
+
+		/* create, launch & block all threads */
+		block_threads(worker, thread_attr);
+
+		/* make sure all threads are already blocked */
+		pthread_mutex_lock(&thread_lock);
+		while (threads_starting)
+			pthread_cond_wait(&thread_parent, &thread_lock);
+		pthread_cond_broadcast(&thread_worker);
+		pthread_mutex_unlock(&thread_lock);
+
+		usleep(100000);
+
+		/* Ok, all threads are patiently blocked, start waking folks up */
+		gettimeofday(&start, NULL);
+		while (nwoken != nthreads)
+			nwoken += futex_wake(&futex1, nwakes, FUTEX_PRIVATE_FLAG);
+		gettimeofday(&end, NULL);
+		timersub(&end, &start, &runtime);
+
+		update_stats(&wakeup_stats, nwoken);
+		update_stats(&waketime_stats, runtime.tv_usec);
+
+		if (!silent) {
+			printf("[Run %d]: Wokeup %d of %d threads in %.4f ms\n",
+			       j + 1, nwoken, nthreads, runtime.tv_usec/1e3);
+		}
+
+		for (i = 0; i < nthreads; i++) {
+			ret = pthread_join(worker[i], NULL);
+			if (ret)
+				err(EXIT_FAILURE, "pthread_join");
+		}
+
+	}
+
+	/* cleanup & report results */
+	pthread_cond_destroy(&thread_parent);
+	pthread_cond_destroy(&thread_worker);
+	pthread_mutex_destroy(&thread_lock);
+	pthread_attr_destroy(&thread_attr);
+
+	print_summary();
+
+	free(worker);
+	return ret;
+}
diff --git a/tools/perf/bench/futex.h b/tools/perf/bench/futex.h
new file mode 100644
index 0000000..71f2844
--- /dev/null
+++ b/tools/perf/bench/futex.h
@@ -0,0 +1,71 @@
+/*
+ * Glibc independent futex library for testing kernel functionality.
+ * Shamelessly stolen from Darren Hart <dvhltc@us.ibm.com>
+ *    http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.git/
+ */
+
+#ifndef _FUTEX_H
+#define _FUTEX_H
+
+#include <unistd.h>
+#include <sys/syscall.h>
+#include <sys/types.h>
+#include <linux/futex.h>
+
+/**
+ * futex() - SYS_futex syscall wrapper
+ * @uaddr:	address of first futex
+ * @op:		futex op code
+ * @val:	typically expected value of uaddr, but varies by op
+ * @timeout:	typically an absolute struct timespec (except where noted
+ *		otherwise). Overloaded by some ops
+ * @uaddr2:	address of second futex for some ops\
+ * @val3:	varies by op
+ * @opflags:	flags to be bitwise OR'd with op, such as FUTEX_PRIVATE_FLAG
+ *
+ * futex() is used by all the following futex op wrappers. It can also be
+ * used for misuse and abuse testing. Generally, the specific op wrappers
+ * should be used instead. It is a macro instead of an static inline function as
+ * some of the types over overloaded (timeout is used for nr_requeue for
+ * example).
+ *
+ * These argument descriptions are the defaults for all
+ * like-named arguments in the following wrappers except where noted below.
+ */
+#define futex(uaddr, op, val, timeout, uaddr2, val3, opflags) \
+	syscall(SYS_futex, uaddr, op | opflags, val, timeout, uaddr2, val3)
+
+/**
+ * futex_wait() - block on uaddr with optional timeout
+ * @timeout:	relative timeout
+ */
+static inline int
+futex_wait(u_int32_t *uaddr, u_int32_t val, struct timespec *timeout, int opflags)
+{
+	return futex(uaddr, FUTEX_WAIT, val, timeout, NULL, 0, opflags);
+}
+
+/**
+ * futex_wake() - wake one or more tasks blocked on uaddr
+ * @nr_wake:	wake up to this many tasks
+ */
+static inline int
+futex_wake(u_int32_t *uaddr, int nr_wake, int opflags)
+{
+	return futex(uaddr, FUTEX_WAKE, nr_wake, NULL, NULL, 0, opflags);
+}
+
+/**
+* futex_cmp_requeue() - requeue tasks from uaddr to uaddr2
+* @nr_wake:        wake up to this many tasks
+* @nr_requeue:        requeue up to this many tasks
+*/
+static inline int
+futex_cmp_requeue(u_int32_t *uaddr, u_int32_t val, u_int32_t *uaddr2, int nr_wake,
+		 int nr_requeue, int opflags)
+{
+	return futex(uaddr, FUTEX_CMP_REQUEUE, nr_wake, nr_requeue, uaddr2,
+		 val, opflags);
+}
+
+#endif /* _FUTEX_H */
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index e47f90c..f600b74 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -12,6 +12,7 @@
  *  sched ... scheduler and IPC performance
  *  mem   ... memory access performance
  *  numa  ... NUMA scheduling and MM performance
+ *  futex ... Futex performance
  */
 #include "perf.h"
 #include "util/util.h"
@@ -54,6 +55,14 @@ static struct bench mem_benchmarks[] = {
 	{ NULL,		NULL,						NULL			}
 };
 
+static struct bench futex_benchmarks[] = {
+	{ "hash",	"Benchmark for futex hash table",               bench_futex_hash	},
+	{ "wake",	"Benchmark for futex wake calls",               bench_futex_wake	},
+	{ "requeue",	"Benchmark for futex requeue calls",            bench_futex_requeue	},
+	{ "all",	"Test all futex benchmarks",			NULL			},
+	{ NULL,		NULL,						NULL			}
+};
+
 struct collection {
 	const char	*name;
 	const char	*summary;
@@ -61,11 +70,12 @@ struct collection {
 };
 
 static struct collection collections[] = {
-	{ "sched",	"Scheduler and IPC benchmarks",		sched_benchmarks	},
+	{ "sched",	"Scheduler and IPC benchmarks",			sched_benchmarks	},
 	{ "mem",	"Memory access benchmarks",			mem_benchmarks		},
 #ifdef HAVE_LIBNUMA_SUPPORT
 	{ "numa",	"NUMA scheduling and MM benchmarks",		numa_benchmarks		},
 #endif
+	{"futex",       "Futex stressing benchmarks",                   futex_benchmarks        },
 	{ "all",	"All benchmarks",				NULL			},
 	{ NULL,		NULL,						NULL			}
 };
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index a77e312..204fffe 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -952,8 +952,8 @@ static int hpp__entry_global(struct perf_hpp_fmt *_fmt, struct perf_hpp *hpp,
 				 dfmt->header_width, buf);
 }
 
-static int hpp__header(struct perf_hpp_fmt *fmt,
-		       struct perf_hpp *hpp)
+static int hpp__header(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
+		       struct perf_evsel *evsel __maybe_unused)
 {
 	struct diff_hpp_fmt *dfmt =
 		container_of(fmt, struct diff_hpp_fmt, fmt);
@@ -963,7 +963,8 @@ static int hpp__header(struct perf_hpp_fmt *fmt,
 }
 
 static int hpp__width(struct perf_hpp_fmt *fmt,
-		      struct perf_hpp *hpp __maybe_unused)
+		      struct perf_hpp *hpp __maybe_unused,
+		      struct perf_evsel *evsel __maybe_unused)
 {
 	struct diff_hpp_fmt *dfmt =
 		container_of(fmt, struct diff_hpp_fmt, fmt);
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index b346601..3a73875 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -312,7 +312,6 @@ found:
 	sample_sw.period = sample->period;
 	sample_sw.time	 = sample->time;
 	perf_event__synthesize_sample(event_sw, evsel->attr.sample_type,
-				      evsel->attr.sample_regs_user,
 				      evsel->attr.read_format, &sample_sw,
 				      false);
 	build_id__mark_dso_hit(tool, event_sw, &sample_sw, evsel, machine);
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index a735051..21c164b 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1691,17 +1691,15 @@ int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 		OPT_END()
 	};
 
-
-	const char * const kvm_usage[] = {
-		"perf kvm [<options>] {top|record|report|diff|buildid-list|stat}",
-		NULL
-	};
+	const char *const kvm_subcommands[] = { "top", "record", "report", "diff",
+						"buildid-list", "stat", NULL };
+	const char *kvm_usage[] = { NULL, NULL };
 
 	perf_host  = 0;
 	perf_guest = 1;
 
-	argc = parse_options(argc, argv, kvm_options, kvm_usage,
-			PARSE_OPT_STOP_AT_NON_OPTION);
+	argc = parse_options_subcommand(argc, argv, kvm_options, kvm_subcommands, kvm_usage,
+					PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc)
 		usage_with_options(kvm_usage, kvm_options);
 
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 7894888..cdcd4eb 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -268,9 +268,9 @@ static int opt_set_filter(const struct option *opt __maybe_unused,
 	return 0;
 }
 
-static void init_params(void)
+static int init_params(void)
 {
-	line_range__init(&params.line_range);
+	return line_range__init(&params.line_range);
 }
 
 static void cleanup_params(void)
@@ -515,9 +515,11 @@ int cmd_probe(int argc, const char **argv, const char *prefix)
 {
 	int ret;
 
-	init_params();
-	ret = __cmd_probe(argc, argv, prefix);
-	cleanup_params();
+	ret = init_params();
+	if (!ret) {
+		ret = __cmd_probe(argc, argv, prefix);
+		cleanup_params();
+	}
 
 	return ret;
 }
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index af47531..eb524f9 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -649,7 +649,7 @@ error:
 	return ret;
 }
 
-#ifdef HAVE_LIBUNWIND_SUPPORT
+#ifdef HAVE_DWARF_UNWIND_SUPPORT
 static int get_stack_size(char *str, unsigned long *_size)
 {
 	char *endptr;
@@ -675,7 +675,7 @@ static int get_stack_size(char *str, unsigned long *_size)
 	       max_size, str);
 	return -1;
 }
-#endif /* HAVE_LIBUNWIND_SUPPORT */
+#endif /* HAVE_DWARF_UNWIND_SUPPORT */
 
 int record_parse_callchain(const char *arg, struct record_opts *opts)
 {
@@ -704,7 +704,7 @@ int record_parse_callchain(const char *arg, struct record_opts *opts)
 				       "needed for -g fp\n");
 			break;
 
-#ifdef HAVE_LIBUNWIND_SUPPORT
+#ifdef HAVE_DWARF_UNWIND_SUPPORT
 		/* Dwarf style */
 		} else if (!strncmp(name, "dwarf", sizeof("dwarf"))) {
 			const unsigned long default_stack_dump_size = 8192;
@@ -720,7 +720,7 @@ int record_parse_callchain(const char *arg, struct record_opts *opts)
 				ret = get_stack_size(tok, &size);
 				opts->stack_dump_size = size;
 			}
-#endif /* HAVE_LIBUNWIND_SUPPORT */
+#endif /* HAVE_DWARF_UNWIND_SUPPORT */
 		} else {
 			pr_err("callchain: Unknown --call-graph option "
 			       "value: %s\n", arg);
@@ -735,7 +735,9 @@ int record_parse_callchain(const char *arg, struct record_opts *opts)
 
 static void callchain_debug(struct record_opts *opts)
 {
-	pr_debug("callchain: type %d\n", opts->call_graph);
+	static const char *str[CALLCHAIN_MAX] = { "NONE", "FP", "DWARF" };
+
+	pr_debug("callchain: type %s\n", str[opts->call_graph]);
 
 	if (opts->call_graph == CALLCHAIN_DWARF)
 		pr_debug("callchain: stack dump size %d\n",
@@ -749,6 +751,8 @@ int record_parse_callchain_opt(const struct option *opt,
 	struct record_opts *opts = opt->value;
 	int ret;
 
+	opts->call_graph_enabled = !unset;
+
 	/* --no-call-graph */
 	if (unset) {
 		opts->call_graph = CALLCHAIN_NONE;
@@ -769,6 +773,8 @@ int record_callchain_opt(const struct option *opt,
 {
 	struct record_opts *opts = opt->value;
 
+	opts->call_graph_enabled = !unset;
+
 	if (opts->call_graph == CALLCHAIN_NONE)
 		opts->call_graph = CALLCHAIN_FP;
 
@@ -776,6 +782,16 @@ int record_callchain_opt(const struct option *opt,
 	return 0;
 }
 
+static int perf_record_config(const char *var, const char *value, void *cb)
+{
+	struct record *rec = cb;
+
+	if (!strcmp(var, "record.call-graph"))
+		return record_parse_callchain(value, &rec->opts);
+
+	return perf_default_config(var, value, cb);
+}
+
 static const char * const record_usage[] = {
 	"perf record [<options>] [<command>]",
 	"perf record [<options>] -- <command> [<options>]",
@@ -807,7 +823,7 @@ static struct record record = {
 
 #define CALLCHAIN_HELP "setup and enables call-graph (stack chain/backtrace) recording: "
 
-#ifdef HAVE_LIBUNWIND_SUPPORT
+#ifdef HAVE_DWARF_UNWIND_SUPPORT
 const char record_callchain_help[] = CALLCHAIN_HELP "fp dwarf";
 #else
 const char record_callchain_help[] = CALLCHAIN_HELP "fp";
@@ -907,6 +923,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (rec->evlist == NULL)
 		return -ENOMEM;
 
+	perf_config(perf_record_config, rec);
+
 	argc = parse_options(argc, argv, record_options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc && target__none(&rec->opts.target))
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 02f985f..c8f2113 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -75,13 +75,10 @@ static int report__config(const char *var, const char *value, void *cb)
 	return perf_default_config(var, value, cb);
 }
 
-static int report__add_mem_hist_entry(struct perf_tool *tool, struct addr_location *al,
-				      struct perf_sample *sample, struct perf_evsel *evsel,
-				      union perf_event *event)
+static int report__add_mem_hist_entry(struct report *rep, struct addr_location *al,
+				      struct perf_sample *sample, struct perf_evsel *evsel)
 {
-	struct report *rep = container_of(tool, struct report, tool);
 	struct symbol *parent = NULL;
-	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 	struct hist_entry *he;
 	struct mem_info *mi, *mx;
 	uint64_t cost;
@@ -90,7 +87,7 @@ static int report__add_mem_hist_entry(struct perf_tool *tool, struct addr_locati
 	if (err)
 		return err;
 
-	mi = machine__resolve_mem(al->machine, al->thread, sample, cpumode);
+	mi = sample__resolve_mem(sample, al);
 	if (!mi)
 		return -ENOMEM;
 
@@ -131,10 +128,9 @@ out:
 	return err;
 }
 
-static int report__add_branch_hist_entry(struct perf_tool *tool, struct addr_location *al,
+static int report__add_branch_hist_entry(struct report *rep, struct addr_location *al,
 					 struct perf_sample *sample, struct perf_evsel *evsel)
 {
-	struct report *rep = container_of(tool, struct report, tool);
 	struct symbol *parent = NULL;
 	unsigned i;
 	struct hist_entry *he;
@@ -144,8 +140,7 @@ static int report__add_branch_hist_entry(struct perf_tool *tool, struct addr_loc
 	if (err)
 		return err;
 
-	bi = machine__resolve_bstack(al->machine, al->thread,
-				     sample->branch_stack);
+	bi = sample__resolve_bstack(sample, al);
 	if (!bi)
 		return -ENOMEM;
 
@@ -190,10 +185,9 @@ out:
 	return err;
 }
 
-static int report__add_hist_entry(struct perf_tool *tool, struct perf_evsel *evsel,
+static int report__add_hist_entry(struct report *rep, struct perf_evsel *evsel,
 				  struct addr_location *al, struct perf_sample *sample)
 {
-	struct report *rep = container_of(tool, struct report, tool);
 	struct symbol *parent = NULL;
 	struct hist_entry *he;
 	int err = sample__resolve_callchain(sample, &parent, evsel, al, rep->max_stack);
@@ -237,25 +231,25 @@ static int process_sample_event(struct perf_tool *tool,
 		return -1;
 	}
 
-	if (al.filtered || (rep->hide_unresolved && al.sym == NULL))
+	if (rep->hide_unresolved && al.sym == NULL)
 		return 0;
 
 	if (rep->cpu_list && !test_bit(sample->cpu, rep->cpu_bitmap))
 		return 0;
 
 	if (sort__mode == SORT_MODE__BRANCH) {
-		ret = report__add_branch_hist_entry(tool, &al, sample, evsel);
+		ret = report__add_branch_hist_entry(rep, &al, sample, evsel);
 		if (ret < 0)
 			pr_debug("problem adding lbr entry, skipping event\n");
 	} else if (rep->mem_mode == 1) {
-		ret = report__add_mem_hist_entry(tool, &al, sample, evsel, event);
+		ret = report__add_mem_hist_entry(rep, &al, sample, evsel);
 		if (ret < 0)
 			pr_debug("problem adding mem entry, skipping event\n");
 	} else {
 		if (al.map != NULL)
 			al.map->dso->hit = 1;
 
-		ret = report__add_hist_entry(tool, evsel, &al, sample);
+		ret = report__add_hist_entry(rep, evsel, &al, sample);
 		if (ret < 0)
 			pr_debug("problem incrementing symbol period, skipping event\n");
 	}
@@ -934,7 +928,7 @@ repeat:
 	 * so don't allocate extra space that won't be used in the stdio
 	 * implementation.
 	 */
-	if (use_browser == 1 && sort__has_sym) {
+	if (ui__has_annotation()) {
 		symbol_conf.priv_size = sizeof(struct annotation);
 		machines__set_symbol_filter(&session->machines,
 					    symbol__annotate_init);
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 6a76a07..9ac0a49 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1124,7 +1124,7 @@ static void output_lat_thread(struct perf_sched *sched, struct work_atoms *work_
 
 	avg = work_list->total_lat / work_list->nb_atoms;
 
-	printf("|%11.3f ms |%9" PRIu64 " | avg:%9.3f ms | max:%9.3f ms | max at: %9.6f s\n",
+	printf("|%11.3f ms |%9" PRIu64 " | avg:%9.3f ms | max:%9.3f ms | max at: %13.6f s\n",
 	      (double)work_list->total_runtime / 1e6,
 		 work_list->nb_atoms, (double)avg / 1e6,
 		 (double)work_list->max_lat / 1e6,
@@ -1527,9 +1527,9 @@ static int perf_sched__lat(struct perf_sched *sched)
 
 	perf_sched__sort_lat(sched);
 
-	printf("\n ---------------------------------------------------------------------------------------------------------------\n");
-	printf("  Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms | Maximum delay at     |\n");
-	printf(" ---------------------------------------------------------------------------------------------------------------\n");
+	printf("\n -----------------------------------------------------------------------------------------------------------------\n");
+	printf("  Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms | Maximum delay at       |\n");
+	printf(" -----------------------------------------------------------------------------------------------------------------\n");
 
 	next = rb_first(&sched->sorted_atom_root);
 
@@ -1541,7 +1541,7 @@ static int perf_sched__lat(struct perf_sched *sched)
 		next = rb_next(next);
 	}
 
-	printf(" -----------------------------------------------------------------------------------------\n");
+	printf(" -----------------------------------------------------------------------------------------------------------------\n");
 	printf("  TOTAL:                |%11.3f ms |%9" PRIu64 " |\n",
 		(double)sched->all_runtime / 1e6, sched->all_count);
 
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 25526d6..74db256 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -494,7 +494,7 @@ static const char *cat_backtrace(union perf_event *event,
 			continue;
 		}
 
-		tal.filtered = false;
+		tal.filtered = 0;
 		thread__find_addr_location(al.thread, machine, cpumode,
 					   MAP__FUNCTION, ip, &tal);
 
@@ -1238,7 +1238,7 @@ static int timechart__record(struct timechart *tchart, int argc, const char **ar
 	for (i = 0; i < old_power_args_nr; i++)
 		*p++ = strdup(old_power_args[i]);
 
-	for (j = 1; j < (unsigned int)argc; j++)
+	for (j = 0; j < (unsigned int)argc; j++)
 		*p++ = argv[j];
 
 	return cmd_record(rec_argc, rec_argv, NULL);
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 5f989a7..65aaa5b 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -993,6 +993,16 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 	return record_parse_callchain_opt(opt, arg, unset);
 }
 
+static int perf_top_config(const char *var, const char *value, void *cb)
+{
+	struct perf_top *top = cb;
+
+	if (!strcmp(var, "top.call-graph"))
+		return record_parse_callchain(value, &top->record_opts);
+
+	return perf_default_config(var, value, cb);
+}
+
 static int
 parse_percent_limit(const struct option *opt, const char *arg,
 		    int unset __maybe_unused)
@@ -1117,6 +1127,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (top.evlist == NULL)
 		return -ENOMEM;
 
+	perf_config(perf_top_config, &top);
+
 	argc = parse_options(argc, argv, options, top_usage, 0);
 	if (argc)
 		usage_with_options(top_usage, options);
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 0331ea2..c234182 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -59,6 +59,18 @@ ifeq ($(NO_PERF_REGS),0)
   CFLAGS += -DHAVE_PERF_REGS_SUPPORT
 endif
 
+ifndef NO_LIBELF
+  # for linking with debug library, run like:
+  # make DEBUG=1 LIBDW_DIR=/opt/libdw/
+  ifdef LIBDW_DIR
+    LIBDW_CFLAGS  := -I$(LIBDW_DIR)/include
+    LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
+
+    FEATURE_CHECK_CFLAGS-libdw-dwarf-unwind := $(LIBDW_CFLAGS)
+    FEATURE_CHECK_LDFLAGS-libdw-dwarf-unwind := $(LIBDW_LDFLAGS) -ldw
+  endif
+endif
+
 # include ARCH specific config
 -include $(src-perf)/arch/$(ARCH)/Makefile
 
@@ -147,7 +159,35 @@ CORE_FEATURE_TESTS =			\
 	libunwind			\
 	on-exit				\
 	stackprotector-all		\
-	timerfd
+	timerfd				\
+	libdw-dwarf-unwind
+
+LIB_FEATURE_TESTS =			\
+	dwarf				\
+	glibc				\
+	gtk2				\
+	libaudit			\
+	libbfd				\
+	libelf				\
+	libnuma				\
+	libperl				\
+	libpython			\
+	libslang			\
+	libunwind			\
+	libdw-dwarf-unwind
+
+VF_FEATURE_TESTS =			\
+	backtrace			\
+	fortify-source			\
+	gtk2-infobar			\
+	libelf-getphdrnum		\
+	libelf-mmap			\
+	libpython-version		\
+	on-exit				\
+	stackprotector-all		\
+	timerfd				\
+	libunwind-debug-frame		\
+	bionic
 
 # Set FEATURE_CHECK_(C|LD)FLAGS-all for all CORE_FEATURE_TESTS features.
 # If in the future we need per-feature checks/flags for features not
@@ -161,17 +201,6 @@ endef
 $(foreach feat,$(CORE_FEATURE_TESTS),$(call set_test_all_flags,$(feat)))
 
 #
-# So here we detect whether test-all was rebuilt, to be able
-# to skip the print-out of the long features list if the file
-# existed before and after it was built:
-#
-ifeq ($(wildcard $(OUTPUT)config/feature-checks/test-all.bin),)
-  test-all-failed := 1
-else
-  test-all-failed := 0
-endif
-
-#
 # Special fast-path for the 'all features are available' case:
 #
 $(call feature_check,all,$(MSG))
@@ -180,15 +209,6 @@ $(call feature_check,all,$(MSG))
 # Just in case the build freshly failed, make sure we print the
 # feature matrix:
 #
-ifeq ($(feature-all), 0)
-  test-all-failed := 1
-endif
-
-ifeq ($(test-all-failed),1)
-  $(info )
-  $(info Auto-detecting system features:)
-endif
-
 ifeq ($(feature-all), 1)
   #
   # test-all.c passed - just set all the core feature flags to 1:
@@ -199,27 +219,6 @@ else
   $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_check,$(feat)))
 endif
 
-#
-# Print the result of the feature test:
-#
-feature_print = $(eval $(feature_print_code)) $(info $(MSG))
-
-define feature_print_code
-  ifeq ($(feature-$(1)), 1)
-    MSG = $(shell printf '...%30s: [ \033[32mon\033[m  ]' $(1))
-  else
-    MSG = $(shell printf '...%30s: [ \033[31mOFF\033[m ]' $(1))
-  endif
-endef
-
-#
-# Only print out our features if we rebuilt the testcases or if a test failed:
-#
-ifeq ($(test-all-failed), 1)
-  $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_print,$(feat)))
-  $(info )
-endif
-
 ifeq ($(feature-stackprotector-all), 1)
   CFLAGS += -fstack-protector-all
 endif
@@ -264,6 +263,7 @@ ifdef NO_LIBELF
   NO_DWARF := 1
   NO_DEMANGLE := 1
   NO_LIBUNWIND := 1
+  NO_LIBDW_DWARF_UNWIND := 1
 else
   ifeq ($(feature-libelf), 0)
     ifeq ($(feature-glibc), 1)
@@ -282,13 +282,12 @@ else
       msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
     endif
   else
-    # for linking with debug library, run like:
-    # make DEBUG=1 LIBDW_DIR=/opt/libdw/
-    ifdef LIBDW_DIR
-      LIBDW_CFLAGS  := -I$(LIBDW_DIR)/include
-      LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
+    ifndef NO_LIBDW_DWARF_UNWIND
+      ifneq ($(feature-libdw-dwarf-unwind),1)
+        NO_LIBDW_DWARF_UNWIND := 1
+        msg := $(warning No libdw DWARF unwind found, Please install elfutils-devel/libdw-dev >= 0.158 and/or set LIBDW_DIR);
+      endif
     endif
-
     ifneq ($(feature-dwarf), 1)
       msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
       NO_DWARF := 1
@@ -324,25 +323,51 @@ endif # NO_LIBELF
 
 ifndef NO_LIBUNWIND
   ifneq ($(feature-libunwind), 1)
-    msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 1.1);
+    msg := $(warning No libunwind found. Please install libunwind-dev[el] >= 1.1 and/or set LIBUNWIND_DIR);
     NO_LIBUNWIND := 1
+  endif
+endif
+
+dwarf-post-unwind := 1
+dwarf-post-unwind-text := BUG
+
+# setup DWARF post unwinder
+ifdef NO_LIBUNWIND
+  ifdef NO_LIBDW_DWARF_UNWIND
+    msg := $(warning Disabling post unwind, no support found.);
+    dwarf-post-unwind := 0
   else
-    ifeq ($(ARCH),arm)
-      $(call feature_check,libunwind-debug-frame)
-      ifneq ($(feature-libunwind-debug-frame), 1)
-        msg := $(warning No debug_frame support found in libunwind);
-        CFLAGS += -DNO_LIBUNWIND_DEBUG_FRAME
-      endif
-    else
-      # non-ARM has no dwarf_find_debug_frame() function:
+    dwarf-post-unwind-text := libdw
+  endif
+else
+  dwarf-post-unwind-text := libunwind
+  # Enable libunwind support by default.
+  ifndef NO_LIBDW_DWARF_UNWIND
+    NO_LIBDW_DWARF_UNWIND := 1
+  endif
+endif
+
+ifeq ($(dwarf-post-unwind),1)
+  CFLAGS += -DHAVE_DWARF_UNWIND_SUPPORT
+else
+  NO_DWARF_UNWIND := 1
+endif
+
+ifndef NO_LIBUNWIND
+  ifeq ($(ARCH),arm)
+    $(call feature_check,libunwind-debug-frame)
+    ifneq ($(feature-libunwind-debug-frame), 1)
+      msg := $(warning No debug_frame support found in libunwind);
       CFLAGS += -DNO_LIBUNWIND_DEBUG_FRAME
     endif
-
-    CFLAGS += -DHAVE_LIBUNWIND_SUPPORT
-    EXTLIBS += $(LIBUNWIND_LIBS)
-    CFLAGS += $(LIBUNWIND_CFLAGS)
-    LDFLAGS += $(LIBUNWIND_LDFLAGS)
-  endif # ifneq ($(feature-libunwind), 1)
+  else
+    # non-ARM has no dwarf_find_debug_frame() function:
+    CFLAGS += -DNO_LIBUNWIND_DEBUG_FRAME
+  endif
+  CFLAGS  += -DHAVE_LIBUNWIND_SUPPORT
+  EXTLIBS += $(LIBUNWIND_LIBS)
+  CFLAGS  += $(LIBUNWIND_CFLAGS)
+  LDFLAGS += $(LIBUNWIND_LDFLAGS)
 endif
 
 ifndef NO_LIBAUDIT
@@ -602,3 +627,84 @@ ifdef DESTDIR
 plugindir=$(libdir)/traceevent/plugins
 plugindir_SQ= $(subst ','\'',$(plugindir))
 endif
+
+#
+# Print the result of the feature test:
+#
+feature_print_status = $(eval $(feature_print_status_code)) $(info $(MSG))
+
+define feature_print_status_code
+  ifeq ($(feature-$(1)), 1)
+    MSG = $(shell printf '...%30s: [ \033[32mon\033[m  ]' $(1))
+  else
+    MSG = $(shell printf '...%30s: [ \033[31mOFF\033[m ]' $(1))
+  endif
+endef
+
+feature_print_var = $(eval $(feature_print_var_code)) $(info $(MSG))
+define feature_print_var_code
+    MSG = $(shell printf '...%30s: %s' $(1) $($(1)))
+endef
+
+feature_print_text = $(eval $(feature_print_text_code)) $(info $(MSG))
+define feature_print_text_code
+    MSG = $(shell printf '...%30s: %s' $(1) $(2))
+endef
+
+PERF_FEATURES := $(foreach feat,$(LIB_FEATURE_TESTS),feature-$(feat)($(feature-$(feat))))
+PERF_FEATURES_FILE := $(shell touch $(OUTPUT)PERF-FEATURES; cat $(OUTPUT)PERF-FEATURES)
+
+ifeq ($(dwarf-post-unwind),1)
+  PERF_FEATURES += dwarf-post-unwind($(dwarf-post-unwind-text))
+endif
+
+# The $(display_lib) controls the default detection message
+# output. It's set if:
+# - detected features differes from stored features from
+#   last build (in PERF-FEATURES file)
+# - one of the $(LIB_FEATURE_TESTS) is not detected
+# - VF is enabled
+
+ifneq ("$(PERF_FEATURES)","$(PERF_FEATURES_FILE)")
+  $(shell echo "$(PERF_FEATURES)" > $(OUTPUT)PERF-FEATURES)
+  display_lib := 1
+endif
+
+feature_check = $(eval $(feature_check_code))
+define feature_check_code
+  ifneq ($(feature-$(1)), 1)
+    display_lib := 1
+  endif
+endef
+
+$(foreach feat,$(LIB_FEATURE_TESTS),$(call feature_check,$(feat)))
+
+ifeq ($(VF),1)
+  display_lib := 1
+  display_vf := 1
+endif
+
+ifeq ($(display_lib),1)
+  $(info )
+  $(info Auto-detecting system features:)
+  $(foreach feat,$(LIB_FEATURE_TESTS),$(call feature_print_status,$(feat),))
+
+  ifeq ($(dwarf-post-unwind),1)
+    $(call feature_print_text,"DWARF post unwind library", $(dwarf-post-unwind-text))
+  endif
+endif
+
+ifeq ($(display_vf),1)
+  $(foreach feat,$(VF_FEATURE_TESTS),$(call feature_print_status,$(feat),))
+  $(info )
+  $(call feature_print_var,prefix)
+  $(call feature_print_var,bindir)
+  $(call feature_print_var,libdir)
+  $(call feature_print_var,sysconfdir)
+  $(call feature_print_var,LIBUNWIND_DIR)
+  $(call feature_print_var,LIBDW_DIR)
+endif
+
+ifeq ($(display_lib),1)
+  $(info )
+endif
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 523b7bc..2da103c 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -26,7 +26,8 @@ FILES=					\
 	test-libunwind-debug-frame.bin	\
 	test-on-exit.bin		\
 	test-stackprotector-all.bin	\
-	test-timerfd.bin
+	test-timerfd.bin		\
+	test-libdw-dwarf-unwind.bin
 
 CC := $(CROSS_COMPILE)gcc -MD
 PKG_CONFIG := $(CROSS_COMPILE)pkg-config
@@ -141,6 +142,9 @@ test-backtrace.bin:
 test-timerfd.bin:
 	$(BUILD)
 
+test-libdw-dwarf-unwind.bin:
+	$(BUILD)
+
 -include *.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-all.c b/tools/perf/config/feature-checks/test-all.c
index 9b8a544..fc37eb3 100644
--- a/tools/perf/config/feature-checks/test-all.c
+++ b/tools/perf/config/feature-checks/test-all.c
@@ -89,6 +89,10 @@
 # include "test-stackprotector-all.c"
 #undef main
 
+#define main main_test_libdw_dwarf_unwind
+# include "test-libdw-dwarf-unwind.c"
+#undef main
+
 int main(int argc, char *argv[])
 {
 	main_test_libpython();
@@ -111,6 +115,7 @@ int main(int argc, char *argv[])
 	main_test_libnuma();
 	main_test_timerfd();
 	main_test_stackprotector_all();
+	main_test_libdw_dwarf_unwind();
 
 	return 0;
 }
diff --git a/tools/perf/config/feature-checks/test-libdw-dwarf-unwind.c b/tools/perf/config/feature-checks/test-libdw-dwarf-unwind.c
new file mode 100644
index 0000000..f676a3f
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libdw-dwarf-unwind.c
@@ -0,0 +1,13 @@
+
+#include <elfutils/libdwfl.h>
+
+int main(void)
+{
+	/*
+	 * This function is guarded via: __nonnull_attribute__ (1, 2).
+	 * Passing '1' as arguments value. This code is never executed,
+	 * only compiled.
+	 */
+	dwfl_thread_getframes((void *) 1, (void *) 1, NULL);
+	return 0;
+}
diff --git a/tools/perf/design.txt b/tools/perf/design.txt
index 63a0e6f..a28dca2 100644
--- a/tools/perf/design.txt
+++ b/tools/perf/design.txt
@@ -18,7 +18,7 @@ underlying hardware counters.
 Performance counters are accessed via special file descriptors.
 There's one file descriptor per virtual counter used.
 
-The special file descriptor is opened via the perf_event_open()
+The special file descriptor is opened via the sys_perf_event_open()
 system call:
 
    int sys_perf_event_open(struct perf_event_attr *hw_event_uptr,
@@ -82,7 +82,7 @@ machine-specific.
 If 'raw_type' is 0, then the 'type' field says what kind of counter
 this is, with the following encoding:
 
-enum perf_event_types {
+enum perf_type_id {
 	PERF_TYPE_HARDWARE		= 0,
 	PERF_TYPE_SOFTWARE		= 1,
 	PERF_TYPE_TRACEPOINT		= 2,
@@ -95,7 +95,7 @@ specified by 'event_id':
  * Generalized performance counter event types, used by the hw_event.event_id
  * parameter of the sys_perf_event_open() syscall:
  */
-enum hw_event_ids {
+enum perf_hw_id {
 	/*
 	 * Common hardware events, generalized by the kernel:
 	 */
@@ -129,7 +129,7 @@ software events, selected by 'event_id':
  * physical and sw events of the kernel (and allow the profiling of them as
  * well):
  */
-enum sw_event_ids {
+enum perf_sw_ids {
 	PERF_COUNT_SW_CPU_CLOCK		= 0,
 	PERF_COUNT_SW_TASK_CLOCK	= 1,
 	PERF_COUNT_SW_PAGE_FAULTS	= 2,
@@ -230,7 +230,7 @@ these events are recorded in the ring-buffer (see below).
 The 'comm' bit allows tracking of process comm data on process creation.
 This too is recorded in the ring-buffer (see below).
 
-The 'pid' parameter to the perf_event_open() system call allows the
+The 'pid' parameter to the sys_perf_event_open() system call allows the
 counter to be specific to a task:
 
  pid == 0: if the pid parameter is zero, the counter is attached to the
@@ -260,7 +260,7 @@ The 'flags' parameter is currently unused and must be zero.
 
 The 'group_fd' parameter allows counter "groups" to be set up.  A
 counter group has one counter which is the group "leader".  The leader
-is created first, with group_fd = -1 in the perf_event_open call
+is created first, with group_fd = -1 in the sys_perf_event_open call
 that creates it.  The rest of the group members are created
 subsequently, with group_fd giving the fd of the group leader.
 (A single counter on its own is created with group_fd = -1 and is
diff --git a/tools/perf/perf-completion.sh b/tools/perf/perf-completion.sh
index 496e2ab..ae3a576 100644
--- a/tools/perf/perf-completion.sh
+++ b/tools/perf/perf-completion.sh
@@ -123,7 +123,7 @@ __perf_main ()
 		__perfcomp_colon "$evts" "$cur"
 	# List subcommands for 'perf kvm'
 	elif [[ $prev == "kvm" ]]; then
-		subcmds="top record report diff buildid-list stat"
+		subcmds=$($cmd $prev --list-cmds)
 		__perfcomp_colon "$subcmds" "$cur"
 	# List long option names
 	elif [[ $cur == --* ]];  then
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index e84fa26..e18a8b5 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -12,6 +12,9 @@
 #ifndef __NR_perf_event_open
 # define __NR_perf_event_open 336
 #endif
+#ifndef __NR_futex
+# define __NR_futex 240
+#endif
 #endif
 
 #if defined(__x86_64__)
@@ -23,6 +26,9 @@
 #ifndef __NR_perf_event_open
 # define __NR_perf_event_open 298
 #endif
+#ifndef __NR_futex
+# define __NR_futex 202
+#endif
 #endif
 
 #ifdef __powerpc__
@@ -251,12 +257,14 @@ void pthread__unblock_sigwinch(void);
 enum perf_call_graph_mode {
 	CALLCHAIN_NONE,
 	CALLCHAIN_FP,
-	CALLCHAIN_DWARF
+	CALLCHAIN_DWARF,
+	CALLCHAIN_MAX
 };
 
 struct record_opts {
 	struct target target;
 	int	     call_graph;
+	bool         call_graph_enabled;
 	bool	     group;
 	bool	     inherit_stat;
 	bool	     no_buffering;
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 1e67437..b11bf8a 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -115,6 +115,14 @@ static struct test {
 		.desc = "Test parsing with no sample_id_all bit set",
 		.func = test__parse_no_sample_id_all,
 	},
+#if defined(__x86_64__) || defined(__i386__)
+#ifdef HAVE_DWARF_UNWIND_SUPPORT
+	{
+		.desc = "Test dwarf unwind",
+		.func = test__dwarf_unwind,
+	},
+#endif
+#endif
 	{
 		.func = NULL,
 	},
diff --git a/tools/perf/tests/dwarf-unwind.c b/tools/perf/tests/dwarf-unwind.c
new file mode 100644
index 0000000..c059ee8
--- /dev/null
+++ b/tools/perf/tests/dwarf-unwind.c
@@ -0,0 +1,144 @@
+#include <linux/compiler.h>
+#include <sys/types.h>
+#include <unistd.h>
+#include "tests.h"
+#include "debug.h"
+#include "machine.h"
+#include "event.h"
+#include "unwind.h"
+#include "perf_regs.h"
+#include "map.h"
+#include "thread.h"
+
+static int mmap_handler(struct perf_tool *tool __maybe_unused,
+			union perf_event *event,
+			struct perf_sample *sample __maybe_unused,
+			struct machine *machine)
+{
+	return machine__process_mmap_event(machine, event, NULL);
+}
+
+static int init_live_machine(struct machine *machine)
+{
+	union perf_event event;
+	pid_t pid = getpid();
+
+	return perf_event__synthesize_mmap_events(NULL, &event, pid, pid,
+						  mmap_handler, machine, true);
+}
+
+#define MAX_STACK 6
+
+static int unwind_entry(struct unwind_entry *entry, void *arg)
+{
+	unsigned long *cnt = (unsigned long *) arg;
+	char *symbol = entry->sym ? entry->sym->name : NULL;
+	static const char *funcs[MAX_STACK] = {
+		"test__arch_unwind_sample",
+		"unwind_thread",
+		"krava_3",
+		"krava_2",
+		"krava_1",
+		"test__dwarf_unwind"
+	};
+
+	if (*cnt >= MAX_STACK) {
+		pr_debug("failed: crossed the max stack value %d\n", MAX_STACK);
+		return -1;
+	}
+
+	if (!symbol) {
+		pr_debug("failed: got unresolved address 0x%" PRIx64 "\n",
+			 entry->ip);
+		return -1;
+	}
+
+	pr_debug("got: %s 0x%" PRIx64 "\n", symbol, entry->ip);
+	return strcmp((const char *) symbol, funcs[(*cnt)++]);
+}
+
+__attribute__ ((noinline))
+static int unwind_thread(struct thread *thread, struct machine *machine)
+{
+	struct perf_sample sample;
+	unsigned long cnt = 0;
+	int err = -1;
+
+	memset(&sample, 0, sizeof(sample));
+
+	if (test__arch_unwind_sample(&sample, thread)) {
+		pr_debug("failed to get unwind sample\n");
+		goto out;
+	}
+
+	err = unwind__get_entries(unwind_entry, &cnt, machine, thread,
+				  &sample, MAX_STACK);
+	if (err)
+		pr_debug("unwind failed\n");
+	else if (cnt != MAX_STACK) {
+		pr_debug("got wrong number of stack entries %lu != %d\n",
+			 cnt, MAX_STACK);
+		err = -1;
+	}
+
+ out:
+	free(sample.user_stack.data);
+	free(sample.user_regs.regs);
+	return err;
+}
+
+__attribute__ ((noinline))
+static int krava_3(struct thread *thread, struct machine *machine)
+{
+	return unwind_thread(thread, machine);
+}
+
+__attribute__ ((noinline))
+static int krava_2(struct thread *thread, struct machine *machine)
+{
+	return krava_3(thread, machine);
+}
+
+__attribute__ ((noinline))
+static int krava_1(struct thread *thread, struct machine *machine)
+{
+	return krava_2(thread, machine);
+}
+
+int test__dwarf_unwind(void)
+{
+	struct machines machines;
+	struct machine *machine;
+	struct thread *thread;
+	int err = -1;
+
+	machines__init(&machines);
+
+	machine = machines__find(&machines, HOST_KERNEL_ID);
+	if (!machine) {
+		pr_err("Could not get machine\n");
+		return -1;
+	}
+
+	if (init_live_machine(machine)) {
+		pr_err("Could not init machine\n");
+		goto out;
+	}
+
+	if (verbose > 1)
+		machine__fprintf(machine, stderr);
+
+	thread = machine__find_thread(machine, getpid(), getpid());
+	if (!thread) {
+		pr_err("Could not get thread\n");
+		goto out;
+	}
+
+	err = krava_1(thread, machine);
+
+ out:
+	machine__delete_threads(machine);
+	machine__exit(machine);
+	machines__exit(&machines);
+	return err;
+}
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 2b6519e..7ccbc7b 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -101,6 +101,7 @@ static struct machine *setup_fake_machine(struct machines *machines)
 			.mmap = {
 				.header = { .misc = PERF_RECORD_MISC_USER, },
 				.pid = fake_mmap_info[i].pid,
+				.tid = fake_mmap_info[i].pid,
 				.start = fake_mmap_info[i].start,
 				.len = 0x1000ULL,
 				.pgoff = 0ULL,
diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index 00544b8..5daeae1 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -27,6 +27,7 @@ make_no_ui          := NO_NEWT=1 NO_SLANG=1 NO_GTK2=1
 make_no_demangle    := NO_DEMANGLE=1
 make_no_libelf      := NO_LIBELF=1
 make_no_libunwind   := NO_LIBUNWIND=1
+make_no_libdw_dwarf_unwind := NO_LIBDW_DWARF_UNWIND=1
 make_no_backtrace   := NO_BACKTRACE=1
 make_no_libnuma     := NO_LIBNUMA=1
 make_no_libaudit    := NO_LIBAUDIT=1
@@ -35,8 +36,9 @@ make_tags           := tags
 make_cscope         := cscope
 make_help           := help
 make_doc            := doc
-make_perf_o         := perf.o
-make_util_map_o     := util/map.o
+make_perf_o           := perf.o
+make_util_map_o       := util/map.o
+make_util_pmu_bison_o := util/pmu-bison.o
 make_install        := install
 make_install_bin    := install-bin
 make_install_doc    := install-doc
@@ -49,6 +51,7 @@ make_install_pdf    := install-pdf
 make_minimal        := NO_LIBPERL=1 NO_LIBPYTHON=1 NO_NEWT=1 NO_GTK2=1
 make_minimal        += NO_DEMANGLE=1 NO_LIBELF=1 NO_LIBUNWIND=1 NO_BACKTRACE=1
 make_minimal        += NO_LIBNUMA=1 NO_LIBAUDIT=1 NO_LIBBIONIC=1
+make_minimal        += NO_LIBDW_DWARF_UNWIND=1
 
 # $(run) contains all available tests
 run := make_pure
@@ -65,6 +68,7 @@ run += make_no_ui
 run += make_no_demangle
 run += make_no_libelf
 run += make_no_libunwind
+run += make_no_libdw_dwarf_unwind
 run += make_no_backtrace
 run += make_no_libnuma
 run += make_no_libaudit
@@ -73,6 +77,7 @@ run += make_help
 run += make_doc
 run += make_perf_o
 run += make_util_map_o
+run += make_util_pmu_bison_o
 run += make_install
 run += make_install_bin
 # FIXME 'install-*' commented out till they're fixed
@@ -113,8 +118,9 @@ test_make_doc_O  := $(test_ok)
 
 test_make_python_perf_so := test -f $(PERF)/python/perf.so
 
-test_make_perf_o     := test -f $(PERF)/perf.o
-test_make_util_map_o := test -f $(PERF)/util/map.o
+test_make_perf_o           := test -f $(PERF)/perf.o
+test_make_util_map_o       := test -f $(PERF)/util/map.o
+test_make_util_pmu_bison_o := test -f $(PERF)/util/pmu-bison.o
 
 define test_dest_files
   for file in $(1); do				\
@@ -167,13 +173,10 @@ test_make_install_info_O := $(test_ok)
 test_make_install_pdf    := $(test_ok)
 test_make_install_pdf_O  := $(test_ok)
 
-# Kbuild tests only
-#test_make_python_perf_so_O := test -f $$TMP/tools/perf/python/perf.so
-#test_make_perf_o_O         := test -f $$TMP/tools/perf/perf.o
-#test_make_util_map_o_O     := test -f $$TMP/tools/perf/util/map.o
-
-test_make_perf_o_O     := true
-test_make_util_map_o_O := true
+test_make_python_perf_so_O    := test -f $$TMP_O/python/perf.so
+test_make_perf_o_O            := test -f $$TMP_O/perf.o
+test_make_util_map_o_O        := test -f $$TMP_O/util/map.o
+test_make_util_pmu_bison_o_O := test -f $$TMP_O/util/pmu-bison.o
 
 test_default = test -x $(PERF)/perf
 test = $(if $(test_$1),$(test_$1),$(test_default))
diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 4db0ae6..8605ff5 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -2,7 +2,7 @@
 #include "parse-events.h"
 #include "evsel.h"
 #include "evlist.h"
-#include "fs.h"
+#include <api/fs/fs.h>
 #include <api/fs/debugfs.h>
 #include "tests.h"
 #include <linux/hw_breakpoint.h>
diff --git a/tools/perf/tests/sample-parsing.c b/tools/perf/tests/sample-parsing.c
index 1b67720..0014d3c 100644
--- a/tools/perf/tests/sample-parsing.c
+++ b/tools/perf/tests/sample-parsing.c
@@ -22,8 +22,8 @@
 } while (0)
 
 static bool samples_same(const struct perf_sample *s1,
-			 const struct perf_sample *s2, u64 type, u64 regs_user,
-			 u64 read_format)
+			 const struct perf_sample *s2,
+			 u64 type, u64 read_format)
 {
 	size_t i;
 
@@ -95,8 +95,9 @@ static bool samples_same(const struct perf_sample *s1,
 	}
 
 	if (type & PERF_SAMPLE_REGS_USER) {
-		size_t sz = hweight_long(regs_user) * sizeof(u64);
+		size_t sz = hweight_long(s1->user_regs.mask) * sizeof(u64);
 
+		COMP(user_regs.mask);
 		COMP(user_regs.abi);
 		if (s1->user_regs.abi &&
 		    (!s1->user_regs.regs || !s2->user_regs.regs ||
@@ -174,6 +175,7 @@ static int do_test(u64 sample_type, u64 sample_regs_user, u64 read_format)
 		.branch_stack	= &branch_stack.branch_stack,
 		.user_regs	= {
 			.abi	= PERF_SAMPLE_REGS_ABI_64,
+			.mask	= sample_regs_user,
 			.regs	= user_regs,
 		},
 		.user_stack	= {
@@ -201,8 +203,7 @@ static int do_test(u64 sample_type, u64 sample_regs_user, u64 read_format)
 		sample.read.one.id    = 99;
 	}
 
-	sz = perf_event__sample_event_size(&sample, sample_type,
-					   sample_regs_user, read_format);
+	sz = perf_event__sample_event_size(&sample, sample_type, read_format);
 	bufsz = sz + 4096; /* Add a bit for overrun checking */
 	event = malloc(bufsz);
 	if (!event) {
@@ -215,8 +216,7 @@ static int do_test(u64 sample_type, u64 sample_regs_user, u64 read_format)
 	event->header.misc = 0;
 	event->header.size = sz;
 
-	err = perf_event__synthesize_sample(event, sample_type,
-					    sample_regs_user, read_format,
+	err = perf_event__synthesize_sample(event, sample_type, read_format,
 					    &sample, false);
 	if (err) {
 		pr_debug("%s failed for sample_type %#"PRIx64", error %d\n",
@@ -244,8 +244,7 @@ static int do_test(u64 sample_type, u64 sample_regs_user, u64 read_format)
 		goto out_free;
 	}
 
-	if (!samples_same(&sample, &sample_out, sample_type,
-			  sample_regs_user, read_format)) {
+	if (!samples_same(&sample, &sample_out, sample_type, read_format)) {
 		pr_debug("parsing failed for sample_type %#"PRIx64"\n",
 			 sample_type);
 		goto out_free;
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index e0ac713..a24795c 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -40,5 +40,14 @@ int test__code_reading(void);
 int test__sample_parsing(void);
 int test__keep_tracking(void);
 int test__parse_no_sample_id_all(void);
+int test__dwarf_unwind(void);
 
+#if defined(__x86_64__) || defined(__i386__)
+#ifdef HAVE_DWARF_UNWIND_SUPPORT
+struct thread;
+struct perf_sample;
+int test__arch_unwind_sample(struct perf_sample *sample,
+			     struct thread *thread);
+#endif
+#endif
 #endif /* TESTS_H */
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index b720b92..7ec871a 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -587,95 +587,52 @@ struct hpp_arg {
 	bool current_entry;
 };
 
-static int __hpp__color_callchain(struct hpp_arg *arg)
+static int __hpp__overhead_callback(struct perf_hpp *hpp, bool front)
 {
-	if (!symbol_conf.use_callchain)
-		return 0;
-
-	slsmg_printf("%c ", arg->folded_sign);
-	return 2;
-}
-
-static int __hpp__color_fmt(struct perf_hpp *hpp, struct hist_entry *he,
-			    u64 (*get_field)(struct hist_entry *),
-			    int (*callchain_cb)(struct hpp_arg *))
-{
-	int ret = 0;
-	double percent = 0.0;
-	struct hists *hists = he->hists;
 	struct hpp_arg *arg = hpp->ptr;
 
-	if (hists->stats.total_period)
-		percent = 100.0 * get_field(he) / hists->stats.total_period;
-
-	ui_browser__set_percent_color(arg->b, percent, arg->current_entry);
-
-	if (callchain_cb)
-		ret += callchain_cb(arg);
-
-	ret += scnprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
-	slsmg_printf("%s", hpp->buf);
-
-	if (symbol_conf.event_group) {
-		int prev_idx, idx_delta;
-		struct perf_evsel *evsel = hists_to_evsel(hists);
-		struct hist_entry *pair;
-		int nr_members = evsel->nr_members;
-
-		if (nr_members <= 1)
-			goto out;
+	if (arg->current_entry && arg->b->navkeypressed)
+		ui_browser__set_color(arg->b, HE_COLORSET_SELECTED);
+	else
+		ui_browser__set_color(arg->b, HE_COLORSET_NORMAL);
 
-		prev_idx = perf_evsel__group_idx(evsel);
+	if (front) {
+		if (!symbol_conf.use_callchain)
+			return 0;
 
-		list_for_each_entry(pair, &he->pairs.head, pairs.node) {
-			u64 period = get_field(pair);
-			u64 total = pair->hists->stats.total_period;
+		slsmg_printf("%c ", arg->folded_sign);
+		return 2;
+	}
 
-			if (!total)
-				continue;
+	return 0;
+}
 
-			evsel = hists_to_evsel(pair->hists);
-			idx_delta = perf_evsel__group_idx(evsel) - prev_idx - 1;
+static int __hpp__color_callback(struct perf_hpp *hpp, bool front __maybe_unused)
+{
+	struct hpp_arg *arg = hpp->ptr;
 
-			while (idx_delta--) {
-				/*
-				 * zero-fill group members in the middle which
-				 * have no sample
-				 */
-				ui_browser__set_percent_color(arg->b, 0.0,
-							arg->current_entry);
-				ret += scnprintf(hpp->buf, hpp->size,
-						 " %6.2f%%", 0.0);
-				slsmg_printf("%s", hpp->buf);
-			}
+	if (!arg->current_entry || !arg->b->navkeypressed)
+		ui_browser__set_color(arg->b, HE_COLORSET_NORMAL);
+	return 0;
+}
 
-			percent = 100.0 * period / total;
-			ui_browser__set_percent_color(arg->b, percent,
-						      arg->current_entry);
-			ret += scnprintf(hpp->buf, hpp->size,
-					 " %6.2f%%", percent);
-			slsmg_printf("%s", hpp->buf);
+static int __hpp__slsmg_color_printf(struct perf_hpp *hpp, const char *fmt, ...)
+{
+	struct hpp_arg *arg = hpp->ptr;
+	int ret;
+	va_list args;
+	double percent;
 
-			prev_idx = perf_evsel__group_idx(evsel);
-		}
+	va_start(args, fmt);
+	percent = va_arg(args, double);
+	va_end(args);
 
-		idx_delta = nr_members - prev_idx - 1;
+	ui_browser__set_percent_color(arg->b, percent, arg->current_entry);
 
-		while (idx_delta--) {
-			/*
-			 * zero-fill group members at last which have no sample
-			 */
-			ui_browser__set_percent_color(arg->b, 0.0,
-						      arg->current_entry);
-			ret += scnprintf(hpp->buf, hpp->size,
-					 " %6.2f%%", 0.0);
-			slsmg_printf("%s", hpp->buf);
-		}
-	}
-out:
-	if (!arg->current_entry || !arg->b->navkeypressed)
-		ui_browser__set_color(arg->b, HE_COLORSET_NORMAL);
+	ret = scnprintf(hpp->buf, hpp->size, fmt, percent);
+	slsmg_printf("%s", hpp->buf);
 
+	advance_hpp(hpp, ret);
 	return ret;
 }
 
@@ -690,14 +647,15 @@ hist_browser__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,\
 				struct perf_hpp *hpp,			\
 				struct hist_entry *he)			\
 {									\
-	return __hpp__color_fmt(hpp, he, __hpp_get_##_field, _cb);	\
+	return __hpp__fmt(hpp, he, __hpp_get_##_field, _cb, " %6.2f%%",	\
+			  __hpp__slsmg_color_printf, true);		\
 }
 
-__HPP_COLOR_PERCENT_FN(overhead, period, __hpp__color_callchain)
-__HPP_COLOR_PERCENT_FN(overhead_sys, period_sys, NULL)
-__HPP_COLOR_PERCENT_FN(overhead_us, period_us, NULL)
-__HPP_COLOR_PERCENT_FN(overhead_guest_sys, period_guest_sys, NULL)
-__HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us, NULL)
+__HPP_COLOR_PERCENT_FN(overhead, period, __hpp__overhead_callback)
+__HPP_COLOR_PERCENT_FN(overhead_sys, period_sys, __hpp__color_callback)
+__HPP_COLOR_PERCENT_FN(overhead_us, period_us, __hpp__color_callback)
+__HPP_COLOR_PERCENT_FN(overhead_guest_sys, period_guest_sys, __hpp__color_callback)
+__HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us, __hpp__color_callback)
 
 #undef __HPP_COLOR_PERCENT_FN
 
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 5b95c44..e395ef9 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -8,16 +8,24 @@
 
 #define MAX_COLUMNS			32
 
-static int __percent_color_snprintf(char *buf, size_t size, double percent)
+static int __percent_color_snprintf(struct perf_hpp *hpp, const char *fmt, ...)
 {
 	int ret = 0;
+	va_list args;
+	double percent;
 	const char *markup;
+	char *buf = hpp->buf;
+	size_t size = hpp->size;
+
+	va_start(args, fmt);
+	percent = va_arg(args, double);
+	va_end(args);
 
 	markup = perf_gtk__get_percent_color(percent);
 	if (markup)
 		ret += scnprintf(buf, size, markup);
 
-	ret += scnprintf(buf + ret, size - ret, " %6.2f%%", percent);
+	ret += scnprintf(buf + ret, size - ret, fmt, percent);
 
 	if (markup)
 		ret += scnprintf(buf + ret, size - ret, "</span>");
@@ -25,66 +33,6 @@ static int __percent_color_snprintf(char *buf, size_t size, double percent)
 	return ret;
 }
 
-
-static int __hpp__color_fmt(struct perf_hpp *hpp, struct hist_entry *he,
-			    u64 (*get_field)(struct hist_entry *))
-{
-	int ret;
-	double percent = 0.0;
-	struct hists *hists = he->hists;
-	struct perf_evsel *evsel = hists_to_evsel(hists);
-
-	if (hists->stats.total_period)
-		percent = 100.0 * get_field(he) / hists->stats.total_period;
-
-	ret = __percent_color_snprintf(hpp->buf, hpp->size, percent);
-
-	if (perf_evsel__is_group_event(evsel)) {
-		int prev_idx, idx_delta;
-		struct hist_entry *pair;
-		int nr_members = evsel->nr_members;
-
-		prev_idx = perf_evsel__group_idx(evsel);
-
-		list_for_each_entry(pair, &he->pairs.head, pairs.node) {
-			u64 period = get_field(pair);
-			u64 total = pair->hists->stats.total_period;
-
-			evsel = hists_to_evsel(pair->hists);
-			idx_delta = perf_evsel__group_idx(evsel) - prev_idx - 1;
-
-			while (idx_delta--) {
-				/*
-				 * zero-fill group members in the middle which
-				 * have no sample
-				 */
-				ret += __percent_color_snprintf(hpp->buf + ret,
-								hpp->size - ret,
-								0.0);
-			}
-
-			percent = 100.0 * period / total;
-			ret += __percent_color_snprintf(hpp->buf + ret,
-							hpp->size - ret,
-							percent);
-
-			prev_idx = perf_evsel__group_idx(evsel);
-		}
-
-		idx_delta = nr_members - prev_idx - 1;
-
-		while (idx_delta--) {
-			/*
-			 * zero-fill group members at last which have no sample
-			 */
-			ret += __percent_color_snprintf(hpp->buf + ret,
-							hpp->size - ret,
-							0.0);
-		}
-	}
-	return ret;
-}
-
 #define __HPP_COLOR_PERCENT_FN(_type, _field)					\
 static u64 he_get_##_field(struct hist_entry *he)				\
 {										\
@@ -95,7 +43,8 @@ static int perf_gtk__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,
 				       struct perf_hpp *hpp,			\
 				       struct hist_entry *he)			\
 {										\
-	return __hpp__color_fmt(hpp, he, he_get_##_field);			\
+	return __hpp__fmt(hpp, he, he_get_##_field, NULL, " %6.2f%%",		\
+			  __percent_color_snprintf, true);			\
 }
 
 __HPP_COLOR_PERCENT_FN(overhead, period)
@@ -216,7 +165,6 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 	struct perf_hpp hpp = {
 		.buf		= s,
 		.size		= sizeof(s),
-		.ptr		= hists_to_evsel(hists),
 	};
 
 	nr_cols = 0;
@@ -243,7 +191,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 	col_idx = 0;
 
 	perf_hpp__for_each_format(fmt) {
-		fmt->header(fmt, &hpp);
+		fmt->header(fmt, &hpp, hists_to_evsel(hists));
 
 		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
 							    -1, ltrim(s),
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 78f4c92..0f403b8 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -8,16 +8,27 @@
 
 /* hist period print (hpp) functions */
 
-typedef int (*hpp_snprint_fn)(char *buf, size_t size, const char *fmt, ...);
-
-static int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
-		      u64 (*get_field)(struct hist_entry *),
-		      const char *fmt, hpp_snprint_fn print_fn,
-		      bool fmt_percent)
+#define hpp__call_print_fn(hpp, fn, fmt, ...)			\
+({								\
+	int __ret = fn(hpp, fmt, ##__VA_ARGS__);		\
+	advance_hpp(hpp, __ret);				\
+	__ret;							\
+})
+
+int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
+	       hpp_field_fn get_field, hpp_callback_fn callback,
+	       const char *fmt, hpp_snprint_fn print_fn, bool fmt_percent)
 {
-	int ret;
+	int ret = 0;
 	struct hists *hists = he->hists;
 	struct perf_evsel *evsel = hists_to_evsel(hists);
+	char *buf = hpp->buf;
+	size_t size = hpp->size;
+
+	if (callback) {
+		ret = callback(hpp, true);
+		advance_hpp(hpp, ret);
+	}
 
 	if (fmt_percent) {
 		double percent = 0.0;
@@ -26,9 +37,9 @@ static int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 			percent = 100.0 * get_field(he) /
 				  hists->stats.total_period;
 
-		ret = print_fn(hpp->buf, hpp->size, fmt, percent);
+		ret += hpp__call_print_fn(hpp, print_fn, fmt, percent);
 	} else
-		ret = print_fn(hpp->buf, hpp->size, fmt, get_field(he));
+		ret += hpp__call_print_fn(hpp, print_fn, fmt, get_field(he));
 
 	if (perf_evsel__is_group_event(evsel)) {
 		int prev_idx, idx_delta;
@@ -52,16 +63,22 @@ static int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 				 * zero-fill group members in the middle which
 				 * have no sample
 				 */
-				ret += print_fn(hpp->buf + ret, hpp->size - ret,
-						fmt, 0);
+				if (fmt_percent) {
+					ret += hpp__call_print_fn(hpp, print_fn,
+								  fmt, 0.0);
+				} else {
+					ret += hpp__call_print_fn(hpp, print_fn,
+								  fmt, 0ULL);
+				}
 			}
 
-			if (fmt_percent)
-				ret += print_fn(hpp->buf + ret, hpp->size - ret,
-						fmt, 100.0 * period / total);
-			else
-				ret += print_fn(hpp->buf + ret, hpp->size - ret,
-						fmt, period);
+			if (fmt_percent) {
+				ret += hpp__call_print_fn(hpp, print_fn, fmt,
+							  100.0 * period / total);
+			} else {
+				ret += hpp__call_print_fn(hpp, print_fn, fmt,
+							  period);
+			}
 
 			prev_idx = perf_evsel__group_idx(evsel);
 		}
@@ -72,41 +89,87 @@ static int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 			/*
 			 * zero-fill group members at last which have no sample
 			 */
-			ret += print_fn(hpp->buf + ret, hpp->size - ret,
-					fmt, 0);
+			if (fmt_percent) {
+				ret += hpp__call_print_fn(hpp, print_fn,
+							  fmt, 0.0);
+			} else {
+				ret += hpp__call_print_fn(hpp, print_fn,
+							  fmt, 0ULL);
+			}
 		}
 	}
+
+	if (callback) {
+		int __ret = callback(hpp, false);
+
+		advance_hpp(hpp, __ret);
+		ret += __ret;
+	}
+
+	/*
+	 * Restore original buf and size as it's where caller expects
+	 * the result will be saved.
+	 */
+	hpp->buf = buf;
+	hpp->size = size;
+
 	return ret;
 }
 
 #define __HPP_HEADER_FN(_type, _str, _min_width, _unit_width) 		\
 static int hpp__header_##_type(struct perf_hpp_fmt *fmt __maybe_unused,	\
-			       struct perf_hpp *hpp)			\
+			       struct perf_hpp *hpp,			\
+			       struct perf_evsel *evsel)		\
 {									\
 	int len = _min_width;						\
 									\
-	if (symbol_conf.event_group) {					\
-		struct perf_evsel *evsel = hpp->ptr;			\
-									\
+	if (symbol_conf.event_group)					\
 		len = max(len, evsel->nr_members * _unit_width);	\
-	}								\
+									\
 	return scnprintf(hpp->buf, hpp->size, "%*s", len, _str);	\
 }
 
 #define __HPP_WIDTH_FN(_type, _min_width, _unit_width) 			\
 static int hpp__width_##_type(struct perf_hpp_fmt *fmt __maybe_unused,	\
-			      struct perf_hpp *hpp __maybe_unused)	\
+			      struct perf_hpp *hpp __maybe_unused,	\
+			      struct perf_evsel *evsel)			\
 {									\
 	int len = _min_width;						\
 									\
-	if (symbol_conf.event_group) {					\
-		struct perf_evsel *evsel = hpp->ptr;			\
-									\
+	if (symbol_conf.event_group)					\
 		len = max(len, evsel->nr_members * _unit_width);	\
-	}								\
+									\
 	return len;							\
 }
 
+static int hpp_color_scnprintf(struct perf_hpp *hpp, const char *fmt, ...)
+{
+	va_list args;
+	ssize_t ssize = hpp->size;
+	double percent;
+	int ret;
+
+	va_start(args, fmt);
+	percent = va_arg(args, double);
+	ret = value_color_snprintf(hpp->buf, hpp->size, fmt, percent);
+	va_end(args);
+
+	return (ret >= ssize) ? (ssize - 1) : ret;
+}
+
+static int hpp_entry_scnprintf(struct perf_hpp *hpp, const char *fmt, ...)
+{
+	va_list args;
+	ssize_t ssize = hpp->size;
+	int ret;
+
+	va_start(args, fmt);
+	ret = vsnprintf(hpp->buf, hpp->size, fmt, args);
+	va_end(args);
+
+	return (ret >= ssize) ? (ssize - 1) : ret;
+}
+
 #define __HPP_COLOR_PERCENT_FN(_type, _field)					\
 static u64 he_get_##_field(struct hist_entry *he)				\
 {										\
@@ -116,8 +179,8 @@ static u64 he_get_##_field(struct hist_entry *he)				\
 static int hpp__color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,		\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
-	return __hpp__fmt(hpp, he, he_get_##_field, " %6.2f%%",			\
-			  percent_color_snprintf, true);			\
+	return __hpp__fmt(hpp, he, he_get_##_field, NULL, " %6.2f%%",		\
+			  hpp_color_scnprintf, true);				\
 }
 
 #define __HPP_ENTRY_PERCENT_FN(_type, _field)					\
@@ -125,8 +188,8 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
 	const char *fmt = symbol_conf.field_sep ? " %.2f" : " %6.2f%%";		\
-	return __hpp__fmt(hpp, he, he_get_##_field, fmt,			\
-			  scnprintf, true);					\
+	return __hpp__fmt(hpp, he, he_get_##_field, NULL, fmt,			\
+			  hpp_entry_scnprintf, true);				\
 }
 
 #define __HPP_ENTRY_RAW_FN(_type, _field)					\
@@ -139,7 +202,8 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
 	const char *fmt = symbol_conf.field_sep ? " %"PRIu64 : " %11"PRIu64;	\
-	return __hpp__fmt(hpp, he, he_get_raw_##_field, fmt, scnprintf, false);	\
+	return __hpp__fmt(hpp, he, he_get_raw_##_field, NULL, fmt,		\
+			  hpp_entry_scnprintf, false);				\
 }
 
 #define HPP_PERCENT_FNS(_type, _str, _field, _min_width, _unit_width)	\
@@ -263,15 +327,13 @@ unsigned int hists__sort_list_width(struct hists *hists)
 	struct perf_hpp_fmt *fmt;
 	struct sort_entry *se;
 	int i = 0, ret = 0;
-	struct perf_hpp dummy_hpp = {
-		.ptr	= hists_to_evsel(hists),
-	};
+	struct perf_hpp dummy_hpp;
 
 	perf_hpp__for_each_format(fmt) {
 		if (i)
 			ret += 2;
 
-		ret += fmt->width(fmt, &dummy_hpp);
+		ret += fmt->width(fmt, &dummy_hpp, hists_to_evsel(hists));
 	}
 
 	list_for_each_entry(se, &hist_entry__sort_list, list)
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 831fbb7..d59893e 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -306,12 +306,6 @@ static size_t hist_entry__callchain_fprintf(struct hist_entry *he,
 	return hist_entry_callchain__fprintf(he, total_period, left_margin, fp);
 }
 
-static inline void advance_hpp(struct perf_hpp *hpp, int inc)
-{
-	hpp->buf  += inc;
-	hpp->size -= inc;
-}
-
 static int hist_entry__period_snprintf(struct perf_hpp *hpp,
 				       struct hist_entry *he)
 {
@@ -385,7 +379,6 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 	struct perf_hpp dummy_hpp = {
 		.buf	= bf,
 		.size	= sizeof(bf),
-		.ptr	= hists_to_evsel(hists),
 	};
 	bool first = true;
 	size_t linesz;
@@ -404,7 +397,7 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		else
 			first = false;
 
-		fmt->header(fmt, &dummy_hpp);
+		fmt->header(fmt, &dummy_hpp, hists_to_evsel(hists));
 		fprintf(fp, "%s", bf);
 	}
 
@@ -449,7 +442,7 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		else
 			first = false;
 
-		width = fmt->width(fmt, &dummy_hpp);
+		width = fmt->width(fmt, &dummy_hpp, hists_to_evsel(hists));
 		for (i = 0; i < width; i++)
 			fprintf(fp, ".");
 	}
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 3aa555f..809b4c5 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -1236,6 +1236,7 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map,
 	struct dso *dso = map->dso;
 	char *filename;
 	const char *d_filename;
+	const char *evsel_name = perf_evsel__name(evsel);
 	struct annotation *notes = symbol__annotation(sym);
 	struct disasm_line *pos, *queue = NULL;
 	u64 start = map__rip_2objdump(map, sym->start);
@@ -1243,7 +1244,7 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map,
 	int more = 0;
 	u64 len;
 	int width = 8;
-	int namelen;
+	int namelen, evsel_name_len, graph_dotted_len;
 
 	filename = strdup(dso->long_name);
 	if (!filename)
@@ -1256,14 +1257,17 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map,
 
 	len = symbol__size(sym);
 	namelen = strlen(d_filename);
+	evsel_name_len = strlen(evsel_name);
 
 	if (perf_evsel__is_group_event(evsel))
 		width *= evsel->nr_members;
 
-	printf(" %-*.*s|	Source code & Disassembly of %s\n",
-	       width, width, "Percent", d_filename);
-	printf("-%-*.*s-------------------------------------\n",
-	       width+namelen, width+namelen, graph_dotted_line);
+	printf(" %-*.*s|	Source code & Disassembly of %s for %s\n",
+	       width, width, "Percent", d_filename, evsel_name);
+
+	graph_dotted_len = width + namelen + evsel_name_len;
+	printf("-%-*.*s-----------------------------------------\n",
+	       graph_dotted_len, graph_dotted_len, graph_dotted_line);
 
 	if (verbose)
 		symbol__annotate_hits(sym, evsel);
diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index a9b48c4..7fe4994 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -1,5 +1,5 @@
 #include "util.h"
-#include "fs.h"
+#include <api/fs/fs.h>
 #include "../perf.h"
 #include "cpumap.h"
 #include <assert.h>
diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 4045d08..64453d6 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -45,8 +45,8 @@ int dso__read_binary_type_filename(const struct dso *dso,
 			debuglink--;
 		if (*debuglink == '/')
 			debuglink++;
-		filename__read_debuglink(dso->long_name, debuglink,
-					 size - (debuglink - filename));
+		ret = filename__read_debuglink(dso->long_name, debuglink,
+					       size - (debuglink - filename));
 		}
 		break;
 	case DSO_BINARY_TYPE__BUILD_ID_CACHE:
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index cd7d6f0..ab06f1c 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -102,6 +102,16 @@ struct dso {
 	char		 name[0];
 };
 
+/* dso__for_each_symbol - iterate over the symbols of given type
+ *
+ * @dso: the 'struct dso *' in which symbols itereated
+ * @pos: the 'struct symbol *' to use as a loop cursor
+ * @n: the 'struct rb_node *' to use as a temporary storage
+ * @type: the 'enum map_type' type of symbols
+ */
+#define dso__for_each_symbol(dso, pos, n, type)	\
+	symbols__for_each_entry(&(dso)->symbols[(type)], pos, n)
+
 static inline void dso__set_loaded(struct dso *dso, enum map_type type)
 {
 	dso->loaded |= (1 << type);
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index b0f3ca8..9d12aa6 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -1,6 +1,7 @@
 #include <linux/types.h>
 #include "event.h"
 #include "debug.h"
+#include "hist.h"
 #include "machine.h"
 #include "sort.h"
 #include "string.h"
@@ -94,14 +95,10 @@ static pid_t perf_event__get_comm_tgid(pid_t pid, char *comm, size_t len)
 
 static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
 					 union perf_event *event, pid_t pid,
-					 int full,
 					 perf_event__handler_t process,
 					 struct machine *machine)
 {
-	char filename[PATH_MAX];
 	size_t size;
-	DIR *tasks;
-	struct dirent dirent, *next;
 	pid_t tgid;
 
 	memset(&event->comm, 0, sizeof(event->comm));
@@ -124,55 +121,35 @@ static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
 	event->comm.header.size = (sizeof(event->comm) -
 				(sizeof(event->comm.comm) - size) +
 				machine->id_hdr_size);
-	if (!full) {
-		event->comm.tid = pid;
+	event->comm.tid = pid;
 
-		if (process(tool, event, &synth_sample, machine) != 0)
-			return -1;
-
-		goto out;
-	}
-
-	if (machine__is_default_guest(machine))
-		return 0;
-
-	snprintf(filename, sizeof(filename), "%s/proc/%d/task",
-		 machine->root_dir, pid);
-
-	tasks = opendir(filename);
-	if (tasks == NULL) {
-		pr_debug("couldn't open %s\n", filename);
-		return 0;
-	}
+	if (process(tool, event, &synth_sample, machine) != 0)
+		return -1;
 
-	while (!readdir_r(tasks, &dirent, &next) && next) {
-		char *end;
-		pid = strtol(dirent.d_name, &end, 10);
-		if (*end)
-			continue;
+out:
+	return tgid;
+}
 
-		/* already have tgid; jut want to update the comm */
-		(void) perf_event__get_comm_tgid(pid, event->comm.comm,
-					 sizeof(event->comm.comm));
+static int perf_event__synthesize_fork(struct perf_tool *tool,
+				       union perf_event *event, pid_t pid,
+				       pid_t tgid, perf_event__handler_t process,
+				       struct machine *machine)
+{
+	memset(&event->fork, 0, sizeof(event->fork) + machine->id_hdr_size);
 
-		size = strlen(event->comm.comm) + 1;
-		size = PERF_ALIGN(size, sizeof(u64));
-		memset(event->comm.comm + size, 0, machine->id_hdr_size);
-		event->comm.header.size = (sizeof(event->comm) -
-					  (sizeof(event->comm.comm) - size) +
-					  machine->id_hdr_size);
+	/* this is really a clone event but we use fork to synthesize it */
+	event->fork.ppid = tgid;
+	event->fork.ptid = tgid;
+	event->fork.pid  = tgid;
+	event->fork.tid  = pid;
+	event->fork.header.type = PERF_RECORD_FORK;
 
-		event->comm.tid = pid;
+	event->fork.header.size = (sizeof(event->fork) + machine->id_hdr_size);
 
-		if (process(tool, event, &synth_sample, machine) != 0) {
-			tgid = -1;
-			break;
-		}
-	}
+	if (process(tool, event, &synth_sample, machine) != 0)
+		return -1;
 
-	closedir(tasks);
-out:
-	return tgid;
+	return 0;
 }
 
 int perf_event__synthesize_mmap_events(struct perf_tool *tool,
@@ -324,17 +301,71 @@ int perf_event__synthesize_modules(struct perf_tool *tool,
 
 static int __event__synthesize_thread(union perf_event *comm_event,
 				      union perf_event *mmap_event,
+				      union perf_event *fork_event,
 				      pid_t pid, int full,
 					  perf_event__handler_t process,
 				      struct perf_tool *tool,
 				      struct machine *machine, bool mmap_data)
 {
-	pid_t tgid = perf_event__synthesize_comm(tool, comm_event, pid, full,
+	char filename[PATH_MAX];
+	DIR *tasks;
+	struct dirent dirent, *next;
+	pid_t tgid;
+
+	/* special case: only send one comm event using passed in pid */
+	if (!full) {
+		tgid = perf_event__synthesize_comm(tool, comm_event, pid,
+						   process, machine);
+
+		if (tgid == -1)
+			return -1;
+
+		return perf_event__synthesize_mmap_events(tool, mmap_event, pid, tgid,
+							  process, machine, mmap_data);
+	}
+
+	if (machine__is_default_guest(machine))
+		return 0;
+
+	snprintf(filename, sizeof(filename), "%s/proc/%d/task",
+		 machine->root_dir, pid);
+
+	tasks = opendir(filename);
+	if (tasks == NULL) {
+		pr_debug("couldn't open %s\n", filename);
+		return 0;
+	}
+
+	while (!readdir_r(tasks, &dirent, &next) && next) {
+		char *end;
+		int rc = 0;
+		pid_t _pid;
+
+		_pid = strtol(dirent.d_name, &end, 10);
+		if (*end)
+			continue;
+
+		tgid = perf_event__synthesize_comm(tool, comm_event, _pid,
+						   process, machine);
+		if (tgid == -1)
+			return -1;
+
+		if (_pid == pid) {
+			/* process the parent's maps too */
+			rc = perf_event__synthesize_mmap_events(tool, mmap_event, pid, tgid,
+						process, machine, mmap_data);
+		} else {
+			/* only fork the tid's map, to save time */
+			rc = perf_event__synthesize_fork(tool, fork_event, _pid, tgid,
 						 process, machine);
-	if (tgid == -1)
-		return -1;
-	return perf_event__synthesize_mmap_events(tool, mmap_event, pid, tgid,
-						  process, machine, mmap_data);
+		}
+
+		if (rc)
+			return rc;
+	}
+
+	closedir(tasks);
+	return 0;
 }
 
 int perf_event__synthesize_thread_map(struct perf_tool *tool,
@@ -343,7 +374,7 @@ int perf_event__synthesize_thread_map(struct perf_tool *tool,
 				      struct machine *machine,
 				      bool mmap_data)
 {
-	union perf_event *comm_event, *mmap_event;
+	union perf_event *comm_event, *mmap_event, *fork_event;
 	int err = -1, thread, j;
 
 	comm_event = malloc(sizeof(comm_event->comm) + machine->id_hdr_size);
@@ -354,9 +385,14 @@ int perf_event__synthesize_thread_map(struct perf_tool *tool,
 	if (mmap_event == NULL)
 		goto out_free_comm;
 
+	fork_event = malloc(sizeof(fork_event->fork) + machine->id_hdr_size);
+	if (fork_event == NULL)
+		goto out_free_mmap;
+
 	err = 0;
 	for (thread = 0; thread < threads->nr; ++thread) {
 		if (__event__synthesize_thread(comm_event, mmap_event,
+					       fork_event,
 					       threads->map[thread], 0,
 					       process, tool, machine,
 					       mmap_data)) {
@@ -382,6 +418,7 @@ int perf_event__synthesize_thread_map(struct perf_tool *tool,
 			/* if not, generate events for it */
 			if (need_leader &&
 			    __event__synthesize_thread(comm_event, mmap_event,
+						       fork_event,
 						       comm_event->comm.pid, 0,
 						       process, tool, machine,
 						       mmap_data)) {
@@ -390,6 +427,8 @@ int perf_event__synthesize_thread_map(struct perf_tool *tool,
 			}
 		}
 	}
+	free(fork_event);
+out_free_mmap:
 	free(mmap_event);
 out_free_comm:
 	free(comm_event);
@@ -404,9 +443,12 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 	DIR *proc;
 	char proc_path[PATH_MAX];
 	struct dirent dirent, *next;
-	union perf_event *comm_event, *mmap_event;
+	union perf_event *comm_event, *mmap_event, *fork_event;
 	int err = -1;
 
+	if (machine__is_default_guest(machine))
+		return 0;
+
 	comm_event = malloc(sizeof(comm_event->comm) + machine->id_hdr_size);
 	if (comm_event == NULL)
 		goto out;
@@ -415,14 +457,15 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 	if (mmap_event == NULL)
 		goto out_free_comm;
 
-	if (machine__is_default_guest(machine))
-		return 0;
+	fork_event = malloc(sizeof(fork_event->fork) + machine->id_hdr_size);
+	if (fork_event == NULL)
+		goto out_free_mmap;
 
 	snprintf(proc_path, sizeof(proc_path), "%s/proc", machine->root_dir);
 	proc = opendir(proc_path);
 
 	if (proc == NULL)
-		goto out_free_mmap;
+		goto out_free_fork;
 
 	while (!readdir_r(proc, &dirent, &next) && next) {
 		char *end;
@@ -434,12 +477,14 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
  		 * We may race with exiting thread, so don't stop just because
  		 * one thread couldn't be synthesized.
  		 */
-		__event__synthesize_thread(comm_event, mmap_event, pid, 1,
-					   process, tool, machine, mmap_data);
+		__event__synthesize_thread(comm_event, mmap_event, fork_event, pid,
+					   1, process, tool, machine, mmap_data);
 	}
 
 	err = 0;
 	closedir(proc);
+out_free_fork:
+	free(fork_event);
 out_free_mmap:
 	free(mmap_event);
 out_free_comm:
@@ -661,7 +706,7 @@ void thread__find_addr_map(struct thread *thread,
 	al->thread = thread;
 	al->addr = addr;
 	al->cpumode = cpumode;
-	al->filtered = false;
+	al->filtered = 0;
 
 	if (machine == NULL) {
 		al->map = NULL;
@@ -687,11 +732,11 @@ void thread__find_addr_map(struct thread *thread,
 		if ((cpumode == PERF_RECORD_MISC_GUEST_USER ||
 			cpumode == PERF_RECORD_MISC_GUEST_KERNEL) &&
 			!perf_guest)
-			al->filtered = true;
+			al->filtered |= (1 << HIST_FILTER__GUEST);
 		if ((cpumode == PERF_RECORD_MISC_USER ||
 			cpumode == PERF_RECORD_MISC_KERNEL) &&
 			!perf_host)
-			al->filtered = true;
+			al->filtered |= (1 << HIST_FILTER__HOST);
 
 		return;
 	}
@@ -748,9 +793,6 @@ int perf_event__preprocess_sample(const union perf_event *event,
 	if (thread == NULL)
 		return -1;
 
-	if (thread__is_filtered(thread))
-		goto out_filtered;
-
 	dump_printf(" ... thread: %s:%d\n", thread__comm_str(thread), thread->tid);
 	/*
 	 * Have we already created the kernel maps for this machine?
@@ -768,6 +810,10 @@ int perf_event__preprocess_sample(const union perf_event *event,
 	dump_printf(" ...... dso: %s\n",
 		    al->map ? al->map->dso->long_name :
 			al->level == 'H' ? "[hypervisor]" : "<not found>");
+
+	if (thread__is_filtered(thread))
+		al->filtered |= (1 << HIST_FILTER__THREAD);
+
 	al->sym = NULL;
 	al->cpu = sample->cpu;
 
@@ -779,8 +825,9 @@ int perf_event__preprocess_sample(const union perf_event *event,
 						  dso->short_name) ||
 			       (dso->short_name != dso->long_name &&
 				strlist__has_entry(symbol_conf.dso_list,
-						   dso->long_name)))))
-			goto out_filtered;
+						   dso->long_name))))) {
+			al->filtered |= (1 << HIST_FILTER__DSO);
+		}
 
 		al->sym = map__find_symbol(al->map, al->addr,
 					   machine->symbol_filter);
@@ -788,12 +835,9 @@ int perf_event__preprocess_sample(const union perf_event *event,
 
 	if (symbol_conf.sym_list &&
 		(!al->sym || !strlist__has_entry(symbol_conf.sym_list,
-						al->sym->name)))
-		goto out_filtered;
-
-	return 0;
+						al->sym->name))) {
+		al->filtered |= (1 << HIST_FILTER__SYMBOL);
+	}
 
-out_filtered:
-	al->filtered = true;
 	return 0;
 }
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 851fa06..38457d4 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -85,6 +85,7 @@ struct sample_event {
 
 struct regs_dump {
 	u64 abi;
+	u64 mask;
 	u64 *regs;
 };
 
@@ -259,9 +260,9 @@ int perf_event__preprocess_sample(const union perf_event *event,
 const char *perf_event__name(unsigned int id);
 
 size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
-				     u64 sample_regs_user, u64 read_format);
+				     u64 read_format);
 int perf_event__synthesize_sample(union perf_event *event, u64 type,
-				  u64 sample_regs_user, u64 read_format,
+				  u64 read_format,
 				  const struct perf_sample *sample,
 				  bool swapped);
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 55407c5..5c28d82 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -500,6 +500,34 @@ int perf_evsel__group_desc(struct perf_evsel *evsel, char *buf, size_t size)
 	return ret;
 }
 
+static void
+perf_evsel__config_callgraph(struct perf_evsel *evsel,
+			     struct record_opts *opts)
+{
+	bool function = perf_evsel__is_function_event(evsel);
+	struct perf_event_attr *attr = &evsel->attr;
+
+	perf_evsel__set_sample_bit(evsel, CALLCHAIN);
+
+	if (opts->call_graph == CALLCHAIN_DWARF) {
+		if (!function) {
+			perf_evsel__set_sample_bit(evsel, REGS_USER);
+			perf_evsel__set_sample_bit(evsel, STACK_USER);
+			attr->sample_regs_user = PERF_REGS_MASK;
+			attr->sample_stack_user = opts->stack_dump_size;
+			attr->exclude_callchain_user = 1;
+		} else {
+			pr_info("Cannot use DWARF unwind for function trace event,"
+				" falling back to framepointers.\n");
+		}
+	}
+
+	if (function) {
+		pr_info("Disabling user space callchains for function trace event.\n");
+		attr->exclude_callchain_user = 1;
+	}
+}
+
 /*
  * The enable_on_exec/disabled value strategy:
  *
@@ -595,17 +623,8 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 		attr->mmap_data = track;
 	}
 
-	if (opts->call_graph) {
-		perf_evsel__set_sample_bit(evsel, CALLCHAIN);
-
-		if (opts->call_graph == CALLCHAIN_DWARF) {
-			perf_evsel__set_sample_bit(evsel, REGS_USER);
-			perf_evsel__set_sample_bit(evsel, STACK_USER);
-			attr->sample_regs_user = PERF_REGS_MASK;
-			attr->sample_stack_user = opts->stack_dump_size;
-			attr->exclude_callchain_user = 1;
-		}
-	}
+	if (opts->call_graph_enabled)
+		perf_evsel__config_callgraph(evsel, opts);
 
 	if (target__has_cpu(&opts->target))
 		perf_evsel__set_sample_bit(evsel, CPU);
@@ -1004,7 +1023,7 @@ retry_sample_id:
 
 			group_fd = get_group_fd(evsel, cpu, thread);
 retry_open:
-			pr_debug2("perf_event_open: pid %d  cpu %d  group_fd %d  flags %#lx\n",
+			pr_debug2("sys_perf_event_open: pid %d  cpu %d  group_fd %d  flags %#lx\n",
 				  pid, cpus->map[cpu], group_fd, flags);
 
 			FD(evsel, cpu, thread) = sys_perf_event_open(&evsel->attr,
@@ -1013,7 +1032,7 @@ retry_open:
 								     group_fd, flags);
 			if (FD(evsel, cpu, thread) < 0) {
 				err = -errno;
-				pr_debug2("perf_event_open failed, error %d\n",
+				pr_debug2("sys_perf_event_open failed, error %d\n",
 					  err);
 				goto try_fallback;
 			}
@@ -1220,7 +1239,7 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 	memset(data, 0, sizeof(*data));
 	data->cpu = data->pid = data->tid = -1;
 	data->stream_id = data->id = data->time = -1ULL;
-	data->period = 1;
+	data->period = evsel->attr.sample_period;
 	data->weight = 0;
 
 	if (event->header.type != PERF_RECORD_SAMPLE) {
@@ -1396,10 +1415,11 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 		array++;
 
 		if (data->user_regs.abi) {
-			u64 regs_user = evsel->attr.sample_regs_user;
+			u64 mask = evsel->attr.sample_regs_user;
 
-			sz = hweight_long(regs_user) * sizeof(u64);
+			sz = hweight_long(mask) * sizeof(u64);
 			OVERFLOW_CHECK(array, sz, max_size);
+			data->user_regs.mask = mask;
 			data->user_regs.regs = (u64 *)array;
 			array = (void *)array + sz;
 		}
@@ -1451,7 +1471,7 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 }
 
 size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
-				     u64 sample_regs_user, u64 read_format)
+				     u64 read_format)
 {
 	size_t sz, result = sizeof(struct sample_event);
 
@@ -1517,7 +1537,7 @@ size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
 	if (type & PERF_SAMPLE_REGS_USER) {
 		if (sample->user_regs.abi) {
 			result += sizeof(u64);
-			sz = hweight_long(sample_regs_user) * sizeof(u64);
+			sz = hweight_long(sample->user_regs.mask) * sizeof(u64);
 			result += sz;
 		} else {
 			result += sizeof(u64);
@@ -1546,7 +1566,7 @@ size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
 }
 
 int perf_event__synthesize_sample(union perf_event *event, u64 type,
-				  u64 sample_regs_user, u64 read_format,
+				  u64 read_format,
 				  const struct perf_sample *sample,
 				  bool swapped)
 {
@@ -1687,7 +1707,7 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 	if (type & PERF_SAMPLE_REGS_USER) {
 		if (sample->user_regs.abi) {
 			*array++ = sample->user_regs.abi;
-			sz = hweight_long(sample_regs_user) * sizeof(u64);
+			sz = hweight_long(sample->user_regs.mask) * sizeof(u64);
 			memcpy(array, sample->user_regs.regs, sz);
 			array = (void *)array + sz;
 		} else {
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index f1b3256..0c9926c 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -315,6 +315,24 @@ static inline bool perf_evsel__is_group_event(struct perf_evsel *evsel)
 	return perf_evsel__is_group_leader(evsel) && evsel->nr_members > 1;
 }
 
+/**
+ * perf_evsel__is_function_event - Return whether given evsel is a function
+ * trace event
+ *
+ * @evsel - evsel selector to be tested
+ *
+ * Return %true if event is function trace event
+ */
+static inline bool perf_evsel__is_function_event(struct perf_evsel *evsel)
+{
+#define FUNCTION_EVENT "ftrace:function"
+
+	return evsel->name &&
+	       !strncmp(FUNCTION_EVENT, evsel->name, sizeof(FUNCTION_EVENT));
+
+#undef FUNCTION_EVENT
+}
+
 struct perf_attr_details {
 	bool freq;
 	bool verbose;
diff --git a/tools/perf/util/fs.h b/tools/perf/util/fs.h
deleted file mode 100644
index 5e09ce1..0000000
--- a/tools/perf/util/fs.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef __PERF_FS
-#define __PERF_FS
-
-const char *sysfs__mountpoint(void);
-const char *procfs__mountpoint(void);
-
-#endif /* __PERF_FS */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index e4e6249..f38590d 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -13,13 +13,6 @@ static bool hists__filter_entry_by_thread(struct hists *hists,
 static bool hists__filter_entry_by_symbol(struct hists *hists,
 					  struct hist_entry *he);
 
-enum hist_filter {
-	HIST_FILTER__DSO,
-	HIST_FILTER__THREAD,
-	HIST_FILTER__PARENT,
-	HIST_FILTER__SYMBOL,
-};
-
 struct callchain_param	callchain_param = {
 	.mode	= CHAIN_GRAPH_REL,
 	.min_percent = 0.5,
@@ -290,7 +283,7 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 		if (he->branch_info) {
 			/*
 			 * This branch info is (a part of) allocated from
-			 * machine__resolve_bstack() and will be freed after
+			 * sample__resolve_bstack() and will be freed after
 			 * adding new entries.  So we need to save a copy.
 			 */
 			he->branch_info = malloc(sizeof(*he->branch_info));
@@ -369,7 +362,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 			he_stat__add_period(&he->stat, period, weight);
 
 			/*
-			 * This mem info was allocated from machine__resolve_mem
+			 * This mem info was allocated from sample__resolve_mem
 			 * and will not be used anymore.
 			 */
 			zfree(&entry->mem_info);
@@ -429,7 +422,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 			.weight = weight,
 		},
 		.parent = sym_parent,
-		.filtered = symbol__parent_filter(sym_parent),
+		.filtered = symbol__parent_filter(sym_parent) | al->filtered,
 		.hists	= hists,
 		.branch_info = bi,
 		.mem_info = mi,
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index a59743f..1f1f513 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -14,6 +14,15 @@ struct hist_entry;
 struct addr_location;
 struct symbol;
 
+enum hist_filter {
+	HIST_FILTER__DSO,
+	HIST_FILTER__THREAD,
+	HIST_FILTER__PARENT,
+	HIST_FILTER__SYMBOL,
+	HIST_FILTER__GUEST,
+	HIST_FILTER__HOST,
+};
+
 /*
  * The kernel collects the number of events it couldn't send in a stretch and
  * when possible sends this number in a PERF_RECORD_LOST event. The number of
@@ -132,8 +141,10 @@ struct perf_hpp {
 };
 
 struct perf_hpp_fmt {
-	int (*header)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp);
-	int (*width)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp);
+	int (*header)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
+		      struct perf_evsel *evsel);
+	int (*width)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
+		     struct perf_evsel *evsel);
 	int (*color)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
 		     struct hist_entry *he);
 	int (*entry)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
@@ -166,6 +177,20 @@ void perf_hpp__init(void);
 void perf_hpp__column_register(struct perf_hpp_fmt *format);
 void perf_hpp__column_enable(unsigned col);
 
+typedef u64 (*hpp_field_fn)(struct hist_entry *he);
+typedef int (*hpp_callback_fn)(struct perf_hpp *hpp, bool front);
+typedef int (*hpp_snprint_fn)(struct perf_hpp *hpp, const char *fmt, ...);
+
+int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
+	       hpp_field_fn get_field, hpp_callback_fn callback,
+	       const char *fmt, hpp_snprint_fn print_fn, bool fmt_percent);
+
+static inline void advance_hpp(struct perf_hpp *hpp, int inc)
+{
+	hpp->buf  += inc;
+	hpp->size -= inc;
+}
+
 static inline size_t perf_hpp__use_color(void)
 {
 	return !symbol_conf.field_sep;
diff --git a/tools/perf/util/include/linux/hash.h b/tools/perf/util/include/linux/hash.h
deleted file mode 100644
index 201f573..0000000
--- a/tools/perf/util/include/linux/hash.h
+++ /dev/null
@@ -1,5 +0,0 @@
-#include "../../../../include/linux/hash.h"
-
-#ifndef PERF_HASH_H
-#define PERF_HASH_H
-#endif
diff --git a/tools/perf/util/include/linux/kernel.h b/tools/perf/util/include/linux/kernel.h
index d8c927c..9844c31 100644
--- a/tools/perf/util/include/linux/kernel.h
+++ b/tools/perf/util/include/linux/kernel.h
@@ -94,12 +94,6 @@ static inline int scnprintf(char * buf, size_t size, const char * fmt, ...)
 	return (i >= ssize) ? (ssize - 1) : i;
 }
 
-static inline unsigned long
-simple_strtoul(const char *nptr, char **endptr, int base)
-{
-	return strtoul(nptr, endptr, base);
-}
-
 int eprintf(int level,
 	    const char *fmt, ...) __attribute__((format(printf, 2, 3)));
 
diff --git a/tools/perf/util/include/linux/list.h b/tools/perf/util/include/linux/list.h
index 1d928a0..bfe0a2a 100644
--- a/tools/perf/util/include/linux/list.h
+++ b/tools/perf/util/include/linux/list.h
@@ -1,5 +1,4 @@
 #include <linux/kernel.h>
-#include <linux/prefetch.h>
 
 #include "../../../../include/linux/list.h"
 
diff --git a/tools/perf/util/include/linux/prefetch.h b/tools/perf/util/include/linux/prefetch.h
deleted file mode 100644
index 7841e48..0000000
--- a/tools/perf/util/include/linux/prefetch.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef PERF_LINUX_PREFETCH_H
-#define PERF_LINUX_PREFETCH_H
-
-static inline void prefetch(void *a __attribute__((unused))) { }
-
-#endif
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 620a198..a53cd0b 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -327,9 +327,10 @@ struct thread *machine__findnew_thread(struct machine *machine, pid_t pid,
 	return __machine__findnew_thread(machine, pid, tid, true);
 }
 
-struct thread *machine__find_thread(struct machine *machine, pid_t tid)
+struct thread *machine__find_thread(struct machine *machine, pid_t pid,
+				    pid_t tid)
 {
-	return __machine__findnew_thread(machine, 0, tid, false);
+	return __machine__findnew_thread(machine, pid, tid, false);
 }
 
 int machine__process_comm_event(struct machine *machine, union perf_event *event,
@@ -1026,7 +1027,7 @@ int machine__process_mmap2_event(struct machine *machine,
 	}
 
 	thread = machine__findnew_thread(machine, event->mmap2.pid,
-					event->mmap2.pid);
+					event->mmap2.tid);
 	if (thread == NULL)
 		goto out_problem;
 
@@ -1074,7 +1075,7 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 	}
 
 	thread = machine__findnew_thread(machine, event->mmap.pid,
-					 event->mmap.pid);
+					 event->mmap.tid);
 	if (thread == NULL)
 		goto out_problem;
 
@@ -1114,7 +1115,9 @@ static void machine__remove_thread(struct machine *machine, struct thread *th)
 int machine__process_fork_event(struct machine *machine, union perf_event *event,
 				struct perf_sample *sample)
 {
-	struct thread *thread = machine__find_thread(machine, event->fork.tid);
+	struct thread *thread = machine__find_thread(machine,
+						     event->fork.pid,
+						     event->fork.tid);
 	struct thread *parent = machine__findnew_thread(machine,
 							event->fork.ppid,
 							event->fork.ptid);
@@ -1140,7 +1143,9 @@ int machine__process_fork_event(struct machine *machine, union perf_event *event
 int machine__process_exit_event(struct machine *machine, union perf_event *event,
 				struct perf_sample *sample __maybe_unused)
 {
-	struct thread *thread = machine__find_thread(machine, event->fork.tid);
+	struct thread *thread = machine__find_thread(machine,
+						     event->fork.pid,
+						     event->fork.tid);
 
 	if (dump_trace)
 		perf_event__fprintf_task(event, stdout);
@@ -1184,39 +1189,22 @@ static bool symbol__match_regex(struct symbol *sym, regex_t *regex)
 	return 0;
 }
 
-static const u8 cpumodes[] = {
-	PERF_RECORD_MISC_USER,
-	PERF_RECORD_MISC_KERNEL,
-	PERF_RECORD_MISC_GUEST_USER,
-	PERF_RECORD_MISC_GUEST_KERNEL
-};
-#define NCPUMODES (sizeof(cpumodes)/sizeof(u8))
-
 static void ip__resolve_ams(struct machine *machine, struct thread *thread,
 			    struct addr_map_symbol *ams,
 			    u64 ip)
 {
 	struct addr_location al;
-	size_t i;
-	u8 m;
 
 	memset(&al, 0, sizeof(al));
+	/*
+	 * We cannot use the header.misc hint to determine whether a
+	 * branch stack address is user, kernel, guest, hypervisor.
+	 * Branches may straddle the kernel/user/hypervisor boundaries.
+	 * Thus, we have to try consecutively until we find a match
+	 * or else, the symbol is unknown
+	 */
+	thread__find_cpumode_addr_location(thread, machine, MAP__FUNCTION, ip, &al);
 
-	for (i = 0; i < NCPUMODES; i++) {
-		m = cpumodes[i];
-		/*
-		 * We cannot use the header.misc hint to determine whether a
-		 * branch stack address is user, kernel, guest, hypervisor.
-		 * Branches may straddle the kernel/user/hypervisor boundaries.
-		 * Thus, we have to try consecutively until we find a match
-		 * or else, the symbol is unknown
-		 */
-		thread__find_addr_location(thread, machine, m, MAP__FUNCTION,
-				ip, &al);
-		if (al.map)
-			goto found;
-	}
-found:
 	ams->addr = ip;
 	ams->al_addr = al.addr;
 	ams->sym = al.sym;
@@ -1238,37 +1226,35 @@ static void ip__resolve_data(struct machine *machine, struct thread *thread,
 	ams->map = al.map;
 }
 
-struct mem_info *machine__resolve_mem(struct machine *machine,
-				      struct thread *thr,
-				      struct perf_sample *sample,
-				      u8 cpumode)
+struct mem_info *sample__resolve_mem(struct perf_sample *sample,
+				     struct addr_location *al)
 {
 	struct mem_info *mi = zalloc(sizeof(*mi));
 
 	if (!mi)
 		return NULL;
 
-	ip__resolve_ams(machine, thr, &mi->iaddr, sample->ip);
-	ip__resolve_data(machine, thr, cpumode, &mi->daddr, sample->addr);
+	ip__resolve_ams(al->machine, al->thread, &mi->iaddr, sample->ip);
+	ip__resolve_data(al->machine, al->thread, al->cpumode,
+			 &mi->daddr, sample->addr);
 	mi->data_src.val = sample->data_src;
 
 	return mi;
 }
 
-struct branch_info *machine__resolve_bstack(struct machine *machine,
-					    struct thread *thr,
-					    struct branch_stack *bs)
+struct branch_info *sample__resolve_bstack(struct perf_sample *sample,
+					   struct addr_location *al)
 {
-	struct branch_info *bi;
 	unsigned int i;
+	const struct branch_stack *bs = sample->branch_stack;
+	struct branch_info *bi = calloc(bs->nr, sizeof(struct branch_info));
 
-	bi = calloc(bs->nr, sizeof(struct branch_info));
 	if (!bi)
 		return NULL;
 
 	for (i = 0; i < bs->nr; i++) {
-		ip__resolve_ams(machine, thr, &bi[i].to, bs->entries[i].to);
-		ip__resolve_ams(machine, thr, &bi[i].from, bs->entries[i].from);
+		ip__resolve_ams(al->machine, al->thread, &bi[i].to, bs->entries[i].to);
+		ip__resolve_ams(al->machine, al->thread, &bi[i].from, bs->entries[i].from);
 		bi[i].flags = bs->entries[i].flags;
 	}
 	return bi;
@@ -1326,7 +1312,7 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 			continue;
 		}
 
-		al.filtered = false;
+		al.filtered = 0;
 		thread__find_addr_location(thread, machine, cpumode,
 					   MAP__FUNCTION, ip, &al);
 		if (al.sym != NULL) {
@@ -1385,8 +1371,7 @@ int machine__resolve_callchain(struct machine *machine,
 		return 0;
 
 	return unwind__get_entries(unwind_entry, &callchain_cursor, machine,
-				   thread, evsel->attr.sample_regs_user,
-				   sample, max_stack);
+				   thread, sample, max_stack);
 
 }
 
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index f77e91e..c8c74a1 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -41,7 +41,8 @@ struct map *machine__kernel_map(struct machine *machine, enum map_type type)
 	return machine->vmlinux_maps[type];
 }
 
-struct thread *machine__find_thread(struct machine *machine, pid_t tid);
+struct thread *machine__find_thread(struct machine *machine, pid_t pid,
+				    pid_t tid);
 
 int machine__process_comm_event(struct machine *machine, union perf_event *event,
 				struct perf_sample *sample);
@@ -91,12 +92,10 @@ void machine__delete_dead_threads(struct machine *machine);
 void machine__delete_threads(struct machine *machine);
 void machine__delete(struct machine *machine);
 
-struct branch_info *machine__resolve_bstack(struct machine *machine,
-					    struct thread *thread,
-					    struct branch_stack *bs);
-struct mem_info *machine__resolve_mem(struct machine *machine,
-				      struct thread *thread,
-				      struct perf_sample *sample, u8 cpumode);
+struct branch_info *sample__resolve_bstack(struct perf_sample *sample,
+					   struct addr_location *al);
+struct mem_info *sample__resolve_mem(struct perf_sample *sample,
+				     struct addr_location *al);
 int machine__resolve_callchain(struct machine *machine,
 			       struct perf_evsel *evsel,
 			       struct thread *thread,
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 257e513..f00f058 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -90,6 +90,16 @@ u64 map__objdump_2mem(struct map *map, u64 ip);
 
 struct symbol;
 
+/* map__for_each_symbol - iterate over the symbols in the given map
+ *
+ * @map: the 'struct map *' in which symbols itereated
+ * @pos: the 'struct symbol *' to use as a loop cursor
+ * @n: the 'struct rb_node *' to use as a temporary storage
+ * Note: caller must ensure map->dso is not NULL (map is loaded).
+ */
+#define map__for_each_symbol(map, pos, n)	\
+	dso__for_each_symbol(map->dso, pos, n, map->type)
+
 typedef int (*symbol_filter_t)(struct map *map, struct symbol *sym);
 
 void map__init(struct map *map, enum map_type type,
diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index d22e3f8..bf48092 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -407,7 +407,9 @@ int parse_options_step(struct parse_opt_ctx_t *ctx,
 		if (internal_help && !strcmp(arg + 2, "help"))
 			return usage_with_options_internal(usagestr, options, 0);
 		if (!strcmp(arg + 2, "list-opts"))
-			return PARSE_OPT_LIST;
+			return PARSE_OPT_LIST_OPTS;
+		if (!strcmp(arg + 2, "list-cmds"))
+			return PARSE_OPT_LIST_SUBCMDS;
 		switch (parse_long_opt(ctx, arg + 2, options)) {
 		case -1:
 			return parse_options_usage(usagestr, options, arg + 2, 0);
@@ -433,25 +435,45 @@ int parse_options_end(struct parse_opt_ctx_t *ctx)
 	return ctx->cpidx + ctx->argc;
 }
 
-int parse_options(int argc, const char **argv, const struct option *options,
-		  const char * const usagestr[], int flags)
+int parse_options_subcommand(int argc, const char **argv, const struct option *options,
+			const char *const subcommands[], const char *usagestr[], int flags)
 {
 	struct parse_opt_ctx_t ctx;
 
 	perf_header__set_cmdline(argc, argv);
 
+	/* build usage string if it's not provided */
+	if (subcommands && !usagestr[0]) {
+		struct strbuf buf = STRBUF_INIT;
+
+		strbuf_addf(&buf, "perf %s [<options>] {", argv[0]);
+		for (int i = 0; subcommands[i]; i++) {
+			if (i)
+				strbuf_addstr(&buf, "|");
+			strbuf_addstr(&buf, subcommands[i]);
+		}
+		strbuf_addstr(&buf, "}");
+
+		usagestr[0] = strdup(buf.buf);
+		strbuf_release(&buf);
+	}
+
 	parse_options_start(&ctx, argc, argv, flags);
 	switch (parse_options_step(&ctx, options, usagestr)) {
 	case PARSE_OPT_HELP:
 		exit(129);
 	case PARSE_OPT_DONE:
 		break;
-	case PARSE_OPT_LIST:
+	case PARSE_OPT_LIST_OPTS:
 		while (options->type != OPTION_END) {
 			printf("--%s ", options->long_name);
 			options++;
 		}
 		exit(130);
+	case PARSE_OPT_LIST_SUBCMDS:
+		for (int i = 0; subcommands[i]; i++)
+			printf("%s ", subcommands[i]);
+		exit(130);
 	default: /* PARSE_OPT_UNKNOWN */
 		if (ctx.argv[0][1] == '-') {
 			error("unknown option `%s'", ctx.argv[0] + 2);
@@ -464,6 +486,13 @@ int parse_options(int argc, const char **argv, const struct option *options,
 	return parse_options_end(&ctx);
 }
 
+int parse_options(int argc, const char **argv, const struct option *options,
+		  const char * const usagestr[], int flags)
+{
+	return parse_options_subcommand(argc, argv, options, NULL,
+					(const char **) usagestr, flags);
+}
+
 #define USAGE_OPTS_WIDTH 24
 #define USAGE_GAP         2
 
diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index cbf0149..d8dac8a 100644
--- a/tools/perf/util/parse-options.h
+++ b/tools/perf/util/parse-options.h
@@ -140,6 +140,11 @@ extern int parse_options(int argc, const char **argv,
                          const struct option *options,
                          const char * const usagestr[], int flags);
 
+extern int parse_options_subcommand(int argc, const char **argv,
+				const struct option *options,
+				const char *const subcommands[],
+				const char *usagestr[], int flags);
+
 extern NORETURN void usage_with_options(const char * const *usagestr,
                                         const struct option *options);
 
@@ -148,7 +153,8 @@ extern NORETURN void usage_with_options(const char * const *usagestr,
 enum {
 	PARSE_OPT_HELP = -1,
 	PARSE_OPT_DONE,
-	PARSE_OPT_LIST,
+	PARSE_OPT_LIST_OPTS,
+	PARSE_OPT_LIST_SUBCMDS,
 	PARSE_OPT_UNKNOWN,
 };
 
diff --git a/tools/perf/util/perf_regs.c b/tools/perf/util/perf_regs.c
new file mode 100644
index 0000000..a3539ef
--- /dev/null
+++ b/tools/perf/util/perf_regs.c
@@ -0,0 +1,19 @@
+#include <errno.h>
+#include "perf_regs.h"
+
+int perf_reg_value(u64 *valp, struct regs_dump *regs, int id)
+{
+	int i, idx = 0;
+	u64 mask = regs->mask;
+
+	if (!(mask & (1 << id)))
+		return -EINVAL;
+
+	for (i = 0; i < id; i++) {
+		if (mask & (1 << i))
+			idx++;
+	}
+
+	*valp = regs->regs[idx];
+	return 0;
+}
diff --git a/tools/perf/util/perf_regs.h b/tools/perf/util/perf_regs.h
index a3d42cd..d6e8b6a 100644
--- a/tools/perf/util/perf_regs.h
+++ b/tools/perf/util/perf_regs.h
@@ -1,8 +1,14 @@
 #ifndef __PERF_REGS_H
 #define __PERF_REGS_H
 
+#include "types.h"
+#include "event.h"
+
 #ifdef HAVE_PERF_REGS_SUPPORT
 #include <perf_regs.h>
+
+int perf_reg_value(u64 *valp, struct regs_dump *regs, int id);
+
 #else
 #define PERF_REGS_MASK	0
 
@@ -10,5 +16,12 @@ static inline const char *perf_reg_name(int id __maybe_unused)
 {
 	return NULL;
 }
+
+static inline int perf_reg_value(u64 *valp __maybe_unused,
+				 struct regs_dump *regs __maybe_unused,
+				 int id __maybe_unused)
+{
+	return 0;
+}
 #endif /* HAVE_PERF_REGS_SUPPORT */
 #endif /* __PERF_REGS_H */
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index b752ecb..00a7dcb 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -3,7 +3,7 @@
 #include <unistd.h>
 #include <stdio.h>
 #include <dirent.h>
-#include "fs.h"
+#include <api/fs/fs.h>
 #include <locale.h>
 #include "util.h"
 #include "pmu.h"
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index d8b048c..0d1542f 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -70,34 +70,32 @@ static int e_snprintf(char *str, size_t size, const char *format, ...)
 }
 
 static char *synthesize_perf_probe_point(struct perf_probe_point *pp);
-static int convert_name_to_addr(struct perf_probe_event *pev,
-				const char *exec);
 static void clear_probe_trace_event(struct probe_trace_event *tev);
-static struct machine machine;
+static struct machine *host_machine;
 
 /* Initialize symbol maps and path of vmlinux/modules */
-static int init_vmlinux(void)
+static int init_symbol_maps(bool user_only)
 {
 	int ret;
 
 	symbol_conf.sort_by_name = true;
-	if (symbol_conf.vmlinux_name == NULL)
-		symbol_conf.try_vmlinux_path = true;
-	else
-		pr_debug("Use vmlinux: %s\n", symbol_conf.vmlinux_name);
 	ret = symbol__init();
 	if (ret < 0) {
 		pr_debug("Failed to init symbol map.\n");
 		goto out;
 	}
 
-	ret = machine__init(&machine, "", HOST_KERNEL_ID);
-	if (ret < 0)
-		goto out;
+	if (host_machine || user_only)	/* already initialized */
+		return 0;
 
-	if (machine__create_kernel_maps(&machine) < 0) {
-		pr_debug("machine__create_kernel_maps() failed.\n");
-		goto out;
+	if (symbol_conf.vmlinux_name)
+		pr_debug("Use vmlinux: %s\n", symbol_conf.vmlinux_name);
+
+	host_machine = machine__new_host();
+	if (!host_machine) {
+		pr_debug("machine__new_host() failed.\n");
+		symbol__exit();
+		ret = -1;
 	}
 out:
 	if (ret < 0)
@@ -105,21 +103,66 @@ out:
 	return ret;
 }
 
+static void exit_symbol_maps(void)
+{
+	if (host_machine) {
+		machine__delete(host_machine);
+		host_machine = NULL;
+	}
+	symbol__exit();
+}
+
 static struct symbol *__find_kernel_function_by_name(const char *name,
 						     struct map **mapp)
 {
-	return machine__find_kernel_function_by_name(&machine, name, mapp,
+	return machine__find_kernel_function_by_name(host_machine, name, mapp,
 						     NULL);
 }
 
+static struct symbol *__find_kernel_function(u64 addr, struct map **mapp)
+{
+	return machine__find_kernel_function(host_machine, addr, mapp, NULL);
+}
+
+static struct ref_reloc_sym *kernel_get_ref_reloc_sym(void)
+{
+	/* kmap->ref_reloc_sym should be set if host_machine is initialized */
+	struct kmap *kmap;
+
+	if (map__load(host_machine->vmlinux_maps[MAP__FUNCTION], NULL) < 0)
+		return NULL;
+
+	kmap = map__kmap(host_machine->vmlinux_maps[MAP__FUNCTION]);
+	return kmap->ref_reloc_sym;
+}
+
+static u64 kernel_get_symbol_address_by_name(const char *name, bool reloc)
+{
+	struct ref_reloc_sym *reloc_sym;
+	struct symbol *sym;
+	struct map *map;
+
+	/* ref_reloc_sym is just a label. Need a special fix*/
+	reloc_sym = kernel_get_ref_reloc_sym();
+	if (reloc_sym && strcmp(name, reloc_sym->name) == 0)
+		return (reloc) ? reloc_sym->addr : reloc_sym->unrelocated_addr;
+	else {
+		sym = __find_kernel_function_by_name(name, &map);
+		if (sym)
+			return map->unmap_ip(map, sym->start) -
+				(reloc) ? 0 : map->reloc;
+	}
+	return 0;
+}
+
 static struct map *kernel_get_module_map(const char *module)
 {
 	struct rb_node *nd;
-	struct map_groups *grp = &machine.kmaps;
+	struct map_groups *grp = &host_machine->kmaps;
 
 	/* A file path -- this is an offline module */
 	if (module && strchr(module, '/'))
-		return machine__new_module(&machine, 0, module);
+		return machine__new_module(host_machine, 0, module);
 
 	if (!module)
 		module = "kernel";
@@ -141,7 +184,7 @@ static struct dso *kernel_get_module_dso(const char *module)
 	const char *vmlinux_name;
 
 	if (module) {
-		list_for_each_entry(dso, &machine.kernel_dsos, node) {
+		list_for_each_entry(dso, &host_machine->kernel_dsos, node) {
 			if (strncmp(dso->short_name + 1, module,
 				    dso->short_name_len - 2) == 0)
 				goto found;
@@ -150,7 +193,7 @@ static struct dso *kernel_get_module_dso(const char *module)
 		return NULL;
 	}
 
-	map = machine.vmlinux_maps[MAP__FUNCTION];
+	map = host_machine->vmlinux_maps[MAP__FUNCTION];
 	dso = map->dso;
 
 	vmlinux_name = symbol_conf.vmlinux_name;
@@ -173,20 +216,6 @@ const char *kernel_get_module_path(const char *module)
 	return (dso) ? dso->long_name : NULL;
 }
 
-static int init_user_exec(void)
-{
-	int ret = 0;
-
-	symbol_conf.try_vmlinux_path = false;
-	symbol_conf.sort_by_name = true;
-	ret = symbol__init();
-
-	if (ret < 0)
-		pr_debug("Failed to init symbol map.\n");
-
-	return ret;
-}
-
 static int convert_exec_to_group(const char *exec, char **result)
 {
 	char *ptr1, *ptr2, *exec_copy;
@@ -218,32 +247,23 @@ out:
 	return ret;
 }
 
-static int convert_to_perf_probe_point(struct probe_trace_point *tp,
-					struct perf_probe_point *pp)
+static void clear_probe_trace_events(struct probe_trace_event *tevs, int ntevs)
 {
-	pp->function = strdup(tp->symbol);
-
-	if (pp->function == NULL)
-		return -ENOMEM;
-
-	pp->offset = tp->offset;
-	pp->retprobe = tp->retprobe;
+	int i;
 
-	return 0;
+	for (i = 0; i < ntevs; i++)
+		clear_probe_trace_event(tevs + i);
 }
 
 #ifdef HAVE_DWARF_SUPPORT
+
 /* Open new debuginfo of given module */
 static struct debuginfo *open_debuginfo(const char *module)
 {
-	const char *path;
+	const char *path = module;
 
-	/* A file path -- this is an offline module */
-	if (module && strchr(module, '/'))
-		path = module;
-	else {
+	if (!module || !strchr(module, '/')) {
 		path = kernel_get_module_path(module);
-
 		if (!path) {
 			pr_err("Failed to find path of %s module.\n",
 			       module ?: "kernel");
@@ -253,46 +273,6 @@ static struct debuginfo *open_debuginfo(const char *module)
 	return debuginfo__new(path);
 }
 
-/*
- * Convert trace point to probe point with debuginfo
- * Currently only handles kprobes.
- */
-static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
-					struct perf_probe_point *pp)
-{
-	struct symbol *sym;
-	struct map *map;
-	u64 addr;
-	int ret = -ENOENT;
-	struct debuginfo *dinfo;
-
-	sym = __find_kernel_function_by_name(tp->symbol, &map);
-	if (sym) {
-		addr = map->unmap_ip(map, sym->start + tp->offset);
-		pr_debug("try to find %s+%ld@%" PRIx64 "\n", tp->symbol,
-			 tp->offset, addr);
-
-		dinfo = debuginfo__new_online_kernel(addr);
-		if (dinfo) {
-			ret = debuginfo__find_probe_point(dinfo,
-						 (unsigned long)addr, pp);
-			debuginfo__delete(dinfo);
-		} else {
-			pr_debug("Failed to open debuginfo at 0x%" PRIx64 "\n",
-				 addr);
-			ret = -ENOENT;
-		}
-	}
-	if (ret <= 0) {
-		pr_debug("Failed to find corresponding probes from "
-			 "debuginfo. Use kprobe event information.\n");
-		return convert_to_perf_probe_point(tp, pp);
-	}
-	pp->retprobe = tp->retprobe;
-
-	return 0;
-}
-
 static int get_text_start_address(const char *exec, unsigned long *address)
 {
 	Elf *elf;
@@ -321,12 +301,62 @@ out:
 	return ret;
 }
 
+/*
+ * Convert trace point to probe point with debuginfo
+ */
+static int find_perf_probe_point_from_dwarf(struct probe_trace_point *tp,
+					    struct perf_probe_point *pp,
+					    bool is_kprobe)
+{
+	struct debuginfo *dinfo = NULL;
+	unsigned long stext = 0;
+	u64 addr = tp->address;
+	int ret = -ENOENT;
+
+	/* convert the address to dwarf address */
+	if (!is_kprobe) {
+		if (!addr) {
+			ret = -EINVAL;
+			goto error;
+		}
+		ret = get_text_start_address(tp->module, &stext);
+		if (ret < 0)
+			goto error;
+		addr += stext;
+	} else {
+		addr = kernel_get_symbol_address_by_name(tp->symbol, false);
+		if (addr == 0)
+			goto error;
+		addr += tp->offset;
+	}
+
+	pr_debug("try to find information at %" PRIx64 " in %s\n", addr,
+		 tp->module ? : "kernel");
+
+	dinfo = open_debuginfo(tp->module);
+	if (dinfo) {
+		ret = debuginfo__find_probe_point(dinfo,
+						 (unsigned long)addr, pp);
+		debuginfo__delete(dinfo);
+	} else {
+		pr_debug("Failed to open debuginfo at 0x%" PRIx64 "\n", addr);
+		ret = -ENOENT;
+	}
+
+	if (ret > 0) {
+		pp->retprobe = tp->retprobe;
+		return 0;
+	}
+error:
+	pr_debug("Failed to find corresponding probes from debuginfo.\n");
+	return ret ? : -ENOENT;
+}
+
 static int add_exec_to_probe_trace_events(struct probe_trace_event *tevs,
 					  int ntevs, const char *exec)
 {
 	int i, ret = 0;
-	unsigned long offset, stext = 0;
-	char buf[32];
+	unsigned long stext = 0;
 
 	if (!exec)
 		return 0;
@@ -337,15 +367,9 @@ static int add_exec_to_probe_trace_events(struct probe_trace_event *tevs,
 
 	for (i = 0; i < ntevs && ret >= 0; i++) {
 		/* point.address is the addres of point.symbol + point.offset */
-		offset = tevs[i].point.address - stext;
-		tevs[i].point.offset = 0;
-		zfree(&tevs[i].point.symbol);
-		ret = e_snprintf(buf, 32, "0x%lx", offset);
-		if (ret < 0)
-			break;
+		tevs[i].point.address -= stext;
 		tevs[i].point.module = strdup(exec);
-		tevs[i].point.symbol = strdup(buf);
-		if (!tevs[i].point.symbol || !tevs[i].point.module) {
+		if (!tevs[i].point.module) {
 			ret = -ENOMEM;
 			break;
 		}
@@ -388,12 +412,40 @@ static int add_module_to_probe_trace_events(struct probe_trace_event *tevs,
 	return ret;
 }
 
-static void clear_probe_trace_events(struct probe_trace_event *tevs, int ntevs)
+/* Post processing the probe events */
+static int post_process_probe_trace_events(struct probe_trace_event *tevs,
+					   int ntevs, const char *module,
+					   bool uprobe)
 {
+	struct ref_reloc_sym *reloc_sym;
+	char *tmp;
 	int i;
 
-	for (i = 0; i < ntevs; i++)
-		clear_probe_trace_event(tevs + i);
+	if (uprobe)
+		return add_exec_to_probe_trace_events(tevs, ntevs, module);
+
+	/* Note that currently ref_reloc_sym based probe is not for drivers */
+	if (module)
+		return add_module_to_probe_trace_events(tevs, ntevs, module);
+
+	reloc_sym = kernel_get_ref_reloc_sym();
+	if (!reloc_sym) {
+		pr_warning("Relocated base symbol is not found!\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < ntevs; i++) {
+		if (tevs[i].point.address) {
+			tmp = strdup(reloc_sym->name);
+			if (!tmp)
+				return -ENOMEM;
+			free(tevs[i].point.symbol);
+			tevs[i].point.symbol = tmp;
+			tevs[i].point.offset = tevs[i].point.address -
+					       reloc_sym->unrelocated_addr;
+		}
+	}
+	return 0;
 }
 
 /* Try to find perf_probe_event with debuginfo */
@@ -416,21 +468,16 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 		return 0;
 	}
 
+	pr_debug("Try to find probe point from debuginfo.\n");
 	/* Searching trace events corresponding to a probe event */
 	ntevs = debuginfo__find_trace_events(dinfo, pev, tevs, max_tevs);
 
 	debuginfo__delete(dinfo);
 
 	if (ntevs > 0) {	/* Succeeded to find trace events */
-		pr_debug("find %d probe_trace_events.\n", ntevs);
-		if (target) {
-			if (pev->uprobes)
-				ret = add_exec_to_probe_trace_events(*tevs,
-						 ntevs, target);
-			else
-				ret = add_module_to_probe_trace_events(*tevs,
-						 ntevs, target);
-		}
+		pr_debug("Found %d probe_trace_events.\n", ntevs);
+		ret = post_process_probe_trace_events(*tevs, ntevs,
+							target, pev->uprobes);
 		if (ret < 0) {
 			clear_probe_trace_events(*tevs, ntevs);
 			zfree(tevs);
@@ -563,20 +610,16 @@ static int _show_one_line(FILE *fp, int l, bool skip, bool show_num)
  * Show line-range always requires debuginfo to find source file and
  * line number.
  */
-int show_line_range(struct line_range *lr, const char *module)
+static int __show_line_range(struct line_range *lr, const char *module)
 {
 	int l = 1;
-	struct line_node *ln;
+	struct int_node *ln;
 	struct debuginfo *dinfo;
 	FILE *fp;
 	int ret;
 	char *tmp;
 
 	/* Search a line range */
-	ret = init_vmlinux();
-	if (ret < 0)
-		return ret;
-
 	dinfo = open_debuginfo(module);
 	if (!dinfo) {
 		pr_warning("Failed to open debuginfo file.\n");
@@ -623,8 +666,8 @@ int show_line_range(struct line_range *lr, const char *module)
 			goto end;
 	}
 
-	list_for_each_entry(ln, &lr->line_list, list) {
-		for (; ln->line > l; l++) {
+	intlist__for_each(ln, lr->line_list) {
+		for (; ln->i > l; l++) {
 			ret = show_one_line(fp, l - lr->offset);
 			if (ret < 0)
 				goto end;
@@ -646,6 +689,19 @@ end:
 	return ret;
 }
 
+int show_line_range(struct line_range *lr, const char *module)
+{
+	int ret;
+
+	ret = init_symbol_maps(false);
+	if (ret < 0)
+		return ret;
+	ret = __show_line_range(lr, module);
+	exit_symbol_maps();
+
+	return ret;
+}
+
 static int show_available_vars_at(struct debuginfo *dinfo,
 				  struct perf_probe_event *pev,
 				  int max_vls, struct strfilter *_filter,
@@ -707,14 +763,15 @@ int show_available_vars(struct perf_probe_event *pevs, int npevs,
 	int i, ret = 0;
 	struct debuginfo *dinfo;
 
-	ret = init_vmlinux();
+	ret = init_symbol_maps(false);
 	if (ret < 0)
 		return ret;
 
 	dinfo = open_debuginfo(module);
 	if (!dinfo) {
 		pr_warning("Failed to open debuginfo file.\n");
-		return -ENOENT;
+		ret = -ENOENT;
+		goto out;
 	}
 
 	setup_pager();
@@ -724,23 +781,19 @@ int show_available_vars(struct perf_probe_event *pevs, int npevs,
 					     externs);
 
 	debuginfo__delete(dinfo);
+out:
+	exit_symbol_maps();
 	return ret;
 }
 
 #else	/* !HAVE_DWARF_SUPPORT */
 
-static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
-					struct perf_probe_point *pp)
+static int
+find_perf_probe_point_from_dwarf(struct probe_trace_point *tp __maybe_unused,
+				 struct perf_probe_point *pp __maybe_unused,
+				 bool is_kprobe __maybe_unused)
 {
-	struct symbol *sym;
-
-	sym = __find_kernel_function_by_name(tp->symbol, NULL);
-	if (!sym) {
-		pr_err("Failed to find symbol %s in kernel.\n", tp->symbol);
-		return -ENOENT;
-	}
-
-	return convert_to_perf_probe_point(tp, pp);
+	return -ENOSYS;
 }
 
 static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
@@ -776,24 +829,22 @@ int show_available_vars(struct perf_probe_event *pevs __maybe_unused,
 
 void line_range__clear(struct line_range *lr)
 {
-	struct line_node *ln;
-
 	free(lr->function);
 	free(lr->file);
 	free(lr->path);
 	free(lr->comp_dir);
-	while (!list_empty(&lr->line_list)) {
-		ln = list_first_entry(&lr->line_list, struct line_node, list);
-		list_del(&ln->list);
-		free(ln);
-	}
+	intlist__delete(lr->line_list);
 	memset(lr, 0, sizeof(*lr));
 }
 
-void line_range__init(struct line_range *lr)
+int line_range__init(struct line_range *lr)
 {
 	memset(lr, 0, sizeof(*lr));
-	INIT_LIST_HEAD(&lr->line_list);
+	lr->line_list = intlist__new(NULL);
+	if (!lr->line_list)
+		return -ENOMEM;
+	else
+		return 0;
 }
 
 static int parse_line_num(char **ptr, int *val, const char *what)
@@ -1267,16 +1318,21 @@ static int parse_probe_trace_command(const char *cmd,
 	} else
 		p = argv[1];
 	fmt1_str = strtok_r(p, "+", &fmt);
-	tp->symbol = strdup(fmt1_str);
-	if (tp->symbol == NULL) {
-		ret = -ENOMEM;
-		goto out;
+	if (fmt1_str[0] == '0')	/* only the address started with 0x */
+		tp->address = strtoul(fmt1_str, NULL, 0);
+	else {
+		/* Only the symbol-based probe has offset */
+		tp->symbol = strdup(fmt1_str);
+		if (tp->symbol == NULL) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		fmt2_str = strtok_r(NULL, "", &fmt);
+		if (fmt2_str == NULL)
+			tp->offset = 0;
+		else
+			tp->offset = strtoul(fmt2_str, NULL, 10);
 	}
-	fmt2_str = strtok_r(NULL, "", &fmt);
-	if (fmt2_str == NULL)
-		tp->offset = 0;
-	else
-		tp->offset = strtoul(fmt2_str, NULL, 10);
 
 	tev->nargs = argc - 2;
 	tev->args = zalloc(sizeof(struct probe_trace_arg) * tev->nargs);
@@ -1518,20 +1574,27 @@ char *synthesize_probe_trace_command(struct probe_trace_event *tev)
 	if (buf == NULL)
 		return NULL;
 
+	len = e_snprintf(buf, MAX_CMDLEN, "%c:%s/%s ", tp->retprobe ? 'r' : 'p',
+			 tev->group, tev->event);
+	if (len <= 0)
+		goto error;
+
+	/* Uprobes must have tp->address and tp->module */
+	if (tev->uprobes && (!tp->address || !tp->module))
+		goto error;
+
+	/* Use the tp->address for uprobes */
 	if (tev->uprobes)
-		len = e_snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s:%s",
-				 tp->retprobe ? 'r' : 'p',
-				 tev->group, tev->event,
-				 tp->module, tp->symbol);
+		ret = e_snprintf(buf + len, MAX_CMDLEN - len, "%s:0x%lx",
+				 tp->module, tp->address);
 	else
-		len = e_snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s%s%s+%lu",
-				 tp->retprobe ? 'r' : 'p',
-				 tev->group, tev->event,
+		ret = e_snprintf(buf + len, MAX_CMDLEN - len, "%s%s%s+%lu",
 				 tp->module ?: "", tp->module ? ":" : "",
 				 tp->symbol, tp->offset);
 
-	if (len <= 0)
+	if (ret <= 0)
 		goto error;
+	len += ret;
 
 	for (i = 0; i < tev->nargs; i++) {
 		ret = synthesize_probe_trace_arg(&tev->args[i], buf + len,
@@ -1547,6 +1610,79 @@ error:
 	return NULL;
 }
 
+static int find_perf_probe_point_from_map(struct probe_trace_point *tp,
+					  struct perf_probe_point *pp,
+					  bool is_kprobe)
+{
+	struct symbol *sym = NULL;
+	struct map *map;
+	u64 addr;
+	int ret = -ENOENT;
+
+	if (!is_kprobe) {
+		map = dso__new_map(tp->module);
+		if (!map)
+			goto out;
+		addr = tp->address;
+		sym = map__find_symbol(map, addr, NULL);
+	} else {
+		addr = kernel_get_symbol_address_by_name(tp->symbol, true);
+		if (addr) {
+			addr += tp->offset;
+			sym = __find_kernel_function(addr, &map);
+		}
+	}
+	if (!sym)
+		goto out;
+
+	pp->retprobe = tp->retprobe;
+	pp->offset = addr - map->unmap_ip(map, sym->start);
+	pp->function = strdup(sym->name);
+	ret = pp->function ? 0 : -ENOMEM;
+
+out:
+	if (map && !is_kprobe) {
+		dso__delete(map->dso);
+		map__delete(map);
+	}
+
+	return ret;
+}
+
+static int convert_to_perf_probe_point(struct probe_trace_point *tp,
+					struct perf_probe_point *pp,
+					bool is_kprobe)
+{
+	char buf[128];
+	int ret;
+
+	ret = find_perf_probe_point_from_dwarf(tp, pp, is_kprobe);
+	if (!ret)
+		return 0;
+	ret = find_perf_probe_point_from_map(tp, pp, is_kprobe);
+	if (!ret)
+		return 0;
+
+	pr_debug("Failed to find probe point from both of dwarf and map.\n");
+
+	if (tp->symbol) {
+		pp->function = strdup(tp->symbol);
+		pp->offset = tp->offset;
+	} else if (!tp->module && !is_kprobe) {
+		ret = e_snprintf(buf, 128, "0x%" PRIx64, (u64)tp->address);
+		if (ret < 0)
+			return ret;
+		pp->function = strdup(buf);
+		pp->offset = 0;
+	}
+	if (pp->function == NULL)
+		return -ENOMEM;
+
+	pp->retprobe = tp->retprobe;
+
+	return 0;
+}
+
 static int convert_to_perf_probe_event(struct probe_trace_event *tev,
 			       struct perf_probe_event *pev, bool is_kprobe)
 {
@@ -1560,11 +1696,7 @@ static int convert_to_perf_probe_event(struct probe_trace_event *tev,
 		return -ENOMEM;
 
 	/* Convert trace_point to probe_point */
-	if (is_kprobe)
-		ret = kprobe_convert_to_perf_probe(&tev->point, &pev->point);
-	else
-		ret = convert_to_perf_probe_point(&tev->point, &pev->point);
-
+	ret = convert_to_perf_probe_point(&tev->point, &pev->point, is_kprobe);
 	if (ret < 0)
 		return ret;
 
@@ -1731,7 +1863,8 @@ static struct strlist *get_probe_trace_command_rawlist(int fd)
 }
 
 /* Show an event */
-static int show_perf_probe_event(struct perf_probe_event *pev)
+static int show_perf_probe_event(struct perf_probe_event *pev,
+				 const char *module)
 {
 	int i, ret;
 	char buf[128];
@@ -1747,6 +1880,8 @@ static int show_perf_probe_event(struct perf_probe_event *pev)
 		return ret;
 
 	printf("  %-20s (on %s", buf, place);
+	if (module)
+		printf(" in %s", module);
 
 	if (pev->nargs > 0) {
 		printf(" with");
@@ -1784,7 +1919,8 @@ static int __show_perf_probe_events(int fd, bool is_kprobe)
 			ret = convert_to_perf_probe_event(&tev, &pev,
 								is_kprobe);
 			if (ret >= 0)
-				ret = show_perf_probe_event(&pev);
+				ret = show_perf_probe_event(&pev,
+							    tev.point.module);
 		}
 		clear_perf_probe_event(&pev);
 		clear_probe_trace_event(&tev);
@@ -1807,7 +1943,7 @@ int show_perf_probe_events(void)
 	if (fd < 0)
 		return fd;
 
-	ret = init_vmlinux();
+	ret = init_symbol_maps(false);
 	if (ret < 0)
 		return ret;
 
@@ -1820,6 +1956,7 @@ int show_perf_probe_events(void)
 		close(fd);
 	}
 
+	exit_symbol_maps();
 	return ret;
 }
 
@@ -1982,7 +2119,7 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
 		group = pev->group;
 		pev->event = tev->event;
 		pev->group = tev->group;
-		show_perf_probe_event(pev);
+		show_perf_probe_event(pev, tev->point.module);
 		/* Trick here - restore current event/group */
 		pev->event = (char *)event;
 		pev->group = (char *)group;
@@ -2008,113 +2145,175 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
 	return ret;
 }
 
-static int convert_to_probe_trace_events(struct perf_probe_event *pev,
-					  struct probe_trace_event **tevs,
-					  int max_tevs, const char *target)
+static char *looking_function_name;
+static int num_matched_functions;
+
+static int probe_function_filter(struct map *map __maybe_unused,
+				      struct symbol *sym)
 {
+	if ((sym->binding == STB_GLOBAL || sym->binding == STB_LOCAL) &&
+	    strcmp(looking_function_name, sym->name) == 0) {
+		num_matched_functions++;
+		return 0;
+	}
+	return 1;
+}
+
+#define strdup_or_goto(str, label)	\
+	({ char *__p = strdup(str); if (!__p) goto label; __p; })
+
+/*
+ * Find probe function addresses from map.
+ * Return an error or the number of found probe_trace_event
+ */
+static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
+					    struct probe_trace_event **tevs,
+					    int max_tevs, const char *target)
+{
+	struct map *map = NULL;
+	struct kmap *kmap = NULL;
+	struct ref_reloc_sym *reloc_sym = NULL;
 	struct symbol *sym;
-	int ret, i;
+	struct rb_node *nd;
 	struct probe_trace_event *tev;
+	struct perf_probe_point *pp = &pev->point;
+	struct probe_trace_point *tp;
+	int ret, i;
 
-	if (pev->uprobes && !pev->group) {
-		/* Replace group name if not given */
-		ret = convert_exec_to_group(target, &pev->group);
-		if (ret != 0) {
-			pr_warning("Failed to make a group name.\n");
-			return ret;
-		}
+	/* Init maps of given executable or kernel */
+	if (pev->uprobes)
+		map = dso__new_map(target);
+	else
+		map = kernel_get_module_map(target);
+	if (!map) {
+		ret = -EINVAL;
+		goto out;
 	}
 
-	/* Convert perf_probe_event with debuginfo */
-	ret = try_to_find_probe_trace_events(pev, tevs, max_tevs, target);
-	if (ret != 0)
-		return ret;	/* Found in debuginfo or got an error */
-
-	if (pev->uprobes) {
-		ret = convert_name_to_addr(pev, target);
-		if (ret < 0)
-			return ret;
+	/*
+	 * Load matched symbols: Since the different local symbols may have
+	 * same name but different addresses, this lists all the symbols.
+	 */
+	num_matched_functions = 0;
+	looking_function_name = pp->function;
+	ret = map__load(map, probe_function_filter);
+	if (ret || num_matched_functions == 0) {
+		pr_err("Failed to find symbol %s in %s\n", pp->function,
+			target ? : "kernel");
+		ret = -ENOENT;
+		goto out;
+	} else if (num_matched_functions > max_tevs) {
+		pr_err("Too many functions matched in %s\n",
+			target ? : "kernel");
+		ret = -E2BIG;
+		goto out;
 	}
 
-	/* Allocate trace event buffer */
-	tev = *tevs = zalloc(sizeof(struct probe_trace_event));
-	if (tev == NULL)
-		return -ENOMEM;
+	if (!pev->uprobes) {
+		kmap = map__kmap(map);
+		reloc_sym = kmap->ref_reloc_sym;
+		if (!reloc_sym) {
+			pr_warning("Relocated base symbol is not found!\n");
+			ret = -EINVAL;
+			goto out;
+		}
+	}
 
-	/* Copy parameters */
-	tev->point.symbol = strdup(pev->point.function);
-	if (tev->point.symbol == NULL) {
+	/* Setup result trace-probe-events */
+	*tevs = zalloc(sizeof(*tev) * num_matched_functions);
+	if (!*tevs) {
 		ret = -ENOMEM;
-		goto error;
+		goto out;
 	}
 
-	if (target) {
-		tev->point.module = strdup(target);
-		if (tev->point.module == NULL) {
-			ret = -ENOMEM;
-			goto error;
+	ret = 0;
+	map__for_each_symbol(map, sym, nd) {
+		tev = (*tevs) + ret;
+		tp = &tev->point;
+		if (ret == num_matched_functions) {
+			pr_warning("Too many symbols are listed. Skip it.\n");
+			break;
 		}
-	}
-
-	tev->point.offset = pev->point.offset;
-	tev->point.retprobe = pev->point.retprobe;
-	tev->nargs = pev->nargs;
-	tev->uprobes = pev->uprobes;
+		ret++;
 
-	if (tev->nargs) {
-		tev->args = zalloc(sizeof(struct probe_trace_arg)
-				   * tev->nargs);
-		if (tev->args == NULL) {
-			ret = -ENOMEM;
-			goto error;
+		if (pp->offset > sym->end - sym->start) {
+			pr_warning("Offset %ld is bigger than the size of %s\n",
+				   pp->offset, sym->name);
+			ret = -ENOENT;
+			goto err_out;
+		}
+		/* Add one probe point */
+		tp->address = map->unmap_ip(map, sym->start) + pp->offset;
+		if (reloc_sym) {
+			tp->symbol = strdup_or_goto(reloc_sym->name, nomem_out);
+			tp->offset = tp->address - reloc_sym->addr;
+		} else {
+			tp->symbol = strdup_or_goto(sym->name, nomem_out);
+			tp->offset = pp->offset;
+		}
+		tp->retprobe = pp->retprobe;
+		if (target)
+			tev->point.module = strdup_or_goto(target, nomem_out);
+		tev->uprobes = pev->uprobes;
+		tev->nargs = pev->nargs;
+		if (tev->nargs) {
+			tev->args = zalloc(sizeof(struct probe_trace_arg) *
+					   tev->nargs);
+			if (tev->args == NULL)
+				goto nomem_out;
 		}
 		for (i = 0; i < tev->nargs; i++) {
-			if (pev->args[i].name) {
-				tev->args[i].name = strdup(pev->args[i].name);
-				if (tev->args[i].name == NULL) {
-					ret = -ENOMEM;
-					goto error;
-				}
-			}
-			tev->args[i].value = strdup(pev->args[i].var);
-			if (tev->args[i].value == NULL) {
-				ret = -ENOMEM;
-				goto error;
-			}
-			if (pev->args[i].type) {
-				tev->args[i].type = strdup(pev->args[i].type);
-				if (tev->args[i].type == NULL) {
-					ret = -ENOMEM;
-					goto error;
-				}
-			}
+			if (pev->args[i].name)
+				tev->args[i].name =
+					strdup_or_goto(pev->args[i].name,
+							nomem_out);
+
+			tev->args[i].value = strdup_or_goto(pev->args[i].var,
+							    nomem_out);
+			if (pev->args[i].type)
+				tev->args[i].type =
+					strdup_or_goto(pev->args[i].type,
+							nomem_out);
 		}
 	}
 
-	if (pev->uprobes)
-		return 1;
+out:
+	if (map && pev->uprobes) {
+		/* Only when using uprobe(exec) map needs to be released */
+		dso__delete(map->dso);
+		map__delete(map);
+	}
+	return ret;
 
-	/* Currently just checking function name from symbol map */
-	sym = __find_kernel_function_by_name(tev->point.symbol, NULL);
-	if (!sym) {
-		pr_warning("Kernel symbol \'%s\' not found.\n",
-			   tev->point.symbol);
-		ret = -ENOENT;
-		goto error;
-	} else if (tev->point.offset > sym->end - sym->start) {
-		pr_warning("Offset specified is greater than size of %s\n",
-			   tev->point.symbol);
-		ret = -ENOENT;
-		goto error;
+nomem_out:
+	ret = -ENOMEM;
+err_out:
+	clear_probe_trace_events(*tevs, num_matched_functions);
+	zfree(tevs);
+	goto out;
+}
+
+static int convert_to_probe_trace_events(struct perf_probe_event *pev,
+					  struct probe_trace_event **tevs,
+					  int max_tevs, const char *target)
+{
+	int ret;
 
+	if (pev->uprobes && !pev->group) {
+		/* Replace group name if not given */
+		ret = convert_exec_to_group(target, &pev->group);
+		if (ret != 0) {
+			pr_warning("Failed to make a group name.\n");
+			return ret;
+		}
 	}
 
-	return 1;
-error:
-	clear_probe_trace_event(tev);
-	free(tev);
-	*tevs = NULL;
-	return ret;
+	/* Convert perf_probe_event with debuginfo */
+	ret = try_to_find_probe_trace_events(pev, tevs, max_tevs, target);
+	if (ret != 0)
+		return ret;	/* Found in debuginfo or got an error */
+
+	return find_probe_trace_events_from_map(pev, tevs, max_tevs, target);
 }
 
 struct __event_package {
@@ -2135,12 +2334,7 @@ int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 	if (pkgs == NULL)
 		return -ENOMEM;
 
-	if (!pevs->uprobes)
-		/* Init vmlinux path */
-		ret = init_vmlinux();
-	else
-		ret = init_user_exec();
-
+	ret = init_symbol_maps(pevs->uprobes);
 	if (ret < 0) {
 		free(pkgs);
 		return ret;
@@ -2174,6 +2368,7 @@ end:
 		zfree(&pkgs[i].tevs);
 	}
 	free(pkgs);
+	exit_symbol_maps();
 
 	return ret;
 }
@@ -2323,159 +2518,51 @@ static struct strfilter *available_func_filter;
 static int filter_available_functions(struct map *map __maybe_unused,
 				      struct symbol *sym)
 {
-	if (sym->binding == STB_GLOBAL &&
+	if ((sym->binding == STB_GLOBAL || sym->binding == STB_LOCAL) &&
 	    strfilter__compare(available_func_filter, sym->name))
 		return 0;
 	return 1;
 }
 
-static int __show_available_funcs(struct map *map)
-{
-	if (map__load(map, filter_available_functions)) {
-		pr_err("Failed to load map.\n");
-		return -EINVAL;
-	}
-	if (!dso__sorted_by_name(map->dso, map->type))
-		dso__sort_by_name(map->dso, map->type);
-
-	dso__fprintf_symbols_by_name(map->dso, map->type, stdout);
-	return 0;
-}
-
-static int available_kernel_funcs(const char *module)
+int show_available_funcs(const char *target, struct strfilter *_filter,
+					bool user)
 {
 	struct map *map;
 	int ret;
 
-	ret = init_vmlinux();
+	ret = init_symbol_maps(user);
 	if (ret < 0)
 		return ret;
 
-	map = kernel_get_module_map(module);
+	/* Get a symbol map */
+	if (user)
+		map = dso__new_map(target);
+	else
+		map = kernel_get_module_map(target);
 	if (!map) {
-		pr_err("Failed to find %s map.\n", (module) ? : "kernel");
+		pr_err("Failed to get a map for %s\n", (target) ? : "kernel");
 		return -EINVAL;
 	}
-	return __show_available_funcs(map);
-}
-
-static int available_user_funcs(const char *target)
-{
-	struct map *map;
-	int ret;
-
-	ret = init_user_exec();
-	if (ret < 0)
-		return ret;
-
-	map = dso__new_map(target);
-	ret = __show_available_funcs(map);
-	dso__delete(map->dso);
-	map__delete(map);
-	return ret;
-}
 
-int show_available_funcs(const char *target, struct strfilter *_filter,
-					bool user)
-{
-	setup_pager();
+	/* Load symbols with given filter */
 	available_func_filter = _filter;
-
-	if (!user)
-		return available_kernel_funcs(target);
-
-	return available_user_funcs(target);
-}
-
-/*
- * uprobe_events only accepts address:
- * Convert function and any offset to address
- */
-static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
-{
-	struct perf_probe_point *pp = &pev->point;
-	struct symbol *sym;
-	struct map *map = NULL;
-	char *function = NULL;
-	int ret = -EINVAL;
-	unsigned long long vaddr = 0;
-
-	if (!pp->function) {
-		pr_warning("No function specified for uprobes");
-		goto out;
-	}
-
-	function = strdup(pp->function);
-	if (!function) {
-		pr_warning("Failed to allocate memory by strdup.\n");
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	map = dso__new_map(exec);
-	if (!map) {
-		pr_warning("Cannot find appropriate DSO for %s.\n", exec);
-		goto out;
-	}
-	available_func_filter = strfilter__new(function, NULL);
 	if (map__load(map, filter_available_functions)) {
-		pr_err("Failed to load map.\n");
-		goto out;
-	}
-
-	sym = map__find_symbol_by_name(map, function, NULL);
-	if (!sym) {
-		pr_warning("Cannot find %s in DSO %s\n", function, exec);
-		goto out;
-	}
-
-	if (map->start > sym->start)
-		vaddr = map->start;
-	vaddr += sym->start + pp->offset + map->pgoff;
-	pp->offset = 0;
-
-	if (!pev->event) {
-		pev->event = function;
-		function = NULL;
-	}
-	if (!pev->group) {
-		char *ptr1, *ptr2, *exec_copy;
-
-		pev->group = zalloc(sizeof(char *) * 64);
-		exec_copy = strdup(exec);
-		if (!exec_copy) {
-			ret = -ENOMEM;
-			pr_warning("Failed to copy exec string.\n");
-			goto out;
-		}
-
-		ptr1 = strdup(basename(exec_copy));
-		if (ptr1) {
-			ptr2 = strpbrk(ptr1, "-._");
-			if (ptr2)
-				*ptr2 = '\0';
-			e_snprintf(pev->group, 64, "%s_%s", PERFPROBE_GROUP,
-					ptr1);
-			free(ptr1);
-		}
-		free(exec_copy);
-	}
-	free(pp->function);
-	pp->function = zalloc(sizeof(char *) * MAX_PROBE_ARGS);
-	if (!pp->function) {
-		ret = -ENOMEM;
-		pr_warning("Failed to allocate memory by zalloc.\n");
-		goto out;
+		pr_err("Failed to load symbols in %s\n", (target) ? : "kernel");
+		goto end;
 	}
-	e_snprintf(pp->function, MAX_PROBE_ARGS, "0x%llx", vaddr);
-	ret = 0;
+	if (!dso__sorted_by_name(map->dso, map->type))
+		dso__sort_by_name(map->dso, map->type);
 
-out:
-	if (map) {
+	/* Show all (filtered) symbols */
+	setup_pager();
+	dso__fprintf_symbols_by_name(map->dso, map->type, stdout);
+end:
+	if (user) {
 		dso__delete(map->dso);
 		map__delete(map);
 	}
-	if (function)
-		free(function);
+	exit_symbol_maps();
+
 	return ret;
 }
+
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index fcaf727..776c934 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -2,6 +2,7 @@
 #define _PROBE_EVENT_H
 
 #include <stdbool.h>
+#include "intlist.h"
 #include "strlist.h"
 #include "strfilter.h"
 
@@ -76,13 +77,6 @@ struct perf_probe_event {
 	struct perf_probe_arg	*args;	/* Arguments */
 };
 
-
-/* Line number container */
-struct line_node {
-	struct list_head	list;
-	int			line;
-};
-
 /* Line range */
 struct line_range {
 	char			*file;		/* File name */
@@ -92,7 +86,7 @@ struct line_range {
 	int			offset;		/* Start line offset */
 	char			*path;		/* Real path name */
 	char			*comp_dir;	/* Compile directory */
-	struct list_head	line_list;	/* Visible lines */
+	struct intlist		*line_list;	/* Visible lines */
 };
 
 /* List of variables */
@@ -124,7 +118,7 @@ extern int parse_line_range_desc(const char *cmd, struct line_range *lr);
 extern void line_range__clear(struct line_range *lr);
 
 /* Initialize line range */
-extern void line_range__init(struct line_range *lr);
+extern int line_range__init(struct line_range *lr);
 
 /* Internal use: Return kernel/module path */
 extern const char *kernel_get_module_path(const char *module);
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 061edb1..df02386 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -34,7 +34,9 @@
 
 #include <linux/bitops.h>
 #include "event.h"
+#include "dso.h"
 #include "debug.h"
+#include "intlist.h"
 #include "util.h"
 #include "symbol.h"
 #include "probe-finder.h"
@@ -42,65 +44,6 @@
 /* Kprobe tracer basic type is up to u64 */
 #define MAX_BASIC_TYPE_BITS	64
 
-/* Line number list operations */
-
-/* Add a line to line number list */
-static int line_list__add_line(struct list_head *head, int line)
-{
-	struct line_node *ln;
-	struct list_head *p;
-
-	/* Reverse search, because new line will be the last one */
-	list_for_each_entry_reverse(ln, head, list) {
-		if (ln->line < line) {
-			p = &ln->list;
-			goto found;
-		} else if (ln->line == line)	/* Already exist */
-			return 1;
-	}
-	/* List is empty, or the smallest entry */
-	p = head;
-found:
-	pr_debug("line list: add a line %u\n", line);
-	ln = zalloc(sizeof(struct line_node));
-	if (ln == NULL)
-		return -ENOMEM;
-	ln->line = line;
-	INIT_LIST_HEAD(&ln->list);
-	list_add(&ln->list, p);
-	return 0;
-}
-
-/* Check if the line in line number list */
-static int line_list__has_line(struct list_head *head, int line)
-{
-	struct line_node *ln;
-
-	/* Reverse search, because new line will be the last one */
-	list_for_each_entry(ln, head, list)
-		if (ln->line == line)
-			return 1;
-
-	return 0;
-}
-
-/* Init line number list */
-static void line_list__init(struct list_head *head)
-{
-	INIT_LIST_HEAD(head);
-}
-
-/* Free line number list */
-static void line_list__free(struct list_head *head)
-{
-	struct line_node *ln;
-	while (!list_empty(head)) {
-		ln = list_first_entry(head, struct line_node, list);
-		list_del(&ln->list);
-		free(ln);
-	}
-}
-
 /* Dwarf FL wrappers */
 static char *debuginfo_path;	/* Currently dummy */
 
@@ -147,80 +90,7 @@ error:
 	return -ENOENT;
 }
 
-#if _ELFUTILS_PREREQ(0, 148)
-/* This method is buggy if elfutils is older than 0.148 */
-static int __linux_kernel_find_elf(Dwfl_Module *mod,
-				   void **userdata,
-				   const char *module_name,
-				   Dwarf_Addr base,
-				   char **file_name, Elf **elfp)
-{
-	int fd;
-	const char *path = kernel_get_module_path(module_name);
-
-	pr_debug2("Use file %s for %s\n", path, module_name);
-	if (path) {
-		fd = open(path, O_RDONLY);
-		if (fd >= 0) {
-			*file_name = strdup(path);
-			return fd;
-		}
-	}
-	/* If failed, try to call standard method */
-	return dwfl_linux_kernel_find_elf(mod, userdata, module_name, base,
-					  file_name, elfp);
-}
-
-static const Dwfl_Callbacks kernel_callbacks = {
-	.find_debuginfo = dwfl_standard_find_debuginfo,
-	.debuginfo_path = &debuginfo_path,
-
-	.find_elf = __linux_kernel_find_elf,
-	.section_address = dwfl_linux_kernel_module_section_address,
-};
-
-/* Get a Dwarf from live kernel image */
-static int debuginfo__init_online_kernel_dwarf(struct debuginfo *dbg,
-					       Dwarf_Addr addr)
-{
-	dbg->dwfl = dwfl_begin(&kernel_callbacks);
-	if (!dbg->dwfl)
-		return -EINVAL;
-
-	/* Load the kernel dwarves: Don't care the result here */
-	dwfl_linux_kernel_report_kernel(dbg->dwfl);
-	dwfl_linux_kernel_report_modules(dbg->dwfl);
-
-	dbg->dbg = dwfl_addrdwarf(dbg->dwfl, addr, &dbg->bias);
-	/* Here, check whether we could get a real dwarf */
-	if (!dbg->dbg) {
-		pr_debug("Failed to find kernel dwarf at %lx\n",
-			 (unsigned long)addr);
-		dwfl_end(dbg->dwfl);
-		memset(dbg, 0, sizeof(*dbg));
-		return -ENOENT;
-	}
-
-	return 0;
-}
-#else
-/* With older elfutils, this just support kernel module... */
-static int debuginfo__init_online_kernel_dwarf(struct debuginfo *dbg,
-					       Dwarf_Addr addr __maybe_unused)
-{
-	const char *path = kernel_get_module_path("kernel");
-
-	if (!path) {
-		pr_err("Failed to find vmlinux path\n");
-		return -ENOENT;
-	}
-
-	pr_debug2("Use file %s for debuginfo\n", path);
-	return debuginfo__init_offline_dwarf(dbg, path);
-}
-#endif
-
-struct debuginfo *debuginfo__new(const char *path)
+static struct debuginfo *__debuginfo__new(const char *path)
 {
 	struct debuginfo *dbg = zalloc(sizeof(*dbg));
 	if (!dbg)
@@ -228,21 +98,44 @@ struct debuginfo *debuginfo__new(const char *path)
 
 	if (debuginfo__init_offline_dwarf(dbg, path) < 0)
 		zfree(&dbg);
-
+	if (dbg)
+		pr_debug("Open Debuginfo file: %s\n", path);
 	return dbg;
 }
 
-struct debuginfo *debuginfo__new_online_kernel(unsigned long addr)
-{
-	struct debuginfo *dbg = zalloc(sizeof(*dbg));
+enum dso_binary_type distro_dwarf_types[] = {
+	DSO_BINARY_TYPE__FEDORA_DEBUGINFO,
+	DSO_BINARY_TYPE__UBUNTU_DEBUGINFO,
+	DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO,
+	DSO_BINARY_TYPE__BUILDID_DEBUGINFO,
+	DSO_BINARY_TYPE__NOT_FOUND,
+};
 
-	if (!dbg)
-		return NULL;
+struct debuginfo *debuginfo__new(const char *path)
+{
+	enum dso_binary_type *type;
+	char buf[PATH_MAX], nil = '\0';
+	struct dso *dso;
+	struct debuginfo *dinfo = NULL;
+
+	/* Try to open distro debuginfo files */
+	dso = dso__new(path);
+	if (!dso)
+		goto out;
 
-	if (debuginfo__init_online_kernel_dwarf(dbg, (Dwarf_Addr)addr) < 0)
-		zfree(&dbg);
+	for (type = distro_dwarf_types;
+	     !dinfo && *type != DSO_BINARY_TYPE__NOT_FOUND;
+	     type++) {
+		if (dso__read_binary_type_filename(dso, *type, &nil,
+						   buf, PATH_MAX) < 0)
+			continue;
+		dinfo = __debuginfo__new(buf);
+	}
+	dso__delete(dso);
 
-	return dbg;
+out:
+	/* if failed to open all distro debuginfo, open given binary */
+	return dinfo ? : __debuginfo__new(path);
 }
 
 void debuginfo__delete(struct debuginfo *dbg)
@@ -880,7 +773,7 @@ static int find_probe_point_by_line(struct probe_finder *pf)
 }
 
 /* Find lines which match lazy pattern */
-static int find_lazy_match_lines(struct list_head *head,
+static int find_lazy_match_lines(struct intlist *list,
 				 const char *fname, const char *pat)
 {
 	FILE *fp;
@@ -901,7 +794,7 @@ static int find_lazy_match_lines(struct list_head *head,
 			line[len - 1] = '\0';
 
 		if (strlazymatch(line, pat)) {
-			line_list__add_line(head, linenum);
+			intlist__add(list, linenum);
 			count++;
 		}
 		linenum++;
@@ -924,7 +817,7 @@ static int probe_point_lazy_walker(const char *fname, int lineno,
 	Dwarf_Die *sc_die, die_mem;
 	int ret;
 
-	if (!line_list__has_line(&pf->lcache, lineno) ||
+	if (!intlist__has_entry(pf->lcache, lineno) ||
 	    strtailcmp(fname, pf->fname) != 0)
 		return 0;
 
@@ -952,9 +845,9 @@ static int find_probe_point_lazy(Dwarf_Die *sp_die, struct probe_finder *pf)
 {
 	int ret = 0;
 
-	if (list_empty(&pf->lcache)) {
+	if (intlist__empty(pf->lcache)) {
 		/* Matching lazy line pattern */
-		ret = find_lazy_match_lines(&pf->lcache, pf->fname,
+		ret = find_lazy_match_lines(pf->lcache, pf->fname,
 					    pf->pev->point.lazy_line);
 		if (ret <= 0)
 			return ret;
@@ -1096,7 +989,9 @@ static int debuginfo__find_probes(struct debuginfo *dbg,
 #endif
 
 	off = 0;
-	line_list__init(&pf->lcache);
+	pf->lcache = intlist__new(NULL);
+	if (!pf->lcache)
+		return -ENOMEM;
 
 	/* Fastpath: lookup by function name from .debug_pubnames section */
 	if (pp->function) {
@@ -1149,7 +1044,8 @@ static int debuginfo__find_probes(struct debuginfo *dbg,
 	}
 
 found:
-	line_list__free(&pf->lcache);
+	intlist__delete(pf->lcache);
+	pf->lcache = NULL;
 
 	return ret;
 }
@@ -1537,7 +1433,7 @@ static int line_range_add_line(const char *src, unsigned int lineno,
 		if (lr->path == NULL)
 			return -ENOMEM;
 	}
-	return line_list__add_line(&lr->line_list, lineno);
+	return intlist__add(lr->line_list, lineno);
 }
 
 static int line_range_walk_cb(const char *fname, int lineno,
@@ -1565,7 +1461,7 @@ static int find_line_range_by_line(Dwarf_Die *sp_die, struct line_finder *lf)
 
 	/* Update status */
 	if (ret >= 0)
-		if (!list_empty(&lf->lr->line_list))
+		if (!intlist__empty(lf->lr->line_list))
 			ret = lf->found = 1;
 		else
 			ret = 0;	/* Lines are not found */
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index ffc33cd..92590b2 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -3,6 +3,7 @@
 
 #include <stdbool.h>
 #include "util.h"
+#include "intlist.h"
 #include "probe-event.h"
 
 #define MAX_PROBE_BUFFER	1024
@@ -29,8 +30,8 @@ struct debuginfo {
 	Dwarf_Addr	bias;
 };
 
+/* This also tries to open distro debuginfo */
 extern struct debuginfo *debuginfo__new(const char *path);
-extern struct debuginfo *debuginfo__new_online_kernel(unsigned long addr);
 extern void debuginfo__delete(struct debuginfo *dbg);
 
 /* Find probe_trace_events specified by perf_probe_event from debuginfo */
@@ -66,7 +67,7 @@ struct probe_finder {
 	const char		*fname;		/* Real file name */
 	Dwarf_Die		cu_die;		/* Current CU */
 	Dwarf_Die		sp_die;
-	struct list_head	lcache;		/* Line cache for lazy match */
+	struct intlist		*lcache;	/* Line cache for lazy match */
 
 	/* For variable searching */
 #if _ELFUTILS_PREREQ(0, 142)
diff --git a/tools/perf/util/python-ext-sources b/tools/perf/util/python-ext-sources
index 595bfc7..16a475a 100644
--- a/tools/perf/util/python-ext-sources
+++ b/tools/perf/util/python-ext-sources
@@ -17,6 +17,6 @@ util/xyarray.c
 util/cgroup.c
 util/rblist.c
 util/strlist.c
-util/fs.c
+../lib/api/fs/fs.c
 util/trace-event.c
 ../../lib/rbtree.c
diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index 3737625..049e0a0 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -2,7 +2,7 @@
 #include "evsel.h"
 #include "cpumap.h"
 #include "parse-events.h"
-#include "fs.h"
+#include <api/fs/fs.h>
 #include "util.h"
 
 typedef void (*setup_probe_fn_t)(struct perf_evsel *evsel);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 5da6ce7..55960f2 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -702,11 +702,12 @@ static void regs_dump__printf(u64 mask, u64 *regs)
 	}
 }
 
-static void regs_user__printf(struct perf_sample *sample, u64 mask)
+static void regs_user__printf(struct perf_sample *sample)
 {
 	struct regs_dump *user_regs = &sample->user_regs;
 
 	if (user_regs->regs) {
+		u64 mask = user_regs->mask;
 		printf("... user regs: mask 0x%" PRIx64 "\n", mask);
 		regs_dump__printf(mask, user_regs->regs);
 	}
@@ -793,7 +794,7 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 	if (!dump_trace)
 		return;
 
-	printf("(IP, %d): %d/%d: %#" PRIx64 " period: %" PRIu64 " addr: %#" PRIx64 "\n",
+	printf("(IP, 0x%x): %d/%d: %#" PRIx64 " period: %" PRIu64 " addr: %#" PRIx64 "\n",
 	       event->header.misc, sample->pid, sample->tid, sample->ip,
 	       sample->period, sample->addr);
 
@@ -806,7 +807,7 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 		branch_stack__printf(sample);
 
 	if (sample_type & PERF_SAMPLE_REGS_USER)
-		regs_user__printf(sample, evsel->attr.sample_regs_user);
+		regs_user__printf(sample);
 
 	if (sample_type & PERF_SAMPLE_STACK_USER)
 		stack_user__printf(&sample->user_stack);
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 516d19f..3b7dbf5 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -506,6 +506,8 @@ int filename__read_debuglink(const char *filename, char *debuglink,
 	/* the start of this section is a zero-terminated string */
 	strncpy(debuglink, data->d_buf, size);
 
+	err = 0;
+
 out_elf_end:
 	elf_end(elf);
 out_close:
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e89afc0..95e2497 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -410,7 +410,7 @@ struct symbol *dso__find_symbol(struct dso *dso,
 	return symbols__find(&dso->symbols[type], addr);
 }
 
-struct symbol *dso__first_symbol(struct dso *dso, enum map_type type)
+static struct symbol *dso__first_symbol(struct dso *dso, enum map_type type)
 {
 	return symbols__first(&dso->symbols[type]);
 }
@@ -1251,6 +1251,46 @@ out_failure:
 	return -1;
 }
 
+static bool dso__is_compatible_symtab_type(struct dso *dso, bool kmod,
+					   enum dso_binary_type type)
+{
+	switch (type) {
+	case DSO_BINARY_TYPE__JAVA_JIT:
+	case DSO_BINARY_TYPE__DEBUGLINK:
+	case DSO_BINARY_TYPE__SYSTEM_PATH_DSO:
+	case DSO_BINARY_TYPE__FEDORA_DEBUGINFO:
+	case DSO_BINARY_TYPE__UBUNTU_DEBUGINFO:
+	case DSO_BINARY_TYPE__BUILDID_DEBUGINFO:
+	case DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO:
+		return !kmod && dso->kernel == DSO_TYPE_USER;
+
+	case DSO_BINARY_TYPE__KALLSYMS:
+	case DSO_BINARY_TYPE__VMLINUX:
+	case DSO_BINARY_TYPE__KCORE:
+		return dso->kernel == DSO_TYPE_KERNEL;
+
+	case DSO_BINARY_TYPE__GUEST_KALLSYMS:
+	case DSO_BINARY_TYPE__GUEST_VMLINUX:
+	case DSO_BINARY_TYPE__GUEST_KCORE:
+		return dso->kernel == DSO_TYPE_GUEST_KERNEL;
+
+	case DSO_BINARY_TYPE__GUEST_KMODULE:
+	case DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE:
+		/*
+		 * kernel modules know their symtab type - it's set when
+		 * creating a module dso in machine__new_module().
+		 */
+		return kmod && dso->symtab_type == type;
+
+	case DSO_BINARY_TYPE__BUILD_ID_CACHE:
+		return true;
+
+	case DSO_BINARY_TYPE__NOT_FOUND:
+	default:
+		return false;
+	}
+}
+
 int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 {
 	char *name;
@@ -1261,6 +1301,7 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 	int ss_pos = 0;
 	struct symsrc ss_[2];
 	struct symsrc *syms_ss = NULL, *runtime_ss = NULL;
+	bool kmod;
 
 	dso__set_loaded(dso, map->type);
 
@@ -1301,7 +1342,11 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 	if (!name)
 		return -1;
 
-	/* Iterate over candidate debug images.
+	kmod = dso->symtab_type == DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE ||
+		dso->symtab_type == DSO_BINARY_TYPE__GUEST_KMODULE;
+
+	/*
+	 * Iterate over candidate debug images.
 	 * Keep track of "interesting" ones (those which have a symtab, dynsym,
 	 * and/or opd section) for processing.
 	 */
@@ -1311,6 +1356,9 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 
 		enum dso_binary_type symtab_type = binary_type_symtab[i];
 
+		if (!dso__is_compatible_symtab_type(dso, kmod, symtab_type))
+			continue;
+
 		if (dso__read_binary_type_filename(dso, symtab_type,
 						   root_dir, name, PATH_MAX))
 			continue;
@@ -1353,15 +1401,10 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 	if (!runtime_ss && syms_ss)
 		runtime_ss = syms_ss;
 
-	if (syms_ss) {
-		int km;
-
-		km = dso->symtab_type == DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE ||
-		     dso->symtab_type == DSO_BINARY_TYPE__GUEST_KMODULE;
-		ret = dso__load_sym(dso, map, syms_ss, runtime_ss, filter, km);
-	} else {
+	if (syms_ss)
+		ret = dso__load_sym(dso, map, syms_ss, runtime_ss, filter, kmod);
+	else
 		ret = -1;
-	}
 
 	if (ret > 0) {
 		int nr_plt;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index fffe288..501e4e7 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -79,6 +79,17 @@ struct symbol {
 void symbol__delete(struct symbol *sym);
 void symbols__delete(struct rb_root *symbols);
 
+/* symbols__for_each_entry - iterate over symbols (rb_root)
+ *
+ * @symbols: the rb_root of symbols
+ * @pos: the 'struct symbol *' to use as a loop cursor
+ * @nd: the 'struct rb_node *' to use as a temporary storage
+ */
+#define symbols__for_each_entry(symbols, pos, nd)			\
+	for (nd = rb_first(symbols);					\
+	     nd && (pos = rb_entry(nd, struct symbol, rb_node));	\
+	     nd = rb_next(nd))
+
 static inline size_t symbol__size(const struct symbol *sym)
 {
 	return sym->end - sym->start + 1;
@@ -175,7 +186,7 @@ struct addr_location {
 	struct symbol *sym;
 	u64	      addr;
 	char	      level;
-	bool	      filtered;
+	u8	      filtered;
 	u8	      cpumode;
 	s32	      cpu;
 };
@@ -223,7 +234,6 @@ struct symbol *dso__find_symbol(struct dso *dso, enum map_type type,
 				u64 addr);
 struct symbol *dso__find_symbol_by_name(struct dso *dso, enum map_type type,
 					const char *name);
-struct symbol *dso__first_symbol(struct dso *dso, enum map_type type);
 
 int filename__read_build_id(const char *filename, void *bf, size_t size);
 int sysfs__read_build_id(const char *filename, void *bf, size_t size);
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 0358882..3ce0498 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -142,3 +142,24 @@ int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp)
 
 	return 0;
 }
+
+void thread__find_cpumode_addr_location(struct thread *thread,
+					struct machine *machine,
+					enum map_type type, u64 addr,
+					struct addr_location *al)
+{
+	size_t i;
+	const u8 const cpumodes[] = {
+		PERF_RECORD_MISC_USER,
+		PERF_RECORD_MISC_KERNEL,
+		PERF_RECORD_MISC_GUEST_USER,
+		PERF_RECORD_MISC_GUEST_KERNEL
+	};
+
+	for (i = 0; i < ARRAY_SIZE(cpumodes); i++) {
+		thread__find_addr_location(thread, machine, cpumodes[i], type,
+					   addr, al);
+		if (al->map)
+			break;
+	}
+}
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 5b856bf..9b29f08 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -44,12 +44,6 @@ void thread__insert_map(struct thread *thread, struct map *map);
 int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp);
 size_t thread__fprintf(struct thread *thread, FILE *fp);
 
-static inline struct map *thread__find_map(struct thread *thread,
-					   enum map_type type, u64 addr)
-{
-	return thread ? map_groups__find(&thread->mg, type, addr) : NULL;
-}
-
 void thread__find_addr_map(struct thread *thread, struct machine *machine,
 			   u8 cpumode, enum map_type type, u64 addr,
 			   struct addr_location *al);
@@ -58,6 +52,11 @@ void thread__find_addr_location(struct thread *thread, struct machine *machine,
 				u8 cpumode, enum map_type type, u64 addr,
 				struct addr_location *al);
 
+void thread__find_cpumode_addr_location(struct thread *thread,
+					struct machine *machine,
+					enum map_type type, u64 addr,
+					struct addr_location *al);
+
 static inline void *thread__priv(struct thread *thread)
 {
 	return thread->priv;
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index e0d6d07f..c36636f 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -126,6 +126,7 @@ void event_format__print(struct event_format *event,
 	trace_seq_init(&s);
 	pevent_event_info(&s, event, &record);
 	trace_seq_do_printf(&s);
+	trace_seq_destroy(&s);
 }
 
 void parse_proc_kallsyms(struct pevent *pevent,
diff --git a/tools/perf/util/unwind-libdw.c b/tools/perf/util/unwind-libdw.c
new file mode 100644
index 0000000..67db73e
--- /dev/null
+++ b/tools/perf/util/unwind-libdw.c
@@ -0,0 +1,210 @@
+#include <linux/compiler.h>
+#include <elfutils/libdw.h>
+#include <elfutils/libdwfl.h>
+#include <inttypes.h>
+#include <errno.h>
+#include "unwind.h"
+#include "unwind-libdw.h"
+#include "machine.h"
+#include "thread.h"
+#include "types.h"
+#include "event.h"
+#include "perf_regs.h"
+
+static char *debuginfo_path;
+
+static const Dwfl_Callbacks offline_callbacks = {
+	.find_debuginfo		= dwfl_standard_find_debuginfo,
+	.debuginfo_path		= &debuginfo_path,
+	.section_address	= dwfl_offline_section_address,
+};
+
+static int __report_module(struct addr_location *al, u64 ip,
+			    struct unwind_info *ui)
+{
+	Dwfl_Module *mod;
+	struct dso *dso = NULL;
+
+	thread__find_addr_location(ui->thread, ui->machine,
+				   PERF_RECORD_MISC_USER,
+				   MAP__FUNCTION, ip, al);
+
+	if (al->map)
+		dso = al->map->dso;
+
+	if (!dso)
+		return 0;
+
+	mod = dwfl_addrmodule(ui->dwfl, ip);
+	if (!mod)
+		mod = dwfl_report_elf(ui->dwfl, dso->short_name,
+				      dso->long_name, -1, al->map->start,
+				      false);
+
+	return mod && dwfl_addrmodule(ui->dwfl, ip) == mod ? 0 : -1;
+}
+
+static int report_module(u64 ip, struct unwind_info *ui)
+{
+	struct addr_location al;
+
+	return __report_module(&al, ip, ui);
+}
+
+static int entry(u64 ip, struct unwind_info *ui)
+
+{
+	struct unwind_entry e;
+	struct addr_location al;
+
+	if (__report_module(&al, ip, ui))
+		return -1;
+
+	e.ip  = ip;
+	e.map = al.map;
+	e.sym = al.sym;
+
+	pr_debug("unwind: %s:ip = 0x%" PRIx64 " (0x%" PRIx64 ")\n",
+		 al.sym ? al.sym->name : "''",
+		 ip,
+		 al.map ? al.map->map_ip(al.map, ip) : (u64) 0);
+
+	return ui->cb(&e, ui->arg);
+}
+
+static pid_t next_thread(Dwfl *dwfl, void *arg, void **thread_argp)
+{
+	/* We want only single thread to be processed. */
+	if (*thread_argp != NULL)
+		return 0;
+
+	*thread_argp = arg;
+	return dwfl_pid(dwfl);
+}
+
+static int access_dso_mem(struct unwind_info *ui, Dwarf_Addr addr,
+			  Dwarf_Word *data)
+{
+	struct addr_location al;
+	ssize_t size;
+
+	thread__find_addr_map(ui->thread, ui->machine, PERF_RECORD_MISC_USER,
+			      MAP__FUNCTION, addr, &al);
+	if (!al.map) {
+		pr_debug("unwind: no map for %lx\n", (unsigned long)addr);
+		return -1;
+	}
+
+	if (!al.map->dso)
+		return -1;
+
+	size = dso__data_read_addr(al.map->dso, al.map, ui->machine,
+				   addr, (u8 *) data, sizeof(*data));
+
+	return !(size == sizeof(*data));
+}
+
+static bool memory_read(Dwfl *dwfl __maybe_unused, Dwarf_Addr addr, Dwarf_Word *result,
+			void *arg)
+{
+	struct unwind_info *ui = arg;
+	struct stack_dump *stack = &ui->sample->user_stack;
+	u64 start, end;
+	int offset;
+	int ret;
+
+	ret = perf_reg_value(&start, &ui->sample->user_regs, PERF_REG_SP);
+	if (ret)
+		return false;
+
+	end = start + stack->size;
+
+	/* Check overflow. */
+	if (addr + sizeof(Dwarf_Word) < addr)
+		return false;
+
+	if (addr < start || addr + sizeof(Dwarf_Word) > end) {
+		ret = access_dso_mem(ui, addr, result);
+		if (ret) {
+			pr_debug("unwind: access_mem 0x%" PRIx64 " not inside range"
+				 " 0x%" PRIx64 "-0x%" PRIx64 "\n",
+				addr, start, end);
+			return false;
+		}
+		return true;
+	}
+
+	offset  = addr - start;
+	*result = *(Dwarf_Word *)&stack->data[offset];
+	pr_debug("unwind: access_mem addr 0x%" PRIx64 ", val %lx, offset %d\n",
+		 addr, (unsigned long)*result, offset);
+	return true;
+}
+
+static const Dwfl_Thread_Callbacks callbacks = {
+	.next_thread		= next_thread,
+	.memory_read		= memory_read,
+	.set_initial_registers	= libdw__arch_set_initial_registers,
+};
+
+static int
+frame_callback(Dwfl_Frame *state, void *arg)
+{
+	struct unwind_info *ui = arg;
+	Dwarf_Addr pc;
+
+	if (!dwfl_frame_pc(state, &pc, NULL)) {
+		pr_err("%s", dwfl_errmsg(-1));
+		return DWARF_CB_ABORT;
+	}
+
+	return entry(pc, ui) || !(--ui->max_stack) ?
+	       DWARF_CB_ABORT : DWARF_CB_OK;
+}
+
+int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
+			struct machine *machine, struct thread *thread,
+			struct perf_sample *data,
+			int max_stack)
+{
+	struct unwind_info ui = {
+		.sample		= data,
+		.thread		= thread,
+		.machine	= machine,
+		.cb		= cb,
+		.arg		= arg,
+		.max_stack	= max_stack,
+	};
+	Dwarf_Word ip;
+	int err = -EINVAL;
+
+	if (!data->user_regs.regs)
+		return -EINVAL;
+
+	ui.dwfl = dwfl_begin(&offline_callbacks);
+	if (!ui.dwfl)
+		goto out;
+
+	err = perf_reg_value(&ip, &data->user_regs, PERF_REG_IP);
+	if (err)
+		goto out;
+
+	err = report_module(ip, &ui);
+	if (err)
+		goto out;
+
+	if (!dwfl_attach_state(ui.dwfl, EM_NONE, thread->tid, &callbacks, &ui))
+		goto out;
+
+	err = dwfl_getthread_frames(ui.dwfl, thread->tid, frame_callback, &ui);
+
+	if (err && !ui.max_stack)
+		err = 0;
+
+ out:
+	if (err)
+		pr_debug("unwind: failed with '%s'\n", dwfl_errmsg(-1));
+
+	dwfl_end(ui.dwfl);
+	return 0;
+}
diff --git a/tools/perf/util/unwind-libdw.h b/tools/perf/util/unwind-libdw.h
new file mode 100644
index 0000000..417a142
--- /dev/null
+++ b/tools/perf/util/unwind-libdw.h
@@ -0,0 +1,21 @@
+#ifndef __PERF_UNWIND_LIBDW_H
+#define __PERF_UNWIND_LIBDW_H
+
+#include <elfutils/libdwfl.h>
+#include "event.h"
+#include "thread.h"
+#include "unwind.h"
+
+bool libdw__arch_set_initial_registers(Dwfl_Thread *thread, void *arg);
+
+struct unwind_info {
+	Dwfl			*dwfl;
+	struct perf_sample      *sample;
+	struct machine          *machine;
+	struct thread           *thread;
+	unwind_entry_cb_t	cb;
+	void			*arg;
+	int			max_stack;
+};
+
+#endif /* __PERF_UNWIND_LIBDW_H */
diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind-libunwind.c
similarity index 92%
rename from tools/perf/util/unwind.c
rename to tools/perf/util/unwind-libunwind.c
index 742f23b..bd5768d 100644
--- a/tools/perf/util/unwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -86,7 +86,6 @@ struct unwind_info {
 	struct perf_sample	*sample;
 	struct machine		*machine;
 	struct thread		*thread;
-	u64			sample_uregs;
 };
 
 #define dw_read(ptr, type, end) ({	\
@@ -391,30 +390,13 @@ static int access_dso_mem(struct unwind_info *ui, unw_word_t addr,
 	return !(size == sizeof(*data));
 }
 
-static int reg_value(unw_word_t *valp, struct regs_dump *regs, int id,
-		     u64 sample_regs)
-{
-	int i, idx = 0;
-
-	if (!(sample_regs & (1 << id)))
-		return -EINVAL;
-
-	for (i = 0; i < id; i++) {
-		if (sample_regs & (1 << i))
-			idx++;
-	}
-
-	*valp = regs->regs[idx];
-	return 0;
-}
-
 static int access_mem(unw_addr_space_t __maybe_unused as,
 		      unw_word_t addr, unw_word_t *valp,
 		      int __write, void *arg)
 {
 	struct unwind_info *ui = arg;
 	struct stack_dump *stack = &ui->sample->user_stack;
-	unw_word_t start, end;
+	u64 start, end;
 	int offset;
 	int ret;
 
@@ -424,8 +406,7 @@ static int access_mem(unw_addr_space_t __maybe_unused as,
 		return 0;
 	}
 
-	ret = reg_value(&start, &ui->sample->user_regs, PERF_REG_SP,
-			ui->sample_uregs);
+	ret = perf_reg_value(&start, &ui->sample->user_regs, PERF_REG_SP);
 	if (ret)
 		return ret;
 
@@ -438,8 +419,9 @@ static int access_mem(unw_addr_space_t __maybe_unused as,
 	if (addr < start || addr + sizeof(unw_word_t) >= end) {
 		ret = access_dso_mem(ui, addr, valp);
 		if (ret) {
-			pr_debug("unwind: access_mem %p not inside range %p-%p\n",
-				(void *)addr, (void *)start, (void *)end);
+			pr_debug("unwind: access_mem %p not inside range"
+				 " 0x%" PRIx64 "-0x%" PRIx64 "\n",
+				 (void *) addr, start, end);
 			*valp = 0;
 			return ret;
 		}
@@ -448,8 +430,8 @@ static int access_mem(unw_addr_space_t __maybe_unused as,
 
 	offset = addr - start;
 	*valp  = *(unw_word_t *)&stack->data[offset];
-	pr_debug("unwind: access_mem addr %p, val %lx, offset %d\n",
-		 (void *)addr, (unsigned long)*valp, offset);
+	pr_debug("unwind: access_mem addr %p val %lx, offset %d\n",
+		 (void *) addr, (unsigned long)*valp, offset);
 	return 0;
 }
 
@@ -459,6 +441,7 @@ static int access_reg(unw_addr_space_t __maybe_unused as,
 {
 	struct unwind_info *ui = arg;
 	int id, ret;
+	u64 val;
 
 	/* Don't support write, I suspect we don't need it. */
 	if (__write) {
@@ -471,16 +454,17 @@ static int access_reg(unw_addr_space_t __maybe_unused as,
 		return 0;
 	}
 
-	id = unwind__arch_reg_id(regnum);
+	id = libunwind__arch_reg_id(regnum);
 	if (id < 0)
 		return -EINVAL;
 
-	ret = reg_value(valp, &ui->sample->user_regs, id, ui->sample_uregs);
+	ret = perf_reg_value(&val, &ui->sample->user_regs, id);
 	if (ret) {
 		pr_err("unwind: can't read reg %d\n", regnum);
 		return ret;
 	}
 
+	*valp = (unw_word_t) val;
 	pr_debug("unwind: reg %d, val %lx\n", regnum, (unsigned long)*valp);
 	return 0;
 }
@@ -563,7 +547,7 @@ static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
 		unw_word_t ip;
 
 		unw_get_reg(&c, UNW_REG_IP, &ip);
-		ret = entry(ip, ui->thread, ui->machine, cb, arg);
+		ret = ip ? entry(ip, ui->thread, ui->machine, cb, arg) : 0;
 	}
 
 	unw_destroy_addr_space(addr_space);
@@ -572,13 +556,11 @@ static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
 
 int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 			struct machine *machine, struct thread *thread,
-			u64 sample_uregs, struct perf_sample *data,
-			int max_stack)
+			struct perf_sample *data, int max_stack)
 {
-	unw_word_t ip;
+	u64 ip;
 	struct unwind_info ui = {
 		.sample       = data,
-		.sample_uregs = sample_uregs,
 		.thread       = thread,
 		.machine      = machine,
 	};
@@ -587,7 +569,7 @@ int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 	if (!data->user_regs.regs)
 		return -EINVAL;
 
-	ret = reg_value(&ip, &data->user_regs, PERF_REG_IP, sample_uregs);
+	ret = perf_reg_value(&ip, &data->user_regs, PERF_REG_IP);
 	if (ret)
 		return ret;
 
@@ -595,5 +577,5 @@ int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 	if (ret)
 		return -ENOMEM;
 
-	return get_entries(&ui, cb, arg, max_stack);
+	return --max_stack > 0 ? get_entries(&ui, cb, arg, max_stack) : 0;
 }
diff --git a/tools/perf/util/unwind.h b/tools/perf/util/unwind.h
index d5966f49..b031316 100644
--- a/tools/perf/util/unwind.h
+++ b/tools/perf/util/unwind.h
@@ -13,24 +13,25 @@ struct unwind_entry {
 
 typedef int (*unwind_entry_cb_t)(struct unwind_entry *entry, void *arg);
 
-#ifdef HAVE_LIBUNWIND_SUPPORT
+#ifdef HAVE_DWARF_UNWIND_SUPPORT
 int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 			struct machine *machine,
 			struct thread *thread,
-			u64 sample_uregs,
 			struct perf_sample *data, int max_stack);
-int unwind__arch_reg_id(int regnum);
+/* libunwind specific */
+#ifdef HAVE_LIBUNWIND_SUPPORT
+int libunwind__arch_reg_id(int regnum);
+#endif
 #else
 static inline int
 unwind__get_entries(unwind_entry_cb_t cb __maybe_unused,
 		    void *arg __maybe_unused,
 		    struct machine *machine __maybe_unused,
 		    struct thread *thread __maybe_unused,
-		    u64 sample_uregs __maybe_unused,
 		    struct perf_sample *data __maybe_unused,
 		    int max_stack __maybe_unused)
 {
 	return 0;
 }
-#endif /* HAVE_LIBUNWIND_SUPPORT */
+#endif /* HAVE_DWARF_UNWIND_SUPPORT */
 #endif /* __UNWIND_H */
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 42ad667..9f66549 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -1,6 +1,6 @@
 #include "../perf.h"
 #include "util.h"
-#include "fs.h"
+#include <api/fs/fs.h>
 #include <sys/mman.h>
 #ifdef HAVE_BACKTRACE_SUPPORT
 #include <execinfo.h>
