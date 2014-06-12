Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102AbaFLLZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 07:25:57 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:59517 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932985AbaFLLZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:25:45 -0400
Date: Thu, 12 Jun 2014 13:25:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf updates for v3.16, #2
Message-ID: <20140612112534.GA24194@gmail.com>
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

   # HEAD: 82b897782d10fcc4930c9d4a15b175348fdd2871 perf: Differentiate exec() and non-exec() comm events

A second round of perf updates:

 - wide reaching kprobes sanitization and robustization, with the hope 
   of fixing all 'probe this function crashes the kernel' bugs, by
   Masami Hiramatsu.

 - uprobes updates from Oleg Nesterov: tmpfs support, corner case 
   fixes and robustization work.

 - perf tooling updates and fixes from Jiri Olsa, Namhyung Ki, Arnaldo 
   et al:

      * Add support to accumulate hist periods (Namhyung Kim)
      * various fixes, refactorings and enhancements

 Thanks,

	Ingo

------------------>
Adrian Hunter (1):
      perf: Differentiate exec() and non-exec() comm events

Alexander Yarygin (3):
      perf tools: Parse tracepoints with '-' in system name
      perf tests: Add numeric identifier to evlist_test
      perf tests: Add a test of kvm-390: trace event

Anshuman Khandual (4):
      perf: Add new conditional branch filter 'PERF_SAMPLE_BRANCH_COND'
      perf/tool: Add conditional branch filter 'cond' to perf record
      perf/x86: Add conditional branch filtering support
      perf/documentation: Add description for conditional branch filter

Arnaldo Carvalho de Melo (4):
      perf tools: Allocate thread map_groups's dynamically
      perf tools: Reference count map_groups objects
      perf trace: Warn the user when not available
      perf tools: Add warning when disabling perl scripting support due to missing devel files

Borislav Petkov (4):
      perf tools: Move u64_swap union
      tools: Unify export.h
      tools: Consolidate types.h
      perf/events/core: Drop unused variable after cleanup

Cody P Schafer (1):
      perf tools: Allow overriding sysfs and proc finding with env var

Denys Vlasenko (3):
      uprobes/x86: Refuse to attach uprobe to "word-sized" branch insns
      uprobes/x86: Simplify rip-relative handling
      uprobes/x86: Fix scratch register selection for rip-relative fixups

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

Jianyu Zhan (1):
      perf tools: Fix 'make help' message error

Jiri Olsa (17):
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
      perf tools: Remove elide setup for SORT_MODE__MEMORY mode
      perf tools: Move elide bool into perf_hpp_fmt struct
      perf record: Fix poll return value propagation

Masami Hiramatsu (18):
      kprobes/x86: Allow to handle reentered kprobe on single-stepping
      kprobes: Prohibit probing on .entry.text code
      kprobes: Introduce NOKPROBE_SYMBOL() macro to maintain kprobes blacklist
      kprobes, x86: Prohibit probing on debug_stack_*()
      kprobes, x86: Prohibit probing on native_set_debugreg()/load_idt()
      kprobes, x86: Prohibit probing on thunk functions and restore
      kprobes/x86: Call exception handlers directly from do_int3/do_debug
      kprobes, x86: Call exception_enter after kprobes handled
      kprobes/x86: Allow probe on some kprobe preparation functions
      kprobes: Allow probe on some kprobe functions
      kprobes, ftrace: Allow probing on some functions
      kprobes, x86: Allow kprobes on text_poke/hw_breakpoint
      kprobes, x86: Use NOKPROBE_SYMBOL() instead of __kprobes annotation
      kprobes: Use NOKPROBE_SYMBOL macro instead of __kprobes
      kprobes, ftrace: Use NOKPROBE_SYMBOL macro in ftrace
      kprobes, notifier: Use NOKPROBE_SYMBOL macro in notifier
      kprobes, sched: Use NOKPROBE_SYMBOL macro in sched
      kprobes: Show blacklist entries via debugfs

Masanari Iida (1):
      perf session: Fix possible null pointer dereference in session.c

Michael Lentine (2):
      perf tools: Add cat as fallback pager
      perf tools: Add automatic remapping of Android libraries

Namhyung Kim (71):
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
      perf tools: Introduce hists__inc_nr_samples()
      perf tools: Introduce struct hist_entry_iter
      perf hists: Add support for accumulated stat of hist entry
      perf hists: Check if accumulated when adding a hist entry
      perf hists: Accumulate hist entry stat based on the callchain
      perf tools: Update cpumode for each cumulative entry
      perf report: Cache cumulative callchains
      perf callchain: Add callchain_cursor_snapshot()
      perf tools: Save callchain info for each cumulative entry
      perf ui/hist: Add support to accumulated hist stat
      perf ui/browser: Add support to accumulated hist stat
      perf ui/gtk: Add support to accumulated hist stat
      perf tools: Apply percent-limit to cumulative percentage
      perf tools: Add more hpp helper functions
      perf report: Add --children option
      perf report: Add report.children config option
      perf tools: Do not auto-remove Children column if --fields given
      perf tools: Add callback function to hist_entry_iter
      perf top: Convert to hist_entry_iter
      perf top: Add --children option
      perf top: Add top.children config option
      perf tools: Enable --children option by default
      perf ui/stdio: Fix invalid percentage value of cumulated hist entries
      perf ui/gtk: Fix callchain display
      perf tools: Reset output/sort order to default
      perf tests: Define and use symbolic names for fake symbols
      perf tests: Add a test case for cumulating callchains

Oleg Nesterov (48):
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
      uprobes/x86: Add uprobe_init_insn(), kill validate_insn_{32,64}bits()
      uprobes/x86: Add is_64bit_mm(), kill validate_insn_bits()
      uprobes/x86: Shift "insn_complete" from branch_setup_xol_ops() to uprobe_init_insn()
      uprobes/x86: Make good_insns_* depend on CONFIG_X86_*
      uprobes/x86: Fix is_64bit_mm() with CONFIG_X86_X32
      uprobes/x86: Don't change the task's state if ->pre_xol() fails
      uprobes/x86: Introduce uprobe_xol_ops->abort() and default_abort_op()
      uprobes/x86: Don't use arch_uprobe_abort_xol() in arch_uprobe_post_xol()
      uprobes/x86: Move UPROBE_FIX_SETF logic from arch_uprobe_post_xol() to default_post_xol_op()
      uprobes/x86: Move default_xol_ops's data into arch_uprobe->def
      uprobes/x86: Cleanup the usage of arch_uprobe->def.fixups, make it u8
      uprobes/x86: Introduce push_ret_address()
      uprobes/x86: Kill adjust_ret_addr(), simplify UPROBE_FIX_CALL logic
      uprobes/x86: Cleanup the usage of UPROBE_FIX_IP/UPROBE_FIX_CALL
      uprobes/x86: Rename *riprel* helpers to make the naming consistent
      uprobes/x86: Kill the "autask" arg of riprel_pre_xol()
      uprobes/x86: Simplify riprel_{pre,post}_xol() and make them similar
      uprobes/tracing: Make uprobe_perf_close() visible to uprobe_perf_open()
      uprobes/tracing: Fix uprobe_perf_open() on uprobe_apply() failure
      uprobes: Refuse to insert a probe into MAP_SHARED vma
      uprobes: Add mem_cgroup_charge_anon() into uprobe_write_opcode()
      x86/traps: Make math_error() static
      x86/traps: Use SEND_SIG_PRIV instead of force_sig()
      x86/traps: Introduce do_error_trap()
      x86/traps: Introduce fill_trap_info(), simplify DO_ERROR_INFO()
      x86/traps: Shift fill_trap_info() from DO_ERROR_INFO() to do_error_trap()
      x86/traps: Kill DO_ERROR_INFO()
      uprobes/x86: Fix the wrong ->si_addr when xol triggers a trap
      uprobes: Shift ->readpage check from __copy_insn() to uprobe_register()
      uprobes: Teach copy_insn() to support tmpfs
      uprobes: Shift ->readpage check from __copy_insn() to uprobe_register()
      uprobes: Teach copy_insn() to support tmpfs
      uprobes/x86: Rename arch_uprobe->def to ->defparam, minor comment updates

Peter Zijlstra (9):
      perf: Ensure consistent inherit state in groups
      perf: Always destroy groups on exit
      perf: Validate locking assumption
      perf: Rework free paths
      perf: Simplify perf_event_exit_task_context()
      perf tools: Remove usage of trace_sched_wakeup(.success)
      perf: Fix perf_event_open(.flags) test
      perf: Fix use after free in perf_remove_from_context()
      perf: Fix perf_event_comm() vs. exec() assumption

Ramkumar Ramachandra (4):
      perf kmem: Introduce --list-cmds for use by scripts
      perf mem: Introduce --list-cmds for use by scripts
      perf lock: Introduce --list-cmds for use by scripts
      perf sched: Introduce --list-cmds for use by scripts

Sebastian Andrzej Siewior (1):
      perf tools: Consider header files outside perf directory in tags target

Stephane Eranian (1):
      fix Haswell precise store data source encoding

Vince Weaver (3):
      perf: Disable sampled events if no PMU interrupt
      perf/ARM: Use common PMU interrupt disabled code
      perf/x86: Use common PMU interrupt disabled code

Vineet Gupta (1):
      kprobes: Ensure blacklist data is aligned

Yan, Zheng (3):
      perf: Allow building PMU drivers as modules
      hrtimer: Export __hrtimer_start_range_ns()
      perf/x86: Export perf_assign_events()

zhangdianfang (1):
      perf tools: Fix "==" into "=" in ui_browser__warning assignment


 Documentation/kprobes.txt                          |  16 +-
 arch/arm/kernel/perf_event.c                       |   2 +-
 arch/arm/kernel/perf_event_cpu.c                   |   8 +-
 arch/x86/include/asm/asm.h                         |   7 +
 arch/x86/include/asm/kprobes.h                     |   2 +
 arch/x86/include/asm/traps.h                       |   3 +-
 arch/x86/include/asm/uprobes.h                     |  20 +-
 arch/x86/kernel/alternative.c                      |   3 +-
 arch/x86/kernel/apic/hw_nmi.c                      |   3 +-
 arch/x86/kernel/cpu/common.c                       |   4 +
 arch/x86/kernel/cpu/perf_event.c                   |  22 +-
 arch/x86/kernel/cpu/perf_event_amd_ibs.c           |   3 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c          |  22 +-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c         |   5 +
 arch/x86/kernel/dumpstack.c                        |   9 +-
 arch/x86/kernel/entry_32.S                         |  33 -
 arch/x86/kernel/entry_64.S                         |  20 -
 arch/x86/kernel/hw_breakpoint.c                    |   5 +-
 arch/x86/kernel/kprobes/core.c                     | 128 ++--
 arch/x86/kernel/kprobes/ftrace.c                   |  17 +-
 arch/x86/kernel/kprobes/opt.c                      |  32 +-
 arch/x86/kernel/kvm.c                              |   4 +-
 arch/x86/kernel/nmi.c                              |  18 +-
 arch/x86/kernel/paravirt.c                         |   6 +
 arch/x86/kernel/process_64.c                       |   7 +-
 arch/x86/kernel/traps.c                            | 145 ++--
 arch/x86/kernel/uprobes.c                          | 842 +++++++++++++--------
 arch/x86/lib/thunk_32.S                            |   3 +-
 arch/x86/lib/thunk_64.S                            |   3 +
 arch/x86/mm/fault.c                                |  29 +-
 fs/exec.c                                          |   7 +-
 include/asm-generic/vmlinux.lds.h                  |  10 +
 include/linux/compiler.h                           |   2 +
 include/linux/kprobes.h                            |  21 +-
 include/linux/perf_event.h                         |  19 +-
 include/linux/sched.h                              |   6 +-
 include/linux/uprobes.h                            |   4 +
 include/uapi/linux/perf_event.h                    |  20 +-
 kernel/events/core.c                               | 156 ++--
 kernel/events/uprobes.c                            |  83 +-
 kernel/hrtimer.c                                   |   1 +
 kernel/kprobes.c                                   | 392 ++++++----
 kernel/notifier.c                                  |  22 +-
 kernel/sched/core.c                                |   7 +-
 kernel/trace/trace_event_perf.c                    |   5 +-
 kernel/trace/trace_kprobe.c                        |  71 +-
 kernel/trace/trace_probe.c                         |  65 +-
 kernel/trace/trace_probe.h                         |  15 +-
 kernel/trace/trace_uprobe.c                        |  66 +-
 tools/include/linux/compiler.h                     |   2 +
 tools/{virtio => include}/linux/export.h           |   5 +
 .../lockdep/uinclude => include}/linux/types.h     |  29 +-
 tools/lib/api/fs/fs.c                              |  43 +-
 tools/lib/lockdep/Makefile                         |   2 +-
 tools/lib/lockdep/uinclude/linux/export.h          |   7 -
 tools/perf/Documentation/perf-diff.txt             |  26 +-
 tools/perf/Documentation/perf-record.txt           |   3 +-
 tools/perf/Documentation/perf-report.txt           |  48 +-
 tools/perf/Documentation/perf-top.txt              |  38 +-
 tools/perf/MANIFEST                                |   2 +
 tools/perf/Makefile.perf                           |  26 +-
 tools/perf/arch/arm/Makefile                       |   7 +
 tools/perf/arch/arm/include/perf_regs.h            |   7 +-
 tools/perf/arch/arm/tests/dwarf-unwind.c           |  60 ++
 tools/perf/arch/arm/tests/regs_load.S              |  58 ++
 tools/perf/arch/arm/util/unwind-libdw.c            |  36 +
 tools/perf/arch/arm64/Makefile                     |   7 +
 tools/perf/arch/arm64/include/perf_regs.h          |  88 +++
 tools/perf/arch/arm64/util/dwarf-regs.c            |  80 ++
 tools/perf/arch/arm64/util/unwind-libunwind.c      |  82 ++
 tools/perf/arch/x86/include/perf_regs.h            |   2 +-
 tools/perf/arch/x86/tests/dwarf-unwind.c           |   2 +-
 tools/perf/arch/x86/util/tsc.c                     |   2 +-
 tools/perf/arch/x86/util/tsc.h                     |   2 +-
 tools/perf/builtin-annotate.c                      |   8 +-
 tools/perf/builtin-diff.c                          |  52 +-
 tools/perf/builtin-inject.c                        |   2 +-
 tools/perf/builtin-kmem.c                          |  88 +--
 tools/perf/builtin-lock.c                          |  10 +-
 tools/perf/builtin-mem.c                           |  15 +-
 tools/perf/builtin-record.c                        | 163 ++--
 tools/perf/builtin-report.c                        | 372 +++------
 tools/perf/builtin-sched.c                         |  82 +-
 tools/perf/builtin-top.c                           | 112 +--
 tools/perf/config/Makefile                         |  23 +-
 tools/perf/config/feature-checks/Makefile          |   4 -
 tools/perf/config/feature-checks/test-all.c        |   5 -
 tools/perf/config/feature-checks/test-on-exit.c    |  16 -
 tools/perf/perf-completion.sh                      |   4 +-
 tools/perf/perf-sys.h                              | 190 +++++
 tools/perf/perf.c                                  |   8 +-
 tools/perf/perf.h                                  | 248 +-----
 tools/perf/tests/attr.c                            |   7 -
 tools/perf/tests/builtin-test.c                    |  22 +-
 tools/perf/tests/code-reading.c                    |   5 +-
 tools/perf/tests/dso-data.c                        |   2 +-
 tools/perf/tests/dwarf-unwind.c                    |   2 +-
 tools/perf/tests/evsel-tp-sched.c                  |   3 -
 tools/perf/tests/hists_common.c                    | 209 +++++
 tools/perf/tests/hists_common.h                    |  75 ++
 tools/perf/tests/hists_cumulate.c                  | 726 ++++++++++++++++++
 tools/perf/tests/hists_filter.c                    | 289 +++++++
 tools/perf/tests/hists_link.c                      | 209 +----
 tools/perf/tests/hists_output.c                    | 621 +++++++++++++++
 tools/perf/tests/keep-tracking.c                   |   2 +-
 tools/perf/tests/mmap-thread-lookup.c              | 233 ++++++
 tools/perf/tests/parse-events.c                    | 142 ++--
 tools/perf/tests/parse-no-sample-id-all.c          |   2 +-
 tools/perf/tests/perf-time-to-tsc.c                |   3 +-
 tools/perf/tests/rdpmc.c                           |   2 +-
 tools/perf/tests/sample-parsing.c                  |   2 +-
 tools/perf/tests/tests.h                           |   7 +-
 tools/perf/tests/thread-mg-share.c                 |  90 +++
 tools/perf/ui/browser.c                            |   2 +-
 tools/perf/ui/browser.h                            |   4 +-
 tools/perf/ui/browsers/hists.c                     | 270 ++++---
 tools/perf/ui/gtk/hists.c                          |  77 +-
 tools/perf/ui/hist.c                               | 371 +++++++--
 tools/perf/ui/progress.h                           |   2 +-
 tools/perf/ui/setup.c                              |   2 -
 tools/perf/ui/stdio/hist.c                         |  89 +--
 tools/perf/util/annotate.h                         |   2 +-
 tools/perf/util/build-id.c                         |   2 +-
 tools/perf/util/build-id.h                         |   2 +-
 tools/perf/util/callchain.c                        | 123 ++-
 tools/perf/util/callchain.h                        |  19 +
 tools/perf/util/config.c                           |   4 +
 tools/perf/util/cpumap.c                           | 160 ++++
 tools/perf/util/cpumap.h                           |  35 +
 tools/perf/util/dso.h                              |   2 +-
 tools/perf/util/event.c                            |   4 +-
 tools/perf/util/event.h                            |  24 +
 tools/perf/util/evsel.h                            |   9 +-
 tools/perf/util/header.h                           |   4 +-
 tools/perf/util/hist.c                             | 668 +++++++++++++---
 tools/perf/util/hist.h                             | 101 ++-
 tools/perf/util/include/linux/bitmap.h             |   3 +
 tools/perf/util/include/linux/export.h             |   6 -
 tools/perf/util/include/linux/list.h               |   1 +
 tools/perf/util/include/linux/types.h              |  29 -
 tools/perf/util/machine.c                          |  11 +
 tools/perf/util/map.c                              | 118 ++-
 tools/perf/util/map.h                              |  14 +-
 tools/perf/util/pager.c                            |  12 +-
 tools/perf/util/parse-events.h                     |   3 +-
 tools/perf/util/parse-events.y                     |  14 +-
 tools/perf/util/perf_regs.h                        |   2 +-
 tools/perf/util/pmu.c                              |   6 +-
 tools/perf/util/pmu.h                              |   2 +-
 tools/perf/util/session.c                          |   5 +-
 tools/perf/util/sort.c                             | 523 +++++++++++--
 tools/perf/util/sort.h                             |  26 +-
 tools/perf/util/stat.h                             |   2 +-
 tools/perf/util/svghelper.c                        |   2 +-
 tools/perf/util/svghelper.h                        |   2 +-
 tools/perf/util/symbol.c                           |  11 +-
 tools/perf/util/symbol.h                           |   5 +-
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
 169 files changed, 7342 insertions(+), 2671 deletions(-)
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
 create mode 100644 tools/perf/tests/hists_cumulate.c
 create mode 100644 tools/perf/tests/hists_filter.c
 create mode 100644 tools/perf/tests/hists_output.c
 create mode 100644 tools/perf/tests/mmap-thread-lookup.c
 create mode 100644 tools/perf/tests/thread-mg-share.c
 delete mode 100644 tools/perf/util/include/linux/export.h
 delete mode 100644 tools/perf/util/include/linux/types.h
 delete mode 100644 tools/perf/util/types.h
 delete mode 100644 tools/virtio/linux/types.h

diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
index 0cfb00f..4bbeca8 100644
--- a/Documentation/kprobes.txt
+++ b/Documentation/kprobes.txt
@@ -22,8 +22,9 @@ Appendix B: The kprobes sysctl interface
 
 Kprobes enables you to dynamically break into any kernel routine and
 collect debugging and performance information non-disruptively. You
-can trap at almost any kernel code address, specifying a handler
+can trap at almost any kernel code address(*), specifying a handler
 routine to be invoked when the breakpoint is hit.
+(*: some parts of the kernel code can not be trapped, see 1.5 Blacklist)
 
 There are currently three types of probes: kprobes, jprobes, and
 kretprobes (also called return probes).  A kprobe can be inserted
@@ -273,6 +274,19 @@ using one of the following techniques:
  or
 - Execute 'sysctl -w debug.kprobes_optimization=n'
 
+1.5 Blacklist
+
+Kprobes can probe most of the kernel except itself. This means
+that there are some functions where kprobes cannot probe. Probing
+(trapping) such functions can cause a recursive trap (e.g. double
+fault) or the nested probe handler may never be called.
+Kprobes manages such functions as a blacklist.
+If you want to add a function into the blacklist, you just need
+to (1) include linux/kprobes.h and (2) use NOKPROBE_SYMBOL() macro
+to specify a blacklisted function.
+Kprobes checks the given probe address against the blacklist and
+rejects registering it, if the given address is in the blacklist.
+
 2. Architectures Supported
 
 Kprobes, jprobes, and return probes are implemented on the following
diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index a6bc431..4238bcb 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -410,7 +410,7 @@ __hw_perf_event_init(struct perf_event *event)
 	 */
 	hwc->config_base	    |= (unsigned long)mapping;
 
-	if (!hwc->sample_period) {
+	if (!is_sampling_event(event)) {
 		/*
 		 * For non-sampling runs, limit the sample_period to half
 		 * of the counter width. That way, the new counter value
diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
index 51798d7..bbdbffd 100644
--- a/arch/arm/kernel/perf_event_cpu.c
+++ b/arch/arm/kernel/perf_event_cpu.c
@@ -126,8 +126,8 @@ static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu, irq_handler_t handler)
 
 	irqs = min(pmu_device->num_resources, num_possible_cpus());
 	if (irqs < 1) {
-		pr_err("no irqs for PMUs defined\n");
-		return -ENODEV;
+		printk_once("perf/ARM: No irqs for PMU defined, sampling events not supported\n");
+		return 0;
 	}
 
 	irq = platform_get_irq(pmu_device, 0);
@@ -191,6 +191,10 @@ static void cpu_pmu_init(struct arm_pmu *cpu_pmu)
 	/* Ensure the PMU has sane values out of reset. */
 	if (cpu_pmu->reset)
 		on_each_cpu(cpu_pmu->reset, cpu_pmu, 1);
+
+	/* If no interrupts available, set the corresponding capability flag */
+	if (!platform_get_irq(cpu_pmu->plat_device, 0))
+		cpu_pmu->pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
 }
 
 /*
diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index 4582e8e..7730c1c 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -57,6 +57,12 @@
 	.long (from) - . ;					\
 	.long (to) - . + 0x7ffffff0 ;				\
 	.popsection
+
+# define _ASM_NOKPROBE(entry)					\
+	.pushsection "_kprobe_blacklist","aw" ;			\
+	_ASM_ALIGN ;						\
+	_ASM_PTR (entry);					\
+	.popsection
 #else
 # define _ASM_EXTABLE(from,to)					\
 	" .pushsection \"__ex_table\",\"a\"\n"			\
@@ -71,6 +77,7 @@
 	" .long (" #from ") - .\n"				\
 	" .long (" #to ") - . + 0x7ffffff0\n"			\
 	" .popsection\n"
+/* For C file, we already have NOKPROBE_SYMBOL macro */
 #endif
 
 #endif /* _ASM_X86_ASM_H */
diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index 9454c16..53cdfb2 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -116,4 +116,6 @@ struct kprobe_ctlblk {
 extern int kprobe_fault_handler(struct pt_regs *regs, int trapnr);
 extern int kprobe_exceptions_notify(struct notifier_block *self,
 				    unsigned long val, void *data);
+extern int kprobe_int3_handler(struct pt_regs *regs);
+extern int kprobe_debug_handler(struct pt_regs *regs);
 #endif /* _ASM_X86_KPROBES_H */
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 58d66fe..cf69d05 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -68,7 +68,7 @@ dotraplinkage void do_segment_not_present(struct pt_regs *, long);
 dotraplinkage void do_stack_segment(struct pt_regs *, long);
 #ifdef CONFIG_X86_64
 dotraplinkage void do_double_fault(struct pt_regs *, long);
-asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *);
+asmlinkage struct pt_regs *sync_regs(struct pt_regs *);
 #endif
 dotraplinkage void do_general_protection(struct pt_regs *, long);
 dotraplinkage void do_page_fault(struct pt_regs *, unsigned long);
@@ -98,7 +98,6 @@ static inline int get_si_code(unsigned long condition)
 
 extern int panic_on_unrecovered_nmi;
 
-void math_error(struct pt_regs *, int, int);
 void math_emulate(struct math_emu_info *);
 #ifndef CONFIG_X86_32
 asmlinkage void smp_thermal_interrupt(void);
diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index 3087ea9..74f4c2f 100644
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
-#ifdef CONFIG_X86_64
-	unsigned long			rip_rela_target_address;
-#endif
+
+	const struct uprobe_xol_ops	*ops;
+
+	union {
+		struct {
+			s32	offs;
+			u8	ilen;
+			u8	opc1;
+		}			branch;
+		struct {
+			u8	fixups;
+			u8	ilen;
+		} 			defparam;
+	};
 };
 
 struct arch_uprobe_task {
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index df94598..703130f 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -5,7 +5,6 @@
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/stringify.h>
-#include <linux/kprobes.h>
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/memory.h>
@@ -551,7 +550,7 @@ void *__init_or_module text_poke_early(void *addr, const void *opcode,
  *
  * Note: Must be called under text_mutex.
  */
-void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
+void *text_poke(void *addr, const void *opcode, size_t len)
 {
 	unsigned long flags;
 	char *vaddr;
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index a698d71..73eb5b3 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -60,7 +60,7 @@ void arch_trigger_all_cpu_backtrace(void)
 	smp_mb__after_clear_bit();
 }
 
-static int __kprobes
+static int
 arch_trigger_all_cpu_backtrace_handler(unsigned int cmd, struct pt_regs *regs)
 {
 	int cpu;
@@ -80,6 +80,7 @@ arch_trigger_all_cpu_backtrace_handler(unsigned int cmd, struct pt_regs *regs)
 
 	return NMI_DONE;
 }
+NOKPROBE_SYMBOL(arch_trigger_all_cpu_backtrace_handler);
 
 static int __init register_trigger_all_cpu_backtrace(void)
 {
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a135239..5af696d 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -8,6 +8,7 @@
 #include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/init.h>
+#include <linux/kprobes.h>
 #include <linux/kgdb.h>
 #include <linux/smp.h>
 #include <linux/io.h>
@@ -1160,6 +1161,7 @@ int is_debug_stack(unsigned long addr)
 		(addr <= __get_cpu_var(debug_stack_addr) &&
 		 addr > (__get_cpu_var(debug_stack_addr) - DEBUG_STKSZ));
 }
+NOKPROBE_SYMBOL(is_debug_stack);
 
 DEFINE_PER_CPU(u32, debug_idt_ctr);
 
@@ -1168,6 +1170,7 @@ void debug_stack_set_zero(void)
 	this_cpu_inc(debug_idt_ctr);
 	load_current_idt();
 }
+NOKPROBE_SYMBOL(debug_stack_set_zero);
 
 void debug_stack_reset(void)
 {
@@ -1176,6 +1179,7 @@ void debug_stack_reset(void)
 	if (this_cpu_dec_return(debug_idt_ctr) == 0)
 		load_current_idt();
 }
+NOKPROBE_SYMBOL(debug_stack_reset);
 
 #else	/* CONFIG_X86_64 */
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ae407f7..2bdfbff 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -303,15 +303,6 @@ int x86_setup_perfctr(struct perf_event *event)
 		hwc->sample_period = x86_pmu.max_period;
 		hwc->last_period = hwc->sample_period;
 		local64_set(&hwc->period_left, hwc->sample_period);
-	} else {
-		/*
-		 * If we have a PMU initialized but no APIC
-		 * interrupts, we cannot sample hardware
-		 * events (user-space has to fall back and
-		 * sample via a hrtimer based software event):
-		 */
-		if (!x86_pmu.apic)
-			return -EOPNOTSUPP;
 	}
 
 	if (attr->type == PERF_TYPE_RAW)
@@ -721,6 +712,7 @@ int perf_assign_events(struct perf_event **events, int n,
 
 	return sched.state.unassigned;
 }
+EXPORT_SYMBOL_GPL(perf_assign_events);
 
 int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 {
@@ -1292,7 +1284,7 @@ void perf_events_lapic_init(void)
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 }
 
-static int __kprobes
+static int
 perf_event_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 {
 	u64 start_clock;
@@ -1310,6 +1302,7 @@ perf_event_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 
 	return ret;
 }
+NOKPROBE_SYMBOL(perf_event_nmi_handler);
 
 struct event_constraint emptyconstraint;
 struct event_constraint unconstrained;
@@ -1365,6 +1358,15 @@ static void __init pmu_check_apic(void)
 	x86_pmu.apic = 0;
 	pr_info("no APIC, boot with the \"lapic\" boot parameter to force-enable it.\n");
 	pr_info("no hardware sampling interrupt available.\n");
+
+	/*
+	 * If we have a PMU initialized but no APIC
+	 * interrupts, we cannot sample hardware
+	 * events (user-space has to fall back and
+	 * sample via a hrtimer based software event):
+	 */
+	pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
+
 }
 
 static struct attribute_group x86_pmu_format_group = {
diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 4c36bbe..cbb1be3e 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -593,7 +593,7 @@ out:
 	return 1;
 }
 
-static int __kprobes
+static int
 perf_ibs_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 {
 	int handled = 0;
@@ -606,6 +606,7 @@ perf_ibs_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 
 	return handled;
 }
+NOKPROBE_SYMBOL(perf_ibs_nmi_handler);
 
 static __init int perf_ibs_pmu_init(struct perf_ibs *perf_ibs, char *name)
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
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index d82d155..9dd2459 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -384,6 +384,9 @@ static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 	if (br_type & PERF_SAMPLE_BRANCH_NO_TX)
 		mask |= X86_BR_NO_TX;
 
+	if (br_type & PERF_SAMPLE_BRANCH_COND)
+		mask |= X86_BR_JCC;
+
 	/*
 	 * stash actual user request into reg, it may
 	 * be used by fixup code for some CPU
@@ -678,6 +681,7 @@ static const int nhm_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX] = {
 	 * NHM/WSM erratum: must include IND_JMP to capture IND_CALL
 	 */
 	[PERF_SAMPLE_BRANCH_IND_CALL] = LBR_IND_CALL | LBR_IND_JMP,
+	[PERF_SAMPLE_BRANCH_COND]     = LBR_JCC,
 };
 
 static const int snb_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX] = {
@@ -689,6 +693,7 @@ static const int snb_lbr_sel_map[PERF_SAMPLE_BRANCH_MAX] = {
 	[PERF_SAMPLE_BRANCH_ANY_CALL]	= LBR_REL_CALL | LBR_IND_CALL
 					| LBR_FAR,
 	[PERF_SAMPLE_BRANCH_IND_CALL]	= LBR_IND_CALL,
+	[PERF_SAMPLE_BRANCH_COND]       = LBR_JCC,
 };
 
 /* core */
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index d9c12d3..b74ebc7 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -200,7 +200,7 @@ static arch_spinlock_t die_lock = __ARCH_SPIN_LOCK_UNLOCKED;
 static int die_owner = -1;
 static unsigned int die_nest_count;
 
-unsigned __kprobes long oops_begin(void)
+unsigned long oops_begin(void)
 {
 	int cpu;
 	unsigned long flags;
@@ -223,8 +223,9 @@ unsigned __kprobes long oops_begin(void)
 	return flags;
 }
 EXPORT_SYMBOL_GPL(oops_begin);
+NOKPROBE_SYMBOL(oops_begin);
 
-void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
+void oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 {
 	if (regs && kexec_should_crash(current))
 		crash_kexec(regs);
@@ -247,8 +248,9 @@ void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 		panic("Fatal exception");
 	do_exit(signr);
 }
+NOKPROBE_SYMBOL(oops_end);
 
-int __kprobes __die(const char *str, struct pt_regs *regs, long err)
+int __die(const char *str, struct pt_regs *regs, long err)
 {
 #ifdef CONFIG_X86_32
 	unsigned short ss;
@@ -291,6 +293,7 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 #endif
 	return 0;
 }
+NOKPROBE_SYMBOL(__die);
 
 /*
  * This is gone through when something in the kernel has done something bad
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index a2a4f46..0ca5bf1 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -315,10 +315,6 @@ ENTRY(ret_from_kernel_thread)
 ENDPROC(ret_from_kernel_thread)
 
 /*
- * Interrupt exit functions should be protected against kprobes
- */
-	.pushsection .kprobes.text, "ax"
-/*
  * Return to user mode is not as complex as all this looks,
  * but we want the default path for a system call return to
  * go as quickly as possible which is why some of this is
@@ -372,10 +368,6 @@ need_resched:
 END(resume_kernel)
 #endif
 	CFI_ENDPROC
-/*
- * End of kprobes section
- */
-	.popsection
 
 /* SYSENTER_RETURN points to after the "sysenter" instruction in
    the vsyscall page.  See vsyscall-sysentry.S, which defines the symbol.  */
@@ -495,10 +487,6 @@ sysexit_audit:
 	PTGS_TO_GS_EX
 ENDPROC(ia32_sysenter_target)
 
-/*
- * syscall stub including irq exit should be protected against kprobes
- */
-	.pushsection .kprobes.text, "ax"
 	# system call handler stub
 ENTRY(system_call)
 	RING0_INT_FRAME			# can't unwind into user space anyway
@@ -691,10 +679,6 @@ syscall_badsys:
 	jmp resume_userspace
 END(syscall_badsys)
 	CFI_ENDPROC
-/*
- * End of kprobes section
- */
-	.popsection
 
 .macro FIXUP_ESPFIX_STACK
 /*
@@ -781,10 +765,6 @@ common_interrupt:
 ENDPROC(common_interrupt)
 	CFI_ENDPROC
 
-/*
- *  Irq entries should be protected against kprobes
- */
-	.pushsection .kprobes.text, "ax"
 #define BUILD_INTERRUPT3(name, nr, fn)	\
 ENTRY(name)				\
 	RING0_INT_FRAME;		\
@@ -961,10 +941,6 @@ ENTRY(spurious_interrupt_bug)
 	jmp error_code
 	CFI_ENDPROC
 END(spurious_interrupt_bug)
-/*
- * End of kprobes section
- */
-	.popsection
 
 #ifdef CONFIG_XEN
 /* Xen doesn't set %esp to be precisely what the normal sysenter
@@ -1239,11 +1215,6 @@ return_to_handler:
 	jmp *%ecx
 #endif
 
-/*
- * Some functions should be protected against kprobes
- */
-	.pushsection .kprobes.text, "ax"
-
 #ifdef CONFIG_TRACING
 ENTRY(trace_page_fault)
 	RING0_EC_FRAME
@@ -1453,7 +1424,3 @@ ENTRY(async_page_fault)
 END(async_page_fault)
 #endif
 
-/*
- * End of kprobes section
- */
-	.popsection
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1e96c36..43bb389 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -487,8 +487,6 @@ ENDPROC(native_usergs_sysret64)
 	TRACE_IRQS_OFF
 	.endm
 
-/* save complete stack frame */
-	.pushsection .kprobes.text, "ax"
 ENTRY(save_paranoid)
 	XCPT_FRAME 1 RDI+8
 	cld
@@ -517,7 +515,6 @@ ENTRY(save_paranoid)
 1:	ret
 	CFI_ENDPROC
 END(save_paranoid)
-	.popsection
 
 /*
  * A newly forked process directly context switches into this address.
@@ -975,10 +972,6 @@ END(interrupt)
 	call \func
 	.endm
 
-/*
- * Interrupt entry/exit should be protected against kprobes
- */
-	.pushsection .kprobes.text, "ax"
 	/*
 	 * The interrupt stubs push (~vector+0x80) onto the stack and
 	 * then jump to common_interrupt.
@@ -1113,10 +1106,6 @@ ENTRY(retint_kernel)
 
 	CFI_ENDPROC
 END(common_interrupt)
-/*
- * End of kprobes section
- */
-       .popsection
 
 /*
  * APIC interrupts.
@@ -1477,11 +1466,6 @@ apicinterrupt3 HYPERVISOR_CALLBACK_VECTOR \
 	hyperv_callback_vector hyperv_vector_handler
 #endif /* CONFIG_HYPERV */
 
-/*
- * Some functions should be protected against kprobes
- */
-	.pushsection .kprobes.text, "ax"
-
 paranoidzeroentry_ist debug do_debug DEBUG_STACK
 paranoidzeroentry_ist int3 do_int3 DEBUG_STACK
 paranoiderrorentry stack_segment do_stack_segment
@@ -1898,7 +1882,3 @@ ENTRY(ignore_sysret)
 	CFI_ENDPROC
 END(ignore_sysret)
 
-/*
- * End of kprobes section
- */
-	.popsection
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index a67b47c..5f9cf20 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -32,7 +32,6 @@
 #include <linux/irqflags.h>
 #include <linux/notifier.h>
 #include <linux/kallsyms.h>
-#include <linux/kprobes.h>
 #include <linux/percpu.h>
 #include <linux/kdebug.h>
 #include <linux/kernel.h>
@@ -424,7 +423,7 @@ EXPORT_SYMBOL_GPL(hw_breakpoint_restore);
  * NOTIFY_STOP returned for all other cases
  *
  */
-static int __kprobes hw_breakpoint_handler(struct die_args *args)
+static int hw_breakpoint_handler(struct die_args *args)
 {
 	int i, cpu, rc = NOTIFY_STOP;
 	struct perf_event *bp;
@@ -511,7 +510,7 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
 /*
  * Handle debug exception notifications.
  */
-int __kprobes hw_breakpoint_exceptions_notify(
+int hw_breakpoint_exceptions_notify(
 		struct notifier_block *unused, unsigned long val, void *data)
 {
 	if (val != DIE_DEBUG)
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 61b17dc..7596df6 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -112,7 +112,8 @@ struct kretprobe_blackpoint kretprobe_blacklist[] = {
 
 const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
 
-static void __kprobes __synthesize_relative_insn(void *from, void *to, u8 op)
+static nokprobe_inline void
+__synthesize_relative_insn(void *from, void *to, u8 op)
 {
 	struct __arch_relative_insn {
 		u8 op;
@@ -125,21 +126,23 @@ static void __kprobes __synthesize_relative_insn(void *from, void *to, u8 op)
 }
 
 /* Insert a jump instruction at address 'from', which jumps to address 'to'.*/
-void __kprobes synthesize_reljump(void *from, void *to)
+void synthesize_reljump(void *from, void *to)
 {
 	__synthesize_relative_insn(from, to, RELATIVEJUMP_OPCODE);
 }
+NOKPROBE_SYMBOL(synthesize_reljump);
 
 /* Insert a call instruction at address 'from', which calls address 'to'.*/
-void __kprobes synthesize_relcall(void *from, void *to)
+void synthesize_relcall(void *from, void *to)
 {
 	__synthesize_relative_insn(from, to, RELATIVECALL_OPCODE);
 }
+NOKPROBE_SYMBOL(synthesize_relcall);
 
 /*
  * Skip the prefixes of the instruction.
  */
-static kprobe_opcode_t *__kprobes skip_prefixes(kprobe_opcode_t *insn)
+static kprobe_opcode_t *skip_prefixes(kprobe_opcode_t *insn)
 {
 	insn_attr_t attr;
 
@@ -154,12 +157,13 @@ static kprobe_opcode_t *__kprobes skip_prefixes(kprobe_opcode_t *insn)
 #endif
 	return insn;
 }
+NOKPROBE_SYMBOL(skip_prefixes);
 
 /*
  * Returns non-zero if opcode is boostable.
  * RIP relative instructions are adjusted at copying time in 64 bits mode
  */
-int __kprobes can_boost(kprobe_opcode_t *opcodes)
+int can_boost(kprobe_opcode_t *opcodes)
 {
 	kprobe_opcode_t opcode;
 	kprobe_opcode_t *orig_opcodes = opcodes;
@@ -260,7 +264,7 @@ unsigned long recover_probed_instruction(kprobe_opcode_t *buf, unsigned long add
 }
 
 /* Check if paddr is at an instruction boundary */
-static int __kprobes can_probe(unsigned long paddr)
+static int can_probe(unsigned long paddr)
 {
 	unsigned long addr, __addr, offset = 0;
 	struct insn insn;
@@ -299,7 +303,7 @@ static int __kprobes can_probe(unsigned long paddr)
 /*
  * Returns non-zero if opcode modifies the interrupt flag.
  */
-static int __kprobes is_IF_modifier(kprobe_opcode_t *insn)
+static int is_IF_modifier(kprobe_opcode_t *insn)
 {
 	/* Skip prefixes */
 	insn = skip_prefixes(insn);
@@ -322,7 +326,7 @@ static int __kprobes is_IF_modifier(kprobe_opcode_t *insn)
  * If not, return null.
  * Only applicable to 64-bit x86.
  */
-int __kprobes __copy_instruction(u8 *dest, u8 *src)
+int __copy_instruction(u8 *dest, u8 *src)
 {
 	struct insn insn;
 	kprobe_opcode_t buf[MAX_INSN_SIZE];
@@ -365,7 +369,7 @@ int __kprobes __copy_instruction(u8 *dest, u8 *src)
 	return insn.length;
 }
 
-static int __kprobes arch_copy_kprobe(struct kprobe *p)
+static int arch_copy_kprobe(struct kprobe *p)
 {
 	int ret;
 
@@ -392,7 +396,7 @@ static int __kprobes arch_copy_kprobe(struct kprobe *p)
 	return 0;
 }
 
-int __kprobes arch_prepare_kprobe(struct kprobe *p)
+int arch_prepare_kprobe(struct kprobe *p)
 {
 	if (alternatives_text_reserved(p->addr, p->addr))
 		return -EINVAL;
@@ -407,17 +411,17 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	return arch_copy_kprobe(p);
 }
 
-void __kprobes arch_arm_kprobe(struct kprobe *p)
+void arch_arm_kprobe(struct kprobe *p)
 {
 	text_poke(p->addr, ((unsigned char []){BREAKPOINT_INSTRUCTION}), 1);
 }
 
-void __kprobes arch_disarm_kprobe(struct kprobe *p)
+void arch_disarm_kprobe(struct kprobe *p)
 {
 	text_poke(p->addr, &p->opcode, 1);
 }
 
-void __kprobes arch_remove_kprobe(struct kprobe *p)
+void arch_remove_kprobe(struct kprobe *p)
 {
 	if (p->ainsn.insn) {
 		free_insn_slot(p->ainsn.insn, (p->ainsn.boostable == 1));
@@ -425,7 +429,8 @@ void __kprobes arch_remove_kprobe(struct kprobe *p)
 	}
 }
 
-static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
+static nokprobe_inline void
+save_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
 	kcb->prev_kprobe.kp = kprobe_running();
 	kcb->prev_kprobe.status = kcb->kprobe_status;
@@ -433,7 +438,8 @@ static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
 	kcb->prev_kprobe.saved_flags = kcb->kprobe_saved_flags;
 }
 
-static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
+static nokprobe_inline void
+restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
 	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
 	kcb->kprobe_status = kcb->prev_kprobe.status;
@@ -441,8 +447,9 @@ static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 	kcb->kprobe_saved_flags = kcb->prev_kprobe.saved_flags;
 }
 
-static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
-				struct kprobe_ctlblk *kcb)
+static nokprobe_inline void
+set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
+		   struct kprobe_ctlblk *kcb)
 {
 	__this_cpu_write(current_kprobe, p);
 	kcb->kprobe_saved_flags = kcb->kprobe_old_flags
@@ -451,7 +458,7 @@ static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 		kcb->kprobe_saved_flags &= ~X86_EFLAGS_IF;
 }
 
-static void __kprobes clear_btf(void)
+static nokprobe_inline void clear_btf(void)
 {
 	if (test_thread_flag(TIF_BLOCKSTEP)) {
 		unsigned long debugctl = get_debugctlmsr();
@@ -461,7 +468,7 @@ static void __kprobes clear_btf(void)
 	}
 }
 
-static void __kprobes restore_btf(void)
+static nokprobe_inline void restore_btf(void)
 {
 	if (test_thread_flag(TIF_BLOCKSTEP)) {
 		unsigned long debugctl = get_debugctlmsr();
@@ -471,8 +478,7 @@ static void __kprobes restore_btf(void)
 	}
 }
 
-void __kprobes
-arch_prepare_kretprobe(struct kretprobe_instance *ri, struct pt_regs *regs)
+void arch_prepare_kretprobe(struct kretprobe_instance *ri, struct pt_regs *regs)
 {
 	unsigned long *sara = stack_addr(regs);
 
@@ -481,9 +487,10 @@ arch_prepare_kretprobe(struct kretprobe_instance *ri, struct pt_regs *regs)
 	/* Replace the return addr with trampoline addr */
 	*sara = (unsigned long) &kretprobe_trampoline;
 }
+NOKPROBE_SYMBOL(arch_prepare_kretprobe);
 
-static void __kprobes
-setup_singlestep(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *kcb, int reenter)
+static void setup_singlestep(struct kprobe *p, struct pt_regs *regs,
+			     struct kprobe_ctlblk *kcb, int reenter)
 {
 	if (setup_detour_execution(p, regs, reenter))
 		return;
@@ -519,22 +526,24 @@ setup_singlestep(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *k
 	else
 		regs->ip = (unsigned long)p->ainsn.insn;
 }
+NOKPROBE_SYMBOL(setup_singlestep);
 
 /*
  * We have reentered the kprobe_handler(), since another probe was hit while
  * within the handler. We save the original kprobes variables and just single
  * step on the instruction of the new probe without calling any user handlers.
  */
-static int __kprobes
-reenter_kprobe(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *kcb)
+static int reenter_kprobe(struct kprobe *p, struct pt_regs *regs,
+			  struct kprobe_ctlblk *kcb)
 {
 	switch (kcb->kprobe_status) {
 	case KPROBE_HIT_SSDONE:
 	case KPROBE_HIT_ACTIVE:
+	case KPROBE_HIT_SS:
 		kprobes_inc_nmissed_count(p);
 		setup_singlestep(p, regs, kcb, 1);
 		break;
-	case KPROBE_HIT_SS:
+	case KPROBE_REENTER:
 		/* A probe has been hit in the codepath leading up to, or just
 		 * after, single-stepping of a probed instruction. This entire
 		 * codepath should strictly reside in .kprobes.text section.
@@ -553,12 +562,13 @@ reenter_kprobe(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *kcb
 
 	return 1;
 }
+NOKPROBE_SYMBOL(reenter_kprobe);
 
 /*
  * Interrupts are disabled on entry as trap3 is an interrupt gate and they
  * remain disabled throughout this function.
  */
-static int __kprobes kprobe_handler(struct pt_regs *regs)
+int kprobe_int3_handler(struct pt_regs *regs)
 {
 	kprobe_opcode_t *addr;
 	struct kprobe *p;
@@ -621,12 +631,13 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 	preempt_enable_no_resched();
 	return 0;
 }
+NOKPROBE_SYMBOL(kprobe_int3_handler);
 
 /*
  * When a retprobed function returns, this code saves registers and
  * calls trampoline_handler() runs, which calls the kretprobe's handler.
  */
-static void __used __kprobes kretprobe_trampoline_holder(void)
+static void __used kretprobe_trampoline_holder(void)
 {
 	asm volatile (
 			".global kretprobe_trampoline\n"
@@ -657,11 +668,13 @@ static void __used __kprobes kretprobe_trampoline_holder(void)
 #endif
 			"	ret\n");
 }
+NOKPROBE_SYMBOL(kretprobe_trampoline_holder);
+NOKPROBE_SYMBOL(kretprobe_trampoline);
 
 /*
  * Called from kretprobe_trampoline
  */
-__visible __used __kprobes void *trampoline_handler(struct pt_regs *regs)
+__visible __used void *trampoline_handler(struct pt_regs *regs)
 {
 	struct kretprobe_instance *ri = NULL;
 	struct hlist_head *head, empty_rp;
@@ -747,6 +760,7 @@ __visible __used __kprobes void *trampoline_handler(struct pt_regs *regs)
 	}
 	return (void *)orig_ret_address;
 }
+NOKPROBE_SYMBOL(trampoline_handler);
 
 /*
  * Called after single-stepping.  p->addr is the address of the
@@ -775,8 +789,8 @@ __visible __used __kprobes void *trampoline_handler(struct pt_regs *regs)
  * jump instruction after the copied instruction, that jumps to the next
  * instruction after the probepoint.
  */
-static void __kprobes
-resume_execution(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *kcb)
+static void resume_execution(struct kprobe *p, struct pt_regs *regs,
+			     struct kprobe_ctlblk *kcb)
 {
 	unsigned long *tos = stack_addr(regs);
 	unsigned long copy_ip = (unsigned long)p->ainsn.insn;
@@ -851,12 +865,13 @@ resume_execution(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *k
 no_change:
 	restore_btf();
 }
+NOKPROBE_SYMBOL(resume_execution);
 
 /*
  * Interrupts are disabled on entry as trap1 is an interrupt gate and they
  * remain disabled throughout this function.
  */
-static int __kprobes post_kprobe_handler(struct pt_regs *regs)
+int kprobe_debug_handler(struct pt_regs *regs)
 {
 	struct kprobe *cur = kprobe_running();
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
@@ -891,8 +906,9 @@ out:
 
 	return 1;
 }
+NOKPROBE_SYMBOL(kprobe_debug_handler);
 
-int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
+int kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 {
 	struct kprobe *cur = kprobe_running();
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
@@ -949,12 +965,13 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 
 	return 0;
 }
+NOKPROBE_SYMBOL(kprobe_fault_handler);
 
 /*
  * Wrapper routine for handling exceptions.
  */
-int __kprobes
-kprobe_exceptions_notify(struct notifier_block *self, unsigned long val, void *data)
+int kprobe_exceptions_notify(struct notifier_block *self, unsigned long val,
+			     void *data)
 {
 	struct die_args *args = data;
 	int ret = NOTIFY_DONE;
@@ -962,22 +979,7 @@ kprobe_exceptions_notify(struct notifier_block *self, unsigned long val, void *d
 	if (args->regs && user_mode_vm(args->regs))
 		return ret;
 
-	switch (val) {
-	case DIE_INT3:
-		if (kprobe_handler(args->regs))
-			ret = NOTIFY_STOP;
-		break;
-	case DIE_DEBUG:
-		if (post_kprobe_handler(args->regs)) {
-			/*
-			 * Reset the BS bit in dr6 (pointed by args->err) to
-			 * denote completion of processing
-			 */
-			(*(unsigned long *)ERR_PTR(args->err)) &= ~DR_STEP;
-			ret = NOTIFY_STOP;
-		}
-		break;
-	case DIE_GPF:
+	if (val == DIE_GPF) {
 		/*
 		 * To be potentially processing a kprobe fault and to
 		 * trust the result from kprobe_running(), we have
@@ -986,14 +988,12 @@ kprobe_exceptions_notify(struct notifier_block *self, unsigned long val, void *d
 		if (!preemptible() && kprobe_running() &&
 		    kprobe_fault_handler(args->regs, args->trapnr))
 			ret = NOTIFY_STOP;
-		break;
-	default:
-		break;
 	}
 	return ret;
 }
+NOKPROBE_SYMBOL(kprobe_exceptions_notify);
 
-int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
+int setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
 {
 	struct jprobe *jp = container_of(p, struct jprobe, kp);
 	unsigned long addr;
@@ -1017,8 +1017,9 @@ int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
 	regs->ip = (unsigned long)(jp->entry);
 	return 1;
 }
+NOKPROBE_SYMBOL(setjmp_pre_handler);
 
-void __kprobes jprobe_return(void)
+void jprobe_return(void)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 
@@ -1034,8 +1035,10 @@ void __kprobes jprobe_return(void)
 			"       nop			\n"::"b"
 			(kcb->jprobe_saved_sp):"memory");
 }
+NOKPROBE_SYMBOL(jprobe_return);
+NOKPROBE_SYMBOL(jprobe_return_end);
 
-int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
+int longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 	u8 *addr = (u8 *) (regs->ip - 1);
@@ -1063,13 +1066,22 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 	}
 	return 0;
 }
+NOKPROBE_SYMBOL(longjmp_break_handler);
+
+bool arch_within_kprobe_blacklist(unsigned long addr)
+{
+	return  (addr >= (unsigned long)__kprobes_text_start &&
+		 addr < (unsigned long)__kprobes_text_end) ||
+		(addr >= (unsigned long)__entry_text_start &&
+		 addr < (unsigned long)__entry_text_end);
+}
 
 int __init arch_init_kprobes(void)
 {
 	return 0;
 }
 
-int __kprobes arch_trampoline_kprobe(struct kprobe *p)
+int arch_trampoline_kprobe(struct kprobe *p)
 {
 	return 0;
 }
diff --git a/arch/x86/kernel/kprobes/ftrace.c b/arch/x86/kernel/kprobes/ftrace.c
index 23ef5c5..717b02a 100644
--- a/arch/x86/kernel/kprobes/ftrace.c
+++ b/arch/x86/kernel/kprobes/ftrace.c
@@ -25,8 +25,9 @@
 
 #include "common.h"
 
-static int __skip_singlestep(struct kprobe *p, struct pt_regs *regs,
-			     struct kprobe_ctlblk *kcb)
+static nokprobe_inline
+int __skip_singlestep(struct kprobe *p, struct pt_regs *regs,
+		      struct kprobe_ctlblk *kcb)
 {
 	/*
 	 * Emulate singlestep (and also recover regs->ip)
@@ -41,18 +42,19 @@ static int __skip_singlestep(struct kprobe *p, struct pt_regs *regs,
 	return 1;
 }
 
-int __kprobes skip_singlestep(struct kprobe *p, struct pt_regs *regs,
-			      struct kprobe_ctlblk *kcb)
+int skip_singlestep(struct kprobe *p, struct pt_regs *regs,
+		    struct kprobe_ctlblk *kcb)
 {
 	if (kprobe_ftrace(p))
 		return __skip_singlestep(p, regs, kcb);
 	else
 		return 0;
 }
+NOKPROBE_SYMBOL(skip_singlestep);
 
 /* Ftrace callback handler for kprobes */
-void __kprobes kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
-				     struct ftrace_ops *ops, struct pt_regs *regs)
+void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
+			   struct ftrace_ops *ops, struct pt_regs *regs)
 {
 	struct kprobe *p;
 	struct kprobe_ctlblk *kcb;
@@ -84,8 +86,9 @@ void __kprobes kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
 end:
 	local_irq_restore(flags);
 }
+NOKPROBE_SYMBOL(kprobe_ftrace_handler);
 
-int __kprobes arch_prepare_kprobe_ftrace(struct kprobe *p)
+int arch_prepare_kprobe_ftrace(struct kprobe *p)
 {
 	p->ainsn.insn = NULL;
 	p->ainsn.boostable = -1;
diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index 898160b..f304773 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -77,7 +77,7 @@ found:
 }
 
 /* Insert a move instruction which sets a pointer to eax/rdi (1st arg). */
-static void __kprobes synthesize_set_arg1(kprobe_opcode_t *addr, unsigned long val)
+static void synthesize_set_arg1(kprobe_opcode_t *addr, unsigned long val)
 {
 #ifdef CONFIG_X86_64
 	*addr++ = 0x48;
@@ -138,7 +138,8 @@ asm (
 #define INT3_SIZE sizeof(kprobe_opcode_t)
 
 /* Optimized kprobe call back function: called from optinsn */
-static void __kprobes optimized_callback(struct optimized_kprobe *op, struct pt_regs *regs)
+static void
+optimized_callback(struct optimized_kprobe *op, struct pt_regs *regs)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 	unsigned long flags;
@@ -168,8 +169,9 @@ static void __kprobes optimized_callback(struct optimized_kprobe *op, struct pt_
 	}
 	local_irq_restore(flags);
 }
+NOKPROBE_SYMBOL(optimized_callback);
 
-static int __kprobes copy_optimized_instructions(u8 *dest, u8 *src)
+static int copy_optimized_instructions(u8 *dest, u8 *src)
 {
 	int len = 0, ret;
 
@@ -189,7 +191,7 @@ static int __kprobes copy_optimized_instructions(u8 *dest, u8 *src)
 }
 
 /* Check whether insn is indirect jump */
-static int __kprobes insn_is_indirect_jump(struct insn *insn)
+static int insn_is_indirect_jump(struct insn *insn)
 {
 	return ((insn->opcode.bytes[0] == 0xff &&
 		(X86_MODRM_REG(insn->modrm.value) & 6) == 4) || /* Jump */
@@ -224,7 +226,7 @@ static int insn_jump_into_range(struct insn *insn, unsigned long start, int len)
 }
 
 /* Decode whole function to ensure any instructions don't jump into target */
-static int __kprobes can_optimize(unsigned long paddr)
+static int can_optimize(unsigned long paddr)
 {
 	unsigned long addr, size = 0, offset = 0;
 	struct insn insn;
@@ -275,7 +277,7 @@ static int __kprobes can_optimize(unsigned long paddr)
 }
 
 /* Check optimized_kprobe can actually be optimized. */
-int __kprobes arch_check_optimized_kprobe(struct optimized_kprobe *op)
+int arch_check_optimized_kprobe(struct optimized_kprobe *op)
 {
 	int i;
 	struct kprobe *p;
@@ -290,15 +292,15 @@ int __kprobes arch_check_optimized_kprobe(struct optimized_kprobe *op)
 }
 
 /* Check the addr is within the optimized instructions. */
-int __kprobes
-arch_within_optimized_kprobe(struct optimized_kprobe *op, unsigned long addr)
+int arch_within_optimized_kprobe(struct optimized_kprobe *op,
+				 unsigned long addr)
 {
 	return ((unsigned long)op->kp.addr <= addr &&
 		(unsigned long)op->kp.addr + op->optinsn.size > addr);
 }
 
 /* Free optimized instruction slot */
-static __kprobes
+static
 void __arch_remove_optimized_kprobe(struct optimized_kprobe *op, int dirty)
 {
 	if (op->optinsn.insn) {
@@ -308,7 +310,7 @@ void __arch_remove_optimized_kprobe(struct optimized_kprobe *op, int dirty)
 	}
 }
 
-void __kprobes arch_remove_optimized_kprobe(struct optimized_kprobe *op)
+void arch_remove_optimized_kprobe(struct optimized_kprobe *op)
 {
 	__arch_remove_optimized_kprobe(op, 1);
 }
@@ -318,7 +320,7 @@ void __kprobes arch_remove_optimized_kprobe(struct optimized_kprobe *op)
  * Target instructions MUST be relocatable (checked inside)
  * This is called when new aggr(opt)probe is allocated or reused.
  */
-int __kprobes arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
+int arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
 {
 	u8 *buf;
 	int ret;
@@ -372,7 +374,7 @@ int __kprobes arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
  * Replace breakpoints (int3) with relative jumps.
  * Caller must call with locking kprobe_mutex and text_mutex.
  */
-void __kprobes arch_optimize_kprobes(struct list_head *oplist)
+void arch_optimize_kprobes(struct list_head *oplist)
 {
 	struct optimized_kprobe *op, *tmp;
 	u8 insn_buf[RELATIVEJUMP_SIZE];
@@ -398,7 +400,7 @@ void __kprobes arch_optimize_kprobes(struct list_head *oplist)
 }
 
 /* Replace a relative jump with a breakpoint (int3).  */
-void __kprobes arch_unoptimize_kprobe(struct optimized_kprobe *op)
+void arch_unoptimize_kprobe(struct optimized_kprobe *op)
 {
 	u8 insn_buf[RELATIVEJUMP_SIZE];
 
@@ -424,8 +426,7 @@ extern void arch_unoptimize_kprobes(struct list_head *oplist,
 	}
 }
 
-int  __kprobes
-setup_detour_execution(struct kprobe *p, struct pt_regs *regs, int reenter)
+int setup_detour_execution(struct kprobe *p, struct pt_regs *regs, int reenter)
 {
 	struct optimized_kprobe *op;
 
@@ -441,3 +442,4 @@ setup_detour_execution(struct kprobe *p, struct pt_regs *regs, int reenter)
 	}
 	return 0;
 }
+NOKPROBE_SYMBOL(setup_detour_execution);
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 0331cb3..d81abcb 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -251,8 +251,9 @@ u32 kvm_read_and_reset_pf_reason(void)
 	return reason;
 }
 EXPORT_SYMBOL_GPL(kvm_read_and_reset_pf_reason);
+NOKPROBE_SYMBOL(kvm_read_and_reset_pf_reason);
 
-dotraplinkage void __kprobes
+dotraplinkage void
 do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	enum ctx_state prev_state;
@@ -276,6 +277,7 @@ do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
 		break;
 	}
 }
+NOKPROBE_SYMBOL(do_async_page_fault);
 
 static void __init paravirt_ops_setup(void)
 {
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index b4872b9..c3e985d 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -110,7 +110,7 @@ static void nmi_max_handler(struct irq_work *w)
 		a->handler, whole_msecs, decimal_msecs);
 }
 
-static int __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2b)
+static int nmi_handle(unsigned int type, struct pt_regs *regs, bool b2b)
 {
 	struct nmi_desc *desc = nmi_to_desc(type);
 	struct nmiaction *a;
@@ -146,6 +146,7 @@ static int __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2
 	/* return total number of NMI events handled */
 	return handled;
 }
+NOKPROBE_SYMBOL(nmi_handle);
 
 int __register_nmi_handler(unsigned int type, struct nmiaction *action)
 {
@@ -208,7 +209,7 @@ void unregister_nmi_handler(unsigned int type, const char *name)
 }
 EXPORT_SYMBOL_GPL(unregister_nmi_handler);
 
-static __kprobes void
+static void
 pci_serr_error(unsigned char reason, struct pt_regs *regs)
 {
 	/* check to see if anyone registered against these types of errors */
@@ -238,8 +239,9 @@ pci_serr_error(unsigned char reason, struct pt_regs *regs)
 	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_SERR;
 	outb(reason, NMI_REASON_PORT);
 }
+NOKPROBE_SYMBOL(pci_serr_error);
 
-static __kprobes void
+static void
 io_check_error(unsigned char reason, struct pt_regs *regs)
 {
 	unsigned long i;
@@ -269,8 +271,9 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
 	reason &= ~NMI_REASON_CLEAR_IOCHK;
 	outb(reason, NMI_REASON_PORT);
 }
+NOKPROBE_SYMBOL(io_check_error);
 
-static __kprobes void
+static void
 unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 {
 	int handled;
@@ -298,11 +301,12 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 
 	pr_emerg("Dazed and confused, but trying to continue\n");
 }
+NOKPROBE_SYMBOL(unknown_nmi_error);
 
 static DEFINE_PER_CPU(bool, swallow_nmi);
 static DEFINE_PER_CPU(unsigned long, last_nmi_rip);
 
-static __kprobes void default_do_nmi(struct pt_regs *regs)
+static void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
 	int handled;
@@ -401,6 +405,7 @@ static __kprobes void default_do_nmi(struct pt_regs *regs)
 	else
 		unknown_nmi_error(reason, regs);
 }
+NOKPROBE_SYMBOL(default_do_nmi);
 
 /*
  * NMIs can hit breakpoints which will cause it to lose its
@@ -520,7 +525,7 @@ static inline void nmi_nesting_postprocess(void)
 }
 #endif
 
-dotraplinkage notrace __kprobes void
+dotraplinkage notrace void
 do_nmi(struct pt_regs *regs, long error_code)
 {
 	nmi_nesting_preprocess(regs);
@@ -537,6 +542,7 @@ do_nmi(struct pt_regs *regs, long error_code)
 	/* On i386, may loop back to preprocess */
 	nmi_nesting_postprocess();
 }
+NOKPROBE_SYMBOL(do_nmi);
 
 void stop_nmi(void)
 {
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 1b10af8..548d25f 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -23,6 +23,7 @@
 #include <linux/efi.h>
 #include <linux/bcd.h>
 #include <linux/highmem.h>
+#include <linux/kprobes.h>
 
 #include <asm/bug.h>
 #include <asm/paravirt.h>
@@ -389,6 +390,11 @@ __visible struct pv_cpu_ops pv_cpu_ops = {
 	.end_context_switch = paravirt_nop,
 };
 
+/* At this point, native_get/set_debugreg has real function entries */
+NOKPROBE_SYMBOL(native_get_debugreg);
+NOKPROBE_SYMBOL(native_set_debugreg);
+NOKPROBE_SYMBOL(native_load_idt);
+
 struct pv_apic_ops pv_apic_ops = {
 #ifdef CONFIG_X86_LOCAL_APIC
 	.startup_ipi_hook = paravirt_nop,
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 898d077..ca5b02d 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -413,12 +413,11 @@ void set_personality_ia32(bool x32)
 	set_thread_flag(TIF_ADDR32);
 
 	/* Mark the associated mm as containing 32-bit tasks. */
-	if (current->mm)
-		current->mm->context.ia32_compat = 1;
-
 	if (x32) {
 		clear_thread_flag(TIF_IA32);
 		set_thread_flag(TIF_X32);
+		if (current->mm)
+			current->mm->context.ia32_compat = TIF_X32;
 		current->personality &= ~READ_IMPLIES_EXEC;
 		/* is_compat_task() uses the presence of the x32
 		   syscall bit flag to determine compat status */
@@ -426,6 +425,8 @@ void set_personality_ia32(bool x32)
 	} else {
 		set_thread_flag(TIF_IA32);
 		clear_thread_flag(TIF_X32);
+		if (current->mm)
+			current->mm->context.ia32_compat = TIF_IA32;
 		current->personality |= force_personality32;
 		/* Prepare the first "return" to user space */
 		current_thread_info()->status |= TS_COMPAT;
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index f73b5d4..c6eb418 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -23,6 +23,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/ptrace.h>
+#include <linux/uprobes.h>
 #include <linux/string.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
@@ -106,7 +107,7 @@ static inline void preempt_conditional_cli(struct pt_regs *regs)
 	preempt_count_dec();
 }
 
-static int __kprobes
+static nokprobe_inline int
 do_trap_no_signal(struct task_struct *tsk, int trapnr, char *str,
 		  struct pt_regs *regs,	long error_code)
 {
@@ -136,7 +137,38 @@ do_trap_no_signal(struct task_struct *tsk, int trapnr, char *str,
 	return -1;
 }
 
-static void __kprobes
+static siginfo_t *fill_trap_info(struct pt_regs *regs, int signr, int trapnr,
+				siginfo_t *info)
+{
+	unsigned long siaddr;
+	int sicode;
+
+	switch (trapnr) {
+	default:
+		return SEND_SIG_PRIV;
+
+	case X86_TRAP_DE:
+		sicode = FPE_INTDIV;
+		siaddr = uprobe_get_trap_addr(regs);
+		break;
+	case X86_TRAP_UD:
+		sicode = ILL_ILLOPN;
+		siaddr = uprobe_get_trap_addr(regs);
+		break;
+	case X86_TRAP_AC:
+		sicode = BUS_ADRALN;
+		siaddr = 0;
+		break;
+	}
+
+	info->si_signo = signr;
+	info->si_errno = 0;
+	info->si_code = sicode;
+	info->si_addr = (void __user *)siaddr;
+	return info;
+}
+
+static void
 do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 	long error_code, siginfo_t *info)
 {
@@ -168,60 +200,43 @@ do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 	}
 #endif
 
-	if (info)
-		force_sig_info(signr, info, tsk);
-	else
-		force_sig(signr, tsk);
+	force_sig_info(signr, info ?: SEND_SIG_PRIV, tsk);
 }
+NOKPROBE_SYMBOL(do_trap);
 
-#define DO_ERROR(trapnr, signr, str, name)				\
-dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
-{									\
-	enum ctx_state prev_state;					\
-									\
-	prev_state = exception_enter();					\
-	if (notify_die(DIE_TRAP, str, regs, error_code,			\
-			trapnr, signr) == NOTIFY_STOP) {		\
-		exception_exit(prev_state);				\
-		return;							\
-	}								\
-	conditional_sti(regs);						\
-	do_trap(trapnr, signr, str, regs, error_code, NULL);		\
-	exception_exit(prev_state);					\
+static void do_error_trap(struct pt_regs *regs, long error_code, char *str,
+			  unsigned long trapnr, int signr)
+{
+	enum ctx_state prev_state = exception_enter();
+	siginfo_t info;
+
+	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr) !=
+			NOTIFY_STOP) {
+		conditional_sti(regs);
+		do_trap(trapnr, signr, str, regs, error_code,
+			fill_trap_info(regs, signr, trapnr, &info));
+	}
+
+	exception_exit(prev_state);
 }
 
-#define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr)		\
+#define DO_ERROR(trapnr, signr, str, name)				\
 dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 {									\
-	siginfo_t info;							\
-	enum ctx_state prev_state;					\
-									\
-	info.si_signo = signr;						\
-	info.si_errno = 0;						\
-	info.si_code = sicode;						\
-	info.si_addr = (void __user *)siaddr;				\
-	prev_state = exception_enter();					\
-	if (notify_die(DIE_TRAP, str, regs, error_code,			\
-			trapnr, signr) == NOTIFY_STOP) {		\
-		exception_exit(prev_state);				\
-		return;							\
-	}								\
-	conditional_sti(regs);						\
-	do_trap(trapnr, signr, str, regs, error_code, &info);		\
-	exception_exit(prev_state);					\
+	do_error_trap(regs, error_code, str, trapnr, signr);		\
 }
 
-DO_ERROR_INFO(X86_TRAP_DE,     SIGFPE,  "divide error",			divide_error,		     FPE_INTDIV, regs->ip )
-DO_ERROR     (X86_TRAP_OF,     SIGSEGV, "overflow",			overflow					  )
-DO_ERROR     (X86_TRAP_BR,     SIGSEGV, "bounds",			bounds						  )
-DO_ERROR_INFO(X86_TRAP_UD,     SIGILL,  "invalid opcode",		invalid_op,		     ILL_ILLOPN, regs->ip )
-DO_ERROR     (X86_TRAP_OLD_MF, SIGFPE,  "coprocessor segment overrun",	coprocessor_segment_overrun			  )
-DO_ERROR     (X86_TRAP_TS,     SIGSEGV, "invalid TSS",			invalid_TSS					  )
-DO_ERROR     (X86_TRAP_NP,     SIGBUS,  "segment not present",		segment_not_present				  )
+DO_ERROR(X86_TRAP_DE,     SIGFPE,  "divide error",		divide_error)
+DO_ERROR(X86_TRAP_OF,     SIGSEGV, "overflow",			overflow)
+DO_ERROR(X86_TRAP_BR,     SIGSEGV, "bounds",			bounds)
+DO_ERROR(X86_TRAP_UD,     SIGILL,  "invalid opcode",		invalid_op)
+DO_ERROR(X86_TRAP_OLD_MF, SIGFPE,  "coprocessor segment overrun",coprocessor_segment_overrun)
+DO_ERROR(X86_TRAP_TS,     SIGSEGV, "invalid TSS",		invalid_TSS)
+DO_ERROR(X86_TRAP_NP,     SIGBUS,  "segment not present",	segment_not_present)
 #ifdef CONFIG_X86_32
-DO_ERROR     (X86_TRAP_SS,     SIGBUS,  "stack segment",		stack_segment					  )
+DO_ERROR(X86_TRAP_SS,     SIGBUS,  "stack segment",		stack_segment)
 #endif
-DO_ERROR_INFO(X86_TRAP_AC,     SIGBUS,  "alignment check",		alignment_check,	     BUS_ADRALN, 0	  )
+DO_ERROR(X86_TRAP_AC,     SIGBUS,  "alignment check",		alignment_check)
 
 #ifdef CONFIG_X86_64
 /* Runs on IST stack */
@@ -263,7 +278,7 @@ dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
 }
 #endif
 
-dotraplinkage void __kprobes
+dotraplinkage void
 do_general_protection(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk;
@@ -305,13 +320,14 @@ do_general_protection(struct pt_regs *regs, long error_code)
 		pr_cont("\n");
 	}
 
-	force_sig(SIGSEGV, tsk);
+	force_sig_info(SIGSEGV, SEND_SIG_PRIV, tsk);
 exit:
 	exception_exit(prev_state);
 }
+NOKPROBE_SYMBOL(do_general_protection);
 
 /* May run on IST stack. */
-dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_code)
+dotraplinkage void notrace do_int3(struct pt_regs *regs, long error_code)
 {
 	enum ctx_state prev_state;
 
@@ -327,13 +343,18 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
 	if (poke_int3_handler(regs))
 		return;
 
-	prev_state = exception_enter();
 #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
 	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
 				SIGTRAP) == NOTIFY_STOP)
 		goto exit;
 #endif /* CONFIG_KGDB_LOW_LEVEL_TRAP */
 
+#ifdef CONFIG_KPROBES
+	if (kprobe_int3_handler(regs))
+		return;
+#endif
+	prev_state = exception_enter();
+
 	if (notify_die(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
 			SIGTRAP) == NOTIFY_STOP)
 		goto exit;
@@ -350,6 +371,7 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
 exit:
 	exception_exit(prev_state);
 }
+NOKPROBE_SYMBOL(do_int3);
 
 #ifdef CONFIG_X86_64
 /*
@@ -357,7 +379,7 @@ exit:
  * for scheduling or signal handling. The actual stack switch is done in
  * entry.S
  */
-asmlinkage __visible __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
+asmlinkage __visible struct pt_regs *sync_regs(struct pt_regs *eregs)
 {
 	struct pt_regs *regs = eregs;
 	/* Did already sync */
@@ -376,6 +398,7 @@ asmlinkage __visible __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
 		*regs = *eregs;
 	return regs;
 }
+NOKPROBE_SYMBOL(sync_regs);
 #endif
 
 /*
@@ -402,7 +425,7 @@ asmlinkage __visible __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
  *
  * May run on IST stack.
  */
-dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
+dotraplinkage void do_debug(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk = current;
 	enum ctx_state prev_state;
@@ -410,8 +433,6 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	unsigned long dr6;
 	int si_code;
 
-	prev_state = exception_enter();
-
 	get_debugreg(dr6, 6);
 
 	/* Filter out all the reserved bits which are preset to 1 */
@@ -440,6 +461,12 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	/* Store the virtualized DR6 value */
 	tsk->thread.debugreg6 = dr6;
 
+#ifdef CONFIG_KPROBES
+	if (kprobe_debug_handler(regs))
+		goto exit;
+#endif
+	prev_state = exception_enter();
+
 	if (notify_die(DIE_DEBUG, "debug", regs, (long)&dr6, error_code,
 							SIGTRAP) == NOTIFY_STOP)
 		goto exit;
@@ -482,13 +509,14 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 exit:
 	exception_exit(prev_state);
 }
+NOKPROBE_SYMBOL(do_debug);
 
 /*
  * Note that we play around with the 'TS' bit in an attempt to get
  * the correct behaviour even in the presence of the asynchronous
  * IRQ13 behaviour
  */
-void math_error(struct pt_regs *regs, int error_code, int trapnr)
+static void math_error(struct pt_regs *regs, int error_code, int trapnr)
 {
 	struct task_struct *task = current;
 	siginfo_t info;
@@ -518,7 +546,7 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
 	task->thread.error_code = error_code;
 	info.si_signo = SIGFPE;
 	info.si_errno = 0;
-	info.si_addr = (void __user *)regs->ip;
+	info.si_addr = (void __user *)uprobe_get_trap_addr(regs);
 	if (trapnr == X86_TRAP_MF) {
 		unsigned short cwd, swd;
 		/*
@@ -645,7 +673,7 @@ void math_state_restore(void)
 	 */
 	if (unlikely(restore_fpu_checking(tsk))) {
 		drop_init_fpu(tsk);
-		force_sig(SIGSEGV, tsk);
+		force_sig_info(SIGSEGV, SEND_SIG_PRIV, tsk);
 		return;
 	}
 
@@ -653,7 +681,7 @@ void math_state_restore(void)
 }
 EXPORT_SYMBOL_GPL(math_state_restore);
 
-dotraplinkage void __kprobes
+dotraplinkage void
 do_device_not_available(struct pt_regs *regs, long error_code)
 {
 	enum ctx_state prev_state;
@@ -679,6 +707,7 @@ do_device_not_available(struct pt_regs *regs, long error_code)
 #endif
 	exception_exit(prev_state);
 }
+NOKPROBE_SYMBOL(do_device_not_available);
 
 #ifdef CONFIG_X86_32
 dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 2ed8459..5d1cbfe 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -32,20 +32,20 @@
 
 /* Post-execution fixups. */
 
-/* No fixup needed */
-#define UPROBE_FIX_NONE		0x0
-
 /* Adjust IP back to vicinity of actual insn */
-#define UPROBE_FIX_IP		0x1
+#define UPROBE_FIX_IP		0x01
 
 /* Adjust the return address of a call insn */
-#define UPROBE_FIX_CALL	0x2
+#define UPROBE_FIX_CALL		0x02
 
 /* Instruction will modify TF, don't change it */
-#define UPROBE_FIX_SETF	0x4
+#define UPROBE_FIX_SETF		0x04
 
-#define UPROBE_FIX_RIP_AX	0x8000
-#define UPROBE_FIX_RIP_CX	0x4000
+#define UPROBE_FIX_RIP_SI	0x08
+#define UPROBE_FIX_RIP_DI	0x10
+#define UPROBE_FIX_RIP_BX	0x20
+#define UPROBE_FIX_RIP_MASK	\
+	(UPROBE_FIX_RIP_SI | UPROBE_FIX_RIP_DI | UPROBE_FIX_RIP_BX)
 
 #define	UPROBE_TRAP_NR		UINT_MAX
 
@@ -53,7 +53,7 @@
 #define OPCODE1(insn)		((insn)->opcode.bytes[0])
 #define OPCODE2(insn)		((insn)->opcode.bytes[1])
 #define OPCODE3(insn)		((insn)->opcode.bytes[2])
-#define MODRM_REG(insn)		X86_MODRM_REG(insn->modrm.value)
+#define MODRM_REG(insn)		X86_MODRM_REG((insn)->modrm.value)
 
 #define W(row, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)\
 	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
@@ -67,6 +67,7 @@
  * to keep gcc from statically optimizing it out, as variable_test_bit makes
  * some versions of gcc to think only *(unsigned long*) is used.
  */
+#if defined(CONFIG_X86_32) || defined(CONFIG_IA32_EMULATION)
 static volatile u32 good_insns_32[256 / 32] = {
 	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
 	/*      ----------------------------------------------         */
@@ -89,33 +90,12 @@ static volatile u32 good_insns_32[256 / 32] = {
 	/*      ----------------------------------------------         */
 	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
 };
+#else
+#define good_insns_32	NULL
+#endif
 
-/* Using this for both 64-bit and 32-bit apps */
-static volatile u32 good_2byte_insns[256 / 32] = {
-	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
-	/*      ----------------------------------------------         */
-	W(0x00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1) | /* 00 */
-	W(0x10, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1) , /* 10 */
-	W(0x20, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1) | /* 20 */
-	W(0x30, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 30 */
-	W(0x40, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 40 */
-	W(0x50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 50 */
-	W(0x60, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 60 */
-	W(0x70, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1) , /* 70 */
-	W(0x80, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 80 */
-	W(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 90 */
-	W(0xa0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1) | /* a0 */
-	W(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1) , /* b0 */
-	W(0xc0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* c0 */
-	W(0xd0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* d0 */
-	W(0xe0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* e0 */
-	W(0xf0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0)   /* f0 */
-	/*      ----------------------------------------------         */
-	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
-};
-
-#ifdef CONFIG_X86_64
 /* Good-instruction tables for 64-bit apps */
+#if defined(CONFIG_X86_64)
 static volatile u32 good_insns_64[256 / 32] = {
 	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
 	/*      ----------------------------------------------         */
@@ -138,7 +118,33 @@ static volatile u32 good_insns_64[256 / 32] = {
 	/*      ----------------------------------------------         */
 	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
 };
+#else
+#define good_insns_64	NULL
 #endif
+
+/* Using this for both 64-bit and 32-bit apps */
+static volatile u32 good_2byte_insns[256 / 32] = {
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
+	/*      ----------------------------------------------         */
+	W(0x00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1) | /* 00 */
+	W(0x10, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1) , /* 10 */
+	W(0x20, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1) | /* 20 */
+	W(0x30, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 30 */
+	W(0x40, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 40 */
+	W(0x50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 50 */
+	W(0x60, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 60 */
+	W(0x70, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1) , /* 70 */
+	W(0x80, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 80 */
+	W(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 90 */
+	W(0xa0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1) | /* a0 */
+	W(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1) , /* b0 */
+	W(0xc0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* c0 */
+	W(0xd0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* d0 */
+	W(0xe0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* e0 */
+	W(0xf0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0)   /* f0 */
+	/*      ----------------------------------------------         */
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
+};
 #undef W
 
 /*
@@ -209,16 +215,25 @@ static bool is_prefix_bad(struct insn *insn)
 	return false;
 }
 
-static int validate_insn_32bits(struct arch_uprobe *auprobe, struct insn *insn)
+static int uprobe_init_insn(struct arch_uprobe *auprobe, struct insn *insn, bool x86_64)
 {
-	insn_init(insn, auprobe->insn, false);
+	u32 volatile *good_insns;
+
+	insn_init(insn, auprobe->insn, x86_64);
+	/* has the side-effect of processing the entire instruction */
+	insn_get_length(insn);
+	if (WARN_ON_ONCE(!insn_complete(insn)))
+		return -ENOEXEC;
 
-	/* Skip good instruction prefixes; reject "bad" ones. */
-	insn_get_opcode(insn);
 	if (is_prefix_bad(insn))
 		return -ENOTSUPP;
 
-	if (test_bit(OPCODE1(insn), (unsigned long *)good_insns_32))
+	if (x86_64)
+		good_insns = good_insns_64;
+	else
+		good_insns = good_insns_32;
+
+	if (test_bit(OPCODE1(insn), (unsigned long *)good_insns))
 		return 0;
 
 	if (insn->opcode.nbytes == 2) {
@@ -229,72 +244,19 @@ static int validate_insn_32bits(struct arch_uprobe *auprobe, struct insn *insn)
 	return -ENOTSUPP;
 }
 
-/*
- * Figure out which fixups arch_uprobe_post_xol() will need to perform, and
- * annotate arch_uprobe->fixups accordingly.  To start with,
- * arch_uprobe->fixups is either zero or it reflects rip-related fixups.
- */
-static void prepare_fixups(struct arch_uprobe *auprobe, struct insn *insn)
+#ifdef CONFIG_X86_64
+static inline bool is_64bit_mm(struct mm_struct *mm)
 {
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
+	return	!config_enabled(CONFIG_IA32_EMULATION) ||
+		!(mm->context.ia32_compat == TIF_IA32);
 }
-
-#ifdef CONFIG_X86_64
 /*
  * If arch_uprobe->insn doesn't use rip-relative addressing, return
  * immediately.  Otherwise, rewrite the instruction so that it accesses
  * its memory operand indirectly through a scratch register.  Set
- * arch_uprobe->fixups and arch_uprobe->rip_rela_target_address
- * accordingly.  (The contents of the scratch register will be saved
- * before we single-step the modified instruction, and restored
- * afterward.)
+ * defparam->fixups accordingly. (The contents of the scratch register
+ * will be saved before we single-step the modified instruction,
+ * and restored afterward).
  *
  * We do this because a rip-relative instruction can access only a
  * relatively small area (+/- 2 GB from the instruction), and the XOL
@@ -305,248 +267,513 @@ static void prepare_fixups(struct arch_uprobe *auprobe, struct insn *insn)
  *
  * Some useful facts about rip-relative instructions:
  *
- *  - There's always a modrm byte.
+ *  - There's always a modrm byte with bit layout "00 reg 101".
  *  - There's never a SIB byte.
  *  - The displacement is always 4 bytes.
+ *  - REX.B=1 bit in REX prefix, which normally extends r/m field,
+ *    has no effect on rip-relative mode. It doesn't make modrm byte
+ *    with r/m=101 refer to register 1101 = R13.
  */
-static void
-handle_riprel_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, struct insn *insn)
+static void riprel_analyze(struct arch_uprobe *auprobe, struct insn *insn)
 {
 	u8 *cursor;
 	u8 reg;
+	u8 reg2;
 
-	if (mm->context.ia32_compat)
-		return;
-
-	auprobe->rip_rela_target_address = 0x0;
 	if (!insn_rip_relative(insn))
 		return;
 
 	/*
-	 * insn_rip_relative() would have decoded rex_prefix, modrm.
+	 * insn_rip_relative() would have decoded rex_prefix, vex_prefix, modrm.
 	 * Clear REX.b bit (extension of MODRM.rm field):
-	 * we want to encode rax/rcx, not r8/r9.
+	 * we want to encode low numbered reg, not r8+.
 	 */
 	if (insn->rex_prefix.nbytes) {
 		cursor = auprobe->insn + insn_offset_rex_prefix(insn);
-		*cursor &= 0xfe;	/* Clearing REX.B bit */
+		/* REX byte has 0100wrxb layout, clearing REX.b bit */
+		*cursor &= 0xfe;
+	}
+	/*
+	 * Similar treatment for VEX3 prefix.
+	 * TODO: add XOP/EVEX treatment when insn decoder supports them
+	 */
+	if (insn->vex_prefix.nbytes == 3) {
+		/*
+		 * vex2:     c5    rvvvvLpp   (has no b bit)
+		 * vex3/xop: c4/8f rxbmmmmm wvvvvLpp
+		 * evex:     62    rxbR00mm wvvvv1pp zllBVaaa
+		 *   (evex will need setting of both b and x since
+		 *   in non-sib encoding evex.x is 4th bit of MODRM.rm)
+		 * Setting VEX3.b (setting because it has inverted meaning):
+		 */
+		cursor = auprobe->insn + insn_offset_vex_prefix(insn) + 1;
+		*cursor |= 0x20;
 	}
 
 	/*
+	 * Convert from rip-relative addressing to register-relative addressing
+	 * via a scratch register.
+	 *
+	 * This is tricky since there are insns with modrm byte
+	 * which also use registers not encoded in modrm byte:
+	 * [i]div/[i]mul: implicitly use dx:ax
+	 * shift ops: implicitly use cx
+	 * cmpxchg: implicitly uses ax
+	 * cmpxchg8/16b: implicitly uses dx:ax and bx:cx
+	 *   Encoding: 0f c7/1 modrm
+	 *   The code below thinks that reg=1 (cx), chooses si as scratch.
+	 * mulx: implicitly uses dx: mulx r/m,r1,r2 does r1:r2 = dx * r/m.
+	 *   First appeared in Haswell (BMI2 insn). It is vex-encoded.
+	 *   Example where none of bx,cx,dx can be used as scratch reg:
+	 *   c4 e2 63 f6 0d disp32   mulx disp32(%rip),%ebx,%ecx
+	 * [v]pcmpistri: implicitly uses cx, xmm0
+	 * [v]pcmpistrm: implicitly uses xmm0
+	 * [v]pcmpestri: implicitly uses ax, dx, cx, xmm0
+	 * [v]pcmpestrm: implicitly uses ax, dx, xmm0
+	 *   Evil SSE4.2 string comparison ops from hell.
+	 * maskmovq/[v]maskmovdqu: implicitly uses (ds:rdi) as destination.
+	 *   Encoding: 0f f7 modrm, 66 0f f7 modrm, vex-encoded: c5 f9 f7 modrm.
+	 *   Store op1, byte-masked by op2 msb's in each byte, to (ds:rdi).
+	 *   AMD says it has no 3-operand form (vex.vvvv must be 1111)
+	 *   and that it can have only register operands, not mem
+	 *   (its modrm byte must have mode=11).
+	 *   If these restrictions will ever be lifted,
+	 *   we'll need code to prevent selection of di as scratch reg!
+	 *
+	 * Summary: I don't know any insns with modrm byte which
+	 * use SI register implicitly. DI register is used only
+	 * by one insn (maskmovq) and BX register is used
+	 * only by one too (cmpxchg8b).
+	 * BP is stack-segment based (may be a problem?).
+	 * AX, DX, CX are off-limits (many implicit users).
+	 * SP is unusable (it's stack pointer - think about "pop mem";
+	 * also, rsp+disp32 needs sib encoding -> insn length change).
+	 */
+
+	reg = MODRM_REG(insn);	/* Fetch modrm.reg */
+	reg2 = 0xff;		/* Fetch vex.vvvv */
+	if (insn->vex_prefix.nbytes == 2)
+		reg2 = insn->vex_prefix.bytes[1];
+	else if (insn->vex_prefix.nbytes == 3)
+		reg2 = insn->vex_prefix.bytes[2];
+	/*
+	 * TODO: add XOP, EXEV vvvv reading.
+	 *
+	 * vex.vvvv field is in bits 6-3, bits are inverted.
+	 * But in 32-bit mode, high-order bit may be ignored.
+	 * Therefore, let's consider only 3 low-order bits.
+	 */
+	reg2 = ((reg2 >> 3) & 0x7) ^ 0x7;
+	/*
+	 * Register numbering is ax,cx,dx,bx, sp,bp,si,di, r8..r15.
+	 *
+	 * Choose scratch reg. Order is important: must not select bx
+	 * if we can use si (cmpxchg8b case!)
+	 */
+	if (reg != 6 && reg2 != 6) {
+		reg2 = 6;
+		auprobe->defparam.fixups |= UPROBE_FIX_RIP_SI;
+	} else if (reg != 7 && reg2 != 7) {
+		reg2 = 7;
+		auprobe->defparam.fixups |= UPROBE_FIX_RIP_DI;
+		/* TODO (paranoia): force maskmovq to not use di */
+	} else {
+		reg2 = 3;
+		auprobe->defparam.fixups |= UPROBE_FIX_RIP_BX;
+	}
+	/*
 	 * Point cursor at the modrm byte.  The next 4 bytes are the
 	 * displacement.  Beyond the displacement, for some instructions,
 	 * is the immediate operand.
 	 */
 	cursor = auprobe->insn + insn_offset_modrm(insn);
-	insn_get_length(insn);
-
 	/*
-	 * Convert from rip-relative addressing to indirect addressing
-	 * via a scratch register.  Change the r/m field from 0x5 (%rip)
-	 * to 0x0 (%rax) or 0x1 (%rcx), and squeeze out the offset field.
+	 * Change modrm from "00 reg 101" to "10 reg reg2". Example:
+	 * 89 05 disp32  mov %eax,disp32(%rip) becomes
+	 * 89 86 disp32  mov %eax,disp32(%rsi)
 	 */
-	reg = MODRM_REG(insn);
-	if (reg == 0) {
-		/*
-		 * The register operand (if any) is either the A register
-		 * (%rax, %eax, etc.) or (if the 0x4 bit is set in the
-		 * REX prefix) %r8.  In any case, we know the C register
-		 * is NOT the register operand, so we use %rcx (register
-		 * #1) for the scratch register.
-		 */
-		auprobe->fixups = UPROBE_FIX_RIP_CX;
-		/* Change modrm from 00 000 101 to 00 000 001. */
-		*cursor = 0x1;
-	} else {
-		/* Use %rax (register #0) for the scratch register. */
-		auprobe->fixups = UPROBE_FIX_RIP_AX;
-		/* Change modrm from 00 xxx 101 to 00 xxx 000 */
-		*cursor = (reg << 3);
-	}
-
-	/* Target address = address of next instruction + (signed) offset */
-	auprobe->rip_rela_target_address = (long)insn->length + insn->displacement.value;
-
-	/* Displacement field is gone; slide immediate field (if any) over. */
-	if (insn->immediate.nbytes) {
-		cursor++;
-		memmove(cursor, cursor + insn->displacement.nbytes, insn->immediate.nbytes);
-	}
-	return;
+	*cursor = 0x80 | (reg << 3) | reg2;
 }
 
-static int validate_insn_64bits(struct arch_uprobe *auprobe, struct insn *insn)
+static inline unsigned long *
+scratch_reg(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-	insn_init(insn, auprobe->insn, true);
-
-	/* Skip good instruction prefixes; reject "bad" ones. */
-	insn_get_opcode(insn);
-	if (is_prefix_bad(insn))
-		return -ENOTSUPP;
+	if (auprobe->defparam.fixups & UPROBE_FIX_RIP_SI)
+		return &regs->si;
+	if (auprobe->defparam.fixups & UPROBE_FIX_RIP_DI)
+		return &regs->di;
+	return &regs->bx;
+}
 
-	if (test_bit(OPCODE1(insn), (unsigned long *)good_insns_64))
-		return 0;
+/*
+ * If we're emulating a rip-relative instruction, save the contents
+ * of the scratch register and store the target address in that register.
+ */
+static void riprel_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	if (auprobe->defparam.fixups & UPROBE_FIX_RIP_MASK) {
+		struct uprobe_task *utask = current->utask;
+		unsigned long *sr = scratch_reg(auprobe, regs);
 
-	if (insn->opcode.nbytes == 2) {
-		if (test_bit(OPCODE2(insn), (unsigned long *)good_2byte_insns))
-			return 0;
+		utask->autask.saved_scratch_register = *sr;
+		*sr = utask->vaddr + auprobe->defparam.ilen;
 	}
-	return -ENOTSUPP;
 }
 
-static int validate_insn_bits(struct arch_uprobe *auprobe, struct mm_struct *mm, struct insn *insn)
+static void riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-	if (mm->context.ia32_compat)
-		return validate_insn_32bits(auprobe, insn);
-	return validate_insn_64bits(auprobe, insn);
+	if (auprobe->defparam.fixups & UPROBE_FIX_RIP_MASK) {
+		struct uprobe_task *utask = current->utask;
+		unsigned long *sr = scratch_reg(auprobe, regs);
+
+		*sr = utask->autask.saved_scratch_register;
+	}
 }
 #else /* 32-bit: */
-static void handle_riprel_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, struct insn *insn)
+static inline bool is_64bit_mm(struct mm_struct *mm)
 {
-	/* No RIP-relative addressing on 32-bit */
+	return false;
 }
-
-static int validate_insn_bits(struct arch_uprobe *auprobe, struct mm_struct *mm,  struct insn *insn)
+/*
+ * No RIP-relative addressing on 32-bit
+ */
+static void riprel_analyze(struct arch_uprobe *auprobe, struct insn *insn)
+{
+}
+static void riprel_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+}
+static void riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-	return validate_insn_32bits(auprobe, insn);
 }
 #endif /* CONFIG_X86_64 */
 
-/**
- * arch_uprobe_analyze_insn - instruction analysis including validity and fixups.
- * @mm: the probed address space.
- * @arch_uprobe: the probepoint information.
- * @addr: virtual address at which to install the probepoint
- * Return 0 on success or a -ve number on error.
- */
-int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long addr)
+struct uprobe_xol_ops {
+	bool	(*emulate)(struct arch_uprobe *, struct pt_regs *);
+	int	(*pre_xol)(struct arch_uprobe *, struct pt_regs *);
+	int	(*post_xol)(struct arch_uprobe *, struct pt_regs *);
+	void	(*abort)(struct arch_uprobe *, struct pt_regs *);
+};
+
+static inline int sizeof_long(void)
 {
-	int ret;
-	struct insn insn;
+	return is_ia32_task() ? 4 : 8;
+}
 
-	auprobe->fixups = 0;
-	ret = validate_insn_bits(auprobe, mm, &insn);
-	if (ret != 0)
-		return ret;
+static int default_pre_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	riprel_pre_xol(auprobe, regs);
+	return 0;
+}
 
-	handle_riprel_insn(auprobe, mm, &insn);
-	prepare_fixups(auprobe, &insn);
+static int push_ret_address(struct pt_regs *regs, unsigned long ip)
+{
+	unsigned long new_sp = regs->sp - sizeof_long();
 
+	if (copy_to_user((void __user *)new_sp, &ip, sizeof_long()))
+		return -EFAULT;
+
+	regs->sp = new_sp;
 	return 0;
 }
 
-#ifdef CONFIG_X86_64
 /*
- * If we're emulating a rip-relative instruction, save the contents
- * of the scratch register and store the target address in that register.
+ * We have to fix things up as follows:
+ *
+ * Typically, the new ip is relative to the copied instruction.  We need
+ * to make it relative to the original instruction (FIX_IP).  Exceptions
+ * are return instructions and absolute or indirect jump or call instructions.
+ *
+ * If the single-stepped instruction was a call, the return address that
+ * is atop the stack is the address following the copied instruction.  We
+ * need to make it the address following the original instruction (FIX_CALL).
+ *
+ * If the original instruction was a rip-relative instruction such as
+ * "movl %edx,0xnnnn(%rip)", we have instead executed an equivalent
+ * instruction using a scratch register -- e.g., "movl %edx,0xnnnn(%rsi)".
+ * We need to restore the contents of the scratch register
+ * (FIX_RIP_reg).
  */
-static void
-pre_xol_rip_insn(struct arch_uprobe *auprobe, struct pt_regs *regs,
-				struct arch_uprobe_task *autask)
-{
-	if (auprobe->fixups & UPROBE_FIX_RIP_AX) {
-		autask->saved_scratch_register = regs->ax;
-		regs->ax = current->utask->vaddr;
-		regs->ax += auprobe->rip_rela_target_address;
-	} else if (auprobe->fixups & UPROBE_FIX_RIP_CX) {
-		autask->saved_scratch_register = regs->cx;
-		regs->cx = current->utask->vaddr;
-		regs->cx += auprobe->rip_rela_target_address;
+static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	struct uprobe_task *utask = current->utask;
+
+	riprel_post_xol(auprobe, regs);
+	if (auprobe->defparam.fixups & UPROBE_FIX_IP) {
+		long correction = utask->vaddr - utask->xol_vaddr;
+		regs->ip += correction;
+	} else if (auprobe->defparam.fixups & UPROBE_FIX_CALL) {
+		regs->sp += sizeof_long(); /* Pop incorrect return address */
+		if (push_ret_address(regs, utask->vaddr + auprobe->defparam.ilen))
+			return -ERESTART;
 	}
+	/* popf; tell the caller to not touch TF */
+	if (auprobe->defparam.fixups & UPROBE_FIX_SETF)
+		utask->autask.saved_tf = true;
+
+	return 0;
 }
-#else
-static void
-pre_xol_rip_insn(struct arch_uprobe *auprobe, struct pt_regs *regs,
-				struct arch_uprobe_task *autask)
+
+static void default_abort_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-	/* No RIP-relative addressing on 32-bit */
+	riprel_post_xol(auprobe, regs);
 }
-#endif
 
-/*
- * arch_uprobe_pre_xol - prepare to execute out of line.
- * @auprobe: the probepoint information.
- * @regs: reflects the saved user state of current task.
- */
-int arch_uprobe_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
+static struct uprobe_xol_ops default_xol_ops = {
+	.pre_xol  = default_pre_xol_op,
+	.post_xol = default_post_xol_op,
+	.abort	  = default_abort_op,
+};
+
+static bool branch_is_call(struct arch_uprobe *auprobe)
 {
-	struct arch_uprobe_task *autask;
+	return auprobe->branch.opc1 == 0xe8;
+}
 
-	autask = &current->utask->autask;
-	autask->saved_trap_nr = current->thread.trap_nr;
-	current->thread.trap_nr = UPROBE_TRAP_NR;
-	regs->ip = current->utask->xol_vaddr;
-	pre_xol_rip_insn(auprobe, regs, autask);
+#define CASE_COND					\
+	COND(70, 71, XF(OF))				\
+	COND(72, 73, XF(CF))				\
+	COND(74, 75, XF(ZF))				\
+	COND(78, 79, XF(SF))				\
+	COND(7a, 7b, XF(PF))				\
+	COND(76, 77, XF(CF) || XF(ZF))			\
+	COND(7c, 7d, XF(SF) != XF(OF))			\
+	COND(7e, 7f, XF(ZF) || XF(SF) != XF(OF))
 
-	autask->saved_tf = !!(regs->flags & X86_EFLAGS_TF);
-	regs->flags |= X86_EFLAGS_TF;
-	if (test_tsk_thread_flag(current, TIF_BLOCKSTEP))
-		set_task_blockstep(current, false);
+#define COND(op_y, op_n, expr)				\
+	case 0x ## op_y: DO((expr) != 0)		\
+	case 0x ## op_n: DO((expr) == 0)
 
-	return 0;
+#define XF(xf)	(!!(flags & X86_EFLAGS_ ## xf))
+
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
+		/*
+		 * If it fails we execute this (mangled, see the comment in
+		 * branch_clear_offset) insn out-of-line. In the likely case
+		 * this should trigger the trap, and the probed application
+		 * should die or restart the same insn after it handles the
+		 * signal, arch_uprobe_post_xol() won't be even called.
+		 *
+		 * But there is corner case, see the comment in ->post_xol().
+		 */
+		if (push_ret_address(regs, new_ip))
+			return false;
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
+}
+
+static void branch_clear_offset(struct arch_uprobe *auprobe, struct insn *insn)
+{
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
 }
 
-static void
-handle_riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs, long *correction)
+static struct uprobe_xol_ops branch_xol_ops = {
+	.emulate  = branch_emulate_op,
+	.post_xol = branch_post_xol_op,
+};
+
+/* Returns -ENOSYS if branch_xol_ops doesn't handle this insn */
+static int branch_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
 {
-	if (is_riprel_insn(auprobe)) {
-		struct arch_uprobe_task *autask;
+	u8 opc1 = OPCODE1(insn);
+	int i;
 
-		autask = &current->utask->autask;
-		if (auprobe->fixups & UPROBE_FIX_RIP_AX)
-			regs->ax = autask->saved_scratch_register;
-		else
-			regs->cx = autask->saved_scratch_register;
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
+	}
+
+	/*
+	 * 16-bit overrides such as CALLW (66 e8 nn nn) are not supported.
+	 * Intel and AMD behavior differ in 64-bit mode: Intel ignores 66 prefix.
+	 * No one uses these insns, reject any branch insns with such prefix.
+	 */
+	for (i = 0; i < insn->prefixes.nbytes; i++) {
+		if (insn->prefixes.bytes[i] == 0x66)
+			return -ENOTSUPP;
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
 {
-	/* No RIP-relative addressing on 32-bit */
+	struct insn insn;
+	u8 fix_ip_or_call = UPROBE_FIX_IP;
+	int ret;
+
+	ret = uprobe_init_insn(auprobe, &insn, is_64bit_mm(mm));
+	if (ret)
+		return ret;
+
+	ret = branch_setup_xol_ops(auprobe, &insn);
+	if (ret != -ENOSYS)
+		return ret;
+
+	/*
+	 * Figure out which fixups default_post_xol_op() will need to perform,
+	 * and annotate defparam->fixups accordingly.
+	 */
+	switch (OPCODE1(&insn)) {
+	case 0x9d:		/* popf */
+		auprobe->defparam.fixups |= UPROBE_FIX_SETF;
+		break;
+	case 0xc3:		/* ret or lret -- ip is correct */
+	case 0xcb:
+	case 0xc2:
+	case 0xca:
+	case 0xea:		/* jmp absolute -- ip is correct */
+		fix_ip_or_call = 0;
+		break;
+	case 0x9a:		/* call absolute - Fix return addr, not ip */
+		fix_ip_or_call = UPROBE_FIX_CALL;
+		break;
+	case 0xff:
+		switch (MODRM_REG(&insn)) {
+		case 2: case 3:			/* call or lcall, indirect */
+			fix_ip_or_call = UPROBE_FIX_CALL;
+			break;
+		case 4: case 5:			/* jmp or ljmp, indirect */
+			fix_ip_or_call = 0;
+			break;
+		}
+		/* fall through */
+	default:
+		riprel_analyze(auprobe, &insn);
+	}
+
+	auprobe->defparam.ilen = insn.length;
+	auprobe->defparam.fixups |= fix_ip_or_call;
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
+{
+	struct uprobe_task *utask = current->utask;
+
+	if (auprobe->ops->pre_xol) {
+		int err = auprobe->ops->pre_xol(auprobe, regs);
+		if (err)
+			return err;
+	}
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
+	return 0;
 }
-#endif
 
 /*
  * If xol insn itself traps and generates a signal(Say,
@@ -572,53 +799,42 @@ bool arch_uprobe_xol_was_trapped(struct task_struct *t)
  * single-step, we single-stepped a copy of the instruction.
  *
  * This function prepares to resume execution after the single-step.
- * We have to fix things up as follows:
- *
- * Typically, the new ip is relative to the copied instruction.  We need
- * to make it relative to the original instruction (FIX_IP).  Exceptions
- * are return instructions and absolute or indirect jump or call instructions.
- *
- * If the single-stepped instruction was a call, the return address that
- * is atop the stack is the address following the copied instruction.  We
- * need to make it the address following the original instruction (FIX_CALL).
- *
- * If the original instruction was a rip-relative instruction such as
- * "movl %edx,0xnnnn(%rip)", we have instead executed an equivalent
- * instruction using a scratch register -- e.g., "movl %edx,(%rax)".
- * We need to restore the contents of the scratch register and adjust
- * the ip, keeping in mind that the instruction we executed is 4 bytes
- * shorter than the original instruction (since we squeezed out the offset
- * field).  (FIX_RIP_AX or FIX_RIP_CX)
  */
 int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
-	struct uprobe_task *utask;
-	long correction;
-	int result = 0;
+	struct uprobe_task *utask = current->utask;
+	bool send_sigtrap = utask->autask.saved_tf;
+	int err = 0;
 
 	WARN_ON_ONCE(current->thread.trap_nr != UPROBE_TRAP_NR);
-
-	utask = current->utask;
 	current->thread.trap_nr = utask->autask.saved_trap_nr;
-	correction = (long)(utask->vaddr - utask->xol_vaddr);
-	handle_riprel_post_xol(auprobe, regs, &correction);
-	if (auprobe->fixups & UPROBE_FIX_IP)
-		regs->ip += correction;
-
-	if (auprobe->fixups & UPROBE_FIX_CALL)
-		result = adjust_ret_addr(regs->sp, correction);
 
+	if (auprobe->ops->post_xol) {
+		err = auprobe->ops->post_xol(auprobe, regs);
+		if (err) {
+			/*
+			 * Restore ->ip for restart or post mortem analysis.
+			 * ->post_xol() must not return -ERESTART unless this
+			 * is really possible.
+			 */
+			regs->ip = utask->vaddr;
+			if (err == -ERESTART)
+				err = 0;
+			send_sigtrap = false;
+		}
+	}
 	/*
 	 * arch_uprobe_pre_xol() doesn't save the state of TIF_BLOCKSTEP
 	 * so we can get an extra SIGTRAP if we do not clear TF. We need
 	 * to examine the opcode to make it right.
 	 */
-	if (utask->autask.saved_tf)
+	if (send_sigtrap)
 		send_sig(SIGTRAP, current, 0);
-	else if (!(auprobe->fixups & UPROBE_FIX_SETF))
+
+	if (!utask->autask.saved_tf)
 		regs->flags &= ~X86_EFLAGS_TF;
 
-	return result;
+	return err;
 }
 
 /* callback routine for handling exceptions. */
@@ -652,41 +868,27 @@ int arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val,
 
 /*
  * This function gets called when XOL instruction either gets trapped or
- * the thread has a fatal signal, so reset the instruction pointer to its
- * probed address.
+ * the thread has a fatal signal. Reset the instruction pointer to its
+ * probed address for the potential restart or for post mortem analysis.
  */
 void arch_uprobe_abort_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
 	struct uprobe_task *utask = current->utask;
 
-	current->thread.trap_nr = utask->autask.saved_trap_nr;
-	handle_riprel_post_xol(auprobe, regs, NULL);
-	instruction_pointer_set(regs, utask->vaddr);
+	if (auprobe->ops->abort)
+		auprobe->ops->abort(auprobe, regs);
 
+	current->thread.trap_nr = utask->autask.saved_trap_nr;
+	regs->ip = utask->vaddr;
 	/* clear TF if it was set by us in arch_uprobe_pre_xol() */
 	if (!utask->autask.saved_tf)
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
 
@@ -701,23 +903,21 @@ bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
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
 
diff --git a/arch/x86/lib/thunk_32.S b/arch/x86/lib/thunk_32.S
index 2930ae0..28f85c91 100644
--- a/arch/x86/lib/thunk_32.S
+++ b/arch/x86/lib/thunk_32.S
@@ -4,8 +4,8 @@
  *  (inspired by Andi Kleen's thunk_64.S)
  * Subject to the GNU public license, v.2. No warranty of any kind.
  */
-
 	#include <linux/linkage.h>
+	#include <asm/asm.h>
 
 #ifdef CONFIG_TRACE_IRQFLAGS
 	/* put return address in eax (arg1) */
@@ -22,6 +22,7 @@
 	popl %ecx
 	popl %eax
 	ret
+	_ASM_NOKPROBE(\name)
 	.endm
 
 	thunk_ra trace_hardirqs_on_thunk,trace_hardirqs_on_caller
diff --git a/arch/x86/lib/thunk_64.S b/arch/x86/lib/thunk_64.S
index a63efd6..92d9fea 100644
--- a/arch/x86/lib/thunk_64.S
+++ b/arch/x86/lib/thunk_64.S
@@ -8,6 +8,7 @@
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
 #include <asm/calling.h>
+#include <asm/asm.h>
 
 	/* rdi:	arg1 ... normal C conventions. rax is saved/restored. */
 	.macro THUNK name, func, put_ret_addr_in_rdi=0
@@ -25,6 +26,7 @@
 	call \func
 	jmp  restore
 	CFI_ENDPROC
+	_ASM_NOKPROBE(\name)
 	.endm
 
 #ifdef CONFIG_TRACE_IRQFLAGS
@@ -43,3 +45,4 @@ restore:
 	RESTORE_ARGS
 	ret
 	CFI_ENDPROC
+	_ASM_NOKPROBE(restore)
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 8e57229..f83bd0d 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -8,7 +8,7 @@
 #include <linux/kdebug.h>		/* oops_begin/end, ...		*/
 #include <linux/module.h>		/* search_exception_table	*/
 #include <linux/bootmem.h>		/* max_low_pfn			*/
-#include <linux/kprobes.h>		/* __kprobes, ...		*/
+#include <linux/kprobes.h>		/* NOKPROBE_SYMBOL, ...		*/
 #include <linux/mmiotrace.h>		/* kmmio_handler, ...		*/
 #include <linux/perf_event.h>		/* perf_sw_event		*/
 #include <linux/hugetlb.h>		/* hstate_index_to_shift	*/
@@ -45,7 +45,7 @@ enum x86_pf_error_code {
  * Returns 0 if mmiotrace is disabled, or if the fault is not
  * handled by mmiotrace:
  */
-static inline int __kprobes
+static nokprobe_inline int
 kmmio_fault(struct pt_regs *regs, unsigned long addr)
 {
 	if (unlikely(is_kmmio_active()))
@@ -54,7 +54,7 @@ kmmio_fault(struct pt_regs *regs, unsigned long addr)
 	return 0;
 }
 
-static inline int __kprobes kprobes_fault(struct pt_regs *regs)
+static nokprobe_inline int kprobes_fault(struct pt_regs *regs)
 {
 	int ret = 0;
 
@@ -261,7 +261,7 @@ void vmalloc_sync_all(void)
  *
  *   Handle a fault on the vmalloc or module mapping area
  */
-static noinline __kprobes int vmalloc_fault(unsigned long address)
+static noinline int vmalloc_fault(unsigned long address)
 {
 	unsigned long pgd_paddr;
 	pmd_t *pmd_k;
@@ -291,6 +291,7 @@ static noinline __kprobes int vmalloc_fault(unsigned long address)
 
 	return 0;
 }
+NOKPROBE_SYMBOL(vmalloc_fault);
 
 /*
  * Did it hit the DOS screen memory VA from vm86 mode?
@@ -358,7 +359,7 @@ void vmalloc_sync_all(void)
  *
  * This assumes no large pages in there.
  */
-static noinline __kprobes int vmalloc_fault(unsigned long address)
+static noinline int vmalloc_fault(unsigned long address)
 {
 	pgd_t *pgd, *pgd_ref;
 	pud_t *pud, *pud_ref;
@@ -425,6 +426,7 @@ static noinline __kprobes int vmalloc_fault(unsigned long address)
 
 	return 0;
 }
+NOKPROBE_SYMBOL(vmalloc_fault);
 
 #ifdef CONFIG_CPU_SUP_AMD
 static const char errata93_warning[] =
@@ -927,7 +929,7 @@ static int spurious_fault_check(unsigned long error_code, pte_t *pte)
  * There are no security implications to leaving a stale TLB when
  * increasing the permissions on a page.
  */
-static noinline __kprobes int
+static noinline int
 spurious_fault(unsigned long error_code, unsigned long address)
 {
 	pgd_t *pgd;
@@ -975,6 +977,7 @@ spurious_fault(unsigned long error_code, unsigned long address)
 
 	return ret;
 }
+NOKPROBE_SYMBOL(spurious_fault);
 
 int show_unhandled_signals = 1;
 
@@ -1030,7 +1033,7 @@ static inline bool smap_violation(int error_code, struct pt_regs *regs)
  * {,trace_}do_page_fault() have notrace on. Having this an actual function
  * guarantees there's a function trace entry.
  */
-static void __kprobes noinline
+static noinline void
 __do_page_fault(struct pt_regs *regs, unsigned long error_code,
 		unsigned long address)
 {
@@ -1253,8 +1256,9 @@ good_area:
 
 	up_read(&mm->mmap_sem);
 }
+NOKPROBE_SYMBOL(__do_page_fault);
 
-dotraplinkage void __kprobes notrace
+dotraplinkage void notrace
 do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	unsigned long address = read_cr2(); /* Get the faulting address */
@@ -1272,10 +1276,12 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	__do_page_fault(regs, error_code, address);
 	exception_exit(prev_state);
 }
+NOKPROBE_SYMBOL(do_page_fault);
 
 #ifdef CONFIG_TRACING
-static void trace_page_fault_entries(unsigned long address, struct pt_regs *regs,
-				     unsigned long error_code)
+static nokprobe_inline void
+trace_page_fault_entries(unsigned long address, struct pt_regs *regs,
+			 unsigned long error_code)
 {
 	if (user_mode(regs))
 		trace_page_fault_user(address, regs, error_code);
@@ -1283,7 +1289,7 @@ static void trace_page_fault_entries(unsigned long address, struct pt_regs *regs
 		trace_page_fault_kernel(address, regs, error_code);
 }
 
-dotraplinkage void __kprobes notrace
+dotraplinkage void notrace
 trace_do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	/*
@@ -1300,4 +1306,5 @@ trace_do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	__do_page_fault(regs, error_code, address);
 	exception_exit(prev_state);
 }
+NOKPROBE_SYMBOL(trace_do_page_fault);
 #endif /* CONFIG_TRACING */
diff --git a/fs/exec.c b/fs/exec.c
index 238b7aa..a3d33fe 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1046,13 +1046,13 @@ EXPORT_SYMBOL_GPL(get_task_comm);
  * so that a new one can be started
  */
 
-void set_task_comm(struct task_struct *tsk, const char *buf)
+void __set_task_comm(struct task_struct *tsk, const char *buf, bool exec)
 {
 	task_lock(tsk);
 	trace_task_rename(tsk, buf);
 	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
 	task_unlock(tsk);
-	perf_event_comm(tsk);
+	perf_event_comm(tsk, exec);
 }
 
 int flush_old_exec(struct linux_binprm * bprm)
@@ -1110,7 +1110,8 @@ void setup_new_exec(struct linux_binprm * bprm)
 	else
 		set_dumpable(current->mm, suid_dumpable);
 
-	set_task_comm(current, kbasename(bprm->filename));
+	perf_event_exec();
+	__set_task_comm(current, kbasename(bprm->filename), true);
 
 	/* Set the new mm task size. We have to do that late because it may
 	 * depend on TIF_32BIT which is only updated in flush_thread() on
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 146e4ff..8e0204a 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -109,6 +109,15 @@
 #define BRANCH_PROFILE()
 #endif
 
+#ifdef CONFIG_KPROBES
+#define KPROBE_BLACKLIST()	. = ALIGN(8);				      \
+				VMLINUX_SYMBOL(__start_kprobe_blacklist) = .; \
+				*(_kprobe_blacklist)			      \
+				VMLINUX_SYMBOL(__stop_kprobe_blacklist) = .;
+#else
+#define KPROBE_BLACKLIST()
+#endif
+
 #ifdef CONFIG_EVENT_TRACING
 #define FTRACE_EVENTS()	. = ALIGN(8);					\
 			VMLINUX_SYMBOL(__start_ftrace_events) = .;	\
@@ -507,6 +516,7 @@
 	*(.init.rodata)							\
 	FTRACE_EVENTS()							\
 	TRACE_SYSCALLS()						\
+	KPROBE_BLACKLIST()						\
 	MEM_DISCARD(init.rodata)					\
 	CLK_OF_TABLES()							\
 	RESERVEDMEM_OF_TABLES()						\
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index ee7239e..0300c0f 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -374,7 +374,9 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 /* Ignore/forbid kprobes attach on very low level functions marked by this attribute: */
 #ifdef CONFIG_KPROBES
 # define __kprobes	__attribute__((__section__(".kprobes.text")))
+# define nokprobe_inline	__always_inline
 #else
 # define __kprobes
+# define nokprobe_inline	inline
 #endif
 #endif /* __LINUX_COMPILER_H */
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 925eaf2..e059507 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -205,10 +205,10 @@ struct kretprobe_blackpoint {
 	void *addr;
 };
 
-struct kprobe_blackpoint {
-	const char *name;
+struct kprobe_blacklist_entry {
+	struct list_head list;
 	unsigned long start_addr;
-	unsigned long range;
+	unsigned long end_addr;
 };
 
 #ifdef CONFIG_KPROBES
@@ -265,6 +265,7 @@ extern void arch_disarm_kprobe(struct kprobe *p);
 extern int arch_init_kprobes(void);
 extern void show_registers(struct pt_regs *regs);
 extern void kprobes_inc_nmissed_count(struct kprobe *p);
+extern bool arch_within_kprobe_blacklist(unsigned long addr);
 
 struct kprobe_insn_cache {
 	struct mutex mutex;
@@ -476,4 +477,18 @@ static inline int enable_jprobe(struct jprobe *jp)
 	return enable_kprobe(&jp->kp);
 }
 
+#ifdef CONFIG_KPROBES
+/*
+ * Blacklist ganerating macro. Specify functions which is not probed
+ * by using this macro.
+ */
+#define __NOKPROBE_SYMBOL(fname)			\
+static unsigned long __used				\
+	__attribute__((section("_kprobe_blacklist")))	\
+	_kbl_addr_##fname = (unsigned long)fname;
+#define NOKPROBE_SYMBOL(fname)	__NOKPROBE_SYMBOL(fname)
+#else
+#define NOKPROBE_SYMBOL(fname)
+#endif
+
 #endif /* _LINUX_KPROBES_H */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3ef6ea1..707617a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -167,16 +167,27 @@ struct perf_event;
 #define PERF_EVENT_TXN 0x1
 
 /**
+ * pmu::capabilities flags
+ */
+#define PERF_PMU_CAP_NO_INTERRUPT		0x01
+
+/**
  * struct pmu - generic performance monitoring unit
  */
 struct pmu {
 	struct list_head		entry;
 
+	struct module			*module;
 	struct device			*dev;
 	const struct attribute_group	**attr_groups;
 	const char			*name;
 	int				type;
 
+	/*
+	 * various common per-pmu feature flags
+	 */
+	int				capabilities;
+
 	int * __percpu			pmu_disable_count;
 	struct perf_cpu_context * __percpu pmu_cpu_context;
 	int				task_ctx_nr;
@@ -695,7 +706,8 @@ extern struct perf_guest_info_callbacks *perf_guest_cbs;
 extern int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
 extern int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
 
-extern void perf_event_comm(struct task_struct *tsk);
+extern void perf_event_exec(void);
+extern void perf_event_comm(struct task_struct *tsk, bool exec);
 extern void perf_event_fork(struct task_struct *tsk);
 
 /* Callchains */
@@ -772,7 +784,7 @@ extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern int __perf_event_disable(void *info);
 extern void perf_event_task_tick(void);
-#else
+#else /* !CONFIG_PERF_EVENTS: */
 static inline void
 perf_event_task_sched_in(struct task_struct *prev,
 			 struct task_struct *task)			{ }
@@ -802,7 +814,8 @@ static inline int perf_unregister_guest_info_callbacks
 (struct perf_guest_info_callbacks *callbacks)				{ return 0; }
 
 static inline void perf_event_mmap(struct vm_area_struct *vma)		{ }
-static inline void perf_event_comm(struct task_struct *tsk)		{ }
+static inline void perf_event_exec(void)				{ }
+static inline void perf_event_comm(struct task_struct *tsk, bool exec)	{ }
 static inline void perf_event_fork(struct task_struct *tsk)		{ }
 static inline void perf_event_init(void)				{ }
 static inline int  perf_swevent_get_recursion_context(void)		{ return -1; }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 221b2bd..ad86e1d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2379,7 +2379,11 @@ extern long do_fork(unsigned long, unsigned long, unsigned long, int __user *, i
 struct task_struct *fork_idle(int);
 extern pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
 
-extern void set_task_comm(struct task_struct *tsk, const char *from);
+extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec);
+static inline void set_task_comm(struct task_struct *tsk, const char *from)
+{
+	__set_task_comm(tsk, from, false);
+}
 extern char *get_task_comm(char *to, struct task_struct *tsk);
 
 #ifdef CONFIG_SMP
diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index edff2b9..88c3b7e 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -102,6 +102,7 @@ extern int __weak set_orig_insn(struct arch_uprobe *aup, struct mm_struct *mm, u
 extern bool __weak is_swbp_insn(uprobe_opcode_t *insn);
 extern bool __weak is_trap_insn(uprobe_opcode_t *insn);
 extern unsigned long __weak uprobe_get_swbp_addr(struct pt_regs *regs);
+extern unsigned long uprobe_get_trap_addr(struct pt_regs *regs);
 extern int uprobe_write_opcode(struct mm_struct *mm, unsigned long vaddr, uprobe_opcode_t);
 extern int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *uc);
 extern int uprobe_apply(struct inode *inode, loff_t offset, struct uprobe_consumer *uc, bool);
@@ -130,6 +131,9 @@ extern bool __weak arch_uprobe_ignore(struct arch_uprobe *aup, struct pt_regs *r
 #else /* !CONFIG_UPROBES */
 struct uprobes_state {
 };
+
+#define uprobe_get_trap_addr(regs)	instruction_pointer(regs)
+
 static inline int
 uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *uc)
 {
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 853bc1c..5312fae 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -163,8 +163,9 @@ enum perf_branch_sample_type {
 	PERF_SAMPLE_BRANCH_ABORT_TX	= 1U << 7, /* transaction aborts */
 	PERF_SAMPLE_BRANCH_IN_TX	= 1U << 8, /* in transaction */
 	PERF_SAMPLE_BRANCH_NO_TX	= 1U << 9, /* not in transaction */
+	PERF_SAMPLE_BRANCH_COND		= 1U << 10, /* conditional branches */
 
-	PERF_SAMPLE_BRANCH_MAX		= 1U << 10, /* non-ABI */
+	PERF_SAMPLE_BRANCH_MAX		= 1U << 11, /* non-ABI */
 };
 
 #define PERF_SAMPLE_BRANCH_PLM_ALL \
@@ -301,8 +302,8 @@ struct perf_event_attr {
 				exclude_callchain_kernel : 1, /* exclude kernel callchains */
 				exclude_callchain_user   : 1, /* exclude user callchains */
 				mmap2          :  1, /* include mmap with inode data     */
-
-				__reserved_1   : 40;
+				comm_exec      :  1, /* flag comm events that are due to an exec */
+				__reserved_1   : 39;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -501,7 +502,12 @@ struct perf_event_mmap_page {
 #define PERF_RECORD_MISC_GUEST_KERNEL		(4 << 0)
 #define PERF_RECORD_MISC_GUEST_USER		(5 << 0)
 
+/*
+ * PERF_RECORD_MISC_MMAP_DATA and PERF_RECORD_MISC_COMM_EXEC are used on
+ * different events so can reuse the same bit position.
+ */
 #define PERF_RECORD_MISC_MMAP_DATA		(1 << 13)
+#define PERF_RECORD_MISC_COMM_EXEC		(1 << 13)
 /*
  * Indicates that the content of PERF_SAMPLE_IP points to
  * the actual instruction that triggered the event. See also
@@ -722,10 +728,10 @@ enum perf_callchain_context {
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
index 440eefc..7da5e56 100644
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
 
@@ -2970,6 +2973,22 @@ out:
 	local_irq_restore(flags);
 }
 
+void perf_event_exec(void)
+{
+	struct perf_event_context *ctx;
+	int ctxn;
+
+	rcu_read_lock();
+	for_each_task_context_nr(ctxn) {
+		ctx = current->perf_event_ctxp[ctxn];
+		if (!ctx)
+			continue;
+
+		perf_event_enable_on_exec(ctx);
+	}
+	rcu_read_unlock();
+}
+
 /*
  * Cross CPU call to read the hardware event
  */
@@ -3244,9 +3263,13 @@ static void __free_event(struct perf_event *event)
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
 
@@ -3267,42 +3290,31 @@ static void free_event(struct perf_event *event)
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
@@ -3341,9 +3353,33 @@ static void put_event(struct perf_event *event)
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
@@ -5054,21 +5090,9 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
 		       NULL);
 }
 
-void perf_event_comm(struct task_struct *task)
+void perf_event_comm(struct task_struct *task, bool exec)
 {
 	struct perf_comm_event comm_event;
-	struct perf_event_context *ctx;
-	int ctxn;
-
-	rcu_read_lock();
-	for_each_task_context_nr(ctxn) {
-		ctx = task->perf_event_ctxp[ctxn];
-		if (!ctx)
-			continue;
-
-		perf_event_enable_on_exec(ctx);
-	}
-	rcu_read_unlock();
 
 	if (!atomic_read(&nr_comm_events))
 		return;
@@ -5080,7 +5104,7 @@ void perf_event_comm(struct task_struct *task)
 		.event_id  = {
 			.header = {
 				.type = PERF_RECORD_COMM,
-				.misc = 0,
+				.misc = exec ? PERF_RECORD_MISC_COMM_EXEC : 0,
 				/* .size */
 			},
 			/* .pid */
@@ -6578,6 +6602,7 @@ free_pdc:
 	free_percpu(pmu->pmu_disable_count);
 	goto unlock;
 }
+EXPORT_SYMBOL_GPL(perf_pmu_register);
 
 void perf_pmu_unregister(struct pmu *pmu)
 {
@@ -6599,6 +6624,7 @@ void perf_pmu_unregister(struct pmu *pmu)
 	put_device(pmu->dev);
 	free_pmu_context(pmu);
 }
+EXPORT_SYMBOL_GPL(perf_pmu_unregister);
 
 struct pmu *perf_init_event(struct perf_event *event)
 {
@@ -6612,6 +6638,10 @@ struct pmu *perf_init_event(struct perf_event *event)
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
@@ -6620,6 +6650,10 @@ struct pmu *perf_init_event(struct perf_event *event)
 	}
 
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
+		if (!try_module_get(pmu->module)) {
+			pmu = ERR_PTR(-ENODEV);
+			goto unlock;
+		}
 		event->pmu = pmu;
 		ret = pmu->event_init(event);
 		if (!ret)
@@ -6798,6 +6832,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 err_pmu:
 	if (event->destroy)
 		event->destroy(event);
+	module_put(pmu->module);
 err_ns:
 	if (event->ns)
 		put_pid_ns(event->ns);
@@ -7067,20 +7102,33 @@ SYSCALL_DEFINE5(perf_event_open,
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
+		}
+	}
+
+	if (is_sampling_event(event)) {
+		if (event->pmu->capabilities & PERF_PMU_CAP_NO_INTERRUPT) {
+			err = -ENOTSUPP;
+			goto err_alloc;
 		}
 	}
 
@@ -7242,8 +7290,9 @@ err_context:
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
@@ -7379,7 +7428,7 @@ __perf_event_exit_task(struct perf_event *child_event,
 			 struct perf_event_context *child_ctx,
 			 struct task_struct *child)
 {
-	perf_remove_from_context(child_event, !!child_event->parent);
+	perf_remove_from_context(child_event, true);
 
 	/*
 	 * It can happen that the parent exits first, and has events
@@ -7394,7 +7443,7 @@ __perf_event_exit_task(struct perf_event *child_event,
 
 static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 {
-	struct perf_event *child_event, *tmp;
+	struct perf_event *child_event, *next;
 	struct perf_event_context *child_ctx;
 	unsigned long flags;
 
@@ -7448,24 +7497,9 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 	 */
 	mutex_lock(&child_ctx->mutex);
 
-again:
-	list_for_each_entry_safe(child_event, tmp, &child_ctx->pinned_groups,
-				 group_entry)
+	list_for_each_entry_safe(child_event, next, &child_ctx->event_list, event_entry)
 		__perf_event_exit_task(child_event, child_ctx, child);
 
-	list_for_each_entry_safe(child_event, tmp, &child_ctx->flexible_groups,
-				 group_entry)
-		__perf_event_exit_task(child_event, child_ctx, child);
-
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
index 04709b6..6bfb671 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -36,6 +36,7 @@
 #include "../../mm/internal.h"	/* munlock_vma_page */
 #include <linux/percpu-rwsem.h>
 #include <linux/task_work.h>
+#include <linux/shmem_fs.h>
 
 #include <linux/uprobes.h>
 
@@ -60,8 +61,6 @@ static struct percpu_rw_semaphore dup_mmap_sem;
 
 /* Have a copy of original instruction */
 #define UPROBE_COPY_INSN	0
-/* Can skip singlestep */
-#define UPROBE_SKIP_SSTEP	1
 
 struct uprobe {
 	struct rb_node		rb_node;	/* node in the rb tree */
@@ -129,7 +128,7 @@ struct xol_area {
  */
 static bool valid_vma(struct vm_area_struct *vma, bool is_register)
 {
-	vm_flags_t flags = VM_HUGETLB | VM_MAYEXEC | VM_SHARED;
+	vm_flags_t flags = VM_HUGETLB | VM_MAYEXEC | VM_MAYSHARE;
 
 	if (is_register)
 		flags |= VM_WRITE;
@@ -281,18 +280,13 @@ static int verify_opcode(struct page *page, unsigned long vaddr, uprobe_opcode_t
  * supported by that architecture then we need to modify is_trap_at_addr and
  * uprobe_write_opcode accordingly. This would never be a problem for archs
  * that have fixed length instructions.
- */
-
-/*
+ *
  * uprobe_write_opcode - write the opcode at a given virtual address.
  * @mm: the probed process address space.
  * @vaddr: the virtual address to store the opcode.
  * @opcode: opcode to be written at @vaddr.
  *
- * Called with mm->mmap_sem held (for read and with a reference to
- * mm).
- *
- * For mm @mm, write the opcode at @vaddr.
+ * Called with mm->mmap_sem held for write.
  * Return 0 (success) or a negative errno.
  */
 int uprobe_write_opcode(struct mm_struct *mm, unsigned long vaddr,
@@ -312,21 +306,25 @@ retry:
 	if (ret <= 0)
 		goto put_old;
 
+	ret = anon_vma_prepare(vma);
+	if (ret)
+		goto put_old;
+
 	ret = -ENOMEM;
 	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vaddr);
 	if (!new_page)
 		goto put_old;
 
-	__SetPageUptodate(new_page);
+	if (mem_cgroup_charge_anon(new_page, mm, GFP_KERNEL))
+		goto put_new;
 
+	__SetPageUptodate(new_page);
 	copy_highpage(new_page, old_page);
 	copy_to_page(new_page, vaddr, &opcode, UPROBE_SWBP_INSN_SIZE);
 
-	ret = anon_vma_prepare(vma);
-	if (ret)
-		goto put_new;
-
 	ret = __replace_page(vma, vaddr, old_page, new_page);
+	if (ret)
+		mem_cgroup_uncharge_page(new_page);
 
 put_new:
 	page_cache_release(new_page);
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
@@ -542,14 +537,15 @@ static int __copy_insn(struct address_space *mapping, struct file *filp,
 			void *insn, int nbytes, loff_t offset)
 {
 	struct page *page;
-
-	if (!mapping->a_ops->readpage)
-		return -EIO;
 	/*
-	 * Ensure that the page that has the original instruction is
-	 * populated and in page-cache.
+	 * Ensure that the page that has the original instruction is populated
+	 * and in page-cache. If ->readpage == NULL it must be shmem_mapping(),
+	 * see uprobe_register().
 	 */
-	page = read_mapping_page(mapping, offset >> PAGE_CACHE_SHIFT, filp);
+	if (mapping->a_ops->readpage)
+		page = read_mapping_page(mapping, offset >> PAGE_CACHE_SHIFT, filp);
+	else
+		page = shmem_read_mapping_page(mapping, offset >> PAGE_CACHE_SHIFT);
 	if (IS_ERR(page))
 		return PTR_ERR(page);
 
@@ -885,6 +881,9 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
 	if (!uc->handler && !uc->ret_handler)
 		return -EINVAL;
 
+	/* copy_insn() uses read_mapping_page() or shmem_read_mapping_page() */
+	if (!inode->i_mapping->a_ops->readpage && !shmem_mapping(inode->i_mapping))
+		return -EIO;
 	/* Racy, just to catch the obvious mistakes */
 	if (offset > i_size_read(inode))
 		return -EINVAL;
@@ -1357,6 +1356,16 @@ unsigned long __weak uprobe_get_swbp_addr(struct pt_regs *regs)
 	return instruction_pointer(regs) - UPROBE_SWBP_INSN_SIZE;
 }
 
+unsigned long uprobe_get_trap_addr(struct pt_regs *regs)
+{
+	struct uprobe_task *utask = current->utask;
+
+	if (unlikely(utask && utask->active_uprobe))
+		return utask->vaddr;
+
+	return instruction_pointer(regs);
+}
+
 /*
  * Called with no locks held.
  * Called in context of a exiting or a exec-ing thread.
@@ -1628,20 +1637,6 @@ bool uprobe_deny_signal(void)
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
@@ -1868,13 +1863,13 @@ static void handle_swbp(struct pt_regs *regs)
 
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
@@ -1886,10 +1881,11 @@ out:
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
@@ -1903,6 +1899,11 @@ static void handle_singlestep(struct uprobe_task *utask, struct pt_regs *regs)
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
index e0501fe..3ab2899 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1039,6 +1039,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(__hrtimer_start_range_ns);
 
 /**
  * hrtimer_start_range_ns - (re)start an hrtimer on the current CPU
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index ceeadfc..3214289 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -86,21 +86,8 @@ static raw_spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
 	return &(kretprobe_table_locks[hash].lock);
 }
 
-/*
- * Normally, functions that we'd want to prohibit kprobes in, are marked
- * __kprobes. But, there are cases where such functions already belong to
- * a different section (__sched for preempt_schedule)
- *
- * For such cases, we now have a blacklist
- */
-static struct kprobe_blackpoint kprobe_blacklist[] = {
-	{"preempt_schedule",},
-	{"native_get_debugreg",},
-	{"irq_entries_start",},
-	{"common_interrupt",},
-	{"mcount",},	/* mcount can be called from everywhere */
-	{NULL}    /* Terminator */
-};
+/* Blacklist -- list of struct kprobe_blacklist_entry */
+static LIST_HEAD(kprobe_blacklist);
 
 #ifdef __ARCH_WANT_KPROBES_INSN_SLOT
 /*
@@ -151,13 +138,13 @@ struct kprobe_insn_cache kprobe_insn_slots = {
 	.insn_size = MAX_INSN_SIZE,
 	.nr_garbage = 0,
 };
-static int __kprobes collect_garbage_slots(struct kprobe_insn_cache *c);
+static int collect_garbage_slots(struct kprobe_insn_cache *c);
 
 /**
  * __get_insn_slot() - Find a slot on an executable page for an instruction.
  * We allocate an executable page if there's no room on existing ones.
  */
-kprobe_opcode_t __kprobes *__get_insn_slot(struct kprobe_insn_cache *c)
+kprobe_opcode_t *__get_insn_slot(struct kprobe_insn_cache *c)
 {
 	struct kprobe_insn_page *kip;
 	kprobe_opcode_t *slot = NULL;
@@ -214,7 +201,7 @@ out:
 }
 
 /* Return 1 if all garbages are collected, otherwise 0. */
-static int __kprobes collect_one_slot(struct kprobe_insn_page *kip, int idx)
+static int collect_one_slot(struct kprobe_insn_page *kip, int idx)
 {
 	kip->slot_used[idx] = SLOT_CLEAN;
 	kip->nused--;
@@ -235,7 +222,7 @@ static int __kprobes collect_one_slot(struct kprobe_insn_page *kip, int idx)
 	return 0;
 }
 
-static int __kprobes collect_garbage_slots(struct kprobe_insn_cache *c)
+static int collect_garbage_slots(struct kprobe_insn_cache *c)
 {
 	struct kprobe_insn_page *kip, *next;
 
@@ -257,8 +244,8 @@ static int __kprobes collect_garbage_slots(struct kprobe_insn_cache *c)
 	return 0;
 }
 
-void __kprobes __free_insn_slot(struct kprobe_insn_cache *c,
-				kprobe_opcode_t *slot, int dirty)
+void __free_insn_slot(struct kprobe_insn_cache *c,
+		      kprobe_opcode_t *slot, int dirty)
 {
 	struct kprobe_insn_page *kip;
 
@@ -314,7 +301,7 @@ static inline void reset_kprobe_instance(void)
  * 				OR
  * 	- with preemption disabled - from arch/xxx/kernel/kprobes.c
  */
-struct kprobe __kprobes *get_kprobe(void *addr)
+struct kprobe *get_kprobe(void *addr)
 {
 	struct hlist_head *head;
 	struct kprobe *p;
@@ -327,8 +314,9 @@ struct kprobe __kprobes *get_kprobe(void *addr)
 
 	return NULL;
 }
+NOKPROBE_SYMBOL(get_kprobe);
 
-static int __kprobes aggr_pre_handler(struct kprobe *p, struct pt_regs *regs);
+static int aggr_pre_handler(struct kprobe *p, struct pt_regs *regs);
 
 /* Return true if the kprobe is an aggregator */
 static inline int kprobe_aggrprobe(struct kprobe *p)
@@ -360,7 +348,7 @@ static bool kprobes_allow_optimization;
  * Call all pre_handler on the list, but ignores its return value.
  * This must be called from arch-dep optimized caller.
  */
-void __kprobes opt_pre_handler(struct kprobe *p, struct pt_regs *regs)
+void opt_pre_handler(struct kprobe *p, struct pt_regs *regs)
 {
 	struct kprobe *kp;
 
@@ -372,9 +360,10 @@ void __kprobes opt_pre_handler(struct kprobe *p, struct pt_regs *regs)
 		reset_kprobe_instance();
 	}
 }
+NOKPROBE_SYMBOL(opt_pre_handler);
 
 /* Free optimized instructions and optimized_kprobe */
-static __kprobes void free_aggr_kprobe(struct kprobe *p)
+static void free_aggr_kprobe(struct kprobe *p)
 {
 	struct optimized_kprobe *op;
 
@@ -412,7 +401,7 @@ static inline int kprobe_disarmed(struct kprobe *p)
 }
 
 /* Return true(!0) if the probe is queued on (un)optimizing lists */
-static int __kprobes kprobe_queued(struct kprobe *p)
+static int kprobe_queued(struct kprobe *p)
 {
 	struct optimized_kprobe *op;
 
@@ -428,7 +417,7 @@ static int __kprobes kprobe_queued(struct kprobe *p)
  * Return an optimized kprobe whose optimizing code replaces
  * instructions including addr (exclude breakpoint).
  */
-static struct kprobe *__kprobes get_optimized_kprobe(unsigned long addr)
+static struct kprobe *get_optimized_kprobe(unsigned long addr)
 {
 	int i;
 	struct kprobe *p = NULL;
@@ -460,7 +449,7 @@ static DECLARE_DELAYED_WORK(optimizing_work, kprobe_optimizer);
  * Optimize (replace a breakpoint with a jump) kprobes listed on
  * optimizing_list.
  */
-static __kprobes void do_optimize_kprobes(void)
+static void do_optimize_kprobes(void)
 {
 	/* Optimization never be done when disarmed */
 	if (kprobes_all_disarmed || !kprobes_allow_optimization ||
@@ -488,7 +477,7 @@ static __kprobes void do_optimize_kprobes(void)
  * Unoptimize (replace a jump with a breakpoint and remove the breakpoint
  * if need) kprobes listed on unoptimizing_list.
  */
-static __kprobes void do_unoptimize_kprobes(void)
+static void do_unoptimize_kprobes(void)
 {
 	struct optimized_kprobe *op, *tmp;
 
@@ -520,7 +509,7 @@ static __kprobes void do_unoptimize_kprobes(void)
 }
 
 /* Reclaim all kprobes on the free_list */
-static __kprobes void do_free_cleaned_kprobes(void)
+static void do_free_cleaned_kprobes(void)
 {
 	struct optimized_kprobe *op, *tmp;
 
@@ -532,13 +521,13 @@ static __kprobes void do_free_cleaned_kprobes(void)
 }
 
 /* Start optimizer after OPTIMIZE_DELAY passed */
-static __kprobes void kick_kprobe_optimizer(void)
+static void kick_kprobe_optimizer(void)
 {
 	schedule_delayed_work(&optimizing_work, OPTIMIZE_DELAY);
 }
 
 /* Kprobe jump optimizer */
-static __kprobes void kprobe_optimizer(struct work_struct *work)
+static void kprobe_optimizer(struct work_struct *work)
 {
 	mutex_lock(&kprobe_mutex);
 	/* Lock modules while optimizing kprobes */
@@ -574,7 +563,7 @@ static __kprobes void kprobe_optimizer(struct work_struct *work)
 }
 
 /* Wait for completing optimization and unoptimization */
-static __kprobes void wait_for_kprobe_optimizer(void)
+static void wait_for_kprobe_optimizer(void)
 {
 	mutex_lock(&kprobe_mutex);
 
@@ -593,7 +582,7 @@ static __kprobes void wait_for_kprobe_optimizer(void)
 }
 
 /* Optimize kprobe if p is ready to be optimized */
-static __kprobes void optimize_kprobe(struct kprobe *p)
+static void optimize_kprobe(struct kprobe *p)
 {
 	struct optimized_kprobe *op;
 
@@ -627,7 +616,7 @@ static __kprobes void optimize_kprobe(struct kprobe *p)
 }
 
 /* Short cut to direct unoptimizing */
-static __kprobes void force_unoptimize_kprobe(struct optimized_kprobe *op)
+static void force_unoptimize_kprobe(struct optimized_kprobe *op)
 {
 	get_online_cpus();
 	arch_unoptimize_kprobe(op);
@@ -637,7 +626,7 @@ static __kprobes void force_unoptimize_kprobe(struct optimized_kprobe *op)
 }
 
 /* Unoptimize a kprobe if p is optimized */
-static __kprobes void unoptimize_kprobe(struct kprobe *p, bool force)
+static void unoptimize_kprobe(struct kprobe *p, bool force)
 {
 	struct optimized_kprobe *op;
 
@@ -697,7 +686,7 @@ static void reuse_unused_kprobe(struct kprobe *ap)
 }
 
 /* Remove optimized instructions */
-static void __kprobes kill_optimized_kprobe(struct kprobe *p)
+static void kill_optimized_kprobe(struct kprobe *p)
 {
 	struct optimized_kprobe *op;
 
@@ -723,7 +712,7 @@ static void __kprobes kill_optimized_kprobe(struct kprobe *p)
 }
 
 /* Try to prepare optimized instructions */
-static __kprobes void prepare_optimized_kprobe(struct kprobe *p)
+static void prepare_optimized_kprobe(struct kprobe *p)
 {
 	struct optimized_kprobe *op;
 
@@ -732,7 +721,7 @@ static __kprobes void prepare_optimized_kprobe(struct kprobe *p)
 }
 
 /* Allocate new optimized_kprobe and try to prepare optimized instructions */
-static __kprobes struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
+static struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
 {
 	struct optimized_kprobe *op;
 
@@ -747,13 +736,13 @@ static __kprobes struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
 	return &op->kp;
 }
 
-static void __kprobes init_aggr_kprobe(struct kprobe *ap, struct kprobe *p);
+static void init_aggr_kprobe(struct kprobe *ap, struct kprobe *p);
 
 /*
  * Prepare an optimized_kprobe and optimize it
  * NOTE: p must be a normal registered kprobe
  */
-static __kprobes void try_to_optimize_kprobe(struct kprobe *p)
+static void try_to_optimize_kprobe(struct kprobe *p)
 {
 	struct kprobe *ap;
 	struct optimized_kprobe *op;
@@ -787,7 +776,7 @@ out:
 }
 
 #ifdef CONFIG_SYSCTL
-static void __kprobes optimize_all_kprobes(void)
+static void optimize_all_kprobes(void)
 {
 	struct hlist_head *head;
 	struct kprobe *p;
@@ -810,7 +799,7 @@ out:
 	mutex_unlock(&kprobe_mutex);
 }
 
-static void __kprobes unoptimize_all_kprobes(void)
+static void unoptimize_all_kprobes(void)
 {
 	struct hlist_head *head;
 	struct kprobe *p;
@@ -861,7 +850,7 @@ int proc_kprobes_optimization_handler(struct ctl_table *table, int write,
 #endif /* CONFIG_SYSCTL */
 
 /* Put a breakpoint for a probe. Must be called with text_mutex locked */
-static void __kprobes __arm_kprobe(struct kprobe *p)
+static void __arm_kprobe(struct kprobe *p)
 {
 	struct kprobe *_p;
 
@@ -876,7 +865,7 @@ static void __kprobes __arm_kprobe(struct kprobe *p)
 }
 
 /* Remove the breakpoint of a probe. Must be called with text_mutex locked */
-static void __kprobes __disarm_kprobe(struct kprobe *p, bool reopt)
+static void __disarm_kprobe(struct kprobe *p, bool reopt)
 {
 	struct kprobe *_p;
 
@@ -911,13 +900,13 @@ static void reuse_unused_kprobe(struct kprobe *ap)
 	BUG_ON(kprobe_unused(ap));
 }
 
-static __kprobes void free_aggr_kprobe(struct kprobe *p)
+static void free_aggr_kprobe(struct kprobe *p)
 {
 	arch_remove_kprobe(p);
 	kfree(p);
 }
 
-static __kprobes struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
+static struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
 {
 	return kzalloc(sizeof(struct kprobe), GFP_KERNEL);
 }
@@ -931,7 +920,7 @@ static struct ftrace_ops kprobe_ftrace_ops __read_mostly = {
 static int kprobe_ftrace_enabled;
 
 /* Must ensure p->addr is really on ftrace */
-static int __kprobes prepare_kprobe(struct kprobe *p)
+static int prepare_kprobe(struct kprobe *p)
 {
 	if (!kprobe_ftrace(p))
 		return arch_prepare_kprobe(p);
@@ -940,7 +929,7 @@ static int __kprobes prepare_kprobe(struct kprobe *p)
 }
 
 /* Caller must lock kprobe_mutex */
-static void __kprobes arm_kprobe_ftrace(struct kprobe *p)
+static void arm_kprobe_ftrace(struct kprobe *p)
 {
 	int ret;
 
@@ -955,7 +944,7 @@ static void __kprobes arm_kprobe_ftrace(struct kprobe *p)
 }
 
 /* Caller must lock kprobe_mutex */
-static void __kprobes disarm_kprobe_ftrace(struct kprobe *p)
+static void disarm_kprobe_ftrace(struct kprobe *p)
 {
 	int ret;
 
@@ -975,7 +964,7 @@ static void __kprobes disarm_kprobe_ftrace(struct kprobe *p)
 #endif
 
 /* Arm a kprobe with text_mutex */
-static void __kprobes arm_kprobe(struct kprobe *kp)
+static void arm_kprobe(struct kprobe *kp)
 {
 	if (unlikely(kprobe_ftrace(kp))) {
 		arm_kprobe_ftrace(kp);
@@ -992,7 +981,7 @@ static void __kprobes arm_kprobe(struct kprobe *kp)
 }
 
 /* Disarm a kprobe with text_mutex */
-static void __kprobes disarm_kprobe(struct kprobe *kp, bool reopt)
+static void disarm_kprobe(struct kprobe *kp, bool reopt)
 {
 	if (unlikely(kprobe_ftrace(kp))) {
 		disarm_kprobe_ftrace(kp);
@@ -1008,7 +997,7 @@ static void __kprobes disarm_kprobe(struct kprobe *kp, bool reopt)
  * Aggregate handlers for multiple kprobes support - these handlers
  * take care of invoking the individual kprobe handlers on p->list
  */
-static int __kprobes aggr_pre_handler(struct kprobe *p, struct pt_regs *regs)
+static int aggr_pre_handler(struct kprobe *p, struct pt_regs *regs)
 {
 	struct kprobe *kp;
 
@@ -1022,9 +1011,10 @@ static int __kprobes aggr_pre_handler(struct kprobe *p, struct pt_regs *regs)
 	}
 	return 0;
 }
+NOKPROBE_SYMBOL(aggr_pre_handler);
 
-static void __kprobes aggr_post_handler(struct kprobe *p, struct pt_regs *regs,
-					unsigned long flags)
+static void aggr_post_handler(struct kprobe *p, struct pt_regs *regs,
+			      unsigned long flags)
 {
 	struct kprobe *kp;
 
@@ -1036,9 +1026,10 @@ static void __kprobes aggr_post_handler(struct kprobe *p, struct pt_regs *regs,
 		}
 	}
 }
+NOKPROBE_SYMBOL(aggr_post_handler);
 
-static int __kprobes aggr_fault_handler(struct kprobe *p, struct pt_regs *regs,
-					int trapnr)
+static int aggr_fault_handler(struct kprobe *p, struct pt_regs *regs,
+			      int trapnr)
 {
 	struct kprobe *cur = __this_cpu_read(kprobe_instance);
 
@@ -1052,8 +1043,9 @@ static int __kprobes aggr_fault_handler(struct kprobe *p, struct pt_regs *regs,
 	}
 	return 0;
 }
+NOKPROBE_SYMBOL(aggr_fault_handler);
 
-static int __kprobes aggr_break_handler(struct kprobe *p, struct pt_regs *regs)
+static int aggr_break_handler(struct kprobe *p, struct pt_regs *regs)
 {
 	struct kprobe *cur = __this_cpu_read(kprobe_instance);
 	int ret = 0;
@@ -1065,9 +1057,10 @@ static int __kprobes aggr_break_handler(struct kprobe *p, struct pt_regs *regs)
 	reset_kprobe_instance();
 	return ret;
 }
+NOKPROBE_SYMBOL(aggr_break_handler);
 
 /* Walks the list and increments nmissed count for multiprobe case */
-void __kprobes kprobes_inc_nmissed_count(struct kprobe *p)
+void kprobes_inc_nmissed_count(struct kprobe *p)
 {
 	struct kprobe *kp;
 	if (!kprobe_aggrprobe(p)) {
@@ -1078,9 +1071,10 @@ void __kprobes kprobes_inc_nmissed_count(struct kprobe *p)
 	}
 	return;
 }
+NOKPROBE_SYMBOL(kprobes_inc_nmissed_count);
 
-void __kprobes recycle_rp_inst(struct kretprobe_instance *ri,
-				struct hlist_head *head)
+void recycle_rp_inst(struct kretprobe_instance *ri,
+		     struct hlist_head *head)
 {
 	struct kretprobe *rp = ri->rp;
 
@@ -1095,8 +1089,9 @@ void __kprobes recycle_rp_inst(struct kretprobe_instance *ri,
 		/* Unregistering */
 		hlist_add_head(&ri->hlist, head);
 }
+NOKPROBE_SYMBOL(recycle_rp_inst);
 
-void __kprobes kretprobe_hash_lock(struct task_struct *tsk,
+void kretprobe_hash_lock(struct task_struct *tsk,
 			 struct hlist_head **head, unsigned long *flags)
 __acquires(hlist_lock)
 {
@@ -1107,17 +1102,19 @@ __acquires(hlist_lock)
 	hlist_lock = kretprobe_table_lock_ptr(hash);
 	raw_spin_lock_irqsave(hlist_lock, *flags);
 }
+NOKPROBE_SYMBOL(kretprobe_hash_lock);
 
-static void __kprobes kretprobe_table_lock(unsigned long hash,
-	unsigned long *flags)
+static void kretprobe_table_lock(unsigned long hash,
+				 unsigned long *flags)
 __acquires(hlist_lock)
 {
 	raw_spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
 	raw_spin_lock_irqsave(hlist_lock, *flags);
 }
+NOKPROBE_SYMBOL(kretprobe_table_lock);
 
-void __kprobes kretprobe_hash_unlock(struct task_struct *tsk,
-	unsigned long *flags)
+void kretprobe_hash_unlock(struct task_struct *tsk,
+			   unsigned long *flags)
 __releases(hlist_lock)
 {
 	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
@@ -1126,14 +1123,16 @@ __releases(hlist_lock)
 	hlist_lock = kretprobe_table_lock_ptr(hash);
 	raw_spin_unlock_irqrestore(hlist_lock, *flags);
 }
+NOKPROBE_SYMBOL(kretprobe_hash_unlock);
 
-static void __kprobes kretprobe_table_unlock(unsigned long hash,
-       unsigned long *flags)
+static void kretprobe_table_unlock(unsigned long hash,
+				   unsigned long *flags)
 __releases(hlist_lock)
 {
 	raw_spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
 	raw_spin_unlock_irqrestore(hlist_lock, *flags);
 }
+NOKPROBE_SYMBOL(kretprobe_table_unlock);
 
 /*
  * This function is called from finish_task_switch when task tk becomes dead,
@@ -1141,7 +1140,7 @@ __releases(hlist_lock)
  * with this task. These left over instances represent probed functions
  * that have been called but will never return.
  */
-void __kprobes kprobe_flush_task(struct task_struct *tk)
+void kprobe_flush_task(struct task_struct *tk)
 {
 	struct kretprobe_instance *ri;
 	struct hlist_head *head, empty_rp;
@@ -1166,6 +1165,7 @@ void __kprobes kprobe_flush_task(struct task_struct *tk)
 		kfree(ri);
 	}
 }
+NOKPROBE_SYMBOL(kprobe_flush_task);
 
 static inline void free_rp_inst(struct kretprobe *rp)
 {
@@ -1178,7 +1178,7 @@ static inline void free_rp_inst(struct kretprobe *rp)
 	}
 }
 
-static void __kprobes cleanup_rp_inst(struct kretprobe *rp)
+static void cleanup_rp_inst(struct kretprobe *rp)
 {
 	unsigned long flags, hash;
 	struct kretprobe_instance *ri;
@@ -1197,12 +1197,13 @@ static void __kprobes cleanup_rp_inst(struct kretprobe *rp)
 	}
 	free_rp_inst(rp);
 }
+NOKPROBE_SYMBOL(cleanup_rp_inst);
 
 /*
 * Add the new probe to ap->list. Fail if this is the
 * second jprobe at the address - two jprobes can't coexist
 */
-static int __kprobes add_new_kprobe(struct kprobe *ap, struct kprobe *p)
+static int add_new_kprobe(struct kprobe *ap, struct kprobe *p)
 {
 	BUG_ON(kprobe_gone(ap) || kprobe_gone(p));
 
@@ -1226,7 +1227,7 @@ static int __kprobes add_new_kprobe(struct kprobe *ap, struct kprobe *p)
  * Fill in the required fields of the "manager kprobe". Replace the
  * earlier kprobe in the hlist with the manager kprobe
  */
-static void __kprobes init_aggr_kprobe(struct kprobe *ap, struct kprobe *p)
+static void init_aggr_kprobe(struct kprobe *ap, struct kprobe *p)
 {
 	/* Copy p's insn slot to ap */
 	copy_kprobe(p, ap);
@@ -1252,8 +1253,7 @@ static void __kprobes init_aggr_kprobe(struct kprobe *ap, struct kprobe *p)
  * This is the second or subsequent kprobe at the address - handle
  * the intricacies
  */
-static int __kprobes register_aggr_kprobe(struct kprobe *orig_p,
-					  struct kprobe *p)
+static int register_aggr_kprobe(struct kprobe *orig_p, struct kprobe *p)
 {
 	int ret = 0;
 	struct kprobe *ap = orig_p;
@@ -1324,25 +1324,29 @@ out:
 	return ret;
 }
 
-static int __kprobes in_kprobes_functions(unsigned long addr)
+bool __weak arch_within_kprobe_blacklist(unsigned long addr)
 {
-	struct kprobe_blackpoint *kb;
+	/* The __kprobes marked functions and entry code must not be probed */
+	return addr >= (unsigned long)__kprobes_text_start &&
+	       addr < (unsigned long)__kprobes_text_end;
+}
 
-	if (addr >= (unsigned long)__kprobes_text_start &&
-	    addr < (unsigned long)__kprobes_text_end)
-		return -EINVAL;
+static bool within_kprobe_blacklist(unsigned long addr)
+{
+	struct kprobe_blacklist_entry *ent;
+
+	if (arch_within_kprobe_blacklist(addr))
+		return true;
 	/*
 	 * If there exists a kprobe_blacklist, verify and
 	 * fail any probe registration in the prohibited area
 	 */
-	for (kb = kprobe_blacklist; kb->name != NULL; kb++) {
-		if (kb->start_addr) {
-			if (addr >= kb->start_addr &&
-			    addr < (kb->start_addr + kb->range))
-				return -EINVAL;
-		}
+	list_for_each_entry(ent, &kprobe_blacklist, list) {
+		if (addr >= ent->start_addr && addr < ent->end_addr)
+			return true;
 	}
-	return 0;
+
+	return false;
 }
 
 /*
@@ -1351,7 +1355,7 @@ static int __kprobes in_kprobes_functions(unsigned long addr)
  * This returns encoded errors if it fails to look up symbol or invalid
  * combination of parameters.
  */
-static kprobe_opcode_t __kprobes *kprobe_addr(struct kprobe *p)
+static kprobe_opcode_t *kprobe_addr(struct kprobe *p)
 {
 	kprobe_opcode_t *addr = p->addr;
 
@@ -1374,7 +1378,7 @@ invalid:
 }
 
 /* Check passed kprobe is valid and return kprobe in kprobe_table. */
-static struct kprobe * __kprobes __get_valid_kprobe(struct kprobe *p)
+static struct kprobe *__get_valid_kprobe(struct kprobe *p)
 {
 	struct kprobe *ap, *list_p;
 
@@ -1406,8 +1410,8 @@ static inline int check_kprobe_rereg(struct kprobe *p)
 	return ret;
 }
 
-static __kprobes int check_kprobe_address_safe(struct kprobe *p,
-					       struct module **probed_mod)
+static int check_kprobe_address_safe(struct kprobe *p,
+				     struct module **probed_mod)
 {
 	int ret = 0;
 	unsigned long ftrace_addr;
@@ -1433,7 +1437,7 @@ static __kprobes int check_kprobe_address_safe(struct kprobe *p,
 
 	/* Ensure it is not in reserved area nor out of text */
 	if (!kernel_text_address((unsigned long) p->addr) ||
-	    in_kprobes_functions((unsigned long) p->addr) ||
+	    within_kprobe_blacklist((unsigned long) p->addr) ||
 	    jump_label_text_reserved(p->addr, p->addr)) {
 		ret = -EINVAL;
 		goto out;
@@ -1469,7 +1473,7 @@ out:
 	return ret;
 }
 
-int __kprobes register_kprobe(struct kprobe *p)
+int register_kprobe(struct kprobe *p)
 {
 	int ret;
 	struct kprobe *old_p;
@@ -1531,7 +1535,7 @@ out:
 EXPORT_SYMBOL_GPL(register_kprobe);
 
 /* Check if all probes on the aggrprobe are disabled */
-static int __kprobes aggr_kprobe_disabled(struct kprobe *ap)
+static int aggr_kprobe_disabled(struct kprobe *ap)
 {
 	struct kprobe *kp;
 
@@ -1547,7 +1551,7 @@ static int __kprobes aggr_kprobe_disabled(struct kprobe *ap)
 }
 
 /* Disable one kprobe: Make sure called under kprobe_mutex is locked */
-static struct kprobe *__kprobes __disable_kprobe(struct kprobe *p)
+static struct kprobe *__disable_kprobe(struct kprobe *p)
 {
 	struct kprobe *orig_p;
 
@@ -1574,7 +1578,7 @@ static struct kprobe *__kprobes __disable_kprobe(struct kprobe *p)
 /*
  * Unregister a kprobe without a scheduler synchronization.
  */
-static int __kprobes __unregister_kprobe_top(struct kprobe *p)
+static int __unregister_kprobe_top(struct kprobe *p)
 {
 	struct kprobe *ap, *list_p;
 
@@ -1631,7 +1635,7 @@ disarmed:
 	return 0;
 }
 
-static void __kprobes __unregister_kprobe_bottom(struct kprobe *p)
+static void __unregister_kprobe_bottom(struct kprobe *p)
 {
 	struct kprobe *ap;
 
@@ -1647,7 +1651,7 @@ static void __kprobes __unregister_kprobe_bottom(struct kprobe *p)
 	/* Otherwise, do nothing. */
 }
 
-int __kprobes register_kprobes(struct kprobe **kps, int num)
+int register_kprobes(struct kprobe **kps, int num)
 {
 	int i, ret = 0;
 
@@ -1665,13 +1669,13 @@ int __kprobes register_kprobes(struct kprobe **kps, int num)
 }
 EXPORT_SYMBOL_GPL(register_kprobes);
 
-void __kprobes unregister_kprobe(struct kprobe *p)
+void unregister_kprobe(struct kprobe *p)
 {
 	unregister_kprobes(&p, 1);
 }
 EXPORT_SYMBOL_GPL(unregister_kprobe);
 
-void __kprobes unregister_kprobes(struct kprobe **kps, int num)
+void unregister_kprobes(struct kprobe **kps, int num)
 {
 	int i;
 
@@ -1700,7 +1704,7 @@ unsigned long __weak arch_deref_entry_point(void *entry)
 	return (unsigned long)entry;
 }
 
-int __kprobes register_jprobes(struct jprobe **jps, int num)
+int register_jprobes(struct jprobe **jps, int num)
 {
 	struct jprobe *jp;
 	int ret = 0, i;
@@ -1731,19 +1735,19 @@ int __kprobes register_jprobes(struct jprobe **jps, int num)
 }
 EXPORT_SYMBOL_GPL(register_jprobes);
 
-int __kprobes register_jprobe(struct jprobe *jp)
+int register_jprobe(struct jprobe *jp)
 {
 	return register_jprobes(&jp, 1);
 }
 EXPORT_SYMBOL_GPL(register_jprobe);
 
-void __kprobes unregister_jprobe(struct jprobe *jp)
+void unregister_jprobe(struct jprobe *jp)
 {
 	unregister_jprobes(&jp, 1);
 }
 EXPORT_SYMBOL_GPL(unregister_jprobe);
 
-void __kprobes unregister_jprobes(struct jprobe **jps, int num)
+void unregister_jprobes(struct jprobe **jps, int num)
 {
 	int i;
 
@@ -1768,8 +1772,7 @@ EXPORT_SYMBOL_GPL(unregister_jprobes);
  * This kprobe pre_handler is registered with every kretprobe. When probe
  * hits it will set up the return probe.
  */
-static int __kprobes pre_handler_kretprobe(struct kprobe *p,
-					   struct pt_regs *regs)
+static int pre_handler_kretprobe(struct kprobe *p, struct pt_regs *regs)
 {
 	struct kretprobe *rp = container_of(p, struct kretprobe, kp);
 	unsigned long hash, flags = 0;
@@ -1807,8 +1810,9 @@ static int __kprobes pre_handler_kretprobe(struct kprobe *p,
 	}
 	return 0;
 }
+NOKPROBE_SYMBOL(pre_handler_kretprobe);
 
-int __kprobes register_kretprobe(struct kretprobe *rp)
+int register_kretprobe(struct kretprobe *rp)
 {
 	int ret = 0;
 	struct kretprobe_instance *inst;
@@ -1861,7 +1865,7 @@ int __kprobes register_kretprobe(struct kretprobe *rp)
 }
 EXPORT_SYMBOL_GPL(register_kretprobe);
 
-int __kprobes register_kretprobes(struct kretprobe **rps, int num)
+int register_kretprobes(struct kretprobe **rps, int num)
 {
 	int ret = 0, i;
 
@@ -1879,13 +1883,13 @@ int __kprobes register_kretprobes(struct kretprobe **rps, int num)
 }
 EXPORT_SYMBOL_GPL(register_kretprobes);
 
-void __kprobes unregister_kretprobe(struct kretprobe *rp)
+void unregister_kretprobe(struct kretprobe *rp)
 {
 	unregister_kretprobes(&rp, 1);
 }
 EXPORT_SYMBOL_GPL(unregister_kretprobe);
 
-void __kprobes unregister_kretprobes(struct kretprobe **rps, int num)
+void unregister_kretprobes(struct kretprobe **rps, int num)
 {
 	int i;
 
@@ -1908,38 +1912,38 @@ void __kprobes unregister_kretprobes(struct kretprobe **rps, int num)
 EXPORT_SYMBOL_GPL(unregister_kretprobes);
 
 #else /* CONFIG_KRETPROBES */
-int __kprobes register_kretprobe(struct kretprobe *rp)
+int register_kretprobe(struct kretprobe *rp)
 {
 	return -ENOSYS;
 }
 EXPORT_SYMBOL_GPL(register_kretprobe);
 
-int __kprobes register_kretprobes(struct kretprobe **rps, int num)
+int register_kretprobes(struct kretprobe **rps, int num)
 {
 	return -ENOSYS;
 }
 EXPORT_SYMBOL_GPL(register_kretprobes);
 
-void __kprobes unregister_kretprobe(struct kretprobe *rp)
+void unregister_kretprobe(struct kretprobe *rp)
 {
 }
 EXPORT_SYMBOL_GPL(unregister_kretprobe);
 
-void __kprobes unregister_kretprobes(struct kretprobe **rps, int num)
+void unregister_kretprobes(struct kretprobe **rps, int num)
 {
 }
 EXPORT_SYMBOL_GPL(unregister_kretprobes);
 
-static int __kprobes pre_handler_kretprobe(struct kprobe *p,
-					   struct pt_regs *regs)
+static int pre_handler_kretprobe(struct kprobe *p, struct pt_regs *regs)
 {
 	return 0;
 }
+NOKPROBE_SYMBOL(pre_handler_kretprobe);
 
 #endif /* CONFIG_KRETPROBES */
 
 /* Set the kprobe gone and remove its instruction buffer. */
-static void __kprobes kill_kprobe(struct kprobe *p)
+static void kill_kprobe(struct kprobe *p)
 {
 	struct kprobe *kp;
 
@@ -1963,7 +1967,7 @@ static void __kprobes kill_kprobe(struct kprobe *p)
 }
 
 /* Disable one kprobe */
-int __kprobes disable_kprobe(struct kprobe *kp)
+int disable_kprobe(struct kprobe *kp)
 {
 	int ret = 0;
 
@@ -1979,7 +1983,7 @@ int __kprobes disable_kprobe(struct kprobe *kp)
 EXPORT_SYMBOL_GPL(disable_kprobe);
 
 /* Enable one kprobe */
-int __kprobes enable_kprobe(struct kprobe *kp)
+int enable_kprobe(struct kprobe *kp)
 {
 	int ret = 0;
 	struct kprobe *p;
@@ -2012,16 +2016,49 @@ out:
 }
 EXPORT_SYMBOL_GPL(enable_kprobe);
 
-void __kprobes dump_kprobe(struct kprobe *kp)
+void dump_kprobe(struct kprobe *kp)
 {
 	printk(KERN_WARNING "Dumping kprobe:\n");
 	printk(KERN_WARNING "Name: %s\nAddress: %p\nOffset: %x\n",
 	       kp->symbol_name, kp->addr, kp->offset);
 }
+NOKPROBE_SYMBOL(dump_kprobe);
+
+/*
+ * Lookup and populate the kprobe_blacklist.
+ *
+ * Unlike the kretprobe blacklist, we'll need to determine
+ * the range of addresses that belong to the said functions,
+ * since a kprobe need not necessarily be at the beginning
+ * of a function.
+ */
+static int __init populate_kprobe_blacklist(unsigned long *start,
+					     unsigned long *end)
+{
+	unsigned long *iter;
+	struct kprobe_blacklist_entry *ent;
+	unsigned long offset = 0, size = 0;
+
+	for (iter = start; iter < end; iter++) {
+		if (!kallsyms_lookup_size_offset(*iter, &size, &offset)) {
+			pr_err("Failed to find blacklist %p\n", (void *)*iter);
+			continue;
+		}
+
+		ent = kmalloc(sizeof(*ent), GFP_KERNEL);
+		if (!ent)
+			return -ENOMEM;
+		ent->start_addr = *iter;
+		ent->end_addr = *iter + size;
+		INIT_LIST_HEAD(&ent->list);
+		list_add_tail(&ent->list, &kprobe_blacklist);
+	}
+	return 0;
+}
 
 /* Module notifier call back, checking kprobes on the module */
-static int __kprobes kprobes_module_callback(struct notifier_block *nb,
-					     unsigned long val, void *data)
+static int kprobes_module_callback(struct notifier_block *nb,
+				   unsigned long val, void *data)
 {
 	struct module *mod = data;
 	struct hlist_head *head;
@@ -2062,14 +2099,13 @@ static struct notifier_block kprobe_module_nb = {
 	.priority = 0
 };
 
+/* Markers of _kprobe_blacklist section */
+extern unsigned long __start_kprobe_blacklist[];
+extern unsigned long __stop_kprobe_blacklist[];
+
 static int __init init_kprobes(void)
 {
 	int i, err = 0;
-	unsigned long offset = 0, size = 0;
-	char *modname, namebuf[KSYM_NAME_LEN];
-	const char *symbol_name;
-	void *addr;
-	struct kprobe_blackpoint *kb;
 
 	/* FIXME allocate the probe table, currently defined statically */
 	/* initialize all list heads */
@@ -2079,26 +2115,11 @@ static int __init init_kprobes(void)
 		raw_spin_lock_init(&(kretprobe_table_locks[i].lock));
 	}
 
-	/*
-	 * Lookup and populate the kprobe_blacklist.
-	 *
-	 * Unlike the kretprobe blacklist, we'll need to determine
-	 * the range of addresses that belong to the said functions,
-	 * since a kprobe need not necessarily be at the beginning
-	 * of a function.
-	 */
-	for (kb = kprobe_blacklist; kb->name != NULL; kb++) {
-		kprobe_lookup_name(kb->name, addr);
-		if (!addr)
-			continue;
-
-		kb->start_addr = (unsigned long)addr;
-		symbol_name = kallsyms_lookup(kb->start_addr,
-				&size, &offset, &modname, namebuf);
-		if (!symbol_name)
-			kb->range = 0;
-		else
-			kb->range = size;
+	err = populate_kprobe_blacklist(__start_kprobe_blacklist,
+					__stop_kprobe_blacklist);
+	if (err) {
+		pr_err("kprobes: failed to populate blacklist: %d\n", err);
+		pr_err("Please take care of using kprobes.\n");
 	}
 
 	if (kretprobe_blacklist_size) {
@@ -2138,7 +2159,7 @@ static int __init init_kprobes(void)
 }
 
 #ifdef CONFIG_DEBUG_FS
-static void __kprobes report_probe(struct seq_file *pi, struct kprobe *p,
+static void report_probe(struct seq_file *pi, struct kprobe *p,
 		const char *sym, int offset, char *modname, struct kprobe *pp)
 {
 	char *kprobe_type;
@@ -2167,12 +2188,12 @@ static void __kprobes report_probe(struct seq_file *pi, struct kprobe *p,
 		(kprobe_ftrace(pp) ? "[FTRACE]" : ""));
 }
 
-static void __kprobes *kprobe_seq_start(struct seq_file *f, loff_t *pos)
+static void *kprobe_seq_start(struct seq_file *f, loff_t *pos)
 {
 	return (*pos < KPROBE_TABLE_SIZE) ? pos : NULL;
 }
 
-static void __kprobes *kprobe_seq_next(struct seq_file *f, void *v, loff_t *pos)
+static void *kprobe_seq_next(struct seq_file *f, void *v, loff_t *pos)
 {
 	(*pos)++;
 	if (*pos >= KPROBE_TABLE_SIZE)
@@ -2180,12 +2201,12 @@ static void __kprobes *kprobe_seq_next(struct seq_file *f, void *v, loff_t *pos)
 	return pos;
 }
 
-static void __kprobes kprobe_seq_stop(struct seq_file *f, void *v)
+static void kprobe_seq_stop(struct seq_file *f, void *v)
 {
 	/* Nothing to do */
 }
 
-static int __kprobes show_kprobe_addr(struct seq_file *pi, void *v)
+static int show_kprobe_addr(struct seq_file *pi, void *v)
 {
 	struct hlist_head *head;
 	struct kprobe *p, *kp;
@@ -2216,7 +2237,7 @@ static const struct seq_operations kprobes_seq_ops = {
 	.show  = show_kprobe_addr
 };
 
-static int __kprobes kprobes_open(struct inode *inode, struct file *filp)
+static int kprobes_open(struct inode *inode, struct file *filp)
 {
 	return seq_open(filp, &kprobes_seq_ops);
 }
@@ -2228,7 +2249,47 @@ static const struct file_operations debugfs_kprobes_operations = {
 	.release        = seq_release,
 };
 
-static void __kprobes arm_all_kprobes(void)
+/* kprobes/blacklist -- shows which functions can not be probed */
+static void *kprobe_blacklist_seq_start(struct seq_file *m, loff_t *pos)
+{
+	return seq_list_start(&kprobe_blacklist, *pos);
+}
+
+static void *kprobe_blacklist_seq_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	return seq_list_next(v, &kprobe_blacklist, pos);
+}
+
+static int kprobe_blacklist_seq_show(struct seq_file *m, void *v)
+{
+	struct kprobe_blacklist_entry *ent =
+		list_entry(v, struct kprobe_blacklist_entry, list);
+
+	seq_printf(m, "0x%p-0x%p\t%ps\n", (void *)ent->start_addr,
+		   (void *)ent->end_addr, (void *)ent->start_addr);
+	return 0;
+}
+
+static const struct seq_operations kprobe_blacklist_seq_ops = {
+	.start = kprobe_blacklist_seq_start,
+	.next  = kprobe_blacklist_seq_next,
+	.stop  = kprobe_seq_stop,	/* Reuse void function */
+	.show  = kprobe_blacklist_seq_show,
+};
+
+static int kprobe_blacklist_open(struct inode *inode, struct file *filp)
+{
+	return seq_open(filp, &kprobe_blacklist_seq_ops);
+}
+
+static const struct file_operations debugfs_kprobe_blacklist_ops = {
+	.open           = kprobe_blacklist_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = seq_release,
+};
+
+static void arm_all_kprobes(void)
 {
 	struct hlist_head *head;
 	struct kprobe *p;
@@ -2256,7 +2317,7 @@ already_enabled:
 	return;
 }
 
-static void __kprobes disarm_all_kprobes(void)
+static void disarm_all_kprobes(void)
 {
 	struct hlist_head *head;
 	struct kprobe *p;
@@ -2340,7 +2401,7 @@ static const struct file_operations fops_kp = {
 	.llseek =	default_llseek,
 };
 
-static int __kprobes debugfs_kprobe_init(void)
+static int __init debugfs_kprobe_init(void)
 {
 	struct dentry *dir, *file;
 	unsigned int value = 1;
@@ -2351,19 +2412,24 @@ static int __kprobes debugfs_kprobe_init(void)
 
 	file = debugfs_create_file("list", 0444, dir, NULL,
 				&debugfs_kprobes_operations);
-	if (!file) {
-		debugfs_remove(dir);
-		return -ENOMEM;
-	}
+	if (!file)
+		goto error;
 
 	file = debugfs_create_file("enabled", 0600, dir,
 					&value, &fops_kp);
-	if (!file) {
-		debugfs_remove(dir);
-		return -ENOMEM;
-	}
+	if (!file)
+		goto error;
+
+	file = debugfs_create_file("blacklist", 0444, dir, NULL,
+				&debugfs_kprobe_blacklist_ops);
+	if (!file)
+		goto error;
 
 	return 0;
+
+error:
+	debugfs_remove(dir);
+	return -ENOMEM;
 }
 
 late_initcall(debugfs_kprobe_init);
diff --git a/kernel/notifier.c b/kernel/notifier.c
index db4c8b0..4803da6 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -71,9 +71,9 @@ static int notifier_chain_unregister(struct notifier_block **nl,
  *	@returns:	notifier_call_chain returns the value returned by the
  *			last notifier function called.
  */
-static int __kprobes notifier_call_chain(struct notifier_block **nl,
-					unsigned long val, void *v,
-					int nr_to_call,	int *nr_calls)
+static int notifier_call_chain(struct notifier_block **nl,
+			       unsigned long val, void *v,
+			       int nr_to_call, int *nr_calls)
 {
 	int ret = NOTIFY_DONE;
 	struct notifier_block *nb, *next_nb;
@@ -102,6 +102,7 @@ static int __kprobes notifier_call_chain(struct notifier_block **nl,
 	}
 	return ret;
 }
+NOKPROBE_SYMBOL(notifier_call_chain);
 
 /*
  *	Atomic notifier chain routines.  Registration and unregistration
@@ -172,9 +173,9 @@ EXPORT_SYMBOL_GPL(atomic_notifier_chain_unregister);
  *	Otherwise the return value is the return value
  *	of the last notifier function called.
  */
-int __kprobes __atomic_notifier_call_chain(struct atomic_notifier_head *nh,
-					unsigned long val, void *v,
-					int nr_to_call, int *nr_calls)
+int __atomic_notifier_call_chain(struct atomic_notifier_head *nh,
+				 unsigned long val, void *v,
+				 int nr_to_call, int *nr_calls)
 {
 	int ret;
 
@@ -184,13 +185,15 @@ int __kprobes __atomic_notifier_call_chain(struct atomic_notifier_head *nh,
 	return ret;
 }
 EXPORT_SYMBOL_GPL(__atomic_notifier_call_chain);
+NOKPROBE_SYMBOL(__atomic_notifier_call_chain);
 
-int __kprobes atomic_notifier_call_chain(struct atomic_notifier_head *nh,
-		unsigned long val, void *v)
+int atomic_notifier_call_chain(struct atomic_notifier_head *nh,
+			       unsigned long val, void *v)
 {
 	return __atomic_notifier_call_chain(nh, val, v, -1, NULL);
 }
 EXPORT_SYMBOL_GPL(atomic_notifier_call_chain);
+NOKPROBE_SYMBOL(atomic_notifier_call_chain);
 
 /*
  *	Blocking notifier chain routines.  All access to the chain is
@@ -527,7 +530,7 @@ EXPORT_SYMBOL_GPL(srcu_init_notifier_head);
 
 static ATOMIC_NOTIFIER_HEAD(die_chain);
 
-int notrace __kprobes notify_die(enum die_val val, const char *str,
+int notrace notify_die(enum die_val val, const char *str,
 	       struct pt_regs *regs, long err, int trap, int sig)
 {
 	struct die_args args = {
@@ -540,6 +543,7 @@ int notrace __kprobes notify_die(enum die_val val, const char *str,
 	};
 	return atomic_notifier_call_chain(&die_chain, val, &args);
 }
+NOKPROBE_SYMBOL(notify_die);
 
 int register_die_notifier(struct notifier_block *nb)
 {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0a72516..a8c0fde 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2480,7 +2480,7 @@ notrace unsigned long get_parent_ip(unsigned long addr)
 #if defined(CONFIG_PREEMPT) && (defined(CONFIG_DEBUG_PREEMPT) || \
 				defined(CONFIG_PREEMPT_TRACER))
 
-void __kprobes preempt_count_add(int val)
+void preempt_count_add(int val)
 {
 #ifdef CONFIG_DEBUG_PREEMPT
 	/*
@@ -2506,8 +2506,9 @@ void __kprobes preempt_count_add(int val)
 	}
 }
 EXPORT_SYMBOL(preempt_count_add);
+NOKPROBE_SYMBOL(preempt_count_add);
 
-void __kprobes preempt_count_sub(int val)
+void preempt_count_sub(int val)
 {
 #ifdef CONFIG_DEBUG_PREEMPT
 	/*
@@ -2528,6 +2529,7 @@ void __kprobes preempt_count_sub(int val)
 	__preempt_count_sub(val);
 }
 EXPORT_SYMBOL(preempt_count_sub);
+NOKPROBE_SYMBOL(preempt_count_sub);
 
 #endif
 
@@ -2810,6 +2812,7 @@ asmlinkage __visible void __sched notrace preempt_schedule(void)
 		barrier();
 	} while (need_resched());
 }
+NOKPROBE_SYMBOL(preempt_schedule);
 EXPORT_SYMBOL(preempt_schedule);
 #endif /* CONFIG_PREEMPT */
 
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index c894614..5d12bb4 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -248,8 +248,8 @@ void perf_trace_del(struct perf_event *p_event, int flags)
 	tp_event->class->reg(tp_event, TRACE_REG_PERF_DEL, p_event);
 }
 
-__kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
-				       struct pt_regs *regs, int *rctxp)
+void *perf_trace_buf_prepare(int size, unsigned short type,
+			     struct pt_regs *regs, int *rctxp)
 {
 	struct trace_entry *entry;
 	unsigned long flags;
@@ -281,6 +281,7 @@ __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
 	return raw_data;
 }
 EXPORT_SYMBOL_GPL(perf_trace_buf_prepare);
+NOKPROBE_SYMBOL(perf_trace_buf_prepare);
 
 #ifdef CONFIG_FUNCTION_TRACER
 static void
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 903ae28..242e4ec 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -40,27 +40,27 @@ struct trace_kprobe {
 	(sizeof(struct probe_arg) * (n)))
 
 
-static __kprobes bool trace_kprobe_is_return(struct trace_kprobe *tk)
+static nokprobe_inline bool trace_kprobe_is_return(struct trace_kprobe *tk)
 {
 	return tk->rp.handler != NULL;
 }
 
-static __kprobes const char *trace_kprobe_symbol(struct trace_kprobe *tk)
+static nokprobe_inline const char *trace_kprobe_symbol(struct trace_kprobe *tk)
 {
 	return tk->symbol ? tk->symbol : "unknown";
 }
 
-static __kprobes unsigned long trace_kprobe_offset(struct trace_kprobe *tk)
+static nokprobe_inline unsigned long trace_kprobe_offset(struct trace_kprobe *tk)
 {
 	return tk->rp.kp.offset;
 }
 
-static __kprobes bool trace_kprobe_has_gone(struct trace_kprobe *tk)
+static nokprobe_inline bool trace_kprobe_has_gone(struct trace_kprobe *tk)
 {
 	return !!(kprobe_gone(&tk->rp.kp));
 }
 
-static __kprobes bool trace_kprobe_within_module(struct trace_kprobe *tk,
+static nokprobe_inline bool trace_kprobe_within_module(struct trace_kprobe *tk,
 						 struct module *mod)
 {
 	int len = strlen(mod->name);
@@ -68,7 +68,7 @@ static __kprobes bool trace_kprobe_within_module(struct trace_kprobe *tk,
 	return strncmp(mod->name, name, len) == 0 && name[len] == ':';
 }
 
-static __kprobes bool trace_kprobe_is_on_module(struct trace_kprobe *tk)
+static nokprobe_inline bool trace_kprobe_is_on_module(struct trace_kprobe *tk)
 {
 	return !!strchr(trace_kprobe_symbol(tk), ':');
 }
@@ -132,19 +132,21 @@ struct symbol_cache *alloc_symbol_cache(const char *sym, long offset)
  * Kprobes-specific fetch functions
  */
 #define DEFINE_FETCH_stack(type)					\
-static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
+static void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,		\
 					  void *offset, void *dest)	\
 {									\
 	*(type *)dest = (type)regs_get_kernel_stack_nth(regs,		\
 				(unsigned int)((unsigned long)offset));	\
-}
+}									\
+NOKPROBE_SYMBOL(FETCH_FUNC_NAME(stack, type));
+
 DEFINE_BASIC_FETCH_FUNCS(stack)
 /* No string on the stack entry */
 #define fetch_stack_string	NULL
 #define fetch_stack_string_size	NULL
 
 #define DEFINE_FETCH_memory(type)					\
-static __kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,\
+static void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,		\
 					  void *addr, void *dest)	\
 {									\
 	type retval;							\
@@ -152,14 +154,16 @@ static __kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,\
 		*(type *)dest = 0;					\
 	else								\
 		*(type *)dest = retval;					\
-}
+}									\
+NOKPROBE_SYMBOL(FETCH_FUNC_NAME(memory, type));
+
 DEFINE_BASIC_FETCH_FUNCS(memory)
 /*
  * Fetch a null-terminated string. Caller MUST set *(u32 *)dest with max
  * length and relative data location.
  */
-static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
-						      void *addr, void *dest)
+static void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
+					    void *addr, void *dest)
 {
 	long ret;
 	int maxlen = get_rloc_len(*(u32 *)dest);
@@ -193,10 +197,11 @@ static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
 					      get_rloc_offs(*(u32 *)dest));
 	}
 }
+NOKPROBE_SYMBOL(FETCH_FUNC_NAME(memory, string));
 
 /* Return the length of string -- including null terminal byte */
-static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
-							void *addr, void *dest)
+static void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
+						 void *addr, void *dest)
 {
 	mm_segment_t old_fs;
 	int ret, len = 0;
@@ -219,17 +224,19 @@ static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
 	else
 		*(u32 *)dest = len;
 }
+NOKPROBE_SYMBOL(FETCH_FUNC_NAME(memory, string_size));
 
 #define DEFINE_FETCH_symbol(type)					\
-__kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,	\
-					  void *data, void *dest)	\
+void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs, void *data, void *dest)\
 {									\
 	struct symbol_cache *sc = data;					\
 	if (sc->addr)							\
 		fetch_memory_##type(regs, (void *)sc->addr, dest);	\
 	else								\
 		*(type *)dest = 0;					\
-}
+}									\
+NOKPROBE_SYMBOL(FETCH_FUNC_NAME(symbol, type));
+
 DEFINE_BASIC_FETCH_FUNCS(symbol)
 DEFINE_FETCH_symbol(string)
 DEFINE_FETCH_symbol(string_size)
@@ -907,7 +914,7 @@ static const struct file_operations kprobe_profile_ops = {
 };
 
 /* Kprobe handler */
-static __kprobes void
+static nokprobe_inline void
 __kprobe_trace_func(struct trace_kprobe *tk, struct pt_regs *regs,
 		    struct ftrace_event_file *ftrace_file)
 {
@@ -943,7 +950,7 @@ __kprobe_trace_func(struct trace_kprobe *tk, struct pt_regs *regs,
 					 entry, irq_flags, pc, regs);
 }
 
-static __kprobes void
+static void
 kprobe_trace_func(struct trace_kprobe *tk, struct pt_regs *regs)
 {
 	struct event_file_link *link;
@@ -951,9 +958,10 @@ kprobe_trace_func(struct trace_kprobe *tk, struct pt_regs *regs)
 	list_for_each_entry_rcu(link, &tk->tp.files, list)
 		__kprobe_trace_func(tk, regs, link->file);
 }
+NOKPROBE_SYMBOL(kprobe_trace_func);
 
 /* Kretprobe handler */
-static __kprobes void
+static nokprobe_inline void
 __kretprobe_trace_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
 		       struct pt_regs *regs,
 		       struct ftrace_event_file *ftrace_file)
@@ -991,7 +999,7 @@ __kretprobe_trace_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
 					 entry, irq_flags, pc, regs);
 }
 
-static __kprobes void
+static void
 kretprobe_trace_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
 		     struct pt_regs *regs)
 {
@@ -1000,6 +1008,7 @@ kretprobe_trace_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
 	list_for_each_entry_rcu(link, &tk->tp.files, list)
 		__kretprobe_trace_func(tk, ri, regs, link->file);
 }
+NOKPROBE_SYMBOL(kretprobe_trace_func);
 
 /* Event entry printers */
 static enum print_line_t
@@ -1131,7 +1140,7 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
 #ifdef CONFIG_PERF_EVENTS
 
 /* Kprobe profile handler */
-static __kprobes void
+static void
 kprobe_perf_func(struct trace_kprobe *tk, struct pt_regs *regs)
 {
 	struct ftrace_event_call *call = &tk->tp.call;
@@ -1158,9 +1167,10 @@ kprobe_perf_func(struct trace_kprobe *tk, struct pt_regs *regs)
 	store_trace_args(sizeof(*entry), &tk->tp, regs, (u8 *)&entry[1], dsize);
 	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
 }
+NOKPROBE_SYMBOL(kprobe_perf_func);
 
 /* Kretprobe profile handler */
-static __kprobes void
+static void
 kretprobe_perf_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
 		    struct pt_regs *regs)
 {
@@ -1188,6 +1198,7 @@ kretprobe_perf_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
 	store_trace_args(sizeof(*entry), &tk->tp, regs, (u8 *)&entry[1], dsize);
 	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
 }
+NOKPROBE_SYMBOL(kretprobe_perf_func);
 #endif	/* CONFIG_PERF_EVENTS */
 
 /*
@@ -1196,9 +1207,8 @@ kretprobe_perf_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
  * kprobe_trace_self_tests_init() does enable_trace_probe/disable_trace_probe
  * lockless, but we can't race with this __init function.
  */
-static __kprobes
-int kprobe_register(struct ftrace_event_call *event,
-		    enum trace_reg type, void *data)
+static int kprobe_register(struct ftrace_event_call *event,
+			   enum trace_reg type, void *data)
 {
 	struct trace_kprobe *tk = (struct trace_kprobe *)event->data;
 	struct ftrace_event_file *file = data;
@@ -1224,8 +1234,7 @@ int kprobe_register(struct ftrace_event_call *event,
 	return 0;
 }
 
-static __kprobes
-int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs)
+static int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs)
 {
 	struct trace_kprobe *tk = container_of(kp, struct trace_kprobe, rp.kp);
 
@@ -1239,9 +1248,10 @@ int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs)
 #endif
 	return 0;	/* We don't tweek kernel, so just return 0 */
 }
+NOKPROBE_SYMBOL(kprobe_dispatcher);
 
-static __kprobes
-int kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
+static int
+kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
 {
 	struct trace_kprobe *tk = container_of(ri->rp, struct trace_kprobe, rp);
 
@@ -1255,6 +1265,7 @@ int kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
 #endif
 	return 0;	/* We don't tweek kernel, so just return 0 */
 }
+NOKPROBE_SYMBOL(kretprobe_dispatcher);
 
 static struct trace_event_functions kretprobe_funcs = {
 	.trace		= print_kretprobe_event
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 8364a42..d4b9fc2 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -37,13 +37,13 @@ const char *reserved_field_names[] = {
 
 /* Printing  in basic type function template */
 #define DEFINE_BASIC_PRINT_TYPE_FUNC(type, fmt)				\
-__kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,	\
-						const char *name,	\
-						void *data, void *ent)	\
+int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s, const char *name,	\
+				void *data, void *ent)			\
 {									\
 	return trace_seq_printf(s, " %s=" fmt, name, *(type *)data);	\
 }									\
-const char PRINT_TYPE_FMT_NAME(type)[] = fmt;
+const char PRINT_TYPE_FMT_NAME(type)[] = fmt;				\
+NOKPROBE_SYMBOL(PRINT_TYPE_FUNC_NAME(type));
 
 DEFINE_BASIC_PRINT_TYPE_FUNC(u8 , "0x%x")
 DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "0x%x")
@@ -55,9 +55,8 @@ DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%d")
 DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%Ld")
 
 /* Print type function for string type */
-__kprobes int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s,
-						  const char *name,
-						  void *data, void *ent)
+int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s, const char *name,
+				 void *data, void *ent)
 {
 	int len = *(u32 *)data >> 16;
 
@@ -67,6 +66,7 @@ __kprobes int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s,
 		return trace_seq_printf(s, " %s=\"%s\"", name,
 					(const char *)get_loc_data(data, ent));
 }
+NOKPROBE_SYMBOL(PRINT_TYPE_FUNC_NAME(string));
 
 const char PRINT_TYPE_FMT_NAME(string)[] = "\\\"%s\\\"";
 
@@ -81,23 +81,24 @@ const char PRINT_TYPE_FMT_NAME(string)[] = "\\\"%s\\\"";
 
 /* Data fetch function templates */
 #define DEFINE_FETCH_reg(type)						\
-__kprobes void FETCH_FUNC_NAME(reg, type)(struct pt_regs *regs,		\
-					void *offset, void *dest)	\
+void FETCH_FUNC_NAME(reg, type)(struct pt_regs *regs, void *offset, void *dest)	\
 {									\
 	*(type *)dest = (type)regs_get_register(regs,			\
 				(unsigned int)((unsigned long)offset));	\
-}
+}									\
+NOKPROBE_SYMBOL(FETCH_FUNC_NAME(reg, type));
 DEFINE_BASIC_FETCH_FUNCS(reg)
 /* No string on the register */
 #define fetch_reg_string	NULL
 #define fetch_reg_string_size	NULL
 
 #define DEFINE_FETCH_retval(type)					\
-__kprobes void FETCH_FUNC_NAME(retval, type)(struct pt_regs *regs,	\
-					  void *dummy, void *dest)	\
+void FETCH_FUNC_NAME(retval, type)(struct pt_regs *regs,		\
+				   void *dummy, void *dest)		\
 {									\
 	*(type *)dest = (type)regs_return_value(regs);			\
-}
+}									\
+NOKPROBE_SYMBOL(FETCH_FUNC_NAME(retval, type));
 DEFINE_BASIC_FETCH_FUNCS(retval)
 /* No string on the retval */
 #define fetch_retval_string		NULL
@@ -112,8 +113,8 @@ struct deref_fetch_param {
 };
 
 #define DEFINE_FETCH_deref(type)					\
-__kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,	\
-					    void *data, void *dest)	\
+void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,			\
+				  void *data, void *dest)		\
 {									\
 	struct deref_fetch_param *dprm = data;				\
 	unsigned long addr;						\
@@ -123,12 +124,13 @@ __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,	\
 		dprm->fetch(regs, (void *)addr, dest);			\
 	} else								\
 		*(type *)dest = 0;					\
-}
+}									\
+NOKPROBE_SYMBOL(FETCH_FUNC_NAME(deref, type));
 DEFINE_BASIC_FETCH_FUNCS(deref)
 DEFINE_FETCH_deref(string)
 
-__kprobes void FETCH_FUNC_NAME(deref, string_size)(struct pt_regs *regs,
-						   void *data, void *dest)
+void FETCH_FUNC_NAME(deref, string_size)(struct pt_regs *regs,
+					 void *data, void *dest)
 {
 	struct deref_fetch_param *dprm = data;
 	unsigned long addr;
@@ -140,16 +142,18 @@ __kprobes void FETCH_FUNC_NAME(deref, string_size)(struct pt_regs *regs,
 	} else
 		*(string_size *)dest = 0;
 }
+NOKPROBE_SYMBOL(FETCH_FUNC_NAME(deref, string_size));
 
-static __kprobes void update_deref_fetch_param(struct deref_fetch_param *data)
+static void update_deref_fetch_param(struct deref_fetch_param *data)
 {
 	if (CHECK_FETCH_FUNCS(deref, data->orig.fn))
 		update_deref_fetch_param(data->orig.data);
 	else if (CHECK_FETCH_FUNCS(symbol, data->orig.fn))
 		update_symbol_cache(data->orig.data);
 }
+NOKPROBE_SYMBOL(update_deref_fetch_param);
 
-static __kprobes void free_deref_fetch_param(struct deref_fetch_param *data)
+static void free_deref_fetch_param(struct deref_fetch_param *data)
 {
 	if (CHECK_FETCH_FUNCS(deref, data->orig.fn))
 		free_deref_fetch_param(data->orig.data);
@@ -157,6 +161,7 @@ static __kprobes void free_deref_fetch_param(struct deref_fetch_param *data)
 		free_symbol_cache(data->orig.data);
 	kfree(data);
 }
+NOKPROBE_SYMBOL(free_deref_fetch_param);
 
 /* Bitfield fetch function */
 struct bitfield_fetch_param {
@@ -166,8 +171,8 @@ struct bitfield_fetch_param {
 };
 
 #define DEFINE_FETCH_bitfield(type)					\
-__kprobes void FETCH_FUNC_NAME(bitfield, type)(struct pt_regs *regs,	\
-					    void *data, void *dest)	\
+void FETCH_FUNC_NAME(bitfield, type)(struct pt_regs *regs,		\
+				     void *data, void *dest)		\
 {									\
 	struct bitfield_fetch_param *bprm = data;			\
 	type buf = 0;							\
@@ -177,13 +182,13 @@ __kprobes void FETCH_FUNC_NAME(bitfield, type)(struct pt_regs *regs,	\
 		buf >>= bprm->low_shift;				\
 	}								\
 	*(type *)dest = buf;						\
-}
-
+}									\
+NOKPROBE_SYMBOL(FETCH_FUNC_NAME(bitfield, type));
 DEFINE_BASIC_FETCH_FUNCS(bitfield)
 #define fetch_bitfield_string		NULL
 #define fetch_bitfield_string_size	NULL
 
-static __kprobes void
+static void
 update_bitfield_fetch_param(struct bitfield_fetch_param *data)
 {
 	/*
@@ -196,7 +201,7 @@ update_bitfield_fetch_param(struct bitfield_fetch_param *data)
 		update_symbol_cache(data->orig.data);
 }
 
-static __kprobes void
+static void
 free_bitfield_fetch_param(struct bitfield_fetch_param *data)
 {
 	/*
@@ -255,17 +260,17 @@ fail:
 }
 
 /* Special function : only accept unsigned long */
-static __kprobes void fetch_kernel_stack_address(struct pt_regs *regs,
-						 void *dummy, void *dest)
+static void fetch_kernel_stack_address(struct pt_regs *regs, void *dummy, void *dest)
 {
 	*(unsigned long *)dest = kernel_stack_pointer(regs);
 }
+NOKPROBE_SYMBOL(fetch_kernel_stack_address);
 
-static __kprobes void fetch_user_stack_address(struct pt_regs *regs,
-					       void *dummy, void *dest)
+static void fetch_user_stack_address(struct pt_regs *regs, void *dummy, void *dest)
 {
 	*(unsigned long *)dest = user_stack_pointer(regs);
 }
+NOKPROBE_SYMBOL(fetch_user_stack_address);
 
 static fetch_func_t get_fetch_size_function(const struct fetch_type *type,
 					    fetch_func_t orig_fn,
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index fb1ab5d..4f815fb 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -81,13 +81,13 @@
  */
 #define convert_rloc_to_loc(dl, offs)	((u32)(dl) + (offs))
 
-static inline void *get_rloc_data(u32 *dl)
+static nokprobe_inline void *get_rloc_data(u32 *dl)
 {
 	return (u8 *)dl + get_rloc_offs(*dl);
 }
 
 /* For data_loc conversion */
-static inline void *get_loc_data(u32 *dl, void *ent)
+static nokprobe_inline void *get_loc_data(u32 *dl, void *ent)
 {
 	return (u8 *)ent + get_rloc_offs(*dl);
 }
@@ -136,9 +136,8 @@ typedef u32 string_size;
 
 /* Printing  in basic type function template */
 #define DECLARE_BASIC_PRINT_TYPE_FUNC(type)				\
-__kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,		\
-					 const char *name,		\
-					 void *data, void *ent);	\
+int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s, const char *name,	\
+				void *data, void *ent);			\
 extern const char PRINT_TYPE_FMT_NAME(type)[]
 
 DECLARE_BASIC_PRINT_TYPE_FUNC(u8);
@@ -303,7 +302,7 @@ static inline bool trace_probe_is_registered(struct trace_probe *tp)
 	return !!(tp->flags & TP_FLAG_REGISTERED);
 }
 
-static inline __kprobes void call_fetch(struct fetch_param *fprm,
+static nokprobe_inline void call_fetch(struct fetch_param *fprm,
 				 struct pt_regs *regs, void *dest)
 {
 	return fprm->fn(regs, fprm->data, dest);
@@ -351,7 +350,7 @@ extern ssize_t traceprobe_probes_write(struct file *file,
 extern int traceprobe_command(const char *buf, int (*createfn)(int, char**));
 
 /* Sum up total data length for dynamic arraies (strings) */
-static inline __kprobes int
+static nokprobe_inline int
 __get_data_size(struct trace_probe *tp, struct pt_regs *regs)
 {
 	int i, ret = 0;
@@ -367,7 +366,7 @@ __get_data_size(struct trace_probe *tp, struct pt_regs *regs)
 }
 
 /* Store the value of each argument */
-static inline __kprobes void
+static nokprobe_inline void
 store_trace_args(int ent_size, struct trace_probe *tp, struct pt_regs *regs,
 		 u8 *data, int maxlen)
 {
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index c082a74..04fdb5d 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -108,8 +108,8 @@ static unsigned long get_user_stack_nth(struct pt_regs *regs, unsigned int n)
  * Uprobes-specific fetch functions
  */
 #define DEFINE_FETCH_stack(type)					\
-static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
-					  void *offset, void *dest)	\
+static void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,		\
+					 void *offset, void *dest)	\
 {									\
 	*(type *)dest = (type)get_user_stack_nth(regs,			\
 					      ((unsigned long)offset)); \
@@ -120,8 +120,8 @@ DEFINE_BASIC_FETCH_FUNCS(stack)
 #define fetch_stack_string_size	NULL
 
 #define DEFINE_FETCH_memory(type)					\
-static __kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,\
-						void *addr, void *dest) \
+static void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,		\
+					  void *addr, void *dest)	\
 {									\
 	type retval;							\
 	void __user *vaddr = (void __force __user *) addr;		\
@@ -136,8 +136,8 @@ DEFINE_BASIC_FETCH_FUNCS(memory)
  * Fetch a null-terminated string. Caller MUST set *(u32 *)dest with max
  * length and relative data location.
  */
-static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
-						      void *addr, void *dest)
+static void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
+					    void *addr, void *dest)
 {
 	long ret;
 	u32 rloc = *(u32 *)dest;
@@ -158,8 +158,8 @@ static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
 	}
 }
 
-static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
-						      void *addr, void *dest)
+static void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
+						 void *addr, void *dest)
 {
 	int len;
 	void __user *vaddr = (void __force __user *) addr;
@@ -184,8 +184,8 @@ static unsigned long translate_user_vaddr(void *file_offset)
 }
 
 #define DEFINE_FETCH_file_offset(type)					\
-static __kprobes void FETCH_FUNC_NAME(file_offset, type)(struct pt_regs *regs,\
-					void *offset, void *dest) 	\
+static void FETCH_FUNC_NAME(file_offset, type)(struct pt_regs *regs,	\
+					       void *offset, void *dest)\
 {									\
 	void *vaddr = (void *)translate_user_vaddr(offset);		\
 									\
@@ -1009,56 +1009,60 @@ uprobe_filter_event(struct trace_uprobe *tu, struct perf_event *event)
 	return __uprobe_perf_filter(&tu->filter, event->hw.tp_target->mm);
 }
 
-static int uprobe_perf_open(struct trace_uprobe *tu, struct perf_event *event)
+static int uprobe_perf_close(struct trace_uprobe *tu, struct perf_event *event)
 {
 	bool done;
 
 	write_lock(&tu->filter.rwlock);
 	if (event->hw.tp_target) {
-		/*
-		 * event->parent != NULL means copy_process(), we can avoid
-		 * uprobe_apply(). current->mm must be probed and we can rely
-		 * on dup_mmap() which preserves the already installed bp's.
-		 *
-		 * attr.enable_on_exec means that exec/mmap will install the
-		 * breakpoints we need.
-		 */
+		list_del(&event->hw.tp_list);
 		done = tu->filter.nr_systemwide ||
-			event->parent || event->attr.enable_on_exec ||
+			(event->hw.tp_target->flags & PF_EXITING) ||
 			uprobe_filter_event(tu, event);
-		list_add(&event->hw.tp_list, &tu->filter.perf_events);
 	} else {
+		tu->filter.nr_systemwide--;
 		done = tu->filter.nr_systemwide;
-		tu->filter.nr_systemwide++;
 	}
 	write_unlock(&tu->filter.rwlock);
 
 	if (!done)
-		uprobe_apply(tu->inode, tu->offset, &tu->consumer, true);
+		return uprobe_apply(tu->inode, tu->offset, &tu->consumer, false);
 
 	return 0;
 }
 
-static int uprobe_perf_close(struct trace_uprobe *tu, struct perf_event *event)
+static int uprobe_perf_open(struct trace_uprobe *tu, struct perf_event *event)
 {
 	bool done;
+	int err;
 
 	write_lock(&tu->filter.rwlock);
 	if (event->hw.tp_target) {
-		list_del(&event->hw.tp_list);
+		/*
+		 * event->parent != NULL means copy_process(), we can avoid
+		 * uprobe_apply(). current->mm must be probed and we can rely
+		 * on dup_mmap() which preserves the already installed bp's.
+		 *
+		 * attr.enable_on_exec means that exec/mmap will install the
+		 * breakpoints we need.
+		 */
 		done = tu->filter.nr_systemwide ||
-			(event->hw.tp_target->flags & PF_EXITING) ||
+			event->parent || event->attr.enable_on_exec ||
 			uprobe_filter_event(tu, event);
+		list_add(&event->hw.tp_list, &tu->filter.perf_events);
 	} else {
-		tu->filter.nr_systemwide--;
 		done = tu->filter.nr_systemwide;
+		tu->filter.nr_systemwide++;
 	}
 	write_unlock(&tu->filter.rwlock);
 
-	if (!done)
-		uprobe_apply(tu->inode, tu->offset, &tu->consumer, false);
-
-	return 0;
+	err = 0;
+	if (!done) {
+		err = uprobe_apply(tu->inode, tu->offset, &tu->consumer, true);
+		if (err)
+			uprobe_perf_close(tu, event);
+	}
+	return err;
 }
 
 static bool uprobe_perf_filter(struct uprobe_consumer *uc,
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
diff --git a/tools/lib/api/fs/fs.c b/tools/lib/api/fs/fs.c
index 5b5eb78..c1b49c3 100644
--- a/tools/lib/api/fs/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -1,8 +1,10 @@
 /* TODO merge/factor in debugfs.c here */
 
+#include <ctype.h>
 #include <errno.h>
 #include <stdbool.h>
 #include <stdio.h>
+#include <stdlib.h>
 #include <string.h>
 #include <sys/vfs.h>
 
@@ -96,12 +98,51 @@ static bool fs__check_mounts(struct fs *fs)
 	return false;
 }
 
+static void mem_toupper(char *f, size_t len)
+{
+	while (len) {
+		*f = toupper(*f);
+		f++;
+		len--;
+	}
+}
+
+/*
+ * Check for "NAME_PATH" environment variable to override fs location (for
+ * testing). This matches the recommendation in Documentation/sysfs-rules.txt
+ * for SYSFS_PATH.
+ */
+static bool fs__env_override(struct fs *fs)
+{
+	char *override_path;
+	size_t name_len = strlen(fs->name);
+	/* name + "_PATH" + '\0' */
+	char upper_name[name_len + 5 + 1];
+	memcpy(upper_name, fs->name, name_len);
+	mem_toupper(upper_name, name_len);
+	strcpy(&upper_name[name_len], "_PATH");
+
+	override_path = getenv(upper_name);
+	if (!override_path)
+		return false;
+
+	fs->found = true;
+	strncpy(fs->path, override_path, sizeof(fs->path));
+	return true;
+}
+
 static const char *fs__get_mountpoint(struct fs *fs)
 {
+	if (fs__env_override(fs))
+		return fs->path;
+
 	if (fs__check_mounts(fs))
 		return fs->path;
 
-	return fs__read_mounts(fs) ? fs->path : NULL;
+	if (fs__read_mounts(fs))
+		return fs->path;
+
+	return NULL;
 }
 
 static const char *fs__mountpoint(int idx)
diff --git a/tools/lib/lockdep/Makefile b/tools/lib/lockdep/Makefile
index bba2f52..52f9279 100644
--- a/tools/lib/lockdep/Makefile
+++ b/tools/lib/lockdep/Makefile
@@ -104,7 +104,7 @@ N		=
 
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
diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index c71b0f3..d460049 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -184,9 +184,10 @@ following filters are defined:
 	- in_tx: only when the target is in a hardware transaction
 	- no_tx: only when the target is not in a hardware transaction
 	- abort_tx: only when the target is a hardware transaction abort
+	- cond: conditional branches
 
 +
-The option requires at least one branch type among any, any_call, any_ret, ind_call.
+The option requires at least one branch type among any, any_call, any_ret, ind_call, cond.
 The privilege levels may be omitted, in which case, the privilege levels of the associated
 event are applied to the branch filter. Both kernel (k) and hypervisor (hv) privilege
 levels are subject to permissions.  When sampling on multiple events, branch stack sampling
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 8eab8a4..cefdf43 100644
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
+	overhead, overhead_sys, overhead_us, overhead_children, sample and period.
+	Also it can contain any sort key(s).
+
+	By default, every sort keys not specified in -F will be appended
+	automatically.
+
 -p::
 --parent=<regex>::
         A regex filter to identify parent. The parent is a caller of this
@@ -141,6 +163,11 @@ OPTIONS
 
 	Default: fractal,0.5,callee,function.
 
+--children::
+	Accumulate callchain of children to parent entry so that then can
+	show up in the output.  The output will have a new "Children" column
+	and will be sorted on the data.  It requires callchains are recorded.
+
 --max-stack::
 	Set the stack depth limit when parsing the callchain, anything
 	beyond the specified depth will be ignored. This is a trade-off
@@ -237,6 +264,15 @@ OPTIONS
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
index 976b00c..180ae02 100644
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
+	overhead, overhead_sys, overhead_us, overhead_children, sample and period.
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
@@ -148,6 +161,12 @@ Default is to monitor all CPUS.
 	Setup and enable call-graph (stack chain/backtrace) recording,
 	implies -g.
 
+--children::
+	Accumulate callchain of children to parent entry so that then can
+	show up in the output.  The output will have a new "Children" column
+	and will be sorted on the data.  It requires -g/--call-graph option
+	enabled.
+
 --max-stack::
 	Set the stack depth limit when parsing the callchain, anything
 	beyond the specified depth will be ignored. This is a trade-off
@@ -165,6 +184,15 @@ Default is to monitor all CPUS.
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
 
@@ -200,4 +228,4 @@ Pressing any unmapped key displays a menu, and prompts for input.
 
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
index 895edd3..ae20edf 100644
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
@@ -397,7 +396,11 @@ LIB_OBJS += $(OUTPUT)tests/rdpmc.o
 LIB_OBJS += $(OUTPUT)tests/evsel-roundtrip-name.o
 LIB_OBJS += $(OUTPUT)tests/evsel-tp-sched.o
 LIB_OBJS += $(OUTPUT)tests/pmu.o
+LIB_OBJS += $(OUTPUT)tests/hists_common.o
 LIB_OBJS += $(OUTPUT)tests/hists_link.o
+LIB_OBJS += $(OUTPUT)tests/hists_filter.o
+LIB_OBJS += $(OUTPUT)tests/hists_output.o
+LIB_OBJS += $(OUTPUT)tests/hists_cumulate.o
 LIB_OBJS += $(OUTPUT)tests/python-use.o
 LIB_OBJS += $(OUTPUT)tests/bp_signal.o
 LIB_OBJS += $(OUTPUT)tests/bp_signal_overflow.o
@@ -410,10 +413,12 @@ LIB_OBJS += $(OUTPUT)tests/code-reading.o
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
@@ -784,8 +789,8 @@ help:
 	@echo ''
 	@echo 'Perf install targets:'
 	@echo '  NOTE: documentation build requires asciidoc, xmlto packages to be installed'
-	@echo '  HINT: use "make prefix=<path> <install target>" to install to a particular'
-	@echo '        path like make prefix=/usr/local install install-doc'
+	@echo '  HINT: use "prefix" or "DESTDIR" to install to a particular'
+	@echo '        path like "make prefix=/usr/local install install-doc"'
 	@echo '  install	- install compiled binaries'
 	@echo '  install-doc	- install *all* documentation'
 	@echo '  install-man	- install manpage documentation'
@@ -810,17 +815,20 @@ INSTALL_DOC_TARGETS += quick-install-doc quick-install-man quick-install-html
 $(DOC_TARGETS):
 	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) $(@:doc=all)
 
+TAG_FOLDERS= . ../lib/traceevent ../lib/api ../lib/symbol
+TAG_FILES= ../../include/uapi/linux/perf_event.h
+
 TAGS:
 	$(RM) TAGS
-	$(FIND) . -name '*.[hcS]' -print | xargs etags -a
+	$(FIND) $(TAG_FOLDERS) -name '*.[hcS]' -print | xargs etags -a $(TAG_FILES)
 
 tags:
 	$(RM) tags
-	$(FIND) . -name '*.[hcS]' -print | xargs ctags -a
+	$(FIND) $(TAG_FOLDERS) -name '*.[hcS]' -print | xargs ctags -a $(TAG_FILES)
 
 cscope:
 	$(RM) cscope*
-	$(FIND) . -name '*.[hcS]' -print | xargs cscope -b
+	$(FIND) $(TAG_FOLDERS) -name '*.[hcS]' -print | xargs cscope -b $(TAG_FILES)
 
 ### Detect prefix changes
 TRACK_CFLAGS = $(subst ','\'',$(CFLAGS)):\
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
index 0da603b..1ec429f 100644
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
@@ -65,13 +65,13 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 		return 0;
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, NULL, NULL, NULL, 1, 1, 0);
+	he = __hists__add_entry(&evsel->hists, al, NULL, NULL, NULL, 1, 1, 0,
+				true);
 	if (he == NULL)
 		return -ENOMEM;
 
 	ret = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
-	evsel->hists.stats.total_period += sample->period;
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+	hists__inc_nr_samples(&evsel->hists, true);
 	return ret;
 }
 
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 204fffe..9a5a035 100644
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
@@ -308,7 +315,7 @@ static int hists__add_entry(struct hists *hists,
 			    u64 weight, u64 transaction)
 {
 	if (__hists__add_entry(hists, al, NULL, NULL, NULL, period, weight,
-			       transaction) != NULL)
+			       transaction, true) != NULL)
 		return 0;
 	return -ENOMEM;
 }
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
index 8ce62ef..378b85b 100644
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
 
@@ -512,13 +447,19 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 
 		if (record__mmap_read_all(rec) < 0) {
 			err = -1;
-			goto out_delete_session;
+			goto out_child;
 		}
 
 		if (hits == rec->samples) {
 			if (done)
 				break;
 			err = poll(rec->evlist->pollfd, rec->evlist->nr_fds, -1);
+			/*
+			 * Propagate error, only if there's any. Ignore positive
+			 * number of returned events and interrupt error.
+			 */
+			if (err > 0 || (err < 0 && errno == EINTR))
+				err = 0;
 			waking++;
 		}
 
@@ -538,28 +479,52 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
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
@@ -583,6 +548,7 @@ static const struct branch_mode branch_modes[] = {
 	BRANCH_OPT("abort_tx", PERF_SAMPLE_BRANCH_ABORT_TX),
 	BRANCH_OPT("in_tx", PERF_SAMPLE_BRANCH_IN_TX),
 	BRANCH_OPT("no_tx", PERF_SAMPLE_BRANCH_NO_TX),
+	BRANCH_OPT("cond", PERF_SAMPLE_BRANCH_COND),
 	BRANCH_END
 };
 
@@ -988,6 +954,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	err = __cmd_record(&record, argc, argv);
 out_symbol_exit:
+	perf_evlist__delete(rec->evlist);
 	symbol__exit();
 	return err;
 }
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index c8f2113..21d830b 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -57,6 +57,7 @@ struct report {
 	const char		*cpu_list;
 	const char		*symbol_filter_str;
 	float			min_percent;
+	u64			nr_entries;
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 };
 
@@ -71,150 +72,69 @@ static int report__config(const char *var, const char *value, void *cb)
 		rep->min_percent = strtof(value, NULL);
 		return 0;
 	}
+	if (!strcmp(var, "report.children")) {
+		symbol_conf.cumulate_callchain = perf_config_bool(var, value);
+		return 0;
+	}
 
 	return perf_default_config(var, value, cb);
 }
 
-static int report__add_mem_hist_entry(struct report *rep, struct addr_location *al,
-				      struct perf_sample *sample, struct perf_evsel *evsel)
+static void report__inc_stats(struct report *rep, struct hist_entry *he)
 {
-	struct symbol *parent = NULL;
-	struct hist_entry *he;
-	struct mem_info *mi, *mx;
-	uint64_t cost;
-	int err = sample__resolve_callchain(sample, &parent, evsel, al, rep->max_stack);
-
-	if (err)
-		return err;
-
-	mi = sample__resolve_mem(sample, al);
-	if (!mi)
-		return -ENOMEM;
-
-	if (rep->hide_unresolved && !al->sym)
-		return 0;
-
-	cost = sample->weight;
-	if (!cost)
-		cost = 1;
-
 	/*
-	 * must pass period=weight in order to get the correct
-	 * sorting from hists__collapse_resort() which is solely
-	 * based on periods. We want sorting be done on nr_events * weight
-	 * and this is indirectly achieved by passing period=weight here
-	 * and the he_stat__add_period() function.
+	 * The @he is either of a newly created one or an existing one
+	 * merging current sample.  We only want to count a new one so
+	 * checking ->nr_events being 1.
 	 */
-	he = __hists__add_entry(&evsel->hists, al, parent, NULL, mi,
-				cost, cost, 0);
-	if (!he)
-		return -ENOMEM;
-
-	if (ui__has_annotation()) {
-		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
-		if (err)
-			goto out;
-
-		mx = he->mem_info;
-		err = addr_map_symbol__inc_samples(&mx->daddr, evsel->idx);
-		if (err)
-			goto out;
-	}
-
-	evsel->hists.stats.total_period += cost;
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-	err = hist_entry__append_callchain(he, sample);
-out:
-	return err;
+	if (he->stat.nr_events == 1)
+		rep->nr_entries++;
 }
 
-static int report__add_branch_hist_entry(struct report *rep, struct addr_location *al,
-					 struct perf_sample *sample, struct perf_evsel *evsel)
+static int hist_iter__report_callback(struct hist_entry_iter *iter,
+				      struct addr_location *al, bool single,
+				      void *arg)
 {
-	struct symbol *parent = NULL;
-	unsigned i;
-	struct hist_entry *he;
-	struct branch_info *bi, *bx;
-	int err = sample__resolve_callchain(sample, &parent, evsel, al, rep->max_stack);
-
-	if (err)
-		return err;
-
-	bi = sample__resolve_bstack(sample, al);
-	if (!bi)
-		return -ENOMEM;
-
-	for (i = 0; i < sample->branch_stack->nr; i++) {
-		if (rep->hide_unresolved && !(bi[i].from.sym && bi[i].to.sym))
-			continue;
+	int err = 0;
+	struct report *rep = arg;
+	struct hist_entry *he = iter->he;
+	struct perf_evsel *evsel = iter->evsel;
+	struct mem_info *mi;
+	struct branch_info *bi;
 
-		err = -ENOMEM;
+	report__inc_stats(rep, he);
 
-		/* overwrite the 'al' to branch-to info */
-		al->map = bi[i].to.map;
-		al->sym = bi[i].to.sym;
-		al->addr = bi[i].to.addr;
-		/*
-		 * The report shows the percentage of total branches captured
-		 * and not events sampled. Thus we use a pseudo period of 1.
-		 */
-		he = __hists__add_entry(&evsel->hists, al, parent, &bi[i], NULL,
-					1, 1, 0);
-		if (he) {
-			if (ui__has_annotation()) {
-				bx = he->branch_info;
-				err = addr_map_symbol__inc_samples(&bx->from,
-								   evsel->idx);
-				if (err)
-					goto out;
-
-				err = addr_map_symbol__inc_samples(&bx->to,
-								   evsel->idx);
-				if (err)
-					goto out;
-			}
+	if (!ui__has_annotation())
+		return 0;
 
-			evsel->hists.stats.total_period += 1;
-			hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-		} else
+	if (sort__mode == SORT_MODE__BRANCH) {
+		bi = he->branch_info;
+		err = addr_map_symbol__inc_samples(&bi->from, evsel->idx);
+		if (err)
 			goto out;
-	}
-	err = 0;
-out:
-	free(bi);
-	return err;
-}
 
-static int report__add_hist_entry(struct report *rep, struct perf_evsel *evsel,
-				  struct addr_location *al, struct perf_sample *sample)
-{
-	struct symbol *parent = NULL;
-	struct hist_entry *he;
-	int err = sample__resolve_callchain(sample, &parent, evsel, al, rep->max_stack);
-
-	if (err)
-		return err;
+		err = addr_map_symbol__inc_samples(&bi->to, evsel->idx);
 
-	he = __hists__add_entry(&evsel->hists, al, parent, NULL, NULL,
-				sample->period, sample->weight,
-				sample->transaction);
-	if (he == NULL)
-		return -ENOMEM;
+	} else if (rep->mem_mode) {
+		mi = he->mem_info;
+		err = addr_map_symbol__inc_samples(&mi->daddr, evsel->idx);
+		if (err)
+			goto out;
 
-	err = hist_entry__append_callchain(he, sample);
-	if (err)
-		goto out;
+		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
 
-	if (ui__has_annotation())
+	} else if (symbol_conf.cumulate_callchain) {
+		if (single)
+			err = hist_entry__inc_addr_samples(he, evsel->idx,
+							   al->addr);
+	} else {
 		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+	}
 
-	evsel->hists.stats.total_period += sample->period;
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
 out:
 	return err;
 }
 
-
 static int process_sample_event(struct perf_tool *tool,
 				union perf_event *event,
 				struct perf_sample *sample,
@@ -223,6 +143,10 @@ static int process_sample_event(struct perf_tool *tool,
 {
 	struct report *rep = container_of(tool, struct report, tool);
 	struct addr_location al;
+	struct hist_entry_iter iter = {
+		.hide_unresolved = rep->hide_unresolved,
+		.add_entry_cb = hist_iter__report_callback,
+	};
 	int ret;
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
@@ -237,22 +161,23 @@ static int process_sample_event(struct perf_tool *tool,
 	if (rep->cpu_list && !test_bit(sample->cpu, rep->cpu_bitmap))
 		return 0;
 
-	if (sort__mode == SORT_MODE__BRANCH) {
-		ret = report__add_branch_hist_entry(rep, &al, sample, evsel);
-		if (ret < 0)
-			pr_debug("problem adding lbr entry, skipping event\n");
-	} else if (rep->mem_mode == 1) {
-		ret = report__add_mem_hist_entry(rep, &al, sample, evsel);
-		if (ret < 0)
-			pr_debug("problem adding mem entry, skipping event\n");
-	} else {
-		if (al.map != NULL)
-			al.map->dso->hit = 1;
+	if (sort__mode == SORT_MODE__BRANCH)
+		iter.ops = &hist_iter_branch;
+	else if (rep->mem_mode)
+		iter.ops = &hist_iter_mem;
+	else if (symbol_conf.cumulate_callchain)
+		iter.ops = &hist_iter_cumulative;
+	else
+		iter.ops = &hist_iter_normal;
+
+	if (al.map != NULL)
+		al.map->dso->hit = 1;
+
+	ret = hist_entry_iter__add(&iter, &al, evsel, sample, rep->max_stack,
+				   rep);
+	if (ret < 0)
+		pr_debug("problem adding hist entry, skipping event\n");
 
-		ret = report__add_hist_entry(rep, evsel, &al, sample);
-		if (ret < 0)
-			pr_debug("problem incrementing symbol period, skipping event\n");
-	}
 	return ret;
 }
 
@@ -309,6 +234,14 @@ static int report__setup_sample_type(struct report *rep)
 			}
 	}
 
+	if (symbol_conf.cumulate_callchain) {
+		/* Silently ignore if callchain is missing */
+		if (!(sample_type & PERF_SAMPLE_CALLCHAIN)) {
+			symbol_conf.cumulate_callchain = false;
+			perf_hpp__cancel_cumulate();
+		}
+	}
+
 	if (sort__mode == SORT_MODE__BRANCH) {
 		if (!is_pipe &&
 		    !(sample_type & PERF_SAMPLE_BRANCH_STACK)) {
@@ -337,6 +270,11 @@ static size_t hists__fprintf_nr_sample_events(struct hists *hists, struct report
 	char buf[512];
 	size_t size = sizeof(buf);
 
+	if (symbol_conf.filter_relative) {
+		nr_samples = hists->stats.nr_non_filtered_samples;
+		nr_events = hists->stats.total_non_filtered_period;
+	}
+
 	if (perf_evsel__is_group_event(evsel)) {
 		struct perf_evsel *pos;
 
@@ -344,8 +282,13 @@ static size_t hists__fprintf_nr_sample_events(struct hists *hists, struct report
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
 
@@ -470,24 +413,12 @@ static int report__browse_hists(struct report *rep)
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
@@ -496,7 +427,6 @@ static u64 report__collapse_hists(struct report *rep)
 			hists->symbol_filter_str = rep->symbol_filter_str;
 
 		hists__collapse_resort(hists, &prog);
-		nr_samples += hists->stats.nr_events[PERF_RECORD_SAMPLE];
 
 		/* Non-group events are considered as leader */
 		if (symbol_conf.event_group &&
@@ -509,14 +439,11 @@ static u64 report__collapse_hists(struct report *rep)
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
@@ -556,12 +483,12 @@ static int __cmd_report(struct report *rep)
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
@@ -573,11 +500,9 @@ static int __cmd_report(struct report *rep)
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
@@ -587,80 +512,7 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
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
@@ -760,10 +612,10 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
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
@@ -772,7 +624,9 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Only display entries with parent-match"),
 	OPT_CALLBACK_DEFAULT('g', "call-graph", &report, "output_type,min_percent[,print_limit],call_order",
 		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold, optional print limit, callchain order, key (function or address). "
-		     "Default: fractal,0.5,callee,function", &parse_callchain_opt, callchain_default_opt),
+		     "Default: fractal,0.5,callee,function", &report_parse_callchain_opt, callchain_default_opt),
+	OPT_BOOLEAN(0, "children", &symbol_conf.cumulate_callchain,
+		    "Accumulate callchains of children and show total overhead as well"),
 	OPT_INTEGER(0, "max-stack", &report.max_stack,
 		    "Set the maximum stack depth when parsing the callchain, "
 		    "anything beyond the specified depth will be ignored. "
@@ -823,6 +677,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "mem-mode", &report.mem_mode, "mem access profile"),
 	OPT_CALLBACK(0, "percent-limit", &report, "percent",
 		     "Don't show entries under that percent", parse_percent_limit),
+	OPT_CALLBACK(0, "percentage", NULL, "relative|absolute",
+		     "how to display percentage of filtered entries", parse_filter_percentage),
 	OPT_END()
 	};
 	struct perf_data_file file = {
@@ -863,55 +719,37 @@ repeat:
 	has_br_stack = perf_header__has_feat(&session->header,
 					     HEADER_BRANCH_STACK);
 
-	if (branch_mode == -1 && has_br_stack)
+	if (branch_mode == -1 && has_br_stack) {
 		sort__mode = SORT_MODE__BRANCH;
-
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
+		symbol_conf.cumulate_callchain = false;
 	}
+
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
+		symbol_conf.cumulate_callchain = false;
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
index 9ac0a49..c38d06c 100644
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
 
@@ -1425,7 +1428,7 @@ static int perf_sched__process_tracepoint_sample(struct perf_tool *tool __maybe_
 	int err = 0;
 
 	evsel->hists.stats.total_period += sample->period;
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+	hists__inc_nr_samples(&evsel->hists, true);
 
 	if (evsel->handler != NULL) {
 		tracepoint_handler f = evsel->handler;
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
index 65aaa5b..377971d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -196,6 +196,12 @@ static void perf_top__record_precise_ip(struct perf_top *top,
 
 	pthread_mutex_unlock(&notes->lock);
 
+	/*
+	 * This function is now called with he->hists->lock held.
+	 * Release it before going to sleep.
+	 */
+	pthread_mutex_unlock(&he->hists->lock);
+
 	if (err == -ERANGE && !he->ms.map->erange_warned)
 		ui__warn_map_erange(he->ms.map, sym, ip);
 	else if (err == -ENOMEM) {
@@ -203,6 +209,8 @@ static void perf_top__record_precise_ip(struct perf_top *top,
 		       sym->name);
 		sleep(1);
 	}
+
+	pthread_mutex_lock(&he->hists->lock);
 }
 
 static void perf_top__show_details(struct perf_top *top)
@@ -238,24 +246,6 @@ out_unlock:
 	pthread_mutex_unlock(&notes->lock);
 }
 
-static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
-						     struct addr_location *al,
-						     struct perf_sample *sample)
-{
-	struct hist_entry *he;
-
-	pthread_mutex_lock(&evsel->hists.lock);
-	he = __hists__add_entry(&evsel->hists, al, NULL, NULL, NULL,
-				sample->period, sample->weight,
-				sample->transaction);
-	pthread_mutex_unlock(&evsel->hists.lock);
-	if (he == NULL)
-		return NULL;
-
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-	return he;
-}
-
 static void perf_top__print_sym_table(struct perf_top *top)
 {
 	char bf[160];
@@ -659,6 +649,26 @@ static int symbol_filter(struct map *map __maybe_unused, struct symbol *sym)
 	return 0;
 }
 
+static int hist_iter__top_callback(struct hist_entry_iter *iter,
+				   struct addr_location *al, bool single,
+				   void *arg)
+{
+	struct perf_top *top = arg;
+	struct hist_entry *he = iter->he;
+	struct perf_evsel *evsel = iter->evsel;
+
+	if (sort__has_sym && single) {
+		u64 ip = al->addr;
+
+		if (al->map)
+			ip = al->map->unmap_ip(al->map, ip);
+
+		perf_top__record_precise_ip(top, he, evsel->idx, ip);
+	}
+
+	return 0;
+}
+
 static void perf_event__process_sample(struct perf_tool *tool,
 				       const union perf_event *event,
 				       struct perf_evsel *evsel,
@@ -666,8 +676,6 @@ static void perf_event__process_sample(struct perf_tool *tool,
 				       struct machine *machine)
 {
 	struct perf_top *top = container_of(tool, struct perf_top, tool);
-	struct symbol *parent = NULL;
-	u64 ip = sample->ip;
 	struct addr_location al;
 	int err;
 
@@ -694,8 +702,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
 	if (event->header.misc & PERF_RECORD_MISC_EXACT_IP)
 		top->exact_samples++;
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0 ||
-	    al.filtered)
+	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0)
 		return;
 
 	if (!top->kptr_restrict_warned &&
@@ -743,25 +750,23 @@ static void perf_event__process_sample(struct perf_tool *tool,
 	}
 
 	if (al.sym == NULL || !al.sym->ignore) {
-		struct hist_entry *he;
+		struct hist_entry_iter iter = {
+			.add_entry_cb = hist_iter__top_callback,
+		};
 
-		err = sample__resolve_callchain(sample, &parent, evsel, &al,
-						top->max_stack);
-		if (err)
-			return;
+		if (symbol_conf.cumulate_callchain)
+			iter.ops = &hist_iter_cumulative;
+		else
+			iter.ops = &hist_iter_normal;
 
-		he = perf_evsel__add_hist_entry(evsel, &al, sample);
-		if (he == NULL) {
-			pr_err("Problem incrementing symbol period, skipping event\n");
-			return;
-		}
+		pthread_mutex_lock(&evsel->hists.lock);
 
-		err = hist_entry__append_callchain(he, sample);
-		if (err)
-			return;
+		err = hist_entry_iter__add(&iter, &al, evsel, sample,
+					   top->max_stack, top);
+		if (err < 0)
+			pr_err("Problem incrementing symbol period, skipping event\n");
 
-		if (sort__has_sym)
-			perf_top__record_precise_ip(top, he, evsel->idx, ip);
+		pthread_mutex_unlock(&evsel->hists.lock);
 	}
 
 	return;
@@ -999,6 +1004,10 @@ static int perf_top_config(const char *var, const char *value, void *cb)
 
 	if (!strcmp(var, "top.call-graph"))
 		return record_parse_callchain(value, &top->record_opts);
+	if (!strcmp(var, "top.children")) {
+		symbol_conf.cumulate_callchain = perf_config_bool(var, value);
+		return 0;
+	}
 
 	return perf_default_config(var, value, cb);
 }
@@ -1081,8 +1090,10 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
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
@@ -1091,6 +1102,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_CALLBACK(0, "call-graph", &top.record_opts,
 		     "mode[,dump_size]", record_callchain_help,
 		     &parse_callchain_opt),
+	OPT_BOOLEAN(0, "children", &symbol_conf.cumulate_callchain,
+		    "Accumulate callchains of children and show total overhead as well"),
 	OPT_INTEGER(0, "max-stack", &top.max_stack,
 		    "Set the maximum stack depth when parsing the callchain. "
 		    "Default: " __stringify(PERF_MAX_STACK_DEPTH)),
@@ -1116,6 +1129,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_STRING('u', "uid", &target->uid_str, "user", "user to profile"),
 	OPT_CALLBACK(0, "percent-limit", &top, "percent",
 		     "Don't show entries under that percent", parse_percent_limit),
+	OPT_CALLBACK(0, "percentage", NULL, "relative|absolute",
+		     "How to display percentage of filtered entries", parse_filter_percentage),
 	OPT_END()
 	};
 	const char * const top_usage[] = {
@@ -1133,17 +1148,19 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
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
@@ -1192,6 +1209,11 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	top.sym_evsel = perf_evlist__first(top.evlist);
 
+	if (!symbol_conf.use_callchain) {
+		symbol_conf.cumulate_callchain = false;
+		perf_hpp__cancel_cumulate();
+	}
+
 	symbol_conf.priv_size = sizeof(struct annotation);
 
 	symbol_conf.try_vmlinux_path = (symbol_conf.vmlinux_name == NULL);
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 802cf54..4f100b5 100644
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
@@ -443,6 +447,7 @@ else
   ifneq ($(feature-libperl), 1)
     CFLAGS += -DNO_LIBPERL
     NO_LIBPERL := 1
+    msg := $(warning Missing perl devel files. Disabling perl scripting support, consider installing perl-ExtUtils-Embed);
   else
     LDFLAGS += $(PERL_EMBED_LDFLAGS)
     EXTLIBS += $(PERL_EMBED_LIBADD)
@@ -565,12 +570,6 @@ ifneq ($(filter -lbfd,$(EXTLIBS)),)
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
@@ -601,7 +600,7 @@ endif
 
 # Make the path relative to DESTDIR, not to prefix
 ifndef DESTDIR
-prefix = $(HOME)
+prefix ?= $(HOME)
 endif
 bindir_relative = bin
 bindir = $(prefix)/$(bindir_relative)
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
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 431798a..78f7b92 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -481,14 +481,18 @@ int main(int argc, const char **argv)
 		fprintf(stderr, "cannot handle %s internally", cmd);
 		goto out;
 	}
-#ifdef HAVE_LIBAUDIT_SUPPORT
 	if (!prefixcmp(cmd, "trace")) {
+#ifdef HAVE_LIBAUDIT_SUPPORT
 		set_buildid_dir();
 		setup_path();
 		argv[0] = "trace";
 		return cmd_trace(argc, argv, NULL);
-	}
+#else
+		fprintf(stderr,
+			"trace command not available: missing audit-libs devel package at build time.\n");
+		goto out;
 #endif
+	}
 	/* Look for flags.. */
 	argv++;
 	argc--;
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
index b11bf8a..802e3cd 100644
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
@@ -124,6 +124,26 @@ static struct test {
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
+		.desc = "Test cumulation of child hist entries",
+		.func = test__hists_cumulate,
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
index 0000000..a62c091
--- /dev/null
+++ b/tools/perf/tests/hists_common.c
@@ -0,0 +1,209 @@
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
+	{ FAKE_PID_PERF1, "perf" },
+	{ FAKE_PID_PERF2, "perf" },
+	{ FAKE_PID_BASH,  "bash" },
+};
+
+static struct {
+	u32 pid;
+	u64 start;
+	const char *filename;
+} fake_mmap_info[] = {
+	{ FAKE_PID_PERF1, FAKE_MAP_PERF,   "perf" },
+	{ FAKE_PID_PERF1, FAKE_MAP_LIBC,   "libc" },
+	{ FAKE_PID_PERF1, FAKE_MAP_KERNEL, "[kernel]" },
+	{ FAKE_PID_PERF2, FAKE_MAP_PERF,   "perf" },
+	{ FAKE_PID_PERF2, FAKE_MAP_LIBC,   "libc" },
+	{ FAKE_PID_PERF2, FAKE_MAP_KERNEL, "[kernel]" },
+	{ FAKE_PID_BASH,  FAKE_MAP_BASH,   "bash" },
+	{ FAKE_PID_BASH,  FAKE_MAP_LIBC,   "libc" },
+	{ FAKE_PID_BASH,  FAKE_MAP_KERNEL, "[kernel]" },
+};
+
+struct fake_sym {
+	u64 start;
+	u64 length;
+	const char *name;
+};
+
+static struct fake_sym perf_syms[] = {
+	{ FAKE_SYM_OFFSET1, FAKE_SYM_LENGTH, "main" },
+	{ FAKE_SYM_OFFSET2, FAKE_SYM_LENGTH, "run_command" },
+	{ FAKE_SYM_OFFSET3, FAKE_SYM_LENGTH, "cmd_record" },
+};
+
+static struct fake_sym bash_syms[] = {
+	{ FAKE_SYM_OFFSET1, FAKE_SYM_LENGTH, "main" },
+	{ FAKE_SYM_OFFSET2, FAKE_SYM_LENGTH, "xmalloc" },
+	{ FAKE_SYM_OFFSET3, FAKE_SYM_LENGTH, "xfree" },
+};
+
+static struct fake_sym libc_syms[] = {
+	{ 700, 100, "malloc" },
+	{ 800, 100, "free" },
+	{ 900, 100, "realloc" },
+	{ FAKE_SYM_OFFSET1, FAKE_SYM_LENGTH, "malloc" },
+	{ FAKE_SYM_OFFSET2, FAKE_SYM_LENGTH, "free" },
+	{ FAKE_SYM_OFFSET3, FAKE_SYM_LENGTH, "realloc" },
+};
+
+static struct fake_sym kernel_syms[] = {
+	{ FAKE_SYM_OFFSET1, FAKE_SYM_LENGTH, "schedule" },
+	{ FAKE_SYM_OFFSET2, FAKE_SYM_LENGTH, "page_fault" },
+	{ FAKE_SYM_OFFSET3, FAKE_SYM_LENGTH, "sys_perf_event_open" },
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
+				.len = FAKE_MAP_LENGTH,
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
+			pr_info("%2d: entry: %8s:%5d [%-8s] %20s: period = %"PRIu64"/%"PRIu64"\n",
+				i, thread__comm_str(he->thread), he->thread->tid,
+				he->ms.map->dso->short_name,
+				he->ms.sym->name, he->stat.period,
+				he->stat_acc ? he->stat_acc->period : 0);
+		}
+
+		i++;
+		node = rb_next(node);
+	}
+}
diff --git a/tools/perf/tests/hists_common.h b/tools/perf/tests/hists_common.h
new file mode 100644
index 0000000..888254e
--- /dev/null
+++ b/tools/perf/tests/hists_common.h
@@ -0,0 +1,75 @@
+#ifndef __PERF_TESTS__HISTS_COMMON_H__
+#define __PERF_TESTS__HISTS_COMMON_H__
+
+struct machine;
+struct machines;
+
+#define FAKE_PID_PERF1  100
+#define FAKE_PID_PERF2  200
+#define FAKE_PID_BASH   300
+
+#define FAKE_MAP_PERF    0x400000
+#define FAKE_MAP_BASH    0x400000
+#define FAKE_MAP_LIBC    0x500000
+#define FAKE_MAP_KERNEL  0xf00000
+#define FAKE_MAP_LENGTH  0x100000
+
+#define FAKE_SYM_OFFSET1  700
+#define FAKE_SYM_OFFSET2  800
+#define FAKE_SYM_OFFSET3  900
+#define FAKE_SYM_LENGTH   100
+
+#define FAKE_IP_PERF_MAIN  FAKE_MAP_PERF + FAKE_SYM_OFFSET1
+#define FAKE_IP_PERF_RUN_COMMAND  FAKE_MAP_PERF + FAKE_SYM_OFFSET2
+#define FAKE_IP_PERF_CMD_RECORD  FAKE_MAP_PERF + FAKE_SYM_OFFSET3
+#define FAKE_IP_BASH_MAIN  FAKE_MAP_BASH + FAKE_SYM_OFFSET1
+#define FAKE_IP_BASH_XMALLOC  FAKE_MAP_BASH + FAKE_SYM_OFFSET2
+#define FAKE_IP_BASH_XFREE  FAKE_MAP_BASH + FAKE_SYM_OFFSET3
+#define FAKE_IP_LIBC_MALLOC  FAKE_MAP_LIBC + FAKE_SYM_OFFSET1
+#define FAKE_IP_LIBC_FREE  FAKE_MAP_LIBC + FAKE_SYM_OFFSET2
+#define FAKE_IP_LIBC_REALLOC  FAKE_MAP_LIBC + FAKE_SYM_OFFSET3
+#define FAKE_IP_KERNEL_SCHEDULE  FAKE_MAP_KERNEL + FAKE_SYM_OFFSET1
+#define FAKE_IP_KERNEL_PAGE_FAULT  FAKE_MAP_KERNEL + FAKE_SYM_OFFSET2
+#define FAKE_IP_KERNEL_SYS_PERF_EVENT_OPEN  FAKE_MAP_KERNEL + FAKE_SYM_OFFSET3
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
+ *    perf:  100           perf  cmd_record
+ *    perf:  100           libc  malloc
+ *    perf:  100           libc  free
+ *    perf:  100           libc  realloc
+ *    perf:  100       [kernel]  schedule
+ *    perf:  100       [kernel]  page_fault
+ *    perf:  100       [kernel]  sys_perf_event_open
+ *    perf:  200           perf  main
+ *    perf:  200           perf  run_command
+ *    perf:  200           perf  cmd_record
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
diff --git a/tools/perf/tests/hists_cumulate.c b/tools/perf/tests/hists_cumulate.c
new file mode 100644
index 0000000..0ac240d
--- /dev/null
+++ b/tools/perf/tests/hists_cumulate.c
@@ -0,0 +1,726 @@
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
+	{ .pid = FAKE_PID_PERF1, .ip = FAKE_IP_KERNEL_SCHEDULE, },
+	/* perf [perf]   main() */
+	{ .pid = FAKE_PID_PERF1, .ip = FAKE_IP_PERF_MAIN, },
+	/* perf [perf]   cmd_record() */
+	{ .pid = FAKE_PID_PERF1, .ip = FAKE_IP_PERF_CMD_RECORD, },
+	/* perf [libc]   malloc() */
+	{ .pid = FAKE_PID_PERF1, .ip = FAKE_IP_LIBC_MALLOC, },
+	/* perf [libc]   free() */
+	{ .pid = FAKE_PID_PERF1, .ip = FAKE_IP_LIBC_FREE, },
+	/* perf [perf]   main() */
+	{ .pid = FAKE_PID_PERF2, .ip = FAKE_IP_PERF_MAIN, },
+	/* perf [kernel] page_fault() */
+	{ .pid = FAKE_PID_PERF2, .ip = FAKE_IP_KERNEL_PAGE_FAULT, },
+	/* bash [bash]   main() */
+	{ .pid = FAKE_PID_BASH,  .ip = FAKE_IP_BASH_MAIN, },
+	/* bash [bash]   xmalloc() */
+	{ .pid = FAKE_PID_BASH,  .ip = FAKE_IP_BASH_XMALLOC, },
+	/* bash [kernel] page_fault() */
+	{ .pid = FAKE_PID_BASH,  .ip = FAKE_IP_KERNEL_PAGE_FAULT, },
+};
+
+/*
+ * Will be casted to struct ip_callchain which has all 64 bit entries
+ * of nr and ips[].
+ */
+static u64 fake_callchains[][10] = {
+	/*   schedule => run_command => main */
+	{ 3, FAKE_IP_KERNEL_SCHEDULE, FAKE_IP_PERF_RUN_COMMAND, FAKE_IP_PERF_MAIN, },
+	/*   main  */
+	{ 1, FAKE_IP_PERF_MAIN, },
+	/*   cmd_record => run_command => main */
+	{ 3, FAKE_IP_PERF_CMD_RECORD, FAKE_IP_PERF_RUN_COMMAND, FAKE_IP_PERF_MAIN, },
+	/*   malloc => cmd_record => run_command => main */
+	{ 4, FAKE_IP_LIBC_MALLOC, FAKE_IP_PERF_CMD_RECORD, FAKE_IP_PERF_RUN_COMMAND,
+	     FAKE_IP_PERF_MAIN, },
+	/*   free => cmd_record => run_command => main */
+	{ 4, FAKE_IP_LIBC_FREE, FAKE_IP_PERF_CMD_RECORD, FAKE_IP_PERF_RUN_COMMAND,
+	     FAKE_IP_PERF_MAIN, },
+	/*   main */
+	{ 1, FAKE_IP_PERF_MAIN, },
+	/*   page_fault => sys_perf_event_open => run_command => main */
+	{ 4, FAKE_IP_KERNEL_PAGE_FAULT, FAKE_IP_KERNEL_SYS_PERF_EVENT_OPEN,
+	     FAKE_IP_PERF_RUN_COMMAND, FAKE_IP_PERF_MAIN, },
+	/*   main */
+	{ 1, FAKE_IP_BASH_MAIN, },
+	/*   xmalloc => malloc => xmalloc => malloc => xmalloc => main */
+	{ 6, FAKE_IP_BASH_XMALLOC, FAKE_IP_LIBC_MALLOC, FAKE_IP_BASH_XMALLOC,
+	     FAKE_IP_LIBC_MALLOC, FAKE_IP_BASH_XMALLOC, FAKE_IP_BASH_MAIN, },
+	/*   page_fault => malloc => main */
+	{ 3, FAKE_IP_KERNEL_PAGE_FAULT, FAKE_IP_LIBC_MALLOC, FAKE_IP_BASH_MAIN, },
+};
+
+static int add_hist_entries(struct hists *hists, struct machine *machine)
+{
+	struct addr_location al;
+	struct perf_evsel *evsel = hists_to_evsel(hists);
+	struct perf_sample sample = { .period = 1000, };
+	size_t i;
+
+	for (i = 0; i < ARRAY_SIZE(fake_samples); i++) {
+		const union perf_event event = {
+			.header = {
+				.misc = PERF_RECORD_MISC_USER,
+			},
+		};
+		struct hist_entry_iter iter = {
+			.hide_unresolved = false,
+		};
+
+		if (symbol_conf.cumulate_callchain)
+			iter.ops = &hist_iter_cumulative;
+		else
+			iter.ops = &hist_iter_normal;
+
+		sample.pid = fake_samples[i].pid;
+		sample.tid = fake_samples[i].pid;
+		sample.ip = fake_samples[i].ip;
+		sample.callchain = (struct ip_callchain *)fake_callchains[i];
+
+		if (perf_event__preprocess_sample(&event, machine, &al,
+						  &sample) < 0)
+			goto out;
+
+		if (hist_entry_iter__add(&iter, &al, evsel, &sample,
+					 PERF_MAX_STACK_DEPTH, NULL) < 0)
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
+#define DEPTH(he) (he->callchain->max_depth)
+#define CDSO(cl)  (cl->ms.map->dso->short_name)
+#define CSYM(cl)  (cl->ms.sym->name)
+
+struct result {
+	u64 children;
+	u64 self;
+	const char *comm;
+	const char *dso;
+	const char *sym;
+};
+
+struct callchain_result {
+	u64 nr;
+	struct {
+		const char *dso;
+		const char *sym;
+	} node[10];
+};
+
+static int do_test(struct hists *hists, struct result *expected, size_t nr_expected,
+		   struct callchain_result *expected_callchain, size_t nr_callchain)
+{
+	char buf[32];
+	size_t i, c;
+	struct hist_entry *he;
+	struct rb_root *root;
+	struct rb_node *node;
+	struct callchain_node *cnode;
+	struct callchain_list *clist;
+
+	/*
+	 * adding and deleting hist entries must be done outside of this
+	 * function since TEST_ASSERT_VAL() returns in case of failure.
+	 */
+	hists__collapse_resort(hists, NULL);
+	hists__output_resort(hists);
+
+	if (verbose > 2) {
+		pr_info("use callchain: %d, cumulate callchain: %d\n",
+			symbol_conf.use_callchain,
+			symbol_conf.cumulate_callchain);
+		print_hists_out(hists);
+	}
+
+	root = &hists->entries;
+	for (node = rb_first(root), i = 0;
+	     node && (he = rb_entry(node, struct hist_entry, rb_node));
+	     node = rb_next(node), i++) {
+		scnprintf(buf, sizeof(buf), "Invalid hist entry #%zd", i);
+
+		TEST_ASSERT_VAL("Incorrect number of hist entry",
+				i < nr_expected);
+		TEST_ASSERT_VAL(buf, he->stat.period == expected[i].self &&
+				!strcmp(COMM(he), expected[i].comm) &&
+				!strcmp(DSO(he), expected[i].dso) &&
+				!strcmp(SYM(he), expected[i].sym));
+
+		if (symbol_conf.cumulate_callchain)
+			TEST_ASSERT_VAL(buf, he->stat_acc->period == expected[i].children);
+
+		if (!symbol_conf.use_callchain)
+			continue;
+
+		/* check callchain entries */
+		root = &he->callchain->node.rb_root;
+		cnode = rb_entry(rb_first(root), struct callchain_node, rb_node);
+
+		c = 0;
+		list_for_each_entry(clist, &cnode->val, list) {
+			scnprintf(buf, sizeof(buf), "Invalid callchain entry #%zd/%zd", i, c);
+
+			TEST_ASSERT_VAL("Incorrect number of callchain entry",
+					c < expected_callchain[i].nr);
+			TEST_ASSERT_VAL(buf,
+				!strcmp(CDSO(clist), expected_callchain[i].node[c].dso) &&
+				!strcmp(CSYM(clist), expected_callchain[i].node[c].sym));
+			c++;
+		}
+		/* TODO: handle multiple child nodes properly */
+		TEST_ASSERT_VAL("Incorrect number of callchain entry",
+				c <= expected_callchain[i].nr);
+	}
+	TEST_ASSERT_VAL("Incorrect number of hist entry",
+			i == nr_expected);
+	TEST_ASSERT_VAL("Incorrect number of callchain entry",
+			!symbol_conf.use_callchain || nr_expected == nr_callchain);
+	return 0;
+}
+
+/* NO callchain + NO children */
+static int test1(struct perf_evsel *evsel, struct machine *machine)
+{
+	int err;
+	struct hists *hists = &evsel->hists;
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
+	struct result expected[] = {
+		{ 0, 2000, "perf", "perf",     "main" },
+		{ 0, 1000, "bash", "[kernel]", "page_fault" },
+		{ 0, 1000, "bash", "bash",     "main" },
+		{ 0, 1000, "bash", "bash",     "xmalloc" },
+		{ 0, 1000, "perf", "[kernel]", "page_fault" },
+		{ 0, 1000, "perf", "[kernel]", "schedule" },
+		{ 0, 1000, "perf", "libc",     "free" },
+		{ 0, 1000, "perf", "libc",     "malloc" },
+		{ 0, 1000, "perf", "perf",     "cmd_record" },
+	};
+
+	symbol_conf.use_callchain = false;
+	symbol_conf.cumulate_callchain = false;
+
+	setup_sorting();
+	callchain_register_param(&callchain_param);
+
+	err = add_hist_entries(hists, machine);
+	if (err < 0)
+		goto out;
+
+	err = do_test(hists, expected, ARRAY_SIZE(expected), NULL, 0);
+
+out:
+	del_hist_entries(hists);
+	reset_output_field();
+	return err;
+}
+
+/* callcain + NO children */
+static int test2(struct perf_evsel *evsel, struct machine *machine)
+{
+	int err;
+	struct hists *hists = &evsel->hists;
+	/*
+	 * expected output:
+	 *
+	 * Overhead  Command  Shared Object          Symbol
+	 * ========  =======  =============  ==============
+	 *   20.00%     perf  perf           [.] main
+	 *              |
+	 *              --- main
+	 *
+	 *   10.00%     bash  [kernel]       [k] page_fault
+	 *              |
+	 *              --- page_fault
+	 *                  malloc
+	 *                  main
+	 *
+	 *   10.00%     bash  bash           [.] main
+	 *              |
+	 *              --- main
+	 *
+	 *   10.00%     bash  bash           [.] xmalloc
+	 *              |
+	 *              --- xmalloc
+	 *                  malloc
+	 *                  xmalloc     <--- NOTE: there's a cycle
+	 *                  malloc
+	 *                  xmalloc
+	 *                  main
+	 *
+	 *   10.00%     perf  [kernel]       [k] page_fault
+	 *              |
+	 *              --- page_fault
+	 *                  sys_perf_event_open
+	 *                  run_command
+	 *                  main
+	 *
+	 *   10.00%     perf  [kernel]       [k] schedule
+	 *              |
+	 *              --- schedule
+	 *                  run_command
+	 *                  main
+	 *
+	 *   10.00%     perf  libc           [.] free
+	 *              |
+	 *              --- free
+	 *                  cmd_record
+	 *                  run_command
+	 *                  main
+	 *
+	 *   10.00%     perf  libc           [.] malloc
+	 *              |
+	 *              --- malloc
+	 *                  cmd_record
+	 *                  run_command
+	 *                  main
+	 *
+	 *   10.00%     perf  perf           [.] cmd_record
+	 *              |
+	 *              --- cmd_record
+	 *                  run_command
+	 *                  main
+	 *
+	 */
+	struct result expected[] = {
+		{ 0, 2000, "perf", "perf",     "main" },
+		{ 0, 1000, "bash", "[kernel]", "page_fault" },
+		{ 0, 1000, "bash", "bash",     "main" },
+		{ 0, 1000, "bash", "bash",     "xmalloc" },
+		{ 0, 1000, "perf", "[kernel]", "page_fault" },
+		{ 0, 1000, "perf", "[kernel]", "schedule" },
+		{ 0, 1000, "perf", "libc",     "free" },
+		{ 0, 1000, "perf", "libc",     "malloc" },
+		{ 0, 1000, "perf", "perf",     "cmd_record" },
+	};
+	struct callchain_result expected_callchain[] = {
+		{
+			1, {	{ "perf",     "main" }, },
+		},
+		{
+			3, {	{ "[kernel]", "page_fault" },
+				{ "libc",     "malloc" },
+				{ "bash",     "main" }, },
+		},
+		{
+			1, {	{ "bash",     "main" }, },
+		},
+		{
+			6, {	{ "bash",     "xmalloc" },
+				{ "libc",     "malloc" },
+				{ "bash",     "xmalloc" },
+				{ "libc",     "malloc" },
+				{ "bash",     "xmalloc" },
+				{ "bash",     "main" }, },
+		},
+		{
+			4, {	{ "[kernel]", "page_fault" },
+				{ "[kernel]", "sys_perf_event_open" },
+				{ "perf",     "run_command" },
+				{ "perf",     "main" }, },
+		},
+		{
+			3, {	{ "[kernel]", "schedule" },
+				{ "perf",     "run_command" },
+				{ "perf",     "main" }, },
+		},
+		{
+			4, {	{ "libc",     "free" },
+				{ "perf",     "cmd_record" },
+				{ "perf",     "run_command" },
+				{ "perf",     "main" }, },
+		},
+		{
+			4, {	{ "libc",     "malloc" },
+				{ "perf",     "cmd_record" },
+				{ "perf",     "run_command" },
+				{ "perf",     "main" }, },
+		},
+		{
+			3, {	{ "perf",     "cmd_record" },
+				{ "perf",     "run_command" },
+				{ "perf",     "main" }, },
+		},
+	};
+
+	symbol_conf.use_callchain = true;
+	symbol_conf.cumulate_callchain = false;
+
+	setup_sorting();
+	callchain_register_param(&callchain_param);
+
+	err = add_hist_entries(hists, machine);
+	if (err < 0)
+		goto out;
+
+	err = do_test(hists, expected, ARRAY_SIZE(expected),
+		      expected_callchain, ARRAY_SIZE(expected_callchain));
+
+out:
+	del_hist_entries(hists);
+	reset_output_field();
+	return err;
+}
+
+/* NO callchain + children */
+static int test3(struct perf_evsel *evsel, struct machine *machine)
+{
+	int err;
+	struct hists *hists = &evsel->hists;
+	/*
+	 * expected output:
+	 *
+	 * Children      Self  Command  Shared Object                   Symbol
+	 * ========  ========  =======  =============  =======================
+	 *   70.00%    20.00%     perf  perf           [.] main
+	 *   50.00%     0.00%     perf  perf           [.] run_command
+	 *   30.00%    10.00%     bash  bash           [.] main
+	 *   30.00%    10.00%     perf  perf           [.] cmd_record
+	 *   20.00%     0.00%     bash  libc           [.] malloc
+	 *   10.00%    10.00%     bash  [kernel]       [k] page_fault
+	 *   10.00%    10.00%     perf  [kernel]       [k] schedule
+	 *   10.00%     0.00%     perf  [kernel]       [k] sys_perf_event_open
+	 *   10.00%    10.00%     perf  [kernel]       [k] page_fault
+	 *   10.00%    10.00%     perf  libc           [.] free
+	 *   10.00%    10.00%     perf  libc           [.] malloc
+	 *   10.00%    10.00%     bash  bash           [.] xmalloc
+	 */
+	struct result expected[] = {
+		{ 7000, 2000, "perf", "perf",     "main" },
+		{ 5000,    0, "perf", "perf",     "run_command" },
+		{ 3000, 1000, "bash", "bash",     "main" },
+		{ 3000, 1000, "perf", "perf",     "cmd_record" },
+		{ 2000,    0, "bash", "libc",     "malloc" },
+		{ 1000, 1000, "bash", "[kernel]", "page_fault" },
+		{ 1000, 1000, "perf", "[kernel]", "schedule" },
+		{ 1000,    0, "perf", "[kernel]", "sys_perf_event_open" },
+		{ 1000, 1000, "perf", "[kernel]", "page_fault" },
+		{ 1000, 1000, "perf", "libc",     "free" },
+		{ 1000, 1000, "perf", "libc",     "malloc" },
+		{ 1000, 1000, "bash", "bash",     "xmalloc" },
+	};
+
+	symbol_conf.use_callchain = false;
+	symbol_conf.cumulate_callchain = true;
+
+	setup_sorting();
+	callchain_register_param(&callchain_param);
+
+	err = add_hist_entries(hists, machine);
+	if (err < 0)
+		goto out;
+
+	err = do_test(hists, expected, ARRAY_SIZE(expected), NULL, 0);
+
+out:
+	del_hist_entries(hists);
+	reset_output_field();
+	return err;
+}
+
+/* callchain + children */
+static int test4(struct perf_evsel *evsel, struct machine *machine)
+{
+	int err;
+	struct hists *hists = &evsel->hists;
+	/*
+	 * expected output:
+	 *
+	 * Children      Self  Command  Shared Object                   Symbol
+	 * ========  ========  =======  =============  =======================
+	 *   70.00%    20.00%     perf  perf           [.] main
+	 *              |
+	 *              --- main
+	 *
+	 *   50.00%     0.00%     perf  perf           [.] run_command
+	 *              |
+	 *              --- run_command
+	 *                  main
+	 *
+	 *   30.00%    10.00%     bash  bash           [.] main
+	 *              |
+	 *              --- main
+	 *
+	 *   30.00%    10.00%     perf  perf           [.] cmd_record
+	 *              |
+	 *              --- cmd_record
+	 *                  run_command
+	 *                  main
+	 *
+	 *   20.00%     0.00%     bash  libc           [.] malloc
+	 *              |
+	 *              --- malloc
+	 *                 |
+	 *                 |--50.00%-- xmalloc
+	 *                 |           main
+	 *                  --50.00%-- main
+	 *
+	 *   10.00%    10.00%     bash  [kernel]       [k] page_fault
+	 *              |
+	 *              --- page_fault
+	 *                  malloc
+	 *                  main
+	 *
+	 *   10.00%    10.00%     perf  [kernel]       [k] schedule
+	 *              |
+	 *              --- schedule
+	 *                  run_command
+	 *                  main
+	 *
+	 *   10.00%     0.00%     perf  [kernel]       [k] sys_perf_event_open
+	 *              |
+	 *              --- sys_perf_event_open
+	 *                  run_command
+	 *                  main
+	 *
+	 *   10.00%    10.00%     perf  [kernel]       [k] page_fault
+	 *              |
+	 *              --- page_fault
+	 *                  sys_perf_event_open
+	 *                  run_command
+	 *                  main
+	 *
+	 *   10.00%    10.00%     perf  libc           [.] free
+	 *              |
+	 *              --- free
+	 *                  cmd_record
+	 *                  run_command
+	 *                  main
+	 *
+	 *   10.00%    10.00%     perf  libc           [.] malloc
+	 *              |
+	 *              --- malloc
+	 *                  cmd_record
+	 *                  run_command
+	 *                  main
+	 *
+	 *   10.00%    10.00%     bash  bash           [.] xmalloc
+	 *              |
+	 *              --- xmalloc
+	 *                  malloc
+	 *                  xmalloc     <--- NOTE: there's a cycle
+	 *                  malloc
+	 *                  xmalloc
+	 *                  main
+	 *
+	 */
+	struct result expected[] = {
+		{ 7000, 2000, "perf", "perf",     "main" },
+		{ 5000,    0, "perf", "perf",     "run_command" },
+		{ 3000, 1000, "bash", "bash",     "main" },
+		{ 3000, 1000, "perf", "perf",     "cmd_record" },
+		{ 2000,    0, "bash", "libc",     "malloc" },
+		{ 1000, 1000, "bash", "[kernel]", "page_fault" },
+		{ 1000, 1000, "perf", "[kernel]", "schedule" },
+		{ 1000,    0, "perf", "[kernel]", "sys_perf_event_open" },
+		{ 1000, 1000, "perf", "[kernel]", "page_fault" },
+		{ 1000, 1000, "perf", "libc",     "free" },
+		{ 1000, 1000, "perf", "libc",     "malloc" },
+		{ 1000, 1000, "bash", "bash",     "xmalloc" },
+	};
+	struct callchain_result expected_callchain[] = {
+		{
+			1, {	{ "perf",     "main" }, },
+		},
+		{
+			2, {	{ "perf",     "run_command" },
+				{ "perf",     "main" }, },
+		},
+		{
+			1, {	{ "bash",     "main" }, },
+		},
+		{
+			3, {	{ "perf",     "cmd_record" },
+				{ "perf",     "run_command" },
+				{ "perf",     "main" }, },
+		},
+		{
+			4, {	{ "libc",     "malloc" },
+				{ "bash",     "xmalloc" },
+				{ "bash",     "main" },
+				{ "bash",     "main" }, },
+		},
+		{
+			3, {	{ "[kernel]", "page_fault" },
+				{ "libc",     "malloc" },
+				{ "bash",     "main" }, },
+		},
+		{
+			3, {	{ "[kernel]", "schedule" },
+				{ "perf",     "run_command" },
+				{ "perf",     "main" }, },
+		},
+		{
+			3, {	{ "[kernel]", "sys_perf_event_open" },
+				{ "perf",     "run_command" },
+				{ "perf",     "main" }, },
+		},
+		{
+			4, {	{ "[kernel]", "page_fault" },
+				{ "[kernel]", "sys_perf_event_open" },
+				{ "perf",     "run_command" },
+				{ "perf",     "main" }, },
+		},
+		{
+			4, {	{ "libc",     "free" },
+				{ "perf",     "cmd_record" },
+				{ "perf",     "run_command" },
+				{ "perf",     "main" }, },
+		},
+		{
+			4, {	{ "libc",     "malloc" },
+				{ "perf",     "cmd_record" },
+				{ "perf",     "run_command" },
+				{ "perf",     "main" }, },
+		},
+		{
+			6, {	{ "bash",     "xmalloc" },
+				{ "libc",     "malloc" },
+				{ "bash",     "xmalloc" },
+				{ "libc",     "malloc" },
+				{ "bash",     "xmalloc" },
+				{ "bash",     "main" }, },
+		},
+	};
+
+	symbol_conf.use_callchain = true;
+	symbol_conf.cumulate_callchain = true;
+
+	setup_sorting();
+	callchain_register_param(&callchain_param);
+
+	err = add_hist_entries(hists, machine);
+	if (err < 0)
+		goto out;
+
+	err = do_test(hists, expected, ARRAY_SIZE(expected),
+		      expected_callchain, ARRAY_SIZE(expected_callchain));
+
+out:
+	del_hist_entries(hists);
+	reset_output_field();
+	return err;
+}
+
+int test__hists_cumulate(void)
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
diff --git a/tools/perf/tests/hists_filter.c b/tools/perf/tests/hists_filter.c
new file mode 100644
index 0000000..821f581
--- /dev/null
+++ b/tools/perf/tests/hists_filter.c
@@ -0,0 +1,289 @@
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
+	{ .pid = FAKE_PID_PERF1, .ip = FAKE_IP_KERNEL_SCHEDULE, },
+	/* perf [perf]   main() */
+	{ .pid = FAKE_PID_PERF1, .ip = FAKE_IP_PERF_MAIN, },
+	/* perf [libc]   malloc() */
+	{ .pid = FAKE_PID_PERF1, .ip = FAKE_IP_LIBC_MALLOC, },
+	/* perf [perf]   main() */
+	{ .pid = FAKE_PID_PERF2, .ip = FAKE_IP_PERF_MAIN, }, /* will be merged */
+	/* perf [perf]   cmd_record() */
+	{ .pid = FAKE_PID_PERF2, .ip = FAKE_IP_PERF_CMD_RECORD, },
+	/* perf [kernel] page_fault() */
+	{ .pid = FAKE_PID_PERF2, .ip = FAKE_IP_KERNEL_PAGE_FAULT, },
+	/* bash [bash]   main() */
+	{ .pid = FAKE_PID_BASH,  .ip = FAKE_IP_BASH_MAIN, },
+	/* bash [bash]   xmalloc() */
+	{ .pid = FAKE_PID_BASH,  .ip = FAKE_IP_BASH_XMALLOC, },
+	/* bash [libc]   malloc() */
+	{ .pid = FAKE_PID_BASH,  .ip = FAKE_IP_LIBC_MALLOC, },
+	/* bash [kernel] page_fault() */
+	{ .pid = FAKE_PID_BASH,  .ip = FAKE_IP_KERNEL_PAGE_FAULT, },
+};
+
+static int add_hist_entries(struct perf_evlist *evlist,
+			    struct machine *machine __maybe_unused)
+{
+	struct perf_evsel *evsel;
+	struct addr_location al;
+	struct perf_sample sample = { .period = 100, };
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
+			struct hist_entry_iter iter = {
+				.ops = &hist_iter_normal,
+				.hide_unresolved = false,
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
+			if (hist_entry_iter__add(&iter, &al, evsel, &sample,
+						 PERF_MAX_STACK_DEPTH, NULL) < 0)
+				goto out;
+
+			fake_samples[i].thread = al.thread;
+			fake_samples[i].map = al.map;
+			fake_samples[i].sym = al.sym;
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
index 7ccbc7b..d4b34b0 100644
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
@@ -156,43 +18,44 @@ struct sample {
 	struct symbol *sym;
 };
 
+/* For the numbers, see hists_common.c */
 static struct sample fake_common_samples[] = {
 	/* perf [kernel] schedule() */
-	{ .pid = 100, .ip = 0xf0000 + 700, },
+	{ .pid = FAKE_PID_PERF1, .ip = FAKE_IP_KERNEL_SCHEDULE, },
 	/* perf [perf]   main() */
-	{ .pid = 200, .ip = 0x40000 + 700, },
+	{ .pid = FAKE_PID_PERF2, .ip = FAKE_IP_PERF_MAIN, },
 	/* perf [perf]   cmd_record() */
-	{ .pid = 200, .ip = 0x40000 + 900, },
+	{ .pid = FAKE_PID_PERF2, .ip = FAKE_IP_PERF_CMD_RECORD, },
 	/* bash [bash]   xmalloc() */
-	{ .pid = 300, .ip = 0x40000 + 800, },
+	{ .pid = FAKE_PID_BASH,  .ip = FAKE_IP_BASH_XMALLOC, },
 	/* bash [libc]   malloc() */
-	{ .pid = 300, .ip = 0x50000 + 700, },
+	{ .pid = FAKE_PID_BASH,  .ip = FAKE_IP_LIBC_MALLOC, },
 };
 
 static struct sample fake_samples[][5] = {
 	{
 		/* perf [perf]   run_command() */
-		{ .pid = 100, .ip = 0x40000 + 800, },
+		{ .pid = FAKE_PID_PERF1, .ip = FAKE_IP_PERF_RUN_COMMAND, },
 		/* perf [libc]   malloc() */
-		{ .pid = 100, .ip = 0x50000 + 700, },
+		{ .pid = FAKE_PID_PERF1, .ip = FAKE_IP_LIBC_MALLOC, },
 		/* perf [kernel] page_fault() */
-		{ .pid = 100, .ip = 0xf0000 + 800, },
+		{ .pid = FAKE_PID_PERF1, .ip = FAKE_IP_KERNEL_PAGE_FAULT, },
 		/* perf [kernel] sys_perf_event_open() */
-		{ .pid = 200, .ip = 0xf0000 + 900, },
+		{ .pid = FAKE_PID_PERF2, .ip = FAKE_IP_KERNEL_SYS_PERF_EVENT_OPEN, },
 		/* bash [libc]   free() */
-		{ .pid = 300, .ip = 0x50000 + 800, },
+		{ .pid = FAKE_PID_BASH,  .ip = FAKE_IP_LIBC_FREE, },
 	},
 	{
 		/* perf [libc]   free() */
-		{ .pid = 200, .ip = 0x50000 + 800, },
+		{ .pid = FAKE_PID_PERF2, .ip = FAKE_IP_LIBC_FREE, },
 		/* bash [libc]   malloc() */
-		{ .pid = 300, .ip = 0x50000 + 700, }, /* will be merged */
+		{ .pid = FAKE_PID_BASH,  .ip = FAKE_IP_LIBC_MALLOC, }, /* will be merged */
 		/* bash [bash]   xfee() */
-		{ .pid = 300, .ip = 0x40000 + 900, },
+		{ .pid = FAKE_PID_BASH,  .ip = FAKE_IP_BASH_XFREE, },
 		/* bash [libc]   realloc() */
-		{ .pid = 300, .ip = 0x50000 + 900, },
+		{ .pid = FAKE_PID_BASH,  .ip = FAKE_IP_LIBC_REALLOC, },
 		/* bash [kernel] page_fault() */
-		{ .pid = 300, .ip = 0xf0000 + 800, },
+		{ .pid = FAKE_PID_BASH,  .ip = FAKE_IP_KERNEL_PAGE_FAULT, },
 	},
 };
 
@@ -201,7 +64,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 	struct perf_evsel *evsel;
 	struct addr_location al;
 	struct hist_entry *he;
-	struct perf_sample sample = { .cpu = 0, };
+	struct perf_sample sample = { .period = 1, };
 	size_t i = 0, k;
 
 	/*
@@ -218,13 +81,14 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 			};
 
 			sample.pid = fake_common_samples[k].pid;
+			sample.tid = fake_common_samples[k].pid;
 			sample.ip = fake_common_samples[k].ip;
 			if (perf_event__preprocess_sample(&event, machine, &al,
 							  &sample) < 0)
 				goto out;
 
 			he = __hists__add_entry(&evsel->hists, &al, NULL,
-						NULL, NULL, 1, 1, 0);
+						NULL, NULL, 1, 1, 0, true);
 			if (he == NULL)
 				goto out;
 
@@ -241,13 +105,14 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 			};
 
 			sample.pid = fake_samples[i][k].pid;
+			sample.tid = fake_samples[i][k].pid;
 			sample.ip = fake_samples[i][k].ip;
 			if (perf_event__preprocess_sample(&event, machine, &al,
 							  &sample) < 0)
 				goto out;
 
 			he = __hists__add_entry(&evsel->hists, &al, NULL,
-						NULL, NULL, 1, 1, 0);
+						NULL, NULL, 1, 1, 0, true);
 			if (he == NULL)
 				goto out;
 
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
index 0000000..e3bbd6c
--- /dev/null
+++ b/tools/perf/tests/hists_output.c
@@ -0,0 +1,621 @@
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
+	{ .cpu = 0, .pid = FAKE_PID_PERF1, .ip = FAKE_IP_KERNEL_SCHEDULE, },
+	/* perf [perf]   main() */
+	{ .cpu = 1, .pid = FAKE_PID_PERF1, .ip = FAKE_IP_PERF_MAIN, },
+	/* perf [perf]   cmd_record() */
+	{ .cpu = 1, .pid = FAKE_PID_PERF1, .ip = FAKE_IP_PERF_CMD_RECORD, },
+	/* perf [libc]   malloc() */
+	{ .cpu = 1, .pid = FAKE_PID_PERF1, .ip = FAKE_IP_LIBC_MALLOC, },
+	/* perf [libc]   free() */
+	{ .cpu = 2, .pid = FAKE_PID_PERF1, .ip = FAKE_IP_LIBC_FREE, },
+	/* perf [perf]   main() */
+	{ .cpu = 2, .pid = FAKE_PID_PERF2, .ip = FAKE_IP_PERF_MAIN, },
+	/* perf [kernel] page_fault() */
+	{ .cpu = 2, .pid = FAKE_PID_PERF2, .ip = FAKE_IP_KERNEL_PAGE_FAULT, },
+	/* bash [bash]   main() */
+	{ .cpu = 3, .pid = FAKE_PID_BASH,  .ip = FAKE_IP_BASH_MAIN, },
+	/* bash [bash]   xmalloc() */
+	{ .cpu = 0, .pid = FAKE_PID_BASH,  .ip = FAKE_IP_BASH_XMALLOC, },
+	/* bash [kernel] page_fault() */
+	{ .cpu = 1, .pid = FAKE_PID_BASH,  .ip = FAKE_IP_KERNEL_PAGE_FAULT, },
+};
+
+static int add_hist_entries(struct hists *hists, struct machine *machine)
+{
+	struct addr_location al;
+	struct perf_evsel *evsel = hists_to_evsel(hists);
+	struct perf_sample sample = { .period = 100, };
+	size_t i;
+
+	for (i = 0; i < ARRAY_SIZE(fake_samples); i++) {
+		const union perf_event event = {
+			.header = {
+				.misc = PERF_RECORD_MISC_USER,
+			},
+		};
+		struct hist_entry_iter iter = {
+			.ops = &hist_iter_normal,
+			.hide_unresolved = false,
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
+		if (hist_entry_iter__add(&iter, &al, evsel, &sample,
+					 PERF_MAX_STACK_DEPTH, NULL) < 0)
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
index a24795c..022bb68 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -41,8 +41,13 @@ int test__sample_parsing(void);
 int test__keep_tracking(void);
 int test__parse_no_sample_id_all(void);
 int test__dwarf_unwind(void);
+int test__hists_filter(void);
+int test__mmap_thread_lookup(void);
+int test__thread_mg_share(void);
+int test__hists_output(void);
+int test__hists_cumulate(void);
 
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
diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index d11541d..3ccf6e1 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -194,7 +194,7 @@ int ui_browser__warning(struct ui_browser *browser, int timeout,
 		ui_helpline__vpush(format, args);
 		va_end(args);
 	} else {
-		while ((key == ui__question_window("Warning!", text,
+		while ((key = ui__question_window("Warning!", text,
 						   "Press any key...",
 						   timeout)) == K_RESIZE)
 			ui_browser__handle_resize(browser);
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
index 7ec871a..52c03fb 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -26,13 +26,35 @@ struct hist_browser {
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
@@ -43,7 +65,14 @@ static void hist_browser__refresh_dimensions(struct hist_browser *browser)
 
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
@@ -198,14 +227,16 @@ static bool hist_browser__toggle_fold(struct hist_browser *browser)
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
@@ -280,23 +311,27 @@ static void hist_entry__set_folding(struct hist_entry *he, bool unfold)
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
+	     (nd = hists__filter_entries(nd, browser->min_pcnt)) != NULL;
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
@@ -310,8 +345,6 @@ static void ui_browser__warn_lost_events(struct ui_browser *browser)
 		"Or reduce the sampling frequency.");
 }
 
-static void hist_browser__update_pcnt_entries(struct hist_browser *hb);
-
 static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 			     struct hist_browser_timer *hbt)
 {
@@ -320,9 +353,7 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 	int delay_secs = hbt ? hbt->refresh : 0;
 
 	browser->b.entries = &browser->hists->entries;
-	browser->b.nr_entries = browser->hists->nr_entries;
-	if (browser->min_pcnt)
-		browser->b.nr_entries = browser->nr_pcnt_entries;
+	browser->b.nr_entries = hist_browser__nr_entries(browser);
 
 	hist_browser__refresh_dimensions(browser);
 	hists__browser_title(browser->hists, title, sizeof(title), ev_name);
@@ -339,13 +370,10 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
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
@@ -587,35 +615,6 @@ struct hpp_arg {
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
@@ -636,7 +635,7 @@ static int __hpp__slsmg_color_printf(struct perf_hpp *hpp, const char *fmt, ...)
 	return ret;
 }
 
-#define __HPP_COLOR_PERCENT_FN(_type, _field, _cb)			\
+#define __HPP_COLOR_PERCENT_FN(_type, _field)				\
 static u64 __hpp_get_##_field(struct hist_entry *he)			\
 {									\
 	return he->stat._field;						\
@@ -647,22 +646,43 @@ hist_browser__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,\
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
+#define __HPP_COLOR_ACC_PERCENT_FN(_type, _field)			\
+static u64 __hpp_get_acc_##_field(struct hist_entry *he)		\
+{									\
+	return he->stat_acc->_field;					\
+}									\
+									\
+static int								\
+hist_browser__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,\
+				struct perf_hpp *hpp,			\
+				struct hist_entry *he)			\
+{									\
+	if (!symbol_conf.cumulate_callchain) {				\
+		int ret = scnprintf(hpp->buf, hpp->size, "%8s", "N/A");	\
+		slsmg_printf("%s", hpp->buf);				\
+									\
+		return ret;						\
+	}								\
+	return __hpp__fmt(hpp, he, __hpp_get_acc_##_field, " %6.2f%%",	\
+			  __hpp__slsmg_color_printf, true);		\
+}
+
+__HPP_COLOR_PERCENT_FN(overhead, period)
+__HPP_COLOR_PERCENT_FN(overhead_sys, period_sys)
+__HPP_COLOR_PERCENT_FN(overhead_us, period_us)
+__HPP_COLOR_PERCENT_FN(overhead_guest_sys, period_guest_sys)
+__HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us)
+__HPP_COLOR_ACC_PERCENT_FN(overhead_acc, period)
 
 #undef __HPP_COLOR_PERCENT_FN
+#undef __HPP_COLOR_ACC_PERCENT_FN
 
 void hist_browser__init_hpp(void)
 {
-	perf_hpp__init();
-
 	perf_hpp__format[PERF_HPP__OVERHEAD].color =
 				hist_browser__hpp_color_overhead;
 	perf_hpp__format[PERF_HPP__OVERHEAD_SYS].color =
@@ -673,6 +693,8 @@ void hist_browser__init_hpp(void)
 				hist_browser__hpp_color_overhead_guest_sys;
 	perf_hpp__format[PERF_HPP__OVERHEAD_GUEST_US].color =
 				hist_browser__hpp_color_overhead_guest_us;
+	perf_hpp__format[PERF_HPP__OVERHEAD_ACC].color =
+				hist_browser__hpp_color_overhead_acc;
 }
 
 static int hist_browser__show_entry(struct hist_browser *browser,
@@ -700,7 +722,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 
 	if (row_offset == 0) {
 		struct hpp_arg arg = {
-			.b 		= &browser->b,
+			.b		= &browser->b,
 			.folded_sign	= folded_sign,
 			.current_entry	= current_entry,
 		};
@@ -713,11 +735,27 @@ static int hist_browser__show_entry(struct hist_browser *browser,
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
@@ -731,8 +769,8 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 		if (!browser->b.navkeypressed)
 			width += 1;
 
-		hist_entry__sort_snprintf(entry, s, sizeof(s), browser->hists);
-		slsmg_write_nstring(s, width);
+		slsmg_write_nstring("", width);
+
 		++row;
 		++printed;
 	} else
@@ -769,12 +807,12 @@ static unsigned int hist_browser__refresh(struct ui_browser *browser)
 
 	for (nd = browser->top; nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		float percent = h->stat.period * 100.0 /
-					hb->hists->stats.total_period;
+		float percent;
 
 		if (h->filtered)
 			continue;
 
+		percent = hist_entry__get_percent_limit(h);
 		if (percent < hb->min_pcnt)
 			continue;
 
@@ -787,18 +825,13 @@ static unsigned int hist_browser__refresh(struct ui_browser *browser)
 }
 
 static struct rb_node *hists__filter_entries(struct rb_node *nd,
-					     struct hists *hists,
 					     float min_pcnt)
 {
 	while (nd != NULL) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		float percent = h->stat.period * 100.0 /
-					hists->stats.total_period;
-
-		if (percent < min_pcnt)
-			return NULL;
+		float percent = hist_entry__get_percent_limit(h);
 
-		if (!h->filtered)
+		if (!h->filtered && percent >= min_pcnt)
 			return nd;
 
 		nd = rb_next(nd);
@@ -808,13 +841,11 @@ static struct rb_node *hists__filter_entries(struct rb_node *nd,
 }
 
 static struct rb_node *hists__filter_prev_entries(struct rb_node *nd,
-						  struct hists *hists,
 						  float min_pcnt)
 {
 	while (nd != NULL) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		float percent = h->stat.period * 100.0 /
-					hists->stats.total_period;
+		float percent = hist_entry__get_percent_limit(h);
 
 		if (!h->filtered && percent >= min_pcnt)
 			return nd;
@@ -843,14 +874,14 @@ static void ui_browser__hists_seek(struct ui_browser *browser,
 	switch (whence) {
 	case SEEK_SET:
 		nd = hists__filter_entries(rb_first(browser->entries),
-					   hb->hists, hb->min_pcnt);
+					   hb->min_pcnt);
 		break;
 	case SEEK_CUR:
 		nd = browser->top;
 		goto do_offset;
 	case SEEK_END:
 		nd = hists__filter_prev_entries(rb_last(browser->entries),
-						hb->hists, hb->min_pcnt);
+						hb->min_pcnt);
 		first = false;
 		break;
 	default:
@@ -893,8 +924,7 @@ do_offset:
 					break;
 				}
 			}
-			nd = hists__filter_entries(rb_next(nd), hb->hists,
-						   hb->min_pcnt);
+			nd = hists__filter_entries(rb_next(nd), hb->min_pcnt);
 			if (nd == NULL)
 				break;
 			--offset;
@@ -927,7 +957,7 @@ do_offset:
 				}
 			}
 
-			nd = hists__filter_prev_entries(rb_prev(nd), hb->hists,
+			nd = hists__filter_prev_entries(rb_prev(nd),
 							hb->min_pcnt);
 			if (nd == NULL)
 				break;
@@ -1066,27 +1096,35 @@ static int hist_browser__fprintf_entry(struct hist_browser *browser,
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
@@ -1098,7 +1136,6 @@ static int hist_browser__fprintf_entry(struct hist_browser *browser,
 static int hist_browser__fprintf(struct hist_browser *browser, FILE *fp)
 {
 	struct rb_node *nd = hists__filter_entries(rb_first(browser->b.entries),
-						   browser->hists,
 						   browser->min_pcnt);
 	int printed = 0;
 
@@ -1106,8 +1143,7 @@ static int hist_browser__fprintf(struct hist_browser *browser, FILE *fp)
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 
 		printed += hist_browser__fprintf_entry(browser, h, fp);
-		nd = hists__filter_entries(rb_next(nd), browser->hists,
-					   browser->min_pcnt);
+		nd = hists__filter_entries(rb_next(nd), browser->min_pcnt);
 	}
 
 	return printed;
@@ -1189,6 +1225,11 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size,
 	char buf[512];
 	size_t buflen = sizeof(buf);
 
+	if (symbol_conf.filter_relative) {
+		nr_samples = hists->stats.nr_non_filtered_samples;
+		nr_events = hists->stats.total_non_filtered_period;
+	}
+
 	if (perf_evsel__is_group_event(evsel)) {
 		struct perf_evsel *pos;
 
@@ -1196,8 +1237,13 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size,
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
 
@@ -1324,18 +1370,22 @@ close_file_and_continue:
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
+	while ((nd = hists__filter_entries(nd, hb->min_pcnt)) != NULL) {
 		nr_entries++;
-		nd = hists__filter_entries(rb_next(nd), hb->hists,
-					   hb->min_pcnt);
+		nd = rb_next(nd);
 	}
 
-	hb->nr_pcnt_entries = nr_entries;
+	hb->nr_non_filtered_entries = nr_entries;
 }
 
 static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
@@ -1370,6 +1420,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	"C             Collapse all callchains\n"			\
 	"d             Zoom into current DSO\n"				\
 	"E             Expand all callchains\n"				\
+	"F             Toggle percentage of filtered entries\n"		\
 
 	/* help messages are sorted by lexical order of the hotkey */
 	const char report_help[] = HIST_BROWSER_HELP_COMMON
@@ -1391,7 +1442,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 
 	if (min_pcnt) {
 		browser->min_pcnt = min_pcnt;
-		hist_browser__update_pcnt_entries(browser);
+		hist_browser__update_nr_entries(browser);
 	}
 
 	fstack = pstack__new(2);
@@ -1475,6 +1526,9 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			if (env->arch)
 				tui__header_window(env);
 			continue;
+		case 'F':
+			symbol_conf.filter_relative ^= 1;
+			continue;
 		case K_F1:
 		case 'h':
 		case '?':
@@ -1652,14 +1706,14 @@ zoom_dso:
 zoom_out_dso:
 				ui_helpline__pop();
 				browser->hists->dso_filter = NULL;
-				sort_dso.elide = false;
+				perf_hpp__set_elide(HISTC_DSO, false);
 			} else {
 				if (dso == NULL)
 					continue;
 				ui_helpline__fpush("To zoom out press <- or -> + \"Zoom out of %s DSO\"",
 						   dso->kernel ? "the Kernel" : dso->short_name);
 				browser->hists->dso_filter = dso;
-				sort_dso.elide = true;
+				perf_hpp__set_elide(HISTC_DSO, true);
 				pstack__push(fstack, &browser->hists->dso_filter);
 			}
 			hists__filter_by_dso(hists);
@@ -1671,13 +1725,13 @@ zoom_thread:
 zoom_out_thread:
 				ui_helpline__pop();
 				browser->hists->thread_filter = NULL;
-				sort_thread.elide = false;
+				perf_hpp__set_elide(HISTC_THREAD, false);
 			} else {
 				ui_helpline__fpush("To zoom out press <- or -> + \"Zoom out of %s(%d) thread\"",
 						   thread->comm_set ? thread__comm_str(thread) : "",
 						   thread->tid);
 				browser->hists->thread_filter = thread;
-				sort_thread.elide = true;
+				perf_hpp__set_elide(HISTC_THREAD, false);
 				pstack__push(fstack, &browser->hists->thread_filter);
 			}
 			hists__filter_by_thread(hists);
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index e395ef9..6ca60e4 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -43,23 +43,36 @@ static int perf_gtk__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,
 				       struct perf_hpp *hpp,			\
 				       struct hist_entry *he)			\
 {										\
-	return __hpp__fmt(hpp, he, he_get_##_field, NULL, " %6.2f%%",		\
+	return __hpp__fmt(hpp, he, he_get_##_field, " %6.2f%%",			\
 			  __percent_color_snprintf, true);			\
 }
 
+#define __HPP_COLOR_ACC_PERCENT_FN(_type, _field)				\
+static u64 he_get_acc_##_field(struct hist_entry *he)				\
+{										\
+	return he->stat_acc->_field;						\
+}										\
+										\
+static int perf_gtk__hpp_color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,	\
+				       struct perf_hpp *hpp,			\
+				       struct hist_entry *he)			\
+{										\
+	return __hpp__fmt_acc(hpp, he, he_get_acc_##_field, " %6.2f%%",		\
+			      __percent_color_snprintf, true);			\
+}
+
 __HPP_COLOR_PERCENT_FN(overhead, period)
 __HPP_COLOR_PERCENT_FN(overhead_sys, period_sys)
 __HPP_COLOR_PERCENT_FN(overhead_us, period_us)
 __HPP_COLOR_PERCENT_FN(overhead_guest_sys, period_guest_sys)
 __HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us)
+__HPP_COLOR_ACC_PERCENT_FN(overhead_acc, period)
 
 #undef __HPP_COLOR_PERCENT_FN
 
 
 void perf_gtk__init_hpp(void)
 {
-	perf_hpp__init();
-
 	perf_hpp__format[PERF_HPP__OVERHEAD].color =
 				perf_gtk__hpp_color_overhead;
 	perf_hpp__format[PERF_HPP__OVERHEAD_SYS].color =
@@ -70,6 +83,8 @@ void perf_gtk__init_hpp(void)
 				perf_gtk__hpp_color_overhead_guest_sys;
 	perf_hpp__format[PERF_HPP__OVERHEAD_GUEST_US].color =
 				perf_gtk__hpp_color_overhead_guest_us;
+	perf_hpp__format[PERF_HPP__OVERHEAD_ACC].color =
+				perf_gtk__hpp_color_overhead_acc;
 }
 
 static void callchain_list__sym_name(struct callchain_list *cl,
@@ -153,7 +168,6 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 	struct perf_hpp_fmt *fmt;
 	GType col_types[MAX_COLUMNS];
 	GtkCellRenderer *renderer;
-	struct sort_entry *se;
 	GtkTreeStore *store;
 	struct rb_node *nd;
 	GtkWidget *view;
@@ -172,16 +186,6 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
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
@@ -191,6 +195,16 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 	col_idx = 0;
 
 	perf_hpp__for_each_format(fmt) {
+		if (perf_hpp__should_skip(fmt))
+			continue;
+
+		/*
+		 * XXX no way to determine where symcol column is..
+		 *     Just use last column for now.
+		 */
+		if (perf_hpp__is_sort_entry(fmt))
+			sym_col = col_idx;
+
 		fmt->header(fmt, &hpp, hists_to_evsel(hists));
 
 		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
@@ -199,16 +213,6 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
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
 
@@ -228,12 +232,13 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 		GtkTreeIter iter;
-		float percent = h->stat.period * 100.0 /
-					hists->stats.total_period;
+		u64 total = hists__total_period(h->hists);
+		float percent;
 
 		if (h->filtered)
 			continue;
 
+		percent = hist_entry__get_percent_limit(h);
 		if (percent < min_pcnt)
 			continue;
 
@@ -242,6 +247,9 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 		col_idx = 0;
 
 		perf_hpp__for_each_format(fmt) {
+			if (perf_hpp__should_skip(fmt))
+				continue;
+
 			if (fmt->color)
 				fmt->color(fmt, &hpp, h);
 			else
@@ -250,23 +258,10 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
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
-				total = h->stat.period;
-			else
-				total = hists->stats.total_period;
+				total = symbol_conf.cumulate_callchain ?
+					h->stat_acc->period : h->stat.period;
 
 			perf_gtk__add_callchain(&h->sorted_chain, store, &iter,
 						sym_col, total);
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 0f403b8..498adb2 100644
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
@@ -116,6 +104,92 @@ int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 	return ret;
 }
 
+int __hpp__fmt_acc(struct perf_hpp *hpp, struct hist_entry *he,
+		   hpp_field_fn get_field, const char *fmt,
+		   hpp_snprint_fn print_fn, bool fmt_percent)
+{
+	if (!symbol_conf.cumulate_callchain) {
+		return snprintf(hpp->buf, hpp->size, "%*s",
+				fmt_percent ? 8 : 12, "N/A");
+	}
+
+	return __hpp__fmt(hpp, he, get_field, fmt, print_fn, fmt_percent);
+}
+
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
+static int __hpp__sort_acc(struct hist_entry *a, struct hist_entry *b,
+			   hpp_field_fn get_field)
+{
+	s64 ret = 0;
+
+	if (symbol_conf.cumulate_callchain) {
+		/*
+		 * Put caller above callee when they have equal period.
+		 */
+		ret = field_cmp(get_field(a), get_field(b));
+		if (ret)
+			return ret;
+
+		ret = b->callchain->max_depth - a->callchain->max_depth;
+	}
+	return ret;
+}
+
 #define __HPP_HEADER_FN(_type, _str, _min_width, _unit_width) 		\
 static int hpp__header_##_type(struct perf_hpp_fmt *fmt __maybe_unused,	\
 			       struct perf_hpp *hpp,			\
@@ -179,7 +253,7 @@ static u64 he_get_##_field(struct hist_entry *he)				\
 static int hpp__color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,		\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
-	return __hpp__fmt(hpp, he, he_get_##_field, NULL, " %6.2f%%",		\
+	return __hpp__fmt(hpp, he, he_get_##_field, " %6.2f%%",			\
 			  hpp_color_scnprintf, true);				\
 }
 
@@ -188,10 +262,44 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
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
+#define __HPP_COLOR_ACC_PERCENT_FN(_type, _field)				\
+static u64 he_get_acc_##_field(struct hist_entry *he)				\
+{										\
+	return he->stat_acc->_field;						\
+}										\
+										\
+static int hpp__color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,		\
+			      struct perf_hpp *hpp, struct hist_entry *he) 	\
+{										\
+	return __hpp__fmt_acc(hpp, he, he_get_acc_##_field, " %6.2f%%",		\
+			      hpp_color_scnprintf, true);			\
+}
+
+#define __HPP_ENTRY_ACC_PERCENT_FN(_type, _field)				\
+static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
+			      struct perf_hpp *hpp, struct hist_entry *he) 	\
+{										\
+	const char *fmt = symbol_conf.field_sep ? " %.2f" : " %6.2f%%";		\
+	return __hpp__fmt_acc(hpp, he, he_get_acc_##_field, fmt,		\
+			      hpp_entry_scnprintf, true);			\
+}
+
+#define __HPP_SORT_ACC_FN(_type, _field)					\
+static int64_t hpp__sort_##_type(struct hist_entry *a, struct hist_entry *b)	\
+{										\
+	return __hpp__sort_acc(a, b, he_get_acc_##_field);			\
+}
+
 #define __HPP_ENTRY_RAW_FN(_type, _field)					\
 static u64 he_get_raw_##_field(struct hist_entry *he)				\
 {										\
@@ -202,44 +310,85 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
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
+
+#define HPP_PERCENT_ACC_FNS(_type, _str, _field, _min_width, _unit_width)\
+__HPP_HEADER_FN(_type, _str, _min_width, _unit_width)			\
+__HPP_WIDTH_FN(_type, _min_width, _unit_width)				\
+__HPP_COLOR_ACC_PERCENT_FN(_type, _field)				\
+__HPP_ENTRY_ACC_PERCENT_FN(_type, _field)				\
+__HPP_SORT_ACC_FN(_type, _field)
 
 #define HPP_RAW_FNS(_type, _str, _field, _min_width, _unit_width)	\
 __HPP_HEADER_FN(_type, _str, _min_width, _unit_width)			\
 __HPP_WIDTH_FN(_type, _min_width, _unit_width)				\
-__HPP_ENTRY_RAW_FN(_type, _field)
+__HPP_ENTRY_RAW_FN(_type, _field)					\
+__HPP_SORT_RAW_FN(_type, _field)
 
+__HPP_HEADER_FN(overhead_self, "Self", 8, 8)
 
 HPP_PERCENT_FNS(overhead, "Overhead", period, 8, 8)
 HPP_PERCENT_FNS(overhead_sys, "sys", period_sys, 8, 8)
 HPP_PERCENT_FNS(overhead_us, "usr", period_us, 8, 8)
 HPP_PERCENT_FNS(overhead_guest_sys, "guest sys", period_guest_sys, 9, 8)
 HPP_PERCENT_FNS(overhead_guest_us, "guest usr", period_guest_us, 9, 8)
+HPP_PERCENT_ACC_FNS(overhead_acc, "Children", period, 8, 8)
 
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
+	}
+
+#define HPP__COLOR_ACC_PRINT_FNS(_name)			\
+	{						\
+		.header	= hpp__header_ ## _name,	\
+		.width	= hpp__width_ ## _name,		\
+		.color	= hpp__color_ ## _name,		\
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
@@ -248,28 +397,63 @@ struct perf_hpp_fmt perf_hpp__format[] = {
 	HPP__COLOR_PRINT_FNS(overhead_us),
 	HPP__COLOR_PRINT_FNS(overhead_guest_sys),
 	HPP__COLOR_PRINT_FNS(overhead_guest_us),
+	HPP__COLOR_ACC_PRINT_FNS(overhead_acc),
 	HPP__PRINT_FNS(samples),
 	HPP__PRINT_FNS(period)
 };
 
 LIST_HEAD(perf_hpp__list);
+LIST_HEAD(perf_hpp__sort_list);
 
 
 #undef HPP__COLOR_PRINT_FNS
+#undef HPP__COLOR_ACC_PRINT_FNS
 #undef HPP__PRINT_FNS
 
 #undef HPP_PERCENT_FNS
+#undef HPP_PERCENT_ACC_FNS
 #undef HPP_RAW_FNS
 
 #undef __HPP_HEADER_FN
 #undef __HPP_WIDTH_FN
 #undef __HPP_COLOR_PERCENT_FN
 #undef __HPP_ENTRY_PERCENT_FN
+#undef __HPP_COLOR_ACC_PERCENT_FN
+#undef __HPP_ENTRY_ACC_PERCENT_FN
 #undef __HPP_ENTRY_RAW_FN
+#undef __HPP_SORT_FN
+#undef __HPP_SORT_ACC_FN
+#undef __HPP_SORT_RAW_FN
 
 
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
+	if (symbol_conf.cumulate_callchain) {
+		perf_hpp__column_enable(PERF_HPP__OVERHEAD_ACC);
+
+		perf_hpp__format[PERF_HPP__OVERHEAD].header =
+						hpp__header_overhead_self;
+	}
+
 	perf_hpp__column_enable(PERF_HPP__OVERHEAD);
 
 	if (symbol_conf.show_cpu_utilization) {
@@ -287,6 +471,17 @@ void perf_hpp__init(void)
 
 	if (symbol_conf.show_total_period)
 		perf_hpp__column_enable(PERF_HPP__PERIOD);
+
+	/* prepend overhead field for backward compatiblity.  */
+	list = &perf_hpp__format[PERF_HPP__OVERHEAD].sort_list;
+	if (list_empty(list))
+		list_add(list, &perf_hpp__sort_list);
+
+	if (symbol_conf.cumulate_callchain) {
+		list = &perf_hpp__format[PERF_HPP__OVERHEAD_ACC].sort_list;
+		if (list_empty(list))
+			list_add(list, &perf_hpp__sort_list);
+	}
 }
 
 void perf_hpp__column_register(struct perf_hpp_fmt *format)
@@ -294,29 +489,110 @@ void perf_hpp__column_register(struct perf_hpp_fmt *format)
 	list_add_tail(&format->list, &perf_hpp__list);
 }
 
+void perf_hpp__column_unregister(struct perf_hpp_fmt *format)
+{
+	list_del(&format->list);
+}
+
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
+void perf_hpp__column_disable(unsigned col)
 {
-	const char *sep = symbol_conf.field_sep;
-	struct sort_entry *se;
-	int ret = 0;
+	BUG_ON(col >= PERF_HPP__MAX_INDEX);
+	perf_hpp__column_unregister(&perf_hpp__format[col]);
+}
+
+void perf_hpp__cancel_cumulate(void)
+{
+	if (field_order)
+		return;
 
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		if (se->elide)
+	perf_hpp__column_disable(PERF_HPP__OVERHEAD_ACC);
+	perf_hpp__format[PERF_HPP__OVERHEAD].header = hpp__header_overhead;
+}
+
+void perf_hpp__setup_output_field(void)
+{
+	struct perf_hpp_fmt *fmt;
+
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
@@ -325,22 +601,23 @@ int hist_entry__sort_snprintf(struct hist_entry *he, char *s, size_t size,
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
index d59893e..90122ab 100644
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
@@ -270,7 +271,9 @@ static size_t hist_entry_callchain__fprintf(struct hist_entry *he,
 {
 	switch (callchain_param.mode) {
 	case CHAIN_GRAPH_REL:
-		return callchain__fprintf_graph(fp, &he->sorted_chain, he->stat.period,
+		return callchain__fprintf_graph(fp, &he->sorted_chain,
+						symbol_conf.cumulate_callchain ?
+						he->stat_acc->period : he->stat.period,
 						left_margin);
 		break;
 	case CHAIN_GRAPH_ABS:
@@ -296,18 +299,24 @@ static size_t hist_entry__callchain_fprintf(struct hist_entry *he,
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
@@ -319,6 +328,9 @@ static int hist_entry__period_snprintf(struct perf_hpp *hpp,
 		return 0;
 
 	perf_hpp__for_each_format(fmt) {
+		if (perf_hpp__should_skip(fmt))
+			continue;
+
 		/*
 		 * If there's no field_sep, we still need
 		 * to display initial '  '.
@@ -353,8 +365,7 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 	if (size == 0 || size > bfsz)
 		size = hpp.size = bfsz;
 
-	ret = hist_entry__period_snprintf(&hpp, he);
-	hist_entry__sort_snprintf(he, bf + ret, size - ret, hists);
+	hist_entry__snprintf(he, &hpp);
 
 	ret = fprintf(fp, "%s\n", bf);
 
@@ -368,12 +379,10 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
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
@@ -386,12 +395,19 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 
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
@@ -401,28 +417,6 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
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
@@ -437,6 +431,9 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 	perf_hpp__for_each_format(fmt) {
 		unsigned int i;
 
+		if (perf_hpp__should_skip(fmt))
+			continue;
+
 		if (!first)
 			fprintf(fp, "%s", sep ?: "  ");
 		else
@@ -447,20 +444,6 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
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
@@ -480,12 +463,12 @@ print_entries:
 
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		float percent = h->stat.period * 100.0 /
-					hists->stats.total_period;
+		float percent;
 
 		if (h->filtered)
 			continue;
 
+		percent = hist_entry__get_percent_limit(h);
 		if (percent < min_pcnt)
 			continue;
 
@@ -495,7 +478,7 @@ print_entries:
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
index 8d9db45..48b6d3f 100644
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
@@ -538,7 +616,8 @@ int sample__resolve_callchain(struct perf_sample *sample, struct symbol **parent
 	if (sample->callchain == NULL)
 		return 0;
 
-	if (symbol_conf.use_callchain || sort__has_parent) {
+	if (symbol_conf.use_callchain || symbol_conf.cumulate_callchain ||
+	    sort__has_parent) {
 		return machine__resolve_callchain(al->machine, evsel, al->thread,
 						  sample, parent, al, max_stack);
 	}
@@ -551,3 +630,45 @@ int hist_entry__append_callchain(struct hist_entry *he, struct perf_sample *samp
 		return 0;
 	return callchain_append(he->callchain, &callchain_cursor, sample->period);
 }
+
+int fill_callchain_info(struct addr_location *al, struct callchain_cursor_node *node,
+			bool hide_unresolved)
+{
+	al->map = node->map;
+	al->sym = node->sym;
+	if (node->map)
+		al->addr = node->map->map_ip(node->map, node->ip);
+	else
+		al->addr = node->ip;
+
+	if (al->sym == NULL) {
+		if (hide_unresolved)
+			return 0;
+		if (al->map == NULL)
+			goto out;
+	}
+
+	if (al->map->groups == &al->machine->kmaps) {
+		if (machine__is_host(al->machine)) {
+			al->cpumode = PERF_RECORD_MISC_KERNEL;
+			al->level = 'k';
+		} else {
+			al->cpumode = PERF_RECORD_MISC_GUEST_KERNEL;
+			al->level = 'g';
+		}
+	} else {
+		if (machine__is_host(al->machine)) {
+			al->cpumode = PERF_RECORD_MISC_USER;
+			al->level = '.';
+		} else if (perf_guest) {
+			al->cpumode = PERF_RECORD_MISC_GUEST_USER;
+			al->level = 'u';
+		} else {
+			al->cpumode = PERF_RECORD_MISC_HYPERVISOR;
+			al->level = 'H';
+		}
+	}
+
+out:
+	return 1;
+}
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 8ad97e9..8f84423 100644
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
@@ -155,6 +162,18 @@ int sample__resolve_callchain(struct perf_sample *sample, struct symbol **parent
 			      struct perf_evsel *evsel, struct addr_location *al,
 			      int max_stack);
 int hist_entry__append_callchain(struct hist_entry *he, struct perf_sample *sample);
+int fill_callchain_info(struct addr_location *al, struct callchain_cursor_node *node,
+			bool hide_unresolved);
 
 extern const char record_callchain_help[];
+int parse_callchain_report_opt(const char *arg);
+
+static inline void callchain_cursor_snapshot(struct callchain_cursor *dest,
+					     struct callchain_cursor *src)
+{
+	*dest = *src;
+
+	dest->first = src->curr;
+	dest->nr -= src->pos;
+}
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
index f38590d..5a0a4b2 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -4,6 +4,7 @@
 #include "session.h"
 #include "sort.h"
 #include "evsel.h"
+#include "annotate.h"
 #include <math.h>
 
 static bool hists__filter_entry_by_dso(struct hists *hists,
@@ -225,14 +226,20 @@ static void he_stat__decay(struct he_stat *he_stat)
 static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
 {
 	u64 prev_period = he->stat.period;
+	u64 diff;
 
 	if (prev_period == 0)
 		return true;
 
 	he_stat__decay(&he->stat);
+	if (symbol_conf.cumulate_callchain)
+		he_stat__decay(he->stat_acc);
 
+	diff = prev_period - he->stat.period;
+
+	hists->stats.total_period -= diff;
 	if (!he->filtered)
-		hists->stats.total_period -= prev_period - he->stat.period;
+		hists->stats.total_non_filtered_period -= diff;
 
 	return he->stat.period == 0;
 }
@@ -259,8 +266,11 @@ void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel)
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
@@ -269,14 +279,31 @@ void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel)
  * histogram, sorted on item, collects periods
  */
 
-static struct hist_entry *hist_entry__new(struct hist_entry *template)
+static struct hist_entry *hist_entry__new(struct hist_entry *template,
+					  bool sample_self)
 {
-	size_t callchain_size = symbol_conf.use_callchain ? sizeof(struct callchain_root) : 0;
-	struct hist_entry *he = zalloc(sizeof(*he) + callchain_size);
+	size_t callchain_size = 0;
+	struct hist_entry *he;
+
+	if (symbol_conf.use_callchain || symbol_conf.cumulate_callchain)
+		callchain_size = sizeof(struct callchain_root);
+
+	he = zalloc(sizeof(*he) + callchain_size);
 
 	if (he != NULL) {
 		*he = *template;
 
+		if (symbol_conf.cumulate_callchain) {
+			he->stat_acc = malloc(sizeof(he->stat));
+			if (he->stat_acc == NULL) {
+				free(he);
+				return NULL;
+			}
+			memcpy(he->stat_acc, &he->stat, sizeof(he->stat));
+			if (!sample_self)
+				memset(&he->stat, 0, sizeof(he->stat));
+		}
+
 		if (he->ms.map)
 			he->ms.map->referenced = true;
 
@@ -288,6 +315,7 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 			 */
 			he->branch_info = malloc(sizeof(*he->branch_info));
 			if (he->branch_info == NULL) {
+				free(he->stat_acc);
 				free(he);
 				return NULL;
 			}
@@ -317,15 +345,6 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
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
@@ -335,7 +354,8 @@ static u8 symbol__parent_filter(const struct symbol *parent)
 
 static struct hist_entry *add_hist_entry(struct hists *hists,
 					 struct hist_entry *entry,
-					 struct addr_location *al)
+					 struct addr_location *al,
+					 bool sample_self)
 {
 	struct rb_node **p;
 	struct rb_node *parent = NULL;
@@ -359,7 +379,10 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 		cmp = hist_entry__cmp(he, entry);
 
 		if (!cmp) {
-			he_stat__add_period(&he->stat, period, weight);
+			if (sample_self)
+				he_stat__add_period(&he->stat, period, weight);
+			if (symbol_conf.cumulate_callchain)
+				he_stat__add_period(he->stat_acc, period, weight);
 
 			/*
 			 * This mem info was allocated from sample__resolve_mem
@@ -387,15 +410,17 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 			p = &(*p)->rb_right;
 	}
 
-	he = hist_entry__new(entry);
+	he = hist_entry__new(entry, sample_self);
 	if (!he)
 		return NULL;
 
-	hists->nr_entries++;
 	rb_link_node(&he->rb_node_in, parent, p);
 	rb_insert_color(&he->rb_node_in, hists->entries_in);
 out:
-	he_stat__add_cpumode_period(&he->stat, al->cpumode, period);
+	if (sample_self)
+		he_stat__add_cpumode_period(&he->stat, al->cpumode, period);
+	if (symbol_conf.cumulate_callchain)
+		he_stat__add_cpumode_period(he->stat_acc, al->cpumode, period);
 	return he;
 }
 
@@ -404,7 +429,8 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 				      struct symbol *sym_parent,
 				      struct branch_info *bi,
 				      struct mem_info *mi,
-				      u64 period, u64 weight, u64 transaction)
+				      u64 period, u64 weight, u64 transaction,
+				      bool sample_self)
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
@@ -429,17 +455,442 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 		.transaction = transaction,
 	};
 
-	return add_hist_entry(hists, &entry, al);
+	return add_hist_entry(hists, &entry, al, sample_self);
+}
+
+static int
+iter_next_nop_entry(struct hist_entry_iter *iter __maybe_unused,
+		    struct addr_location *al __maybe_unused)
+{
+	return 0;
+}
+
+static int
+iter_add_next_nop_entry(struct hist_entry_iter *iter __maybe_unused,
+			struct addr_location *al __maybe_unused)
+{
+	return 0;
+}
+
+static int
+iter_prepare_mem_entry(struct hist_entry_iter *iter, struct addr_location *al)
+{
+	struct perf_sample *sample = iter->sample;
+	struct mem_info *mi;
+
+	mi = sample__resolve_mem(sample, al);
+	if (mi == NULL)
+		return -ENOMEM;
+
+	iter->priv = mi;
+	return 0;
+}
+
+static int
+iter_add_single_mem_entry(struct hist_entry_iter *iter, struct addr_location *al)
+{
+	u64 cost;
+	struct mem_info *mi = iter->priv;
+	struct hist_entry *he;
+
+	if (mi == NULL)
+		return -EINVAL;
+
+	cost = iter->sample->weight;
+	if (!cost)
+		cost = 1;
+
+	/*
+	 * must pass period=weight in order to get the correct
+	 * sorting from hists__collapse_resort() which is solely
+	 * based on periods. We want sorting be done on nr_events * weight
+	 * and this is indirectly achieved by passing period=weight here
+	 * and the he_stat__add_period() function.
+	 */
+	he = __hists__add_entry(&iter->evsel->hists, al, iter->parent, NULL, mi,
+				cost, cost, 0, true);
+	if (!he)
+		return -ENOMEM;
+
+	iter->he = he;
+	return 0;
+}
+
+static int
+iter_finish_mem_entry(struct hist_entry_iter *iter,
+		      struct addr_location *al __maybe_unused)
+{
+	struct perf_evsel *evsel = iter->evsel;
+	struct hist_entry *he = iter->he;
+	int err = -EINVAL;
+
+	if (he == NULL)
+		goto out;
+
+	hists__inc_nr_samples(&evsel->hists, he->filtered);
+
+	err = hist_entry__append_callchain(he, iter->sample);
+
+out:
+	/*
+	 * We don't need to free iter->priv (mem_info) here since
+	 * the mem info was either already freed in add_hist_entry() or
+	 * passed to a new hist entry by hist_entry__new().
+	 */
+	iter->priv = NULL;
+
+	iter->he = NULL;
+	return err;
+}
+
+static int
+iter_prepare_branch_entry(struct hist_entry_iter *iter, struct addr_location *al)
+{
+	struct branch_info *bi;
+	struct perf_sample *sample = iter->sample;
+
+	bi = sample__resolve_bstack(sample, al);
+	if (!bi)
+		return -ENOMEM;
+
+	iter->curr = 0;
+	iter->total = sample->branch_stack->nr;
+
+	iter->priv = bi;
+	return 0;
+}
+
+static int
+iter_add_single_branch_entry(struct hist_entry_iter *iter __maybe_unused,
+			     struct addr_location *al __maybe_unused)
+{
+	/* to avoid calling callback function */
+	iter->he = NULL;
+
+	return 0;
+}
+
+static int
+iter_next_branch_entry(struct hist_entry_iter *iter, struct addr_location *al)
+{
+	struct branch_info *bi = iter->priv;
+	int i = iter->curr;
+
+	if (bi == NULL)
+		return 0;
+
+	if (iter->curr >= iter->total)
+		return 0;
+
+	al->map = bi[i].to.map;
+	al->sym = bi[i].to.sym;
+	al->addr = bi[i].to.addr;
+	return 1;
+}
+
+static int
+iter_add_next_branch_entry(struct hist_entry_iter *iter, struct addr_location *al)
+{
+	struct branch_info *bi;
+	struct perf_evsel *evsel = iter->evsel;
+	struct hist_entry *he = NULL;
+	int i = iter->curr;
+	int err = 0;
+
+	bi = iter->priv;
+
+	if (iter->hide_unresolved && !(bi[i].from.sym && bi[i].to.sym))
+		goto out;
+
+	/*
+	 * The report shows the percentage of total branches captured
+	 * and not events sampled. Thus we use a pseudo period of 1.
+	 */
+	he = __hists__add_entry(&evsel->hists, al, iter->parent, &bi[i], NULL,
+				1, 1, 0, true);
+	if (he == NULL)
+		return -ENOMEM;
+
+	hists__inc_nr_samples(&evsel->hists, he->filtered);
+
+out:
+	iter->he = he;
+	iter->curr++;
+	return err;
+}
+
+static int
+iter_finish_branch_entry(struct hist_entry_iter *iter,
+			 struct addr_location *al __maybe_unused)
+{
+	zfree(&iter->priv);
+	iter->he = NULL;
+
+	return iter->curr >= iter->total ? 0 : -1;
+}
+
+static int
+iter_prepare_normal_entry(struct hist_entry_iter *iter __maybe_unused,
+			  struct addr_location *al __maybe_unused)
+{
+	return 0;
+}
+
+static int
+iter_add_single_normal_entry(struct hist_entry_iter *iter, struct addr_location *al)
+{
+	struct perf_evsel *evsel = iter->evsel;
+	struct perf_sample *sample = iter->sample;
+	struct hist_entry *he;
+
+	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
+				sample->period, sample->weight,
+				sample->transaction, true);
+	if (he == NULL)
+		return -ENOMEM;
+
+	iter->he = he;
+	return 0;
+}
+
+static int
+iter_finish_normal_entry(struct hist_entry_iter *iter,
+			 struct addr_location *al __maybe_unused)
+{
+	struct hist_entry *he = iter->he;
+	struct perf_evsel *evsel = iter->evsel;
+	struct perf_sample *sample = iter->sample;
+
+	if (he == NULL)
+		return 0;
+
+	iter->he = NULL;
+
+	hists__inc_nr_samples(&evsel->hists, he->filtered);
+
+	return hist_entry__append_callchain(he, sample);
+}
+
+static int
+iter_prepare_cumulative_entry(struct hist_entry_iter *iter __maybe_unused,
+			      struct addr_location *al __maybe_unused)
+{
+	struct hist_entry **he_cache;
+
+	callchain_cursor_commit(&callchain_cursor);
+
+	/*
+	 * This is for detecting cycles or recursions so that they're
+	 * cumulated only one time to prevent entries more than 100%
+	 * overhead.
+	 */
+	he_cache = malloc(sizeof(*he_cache) * (PERF_MAX_STACK_DEPTH + 1));
+	if (he_cache == NULL)
+		return -ENOMEM;
+
+	iter->priv = he_cache;
+	iter->curr = 0;
+
+	return 0;
+}
+
+static int
+iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
+				 struct addr_location *al)
+{
+	struct perf_evsel *evsel = iter->evsel;
+	struct perf_sample *sample = iter->sample;
+	struct hist_entry **he_cache = iter->priv;
+	struct hist_entry *he;
+	int err = 0;
+
+	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
+				sample->period, sample->weight,
+				sample->transaction, true);
+	if (he == NULL)
+		return -ENOMEM;
+
+	iter->he = he;
+	he_cache[iter->curr++] = he;
+
+	callchain_append(he->callchain, &callchain_cursor, sample->period);
+
+	/*
+	 * We need to re-initialize the cursor since callchain_append()
+	 * advanced the cursor to the end.
+	 */
+	callchain_cursor_commit(&callchain_cursor);
+
+	hists__inc_nr_samples(&evsel->hists, he->filtered);
+
+	return err;
+}
+
+static int
+iter_next_cumulative_entry(struct hist_entry_iter *iter,
+			   struct addr_location *al)
+{
+	struct callchain_cursor_node *node;
+
+	node = callchain_cursor_current(&callchain_cursor);
+	if (node == NULL)
+		return 0;
+
+	return fill_callchain_info(al, node, iter->hide_unresolved);
+}
+
+static int
+iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
+			       struct addr_location *al)
+{
+	struct perf_evsel *evsel = iter->evsel;
+	struct perf_sample *sample = iter->sample;
+	struct hist_entry **he_cache = iter->priv;
+	struct hist_entry *he;
+	struct hist_entry he_tmp = {
+		.cpu = al->cpu,
+		.thread = al->thread,
+		.comm = thread__comm(al->thread),
+		.ip = al->addr,
+		.ms = {
+			.map = al->map,
+			.sym = al->sym,
+		},
+		.parent = iter->parent,
+	};
+	int i;
+	struct callchain_cursor cursor;
+
+	callchain_cursor_snapshot(&cursor, &callchain_cursor);
+
+	callchain_cursor_advance(&callchain_cursor);
+
+	/*
+	 * Check if there's duplicate entries in the callchain.
+	 * It's possible that it has cycles or recursive calls.
+	 */
+	for (i = 0; i < iter->curr; i++) {
+		if (hist_entry__cmp(he_cache[i], &he_tmp) == 0) {
+			/* to avoid calling callback function */
+			iter->he = NULL;
+			return 0;
+		}
+	}
+
+	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
+				sample->period, sample->weight,
+				sample->transaction, false);
+	if (he == NULL)
+		return -ENOMEM;
+
+	iter->he = he;
+	he_cache[iter->curr++] = he;
+
+	callchain_append(he->callchain, &cursor, sample->period);
+	return 0;
+}
+
+static int
+iter_finish_cumulative_entry(struct hist_entry_iter *iter,
+			     struct addr_location *al __maybe_unused)
+{
+	zfree(&iter->priv);
+	iter->he = NULL;
+
+	return 0;
+}
+
+const struct hist_iter_ops hist_iter_mem = {
+	.prepare_entry 		= iter_prepare_mem_entry,
+	.add_single_entry 	= iter_add_single_mem_entry,
+	.next_entry 		= iter_next_nop_entry,
+	.add_next_entry 	= iter_add_next_nop_entry,
+	.finish_entry 		= iter_finish_mem_entry,
+};
+
+const struct hist_iter_ops hist_iter_branch = {
+	.prepare_entry 		= iter_prepare_branch_entry,
+	.add_single_entry 	= iter_add_single_branch_entry,
+	.next_entry 		= iter_next_branch_entry,
+	.add_next_entry 	= iter_add_next_branch_entry,
+	.finish_entry 		= iter_finish_branch_entry,
+};
+
+const struct hist_iter_ops hist_iter_normal = {
+	.prepare_entry 		= iter_prepare_normal_entry,
+	.add_single_entry 	= iter_add_single_normal_entry,
+	.next_entry 		= iter_next_nop_entry,
+	.add_next_entry 	= iter_add_next_nop_entry,
+	.finish_entry 		= iter_finish_normal_entry,
+};
+
+const struct hist_iter_ops hist_iter_cumulative = {
+	.prepare_entry 		= iter_prepare_cumulative_entry,
+	.add_single_entry 	= iter_add_single_cumulative_entry,
+	.next_entry 		= iter_next_cumulative_entry,
+	.add_next_entry 	= iter_add_next_cumulative_entry,
+	.finish_entry 		= iter_finish_cumulative_entry,
+};
+
+int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
+			 struct perf_evsel *evsel, struct perf_sample *sample,
+			 int max_stack_depth, void *arg)
+{
+	int err, err2;
+
+	err = sample__resolve_callchain(sample, &iter->parent, evsel, al,
+					max_stack_depth);
+	if (err)
+		return err;
+
+	iter->evsel = evsel;
+	iter->sample = sample;
+
+	err = iter->ops->prepare_entry(iter, al);
+	if (err)
+		goto out;
+
+	err = iter->ops->add_single_entry(iter, al);
+	if (err)
+		goto out;
+
+	if (iter->he && iter->add_entry_cb) {
+		err = iter->add_entry_cb(iter, al, true, arg);
+		if (err)
+			goto out;
+	}
+
+	while (iter->ops->next_entry(iter, al)) {
+		err = iter->ops->add_next_entry(iter, al);
+		if (err)
+			break;
+
+		if (iter->he && iter->add_entry_cb) {
+			err = iter->add_entry_cb(iter, al, false, arg);
+			if (err)
+				goto out;
+		}
+	}
+
+out:
+	err2 = iter->ops->finish_entry(iter, al);
+	if (!err)
+		err = err2;
+
+	return err;
 }
 
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
@@ -450,15 +901,14 @@ hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
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
@@ -470,6 +920,7 @@ void hist_entry__free(struct hist_entry *he)
 {
 	zfree(&he->branch_info);
 	zfree(&he->mem_info);
+	zfree(&he->stat_acc);
 	free_srcline(he->srcline);
 	free(he);
 }
@@ -495,6 +946,8 @@ static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
 
 		if (!cmp) {
 			he_stat__add_stat(&iter->stat, &he->stat);
+			if (symbol_conf.cumulate_callchain)
+				he_stat__add_stat(iter->stat_acc, he->stat_acc);
 
 			if (symbol_conf.use_callchain) {
 				callchain_cursor_reset(&callchain_cursor);
@@ -571,64 +1024,50 @@ void hists__collapse_resort(struct hists *hists, struct ui_progress *prog)
 	}
 }
 
-/*
- * reverse the map, sort on period.
- */
-
-static int period_cmp(u64 period_a, u64 period_b)
-{
-	if (period_a > period_b)
-		return 1;
-	if (period_a < period_b)
-		return -1;
-	return 0;
-}
-
-static int hist_entry__sort_on_period(struct hist_entry *a,
-				      struct hist_entry *b)
+static int hist_entry__sort(struct hist_entry *a, struct hist_entry *b)
 {
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
@@ -647,7 +1086,7 @@ static void __hists__insert_output_entry(struct rb_root *entries,
 		parent = *p;
 		iter = rb_entry(parent, struct hist_entry, rb_node);
 
-		if (hist_entry__sort_on_period(he, iter) > 0)
+		if (hist_entry__sort(he, iter) > 0)
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
@@ -674,8 +1113,7 @@ void hists__output_resort(struct hists *hists)
 	next = rb_first(root);
 	hists->entries = RB_ROOT;
 
-	hists->nr_entries = 0;
-	hists->stats.total_period = 0;
+	hists__reset_stats(hists);
 	hists__reset_col_len(hists);
 
 	while (next) {
@@ -683,7 +1121,10 @@ void hists__output_resort(struct hists *hists)
 		next = rb_next(&n->rb_node_in);
 
 		__hists__insert_output_entry(&hists->entries, n, min_callchain_hits);
-		hists__inc_nr_entries(hists, n);
+		hists__inc_stats(hists, n);
+
+		if (!n->filtered)
+			hists__calc_col_len(hists, n);
 	}
 }
 
@@ -694,13 +1135,13 @@ static void hists__remove_entry_filter(struct hists *hists, struct hist_entry *h
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
 
@@ -721,8 +1162,9 @@ void hists__filter_by_dso(struct hists *hists)
 {
 	struct rb_node *nd;
 
-	hists->nr_entries = hists->stats.total_period = 0;
-	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
+	hists->stats.nr_non_filtered_samples = 0;
+
+	hists__reset_filter_stats(hists);
 	hists__reset_col_len(hists);
 
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
@@ -754,8 +1196,9 @@ void hists__filter_by_thread(struct hists *hists)
 {
 	struct rb_node *nd;
 
-	hists->nr_entries = hists->stats.total_period = 0;
-	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
+	hists->stats.nr_non_filtered_samples = 0;
+
+	hists__reset_filter_stats(hists);
 	hists__reset_col_len(hists);
 
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
@@ -785,8 +1228,9 @@ void hists__filter_by_symbol(struct hists *hists)
 {
 	struct rb_node *nd;
 
-	hists->nr_entries = hists->stats.total_period = 0;
-	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
+	hists->stats.nr_non_filtered_samples = 0;
+
+	hists__reset_filter_stats(hists);
 	hists__reset_col_len(hists);
 
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
@@ -810,6 +1254,13 @@ void hists__inc_nr_events(struct hists *hists, u32 type)
 	events_stats__inc(&hists->stats, type);
 }
 
+void hists__inc_nr_samples(struct hists *hists, bool filtered)
+{
+	events_stats__inc(&hists->stats, PERF_RECORD_SAMPLE);
+	if (!filtered)
+		hists->stats.nr_non_filtered_samples++;
+}
+
 static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
 						 struct hist_entry *pair)
 {
@@ -841,13 +1292,13 @@ static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
 			p = &(*p)->rb_right;
 	}
 
-	he = hist_entry__new(pair);
+	he = hist_entry__new(pair, true);
 	if (he) {
 		memset(&he->stat, 0, sizeof(he->stat));
 		he->hists = hists;
 		rb_link_node(&he->rb_node_in, parent, p);
 		rb_insert_color(&he->rb_node_in, root);
-		hists__inc_nr_entries(hists, he);
+		hists__inc_stats(hists, he);
 		he->dummy = true;
 	}
 out:
@@ -931,3 +1382,30 @@ int hists__link(struct hists *leader, struct hists *other)
 
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
index 1f1f513..d2bf035 100644
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
@@ -93,12 +96,50 @@ struct hists {
 	u16			col_len[HISTC_NR_COLS];
 };
 
+struct hist_entry_iter;
+
+struct hist_iter_ops {
+	int (*prepare_entry)(struct hist_entry_iter *, struct addr_location *);
+	int (*add_single_entry)(struct hist_entry_iter *, struct addr_location *);
+	int (*next_entry)(struct hist_entry_iter *, struct addr_location *);
+	int (*add_next_entry)(struct hist_entry_iter *, struct addr_location *);
+	int (*finish_entry)(struct hist_entry_iter *, struct addr_location *);
+};
+
+struct hist_entry_iter {
+	int total;
+	int curr;
+
+	bool hide_unresolved;
+
+	struct perf_evsel *evsel;
+	struct perf_sample *sample;
+	struct hist_entry *he;
+	struct symbol *parent;
+	void *priv;
+
+	const struct hist_iter_ops *ops;
+	/* user-defined callback function (optional) */
+	int (*add_entry_cb)(struct hist_entry_iter *iter,
+			    struct addr_location *al, bool single, void *arg);
+};
+
+extern const struct hist_iter_ops hist_iter_normal;
+extern const struct hist_iter_ops hist_iter_branch;
+extern const struct hist_iter_ops hist_iter_mem;
+extern const struct hist_iter_ops hist_iter_cumulative;
+
 struct hist_entry *__hists__add_entry(struct hists *hists,
 				      struct addr_location *al,
 				      struct symbol *parent,
 				      struct branch_info *bi,
 				      struct mem_info *mi, u64 period,
-				      u64 weight, u64 transaction);
+				      u64 weight, u64 transaction,
+				      bool sample_self);
+int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
+			 struct perf_evsel *evsel, struct perf_sample *sample,
+			 int max_stack_depth, void *arg);
+
 int64_t hist_entry__cmp(struct hist_entry *left, struct hist_entry *right);
 int64_t hist_entry__collapse(struct hist_entry *left, struct hist_entry *right);
 int hist_entry__transaction_len(void);
@@ -112,8 +153,11 @@ void hists__collapse_resort(struct hists *hists, struct ui_progress *prog);
 void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel);
 void hists__output_recalc_col_len(struct hists *hists, int max_rows);
 
-void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h);
+u64 hists__total_period(struct hists *hists);
+void hists__reset_stats(struct hists *hists);
+void hists__inc_stats(struct hists *hists, struct hist_entry *h);
 void hists__inc_nr_events(struct hists *hists, u32 type);
+void hists__inc_nr_samples(struct hists *hists, bool filtered);
 void events_stats__inc(struct events_stats *stats, u32 type);
 size_t events_stats__fprintf(struct events_stats *stats, FILE *fp);
 
@@ -124,6 +168,12 @@ void hists__filter_by_dso(struct hists *hists);
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
@@ -149,15 +199,30 @@ struct perf_hpp_fmt {
 		     struct hist_entry *he);
 	int (*entry)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
 		     struct hist_entry *he);
+	int64_t (*cmp)(struct hist_entry *a, struct hist_entry *b);
+	int64_t (*collapse)(struct hist_entry *a, struct hist_entry *b);
+	int64_t (*sort)(struct hist_entry *a, struct hist_entry *b);
 
 	struct list_head list;
+	struct list_head sort_list;
+	bool elide;
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
@@ -167,6 +232,7 @@ enum {
 	PERF_HPP__OVERHEAD_US,
 	PERF_HPP__OVERHEAD_GUEST_SYS,
 	PERF_HPP__OVERHEAD_GUEST_US,
+	PERF_HPP__OVERHEAD_ACC,
 	PERF_HPP__SAMPLES,
 	PERF_HPP__PERIOD,
 
@@ -175,15 +241,36 @@ enum {
 
 void perf_hpp__init(void);
 void perf_hpp__column_register(struct perf_hpp_fmt *format);
+void perf_hpp__column_unregister(struct perf_hpp_fmt *format);
 void perf_hpp__column_enable(unsigned col);
+void perf_hpp__column_disable(unsigned col);
+void perf_hpp__cancel_cumulate(void);
+
+void perf_hpp__register_sort_field(struct perf_hpp_fmt *format);
+void perf_hpp__setup_output_field(void);
+void perf_hpp__reset_output_field(void);
+void perf_hpp__append_sort_keys(void);
+
+bool perf_hpp__is_sort_entry(struct perf_hpp_fmt *format);
+bool perf_hpp__same_sort_entry(struct perf_hpp_fmt *a, struct perf_hpp_fmt *b);
+
+static inline bool perf_hpp__should_skip(struct perf_hpp_fmt *format)
+{
+	return format->elide;
+}
+
+void perf_hpp__reset_width(struct perf_hpp_fmt *fmt, struct hists *hists);
 
 typedef u64 (*hpp_field_fn)(struct hist_entry *he);
 typedef int (*hpp_callback_fn)(struct perf_hpp *hpp, bool front);
 typedef int (*hpp_snprint_fn)(struct perf_hpp *hpp, const char *fmt, ...);
 
 int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
-	       hpp_field_fn get_field, hpp_callback_fn callback,
-	       const char *fmt, hpp_snprint_fn print_fn, bool fmt_percent);
+	       hpp_field_fn get_field, const char *fmt,
+	       hpp_snprint_fn print_fn, bool fmt_percent);
+int __hpp__fmt_acc(struct perf_hpp *hpp, struct hist_entry *he,
+		   hpp_field_fn get_field, const char *fmt,
+		   hpp_snprint_fn print_fn, bool fmt_percent);
 
 static inline void advance_hpp(struct perf_hpp *hpp, int inc)
 {
@@ -250,4 +337,10 @@ static inline int script_browse(const char *script_opt __maybe_unused)
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
index 635cd8f..45512ba 100644
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
@@ -1027,19 +1047,194 @@ static struct sort_dimension memory_sort_dimensions[] = {
 
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
+	DIM(PERF_HPP__OVERHEAD_ACC, "overhead_children"),
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
+	hse->hpp.elide = false;
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
@@ -1068,8 +1263,16 @@ int sort_dimension__add(const char *tok)
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
@@ -1084,7 +1287,7 @@ int sort_dimension__add(const char *tok)
 		if (sd->entry == &sort_sym_from || sd->entry == &sort_sym_to)
 			sort__has_sym = 1;
 
-		__sort_dimension__add(sd, i + __SORT_BRANCH_STACK);
+		__sort_dimension__add(sd);
 		return 0;
 	}
 
@@ -1100,18 +1303,47 @@ int sort_dimension__add(const char *tok)
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
@@ -1133,66 +1365,235 @@ int setup_sorting(void)
 	return ret;
 }
 
-static void sort_entry__setup_elide(struct sort_entry *se,
-				    struct strlist *list,
-				    const char *list_name, FILE *fp)
+void perf_hpp__set_elide(int idx, bool elide)
+{
+	struct perf_hpp_fmt *fmt;
+	struct hpp_sort_entry *hse;
+
+	perf_hpp__for_each_format(fmt) {
+		if (!perf_hpp__is_sort_entry(fmt))
+			continue;
+
+		hse = container_of(fmt, struct hpp_sort_entry, hpp);
+		if (hse->se->se_width_idx == idx) {
+			fmt->elide = elide;
+			break;
+		}
+	}
+}
+
+static bool __get_elide(struct strlist *list, const char *list_name, FILE *fp)
 {
 	if (list && strlist__nr_entries(list) == 1) {
 		if (fp != NULL)
 			fprintf(fp, "# %s: %s\n", list_name,
 				strlist__entry(list, 0)->s);
-		se->elide = true;
+		return true;
+	}
+	return false;
+}
+
+static bool get_elide(int idx, FILE *output)
+{
+	switch (idx) {
+	case HISTC_SYMBOL:
+		return __get_elide(symbol_conf.sym_list, "symbol", output);
+	case HISTC_DSO:
+		return __get_elide(symbol_conf.dso_list, "dso", output);
+	case HISTC_COMM:
+		return __get_elide(symbol_conf.comm_list, "comm", output);
+	default:
+		break;
 	}
+
+	if (sort__mode != SORT_MODE__BRANCH)
+		return false;
+
+	switch (idx) {
+	case HISTC_SYMBOL_FROM:
+		return __get_elide(symbol_conf.sym_from_list, "sym_from", output);
+	case HISTC_SYMBOL_TO:
+		return __get_elide(symbol_conf.sym_to_list, "sym_to", output);
+	case HISTC_DSO_FROM:
+		return __get_elide(symbol_conf.dso_from_list, "dso_from", output);
+	case HISTC_DSO_TO:
+		return __get_elide(symbol_conf.dso_to_list, "dso_to", output);
+	default:
+		break;
+	}
+
+	return false;
 }
 
 void sort__setup_elide(FILE *output)
 {
-	struct sort_entry *se;
+	struct perf_hpp_fmt *fmt;
+	struct hpp_sort_entry *hse;
 
-	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
-				"dso", output);
-	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list,
-				"comm", output);
-	sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list,
-				"symbol", output);
-
-	if (sort__mode == SORT_MODE__BRANCH) {
-		sort_entry__setup_elide(&sort_dso_from,
-					symbol_conf.dso_from_list,
-					"dso_from", output);
-		sort_entry__setup_elide(&sort_dso_to,
-					symbol_conf.dso_to_list,
-					"dso_to", output);
-		sort_entry__setup_elide(&sort_sym_from,
-					symbol_conf.sym_from_list,
-					"sym_from", output);
-		sort_entry__setup_elide(&sort_sym_to,
-					symbol_conf.sym_to_list,
-					"sym_to", output);
-	} else if (sort__mode == SORT_MODE__MEMORY) {
-		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
-					"symbol_daddr", output);
-		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
-					"dso_daddr", output);
-		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
-					"mem", output);
-		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
-					"local_weight", output);
-		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
-					"tlb", output);
-		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
-					"snoop", output);
+	perf_hpp__for_each_format(fmt) {
+		if (!perf_hpp__is_sort_entry(fmt))
+			continue;
+
+		hse = container_of(fmt, struct hpp_sort_entry, hpp);
+		fmt->elide = get_elide(hse->se->se_width_idx, output);
 	}
 
 	/*
 	 * It makes no sense to elide all of sort entries.
 	 * Just revert them to show up again.
 	 */
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		if (!se->elide)
+	perf_hpp__for_each_format(fmt) {
+		if (!perf_hpp__is_sort_entry(fmt))
+			continue;
+
+		if (!fmt->elide)
 			return;
 	}
 
-	list_for_each_entry(se, &hist_entry__sort_list, list)
-		se->elide = false;
+	perf_hpp__for_each_format(fmt) {
+		if (!perf_hpp__is_sort_entry(fmt))
+			continue;
+
+		fmt->elide = false;
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
+	field_order = NULL;
+	sort_order = NULL;
+
+	reset_dimensions();
+	perf_hpp__reset_output_field();
 }
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 43e5ff4..5bf0098 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -20,11 +20,12 @@
 
 #include "parse-options.h"
 #include "parse-events.h"
-
+#include "hist.h"
 #include "thread.h"
 
 extern regex_t parent_regex;
 extern const char *sort_order;
+extern const char *field_order;
 extern const char default_parent_pattern[];
 extern const char *parent_pattern;
 extern const char default_sort_order[];
@@ -81,6 +82,7 @@ struct hist_entry {
 		struct list_head head;
 	} pairs;
 	struct he_stat		stat;
+	struct he_stat		*stat_acc;
 	struct map_symbol	ms;
 	struct thread		*thread;
 	struct comm		*comm;
@@ -129,10 +131,27 @@ static inline void hist_entry__add_pair(struct hist_entry *pair,
 	list_add_tail(&pair->pairs.node, &he->pairs.head);
 }
 
+static inline float hist_entry__get_percent_limit(struct hist_entry *he)
+{
+	u64 period = he->stat.period;
+	u64 total_period = hists__total_period(he->hists);
+
+	if (unlikely(total_period == 0))
+		return 0;
+
+	if (symbol_conf.cumulate_callchain)
+		period = he->stat_acc->period;
+
+	return period * 100.0 / total_period;
+}
+
+
 enum sort_mode {
 	SORT_MODE__NORMAL,
 	SORT_MODE__BRANCH,
 	SORT_MODE__MEMORY,
+	SORT_MODE__TOP,
+	SORT_MODE__DIFF,
 };
 
 enum sort_type {
@@ -179,18 +198,21 @@ struct sort_entry {
 
 	int64_t (*se_cmp)(struct hist_entry *, struct hist_entry *);
 	int64_t (*se_collapse)(struct hist_entry *, struct hist_entry *);
+	int64_t	(*se_sort)(struct hist_entry *, struct hist_entry *);
 	int	(*se_snprintf)(struct hist_entry *he, char *bf, size_t size,
 			       unsigned int width);
 	u8	se_width_idx;
-	bool	elide;
 };
 
 extern struct sort_entry sort_thread;
 extern struct list_head hist_entry__sort_list;
 
 int setup_sorting(void);
+int setup_output_field(void);
+void reset_output_field(void);
 extern int sort_dimension__add(const char *);
 void sort__setup_elide(FILE *fp);
+void perf_hpp__set_elide(int idx, bool elide);
 
 int report_parse_ignore_callees_opt(const struct option *opt, const char *arg, int unset);
 
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
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 95e2497..7b9096f 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -29,11 +29,12 @@ int vmlinux_path__nr_entries;
 char **vmlinux_path;
 
 struct symbol_conf symbol_conf = {
-	.use_modules	  = true,
-	.try_vmlinux_path = true,
-	.annotate_src	  = true,
-	.demangle	  = true,
-	.symfs            = "",
+	.use_modules		= true,
+	.try_vmlinux_path	= true,
+	.annotate_src		= true,
+	.demangle		= true,
+	.cumulate_callchain	= true,
+	.symfs			= "",
 };
 
 static enum dso_binary_type binary_type_symtab[] = {
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 501e4e7..615c752 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -12,6 +12,7 @@
 #include <byteswap.h>
 #include <libgen.h>
 #include "build-id.h"
+#include "event.h"
 
 #ifdef HAVE_LIBELF_SUPPORT
 #include <libelf.h>
@@ -108,6 +109,7 @@ struct symbol_conf {
 			show_nr_samples,
 			show_total_period,
 			use_callchain,
+			cumulate_callchain,
 			exclude_other,
 			show_cpu_utilization,
 			initialized,
@@ -115,7 +117,8 @@ struct symbol_conf {
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
