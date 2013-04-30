Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396Ab3D3Gx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 02:53:28 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:33113 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab3D3GxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 02:53:20 -0400
Date: Tue, 30 Apr 2013 08:53:12 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf changes for v3.10
Message-ID: <20130430065312.GA19554@gmail.com>
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

   HEAD: 5ac2b5c2721501a8f5c5e1cd4116cbc31ace6886 perf/x86/intel/P4: Robistify P4 PMU types

This was another active development cycle for instrumentation:

 130 files changed, 5670 insertions(+), 1708 deletions(-)

Features:
    
      * Add "uretprobes" - an optimization to uprobes, like kretprobes are 
        an optimization to kprobes. "perf probe -x file sym%return" now 
        works like kretprobes. By Oleg Nesterov.
    
      * Introduce per core aggregation in 'perf stat', from Stephane Eranian.
    
      * Add memory profiling via PEBS, from Stephane Eranian.
    
      * Event group view for 'annotate' in --stdio, --tui and --gtk, from Namhyung Kim.

      * Add support for AMD NB and L2I "uncore" counters, by Jacob Shin.

      * Add Ivy Bridge-EP uncore support, by Zheng Yan

      * IBM zEnterprise EC12 oprofile support patchlet from Robert Richter.
  
      * Add perf test entries for checking breakpoint overflow signal handler issues,
        from Jiri Olsa.
    
      * Add perf test entry for for checking number of EXIT events, from Namhyung Kim.
    
      * Add perf test entries for checking --cpu in record and stat, from Jiri Olsa.
    
      * Introduce perf stat --repeat forever, from Frederik Deweerdt.
    
      * Add --no-demangle to report/top, from Namhyung Kim.
    
      * PowerPC fixes plus a couple of cleanups/optimizations in uprobes and trace_uprobes,
        by Oleg Nesterov.
   
Various fixes and refactorings:

      * Fix dependency of the python binding wrt libtraceevent, from Naohiro Aota.
    
      * Simplify some perf_evlist methods and to allow 'stat' to share code with
        'record' and 'trace', by Arnaldo Carvalho de Melo.
    
      * Remove dead code in related to libtraceevent integration, from Namhyung Kim.

      * Revert "perf sched: Handle PERF_RECORD_EXIT events" to get 'perf sched lat'
        back working, by Arnaldo Carvalho de Melo
    
      * We don't use Newt anymore, just plain libslang, by Arnaldo Carvalho de Melo.
    
      * Kill a bunch of die() calls, from Namhyung Kim.
    
      * Fix build on non-glibc systems due to libio.h absence, from Cody P Schafer.
    
      * Remove some perf_session and tracing dead code, from David Ahern.
    
      * Honor parallel jobs, fix from Borislav Petkov
    
      * Introduce tools/lib/lk library, initially just removing duplication
        among tools/perf and tools/vm. from Borislav Petkov

... and many more I missed to list, see the shortlog and git log for more 
details.
 
 Thanks,

	Ingo

------------------>
Ananth N Mavinakayanahalli (3):
      uprobes: Add trap variant helper
      uprobes/powerpc: Teach uprobes to ignore gdb breakpoints
      uprobes/powerpc: Remove additional trap instruction check

Andi Kleen (4):
      perf/x86: Support CPU specific sysfs events
      perf/core: Add weighted samples
      perf tools: Add support for weight v7 (modified)
      perf/x86: Add Sandy Bridge constraints for CYCLE_ACTIVITY.*

Andreas Krebbel (1):
      oprofile, s390: Add support for IBM zEnterprise EC12

Anton Arapov (9):
      uretprobes: Introduce uprobe_consumer->ret_handler()
      uretprobes: Reserve the first slot in xol_vma for trampoline
      uretprobes/x86: Hijack return address
      uretprobes/powerpc: Hijack return address
      uretprobes: Return probe entry, prepare_uretprobe()
      uretprobes: Return probe exit, invoke handlers
      uretprobes: Limit the depth of return probe nestedness
      uretprobes: Remove -ENOSYS as return probes implemented
      uretprobes: Documentation update

Arnaldo Carvalho de Melo (6):
      perf stat: Introduce evlist methods to allocate/free the stats
      Revert "perf sched: Handle PERF_RECORD_EXIT events"
      perf tools: Convert needless static variable to local
      perf map browser: Use ui_browser__input_window()
      perf tools: Remove dependency on libnewt
      perf map browser: Exit just on well known key presses

Borislav Petkov (7):
      perf tools: Remove a write-only variable in the debugfs code
      perf tools: Honor parallel jobs
      perf tools: Correct Makefile.include
      perf tools: Introduce tools/lib/lk library
      perf tools: Extract perf-specific stuff from debugfs.c
      tools/vm: Switch to liblk library
      tools lib lk: Fix _FORTIFY_SOURCE builds

Cody P Schafer (1):
      perf tools: Fix build on non-glibc systems due to libio.h absence

David Ahern (3):
      perf tools: Remove unused tracing functions
      perf session: Remove unused perf_session__remove_thread method
      perf machine: Move machine__remove_thread and make static

Frederik Deweerdt (1):
      perf stat: Introduce --repeat forever

George Dunlap (1):
      perf/x86: Check all MSRs before passing hw check

Ingo Molnar (1):
      perf/x86/intel/P4: Robistify P4 PMU types

Jacob Shin (3):
      perf/x86/amd: Add support for AMD NB and L2I "uncore" counters
      perf/x86/amd: Remove old-style NB counter support from perf_event_amd.c
      perf/x86/amd: Fix AMD NB and L2I "uncore" support

Jiri Olsa (6):
      perf tests: Make attr script verbose friendly
      perf tests: Make attr script test event cpu
      perf tests: Add attr record -C cpu test
      perf tests: Add attr stat -C cpu test
      perf tests: Test breakpoint overflow signal handler
      perf tests: Test breakpoint overflow signal handler counts

Li Zefan (1):
      perf: Remove include of cgroup.h from perf_event.h

Masami Hiramatsu (2):
      kprobes: Move __kprobes definition into compiler.h
      kprobes/x86: Just return error for sanity check failure instead of using BUG_ON

Namhyung Kim (46):
      perf evlist: Remove cpus and threads arguments from perf_evlist__new()
      perf evlist: Use cpu_map__nr() helper
      perf evlist: Add thread_map__nr() helper
      perf evlist: Pass struct perf_target to perf_evlist__prepare_workload()
      perf evlist: Do not pass struct record_opts to perf_evlist__prepare_workload()
      perf evlist: Add want_signal parameter to perf_evlist__prepare_workload()
      perf stat: Use perf_evlist__prepare/start_workload()
      perf annotate: Pass evsel instead of evidx on annotation functions
      perf annotate: Add a comment on the symbol__parse_objdump_line()
      perf annotate: Factor out disasm__calc_percent()
      perf annotate: Cleanup disasm__calc_percent()
      perf annotate: Add basic support to event group view
      perf evsel: Introduce perf_evsel__is_group_event() helper
      perf annotate: Factor out struct source_line_percent
      perf annotate: Support event group view for --print-line
      perf annotate browser: Make browser_disasm_line->percent an array
      perf annotate browser: Use disasm__calc_percent()
      perf annotate/gtk: Support event group view on GTK
      perf annotate browser: Support event group view on TUI
      perf trace: Get rid of a duplicate code
      perf tools: Remove unused trace_read_data function
      perf tools: Remove unused struct definitions
      perf tools: Remove unnecessary calc_data_size variable
      perf tools: Remove unused macro definitions
      perf tools: Remove duplicated page_size definition
      perf evsel: Cleanup perf_evsel__exit()
      perf evlist: Introduce perf_evlist__close()
      perf trace: Free evlist resources properly on return path
      perf record: Fixup return path of cmd_record()
      perf tests: Fixup return path of open-syscall-tp-fields test case
      perf tests: Fixup return path of perf record test case
      perf test: Add test case for checking number of EXIT events
      perf/cgroup: Add __percpu annotation to perf_cgroup->info
      perf tests: Add a test case for checking sw clock event frequency
      perf tools: Get rid of redundant _FILE_OFFSET_BITS definition
      perf tools: Let get_tracing_file() return NULL to indicate failure.
      perf tools: Get rid of malloc_or_die() in trace-event-info.c
      perf tools: Get rid of write_or_die() from trace-event-info.c
      perf tools: Get rid of die() calls from trace-event-info.c
      perf tools: Handle failure case in trace_report()
      perf tools: Get rid of malloc_or_die() in trace-event-read.c
      perf tools: Get rid of read_or_die() in trace-event-read.c
      perf tools: Get rid of die() calls in trace-data-read.c
      perf tools: Cleanup calc_data_size logic
      perf report: Add --no-demangle option
      perf tools: Fix output of symbol_daddr offset

Naohiro Aota (1):
      perf python: Fix dependency for python/perf.so

Oleg Nesterov (18):
      uprobes: Use file_inode()
      uprobes: Turn copy_opcode() into copy_from_page()
      uprobes: Change __copy_insn() to use copy_from_page()
      uprobes: Kill the unnecesary filp != NULL check in __copy_insn()
      uprobes: Introduce copy_to_page()
      uprobes: Change write_opcode() to use copy_*page()
      uprobes/tracing: Kill the pointless task_pt_regs() calls
      uprobes/tracing: Kill the pointless seq_print_ip_sym() call
      uprobes/tracing: Kill the pointless local_save_flags/preempt_count calls
      uprobes/tracing: Generalize struct uprobe_trace_entry_head
      uprobes/tracing: Introduce uprobe_{trace,perf}_print() helpers
      uprobes/tracing: Introduce is_ret_probe() and uretprobe_dispatcher()
      uprobes/tracing: Make uprobe_{trace,perf}_print() uretprobe-friendly
      uprobes/tracing: Make register_uprobe_event() paths uretprobe-friendly
      uprobes/tracing: Make seq_printf() code uretprobe-friendly
      uprobes/tracing: Change create_trace_uprobe() to support uretprobes
      uprobes/tracing: Don't pass addr=ip to perf_trace_buf_submit()
      uprobes/perf: Avoid perf_trace_buf_prepare/submit if ->perf_events is empty

Stephane Eranian (16):
      perf stat: Refactor aggregation code
      perf stat: Rename --aggr-socket to --per-socket
      perf stat: Add per-core aggregation
      perf/x86: Improve sysfs event mapping with event string
      perf/x86: Add flags to event constraints
      perf: Add generic memory sampling interface
      perf/x86: Add memory profiling via PEBS Load Latency
      perf/x86: Export PEBS load latency threshold register to sysfs
      perf/x86: Add support for PEBS Precise Store
      perf: Add PERF_RECORD_MISC_MMAP_DATA to RECORD_MMAP
      perf tools: Add mem access sampling core support
      perf record: Add support for mem access profiling
      perf report: Add support for mem access profiling
      perf tools: Add new mem command for memory access profiling
      perf machine: Detect data vs. text mappings
      perf: Fix comments in PERF_MEM_LVL bitmask

Wei Yongjun (1):
      perf report: Remove duplicated include

Yan, Zheng (3):
      perf/x86: Avoid kfree() in CPU_{STARTING,DYING}
      perf/x86/intel: Fix SNB-EP CBO and PCU uncore PMU filter management
      perf/x86/intel: Add Ivy Bridge-EP uncore support

anish kumar (1):
      watchdog: Add comments to explain the watchdog_disabled variable

liguang (1):
      perf tools: Sort command-list.txt alphabetically


 Documentation/trace/uprobetracer.txt          | 114 ++--
 Makefile                                      |   4 +-
 arch/powerpc/include/asm/uprobes.h            |   1 +
 arch/powerpc/kernel/uprobes.c                 |  29 +-
 arch/s390/oprofile/init.c                     |   1 +
 arch/x86/include/asm/cpufeature.h             |   2 +
 arch/x86/include/asm/perf_event_p4.h          |  62 +-
 arch/x86/include/asm/uprobes.h                |   1 +
 arch/x86/include/uapi/asm/msr-index.h         |   5 +
 arch/x86/kernel/cpu/Makefile                  |   2 +-
 arch/x86/kernel/cpu/perf_event.c              |  89 ++-
 arch/x86/kernel/cpu/perf_event.h              |  56 +-
 arch/x86/kernel/cpu/perf_event_amd.c          | 138 +---
 arch/x86/kernel/cpu/perf_event_amd_uncore.c   | 547 ++++++++++++++++
 arch/x86/kernel/cpu/perf_event_intel.c        |  38 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c     | 182 +++++-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 876 +++++++++++++++++++++++---
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |  64 +-
 arch/x86/kernel/cpu/perf_event_p4.c           |   9 +-
 arch/x86/kernel/kprobes/core.c                |   6 +-
 arch/x86/kernel/uprobes.c                     |  29 +
 include/linux/compiler.h                      |   6 +
 include/linux/kprobes.h                       |   6 +-
 include/linux/perf_event.h                    |  24 +-
 include/linux/uprobes.h                       |   8 +
 include/uapi/linux/perf_event.h               |  71 ++-
 kernel/events/core.c                          |  30 +
 kernel/events/uprobes.c                       | 300 +++++++--
 kernel/trace/trace.h                          |   5 -
 kernel/trace/trace_uprobe.c                   | 203 ++++--
 kernel/watchdog.c                             |   5 +
 tools/Makefile                                |  16 +-
 tools/lib/lk/Makefile                         |  35 +
 tools/{perf/util => lib/lk}/debugfs.c         |  49 +-
 tools/lib/lk/debugfs.h                        |  29 +
 tools/perf/Documentation/perf-annotate.txt    |   3 +
 tools/perf/Documentation/perf-mem.txt         |  48 ++
 tools/perf/Documentation/perf-record.txt      |   6 +
 tools/perf/Documentation/perf-report.txt      |   6 +-
 tools/perf/Documentation/perf-stat.txt        |  12 +-
 tools/perf/Documentation/perf-top.txt         |   2 +-
 tools/perf/MANIFEST                           |   1 +
 tools/perf/Makefile                           |  61 +-
 tools/perf/arch/arm/util/dwarf-regs.c         |   5 +-
 tools/perf/arch/powerpc/util/dwarf-regs.c     |   5 +-
 tools/perf/arch/s390/util/dwarf-regs.c        |   2 +-
 tools/perf/arch/sh/util/dwarf-regs.c          |   2 +-
 tools/perf/arch/sparc/util/dwarf-regs.c       |   2 +-
 tools/perf/arch/x86/util/dwarf-regs.c         |   2 +-
 tools/perf/builtin-annotate.c                 |  25 +-
 tools/perf/builtin-diff.c                     |   7 +-
 tools/perf/builtin-kvm.c                      |   2 +-
 tools/perf/builtin-mem.c                      | 242 +++++++
 tools/perf/builtin-probe.c                    |   2 +-
 tools/perf/builtin-record.c                   |  15 +-
 tools/perf/builtin-report.c                   | 150 ++++-
 tools/perf/builtin-sched.c                    |   1 -
 tools/perf/builtin-stat.c                     | 398 +++++++-----
 tools/perf/builtin-top.c                      |   9 +-
 tools/perf/builtin-trace.c                    |  28 +-
 tools/perf/builtin.h                          |   1 +
 tools/perf/command-list.txt                   |  15 +-
 tools/perf/config/feature-tests.mak           |  12 +-
 tools/perf/perf.c                             |  12 +-
 tools/perf/perf.h                             |   1 +
 tools/perf/tests/attr.c                       |   9 +-
 tools/perf/tests/attr.py                      |   5 +-
 tools/perf/tests/attr/base-record             |   1 +
 tools/perf/tests/attr/base-stat               |   1 +
 tools/perf/tests/attr/test-record-C0          |  13 +
 tools/perf/tests/attr/test-stat-C0            |   9 +
 tools/perf/tests/bp_signal.c                  | 186 ++++++
 tools/perf/tests/bp_signal_overflow.c         | 126 ++++
 tools/perf/tests/builtin-test.c               |  16 +
 tools/perf/tests/evsel-roundtrip-name.c       |   4 +-
 tools/perf/tests/hists_link.c                 |   6 +-
 tools/perf/tests/mmap-basic.c                 |   4 +-
 tools/perf/tests/open-syscall-tp-fields.c     |  10 +-
 tools/perf/tests/parse-events.c               |   4 +-
 tools/perf/tests/perf-record.c                |   9 +-
 tools/perf/tests/sw-clock.c                   | 119 ++++
 tools/perf/tests/task-exit.c                  | 123 ++++
 tools/perf/tests/tests.h                      |   4 +
 tools/perf/ui/browser.c                       |   9 +-
 tools/perf/ui/browser.h                       |   1 +
 tools/perf/ui/browsers/annotate.c             | 158 +++--
 tools/perf/ui/browsers/hists.c                |   7 +-
 tools/perf/ui/browsers/map.c                  |  60 +-
 tools/perf/ui/browsers/scripts.c              |   1 -
 tools/perf/ui/gtk/annotate.c                  |  26 +-
 tools/perf/ui/gtk/hists.c                     |   7 +-
 tools/perf/ui/hist.c                          |   7 +-
 tools/perf/ui/tui/setup.c                     |  21 +-
 tools/perf/ui/ui.h                            |   2 +-
 tools/perf/util/annotate.c                    | 262 ++++++--
 tools/perf/util/annotate.h                    |  51 +-
 tools/perf/util/cpumap.c                      |  86 ++-
 tools/perf/util/cpumap.h                      |  12 +
 tools/perf/util/debugfs.h                     |  12 -
 tools/perf/util/event.h                       |   9 +
 tools/perf/util/evlist.c                      |  73 ++-
 tools/perf/util/evlist.h                      |   9 +-
 tools/perf/util/evsel.c                       |  32 +-
 tools/perf/util/evsel.h                       |  25 +
 tools/perf/util/header.c                      |  15 +-
 tools/perf/util/hist.c                        | 110 +++-
 tools/perf/util/hist.h                        |  28 +-
 tools/perf/util/machine.c                     |  64 +-
 tools/perf/util/machine.h                     |   4 +-
 tools/perf/util/parse-events.c                |   2 +-
 tools/perf/util/probe-event.c                 |   2 +-
 tools/perf/util/python-ext-sources            |   1 -
 tools/perf/util/session.c                     |  20 +-
 tools/perf/util/session.h                     |   1 -
 tools/perf/util/setup.py                      |   3 +-
 tools/perf/util/sort.c                        | 414 +++++++++++-
 tools/perf/util/sort.h                        |  12 +-
 tools/perf/util/symbol-elf.c                  |   9 +-
 tools/perf/util/symbol.c                      |   1 +
 tools/perf/util/symbol.h                      |   9 +-
 tools/perf/util/thread_map.h                  |   5 +
 tools/perf/util/trace-event-info.c            | 380 +++++++----
 tools/perf/util/trace-event-parse.c           |  37 --
 tools/perf/util/trace-event-read.c            | 473 ++++++--------
 tools/perf/util/trace-event.h                 |   6 +-
 tools/perf/util/util.c                        |  27 +
 tools/perf/util/util.h                        |   9 +-
 tools/scripts/Makefile.include                |   6 +-
 tools/vm/Makefile                             |  17 +-
 tools/vm/page-types.c                         |  85 +--
 130 files changed, 5670 insertions(+), 1708 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/perf_event_amd_uncore.c
 create mode 100644 tools/lib/lk/Makefile
 rename tools/{perf/util => lib/lk}/debugfs.c (68%)
 create mode 100644 tools/lib/lk/debugfs.h
 create mode 100644 tools/perf/Documentation/perf-mem.txt
 create mode 100644 tools/perf/builtin-mem.c
 create mode 100644 tools/perf/tests/attr/test-record-C0
 create mode 100644 tools/perf/tests/attr/test-stat-C0
 create mode 100644 tools/perf/tests/bp_signal.c
 create mode 100644 tools/perf/tests/bp_signal_overflow.c
 create mode 100644 tools/perf/tests/sw-clock.c
 create mode 100644 tools/perf/tests/task-exit.c
 delete mode 100644 tools/perf/util/debugfs.h

diff --git a/Documentation/trace/uprobetracer.txt b/Documentation/trace/uprobetracer.txt
index 24ce682..d9c3e68 100644
--- a/Documentation/trace/uprobetracer.txt
+++ b/Documentation/trace/uprobetracer.txt
@@ -1,6 +1,8 @@
-		Uprobe-tracer: Uprobe-based Event Tracing
-		=========================================
-                 Documentation written by Srikar Dronamraju
+            Uprobe-tracer: Uprobe-based Event Tracing
+            =========================================
+
+           Documentation written by Srikar Dronamraju
+
 
 Overview
 --------
@@ -13,78 +15,94 @@ current_tracer. Instead of that, add probe points via
 /sys/kernel/debug/tracing/events/uprobes/<EVENT>/enabled.
 
 However unlike kprobe-event tracer, the uprobe event interface expects the
-user to calculate the offset of the probepoint in the object
+user to calculate the offset of the probepoint in the object.
 
 Synopsis of uprobe_tracer
 -------------------------
-  p[:[GRP/]EVENT] PATH:SYMBOL[+offs] [FETCHARGS]	: Set a probe
+  p[:[GRP/]EVENT] PATH:SYMBOL[+offs] [FETCHARGS] : Set a uprobe
+  r[:[GRP/]EVENT] PATH:SYMBOL[+offs] [FETCHARGS] : Set a return uprobe (uretprobe)
+  -:[GRP/]EVENT                                  : Clear uprobe or uretprobe event
 
- GRP		: Group name. If omitted, use "uprobes" for it.
- EVENT		: Event name. If omitted, the event name is generated
-		  based on SYMBOL+offs.
- PATH		: path to an executable or a library.
- SYMBOL[+offs]	: Symbol+offset where the probe is inserted.
+  GRP           : Group name. If omitted, "uprobes" is the default value.
+  EVENT         : Event name. If omitted, the event name is generated based
+                  on SYMBOL+offs.
+  PATH          : Path to an executable or a library.
+  SYMBOL[+offs] : Symbol+offset where the probe is inserted.
 
- FETCHARGS	: Arguments. Each probe can have up to 128 args.
-  %REG		: Fetch register REG
+  FETCHARGS     : Arguments. Each probe can have up to 128 args.
+   %REG         : Fetch register REG
 
 Event Profiling
 ---------------
- You can check the total number of probe hits and probe miss-hits via
+You can check the total number of probe hits and probe miss-hits via
 /sys/kernel/debug/tracing/uprobe_profile.
- The first column is event name, the second is the number of probe hits,
+The first column is event name, the second is the number of probe hits,
 the third is the number of probe miss-hits.
 
 Usage examples
 --------------
-To add a probe as a new event, write a new definition to uprobe_events
-as below.
+ * Add a probe as a new uprobe event, write a new definition to uprobe_events
+as below: (sets a uprobe at an offset of 0x4245c0 in the executable /bin/bash)
+
+    echo 'p: /bin/bash:0x4245c0' > /sys/kernel/debug/tracing/uprobe_events
+
+ * Add a probe as a new uretprobe event:
+
+    echo 'r: /bin/bash:0x4245c0' > /sys/kernel/debug/tracing/uprobe_events
+
+ * Unset registered event:
 
-  echo 'p: /bin/bash:0x4245c0' > /sys/kernel/debug/tracing/uprobe_events
+    echo '-:bash_0x4245c0' >> /sys/kernel/debug/tracing/uprobe_events
 
- This sets a uprobe at an offset of 0x4245c0 in the executable /bin/bash
+ * Print out the events that are registered:
 
-  echo > /sys/kernel/debug/tracing/uprobe_events
+    cat /sys/kernel/debug/tracing/uprobe_events
 
- This clears all probe points.
+ * Clear all events:
 
-The following example shows how to dump the instruction pointer and %ax
-a register at the probed text address.  Here we are trying to probe
-function zfree in /bin/zsh
+    echo > /sys/kernel/debug/tracing/uprobe_events
+
+Following example shows how to dump the instruction pointer and %ax register
+at the probed text address. Probe zfree function in /bin/zsh:
 
     # cd /sys/kernel/debug/tracing/
-    # cat /proc/`pgrep  zsh`/maps | grep /bin/zsh | grep r-xp
+    # cat /proc/`pgrep zsh`/maps | grep /bin/zsh | grep r-xp
     00400000-0048a000 r-xp 00000000 08:03 130904 /bin/zsh
     # objdump -T /bin/zsh | grep -w zfree
     0000000000446420 g    DF .text  0000000000000012  Base        zfree
 
-0x46420 is the offset of zfree in object /bin/zsh that is loaded at
-0x00400000. Hence the command to probe would be :
+  0x46420 is the offset of zfree in object /bin/zsh that is loaded at
+  0x00400000. Hence the command to uprobe would be:
+
+    # echo 'p:zfree_entry /bin/zsh:0x46420 %ip %ax' > uprobe_events
+
+  And the same for the uretprobe would be:
 
-    # echo 'p /bin/zsh:0x46420 %ip %ax' > uprobe_events
+    # echo 'r:zfree_exit /bin/zsh:0x46420 %ip %ax' >> uprobe_events
 
-Please note: User has to explicitly calculate the offset of the probepoint
+Please note: User has to explicitly calculate the offset of the probe-point
 in the object. We can see the events that are registered by looking at the
 uprobe_events file.
 
     # cat uprobe_events
-    p:uprobes/p_zsh_0x46420 /bin/zsh:0x00046420 arg1=%ip arg2=%ax
+    p:uprobes/zfree_entry /bin/zsh:0x00046420 arg1=%ip arg2=%ax
+    r:uprobes/zfree_exit /bin/zsh:0x00046420 arg1=%ip arg2=%ax
 
-The format of events can be seen by viewing the file events/uprobes/p_zsh_0x46420/format
+Format of events can be seen by viewing the file events/uprobes/zfree_entry/format
 
-    # cat events/uprobes/p_zsh_0x46420/format
-    name: p_zsh_0x46420
+    # cat events/uprobes/zfree_entry/format
+    name: zfree_entry
     ID: 922
     format:
-	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
-	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
-	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
-	field:int common_pid;	offset:4;	size:4;	signed:1;
-	field:int common_padding;	offset:8;	size:4;	signed:1;
+         field:unsigned short common_type;         offset:0;  size:2; signed:0;
+         field:unsigned char common_flags;         offset:2;  size:1; signed:0;
+         field:unsigned char common_preempt_count; offset:3;  size:1; signed:0;
+         field:int common_pid;                     offset:4;  size:4; signed:1;
+         field:int common_padding;                 offset:8;  size:4; signed:1;
 
-	field:unsigned long __probe_ip;	offset:12;	size:4;	signed:0;
-	field:u32 arg1;	offset:16;	size:4;	signed:0;
-	field:u32 arg2;	offset:20;	size:4;	signed:0;
+         field:unsigned long __probe_ip;           offset:12; size:4; signed:0;
+         field:u32 arg1;                           offset:16; size:4; signed:0;
+         field:u32 arg2;                           offset:20; size:4; signed:0;
 
     print fmt: "(%lx) arg1=%lx arg2=%lx", REC->__probe_ip, REC->arg1, REC->arg2
 
@@ -94,6 +112,7 @@ events, you need to enable it by:
     # echo 1 > events/uprobes/enable
 
 Lets disable the event after sleeping for some time.
+
     # sleep 20
     # echo 0 > events/uprobes/enable
 
@@ -104,10 +123,11 @@ And you can see the traced information via /sys/kernel/debug/tracing/trace.
     #
     #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
     #              | |       |          |         |
-                 zsh-24842 [006] 258544.995456: p_zsh_0x46420: (0x446420) arg1=446421 arg2=79
-                 zsh-24842 [007] 258545.000270: p_zsh_0x46420: (0x446420) arg1=446421 arg2=79
-                 zsh-24842 [002] 258545.043929: p_zsh_0x46420: (0x446420) arg1=446421 arg2=79
-                 zsh-24842 [004] 258547.046129: p_zsh_0x46420: (0x446420) arg1=446421 arg2=79
-
-Each line shows us probes were triggered for a pid 24842 with ip being
-0x446421 and contents of ax register being 79.
+                 zsh-24842 [006] 258544.995456: zfree_entry: (0x446420) arg1=446420 arg2=79
+                 zsh-24842 [007] 258545.000270: zfree_exit:  (0x446540 <- 0x446420) arg1=446540 arg2=0
+                 zsh-24842 [002] 258545.043929: zfree_entry: (0x446420) arg1=446420 arg2=79
+                 zsh-24842 [004] 258547.046129: zfree_exit:  (0x446540 <- 0x446420) arg1=446540 arg2=0
+
+Output shows us uprobe was triggered for a pid 24842 with ip being 0x446420
+and contents of ax register being 79. And uretprobe was triggered with ip at
+0x446540 with counterpart function entry at 0x446420.
diff --git a/Makefile b/Makefile
index 9cf6783..57fda9c 100644
--- a/Makefile
+++ b/Makefile
@@ -1331,11 +1331,11 @@ kernelversion:
 # Clear a bunch of variables before executing the submake
 tools/: FORCE
 	$(Q)mkdir -p $(objtree)/tools
-	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= O=$(objtree) subdir=tools -C $(src)/tools/
+	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS="$(filter --j% -j,$(MAKEFLAGS))" O=$(objtree) subdir=tools -C $(src)/tools/
 
 tools/%: FORCE
 	$(Q)mkdir -p $(objtree)/tools
-	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= O=$(objtree) subdir=tools -C $(src)/tools/ $*
+	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS="$(filter --j% -j,$(MAKEFLAGS))" O=$(objtree) subdir=tools -C $(src)/tools/ $*
 
 # Single targets
 # ---------------------------------------------------------------------------
diff --git a/arch/powerpc/include/asm/uprobes.h b/arch/powerpc/include/asm/uprobes.h
index b532060..2301602 100644
--- a/arch/powerpc/include/asm/uprobes.h
+++ b/arch/powerpc/include/asm/uprobes.h
@@ -51,4 +51,5 @@ extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
 extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
 extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
 extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
+extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs);
 #endif	/* _ASM_UPROBES_H */
diff --git a/arch/powerpc/kernel/uprobes.c b/arch/powerpc/kernel/uprobes.c
index bc77834..59f419b 100644
--- a/arch/powerpc/kernel/uprobes.c
+++ b/arch/powerpc/kernel/uprobes.c
@@ -31,6 +31,16 @@
 #define UPROBE_TRAP_NR	UINT_MAX
 
 /**
+ * is_trap_insn - check if the instruction is a trap variant
+ * @insn: instruction to be checked.
+ * Returns true if @insn is a trap variant.
+ */
+bool is_trap_insn(uprobe_opcode_t *insn)
+{
+	return (is_trap(*insn));
+}
+
+/**
  * arch_uprobe_analyze_insn
  * @mm: the probed address space.
  * @arch_uprobe: the probepoint information.
@@ -43,12 +53,6 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe,
 	if (addr & 0x03)
 		return -EINVAL;
 
-	/*
-	 * We currently don't support a uprobe on an already
-	 * existing breakpoint instruction underneath
-	 */
-	if (is_trap(auprobe->ainsn))
-		return -ENOTSUPP;
 	return 0;
 }
 
@@ -188,3 +192,16 @@ bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
 
 	return false;
 }
+
+unsigned long
+arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs)
+{
+	unsigned long orig_ret_vaddr;
+
+	orig_ret_vaddr = regs->link;
+
+	/* Replace the return addr with trampoline addr */
+	regs->link = trampoline_vaddr;
+
+	return orig_ret_vaddr;
+}
diff --git a/arch/s390/oprofile/init.c b/arch/s390/oprofile/init.c
index 584b936..ffeb17c 100644
--- a/arch/s390/oprofile/init.c
+++ b/arch/s390/oprofile/init.c
@@ -440,6 +440,7 @@ static int oprofile_hwsampler_init(struct oprofile_operations *ops)
 		switch (id.machine) {
 		case 0x2097: case 0x2098: ops->cpu_type = "s390/z10"; break;
 		case 0x2817: case 0x2818: ops->cpu_type = "s390/z196"; break;
+		case 0x2827:              ops->cpu_type = "s390/zEC12"; break;
 		default: return -ENODEV;
 		}
 	}
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 93fe929..ac10df7 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -168,6 +168,7 @@
 #define X86_FEATURE_TOPOEXT	(6*32+22) /* topology extensions CPUID leafs */
 #define X86_FEATURE_PERFCTR_CORE (6*32+23) /* core performance counter extensions */
 #define X86_FEATURE_PERFCTR_NB  (6*32+24) /* NB performance counter extensions */
+#define X86_FEATURE_PERFCTR_L2	(6*32+28) /* L2 performance counter extensions */
 
 /*
  * Auxiliary flags: Linux defined - For features scattered in various
@@ -311,6 +312,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_pclmulqdq	boot_cpu_has(X86_FEATURE_PCLMULQDQ)
 #define cpu_has_perfctr_core	boot_cpu_has(X86_FEATURE_PERFCTR_CORE)
 #define cpu_has_perfctr_nb	boot_cpu_has(X86_FEATURE_PERFCTR_NB)
+#define cpu_has_perfctr_l2	boot_cpu_has(X86_FEATURE_PERFCTR_L2)
 #define cpu_has_cx8		boot_cpu_has(X86_FEATURE_CX8)
 #define cpu_has_cx16		boot_cpu_has(X86_FEATURE_CX16)
 #define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
diff --git a/arch/x86/include/asm/perf_event_p4.h b/arch/x86/include/asm/perf_event_p4.h
index 4f7e67e..85e13cc 100644
--- a/arch/x86/include/asm/perf_event_p4.h
+++ b/arch/x86/include/asm/perf_event_p4.h
@@ -24,45 +24,45 @@
 #define ARCH_P4_CNTRVAL_MASK	((1ULL << ARCH_P4_CNTRVAL_BITS) - 1)
 #define ARCH_P4_UNFLAGGED_BIT	((1ULL) << (ARCH_P4_CNTRVAL_BITS - 1))
 
-#define P4_ESCR_EVENT_MASK	0x7e000000U
+#define P4_ESCR_EVENT_MASK	0x7e000000ULL
 #define P4_ESCR_EVENT_SHIFT	25
-#define P4_ESCR_EVENTMASK_MASK	0x01fffe00U
+#define P4_ESCR_EVENTMASK_MASK	0x01fffe00ULL
 #define P4_ESCR_EVENTMASK_SHIFT	9
-#define P4_ESCR_TAG_MASK	0x000001e0U
+#define P4_ESCR_TAG_MASK	0x000001e0ULL
 #define P4_ESCR_TAG_SHIFT	5
-#define P4_ESCR_TAG_ENABLE	0x00000010U
-#define P4_ESCR_T0_OS		0x00000008U
-#define P4_ESCR_T0_USR		0x00000004U
-#define P4_ESCR_T1_OS		0x00000002U
-#define P4_ESCR_T1_USR		0x00000001U
+#define P4_ESCR_TAG_ENABLE	0x00000010ULL
+#define P4_ESCR_T0_OS		0x00000008ULL
+#define P4_ESCR_T0_USR		0x00000004ULL
+#define P4_ESCR_T1_OS		0x00000002ULL
+#define P4_ESCR_T1_USR		0x00000001ULL
 
 #define P4_ESCR_EVENT(v)	((v) << P4_ESCR_EVENT_SHIFT)
 #define P4_ESCR_EMASK(v)	((v) << P4_ESCR_EVENTMASK_SHIFT)
 #define P4_ESCR_TAG(v)		((v) << P4_ESCR_TAG_SHIFT)
 
-#define P4_CCCR_OVF			0x80000000U
-#define P4_CCCR_CASCADE			0x40000000U
-#define P4_CCCR_OVF_PMI_T0		0x04000000U
-#define P4_CCCR_OVF_PMI_T1		0x08000000U
-#define P4_CCCR_FORCE_OVF		0x02000000U
-#define P4_CCCR_EDGE			0x01000000U
-#define P4_CCCR_THRESHOLD_MASK		0x00f00000U
+#define P4_CCCR_OVF			0x80000000ULL
+#define P4_CCCR_CASCADE			0x40000000ULL
+#define P4_CCCR_OVF_PMI_T0		0x04000000ULL
+#define P4_CCCR_OVF_PMI_T1		0x08000000ULL
+#define P4_CCCR_FORCE_OVF		0x02000000ULL
+#define P4_CCCR_EDGE			0x01000000ULL
+#define P4_CCCR_THRESHOLD_MASK		0x00f00000ULL
 #define P4_CCCR_THRESHOLD_SHIFT		20
-#define P4_CCCR_COMPLEMENT		0x00080000U
-#define P4_CCCR_COMPARE			0x00040000U
-#define P4_CCCR_ESCR_SELECT_MASK	0x0000e000U
+#define P4_CCCR_COMPLEMENT		0x00080000ULL
+#define P4_CCCR_COMPARE			0x00040000ULL
+#define P4_CCCR_ESCR_SELECT_MASK	0x0000e000ULL
 #define P4_CCCR_ESCR_SELECT_SHIFT	13
-#define P4_CCCR_ENABLE			0x00001000U
-#define P4_CCCR_THREAD_SINGLE		0x00010000U
-#define P4_CCCR_THREAD_BOTH		0x00020000U
-#define P4_CCCR_THREAD_ANY		0x00030000U
-#define P4_CCCR_RESERVED		0x00000fffU
+#define P4_CCCR_ENABLE			0x00001000ULL
+#define P4_CCCR_THREAD_SINGLE		0x00010000ULL
+#define P4_CCCR_THREAD_BOTH		0x00020000ULL
+#define P4_CCCR_THREAD_ANY		0x00030000ULL
+#define P4_CCCR_RESERVED		0x00000fffULL
 
 #define P4_CCCR_THRESHOLD(v)		((v) << P4_CCCR_THRESHOLD_SHIFT)
 #define P4_CCCR_ESEL(v)			((v) << P4_CCCR_ESCR_SELECT_SHIFT)
 
 #define P4_GEN_ESCR_EMASK(class, name, bit)	\
-	class##__##name = ((1 << bit) << P4_ESCR_EVENTMASK_SHIFT)
+	class##__##name = ((1ULL << bit) << P4_ESCR_EVENTMASK_SHIFT)
 #define P4_ESCR_EMASK_BIT(class, name)		class##__##name
 
 /*
@@ -107,7 +107,7 @@
  * P4_PEBS_CONFIG_MASK and related bits on
  * modification.)
  */
-#define P4_CONFIG_ALIASABLE		(1 << 9)
+#define P4_CONFIG_ALIASABLE		(1ULL << 9)
 
 /*
  * The bits we allow to pass for RAW events
@@ -784,17 +784,17 @@ enum P4_ESCR_EMASKS {
  * Note we have UOP and PEBS bits reserved for now
  * just in case if we will need them once
  */
-#define P4_PEBS_CONFIG_ENABLE		(1 << 7)
-#define P4_PEBS_CONFIG_UOP_TAG		(1 << 8)
-#define P4_PEBS_CONFIG_METRIC_MASK	0x3f
-#define P4_PEBS_CONFIG_MASK		0xff
+#define P4_PEBS_CONFIG_ENABLE		(1ULL << 7)
+#define P4_PEBS_CONFIG_UOP_TAG		(1ULL << 8)
+#define P4_PEBS_CONFIG_METRIC_MASK	0x3FLL
+#define P4_PEBS_CONFIG_MASK		0xFFLL
 
 /*
  * mem: Only counters MSR_IQ_COUNTER4 (16) and
  * MSR_IQ_COUNTER5 (17) are allowed for PEBS sampling
  */
-#define P4_PEBS_ENABLE			0x02000000U
-#define P4_PEBS_ENABLE_UOP_TAG		0x01000000U
+#define P4_PEBS_ENABLE			0x02000000ULL
+#define P4_PEBS_ENABLE_UOP_TAG		0x01000000ULL
 
 #define p4_config_unpack_metric(v)	(((u64)(v)) & P4_PEBS_CONFIG_METRIC_MASK)
 #define p4_config_unpack_pebs(v)	(((u64)(v)) & P4_PEBS_CONFIG_MASK)
diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index 8ff8be7..6e51979 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -55,4 +55,5 @@ extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
 extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
 extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
 extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
+extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs);
 #endif	/* _ASM_UPROBES_H */
diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
index 7a060f4..b575788 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -72,6 +72,7 @@
 #define MSR_IA32_PEBS_ENABLE		0x000003f1
 #define MSR_IA32_DS_AREA		0x00000600
 #define MSR_IA32_PERF_CAPABILITIES	0x00000345
+#define MSR_PEBS_LD_LAT_THRESHOLD	0x000003f6
 
 #define MSR_MTRRfix64K_00000		0x00000250
 #define MSR_MTRRfix16K_80000		0x00000258
@@ -195,6 +196,10 @@
 #define MSR_AMD64_IBSBRTARGET		0xc001103b
 #define MSR_AMD64_IBS_REG_COUNT_MAX	8 /* includes MSR_AMD64_IBSBRTARGET */
 
+/* Fam 16h MSRs */
+#define MSR_F16H_L2I_PERF_CTL		0xc0010230
+#define MSR_F16H_L2I_PERF_CTR		0xc0010231
+
 /* Fam 15h MSRs */
 #define MSR_F15H_PERF_CTL		0xc0010200
 #define MSR_F15H_PERF_CTR		0xc0010201
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index a0e067d..0074572 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -31,7 +31,7 @@ obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
 obj-$(CONFIG_PERF_EVENTS)		+= perf_event.o
 
 ifdef CONFIG_PERF_EVENTS
-obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd.o
+obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd.o perf_event_amd_uncore.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_knc.o perf_event_p4.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore.o
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index bf0f01a..1025f3c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -180,8 +180,9 @@ static void release_pmc_hardware(void) {}
 
 static bool check_hw_exists(void)
 {
-	u64 val, val_new = ~0;
-	int i, reg, ret = 0;
+	u64 val, val_fail, val_new= ~0;
+	int i, reg, reg_fail, ret = 0;
+	int bios_fail = 0;
 
 	/*
 	 * Check to see if the BIOS enabled any of the counters, if so
@@ -192,8 +193,11 @@ static bool check_hw_exists(void)
 		ret = rdmsrl_safe(reg, &val);
 		if (ret)
 			goto msr_fail;
-		if (val & ARCH_PERFMON_EVENTSEL_ENABLE)
-			goto bios_fail;
+		if (val & ARCH_PERFMON_EVENTSEL_ENABLE) {
+			bios_fail = 1;
+			val_fail = val;
+			reg_fail = reg;
+		}
 	}
 
 	if (x86_pmu.num_counters_fixed) {
@@ -202,8 +206,11 @@ static bool check_hw_exists(void)
 		if (ret)
 			goto msr_fail;
 		for (i = 0; i < x86_pmu.num_counters_fixed; i++) {
-			if (val & (0x03 << i*4))
-				goto bios_fail;
+			if (val & (0x03 << i*4)) {
+				bios_fail = 1;
+				val_fail = val;
+				reg_fail = reg;
+			}
 		}
 	}
 
@@ -221,14 +228,13 @@ static bool check_hw_exists(void)
 	if (ret || val != val_new)
 		goto msr_fail;
 
-	return true;
-
-bios_fail:
 	/*
 	 * We still allow the PMU driver to operate:
 	 */
-	printk(KERN_CONT "Broken BIOS detected, complain to your hardware vendor.\n");
-	printk(KERN_ERR FW_BUG "the BIOS has corrupted hw-PMU resources (MSR %x is %Lx)\n", reg, val);
+	if (bios_fail) {
+		printk(KERN_CONT "Broken BIOS detected, complain to your hardware vendor.\n");
+		printk(KERN_ERR FW_BUG "the BIOS has corrupted hw-PMU resources (MSR %x is %Lx)\n", reg_fail, val_fail);
+	}
 
 	return true;
 
@@ -1316,9 +1322,16 @@ static struct attribute_group x86_pmu_format_group = {
  */
 static void __init filter_events(struct attribute **attrs)
 {
+	struct device_attribute *d;
+	struct perf_pmu_events_attr *pmu_attr;
 	int i, j;
 
 	for (i = 0; attrs[i]; i++) {
+		d = (struct device_attribute *)attrs[i];
+		pmu_attr = container_of(d, struct perf_pmu_events_attr, attr);
+		/* str trumps id */
+		if (pmu_attr->event_str)
+			continue;
 		if (x86_pmu.event_map(i))
 			continue;
 
@@ -1330,22 +1343,45 @@ static void __init filter_events(struct attribute **attrs)
 	}
 }
 
-static ssize_t events_sysfs_show(struct device *dev, struct device_attribute *attr,
+/* Merge two pointer arrays */
+static __init struct attribute **merge_attr(struct attribute **a, struct attribute **b)
+{
+	struct attribute **new;
+	int j, i;
+
+	for (j = 0; a[j]; j++)
+		;
+	for (i = 0; b[i]; i++)
+		j++;
+	j++;
+
+	new = kmalloc(sizeof(struct attribute *) * j, GFP_KERNEL);
+	if (!new)
+		return NULL;
+
+	j = 0;
+	for (i = 0; a[i]; i++)
+		new[j++] = a[i];
+	for (i = 0; b[i]; i++)
+		new[j++] = b[i];
+	new[j] = NULL;
+
+	return new;
+}
+
+ssize_t events_sysfs_show(struct device *dev, struct device_attribute *attr,
 			  char *page)
 {
 	struct perf_pmu_events_attr *pmu_attr = \
 		container_of(attr, struct perf_pmu_events_attr, attr);
-
 	u64 config = x86_pmu.event_map(pmu_attr->id);
-	return x86_pmu.events_sysfs_show(page, config);
-}
 
-#define EVENT_VAR(_id)  event_attr_##_id
-#define EVENT_PTR(_id) &event_attr_##_id.attr.attr
+	/* string trumps id */
+	if (pmu_attr->event_str)
+		return sprintf(page, "%s", pmu_attr->event_str);
 
-#define EVENT_ATTR(_name, _id)						\
-	PMU_EVENT_ATTR(_name, EVENT_VAR(_id), PERF_COUNT_HW_##_id,	\
-			events_sysfs_show)
+	return x86_pmu.events_sysfs_show(page, config);
+}
 
 EVENT_ATTR(cpu-cycles,			CPU_CYCLES		);
 EVENT_ATTR(instructions,		INSTRUCTIONS		);
@@ -1459,16 +1495,27 @@ static int __init init_hw_perf_events(void)
 
 	unconstrained = (struct event_constraint)
 		__EVENT_CONSTRAINT(0, (1ULL << x86_pmu.num_counters) - 1,
-				   0, x86_pmu.num_counters, 0);
+				   0, x86_pmu.num_counters, 0, 0);
 
 	x86_pmu.attr_rdpmc = 1; /* enable userspace RDPMC usage by default */
 	x86_pmu_format_group.attrs = x86_pmu.format_attrs;
 
+	if (x86_pmu.event_attrs)
+		x86_pmu_events_group.attrs = x86_pmu.event_attrs;
+
 	if (!x86_pmu.events_sysfs_show)
 		x86_pmu_events_group.attrs = &empty_attrs;
 	else
 		filter_events(x86_pmu_events_group.attrs);
 
+	if (x86_pmu.cpu_events) {
+		struct attribute **tmp;
+
+		tmp = merge_attr(x86_pmu_events_group.attrs, x86_pmu.cpu_events);
+		if (!WARN_ON(!tmp))
+			x86_pmu_events_group.attrs = tmp;
+	}
+
 	pr_info("... version:                %d\n",     x86_pmu.version);
 	pr_info("... bit width:              %d\n",     x86_pmu.cntval_bits);
 	pr_info("... generic registers:      %d\n",     x86_pmu.num_counters);
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 7f5c75c..ba9aadf 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -46,6 +46,7 @@ enum extra_reg_type {
 	EXTRA_REG_RSP_0 = 0,	/* offcore_response_0 */
 	EXTRA_REG_RSP_1 = 1,	/* offcore_response_1 */
 	EXTRA_REG_LBR   = 2,	/* lbr_select */
+	EXTRA_REG_LDLAT = 3,	/* ld_lat_threshold */
 
 	EXTRA_REG_MAX		/* number of entries needed */
 };
@@ -59,7 +60,13 @@ struct event_constraint {
 	u64	cmask;
 	int	weight;
 	int	overlap;
+	int	flags;
 };
+/*
+ * struct event_constraint flags
+ */
+#define PERF_X86_EVENT_PEBS_LDLAT	0x1 /* ld+ldlat data address sampling */
+#define PERF_X86_EVENT_PEBS_ST		0x2 /* st data address sampling */
 
 struct amd_nb {
 	int nb_id;  /* NorthBridge id */
@@ -170,16 +177,17 @@ struct cpu_hw_events {
 	void				*kfree_on_online;
 };
 
-#define __EVENT_CONSTRAINT(c, n, m, w, o) {\
+#define __EVENT_CONSTRAINT(c, n, m, w, o, f) {\
 	{ .idxmsk64 = (n) },		\
 	.code = (c),			\
 	.cmask = (m),			\
 	.weight = (w),			\
 	.overlap = (o),			\
+	.flags = f,			\
 }
 
 #define EVENT_CONSTRAINT(c, n, m)	\
-	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n), 0)
+	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n), 0, 0)
 
 /*
  * The overlap flag marks event constraints with overlapping counter
@@ -203,7 +211,7 @@ struct cpu_hw_events {
  * and its counter masks must be kept at a minimum.
  */
 #define EVENT_CONSTRAINT_OVERLAP(c, n, m)	\
-	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n), 1)
+	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n), 1, 0)
 
 /*
  * Constraint on the Event code.
@@ -231,6 +239,14 @@ struct cpu_hw_events {
 #define INTEL_UEVENT_CONSTRAINT(c, n)	\
 	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
 
+#define INTEL_PLD_CONSTRAINT(c, n)	\
+	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK, \
+			   HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_LDLAT)
+
+#define INTEL_PST_CONSTRAINT(c, n)	\
+	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK, \
+			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_ST)
+
 #define EVENT_CONSTRAINT_END		\
 	EVENT_CONSTRAINT(0, 0, 0)
 
@@ -260,12 +276,22 @@ struct extra_reg {
 	.msr = (ms),		\
 	.config_mask = (m),	\
 	.valid_mask = (vm),	\
-	.idx = EXTRA_REG_##i	\
+	.idx = EXTRA_REG_##i,	\
 	}
 
 #define INTEL_EVENT_EXTRA_REG(event, msr, vm, idx)	\
 	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT, vm, idx)
 
+#define INTEL_UEVENT_EXTRA_REG(event, msr, vm, idx) \
+	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT | \
+			ARCH_PERFMON_EVENTSEL_UMASK, vm, idx)
+
+#define INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(c) \
+	INTEL_UEVENT_EXTRA_REG(c, \
+			       MSR_PEBS_LD_LAT_THRESHOLD, \
+			       0xffff, \
+			       LDLAT)
+
 #define EVENT_EXTRA_END EVENT_EXTRA_REG(0, 0, 0, 0, RSP_0)
 
 union perf_capabilities {
@@ -355,8 +381,10 @@ struct x86_pmu {
 	 */
 	int		attr_rdpmc;
 	struct attribute **format_attrs;
+	struct attribute **event_attrs;
 
 	ssize_t		(*events_sysfs_show)(char *page, u64 config);
+	struct attribute **cpu_events;
 
 	/*
 	 * CPU Hotplug hooks
@@ -421,6 +449,23 @@ do {									\
 #define ERF_NO_HT_SHARING	1
 #define ERF_HAS_RSP_1		2
 
+#define EVENT_VAR(_id)  event_attr_##_id
+#define EVENT_PTR(_id) &event_attr_##_id.attr.attr
+
+#define EVENT_ATTR(_name, _id)						\
+static struct perf_pmu_events_attr EVENT_VAR(_id) = {			\
+	.attr		= __ATTR(_name, 0444, events_sysfs_show, NULL),	\
+	.id		= PERF_COUNT_HW_##_id,				\
+	.event_str	= NULL,						\
+};
+
+#define EVENT_ATTR_STR(_name, v, str)					\
+static struct perf_pmu_events_attr event_attr_##v = {			\
+	.attr		= __ATTR(_name, 0444, events_sysfs_show, NULL),	\
+	.id		= 0,						\
+	.event_str	= str,						\
+};
+
 extern struct x86_pmu x86_pmu __read_mostly;
 
 DECLARE_PER_CPU(struct cpu_hw_events, cpu_hw_events);
@@ -628,6 +673,9 @@ int p6_pmu_init(void);
 
 int knc_pmu_init(void);
 
+ssize_t events_sysfs_show(struct device *dev, struct device_attribute *attr,
+			  char *page);
+
 #else /* CONFIG_CPU_SUP_INTEL */
 
 static inline void reserve_ds_buffers(void)
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index dfdab42..7e28d94 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -132,14 +132,11 @@ static u64 amd_pmu_event_map(int hw_event)
 	return amd_perfmon_event_map[hw_event];
 }
 
-static struct event_constraint *amd_nb_event_constraint;
-
 /*
  * Previously calculated offsets
  */
 static unsigned int event_offsets[X86_PMC_IDX_MAX] __read_mostly;
 static unsigned int count_offsets[X86_PMC_IDX_MAX] __read_mostly;
-static unsigned int rdpmc_indexes[X86_PMC_IDX_MAX] __read_mostly;
 
 /*
  * Legacy CPUs:
@@ -147,14 +144,10 @@ static unsigned int rdpmc_indexes[X86_PMC_IDX_MAX] __read_mostly;
  *
  * CPUs with core performance counter extensions:
  *   6 counters starting at 0xc0010200 each offset by 2
- *
- * CPUs with north bridge performance counter extensions:
- *   4 additional counters starting at 0xc0010240 each offset by 2
- *   (indexed right above either one of the above core counters)
  */
 static inline int amd_pmu_addr_offset(int index, bool eventsel)
 {
-	int offset, first, base;
+	int offset;
 
 	if (!index)
 		return index;
@@ -167,23 +160,7 @@ static inline int amd_pmu_addr_offset(int index, bool eventsel)
 	if (offset)
 		return offset;
 
-	if (amd_nb_event_constraint &&
-	    test_bit(index, amd_nb_event_constraint->idxmsk)) {
-		/*
-		 * calculate the offset of NB counters with respect to
-		 * base eventsel or perfctr
-		 */
-
-		first = find_first_bit(amd_nb_event_constraint->idxmsk,
-				       X86_PMC_IDX_MAX);
-
-		if (eventsel)
-			base = MSR_F15H_NB_PERF_CTL - x86_pmu.eventsel;
-		else
-			base = MSR_F15H_NB_PERF_CTR - x86_pmu.perfctr;
-
-		offset = base + ((index - first) << 1);
-	} else if (!cpu_has_perfctr_core)
+	if (!cpu_has_perfctr_core)
 		offset = index;
 	else
 		offset = index << 1;
@@ -196,36 +173,6 @@ static inline int amd_pmu_addr_offset(int index, bool eventsel)
 	return offset;
 }
 
-static inline int amd_pmu_rdpmc_index(int index)
-{
-	int ret, first;
-
-	if (!index)
-		return index;
-
-	ret = rdpmc_indexes[index];
-
-	if (ret)
-		return ret;
-
-	if (amd_nb_event_constraint &&
-	    test_bit(index, amd_nb_event_constraint->idxmsk)) {
-		/*
-		 * according to the mnual, ECX value of the NB counters is
-		 * the index of the NB counter (0, 1, 2 or 3) plus 6
-		 */
-
-		first = find_first_bit(amd_nb_event_constraint->idxmsk,
-				       X86_PMC_IDX_MAX);
-		ret = index - first + 6;
-	} else
-		ret = index;
-
-	rdpmc_indexes[index] = ret;
-
-	return ret;
-}
-
 static int amd_core_hw_config(struct perf_event *event)
 {
 	if (event->attr.exclude_host && event->attr.exclude_guest)
@@ -245,34 +192,6 @@ static int amd_core_hw_config(struct perf_event *event)
 }
 
 /*
- * NB counters do not support the following event select bits:
- *   Host/Guest only
- *   Counter mask
- *   Invert counter mask
- *   Edge detect
- *   OS/User mode
- */
-static int amd_nb_hw_config(struct perf_event *event)
-{
-	/* for NB, we only allow system wide counting mode */
-	if (is_sampling_event(event) || event->attach_state & PERF_ATTACH_TASK)
-		return -EINVAL;
-
-	if (event->attr.exclude_user || event->attr.exclude_kernel ||
-	    event->attr.exclude_host || event->attr.exclude_guest)
-		return -EINVAL;
-
-	event->hw.config &= ~(ARCH_PERFMON_EVENTSEL_USR |
-			      ARCH_PERFMON_EVENTSEL_OS);
-
-	if (event->hw.config & ~(AMD64_RAW_EVENT_MASK_NB |
-				 ARCH_PERFMON_EVENTSEL_INT))
-		return -EINVAL;
-
-	return 0;
-}
-
-/*
  * AMD64 events are detected based on their event codes.
  */
 static inline unsigned int amd_get_event_code(struct hw_perf_event *hwc)
@@ -285,11 +204,6 @@ static inline int amd_is_nb_event(struct hw_perf_event *hwc)
 	return (hwc->config & 0xe0) == 0xe0;
 }
 
-static inline int amd_is_perfctr_nb_event(struct hw_perf_event *hwc)
-{
-	return amd_nb_event_constraint && amd_is_nb_event(hwc);
-}
-
 static inline int amd_has_nb(struct cpu_hw_events *cpuc)
 {
 	struct amd_nb *nb = cpuc->amd_nb;
@@ -315,9 +229,6 @@ static int amd_pmu_hw_config(struct perf_event *event)
 	if (event->attr.type == PERF_TYPE_RAW)
 		event->hw.config |= event->attr.config & AMD64_RAW_EVENT_MASK;
 
-	if (amd_is_perfctr_nb_event(&event->hw))
-		return amd_nb_hw_config(event);
-
 	return amd_core_hw_config(event);
 }
 
@@ -341,19 +252,6 @@ static void __amd_put_nb_event_constraints(struct cpu_hw_events *cpuc,
 	}
 }
 
-static void amd_nb_interrupt_hw_config(struct hw_perf_event *hwc)
-{
-	int core_id = cpu_data(smp_processor_id()).cpu_core_id;
-
-	/* deliver interrupts only to this core */
-	if (hwc->config & ARCH_PERFMON_EVENTSEL_INT) {
-		hwc->config |= AMD64_EVENTSEL_INT_CORE_ENABLE;
-		hwc->config &= ~AMD64_EVENTSEL_INT_CORE_SEL_MASK;
-		hwc->config |= (u64)(core_id) <<
-			AMD64_EVENTSEL_INT_CORE_SEL_SHIFT;
-	}
-}
-
  /*
   * AMD64 NorthBridge events need special treatment because
   * counter access needs to be synchronized across all cores
@@ -441,9 +339,6 @@ __amd_get_nb_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *ev
 	if (new == -1)
 		return &emptyconstraint;
 
-	if (amd_is_perfctr_nb_event(hwc))
-		amd_nb_interrupt_hw_config(hwc);
-
 	return &nb->event_constraints[new];
 }
 
@@ -543,8 +438,7 @@ amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 	if (!(amd_has_nb(cpuc) && amd_is_nb_event(&event->hw)))
 		return &unconstrained;
 
-	return __amd_get_nb_event_constraints(cpuc, event,
-					      amd_nb_event_constraint);
+	return __amd_get_nb_event_constraints(cpuc, event, NULL);
 }
 
 static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
@@ -643,9 +537,6 @@ static struct event_constraint amd_f15_PMC30 = EVENT_CONSTRAINT_OVERLAP(0, 0x09,
 static struct event_constraint amd_f15_PMC50 = EVENT_CONSTRAINT(0, 0x3F, 0);
 static struct event_constraint amd_f15_PMC53 = EVENT_CONSTRAINT(0, 0x38, 0);
 
-static struct event_constraint amd_NBPMC96 = EVENT_CONSTRAINT(0, 0x3C0, 0);
-static struct event_constraint amd_NBPMC74 = EVENT_CONSTRAINT(0, 0xF0, 0);
-
 static struct event_constraint *
 amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *event)
 {
@@ -711,8 +602,8 @@ amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *ev
 			return &amd_f15_PMC20;
 		}
 	case AMD_EVENT_NB:
-		return __amd_get_nb_event_constraints(cpuc, event,
-						      amd_nb_event_constraint);
+		/* moved to perf_event_amd_uncore.c */
+		return &emptyconstraint;
 	default:
 		return &emptyconstraint;
 	}
@@ -738,7 +629,6 @@ static __initconst const struct x86_pmu amd_pmu = {
 	.eventsel		= MSR_K7_EVNTSEL0,
 	.perfctr		= MSR_K7_PERFCTR0,
 	.addr_offset            = amd_pmu_addr_offset,
-	.rdpmc_index		= amd_pmu_rdpmc_index,
 	.event_map		= amd_pmu_event_map,
 	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
 	.num_counters		= AMD64_NUM_COUNTERS,
@@ -790,23 +680,6 @@ static int setup_perfctr_core(void)
 	return 0;
 }
 
-static int setup_perfctr_nb(void)
-{
-	if (!cpu_has_perfctr_nb)
-		return -ENODEV;
-
-	x86_pmu.num_counters += AMD64_NUM_COUNTERS_NB;
-
-	if (cpu_has_perfctr_core)
-		amd_nb_event_constraint = &amd_NBPMC96;
-	else
-		amd_nb_event_constraint = &amd_NBPMC74;
-
-	printk(KERN_INFO "perf: AMD northbridge performance counters detected\n");
-
-	return 0;
-}
-
 __init int amd_pmu_init(void)
 {
 	/* Performance-monitoring supported from K7 and later: */
@@ -817,7 +690,6 @@ __init int amd_pmu_init(void)
 
 	setup_event_constraints();
 	setup_perfctr_core();
-	setup_perfctr_nb();
 
 	/* Events are common for all AMDs */
 	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
diff --git a/arch/x86/kernel/cpu/perf_event_amd_uncore.c b/arch/x86/kernel/cpu/perf_event_amd_uncore.c
new file mode 100644
index 0000000..c0c661a
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_amd_uncore.c
@@ -0,0 +1,547 @@
+/*
+ * Copyright (C) 2013 Advanced Micro Devices, Inc.
+ *
+ * Author: Jacob Shin <jacob.shin@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/perf_event.h>
+#include <linux/percpu.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/cpu.h>
+#include <linux/cpumask.h>
+
+#include <asm/cpufeature.h>
+#include <asm/perf_event.h>
+#include <asm/msr.h>
+
+#define NUM_COUNTERS_NB		4
+#define NUM_COUNTERS_L2		4
+#define MAX_COUNTERS		NUM_COUNTERS_NB
+
+#define RDPMC_BASE_NB		6
+#define RDPMC_BASE_L2		10
+
+#define COUNTER_SHIFT		16
+
+struct amd_uncore {
+	int id;
+	int refcnt;
+	int cpu;
+	int num_counters;
+	int rdpmc_base;
+	u32 msr_base;
+	cpumask_t *active_mask;
+	struct pmu *pmu;
+	struct perf_event *events[MAX_COUNTERS];
+	struct amd_uncore *free_when_cpu_online;
+};
+
+static struct amd_uncore * __percpu *amd_uncore_nb;
+static struct amd_uncore * __percpu *amd_uncore_l2;
+
+static struct pmu amd_nb_pmu;
+static struct pmu amd_l2_pmu;
+
+static cpumask_t amd_nb_active_mask;
+static cpumask_t amd_l2_active_mask;
+
+static bool is_nb_event(struct perf_event *event)
+{
+	return event->pmu->type == amd_nb_pmu.type;
+}
+
+static bool is_l2_event(struct perf_event *event)
+{
+	return event->pmu->type == amd_l2_pmu.type;
+}
+
+static struct amd_uncore *event_to_amd_uncore(struct perf_event *event)
+{
+	if (is_nb_event(event) && amd_uncore_nb)
+		return *per_cpu_ptr(amd_uncore_nb, event->cpu);
+	else if (is_l2_event(event) && amd_uncore_l2)
+		return *per_cpu_ptr(amd_uncore_l2, event->cpu);
+
+	return NULL;
+}
+
+static void amd_uncore_read(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	u64 prev, new;
+	s64 delta;
+
+	/*
+	 * since we do not enable counter overflow interrupts,
+	 * we do not have to worry about prev_count changing on us
+	 */
+
+	prev = local64_read(&hwc->prev_count);
+	rdpmcl(hwc->event_base_rdpmc, new);
+	local64_set(&hwc->prev_count, new);
+	delta = (new << COUNTER_SHIFT) - (prev << COUNTER_SHIFT);
+	delta >>= COUNTER_SHIFT;
+	local64_add(delta, &event->count);
+}
+
+static void amd_uncore_start(struct perf_event *event, int flags)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (flags & PERF_EF_RELOAD)
+		wrmsrl(hwc->event_base, (u64)local64_read(&hwc->prev_count));
+
+	hwc->state = 0;
+	wrmsrl(hwc->config_base, (hwc->config | ARCH_PERFMON_EVENTSEL_ENABLE));
+	perf_event_update_userpage(event);
+}
+
+static void amd_uncore_stop(struct perf_event *event, int flags)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	wrmsrl(hwc->config_base, hwc->config);
+	hwc->state |= PERF_HES_STOPPED;
+
+	if ((flags & PERF_EF_UPDATE) && !(hwc->state & PERF_HES_UPTODATE)) {
+		amd_uncore_read(event);
+		hwc->state |= PERF_HES_UPTODATE;
+	}
+}
+
+static int amd_uncore_add(struct perf_event *event, int flags)
+{
+	int i;
+	struct amd_uncore *uncore = event_to_amd_uncore(event);
+	struct hw_perf_event *hwc = &event->hw;
+
+	/* are we already assigned? */
+	if (hwc->idx != -1 && uncore->events[hwc->idx] == event)
+		goto out;
+
+	for (i = 0; i < uncore->num_counters; i++) {
+		if (uncore->events[i] == event) {
+			hwc->idx = i;
+			goto out;
+		}
+	}
+
+	/* if not, take the first available counter */
+	hwc->idx = -1;
+	for (i = 0; i < uncore->num_counters; i++) {
+		if (cmpxchg(&uncore->events[i], NULL, event) == NULL) {
+			hwc->idx = i;
+			break;
+		}
+	}
+
+out:
+	if (hwc->idx == -1)
+		return -EBUSY;
+
+	hwc->config_base = uncore->msr_base + (2 * hwc->idx);
+	hwc->event_base = uncore->msr_base + 1 + (2 * hwc->idx);
+	hwc->event_base_rdpmc = uncore->rdpmc_base + hwc->idx;
+	hwc->state = PERF_HES_UPTODATE | PERF_HES_STOPPED;
+
+	if (flags & PERF_EF_START)
+		amd_uncore_start(event, PERF_EF_RELOAD);
+
+	return 0;
+}
+
+static void amd_uncore_del(struct perf_event *event, int flags)
+{
+	int i;
+	struct amd_uncore *uncore = event_to_amd_uncore(event);
+	struct hw_perf_event *hwc = &event->hw;
+
+	amd_uncore_stop(event, PERF_EF_UPDATE);
+
+	for (i = 0; i < uncore->num_counters; i++) {
+		if (cmpxchg(&uncore->events[i], event, NULL) == event)
+			break;
+	}
+
+	hwc->idx = -1;
+}
+
+static int amd_uncore_event_init(struct perf_event *event)
+{
+	struct amd_uncore *uncore;
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (event->attr.type != event->pmu->type)
+		return -ENOENT;
+
+	/*
+	 * NB and L2 counters (MSRs) are shared across all cores that share the
+	 * same NB / L2 cache. Interrupts can be directed to a single target
+	 * core, however, event counts generated by processes running on other
+	 * cores cannot be masked out. So we do not support sampling and
+	 * per-thread events.
+	 */
+	if (is_sampling_event(event) || event->attach_state & PERF_ATTACH_TASK)
+		return -EINVAL;
+
+	/* NB and L2 counters do not have usr/os/guest/host bits */
+	if (event->attr.exclude_user || event->attr.exclude_kernel ||
+	    event->attr.exclude_host || event->attr.exclude_guest)
+		return -EINVAL;
+
+	/* and we do not enable counter overflow interrupts */
+	hwc->config = event->attr.config & AMD64_RAW_EVENT_MASK_NB;
+	hwc->idx = -1;
+
+	if (event->cpu < 0)
+		return -EINVAL;
+
+	uncore = event_to_amd_uncore(event);
+	if (!uncore)
+		return -ENODEV;
+
+	/*
+	 * since request can come in to any of the shared cores, we will remap
+	 * to a single common cpu.
+	 */
+	event->cpu = uncore->cpu;
+
+	return 0;
+}
+
+static ssize_t amd_uncore_attr_show_cpumask(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	int n;
+	cpumask_t *active_mask;
+	struct pmu *pmu = dev_get_drvdata(dev);
+
+	if (pmu->type == amd_nb_pmu.type)
+		active_mask = &amd_nb_active_mask;
+	else if (pmu->type == amd_l2_pmu.type)
+		active_mask = &amd_l2_active_mask;
+	else
+		return 0;
+
+	n = cpulist_scnprintf(buf, PAGE_SIZE - 2, active_mask);
+	buf[n++] = '\n';
+	buf[n] = '\0';
+	return n;
+}
+static DEVICE_ATTR(cpumask, S_IRUGO, amd_uncore_attr_show_cpumask, NULL);
+
+static struct attribute *amd_uncore_attrs[] = {
+	&dev_attr_cpumask.attr,
+	NULL,
+};
+
+static struct attribute_group amd_uncore_attr_group = {
+	.attrs = amd_uncore_attrs,
+};
+
+PMU_FORMAT_ATTR(event, "config:0-7,32-35");
+PMU_FORMAT_ATTR(umask, "config:8-15");
+
+static struct attribute *amd_uncore_format_attr[] = {
+	&format_attr_event.attr,
+	&format_attr_umask.attr,
+	NULL,
+};
+
+static struct attribute_group amd_uncore_format_group = {
+	.name = "format",
+	.attrs = amd_uncore_format_attr,
+};
+
+static const struct attribute_group *amd_uncore_attr_groups[] = {
+	&amd_uncore_attr_group,
+	&amd_uncore_format_group,
+	NULL,
+};
+
+static struct pmu amd_nb_pmu = {
+	.attr_groups	= amd_uncore_attr_groups,
+	.name		= "amd_nb",
+	.event_init	= amd_uncore_event_init,
+	.add		= amd_uncore_add,
+	.del		= amd_uncore_del,
+	.start		= amd_uncore_start,
+	.stop		= amd_uncore_stop,
+	.read		= amd_uncore_read,
+};
+
+static struct pmu amd_l2_pmu = {
+	.attr_groups	= amd_uncore_attr_groups,
+	.name		= "amd_l2",
+	.event_init	= amd_uncore_event_init,
+	.add		= amd_uncore_add,
+	.del		= amd_uncore_del,
+	.start		= amd_uncore_start,
+	.stop		= amd_uncore_stop,
+	.read		= amd_uncore_read,
+};
+
+static struct amd_uncore * __cpuinit amd_uncore_alloc(unsigned int cpu)
+{
+	return kzalloc_node(sizeof(struct amd_uncore), GFP_KERNEL,
+			cpu_to_node(cpu));
+}
+
+static void __cpuinit amd_uncore_cpu_up_prepare(unsigned int cpu)
+{
+	struct amd_uncore *uncore;
+
+	if (amd_uncore_nb) {
+		uncore = amd_uncore_alloc(cpu);
+		uncore->cpu = cpu;
+		uncore->num_counters = NUM_COUNTERS_NB;
+		uncore->rdpmc_base = RDPMC_BASE_NB;
+		uncore->msr_base = MSR_F15H_NB_PERF_CTL;
+		uncore->active_mask = &amd_nb_active_mask;
+		uncore->pmu = &amd_nb_pmu;
+		*per_cpu_ptr(amd_uncore_nb, cpu) = uncore;
+	}
+
+	if (amd_uncore_l2) {
+		uncore = amd_uncore_alloc(cpu);
+		uncore->cpu = cpu;
+		uncore->num_counters = NUM_COUNTERS_L2;
+		uncore->rdpmc_base = RDPMC_BASE_L2;
+		uncore->msr_base = MSR_F16H_L2I_PERF_CTL;
+		uncore->active_mask = &amd_l2_active_mask;
+		uncore->pmu = &amd_l2_pmu;
+		*per_cpu_ptr(amd_uncore_l2, cpu) = uncore;
+	}
+}
+
+static struct amd_uncore *
+__cpuinit amd_uncore_find_online_sibling(struct amd_uncore *this,
+					 struct amd_uncore * __percpu *uncores)
+{
+	unsigned int cpu;
+	struct amd_uncore *that;
+
+	for_each_online_cpu(cpu) {
+		that = *per_cpu_ptr(uncores, cpu);
+
+		if (!that)
+			continue;
+
+		if (this == that)
+			continue;
+
+		if (this->id == that->id) {
+			that->free_when_cpu_online = this;
+			this = that;
+			break;
+		}
+	}
+
+	this->refcnt++;
+	return this;
+}
+
+static void __cpuinit amd_uncore_cpu_starting(unsigned int cpu)
+{
+	unsigned int eax, ebx, ecx, edx;
+	struct amd_uncore *uncore;
+
+	if (amd_uncore_nb) {
+		uncore = *per_cpu_ptr(amd_uncore_nb, cpu);
+		cpuid(0x8000001e, &eax, &ebx, &ecx, &edx);
+		uncore->id = ecx & 0xff;
+
+		uncore = amd_uncore_find_online_sibling(uncore, amd_uncore_nb);
+		*per_cpu_ptr(amd_uncore_nb, cpu) = uncore;
+	}
+
+	if (amd_uncore_l2) {
+		unsigned int apicid = cpu_data(cpu).apicid;
+		unsigned int nshared;
+
+		uncore = *per_cpu_ptr(amd_uncore_l2, cpu);
+		cpuid_count(0x8000001d, 2, &eax, &ebx, &ecx, &edx);
+		nshared = ((eax >> 14) & 0xfff) + 1;
+		uncore->id = apicid - (apicid % nshared);
+
+		uncore = amd_uncore_find_online_sibling(uncore, amd_uncore_l2);
+		*per_cpu_ptr(amd_uncore_l2, cpu) = uncore;
+	}
+}
+
+static void __cpuinit uncore_online(unsigned int cpu,
+				    struct amd_uncore * __percpu *uncores)
+{
+	struct amd_uncore *uncore = *per_cpu_ptr(uncores, cpu);
+
+	kfree(uncore->free_when_cpu_online);
+	uncore->free_when_cpu_online = NULL;
+
+	if (cpu == uncore->cpu)
+		cpumask_set_cpu(cpu, uncore->active_mask);
+}
+
+static void __cpuinit amd_uncore_cpu_online(unsigned int cpu)
+{
+	if (amd_uncore_nb)
+		uncore_online(cpu, amd_uncore_nb);
+
+	if (amd_uncore_l2)
+		uncore_online(cpu, amd_uncore_l2);
+}
+
+static void __cpuinit uncore_down_prepare(unsigned int cpu,
+					  struct amd_uncore * __percpu *uncores)
+{
+	unsigned int i;
+	struct amd_uncore *this = *per_cpu_ptr(uncores, cpu);
+
+	if (this->cpu != cpu)
+		return;
+
+	/* this cpu is going down, migrate to a shared sibling if possible */
+	for_each_online_cpu(i) {
+		struct amd_uncore *that = *per_cpu_ptr(uncores, i);
+
+		if (cpu == i)
+			continue;
+
+		if (this == that) {
+			perf_pmu_migrate_context(this->pmu, cpu, i);
+			cpumask_clear_cpu(cpu, that->active_mask);
+			cpumask_set_cpu(i, that->active_mask);
+			that->cpu = i;
+			break;
+		}
+	}
+}
+
+static void __cpuinit amd_uncore_cpu_down_prepare(unsigned int cpu)
+{
+	if (amd_uncore_nb)
+		uncore_down_prepare(cpu, amd_uncore_nb);
+
+	if (amd_uncore_l2)
+		uncore_down_prepare(cpu, amd_uncore_l2);
+}
+
+static void __cpuinit uncore_dead(unsigned int cpu,
+				  struct amd_uncore * __percpu *uncores)
+{
+	struct amd_uncore *uncore = *per_cpu_ptr(uncores, cpu);
+
+	if (cpu == uncore->cpu)
+		cpumask_clear_cpu(cpu, uncore->active_mask);
+
+	if (!--uncore->refcnt)
+		kfree(uncore);
+	*per_cpu_ptr(amd_uncore_nb, cpu) = NULL;
+}
+
+static void __cpuinit amd_uncore_cpu_dead(unsigned int cpu)
+{
+	if (amd_uncore_nb)
+		uncore_dead(cpu, amd_uncore_nb);
+
+	if (amd_uncore_l2)
+		uncore_dead(cpu, amd_uncore_l2);
+}
+
+static int __cpuinit
+amd_uncore_cpu_notifier(struct notifier_block *self, unsigned long action,
+			void *hcpu)
+{
+	unsigned int cpu = (long)hcpu;
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_UP_PREPARE:
+		amd_uncore_cpu_up_prepare(cpu);
+		break;
+
+	case CPU_STARTING:
+		amd_uncore_cpu_starting(cpu);
+		break;
+
+	case CPU_ONLINE:
+		amd_uncore_cpu_online(cpu);
+		break;
+
+	case CPU_DOWN_PREPARE:
+		amd_uncore_cpu_down_prepare(cpu);
+		break;
+
+	case CPU_UP_CANCELED:
+	case CPU_DEAD:
+		amd_uncore_cpu_dead(cpu);
+		break;
+
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block amd_uncore_cpu_notifier_block __cpuinitdata = {
+	.notifier_call	= amd_uncore_cpu_notifier,
+	.priority	= CPU_PRI_PERF + 1,
+};
+
+static void __init init_cpu_already_online(void *dummy)
+{
+	unsigned int cpu = smp_processor_id();
+
+	amd_uncore_cpu_starting(cpu);
+	amd_uncore_cpu_online(cpu);
+}
+
+static int __init amd_uncore_init(void)
+{
+	unsigned int cpu;
+	int ret = -ENODEV;
+
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
+		return -ENODEV;
+
+	if (!cpu_has_topoext)
+		return -ENODEV;
+
+	if (cpu_has_perfctr_nb) {
+		amd_uncore_nb = alloc_percpu(struct amd_uncore *);
+		perf_pmu_register(&amd_nb_pmu, amd_nb_pmu.name, -1);
+
+		printk(KERN_INFO "perf: AMD NB counters detected\n");
+		ret = 0;
+	}
+
+	if (cpu_has_perfctr_l2) {
+		amd_uncore_l2 = alloc_percpu(struct amd_uncore *);
+		perf_pmu_register(&amd_l2_pmu, amd_l2_pmu.name, -1);
+
+		printk(KERN_INFO "perf: AMD L2I counters detected\n");
+		ret = 0;
+	}
+
+	if (ret)
+		return -ENODEV;
+
+	get_online_cpus();
+	/* init cpus already online before registering for hotplug notifier */
+	for_each_online_cpu(cpu) {
+		amd_uncore_cpu_up_prepare(cpu);
+		smp_call_function_single(cpu, init_cpu_already_online, NULL, 1);
+	}
+
+	register_cpu_notifier(&amd_uncore_cpu_notifier_block);
+	put_online_cpus();
+
+	return 0;
+}
+device_initcall(amd_uncore_init);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index cc45deb..ffd6050 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -81,6 +81,7 @@ static struct event_constraint intel_nehalem_event_constraints[] __read_mostly =
 static struct extra_reg intel_nehalem_extra_regs[] __read_mostly =
 {
 	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff, RSP_0),
+	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x100b),
 	EVENT_EXTRA_END
 };
 
@@ -108,6 +109,8 @@ static struct event_constraint intel_snb_event_constraints[] __read_mostly =
 	INTEL_EVENT_CONSTRAINT(0x48, 0x4), /* L1D_PEND_MISS.PENDING */
 	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
 	INTEL_EVENT_CONSTRAINT(0xcd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
+	INTEL_UEVENT_CONSTRAINT(0x04a3, 0xf), /* CYCLE_ACTIVITY.CYCLES_NO_DISPATCH */
+	INTEL_UEVENT_CONSTRAINT(0x02a3, 0x4), /* CYCLE_ACTIVITY.CYCLES_L1D_PENDING */
 	EVENT_CONSTRAINT_END
 };
 
@@ -136,6 +139,7 @@ static struct extra_reg intel_westmere_extra_regs[] __read_mostly =
 {
 	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff, RSP_0),
 	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0xffff, RSP_1),
+	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x100b),
 	EVENT_EXTRA_END
 };
 
@@ -155,6 +159,8 @@ static struct event_constraint intel_gen_event_constraints[] __read_mostly =
 static struct extra_reg intel_snb_extra_regs[] __read_mostly = {
 	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3f807f8fffull, RSP_0),
 	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3f807f8fffull, RSP_1),
+	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x01cd),
+	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x01cd),
 	EVENT_EXTRA_END
 };
 
@@ -164,6 +170,21 @@ static struct extra_reg intel_snbep_extra_regs[] __read_mostly = {
 	EVENT_EXTRA_END
 };
 
+EVENT_ATTR_STR(mem-loads, mem_ld_nhm, "event=0x0b,umask=0x10,ldlat=3");
+EVENT_ATTR_STR(mem-loads, mem_ld_snb, "event=0xcd,umask=0x1,ldlat=3");
+EVENT_ATTR_STR(mem-stores, mem_st_snb, "event=0xcd,umask=0x2");
+
+struct attribute *nhm_events_attrs[] = {
+	EVENT_PTR(mem_ld_nhm),
+	NULL,
+};
+
+struct attribute *snb_events_attrs[] = {
+	EVENT_PTR(mem_ld_snb),
+	EVENT_PTR(mem_st_snb),
+	NULL,
+};
+
 static u64 intel_pmu_event_map(int hw_event)
 {
 	return intel_perfmon_event_map[hw_event];
@@ -1398,8 +1419,11 @@ x86_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 
 	if (x86_pmu.event_constraints) {
 		for_each_event_constraint(c, x86_pmu.event_constraints) {
-			if ((event->hw.config & c->cmask) == c->code)
+			if ((event->hw.config & c->cmask) == c->code) {
+				/* hw.flags zeroed at initialization */
+				event->hw.flags |= c->flags;
 				return c;
+			}
 		}
 	}
 
@@ -1444,6 +1468,7 @@ intel_put_shared_regs_event_constraints(struct cpu_hw_events *cpuc,
 static void intel_put_event_constraints(struct cpu_hw_events *cpuc,
 					struct perf_event *event)
 {
+	event->hw.flags = 0;
 	intel_put_shared_regs_event_constraints(cpuc, event);
 }
 
@@ -1767,6 +1792,8 @@ static void intel_pmu_flush_branch_stack(void)
 
 PMU_FORMAT_ATTR(offcore_rsp, "config1:0-63");
 
+PMU_FORMAT_ATTR(ldlat, "config1:0-15");
+
 static struct attribute *intel_arch3_formats_attr[] = {
 	&format_attr_event.attr,
 	&format_attr_umask.attr,
@@ -1777,6 +1804,7 @@ static struct attribute *intel_arch3_formats_attr[] = {
 	&format_attr_cmask.attr,
 
 	&format_attr_offcore_rsp.attr, /* XXX do NHM/WSM + SNB breakout */
+	&format_attr_ldlat.attr, /* PEBS load latency */
 	NULL,
 };
 
@@ -2037,6 +2065,8 @@ __init int intel_pmu_init(void)
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
 		x86_pmu.extra_regs = intel_nehalem_extra_regs;
 
+		x86_pmu.cpu_events = nhm_events_attrs;
+
 		/* UOPS_ISSUED.STALLED_CYCLES */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =
 			X86_CONFIG(.event=0x0e, .umask=0x01, .inv=1, .cmask=1);
@@ -2080,6 +2110,8 @@ __init int intel_pmu_init(void)
 		x86_pmu.extra_regs = intel_westmere_extra_regs;
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
 
+		x86_pmu.cpu_events = nhm_events_attrs;
+
 		/* UOPS_ISSUED.STALLED_CYCLES */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =
 			X86_CONFIG(.event=0x0e, .umask=0x01, .inv=1, .cmask=1);
@@ -2111,6 +2143,8 @@ __init int intel_pmu_init(void)
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
 		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
 
+		x86_pmu.cpu_events = snb_events_attrs;
+
 		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =
 			X86_CONFIG(.event=0x0e, .umask=0x01, .inv=1, .cmask=1);
@@ -2140,6 +2174,8 @@ __init int intel_pmu_init(void)
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
 		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
 
+		x86_pmu.cpu_events = snb_events_attrs;
+
 		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =
 			X86_CONFIG(.event=0x0e, .umask=0x01, .inv=1, .cmask=1);
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 26830f3..60250f6 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -24,6 +24,130 @@ struct pebs_record_32 {
 
  */
 
+union intel_x86_pebs_dse {
+	u64 val;
+	struct {
+		unsigned int ld_dse:4;
+		unsigned int ld_stlb_miss:1;
+		unsigned int ld_locked:1;
+		unsigned int ld_reserved:26;
+	};
+	struct {
+		unsigned int st_l1d_hit:1;
+		unsigned int st_reserved1:3;
+		unsigned int st_stlb_miss:1;
+		unsigned int st_locked:1;
+		unsigned int st_reserved2:26;
+	};
+};
+
+
+/*
+ * Map PEBS Load Latency Data Source encodings to generic
+ * memory data source information
+ */
+#define P(a, b) PERF_MEM_S(a, b)
+#define OP_LH (P(OP, LOAD) | P(LVL, HIT))
+#define SNOOP_NONE_MISS (P(SNOOP, NONE) | P(SNOOP, MISS))
+
+static const u64 pebs_data_source[] = {
+	P(OP, LOAD) | P(LVL, MISS) | P(LVL, L3) | P(SNOOP, NA),/* 0x00:ukn L3 */
+	OP_LH | P(LVL, L1)  | P(SNOOP, NONE),	/* 0x01: L1 local */
+	OP_LH | P(LVL, LFB) | P(SNOOP, NONE),	/* 0x02: LFB hit */
+	OP_LH | P(LVL, L2)  | P(SNOOP, NONE),	/* 0x03: L2 hit */
+	OP_LH | P(LVL, L3)  | P(SNOOP, NONE),	/* 0x04: L3 hit */
+	OP_LH | P(LVL, L3)  | P(SNOOP, MISS),	/* 0x05: L3 hit, snoop miss */
+	OP_LH | P(LVL, L3)  | P(SNOOP, HIT),	/* 0x06: L3 hit, snoop hit */
+	OP_LH | P(LVL, L3)  | P(SNOOP, HITM),	/* 0x07: L3 hit, snoop hitm */
+	OP_LH | P(LVL, REM_CCE1) | P(SNOOP, HIT),  /* 0x08: L3 miss snoop hit */
+	OP_LH | P(LVL, REM_CCE1) | P(SNOOP, HITM), /* 0x09: L3 miss snoop hitm*/
+	OP_LH | P(LVL, LOC_RAM)  | P(SNOOP, HIT),  /* 0x0a: L3 miss, shared */
+	OP_LH | P(LVL, REM_RAM1) | P(SNOOP, HIT),  /* 0x0b: L3 miss, shared */
+	OP_LH | P(LVL, LOC_RAM)  | SNOOP_NONE_MISS,/* 0x0c: L3 miss, excl */
+	OP_LH | P(LVL, REM_RAM1) | SNOOP_NONE_MISS,/* 0x0d: L3 miss, excl */
+	OP_LH | P(LVL, IO)  | P(SNOOP, NONE), /* 0x0e: I/O */
+	OP_LH | P(LVL, UNC) | P(SNOOP, NONE), /* 0x0f: uncached */
+};
+
+static u64 precise_store_data(u64 status)
+{
+	union intel_x86_pebs_dse dse;
+	u64 val = P(OP, STORE) | P(SNOOP, NA) | P(LVL, L1) | P(TLB, L2);
+
+	dse.val = status;
+
+	/*
+	 * bit 4: TLB access
+	 * 1 = stored missed 2nd level TLB
+	 *
+	 * so it either hit the walker or the OS
+	 * otherwise hit 2nd level TLB
+	 */
+	if (dse.st_stlb_miss)
+		val |= P(TLB, MISS);
+	else
+		val |= P(TLB, HIT);
+
+	/*
+	 * bit 0: hit L1 data cache
+	 * if not set, then all we know is that
+	 * it missed L1D
+	 */
+	if (dse.st_l1d_hit)
+		val |= P(LVL, HIT);
+	else
+		val |= P(LVL, MISS);
+
+	/*
+	 * bit 5: Locked prefix
+	 */
+	if (dse.st_locked)
+		val |= P(LOCK, LOCKED);
+
+	return val;
+}
+
+static u64 load_latency_data(u64 status)
+{
+	union intel_x86_pebs_dse dse;
+	u64 val;
+	int model = boot_cpu_data.x86_model;
+	int fam = boot_cpu_data.x86;
+
+	dse.val = status;
+
+	/*
+	 * use the mapping table for bit 0-3
+	 */
+	val = pebs_data_source[dse.ld_dse];
+
+	/*
+	 * Nehalem models do not support TLB, Lock infos
+	 */
+	if (fam == 0x6 && (model == 26 || model == 30
+	    || model == 31 || model == 46)) {
+		val |= P(TLB, NA) | P(LOCK, NA);
+		return val;
+	}
+	/*
+	 * bit 4: TLB access
+	 * 0 = did not miss 2nd level TLB
+	 * 1 = missed 2nd level TLB
+	 */
+	if (dse.ld_stlb_miss)
+		val |= P(TLB, MISS) | P(TLB, L2);
+	else
+		val |= P(TLB, HIT) | P(TLB, L1) | P(TLB, L2);
+
+	/*
+	 * bit 5: locked prefix
+	 */
+	if (dse.ld_locked)
+		val |= P(LOCK, LOCKED);
+
+	return val;
+}
+
 struct pebs_record_core {
 	u64 flags, ip;
 	u64 ax, bx, cx, dx;
@@ -365,7 +489,7 @@ struct event_constraint intel_atom_pebs_event_constraints[] = {
 };
 
 struct event_constraint intel_nehalem_pebs_event_constraints[] = {
-	INTEL_EVENT_CONSTRAINT(0x0b, 0xf),    /* MEM_INST_RETIRED.* */
+	INTEL_PLD_CONSTRAINT(0x100b, 0xf),      /* MEM_INST_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0x0f, 0xf),    /* MEM_UNCORE_RETIRED.* */
 	INTEL_UEVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
 	INTEL_EVENT_CONSTRAINT(0xc0, 0xf),    /* INST_RETIRED.ANY */
@@ -380,7 +504,7 @@ struct event_constraint intel_nehalem_pebs_event_constraints[] = {
 };
 
 struct event_constraint intel_westmere_pebs_event_constraints[] = {
-	INTEL_EVENT_CONSTRAINT(0x0b, 0xf),    /* MEM_INST_RETIRED.* */
+	INTEL_PLD_CONSTRAINT(0x100b, 0xf),      /* MEM_INST_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0x0f, 0xf),    /* MEM_UNCORE_RETIRED.* */
 	INTEL_UEVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
 	INTEL_EVENT_CONSTRAINT(0xc0, 0xf),    /* INSTR_RETIRED.* */
@@ -400,7 +524,8 @@ struct event_constraint intel_snb_pebs_event_constraints[] = {
 	INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
 	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xcd, 0x8),    /* MEM_TRANS_RETIRED.* */
+	INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
+	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
 	INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
@@ -414,7 +539,8 @@ struct event_constraint intel_ivb_pebs_event_constraints[] = {
         INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
         INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
         INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
-        INTEL_EVENT_CONSTRAINT(0xcd, 0x8),    /* MEM_TRANS_RETIRED.* */
+        INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
+	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
         INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
         INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
         INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
@@ -431,8 +557,10 @@ struct event_constraint *intel_pebs_constraints(struct perf_event *event)
 
 	if (x86_pmu.pebs_constraints) {
 		for_each_event_constraint(c, x86_pmu.pebs_constraints) {
-			if ((event->hw.config & c->cmask) == c->code)
+			if ((event->hw.config & c->cmask) == c->code) {
+				event->hw.flags |= c->flags;
 				return c;
+			}
 		}
 	}
 
@@ -447,6 +575,11 @@ void intel_pmu_pebs_enable(struct perf_event *event)
 	hwc->config &= ~ARCH_PERFMON_EVENTSEL_INT;
 
 	cpuc->pebs_enabled |= 1ULL << hwc->idx;
+
+	if (event->hw.flags & PERF_X86_EVENT_PEBS_LDLAT)
+		cpuc->pebs_enabled |= 1ULL << (hwc->idx + 32);
+	else if (event->hw.flags & PERF_X86_EVENT_PEBS_ST)
+		cpuc->pebs_enabled |= 1ULL << 63;
 }
 
 void intel_pmu_pebs_disable(struct perf_event *event)
@@ -559,20 +692,51 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 				   struct pt_regs *iregs, void *__pebs)
 {
 	/*
-	 * We cast to pebs_record_core since that is a subset of
-	 * both formats and we don't use the other fields in this
-	 * routine.
+	 * We cast to pebs_record_nhm to get the load latency data
+	 * if extra_reg MSR_PEBS_LD_LAT_THRESHOLD used
 	 */
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	struct pebs_record_core *pebs = __pebs;
+	struct pebs_record_nhm *pebs = __pebs;
 	struct perf_sample_data data;
 	struct pt_regs regs;
+	u64 sample_type;
+	int fll, fst;
 
 	if (!intel_pmu_save_and_restart(event))
 		return;
 
+	fll = event->hw.flags & PERF_X86_EVENT_PEBS_LDLAT;
+	fst = event->hw.flags & PERF_X86_EVENT_PEBS_ST;
+
 	perf_sample_data_init(&data, 0, event->hw.last_period);
 
+	data.period = event->hw.last_period;
+	sample_type = event->attr.sample_type;
+
+	/*
+	 * if PEBS-LL or PreciseStore
+	 */
+	if (fll || fst) {
+		if (sample_type & PERF_SAMPLE_ADDR)
+			data.addr = pebs->dla;
+
+		/*
+		 * Use latency for weight (only avail with PEBS-LL)
+		 */
+		if (fll && (sample_type & PERF_SAMPLE_WEIGHT))
+			data.weight = pebs->lat;
+
+		/*
+		 * data.data_src encodes the data source
+		 */
+		if (sample_type & PERF_SAMPLE_DATA_SRC) {
+			if (fll)
+				data.data_src.val = load_latency_data(pebs->dse);
+			else
+				data.data_src.val = precise_store_data(pebs->dse);
+		}
+	}
+
 	/*
 	 * We use the interrupt regs as a base because the PEBS record
 	 * does not contain a full regs set, specifically it seems to
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index b43200d..d0f9e5a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -17,6 +17,9 @@ static struct event_constraint constraint_fixed =
 static struct event_constraint constraint_empty =
 	EVENT_CONSTRAINT(0, 0, 0);
 
+#define __BITS_VALUE(x, i, n)  ((typeof(x))(((x) >> ((i) * (n))) & \
+				((1ULL << (n)) - 1)))
+
 DEFINE_UNCORE_FORMAT_ATTR(event, event, "config:0-7");
 DEFINE_UNCORE_FORMAT_ATTR(event_ext, event, "config:0-7,21");
 DEFINE_UNCORE_FORMAT_ATTR(umask, umask, "config:8-15");
@@ -31,9 +34,13 @@ DEFINE_UNCORE_FORMAT_ATTR(occ_sel, occ_sel, "config:14-15");
 DEFINE_UNCORE_FORMAT_ATTR(occ_invert, occ_invert, "config:30");
 DEFINE_UNCORE_FORMAT_ATTR(occ_edge, occ_edge, "config:14-51");
 DEFINE_UNCORE_FORMAT_ATTR(filter_tid, filter_tid, "config1:0-4");
+DEFINE_UNCORE_FORMAT_ATTR(filter_link, filter_link, "config1:5-8");
 DEFINE_UNCORE_FORMAT_ATTR(filter_nid, filter_nid, "config1:10-17");
+DEFINE_UNCORE_FORMAT_ATTR(filter_nid2, filter_nid, "config1:32-47");
 DEFINE_UNCORE_FORMAT_ATTR(filter_state, filter_state, "config1:18-22");
+DEFINE_UNCORE_FORMAT_ATTR(filter_state2, filter_state, "config1:17-22");
 DEFINE_UNCORE_FORMAT_ATTR(filter_opc, filter_opc, "config1:23-31");
+DEFINE_UNCORE_FORMAT_ATTR(filter_opc2, filter_opc, "config1:52-60");
 DEFINE_UNCORE_FORMAT_ATTR(filter_band0, filter_band0, "config1:0-7");
 DEFINE_UNCORE_FORMAT_ATTR(filter_band1, filter_band1, "config1:8-15");
 DEFINE_UNCORE_FORMAT_ATTR(filter_band2, filter_band2, "config1:16-23");
@@ -110,6 +117,21 @@ static void uncore_put_constraint(struct intel_uncore_box *box, struct perf_even
 	reg1->alloc = 0;
 }
 
+static u64 uncore_shared_reg_config(struct intel_uncore_box *box, int idx)
+{
+	struct intel_uncore_extra_reg *er;
+	unsigned long flags;
+	u64 config;
+
+	er = &box->shared_regs[idx];
+
+	raw_spin_lock_irqsave(&er->lock, flags);
+	config = er->config;
+	raw_spin_unlock_irqrestore(&er->lock, flags);
+
+	return config;
+}
+
 /* Sandy Bridge-EP uncore support */
 static struct intel_uncore_type snbep_uncore_cbox;
 static struct intel_uncore_type snbep_uncore_pcu;
@@ -205,7 +227,7 @@ static void snbep_uncore_msr_enable_event(struct intel_uncore_box *box, struct p
 	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
 
 	if (reg1->idx != EXTRA_REG_NONE)
-		wrmsrl(reg1->reg, reg1->config);
+		wrmsrl(reg1->reg, uncore_shared_reg_config(box, 0));
 
 	wrmsrl(hwc->config_base, hwc->config | SNBEP_PMON_CTL_EN);
 }
@@ -226,29 +248,6 @@ static void snbep_uncore_msr_init_box(struct intel_uncore_box *box)
 		wrmsrl(msr, SNBEP_PMON_BOX_CTL_INT);
 }
 
-static int snbep_uncore_hw_config(struct intel_uncore_box *box, struct perf_event *event)
-{
-	struct hw_perf_event *hwc = &event->hw;
-	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
-
-	if (box->pmu->type == &snbep_uncore_cbox) {
-		reg1->reg = SNBEP_C0_MSR_PMON_BOX_FILTER +
-			SNBEP_CBO_MSR_OFFSET * box->pmu->pmu_idx;
-		reg1->config = event->attr.config1 &
-			SNBEP_CB0_MSR_PMON_BOX_FILTER_MASK;
-	} else {
-		if (box->pmu->type == &snbep_uncore_pcu) {
-			reg1->reg = SNBEP_PCU_MSR_PMON_BOX_FILTER;
-			reg1->config = event->attr.config1 & SNBEP_PCU_MSR_PMON_BOX_FILTER_MASK;
-		} else {
-			return 0;
-		}
-	}
-	reg1->idx = 0;
-
-	return 0;
-}
-
 static struct attribute *snbep_uncore_formats_attr[] = {
 	&format_attr_event.attr,
 	&format_attr_umask.attr,
@@ -345,16 +344,16 @@ static struct attribute_group snbep_uncore_qpi_format_group = {
 	.attrs = snbep_uncore_qpi_formats_attr,
 };
 
+#define SNBEP_UNCORE_MSR_OPS_COMMON_INIT()			\
+	.init_box	= snbep_uncore_msr_init_box,		\
+	.disable_box	= snbep_uncore_msr_disable_box,		\
+	.enable_box	= snbep_uncore_msr_enable_box,		\
+	.disable_event	= snbep_uncore_msr_disable_event,	\
+	.enable_event	= snbep_uncore_msr_enable_event,	\
+	.read_counter	= uncore_msr_read_counter
+
 static struct intel_uncore_ops snbep_uncore_msr_ops = {
-	.init_box	= snbep_uncore_msr_init_box,
-	.disable_box	= snbep_uncore_msr_disable_box,
-	.enable_box	= snbep_uncore_msr_enable_box,
-	.disable_event	= snbep_uncore_msr_disable_event,
-	.enable_event	= snbep_uncore_msr_enable_event,
-	.read_counter	= uncore_msr_read_counter,
-	.get_constraint = uncore_get_constraint,
-	.put_constraint = uncore_put_constraint,
-	.hw_config	= snbep_uncore_hw_config,
+	SNBEP_UNCORE_MSR_OPS_COMMON_INIT(),
 };
 
 static struct intel_uncore_ops snbep_uncore_pci_ops = {
@@ -372,6 +371,7 @@ static struct event_constraint snbep_uncore_cbox_constraints[] = {
 	UNCORE_EVENT_CONSTRAINT(0x04, 0x3),
 	UNCORE_EVENT_CONSTRAINT(0x05, 0x3),
 	UNCORE_EVENT_CONSTRAINT(0x07, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x09, 0x3),
 	UNCORE_EVENT_CONSTRAINT(0x11, 0x1),
 	UNCORE_EVENT_CONSTRAINT(0x12, 0x3),
 	UNCORE_EVENT_CONSTRAINT(0x13, 0x3),
@@ -421,6 +421,14 @@ static struct event_constraint snbep_uncore_r3qpi_constraints[] = {
 	UNCORE_EVENT_CONSTRAINT(0x24, 0x3),
 	UNCORE_EVENT_CONSTRAINT(0x25, 0x3),
 	UNCORE_EVENT_CONSTRAINT(0x26, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x28, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x29, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x2a, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x2b, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x2c, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x2d, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x2e, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x2f, 0x3),
 	UNCORE_EVENT_CONSTRAINT(0x30, 0x3),
 	UNCORE_EVENT_CONSTRAINT(0x31, 0x3),
 	UNCORE_EVENT_CONSTRAINT(0x32, 0x3),
@@ -428,6 +436,8 @@ static struct event_constraint snbep_uncore_r3qpi_constraints[] = {
 	UNCORE_EVENT_CONSTRAINT(0x34, 0x3),
 	UNCORE_EVENT_CONSTRAINT(0x36, 0x3),
 	UNCORE_EVENT_CONSTRAINT(0x37, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x38, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x39, 0x3),
 	EVENT_CONSTRAINT_END
 };
 
@@ -446,6 +456,145 @@ static struct intel_uncore_type snbep_uncore_ubox = {
 	.format_group	= &snbep_uncore_ubox_format_group,
 };
 
+static struct extra_reg snbep_uncore_cbox_extra_regs[] = {
+	SNBEP_CBO_EVENT_EXTRA_REG(SNBEP_CBO_PMON_CTL_TID_EN,
+				  SNBEP_CBO_PMON_CTL_TID_EN, 0x1),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x0334, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x0534, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x0934, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4134, 0xffff, 0x6),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x0135, 0xffff, 0x8),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x0335, 0xffff, 0x8),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4135, 0xffff, 0xc),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4335, 0xffff, 0xc),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4435, 0xffff, 0x2),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4835, 0xffff, 0x2),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4a35, 0xffff, 0x2),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x5035, 0xffff, 0x2),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x0136, 0xffff, 0x8),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x0336, 0xffff, 0x8),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4136, 0xffff, 0xc),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4336, 0xffff, 0xc),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4436, 0xffff, 0x2),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4836, 0xffff, 0x2),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4a36, 0xffff, 0x2),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4037, 0x40ff, 0x2),
+	EVENT_EXTRA_END
+};
+
+static void snbep_cbox_put_constraint(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
+	struct intel_uncore_extra_reg *er = &box->shared_regs[0];
+	int i;
+
+	if (uncore_box_is_fake(box))
+		return;
+
+	for (i = 0; i < 5; i++) {
+		if (reg1->alloc & (0x1 << i))
+			atomic_sub(1 << (i * 6), &er->ref);
+	}
+	reg1->alloc = 0;
+}
+
+static struct event_constraint *
+__snbep_cbox_get_constraint(struct intel_uncore_box *box, struct perf_event *event,
+			    u64 (*cbox_filter_mask)(int fields))
+{
+	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
+	struct intel_uncore_extra_reg *er = &box->shared_regs[0];
+	int i, alloc = 0;
+	unsigned long flags;
+	u64 mask;
+
+	if (reg1->idx == EXTRA_REG_NONE)
+		return NULL;
+
+	raw_spin_lock_irqsave(&er->lock, flags);
+	for (i = 0; i < 5; i++) {
+		if (!(reg1->idx & (0x1 << i)))
+			continue;
+		if (!uncore_box_is_fake(box) && (reg1->alloc & (0x1 << i)))
+			continue;
+
+		mask = cbox_filter_mask(0x1 << i);
+		if (!__BITS_VALUE(atomic_read(&er->ref), i, 6) ||
+		    !((reg1->config ^ er->config) & mask)) {
+			atomic_add(1 << (i * 6), &er->ref);
+			er->config &= ~mask;
+			er->config |= reg1->config & mask;
+			alloc |= (0x1 << i);
+		} else {
+			break;
+		}
+	}
+	raw_spin_unlock_irqrestore(&er->lock, flags);
+	if (i < 5)
+		goto fail;
+
+	if (!uncore_box_is_fake(box))
+		reg1->alloc |= alloc;
+
+	return 0;
+fail:
+	for (; i >= 0; i--) {
+		if (alloc & (0x1 << i))
+			atomic_sub(1 << (i * 6), &er->ref);
+	}
+	return &constraint_empty;
+}
+
+static u64 snbep_cbox_filter_mask(int fields)
+{
+	u64 mask = 0;
+
+	if (fields & 0x1)
+		mask |= SNBEP_CB0_MSR_PMON_BOX_FILTER_TID;
+	if (fields & 0x2)
+		mask |= SNBEP_CB0_MSR_PMON_BOX_FILTER_NID;
+	if (fields & 0x4)
+		mask |= SNBEP_CB0_MSR_PMON_BOX_FILTER_STATE;
+	if (fields & 0x8)
+		mask |= SNBEP_CB0_MSR_PMON_BOX_FILTER_OPC;
+
+	return mask;
+}
+
+static struct event_constraint *
+snbep_cbox_get_constraint(struct intel_uncore_box *box, struct perf_event *event)
+{
+	return __snbep_cbox_get_constraint(box, event, snbep_cbox_filter_mask);
+}
+
+static int snbep_cbox_hw_config(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
+	struct extra_reg *er;
+	int idx = 0;
+
+	for (er = snbep_uncore_cbox_extra_regs; er->msr; er++) {
+		if (er->event != (event->hw.config & er->config_mask))
+			continue;
+		idx |= er->idx;
+	}
+
+	if (idx) {
+		reg1->reg = SNBEP_C0_MSR_PMON_BOX_FILTER +
+			SNBEP_CBO_MSR_OFFSET * box->pmu->pmu_idx;
+		reg1->config = event->attr.config1 & snbep_cbox_filter_mask(idx);
+		reg1->idx = idx;
+	}
+	return 0;
+}
+
+static struct intel_uncore_ops snbep_uncore_cbox_ops = {
+	SNBEP_UNCORE_MSR_OPS_COMMON_INIT(),
+	.hw_config		= snbep_cbox_hw_config,
+	.get_constraint		= snbep_cbox_get_constraint,
+	.put_constraint		= snbep_cbox_put_constraint,
+};
+
 static struct intel_uncore_type snbep_uncore_cbox = {
 	.name			= "cbox",
 	.num_counters		= 4,
@@ -458,10 +607,104 @@ static struct intel_uncore_type snbep_uncore_cbox = {
 	.msr_offset		= SNBEP_CBO_MSR_OFFSET,
 	.num_shared_regs	= 1,
 	.constraints		= snbep_uncore_cbox_constraints,
-	.ops			= &snbep_uncore_msr_ops,
+	.ops			= &snbep_uncore_cbox_ops,
 	.format_group		= &snbep_uncore_cbox_format_group,
 };
 
+static u64 snbep_pcu_alter_er(struct perf_event *event, int new_idx, bool modify)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
+	u64 config = reg1->config;
+
+	if (new_idx > reg1->idx)
+		config <<= 8 * (new_idx - reg1->idx);
+	else
+		config >>= 8 * (reg1->idx - new_idx);
+
+	if (modify) {
+		hwc->config += new_idx - reg1->idx;
+		reg1->config = config;
+		reg1->idx = new_idx;
+	}
+	return config;
+}
+
+static struct event_constraint *
+snbep_pcu_get_constraint(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
+	struct intel_uncore_extra_reg *er = &box->shared_regs[0];
+	unsigned long flags;
+	int idx = reg1->idx;
+	u64 mask, config1 = reg1->config;
+	bool ok = false;
+
+	if (reg1->idx == EXTRA_REG_NONE ||
+	    (!uncore_box_is_fake(box) && reg1->alloc))
+		return NULL;
+again:
+	mask = 0xff << (idx * 8);
+	raw_spin_lock_irqsave(&er->lock, flags);
+	if (!__BITS_VALUE(atomic_read(&er->ref), idx, 8) ||
+	    !((config1 ^ er->config) & mask)) {
+		atomic_add(1 << (idx * 8), &er->ref);
+		er->config &= ~mask;
+		er->config |= config1 & mask;
+		ok = true;
+	}
+	raw_spin_unlock_irqrestore(&er->lock, flags);
+
+	if (!ok) {
+		idx = (idx + 1) % 4;
+		if (idx != reg1->idx) {
+			config1 = snbep_pcu_alter_er(event, idx, false);
+			goto again;
+		}
+		return &constraint_empty;
+	}
+
+	if (!uncore_box_is_fake(box)) {
+		if (idx != reg1->idx)
+			snbep_pcu_alter_er(event, idx, true);
+		reg1->alloc = 1;
+	}
+	return NULL;
+}
+
+static void snbep_pcu_put_constraint(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
+	struct intel_uncore_extra_reg *er = &box->shared_regs[0];
+
+	if (uncore_box_is_fake(box) || !reg1->alloc)
+		return;
+
+	atomic_sub(1 << (reg1->idx * 8), &er->ref);
+	reg1->alloc = 0;
+}
+
+static int snbep_pcu_hw_config(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
+	int ev_sel = hwc->config & SNBEP_PMON_CTL_EV_SEL_MASK;
+
+	if (ev_sel >= 0xb && ev_sel <= 0xe) {
+		reg1->reg = SNBEP_PCU_MSR_PMON_BOX_FILTER;
+		reg1->idx = ev_sel - 0xb;
+		reg1->config = event->attr.config1 & (0xff << reg1->idx);
+	}
+	return 0;
+}
+
+static struct intel_uncore_ops snbep_uncore_pcu_ops = {
+	SNBEP_UNCORE_MSR_OPS_COMMON_INIT(),
+	.hw_config		= snbep_pcu_hw_config,
+	.get_constraint		= snbep_pcu_get_constraint,
+	.put_constraint		= snbep_pcu_put_constraint,
+};
+
 static struct intel_uncore_type snbep_uncore_pcu = {
 	.name			= "pcu",
 	.num_counters		= 4,
@@ -472,7 +715,7 @@ static struct intel_uncore_type snbep_uncore_pcu = {
 	.event_mask		= SNBEP_PCU_MSR_PMON_RAW_EVENT_MASK,
 	.box_ctl		= SNBEP_PCU_MSR_PMON_BOX_CTL,
 	.num_shared_regs	= 1,
-	.ops			= &snbep_uncore_msr_ops,
+	.ops			= &snbep_uncore_pcu_ops,
 	.format_group		= &snbep_uncore_pcu_format_group,
 };
 
@@ -544,55 +787,63 @@ static struct intel_uncore_type snbep_uncore_r3qpi = {
 	SNBEP_UNCORE_PCI_COMMON_INIT(),
 };
 
+enum {
+	SNBEP_PCI_UNCORE_HA,
+	SNBEP_PCI_UNCORE_IMC,
+	SNBEP_PCI_UNCORE_QPI,
+	SNBEP_PCI_UNCORE_R2PCIE,
+	SNBEP_PCI_UNCORE_R3QPI,
+};
+
 static struct intel_uncore_type *snbep_pci_uncores[] = {
-	&snbep_uncore_ha,
-	&snbep_uncore_imc,
-	&snbep_uncore_qpi,
-	&snbep_uncore_r2pcie,
-	&snbep_uncore_r3qpi,
+	[SNBEP_PCI_UNCORE_HA]		= &snbep_uncore_ha,
+	[SNBEP_PCI_UNCORE_IMC]		= &snbep_uncore_imc,
+	[SNBEP_PCI_UNCORE_QPI]		= &snbep_uncore_qpi,
+	[SNBEP_PCI_UNCORE_R2PCIE]	= &snbep_uncore_r2pcie,
+	[SNBEP_PCI_UNCORE_R3QPI]	= &snbep_uncore_r3qpi,
 	NULL,
 };
 
 static DEFINE_PCI_DEVICE_TABLE(snbep_uncore_pci_ids) = {
 	{ /* Home Agent */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_UNC_HA),
-		.driver_data = (unsigned long)&snbep_uncore_ha,
+		.driver_data = SNBEP_PCI_UNCORE_HA,
 	},
 	{ /* MC Channel 0 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_UNC_IMC0),
-		.driver_data = (unsigned long)&snbep_uncore_imc,
+		.driver_data = SNBEP_PCI_UNCORE_IMC,
 	},
 	{ /* MC Channel 1 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_UNC_IMC1),
-		.driver_data = (unsigned long)&snbep_uncore_imc,
+		.driver_data = SNBEP_PCI_UNCORE_IMC,
 	},
 	{ /* MC Channel 2 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_UNC_IMC2),
-		.driver_data = (unsigned long)&snbep_uncore_imc,
+		.driver_data = SNBEP_PCI_UNCORE_IMC,
 	},
 	{ /* MC Channel 3 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_UNC_IMC3),
-		.driver_data = (unsigned long)&snbep_uncore_imc,
+		.driver_data = SNBEP_PCI_UNCORE_IMC,
 	},
 	{ /* QPI Port 0 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_UNC_QPI0),
-		.driver_data = (unsigned long)&snbep_uncore_qpi,
+		.driver_data = SNBEP_PCI_UNCORE_QPI,
 	},
 	{ /* QPI Port 1 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_UNC_QPI1),
-		.driver_data = (unsigned long)&snbep_uncore_qpi,
+		.driver_data = SNBEP_PCI_UNCORE_QPI,
 	},
-	{ /* P2PCIe */
+	{ /* R2PCIe */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_UNC_R2PCIE),
-		.driver_data = (unsigned long)&snbep_uncore_r2pcie,
+		.driver_data = SNBEP_PCI_UNCORE_R2PCIE,
 	},
 	{ /* R3QPI Link 0 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_UNC_R3QPI0),
-		.driver_data = (unsigned long)&snbep_uncore_r3qpi,
+		.driver_data = SNBEP_PCI_UNCORE_R3QPI,
 	},
 	{ /* R3QPI Link 1 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_UNC_R3QPI1),
-		.driver_data = (unsigned long)&snbep_uncore_r3qpi,
+		.driver_data = SNBEP_PCI_UNCORE_R3QPI,
 	},
 	{ /* end: all zeroes */ }
 };
@@ -605,7 +856,7 @@ static struct pci_driver snbep_uncore_pci_driver = {
 /*
  * build pci bus to socket mapping
  */
-static int snbep_pci2phy_map_init(void)
+static int snbep_pci2phy_map_init(int devid)
 {
 	struct pci_dev *ubox_dev = NULL;
 	int i, bus, nodeid;
@@ -614,9 +865,7 @@ static int snbep_pci2phy_map_init(void)
 
 	while (1) {
 		/* find the UBOX device */
-		ubox_dev = pci_get_device(PCI_VENDOR_ID_INTEL,
-					PCI_DEVICE_ID_INTEL_JAKETOWN_UBOX,
-					ubox_dev);
+		ubox_dev = pci_get_device(PCI_VENDOR_ID_INTEL, devid, ubox_dev);
 		if (!ubox_dev)
 			break;
 		bus = ubox_dev->bus->number;
@@ -639,7 +888,7 @@ static int snbep_pci2phy_map_init(void)
 				break;
 			}
 		}
-	};
+	}
 
 	if (ubox_dev)
 		pci_dev_put(ubox_dev);
@@ -648,6 +897,440 @@ static int snbep_pci2phy_map_init(void)
 }
 /* end of Sandy Bridge-EP uncore support */
 
+/* IvyTown uncore support */
+static void ivt_uncore_msr_init_box(struct intel_uncore_box *box)
+{
+	unsigned msr = uncore_msr_box_ctl(box);
+	if (msr)
+		wrmsrl(msr, IVT_PMON_BOX_CTL_INT);
+}
+
+static void ivt_uncore_pci_init_box(struct intel_uncore_box *box)
+{
+	struct pci_dev *pdev = box->pci_dev;
+
+	pci_write_config_dword(pdev, SNBEP_PCI_PMON_BOX_CTL, IVT_PMON_BOX_CTL_INT);
+}
+
+#define IVT_UNCORE_MSR_OPS_COMMON_INIT()			\
+	.init_box	= ivt_uncore_msr_init_box,		\
+	.disable_box	= snbep_uncore_msr_disable_box,		\
+	.enable_box	= snbep_uncore_msr_enable_box,		\
+	.disable_event	= snbep_uncore_msr_disable_event,	\
+	.enable_event	= snbep_uncore_msr_enable_event,	\
+	.read_counter	= uncore_msr_read_counter
+
+static struct intel_uncore_ops ivt_uncore_msr_ops = {
+	IVT_UNCORE_MSR_OPS_COMMON_INIT(),
+};
+
+static struct intel_uncore_ops ivt_uncore_pci_ops = {
+	.init_box	= ivt_uncore_pci_init_box,
+	.disable_box	= snbep_uncore_pci_disable_box,
+	.enable_box	= snbep_uncore_pci_enable_box,
+	.disable_event	= snbep_uncore_pci_disable_event,
+	.enable_event	= snbep_uncore_pci_enable_event,
+	.read_counter	= snbep_uncore_pci_read_counter,
+};
+
+#define IVT_UNCORE_PCI_COMMON_INIT()				\
+	.perf_ctr	= SNBEP_PCI_PMON_CTR0,			\
+	.event_ctl	= SNBEP_PCI_PMON_CTL0,			\
+	.event_mask	= IVT_PMON_RAW_EVENT_MASK,		\
+	.box_ctl	= SNBEP_PCI_PMON_BOX_CTL,		\
+	.ops		= &ivt_uncore_pci_ops,			\
+	.format_group	= &ivt_uncore_format_group
+
+static struct attribute *ivt_uncore_formats_attr[] = {
+	&format_attr_event.attr,
+	&format_attr_umask.attr,
+	&format_attr_edge.attr,
+	&format_attr_inv.attr,
+	&format_attr_thresh8.attr,
+	NULL,
+};
+
+static struct attribute *ivt_uncore_ubox_formats_attr[] = {
+	&format_attr_event.attr,
+	&format_attr_umask.attr,
+	&format_attr_edge.attr,
+	&format_attr_inv.attr,
+	&format_attr_thresh5.attr,
+	NULL,
+};
+
+static struct attribute *ivt_uncore_cbox_formats_attr[] = {
+	&format_attr_event.attr,
+	&format_attr_umask.attr,
+	&format_attr_edge.attr,
+	&format_attr_tid_en.attr,
+	&format_attr_thresh8.attr,
+	&format_attr_filter_tid.attr,
+	&format_attr_filter_link.attr,
+	&format_attr_filter_state2.attr,
+	&format_attr_filter_nid2.attr,
+	&format_attr_filter_opc2.attr,
+	NULL,
+};
+
+static struct attribute *ivt_uncore_pcu_formats_attr[] = {
+	&format_attr_event_ext.attr,
+	&format_attr_occ_sel.attr,
+	&format_attr_edge.attr,
+	&format_attr_thresh5.attr,
+	&format_attr_occ_invert.attr,
+	&format_attr_occ_edge.attr,
+	&format_attr_filter_band0.attr,
+	&format_attr_filter_band1.attr,
+	&format_attr_filter_band2.attr,
+	&format_attr_filter_band3.attr,
+	NULL,
+};
+
+static struct attribute *ivt_uncore_qpi_formats_attr[] = {
+	&format_attr_event_ext.attr,
+	&format_attr_umask.attr,
+	&format_attr_edge.attr,
+	&format_attr_thresh8.attr,
+	NULL,
+};
+
+static struct attribute_group ivt_uncore_format_group = {
+	.name = "format",
+	.attrs = ivt_uncore_formats_attr,
+};
+
+static struct attribute_group ivt_uncore_ubox_format_group = {
+	.name = "format",
+	.attrs = ivt_uncore_ubox_formats_attr,
+};
+
+static struct attribute_group ivt_uncore_cbox_format_group = {
+	.name = "format",
+	.attrs = ivt_uncore_cbox_formats_attr,
+};
+
+static struct attribute_group ivt_uncore_pcu_format_group = {
+	.name = "format",
+	.attrs = ivt_uncore_pcu_formats_attr,
+};
+
+static struct attribute_group ivt_uncore_qpi_format_group = {
+	.name = "format",
+	.attrs = ivt_uncore_qpi_formats_attr,
+};
+
+static struct intel_uncore_type ivt_uncore_ubox = {
+	.name		= "ubox",
+	.num_counters   = 2,
+	.num_boxes	= 1,
+	.perf_ctr_bits	= 44,
+	.fixed_ctr_bits	= 48,
+	.perf_ctr	= SNBEP_U_MSR_PMON_CTR0,
+	.event_ctl	= SNBEP_U_MSR_PMON_CTL0,
+	.event_mask	= IVT_U_MSR_PMON_RAW_EVENT_MASK,
+	.fixed_ctr	= SNBEP_U_MSR_PMON_UCLK_FIXED_CTR,
+	.fixed_ctl	= SNBEP_U_MSR_PMON_UCLK_FIXED_CTL,
+	.ops		= &ivt_uncore_msr_ops,
+	.format_group	= &ivt_uncore_ubox_format_group,
+};
+
+static struct extra_reg ivt_uncore_cbox_extra_regs[] = {
+	SNBEP_CBO_EVENT_EXTRA_REG(SNBEP_CBO_PMON_CTL_TID_EN,
+				  SNBEP_CBO_PMON_CTL_TID_EN, 0x1),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x1031, 0x10ff, 0x2),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x0334, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x0534, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x0934, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4134, 0xffff, 0xc),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x0135, 0xffff, 0x10),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x0335, 0xffff, 0x10),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x2135, 0xffff, 0x10),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x2335, 0xffff, 0x10),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4135, 0xffff, 0x18),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4335, 0xffff, 0x18),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4435, 0xffff, 0x8),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4835, 0xffff, 0x8),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4a35, 0xffff, 0x8),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x5035, 0xffff, 0x8),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x8135, 0xffff, 0x10),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x8335, 0xffff, 0x10),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x0136, 0xffff, 0x10),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x0336, 0xffff, 0x10),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x2336, 0xffff, 0x10),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x2336, 0xffff, 0x10),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4136, 0xffff, 0x18),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4336, 0xffff, 0x18),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4436, 0xffff, 0x8),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4836, 0xffff, 0x8),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4a36, 0xffff, 0x8),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x5036, 0xffff, 0x8),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x8136, 0xffff, 0x10),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x8336, 0xffff, 0x10),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4037, 0x40ff, 0x8),
+	EVENT_EXTRA_END
+};
+
+static u64 ivt_cbox_filter_mask(int fields)
+{
+	u64 mask = 0;
+
+	if (fields & 0x1)
+		mask |= IVT_CB0_MSR_PMON_BOX_FILTER_TID;
+	if (fields & 0x2)
+		mask |= IVT_CB0_MSR_PMON_BOX_FILTER_LINK;
+	if (fields & 0x4)
+		mask |= IVT_CB0_MSR_PMON_BOX_FILTER_STATE;
+	if (fields & 0x8)
+		mask |= IVT_CB0_MSR_PMON_BOX_FILTER_NID;
+	if (fields & 0x10)
+		mask |= IVT_CB0_MSR_PMON_BOX_FILTER_OPC;
+
+	return mask;
+}
+
+static struct event_constraint *
+ivt_cbox_get_constraint(struct intel_uncore_box *box, struct perf_event *event)
+{
+	return __snbep_cbox_get_constraint(box, event, ivt_cbox_filter_mask);
+}
+
+static int ivt_cbox_hw_config(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
+	struct extra_reg *er;
+	int idx = 0;
+
+	for (er = ivt_uncore_cbox_extra_regs; er->msr; er++) {
+		if (er->event != (event->hw.config & er->config_mask))
+			continue;
+		idx |= er->idx;
+	}
+
+	if (idx) {
+		reg1->reg = SNBEP_C0_MSR_PMON_BOX_FILTER +
+			SNBEP_CBO_MSR_OFFSET * box->pmu->pmu_idx;
+		reg1->config = event->attr.config1 & ivt_cbox_filter_mask(idx);
+		reg1->idx = idx;
+	}
+	return 0;
+}
+
+static void ivt_cbox_enable_event(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
+
+	if (reg1->idx != EXTRA_REG_NONE) {
+		u64 filter = uncore_shared_reg_config(box, 0);
+		wrmsrl(reg1->reg, filter & 0xffffffff);
+		wrmsrl(reg1->reg + 6, filter >> 32);
+	}
+
+	wrmsrl(hwc->config_base, hwc->config | SNBEP_PMON_CTL_EN);
+}
+
+static struct intel_uncore_ops ivt_uncore_cbox_ops = {
+	.init_box		= ivt_uncore_msr_init_box,
+	.disable_box		= snbep_uncore_msr_disable_box,
+	.enable_box		= snbep_uncore_msr_enable_box,
+	.disable_event		= snbep_uncore_msr_disable_event,
+	.enable_event		= ivt_cbox_enable_event,
+	.read_counter		= uncore_msr_read_counter,
+	.hw_config		= ivt_cbox_hw_config,
+	.get_constraint		= ivt_cbox_get_constraint,
+	.put_constraint		= snbep_cbox_put_constraint,
+};
+
+static struct intel_uncore_type ivt_uncore_cbox = {
+	.name			= "cbox",
+	.num_counters		= 4,
+	.num_boxes		= 15,
+	.perf_ctr_bits		= 44,
+	.event_ctl		= SNBEP_C0_MSR_PMON_CTL0,
+	.perf_ctr		= SNBEP_C0_MSR_PMON_CTR0,
+	.event_mask		= IVT_CBO_MSR_PMON_RAW_EVENT_MASK,
+	.box_ctl		= SNBEP_C0_MSR_PMON_BOX_CTL,
+	.msr_offset		= SNBEP_CBO_MSR_OFFSET,
+	.num_shared_regs	= 1,
+	.constraints		= snbep_uncore_cbox_constraints,
+	.ops			= &ivt_uncore_cbox_ops,
+	.format_group		= &ivt_uncore_cbox_format_group,
+};
+
+static struct intel_uncore_ops ivt_uncore_pcu_ops = {
+	IVT_UNCORE_MSR_OPS_COMMON_INIT(),
+	.hw_config		= snbep_pcu_hw_config,
+	.get_constraint		= snbep_pcu_get_constraint,
+	.put_constraint		= snbep_pcu_put_constraint,
+};
+
+static struct intel_uncore_type ivt_uncore_pcu = {
+	.name			= "pcu",
+	.num_counters		= 4,
+	.num_boxes		= 1,
+	.perf_ctr_bits		= 48,
+	.perf_ctr		= SNBEP_PCU_MSR_PMON_CTR0,
+	.event_ctl		= SNBEP_PCU_MSR_PMON_CTL0,
+	.event_mask		= IVT_PCU_MSR_PMON_RAW_EVENT_MASK,
+	.box_ctl		= SNBEP_PCU_MSR_PMON_BOX_CTL,
+	.num_shared_regs	= 1,
+	.ops			= &ivt_uncore_pcu_ops,
+	.format_group		= &ivt_uncore_pcu_format_group,
+};
+
+static struct intel_uncore_type *ivt_msr_uncores[] = {
+	&ivt_uncore_ubox,
+	&ivt_uncore_cbox,
+	&ivt_uncore_pcu,
+	NULL,
+};
+
+static struct intel_uncore_type ivt_uncore_ha = {
+	.name		= "ha",
+	.num_counters   = 4,
+	.num_boxes	= 2,
+	.perf_ctr_bits	= 48,
+	IVT_UNCORE_PCI_COMMON_INIT(),
+};
+
+static struct intel_uncore_type ivt_uncore_imc = {
+	.name		= "imc",
+	.num_counters   = 4,
+	.num_boxes	= 8,
+	.perf_ctr_bits	= 48,
+	.fixed_ctr_bits	= 48,
+	.fixed_ctr	= SNBEP_MC_CHy_PCI_PMON_FIXED_CTR,
+	.fixed_ctl	= SNBEP_MC_CHy_PCI_PMON_FIXED_CTL,
+	IVT_UNCORE_PCI_COMMON_INIT(),
+};
+
+static struct intel_uncore_type ivt_uncore_qpi = {
+	.name		= "qpi",
+	.num_counters   = 4,
+	.num_boxes	= 3,
+	.perf_ctr_bits	= 48,
+	.perf_ctr	= SNBEP_PCI_PMON_CTR0,
+	.event_ctl	= SNBEP_PCI_PMON_CTL0,
+	.event_mask	= IVT_QPI_PCI_PMON_RAW_EVENT_MASK,
+	.box_ctl	= SNBEP_PCI_PMON_BOX_CTL,
+	.ops		= &ivt_uncore_pci_ops,
+	.format_group	= &ivt_uncore_qpi_format_group,
+};
+
+static struct intel_uncore_type ivt_uncore_r2pcie = {
+	.name		= "r2pcie",
+	.num_counters   = 4,
+	.num_boxes	= 1,
+	.perf_ctr_bits	= 44,
+	.constraints	= snbep_uncore_r2pcie_constraints,
+	IVT_UNCORE_PCI_COMMON_INIT(),
+};
+
+static struct intel_uncore_type ivt_uncore_r3qpi = {
+	.name		= "r3qpi",
+	.num_counters   = 3,
+	.num_boxes	= 2,
+	.perf_ctr_bits	= 44,
+	.constraints	= snbep_uncore_r3qpi_constraints,
+	IVT_UNCORE_PCI_COMMON_INIT(),
+};
+
+enum {
+	IVT_PCI_UNCORE_HA,
+	IVT_PCI_UNCORE_IMC,
+	IVT_PCI_UNCORE_QPI,
+	IVT_PCI_UNCORE_R2PCIE,
+	IVT_PCI_UNCORE_R3QPI,
+};
+
+static struct intel_uncore_type *ivt_pci_uncores[] = {
+	[IVT_PCI_UNCORE_HA]	= &ivt_uncore_ha,
+	[IVT_PCI_UNCORE_IMC]	= &ivt_uncore_imc,
+	[IVT_PCI_UNCORE_QPI]	= &ivt_uncore_qpi,
+	[IVT_PCI_UNCORE_R2PCIE]	= &ivt_uncore_r2pcie,
+	[IVT_PCI_UNCORE_R3QPI]	= &ivt_uncore_r3qpi,
+	NULL,
+};
+
+static DEFINE_PCI_DEVICE_TABLE(ivt_uncore_pci_ids) = {
+	{ /* Home Agent 0 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe30),
+		.driver_data = IVT_PCI_UNCORE_HA,
+	},
+	{ /* Home Agent 1 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe38),
+		.driver_data = IVT_PCI_UNCORE_HA,
+	},
+	{ /* MC0 Channel 0 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xeb4),
+		.driver_data = IVT_PCI_UNCORE_IMC,
+	},
+	{ /* MC0 Channel 1 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xeb5),
+		.driver_data = IVT_PCI_UNCORE_IMC,
+	},
+	{ /* MC0 Channel 3 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xeb0),
+		.driver_data = IVT_PCI_UNCORE_IMC,
+	},
+	{ /* MC0 Channel 4 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xeb1),
+		.driver_data = IVT_PCI_UNCORE_IMC,
+	},
+	{ /* MC1 Channel 0 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xef4),
+		.driver_data = IVT_PCI_UNCORE_IMC,
+	},
+	{ /* MC1 Channel 1 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xef5),
+		.driver_data = IVT_PCI_UNCORE_IMC,
+	},
+	{ /* MC1 Channel 3 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xef0),
+		.driver_data = IVT_PCI_UNCORE_IMC,
+	},
+	{ /* MC1 Channel 4 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xef1),
+		.driver_data = IVT_PCI_UNCORE_IMC,
+	},
+	{ /* QPI0 Port 0 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe32),
+		.driver_data = IVT_PCI_UNCORE_QPI,
+	},
+	{ /* QPI0 Port 1 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe33),
+		.driver_data = IVT_PCI_UNCORE_QPI,
+	},
+	{ /* QPI1 Port 2 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe3a),
+		.driver_data = IVT_PCI_UNCORE_QPI,
+	},
+	{ /* R2PCIe */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe34),
+		.driver_data = IVT_PCI_UNCORE_R2PCIE,
+	},
+	{ /* R3QPI0 Link 0 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe36),
+		.driver_data = IVT_PCI_UNCORE_R3QPI,
+	},
+	{ /* R3QPI0 Link 1 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe37),
+		.driver_data = IVT_PCI_UNCORE_R3QPI,
+	},
+	{ /* R3QPI1 Link 2 */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe3e),
+		.driver_data = IVT_PCI_UNCORE_R3QPI,
+	},
+	{ /* end: all zeroes */ }
+};
+
+static struct pci_driver ivt_uncore_pci_driver = {
+	.name		= "ivt_uncore",
+	.id_table	= ivt_uncore_pci_ids,
+};
+/* end of IvyTown uncore support */
+
 /* Sandy Bridge uncore support */
 static void snb_uncore_msr_enable_event(struct intel_uncore_box *box, struct perf_event *event)
 {
@@ -808,9 +1491,6 @@ static struct intel_uncore_type *nhm_msr_uncores[] = {
 /* end of Nehalem uncore support */
 
 /* Nehalem-EX uncore support */
-#define __BITS_VALUE(x, i, n)  ((typeof(x))(((x) >> ((i) * (n))) & \
-				((1ULL << (n)) - 1)))
-
 DEFINE_UNCORE_FORMAT_ATTR(event5, event, "config:1-5");
 DEFINE_UNCORE_FORMAT_ATTR(counter, counter, "config:6-7");
 DEFINE_UNCORE_FORMAT_ATTR(match, match, "config1:0-63");
@@ -1161,7 +1841,7 @@ static struct extra_reg nhmex_uncore_mbox_extra_regs[] = {
 };
 
 /* Nehalem-EX or Westmere-EX ? */
-bool uncore_nhmex;
+static bool uncore_nhmex;
 
 static bool nhmex_mbox_get_shared_reg(struct intel_uncore_box *box, int idx, u64 config)
 {
@@ -1239,7 +1919,7 @@ static void nhmex_mbox_put_shared_reg(struct intel_uncore_box *box, int idx)
 	atomic_sub(1 << (idx * 8), &er->ref);
 }
 
-u64 nhmex_mbox_alter_er(struct perf_event *event, int new_idx, bool modify)
+static u64 nhmex_mbox_alter_er(struct perf_event *event, int new_idx, bool modify)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
@@ -1554,7 +2234,7 @@ static struct intel_uncore_type nhmex_uncore_mbox = {
 	.format_group		= &nhmex_uncore_mbox_format_group,
 };
 
-void nhmex_rbox_alter_er(struct intel_uncore_box *box, struct perf_event *event)
+static void nhmex_rbox_alter_er(struct intel_uncore_box *box, struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
@@ -1724,21 +2404,6 @@ static int nhmex_rbox_hw_config(struct intel_uncore_box *box, struct perf_event
 	return 0;
 }
 
-static u64 nhmex_rbox_shared_reg_config(struct intel_uncore_box *box, int idx)
-{
-	struct intel_uncore_extra_reg *er;
-	unsigned long flags;
-	u64 config;
-
-	er = &box->shared_regs[idx];
-
-	raw_spin_lock_irqsave(&er->lock, flags);
-	config = er->config;
-	raw_spin_unlock_irqrestore(&er->lock, flags);
-
-	return config;
-}
-
 static void nhmex_rbox_msr_enable_event(struct intel_uncore_box *box, struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -1759,7 +2424,7 @@ static void nhmex_rbox_msr_enable_event(struct intel_uncore_box *box, struct per
 	case 2:
 	case 3:
 		wrmsrl(NHMEX_R_MSR_PORTN_QLX_CFG(port),
-			nhmex_rbox_shared_reg_config(box, 2 + (idx / 6) * 5));
+			uncore_shared_reg_config(box, 2 + (idx / 6) * 5));
 		break;
 	case 4:
 		wrmsrl(NHMEX_R_MSR_PORTN_XBR_SET1_MM_CFG(port),
@@ -2285,7 +2950,7 @@ out:
 	return ret;
 }
 
-int uncore_pmu_event_init(struct perf_event *event)
+static int uncore_pmu_event_init(struct perf_event *event)
 {
 	struct intel_uncore_pmu *pmu;
 	struct intel_uncore_box *box;
@@ -2438,7 +3103,7 @@ static int __init uncore_type_init(struct intel_uncore_type *type)
 
 	type->unconstrainted = (struct event_constraint)
 		__EVENT_CONSTRAINT(0, (1ULL << type->num_counters) - 1,
-				0, type->num_counters, 0);
+				0, type->num_counters, 0, 0);
 
 	for (i = 0; i < type->num_boxes; i++) {
 		pmus[i].func_id = -1;
@@ -2556,6 +3221,8 @@ static void uncore_pci_remove(struct pci_dev *pdev)
 	if (WARN_ON_ONCE(phys_id != box->phys_id))
 		return;
 
+	pci_set_drvdata(pdev, NULL);
+
 	raw_spin_lock(&uncore_box_lock);
 	list_del(&box->list);
 	raw_spin_unlock(&uncore_box_lock);
@@ -2574,11 +3241,7 @@ static void uncore_pci_remove(struct pci_dev *pdev)
 static int uncore_pci_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *id)
 {
-	struct intel_uncore_type *type;
-
-	type = (struct intel_uncore_type *)id->driver_data;
-
-	return uncore_pci_add(type, pdev);
+	return uncore_pci_add(pci_uncores[id->driver_data], pdev);
 }
 
 static int __init uncore_pci_init(void)
@@ -2587,12 +3250,19 @@ static int __init uncore_pci_init(void)
 
 	switch (boot_cpu_data.x86_model) {
 	case 45: /* Sandy Bridge-EP */
-		ret = snbep_pci2phy_map_init();
+		ret = snbep_pci2phy_map_init(0x3ce0);
 		if (ret)
 			return ret;
 		pci_uncores = snbep_pci_uncores;
 		uncore_pci_driver = &snbep_uncore_pci_driver;
 		break;
+	case 62: /* IvyTown */
+		ret = snbep_pci2phy_map_init(0x0e1e);
+		if (ret)
+			return ret;
+		pci_uncores = ivt_pci_uncores;
+		uncore_pci_driver = &ivt_uncore_pci_driver;
+		break;
 	default:
 		return 0;
 	}
@@ -2622,6 +3292,21 @@ static void __init uncore_pci_exit(void)
 	}
 }
 
+/* CPU hot plug/unplug are serialized by cpu_add_remove_lock mutex */
+static LIST_HEAD(boxes_to_free);
+
+static void __cpuinit uncore_kfree_boxes(void)
+{
+	struct intel_uncore_box *box;
+
+	while (!list_empty(&boxes_to_free)) {
+		box = list_entry(boxes_to_free.next,
+				 struct intel_uncore_box, list);
+		list_del(&box->list);
+		kfree(box);
+	}
+}
+
 static void __cpuinit uncore_cpu_dying(int cpu)
 {
 	struct intel_uncore_type *type;
@@ -2636,7 +3321,7 @@ static void __cpuinit uncore_cpu_dying(int cpu)
 			box = *per_cpu_ptr(pmu->box, cpu);
 			*per_cpu_ptr(pmu->box, cpu) = NULL;
 			if (box && atomic_dec_and_test(&box->refcnt))
-				kfree(box);
+				list_add(&box->list, &boxes_to_free);
 		}
 	}
 }
@@ -2666,8 +3351,11 @@ static int __cpuinit uncore_cpu_starting(int cpu)
 				if (exist && exist->phys_id == phys_id) {
 					atomic_inc(&exist->refcnt);
 					*per_cpu_ptr(pmu->box, cpu) = exist;
-					kfree(box);
-					box = NULL;
+					if (box) {
+						list_add(&box->list,
+							 &boxes_to_free);
+						box = NULL;
+					}
 					break;
 				}
 			}
@@ -2806,6 +3494,10 @@ static int
 	case CPU_DYING:
 		uncore_cpu_dying(cpu);
 		break;
+	case CPU_ONLINE:
+	case CPU_DEAD:
+		uncore_kfree_boxes();
+		break;
 	default:
 		break;
 	}
@@ -2871,6 +3563,12 @@ static int __init uncore_cpu_init(void)
 			nhmex_uncore_cbox.num_boxes = max_cores;
 		msr_uncores = nhmex_msr_uncores;
 		break;
+	case 62: /* IvyTown */
+		if (ivt_uncore_cbox.num_boxes > max_cores)
+			ivt_uncore_cbox.num_boxes = max_cores;
+		msr_uncores = ivt_msr_uncores;
+		break;
+
 	default:
 		return 0;
 	}
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index e68a455..f952891 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -76,7 +76,7 @@
 #define SNBEP_PMON_CTL_UMASK_MASK	0x0000ff00
 #define SNBEP_PMON_CTL_RST		(1 << 17)
 #define SNBEP_PMON_CTL_EDGE_DET		(1 << 18)
-#define SNBEP_PMON_CTL_EV_SEL_EXT	(1 << 21)	/* only for QPI */
+#define SNBEP_PMON_CTL_EV_SEL_EXT	(1 << 21)
 #define SNBEP_PMON_CTL_EN		(1 << 22)
 #define SNBEP_PMON_CTL_INVERT		(1 << 23)
 #define SNBEP_PMON_CTL_TRESH_MASK	0xff000000
@@ -148,9 +148,20 @@
 #define SNBEP_C0_MSR_PMON_CTL0			0xd10
 #define SNBEP_C0_MSR_PMON_BOX_CTL		0xd04
 #define SNBEP_C0_MSR_PMON_BOX_FILTER		0xd14
-#define SNBEP_CB0_MSR_PMON_BOX_FILTER_MASK	0xfffffc1f
 #define SNBEP_CBO_MSR_OFFSET			0x20
 
+#define SNBEP_CB0_MSR_PMON_BOX_FILTER_TID	0x1f
+#define SNBEP_CB0_MSR_PMON_BOX_FILTER_NID	0x3fc00
+#define SNBEP_CB0_MSR_PMON_BOX_FILTER_STATE	0x7c0000
+#define SNBEP_CB0_MSR_PMON_BOX_FILTER_OPC	0xff800000
+
+#define SNBEP_CBO_EVENT_EXTRA_REG(e, m, i) {	\
+	.event = (e),				\
+	.msr = SNBEP_C0_MSR_PMON_BOX_FILTER,	\
+	.config_mask = (m),			\
+	.idx = (i)				\
+}
+
 /* SNB-EP PCU register */
 #define SNBEP_PCU_MSR_PMON_CTR0			0xc36
 #define SNBEP_PCU_MSR_PMON_CTL0			0xc30
@@ -160,6 +171,55 @@
 #define SNBEP_PCU_MSR_CORE_C3_CTR		0x3fc
 #define SNBEP_PCU_MSR_CORE_C6_CTR		0x3fd
 
+/* IVT event control */
+#define IVT_PMON_BOX_CTL_INT		(SNBEP_PMON_BOX_CTL_RST_CTRL | \
+					 SNBEP_PMON_BOX_CTL_RST_CTRS)
+#define IVT_PMON_RAW_EVENT_MASK		(SNBEP_PMON_CTL_EV_SEL_MASK | \
+					 SNBEP_PMON_CTL_UMASK_MASK | \
+					 SNBEP_PMON_CTL_EDGE_DET | \
+					 SNBEP_PMON_CTL_TRESH_MASK)
+/* IVT Ubox */
+#define IVT_U_MSR_PMON_GLOBAL_CTL		0xc00
+#define IVT_U_PMON_GLOBAL_FRZ_ALL		(1 << 31)
+#define IVT_U_PMON_GLOBAL_UNFRZ_ALL		(1 << 29)
+
+#define IVT_U_MSR_PMON_RAW_EVENT_MASK	\
+				(SNBEP_PMON_CTL_EV_SEL_MASK | \
+				 SNBEP_PMON_CTL_UMASK_MASK | \
+				 SNBEP_PMON_CTL_EDGE_DET | \
+				 SNBEP_U_MSR_PMON_CTL_TRESH_MASK)
+/* IVT Cbo */
+#define IVT_CBO_MSR_PMON_RAW_EVENT_MASK		(IVT_PMON_RAW_EVENT_MASK | \
+						 SNBEP_CBO_PMON_CTL_TID_EN)
+
+#define IVT_CB0_MSR_PMON_BOX_FILTER_TID		(0x1fULL << 0)
+#define IVT_CB0_MSR_PMON_BOX_FILTER_LINK	(0xfULL << 5)
+#define IVT_CB0_MSR_PMON_BOX_FILTER_STATE	(0x3fULL << 17)
+#define IVT_CB0_MSR_PMON_BOX_FILTER_NID		(0xffffULL << 32)
+#define IVT_CB0_MSR_PMON_BOX_FILTER_OPC		(0x1ffULL << 52)
+#define IVT_CB0_MSR_PMON_BOX_FILTER_C6		(0x1ULL << 61)
+#define IVT_CB0_MSR_PMON_BOX_FILTER_NC		(0x1ULL << 62)
+#define IVT_CB0_MSR_PMON_BOX_FILTER_IOSC	(0x1ULL << 63)
+
+/* IVT home agent */
+#define IVT_HA_PCI_PMON_CTL_Q_OCC_RST		(1 << 16)
+#define IVT_HA_PCI_PMON_RAW_EVENT_MASK		\
+				(IVT_PMON_RAW_EVENT_MASK | \
+				 IVT_HA_PCI_PMON_CTL_Q_OCC_RST)
+/* IVT PCU */
+#define IVT_PCU_MSR_PMON_RAW_EVENT_MASK	\
+				(SNBEP_PMON_CTL_EV_SEL_MASK | \
+				 SNBEP_PMON_CTL_EV_SEL_EXT | \
+				 SNBEP_PCU_MSR_PMON_CTL_OCC_SEL_MASK | \
+				 SNBEP_PMON_CTL_EDGE_DET | \
+				 SNBEP_PCU_MSR_PMON_CTL_TRESH_MASK | \
+				 SNBEP_PCU_MSR_PMON_CTL_OCC_INVERT | \
+				 SNBEP_PCU_MSR_PMON_CTL_OCC_EDGE_DET)
+/* IVT QPI */
+#define IVT_QPI_PCI_PMON_RAW_EVENT_MASK	\
+				(IVT_PMON_RAW_EVENT_MASK | \
+				 SNBEP_PMON_CTL_EV_SEL_EXT)
+
 /* NHM-EX event control */
 #define NHMEX_PMON_CTL_EV_SEL_MASK	0x000000ff
 #define NHMEX_PMON_CTL_UMASK_MASK	0x0000ff00
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 92c7e39..3486e66 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -895,8 +895,8 @@ static void p4_pmu_disable_pebs(void)
 	 * So at moment let leave metrics turned on forever -- it's
 	 * ok for now but need to be revisited!
 	 *
-	 * (void)wrmsrl_safe(MSR_IA32_PEBS_ENABLE, (u64)0);
-	 * (void)wrmsrl_safe(MSR_P4_PEBS_MATRIX_VERT, (u64)0);
+	 * (void)wrmsrl_safe(MSR_IA32_PEBS_ENABLE, 0);
+	 * (void)wrmsrl_safe(MSR_P4_PEBS_MATRIX_VERT, 0);
 	 */
 }
 
@@ -910,8 +910,7 @@ static inline void p4_pmu_disable_event(struct perf_event *event)
 	 * asserted again and again
 	 */
 	(void)wrmsrl_safe(hwc->config_base,
-		(u64)(p4_config_unpack_cccr(hwc->config)) &
-			~P4_CCCR_ENABLE & ~P4_CCCR_OVF & ~P4_CCCR_RESERVED);
+		p4_config_unpack_cccr(hwc->config) & ~P4_CCCR_ENABLE & ~P4_CCCR_OVF & ~P4_CCCR_RESERVED);
 }
 
 static void p4_pmu_disable_all(void)
@@ -957,7 +956,7 @@ static void p4_pmu_enable_event(struct perf_event *event)
 	u64 escr_addr, cccr;
 
 	bind = &p4_event_bind_map[idx];
-	escr_addr = (u64)bind->escr_msr[thread];
+	escr_addr = bind->escr_msr[thread];
 
 	/*
 	 * - we dont support cascaded counters yet
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 7bfe318..9895a9a 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -353,7 +353,11 @@ int __kprobes __copy_instruction(u8 *dest, u8 *src)
 		 * have given.
 		 */
 		newdisp = (u8 *) src + (s64) insn.displacement.value - (u8 *) dest;
-		BUG_ON((s64) (s32) newdisp != newdisp); /* Sanity check.  */
+		if ((s64) (s32) newdisp != newdisp) {
+			pr_err("Kprobes error: new displacement does not fit into s32 (%llx)\n", newdisp);
+			pr_err("\tSrc: %p, Dest: %p, old disp: %x\n", src, dest, insn.displacement.value);
+			return 0;
+		}
 		disp = (u8 *) dest + insn_offset_displacement(&insn);
 		*(s32 *) disp = (s32) newdisp;
 	}
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 0ba4cfb..2ed8459 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -697,3 +697,32 @@ bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
 		send_sig(SIGTRAP, current, 0);
 	return ret;
 }
+
+unsigned long
+arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs)
+{
+	int rasize, ncopied;
+	unsigned long orig_ret_vaddr = 0; /* clear high bits for 32-bit apps */
+
+	rasize = is_ia32_task() ? 4 : 8;
+	ncopied = copy_from_user(&orig_ret_vaddr, (void __user *)regs->sp, rasize);
+	if (unlikely(ncopied))
+		return -1;
+
+	/* check whether address has been already hijacked */
+	if (orig_ret_vaddr == trampoline_vaddr)
+		return orig_ret_vaddr;
+
+	ncopied = copy_to_user((void __user *)regs->sp, &trampoline_vaddr, rasize);
+	if (likely(!ncopied))
+		return orig_ret_vaddr;
+
+	if (ncopied != rasize) {
+		pr_err("uprobe: return address clobbered: pid=%d, %%sp=%#lx, "
+			"%%ip=%#lx\n", current->pid, regs->sp, regs->ip);
+
+		force_sig_info(SIGSEGV, SEND_SIG_FORCED, current);
+	}
+
+	return -1;
+}
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 10b8f23..92669cd 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -351,4 +351,10 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
  */
 #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
 
+/* Ignore/forbid kprobes attach on very low level functions marked by this attribute: */
+#ifdef CONFIG_KPROBES
+# define __kprobes	__attribute__((__section__(".kprobes.text")))
+#else
+# define __kprobes
+#endif
 #endif /* __LINUX_COMPILER_H */
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 4b6ef4d..ca1d27a 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -29,6 +29,7 @@
  *		<jkenisto@us.ibm.com>  and Prasanna S Panchamukhi
  *		<prasanna@in.ibm.com> added function-return probes.
  */
+#include <linux/compiler.h>	/* for __kprobes */
 #include <linux/linkage.h>
 #include <linux/list.h>
 #include <linux/notifier.h>
@@ -49,16 +50,11 @@
 #define KPROBE_REENTER		0x00000004
 #define KPROBE_HIT_SSDONE	0x00000008
 
-/* Attach to insert probes on any functions which should be ignored*/
-#define __kprobes	__attribute__((__section__(".kprobes.text")))
-
 #else /* CONFIG_KPROBES */
 typedef int kprobe_opcode_t;
 struct arch_specific_insn {
 	int dummy;
 };
-#define __kprobes
-
 #endif /* CONFIG_KPROBES */
 
 struct kprobe;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 1d795df..e0373d2 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -21,7 +21,6 @@
  */
 
 #ifdef CONFIG_PERF_EVENTS
-# include <linux/cgroup.h>
 # include <asm/perf_event.h>
 # include <asm/local64.h>
 #endif
@@ -128,6 +127,7 @@ struct hw_perf_event {
 			int		event_base_rdpmc;
 			int		idx;
 			int		last_cpu;
+			int		flags;
 
 			struct hw_perf_event_extra extra_reg;
 			struct hw_perf_event_extra branch_reg;
@@ -299,22 +299,7 @@ struct swevent_hlist {
 #define PERF_ATTACH_GROUP	0x02
 #define PERF_ATTACH_TASK	0x04
 
-#ifdef CONFIG_CGROUP_PERF
-/*
- * perf_cgroup_info keeps track of time_enabled for a cgroup.
- * This is a per-cpu dynamically allocated data structure.
- */
-struct perf_cgroup_info {
-	u64				time;
-	u64				timestamp;
-};
-
-struct perf_cgroup {
-	struct				cgroup_subsys_state css;
-	struct				perf_cgroup_info *info;	/* timing info, one per cpu */
-};
-#endif
-
+struct perf_cgroup;
 struct ring_buffer;
 
 /**
@@ -583,11 +568,13 @@ struct perf_sample_data {
 		u32	reserved;
 	}				cpu_entry;
 	u64				period;
+	union  perf_mem_data_src	data_src;
 	struct perf_callchain_entry	*callchain;
 	struct perf_raw_record		*raw;
 	struct perf_branch_stack	*br_stack;
 	struct perf_regs_user		regs_user;
 	u64				stack_user_size;
+	u64				weight;
 };
 
 static inline void perf_sample_data_init(struct perf_sample_data *data,
@@ -601,6 +588,8 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
 	data->regs_user.abi = PERF_SAMPLE_REGS_ABI_NONE;
 	data->regs_user.regs = NULL;
 	data->stack_user_size = 0;
+	data->weight = 0;
+	data->data_src.val = 0;
 }
 
 extern void perf_output_sample(struct perf_output_handle *handle,
@@ -831,6 +820,7 @@ do {									\
 struct perf_pmu_events_attr {
 	struct device_attribute attr;
 	u64 id;
+	const char *event_str;
 };
 
 #define PMU_EVENT_ATTR(_name, _var, _id, _show)				\
diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 02b83db..06f28be 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -38,6 +38,8 @@ struct inode;
 #define UPROBE_HANDLER_REMOVE		1
 #define UPROBE_HANDLER_MASK		1
 
+#define MAX_URETPROBE_DEPTH		64
+
 enum uprobe_filter_ctx {
 	UPROBE_FILTER_REGISTER,
 	UPROBE_FILTER_UNREGISTER,
@@ -46,6 +48,9 @@ enum uprobe_filter_ctx {
 
 struct uprobe_consumer {
 	int (*handler)(struct uprobe_consumer *self, struct pt_regs *regs);
+	int (*ret_handler)(struct uprobe_consumer *self,
+				unsigned long func,
+				struct pt_regs *regs);
 	bool (*filter)(struct uprobe_consumer *self,
 				enum uprobe_filter_ctx ctx,
 				struct mm_struct *mm);
@@ -68,6 +73,8 @@ struct uprobe_task {
 	enum uprobe_task_state		state;
 	struct arch_uprobe_task		autask;
 
+	struct return_instance		*return_instances;
+	unsigned int			depth;
 	struct uprobe			*active_uprobe;
 
 	unsigned long			xol_vaddr;
@@ -100,6 +107,7 @@ struct uprobes_state {
 extern int __weak set_swbp(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long vaddr);
 extern int __weak set_orig_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long vaddr);
 extern bool __weak is_swbp_insn(uprobe_opcode_t *insn);
+extern bool __weak is_trap_insn(uprobe_opcode_t *insn);
 extern int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *uc);
 extern int uprobe_apply(struct inode *inode, loff_t offset, struct uprobe_consumer *uc, bool);
 extern void uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consumer *uc);
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 9fa9c62..fb104e5 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -132,8 +132,10 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_BRANCH_STACK		= 1U << 11,
 	PERF_SAMPLE_REGS_USER			= 1U << 12,
 	PERF_SAMPLE_STACK_USER			= 1U << 13,
+	PERF_SAMPLE_WEIGHT			= 1U << 14,
+	PERF_SAMPLE_DATA_SRC			= 1U << 15,
 
-	PERF_SAMPLE_MAX = 1U << 14,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 16,		/* non-ABI */
 };
 
 /*
@@ -443,6 +445,7 @@ struct perf_event_mmap_page {
 #define PERF_RECORD_MISC_GUEST_KERNEL		(4 << 0)
 #define PERF_RECORD_MISC_GUEST_USER		(5 << 0)
 
+#define PERF_RECORD_MISC_MMAP_DATA		(1 << 13)
 /*
  * Indicates that the content of PERF_SAMPLE_IP points to
  * the actual instruction that triggered the event. See also
@@ -588,6 +591,9 @@ enum perf_event_type {
 	 * 	{ u64			size;
 	 * 	  char			data[size];
 	 * 	  u64			dyn_size; } && PERF_SAMPLE_STACK_USER
+	 *
+	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
+	 *	{ u64			data_src;     } && PERF_SAMPLE_DATA_SRC
 	 * };
 	 */
 	PERF_RECORD_SAMPLE			= 9,
@@ -613,4 +619,67 @@ enum perf_callchain_context {
 #define PERF_FLAG_FD_OUTPUT		(1U << 1)
 #define PERF_FLAG_PID_CGROUP		(1U << 2) /* pid=cgroup id, per-cpu mode only */
 
+union perf_mem_data_src {
+	__u64 val;
+	struct {
+		__u64   mem_op:5,	/* type of opcode */
+			mem_lvl:14,	/* memory hierarchy level */
+			mem_snoop:5,	/* snoop mode */
+			mem_lock:2,	/* lock instr */
+			mem_dtlb:7,	/* tlb access */
+			mem_rsvd:31;
+	};
+};
+
+/* type of opcode (load/store/prefetch,code) */
+#define PERF_MEM_OP_NA		0x01 /* not available */
+#define PERF_MEM_OP_LOAD	0x02 /* load instruction */
+#define PERF_MEM_OP_STORE	0x04 /* store instruction */
+#define PERF_MEM_OP_PFETCH	0x08 /* prefetch */
+#define PERF_MEM_OP_EXEC	0x10 /* code (execution) */
+#define PERF_MEM_OP_SHIFT	0
+
+/* memory hierarchy (memory level, hit or miss) */
+#define PERF_MEM_LVL_NA		0x01  /* not available */
+#define PERF_MEM_LVL_HIT	0x02  /* hit level */
+#define PERF_MEM_LVL_MISS	0x04  /* miss level  */
+#define PERF_MEM_LVL_L1		0x08  /* L1 */
+#define PERF_MEM_LVL_LFB	0x10  /* Line Fill Buffer */
+#define PERF_MEM_LVL_L2		0x20  /* L2 */
+#define PERF_MEM_LVL_L3		0x40  /* L3 */
+#define PERF_MEM_LVL_LOC_RAM	0x80  /* Local DRAM */
+#define PERF_MEM_LVL_REM_RAM1	0x100 /* Remote DRAM (1 hop) */
+#define PERF_MEM_LVL_REM_RAM2	0x200 /* Remote DRAM (2 hops) */
+#define PERF_MEM_LVL_REM_CCE1	0x400 /* Remote Cache (1 hop) */
+#define PERF_MEM_LVL_REM_CCE2	0x800 /* Remote Cache (2 hops) */
+#define PERF_MEM_LVL_IO		0x1000 /* I/O memory */
+#define PERF_MEM_LVL_UNC	0x2000 /* Uncached memory */
+#define PERF_MEM_LVL_SHIFT	5
+
+/* snoop mode */
+#define PERF_MEM_SNOOP_NA	0x01 /* not available */
+#define PERF_MEM_SNOOP_NONE	0x02 /* no snoop */
+#define PERF_MEM_SNOOP_HIT	0x04 /* snoop hit */
+#define PERF_MEM_SNOOP_MISS	0x08 /* snoop miss */
+#define PERF_MEM_SNOOP_HITM	0x10 /* snoop hit modified */
+#define PERF_MEM_SNOOP_SHIFT	19
+
+/* locked instruction */
+#define PERF_MEM_LOCK_NA	0x01 /* not available */
+#define PERF_MEM_LOCK_LOCKED	0x02 /* locked transaction */
+#define PERF_MEM_LOCK_SHIFT	24
+
+/* TLB access */
+#define PERF_MEM_TLB_NA		0x01 /* not available */
+#define PERF_MEM_TLB_HIT	0x02 /* hit level */
+#define PERF_MEM_TLB_MISS	0x04 /* miss level */
+#define PERF_MEM_TLB_L1		0x08 /* L1 */
+#define PERF_MEM_TLB_L2		0x10 /* L2 */
+#define PERF_MEM_TLB_WK		0x20 /* Hardware Walker*/
+#define PERF_MEM_TLB_OS		0x40 /* OS fault handler */
+#define PERF_MEM_TLB_SHIFT	26
+
+#define PERF_MEM_S(a, s) \
+	(((u64)PERF_MEM_##a##_##s) << PERF_MEM_##a##_SHIFT)
+
 #endif /* _UAPI_LINUX_PERF_EVENT_H */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4d3124b..8097df3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -37,6 +37,7 @@
 #include <linux/ftrace_event.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/mm_types.h>
+#include <linux/cgroup.h>
 
 #include "internal.h"
 
@@ -234,6 +235,20 @@ static void perf_ctx_unlock(struct perf_cpu_context *cpuctx,
 #ifdef CONFIG_CGROUP_PERF
 
 /*
+ * perf_cgroup_info keeps track of time_enabled for a cgroup.
+ * This is a per-cpu dynamically allocated data structure.
+ */
+struct perf_cgroup_info {
+	u64				time;
+	u64				timestamp;
+};
+
+struct perf_cgroup {
+	struct cgroup_subsys_state	css;
+	struct perf_cgroup_info	__percpu *info;
+};
+
+/*
  * Must ensure cgroup is pinned (css_get) before calling
  * this function. In other words, we cannot call this function
  * if there is no cgroup event for the current CPU context.
@@ -961,9 +976,15 @@ static void perf_event__header_size(struct perf_event *event)
 	if (sample_type & PERF_SAMPLE_PERIOD)
 		size += sizeof(data->period);
 
+	if (sample_type & PERF_SAMPLE_WEIGHT)
+		size += sizeof(data->weight);
+
 	if (sample_type & PERF_SAMPLE_READ)
 		size += event->read_size;
 
+	if (sample_type & PERF_SAMPLE_DATA_SRC)
+		size += sizeof(data->data_src.val);
+
 	event->header_size = size;
 }
 
@@ -4178,6 +4199,12 @@ void perf_output_sample(struct perf_output_handle *handle,
 		perf_output_sample_ustack(handle,
 					  data->stack_user_size,
 					  data->regs_user.regs);
+
+	if (sample_type & PERF_SAMPLE_WEIGHT)
+		perf_output_put(handle, data->weight);
+
+	if (sample_type & PERF_SAMPLE_DATA_SRC)
+		perf_output_put(handle, data->data_src.val);
 }
 
 void perf_prepare_sample(struct perf_event_header *header,
@@ -4765,6 +4792,9 @@ got_name:
 	mmap_event->file_name = name;
 	mmap_event->file_size = size;
 
+	if (!(vma->vm_flags & VM_EXEC))
+		mmap_event->event_id.header.misc |= PERF_RECORD_MISC_MMAP_DATA;
+
 	mmap_event->event_id.header.size = sizeof(mmap_event->event_id) + size;
 
 	rcu_read_lock();
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index a567c8c..f356974 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -75,6 +75,15 @@ struct uprobe {
 	struct arch_uprobe	arch;
 };
 
+struct return_instance {
+	struct uprobe		*uprobe;
+	unsigned long		func;
+	unsigned long		orig_ret_vaddr; /* original return address */
+	bool			chained;	/* true, if instance is nested */
+
+	struct return_instance	*next;		/* keep as stack */
+};
+
 /*
  * valid_vma: Verify if the specified vma is an executable vma
  * Relax restrictions while unregistering: vm_flags might have
@@ -173,10 +182,31 @@ bool __weak is_swbp_insn(uprobe_opcode_t *insn)
 	return *insn == UPROBE_SWBP_INSN;
 }
 
-static void copy_opcode(struct page *page, unsigned long vaddr, uprobe_opcode_t *opcode)
+/**
+ * is_trap_insn - check if instruction is breakpoint instruction.
+ * @insn: instruction to be checked.
+ * Default implementation of is_trap_insn
+ * Returns true if @insn is a breakpoint instruction.
+ *
+ * This function is needed for the case where an architecture has multiple
+ * trap instructions (like powerpc).
+ */
+bool __weak is_trap_insn(uprobe_opcode_t *insn)
+{
+	return is_swbp_insn(insn);
+}
+
+static void copy_from_page(struct page *page, unsigned long vaddr, void *dst, int len)
 {
 	void *kaddr = kmap_atomic(page);
-	memcpy(opcode, kaddr + (vaddr & ~PAGE_MASK), UPROBE_SWBP_INSN_SIZE);
+	memcpy(dst, kaddr + (vaddr & ~PAGE_MASK), len);
+	kunmap_atomic(kaddr);
+}
+
+static void copy_to_page(struct page *page, unsigned long vaddr, const void *src, int len)
+{
+	void *kaddr = kmap_atomic(page);
+	memcpy(kaddr + (vaddr & ~PAGE_MASK), src, len);
 	kunmap_atomic(kaddr);
 }
 
@@ -185,7 +215,16 @@ static int verify_opcode(struct page *page, unsigned long vaddr, uprobe_opcode_t
 	uprobe_opcode_t old_opcode;
 	bool is_swbp;
 
-	copy_opcode(page, vaddr, &old_opcode);
+	/*
+	 * Note: We only check if the old_opcode is UPROBE_SWBP_INSN here.
+	 * We do not check if it is any other 'trap variant' which could
+	 * be conditional trap instruction such as the one powerpc supports.
+	 *
+	 * The logic is that we do not care if the underlying instruction
+	 * is a trap variant; uprobes always wins over any other (gdb)
+	 * breakpoint.
+	 */
+	copy_from_page(page, vaddr, &old_opcode, UPROBE_SWBP_INSN_SIZE);
 	is_swbp = is_swbp_insn(&old_opcode);
 
 	if (is_swbp_insn(new_opcode)) {
@@ -204,7 +243,7 @@ static int verify_opcode(struct page *page, unsigned long vaddr, uprobe_opcode_t
  * Expect the breakpoint instruction to be the smallest size instruction for
  * the architecture. If an arch has variable length instruction and the
  * breakpoint instruction is not of the smallest length instruction
- * supported by that architecture then we need to modify is_swbp_at_addr and
+ * supported by that architecture then we need to modify is_trap_at_addr and
  * write_opcode accordingly. This would never be a problem for archs that
  * have fixed length instructions.
  */
@@ -225,7 +264,6 @@ static int write_opcode(struct mm_struct *mm, unsigned long vaddr,
 			uprobe_opcode_t opcode)
 {
 	struct page *old_page, *new_page;
-	void *vaddr_old, *vaddr_new;
 	struct vm_area_struct *vma;
 	int ret;
 
@@ -246,15 +284,8 @@ retry:
 
 	__SetPageUptodate(new_page);
 
-	/* copy the page now that we've got it stable */
-	vaddr_old = kmap_atomic(old_page);
-	vaddr_new = kmap_atomic(new_page);
-
-	memcpy(vaddr_new, vaddr_old, PAGE_SIZE);
-	memcpy(vaddr_new + (vaddr & ~PAGE_MASK), &opcode, UPROBE_SWBP_INSN_SIZE);
-
-	kunmap_atomic(vaddr_new);
-	kunmap_atomic(vaddr_old);
+	copy_highpage(new_page, old_page);
+	copy_to_page(new_page, vaddr, &opcode, UPROBE_SWBP_INSN_SIZE);
 
 	ret = anon_vma_prepare(vma);
 	if (ret)
@@ -477,30 +508,18 @@ __copy_insn(struct address_space *mapping, struct file *filp, char *insn,
 			unsigned long nbytes, loff_t offset)
 {
 	struct page *page;
-	void *vaddr;
-	unsigned long off;
-	pgoff_t idx;
-
-	if (!filp)
-		return -EINVAL;
 
 	if (!mapping->a_ops->readpage)
 		return -EIO;
-
-	idx = offset >> PAGE_CACHE_SHIFT;
-	off = offset & ~PAGE_MASK;
-
 	/*
 	 * Ensure that the page that has the original instruction is
 	 * populated and in page-cache.
 	 */
-	page = read_mapping_page(mapping, idx, filp);
+	page = read_mapping_page(mapping, offset >> PAGE_CACHE_SHIFT, filp);
 	if (IS_ERR(page))
 		return PTR_ERR(page);
 
-	vaddr = kmap_atomic(page);
-	memcpy(insn, vaddr + off, nbytes);
-	kunmap_atomic(vaddr);
+	copy_from_page(page, offset, insn, nbytes);
 	page_cache_release(page);
 
 	return 0;
@@ -550,7 +569,7 @@ static int prepare_uprobe(struct uprobe *uprobe, struct file *file,
 		goto out;
 
 	ret = -ENOTSUPP;
-	if (is_swbp_insn((uprobe_opcode_t *)uprobe->arch.insn))
+	if (is_trap_insn((uprobe_opcode_t *)uprobe->arch.insn))
 		goto out;
 
 	ret = arch_uprobe_analyze_insn(&uprobe->arch, mm, vaddr);
@@ -758,7 +777,7 @@ register_for_each_vma(struct uprobe *uprobe, struct uprobe_consumer *new)
 		down_write(&mm->mmap_sem);
 		vma = find_vma(mm, info->vaddr);
 		if (!vma || !valid_vma(vma, is_register) ||
-		    vma->vm_file->f_mapping->host != uprobe->inode)
+		    file_inode(vma->vm_file) != uprobe->inode)
 			goto unlock;
 
 		if (vma->vm_start > info->vaddr ||
@@ -828,6 +847,10 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
 	struct uprobe *uprobe;
 	int ret;
 
+	/* Uprobe must have at least one set consumer */
+	if (!uc->handler && !uc->ret_handler)
+		return -EINVAL;
+
 	/* Racy, just to catch the obvious mistakes */
 	if (offset > i_size_read(inode))
 		return -EINVAL;
@@ -917,7 +940,7 @@ static int unapply_uprobe(struct uprobe *uprobe, struct mm_struct *mm)
 		loff_t offset;
 
 		if (!valid_vma(vma, false) ||
-		    vma->vm_file->f_mapping->host != uprobe->inode)
+		    file_inode(vma->vm_file) != uprobe->inode)
 			continue;
 
 		offset = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
@@ -1010,7 +1033,7 @@ int uprobe_mmap(struct vm_area_struct *vma)
 	if (no_uprobe_events() || !valid_vma(vma, true))
 		return 0;
 
-	inode = vma->vm_file->f_mapping->host;
+	inode = file_inode(vma->vm_file);
 	if (!inode)
 		return 0;
 
@@ -1041,7 +1064,7 @@ vma_has_uprobes(struct vm_area_struct *vma, unsigned long start, unsigned long e
 	struct inode *inode;
 	struct rb_node *n;
 
-	inode = vma->vm_file->f_mapping->host;
+	inode = file_inode(vma->vm_file);
 
 	min = vaddr_to_offset(vma, start);
 	max = min + (end - start) - 1;
@@ -1114,6 +1137,7 @@ static struct xol_area *get_xol_area(void)
 {
 	struct mm_struct *mm = current->mm;
 	struct xol_area *area;
+	uprobe_opcode_t insn = UPROBE_SWBP_INSN;
 
 	area = mm->uprobes_state.xol_area;
 	if (area)
@@ -1131,7 +1155,12 @@ static struct xol_area *get_xol_area(void)
 	if (!area->page)
 		goto free_bitmap;
 
+	/* allocate first slot of task's xol_area for the return probes */
+	set_bit(0, area->bitmap);
+	copy_to_page(area->page, 0, &insn, UPROBE_SWBP_INSN_SIZE);
+	atomic_set(&area->slot_count, 1);
 	init_waitqueue_head(&area->wq);
+
 	if (!xol_add_vma(area))
 		return area;
 
@@ -1216,9 +1245,7 @@ static unsigned long xol_take_insn_slot(struct xol_area *area)
 static unsigned long xol_get_insn_slot(struct uprobe *uprobe)
 {
 	struct xol_area *area;
-	unsigned long offset;
 	unsigned long xol_vaddr;
-	void *vaddr;
 
 	area = get_xol_area();
 	if (!area)
@@ -1229,10 +1256,7 @@ static unsigned long xol_get_insn_slot(struct uprobe *uprobe)
 		return 0;
 
 	/* Initialize the slot */
-	offset = xol_vaddr & ~PAGE_MASK;
-	vaddr = kmap_atomic(area->page);
-	memcpy(vaddr + offset, uprobe->arch.insn, MAX_UINSN_BYTES);
-	kunmap_atomic(vaddr);
+	copy_to_page(area->page, xol_vaddr, uprobe->arch.insn, MAX_UINSN_BYTES);
 	/*
 	 * We probably need flush_icache_user_range() but it needs vma.
 	 * This should work on supported architectures too.
@@ -1298,6 +1322,7 @@ unsigned long __weak uprobe_get_swbp_addr(struct pt_regs *regs)
 void uprobe_free_utask(struct task_struct *t)
 {
 	struct uprobe_task *utask = t->utask;
+	struct return_instance *ri, *tmp;
 
 	if (!utask)
 		return;
@@ -1305,6 +1330,15 @@ void uprobe_free_utask(struct task_struct *t)
 	if (utask->active_uprobe)
 		put_uprobe(utask->active_uprobe);
 
+	ri = utask->return_instances;
+	while (ri) {
+		tmp = ri;
+		ri = ri->next;
+
+		put_uprobe(tmp->uprobe);
+		kfree(tmp);
+	}
+
 	xol_free_insn_slot(t);
 	kfree(utask);
 	t->utask = NULL;
@@ -1333,6 +1367,93 @@ static struct uprobe_task *get_utask(void)
 	return current->utask;
 }
 
+/*
+ * Current area->vaddr notion assume the trampoline address is always
+ * equal area->vaddr.
+ *
+ * Returns -1 in case the xol_area is not allocated.
+ */
+static unsigned long get_trampoline_vaddr(void)
+{
+	struct xol_area *area;
+	unsigned long trampoline_vaddr = -1;
+
+	area = current->mm->uprobes_state.xol_area;
+	smp_read_barrier_depends();
+	if (area)
+		trampoline_vaddr = area->vaddr;
+
+	return trampoline_vaddr;
+}
+
+static void prepare_uretprobe(struct uprobe *uprobe, struct pt_regs *regs)
+{
+	struct return_instance *ri;
+	struct uprobe_task *utask;
+	unsigned long orig_ret_vaddr, trampoline_vaddr;
+	bool chained = false;
+
+	if (!get_xol_area())
+		return;
+
+	utask = get_utask();
+	if (!utask)
+		return;
+
+	if (utask->depth >= MAX_URETPROBE_DEPTH) {
+		printk_ratelimited(KERN_INFO "uprobe: omit uretprobe due to"
+				" nestedness limit pid/tgid=%d/%d\n",
+				current->pid, current->tgid);
+		return;
+	}
+
+	ri = kzalloc(sizeof(struct return_instance), GFP_KERNEL);
+	if (!ri)
+		goto fail;
+
+	trampoline_vaddr = get_trampoline_vaddr();
+	orig_ret_vaddr = arch_uretprobe_hijack_return_addr(trampoline_vaddr, regs);
+	if (orig_ret_vaddr == -1)
+		goto fail;
+
+	/*
+	 * We don't want to keep trampoline address in stack, rather keep the
+	 * original return address of first caller thru all the consequent
+	 * instances. This also makes breakpoint unwrapping easier.
+	 */
+	if (orig_ret_vaddr == trampoline_vaddr) {
+		if (!utask->return_instances) {
+			/*
+			 * This situation is not possible. Likely we have an
+			 * attack from user-space.
+			 */
+			pr_warn("uprobe: unable to set uretprobe pid/tgid=%d/%d\n",
+						current->pid, current->tgid);
+			goto fail;
+		}
+
+		chained = true;
+		orig_ret_vaddr = utask->return_instances->orig_ret_vaddr;
+	}
+
+	atomic_inc(&uprobe->ref);
+	ri->uprobe = uprobe;
+	ri->func = instruction_pointer(regs);
+	ri->orig_ret_vaddr = orig_ret_vaddr;
+	ri->chained = chained;
+
+	utask->depth++;
+
+	/* add instance to the stack */
+	ri->next = utask->return_instances;
+	utask->return_instances = ri;
+
+	return;
+
+ fail:
+	kfree(ri);
+}
+
 /* Prepare to single-step probed instruction out of line. */
 static int
 pre_ssout(struct uprobe *uprobe, struct pt_regs *regs, unsigned long bp_vaddr)
@@ -1431,7 +1552,7 @@ static void mmf_recalc_uprobes(struct mm_struct *mm)
 	clear_bit(MMF_HAS_UPROBES, &mm->flags);
 }
 
-static int is_swbp_at_addr(struct mm_struct *mm, unsigned long vaddr)
+static int is_trap_at_addr(struct mm_struct *mm, unsigned long vaddr)
 {
 	struct page *page;
 	uprobe_opcode_t opcode;
@@ -1449,10 +1570,11 @@ static int is_swbp_at_addr(struct mm_struct *mm, unsigned long vaddr)
 	if (result < 0)
 		return result;
 
-	copy_opcode(page, vaddr, &opcode);
+	copy_from_page(page, vaddr, &opcode, UPROBE_SWBP_INSN_SIZE);
 	put_page(page);
  out:
-	return is_swbp_insn(&opcode);
+	/* This needs to return true for any variant of the trap insn */
+	return is_trap_insn(&opcode);
 }
 
 static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
@@ -1465,14 +1587,14 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
 	vma = find_vma(mm, bp_vaddr);
 	if (vma && vma->vm_start <= bp_vaddr) {
 		if (valid_vma(vma, false)) {
-			struct inode *inode = vma->vm_file->f_mapping->host;
+			struct inode *inode = file_inode(vma->vm_file);
 			loff_t offset = vaddr_to_offset(vma, bp_vaddr);
 
 			uprobe = find_uprobe(inode, offset);
 		}
 
 		if (!uprobe)
-			*is_swbp = is_swbp_at_addr(mm, bp_vaddr);
+			*is_swbp = is_trap_at_addr(mm, bp_vaddr);
 	} else {
 		*is_swbp = -EFAULT;
 	}
@@ -1488,16 +1610,27 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
 {
 	struct uprobe_consumer *uc;
 	int remove = UPROBE_HANDLER_REMOVE;
+	bool need_prep = false; /* prepare return uprobe, when needed */
 
 	down_read(&uprobe->register_rwsem);
 	for (uc = uprobe->consumers; uc; uc = uc->next) {
-		int rc = uc->handler(uc, regs);
+		int rc = 0;
+
+		if (uc->handler) {
+			rc = uc->handler(uc, regs);
+			WARN(rc & ~UPROBE_HANDLER_MASK,
+				"bad rc=0x%x from %pf()\n", rc, uc->handler);
+		}
+
+		if (uc->ret_handler)
+			need_prep = true;
 
-		WARN(rc & ~UPROBE_HANDLER_MASK,
-			"bad rc=0x%x from %pf()\n", rc, uc->handler);
 		remove &= rc;
 	}
 
+	if (need_prep && !remove)
+		prepare_uretprobe(uprobe, regs); /* put bp at return */
+
 	if (remove && uprobe->consumers) {
 		WARN_ON(!uprobe_is_active(uprobe));
 		unapply_uprobe(uprobe, current->mm);
@@ -1505,6 +1638,64 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
 	up_read(&uprobe->register_rwsem);
 }
 
+static void
+handle_uretprobe_chain(struct return_instance *ri, struct pt_regs *regs)
+{
+	struct uprobe *uprobe = ri->uprobe;
+	struct uprobe_consumer *uc;
+
+	down_read(&uprobe->register_rwsem);
+	for (uc = uprobe->consumers; uc; uc = uc->next) {
+		if (uc->ret_handler)
+			uc->ret_handler(uc, ri->func, regs);
+	}
+	up_read(&uprobe->register_rwsem);
+}
+
+static bool handle_trampoline(struct pt_regs *regs)
+{
+	struct uprobe_task *utask;
+	struct return_instance *ri, *tmp;
+	bool chained;
+
+	utask = current->utask;
+	if (!utask)
+		return false;
+
+	ri = utask->return_instances;
+	if (!ri)
+		return false;
+
+	/*
+	 * TODO: we should throw out return_instance's invalidated by
+	 * longjmp(), currently we assume that the probed function always
+	 * returns.
+	 */
+	instruction_pointer_set(regs, ri->orig_ret_vaddr);
+
+	for (;;) {
+		handle_uretprobe_chain(ri, regs);
+
+		chained = ri->chained;
+		put_uprobe(ri->uprobe);
+
+		tmp = ri;
+		ri = ri->next;
+		kfree(tmp);
+
+		if (!chained)
+			break;
+
+		utask->depth--;
+
+		BUG_ON(!ri);
+	}
+
+	utask->return_instances = ri;
+
+	return true;
+}
+
 /*
  * Run handler and ask thread to singlestep.
  * Ensure all non-fatal signals cannot interrupt thread while it singlesteps.
@@ -1516,8 +1707,15 @@ static void handle_swbp(struct pt_regs *regs)
 	int uninitialized_var(is_swbp);
 
 	bp_vaddr = uprobe_get_swbp_addr(regs);
-	uprobe = find_active_uprobe(bp_vaddr, &is_swbp);
+	if (bp_vaddr == get_trampoline_vaddr()) {
+		if (handle_trampoline(regs))
+			return;
+
+		pr_warn("uprobe: unable to handle uretprobe pid/tgid=%d/%d\n",
+						current->pid, current->tgid);
+	}
 
+	uprobe = find_active_uprobe(bp_vaddr, &is_swbp);
 	if (!uprobe) {
 		if (is_swbp > 0) {
 			/* No matching uprobe; signal SIGTRAP. */
@@ -1616,7 +1814,11 @@ void uprobe_notify_resume(struct pt_regs *regs)
  */
 int uprobe_pre_sstep_notifier(struct pt_regs *regs)
 {
-	if (!current->mm || !test_bit(MMF_HAS_UPROBES, &current->mm->flags))
+	if (!current->mm)
+		return 0;
+
+	if (!test_bit(MMF_HAS_UPROBES, &current->mm->flags) &&
+	    (!current->utask || !current->utask->return_instances))
 		return 0;
 
 	set_thread_flag(TIF_UPROBE);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 2081971..8bed1df 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -103,11 +103,6 @@ struct kretprobe_trace_entry_head {
 	unsigned long		ret_ip;
 };
 
-struct uprobe_trace_entry_head {
-	struct trace_entry	ent;
-	unsigned long		ip;
-};
-
 /*
  * trace_flag_type is an enumeration that holds different
  * states when a trace occurs. These are:
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 8dad2a9..32494fb0 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -28,6 +28,18 @@
 
 #define UPROBE_EVENT_SYSTEM	"uprobes"
 
+struct uprobe_trace_entry_head {
+	struct trace_entry	ent;
+	unsigned long		vaddr[];
+};
+
+#define SIZEOF_TRACE_ENTRY(is_return)			\
+	(sizeof(struct uprobe_trace_entry_head) +	\
+	 sizeof(unsigned long) * (is_return ? 2 : 1))
+
+#define DATAOF_TRACE_ENTRY(entry, is_return)		\
+	((void*)(entry) + SIZEOF_TRACE_ENTRY(is_return))
+
 struct trace_uprobe_filter {
 	rwlock_t		rwlock;
 	int			nr_systemwide;
@@ -64,6 +76,8 @@ static DEFINE_MUTEX(uprobe_lock);
 static LIST_HEAD(uprobe_list);
 
 static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs);
+static int uretprobe_dispatcher(struct uprobe_consumer *con,
+				unsigned long func, struct pt_regs *regs);
 
 static inline void init_trace_uprobe_filter(struct trace_uprobe_filter *filter)
 {
@@ -77,11 +91,16 @@ static inline bool uprobe_filter_is_empty(struct trace_uprobe_filter *filter)
 	return !filter->nr_systemwide && list_empty(&filter->perf_events);
 }
 
+static inline bool is_ret_probe(struct trace_uprobe *tu)
+{
+	return tu->consumer.ret_handler != NULL;
+}
+
 /*
  * Allocate new trace_uprobe and initialize it (including uprobes).
  */
 static struct trace_uprobe *
-alloc_trace_uprobe(const char *group, const char *event, int nargs)
+alloc_trace_uprobe(const char *group, const char *event, int nargs, bool is_ret)
 {
 	struct trace_uprobe *tu;
 
@@ -106,6 +125,8 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs)
 
 	INIT_LIST_HEAD(&tu->list);
 	tu->consumer.handler = uprobe_dispatcher;
+	if (is_ret)
+		tu->consumer.ret_handler = uretprobe_dispatcher;
 	init_trace_uprobe_filter(&tu->filter);
 	return tu;
 
@@ -180,7 +201,7 @@ end:
 
 /*
  * Argument syntax:
- *  - Add uprobe: p[:[GRP/]EVENT] PATH:SYMBOL[+offs] [FETCHARGS]
+ *  - Add uprobe: p|r[:[GRP/]EVENT] PATH:SYMBOL [FETCHARGS]
  *
  *  - Remove uprobe: -:[GRP/]EVENT
  */
@@ -192,20 +213,23 @@ static int create_trace_uprobe(int argc, char **argv)
 	char buf[MAX_EVENT_NAME_LEN];
 	struct path path;
 	unsigned long offset;
-	bool is_delete;
+	bool is_delete, is_return;
 	int i, ret;
 
 	inode = NULL;
 	ret = 0;
 	is_delete = false;
+	is_return = false;
 	event = NULL;
 	group = NULL;
 
 	/* argc must be >= 1 */
 	if (argv[0][0] == '-')
 		is_delete = true;
+	else if (argv[0][0] == 'r')
+		is_return = true;
 	else if (argv[0][0] != 'p') {
-		pr_info("Probe definition must be started with 'p' or '-'.\n");
+		pr_info("Probe definition must be started with 'p', 'r' or '-'.\n");
 		return -EINVAL;
 	}
 
@@ -303,7 +327,7 @@ static int create_trace_uprobe(int argc, char **argv)
 		kfree(tail);
 	}
 
-	tu = alloc_trace_uprobe(group, event, argc);
+	tu = alloc_trace_uprobe(group, event, argc, is_return);
 	if (IS_ERR(tu)) {
 		pr_info("Failed to allocate trace_uprobe.(%d)\n", (int)PTR_ERR(tu));
 		ret = PTR_ERR(tu);
@@ -414,9 +438,10 @@ static void probes_seq_stop(struct seq_file *m, void *v)
 static int probes_seq_show(struct seq_file *m, void *v)
 {
 	struct trace_uprobe *tu = v;
+	char c = is_ret_probe(tu) ? 'r' : 'p';
 	int i;
 
-	seq_printf(m, "p:%s/%s", tu->call.class->system, tu->call.name);
+	seq_printf(m, "%c:%s/%s", c, tu->call.class->system, tu->call.name);
 	seq_printf(m, " %s:0x%p", tu->filename, (void *)tu->offset);
 
 	for (i = 0; i < tu->nr_args; i++)
@@ -485,65 +510,81 @@ static const struct file_operations uprobe_profile_ops = {
 	.release	= seq_release,
 };
 
-/* uprobe handler */
-static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
+static void uprobe_trace_print(struct trace_uprobe *tu,
+				unsigned long func, struct pt_regs *regs)
 {
 	struct uprobe_trace_entry_head *entry;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
-	u8 *data;
-	int size, i, pc;
-	unsigned long irq_flags;
+	void *data;
+	int size, i;
 	struct ftrace_event_call *call = &tu->call;
 
-	local_save_flags(irq_flags);
-	pc = preempt_count();
-
-	size = sizeof(*entry) + tu->size;
-
+	size = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
-						  size, irq_flags, pc);
+						  size + tu->size, 0, 0);
 	if (!event)
-		return 0;
+		return;
 
 	entry = ring_buffer_event_data(event);
-	entry->ip = instruction_pointer(task_pt_regs(current));
-	data = (u8 *)&entry[1];
+	if (is_ret_probe(tu)) {
+		entry->vaddr[0] = func;
+		entry->vaddr[1] = instruction_pointer(regs);
+		data = DATAOF_TRACE_ENTRY(entry, true);
+	} else {
+		entry->vaddr[0] = instruction_pointer(regs);
+		data = DATAOF_TRACE_ENTRY(entry, false);
+	}
+
 	for (i = 0; i < tu->nr_args; i++)
 		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
-		trace_buffer_unlock_commit(buffer, event, irq_flags, pc);
+		trace_buffer_unlock_commit(buffer, event, 0, 0);
+}
 
+/* uprobe handler */
+static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
+{
+	if (!is_ret_probe(tu))
+		uprobe_trace_print(tu, 0, regs);
 	return 0;
 }
 
+static void uretprobe_trace_func(struct trace_uprobe *tu, unsigned long func,
+				struct pt_regs *regs)
+{
+	uprobe_trace_print(tu, func, regs);
+}
+
 /* Event entry printers */
 static enum print_line_t
 print_uprobe_event(struct trace_iterator *iter, int flags, struct trace_event *event)
 {
-	struct uprobe_trace_entry_head *field;
+	struct uprobe_trace_entry_head *entry;
 	struct trace_seq *s = &iter->seq;
 	struct trace_uprobe *tu;
 	u8 *data;
 	int i;
 
-	field = (struct uprobe_trace_entry_head *)iter->ent;
+	entry = (struct uprobe_trace_entry_head *)iter->ent;
 	tu = container_of(event, struct trace_uprobe, call.event);
 
-	if (!trace_seq_printf(s, "%s: (", tu->call.name))
-		goto partial;
-
-	if (!seq_print_ip_sym(s, field->ip, flags | TRACE_ITER_SYM_OFFSET))
-		goto partial;
-
-	if (!trace_seq_puts(s, ")"))
-		goto partial;
+	if (is_ret_probe(tu)) {
+		if (!trace_seq_printf(s, "%s: (0x%lx <- 0x%lx)", tu->call.name,
+					entry->vaddr[1], entry->vaddr[0]))
+			goto partial;
+		data = DATAOF_TRACE_ENTRY(entry, true);
+	} else {
+		if (!trace_seq_printf(s, "%s: (0x%lx)", tu->call.name,
+					entry->vaddr[0]))
+			goto partial;
+		data = DATAOF_TRACE_ENTRY(entry, false);
+	}
 
-	data = (u8 *)&field[1];
 	for (i = 0; i < tu->nr_args; i++) {
 		if (!tu->args[i].type->print(s, tu->args[i].name,
-					     data + tu->args[i].offset, field))
+					     data + tu->args[i].offset, entry))
 			goto partial;
 	}
 
@@ -595,16 +636,23 @@ static void probe_event_disable(struct trace_uprobe *tu, int flag)
 
 static int uprobe_event_define_fields(struct ftrace_event_call *event_call)
 {
-	int ret, i;
+	int ret, i, size;
 	struct uprobe_trace_entry_head field;
-	struct trace_uprobe *tu = (struct trace_uprobe *)event_call->data;
+	struct trace_uprobe *tu = event_call->data;
 
-	DEFINE_FIELD(unsigned long, ip, FIELD_STRING_IP, 0);
+	if (is_ret_probe(tu)) {
+		DEFINE_FIELD(unsigned long, vaddr[0], FIELD_STRING_FUNC, 0);
+		DEFINE_FIELD(unsigned long, vaddr[1], FIELD_STRING_RETIP, 0);
+		size = SIZEOF_TRACE_ENTRY(true);
+	} else {
+		DEFINE_FIELD(unsigned long, vaddr[0], FIELD_STRING_IP, 0);
+		size = SIZEOF_TRACE_ENTRY(false);
+	}
 	/* Set argument names as fields */
 	for (i = 0; i < tu->nr_args; i++) {
 		ret = trace_define_field(event_call, tu->args[i].type->fmttype,
 					 tu->args[i].name,
-					 sizeof(field) + tu->args[i].offset,
+					 size + tu->args[i].offset,
 					 tu->args[i].type->size,
 					 tu->args[i].type->is_signed,
 					 FILTER_OTHER);
@@ -622,8 +670,13 @@ static int __set_print_fmt(struct trace_uprobe *tu, char *buf, int len)
 	int i;
 	int pos = 0;
 
-	fmt = "(%lx)";
-	arg = "REC->" FIELD_STRING_IP;
+	if (is_ret_probe(tu)) {
+		fmt = "(%lx <- %lx)";
+		arg = "REC->" FIELD_STRING_FUNC ", REC->" FIELD_STRING_RETIP;
+	} else {
+		fmt = "(%lx)";
+		arg = "REC->" FIELD_STRING_IP;
+	}
 
 	/* When len=0, we just calculate the needed length */
 
@@ -752,49 +805,68 @@ static bool uprobe_perf_filter(struct uprobe_consumer *uc,
 	return ret;
 }
 
-/* uprobe profile handler */
-static int uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
+static void uprobe_perf_print(struct trace_uprobe *tu,
+				unsigned long func, struct pt_regs *regs)
 {
 	struct ftrace_event_call *call = &tu->call;
 	struct uprobe_trace_entry_head *entry;
 	struct hlist_head *head;
-	u8 *data;
-	int size, __size, i;
-	int rctx;
+	void *data;
+	int size, rctx, i;
 
-	if (!uprobe_perf_filter(&tu->consumer, 0, current->mm))
-		return UPROBE_HANDLER_REMOVE;
-
-	__size = sizeof(*entry) + tu->size;
-	size = ALIGN(__size + sizeof(u32), sizeof(u64));
-	size -= sizeof(u32);
+	size = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
+	size = ALIGN(size + tu->size + sizeof(u32), sizeof(u64)) - sizeof(u32);
 	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE, "profile buffer not large enough"))
-		return 0;
+		return;
 
 	preempt_disable();
+	head = this_cpu_ptr(call->perf_events);
+	if (hlist_empty(head))
+		goto out;
 
 	entry = perf_trace_buf_prepare(size, call->event.type, regs, &rctx);
 	if (!entry)
 		goto out;
 
-	entry->ip = instruction_pointer(task_pt_regs(current));
-	data = (u8 *)&entry[1];
+	if (is_ret_probe(tu)) {
+		entry->vaddr[0] = func;
+		entry->vaddr[1] = instruction_pointer(regs);
+		data = DATAOF_TRACE_ENTRY(entry, true);
+	} else {
+		entry->vaddr[0] = instruction_pointer(regs);
+		data = DATAOF_TRACE_ENTRY(entry, false);
+	}
+
 	for (i = 0; i < tu->nr_args; i++)
 		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
 
-	head = this_cpu_ptr(call->perf_events);
-	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, regs, head, NULL);
-
+	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
  out:
 	preempt_enable();
+}
+
+/* uprobe profile handler */
+static int uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
+{
+	if (!uprobe_perf_filter(&tu->consumer, 0, current->mm))
+		return UPROBE_HANDLER_REMOVE;
+
+	if (!is_ret_probe(tu))
+		uprobe_perf_print(tu, 0, regs);
 	return 0;
 }
+
+static void uretprobe_perf_func(struct trace_uprobe *tu, unsigned long func,
+				struct pt_regs *regs)
+{
+	uprobe_perf_print(tu, func, regs);
+}
 #endif	/* CONFIG_PERF_EVENTS */
 
 static
 int trace_uprobe_register(struct ftrace_event_call *event, enum trace_reg type, void *data)
 {
-	struct trace_uprobe *tu = (struct trace_uprobe *)event->data;
+	struct trace_uprobe *tu = event->data;
 
 	switch (type) {
 	case TRACE_REG_REGISTER:
@@ -843,6 +915,23 @@ static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
 	return ret;
 }
 
+static int uretprobe_dispatcher(struct uprobe_consumer *con,
+				unsigned long func, struct pt_regs *regs)
+{
+	struct trace_uprobe *tu;
+
+	tu = container_of(con, struct trace_uprobe, consumer);
+
+	if (tu->flags & TP_FLAG_TRACE)
+		uretprobe_trace_func(tu, func, regs);
+
+#ifdef CONFIG_PERF_EVENTS
+	if (tu->flags & TP_FLAG_PROFILE)
+		uretprobe_perf_func(tu, func, regs);
+#endif
+	return 0;
+}
+
 static struct trace_event_functions uprobe_funcs = {
 	.trace		= print_uprobe_event
 };
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 4a94467..05039e3 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -517,6 +517,11 @@ int proc_dowatchdog(struct ctl_table *table, int write,
 		return ret;
 
 	set_sample_period();
+	/*
+	 * Watchdog threads shouldn't be enabled if they are
+	 * disabled. The 'watchdog_disabled' variable check in
+	 * watchdog_*_all_cpus() function takes care of this.
+	 */
 	if (watchdog_enabled && watchdog_thresh)
 		watchdog_enable_all_cpus();
 	else
diff --git a/tools/Makefile b/tools/Makefile
index fa36565..6aaeb6c 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -34,7 +34,13 @@ help:
 cpupower: FORCE
 	$(call descend,power/$@)
 
-cgroup firewire lguest perf usb virtio vm: FORCE
+cgroup firewire guest usb virtio vm: FORCE
+	$(call descend,$@)
+
+liblk: FORCE
+	$(call descend,lib/lk)
+
+perf: liblk FORCE
 	$(call descend,$@)
 
 selftests: FORCE
@@ -62,7 +68,13 @@ install: cgroup_install cpupower_install firewire_install lguest_install \
 cpupower_clean:
 	$(call descend,power/cpupower,clean)
 
-cgroup_clean firewire_clean lguest_clean perf_clean usb_clean virtio_clean vm_clean:
+cgroup_clean firewire_clean lguest_clean usb_clean virtio_clean vm_clean:
+	$(call descend,$(@:_clean=),clean)
+
+liblk_clean:
+	$(call descend,lib/lk,clean)
+
+perf_clean: liblk_clean
 	$(call descend,$(@:_clean=),clean)
 
 selftests_clean:
diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
new file mode 100644
index 0000000..926cbf3
--- /dev/null
+++ b/tools/lib/lk/Makefile
@@ -0,0 +1,35 @@
+include ../../scripts/Makefile.include
+
+# guard against environment variables
+LIB_H=
+LIB_OBJS=
+
+LIB_H += debugfs.h
+
+LIB_OBJS += $(OUTPUT)debugfs.o
+
+LIBFILE = liblk.a
+
+CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) -fPIC
+EXTLIBS = -lpthread -lrt -lelf -lm
+ALL_CFLAGS = $(CFLAGS) $(BASIC_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
+ALL_LDFLAGS = $(LDFLAGS)
+
+RM = rm -f
+
+$(LIBFILE): $(LIB_OBJS)
+	$(QUIET_AR)$(RM) $@ && $(AR) rcs $(OUTPUT)$@ $(LIB_OBJS)
+
+$(LIB_OBJS): $(LIB_H)
+
+$(OUTPUT)%.o: %.c
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+$(OUTPUT)%.s: %.c
+	$(QUIET_CC)$(CC) -S $(ALL_CFLAGS) $<
+$(OUTPUT)%.o: %.S
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+
+clean:
+	$(RM) $(LIB_OBJS) $(LIBFILE)
+
+.PHONY: clean
diff --git a/tools/perf/util/debugfs.c b/tools/lib/lk/debugfs.c
similarity index 68%
rename from tools/perf/util/debugfs.c
rename to tools/lib/lk/debugfs.c
index dd8b193..099e7cd 100644
--- a/tools/perf/util/debugfs.c
+++ b/tools/lib/lk/debugfs.c
@@ -1,36 +1,39 @@
-#include "util.h"
-#include "debugfs.h"
-#include "cache.h"
-
-#include <linux/kernel.h>
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdbool.h>
+#include <sys/vfs.h>
 #include <sys/mount.h>
+#include <linux/magic.h>
+#include <linux/kernel.h>
+
+#include "debugfs.h"
 
-static int debugfs_premounted;
 char debugfs_mountpoint[PATH_MAX + 1] = "/sys/kernel/debug";
-char tracing_events_path[PATH_MAX + 1] = "/sys/kernel/debug/tracing/events";
 
-static const char *debugfs_known_mountpoints[] = {
+static const char * const debugfs_known_mountpoints[] = {
 	"/sys/kernel/debug/",
 	"/debug/",
 	0,
 };
 
-static int debugfs_found;
+static bool debugfs_found;
 
 /* find the path to the mounted debugfs */
 const char *debugfs_find_mountpoint(void)
 {
-	const char **ptr;
+	const char * const *ptr;
 	char type[100];
 	FILE *fp;
 
 	if (debugfs_found)
-		return (const char *) debugfs_mountpoint;
+		return (const char *)debugfs_mountpoint;
 
 	ptr = debugfs_known_mountpoints;
 	while (*ptr) {
 		if (debugfs_valid_mountpoint(*ptr) == 0) {
-			debugfs_found = 1;
+			debugfs_found = true;
 			strcpy(debugfs_mountpoint, *ptr);
 			return debugfs_mountpoint;
 		}
@@ -52,7 +55,7 @@ const char *debugfs_find_mountpoint(void)
 	if (strcmp(type, "debugfs") != 0)
 		return NULL;
 
-	debugfs_found = 1;
+	debugfs_found = true;
 
 	return debugfs_mountpoint;
 }
@@ -71,21 +74,12 @@ int debugfs_valid_mountpoint(const char *debugfs)
 	return 0;
 }
 
-static void debugfs_set_tracing_events_path(const char *mountpoint)
-{
-	snprintf(tracing_events_path, sizeof(tracing_events_path), "%s/%s",
-		 mountpoint, "tracing/events");
-}
-
 /* mount the debugfs somewhere if it's not mounted */
-
 char *debugfs_mount(const char *mountpoint)
 {
 	/* see if it's already mounted */
-	if (debugfs_find_mountpoint()) {
-		debugfs_premounted = 1;
+	if (debugfs_find_mountpoint())
 		goto out;
-	}
 
 	/* if not mounted and no argument */
 	if (mountpoint == NULL) {
@@ -100,15 +94,8 @@ char *debugfs_mount(const char *mountpoint)
 		return NULL;
 
 	/* save the mountpoint */
-	debugfs_found = 1;
+	debugfs_found = true;
 	strncpy(debugfs_mountpoint, mountpoint, sizeof(debugfs_mountpoint));
 out:
-	debugfs_set_tracing_events_path(debugfs_mountpoint);
 	return debugfs_mountpoint;
 }
-
-void debugfs_set_path(const char *mountpoint)
-{
-	snprintf(debugfs_mountpoint, sizeof(debugfs_mountpoint), "%s", mountpoint);
-	debugfs_set_tracing_events_path(mountpoint);
-}
diff --git a/tools/lib/lk/debugfs.h b/tools/lib/lk/debugfs.h
new file mode 100644
index 0000000..935c59b
--- /dev/null
+++ b/tools/lib/lk/debugfs.h
@@ -0,0 +1,29 @@
+#ifndef __LK_DEBUGFS_H__
+#define __LK_DEBUGFS_H__
+
+#define _STR(x) #x
+#define STR(x) _STR(x)
+
+/*
+ * On most systems <limits.h> would have given us this, but  not on some systems
+ * (e.g. GNU/Hurd).
+ */
+#ifndef PATH_MAX
+#define PATH_MAX 4096
+#endif
+
+#ifndef DEBUGFS_MAGIC
+#define DEBUGFS_MAGIC          0x64626720
+#endif
+
+#ifndef PERF_DEBUGFS_ENVIRONMENT
+#define PERF_DEBUGFS_ENVIRONMENT "PERF_DEBUGFS_DIR"
+#endif
+
+const char *debugfs_find_mountpoint(void);
+int debugfs_valid_mountpoint(const char *debugfs);
+char *debugfs_mount(const char *mountpoint);
+
+extern char debugfs_mountpoint[];
+
+#endif /* __LK_DEBUGFS_H__ */
diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
index 5ad07ef..e9cd39a 100644
--- a/tools/perf/Documentation/perf-annotate.txt
+++ b/tools/perf/Documentation/perf-annotate.txt
@@ -93,6 +93,9 @@ OPTIONS
 --skip-missing::
 	Skip symbols that cannot be annotated.
 
+--group::
+	Show event group information together
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-report[1]
diff --git a/tools/perf/Documentation/perf-mem.txt b/tools/perf/Documentation/perf-mem.txt
new file mode 100644
index 0000000..888d511
--- /dev/null
+++ b/tools/perf/Documentation/perf-mem.txt
@@ -0,0 +1,48 @@
+perf-mem(1)
+===========
+
+NAME
+----
+perf-mem - Profile memory accesses
+
+SYNOPSIS
+--------
+[verse]
+'perf mem' [<options>] (record [<command>] | report)
+
+DESCRIPTION
+-----------
+"perf mem -t <TYPE> record" runs a command and gathers memory operation data
+from it, into perf.data. Perf record options are accepted and are passed through.
+
+"perf mem -t <TYPE> report" displays the result. It invokes perf report with the
+right set of options to display a memory access profile.
+
+OPTIONS
+-------
+<command>...::
+	Any command you can specify in a shell.
+
+-t::
+--type=::
+	Select the memory operation type: load or store (default: load)
+
+-D::
+--dump-raw-samples=::
+	Dump the raw decoded samples on the screen in a format that is easy to parse with
+	one sample per line.
+
+-x::
+--field-separator::
+	Specify the field separator used when dump raw samples (-D option). By default,
+	The separator is the space character.
+
+-C::
+--cpu-list::
+	Restrict dump of raw samples to those provided via this option. Note that the same
+	option can be passed in record mode. It will be interpreted the same way as perf
+	record.
+
+SEE ALSO
+--------
+linkperf:perf-record[1], linkperf:perf-report[1]
diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 938e890..d4da111 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -182,6 +182,12 @@ is enabled for all the sampling events. The sampled branch type is the same for
 The various filters must be specified as a comma separated list: --branch-filter any_ret,u,k
 Note that this feature may not be available on all processors.
 
+-W::
+--weight::
+Enable weightened sampling. An additional weight is recorded per sample and can be
+displayed with the weight and local_weight sort keys.  This currently works for TSX
+abort events and some memory events in precise mode on modern Intel CPUs.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 02284a0..7d5f4f3 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -59,7 +59,7 @@ OPTIONS
 --sort=::
 	Sort histogram entries by given key(s) - multiple keys can be specified
 	in CSV format.  Following sort keys are available:
-	pid, comm, dso, symbol, parent, cpu, srcline.
+	pid, comm, dso, symbol, parent, cpu, srcline, weight, local_weight.
 
 	Each key has following meaning:
 
@@ -206,6 +206,10 @@ OPTIONS
 --group::
 	Show event group information together.
 
+--demangle::
+	Demangle symbol names to human readable form. It's enabled by default,
+	disable with --no-demangle.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-annotate[1]
diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index faf4f4f..2fe87fb 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -52,7 +52,7 @@ OPTIONS
 
 -r::
 --repeat=<n>::
-	repeat command and print average + stddev (max: 100)
+	repeat command and print average + stddev (max: 100). 0 means forever.
 
 -B::
 --big-num::
@@ -119,13 +119,19 @@ perf stat --repeat 10 --null --sync --pre 'make -s O=defconfig-build/clean' -- m
 	Print count deltas every N milliseconds (minimum: 100ms)
 	example: perf stat -I 1000 -e cycles -a sleep 5
 
---aggr-socket::
+--per-socket::
 Aggregate counts per processor socket for system-wide mode measurements.  This
 is a useful mode to detect imbalance between sockets.  To enable this mode,
-use --aggr-socket in addition to -a. (system-wide).  The output includes the
+use --per-socket in addition to -a. (system-wide).  The output includes the
 socket number and the number of online processors on that socket. This is
 useful to gauge the amount of aggregation.
 
+--per-core::
+Aggregate counts per physical processor for system-wide mode measurements.  This
+is a useful mode to detect imbalance between physical cores.  To enable this mode,
+use --per-core in addition to -a. (system-wide).  The output includes the
+core number and the number of online logical processors on that physical processor.
+
 EXAMPLES
 --------
 
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index a414bc9..9f1a2fe 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -112,7 +112,7 @@ Default is to monitor all CPUS.
 
 -s::
 --sort::
-	Sort by key(s): pid, comm, dso, symbol, parent, srcline.
+	Sort by key(s): pid, comm, dso, symbol, parent, srcline, weight, local_weight.
 
 -n::
 --show-nr-samples::
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 39d4106..025de79 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -1,6 +1,7 @@
 tools/perf
 tools/scripts
 tools/lib/traceevent
+tools/lib/lk
 include/linux/const.h
 include/linux/perf_event.h
 include/linux/rbtree.h
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index bb74c79..b0f164b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -35,7 +35,9 @@ include config/utilities.mak
 #
 # Define WERROR=0 to disable treating any warnings as errors.
 #
-# Define NO_NEWT if you do not want TUI support.
+# Define NO_NEWT if you do not want TUI support. (deprecated)
+#
+# Define NO_SLANG if you do not want TUI support.
 #
 # Define NO_GTK2 if you do not want GTK+ GUI support.
 #
@@ -104,6 +106,10 @@ ifdef PARSER_DEBUG
 	PARSER_DEBUG_CFLAGS := -DPARSER_DEBUG
 endif
 
+ifdef NO_NEWT
+	NO_SLANG=1
+endif
+
 CFLAGS = -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) $(PARSER_DEBUG_CFLAGS)
 EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
@@ -215,6 +221,7 @@ BASIC_CFLAGS = \
 	-Iutil \
 	-I. \
 	-I$(TRACE_EVENT_DIR) \
+	-I../lib/ \
 	-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 
 BASIC_LDFLAGS =
@@ -240,19 +247,28 @@ SCRIPT_SH += perf-archive.sh
 grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
+LK_DIR = ../lib/lk/
 TRACE_EVENT_DIR = ../lib/traceevent/
 
+LK_PATH=$(LK_DIR)
+
 ifneq ($(OUTPUT),)
 	TE_PATH=$(OUTPUT)
+ifneq ($(subdir),)
+	LK_PATH=$(OUTPUT)$(LK_DIR)
+else
+	LK_PATH=$(OUTPUT)
+endif
 else
 	TE_PATH=$(TRACE_EVENT_DIR)
 endif
 
 LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
-TE_LIB := -L$(TE_PATH) -ltraceevent
-
 export LIBTRACEEVENT
 
+LIBLK = $(LK_PATH)liblk.a
+export LIBLK
+
 # python extension build directories
 PYTHON_EXTBUILD     := $(OUTPUT)python_ext_build/
 PYTHON_EXTBUILD_LIB := $(PYTHON_EXTBUILD)lib/
@@ -262,7 +278,7 @@ export PYTHON_EXTBUILD_LIB PYTHON_EXTBUILD_TMP
 python-clean := rm -rf $(PYTHON_EXTBUILD) $(OUTPUT)python/perf.so
 
 PYTHON_EXT_SRCS := $(shell grep -v ^\# util/python-ext-sources)
-PYTHON_EXT_DEPS := util/python-ext-sources util/setup.py
+PYTHON_EXT_DEPS := util/python-ext-sources util/setup.py $(LIBTRACEEVENT)
 
 $(OUTPUT)python/perf.so: $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
 	$(QUIET_GEN)CFLAGS='$(BASIC_CFLAGS)' $(PYTHON_WORD) util/setup.py \
@@ -355,7 +371,6 @@ LIB_H += util/cache.h
 LIB_H += util/callchain.h
 LIB_H += util/build-id.h
 LIB_H += util/debug.h
-LIB_H += util/debugfs.h
 LIB_H += util/sysfs.h
 LIB_H += util/pmu.h
 LIB_H += util/event.h
@@ -416,7 +431,6 @@ LIB_OBJS += $(OUTPUT)util/annotate.o
 LIB_OBJS += $(OUTPUT)util/build-id.o
 LIB_OBJS += $(OUTPUT)util/config.o
 LIB_OBJS += $(OUTPUT)util/ctype.o
-LIB_OBJS += $(OUTPUT)util/debugfs.o
 LIB_OBJS += $(OUTPUT)util/sysfs.o
 LIB_OBJS += $(OUTPUT)util/pmu.o
 LIB_OBJS += $(OUTPUT)util/environment.o
@@ -503,6 +517,10 @@ LIB_OBJS += $(OUTPUT)tests/evsel-tp-sched.o
 LIB_OBJS += $(OUTPUT)tests/pmu.o
 LIB_OBJS += $(OUTPUT)tests/hists_link.o
 LIB_OBJS += $(OUTPUT)tests/python-use.o
+LIB_OBJS += $(OUTPUT)tests/bp_signal.o
+LIB_OBJS += $(OUTPUT)tests/bp_signal_overflow.o
+LIB_OBJS += $(OUTPUT)tests/task-exit.o
+LIB_OBJS += $(OUTPUT)tests/sw-clock.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
@@ -535,8 +553,9 @@ BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
 BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
 BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
 BUILTIN_OBJS += $(OUTPUT)tests/builtin-test.o
+BUILTIN_OBJS += $(OUTPUT)builtin-mem.o
 
-PERFLIBS = $(LIB_FILE) $(LIBTRACEEVENT)
+PERFLIBS = $(LIB_FILE) $(LIBLK) $(LIBTRACEEVENT)
 
 #
 # Platform specific tweaks
@@ -667,15 +686,15 @@ ifndef NO_LIBAUDIT
 	endif
 endif
 
-ifndef NO_NEWT
-	FLAGS_NEWT=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lnewt
-	ifneq ($(call try-cc,$(SOURCE_NEWT),$(FLAGS_NEWT),libnewt),y)
-		msg := $(warning newt not found, disables TUI support. Please install newt-devel or libnewt-dev);
+ifndef NO_SLANG
+	FLAGS_SLANG=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -I/usr/include/slang -lslang
+	ifneq ($(call try-cc,$(SOURCE_SLANG),$(FLAGS_SLANG),libslang),y)
+		msg := $(warning slang not found, disables TUI support. Please install slang-devel or libslang-dev);
 	else
 		# Fedora has /usr/include/slang/slang.h, but ubuntu /usr/include/slang.h
 		BASIC_CFLAGS += -I/usr/include/slang
-		BASIC_CFLAGS += -DNEWT_SUPPORT
-		EXTLIBS += -lnewt -lslang
+		BASIC_CFLAGS += -DSLANG_SUPPORT
+		EXTLIBS += -lslang
 		LIB_OBJS += $(OUTPUT)ui/browser.o
 		LIB_OBJS += $(OUTPUT)ui/browsers/annotate.o
 		LIB_OBJS += $(OUTPUT)ui/browsers/hists.o
@@ -1051,6 +1070,18 @@ $(LIBTRACEEVENT):
 $(LIBTRACEEVENT)-clean:
 	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) clean
 
+# if subdir is set, we've been called from above so target has been built
+# already
+$(LIBLK):
+ifeq ($(subdir),)
+	$(QUIET_SUBDIR0)$(LK_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) liblk.a
+endif
+
+$(LIBLK)-clean:
+ifeq ($(subdir),)
+	$(QUIET_SUBDIR0)$(LK_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) clean
+endif
+
 help:
 	@echo 'Perf make targets:'
 	@echo '  doc		- make *all* documentation (see below)'
@@ -1171,7 +1202,7 @@ $(INSTALL_DOC_TARGETS):
 
 ### Cleaning rules
 
-clean: $(LIBTRACEEVENT)-clean
+clean: $(LIBTRACEEVENT)-clean $(LIBLK)-clean
 	$(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS)
 	$(RM) $(ALL_PROGRAMS) perf
 	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
@@ -1181,6 +1212,6 @@ clean: $(LIBTRACEEVENT)-clean
 	$(RM) $(OUTPUT)util/*-flex*
 	$(python-clean)
 
-.PHONY: all install clean strip $(LIBTRACEEVENT)
+.PHONY: all install clean strip $(LIBTRACEEVENT) $(LIBLK)
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
 .PHONY: .FORCE-PERF-VERSION-FILE TAGS tags cscope .FORCE-PERF-CFLAGS
diff --git a/tools/perf/arch/arm/util/dwarf-regs.c b/tools/perf/arch/arm/util/dwarf-regs.c
index e8d5c55..33ec5b3 100644
--- a/tools/perf/arch/arm/util/dwarf-regs.c
+++ b/tools/perf/arch/arm/util/dwarf-regs.c
@@ -8,10 +8,7 @@
  * published by the Free Software Foundation.
  */
 
-#include <stdlib.h>
-#ifndef __UCLIBC__
-#include <libio.h>
-#endif
+#include <stddef.h>
 #include <dwarf-regs.h>
 
 struct pt_regs_dwarfnum {
diff --git a/tools/perf/arch/powerpc/util/dwarf-regs.c b/tools/perf/arch/powerpc/util/dwarf-regs.c
index 7cdd61d..733151c 100644
--- a/tools/perf/arch/powerpc/util/dwarf-regs.c
+++ b/tools/perf/arch/powerpc/util/dwarf-regs.c
@@ -9,10 +9,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#include <stdlib.h>
-#ifndef __UCLIBC__
-#include <libio.h>
-#endif
+#include <stddef.h>
 #include <dwarf-regs.h>
 
 
diff --git a/tools/perf/arch/s390/util/dwarf-regs.c b/tools/perf/arch/s390/util/dwarf-regs.c
index e19653e..0469df0 100644
--- a/tools/perf/arch/s390/util/dwarf-regs.c
+++ b/tools/perf/arch/s390/util/dwarf-regs.c
@@ -6,7 +6,7 @@
  *
  */
 
-#include <libio.h>
+#include <stddef.h>
 #include <dwarf-regs.h>
 
 #define NUM_GPRS 16
diff --git a/tools/perf/arch/sh/util/dwarf-regs.c b/tools/perf/arch/sh/util/dwarf-regs.c
index a11edb0..0d0897f 100644
--- a/tools/perf/arch/sh/util/dwarf-regs.c
+++ b/tools/perf/arch/sh/util/dwarf-regs.c
@@ -19,7 +19,7 @@
  *
  */
 
-#include <libio.h>
+#include <stddef.h>
 #include <dwarf-regs.h>
 
 /*
diff --git a/tools/perf/arch/sparc/util/dwarf-regs.c b/tools/perf/arch/sparc/util/dwarf-regs.c
index 0ab8848..92eda41 100644
--- a/tools/perf/arch/sparc/util/dwarf-regs.c
+++ b/tools/perf/arch/sparc/util/dwarf-regs.c
@@ -9,7 +9,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#include <libio.h>
+#include <stddef.h>
 #include <dwarf-regs.h>
 
 #define SPARC_MAX_REGS	96
diff --git a/tools/perf/arch/x86/util/dwarf-regs.c b/tools/perf/arch/x86/util/dwarf-regs.c
index a794d30..be22dd4 100644
--- a/tools/perf/arch/x86/util/dwarf-regs.c
+++ b/tools/perf/arch/x86/util/dwarf-regs.c
@@ -20,7 +20,7 @@
  *
  */
 
-#include <libio.h>
+#include <stddef.h>
 #include <dwarf-regs.h>
 
 /*
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 2e6961e..db491e9 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -63,7 +63,7 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 		return 0;
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, NULL, 1);
+	he = __hists__add_entry(&evsel->hists, al, NULL, 1, 1);
 	if (he == NULL)
 		return -ENOMEM;
 
@@ -109,14 +109,16 @@ static int process_sample_event(struct perf_tool *tool,
 	return 0;
 }
 
-static int hist_entry__tty_annotate(struct hist_entry *he, int evidx,
+static int hist_entry__tty_annotate(struct hist_entry *he,
+				    struct perf_evsel *evsel,
 				    struct perf_annotate *ann)
 {
-	return symbol__tty_annotate(he->ms.sym, he->ms.map, evidx,
+	return symbol__tty_annotate(he->ms.sym, he->ms.map, evsel,
 				    ann->print_line, ann->full_paths, 0, 0);
 }
 
-static void hists__find_annotations(struct hists *self, int evidx,
+static void hists__find_annotations(struct hists *self,
+				    struct perf_evsel *evsel,
 				    struct perf_annotate *ann)
 {
 	struct rb_node *nd = rb_first(&self->entries), *next;
@@ -142,14 +144,14 @@ find_next:
 		if (use_browser == 2) {
 			int ret;
 
-			ret = hist_entry__gtk_annotate(he, evidx, NULL);
+			ret = hist_entry__gtk_annotate(he, evsel, NULL);
 			if (!ret || !ann->skip_missing)
 				return;
 
 			/* skip missing symbols */
 			nd = rb_next(nd);
 		} else if (use_browser == 1) {
-			key = hist_entry__tui_annotate(he, evidx, NULL);
+			key = hist_entry__tui_annotate(he, evsel, NULL);
 			switch (key) {
 			case -1:
 				if (!ann->skip_missing)
@@ -168,7 +170,7 @@ find_next:
 			if (next != NULL)
 				nd = next;
 		} else {
-			hist_entry__tty_annotate(he, evidx, ann);
+			hist_entry__tty_annotate(he, evsel, ann);
 			nd = rb_next(nd);
 			/*
 			 * Since we have a hist_entry per IP for the same
@@ -230,7 +232,12 @@ static int __cmd_annotate(struct perf_annotate *ann)
 			total_nr_samples += nr_samples;
 			hists__collapse_resort(hists);
 			hists__output_resort(hists);
-			hists__find_annotations(hists, pos->idx, ann);
+
+			if (symbol_conf.event_group &&
+			    !perf_evsel__is_group_leader(pos))
+				continue;
+
+			hists__find_annotations(hists, pos, ann);
 		}
 	}
 
@@ -312,6 +319,8 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
 	OPT_STRING(0, "objdump", &objdump_path, "path",
 		   "objdump binary to use for disassembly and annotations"),
+	OPT_BOOLEAN(0, "group", &symbol_conf.event_group,
+		    "Show event group information together"),
 	OPT_END()
 	};
 
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index d207a97..2d0462d 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -231,9 +231,10 @@ int perf_diff__formula(struct hist_entry *he, struct hist_entry *pair,
 }
 
 static int hists__add_entry(struct hists *self,
-			    struct addr_location *al, u64 period)
+			    struct addr_location *al, u64 period,
+			    u64 weight)
 {
-	if (__hists__add_entry(self, al, NULL, period) != NULL)
+	if (__hists__add_entry(self, al, NULL, period, weight) != NULL)
 		return 0;
 	return -ENOMEM;
 }
@@ -255,7 +256,7 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
 	if (al.filtered)
 		return 0;
 
-	if (hists__add_entry(&evsel->hists, &al, sample->period)) {
+	if (hists__add_entry(&evsel->hists, &al, sample->period, sample->weight)) {
 		pr_warning("problem incrementing symbol period, skipping event\n");
 		return -1;
 	}
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 37a769d..533501e 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -12,7 +12,7 @@
 #include "util/parse-options.h"
 #include "util/trace-event.h"
 #include "util/debug.h"
-#include "util/debugfs.h"
+#include <lk/debugfs.h>
 #include "util/tool.h"
 #include "util/stat.h"
 
diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
new file mode 100644
index 0000000..a8ff6d2
--- /dev/null
+++ b/tools/perf/builtin-mem.c
@@ -0,0 +1,242 @@
+#include "builtin.h"
+#include "perf.h"
+
+#include "util/parse-options.h"
+#include "util/trace-event.h"
+#include "util/tool.h"
+#include "util/session.h"
+
+#define MEM_OPERATION_LOAD	"load"
+#define MEM_OPERATION_STORE	"store"
+
+static const char	*mem_operation		= MEM_OPERATION_LOAD;
+
+struct perf_mem {
+	struct perf_tool	tool;
+	char const		*input_name;
+	symbol_filter_t		annotate_init;
+	bool			hide_unresolved;
+	bool			dump_raw;
+	const char		*cpu_list;
+	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
+};
+
+static const char * const mem_usage[] = {
+	"perf mem [<options>] {record <command> |report}",
+	NULL
+};
+
+static int __cmd_record(int argc, const char **argv)
+{
+	int rec_argc, i = 0, j;
+	const char **rec_argv;
+	char event[64];
+	int ret;
+
+	rec_argc = argc + 4;
+	rec_argv = calloc(rec_argc + 1, sizeof(char *));
+	if (!rec_argv)
+		return -1;
+
+	rec_argv[i++] = strdup("record");
+	if (!strcmp(mem_operation, MEM_OPERATION_LOAD))
+		rec_argv[i++] = strdup("-W");
+	rec_argv[i++] = strdup("-d");
+	rec_argv[i++] = strdup("-e");
+
+	if (strcmp(mem_operation, MEM_OPERATION_LOAD))
+		sprintf(event, "cpu/mem-stores/pp");
+	else
+		sprintf(event, "cpu/mem-loads/pp");
+
+	rec_argv[i++] = strdup(event);
+	for (j = 1; j < argc; j++, i++)
+		rec_argv[i] = argv[j];
+
+	ret = cmd_record(i, rec_argv, NULL);
+	free(rec_argv);
+	return ret;
+}
+
+static int
+dump_raw_samples(struct perf_tool *tool,
+		 union perf_event *event,
+		 struct perf_sample *sample,
+		 struct perf_evsel *evsel __maybe_unused,
+		 struct machine *machine)
+{
+	struct perf_mem *mem = container_of(tool, struct perf_mem, tool);
+	struct addr_location al;
+	const char *fmt;
+
+	if (perf_event__preprocess_sample(event, machine, &al, sample,
+				mem->annotate_init) < 0) {
+		fprintf(stderr, "problem processing %d event, skipping it.\n",
+				event->header.type);
+		return -1;
+	}
+
+	if (al.filtered || (mem->hide_unresolved && al.sym == NULL))
+		return 0;
+
+	if (al.map != NULL)
+		al.map->dso->hit = 1;
+
+	if (symbol_conf.field_sep) {
+		fmt = "%d%s%d%s0x%"PRIx64"%s0x%"PRIx64"%s%"PRIu64
+		      "%s0x%"PRIx64"%s%s:%s\n";
+	} else {
+		fmt = "%5d%s%5d%s0x%016"PRIx64"%s0x016%"PRIx64
+		      "%s%5"PRIu64"%s0x%06"PRIx64"%s%s:%s\n";
+		symbol_conf.field_sep = " ";
+	}
+
+	printf(fmt,
+		sample->pid,
+		symbol_conf.field_sep,
+		sample->tid,
+		symbol_conf.field_sep,
+		event->ip.ip,
+		symbol_conf.field_sep,
+		sample->addr,
+		symbol_conf.field_sep,
+		sample->weight,
+		symbol_conf.field_sep,
+		sample->data_src,
+		symbol_conf.field_sep,
+		al.map ? (al.map->dso ? al.map->dso->long_name : "???") : "???",
+		al.sym ? al.sym->name : "???");
+
+	return 0;
+}
+
+static int process_sample_event(struct perf_tool *tool,
+				union perf_event *event,
+				struct perf_sample *sample,
+				struct perf_evsel *evsel,
+				struct machine *machine)
+{
+	return dump_raw_samples(tool, event, sample, evsel, machine);
+}
+
+static int report_raw_events(struct perf_mem *mem)
+{
+	int err = -EINVAL;
+	int ret;
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
+							 0, false, &mem->tool);
+
+	if (session == NULL)
+		return -ENOMEM;
+
+	if (mem->cpu_list) {
+		ret = perf_session__cpu_bitmap(session, mem->cpu_list,
+					       mem->cpu_bitmap);
+		if (ret)
+			goto out_delete;
+	}
+
+	if (symbol__init() < 0)
+		return -1;
+
+	printf("# PID, TID, IP, ADDR, LOCAL WEIGHT, DSRC, SYMBOL\n");
+
+	err = perf_session__process_events(session, &mem->tool);
+	if (err)
+		return err;
+
+	return 0;
+
+out_delete:
+	perf_session__delete(session);
+	return err;
+}
+
+static int report_events(int argc, const char **argv, struct perf_mem *mem)
+{
+	const char **rep_argv;
+	int ret, i = 0, j, rep_argc;
+
+	if (mem->dump_raw)
+		return report_raw_events(mem);
+
+	rep_argc = argc + 3;
+	rep_argv = calloc(rep_argc + 1, sizeof(char *));
+	if (!rep_argv)
+		return -1;
+
+	rep_argv[i++] = strdup("report");
+	rep_argv[i++] = strdup("--mem-mode");
+	rep_argv[i++] = strdup("-n"); /* display number of samples */
+
+	/*
+	 * there is no weight (cost) associated with stores, so don't print
+	 * the column
+	 */
+	if (strcmp(mem_operation, MEM_OPERATION_LOAD))
+		rep_argv[i++] = strdup("--sort=mem,sym,dso,symbol_daddr,"
+				       "dso_daddr,tlb,locked");
+
+	for (j = 1; j < argc; j++, i++)
+		rep_argv[i] = argv[j];
+
+	ret = cmd_report(i, rep_argv, NULL);
+	free(rep_argv);
+	return ret;
+}
+
+int cmd_mem(int argc, const char **argv, const char *prefix __maybe_unused)
+{
+	struct stat st;
+	struct perf_mem mem = {
+		.tool = {
+			.sample		= process_sample_event,
+			.mmap		= perf_event__process_mmap,
+			.comm		= perf_event__process_comm,
+			.lost		= perf_event__process_lost,
+			.fork		= perf_event__process_fork,
+			.build_id	= perf_event__process_build_id,
+			.ordered_samples = true,
+		},
+		.input_name		 = "perf.data",
+	};
+	const struct option mem_options[] = {
+	OPT_STRING('t', "type", &mem_operation,
+		   "type", "memory operations(load/store)"),
+	OPT_BOOLEAN('D', "dump-raw-samples", &mem.dump_raw,
+		    "dump raw samples in ASCII"),
+	OPT_BOOLEAN('U', "hide-unresolved", &mem.hide_unresolved,
+		    "Only display entries resolved to a symbol"),
+	OPT_STRING('i', "input", &input_name, "file",
+		   "input file name"),
+	OPT_STRING('C', "cpu", &mem.cpu_list, "cpu",
+		   "list of cpus to profile"),
+	OPT_STRING('x', "field-separator", &symbol_conf.field_sep,
+		   "separator",
+		   "separator for columns, no spaces will be added"
+		   " between columns '.' is reserved."),
+	OPT_END()
+	};
+
+	argc = parse_options(argc, argv, mem_options, mem_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
+
+	if (!argc || !(strncmp(argv[0], "rec", 3) || mem_operation))
+		usage_with_options(mem_usage, mem_options);
+
+	if (!mem.input_name || !strlen(mem.input_name)) {
+		if (!fstat(STDIN_FILENO, &st) && S_ISFIFO(st.st_mode))
+			mem.input_name = "-";
+		else
+			mem.input_name = "perf.data";
+	}
+
+	if (!strncmp(argv[0], "rec", 3))
+		return __cmd_record(argc, argv);
+	else if (!strncmp(argv[0], "rep", 3))
+		return report_events(argc, argv, &mem);
+	else
+		usage_with_options(mem_usage, mem_options);
+
+	return 0;
+}
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index de38a03..e8a66f9 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -37,7 +37,7 @@
 #include "util/strfilter.h"
 #include "util/symbol.h"
 #include "util/debug.h"
-#include "util/debugfs.h"
+#include <lk/debugfs.h>
 #include "util/parse-options.h"
 #include "util/probe-finder.h"
 #include "util/probe-event.h"
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f1a939e..cdf58ec 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -5,8 +5,6 @@
  * (or a CPU, or a PID) into the perf.data output file - for
  * later analysis via perf report.
  */
-#define _FILE_OFFSET_BITS 64
-
 #include "builtin.h"
 
 #include "perf.h"
@@ -474,7 +472,9 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	}
 
 	if (forks) {
-		err = perf_evlist__prepare_workload(evsel_list, opts, argv);
+		err = perf_evlist__prepare_workload(evsel_list, &opts->target,
+						    argv, opts->pipe_output,
+						    true);
 		if (err < 0) {
 			pr_err("Couldn't run the workload!\n");
 			goto out_delete_session;
@@ -953,6 +953,8 @@ const struct option record_options[] = {
 	OPT_CALLBACK('j', "branch-filter", &record.opts.branch_stack,
 		     "branch filter mask", "branch stack filter modes",
 		     parse_branch_stack),
+	OPT_BOOLEAN('W', "weight", &record.opts.sample_weight,
+		    "sample by weight (on special events only)"),
 	OPT_END()
 };
 
@@ -964,7 +966,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 	struct perf_record *rec = &record;
 	char errbuf[BUFSIZ];
 
-	evsel_list = perf_evlist__new(NULL, NULL);
+	evsel_list = perf_evlist__new();
 	if (evsel_list == NULL)
 		return -ENOMEM;
 
@@ -1026,7 +1028,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 		ui__error("%s", errbuf);
 
 		err = -saved_errno;
-		goto out_free_fd;
+		goto out_symbol_exit;
 	}
 
 	err = -ENOMEM;
@@ -1057,6 +1059,9 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 	}
 
 	err = __cmd_record(&record, argc, argv);
+
+	perf_evlist__munmap(evsel_list);
+	perf_evlist__close(evsel_list);
 out_free_fd:
 	perf_evlist__delete_maps(evsel_list);
 out_symbol_exit:
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 96b5a7f..bd0ca81 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -13,7 +13,6 @@
 #include "util/annotate.h"
 #include "util/color.h"
 #include <linux/list.h>
-#include "util/cache.h"
 #include <linux/rbtree.h>
 #include "util/symbol.h"
 #include "util/callchain.h"
@@ -47,6 +46,7 @@ struct perf_report {
 	bool			show_full_info;
 	bool			show_threads;
 	bool			inverted_callchain;
+	bool			mem_mode;
 	struct perf_read_values	show_threads_values;
 	const char		*pretty_printing_style;
 	symbol_filter_t		annotate_init;
@@ -65,6 +65,99 @@ static int perf_report_config(const char *var, const char *value, void *cb)
 	return perf_default_config(var, value, cb);
 }
 
+static int perf_report__add_mem_hist_entry(struct perf_tool *tool,
+					   struct addr_location *al,
+					   struct perf_sample *sample,
+					   struct perf_evsel *evsel,
+					   struct machine *machine,
+					   union perf_event *event)
+{
+	struct perf_report *rep = container_of(tool, struct perf_report, tool);
+	struct symbol *parent = NULL;
+	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+	int err = 0;
+	struct hist_entry *he;
+	struct mem_info *mi, *mx;
+	uint64_t cost;
+
+	if ((sort__has_parent || symbol_conf.use_callchain) &&
+	    sample->callchain) {
+		err = machine__resolve_callchain(machine, evsel, al->thread,
+						 sample, &parent);
+		if (err)
+			return err;
+	}
+
+	mi = machine__resolve_mem(machine, al->thread, sample, cpumode);
+	if (!mi)
+		return -ENOMEM;
+
+	if (rep->hide_unresolved && !al->sym)
+		return 0;
+
+	cost = sample->weight;
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
+	he = __hists__add_mem_entry(&evsel->hists, al, parent, mi, cost, cost);
+	if (!he)
+		return -ENOMEM;
+
+	/*
+	 * In the TUI browser, we are doing integrated annotation,
+	 * so we don't allocate the extra space needed because the stdio
+	 * code will not use it.
+	 */
+	if (sort__has_sym && he->ms.sym && use_browser > 0) {
+		struct annotation *notes = symbol__annotation(he->ms.sym);
+
+		assert(evsel != NULL);
+
+		if (notes->src == NULL && symbol__alloc_hist(he->ms.sym) < 0)
+			goto out;
+
+		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+		if (err)
+			goto out;
+	}
+
+	if (sort__has_sym && he->mem_info->daddr.sym && use_browser > 0) {
+		struct annotation *notes;
+
+		mx = he->mem_info;
+
+		notes = symbol__annotation(mx->daddr.sym);
+		if (notes->src == NULL && symbol__alloc_hist(mx->daddr.sym) < 0)
+			goto out;
+
+		err = symbol__inc_addr_samples(mx->daddr.sym,
+					       mx->daddr.map,
+					       evsel->idx,
+					       mx->daddr.al_addr);
+		if (err)
+			goto out;
+	}
+
+	evsel->hists.stats.total_period += cost;
+	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+	err = 0;
+
+	if (symbol_conf.use_callchain) {
+		err = callchain_append(he->callchain,
+				       &callchain_cursor,
+				       sample->period);
+	}
+out:
+	return err;
+}
+
 static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 					struct addr_location *al,
 					struct perf_sample *sample,
@@ -99,7 +192,7 @@ static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 		 * and not events sampled. Thus we use a pseudo period of 1.
 		 */
 		he = __hists__add_branch_entry(&evsel->hists, al, parent,
-				&bi[i], 1);
+				&bi[i], 1, 1);
 		if (he) {
 			struct annotation *notes;
 			err = -ENOMEM;
@@ -157,7 +250,8 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 			return err;
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, parent, sample->period);
+	he = __hists__add_entry(&evsel->hists, al, parent, sample->period,
+					sample->weight);
 	if (he == NULL)
 		return -ENOMEM;
 
@@ -169,7 +263,7 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 			return err;
 	}
 	/*
-	 * Only in the newt browser we are doing integrated annotation,
+	 * Only in the TUI browser we are doing integrated annotation,
 	 * so we don't allocated the extra space needed because the stdio
 	 * code will not use it.
 	 */
@@ -220,6 +314,12 @@ static int process_sample_event(struct perf_tool *tool,
 			pr_debug("problem adding lbr entry, skipping event\n");
 			return -1;
 		}
+	} else if (rep->mem_mode == 1) {
+		if (perf_report__add_mem_hist_entry(tool, &al, sample,
+						    evsel, machine, event)) {
+			pr_debug("problem adding mem entry, skipping event\n");
+			return -1;
+		}
 	} else {
 		if (al.map != NULL)
 			al.map->dso->hit = 1;
@@ -303,7 +403,8 @@ static void sig_handler(int sig __maybe_unused)
 	session_done = 1;
 }
 
-static size_t hists__fprintf_nr_sample_events(struct hists *self,
+static size_t hists__fprintf_nr_sample_events(struct perf_report *rep,
+					      struct hists *self,
 					      const char *evname, FILE *fp)
 {
 	size_t ret;
@@ -314,7 +415,7 @@ static size_t hists__fprintf_nr_sample_events(struct hists *self,
 	char buf[512];
 	size_t size = sizeof(buf);
 
-	if (symbol_conf.event_group && evsel->nr_members > 1) {
+	if (perf_evsel__is_group_event(evsel)) {
 		struct perf_evsel *pos;
 
 		perf_evsel__group_desc(evsel, buf, size);
@@ -331,7 +432,11 @@ static size_t hists__fprintf_nr_sample_events(struct hists *self,
 	if (evname != NULL)
 		ret += fprintf(fp, " of event '%s'", evname);
 
-	ret += fprintf(fp, "\n# Event count (approx.): %" PRIu64, nr_events);
+	if (rep->mem_mode) {
+		ret += fprintf(fp, "\n# Total weight : %" PRIu64, nr_events);
+		ret += fprintf(fp, "\n# Sort order   : %s", sort_order);
+	} else
+		ret += fprintf(fp, "\n# Event count (approx.): %" PRIu64, nr_events);
 	return ret + fprintf(fp, "\n#\n");
 }
 
@@ -349,7 +454,7 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
 		    !perf_evsel__is_group_leader(pos))
 			continue;
 
-		hists__fprintf_nr_sample_events(hists, evname, stdout);
+		hists__fprintf_nr_sample_events(rep, hists, evname, stdout);
 		hists__fprintf(hists, true, 0, 0, stdout);
 		fprintf(stdout, "\n\n");
 	}
@@ -645,7 +750,9 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Use the stdio interface"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline,"
-		   " dso_to, dso_from, symbol_to, symbol_from, mispredict"),
+		   " dso_to, dso_from, symbol_to, symbol_from, mispredict,"
+		   " weight, local_weight, mem, symbol_daddr, dso_daddr, tlb, "
+		   "snoop, locked"),
 	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
 		    "Show sample percentage for different cpu modes"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
@@ -693,6 +800,9 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "use branch records for histogram filling", parse_branch_mode),
 	OPT_STRING(0, "objdump", &objdump_path, "path",
 		   "objdump binary to use for disassembly and annotations"),
+	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
+		    "Disable symbol demangling"),
+	OPT_BOOLEAN(0, "mem-mode", &report.mem_mode, "mem access profile"),
 	OPT_END()
 	};
 
@@ -750,12 +860,24 @@ repeat:
 				     "dso_to,symbol_to";
 
 	}
+	if (report.mem_mode) {
+		if (sort__branch_mode == 1) {
+			fprintf(stderr, "branch and mem mode incompatible\n");
+			goto error;
+		}
+		/*
+		 * if no sort_order is provided, then specify
+		 * branch-mode specific order
+		 */
+		if (sort_order == default_sort_order)
+			sort_order = "local_weight,mem,sym,dso,symbol_daddr,dso_daddr,snoop,tlb,locked";
+	}
 
 	if (setup_sorting() < 0)
 		usage_with_options(report_usage, options);
 
 	/*
-	 * Only in the newt browser we are doing integrated annotation,
+	 * Only in the TUI browser we are doing integrated annotation,
 	 * so don't allocate extra space that won't be used in the stdio
 	 * implementation.
 	 */
@@ -815,6 +937,14 @@ repeat:
 		sort_entry__setup_elide(&sort_sym_from, symbol_conf.sym_from_list, "sym_from", stdout);
 		sort_entry__setup_elide(&sort_sym_to, symbol_conf.sym_to_list, "sym_to", stdout);
 	} else {
+		if (report.mem_mode) {
+			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "symbol_daddr", stdout);
+			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso_daddr", stdout);
+			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "mem", stdout);
+			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "local_weight", stdout);
+			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "tlb", stdout);
+			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "snoop", stdout);
+		}
 		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso", stdout);
 		sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "symbol", stdout);
 	}
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 1382294..2da2a6c 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1671,7 +1671,6 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 			.sample		 = perf_sched__process_tracepoint_sample,
 			.comm		 = perf_event__process_comm,
 			.lost		 = perf_event__process_lost,
-			.exit		 = perf_event__process_exit,
 			.fork		 = perf_event__process_fork,
 			.ordered_samples = true,
 		},
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 9984876..7e910ba 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -68,7 +68,7 @@
 static void print_stat(int argc, const char **argv);
 static void print_counter_aggr(struct perf_evsel *counter, char *prefix);
 static void print_counter(struct perf_evsel *counter, char *prefix);
-static void print_aggr_socket(char *prefix);
+static void print_aggr(char *prefix);
 
 static struct perf_evlist	*evsel_list;
 
@@ -76,11 +76,17 @@ static struct perf_target	target = {
 	.uid	= UINT_MAX,
 };
 
+enum aggr_mode {
+	AGGR_NONE,
+	AGGR_GLOBAL,
+	AGGR_SOCKET,
+	AGGR_CORE,
+};
+
 static int			run_count			=  1;
 static bool			no_inherit			= false;
 static bool			scale				=  true;
-static bool			no_aggr				= false;
-static bool			aggr_socket			= false;
+static enum aggr_mode		aggr_mode			= AGGR_GLOBAL;
 static pid_t			child_pid			= -1;
 static bool			null_run			=  false;
 static int			detailed_run			=  0;
@@ -94,8 +100,10 @@ static const char		*pre_cmd			= NULL;
 static const char		*post_cmd			= NULL;
 static bool			sync_run			= false;
 static unsigned int		interval			= 0;
+static bool			forever				= false;
 static struct timespec		ref_time;
-static struct cpu_map		*sock_map;
+static struct cpu_map		*aggr_map;
+static int			(*aggr_get_id)(struct cpu_map *m, int cpu);
 
 static volatile int done = 0;
 
@@ -125,6 +133,11 @@ static inline int perf_evsel__nr_cpus(struct perf_evsel *evsel)
 	return perf_evsel__cpus(evsel)->nr;
 }
 
+static void perf_evsel__reset_stat_priv(struct perf_evsel *evsel)
+{
+	memset(evsel->priv, 0, sizeof(struct perf_stat));
+}
+
 static int perf_evsel__alloc_stat_priv(struct perf_evsel *evsel)
 {
 	evsel->priv = zalloc(sizeof(struct perf_stat));
@@ -160,6 +173,35 @@ static void perf_evsel__free_prev_raw_counts(struct perf_evsel *evsel)
 	evsel->prev_raw_counts = NULL;
 }
 
+static void perf_evlist__free_stats(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		perf_evsel__free_stat_priv(evsel);
+		perf_evsel__free_counts(evsel);
+		perf_evsel__free_prev_raw_counts(evsel);
+	}
+}
+
+static int perf_evlist__alloc_stats(struct perf_evlist *evlist, bool alloc_raw)
+{
+	struct perf_evsel *evsel;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		if (perf_evsel__alloc_stat_priv(evsel) < 0 ||
+		    perf_evsel__alloc_counts(evsel, perf_evsel__nr_cpus(evsel)) < 0 ||
+		    (alloc_raw && perf_evsel__alloc_prev_raw_counts(evsel) < 0))
+			goto out_free;
+	}
+
+	return 0;
+
+out_free:
+	perf_evlist__free_stats(evlist);
+	return -1;
+}
+
 static struct stats runtime_nsecs_stats[MAX_NR_CPUS];
 static struct stats runtime_cycles_stats[MAX_NR_CPUS];
 static struct stats runtime_stalled_cycles_front_stats[MAX_NR_CPUS];
@@ -173,6 +215,29 @@ static struct stats runtime_itlb_cache_stats[MAX_NR_CPUS];
 static struct stats runtime_dtlb_cache_stats[MAX_NR_CPUS];
 static struct stats walltime_nsecs_stats;
 
+static void perf_stat__reset_stats(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		perf_evsel__reset_stat_priv(evsel);
+		perf_evsel__reset_counts(evsel, perf_evsel__nr_cpus(evsel));
+	}
+
+	memset(runtime_nsecs_stats, 0, sizeof(runtime_nsecs_stats));
+	memset(runtime_cycles_stats, 0, sizeof(runtime_cycles_stats));
+	memset(runtime_stalled_cycles_front_stats, 0, sizeof(runtime_stalled_cycles_front_stats));
+	memset(runtime_stalled_cycles_back_stats, 0, sizeof(runtime_stalled_cycles_back_stats));
+	memset(runtime_branches_stats, 0, sizeof(runtime_branches_stats));
+	memset(runtime_cacherefs_stats, 0, sizeof(runtime_cacherefs_stats));
+	memset(runtime_l1_dcache_stats, 0, sizeof(runtime_l1_dcache_stats));
+	memset(runtime_l1_icache_stats, 0, sizeof(runtime_l1_icache_stats));
+	memset(runtime_ll_cache_stats, 0, sizeof(runtime_ll_cache_stats));
+	memset(runtime_itlb_cache_stats, 0, sizeof(runtime_itlb_cache_stats));
+	memset(runtime_dtlb_cache_stats, 0, sizeof(runtime_dtlb_cache_stats));
+	memset(&walltime_nsecs_stats, 0, sizeof(walltime_nsecs_stats));
+}
+
 static int create_perf_stat_counter(struct perf_evsel *evsel)
 {
 	struct perf_event_attr *attr = &evsel->attr;
@@ -249,7 +314,7 @@ static int read_counter_aggr(struct perf_evsel *counter)
 	int i;
 
 	if (__perf_evsel__read(counter, perf_evsel__nr_cpus(counter),
-			       evsel_list->threads->nr, scale) < 0)
+			       thread_map__nr(evsel_list->threads), scale) < 0)
 		return -1;
 
 	for (i = 0; i < 3; i++)
@@ -297,56 +362,68 @@ static void print_interval(void)
 	struct timespec ts, rs;
 	char prefix[64];
 
-	if (no_aggr) {
+	if (aggr_mode == AGGR_GLOBAL) {
 		list_for_each_entry(counter, &evsel_list->entries, node) {
 			ps = counter->priv;
 			memset(ps->res_stats, 0, sizeof(ps->res_stats));
-			read_counter(counter);
+			read_counter_aggr(counter);
 		}
-	} else {
+	} else	{
 		list_for_each_entry(counter, &evsel_list->entries, node) {
 			ps = counter->priv;
 			memset(ps->res_stats, 0, sizeof(ps->res_stats));
-			read_counter_aggr(counter);
+			read_counter(counter);
 		}
 	}
+
 	clock_gettime(CLOCK_MONOTONIC, &ts);
 	diff_timespec(&rs, &ts, &ref_time);
 	sprintf(prefix, "%6lu.%09lu%s", rs.tv_sec, rs.tv_nsec, csv_sep);
 
 	if (num_print_interval == 0 && !csv_output) {
-		if (aggr_socket)
+		switch (aggr_mode) {
+		case AGGR_SOCKET:
 			fprintf(output, "#           time socket cpus             counts events\n");
-		else if (no_aggr)
+			break;
+		case AGGR_CORE:
+			fprintf(output, "#           time core         cpus             counts events\n");
+			break;
+		case AGGR_NONE:
 			fprintf(output, "#           time CPU                 counts events\n");
-		else
+			break;
+		case AGGR_GLOBAL:
+		default:
 			fprintf(output, "#           time             counts events\n");
+		}
 	}
 
 	if (++num_print_interval == 25)
 		num_print_interval = 0;
 
-	if (aggr_socket)
-		print_aggr_socket(prefix);
-	else if (no_aggr) {
+	switch (aggr_mode) {
+	case AGGR_CORE:
+	case AGGR_SOCKET:
+		print_aggr(prefix);
+		break;
+	case AGGR_NONE:
 		list_for_each_entry(counter, &evsel_list->entries, node)
 			print_counter(counter, prefix);
-	} else {
+		break;
+	case AGGR_GLOBAL:
+	default:
 		list_for_each_entry(counter, &evsel_list->entries, node)
 			print_counter_aggr(counter, prefix);
 	}
 }
 
-static int __run_perf_stat(int argc __maybe_unused, const char **argv)
+static int __run_perf_stat(int argc, const char **argv)
 {
 	char msg[512];
 	unsigned long long t0, t1;
 	struct perf_evsel *counter;
 	struct timespec ts;
 	int status = 0;
-	int child_ready_pipe[2], go_pipe[2];
 	const bool forks = (argc > 0);
-	char buf;
 
 	if (interval) {
 		ts.tv_sec  = interval / 1000;
@@ -356,61 +433,12 @@ static int __run_perf_stat(int argc __maybe_unused, const char **argv)
 		ts.tv_nsec = 0;
 	}
 
-	if (aggr_socket
-	    && cpu_map__build_socket_map(evsel_list->cpus, &sock_map)) {
-		perror("cannot build socket map");
-		return -1;
-	}
-
-	if (forks && (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0)) {
-		perror("failed to create pipes");
-		return -1;
-	}
-
 	if (forks) {
-		if ((child_pid = fork()) < 0)
-			perror("failed to fork");
-
-		if (!child_pid) {
-			close(child_ready_pipe[0]);
-			close(go_pipe[1]);
-			fcntl(go_pipe[0], F_SETFD, FD_CLOEXEC);
-
-			/*
-			 * Do a dummy execvp to get the PLT entry resolved,
-			 * so we avoid the resolver overhead on the real
-			 * execvp call.
-			 */
-			execvp("", (char **)argv);
-
-			/*
-			 * Tell the parent we're ready to go
-			 */
-			close(child_ready_pipe[1]);
-
-			/*
-			 * Wait until the parent tells us to go.
-			 */
-			if (read(go_pipe[0], &buf, 1) == -1)
-				perror("unable to read pipe");
-
-			execvp(argv[0], (char **)argv);
-
-			perror(argv[0]);
-			exit(-1);
+		if (perf_evlist__prepare_workload(evsel_list, &target, argv,
+						  false, false) < 0) {
+			perror("failed to prepare workload");
+			return -1;
 		}
-
-		if (perf_target__none(&target))
-			evsel_list->threads->map[0] = child_pid;
-
-		/*
-		 * Wait for the child to be ready to exec.
-		 */
-		close(child_ready_pipe[1]);
-		close(go_pipe[0]);
-		if (read(child_ready_pipe[0], &buf, 1) == -1)
-			perror("unable to read pipe");
-		close(child_ready_pipe[0]);
 	}
 
 	if (group)
@@ -457,7 +485,8 @@ static int __run_perf_stat(int argc __maybe_unused, const char **argv)
 	clock_gettime(CLOCK_MONOTONIC, &ref_time);
 
 	if (forks) {
-		close(go_pipe[1]);
+		perf_evlist__start_workload(evsel_list);
+
 		if (interval) {
 			while (!waitpid(child_pid, &status, WNOHANG)) {
 				nanosleep(&ts, NULL);
@@ -479,16 +508,16 @@ static int __run_perf_stat(int argc __maybe_unused, const char **argv)
 
 	update_stats(&walltime_nsecs_stats, t1 - t0);
 
-	if (no_aggr) {
+	if (aggr_mode == AGGR_GLOBAL) {
 		list_for_each_entry(counter, &evsel_list->entries, node) {
-			read_counter(counter);
-			perf_evsel__close_fd(counter, perf_evsel__nr_cpus(counter), 1);
+			read_counter_aggr(counter);
+			perf_evsel__close_fd(counter, perf_evsel__nr_cpus(counter),
+					     thread_map__nr(evsel_list->threads));
 		}
 	} else {
 		list_for_each_entry(counter, &evsel_list->entries, node) {
-			read_counter_aggr(counter);
-			perf_evsel__close_fd(counter, perf_evsel__nr_cpus(counter),
-					     evsel_list->threads->nr);
+			read_counter(counter);
+			perf_evsel__close_fd(counter, perf_evsel__nr_cpus(counter), 1);
 		}
 	}
 
@@ -542,26 +571,47 @@ static void print_noise(struct perf_evsel *evsel, double avg)
 	print_noise_pct(stddev_stats(&ps->res_stats[0]), avg);
 }
 
-static void nsec_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
+static void aggr_printout(struct perf_evsel *evsel, int id, int nr)
 {
-	double msecs = avg / 1e6;
-	char cpustr[16] = { '\0', };
-	const char *fmt = csv_output ? "%s%.6f%s%s" : "%s%18.6f%s%-25s";
-
-	if (aggr_socket)
-		sprintf(cpustr, "S%*d%s%*d%s",
+	switch (aggr_mode) {
+	case AGGR_CORE:
+		fprintf(output, "S%d-C%*d%s%*d%s",
+			cpu_map__id_to_socket(id),
+			csv_output ? 0 : -8,
+			cpu_map__id_to_cpu(id),
+			csv_sep,
+			csv_output ? 0 : 4,
+			nr,
+			csv_sep);
+		break;
+	case AGGR_SOCKET:
+		fprintf(output, "S%*d%s%*d%s",
 			csv_output ? 0 : -5,
-			cpu,
+			id,
 			csv_sep,
 			csv_output ? 0 : 4,
 			nr,
 			csv_sep);
-	else if (no_aggr)
-		sprintf(cpustr, "CPU%*d%s",
+			break;
+	case AGGR_NONE:
+		fprintf(output, "CPU%*d%s",
 			csv_output ? 0 : -4,
-			perf_evsel__cpus(evsel)->map[cpu], csv_sep);
+			perf_evsel__cpus(evsel)->map[id], csv_sep);
+		break;
+	case AGGR_GLOBAL:
+	default:
+		break;
+	}
+}
+
+static void nsec_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
+{
+	double msecs = avg / 1e6;
+	const char *fmt = csv_output ? "%.6f%s%s" : "%18.6f%s%-25s";
+
+	aggr_printout(evsel, cpu, nr);
 
-	fprintf(output, fmt, cpustr, msecs, csv_sep, perf_evsel__name(evsel));
+	fprintf(output, fmt, msecs, csv_sep, perf_evsel__name(evsel));
 
 	if (evsel->cgrp)
 		fprintf(output, "%s%s", csv_sep, evsel->cgrp->name);
@@ -758,32 +808,21 @@ static void print_ll_cache_misses(int cpu,
 static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 {
 	double total, ratio = 0.0;
-	char cpustr[16] = { '\0', };
 	const char *fmt;
 
 	if (csv_output)
-		fmt = "%s%.0f%s%s";
+		fmt = "%.0f%s%s";
 	else if (big_num)
-		fmt = "%s%'18.0f%s%-25s";
+		fmt = "%'18.0f%s%-25s";
 	else
-		fmt = "%s%18.0f%s%-25s";
+		fmt = "%18.0f%s%-25s";
 
-	if (aggr_socket)
-		sprintf(cpustr, "S%*d%s%*d%s",
-			csv_output ? 0 : -5,
-			cpu,
-			csv_sep,
-			csv_output ? 0 : 4,
-			nr,
-			csv_sep);
-	else if (no_aggr)
-		sprintf(cpustr, "CPU%*d%s",
-			csv_output ? 0 : -4,
-			perf_evsel__cpus(evsel)->map[cpu], csv_sep);
-	else
+	aggr_printout(evsel, cpu, nr);
+
+	if (aggr_mode == AGGR_GLOBAL)
 		cpu = 0;
 
-	fprintf(output, fmt, cpustr, avg, csv_sep, perf_evsel__name(evsel));
+	fprintf(output, fmt, avg, csv_sep, perf_evsel__name(evsel));
 
 	if (evsel->cgrp)
 		fprintf(output, "%s%s", csv_sep, evsel->cgrp->name);
@@ -882,23 +921,23 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 	}
 }
 
-static void print_aggr_socket(char *prefix)
+static void print_aggr(char *prefix)
 {
 	struct perf_evsel *counter;
+	int cpu, s, s2, id, nr;
 	u64 ena, run, val;
-	int cpu, s, s2, sock, nr;
 
-	if (!sock_map)
+	if (!(aggr_map || aggr_get_id))
 		return;
 
-	for (s = 0; s < sock_map->nr; s++) {
-		sock = cpu_map__socket(sock_map, s);
+	for (s = 0; s < aggr_map->nr; s++) {
+		id = aggr_map->map[s];
 		list_for_each_entry(counter, &evsel_list->entries, node) {
 			val = ena = run = 0;
 			nr = 0;
 			for (cpu = 0; cpu < perf_evsel__nr_cpus(counter); cpu++) {
-				s2 = cpu_map__get_socket(evsel_list->cpus, cpu);
-				if (s2 != sock)
+				s2 = aggr_get_id(evsel_list->cpus, cpu);
+				if (s2 != id)
 					continue;
 				val += counter->counts->cpu[cpu].val;
 				ena += counter->counts->cpu[cpu].ena;
@@ -909,18 +948,15 @@ static void print_aggr_socket(char *prefix)
 				fprintf(output, "%s", prefix);
 
 			if (run == 0 || ena == 0) {
-				fprintf(output, "S%*d%s%*d%s%*s%s%*s",
-					csv_output ? 0 : -5,
-					s,
-					csv_sep,
-					csv_output ? 0 : 4,
-					nr,
-					csv_sep,
+				aggr_printout(counter, cpu, nr);
+
+				fprintf(output, "%*s%s%*s",
 					csv_output ? 0 : 18,
 					counter->supported ? CNTR_NOT_COUNTED : CNTR_NOT_SUPPORTED,
 					csv_sep,
 					csv_output ? 0 : -24,
 					perf_evsel__name(counter));
+
 				if (counter->cgrp)
 					fprintf(output, "%s%s",
 						csv_sep, counter->cgrp->name);
@@ -930,9 +966,9 @@ static void print_aggr_socket(char *prefix)
 			}
 
 			if (nsec_counter(counter))
-				nsec_printout(sock, nr, counter, val);
+				nsec_printout(id, nr, counter, val);
 			else
-				abs_printout(sock, nr, counter, val);
+				abs_printout(id, nr, counter, val);
 
 			if (!csv_output) {
 				print_noise(counter, 1.0);
@@ -1073,14 +1109,21 @@ static void print_stat(int argc, const char **argv)
 		fprintf(output, ":\n\n");
 	}
 
-	if (aggr_socket)
-		print_aggr_socket(NULL);
-	else if (no_aggr) {
-		list_for_each_entry(counter, &evsel_list->entries, node)
-			print_counter(counter, NULL);
-	} else {
+	switch (aggr_mode) {
+	case AGGR_CORE:
+	case AGGR_SOCKET:
+		print_aggr(NULL);
+		break;
+	case AGGR_GLOBAL:
 		list_for_each_entry(counter, &evsel_list->entries, node)
 			print_counter_aggr(counter, NULL);
+		break;
+	case AGGR_NONE:
+		list_for_each_entry(counter, &evsel_list->entries, node)
+			print_counter(counter, NULL);
+		break;
+	default:
+		break;
 	}
 
 	if (!csv_output) {
@@ -1126,6 +1169,32 @@ static int stat__set_big_num(const struct option *opt __maybe_unused,
 	return 0;
 }
 
+static int perf_stat_init_aggr_mode(void)
+{
+	switch (aggr_mode) {
+	case AGGR_SOCKET:
+		if (cpu_map__build_socket_map(evsel_list->cpus, &aggr_map)) {
+			perror("cannot build socket map");
+			return -1;
+		}
+		aggr_get_id = cpu_map__get_socket;
+		break;
+	case AGGR_CORE:
+		if (cpu_map__build_core_map(evsel_list->cpus, &aggr_map)) {
+			perror("cannot build core map");
+			return -1;
+		}
+		aggr_get_id = cpu_map__get_core;
+		break;
+	case AGGR_NONE:
+	case AGGR_GLOBAL:
+	default:
+		break;
+	}
+	return 0;
+}
+
+
 /*
  * Add default attributes, if there were no attributes specified or
  * if -d/--detailed, -d -d or -d -d -d is used:
@@ -1296,7 +1365,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_INTEGER('r', "repeat", &run_count,
-		    "repeat command and print average + stddev (max: 100)"),
+		    "repeat command and print average + stddev (max: 100, forever: 0)"),
 	OPT_BOOLEAN('n', "null", &null_run,
 		    "null run - dont start any counters"),
 	OPT_INCR('d', "detailed", &detailed_run,
@@ -1308,7 +1377,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 			   stat__set_big_num),
 	OPT_STRING('C', "cpu", &target.cpu_list, "cpu",
 		    "list of cpus to monitor in system-wide"),
-	OPT_BOOLEAN('A', "no-aggr", &no_aggr, "disable CPU count aggregation"),
+	OPT_SET_UINT('A', "no-aggr", &aggr_mode,
+		    "disable CPU count aggregation", AGGR_NONE),
 	OPT_STRING('x', "field-separator", &csv_sep, "separator",
 		   "print counts with custom separator"),
 	OPT_CALLBACK('G', "cgroup", &evsel_list, "name",
@@ -1323,20 +1393,22 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 			"command to run after to the measured command"),
 	OPT_UINTEGER('I', "interval-print", &interval,
 		    "print counts at regular interval in ms (>= 100)"),
-	OPT_BOOLEAN(0, "aggr-socket", &aggr_socket, "aggregate counts per processor socket"),
+	OPT_SET_UINT(0, "per-socket", &aggr_mode,
+		     "aggregate counts per processor socket", AGGR_SOCKET),
+	OPT_SET_UINT(0, "per-core", &aggr_mode,
+		     "aggregate counts per physical processor core", AGGR_CORE),
 	OPT_END()
 	};
 	const char * const stat_usage[] = {
 		"perf stat [<options>] [<command>]",
 		NULL
 	};
-	struct perf_evsel *pos;
 	int status = -ENOMEM, run_idx;
 	const char *mode;
 
 	setlocale(LC_ALL, "");
 
-	evsel_list = perf_evlist__new(NULL, NULL);
+	evsel_list = perf_evlist__new();
 	if (evsel_list == NULL)
 		return -ENOMEM;
 
@@ -1399,23 +1471,21 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	if (!argc && !perf_target__has_task(&target))
 		usage_with_options(stat_usage, options);
-	if (run_count <= 0)
+	if (run_count < 0) {
 		usage_with_options(stat_usage, options);
+	} else if (run_count == 0) {
+		forever = true;
+		run_count = 1;
+	}
 
 	/* no_aggr, cgroup are for system-wide only */
-	if ((no_aggr || nr_cgroups) && !perf_target__has_cpu(&target)) {
+	if ((aggr_mode != AGGR_GLOBAL || nr_cgroups)
+	     && !perf_target__has_cpu(&target)) {
 		fprintf(stderr, "both cgroup and no-aggregation "
 			"modes only available in system-wide mode\n");
 
 		usage_with_options(stat_usage, options);
-	}
-
-	if (aggr_socket) {
-		if (!perf_target__has_cpu(&target)) {
-			fprintf(stderr, "--aggr-socket only available in system-wide mode (-a)\n");
-			usage_with_options(stat_usage, options);
-		}
-		no_aggr = true;
+		return -1;
 	}
 
 	if (add_default_attributes())
@@ -1438,17 +1508,11 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 		return -1;
 	}
 
-	list_for_each_entry(pos, &evsel_list->entries, node) {
-		if (perf_evsel__alloc_stat_priv(pos) < 0 ||
-		    perf_evsel__alloc_counts(pos, perf_evsel__nr_cpus(pos)) < 0)
-			goto out_free_fd;
-	}
-	if (interval) {
-		list_for_each_entry(pos, &evsel_list->entries, node) {
-			if (perf_evsel__alloc_prev_raw_counts(pos) < 0)
-				goto out_free_fd;
-		}
-	}
+	if (perf_evlist__alloc_stats(evsel_list, interval))
+		goto out_free_maps;
+
+	if (perf_stat_init_aggr_mode())
+		goto out;
 
 	/*
 	 * We dont want to block the signals - that would cause
@@ -1457,28 +1521,30 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	 * task, but being ignored by perf stat itself:
 	 */
 	atexit(sig_atexit);
-	signal(SIGINT,  skip_signal);
+	if (!forever)
+		signal(SIGINT,  skip_signal);
 	signal(SIGCHLD, skip_signal);
 	signal(SIGALRM, skip_signal);
 	signal(SIGABRT, skip_signal);
 
 	status = 0;
-	for (run_idx = 0; run_idx < run_count; run_idx++) {
+	for (run_idx = 0; forever || run_idx < run_count; run_idx++) {
 		if (run_count != 1 && verbose)
 			fprintf(output, "[ perf stat: executing run #%d ... ]\n",
 				run_idx + 1);
 
 		status = run_perf_stat(argc, argv);
+		if (forever && status != -1) {
+			print_stat(argc, argv);
+			perf_stat__reset_stats(evsel_list);
+		}
 	}
 
-	if (status != -1 && !interval)
+	if (!forever && status != -1 && !interval)
 		print_stat(argc, argv);
-out_free_fd:
-	list_for_each_entry(pos, &evsel_list->entries, node) {
-		perf_evsel__free_stat_priv(pos);
-		perf_evsel__free_counts(pos);
-		perf_evsel__free_prev_raw_counts(pos);
-	}
+
+	perf_evlist__free_stats(evsel_list);
+out_free_maps:
 	perf_evlist__delete_maps(evsel_list);
 out:
 	perf_evlist__delete(evsel_list);
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 72f6eb7..67bdb9f 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -231,7 +231,7 @@ static void perf_top__show_details(struct perf_top *top)
 	printf("Showing %s for %s\n", perf_evsel__name(top->sym_evsel), symbol->name);
 	printf("  Events  Pcnt (>=%d%%)\n", top->sym_pcnt_filter);
 
-	more = symbol__annotate_printf(symbol, he->ms.map, top->sym_evsel->idx,
+	more = symbol__annotate_printf(symbol, he->ms.map, top->sym_evsel,
 				       0, top->sym_pcnt_filter, top->print_entries, 4);
 	if (top->zero)
 		symbol__annotate_zero_histogram(symbol, top->sym_evsel->idx);
@@ -251,7 +251,8 @@ static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 {
 	struct hist_entry *he;
 
-	he = __hists__add_entry(&evsel->hists, al, NULL, sample->period);
+	he = __hists__add_entry(&evsel->hists, al, NULL, sample->period,
+				sample->weight);
 	if (he == NULL)
 		return NULL;
 
@@ -1088,7 +1089,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
-		   "sort by key(s): pid, comm, dso, symbol, parent"),
+		   "sort by key(s): pid, comm, dso, symbol, parent, weight, local_weight"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
 	OPT_CALLBACK_DEFAULT('G', "call-graph", &top.record_opts,
@@ -1116,7 +1117,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		NULL
 	};
 
-	top.evlist = perf_evlist__new(NULL, NULL);
+	top.evlist = perf_evlist__new();
 	if (top.evlist == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index d222d7f..ab3ed4a 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -419,7 +419,7 @@ out_dump:
 
 static int trace__run(struct trace *trace, int argc, const char **argv)
 {
-	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
+	struct perf_evlist *evlist = perf_evlist__new();
 	struct perf_evsel *evsel;
 	int err = -1, i;
 	unsigned long before;
@@ -452,7 +452,7 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 	err = trace__symbols_init(trace, evlist);
 	if (err < 0) {
 		printf("Problems initializing symbol libraries!\n");
-		goto out_delete_evlist;
+		goto out_delete_maps;
 	}
 
 	perf_evlist__config(evlist, &trace->opts);
@@ -461,23 +461,24 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 	signal(SIGINT, sig_handler);
 
 	if (forks) {
-		err = perf_evlist__prepare_workload(evlist, &trace->opts, argv);
+		err = perf_evlist__prepare_workload(evlist, &trace->opts.target,
+						    argv, false, false);
 		if (err < 0) {
 			printf("Couldn't run the workload!\n");
-			goto out_delete_evlist;
+			goto out_delete_maps;
 		}
 	}
 
 	err = perf_evlist__open(evlist);
 	if (err < 0) {
 		printf("Couldn't create the events: %s\n", strerror(errno));
-		goto out_delete_evlist;
+		goto out_delete_maps;
 	}
 
 	err = perf_evlist__mmap(evlist, UINT_MAX, false);
 	if (err < 0) {
 		printf("Couldn't mmap the events: %s\n", strerror(errno));
-		goto out_delete_evlist;
+		goto out_close_evlist;
 	}
 
 	perf_evlist__enable(evlist);
@@ -526,13 +527,6 @@ again:
 				continue;
 			}
 
-			if (sample.raw_data == NULL) {
-				printf("%s sample with no payload for tid: %d, cpu %d, raw_size=%d, skipping...\n",
-				       perf_evsel__name(evsel), sample.tid,
-				       sample.cpu, sample.raw_size);
-				continue;
-			}
-
 			handler = evsel->handler.func;
 			handler(trace, evsel, &sample);
 		}
@@ -540,7 +534,7 @@ again:
 
 	if (trace->nr_events == before) {
 		if (done)
-			goto out_delete_evlist;
+			goto out_unmap_evlist;
 
 		poll(evlist->pollfd, evlist->nr_fds, -1);
 	}
@@ -550,6 +544,12 @@ again:
 
 	goto again;
 
+out_unmap_evlist:
+	perf_evlist__munmap(evlist);
+out_close_evlist:
+	perf_evlist__close(evlist);
+out_delete_maps:
+	perf_evlist__delete_maps(evlist);
 out_delete_evlist:
 	perf_evlist__delete(evlist);
 out:
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index 08143bd..b210d62 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -36,6 +36,7 @@ extern int cmd_kvm(int argc, const char **argv, const char *prefix);
 extern int cmd_test(int argc, const char **argv, const char *prefix);
 extern int cmd_trace(int argc, const char **argv, const char *prefix);
 extern int cmd_inject(int argc, const char **argv, const char *prefix);
+extern int cmd_mem(int argc, const char **argv, const char *prefix);
 
 extern int find_scripts(char **scripts_array, char **scripts_path_array);
 #endif
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index 3e86bbd..0906fc4 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -10,17 +10,18 @@ perf-buildid-list		mainporcelain common
 perf-diff			mainporcelain common
 perf-evlist			mainporcelain common
 perf-inject			mainporcelain common
+perf-kmem			mainporcelain common
+perf-kvm			mainporcelain common
 perf-list			mainporcelain common
-perf-sched			mainporcelain common
+perf-lock			mainporcelain common
+perf-mem			mainporcelain common
+perf-probe			mainporcelain full
 perf-record			mainporcelain common
 perf-report			mainporcelain common
+perf-sched			mainporcelain common
+perf-script			mainporcelain common
 perf-stat			mainporcelain common
+perf-test			mainporcelain common
 perf-timechart			mainporcelain common
 perf-top			mainporcelain common
 perf-trace			mainporcelain common
-perf-script			mainporcelain common
-perf-probe			mainporcelain full
-perf-kmem			mainporcelain common
-perf-lock			mainporcelain common
-perf-kvm			mainporcelain common
-perf-test			mainporcelain common
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index b4eabb4..708fb8e 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -61,15 +61,13 @@ int main(void)
 }
 endef
 
-ifndef NO_NEWT
-define SOURCE_NEWT
-#include <newt.h>
+ifndef NO_SLANG
+define SOURCE_SLANG
+#include <slang.h>
 
 int main(void)
 {
-	newtInit();
-	newtCls();
-	return newtFinished();
+	return SLsmg_init_smg();
 }
 endef
 endif
@@ -235,4 +233,4 @@ int main(void)
 	numa_available();
 	return 0;
 }
-endef
\ No newline at end of file
+endef
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 095b882..85e1aed 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -13,7 +13,7 @@
 #include "util/quote.h"
 #include "util/run-command.h"
 #include "util/parse-events.h"
-#include "util/debugfs.h"
+#include <lk/debugfs.h>
 #include <pthread.h>
 
 const char perf_usage_string[] =
@@ -60,6 +60,7 @@ static struct cmd_struct commands[] = {
 	{ "trace",	cmd_trace,	0 },
 #endif
 	{ "inject",	cmd_inject,	0 },
+	{ "mem",	cmd_mem,	0 },
 };
 
 struct pager_config {
@@ -193,13 +194,13 @@ static int handle_options(const char ***argv, int *argc, int *envchanged)
 				fprintf(stderr, "No directory given for --debugfs-dir.\n");
 				usage(perf_usage_string);
 			}
-			debugfs_set_path((*argv)[1]);
+			perf_debugfs_set_path((*argv)[1]);
 			if (envchanged)
 				*envchanged = 1;
 			(*argv)++;
 			(*argc)--;
 		} else if (!prefixcmp(cmd, CMD_DEBUGFS_DIR)) {
-			debugfs_set_path(cmd + strlen(CMD_DEBUGFS_DIR));
+			perf_debugfs_set_path(cmd + strlen(CMD_DEBUGFS_DIR));
 			fprintf(stderr, "dir: %s\n", debugfs_mountpoint);
 			if (envchanged)
 				*envchanged = 1;
@@ -461,7 +462,7 @@ int main(int argc, const char **argv)
 	if (!cmd)
 		cmd = "perf-help";
 	/* get debugfs mount point from /proc/mounts */
-	debugfs_mount(NULL);
+	perf_debugfs_mount(NULL);
 	/*
 	 * "perf-xxxx" is the same as "perf xxxx", but we obviously:
 	 *
@@ -517,9 +518,8 @@ int main(int argc, const char **argv)
 
 	while (1) {
 		static int done_help;
-		static int was_alias;
+		int was_alias = run_argv(&argc, &argv);
 
-		was_alias = run_argv(&argc, &argv);
 		if (errno != ENOENT)
 			break;
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 74659ec..32bd102 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -218,6 +218,7 @@ struct perf_record_opts {
 	bool	     pipe_output;
 	bool	     raw_samples;
 	bool	     sample_address;
+	bool	     sample_weight;
 	bool	     sample_time;
 	bool	     period;
 	unsigned int freq;
diff --git a/tools/perf/tests/attr.c b/tools/perf/tests/attr.c
index bdcceb8..038de3e 100644
--- a/tools/perf/tests/attr.c
+++ b/tools/perf/tests/attr.c
@@ -147,10 +147,15 @@ void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
 
 static int run_dir(const char *d, const char *perf)
 {
+	char v[] = "-vvvvv";
+	int vcnt = min(verbose, (int) sizeof(v) - 1);
 	char cmd[3*PATH_MAX];
 
-	snprintf(cmd, 3*PATH_MAX, PYTHON " %s/attr.py -d %s/attr/ -p %s %s",
-		 d, d, perf, verbose ? "-v" : "");
+	if (verbose)
+		vcnt++;
+
+	snprintf(cmd, 3*PATH_MAX, PYTHON " %s/attr.py -d %s/attr/ -p %s %.*s",
+		 d, d, perf, vcnt, v);
 
 	return system(cmd);
 }
diff --git a/tools/perf/tests/attr.py b/tools/perf/tests/attr.py
index 2f629ca..c9b4b62 100644
--- a/tools/perf/tests/attr.py
+++ b/tools/perf/tests/attr.py
@@ -24,6 +24,7 @@ class Unsup(Exception):
 
 class Event(dict):
     terms = [
+        'cpu',
         'flags',
         'type',
         'size',
@@ -121,7 +122,7 @@ class Test(object):
         parser = ConfigParser.SafeConfigParser()
         parser.read(path)
 
-        log.debug("running '%s'" % path)
+        log.warning("running '%s'" % path)
 
         self.path     = path
         self.test_dir = options.test_dir
@@ -172,7 +173,7 @@ class Test(object):
               self.perf, self.command, tempdir, self.args)
         ret = os.WEXITSTATUS(os.system(cmd))
 
-        log.warning("  running '%s' ret %d " % (cmd, ret))
+        log.info("  '%s' ret %d " % (cmd, ret))
 
         if ret != int(self.ret):
             raise Unsup(self)
diff --git a/tools/perf/tests/attr/base-record b/tools/perf/tests/attr/base-record
index 5bc3880..b4fc835 100644
--- a/tools/perf/tests/attr/base-record
+++ b/tools/perf/tests/attr/base-record
@@ -2,6 +2,7 @@
 fd=1
 group_fd=-1
 flags=0
+cpu=*
 type=0|1
 size=96
 config=0
diff --git a/tools/perf/tests/attr/base-stat b/tools/perf/tests/attr/base-stat
index 4bd79a8..748ee94 100644
--- a/tools/perf/tests/attr/base-stat
+++ b/tools/perf/tests/attr/base-stat
@@ -2,6 +2,7 @@
 fd=1
 group_fd=-1
 flags=0
+cpu=*
 type=0
 size=96
 config=0
diff --git a/tools/perf/tests/attr/test-record-C0 b/tools/perf/tests/attr/test-record-C0
new file mode 100644
index 0000000..d6a7e43
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-C0
@@ -0,0 +1,13 @@
+[config]
+command = record
+args    = -C 0 kill >/dev/null 2>&1
+
+[event:base-record]
+cpu=0
+
+# no enable on exec for CPU attached
+enable_on_exec=0
+
+# PERF_SAMPLE_IP | PERF_SAMPLE_TID PERF_SAMPLE_TIME | # PERF_SAMPLE_PERIOD
+# + PERF_SAMPLE_CPU added by -C 0
+sample_type=391
diff --git a/tools/perf/tests/attr/test-stat-C0 b/tools/perf/tests/attr/test-stat-C0
new file mode 100644
index 0000000..aa83595
--- /dev/null
+++ b/tools/perf/tests/attr/test-stat-C0
@@ -0,0 +1,9 @@
+[config]
+command = stat
+args    = -e cycles -C 0 kill >/dev/null 2>&1
+ret     = 1
+
+[event:base-stat]
+# events are enabled by default when attached to cpu
+disabled=0
+enable_on_exec=0
diff --git a/tools/perf/tests/bp_signal.c b/tools/perf/tests/bp_signal.c
new file mode 100644
index 0000000..68daa28
--- /dev/null
+++ b/tools/perf/tests/bp_signal.c
@@ -0,0 +1,186 @@
+/*
+ * Inspired by breakpoint overflow test done by
+ * Vince Weaver <vincent.weaver@maine.edu> for perf_event_tests
+ * (git://github.com/deater/perf_event_tests)
+ */
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <time.h>
+#include <fcntl.h>
+#include <signal.h>
+#include <sys/mman.h>
+#include <linux/compiler.h>
+#include <linux/hw_breakpoint.h>
+
+#include "tests.h"
+#include "debug.h"
+#include "perf.h"
+
+static int fd1;
+static int fd2;
+static int overflows;
+
+__attribute__ ((noinline))
+static int test_function(void)
+{
+	return time(NULL);
+}
+
+static void sig_handler(int signum __maybe_unused,
+			siginfo_t *oh __maybe_unused,
+			void *uc __maybe_unused)
+{
+	overflows++;
+
+	if (overflows > 10) {
+		/*
+		 * This should be executed only once during
+		 * this test, if we are here for the 10th
+		 * time, consider this the recursive issue.
+		 *
+		 * We can get out of here by disable events,
+		 * so no new SIGIO is delivered.
+		 */
+		ioctl(fd1, PERF_EVENT_IOC_DISABLE, 0);
+		ioctl(fd2, PERF_EVENT_IOC_DISABLE, 0);
+	}
+}
+
+static int bp_event(void *fn, int setup_signal)
+{
+	struct perf_event_attr pe;
+	int fd;
+
+	memset(&pe, 0, sizeof(struct perf_event_attr));
+	pe.type = PERF_TYPE_BREAKPOINT;
+	pe.size = sizeof(struct perf_event_attr);
+
+	pe.config = 0;
+	pe.bp_type = HW_BREAKPOINT_X;
+	pe.bp_addr = (unsigned long) fn;
+	pe.bp_len = sizeof(long);
+
+	pe.sample_period = 1;
+	pe.sample_type = PERF_SAMPLE_IP;
+	pe.wakeup_events = 1;
+
+	pe.disabled = 1;
+	pe.exclude_kernel = 1;
+	pe.exclude_hv = 1;
+
+	fd = sys_perf_event_open(&pe, 0, -1, -1, 0);
+	if (fd < 0) {
+		pr_debug("failed opening event %llx\n", pe.config);
+		return TEST_FAIL;
+	}
+
+	if (setup_signal) {
+		fcntl(fd, F_SETFL, O_RDWR|O_NONBLOCK|O_ASYNC);
+		fcntl(fd, F_SETSIG, SIGIO);
+		fcntl(fd, F_SETOWN, getpid());
+	}
+
+	ioctl(fd, PERF_EVENT_IOC_RESET, 0);
+
+	return fd;
+}
+
+static long long bp_count(int fd)
+{
+	long long count;
+	int ret;
+
+	ret = read(fd, &count, sizeof(long long));
+	if (ret != sizeof(long long)) {
+		pr_debug("failed to read: %d\n", ret);
+		return TEST_FAIL;
+	}
+
+	return count;
+}
+
+int test__bp_signal(void)
+{
+	struct sigaction sa;
+	long long count1, count2;
+
+	/* setup SIGIO signal handler */
+	memset(&sa, 0, sizeof(struct sigaction));
+	sa.sa_sigaction = (void *) sig_handler;
+	sa.sa_flags = SA_SIGINFO;
+
+	if (sigaction(SIGIO, &sa, NULL) < 0) {
+		pr_debug("failed setting up signal handler\n");
+		return TEST_FAIL;
+	}
+
+	/*
+	 * We create following events:
+	 *
+	 * fd1 - breakpoint event on test_function with SIGIO
+	 *       signal configured. We should get signal
+	 *       notification each time the breakpoint is hit
+	 *
+	 * fd2 - breakpoint event on sig_handler without SIGIO
+	 *       configured.
+	 *
+	 * Following processing should happen:
+	 *   - execute test_function
+	 *   - fd1 event breakpoint hit -> count1 == 1
+	 *   - SIGIO is delivered       -> overflows == 1
+	 *   - fd2 event breakpoint hit -> count2 == 1
+	 *
+	 * The test case check following error conditions:
+	 * - we get stuck in signal handler because of debug
+	 *   exception being triggered receursively due to
+	 *   the wrong RF EFLAG management
+	 *
+	 * - we never trigger the sig_handler breakpoint due
+	 *   to the rong RF EFLAG management
+	 *
+	 */
+
+	fd1 = bp_event(test_function, 1);
+	fd2 = bp_event(sig_handler, 0);
+
+	ioctl(fd1, PERF_EVENT_IOC_ENABLE, 0);
+	ioctl(fd2, PERF_EVENT_IOC_ENABLE, 0);
+
+	/*
+	 * Kick off the test by trigering 'fd1'
+	 * breakpoint.
+	 */
+	test_function();
+
+	ioctl(fd1, PERF_EVENT_IOC_DISABLE, 0);
+	ioctl(fd2, PERF_EVENT_IOC_DISABLE, 0);
+
+	count1 = bp_count(fd1);
+	count2 = bp_count(fd2);
+
+	close(fd1);
+	close(fd2);
+
+	pr_debug("count1 %lld, count2 %lld, overflow %d\n",
+		 count1, count2, overflows);
+
+	if (count1 != 1) {
+		if (count1 == 11)
+			pr_debug("failed: RF EFLAG recursion issue detected\n");
+		else
+			pr_debug("failed: wrong count for bp1%lld\n", count1);
+	}
+
+	if (overflows != 1)
+		pr_debug("failed: wrong overflow hit\n");
+
+	if (count2 != 1)
+		pr_debug("failed: wrong count for bp2\n");
+
+	return count1 == 1 && overflows == 1 && count2 == 1 ?
+		TEST_OK : TEST_FAIL;
+}
diff --git a/tools/perf/tests/bp_signal_overflow.c b/tools/perf/tests/bp_signal_overflow.c
new file mode 100644
index 0000000..fe7ed28
--- /dev/null
+++ b/tools/perf/tests/bp_signal_overflow.c
@@ -0,0 +1,126 @@
+/*
+ * Originally done by Vince Weaver <vincent.weaver@maine.edu> for
+ * perf_event_tests (git://github.com/deater/perf_event_tests)
+ */
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <time.h>
+#include <fcntl.h>
+#include <signal.h>
+#include <sys/mman.h>
+#include <linux/compiler.h>
+#include <linux/hw_breakpoint.h>
+
+#include "tests.h"
+#include "debug.h"
+#include "perf.h"
+
+static int overflows;
+
+__attribute__ ((noinline))
+static int test_function(void)
+{
+	return time(NULL);
+}
+
+static void sig_handler(int signum __maybe_unused,
+			siginfo_t *oh __maybe_unused,
+			void *uc __maybe_unused)
+{
+	overflows++;
+}
+
+static long long bp_count(int fd)
+{
+	long long count;
+	int ret;
+
+	ret = read(fd, &count, sizeof(long long));
+	if (ret != sizeof(long long)) {
+		pr_debug("failed to read: %d\n", ret);
+		return TEST_FAIL;
+	}
+
+	return count;
+}
+
+#define EXECUTIONS 10000
+#define THRESHOLD  100
+
+int test__bp_signal_overflow(void)
+{
+	struct perf_event_attr pe;
+	struct sigaction sa;
+	long long count;
+	int fd, i, fails = 0;
+
+	/* setup SIGIO signal handler */
+	memset(&sa, 0, sizeof(struct sigaction));
+	sa.sa_sigaction = (void *) sig_handler;
+	sa.sa_flags = SA_SIGINFO;
+
+	if (sigaction(SIGIO, &sa, NULL) < 0) {
+		pr_debug("failed setting up signal handler\n");
+		return TEST_FAIL;
+	}
+
+	memset(&pe, 0, sizeof(struct perf_event_attr));
+	pe.type = PERF_TYPE_BREAKPOINT;
+	pe.size = sizeof(struct perf_event_attr);
+
+	pe.config = 0;
+	pe.bp_type = HW_BREAKPOINT_X;
+	pe.bp_addr = (unsigned long) test_function;
+	pe.bp_len = sizeof(long);
+
+	pe.sample_period = THRESHOLD;
+	pe.sample_type = PERF_SAMPLE_IP;
+	pe.wakeup_events = 1;
+
+	pe.disabled = 1;
+	pe.exclude_kernel = 1;
+	pe.exclude_hv = 1;
+
+	fd = sys_perf_event_open(&pe, 0, -1, -1, 0);
+	if (fd < 0) {
+		pr_debug("failed opening event %llx\n", pe.config);
+		return TEST_FAIL;
+	}
+
+	fcntl(fd, F_SETFL, O_RDWR|O_NONBLOCK|O_ASYNC);
+	fcntl(fd, F_SETSIG, SIGIO);
+	fcntl(fd, F_SETOWN, getpid());
+
+	ioctl(fd, PERF_EVENT_IOC_RESET, 0);
+	ioctl(fd, PERF_EVENT_IOC_ENABLE, 0);
+
+	for (i = 0; i < EXECUTIONS; i++)
+		test_function();
+
+	ioctl(fd, PERF_EVENT_IOC_DISABLE, 0);
+
+	count = bp_count(fd);
+
+	close(fd);
+
+	pr_debug("count %lld, overflow %d\n",
+		 count, overflows);
+
+	if (count != EXECUTIONS) {
+		pr_debug("\tWrong number of executions %lld != %d\n",
+		count, EXECUTIONS);
+		fails++;
+	}
+
+	if (overflows != EXECUTIONS / THRESHOLD) {
+		pr_debug("\tWrong number of overflows %d != %d\n",
+		overflows, EXECUTIONS / THRESHOLD);
+		fails++;
+	}
+
+	return fails ? TEST_FAIL : TEST_OK;
+}
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index acb98e0..0918ada 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -78,6 +78,22 @@ static struct test {
 		.func = test__python_use,
 	},
 	{
+		.desc = "Test breakpoint overflow signal handler",
+		.func = test__bp_signal,
+	},
+	{
+		.desc = "Test breakpoint overflow sampling",
+		.func = test__bp_signal_overflow,
+	},
+	{
+		.desc = "Test number of exit event of a simple workload",
+		.func = test__task_exit,
+	},
+	{
+		.desc = "Test software clock events have valid period values",
+		.func = test__sw_clock_freq,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/evsel-roundtrip-name.c b/tools/perf/tests/evsel-roundtrip-name.c
index 0fd99a9..0197bda 100644
--- a/tools/perf/tests/evsel-roundtrip-name.c
+++ b/tools/perf/tests/evsel-roundtrip-name.c
@@ -8,7 +8,7 @@ static int perf_evsel__roundtrip_cache_name_test(void)
 	char name[128];
 	int type, op, err = 0, ret = 0, i, idx;
 	struct perf_evsel *evsel;
-        struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
+	struct perf_evlist *evlist = perf_evlist__new();
 
         if (evlist == NULL)
                 return -ENOMEM;
@@ -64,7 +64,7 @@ static int __perf_evsel__name_array_test(const char *names[], int nr_names)
 {
 	int i, err;
 	struct perf_evsel *evsel;
-        struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
+	struct perf_evlist *evlist = perf_evlist__new();
 
         if (evlist == NULL)
                 return -ENOMEM;
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 1be64a6..89085a9 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -223,7 +223,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 							  &sample, 0) < 0)
 				goto out;
 
-			he = __hists__add_entry(&evsel->hists, &al, NULL, 1);
+			he = __hists__add_entry(&evsel->hists, &al, NULL, 1, 1);
 			if (he == NULL)
 				goto out;
 
@@ -247,7 +247,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 							  &sample, 0) < 0)
 				goto out;
 
-			he = __hists__add_entry(&evsel->hists, &al, NULL, 1);
+			he = __hists__add_entry(&evsel->hists, &al, NULL, 1, 1);
 			if (he == NULL)
 				goto out;
 
@@ -436,7 +436,7 @@ int test__hists_link(void)
 	struct machines machines;
 	struct machine *machine = NULL;
 	struct perf_evsel *evsel, *first;
-        struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
+	struct perf_evlist *evlist = perf_evlist__new();
 
 	if (evlist == NULL)
                 return -ENOMEM;
diff --git a/tools/perf/tests/mmap-basic.c b/tools/perf/tests/mmap-basic.c
index cdd5075..5b1b5ab 100644
--- a/tools/perf/tests/mmap-basic.c
+++ b/tools/perf/tests/mmap-basic.c
@@ -53,12 +53,14 @@ int test__basic_mmap(void)
 		goto out_free_cpus;
 	}
 
-	evlist = perf_evlist__new(cpus, threads);
+	evlist = perf_evlist__new();
 	if (evlist == NULL) {
 		pr_debug("perf_evlist__new\n");
 		goto out_free_cpus;
 	}
 
+	perf_evlist__set_maps(evlist, cpus, threads);
+
 	for (i = 0; i < nsyscalls; ++i) {
 		char name[64];
 
diff --git a/tools/perf/tests/open-syscall-tp-fields.c b/tools/perf/tests/open-syscall-tp-fields.c
index 1c52fdc..fc5b9fc 100644
--- a/tools/perf/tests/open-syscall-tp-fields.c
+++ b/tools/perf/tests/open-syscall-tp-fields.c
@@ -18,7 +18,7 @@ int test__syscall_open_tp_fields(void)
 	};
 	const char *filename = "/etc/passwd";
 	int flags = O_RDONLY | O_DIRECTORY;
-	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
+	struct perf_evlist *evlist = perf_evlist__new();
 	struct perf_evsel *evsel;
 	int err = -1, i, nr_events = 0, nr_polls = 0;
 
@@ -48,13 +48,13 @@ int test__syscall_open_tp_fields(void)
 	err = perf_evlist__open(evlist);
 	if (err < 0) {
 		pr_debug("perf_evlist__open: %s\n", strerror(errno));
-		goto out_delete_evlist;
+		goto out_delete_maps;
 	}
 
 	err = perf_evlist__mmap(evlist, UINT_MAX, false);
 	if (err < 0) {
 		pr_debug("perf_evlist__mmap: %s\n", strerror(errno));
-		goto out_delete_evlist;
+		goto out_close_evlist;
 	}
 
 	perf_evlist__enable(evlist);
@@ -110,6 +110,10 @@ out_ok:
 	err = 0;
 out_munmap:
 	perf_evlist__munmap(evlist);
+out_close_evlist:
+	perf_evlist__close(evlist);
+out_delete_maps:
+	perf_evlist__delete_maps(evlist);
 out_delete_evlist:
 	perf_evlist__delete(evlist);
 out:
diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index c5636f3..88e2f44 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -3,7 +3,7 @@
 #include "evsel.h"
 #include "evlist.h"
 #include "sysfs.h"
-#include "debugfs.h"
+#include <lk/debugfs.h>
 #include "tests.h"
 #include <linux/hw_breakpoint.h>
 
@@ -1218,7 +1218,7 @@ static int test_event(struct evlist_test *e)
 	struct perf_evlist *evlist;
 	int ret;
 
-	evlist = perf_evlist__new(NULL, NULL);
+	evlist = perf_evlist__new();
 	if (evlist == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index 1e8e512..72d8881 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -45,7 +45,7 @@ int test__PERF_RECORD(void)
 	};
 	cpu_set_t cpu_mask;
 	size_t cpu_mask_size = sizeof(cpu_mask);
-	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
+	struct perf_evlist *evlist = perf_evlist__new();
 	struct perf_evsel *evsel;
 	struct perf_sample sample;
 	const char *cmd = "sleep";
@@ -93,7 +93,8 @@ int test__PERF_RECORD(void)
 	 * so that we have time to open the evlist (calling sys_perf_event_open
 	 * on all the fds) and then mmap them.
 	 */
-	err = perf_evlist__prepare_workload(evlist, &opts, argv);
+	err = perf_evlist__prepare_workload(evlist, &opts.target, argv,
+					    false, false);
 	if (err < 0) {
 		pr_debug("Couldn't run the workload!\n");
 		goto out_delete_maps;
@@ -142,7 +143,7 @@ int test__PERF_RECORD(void)
 	err = perf_evlist__mmap(evlist, opts.mmap_pages, false);
 	if (err < 0) {
 		pr_debug("perf_evlist__mmap: %s\n", strerror(errno));
-		goto out_delete_maps;
+		goto out_close_evlist;
 	}
 
 	/*
@@ -305,6 +306,8 @@ found_exit:
 	}
 out_err:
 	perf_evlist__munmap(evlist);
+out_close_evlist:
+	perf_evlist__close(evlist);
 out_delete_maps:
 	perf_evlist__delete_maps(evlist);
 out_delete_evlist:
diff --git a/tools/perf/tests/sw-clock.c b/tools/perf/tests/sw-clock.c
new file mode 100644
index 0000000..2e41e2d
--- /dev/null
+++ b/tools/perf/tests/sw-clock.c
@@ -0,0 +1,119 @@
+#include <unistd.h>
+#include <stdlib.h>
+#include <signal.h>
+#include <sys/mman.h>
+
+#include "tests.h"
+#include "util/evsel.h"
+#include "util/evlist.h"
+#include "util/cpumap.h"
+#include "util/thread_map.h"
+
+#define NR_LOOPS  1000000
+
+/*
+ * This test will open software clock events (cpu-clock, task-clock)
+ * then check their frequency -> period conversion has no artifact of
+ * setting period to 1 forcefully.
+ */
+static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
+{
+	int i, err = -1;
+	volatile int tmp = 0;
+	u64 total_periods = 0;
+	int nr_samples = 0;
+	union perf_event *event;
+	struct perf_evsel *evsel;
+	struct perf_evlist *evlist;
+	struct perf_event_attr attr = {
+		.type = PERF_TYPE_SOFTWARE,
+		.config = clock_id,
+		.sample_type = PERF_SAMPLE_PERIOD,
+		.exclude_kernel = 1,
+		.disabled = 1,
+		.freq = 1,
+	};
+
+	attr.sample_freq = 10000;
+
+	evlist = perf_evlist__new();
+	if (evlist == NULL) {
+		pr_debug("perf_evlist__new\n");
+		return -1;
+	}
+
+	evsel = perf_evsel__new(&attr, 0);
+	if (evsel == NULL) {
+		pr_debug("perf_evsel__new\n");
+		goto out_free_evlist;
+	}
+	perf_evlist__add(evlist, evsel);
+
+	evlist->cpus = cpu_map__dummy_new();
+	evlist->threads = thread_map__new_by_tid(getpid());
+	if (!evlist->cpus || !evlist->threads) {
+		err = -ENOMEM;
+		pr_debug("Not enough memory to create thread/cpu maps\n");
+		goto out_delete_maps;
+	}
+
+	perf_evlist__open(evlist);
+
+	err = perf_evlist__mmap(evlist, 128, true);
+	if (err < 0) {
+		pr_debug("failed to mmap event: %d (%s)\n", errno,
+			 strerror(errno));
+		goto out_close_evlist;
+	}
+
+	perf_evlist__enable(evlist);
+
+	/* collect samples */
+	for (i = 0; i < NR_LOOPS; i++)
+		tmp++;
+
+	perf_evlist__disable(evlist);
+
+	while ((event = perf_evlist__mmap_read(evlist, 0)) != NULL) {
+		struct perf_sample sample;
+
+		if (event->header.type != PERF_RECORD_SAMPLE)
+			continue;
+
+		err = perf_evlist__parse_sample(evlist, event, &sample);
+		if (err < 0) {
+			pr_debug("Error during parse sample\n");
+			goto out_unmap_evlist;
+		}
+
+		total_periods += sample.period;
+		nr_samples++;
+	}
+
+	if ((u64) nr_samples == total_periods) {
+		pr_debug("All (%d) samples have period value of 1!\n",
+			 nr_samples);
+		err = -1;
+	}
+
+out_unmap_evlist:
+	perf_evlist__munmap(evlist);
+out_close_evlist:
+	perf_evlist__close(evlist);
+out_delete_maps:
+	perf_evlist__delete_maps(evlist);
+out_free_evlist:
+	perf_evlist__delete(evlist);
+	return err;
+}
+
+int test__sw_clock_freq(void)
+{
+	int ret;
+
+	ret = __test__sw_clock_freq(PERF_COUNT_SW_CPU_CLOCK);
+	if (!ret)
+		ret = __test__sw_clock_freq(PERF_COUNT_SW_TASK_CLOCK);
+
+	return ret;
+}
diff --git a/tools/perf/tests/task-exit.c b/tools/perf/tests/task-exit.c
new file mode 100644
index 0000000..28fe589
--- /dev/null
+++ b/tools/perf/tests/task-exit.c
@@ -0,0 +1,123 @@
+#include "evlist.h"
+#include "evsel.h"
+#include "thread_map.h"
+#include "cpumap.h"
+#include "tests.h"
+
+#include <signal.h>
+
+static int exited;
+static int nr_exit;
+
+static void sig_handler(int sig)
+{
+	exited = 1;
+
+	if (sig == SIGUSR1)
+		nr_exit = -1;
+}
+
+/*
+ * This test will start a workload that does nothing then it checks
+ * if the number of exit event reported by the kernel is 1 or not
+ * in order to check the kernel returns correct number of event.
+ */
+int test__task_exit(void)
+{
+	int err = -1;
+	union perf_event *event;
+	struct perf_evsel *evsel;
+	struct perf_evlist *evlist;
+	struct perf_target target = {
+		.uid		= UINT_MAX,
+		.uses_mmap	= true,
+	};
+	const char *argv[] = { "true", NULL };
+
+	signal(SIGCHLD, sig_handler);
+	signal(SIGUSR1, sig_handler);
+
+	evlist = perf_evlist__new();
+	if (evlist == NULL) {
+		pr_debug("perf_evlist__new\n");
+		return -1;
+	}
+	/*
+	 * We need at least one evsel in the evlist, use the default
+	 * one: "cycles".
+	 */
+	err = perf_evlist__add_default(evlist);
+	if (err < 0) {
+		pr_debug("Not enough memory to create evsel\n");
+		goto out_free_evlist;
+	}
+
+	/*
+	 * Create maps of threads and cpus to monitor. In this case
+	 * we start with all threads and cpus (-1, -1) but then in
+	 * perf_evlist__prepare_workload we'll fill in the only thread
+	 * we're monitoring, the one forked there.
+	 */
+	evlist->cpus = cpu_map__dummy_new();
+	evlist->threads = thread_map__new_by_tid(-1);
+	if (!evlist->cpus || !evlist->threads) {
+		err = -ENOMEM;
+		pr_debug("Not enough memory to create thread/cpu maps\n");
+		goto out_delete_maps;
+	}
+
+	err = perf_evlist__prepare_workload(evlist, &target, argv, false, true);
+	if (err < 0) {
+		pr_debug("Couldn't run the workload!\n");
+		goto out_delete_maps;
+	}
+
+	evsel = perf_evlist__first(evlist);
+	evsel->attr.task = 1;
+	evsel->attr.sample_freq = 0;
+	evsel->attr.inherit = 0;
+	evsel->attr.watermark = 0;
+	evsel->attr.wakeup_events = 1;
+	evsel->attr.exclude_kernel = 1;
+
+	err = perf_evlist__open(evlist);
+	if (err < 0) {
+		pr_debug("Couldn't open the evlist: %s\n", strerror(-err));
+		goto out_delete_maps;
+	}
+
+	if (perf_evlist__mmap(evlist, 128, true) < 0) {
+		pr_debug("failed to mmap events: %d (%s)\n", errno,
+			 strerror(errno));
+		goto out_close_evlist;
+	}
+
+	perf_evlist__start_workload(evlist);
+
+retry:
+	while ((event = perf_evlist__mmap_read(evlist, 0)) != NULL) {
+		if (event->header.type != PERF_RECORD_EXIT)
+			continue;
+
+		nr_exit++;
+	}
+
+	if (!exited || !nr_exit) {
+		poll(evlist->pollfd, evlist->nr_fds, -1);
+		goto retry;
+	}
+
+	if (nr_exit != 1) {
+		pr_debug("received %d EXIT records\n", nr_exit);
+		err = -1;
+	}
+
+	perf_evlist__munmap(evlist);
+out_close_evlist:
+	perf_evlist__close(evlist);
+out_delete_maps:
+	perf_evlist__delete_maps(evlist);
+out_free_evlist:
+	perf_evlist__delete(evlist);
+	return err;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 5de0be1..dd7feae 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -23,5 +23,9 @@ int test__dso_data(void);
 int test__parse_events(void);
 int test__hists_link(void);
 int test__python_use(void);
+int test__bp_signal(void);
+int test__bp_signal_overflow(void);
+int test__task_exit(void);
+int test__sw_clock_freq(void);
 
 #endif /* TESTS_H */
diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index 809ea46..bbc782e 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -2,7 +2,6 @@
 #include "../cache.h"
 #include "../../perf.h"
 #include "libslang.h"
-#include <newt.h>
 #include "ui.h"
 #include "util.h"
 #include <linux/compiler.h>
@@ -234,7 +233,7 @@ void ui_browser__reset_index(struct ui_browser *browser)
 void __ui_browser__show_title(struct ui_browser *browser, const char *title)
 {
 	SLsmg_gotorc(0, 0);
-	ui_browser__set_color(browser, NEWT_COLORSET_ROOT);
+	ui_browser__set_color(browser, HE_COLORSET_ROOT);
 	slsmg_write_nstring(title, browser->width + 1);
 }
 
@@ -514,6 +513,12 @@ static struct ui_browser_colorset {
 		.bg	  = "default",
 	},
 	{
+		.colorset = HE_COLORSET_ROOT,
+		.name	  = "root",
+		.fg	  = "white",
+		.bg	  = "blue",
+	},
+	{
 		.name = NULL,
 	}
 };
diff --git a/tools/perf/ui/browser.h b/tools/perf/ui/browser.h
index af70314..404ff66 100644
--- a/tools/perf/ui/browser.h
+++ b/tools/perf/ui/browser.h
@@ -11,6 +11,7 @@
 #define HE_COLORSET_SELECTED	53
 #define HE_COLORSET_CODE	54
 #define HE_COLORSET_ADDR	55
+#define HE_COLORSET_ROOT	56
 
 struct ui_browser {
 	u64	      index, top_idx;
diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 7dca155..cc64d3f 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -8,15 +8,19 @@
 #include "../../util/hist.h"
 #include "../../util/sort.h"
 #include "../../util/symbol.h"
+#include "../../util/evsel.h"
 #include <pthread.h>
-#include <newt.h>
 
 struct browser_disasm_line {
 	struct rb_node	rb_node;
-	double		percent;
 	u32		idx;
 	int		idx_asm;
 	int		jump_sources;
+	/*
+	 * actual length of this array is saved on the nr_events field
+	 * of the struct annotate_browser
+	 */
+	double		percent[1];
 };
 
 static struct annotate_browser_opt {
@@ -33,8 +37,9 @@ struct annotate_browser {
 	struct ui_browser b;
 	struct rb_root	  entries;
 	struct rb_node	  *curr_hot;
-	struct disasm_line	  *selection;
+	struct disasm_line  *selection;
 	struct disasm_line  **offsets;
+	int		    nr_events;
 	u64		    start;
 	int		    nr_asm_entries;
 	int		    nr_entries;
@@ -94,14 +99,24 @@ static void annotate_browser__write(struct ui_browser *browser, void *entry, int
 			     (!current_entry || (browser->use_navkeypressed &&
 					         !browser->navkeypressed)));
 	int width = browser->width, printed;
+	int i, pcnt_width = 7 * ab->nr_events;
+	double percent_max = 0.0;
 	char bf[256];
 
-	if (dl->offset != -1 && bdl->percent != 0.0) {
-		ui_browser__set_percent_color(browser, bdl->percent, current_entry);
-		slsmg_printf("%6.2f ", bdl->percent);
+	for (i = 0; i < ab->nr_events; i++) {
+		if (bdl->percent[i] > percent_max)
+			percent_max = bdl->percent[i];
+	}
+
+	if (dl->offset != -1 && percent_max != 0.0) {
+		for (i = 0; i < ab->nr_events; i++) {
+			ui_browser__set_percent_color(browser, bdl->percent[i],
+						      current_entry);
+			slsmg_printf("%6.2f ", bdl->percent[i]);
+		}
 	} else {
 		ui_browser__set_percent_color(browser, 0, current_entry);
-		slsmg_write_nstring(" ", 7);
+		slsmg_write_nstring(" ", pcnt_width);
 	}
 
 	SLsmg_write_char(' ');
@@ -111,12 +126,12 @@ static void annotate_browser__write(struct ui_browser *browser, void *entry, int
 		width += 1;
 
 	if (!*dl->line)
-		slsmg_write_nstring(" ", width - 7);
+		slsmg_write_nstring(" ", width - pcnt_width);
 	else if (dl->offset == -1) {
 		printed = scnprintf(bf, sizeof(bf), "%*s  ",
 				    ab->addr_width, " ");
 		slsmg_write_nstring(bf, printed);
-		slsmg_write_nstring(dl->line, width - printed - 6);
+		slsmg_write_nstring(dl->line, width - printed - pcnt_width + 1);
 	} else {
 		u64 addr = dl->offset;
 		int color = -1;
@@ -175,7 +190,7 @@ static void annotate_browser__write(struct ui_browser *browser, void *entry, int
 		}
 
 		disasm_line__scnprintf(dl, bf, sizeof(bf), !annotate_browser__opts.use_offset);
-		slsmg_write_nstring(bf, width - 10 - printed);
+		slsmg_write_nstring(bf, width - pcnt_width - 3 - printed);
 	}
 
 	if (current_entry)
@@ -200,6 +215,7 @@ static void annotate_browser__draw_current_jump(struct ui_browser *browser)
 	unsigned int from, to;
 	struct map_symbol *ms = ab->b.priv;
 	struct symbol *sym = ms->sym;
+	u8 pcnt_width = 7;
 
 	/* PLT symbols contain external offsets */
 	if (strstr(sym->name, "@plt"))
@@ -223,57 +239,44 @@ static void annotate_browser__draw_current_jump(struct ui_browser *browser)
 		to = (u64)btarget->idx;
 	}
 
+	pcnt_width *= ab->nr_events;
+
 	ui_browser__set_color(browser, HE_COLORSET_CODE);
-	__ui_browser__line_arrow(browser, 9 + ab->addr_width, from, to);
+	__ui_browser__line_arrow(browser, pcnt_width + 2 + ab->addr_width,
+				 from, to);
 }
 
 static unsigned int annotate_browser__refresh(struct ui_browser *browser)
 {
+	struct annotate_browser *ab = container_of(browser, struct annotate_browser, b);
 	int ret = ui_browser__list_head_refresh(browser);
+	int pcnt_width;
+
+	pcnt_width = 7 * ab->nr_events;
 
 	if (annotate_browser__opts.jump_arrows)
 		annotate_browser__draw_current_jump(browser);
 
 	ui_browser__set_color(browser, HE_COLORSET_NORMAL);
-	__ui_browser__vline(browser, 7, 0, browser->height - 1);
+	__ui_browser__vline(browser, pcnt_width, 0, browser->height - 1);
 	return ret;
 }
 
-static double disasm_line__calc_percent(struct disasm_line *dl, struct symbol *sym, int evidx)
+static int disasm__cmp(struct browser_disasm_line *a,
+		       struct browser_disasm_line *b, int nr_pcnt)
 {
-	double percent = 0.0;
-
-	if (dl->offset != -1) {
-		int len = sym->end - sym->start;
-		unsigned int hits = 0;
-		struct annotation *notes = symbol__annotation(sym);
-		struct source_line *src_line = notes->src->lines;
-		struct sym_hist *h = annotation__histogram(notes, evidx);
-		s64 offset = dl->offset;
-		struct disasm_line *next;
+	int i;
 
-		next = disasm__get_next_ip_line(&notes->src->source, dl);
-		while (offset < (s64)len &&
-		       (next == NULL || offset < next->offset)) {
-			if (src_line) {
-				percent += src_line[offset].percent;
-			} else
-				hits += h->addr[offset];
-
-			++offset;
-		}
-		/*
- 		 * If the percentage wasn't already calculated in
- 		 * symbol__get_source_line, do it now:
- 		 */
-		if (src_line == NULL && h->sum)
-			percent = 100.0 * hits / h->sum;
+	for (i = 0; i < nr_pcnt; i++) {
+		if (a->percent[i] == b->percent[i])
+			continue;
+		return a->percent[i] < b->percent[i];
 	}
-
-	return percent;
+	return 0;
 }
 
-static void disasm_rb_tree__insert(struct rb_root *root, struct browser_disasm_line *bdl)
+static void disasm_rb_tree__insert(struct rb_root *root, struct browser_disasm_line *bdl,
+				   int nr_events)
 {
 	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
@@ -282,7 +285,8 @@ static void disasm_rb_tree__insert(struct rb_root *root, struct browser_disasm_l
 	while (*p != NULL) {
 		parent = *p;
 		l = rb_entry(parent, struct browser_disasm_line, rb_node);
-		if (bdl->percent < l->percent)
+
+		if (disasm__cmp(bdl, l, nr_events))
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
@@ -331,12 +335,13 @@ static void annotate_browser__set_rb_top(struct annotate_browser *browser,
 }
 
 static void annotate_browser__calc_percent(struct annotate_browser *browser,
-					   int evidx)
+					   struct perf_evsel *evsel)
 {
 	struct map_symbol *ms = browser->b.priv;
 	struct symbol *sym = ms->sym;
 	struct annotation *notes = symbol__annotation(sym);
-	struct disasm_line *pos;
+	struct disasm_line *pos, *next;
+	s64 len = symbol__size(sym);
 
 	browser->entries = RB_ROOT;
 
@@ -344,12 +349,34 @@ static void annotate_browser__calc_percent(struct annotate_browser *browser,
 
 	list_for_each_entry(pos, &notes->src->source, node) {
 		struct browser_disasm_line *bpos = disasm_line__browser(pos);
-		bpos->percent = disasm_line__calc_percent(pos, sym, evidx);
-		if (bpos->percent < 0.01) {
+		const char *path = NULL;
+		double max_percent = 0.0;
+		int i;
+
+		if (pos->offset == -1) {
+			RB_CLEAR_NODE(&bpos->rb_node);
+			continue;
+		}
+
+		next = disasm__get_next_ip_line(&notes->src->source, pos);
+
+		for (i = 0; i < browser->nr_events; i++) {
+			bpos->percent[i] = disasm__calc_percent(notes,
+						evsel->idx + i,
+						pos->offset,
+						next ? next->offset : len,
+					        &path);
+
+			if (max_percent < bpos->percent[i])
+				max_percent = bpos->percent[i];
+		}
+
+		if (max_percent < 0.01) {
 			RB_CLEAR_NODE(&bpos->rb_node);
 			continue;
 		}
-		disasm_rb_tree__insert(&browser->entries, bpos);
+		disasm_rb_tree__insert(&browser->entries, bpos,
+				       browser->nr_events);
 	}
 	pthread_mutex_unlock(&notes->lock);
 
@@ -401,7 +428,8 @@ static void annotate_browser__init_asm_mode(struct annotate_browser *browser)
 	browser->b.nr_entries = browser->nr_asm_entries;
 }
 
-static bool annotate_browser__callq(struct annotate_browser *browser, int evidx,
+static bool annotate_browser__callq(struct annotate_browser *browser,
+				    struct perf_evsel *evsel,
 				    struct hist_browser_timer *hbt)
 {
 	struct map_symbol *ms = browser->b.priv;
@@ -432,7 +460,7 @@ static bool annotate_browser__callq(struct annotate_browser *browser, int evidx,
 	}
 
 	pthread_mutex_unlock(&notes->lock);
-	symbol__tui_annotate(target, ms->map, evidx, hbt);
+	symbol__tui_annotate(target, ms->map, evsel, hbt);
 	ui_browser__show_title(&browser->b, sym->name);
 	return true;
 }
@@ -615,7 +643,8 @@ static void annotate_browser__update_addr_width(struct annotate_browser *browser
 		browser->addr_width += browser->jumps_width + 1;
 }
 
-static int annotate_browser__run(struct annotate_browser *browser, int evidx,
+static int annotate_browser__run(struct annotate_browser *browser,
+				 struct perf_evsel *evsel,
 				 struct hist_browser_timer *hbt)
 {
 	struct rb_node *nd = NULL;
@@ -628,7 +657,7 @@ static int annotate_browser__run(struct annotate_browser *browser, int evidx,
 	if (ui_browser__show(&browser->b, sym->name, help) < 0)
 		return -1;
 
-	annotate_browser__calc_percent(browser, evidx);
+	annotate_browser__calc_percent(browser, evsel);
 
 	if (browser->curr_hot) {
 		annotate_browser__set_rb_top(browser, browser->curr_hot);
@@ -641,7 +670,7 @@ static int annotate_browser__run(struct annotate_browser *browser, int evidx,
 		key = ui_browser__run(&browser->b, delay_secs);
 
 		if (delay_secs != 0) {
-			annotate_browser__calc_percent(browser, evidx);
+			annotate_browser__calc_percent(browser, evsel);
 			/*
 			 * Current line focus got out of the list of most active
 			 * lines, NULL it so that if TAB|UNTAB is pressed, we
@@ -657,7 +686,7 @@ static int annotate_browser__run(struct annotate_browser *browser, int evidx,
 				hbt->timer(hbt->arg);
 
 			if (delay_secs != 0)
-				symbol__annotate_decay_histogram(sym, evidx);
+				symbol__annotate_decay_histogram(sym, evsel->idx);
 			continue;
 		case K_TAB:
 			if (nd != NULL) {
@@ -754,7 +783,7 @@ show_help:
 					goto show_sup_ins;
 				goto out;
 			} else if (!(annotate_browser__jump(browser) ||
-				     annotate_browser__callq(browser, evidx, hbt))) {
+				     annotate_browser__callq(browser, evsel, hbt))) {
 show_sup_ins:
 				ui_helpline__puts("Actions are only available for 'callq', 'retq' & jump instructions.");
 			}
@@ -776,10 +805,10 @@ out:
 	return key;
 }
 
-int hist_entry__tui_annotate(struct hist_entry *he, int evidx,
+int hist_entry__tui_annotate(struct hist_entry *he, struct perf_evsel *evsel,
 			     struct hist_browser_timer *hbt)
 {
-	return symbol__tui_annotate(he->ms.sym, he->ms.map, evidx, hbt);
+	return symbol__tui_annotate(he->ms.sym, he->ms.map, evsel, hbt);
 }
 
 static void annotate_browser__mark_jump_targets(struct annotate_browser *browser,
@@ -826,7 +855,8 @@ static inline int width_jumps(int n)
 	return 1;
 }
 
-int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
+int symbol__tui_annotate(struct symbol *sym, struct map *map,
+			 struct perf_evsel *evsel,
 			 struct hist_browser_timer *hbt)
 {
 	struct disasm_line *pos, *n;
@@ -847,6 +877,8 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 		},
 	};
 	int ret = -1;
+	int nr_pcnt = 1;
+	size_t sizeof_bdl = sizeof(struct browser_disasm_line);
 
 	if (sym == NULL)
 		return -1;
@@ -862,7 +894,12 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 		return -1;
 	}
 
-	if (symbol__annotate(sym, map, sizeof(struct browser_disasm_line)) < 0) {
+	if (perf_evsel__is_group_event(evsel)) {
+		nr_pcnt = evsel->nr_members;
+		sizeof_bdl += sizeof(double) * (nr_pcnt - 1);
+	}
+
+	if (symbol__annotate(sym, map, sizeof_bdl) < 0) {
 		ui__error("%s", ui_helpline__last_msg);
 		goto out_free_offsets;
 	}
@@ -900,6 +937,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 	browser.addr_width = browser.target_width = browser.min_addr_width = hex_width(size);
 	browser.max_addr_width = hex_width(sym->end);
 	browser.jumps_width = width_jumps(browser.max_jump_sources);
+	browser.nr_events = nr_pcnt;
 	browser.b.nr_entries = browser.nr_entries;
 	browser.b.entries = &notes->src->source,
 	browser.b.width += 18; /* Percentage */
@@ -909,7 +947,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 
 	annotate_browser__update_addr_width(&browser);
 
-	ret = annotate_browser__run(&browser, evidx, hbt);
+	ret = annotate_browser__run(&browser, evsel, hbt);
 	list_for_each_entry_safe(pos, n, &notes->src->source, node) {
 		list_del(&pos->node);
 		disasm_line__free(pos);
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index aa22704..d88a2d0 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -2,7 +2,6 @@
 #include "../libslang.h"
 #include <stdlib.h>
 #include <string.h>
-#include <newt.h>
 #include <linux/rbtree.h>
 
 #include "../../util/evsel.h"
@@ -1193,7 +1192,7 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size,
 	char buf[512];
 	size_t buflen = sizeof(buf);
 
-	if (symbol_conf.event_group && evsel->nr_members > 1) {
+	if (perf_evsel__is_group_event(evsel)) {
 		struct perf_evsel *pos;
 
 		perf_evsel__group_desc(evsel, buf, buflen);
@@ -1599,7 +1598,7 @@ do_annotate:
 			 * Don't let this be freed, say, by hists__decay_entry.
 			 */
 			he->used = true;
-			err = hist_entry__tui_annotate(he, evsel->idx, hbt);
+			err = hist_entry__tui_annotate(he, evsel, hbt);
 			he->used = false;
 			/*
 			 * offer option to annotate the other branch source or target
@@ -1709,7 +1708,7 @@ static void perf_evsel_menu__write(struct ui_browser *browser,
 	ui_browser__set_color(browser, current_entry ? HE_COLORSET_SELECTED :
 						       HE_COLORSET_NORMAL);
 
-	if (symbol_conf.event_group && evsel->nr_members > 1) {
+	if (perf_evsel__is_group_event(evsel)) {
 		struct perf_evsel *pos;
 
 		ev_name = perf_evsel__group_name(evsel);
diff --git a/tools/perf/ui/browsers/map.c b/tools/perf/ui/browsers/map.c
index 98851d5..95c7cfb 100644
--- a/tools/perf/ui/browsers/map.c
+++ b/tools/perf/ui/browsers/map.c
@@ -1,6 +1,5 @@
 #include "../libslang.h"
 #include <elf.h>
-#include <newt.h>
 #include <inttypes.h>
 #include <sys/ttydefaults.h>
 #include <string.h>
@@ -10,41 +9,9 @@
 #include "../../util/symbol.h"
 #include "../browser.h"
 #include "../helpline.h"
+#include "../keysyms.h"
 #include "map.h"
 
-static int ui_entry__read(const char *title, char *bf, size_t size, int width)
-{
-	struct newtExitStruct es;
-	newtComponent form, entry;
-	const char *result;
-	int err = -1;
-
-	newtCenteredWindow(width, 1, title);
-	form = newtForm(NULL, NULL, 0);
-	if (form == NULL)
-		return -1;
-
-	entry = newtEntry(0, 0, "0x", width, &result, NEWT_FLAG_SCROLL);
-	if (entry == NULL)
-		goto out_free_form;
-
-	newtFormAddComponent(form, entry);
-	newtFormAddHotKey(form, NEWT_KEY_ENTER);
-	newtFormAddHotKey(form, NEWT_KEY_ESCAPE);
-	newtFormAddHotKey(form, NEWT_KEY_LEFT);
-	newtFormAddHotKey(form, CTRL('c'));
-	newtFormRun(form, &es);
-
-	if (result != NULL) {
-		strncpy(bf, result, size);
-		err = 0;
-	}
-out_free_form:
-	newtPopWindow();
-	newtFormDestroy(form);
-	return err;
-}
-
 struct map_browser {
 	struct ui_browser b;
 	struct map	  *map;
@@ -78,10 +45,11 @@ static int map_browser__search(struct map_browser *self)
 {
 	char target[512];
 	struct symbol *sym;
-	int err = ui_entry__read("Search by name/addr", target, sizeof(target), 40);
-
-	if (err)
-		return err;
+	int err = ui_browser__input_window("Search by name/addr",
+					   "Prefix with 0x to search by address",
+					   target, "ENTER: OK, ESC: Cancel", 0);
+	if (err != K_ENTER)
+		return -1;
 
 	if (target[0] == '0' && tolower(target[1]) == 'x') {
 		u64 addr = strtoull(target, NULL, 16);
@@ -112,12 +80,20 @@ static int map_browser__run(struct map_browser *self)
 	while (1) {
 		key = ui_browser__run(&self->b, 0);
 
-		if (verbose && key == '/')
-			map_browser__search(self);
-		else
+		switch (key) {
+		case '/':
+			if (verbose)
+				map_browser__search(self);
+		default:
 			break;
+                case K_LEFT:
+                case K_ESC:
+                case 'q':
+                case CTRL('c'):
+                        goto out;
+		}
 	}
-
+out:
 	ui_browser__hide(&self->b);
 	return key;
 }
diff --git a/tools/perf/ui/browsers/scripts.c b/tools/perf/ui/browsers/scripts.c
index cbbd44b..12f009e 100644
--- a/tools/perf/ui/browsers/scripts.c
+++ b/tools/perf/ui/browsers/scripts.c
@@ -1,5 +1,4 @@
 #include <elf.h>
-#include <newt.h>
 #include <inttypes.h>
 #include <sys/ttydefaults.h>
 #include <string.h>
diff --git a/tools/perf/ui/gtk/annotate.c b/tools/perf/ui/gtk/annotate.c
index 7d8dc58..f538794 100644
--- a/tools/perf/ui/gtk/annotate.c
+++ b/tools/perf/ui/gtk/annotate.c
@@ -1,6 +1,7 @@
 #include "gtk.h"
 #include "util/debug.h"
 #include "util/annotate.h"
+#include "util/evsel.h"
 #include "ui/helpline.h"
 
 
@@ -32,7 +33,7 @@ static int perf_gtk__get_percent(char *buf, size_t size, struct symbol *sym,
 		return 0;
 
 	symhist = annotation__histogram(symbol__annotation(sym), evidx);
-	if (!symhist->addr[dl->offset])
+	if (!symbol_conf.event_group && !symhist->addr[dl->offset])
 		return 0;
 
 	percent = 100.0 * symhist->addr[dl->offset] / symhist->sum;
@@ -85,7 +86,7 @@ static int perf_gtk__get_line(char *buf, size_t size, struct disasm_line *dl)
 }
 
 static int perf_gtk__annotate_symbol(GtkWidget *window, struct symbol *sym,
-				struct map *map, int evidx,
+				struct map *map, struct perf_evsel *evsel,
 				struct hist_browser_timer *hbt __maybe_unused)
 {
 	struct disasm_line *pos, *n;
@@ -118,10 +119,24 @@ static int perf_gtk__annotate_symbol(GtkWidget *window, struct symbol *sym,
 
 	list_for_each_entry(pos, &notes->src->source, node) {
 		GtkTreeIter iter;
+		int ret = 0;
 
 		gtk_list_store_append(store, &iter);
 
-		if (perf_gtk__get_percent(s, sizeof(s), sym, pos, evidx))
+		if (perf_evsel__is_group_event(evsel)) {
+			for (i = 0; i < evsel->nr_members; i++) {
+				ret += perf_gtk__get_percent(s + ret,
+							     sizeof(s) - ret,
+							     sym, pos,
+							     evsel->idx + i);
+				ret += scnprintf(s + ret, sizeof(s) - ret, " ");
+			}
+		} else {
+			ret = perf_gtk__get_percent(s, sizeof(s), sym, pos,
+						    evsel->idx);
+		}
+
+		if (ret)
 			gtk_list_store_set(store, &iter, ANN_COL__PERCENT, s, -1);
 		if (perf_gtk__get_offset(s, sizeof(s), sym, map, pos))
 			gtk_list_store_set(store, &iter, ANN_COL__OFFSET, s, -1);
@@ -139,7 +154,8 @@ static int perf_gtk__annotate_symbol(GtkWidget *window, struct symbol *sym,
 	return 0;
 }
 
-int symbol__gtk_annotate(struct symbol *sym, struct map *map, int evidx,
+int symbol__gtk_annotate(struct symbol *sym, struct map *map,
+			 struct perf_evsel *evsel,
 			 struct hist_browser_timer *hbt)
 {
 	GtkWidget *window;
@@ -206,7 +222,7 @@ int symbol__gtk_annotate(struct symbol *sym, struct map *map, int evidx,
 	gtk_notebook_append_page(GTK_NOTEBOOK(notebook), scrolled_window,
 				 tab_label);
 
-	perf_gtk__annotate_symbol(scrolled_window, sym, map, evidx, hbt);
+	perf_gtk__annotate_symbol(scrolled_window, sym, map, evsel, hbt);
 	return 0;
 }
 
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 1e764a8..6f259b3 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -32,21 +32,18 @@ static int __hpp__color_fmt(struct perf_hpp *hpp, struct hist_entry *he,
 	int ret;
 	double percent = 0.0;
 	struct hists *hists = he->hists;
+	struct perf_evsel *evsel = hists_to_evsel(hists);
 
 	if (hists->stats.total_period)
 		percent = 100.0 * get_field(he) / hists->stats.total_period;
 
 	ret = __percent_color_snprintf(hpp->buf, hpp->size, percent);
 
-	if (symbol_conf.event_group) {
+	if (perf_evsel__is_group_event(evsel)) {
 		int prev_idx, idx_delta;
-		struct perf_evsel *evsel = hists_to_evsel(hists);
 		struct hist_entry *pair;
 		int nr_members = evsel->nr_members;
 
-		if (nr_members <= 1)
-			return ret;
-
 		prev_idx = perf_evsel__group_idx(evsel);
 
 		list_for_each_entry(pair, &he->pairs.head, pairs.node) {
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index d671e63..4bf91b0 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -16,6 +16,7 @@ static int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 {
 	int ret;
 	struct hists *hists = he->hists;
+	struct perf_evsel *evsel = hists_to_evsel(hists);
 
 	if (fmt_percent) {
 		double percent = 0.0;
@@ -28,15 +29,11 @@ static int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 	} else
 		ret = print_fn(hpp->buf, hpp->size, fmt, get_field(he));
 
-	if (symbol_conf.event_group) {
+	if (perf_evsel__is_group_event(evsel)) {
 		int prev_idx, idx_delta;
-		struct perf_evsel *evsel = hists_to_evsel(hists);
 		struct hist_entry *pair;
 		int nr_members = evsel->nr_members;
 
-		if (nr_members <= 1)
-			return ret;
-
 		prev_idx = perf_evsel__group_idx(evsel);
 
 		list_for_each_entry(pair, &he->pairs.head, pairs.node) {
diff --git a/tools/perf/ui/tui/setup.c b/tools/perf/ui/tui/setup.c
index 81efa19..b940148 100644
--- a/tools/perf/ui/tui/setup.c
+++ b/tools/perf/ui/tui/setup.c
@@ -1,4 +1,3 @@
-#include <newt.h>
 #include <signal.h>
 #include <stdbool.h>
 
@@ -88,13 +87,6 @@ int ui__getch(int delay_secs)
 	return SLkp_getkey();
 }
 
-static void newt_suspend(void *d __maybe_unused)
-{
-	newtSuspend();
-	raise(SIGTSTP);
-	newtResume();
-}
-
 static void ui__signal(int sig)
 {
 	ui__exit(false);
@@ -106,7 +98,17 @@ int ui__init(void)
 {
 	int err;
 
-	newtInit();
+	SLutf8_enable(-1);
+	SLtt_get_terminfo();
+	SLtt_get_screen_size();
+
+	err = SLsmg_init_smg();
+	if (err < 0)
+		goto out;
+	err = SLang_init_tty(0, 0, 0);
+	if (err < 0)
+		goto out;
+
 	err = SLkp_init();
 	if (err < 0) {
 		pr_err("TUI initialization failed.\n");
@@ -115,7 +117,6 @@ int ui__init(void)
 
 	SLkp_define_keysym((char *)"^(kB)", SL_KEY_UNTAB);
 
-	newtSetSuspendCallback(newt_suspend, NULL);
 	ui_helpline__init();
 	ui_browser__init();
 	ui_progress__init();
diff --git a/tools/perf/ui/ui.h b/tools/perf/ui/ui.h
index d86359c..70cb0d4 100644
--- a/tools/perf/ui/ui.h
+++ b/tools/perf/ui/ui.h
@@ -12,7 +12,7 @@ extern int use_browser;
 void setup_browser(bool fallback_to_pager);
 void exit_browser(bool wait_for_ok);
 
-#ifdef NEWT_SUPPORT
+#ifdef SLANG_SUPPORT
 int ui__init(void);
 void ui__exit(bool wait_for_ok);
 #else
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index d33fe93..d102716 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -14,6 +14,7 @@
 #include "symbol.h"
 #include "debug.h"
 #include "annotate.h"
+#include "evsel.h"
 #include <pthread.h>
 #include <linux/bitops.h>
 
@@ -602,8 +603,42 @@ struct disasm_line *disasm__get_next_ip_line(struct list_head *head, struct disa
 	return NULL;
 }
 
+double disasm__calc_percent(struct annotation *notes, int evidx, s64 offset,
+			    s64 end, const char **path)
+{
+	struct source_line *src_line = notes->src->lines;
+	double percent = 0.0;
+
+	if (src_line) {
+		size_t sizeof_src_line = sizeof(*src_line) +
+				sizeof(src_line->p) * (src_line->nr_pcnt - 1);
+
+		while (offset < end) {
+			src_line = (void *)notes->src->lines +
+					(sizeof_src_line * offset);
+
+			if (*path == NULL)
+				*path = src_line->path;
+
+			percent += src_line->p[evidx].percent;
+			offset++;
+		}
+	} else {
+		struct sym_hist *h = annotation__histogram(notes, evidx);
+		unsigned int hits = 0;
+
+		while (offset < end)
+			hits += h->addr[offset++];
+
+		if (h->sum)
+			percent = 100.0 * hits / h->sum;
+	}
+
+	return percent;
+}
+
 static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 start,
-		      int evidx, u64 len, int min_pcnt, int printed,
+		      struct perf_evsel *evsel, u64 len, int min_pcnt, int printed,
 		      int max_lines, struct disasm_line *queue)
 {
 	static const char *prev_line;
@@ -611,34 +646,37 @@ static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 st
 
 	if (dl->offset != -1) {
 		const char *path = NULL;
-		unsigned int hits = 0;
-		double percent = 0.0;
+		double percent, max_percent = 0.0;
+		double *ppercents = &percent;
+		int i, nr_percent = 1;
 		const char *color;
 		struct annotation *notes = symbol__annotation(sym);
-		struct source_line *src_line = notes->src->lines;
-		struct sym_hist *h = annotation__histogram(notes, evidx);
 		s64 offset = dl->offset;
 		const u64 addr = start + offset;
 		struct disasm_line *next;
 
 		next = disasm__get_next_ip_line(&notes->src->source, dl);
 
-		while (offset < (s64)len &&
-		       (next == NULL || offset < next->offset)) {
-			if (src_line) {
-				if (path == NULL)
-					path = src_line[offset].path;
-				percent += src_line[offset].percent;
-			} else
-				hits += h->addr[offset];
-
-			++offset;
+		if (perf_evsel__is_group_event(evsel)) {
+			nr_percent = evsel->nr_members;
+			ppercents = calloc(nr_percent, sizeof(double));
+			if (ppercents == NULL)
+				return -1;
 		}
 
-		if (src_line == NULL && h->sum)
-			percent = 100.0 * hits / h->sum;
+		for (i = 0; i < nr_percent; i++) {
+			percent = disasm__calc_percent(notes,
+					notes->src->lines ? i : evsel->idx + i,
+					offset,
+					next ? next->offset : (s64) len,
+					&path);
+
+			ppercents[i] = percent;
+			if (percent > max_percent)
+				max_percent = percent;
+		}
 
-		if (percent < min_pcnt)
+		if (max_percent < min_pcnt)
 			return -1;
 
 		if (max_lines && printed >= max_lines)
@@ -648,12 +686,12 @@ static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 st
 			list_for_each_entry_from(queue, &notes->src->source, node) {
 				if (queue == dl)
 					break;
-				disasm_line__print(queue, sym, start, evidx, len,
+				disasm_line__print(queue, sym, start, evsel, len,
 						    0, 0, 1, NULL);
 			}
 		}
 
-		color = get_percent_color(percent);
+		color = get_percent_color(max_percent);
 
 		/*
 		 * Also color the filename and line if needed, with
@@ -669,25 +707,59 @@ static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 st
 			}
 		}
 
-		color_fprintf(stdout, color, " %7.2f", percent);
+		for (i = 0; i < nr_percent; i++) {
+			percent = ppercents[i];
+			color = get_percent_color(percent);
+			color_fprintf(stdout, color, " %7.2f", percent);
+		}
+
 		printf(" :	");
 		color_fprintf(stdout, PERF_COLOR_MAGENTA, "  %" PRIx64 ":", addr);
 		color_fprintf(stdout, PERF_COLOR_BLUE, "%s\n", dl->line);
+
+		if (ppercents != &percent)
+			free(ppercents);
+
 	} else if (max_lines && printed >= max_lines)
 		return 1;
 	else {
+		int width = 8;
+
 		if (queue)
 			return -1;
 
+		if (perf_evsel__is_group_event(evsel))
+			width *= evsel->nr_members;
+
 		if (!*dl->line)
-			printf("         :\n");
+			printf(" %*s:\n", width, " ");
 		else
-			printf("         :	%s\n", dl->line);
+			printf(" %*s:	%s\n", width, " ", dl->line);
 	}
 
 	return 0;
 }
 
+/*
+ * symbol__parse_objdump_line() parses objdump output (with -d --no-show-raw)
+ * which looks like following
+ *
+ *  0000000000415500 <_init>:
+ *    415500:       sub    $0x8,%rsp
+ *    415504:       mov    0x2f5ad5(%rip),%rax        # 70afe0 <_DYNAMIC+0x2f8>
+ *    41550b:       test   %rax,%rax
+ *    41550e:       je     415515 <_init+0x15>
+ *    415510:       callq  416e70 <__gmon_start__@plt>
+ *    415515:       add    $0x8,%rsp
+ *    415519:       retq
+ *
+ * it will be parsed and saved into struct disasm_line as
+ *  <offset>       <name>  <ops.raw>
+ *
+ * The offset will be a relative offset from the start of the symbol and -1
+ * means that it's not a disassembly line so should be treated differently.
+ * The ops.raw part will be parsed further according to type of the instruction.
+ */
 static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
 				      FILE *file, size_t privsize)
 {
@@ -858,7 +930,7 @@ static void insert_source_line(struct rb_root *root, struct source_line *src_lin
 	struct source_line *iter;
 	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
-	int ret;
+	int i, ret;
 
 	while (*p != NULL) {
 		parent = *p;
@@ -866,7 +938,8 @@ static void insert_source_line(struct rb_root *root, struct source_line *src_lin
 
 		ret = strcmp(iter->path, src_line->path);
 		if (ret == 0) {
-			iter->percent_sum += src_line->percent;
+			for (i = 0; i < src_line->nr_pcnt; i++)
+				iter->p[i].percent_sum += src_line->p[i].percent;
 			return;
 		}
 
@@ -876,12 +949,26 @@ static void insert_source_line(struct rb_root *root, struct source_line *src_lin
 			p = &(*p)->rb_right;
 	}
 
-	src_line->percent_sum = src_line->percent;
+	for (i = 0; i < src_line->nr_pcnt; i++)
+		src_line->p[i].percent_sum = src_line->p[i].percent;
 
 	rb_link_node(&src_line->node, parent, p);
 	rb_insert_color(&src_line->node, root);
 }
 
+static int cmp_source_line(struct source_line *a, struct source_line *b)
+{
+	int i;
+
+	for (i = 0; i < a->nr_pcnt; i++) {
+		if (a->p[i].percent_sum == b->p[i].percent_sum)
+			continue;
+		return a->p[i].percent_sum > b->p[i].percent_sum;
+	}
+
+	return 0;
+}
+
 static void __resort_source_line(struct rb_root *root, struct source_line *src_line)
 {
 	struct source_line *iter;
@@ -892,7 +979,7 @@ static void __resort_source_line(struct rb_root *root, struct source_line *src_l
 		parent = *p;
 		iter = rb_entry(parent, struct source_line, node);
 
-		if (src_line->percent_sum > iter->percent_sum)
+		if (cmp_source_line(src_line, iter))
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
@@ -924,32 +1011,52 @@ static void symbol__free_source_line(struct symbol *sym, int len)
 {
 	struct annotation *notes = symbol__annotation(sym);
 	struct source_line *src_line = notes->src->lines;
+	size_t sizeof_src_line;
 	int i;
 
-	for (i = 0; i < len; i++)
-		free(src_line[i].path);
+	sizeof_src_line = sizeof(*src_line) +
+			  (sizeof(src_line->p) * (src_line->nr_pcnt - 1));
+
+	for (i = 0; i < len; i++) {
+		free(src_line->path);
+		src_line = (void *)src_line + sizeof_src_line;
+	}
 
-	free(src_line);
+	free(notes->src->lines);
 	notes->src->lines = NULL;
 }
 
 /* Get the filename:line for the colored entries */
 static int symbol__get_source_line(struct symbol *sym, struct map *map,
-				   int evidx, struct rb_root *root, int len,
+				   struct perf_evsel *evsel,
+				   struct rb_root *root, int len,
 				   const char *filename)
 {
 	u64 start;
-	int i;
+	int i, k;
+	int evidx = evsel->idx;
 	char cmd[PATH_MAX * 2];
 	struct source_line *src_line;
 	struct annotation *notes = symbol__annotation(sym);
 	struct sym_hist *h = annotation__histogram(notes, evidx);
 	struct rb_root tmp_root = RB_ROOT;
+	int nr_pcnt = 1;
+	u64 h_sum = h->sum;
+	size_t sizeof_src_line = sizeof(struct source_line);
+
+	if (perf_evsel__is_group_event(evsel)) {
+		for (i = 1; i < evsel->nr_members; i++) {
+			h = annotation__histogram(notes, evidx + i);
+			h_sum += h->sum;
+		}
+		nr_pcnt = evsel->nr_members;
+		sizeof_src_line += (nr_pcnt - 1) * sizeof(src_line->p);
+	}
 
-	if (!h->sum)
+	if (!h_sum)
 		return 0;
 
-	src_line = notes->src->lines = calloc(len, sizeof(struct source_line));
+	src_line = notes->src->lines = calloc(len, sizeof_src_line);
 	if (!notes->src->lines)
 		return -1;
 
@@ -960,29 +1067,41 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 		size_t line_len;
 		u64 offset;
 		FILE *fp;
+		double percent_max = 0.0;
 
-		src_line[i].percent = 100.0 * h->addr[i] / h->sum;
-		if (src_line[i].percent <= 0.5)
-			continue;
+		src_line->nr_pcnt = nr_pcnt;
+
+		for (k = 0; k < nr_pcnt; k++) {
+			h = annotation__histogram(notes, evidx + k);
+			src_line->p[k].percent = 100.0 * h->addr[i] / h->sum;
+
+			if (src_line->p[k].percent > percent_max)
+				percent_max = src_line->p[k].percent;
+		}
+
+		if (percent_max <= 0.5)
+			goto next;
 
 		offset = start + i;
 		sprintf(cmd, "addr2line -e %s %016" PRIx64, filename, offset);
 		fp = popen(cmd, "r");
 		if (!fp)
-			continue;
+			goto next;
 
 		if (getline(&path, &line_len, fp) < 0 || !line_len)
-			goto next;
+			goto next_close;
 
-		src_line[i].path = malloc(sizeof(char) * line_len + 1);
-		if (!src_line[i].path)
-			goto next;
+		src_line->path = malloc(sizeof(char) * line_len + 1);
+		if (!src_line->path)
+			goto next_close;
 
-		strcpy(src_line[i].path, path);
-		insert_source_line(&tmp_root, &src_line[i]);
+		strcpy(src_line->path, path);
+		insert_source_line(&tmp_root, src_line);
 
-	next:
+	next_close:
 		pclose(fp);
+	next:
+		src_line = (void *)src_line + sizeof_src_line;
 	}
 
 	resort_source_line(root, &tmp_root);
@@ -1004,24 +1123,33 @@ static void print_summary(struct rb_root *root, const char *filename)
 
 	node = rb_first(root);
 	while (node) {
-		double percent;
+		double percent, percent_max = 0.0;
 		const char *color;
 		char *path;
+		int i;
 
 		src_line = rb_entry(node, struct source_line, node);
-		percent = src_line->percent_sum;
-		color = get_percent_color(percent);
+		for (i = 0; i < src_line->nr_pcnt; i++) {
+			percent = src_line->p[i].percent_sum;
+			color = get_percent_color(percent);
+			color_fprintf(stdout, color, " %7.2f", percent);
+
+			if (percent > percent_max)
+				percent_max = percent;
+		}
+
 		path = src_line->path;
+		color = get_percent_color(percent_max);
+		color_fprintf(stdout, color, " %s", path);
 
-		color_fprintf(stdout, color, " %7.2f %s", percent, path);
 		node = rb_next(node);
 	}
 }
 
-static void symbol__annotate_hits(struct symbol *sym, int evidx)
+static void symbol__annotate_hits(struct symbol *sym, struct perf_evsel *evsel)
 {
 	struct annotation *notes = symbol__annotation(sym);
-	struct sym_hist *h = annotation__histogram(notes, evidx);
+	struct sym_hist *h = annotation__histogram(notes, evsel->idx);
 	u64 len = symbol__size(sym), offset;
 
 	for (offset = 0; offset < len; ++offset)
@@ -1031,9 +1159,9 @@ static void symbol__annotate_hits(struct symbol *sym, int evidx)
 	printf("%*s: %" PRIu64 "\n", BITS_PER_LONG / 2, "h->sum", h->sum);
 }
 
-int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
-			    bool full_paths, int min_pcnt, int max_lines,
-			    int context)
+int symbol__annotate_printf(struct symbol *sym, struct map *map,
+			    struct perf_evsel *evsel, bool full_paths,
+			    int min_pcnt, int max_lines, int context)
 {
 	struct dso *dso = map->dso;
 	char *filename;
@@ -1044,6 +1172,8 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
 	int printed = 2, queue_len = 0;
 	int more = 0;
 	u64 len;
+	int width = 8;
+	int namelen;
 
 	filename = strdup(dso->long_name);
 	if (!filename)
@@ -1055,12 +1185,18 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
 		d_filename = basename(filename);
 
 	len = symbol__size(sym);
+	namelen = strlen(d_filename);
+
+	if (perf_evsel__is_group_event(evsel))
+		width *= evsel->nr_members;
 
-	printf(" Percent |	Source code & Disassembly of %s\n", d_filename);
-	printf("------------------------------------------------\n");
+	printf(" %-*.*s|	Source code & Disassembly of %s\n",
+	       width, width, "Percent", d_filename);
+	printf("-%-*.*s-------------------------------------\n",
+	       width+namelen, width+namelen, graph_dotted_line);
 
 	if (verbose)
-		symbol__annotate_hits(sym, evidx);
+		symbol__annotate_hits(sym, evsel);
 
 	list_for_each_entry(pos, &notes->src->source, node) {
 		if (context && queue == NULL) {
@@ -1068,7 +1204,7 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
 			queue_len = 0;
 		}
 
-		switch (disasm_line__print(pos, sym, start, evidx, len,
+		switch (disasm_line__print(pos, sym, start, evsel, len,
 					    min_pcnt, printed, max_lines,
 					    queue)) {
 		case 0:
@@ -1163,9 +1299,9 @@ size_t disasm__fprintf(struct list_head *head, FILE *fp)
 	return printed;
 }
 
-int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
-			 bool print_lines, bool full_paths, int min_pcnt,
-			 int max_lines)
+int symbol__tty_annotate(struct symbol *sym, struct map *map,
+			 struct perf_evsel *evsel, bool print_lines,
+			 bool full_paths, int min_pcnt, int max_lines)
 {
 	struct dso *dso = map->dso;
 	const char *filename = dso->long_name;
@@ -1178,12 +1314,12 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 	len = symbol__size(sym);
 
 	if (print_lines) {
-		symbol__get_source_line(sym, map, evidx, &source_line,
+		symbol__get_source_line(sym, map, evsel, &source_line,
 					len, filename);
 		print_summary(&source_line, filename);
 	}
 
-	symbol__annotate_printf(sym, map, evidx, full_paths,
+	symbol__annotate_printf(sym, map, evsel, full_paths,
 				min_pcnt, max_lines, 0);
 	if (print_lines)
 		symbol__free_source_line(sym, len);
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index c422440..af75515 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -50,6 +50,8 @@ bool ins__is_jump(const struct ins *ins);
 bool ins__is_call(const struct ins *ins);
 int ins__scnprintf(struct ins *ins, char *bf, size_t size, struct ins_operands *ops);
 
+struct annotation;
+
 struct disasm_line {
 	struct list_head    node;
 	s64		    offset;
@@ -68,17 +70,24 @@ void disasm_line__free(struct disasm_line *dl);
 struct disasm_line *disasm__get_next_ip_line(struct list_head *head, struct disasm_line *pos);
 int disasm_line__scnprintf(struct disasm_line *dl, char *bf, size_t size, bool raw);
 size_t disasm__fprintf(struct list_head *head, FILE *fp);
+double disasm__calc_percent(struct annotation *notes, int evidx, s64 offset,
+			    s64 end, const char **path);
 
 struct sym_hist {
 	u64		sum;
 	u64		addr[0];
 };
 
-struct source_line {
-	struct rb_node	node;
+struct source_line_percent {
 	double		percent;
 	double		percent_sum;
+};
+
+struct source_line {
+	struct rb_node	node;
 	char		*path;
+	int		nr_pcnt;
+	struct source_line_percent p[1];
 };
 
 /** struct annotated_source - symbols with hits have this attached as in sannotation
@@ -130,47 +139,49 @@ void symbol__annotate_zero_histograms(struct symbol *sym);
 
 int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize);
 int symbol__annotate_init(struct map *map __maybe_unused, struct symbol *sym);
-int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
-			    bool full_paths, int min_pcnt, int max_lines,
-			    int context);
+int symbol__annotate_printf(struct symbol *sym, struct map *map,
+			    struct perf_evsel *evsel, bool full_paths,
+			    int min_pcnt, int max_lines, int context);
 void symbol__annotate_zero_histogram(struct symbol *sym, int evidx);
 void symbol__annotate_decay_histogram(struct symbol *sym, int evidx);
 void disasm__purge(struct list_head *head);
 
-int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
-			 bool print_lines, bool full_paths, int min_pcnt,
-			 int max_lines);
+int symbol__tty_annotate(struct symbol *sym, struct map *map,
+			 struct perf_evsel *evsel, bool print_lines,
+			 bool full_paths, int min_pcnt, int max_lines);
 
-#ifdef NEWT_SUPPORT
-int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
+#ifdef SLANG_SUPPORT
+int symbol__tui_annotate(struct symbol *sym, struct map *map,
+			 struct perf_evsel *evsel,
 			 struct hist_browser_timer *hbt);
 #else
 static inline int symbol__tui_annotate(struct symbol *sym __maybe_unused,
-				       struct map *map __maybe_unused,
-				       int evidx __maybe_unused,
-				       struct hist_browser_timer *hbt
-				       __maybe_unused)
+				struct map *map __maybe_unused,
+				struct perf_evsel *evsel  __maybe_unused,
+				struct hist_browser_timer *hbt
+				__maybe_unused)
 {
 	return 0;
 }
 #endif
 
 #ifdef GTK2_SUPPORT
-int symbol__gtk_annotate(struct symbol *sym, struct map *map, int evidx,
+int symbol__gtk_annotate(struct symbol *sym, struct map *map,
+			 struct perf_evsel *evsel,
 			 struct hist_browser_timer *hbt);
 
-static inline int hist_entry__gtk_annotate(struct hist_entry *he, int evidx,
+static inline int hist_entry__gtk_annotate(struct hist_entry *he,
+					   struct perf_evsel *evsel,
 					   struct hist_browser_timer *hbt)
 {
-	return symbol__gtk_annotate(he->ms.sym, he->ms.map, evidx, hbt);
+	return symbol__gtk_annotate(he->ms.sym, he->ms.map, evsel, hbt);
 }
 
 void perf_gtk__show_annotations(void);
 #else
 static inline int hist_entry__gtk_annotate(struct hist_entry *he __maybe_unused,
-					   int evidx __maybe_unused,
-					   struct hist_browser_timer *hbt
-					   __maybe_unused)
+				struct perf_evsel *evsel __maybe_unused,
+				struct hist_browser_timer *hbt __maybe_unused)
 {
 	return 0;
 }
diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index f817046..beb8cf9 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -4,6 +4,7 @@
 #include "cpumap.h"
 #include <assert.h>
 #include <stdio.h>
+#include <stdlib.h>
 
 static struct cpu_map *cpu_map__default_new(void)
 {
@@ -219,7 +220,7 @@ int cpu_map__get_socket(struct cpu_map *map, int idx)
 	if (!mnt)
 		return -1;
 
-	sprintf(path,
+	snprintf(path, PATH_MAX,
 		"%s/devices/system/cpu/cpu%d/topology/physical_package_id",
 		mnt, cpu);
 
@@ -231,27 +232,88 @@ int cpu_map__get_socket(struct cpu_map *map, int idx)
 	return ret == 1 ? cpu : -1;
 }
 
-int cpu_map__build_socket_map(struct cpu_map *cpus, struct cpu_map **sockp)
+static int cmp_ids(const void *a, const void *b)
 {
-	struct cpu_map *sock;
+	return *(int *)a - *(int *)b;
+}
+
+static int cpu_map__build_map(struct cpu_map *cpus, struct cpu_map **res,
+			      int (*f)(struct cpu_map *map, int cpu))
+{
+	struct cpu_map *c;
 	int nr = cpus->nr;
 	int cpu, s1, s2;
 
-	sock = calloc(1, sizeof(*sock) + nr * sizeof(int));
-	if (!sock)
+	/* allocate as much as possible */
+	c = calloc(1, sizeof(*c) + nr * sizeof(int));
+	if (!c)
 		return -1;
 
 	for (cpu = 0; cpu < nr; cpu++) {
-		s1 = cpu_map__get_socket(cpus, cpu);
-		for (s2 = 0; s2 < sock->nr; s2++) {
-			if (s1 == sock->map[s2])
+		s1 = f(cpus, cpu);
+		for (s2 = 0; s2 < c->nr; s2++) {
+			if (s1 == c->map[s2])
 				break;
 		}
-		if (s2 == sock->nr) {
-			sock->map[sock->nr] = s1;
-			sock->nr++;
+		if (s2 == c->nr) {
+			c->map[c->nr] = s1;
+			c->nr++;
 		}
 	}
-	*sockp = sock;
+	/* ensure we process id in increasing order */
+	qsort(c->map, c->nr, sizeof(int), cmp_ids);
+
+	*res = c;
 	return 0;
 }
+
+int cpu_map__get_core(struct cpu_map *map, int idx)
+{
+	FILE *fp;
+	const char *mnt;
+	char path[PATH_MAX];
+	int cpu, ret, s;
+
+	if (idx > map->nr)
+		return -1;
+
+	cpu = map->map[idx];
+
+	mnt = sysfs_find_mountpoint();
+	if (!mnt)
+		return -1;
+
+	snprintf(path, PATH_MAX,
+		"%s/devices/system/cpu/cpu%d/topology/core_id",
+		mnt, cpu);
+
+	fp = fopen(path, "r");
+	if (!fp)
+		return -1;
+	ret = fscanf(fp, "%d", &cpu);
+	fclose(fp);
+	if (ret != 1)
+		return -1;
+
+	s = cpu_map__get_socket(map, idx);
+	if (s == -1)
+		return -1;
+
+	/*
+	 * encode socket in upper 16 bits
+	 * core_id is relative to socket, and
+	 * we need a global id. So we combine
+	 * socket+ core id
+	 */
+	return (s << 16) | (cpu & 0xffff);
+}
+
+int cpu_map__build_socket_map(struct cpu_map *cpus, struct cpu_map **sockp)
+{
+	return cpu_map__build_map(cpus, sockp, cpu_map__get_socket);
+}
+
+int cpu_map__build_core_map(struct cpu_map *cpus, struct cpu_map **corep)
+{
+	return cpu_map__build_map(cpus, corep, cpu_map__get_core);
+}
diff --git a/tools/perf/util/cpumap.h b/tools/perf/util/cpumap.h
index 161b007..9bed02e 100644
--- a/tools/perf/util/cpumap.h
+++ b/tools/perf/util/cpumap.h
@@ -15,7 +15,9 @@ void cpu_map__delete(struct cpu_map *map);
 struct cpu_map *cpu_map__read(FILE *file);
 size_t cpu_map__fprintf(struct cpu_map *map, FILE *fp);
 int cpu_map__get_socket(struct cpu_map *map, int idx);
+int cpu_map__get_core(struct cpu_map *map, int idx);
 int cpu_map__build_socket_map(struct cpu_map *cpus, struct cpu_map **sockp);
+int cpu_map__build_core_map(struct cpu_map *cpus, struct cpu_map **corep);
 
 static inline int cpu_map__socket(struct cpu_map *sock, int s)
 {
@@ -24,6 +26,16 @@ static inline int cpu_map__socket(struct cpu_map *sock, int s)
 	return sock->map[s];
 }
 
+static inline int cpu_map__id_to_socket(int id)
+{
+	return id >> 16;
+}
+
+static inline int cpu_map__id_to_cpu(int id)
+{
+	return id & 0xffff;
+}
+
 static inline int cpu_map__nr(const struct cpu_map *map)
 {
 	return map ? map->nr : 1;
diff --git a/tools/perf/util/debugfs.h b/tools/perf/util/debugfs.h
deleted file mode 100644
index 68f3e87..0000000
--- a/tools/perf/util/debugfs.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef __DEBUGFS_H__
-#define __DEBUGFS_H__
-
-const char *debugfs_find_mountpoint(void);
-int debugfs_valid_mountpoint(const char *debugfs);
-char *debugfs_mount(const char *mountpoint);
-void debugfs_set_path(const char *mountpoint);
-
-extern char debugfs_mountpoint[];
-extern char tracing_events_path[];
-
-#endif /* __DEBUGFS_H__ */
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 0d573ff..1813895 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -88,8 +88,10 @@ struct perf_sample {
 	u64 id;
 	u64 stream_id;
 	u64 period;
+	u64 weight;
 	u32 cpu;
 	u32 raw_size;
+	u64 data_src;
 	void *raw_data;
 	struct ip_callchain *callchain;
 	struct branch_stack *branch_stack;
@@ -97,6 +99,13 @@ struct perf_sample {
 	struct stack_dump user_stack;
 };
 
+#define PERF_MEM_DATA_SRC_NONE \
+	(PERF_MEM_S(OP, NA) |\
+	 PERF_MEM_S(LVL, NA) |\
+	 PERF_MEM_S(SNOOP, NA) |\
+	 PERF_MEM_S(LOCK, NA) |\
+	 PERF_MEM_S(TLB, NA))
+
 struct build_id_event {
 	struct perf_event_header header;
 	pid_t			 pid;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index c8be0fb..f7c7278 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -7,7 +7,7 @@
  * Released under the GPL v2. (and only v2, not any later version)
  */
 #include "util.h"
-#include "debugfs.h"
+#include <lk/debugfs.h>
 #include <poll.h>
 #include "cpumap.h"
 #include "thread_map.h"
@@ -38,13 +38,12 @@ void perf_evlist__init(struct perf_evlist *evlist, struct cpu_map *cpus,
 	evlist->workload.pid = -1;
 }
 
-struct perf_evlist *perf_evlist__new(struct cpu_map *cpus,
-				     struct thread_map *threads)
+struct perf_evlist *perf_evlist__new(void)
 {
 	struct perf_evlist *evlist = zalloc(sizeof(*evlist));
 
 	if (evlist != NULL)
-		perf_evlist__init(evlist, cpus, threads);
+		perf_evlist__init(evlist, NULL, NULL);
 
 	return evlist;
 }
@@ -228,12 +227,14 @@ void perf_evlist__disable(struct perf_evlist *evlist)
 {
 	int cpu, thread;
 	struct perf_evsel *pos;
+	int nr_cpus = cpu_map__nr(evlist->cpus);
+	int nr_threads = thread_map__nr(evlist->threads);
 
-	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		list_for_each_entry(pos, &evlist->entries, node) {
 			if (!perf_evsel__is_group_leader(pos))
 				continue;
-			for (thread = 0; thread < evlist->threads->nr; thread++)
+			for (thread = 0; thread < nr_threads; thread++)
 				ioctl(FD(pos, cpu, thread),
 				      PERF_EVENT_IOC_DISABLE, 0);
 		}
@@ -244,12 +245,14 @@ void perf_evlist__enable(struct perf_evlist *evlist)
 {
 	int cpu, thread;
 	struct perf_evsel *pos;
+	int nr_cpus = cpu_map__nr(evlist->cpus);
+	int nr_threads = thread_map__nr(evlist->threads);
 
-	for (cpu = 0; cpu < cpu_map__nr(evlist->cpus); cpu++) {
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		list_for_each_entry(pos, &evlist->entries, node) {
 			if (!perf_evsel__is_group_leader(pos))
 				continue;
-			for (thread = 0; thread < evlist->threads->nr; thread++)
+			for (thread = 0; thread < nr_threads; thread++)
 				ioctl(FD(pos, cpu, thread),
 				      PERF_EVENT_IOC_ENABLE, 0);
 		}
@@ -258,7 +261,9 @@ void perf_evlist__enable(struct perf_evlist *evlist)
 
 static int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
 {
-	int nfds = cpu_map__nr(evlist->cpus) * evlist->threads->nr * evlist->nr_entries;
+	int nr_cpus = cpu_map__nr(evlist->cpus);
+	int nr_threads = thread_map__nr(evlist->threads);
+	int nfds = nr_cpus * nr_threads * evlist->nr_entries;
 	evlist->pollfd = malloc(sizeof(struct pollfd) * nfds);
 	return evlist->pollfd != NULL ? 0 : -ENOMEM;
 }
@@ -417,7 +422,7 @@ static int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
 {
 	evlist->nr_mmaps = cpu_map__nr(evlist->cpus);
 	if (cpu_map__all(evlist->cpus))
-		evlist->nr_mmaps = evlist->threads->nr;
+		evlist->nr_mmaps = thread_map__nr(evlist->threads);
 	evlist->mmap = zalloc(evlist->nr_mmaps * sizeof(struct perf_mmap));
 	return evlist->mmap != NULL ? 0 : -ENOMEM;
 }
@@ -442,11 +447,13 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int m
 {
 	struct perf_evsel *evsel;
 	int cpu, thread;
+	int nr_cpus = cpu_map__nr(evlist->cpus);
+	int nr_threads = thread_map__nr(evlist->threads);
 
-	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		int output = -1;
 
-		for (thread = 0; thread < evlist->threads->nr; thread++) {
+		for (thread = 0; thread < nr_threads; thread++) {
 			list_for_each_entry(evsel, &evlist->entries, node) {
 				int fd = FD(evsel, cpu, thread);
 
@@ -470,7 +477,7 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int m
 	return 0;
 
 out_unmap:
-	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		if (evlist->mmap[cpu].base != NULL) {
 			munmap(evlist->mmap[cpu].base, evlist->mmap_len);
 			evlist->mmap[cpu].base = NULL;
@@ -483,8 +490,9 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, in
 {
 	struct perf_evsel *evsel;
 	int thread;
+	int nr_threads = thread_map__nr(evlist->threads);
 
-	for (thread = 0; thread < evlist->threads->nr; thread++) {
+	for (thread = 0; thread < nr_threads; thread++) {
 		int output = -1;
 
 		list_for_each_entry(evsel, &evlist->entries, node) {
@@ -509,7 +517,7 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, in
 	return 0;
 
 out_unmap:
-	for (thread = 0; thread < evlist->threads->nr; thread++) {
+	for (thread = 0; thread < nr_threads; thread++) {
 		if (evlist->mmap[thread].base != NULL) {
 			munmap(evlist->mmap[thread].base, evlist->mmap_len);
 			evlist->mmap[thread].base = NULL;
@@ -610,7 +618,7 @@ int perf_evlist__apply_filters(struct perf_evlist *evlist)
 	struct perf_evsel *evsel;
 	int err = 0;
 	const int ncpus = cpu_map__nr(evlist->cpus),
-		  nthreads = evlist->threads->nr;
+		  nthreads = thread_map__nr(evlist->threads);
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		if (evsel->filter == NULL)
@@ -629,7 +637,7 @@ int perf_evlist__set_filter(struct perf_evlist *evlist, const char *filter)
 	struct perf_evsel *evsel;
 	int err = 0;
 	const int ncpus = cpu_map__nr(evlist->cpus),
-		  nthreads = evlist->threads->nr;
+		  nthreads = thread_map__nr(evlist->threads);
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		err = perf_evsel__set_filter(evsel, ncpus, nthreads, filter);
@@ -712,10 +720,20 @@ void perf_evlist__set_selected(struct perf_evlist *evlist,
 	evlist->selected = evsel;
 }
 
+void perf_evlist__close(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+	int ncpus = cpu_map__nr(evlist->cpus);
+	int nthreads = thread_map__nr(evlist->threads);
+
+	list_for_each_entry_reverse(evsel, &evlist->entries, node)
+		perf_evsel__close(evsel, ncpus, nthreads);
+}
+
 int perf_evlist__open(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel;
-	int err, ncpus, nthreads;
+	int err;
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		err = perf_evsel__open(evsel, evlist->cpus, evlist->threads);
@@ -725,19 +743,15 @@ int perf_evlist__open(struct perf_evlist *evlist)
 
 	return 0;
 out_err:
-	ncpus = evlist->cpus ? evlist->cpus->nr : 1;
-	nthreads = evlist->threads ? evlist->threads->nr : 1;
-
-	list_for_each_entry_reverse(evsel, &evlist->entries, node)
-		perf_evsel__close(evsel, ncpus, nthreads);
-
+	perf_evlist__close(evlist);
 	errno = -err;
 	return err;
 }
 
 int perf_evlist__prepare_workload(struct perf_evlist *evlist,
-				  struct perf_record_opts *opts,
-				  const char *argv[])
+				  struct perf_target *target,
+				  const char *argv[], bool pipe_output,
+				  bool want_signal)
 {
 	int child_ready_pipe[2], go_pipe[2];
 	char bf;
@@ -759,7 +773,7 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 	}
 
 	if (!evlist->workload.pid) {
-		if (opts->pipe_output)
+		if (pipe_output)
 			dup2(2, 1);
 
 		close(child_ready_pipe[0]);
@@ -787,11 +801,12 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 		execvp(argv[0], (char **)argv);
 
 		perror(argv[0]);
-		kill(getppid(), SIGUSR1);
+		if (want_signal)
+			kill(getppid(), SIGUSR1);
 		exit(-1);
 	}
 
-	if (perf_target__none(&opts->target))
+	if (perf_target__none(target))
 		evlist->threads->map[0] = evlist->workload.pid;
 
 	close(child_ready_pipe[1]);
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 2dd07bd..0583d36 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -49,8 +49,7 @@ struct perf_evsel_str_handler {
 	void	   *handler;
 };
 
-struct perf_evlist *perf_evlist__new(struct cpu_map *cpus,
-				     struct thread_map *threads);
+struct perf_evlist *perf_evlist__new(void);
 void perf_evlist__init(struct perf_evlist *evlist, struct cpu_map *cpus,
 		       struct thread_map *threads);
 void perf_evlist__exit(struct perf_evlist *evlist);
@@ -82,13 +81,15 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
 union perf_event *perf_evlist__mmap_read(struct perf_evlist *self, int idx);
 
 int perf_evlist__open(struct perf_evlist *evlist);
+void perf_evlist__close(struct perf_evlist *evlist);
 
 void perf_evlist__config(struct perf_evlist *evlist,
 			 struct perf_record_opts *opts);
 
 int perf_evlist__prepare_workload(struct perf_evlist *evlist,
-				  struct perf_record_opts *opts,
-				  const char *argv[]);
+				  struct perf_target *target,
+				  const char *argv[], bool pipe_output,
+				  bool want_signal);
 int perf_evlist__start_workload(struct perf_evlist *evlist);
 
 int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 9c82f98f..07b1a3a 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -10,7 +10,7 @@
 #include <byteswap.h>
 #include <linux/bitops.h>
 #include "asm/bug.h"
-#include "debugfs.h"
+#include <lk/debugfs.h>
 #include "event-parse.h"
 #include "evsel.h"
 #include "evlist.h"
@@ -554,6 +554,9 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		perf_evsel__set_sample_bit(evsel, CPU);
 	}
 
+	if (opts->sample_address)
+		attr->sample_type	|= PERF_SAMPLE_DATA_SRC;
+
 	if (opts->no_delay) {
 		attr->watermark = 0;
 		attr->wakeup_events = 1;
@@ -563,6 +566,9 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		attr->branch_sample_type = opts->branch_stack;
 	}
 
+	if (opts->sample_weight)
+		attr->sample_type	|= PERF_SAMPLE_WEIGHT;
+
 	attr->mmap = track;
 	attr->comm = track;
 
@@ -633,6 +639,12 @@ int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads)
 	return 0;
 }
 
+void perf_evsel__reset_counts(struct perf_evsel *evsel, int ncpus)
+{
+	memset(evsel->counts, 0, (sizeof(*evsel->counts) +
+				 (ncpus * sizeof(struct perf_counts_values))));
+}
+
 int perf_evsel__alloc_counts(struct perf_evsel *evsel, int ncpus)
 {
 	evsel->counts = zalloc((sizeof(*evsel->counts) +
@@ -673,9 +685,8 @@ void perf_evsel__free_counts(struct perf_evsel *evsel)
 void perf_evsel__exit(struct perf_evsel *evsel)
 {
 	assert(list_empty(&evsel->node));
-	xyarray__delete(evsel->fd);
-	xyarray__delete(evsel->sample_id);
-	free(evsel->id);
+	perf_evsel__free_fd(evsel);
+	perf_evsel__free_id(evsel);
 }
 
 void perf_evsel__delete(struct perf_evsel *evsel)
@@ -1012,6 +1023,7 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 	data->cpu = data->pid = data->tid = -1;
 	data->stream_id = data->id = data->time = -1ULL;
 	data->period = 1;
+	data->weight = 0;
 
 	if (event->header.type != PERF_RECORD_SAMPLE) {
 		if (!evsel->attr.sample_id_all)
@@ -1162,6 +1174,18 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 		}
 	}
 
+	data->weight = 0;
+	if (type & PERF_SAMPLE_WEIGHT) {
+		data->weight = *array;
+		array++;
+	}
+
+	data->data_src = PERF_MEM_DATA_SRC_NONE;
+	if (type & PERF_SAMPLE_DATA_SRC) {
+		data->data_src = *array;
+		array++;
+	}
+
 	return 0;
 }
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 52021c3..3f156cc 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -9,6 +9,7 @@
 #include "xyarray.h"
 #include "cgroup.h"
 #include "hist.h"
+#include "symbol.h"
  
 struct perf_counts_values {
 	union {
@@ -120,6 +121,7 @@ int perf_evsel__group_desc(struct perf_evsel *evsel, char *buf, size_t size);
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads);
 int perf_evsel__alloc_counts(struct perf_evsel *evsel, int ncpus);
+void perf_evsel__reset_counts(struct perf_evsel *evsel, int ncpus);
 void perf_evsel__free_fd(struct perf_evsel *evsel);
 void perf_evsel__free_id(struct perf_evsel *evsel);
 void perf_evsel__free_counts(struct perf_evsel *evsel);
@@ -246,11 +248,34 @@ static inline struct perf_evsel *perf_evsel__next(struct perf_evsel *evsel)
 	return list_entry(evsel->node.next, struct perf_evsel, node);
 }
 
+/**
+ * perf_evsel__is_group_leader - Return whether given evsel is a leader event
+ *
+ * @evsel - evsel selector to be tested
+ *
+ * Return %true if @evsel is a group leader or a stand-alone event
+ */
 static inline bool perf_evsel__is_group_leader(const struct perf_evsel *evsel)
 {
 	return evsel->leader == evsel;
 }
 
+/**
+ * perf_evsel__is_group_event - Return whether given evsel is a group event
+ *
+ * @evsel - evsel selector to be tested
+ *
+ * Return %true iff event group view is enabled and @evsel is a actual group
+ * leader which has other members in the group
+ */
+static inline bool perf_evsel__is_group_event(struct perf_evsel *evsel)
+{
+	if (!symbol_conf.event_group)
+		return false;
+
+	return perf_evsel__is_group_leader(evsel) && evsel->nr_members > 1;
+}
+
 struct perf_attr_details {
 	bool freq;
 	bool verbose;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index f4bfd79..326068a 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1,5 +1,3 @@
-#define _FILE_OFFSET_BITS 64
-
 #include "util.h"
 #include <sys/types.h>
 #include <byteswap.h>
@@ -1672,8 +1670,8 @@ static int process_tracing_data(struct perf_file_section *section __maybe_unused
 				struct perf_header *ph __maybe_unused,
 				int fd, void *data)
 {
-	trace_report(fd, data, false);
-	return 0;
+	ssize_t ret = trace_report(fd, data, false);
+	return ret < 0 ? -1 : 0;
 }
 
 static int process_build_id(struct perf_file_section *section,
@@ -2752,6 +2750,11 @@ static int perf_evsel__prepare_tracepoint_event(struct perf_evsel *evsel,
 	if (evsel->tp_format)
 		return 0;
 
+	if (pevent == NULL) {
+		pr_debug("broken or missing trace data\n");
+		return -1;
+	}
+
 	event = pevent_find_event(pevent, evsel->attr.config);
 	if (event == NULL)
 		return -1;
@@ -2789,7 +2792,7 @@ int perf_session__read_header(struct perf_session *session, int fd)
 	u64			f_id;
 	int nr_attrs, nr_ids, i, j;
 
-	session->evlist = perf_evlist__new(NULL, NULL);
+	session->evlist = perf_evlist__new();
 	if (session->evlist == NULL)
 		return -ENOMEM;
 
@@ -2940,7 +2943,7 @@ int perf_event__process_attr(union perf_event *event,
 	struct perf_evlist *evlist = *pevlist;
 
 	if (evlist == NULL) {
-		*pevlist = evlist = perf_evlist__new(NULL, NULL);
+		*pevlist = evlist = perf_evlist__new();
 		if (evlist == NULL)
 			return -ENOMEM;
 	}
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index f855941..6b32721 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -67,12 +67,16 @@ static void hists__set_unres_dso_col_len(struct hists *hists, int dso)
 void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 {
 	const unsigned int unresolved_col_width = BITS_PER_LONG / 4;
+	int symlen;
 	u16 len;
 
 	if (h->ms.sym)
 		hists__new_col_len(hists, HISTC_SYMBOL, h->ms.sym->namelen + 4);
-	else
+	else {
+		symlen = unresolved_col_width + 4 + 2;
+		hists__new_col_len(hists, HISTC_SYMBOL, symlen);
 		hists__set_unres_dso_col_len(hists, HISTC_DSO);
+	}
 
 	len = thread__comm_len(h->thread);
 	if (hists__new_col_len(hists, HISTC_COMM, len))
@@ -87,7 +91,6 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 		hists__new_col_len(hists, HISTC_PARENT, h->parent->namelen);
 
 	if (h->branch_info) {
-		int symlen;
 		/*
 		 * +4 accounts for '[x] ' priv level info
 		 * +2 account of 0x prefix on raw addresses
@@ -116,6 +119,42 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 			hists__set_unres_dso_col_len(hists, HISTC_DSO_TO);
 		}
 	}
+
+	if (h->mem_info) {
+		/*
+		 * +4 accounts for '[x] ' priv level info
+		 * +2 account of 0x prefix on raw addresses
+		 */
+		if (h->mem_info->daddr.sym) {
+			symlen = (int)h->mem_info->daddr.sym->namelen + 4
+			       + unresolved_col_width + 2;
+			hists__new_col_len(hists, HISTC_MEM_DADDR_SYMBOL,
+					   symlen);
+		} else {
+			symlen = unresolved_col_width + 4 + 2;
+			hists__new_col_len(hists, HISTC_MEM_DADDR_SYMBOL,
+					   symlen);
+		}
+		if (h->mem_info->daddr.map) {
+			symlen = dso__name_len(h->mem_info->daddr.map->dso);
+			hists__new_col_len(hists, HISTC_MEM_DADDR_DSO,
+					   symlen);
+		} else {
+			symlen = unresolved_col_width + 4 + 2;
+			hists__set_unres_dso_col_len(hists, HISTC_MEM_DADDR_DSO);
+		}
+	} else {
+		symlen = unresolved_col_width + 4 + 2;
+		hists__new_col_len(hists, HISTC_MEM_DADDR_SYMBOL, symlen);
+		hists__set_unres_dso_col_len(hists, HISTC_MEM_DADDR_DSO);
+	}
+
+	hists__new_col_len(hists, HISTC_MEM_LOCKED, 6);
+	hists__new_col_len(hists, HISTC_MEM_TLB, 22);
+	hists__new_col_len(hists, HISTC_MEM_SNOOP, 12);
+	hists__new_col_len(hists, HISTC_MEM_LVL, 21 + 3);
+	hists__new_col_len(hists, HISTC_LOCAL_WEIGHT, 12);
+	hists__new_col_len(hists, HISTC_GLOBAL_WEIGHT, 12);
 }
 
 void hists__output_recalc_col_len(struct hists *hists, int max_rows)
@@ -155,9 +194,12 @@ static void hist_entry__add_cpumode_period(struct hist_entry *he,
 	}
 }
 
-static void he_stat__add_period(struct he_stat *he_stat, u64 period)
+static void he_stat__add_period(struct he_stat *he_stat, u64 period,
+				u64 weight)
 {
+
 	he_stat->period		+= period;
+	he_stat->weight		+= weight;
 	he_stat->nr_events	+= 1;
 }
 
@@ -169,12 +211,14 @@ static void he_stat__add_stat(struct he_stat *dest, struct he_stat *src)
 	dest->period_guest_sys	+= src->period_guest_sys;
 	dest->period_guest_us	+= src->period_guest_us;
 	dest->nr_events		+= src->nr_events;
+	dest->weight		+= src->weight;
 }
 
 static void hist_entry__decay(struct hist_entry *he)
 {
 	he->stat.period = (he->stat.period * 7) / 8;
 	he->stat.nr_events = (he->stat.nr_events * 7) / 8;
+	/* XXX need decay for weight too? */
 }
 
 static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
@@ -239,7 +283,7 @@ void hists__decay_entries_threaded(struct hists *hists,
 static struct hist_entry *hist_entry__new(struct hist_entry *template)
 {
 	size_t callchain_size = symbol_conf.use_callchain ? sizeof(struct callchain_root) : 0;
-	struct hist_entry *he = malloc(sizeof(*he) + callchain_size);
+	struct hist_entry *he = zalloc(sizeof(*he) + callchain_size);
 
 	if (he != NULL) {
 		*he = *template;
@@ -254,6 +298,13 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 				he->branch_info->to.map->referenced = true;
 		}
 
+		if (he->mem_info) {
+			if (he->mem_info->iaddr.map)
+				he->mem_info->iaddr.map->referenced = true;
+			if (he->mem_info->daddr.map)
+				he->mem_info->daddr.map->referenced = true;
+		}
+
 		if (symbol_conf.use_callchain)
 			callchain_init(he->callchain);
 
@@ -282,7 +333,8 @@ static u8 symbol__parent_filter(const struct symbol *parent)
 static struct hist_entry *add_hist_entry(struct hists *hists,
 				      struct hist_entry *entry,
 				      struct addr_location *al,
-				      u64 period)
+				      u64 period,
+				      u64 weight)
 {
 	struct rb_node **p;
 	struct rb_node *parent = NULL;
@@ -306,7 +358,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 		cmp = hist_entry__cmp(he, entry);
 
 		if (!cmp) {
-			he_stat__add_period(&he->stat, period);
+			he_stat__add_period(&he->stat, period, weight);
 
 			/* If the map of an existing hist_entry has
 			 * become out-of-date due to an exec() or
@@ -341,11 +393,42 @@ out_unlock:
 	return he;
 }
 
+struct hist_entry *__hists__add_mem_entry(struct hists *self,
+					  struct addr_location *al,
+					  struct symbol *sym_parent,
+					  struct mem_info *mi,
+					  u64 period,
+					  u64 weight)
+{
+	struct hist_entry entry = {
+		.thread	= al->thread,
+		.ms = {
+			.map	= al->map,
+			.sym	= al->sym,
+		},
+		.stat = {
+			.period	= period,
+			.weight = weight,
+			.nr_events = 1,
+		},
+		.cpu	= al->cpu,
+		.ip	= al->addr,
+		.level	= al->level,
+		.parent = sym_parent,
+		.filtered = symbol__parent_filter(sym_parent),
+		.hists = self,
+		.mem_info = mi,
+		.branch_info = NULL,
+	};
+	return add_hist_entry(self, &entry, al, period, weight);
+}
+
 struct hist_entry *__hists__add_branch_entry(struct hists *self,
 					     struct addr_location *al,
 					     struct symbol *sym_parent,
 					     struct branch_info *bi,
-					     u64 period)
+					     u64 period,
+					     u64 weight)
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
@@ -359,19 +442,22 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 		.stat = {
 			.period	= period,
 			.nr_events = 1,
+			.weight = weight,
 		},
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent),
 		.branch_info = bi,
 		.hists	= self,
+		.mem_info = NULL,
 	};
 
-	return add_hist_entry(self, &entry, al, period);
+	return add_hist_entry(self, &entry, al, period, weight);
 }
 
 struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct addr_location *al,
-				      struct symbol *sym_parent, u64 period)
+				      struct symbol *sym_parent, u64 period,
+				      u64 weight)
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
@@ -385,13 +471,16 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 		.stat = {
 			.period	= period,
 			.nr_events = 1,
+			.weight = weight,
 		},
 		.parent = sym_parent,
 		.filtered = symbol__parent_filter(sym_parent),
 		.hists	= self,
+		.branch_info = NULL,
+		.mem_info = NULL,
 	};
 
-	return add_hist_entry(self, &entry, al, period);
+	return add_hist_entry(self, &entry, al, period, weight);
 }
 
 int64_t
@@ -431,6 +520,7 @@ hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
 void hist_entry__free(struct hist_entry *he)
 {
 	free(he->branch_info);
+	free(he->mem_info);
 	free(he);
 }
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 226a4ae..14c2fe2 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -49,6 +49,14 @@ enum hist_column {
 	HISTC_DSO_FROM,
 	HISTC_DSO_TO,
 	HISTC_SRCLINE,
+	HISTC_LOCAL_WEIGHT,
+	HISTC_GLOBAL_WEIGHT,
+	HISTC_MEM_DADDR_SYMBOL,
+	HISTC_MEM_DADDR_DSO,
+	HISTC_MEM_LOCKED,
+	HISTC_MEM_TLB,
+	HISTC_MEM_LVL,
+	HISTC_MEM_SNOOP,
 	HISTC_NR_COLS, /* Last entry */
 };
 
@@ -73,7 +81,8 @@ struct hists {
 
 struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct addr_location *al,
-				      struct symbol *parent, u64 period);
+				      struct symbol *parent, u64 period,
+				      u64 weight);
 int64_t hist_entry__cmp(struct hist_entry *left, struct hist_entry *right);
 int64_t hist_entry__collapse(struct hist_entry *left, struct hist_entry *right);
 int hist_entry__sort_snprintf(struct hist_entry *self, char *bf, size_t size,
@@ -84,7 +93,15 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 					     struct addr_location *al,
 					     struct symbol *sym_parent,
 					     struct branch_info *bi,
-					     u64 period);
+					     u64 period,
+					     u64 weight);
+
+struct hist_entry *__hists__add_mem_entry(struct hists *self,
+					  struct addr_location *al,
+					  struct symbol *sym_parent,
+					  struct mem_info *mi,
+					  u64 period,
+					  u64 weight);
 
 void hists__output_resort(struct hists *self);
 void hists__output_resort_threaded(struct hists *hists);
@@ -175,9 +192,9 @@ struct hist_browser_timer {
 	int refresh;
 };
 
-#ifdef NEWT_SUPPORT
+#ifdef SLANG_SUPPORT
 #include "../ui/keysyms.h"
-int hist_entry__tui_annotate(struct hist_entry *he, int evidx,
+int hist_entry__tui_annotate(struct hist_entry *he, struct perf_evsel *evsel,
 			     struct hist_browser_timer *hbt);
 
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
@@ -196,7 +213,8 @@ int perf_evlist__tui_browse_hists(struct perf_evlist *evlist __maybe_unused,
 
 static inline int hist_entry__tui_annotate(struct hist_entry *self
 					   __maybe_unused,
-					   int evidx __maybe_unused,
+					   struct perf_evsel *evsel
+					   __maybe_unused,
 					   struct hist_browser_timer *hbt
 					   __maybe_unused)
 {
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index efdb38e..b2ecad6 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -955,6 +955,7 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 	struct thread *thread;
 	struct map *map;
+	enum map_type type;
 	int ret = 0;
 
 	if (dump_trace)
@@ -971,10 +972,17 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 	thread = machine__findnew_thread(machine, event->mmap.pid);
 	if (thread == NULL)
 		goto out_problem;
+
+	if (event->header.misc & PERF_RECORD_MISC_MMAP_DATA)
+		type = MAP__VARIABLE;
+	else
+		type = MAP__FUNCTION;
+
 	map = map__new(&machine->user_dsos, event->mmap.start,
 			event->mmap.len, event->mmap.pgoff,
 			event->mmap.pid, event->mmap.filename,
-			MAP__FUNCTION);
+			type);
+
 	if (map == NULL)
 		goto out_problem;
 
@@ -1003,6 +1011,17 @@ int machine__process_fork_event(struct machine *machine, union perf_event *event
 	return 0;
 }
 
+static void machine__remove_thread(struct machine *machine, struct thread *th)
+{
+	machine->last_match = NULL;
+	rb_erase(&th->rb_node, &machine->threads);
+	/*
+	 * We may have references to this thread, for instance in some hist_entry
+	 * instances, so just move them to a separate list.
+	 */
+	list_add_tail(&th->node, &machine->dead_threads);
+}
+
 int machine__process_exit_event(struct machine *machine, union perf_event *event)
 {
 	struct thread *thread = machine__find_thread(machine, event->fork.tid);
@@ -1039,17 +1058,6 @@ int machine__process_event(struct machine *machine, union perf_event *event)
 	return ret;
 }
 
-void machine__remove_thread(struct machine *machine, struct thread *th)
-{
-	machine->last_match = NULL;
-	rb_erase(&th->rb_node, &machine->threads);
-	/*
-	 * We may have references to this thread, for instance in some hist_entry
-	 * instances, so just move them to a separate list.
-	 */
-	list_add_tail(&th->node, &machine->dead_threads);
-}
-
 static bool symbol__match_parent_regex(struct symbol *sym)
 {
 	if (sym->name && !regexec(&parent_regex, sym->name, 0, NULL, 0))
@@ -1097,6 +1105,38 @@ found:
 	ams->map = al.map;
 }
 
+static void ip__resolve_data(struct machine *machine, struct thread *thread,
+			     u8 m, struct addr_map_symbol *ams, u64 addr)
+{
+	struct addr_location al;
+
+	memset(&al, 0, sizeof(al));
+
+	thread__find_addr_location(thread, machine, m, MAP__VARIABLE, addr, &al,
+				   NULL);
+	ams->addr = addr;
+	ams->al_addr = al.addr;
+	ams->sym = al.sym;
+	ams->map = al.map;
+}
+
+struct mem_info *machine__resolve_mem(struct machine *machine,
+				      struct thread *thr,
+				      struct perf_sample *sample,
+				      u8 cpumode)
+{
+	struct mem_info *mi = zalloc(sizeof(*mi));
+
+	if (!mi)
+		return NULL;
+
+	ip__resolve_ams(machine, thr, &mi->iaddr, sample->ip);
+	ip__resolve_data(machine, thr, cpumode, &mi->daddr, sample->addr);
+	mi->data_src.val = sample->data_src;
+
+	return mi;
+}
+
 struct branch_info *machine__resolve_bstack(struct machine *machine,
 					    struct thread *thr,
 					    struct branch_stack *bs)
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 5ac5892..7794068 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -76,6 +76,9 @@ void machine__delete(struct machine *machine);
 struct branch_info *machine__resolve_bstack(struct machine *machine,
 					    struct thread *thread,
 					    struct branch_stack *bs);
+struct mem_info *machine__resolve_mem(struct machine *machine,
+				      struct thread *thread,
+				      struct perf_sample *sample, u8 cpumode);
 int machine__resolve_callchain(struct machine *machine,
 			       struct perf_evsel *evsel,
 			       struct thread *thread,
@@ -97,7 +100,6 @@ static inline bool machine__is_host(struct machine *machine)
 }
 
 struct thread *machine__findnew_thread(struct machine *machine, pid_t pid);
-void machine__remove_thread(struct machine *machine, struct thread *th);
 
 size_t machine__fprintf(struct machine *machine, FILE *fp);
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index c84f48c..6c8bb0f 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -10,7 +10,7 @@
 #include "symbol.h"
 #include "cache.h"
 #include "header.h"
-#include "debugfs.h"
+#include <lk/debugfs.h>
 #include "parse-events-bison.h"
 #define YY_EXTRA_TYPE int
 #include "parse-events-flex.h"
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 49a256e..aa04bf9 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -40,7 +40,7 @@
 #include "color.h"
 #include "symbol.h"
 #include "thread.h"
-#include "debugfs.h"
+#include <lk/debugfs.h>
 #include "trace-event.h"	/* For __maybe_unused */
 #include "probe-event.h"
 #include "probe-finder.h"
diff --git a/tools/perf/util/python-ext-sources b/tools/perf/util/python-ext-sources
index 64536a9..f75ae1b 100644
--- a/tools/perf/util/python-ext-sources
+++ b/tools/perf/util/python-ext-sources
@@ -15,7 +15,6 @@ util/thread_map.c
 util/util.c
 util/xyarray.c
 util/cgroup.c
-util/debugfs.c
 util/rblist.c
 util/strlist.c
 util/sysfs.c
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index bd85280b..cf1fe01 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1,5 +1,3 @@
-#define _FILE_OFFSET_BITS 64
-
 #include <linux/kernel.h>
 
 #include <byteswap.h>
@@ -800,6 +798,12 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 
 	if (sample_type & PERF_SAMPLE_STACK_USER)
 		stack_user__printf(&sample->user_stack);
+
+	if (sample_type & PERF_SAMPLE_WEIGHT)
+		printf("... weight: %" PRIu64 "\n", sample->weight);
+
+	if (sample_type & PERF_SAMPLE_DATA_SRC)
+		printf(" . data_src: 0x%"PRIx64"\n", sample->data_src);
 }
 
 static struct machine *
@@ -1365,18 +1369,6 @@ size_t perf_session__fprintf(struct perf_session *session, FILE *fp)
 	return machine__fprintf(&session->machines.host, fp);
 }
 
-void perf_session__remove_thread(struct perf_session *session,
-				 struct thread *th)
-{
-	/*
-	 * FIXME: This one makes no sense, we need to remove the thread from
-	 * the machine it belongs to, perf_session can have many machines, so
-	 * doing it always on ->machines.host is wrong.  Fix when auditing all
-	 * the 'perf kvm' code.
-	 */
-	machine__remove_thread(&session->machines.host, th);
-}
-
 struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 					      unsigned int type)
 {
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index b5c0847..6b51d47 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -72,7 +72,6 @@ void perf_event__attr_swap(struct perf_event_attr *attr);
 int perf_session__create_kernel_maps(struct perf_session *self);
 
 void perf_session__set_id_hdr_size(struct perf_session *session);
-void perf_session__remove_thread(struct perf_session *self, struct thread *th);
 
 static inline
 struct machine *perf_session__find_machine(struct perf_session *self, pid_t pid)
diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index 73d5102..6b0ed32 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -24,6 +24,7 @@ cflags += getenv('CFLAGS', '').split()
 build_lib = getenv('PYTHON_EXTBUILD_LIB')
 build_tmp = getenv('PYTHON_EXTBUILD_TMP')
 libtraceevent = getenv('LIBTRACEEVENT')
+liblk = getenv('LIBLK')
 
 ext_sources = [f.strip() for f in file('util/python-ext-sources')
 				if len(f.strip()) > 0 and f[0] != '#']
@@ -32,7 +33,7 @@ perf = Extension('perf',
 		  sources = ext_sources,
 		  include_dirs = ['util/include'],
 		  extra_compile_args = cflags,
-		  extra_objects = [libtraceevent],
+		  extra_objects = [libtraceevent, liblk],
                  )
 
 setup(name='perf',
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index d41926c..5f52d49 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -198,11 +198,19 @@ static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
 	}
 
 	ret += repsep_snprintf(bf + ret, size - ret, "[%c] ", level);
-	if (sym)
-		ret += repsep_snprintf(bf + ret, size - ret, "%-*s",
-				       width - ret,
-				       sym->name);
-	else {
+	if (sym && map) {
+		if (map->type == MAP__VARIABLE) {
+			ret += repsep_snprintf(bf + ret, size - ret, "%s", sym->name);
+			ret += repsep_snprintf(bf + ret, size - ret, "+0x%llx",
+					ip - map->unmap_ip(map, sym->start));
+			ret += repsep_snprintf(bf + ret, size - ret, "%-*s",
+				       width - ret, "");
+		} else {
+			ret += repsep_snprintf(bf + ret, size - ret, "%-*s",
+					       width - ret,
+					       sym->name);
+		}
+	} else {
 		size_t len = BITS_PER_LONG / 4;
 		ret += repsep_snprintf(bf + ret, size - ret, "%-#.*llx",
 				       len, ip);
@@ -457,6 +465,304 @@ static int hist_entry__mispredict_snprintf(struct hist_entry *self, char *bf,
 	return repsep_snprintf(bf, size, "%-*s", width, out);
 }
 
+/* --sort daddr_sym */
+static int64_t
+sort__daddr_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	uint64_t l = 0, r = 0;
+
+	if (left->mem_info)
+		l = left->mem_info->daddr.addr;
+	if (right->mem_info)
+		r = right->mem_info->daddr.addr;
+
+	return (int64_t)(r - l);
+}
+
+static int hist_entry__daddr_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
+	uint64_t addr = 0;
+	struct map *map = NULL;
+	struct symbol *sym = NULL;
+
+	if (self->mem_info) {
+		addr = self->mem_info->daddr.addr;
+		map = self->mem_info->daddr.map;
+		sym = self->mem_info->daddr.sym;
+	}
+	return _hist_entry__sym_snprintf(map, sym, addr, self->level, bf, size,
+					 width);
+}
+
+static int64_t
+sort__dso_daddr_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	struct map *map_l = NULL;
+	struct map *map_r = NULL;
+
+	if (left->mem_info)
+		map_l = left->mem_info->daddr.map;
+	if (right->mem_info)
+		map_r = right->mem_info->daddr.map;
+
+	return _sort__dso_cmp(map_l, map_r);
+}
+
+static int hist_entry__dso_daddr_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
+	struct map *map = NULL;
+
+	if (self->mem_info)
+		map = self->mem_info->daddr.map;
+
+	return _hist_entry__dso_snprintf(map, bf, size, width);
+}
+
+static int64_t
+sort__locked_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	union perf_mem_data_src data_src_l;
+	union perf_mem_data_src data_src_r;
+
+	if (left->mem_info)
+		data_src_l = left->mem_info->data_src;
+	else
+		data_src_l.mem_lock = PERF_MEM_LOCK_NA;
+
+	if (right->mem_info)
+		data_src_r = right->mem_info->data_src;
+	else
+		data_src_r.mem_lock = PERF_MEM_LOCK_NA;
+
+	return (int64_t)(data_src_r.mem_lock - data_src_l.mem_lock);
+}
+
+static int hist_entry__locked_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
+	const char *out;
+	u64 mask = PERF_MEM_LOCK_NA;
+
+	if (self->mem_info)
+		mask = self->mem_info->data_src.mem_lock;
+
+	if (mask & PERF_MEM_LOCK_NA)
+		out = "N/A";
+	else if (mask & PERF_MEM_LOCK_LOCKED)
+		out = "Yes";
+	else
+		out = "No";
+
+	return repsep_snprintf(bf, size, "%-*s", width, out);
+}
+
+static int64_t
+sort__tlb_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	union perf_mem_data_src data_src_l;
+	union perf_mem_data_src data_src_r;
+
+	if (left->mem_info)
+		data_src_l = left->mem_info->data_src;
+	else
+		data_src_l.mem_dtlb = PERF_MEM_TLB_NA;
+
+	if (right->mem_info)
+		data_src_r = right->mem_info->data_src;
+	else
+		data_src_r.mem_dtlb = PERF_MEM_TLB_NA;
+
+	return (int64_t)(data_src_r.mem_dtlb - data_src_l.mem_dtlb);
+}
+
+static const char * const tlb_access[] = {
+	"N/A",
+	"HIT",
+	"MISS",
+	"L1",
+	"L2",
+	"Walker",
+	"Fault",
+};
+#define NUM_TLB_ACCESS (sizeof(tlb_access)/sizeof(const char *))
+
+static int hist_entry__tlb_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
+	char out[64];
+	size_t sz = sizeof(out) - 1; /* -1 for null termination */
+	size_t l = 0, i;
+	u64 m = PERF_MEM_TLB_NA;
+	u64 hit, miss;
+
+	out[0] = '\0';
+
+	if (self->mem_info)
+		m = self->mem_info->data_src.mem_dtlb;
+
+	hit = m & PERF_MEM_TLB_HIT;
+	miss = m & PERF_MEM_TLB_MISS;
+
+	/* already taken care of */
+	m &= ~(PERF_MEM_TLB_HIT|PERF_MEM_TLB_MISS);
+
+	for (i = 0; m && i < NUM_TLB_ACCESS; i++, m >>= 1) {
+		if (!(m & 0x1))
+			continue;
+		if (l) {
+			strcat(out, " or ");
+			l += 4;
+		}
+		strncat(out, tlb_access[i], sz - l);
+		l += strlen(tlb_access[i]);
+	}
+	if (*out == '\0')
+		strcpy(out, "N/A");
+	if (hit)
+		strncat(out, " hit", sz - l);
+	if (miss)
+		strncat(out, " miss", sz - l);
+
+	return repsep_snprintf(bf, size, "%-*s", width, out);
+}
+
+static int64_t
+sort__lvl_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	union perf_mem_data_src data_src_l;
+	union perf_mem_data_src data_src_r;
+
+	if (left->mem_info)
+		data_src_l = left->mem_info->data_src;
+	else
+		data_src_l.mem_lvl = PERF_MEM_LVL_NA;
+
+	if (right->mem_info)
+		data_src_r = right->mem_info->data_src;
+	else
+		data_src_r.mem_lvl = PERF_MEM_LVL_NA;
+
+	return (int64_t)(data_src_r.mem_lvl - data_src_l.mem_lvl);
+}
+
+static const char * const mem_lvl[] = {
+	"N/A",
+	"HIT",
+	"MISS",
+	"L1",
+	"LFB",
+	"L2",
+	"L3",
+	"Local RAM",
+	"Remote RAM (1 hop)",
+	"Remote RAM (2 hops)",
+	"Remote Cache (1 hop)",
+	"Remote Cache (2 hops)",
+	"I/O",
+	"Uncached",
+};
+#define NUM_MEM_LVL (sizeof(mem_lvl)/sizeof(const char *))
+
+static int hist_entry__lvl_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
+	char out[64];
+	size_t sz = sizeof(out) - 1; /* -1 for null termination */
+	size_t i, l = 0;
+	u64 m =  PERF_MEM_LVL_NA;
+	u64 hit, miss;
+
+	if (self->mem_info)
+		m  = self->mem_info->data_src.mem_lvl;
+
+	out[0] = '\0';
+
+	hit = m & PERF_MEM_LVL_HIT;
+	miss = m & PERF_MEM_LVL_MISS;
+
+	/* already taken care of */
+	m &= ~(PERF_MEM_LVL_HIT|PERF_MEM_LVL_MISS);
+
+	for (i = 0; m && i < NUM_MEM_LVL; i++, m >>= 1) {
+		if (!(m & 0x1))
+			continue;
+		if (l) {
+			strcat(out, " or ");
+			l += 4;
+		}
+		strncat(out, mem_lvl[i], sz - l);
+		l += strlen(mem_lvl[i]);
+	}
+	if (*out == '\0')
+		strcpy(out, "N/A");
+	if (hit)
+		strncat(out, " hit", sz - l);
+	if (miss)
+		strncat(out, " miss", sz - l);
+
+	return repsep_snprintf(bf, size, "%-*s", width, out);
+}
+
+static int64_t
+sort__snoop_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	union perf_mem_data_src data_src_l;
+	union perf_mem_data_src data_src_r;
+
+	if (left->mem_info)
+		data_src_l = left->mem_info->data_src;
+	else
+		data_src_l.mem_snoop = PERF_MEM_SNOOP_NA;
+
+	if (right->mem_info)
+		data_src_r = right->mem_info->data_src;
+	else
+		data_src_r.mem_snoop = PERF_MEM_SNOOP_NA;
+
+	return (int64_t)(data_src_r.mem_snoop - data_src_l.mem_snoop);
+}
+
+static const char * const snoop_access[] = {
+	"N/A",
+	"None",
+	"Miss",
+	"Hit",
+	"HitM",
+};
+#define NUM_SNOOP_ACCESS (sizeof(snoop_access)/sizeof(const char *))
+
+static int hist_entry__snoop_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
+	char out[64];
+	size_t sz = sizeof(out) - 1; /* -1 for null termination */
+	size_t i, l = 0;
+	u64 m = PERF_MEM_SNOOP_NA;
+
+	out[0] = '\0';
+
+	if (self->mem_info)
+		m = self->mem_info->data_src.mem_snoop;
+
+	for (i = 0; m && i < NUM_SNOOP_ACCESS; i++, m >>= 1) {
+		if (!(m & 0x1))
+			continue;
+		if (l) {
+			strcat(out, " or ");
+			l += 4;
+		}
+		strncat(out, snoop_access[i], sz - l);
+		l += strlen(snoop_access[i]);
+	}
+
+	if (*out == '\0')
+		strcpy(out, "N/A");
+
+	return repsep_snprintf(bf, size, "%-*s", width, out);
+}
+
 struct sort_entry sort_mispredict = {
 	.se_header	= "Branch Mispredicted",
 	.se_cmp		= sort__mispredict_cmp,
@@ -464,6 +770,91 @@ struct sort_entry sort_mispredict = {
 	.se_width_idx	= HISTC_MISPREDICT,
 };
 
+static u64 he_weight(struct hist_entry *he)
+{
+	return he->stat.nr_events ? he->stat.weight / he->stat.nr_events : 0;
+}
+
+static int64_t
+sort__local_weight_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return he_weight(left) - he_weight(right);
+}
+
+static int hist_entry__local_weight_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
+	return repsep_snprintf(bf, size, "%-*llu", width, he_weight(self));
+}
+
+struct sort_entry sort_local_weight = {
+	.se_header	= "Local Weight",
+	.se_cmp		= sort__local_weight_cmp,
+	.se_snprintf	= hist_entry__local_weight_snprintf,
+	.se_width_idx	= HISTC_LOCAL_WEIGHT,
+};
+
+static int64_t
+sort__global_weight_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return left->stat.weight - right->stat.weight;
+}
+
+static int hist_entry__global_weight_snprintf(struct hist_entry *self, char *bf,
+					      size_t size, unsigned int width)
+{
+	return repsep_snprintf(bf, size, "%-*llu", width, self->stat.weight);
+}
+
+struct sort_entry sort_global_weight = {
+	.se_header	= "Weight",
+	.se_cmp		= sort__global_weight_cmp,
+	.se_snprintf	= hist_entry__global_weight_snprintf,
+	.se_width_idx	= HISTC_GLOBAL_WEIGHT,
+};
+
+struct sort_entry sort_mem_daddr_sym = {
+	.se_header	= "Data Symbol",
+	.se_cmp		= sort__daddr_cmp,
+	.se_snprintf	= hist_entry__daddr_snprintf,
+	.se_width_idx	= HISTC_MEM_DADDR_SYMBOL,
+};
+
+struct sort_entry sort_mem_daddr_dso = {
+	.se_header	= "Data Object",
+	.se_cmp		= sort__dso_daddr_cmp,
+	.se_snprintf	= hist_entry__dso_daddr_snprintf,
+	.se_width_idx	= HISTC_MEM_DADDR_SYMBOL,
+};
+
+struct sort_entry sort_mem_locked = {
+	.se_header	= "Locked",
+	.se_cmp		= sort__locked_cmp,
+	.se_snprintf	= hist_entry__locked_snprintf,
+	.se_width_idx	= HISTC_MEM_LOCKED,
+};
+
+struct sort_entry sort_mem_tlb = {
+	.se_header	= "TLB access",
+	.se_cmp		= sort__tlb_cmp,
+	.se_snprintf	= hist_entry__tlb_snprintf,
+	.se_width_idx	= HISTC_MEM_TLB,
+};
+
+struct sort_entry sort_mem_lvl = {
+	.se_header	= "Memory access",
+	.se_cmp		= sort__lvl_cmp,
+	.se_snprintf	= hist_entry__lvl_snprintf,
+	.se_width_idx	= HISTC_MEM_LVL,
+};
+
+struct sort_entry sort_mem_snoop = {
+	.se_header	= "Snoop",
+	.se_cmp		= sort__snoop_cmp,
+	.se_snprintf	= hist_entry__snoop_snprintf,
+	.se_width_idx	= HISTC_MEM_SNOOP,
+};
+
 struct sort_dimension {
 	const char		*name;
 	struct sort_entry	*entry;
@@ -480,6 +871,14 @@ static struct sort_dimension common_sort_dimensions[] = {
 	DIM(SORT_PARENT, "parent", sort_parent),
 	DIM(SORT_CPU, "cpu", sort_cpu),
 	DIM(SORT_SRCLINE, "srcline", sort_srcline),
+	DIM(SORT_LOCAL_WEIGHT, "local_weight", sort_local_weight),
+	DIM(SORT_GLOBAL_WEIGHT, "weight", sort_global_weight),
+	DIM(SORT_MEM_DADDR_SYMBOL, "symbol_daddr", sort_mem_daddr_sym),
+	DIM(SORT_MEM_DADDR_DSO, "dso_daddr", sort_mem_daddr_dso),
+	DIM(SORT_MEM_LOCKED, "locked", sort_mem_locked),
+	DIM(SORT_MEM_TLB, "tlb", sort_mem_tlb),
+	DIM(SORT_MEM_LVL, "mem", sort_mem_lvl),
+	DIM(SORT_MEM_SNOOP, "snoop", sort_mem_snoop),
 };
 
 #undef DIM
@@ -516,7 +915,10 @@ int sort_dimension__add(const char *tok)
 				return -EINVAL;
 			}
 			sort__has_parent = 1;
-		} else if (sd->entry == &sort_sym) {
+		} else if (sd->entry == &sort_sym ||
+			   sd->entry == &sort_sym_from ||
+			   sd->entry == &sort_sym_to ||
+			   sd->entry == &sort_mem_daddr_sym) {
 			sort__has_sym = 1;
 		}
 
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index b13e56f..f24bdf6 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -49,6 +49,7 @@ struct he_stat {
 	u64			period_us;
 	u64			period_guest_sys;
 	u64			period_guest_us;
+	u64			weight;
 	u32			nr_events;
 };
 
@@ -100,7 +101,8 @@ struct hist_entry {
 	struct rb_root		sorted_chain;
 	struct branch_info	*branch_info;
 	struct hists		*hists;
-	struct callchain_root	callchain[0];
+	struct mem_info		*mem_info;
+	struct callchain_root	callchain[0]; /* must be last member */
 };
 
 static inline bool hist_entry__has_pairs(struct hist_entry *he)
@@ -130,6 +132,14 @@ enum sort_type {
 	SORT_PARENT,
 	SORT_CPU,
 	SORT_SRCLINE,
+	SORT_LOCAL_WEIGHT,
+	SORT_GLOBAL_WEIGHT,
+	SORT_MEM_DADDR_SYMBOL,
+	SORT_MEM_DADDR_DSO,
+	SORT_MEM_LOCKED,
+	SORT_MEM_TLB,
+	SORT_MEM_LVL,
+	SORT_MEM_SNOOP,
 
 	/* branch stack specific sort keys */
 	__SORT_BRANCH_STACK,
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 54efcb5..4b12bf8 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -806,9 +806,12 @@ int dso__load_sym(struct dso *dso, struct map *map,
 		 * DWARF DW_compile_unit has this, but we don't always have access
 		 * to it...
 		 */
-		demangled = bfd_demangle(NULL, elf_name, DMGL_PARAMS | DMGL_ANSI);
-		if (demangled != NULL)
-			elf_name = demangled;
+		if (symbol_conf.demangle) {
+			demangled = bfd_demangle(NULL, elf_name,
+						 DMGL_PARAMS | DMGL_ANSI);
+			if (demangled != NULL)
+				elf_name = demangled;
+		}
 new_symbol:
 		f = symbol__new(sym.st_value, sym.st_size,
 				GELF_ST_BIND(sym.st_info), elf_name);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e6432d8..8cf3b54 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -36,6 +36,7 @@ struct symbol_conf symbol_conf = {
 	.use_modules	  = true,
 	.try_vmlinux_path = true,
 	.annotate_src	  = true,
+	.demangle	  = true,
 	.symfs            = "",
 };
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index b62ca37..5f720dc 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -97,7 +97,8 @@ struct symbol_conf {
 			kptr_restrict,
 			annotate_asm_raw,
 			annotate_src,
-			event_group;
+			event_group,
+			demangle;
 	const char	*vmlinux_name,
 			*kallsyms_name,
 			*source_prefix,
@@ -155,6 +156,12 @@ struct branch_info {
 	struct branch_flags flags;
 };
 
+struct mem_info {
+	struct addr_map_symbol iaddr;
+	struct addr_map_symbol daddr;
+	union perf_mem_data_src data_src;
+};
+
 struct addr_location {
 	struct thread *thread;
 	struct map    *map;
diff --git a/tools/perf/util/thread_map.h b/tools/perf/util/thread_map.h
index f718df8..0cd8b31 100644
--- a/tools/perf/util/thread_map.h
+++ b/tools/perf/util/thread_map.h
@@ -21,4 +21,9 @@ void thread_map__delete(struct thread_map *threads);
 
 size_t thread_map__fprintf(struct thread_map *threads, FILE *fp);
 
+static inline int thread_map__nr(struct thread_map *threads)
+{
+	return threads ? threads->nr : 1;
+}
+
 #endif	/* __PERF_THREAD_MAP_H */
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index a8d81c3..3917eb9 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -38,52 +38,20 @@
 
 #include "../perf.h"
 #include "trace-event.h"
-#include "debugfs.h"
+#include <lk/debugfs.h>
 #include "evsel.h"
 
 #define VERSION "0.5"
 
-#define TRACE_CTRL	"tracing_on"
-#define TRACE		"trace"
-#define AVAILABLE	"available_tracers"
-#define CURRENT		"current_tracer"
-#define ITER_CTRL	"trace_options"
-#define MAX_LATENCY	"tracing_max_latency"
-
-unsigned int page_size;
-
-static const char *output_file = "trace.info";
 static int output_fd;
 
-struct event_list {
-	struct event_list *next;
-	const char *event;
-};
-
-struct events {
-	struct events *sibling;
-	struct events *children;
-	struct events *next;
-	char *name;
-};
-
-
-static void *malloc_or_die(unsigned int size)
-{
-	void *data;
-
-	data = malloc(size);
-	if (!data)
-		die("malloc");
-	return data;
-}
 
 static const char *find_debugfs(void)
 {
-	const char *path = debugfs_mount(NULL);
+	const char *path = perf_debugfs_mount(NULL);
 
 	if (!path)
-		die("Your kernel not support debugfs filesystem");
+		pr_debug("Your kernel does not support the debugfs filesystem");
 
 	return path;
 }
@@ -102,8 +70,12 @@ static const char *find_tracing_dir(void)
 		return tracing;
 
 	debugfs = find_debugfs();
+	if (!debugfs)
+		return NULL;
 
-	tracing = malloc_or_die(strlen(debugfs) + 9);
+	tracing = malloc(strlen(debugfs) + 9);
+	if (!tracing)
+		return NULL;
 
 	sprintf(tracing, "%s/tracing", debugfs);
 
@@ -120,7 +92,9 @@ static char *get_tracing_file(const char *name)
 	if (!tracing)
 		return NULL;
 
-	file = malloc_or_die(strlen(tracing) + strlen(name) + 2);
+	file = malloc(strlen(tracing) + strlen(name) + 2);
+	if (!file)
+		return NULL;
 
 	sprintf(file, "%s/%s", tracing, name);
 	return file;
@@ -131,24 +105,6 @@ static void put_tracing_file(char *file)
 	free(file);
 }
 
-static ssize_t calc_data_size;
-
-static ssize_t write_or_die(const void *buf, size_t len)
-{
-	int ret;
-
-	if (calc_data_size) {
-		calc_data_size += len;
-		return len;
-	}
-
-	ret = write(output_fd, buf, len);
-	if (ret < 0)
-		die("writing to '%s'", output_file);
-
-	return ret;
-}
-
 int bigendian(void)
 {
 	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4, 0x0, 0x0, 0x0, 0x0};
@@ -159,59 +115,106 @@ int bigendian(void)
 }
 
 /* unfortunately, you can not stat debugfs or proc files for size */
-static void record_file(const char *file, size_t hdr_sz)
+static int record_file(const char *file, ssize_t hdr_sz)
 {
 	unsigned long long size = 0;
 	char buf[BUFSIZ], *sizep;
 	off_t hdr_pos = lseek(output_fd, 0, SEEK_CUR);
 	int r, fd;
+	int err = -EIO;
 
 	fd = open(file, O_RDONLY);
-	if (fd < 0)
-		die("Can't read '%s'", file);
+	if (fd < 0) {
+		pr_debug("Can't read '%s'", file);
+		return -errno;
+	}
 
 	/* put in zeros for file size, then fill true size later */
-	if (hdr_sz)
-		write_or_die(&size, hdr_sz);
+	if (hdr_sz) {
+		if (write(output_fd, &size, hdr_sz) != hdr_sz)
+			goto out;
+	}
 
 	do {
 		r = read(fd, buf, BUFSIZ);
 		if (r > 0) {
 			size += r;
-			write_or_die(buf, r);
+			if (write(output_fd, buf, r) != r)
+				goto out;
 		}
 	} while (r > 0);
-	close(fd);
 
 	/* ugh, handle big-endian hdr_size == 4 */
 	sizep = (char*)&size;
 	if (bigendian())
 		sizep += sizeof(u64) - hdr_sz;
 
-	if (hdr_sz && pwrite(output_fd, sizep, hdr_sz, hdr_pos) < 0)
-		die("writing to %s", output_file);
+	if (hdr_sz && pwrite(output_fd, sizep, hdr_sz, hdr_pos) < 0) {
+		pr_debug("writing file size failed\n");
+		goto out;
+	}
+
+	err = 0;
+out:
+	close(fd);
+	return err;
 }
 
-static void read_header_files(void)
+static int read_header_files(void)
 {
 	char *path;
 	struct stat st;
+	int err = -EIO;
 
 	path = get_tracing_file("events/header_page");
-	if (stat(path, &st) < 0)
-		die("can't read '%s'", path);
+	if (!path) {
+		pr_debug("can't get tracing/events/header_page");
+		return -ENOMEM;
+	}
+
+	if (stat(path, &st) < 0) {
+		pr_debug("can't read '%s'", path);
+		goto out;
+	}
+
+	if (write(output_fd, "header_page", 12) != 12) {
+		pr_debug("can't write header_page\n");
+		goto out;
+	}
+
+	if (record_file(path, 8) < 0) {
+		pr_debug("can't record header_page file\n");
+		goto out;
+	}
 
-	write_or_die("header_page", 12);
-	record_file(path, 8);
 	put_tracing_file(path);
 
 	path = get_tracing_file("events/header_event");
-	if (stat(path, &st) < 0)
-		die("can't read '%s'", path);
+	if (!path) {
+		pr_debug("can't get tracing/events/header_event");
+		err = -ENOMEM;
+		goto out;
+	}
+
+	if (stat(path, &st) < 0) {
+		pr_debug("can't read '%s'", path);
+		goto out;
+	}
 
-	write_or_die("header_event", 13);
-	record_file(path, 8);
+	if (write(output_fd, "header_event", 13) != 13) {
+		pr_debug("can't write header_event\n");
+		goto out;
+	}
+
+	if (record_file(path, 8) < 0) {
+		pr_debug("can't record header_event file\n");
+		goto out;
+	}
+
+	err = 0;
+out:
 	put_tracing_file(path);
+	return err;
 }
 
 static bool name_in_tp_list(char *sys, struct tracepoint_path *tps)
@@ -225,7 +228,7 @@ static bool name_in_tp_list(char *sys, struct tracepoint_path *tps)
 	return false;
 }
 
-static void copy_event_system(const char *sys, struct tracepoint_path *tps)
+static int copy_event_system(const char *sys, struct tracepoint_path *tps)
 {
 	struct dirent *dent;
 	struct stat st;
@@ -233,10 +236,13 @@ static void copy_event_system(const char *sys, struct tracepoint_path *tps)
 	DIR *dir;
 	int count = 0;
 	int ret;
+	int err;
 
 	dir = opendir(sys);
-	if (!dir)
-		die("can't read directory '%s'", sys);
+	if (!dir) {
+		pr_debug("can't read directory '%s'", sys);
+		return -errno;
+	}
 
 	while ((dent = readdir(dir))) {
 		if (dent->d_type != DT_DIR ||
@@ -244,7 +250,11 @@ static void copy_event_system(const char *sys, struct tracepoint_path *tps)
 		    strcmp(dent->d_name, "..") == 0 ||
 		    !name_in_tp_list(dent->d_name, tps))
 			continue;
-		format = malloc_or_die(strlen(sys) + strlen(dent->d_name) + 10);
+		format = malloc(strlen(sys) + strlen(dent->d_name) + 10);
+		if (!format) {
+			err = -ENOMEM;
+			goto out;
+		}
 		sprintf(format, "%s/%s/format", sys, dent->d_name);
 		ret = stat(format, &st);
 		free(format);
@@ -253,7 +263,11 @@ static void copy_event_system(const char *sys, struct tracepoint_path *tps)
 		count++;
 	}
 
-	write_or_die(&count, 4);
+	if (write(output_fd, &count, 4) != 4) {
+		err = -EIO;
+		pr_debug("can't write count\n");
+		goto out;
+	}
 
 	rewinddir(dir);
 	while ((dent = readdir(dir))) {
@@ -262,27 +276,45 @@ static void copy_event_system(const char *sys, struct tracepoint_path *tps)
 		    strcmp(dent->d_name, "..") == 0 ||
 		    !name_in_tp_list(dent->d_name, tps))
 			continue;
-		format = malloc_or_die(strlen(sys) + strlen(dent->d_name) + 10);
+		format = malloc(strlen(sys) + strlen(dent->d_name) + 10);
+		if (!format) {
+			err = -ENOMEM;
+			goto out;
+		}
 		sprintf(format, "%s/%s/format", sys, dent->d_name);
 		ret = stat(format, &st);
 
-		if (ret >= 0)
-			record_file(format, 8);
-
+		if (ret >= 0) {
+			err = record_file(format, 8);
+			if (err) {
+				free(format);
+				goto out;
+			}
+		}
 		free(format);
 	}
+	err = 0;
+out:
 	closedir(dir);
+	return err;
 }
 
-static void read_ftrace_files(struct tracepoint_path *tps)
+static int read_ftrace_files(struct tracepoint_path *tps)
 {
 	char *path;
+	int ret;
 
 	path = get_tracing_file("events/ftrace");
+	if (!path) {
+		pr_debug("can't get tracing/events/ftrace");
+		return -ENOMEM;
+	}
 
-	copy_event_system(path, tps);
+	ret = copy_event_system(path, tps);
 
 	put_tracing_file(path);
+
+	return ret;
 }
 
 static bool system_in_tp_list(char *sys, struct tracepoint_path *tps)
@@ -296,7 +328,7 @@ static bool system_in_tp_list(char *sys, struct tracepoint_path *tps)
 	return false;
 }
 
-static void read_event_files(struct tracepoint_path *tps)
+static int read_event_files(struct tracepoint_path *tps)
 {
 	struct dirent *dent;
 	struct stat st;
@@ -305,12 +337,20 @@ static void read_event_files(struct tracepoint_path *tps)
 	DIR *dir;
 	int count = 0;
 	int ret;
+	int err;
 
 	path = get_tracing_file("events");
+	if (!path) {
+		pr_debug("can't get tracing/events");
+		return -ENOMEM;
+	}
 
 	dir = opendir(path);
-	if (!dir)
-		die("can't read directory '%s'", path);
+	if (!dir) {
+		err = -errno;
+		pr_debug("can't read directory '%s'", path);
+		goto out;
+	}
 
 	while ((dent = readdir(dir))) {
 		if (dent->d_type != DT_DIR ||
@@ -322,7 +362,11 @@ static void read_event_files(struct tracepoint_path *tps)
 		count++;
 	}
 
-	write_or_die(&count, 4);
+	if (write(output_fd, &count, 4) != 4) {
+		err = -EIO;
+		pr_debug("can't write count\n");
+		goto out;
+	}
 
 	rewinddir(dir);
 	while ((dent = readdir(dir))) {
@@ -332,56 +376,90 @@ static void read_event_files(struct tracepoint_path *tps)
 		    strcmp(dent->d_name, "ftrace") == 0 ||
 		    !system_in_tp_list(dent->d_name, tps))
 			continue;
-		sys = malloc_or_die(strlen(path) + strlen(dent->d_name) + 2);
+		sys = malloc(strlen(path) + strlen(dent->d_name) + 2);
+		if (!sys) {
+			err = -ENOMEM;
+			goto out;
+		}
 		sprintf(sys, "%s/%s", path, dent->d_name);
 		ret = stat(sys, &st);
 		if (ret >= 0) {
-			write_or_die(dent->d_name, strlen(dent->d_name) + 1);
-			copy_event_system(sys, tps);
+			ssize_t size = strlen(dent->d_name) + 1;
+
+			if (write(output_fd, dent->d_name, size) != size ||
+			    copy_event_system(sys, tps) < 0) {
+				err = -EIO;
+				free(sys);
+				goto out;
+			}
 		}
 		free(sys);
 	}
-
+	err = 0;
+out:
 	closedir(dir);
 	put_tracing_file(path);
+
+	return err;
 }
 
-static void read_proc_kallsyms(void)
+static int read_proc_kallsyms(void)
 {
 	unsigned int size;
 	const char *path = "/proc/kallsyms";
 	struct stat st;
-	int ret;
+	int ret, err = 0;
 
 	ret = stat(path, &st);
 	if (ret < 0) {
 		/* not found */
 		size = 0;
-		write_or_die(&size, 4);
-		return;
+		if (write(output_fd, &size, 4) != 4)
+			err = -EIO;
+		return err;
 	}
-	record_file(path, 4);
+	return record_file(path, 4);
 }
 
-static void read_ftrace_printk(void)
+static int read_ftrace_printk(void)
 {
 	unsigned int size;
 	char *path;
 	struct stat st;
-	int ret;
+	int ret, err = 0;
 
 	path = get_tracing_file("printk_formats");
+	if (!path) {
+		pr_debug("can't get tracing/printk_formats");
+		return -ENOMEM;
+	}
+
 	ret = stat(path, &st);
 	if (ret < 0) {
 		/* not found */
 		size = 0;
-		write_or_die(&size, 4);
+		if (write(output_fd, &size, 4) != 4)
+			err = -EIO;
 		goto out;
 	}
-	record_file(path, 4);
+	err = record_file(path, 4);
 
 out:
 	put_tracing_file(path);
+	return err;
+}
+
+static void
+put_tracepoints_path(struct tracepoint_path *tps)
+{
+	while (tps) {
+		struct tracepoint_path *t = tps;
+
+		tps = tps->next;
+		free(t->name);
+		free(t->system);
+		free(t);
+	}
 }
 
 static struct tracepoint_path *
@@ -396,27 +474,17 @@ get_tracepoints_path(struct list_head *pattrs)
 			continue;
 		++nr_tracepoints;
 		ppath->next = tracepoint_id_to_path(pos->attr.config);
-		if (!ppath->next)
-			die("%s\n", "No memory to alloc tracepoints list");
+		if (!ppath->next) {
+			pr_debug("No memory to alloc tracepoints list\n");
+			put_tracepoints_path(&path);
+			return NULL;
+		}
 		ppath = ppath->next;
 	}
 
 	return nr_tracepoints > 0 ? path.next : NULL;
 }
 
-static void
-put_tracepoints_path(struct tracepoint_path *tps)
-{
-	while (tps) {
-		struct tracepoint_path *t = tps;
-
-		tps = tps->next;
-		free(t->name);
-		free(t->system);
-		free(t);
-	}
-}
-
 bool have_tracepoints(struct list_head *pattrs)
 {
 	struct perf_evsel *pos;
@@ -428,9 +496,10 @@ bool have_tracepoints(struct list_head *pattrs)
 	return false;
 }
 
-static void tracing_data_header(void)
+static int tracing_data_header(void)
 {
 	char buf[20];
+	ssize_t size;
 
 	/* just guessing this is someone's birthday.. ;) */
 	buf[0] = 23;
@@ -438,9 +507,12 @@ static void tracing_data_header(void)
 	buf[2] = 68;
 	memcpy(buf + 3, "tracing", 7);
 
-	write_or_die(buf, 10);
+	if (write(output_fd, buf, 10) != 10)
+		return -1;
 
-	write_or_die(VERSION, strlen(VERSION) + 1);
+	size = strlen(VERSION) + 1;
+	if (write(output_fd, VERSION, size) != size)
+		return -1;
 
 	/* save endian */
 	if (bigendian())
@@ -450,15 +522,19 @@ static void tracing_data_header(void)
 
 	read_trace_init(buf[0], buf[0]);
 
-	write_or_die(buf, 1);
+	if (write(output_fd, buf, 1) != 1)
+		return -1;
 
 	/* save size of long */
 	buf[0] = sizeof(long);
-	write_or_die(buf, 1);
+	if (write(output_fd, buf, 1) != 1)
+		return -1;
 
 	/* save page_size */
-	page_size = sysconf(_SC_PAGESIZE);
-	write_or_die(&page_size, 4);
+	if (write(output_fd, &page_size, 4) != 4)
+		return -1;
+
+	return 0;
 }
 
 struct tracing_data *tracing_data_get(struct list_head *pattrs,
@@ -466,6 +542,7 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,
 {
 	struct tracepoint_path *tps;
 	struct tracing_data *tdata;
+	int err;
 
 	output_fd = fd;
 
@@ -473,7 +550,10 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,
 	if (!tps)
 		return NULL;
 
-	tdata = malloc_or_die(sizeof(*tdata));
+	tdata = malloc(sizeof(*tdata));
+	if (!tdata)
+		return NULL;
+
 	tdata->temp = temp;
 	tdata->size = 0;
 
@@ -482,12 +562,16 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,
 
 		snprintf(tdata->temp_file, sizeof(tdata->temp_file),
 			 "/tmp/perf-XXXXXX");
-		if (!mkstemp(tdata->temp_file))
-			die("Can't make temp file");
+		if (!mkstemp(tdata->temp_file)) {
+			pr_debug("Can't make temp file");
+			return NULL;
+		}
 
 		temp_fd = open(tdata->temp_file, O_RDWR);
-		if (temp_fd < 0)
-			die("Can't read '%s'", tdata->temp_file);
+		if (temp_fd < 0) {
+			pr_debug("Can't read '%s'", tdata->temp_file);
+			return NULL;
+		}
 
 		/*
 		 * Set the temp file the default output, so all the
@@ -496,13 +580,24 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,
 		output_fd = temp_fd;
 	}
 
-	tracing_data_header();
-	read_header_files();
-	read_ftrace_files(tps);
-	read_event_files(tps);
-	read_proc_kallsyms();
-	read_ftrace_printk();
+	err = tracing_data_header();
+	if (err)
+		goto out;
+	err = read_header_files();
+	if (err)
+		goto out;
+	err = read_ftrace_files(tps);
+	if (err)
+		goto out;
+	err = read_event_files(tps);
+	if (err)
+		goto out;
+	err = read_proc_kallsyms();
+	if (err)
+		goto out;
+	err = read_ftrace_printk();
 
+out:
 	/*
 	 * All tracing data are stored by now, we can restore
 	 * the default output file in case we used temp file.
@@ -513,22 +608,31 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,
 		output_fd = fd;
 	}
 
+	if (err) {
+		free(tdata);
+		tdata = NULL;
+	}
+
 	put_tracepoints_path(tps);
 	return tdata;
 }
 
-void tracing_data_put(struct tracing_data *tdata)
+int tracing_data_put(struct tracing_data *tdata)
 {
+	int err = 0;
+
 	if (tdata->temp) {
-		record_file(tdata->temp_file, 0);
+		err = record_file(tdata->temp_file, 0);
 		unlink(tdata->temp_file);
 	}
 
 	free(tdata);
+	return err;
 }
 
 int read_tracing_data(int fd, struct list_head *pattrs)
 {
+	int err;
 	struct tracing_data *tdata;
 
 	/*
@@ -539,6 +643,6 @@ int read_tracing_data(int fd, struct list_head *pattrs)
 	if (!tdata)
 		return -ENOMEM;
 
-	tracing_data_put(tdata);
-	return 0;
+	err = tracing_data_put(tdata);
+	return err;
 }
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 3aabcd6..4454835 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -183,43 +183,6 @@ void event_format__print(struct event_format *event,
 	trace_seq_do_printf(&s);
 }
 
-void print_trace_event(struct pevent *pevent, int cpu, void *data, int size)
-{
-	int type = trace_parse_common_type(pevent, data);
-	struct event_format *event = pevent_find_event(pevent, type);
-
-	if (!event) {
-		warning("ug! no event found for type %d", type);
-		return;
-	}
-
-	event_format__print(event, cpu, data, size);
-}
-
-void print_event(struct pevent *pevent, int cpu, void *data, int size,
-		 unsigned long long nsecs, char *comm)
-{
-	struct pevent_record record;
-	struct trace_seq s;
-	int pid;
-
-	pevent->latency_format = latency_format;
-
-	record.ts = nsecs;
-	record.cpu = cpu;
-	record.size = size;
-	record.data = data;
-	pid = pevent_data_pid(pevent, &record);
-
-	if (!pevent_pid_is_registered(pevent, pid))
-		pevent_register_comm(pevent, comm, pid);
-
-	trace_seq_init(&s);
-	pevent_print_event(pevent, &s, &record);
-	trace_seq_do_printf(&s);
-	printf("\n");
-}
-
 void parse_proc_kallsyms(struct pevent *pevent,
 			 char *file, unsigned int size __maybe_unused)
 {
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 3741572..af215c0 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -18,8 +18,6 @@
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
-#define _FILE_OFFSET_BITS 64
-
 #include <dirent.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -41,26 +39,14 @@
 
 static int input_fd;
 
-static int read_page;
-
 int file_bigendian;
 int host_bigendian;
 static int long_size;
 
-static ssize_t calc_data_size;
+static ssize_t trace_data_size;
 static bool repipe;
 
-static void *malloc_or_die(int size)
-{
-	void *ret;
-
-	ret = malloc(size);
-	if (!ret)
-		die("malloc");
-	return ret;
-}
-
-static int do_read(int fd, void *buf, int size)
+static int __do_read(int fd, void *buf, int size)
 {
 	int rsize = size;
 
@@ -73,8 +59,10 @@ static int do_read(int fd, void *buf, int size)
 		if (repipe) {
 			int retw = write(STDOUT_FILENO, buf, ret);
 
-			if (retw <= 0 || retw != ret)
-				die("repiping input file");
+			if (retw <= 0 || retw != ret) {
+				pr_debug("repiping input file");
+				return -1;
+			}
 		}
 
 		size -= ret;
@@ -84,17 +72,18 @@ static int do_read(int fd, void *buf, int size)
 	return rsize;
 }
 
-static int read_or_die(void *data, int size)
+static int do_read(void *data, int size)
 {
 	int r;
 
-	r = do_read(input_fd, data, size);
-	if (r <= 0)
-		die("reading input file (size expected=%d received=%d)",
-		    size, r);
+	r = __do_read(input_fd, data, size);
+	if (r <= 0) {
+		pr_debug("reading input file (size expected=%d received=%d)",
+			 size, r);
+		return -1;
+	}
 
-	if (calc_data_size)
-		calc_data_size += r;
+	trace_data_size += r;
 
 	return r;
 }
@@ -107,7 +96,7 @@ static void skip(int size)
 
 	while (size) {
 		r = size > BUFSIZ ? BUFSIZ : size;
-		read_or_die(buf, r);
+		do_read(buf, r);
 		size -= r;
 	};
 }
@@ -116,7 +105,8 @@ static unsigned int read4(struct pevent *pevent)
 {
 	unsigned int data;
 
-	read_or_die(&data, 4);
+	if (do_read(&data, 4) < 0)
+		return 0;
 	return __data2host4(pevent, data);
 }
 
@@ -124,7 +114,8 @@ static unsigned long long read8(struct pevent *pevent)
 {
 	unsigned long long data;
 
-	read_or_die(&data, 8);
+	if (do_read(&data, 8) < 0)
+		return 0;
 	return __data2host8(pevent, data);
 }
 
@@ -138,17 +129,23 @@ static char *read_string(void)
 
 	for (;;) {
 		r = read(input_fd, &c, 1);
-		if (r < 0)
-			die("reading input file");
+		if (r < 0) {
+			pr_debug("reading input file");
+			goto out;
+		}
 
-		if (!r)
-			die("no data");
+		if (!r) {
+			pr_debug("no data");
+			goto out;
+		}
 
 		if (repipe) {
 			int retw = write(STDOUT_FILENO, &c, 1);
 
-			if (retw <= 0 || retw != r)
-				die("repiping input file string");
+			if (retw <= 0 || retw != r) {
+				pr_debug("repiping input file string");
+				goto out;
+			}
 		}
 
 		buf[size++] = c;
@@ -157,60 +154,79 @@ static char *read_string(void)
 			break;
 	}
 
-	if (calc_data_size)
-		calc_data_size += size;
-
-	str = malloc_or_die(size);
-	memcpy(str, buf, size);
+	trace_data_size += size;
 
+	str = malloc(size);
+	if (str)
+		memcpy(str, buf, size);
+out:
 	return str;
 }
 
-static void read_proc_kallsyms(struct pevent *pevent)
+static int read_proc_kallsyms(struct pevent *pevent)
 {
 	unsigned int size;
 	char *buf;
 
 	size = read4(pevent);
 	if (!size)
-		return;
+		return 0;
+
+	buf = malloc(size + 1);
+	if (buf == NULL)
+		return -1;
 
-	buf = malloc_or_die(size + 1);
-	read_or_die(buf, size);
+	if (do_read(buf, size) < 0) {
+		free(buf);
+		return -1;
+	}
 	buf[size] = '\0';
 
 	parse_proc_kallsyms(pevent, buf, size);
 
 	free(buf);
+	return 0;
 }
 
-static void read_ftrace_printk(struct pevent *pevent)
+static int read_ftrace_printk(struct pevent *pevent)
 {
 	unsigned int size;
 	char *buf;
 
+	/* it can have 0 size */
 	size = read4(pevent);
 	if (!size)
-		return;
+		return 0;
+
+	buf = malloc(size);
+	if (buf == NULL)
+		return -1;
 
-	buf = malloc_or_die(size);
-	read_or_die(buf, size);
+	if (do_read(buf, size) < 0) {
+		free(buf);
+		return -1;
+	}
 
 	parse_ftrace_printk(pevent, buf, size);
 
 	free(buf);
+	return 0;
 }
 
-static void read_header_files(struct pevent *pevent)
+static int read_header_files(struct pevent *pevent)
 {
 	unsigned long long size;
 	char *header_event;
 	char buf[BUFSIZ];
+	int ret = 0;
 
-	read_or_die(buf, 12);
+	if (do_read(buf, 12) < 0)
+		return -1;
 
-	if (memcmp(buf, "header_page", 12) != 0)
-		die("did not read header page");
+	if (memcmp(buf, "header_page", 12) != 0) {
+		pr_debug("did not read header page");
+		return -1;
+	}
 
 	size = read8(pevent);
 	skip(size);
@@ -221,269 +237,107 @@ static void read_header_files(struct pevent *pevent)
 	 */
 	long_size = header_page_size_size;
 
-	read_or_die(buf, 13);
-	if (memcmp(buf, "header_event", 13) != 0)
-		die("did not read header event");
+	if (do_read(buf, 13) < 0)
+		return -1;
+
+	if (memcmp(buf, "header_event", 13) != 0) {
+		pr_debug("did not read header event");
+		return -1;
+	}
 
 	size = read8(pevent);
-	header_event = malloc_or_die(size);
-	read_or_die(header_event, size);
+	header_event = malloc(size);
+	if (header_event == NULL)
+		return -1;
+
+	if (do_read(header_event, size) < 0)
+		ret = -1;
+
 	free(header_event);
+	return ret;
 }
 
-static void read_ftrace_file(struct pevent *pevent, unsigned long long size)
+static int read_ftrace_file(struct pevent *pevent, unsigned long long size)
 {
 	char *buf;
 
-	buf = malloc_or_die(size);
-	read_or_die(buf, size);
+	buf = malloc(size);
+	if (buf == NULL)
+		return -1;
+
+	if (do_read(buf, size) < 0) {
+		free(buf);
+		return -1;
+	}
+
 	parse_ftrace_file(pevent, buf, size);
 	free(buf);
+	return 0;
 }
 
-static void read_event_file(struct pevent *pevent, char *sys,
+static int read_event_file(struct pevent *pevent, char *sys,
 			    unsigned long long size)
 {
 	char *buf;
 
-	buf = malloc_or_die(size);
-	read_or_die(buf, size);
+	buf = malloc(size);
+	if (buf == NULL)
+		return -1;
+
+	if (do_read(buf, size) < 0) {
+		free(buf);
+		return -1;
+	}
+
 	parse_event_file(pevent, buf, size, sys);
 	free(buf);
+	return 0;
 }
 
-static void read_ftrace_files(struct pevent *pevent)
+static int read_ftrace_files(struct pevent *pevent)
 {
 	unsigned long long size;
 	int count;
 	int i;
+	int ret;
 
 	count = read4(pevent);
 
 	for (i = 0; i < count; i++) {
 		size = read8(pevent);
-		read_ftrace_file(pevent, size);
+		ret = read_ftrace_file(pevent, size);
+		if (ret)
+			return ret;
 	}
+	return 0;
 }
 
-static void read_event_files(struct pevent *pevent)
+static int read_event_files(struct pevent *pevent)
 {
 	unsigned long long size;
 	char *sys;
 	int systems;
 	int count;
 	int i,x;
+	int ret;
 
 	systems = read4(pevent);
 
 	for (i = 0; i < systems; i++) {
 		sys = read_string();
+		if (sys == NULL)
+			return -1;
 
 		count = read4(pevent);
+
 		for (x=0; x < count; x++) {
 			size = read8(pevent);
-			read_event_file(pevent, sys, size);
+			ret = read_event_file(pevent, sys, size);
+			if (ret)
+				return ret;
 		}
 	}
-}
-
-struct cpu_data {
-	unsigned long long	offset;
-	unsigned long long	size;
-	unsigned long long	timestamp;
-	struct pevent_record	*next;
-	char			*page;
-	int			cpu;
-	int			index;
-	int			page_size;
-};
-
-static struct cpu_data *cpu_data;
-
-static void update_cpu_data_index(int cpu)
-{
-	cpu_data[cpu].offset += page_size;
-	cpu_data[cpu].size -= page_size;
-	cpu_data[cpu].index = 0;
-}
-
-static void get_next_page(int cpu)
-{
-	off_t save_seek;
-	off_t ret;
-
-	if (!cpu_data[cpu].page)
-		return;
-
-	if (read_page) {
-		if (cpu_data[cpu].size <= page_size) {
-			free(cpu_data[cpu].page);
-			cpu_data[cpu].page = NULL;
-			return;
-		}
-
-		update_cpu_data_index(cpu);
-
-		/* other parts of the code may expect the pointer to not move */
-		save_seek = lseek(input_fd, 0, SEEK_CUR);
-
-		ret = lseek(input_fd, cpu_data[cpu].offset, SEEK_SET);
-		if (ret == (off_t)-1)
-			die("failed to lseek");
-		ret = read(input_fd, cpu_data[cpu].page, page_size);
-		if (ret < 0)
-			die("failed to read page");
-
-		/* reset the file pointer back */
-		lseek(input_fd, save_seek, SEEK_SET);
-
-		return;
-	}
-
-	munmap(cpu_data[cpu].page, page_size);
-	cpu_data[cpu].page = NULL;
-
-	if (cpu_data[cpu].size <= page_size)
-		return;
-
-	update_cpu_data_index(cpu);
-
-	cpu_data[cpu].page = mmap(NULL, page_size, PROT_READ, MAP_PRIVATE,
-				  input_fd, cpu_data[cpu].offset);
-	if (cpu_data[cpu].page == MAP_FAILED)
-		die("failed to mmap cpu %d at offset 0x%llx",
-		    cpu, cpu_data[cpu].offset);
-}
-
-static unsigned int type_len4host(unsigned int type_len_ts)
-{
-	if (file_bigendian)
-		return (type_len_ts >> 27) & ((1 << 5) - 1);
-	else
-		return type_len_ts & ((1 << 5) - 1);
-}
-
-static unsigned int ts4host(unsigned int type_len_ts)
-{
-	if (file_bigendian)
-		return type_len_ts & ((1 << 27) - 1);
-	else
-		return type_len_ts >> 5;
-}
-
-static int calc_index(void *ptr, int cpu)
-{
-	return (unsigned long)ptr - (unsigned long)cpu_data[cpu].page;
-}
-
-struct pevent_record *trace_peek_data(struct pevent *pevent, int cpu)
-{
-	struct pevent_record *data;
-	void *page = cpu_data[cpu].page;
-	int idx = cpu_data[cpu].index;
-	void *ptr = page + idx;
-	unsigned long long extend;
-	unsigned int type_len_ts;
-	unsigned int type_len;
-	unsigned int delta;
-	unsigned int length = 0;
-
-	if (cpu_data[cpu].next)
-		return cpu_data[cpu].next;
-
-	if (!page)
-		return NULL;
-
-	if (!idx) {
-		/* FIXME: handle header page */
-		if (header_page_ts_size != 8)
-			die("expected a long long type for timestamp");
-		cpu_data[cpu].timestamp = data2host8(pevent, ptr);
-		ptr += 8;
-		switch (header_page_size_size) {
-		case 4:
-			cpu_data[cpu].page_size = data2host4(pevent, ptr);
-			ptr += 4;
-			break;
-		case 8:
-			cpu_data[cpu].page_size = data2host8(pevent, ptr);
-			ptr += 8;
-			break;
-		default:
-			die("bad long size");
-		}
-		ptr = cpu_data[cpu].page + header_page_data_offset;
-	}
-
-read_again:
-	idx = calc_index(ptr, cpu);
-
-	if (idx >= cpu_data[cpu].page_size) {
-		get_next_page(cpu);
-		return trace_peek_data(pevent, cpu);
-	}
-
-	type_len_ts = data2host4(pevent, ptr);
-	ptr += 4;
-
-	type_len = type_len4host(type_len_ts);
-	delta = ts4host(type_len_ts);
-
-	switch (type_len) {
-	case RINGBUF_TYPE_PADDING:
-		if (!delta)
-			die("error, hit unexpected end of page");
-		length = data2host4(pevent, ptr);
-		ptr += 4;
-		length *= 4;
-		ptr += length;
-		goto read_again;
-
-	case RINGBUF_TYPE_TIME_EXTEND:
-		extend = data2host4(pevent, ptr);
-		ptr += 4;
-		extend <<= TS_SHIFT;
-		extend += delta;
-		cpu_data[cpu].timestamp += extend;
-		goto read_again;
-
-	case RINGBUF_TYPE_TIME_STAMP:
-		ptr += 12;
-		break;
-	case 0:
-		length = data2host4(pevent, ptr);
-		ptr += 4;
-		die("here! length=%d", length);
-		break;
-	default:
-		length = type_len * 4;
-		break;
-	}
-
-	cpu_data[cpu].timestamp += delta;
-
-	data = malloc_or_die(sizeof(*data));
-	memset(data, 0, sizeof(*data));
-
-	data->ts = cpu_data[cpu].timestamp;
-	data->size = length;
-	data->data = ptr;
-	ptr += length;
-
-	cpu_data[cpu].index = calc_index(ptr, cpu);
-	cpu_data[cpu].next = data;
-
-	return data;
-}
-
-struct pevent_record *trace_read_data(struct pevent *pevent, int cpu)
-{
-	struct pevent_record *data;
-
-	data = trace_peek_data(pevent, cpu);
-	cpu_data[cpu].next = NULL;
-
-	return data;
+	return 0;
 }
 
 ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
@@ -494,58 +348,85 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 	int show_version = 0;
 	int show_funcs = 0;
 	int show_printk = 0;
-	ssize_t size;
+	ssize_t size = -1;
+	struct pevent *pevent;
+	int err;
 
-	calc_data_size = 1;
-	repipe = __repipe;
+	*ppevent = NULL;
 
+	repipe = __repipe;
 	input_fd = fd;
 
-	read_or_die(buf, 3);
-	if (memcmp(buf, test, 3) != 0)
-		die("no trace data in the file");
+	if (do_read(buf, 3) < 0)
+		return -1;
+	if (memcmp(buf, test, 3) != 0) {
+		pr_debug("no trace data in the file");
+		return -1;
+	}
 
-	read_or_die(buf, 7);
-	if (memcmp(buf, "tracing", 7) != 0)
-		die("not a trace file (missing 'tracing' tag)");
+	if (do_read(buf, 7) < 0)
+		return -1;
+	if (memcmp(buf, "tracing", 7) != 0) {
+		pr_debug("not a trace file (missing 'tracing' tag)");
+		return -1;
+	}
 
 	version = read_string();
+	if (version == NULL)
+		return -1;
 	if (show_version)
 		printf("version = %s\n", version);
 	free(version);
 
-	read_or_die(buf, 1);
+	if (do_read(buf, 1) < 0)
+		return -1;
 	file_bigendian = buf[0];
 	host_bigendian = bigendian();
 
-	*ppevent = read_trace_init(file_bigendian, host_bigendian);
-	if (*ppevent == NULL)
-		die("read_trace_init failed");
+	pevent = read_trace_init(file_bigendian, host_bigendian);
+	if (pevent == NULL) {
+		pr_debug("read_trace_init failed");
+		goto out;
+	}
 
-	read_or_die(buf, 1);
+	if (do_read(buf, 1) < 0)
+		goto out;
 	long_size = buf[0];
 
-	page_size = read4(*ppevent);
-
-	read_header_files(*ppevent);
-
-	read_ftrace_files(*ppevent);
-	read_event_files(*ppevent);
-	read_proc_kallsyms(*ppevent);
-	read_ftrace_printk(*ppevent);
-
-	size = calc_data_size - 1;
-	calc_data_size = 0;
+	page_size = read4(pevent);
+	if (!page_size)
+		goto out;
+
+	err = read_header_files(pevent);
+	if (err)
+		goto out;
+	err = read_ftrace_files(pevent);
+	if (err)
+		goto out;
+	err = read_event_files(pevent);
+	if (err)
+		goto out;
+	err = read_proc_kallsyms(pevent);
+	if (err)
+		goto out;
+	err = read_ftrace_printk(pevent);
+	if (err)
+		goto out;
+
+	size = trace_data_size;
 	repipe = false;
 
 	if (show_funcs) {
-		pevent_print_funcs(*ppevent);
-		return size;
-	}
-	if (show_printk) {
-		pevent_print_printk(*ppevent);
-		return size;
+		pevent_print_funcs(pevent);
+	} else if (show_printk) {
+		pevent_print_printk(pevent);
 	}
 
+	*ppevent = pevent;
+	pevent = NULL;
+
+out:
+	if (pevent)
+		pevent_free(pevent);
 	return size;
 }
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index a55fd37..1978c39 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -30,13 +30,9 @@ enum {
 int bigendian(void);
 
 struct pevent *read_trace_init(int file_bigendian, int host_bigendian);
-void print_trace_event(struct pevent *pevent, int cpu, void *data, int size);
 void event_format__print(struct event_format *event,
 			 int cpu, void *data, int size);
 
-void print_event(struct pevent *pevent, int cpu, void *data, int size,
-		 unsigned long long nsecs, char *comm);
-
 int parse_ftrace_file(struct pevent *pevent, char *buf, unsigned long size);
 int parse_event_file(struct pevent *pevent,
 		     char *buf, unsigned long size, char *sys);
@@ -72,7 +68,7 @@ struct tracing_data {
 
 struct tracing_data *tracing_data_get(struct list_head *pattrs,
 				      int fd, bool temp);
-void tracing_data_put(struct tracing_data *tdata);
+int tracing_data_put(struct tracing_data *tdata);
 
 
 struct addr_location;
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 805d1f5..59d868a 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -17,6 +17,8 @@ bool test_attr__enabled;
 bool perf_host  = true;
 bool perf_guest = false;
 
+char tracing_events_path[PATH_MAX + 1] = "/sys/kernel/debug/tracing/events";
+
 void event_attr_init(struct perf_event_attr *attr)
 {
 	if (!perf_host)
@@ -242,3 +244,28 @@ void get_term_dimensions(struct winsize *ws)
 	ws->ws_row = 25;
 	ws->ws_col = 80;
 }
+
+static void set_tracing_events_path(const char *mountpoint)
+{
+	snprintf(tracing_events_path, sizeof(tracing_events_path), "%s/%s",
+		 mountpoint, "tracing/events");
+}
+
+const char *perf_debugfs_mount(const char *mountpoint)
+{
+	const char *mnt;
+
+	mnt = debugfs_mount(mountpoint);
+	if (!mnt)
+		return NULL;
+
+	set_tracing_events_path(mnt);
+
+	return mnt;
+}
+
+void perf_debugfs_set_path(const char *mntpt)
+{
+	snprintf(debugfs_mountpoint, strlen(debugfs_mountpoint), "%s", mntpt);
+	set_tracing_events_path(mntpt);
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 09b4c26..a45710b 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -1,8 +1,6 @@
 #ifndef GIT_COMPAT_UTIL_H
 #define GIT_COMPAT_UTIL_H
 
-#define _FILE_OFFSET_BITS 64
-
 #ifndef FLEX_ARRAY
 /*
  * See if our compiler is known to support flexible array members.
@@ -73,10 +71,14 @@
 #include <linux/magic.h>
 #include "types.h"
 #include <sys/ttydefaults.h>
+#include <lk/debugfs.h>
 
 extern const char *graph_line;
 extern const char *graph_dotted_line;
 extern char buildid_dir[];
+extern char tracing_events_path[];
+extern void perf_debugfs_set_path(const char *mountpoint);
+const char *perf_debugfs_mount(const char *mountpoint);
 
 /* On most systems <limits.h> would have given us this, but
  * not on some systems (e.g. GNU/Hurd).
@@ -274,5 +276,4 @@ extern unsigned int page_size;
 
 struct winsize;
 void get_term_dimensions(struct winsize *ws);
-
-#endif
+#endif /* GIT_COMPAT_UTIL_H */
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 2964b96..f03e681 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -1,3 +1,4 @@
+ifneq ($(O),)
 ifeq ($(origin O), command line)
 	dummy := $(if $(shell test -d $(O) || echo $(O)),$(error O=$(O) does not exist),)
 	ABSOLUTE_O := $(shell cd $(O) ; pwd)
@@ -7,9 +8,10 @@ ifeq ($(objtree),)
 	objtree := $(O)
 endif
 endif
+endif
 
-ifneq ($(OUTPUT),)
 # check that the output directory actually exists
+ifneq ($(OUTPUT),)
 OUTDIR := $(shell cd $(OUTPUT) && /bin/pwd)
 $(if $(OUTDIR),, $(error output directory "$(OUTPUT)" does not exist))
 endif
@@ -70,7 +72,7 @@ ifndef V
 	QUIET_BISON    = @echo '   ' BISON $@;
 
 	descend = \
-		@echo '   ' DESCEND $(1); \
+		+@echo '   ' DESCEND $(1); \
 		mkdir -p $(OUTPUT)$(1) && \
 		$(MAKE) $(COMMAND_O) subdir=$(if $(subdir),$(subdir)/$(1),$(1)) $(PRINT_DIR) -C $(1) $(2)
 endif
diff --git a/tools/vm/Makefile b/tools/vm/Makefile
index 8e30e5c..24e9ddd 100644
--- a/tools/vm/Makefile
+++ b/tools/vm/Makefile
@@ -1,11 +1,22 @@
 # Makefile for vm tools
+#
+TARGETS=page-types slabinfo
+
+LK_DIR = ../lib/lk
+LIBLK = $(LK_DIR)/liblk.a
 
 CC = $(CROSS_COMPILE)gcc
-CFLAGS = -Wall -Wextra
+CFLAGS = -Wall -Wextra -I../lib/
+LDFLAGS = $(LIBLK)
+
+$(TARGETS): liblk
+
+liblk:
+	make -C $(LK_DIR)
 
-all: page-types slabinfo
 %: %.c
-	$(CC) $(CFLAGS) -o $@ $^
+	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)
 
 clean:
 	$(RM) page-types slabinfo
+	make -C ../lib/lk clean
diff --git a/tools/vm/page-types.c b/tools/vm/page-types.c
index b76edf2..71c9c25 100644
--- a/tools/vm/page-types.c
+++ b/tools/vm/page-types.c
@@ -36,7 +36,7 @@
 #include <sys/statfs.h>
 #include "../../include/uapi/linux/magic.h"
 #include "../../include/uapi/linux/kernel-page-flags.h"
-
+#include <lk/debugfs.h>
 
 #ifndef MAX_PATH
 # define MAX_PATH 256
@@ -178,7 +178,7 @@ static int		kpageflags_fd;
 static int		opt_hwpoison;
 static int		opt_unpoison;
 
-static char		hwpoison_debug_fs[MAX_PATH+1];
+static char		*hwpoison_debug_fs;
 static int		hwpoison_inject_fd;
 static int		hwpoison_forget_fd;
 
@@ -458,81 +458,6 @@ static uint64_t kpageflags_flags(uint64_t flags)
 	return flags;
 }
 
-/* verify that a mountpoint is actually a debugfs instance */
-static int debugfs_valid_mountpoint(const char *debugfs)
-{
-	struct statfs st_fs;
-
-	if (statfs(debugfs, &st_fs) < 0)
-		return -ENOENT;
-	else if (st_fs.f_type != (long) DEBUGFS_MAGIC)
-		return -ENOENT;
-
-	return 0;
-}
-
-/* find the path to the mounted debugfs */
-static const char *debugfs_find_mountpoint(void)
-{
-	const char *const *ptr;
-	char type[100];
-	FILE *fp;
-
-	ptr = debugfs_known_mountpoints;
-	while (*ptr) {
-		if (debugfs_valid_mountpoint(*ptr) == 0) {
-			strcpy(hwpoison_debug_fs, *ptr);
-			return hwpoison_debug_fs;
-		}
-		ptr++;
-	}
-
-	/* give up and parse /proc/mounts */
-	fp = fopen("/proc/mounts", "r");
-	if (fp == NULL)
-		perror("Can't open /proc/mounts for read");
-
-	while (fscanf(fp, "%*s %"
-		      STR(MAX_PATH)
-		      "s %99s %*s %*d %*d\n",
-		      hwpoison_debug_fs, type) == 2) {
-		if (strcmp(type, "debugfs") == 0)
-			break;
-	}
-	fclose(fp);
-
-	if (strcmp(type, "debugfs") != 0)
-		return NULL;
-
-	return hwpoison_debug_fs;
-}
-
-/* mount the debugfs somewhere if it's not mounted */
-
-static void debugfs_mount(void)
-{
-	const char *const *ptr;
-
-	/* see if it's already mounted */
-	if (debugfs_find_mountpoint())
-		return;
-
-	ptr = debugfs_known_mountpoints;
-	while (*ptr) {
-		if (mount(NULL, *ptr, "debugfs", 0, NULL) == 0) {
-			/* save the mountpoint */
-			strcpy(hwpoison_debug_fs, *ptr);
-			break;
-		}
-		ptr++;
-	}
-
-	if (*ptr == NULL) {
-		perror("mount debugfs");
-		exit(EXIT_FAILURE);
-	}
-}
-
 /*
  * page actions
  */
@@ -541,7 +466,11 @@ static void prepare_hwpoison_fd(void)
 {
 	char buf[MAX_PATH + 1];
 
-	debugfs_mount();
+	hwpoison_debug_fs = debugfs_mount(NULL);
+	if (!hwpoison_debug_fs) {
+		perror("mount debugfs");
+		exit(EXIT_FAILURE);
+	}
 
 	if (opt_hwpoison && !hwpoison_inject_fd) {
 		snprintf(buf, MAX_PATH, "%s/hwpoison/corrupt-pfn",
