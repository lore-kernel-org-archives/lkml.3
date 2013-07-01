Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab3GAJEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:04:10 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:54371 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab3GAJEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:04:02 -0400
Date: Mon, 1 Jul 2013 11:03:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf changes for v3.11
Message-ID: <20130701090356.GA14912@gmail.com>
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

   HEAD: 983433b5812c5cf33a9008fa38c6f9b407fedb76 perf/x86: Disable PEBS-LL in intel_pmu_pebs_disable()

The main changes:

Kernel improvements:

 * watchdog driver improvements by Li Zefan
 * Power7 CPI stack events related improvements by Sukadev Bhattiprolu
 * event multiplexing via hrtimers and other improvements by Stephane Eranian
 * kernel stack use optimization by Andrew Hunter
 * AMD IOMMU uncore PMU support by Suravee Suthikulpanit
 * NMI handling rate-limits by Dave Hansen
 * various hw_breakpoint fixes by Oleg Nesterov
 * hw_breakpoint overflow period sampling and related signal handling fixes by Jiri Olsa
 * Intel Haswell PMU support by Andi Kleen

Tooling improvements:

 * Reset SIGTERM handler in workload child process, fix from David Ahern.
 * Makefile reorganization, prep work for Kconfig patches, from Jiri Olsa.
 * Add automated make test suite, from Jiri Olsa.
 * Add --percent-limit option to 'top' and 'report', from Namhyung Kim.
 * Sorting improvements, from Namhyung Kim.
 * Expand definition of sysfs format attribute, from Michael Ellerman.

Tooling fixes:

 * 'perf tests' fixes from Jiri Olsa.
 * Make Power7 CPI stack events available in sysfs, from Sukadev Bhattiprolu.
 * Handle death by SIGTERM in 'perf record', fix from David Ahern.
 * Fix printing of perf_event_paranoid message, from David Ahern.
 * Handle realloc failures in 'perf kvm', from David Ahern.
 * Fix divide by 0 in variance, from David Ahern.
 * Save parent pid in thread struct, from David Ahern.
 * Handle JITed code in shared memory, from Andi Kleen.
 * Fixes for 'perf diff', from Jiri Olsa.
 * Remove some unused struct members, from Jiri Olsa.
 * Add missing liblk.a dependency for python/perf.so, fix from Jiri Olsa.
 * Respect CROSS_COMPILE in liblk.a, from Rabin Vincent.
 * No need to do locking when adding hists in perf report, only 'top'
   needs that, from Namhyung Kim.
 * Fix alignment of symbol column in in the hists browser (top, report)
   when -v is given, from NAmhyung Kim.
 * Fix 'perf top' -E option behavior, from Namhyung Kim.
 * Fix bug in isupper() and islower(), from Sukadev Bhattiprolu.
 * Fix compile errors in bp_signal 'perf test', from Sukadev Bhattiprolu.

... and more things.

 Thanks,

	Ingo

------------------>
Andi Kleen (8):
      perf tools: Handle JITed code in shared memory
      perf/x86/intel: Add Haswell PEBS record support
      perf/x86/intel: Add simple Haswell PMU support
      perf/x86/intel: Add Haswell PEBS support
      perf/x86/intel: Move NMI clearing to end of PMI handler
      perf/x86/intel: Support Haswell/v4 LBR format
      perf/x86/intel: Add mem-loads/stores support for Haswell
      perf/x86/intel: Support full width counting

Andrew Hunter (1):
      perf/x86: Reduce stack usage of x86_schedule_events()

Arnaldo Carvalho de Melo (3):
      perf archive: Fix typo on Documentation
      perf hists browser: Use sort__has_sym
      perf test: Fix typo

Dan Carpenter (1):
      perf/x86/intel: Prevent some shift wrapping bugs in the Intel uncore driver

Dave Hansen (4):
      perf/x86: Only print PMU state when also WARN()'ing
      x86: Warn when NMI handlers take large amounts of time
      perf: Drop sample rate when sampling is too slow
      x86: Add NMI duration tracepoints

David Ahern (6):
      perf record: handle death by SIGTERM
      perf evsel: Fix printing of perf_event_paranoid message
      perf kvm: Handle realloc failures
      perf stats: Fix divide by 0 in variance
      perf  tools: Save parent pid in thread struct
      perf evlist: Reset SIGTERM handler in workload child process

Jiri Olsa (36):
      x86/signals: Propagate RF EFLAGS bit through the signal restore call
      x86/signals: Clear RF EFLAGS bit for signal handler
      x86/signals: Merge EFLAGS bit clearing into a single statement
      perf: Fix hw breakpoints overflow period sampling
      perf tools: Fix tab vs spaces issue in Makefile ifdef/endif
      perf diff: Use internal rb tree for hists__precompute
      perf hists: Rename hist_entry__add_pair arguments
      perf tools: Add automated make test suite
      perf tools: Move arch check into config/Makefile
      perf tools: Move programs check into config/Makefile
      perf tools: Move compiler and linker flags check into config/Makefile
      perf tools: Move libelf check config into config/Makefile
      perf tools: Move libdw check config into config/Makefile
      perf tools: Move libunwind check config into config/Makefile
      perf tools: Move libaudit check config into config/Makefile
      perf tools: Move slang check config into config/Makefile
      perf tools: Move gtk2 check config into config/Makefile
      perf tools: Move libperl check config into config/Makefile
      perf tools: Move libpython check config into config/Makefile
      perf tools: Move libbfd check config into config/Makefile
      perf tools: Move stdlib check config into config/Makefile
      perf tools: Move libnuma check config into config/Makefile
      perf tools: Move paths config into config/Makefile
      perf tools: Final touches for CHK config move
      perf tests: Fix attr test for record -d option
      perf tests: Fix exclude_guest|exclude_host checking for attr tests
      perf tools: Remove frozen from perf_header struct
      perf tools: Remove cwdlen from struct perf_session
      perf tools: Merge all *CFLAGS* make variable into CFLAGS
      perf tools: Merge all *LDFLAGS* make variable into LDFLAGS
      perf tools: Switch to full path C include directories
      perf tools: Add NO_BIONIC variable to confiure bionic setup
      perf tools: Replace tabs with spaces for all non-commands statements
      perf tools: Replace multiple line assignment with multiple statements
      perf tools: Remove '?=' Makefile STRIP assignment
      perf tools: Add missing liblk.a dependency for python/perf.so

Li Zefan (3):
      watchdog: Disallow setting watchdog_thresh to -1
      watchdog: Document watchdog_thresh sysctl
      watchdog: Remove softlockup_thresh from Documentation

Michael Ellerman (1):
      perf: Expand definition of sysfs format attribute

Mischa Jonker (1):
      perf: Add const qualifier to perf_pmu_register's 'name' arg

Namhyung Kim (18):
      perf hists: Fix an invalid memory free on he->branch_info
      perf hists: Free unused mem info of a matched hist entry
      perf report: Fix alignment of symbol column when -v is given
      perf sort: Introduce sort__mode variable
      perf sort: Factor out common code in sort_dimension__add()
      perf sort: Separate out memory-specific sort keys
      perf sort: Consolidate sort_entry__setup_elide()
      perf sort: Reorder HISTC_SRCLINE index
      perf sort: Cleanup sort__has_sym setting
      perf top: Use sort__has_sym
      perf top: Fix -E option behavior
      perf top: Fix percent output when no samples collected
      perf top: Get rid of *_threaded() functions
      perf hists: Move locking to its call-sites
      perf report: Don't bother locking when adding hist entries
      perf report: Add --percent-limit option
      perf top: Add --percent-limit option
      perf report: Add report.percent-limit config variable

Oleg Nesterov (5):
      hw_breakpoint: Simplify list/idx mess in toggle_bp_slot() paths
      hw_breakpoint: Simplify the "weight" usage in toggle_bp_slot() paths
      hw_breakpoint: Introduce cpumask_of_bp()
      hw_breakpoint: Simplify *register_wide_hw_breakpoint()
      hw_breakpoint: Introduce "struct bp_cpuinfo"

Peter Zijlstra (1):
      perf/x86/amd: Rework AMD PMU init code

Rabin Vincent (1):
      tools lib lk: Respect CROSS_COMPILE

Stephane Eranian (6):
      perf: Use hrtimers for event multiplexing
      perf: Add sysfs entry to adjust multiplexing interval per PMU
      perf/x86: Check branch sampling priv level in generic code
      perf: Fix hypervisor branch sampling permission check
      perf/x86: Fix shared register mutual exclusion enforcement
      perf/x86: Disable PEBS-LL in intel_pmu_pebs_disable()

Steven L Kinney (1):
      perf/x86/amd: Add IOMMU Performance Counter resource management

Sukadev Bhattiprolu (4):
      perf tools: Fix bug in isupper() and islower()
      perf tests: Fix compile errors in bp_signal files
      perf: Power7: Make CPI stack events available in sysfs
      perf: Power7 Update testing ABI to list CPI-stack events

Suravee Suthikulpanit (1):
      perf/x86/amd: AMD IOMMU Performance Counter PERF uncore PMU implementation

Yan, Zheng (1):
      perf/x86/intel: Fix sparse warning


 .../testing/sysfs-bus-event_source-devices-events  |  32 +-
 .../testing/sysfs-bus-event_source-devices-format  |   6 +
 Documentation/sysctl/kernel.txt                    |  50 +-
 Documentation/trace/events-nmi.txt                 |  43 ++
 arch/metag/kernel/perf/perf_event.c                |   2 +-
 arch/powerpc/perf/power7-pmu.c                     |  73 +++
 arch/x86/ia32/ia32_signal.c                        |   2 -
 arch/x86/include/asm/perf_event.h                  |   3 +
 arch/x86/include/asm/sighandling.h                 |   4 +-
 arch/x86/include/uapi/asm/msr-index.h              |   3 +
 arch/x86/kernel/cpu/Makefile                       |   4 +
 arch/x86/kernel/cpu/perf_event.c                   |  69 ++-
 arch/x86/kernel/cpu/perf_event.h                   |  24 +-
 arch/x86/kernel/cpu/perf_event_amd.c               |  34 +-
 arch/x86/kernel/cpu/perf_event_amd_iommu.c         | 504 +++++++++++++++++
 arch/x86/kernel/cpu/perf_event_amd_iommu.h         |  40 ++
 arch/x86/kernel/cpu/perf_event_intel.c             | 136 ++++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c          | 178 +++++-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c         |  69 ++-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c      |  16 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.h      |   4 +-
 arch/x86/kernel/nmi.c                              |  36 +-
 arch/x86/kernel/signal.c                           |  16 +-
 drivers/iommu/amd_iommu_init.c                     | 140 ++++-
 drivers/iommu/amd_iommu_proto.h                    |   7 +
 drivers/iommu/amd_iommu_types.h                    |  15 +-
 include/linux/perf_event.h                         |  28 +-
 include/trace/events/nmi.h                         |  37 ++
 include/uapi/linux/perf_event.h                    |   5 +-
 init/main.c                                        |   2 +-
 kernel/events/core.c                               | 278 ++++++++-
 kernel/events/hw_breakpoint.c                      | 191 +++----
 kernel/sysctl.c                                    |  12 +-
 tools/lib/lk/Makefile                              |   3 +
 tools/perf/Documentation/perf-archive.txt          |   2 +-
 tools/perf/Documentation/perf-report.txt           |   4 +
 tools/perf/Documentation/perf-top.txt              |   4 +
 tools/perf/Makefile                                | 630 ++++-----------------
 tools/perf/builtin-diff.c                          |  19 +-
 tools/perf/builtin-kvm.c                           |   3 +
 tools/perf/builtin-record.c                        |   2 +-
 tools/perf/builtin-report.c                        | 102 ++--
 tools/perf/builtin-top.c                           |  74 +--
 tools/perf/config/Makefile                         | 477 ++++++++++++++++
 tools/perf/tests/attr/base-record                  |   4 +-
 tools/perf/tests/attr/base-stat                    |   4 +-
 tools/perf/tests/attr/test-record-data             |   5 +-
 tools/perf/tests/bp_signal.c                       |   6 +
 tools/perf/tests/bp_signal_overflow.c              |   6 +
 tools/perf/tests/builtin-test.c                    |   2 +-
 tools/perf/tests/make                              | 138 +++++
 tools/perf/ui/browsers/hists.c                     | 106 +++-
 tools/perf/ui/gtk/hists.c                          |  13 +-
 tools/perf/ui/stdio/hist.c                         |   7 +-
 tools/perf/util/evlist.c                           |   2 +
 tools/perf/util/evsel.c                            |   2 +-
 tools/perf/util/header.c                           |   2 -
 tools/perf/util/header.h                           |   1 -
 tools/perf/util/hist.c                             |  96 ++--
 tools/perf/util/hist.h                             |  16 +-
 tools/perf/util/map.c                              |   1 +
 tools/perf/util/session.h                          |   1 -
 tools/perf/util/setup.py                           |   5 +-
 tools/perf/util/sort.c                             | 128 +++--
 tools/perf/util/sort.h                             |  36 +-
 tools/perf/util/stat.c                             |   2 +-
 tools/perf/util/thread.c                           |   4 +
 tools/perf/util/thread.h                           |   1 +
 tools/perf/util/top.c                              |  23 +-
 tools/perf/util/top.h                              |   2 +-
 tools/perf/util/util.h                             |   4 +-
 71 files changed, 2947 insertions(+), 1053 deletions(-)
 create mode 100644 Documentation/trace/events-nmi.txt
 create mode 100644 arch/x86/kernel/cpu/perf_event_amd_iommu.c
 create mode 100644 arch/x86/kernel/cpu/perf_event_amd_iommu.h
 create mode 100644 include/trace/events/nmi.h
 create mode 100644 tools/perf/config/Makefile
 create mode 100644 tools/perf/tests/make

diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-events b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
index 0adeb52..8b25ffb 100644
--- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
@@ -27,14 +27,36 @@ Description:	Generic performance monitoring events
 		"basename".
 
 
-What: 		/sys/devices/cpu/events/PM_LD_MISS_L1
-		/sys/devices/cpu/events/PM_LD_REF_L1
-		/sys/devices/cpu/events/PM_CYC
+What: 		/sys/devices/cpu/events/PM_1PLUS_PPC_CMPL
 		/sys/devices/cpu/events/PM_BRU_FIN
-		/sys/devices/cpu/events/PM_GCT_NOSLOT_CYC
 		/sys/devices/cpu/events/PM_BRU_MPRED
-		/sys/devices/cpu/events/PM_INST_CMPL
 		/sys/devices/cpu/events/PM_CMPLU_STALL
+		/sys/devices/cpu/events/PM_CMPLU_STALL_BRU
+		/sys/devices/cpu/events/PM_CMPLU_STALL_DCACHE_MISS
+		/sys/devices/cpu/events/PM_CMPLU_STALL_DFU
+		/sys/devices/cpu/events/PM_CMPLU_STALL_DIV
+		/sys/devices/cpu/events/PM_CMPLU_STALL_ERAT_MISS
+		/sys/devices/cpu/events/PM_CMPLU_STALL_FXU
+		/sys/devices/cpu/events/PM_CMPLU_STALL_IFU
+		/sys/devices/cpu/events/PM_CMPLU_STALL_LSU
+		/sys/devices/cpu/events/PM_CMPLU_STALL_REJECT
+		/sys/devices/cpu/events/PM_CMPLU_STALL_SCALAR
+		/sys/devices/cpu/events/PM_CMPLU_STALL_SCALAR_LONG
+		/sys/devices/cpu/events/PM_CMPLU_STALL_STORE
+		/sys/devices/cpu/events/PM_CMPLU_STALL_THRD
+		/sys/devices/cpu/events/PM_CMPLU_STALL_VECTOR
+		/sys/devices/cpu/events/PM_CMPLU_STALL_VECTOR_LONG
+		/sys/devices/cpu/events/PM_CYC
+		/sys/devices/cpu/events/PM_GCT_NOSLOT_BR_MPRED
+		/sys/devices/cpu/events/PM_GCT_NOSLOT_BR_MPRED_IC_MISS
+		/sys/devices/cpu/events/PM_GCT_NOSLOT_CYC
+		/sys/devices/cpu/events/PM_GCT_NOSLOT_IC_MISS
+		/sys/devices/cpu/events/PM_GRP_CMPL
+		/sys/devices/cpu/events/PM_INST_CMPL
+		/sys/devices/cpu/events/PM_LD_MISS_L1
+		/sys/devices/cpu/events/PM_LD_REF_L1
+		/sys/devices/cpu/events/PM_RUN_CYC
+		/sys/devices/cpu/events/PM_RUN_INST_CMPL
 
 Date:		2013/01/08
 
diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-format b/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
index 079afc7..77f47ff 100644
--- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
@@ -9,6 +9,12 @@ Description:
 		we want to export, so that userspace can deal with sane
 		name/value pairs.
 
+		Userspace must be prepared for the possibility that attributes
+		define overlapping bit ranges. For example:
+			attr1 = 'config:0-23'
+			attr2 = 'config:0-7'
+			attr3 = 'config:12-35'
+
 		Example: 'config1:1,6-10,44'
 		Defines contents of attribute that occupies bits 1,6-10,44 of
 		perf_event_attr::config1.
diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index ccd4258..ab7d16e 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -70,12 +70,12 @@ show up in /proc/sys/kernel:
 - shmall
 - shmmax                      [ sysv ipc ]
 - shmmni
-- softlockup_thresh
 - stop-a                      [ SPARC only ]
 - sysrq                       ==> Documentation/sysrq.txt
 - tainted
 - threads-max
 - unknown_nmi_panic
+- watchdog_thresh
 - version
 
 ==============================================================
@@ -427,6 +427,32 @@ This file shows up if CONFIG_DEBUG_STACKOVERFLOW is enabled.
 
 ==============================================================
 
+perf_cpu_time_max_percent:
+
+Hints to the kernel how much CPU time it should be allowed to
+use to handle perf sampling events.  If the perf subsystem
+is informed that its samples are exceeding this limit, it
+will drop its sampling frequency to attempt to reduce its CPU
+usage.
+
+Some perf sampling happens in NMIs.  If these samples
+unexpectedly take too long to execute, the NMIs can become
+stacked up next to each other so much that nothing else is
+allowed to execute.
+
+0: disable the mechanism.  Do not monitor or correct perf's
+   sampling rate no matter how CPU time it takes.
+
+1-100: attempt to throttle perf's sample rate to this
+   percentage of CPU.  Note: the kernel calculates an
+   "expected" length of each sample event.  100 here means
+   100% of that expected length.  Even if this is set to
+   100, you may still see sample throttling if this
+   length is exceeded.  Set to 0 if you truly do not care
+   how much CPU is consumed.
+
+==============================================================
+
 
 pid_max:
 
@@ -604,15 +630,6 @@ without users and with a dead originative process will be destroyed.
 
 ==============================================================
 
-softlockup_thresh:
-
-This value can be used to lower the softlockup tolerance threshold.  The
-default threshold is 60 seconds.  If a cpu is locked up for 60 seconds,
-the kernel complains.  Valid values are 1-60 seconds.  Setting this
-tunable to zero will disable the softlockup detection altogether.
-
-==============================================================
-
 tainted:
 
 Non-zero if the kernel has been tainted.  Numeric values, which
@@ -648,3 +665,16 @@ that time, kernel debugging information is displayed on console.
 
 NMI switch that most IA32 servers have fires unknown NMI up, for
 example.  If a system hangs up, try pressing the NMI switch.
+
+==============================================================
+
+watchdog_thresh:
+
+This value can be used to control the frequency of hrtimer and NMI
+events and the soft and hard lockup thresholds. The default threshold
+is 10 seconds.
+
+The softlockup threshold is (2 * watchdog_thresh). Setting this
+tunable to zero will disable lockup detection altogether.
+
+==============================================================
diff --git a/Documentation/trace/events-nmi.txt b/Documentation/trace/events-nmi.txt
new file mode 100644
index 0000000..c03c8c8
--- /dev/null
+++ b/Documentation/trace/events-nmi.txt
@@ -0,0 +1,43 @@
+NMI Trace Events
+
+These events normally show up here:
+
+	/sys/kernel/debug/tracing/events/nmi
+
+--
+
+nmi_handler:
+
+You might want to use this tracepoint if you suspect that your
+NMI handlers are hogging large amounts of CPU time.  The kernel
+will warn if it sees long-running handlers:
+
+	INFO: NMI handler took too long to run: 9.207 msecs
+
+and this tracepoint will allow you to drill down and get some
+more details.
+
+Let's say you suspect that perf_event_nmi_handler() is causing
+you some problems and you only want to trace that handler
+specifically.  You need to find its address:
+
+	$ grep perf_event_nmi_handler /proc/kallsyms
+	ffffffff81625600 t perf_event_nmi_handler
+
+Let's also say you are only interested in when that function is
+really hogging a lot of CPU time, like a millisecond at a time.
+Note that the kernel's output is in milliseconds, but the input
+to the filter is in nanoseconds!  You can filter on 'delta_ns':
+
+cd /sys/kernel/debug/tracing/events/nmi/nmi_handler
+echo 'handler==0xffffffff81625600 && delta_ns>1000000' > filter
+echo 1 > enable
+
+Your output would then look like:
+
+$ cat /sys/kernel/debug/tracing/trace_pipe
+<idle>-0     [000] d.h3   505.397558: nmi_handler: perf_event_nmi_handler() delta_ns: 3236765 handled: 1
+<idle>-0     [000] d.h3   505.805893: nmi_handler: perf_event_nmi_handler() delta_ns: 3174234 handled: 1
+<idle>-0     [000] d.h3   506.158206: nmi_handler: perf_event_nmi_handler() delta_ns: 3084642 handled: 1
+<idle>-0     [000] d.h3   506.334346: nmi_handler: perf_event_nmi_handler() delta_ns: 3080351 handled: 1
+
diff --git a/arch/metag/kernel/perf/perf_event.c b/arch/metag/kernel/perf/perf_event.c
index 3665694..5b18888 100644
--- a/arch/metag/kernel/perf/perf_event.c
+++ b/arch/metag/kernel/perf/perf_event.c
@@ -882,7 +882,7 @@ static int __init init_hw_perf_events(void)
 	}
 
 	register_cpu_notifier(&metag_pmu_notifier);
-	ret = perf_pmu_register(&pmu, (char *)metag_pmu->name, PERF_TYPE_RAW);
+	ret = perf_pmu_register(&pmu, metag_pmu->name, PERF_TYPE_RAW);
 out:
 	return ret;
 }
diff --git a/arch/powerpc/perf/power7-pmu.c b/arch/powerpc/perf/power7-pmu.c
index 3c475d6..13c3f0e 100644
--- a/arch/powerpc/perf/power7-pmu.c
+++ b/arch/powerpc/perf/power7-pmu.c
@@ -62,6 +62,29 @@
 #define	PME_PM_BRU_FIN			0x10068
 #define	PME_PM_BRU_MPRED		0x400f6
 
+#define PME_PM_CMPLU_STALL_FXU			0x20014
+#define PME_PM_CMPLU_STALL_DIV			0x40014
+#define PME_PM_CMPLU_STALL_SCALAR		0x40012
+#define PME_PM_CMPLU_STALL_SCALAR_LONG		0x20018
+#define PME_PM_CMPLU_STALL_VECTOR		0x2001c
+#define PME_PM_CMPLU_STALL_VECTOR_LONG		0x4004a
+#define PME_PM_CMPLU_STALL_LSU			0x20012
+#define PME_PM_CMPLU_STALL_REJECT		0x40016
+#define PME_PM_CMPLU_STALL_ERAT_MISS		0x40018
+#define PME_PM_CMPLU_STALL_DCACHE_MISS		0x20016
+#define PME_PM_CMPLU_STALL_STORE		0x2004a
+#define PME_PM_CMPLU_STALL_THRD			0x1001c
+#define PME_PM_CMPLU_STALL_IFU			0x4004c
+#define PME_PM_CMPLU_STALL_BRU			0x4004e
+#define PME_PM_GCT_NOSLOT_IC_MISS		0x2001a
+#define PME_PM_GCT_NOSLOT_BR_MPRED		0x4001a
+#define PME_PM_GCT_NOSLOT_BR_MPRED_IC_MISS	0x4001c
+#define PME_PM_GRP_CMPL				0x30004
+#define PME_PM_1PLUS_PPC_CMPL			0x100f2
+#define PME_PM_CMPLU_STALL_DFU			0x2003c
+#define PME_PM_RUN_CYC				0x200f4
+#define PME_PM_RUN_INST_CMPL			0x400fa
+
 /*
  * Layout of constraint bits:
  * 6666555555555544444444443333333333222222222211111111110000000000
@@ -393,6 +416,31 @@ POWER_EVENT_ATTR(LD_MISS_L1,			LD_MISS_L1);
 POWER_EVENT_ATTR(BRU_FIN,			BRU_FIN)
 POWER_EVENT_ATTR(BRU_MPRED,			BRU_MPRED);
 
+POWER_EVENT_ATTR(CMPLU_STALL_FXU,		CMPLU_STALL_FXU);
+POWER_EVENT_ATTR(CMPLU_STALL_DIV,		CMPLU_STALL_DIV);
+POWER_EVENT_ATTR(CMPLU_STALL_SCALAR,		CMPLU_STALL_SCALAR);
+POWER_EVENT_ATTR(CMPLU_STALL_SCALAR_LONG,	CMPLU_STALL_SCALAR_LONG);
+POWER_EVENT_ATTR(CMPLU_STALL_VECTOR,		CMPLU_STALL_VECTOR);
+POWER_EVENT_ATTR(CMPLU_STALL_VECTOR_LONG,	CMPLU_STALL_VECTOR_LONG);
+POWER_EVENT_ATTR(CMPLU_STALL_LSU,		CMPLU_STALL_LSU);
+POWER_EVENT_ATTR(CMPLU_STALL_REJECT,		CMPLU_STALL_REJECT);
+
+POWER_EVENT_ATTR(CMPLU_STALL_ERAT_MISS,		CMPLU_STALL_ERAT_MISS);
+POWER_EVENT_ATTR(CMPLU_STALL_DCACHE_MISS,	CMPLU_STALL_DCACHE_MISS);
+POWER_EVENT_ATTR(CMPLU_STALL_STORE,		CMPLU_STALL_STORE);
+POWER_EVENT_ATTR(CMPLU_STALL_THRD,		CMPLU_STALL_THRD);
+POWER_EVENT_ATTR(CMPLU_STALL_IFU,		CMPLU_STALL_IFU);
+POWER_EVENT_ATTR(CMPLU_STALL_BRU,		CMPLU_STALL_BRU);
+POWER_EVENT_ATTR(GCT_NOSLOT_IC_MISS,		GCT_NOSLOT_IC_MISS);
+
+POWER_EVENT_ATTR(GCT_NOSLOT_BR_MPRED,		GCT_NOSLOT_BR_MPRED);
+POWER_EVENT_ATTR(GCT_NOSLOT_BR_MPRED_IC_MISS,	GCT_NOSLOT_BR_MPRED_IC_MISS);
+POWER_EVENT_ATTR(GRP_CMPL,			GRP_CMPL);
+POWER_EVENT_ATTR(1PLUS_PPC_CMPL,		1PLUS_PPC_CMPL);
+POWER_EVENT_ATTR(CMPLU_STALL_DFU,		CMPLU_STALL_DFU);
+POWER_EVENT_ATTR(RUN_CYC,			RUN_CYC);
+POWER_EVENT_ATTR(RUN_INST_CMPL,			RUN_INST_CMPL);
+
 static struct attribute *power7_events_attr[] = {
 	GENERIC_EVENT_PTR(CYC),
 	GENERIC_EVENT_PTR(GCT_NOSLOT_CYC),
@@ -411,6 +459,31 @@ static struct attribute *power7_events_attr[] = {
 	POWER_EVENT_PTR(LD_MISS_L1),
 	POWER_EVENT_PTR(BRU_FIN),
 	POWER_EVENT_PTR(BRU_MPRED),
+
+	POWER_EVENT_PTR(CMPLU_STALL_FXU),
+	POWER_EVENT_PTR(CMPLU_STALL_DIV),
+	POWER_EVENT_PTR(CMPLU_STALL_SCALAR),
+	POWER_EVENT_PTR(CMPLU_STALL_SCALAR_LONG),
+	POWER_EVENT_PTR(CMPLU_STALL_VECTOR),
+	POWER_EVENT_PTR(CMPLU_STALL_VECTOR_LONG),
+	POWER_EVENT_PTR(CMPLU_STALL_LSU),
+	POWER_EVENT_PTR(CMPLU_STALL_REJECT),
+
+	POWER_EVENT_PTR(CMPLU_STALL_ERAT_MISS),
+	POWER_EVENT_PTR(CMPLU_STALL_DCACHE_MISS),
+	POWER_EVENT_PTR(CMPLU_STALL_STORE),
+	POWER_EVENT_PTR(CMPLU_STALL_THRD),
+	POWER_EVENT_PTR(CMPLU_STALL_IFU),
+	POWER_EVENT_PTR(CMPLU_STALL_BRU),
+	POWER_EVENT_PTR(GCT_NOSLOT_IC_MISS),
+	POWER_EVENT_PTR(GCT_NOSLOT_BR_MPRED),
+
+	POWER_EVENT_PTR(GCT_NOSLOT_BR_MPRED_IC_MISS),
+	POWER_EVENT_PTR(GRP_CMPL),
+	POWER_EVENT_PTR(1PLUS_PPC_CMPL),
+	POWER_EVENT_PTR(CMPLU_STALL_DFU),
+	POWER_EVENT_PTR(RUN_CYC),
+	POWER_EVENT_PTR(RUN_INST_CMPL),
 	NULL
 };
 
diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index cf1a471..bccfca6 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -34,8 +34,6 @@
 #include <asm/sys_ia32.h>
 #include <asm/smap.h>
 
-#define FIX_EFLAGS	__FIX_EFLAGS
-
 int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
 {
 	int err = 0;
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 57cb634..8249df4 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -29,6 +29,9 @@
 #define ARCH_PERFMON_EVENTSEL_INV			(1ULL << 23)
 #define ARCH_PERFMON_EVENTSEL_CMASK			0xFF000000ULL
 
+#define HSW_IN_TX					(1ULL << 32)
+#define HSW_IN_TX_CHECKPOINTED				(1ULL << 33)
+
 #define AMD64_EVENTSEL_INT_CORE_ENABLE			(1ULL << 36)
 #define AMD64_EVENTSEL_GUESTONLY			(1ULL << 40)
 #define AMD64_EVENTSEL_HOSTONLY				(1ULL << 41)
diff --git a/arch/x86/include/asm/sighandling.h b/arch/x86/include/asm/sighandling.h
index beff97f..7a95816 100644
--- a/arch/x86/include/asm/sighandling.h
+++ b/arch/x86/include/asm/sighandling.h
@@ -7,10 +7,10 @@
 
 #include <asm/processor-flags.h>
 
-#define __FIX_EFLAGS	(X86_EFLAGS_AC | X86_EFLAGS_OF | \
+#define FIX_EFLAGS	(X86_EFLAGS_AC | X86_EFLAGS_OF | \
 			 X86_EFLAGS_DF | X86_EFLAGS_TF | X86_EFLAGS_SF | \
 			 X86_EFLAGS_ZF | X86_EFLAGS_AF | X86_EFLAGS_PF | \
-			 X86_EFLAGS_CF)
+			 X86_EFLAGS_CF | X86_EFLAGS_RF)
 
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
 
diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
index 2af848d..bb04650 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -170,6 +170,9 @@
 #define MSR_KNC_EVNTSEL0               0x00000028
 #define MSR_KNC_EVNTSEL1               0x00000029
 
+/* Alternative perfctr range with full access. */
+#define MSR_IA32_PMC0			0x000004c1
+
 /* AMD64 MSRs. Not complete. See the architecture manual for a more
    complete list. */
 
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index b0684e4..47b56a7 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -31,11 +31,15 @@ obj-$(CONFIG_PERF_EVENTS)		+= perf_event.o
 
 ifdef CONFIG_PERF_EVENTS
 obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd.o perf_event_amd_uncore.o
+ifdef CONFIG_AMD_IOMMU
+obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd_iommu.o
+endif
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_knc.o perf_event_p4.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore.o
 endif
 
+
 obj-$(CONFIG_X86_MCE)			+= mcheck/
 obj-$(CONFIG_MTRR)			+= mtrr/
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 1025f3c..9e581c5 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -403,7 +403,8 @@ int x86_pmu_hw_config(struct perf_event *event)
 		 * check that PEBS LBR correction does not conflict with
 		 * whatever the user is asking with attr->branch_sample_type
 		 */
-		if (event->attr.precise_ip > 1) {
+		if (event->attr.precise_ip > 1 &&
+		    x86_pmu.intel_cap.pebs_format < 2) {
 			u64 *br_type = &event->attr.branch_sample_type;
 
 			if (has_branch_stack(event)) {
@@ -568,7 +569,7 @@ struct sched_state {
 struct perf_sched {
 	int			max_weight;
 	int			max_events;
-	struct event_constraint	**constraints;
+	struct perf_event	**events;
 	struct sched_state	state;
 	int			saved_states;
 	struct sched_state	saved[SCHED_STATES_MAX];
@@ -577,7 +578,7 @@ struct perf_sched {
 /*
  * Initialize interator that runs through all events and counters.
  */
-static void perf_sched_init(struct perf_sched *sched, struct event_constraint **c,
+static void perf_sched_init(struct perf_sched *sched, struct perf_event **events,
 			    int num, int wmin, int wmax)
 {
 	int idx;
@@ -585,10 +586,10 @@ static void perf_sched_init(struct perf_sched *sched, struct event_constraint **
 	memset(sched, 0, sizeof(*sched));
 	sched->max_events	= num;
 	sched->max_weight	= wmax;
-	sched->constraints	= c;
+	sched->events		= events;
 
 	for (idx = 0; idx < num; idx++) {
-		if (c[idx]->weight == wmin)
+		if (events[idx]->hw.constraint->weight == wmin)
 			break;
 	}
 
@@ -635,8 +636,7 @@ static bool __perf_sched_find_counter(struct perf_sched *sched)
 	if (sched->state.event >= sched->max_events)
 		return false;
 
-	c = sched->constraints[sched->state.event];
-
+	c = sched->events[sched->state.event]->hw.constraint;
 	/* Prefer fixed purpose counters */
 	if (c->idxmsk64 & (~0ULL << INTEL_PMC_IDX_FIXED)) {
 		idx = INTEL_PMC_IDX_FIXED;
@@ -694,7 +694,7 @@ static bool perf_sched_next_event(struct perf_sched *sched)
 			if (sched->state.weight > sched->max_weight)
 				return false;
 		}
-		c = sched->constraints[sched->state.event];
+		c = sched->events[sched->state.event]->hw.constraint;
 	} while (c->weight != sched->state.weight);
 
 	sched->state.counter = 0;	/* start with first counter */
@@ -705,12 +705,12 @@ static bool perf_sched_next_event(struct perf_sched *sched)
 /*
  * Assign a counter for each event.
  */
-int perf_assign_events(struct event_constraint **constraints, int n,
+int perf_assign_events(struct perf_event **events, int n,
 			int wmin, int wmax, int *assign)
 {
 	struct perf_sched sched;
 
-	perf_sched_init(&sched, constraints, n, wmin, wmax);
+	perf_sched_init(&sched, events, n, wmin, wmax);
 
 	do {
 		if (!perf_sched_find_counter(&sched))
@@ -724,16 +724,19 @@ int perf_assign_events(struct event_constraint **constraints, int n,
 
 int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 {
-	struct event_constraint *c, *constraints[X86_PMC_IDX_MAX];
+	struct event_constraint *c;
 	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	struct perf_event *e;
 	int i, wmin, wmax, num = 0;
 	struct hw_perf_event *hwc;
 
 	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
 
 	for (i = 0, wmin = X86_PMC_IDX_MAX, wmax = 0; i < n; i++) {
+		hwc = &cpuc->event_list[i]->hw;
 		c = x86_pmu.get_event_constraints(cpuc, cpuc->event_list[i]);
-		constraints[i] = c;
+		hwc->constraint = c;
+
 		wmin = min(wmin, c->weight);
 		wmax = max(wmax, c->weight);
 	}
@@ -743,7 +746,7 @@ int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 	 */
 	for (i = 0; i < n; i++) {
 		hwc = &cpuc->event_list[i]->hw;
-		c = constraints[i];
+		c = hwc->constraint;
 
 		/* never assigned */
 		if (hwc->idx == -1)
@@ -764,16 +767,35 @@ int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 
 	/* slow path */
 	if (i != n)
-		num = perf_assign_events(constraints, n, wmin, wmax, assign);
+		num = perf_assign_events(cpuc->event_list, n, wmin,
+					 wmax, assign);
 
 	/*
+	 * Mark the event as committed, so we do not put_constraint()
+	 * in case new events are added and fail scheduling.
+	 */
+	if (!num && assign) {
+		for (i = 0; i < n; i++) {
+			e = cpuc->event_list[i];
+			e->hw.flags |= PERF_X86_EVENT_COMMITTED;
+		}
+	}
+	/*
 	 * scheduling failed or is just a simulation,
 	 * free resources if necessary
 	 */
 	if (!assign || num) {
 		for (i = 0; i < n; i++) {
+			e = cpuc->event_list[i];
+			/*
+			 * do not put_constraint() on comitted events,
+			 * because they are good to go
+			 */
+			if ((e->hw.flags & PERF_X86_EVENT_COMMITTED))
+				continue;
+
 			if (x86_pmu.put_event_constraints)
-				x86_pmu.put_event_constraints(cpuc, cpuc->event_list[i]);
+				x86_pmu.put_event_constraints(cpuc, e);
 		}
 	}
 	return num ? -EINVAL : 0;
@@ -1153,6 +1175,11 @@ static void x86_pmu_del(struct perf_event *event, int flags)
 	int i;
 
 	/*
+	 * event is descheduled
+	 */
+	event->hw.flags &= ~PERF_X86_EVENT_COMMITTED;
+
+	/*
 	 * If we're called during a txn, we don't need to do anything.
 	 * The events never got scheduled and ->cancel_txn will truncate
 	 * the event_list.
@@ -1249,10 +1276,20 @@ void perf_events_lapic_init(void)
 static int __kprobes
 perf_event_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 {
+	int ret;
+	u64 start_clock;
+	u64 finish_clock;
+
 	if (!atomic_read(&active_events))
 		return NMI_DONE;
 
-	return x86_pmu.handle_irq(regs);
+	start_clock = local_clock();
+	ret = x86_pmu.handle_irq(regs);
+	finish_clock = local_clock();
+
+	perf_sample_event_took(finish_clock - start_clock);
+
+	return ret;
 }
 
 struct event_constraint emptyconstraint;
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index ba9aadf..97e557b 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -63,10 +63,12 @@ struct event_constraint {
 	int	flags;
 };
 /*
- * struct event_constraint flags
+ * struct hw_perf_event.flags flags
  */
 #define PERF_X86_EVENT_PEBS_LDLAT	0x1 /* ld+ldlat data address sampling */
 #define PERF_X86_EVENT_PEBS_ST		0x2 /* st data address sampling */
+#define PERF_X86_EVENT_PEBS_ST_HSW	0x4 /* haswell style st data sampling */
+#define PERF_X86_EVENT_COMMITTED	0x8 /* event passed commit_txn */
 
 struct amd_nb {
 	int nb_id;  /* NorthBridge id */
@@ -227,11 +229,14 @@ struct cpu_hw_events {
  *  - inv
  *  - edge
  *  - cnt-mask
+ *  - in_tx
+ *  - in_tx_checkpointed
  *  The other filters are supported by fixed counters.
  *  The any-thread option is supported starting with v3.
  */
+#define FIXED_EVENT_FLAGS (X86_RAW_EVENT_MASK|HSW_IN_TX|HSW_IN_TX_CHECKPOINTED)
 #define FIXED_EVENT_CONSTRAINT(c, n)	\
-	EVENT_CONSTRAINT(c, (1ULL << (32+n)), X86_RAW_EVENT_MASK)
+	EVENT_CONSTRAINT(c, (1ULL << (32+n)), FIXED_EVENT_FLAGS)
 
 /*
  * Constraint on the Event code + UMask
@@ -247,6 +252,11 @@ struct cpu_hw_events {
 	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK, \
 			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_ST)
 
+/* DataLA version of store sampling without extra enable bit. */
+#define INTEL_PST_HSW_CONSTRAINT(c, n)	\
+	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK, \
+			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_ST_HSW)
+
 #define EVENT_CONSTRAINT_END		\
 	EVENT_CONSTRAINT(0, 0, 0)
 
@@ -301,6 +311,11 @@ union perf_capabilities {
 		u64	pebs_arch_reg:1;
 		u64	pebs_format:4;
 		u64	smm_freeze:1;
+		/*
+		 * PMU supports separate counter range for writing
+		 * values > 32bit.
+		 */
+		u64	full_width_write:1;
 	};
 	u64	capabilities;
 };
@@ -375,6 +390,7 @@ struct x86_pmu {
 	struct event_constraint *event_constraints;
 	struct x86_pmu_quirk *quirks;
 	int		perfctr_second_write;
+	bool		late_ack;
 
 	/*
 	 * sysfs attrs
@@ -528,7 +544,7 @@ static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
 
 void x86_pmu_enable_all(int added);
 
-int perf_assign_events(struct event_constraint **constraints, int n,
+int perf_assign_events(struct perf_event **events, int n,
 			int wmin, int wmax, int *assign);
 int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign);
 
@@ -633,6 +649,8 @@ extern struct event_constraint intel_snb_pebs_event_constraints[];
 
 extern struct event_constraint intel_ivb_pebs_event_constraints[];
 
+extern struct event_constraint intel_hsw_pebs_event_constraints[];
+
 struct event_constraint *intel_pebs_constraints(struct perf_event *event);
 
 void intel_pmu_pebs_enable(struct perf_event *event);
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 7e28d94..4cbe032 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -648,48 +648,48 @@ static __initconst const struct x86_pmu amd_pmu = {
 	.cpu_dead		= amd_pmu_cpu_dead,
 };
 
-static int setup_event_constraints(void)
+static int __init amd_core_pmu_init(void)
 {
-	if (boot_cpu_data.x86 == 0x15)
+	if (!cpu_has_perfctr_core)
+		return 0;
+
+	switch (boot_cpu_data.x86) {
+	case 0x15:
+		pr_cont("Fam15h ");
 		x86_pmu.get_event_constraints = amd_get_event_constraints_f15h;
-	return 0;
-}
+		break;
 
-static int setup_perfctr_core(void)
-{
-	if (!cpu_has_perfctr_core) {
-		WARN(x86_pmu.get_event_constraints == amd_get_event_constraints_f15h,
-		     KERN_ERR "Odd, counter constraints enabled but no core perfctrs detected!");
+	default:
+		pr_err("core perfctr but no constraints; unknown hardware!\n");
 		return -ENODEV;
 	}
 
-	WARN(x86_pmu.get_event_constraints == amd_get_event_constraints,
-	     KERN_ERR "hw perf events core counters need constraints handler!");
-
 	/*
 	 * If core performance counter extensions exists, we must use
 	 * MSR_F15H_PERF_CTL/MSR_F15H_PERF_CTR msrs. See also
-	 * x86_pmu_addr_offset().
+	 * amd_pmu_addr_offset().
 	 */
 	x86_pmu.eventsel	= MSR_F15H_PERF_CTL;
 	x86_pmu.perfctr		= MSR_F15H_PERF_CTR;
 	x86_pmu.num_counters	= AMD64_NUM_COUNTERS_CORE;
 
-	printk(KERN_INFO "perf: AMD core performance counters detected\n");
-
+	pr_cont("core perfctr, ");
 	return 0;
 }
 
 __init int amd_pmu_init(void)
 {
+	int ret;
+
 	/* Performance-monitoring supported from K7 and later: */
 	if (boot_cpu_data.x86 < 6)
 		return -ENODEV;
 
 	x86_pmu = amd_pmu;
 
-	setup_event_constraints();
-	setup_perfctr_core();
+	ret = amd_core_pmu_init();
+	if (ret)
+		return ret;
 
 	/* Events are common for all AMDs */
 	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
diff --git a/arch/x86/kernel/cpu/perf_event_amd_iommu.c b/arch/x86/kernel/cpu/perf_event_amd_iommu.c
new file mode 100644
index 0000000..0db655e
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_amd_iommu.c
@@ -0,0 +1,504 @@
+/*
+ * Copyright (C) 2013 Advanced Micro Devices, Inc.
+ *
+ * Author: Steven Kinney <Steven.Kinney@amd.com>
+ * Author: Suravee Suthikulpanit <Suraveee.Suthikulpanit@amd.com>
+ *
+ * Perf: amd_iommu - AMD IOMMU Performance Counter PMU implementation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/perf_event.h>
+#include <linux/module.h>
+#include <linux/cpumask.h>
+#include <linux/slab.h>
+
+#include "perf_event.h"
+#include "perf_event_amd_iommu.h"
+
+#define COUNTER_SHIFT		16
+
+#define _GET_BANK(ev)       ((u8)(ev->hw.extra_reg.reg >> 8))
+#define _GET_CNTR(ev)       ((u8)(ev->hw.extra_reg.reg))
+
+/* iommu pmu config masks */
+#define _GET_CSOURCE(ev)    ((ev->hw.config & 0xFFULL))
+#define _GET_DEVID(ev)      ((ev->hw.config >> 8)  & 0xFFFFULL)
+#define _GET_PASID(ev)      ((ev->hw.config >> 24) & 0xFFFFULL)
+#define _GET_DOMID(ev)      ((ev->hw.config >> 40) & 0xFFFFULL)
+#define _GET_DEVID_MASK(ev) ((ev->hw.extra_reg.config)  & 0xFFFFULL)
+#define _GET_PASID_MASK(ev) ((ev->hw.extra_reg.config >> 16) & 0xFFFFULL)
+#define _GET_DOMID_MASK(ev) ((ev->hw.extra_reg.config >> 32) & 0xFFFFULL)
+
+static struct perf_amd_iommu __perf_iommu;
+
+struct perf_amd_iommu {
+	struct pmu pmu;
+	u8 max_banks;
+	u8 max_counters;
+	u64 cntr_assign_mask;
+	raw_spinlock_t lock;
+	const struct attribute_group *attr_groups[4];
+};
+
+#define format_group	attr_groups[0]
+#define cpumask_group	attr_groups[1]
+#define events_group	attr_groups[2]
+#define null_group	attr_groups[3]
+
+/*---------------------------------------------
+ * sysfs format attributes
+ *---------------------------------------------*/
+PMU_FORMAT_ATTR(csource,    "config:0-7");
+PMU_FORMAT_ATTR(devid,      "config:8-23");
+PMU_FORMAT_ATTR(pasid,      "config:24-39");
+PMU_FORMAT_ATTR(domid,      "config:40-55");
+PMU_FORMAT_ATTR(devid_mask, "config1:0-15");
+PMU_FORMAT_ATTR(pasid_mask, "config1:16-31");
+PMU_FORMAT_ATTR(domid_mask, "config1:32-47");
+
+static struct attribute *iommu_format_attrs[] = {
+	&format_attr_csource.attr,
+	&format_attr_devid.attr,
+	&format_attr_pasid.attr,
+	&format_attr_domid.attr,
+	&format_attr_devid_mask.attr,
+	&format_attr_pasid_mask.attr,
+	&format_attr_domid_mask.attr,
+	NULL,
+};
+
+static struct attribute_group amd_iommu_format_group = {
+	.name = "format",
+	.attrs = iommu_format_attrs,
+};
+
+/*---------------------------------------------
+ * sysfs events attributes
+ *---------------------------------------------*/
+struct amd_iommu_event_desc {
+	struct kobj_attribute attr;
+	const char *event;
+};
+
+static ssize_t _iommu_event_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buf)
+{
+	struct amd_iommu_event_desc *event =
+		container_of(attr, struct amd_iommu_event_desc, attr);
+	return sprintf(buf, "%s\n", event->event);
+}
+
+#define AMD_IOMMU_EVENT_DESC(_name, _event)			\
+{								\
+	.attr  = __ATTR(_name, 0444, _iommu_event_show, NULL),	\
+	.event = _event,					\
+}
+
+static struct amd_iommu_event_desc amd_iommu_v2_event_descs[] = {
+	AMD_IOMMU_EVENT_DESC(mem_pass_untrans,        "csource=0x01"),
+	AMD_IOMMU_EVENT_DESC(mem_pass_pretrans,       "csource=0x02"),
+	AMD_IOMMU_EVENT_DESC(mem_pass_excl,           "csource=0x03"),
+	AMD_IOMMU_EVENT_DESC(mem_target_abort,        "csource=0x04"),
+	AMD_IOMMU_EVENT_DESC(mem_trans_total,         "csource=0x05"),
+	AMD_IOMMU_EVENT_DESC(mem_iommu_tlb_pte_hit,   "csource=0x06"),
+	AMD_IOMMU_EVENT_DESC(mem_iommu_tlb_pte_mis,   "csource=0x07"),
+	AMD_IOMMU_EVENT_DESC(mem_iommu_tlb_pde_hit,   "csource=0x08"),
+	AMD_IOMMU_EVENT_DESC(mem_iommu_tlb_pde_mis,   "csource=0x09"),
+	AMD_IOMMU_EVENT_DESC(mem_dte_hit,             "csource=0x0a"),
+	AMD_IOMMU_EVENT_DESC(mem_dte_mis,             "csource=0x0b"),
+	AMD_IOMMU_EVENT_DESC(page_tbl_read_tot,       "csource=0x0c"),
+	AMD_IOMMU_EVENT_DESC(page_tbl_read_nst,       "csource=0x0d"),
+	AMD_IOMMU_EVENT_DESC(page_tbl_read_gst,       "csource=0x0e"),
+	AMD_IOMMU_EVENT_DESC(int_dte_hit,             "csource=0x0f"),
+	AMD_IOMMU_EVENT_DESC(int_dte_mis,             "csource=0x10"),
+	AMD_IOMMU_EVENT_DESC(cmd_processed,           "csource=0x11"),
+	AMD_IOMMU_EVENT_DESC(cmd_processed_inv,       "csource=0x12"),
+	AMD_IOMMU_EVENT_DESC(tlb_inv,                 "csource=0x13"),
+	{ /* end: all zeroes */ },
+};
+
+/*---------------------------------------------
+ * sysfs cpumask attributes
+ *---------------------------------------------*/
+static cpumask_t iommu_cpumask;
+
+static ssize_t _iommu_cpumask_show(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	int n = cpulist_scnprintf(buf, PAGE_SIZE - 2, &iommu_cpumask);
+	buf[n++] = '\n';
+	buf[n] = '\0';
+	return n;
+}
+static DEVICE_ATTR(cpumask, S_IRUGO, _iommu_cpumask_show, NULL);
+
+static struct attribute *iommu_cpumask_attrs[] = {
+	&dev_attr_cpumask.attr,
+	NULL,
+};
+
+static struct attribute_group amd_iommu_cpumask_group = {
+	.attrs = iommu_cpumask_attrs,
+};
+
+/*---------------------------------------------*/
+
+static int get_next_avail_iommu_bnk_cntr(struct perf_amd_iommu *perf_iommu)
+{
+	unsigned long flags;
+	int shift, bank, cntr, retval;
+	int max_banks = perf_iommu->max_banks;
+	int max_cntrs = perf_iommu->max_counters;
+
+	raw_spin_lock_irqsave(&perf_iommu->lock, flags);
+
+	for (bank = 0, shift = 0; bank < max_banks; bank++) {
+		for (cntr = 0; cntr < max_cntrs; cntr++) {
+			shift = bank + (bank*3) + cntr;
+			if (perf_iommu->cntr_assign_mask & (1ULL<<shift)) {
+				continue;
+			} else {
+				perf_iommu->cntr_assign_mask |= (1ULL<<shift);
+				retval = ((u16)((u16)bank<<8) | (u8)(cntr));
+				goto out;
+			}
+		}
+	}
+	retval = -ENOSPC;
+out:
+	raw_spin_unlock_irqrestore(&perf_iommu->lock, flags);
+	return retval;
+}
+
+static int clear_avail_iommu_bnk_cntr(struct perf_amd_iommu *perf_iommu,
+					u8 bank, u8 cntr)
+{
+	unsigned long flags;
+	int max_banks, max_cntrs;
+	int shift = 0;
+
+	max_banks = perf_iommu->max_banks;
+	max_cntrs = perf_iommu->max_counters;
+
+	if ((bank > max_banks) || (cntr > max_cntrs))
+		return -EINVAL;
+
+	shift = bank + cntr + (bank*3);
+
+	raw_spin_lock_irqsave(&perf_iommu->lock, flags);
+	perf_iommu->cntr_assign_mask &= ~(1ULL<<shift);
+	raw_spin_unlock_irqrestore(&perf_iommu->lock, flags);
+
+	return 0;
+}
+
+static int perf_iommu_event_init(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct perf_amd_iommu *perf_iommu;
+	u64 config, config1;
+
+	/* test the event attr type check for PMU enumeration */
+	if (event->attr.type != event->pmu->type)
+		return -ENOENT;
+
+	/*
+	 * IOMMU counters are shared across all cores.
+	 * Therefore, it does not support per-process mode.
+	 * Also, it does not support event sampling mode.
+	 */
+	if (is_sampling_event(event) || event->attach_state & PERF_ATTACH_TASK)
+		return -EINVAL;
+
+	/* IOMMU counters do not have usr/os/guest/host bits */
+	if (event->attr.exclude_user || event->attr.exclude_kernel ||
+	    event->attr.exclude_host || event->attr.exclude_guest)
+		return -EINVAL;
+
+	if (event->cpu < 0)
+		return -EINVAL;
+
+	perf_iommu = &__perf_iommu;
+
+	if (event->pmu != &perf_iommu->pmu)
+		return -ENOENT;
+
+	if (perf_iommu) {
+		config = event->attr.config;
+		config1 = event->attr.config1;
+	} else {
+		return -EINVAL;
+	}
+
+	/* integrate with iommu base devid (0000), assume one iommu */
+	perf_iommu->max_banks =
+		amd_iommu_pc_get_max_banks(IOMMU_BASE_DEVID);
+	perf_iommu->max_counters =
+		amd_iommu_pc_get_max_counters(IOMMU_BASE_DEVID);
+	if ((perf_iommu->max_banks == 0) || (perf_iommu->max_counters == 0))
+		return -EINVAL;
+
+	/* update the hw_perf_event struct with the iommu config data */
+	hwc->config = config;
+	hwc->extra_reg.config = config1;
+
+	return 0;
+}
+
+static void perf_iommu_enable_event(struct perf_event *ev)
+{
+	u8 csource = _GET_CSOURCE(ev);
+	u16 devid = _GET_DEVID(ev);
+	u64 reg = 0ULL;
+
+	reg = csource;
+	amd_iommu_pc_get_set_reg_val(devid,
+			_GET_BANK(ev), _GET_CNTR(ev) ,
+			 IOMMU_PC_COUNTER_SRC_REG, &reg, true);
+
+	reg = 0ULL | devid | (_GET_DEVID_MASK(ev) << 32);
+	if (reg)
+		reg |= (1UL << 31);
+	amd_iommu_pc_get_set_reg_val(devid,
+			_GET_BANK(ev), _GET_CNTR(ev) ,
+			 IOMMU_PC_DEVID_MATCH_REG, &reg, true);
+
+	reg = 0ULL | _GET_PASID(ev) | (_GET_PASID_MASK(ev) << 32);
+	if (reg)
+		reg |= (1UL << 31);
+	amd_iommu_pc_get_set_reg_val(devid,
+			_GET_BANK(ev), _GET_CNTR(ev) ,
+			 IOMMU_PC_PASID_MATCH_REG, &reg, true);
+
+	reg = 0ULL | _GET_DOMID(ev) | (_GET_DOMID_MASK(ev) << 32);
+	if (reg)
+		reg |= (1UL << 31);
+	amd_iommu_pc_get_set_reg_val(devid,
+			_GET_BANK(ev), _GET_CNTR(ev) ,
+			 IOMMU_PC_DOMID_MATCH_REG, &reg, true);
+}
+
+static void perf_iommu_disable_event(struct perf_event *event)
+{
+	u64 reg = 0ULL;
+
+	amd_iommu_pc_get_set_reg_val(_GET_DEVID(event),
+			_GET_BANK(event), _GET_CNTR(event),
+			IOMMU_PC_COUNTER_SRC_REG, &reg, true);
+}
+
+static void perf_iommu_start(struct perf_event *event, int flags)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	pr_debug("perf: amd_iommu:perf_iommu_start\n");
+	if (WARN_ON_ONCE(!(hwc->state & PERF_HES_STOPPED)))
+		return;
+
+	WARN_ON_ONCE(!(hwc->state & PERF_HES_UPTODATE));
+	hwc->state = 0;
+
+	if (flags & PERF_EF_RELOAD) {
+		u64 prev_raw_count =  local64_read(&hwc->prev_count);
+		amd_iommu_pc_get_set_reg_val(_GET_DEVID(event),
+				_GET_BANK(event), _GET_CNTR(event),
+				IOMMU_PC_COUNTER_REG, &prev_raw_count, true);
+	}
+
+	perf_iommu_enable_event(event);
+	perf_event_update_userpage(event);
+
+}
+
+static void perf_iommu_read(struct perf_event *event)
+{
+	u64 count = 0ULL;
+	u64 prev_raw_count = 0ULL;
+	u64 delta = 0ULL;
+	struct hw_perf_event *hwc = &event->hw;
+	pr_debug("perf: amd_iommu:perf_iommu_read\n");
+
+	amd_iommu_pc_get_set_reg_val(_GET_DEVID(event),
+				_GET_BANK(event), _GET_CNTR(event),
+				IOMMU_PC_COUNTER_REG, &count, false);
+
+	/* IOMMU pc counter register is only 48 bits */
+	count &= 0xFFFFFFFFFFFFULL;
+
+	prev_raw_count =  local64_read(&hwc->prev_count);
+	if (local64_cmpxchg(&hwc->prev_count, prev_raw_count,
+					count) != prev_raw_count)
+		return;
+
+	/* Handling 48-bit counter overflowing */
+	delta = (count << COUNTER_SHIFT) - (prev_raw_count << COUNTER_SHIFT);
+	delta >>= COUNTER_SHIFT;
+	local64_add(delta, &event->count);
+
+}
+
+static void perf_iommu_stop(struct perf_event *event, int flags)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	u64 config;
+
+	pr_debug("perf: amd_iommu:perf_iommu_stop\n");
+
+	if (hwc->state & PERF_HES_UPTODATE)
+		return;
+
+	perf_iommu_disable_event(event);
+	WARN_ON_ONCE(hwc->state & PERF_HES_STOPPED);
+	hwc->state |= PERF_HES_STOPPED;
+
+	if (hwc->state & PERF_HES_UPTODATE)
+		return;
+
+	config = hwc->config;
+	perf_iommu_read(event);
+	hwc->state |= PERF_HES_UPTODATE;
+}
+
+static int perf_iommu_add(struct perf_event *event, int flags)
+{
+	int retval;
+	struct perf_amd_iommu *perf_iommu =
+			container_of(event->pmu, struct perf_amd_iommu, pmu);
+
+	pr_debug("perf: amd_iommu:perf_iommu_add\n");
+	event->hw.state = PERF_HES_UPTODATE | PERF_HES_STOPPED;
+
+	/* request an iommu bank/counter */
+	retval = get_next_avail_iommu_bnk_cntr(perf_iommu);
+	if (retval != -ENOSPC)
+		event->hw.extra_reg.reg = (u16)retval;
+	else
+		return retval;
+
+	if (flags & PERF_EF_START)
+		perf_iommu_start(event, PERF_EF_RELOAD);
+
+	return 0;
+}
+
+static void perf_iommu_del(struct perf_event *event, int flags)
+{
+	struct perf_amd_iommu *perf_iommu =
+			container_of(event->pmu, struct perf_amd_iommu, pmu);
+
+	pr_debug("perf: amd_iommu:perf_iommu_del\n");
+	perf_iommu_stop(event, PERF_EF_UPDATE);
+
+	/* clear the assigned iommu bank/counter */
+	clear_avail_iommu_bnk_cntr(perf_iommu,
+				     _GET_BANK(event),
+				     _GET_CNTR(event));
+
+	perf_event_update_userpage(event);
+}
+
+static __init int _init_events_attrs(struct perf_amd_iommu *perf_iommu)
+{
+	struct attribute **attrs;
+	struct attribute_group *attr_group;
+	int i = 0, j;
+
+	while (amd_iommu_v2_event_descs[i].attr.attr.name)
+		i++;
+
+	attr_group = kzalloc(sizeof(struct attribute *)
+		* (i + 1) + sizeof(*attr_group), GFP_KERNEL);
+	if (!attr_group)
+		return -ENOMEM;
+
+	attrs = (struct attribute **)(attr_group + 1);
+	for (j = 0; j < i; j++)
+		attrs[j] = &amd_iommu_v2_event_descs[j].attr.attr;
+
+	attr_group->name = "events";
+	attr_group->attrs = attrs;
+	perf_iommu->events_group = attr_group;
+
+	return 0;
+}
+
+static __init void amd_iommu_pc_exit(void)
+{
+	if (__perf_iommu.events_group != NULL) {
+		kfree(__perf_iommu.events_group);
+		__perf_iommu.events_group = NULL;
+	}
+}
+
+static __init int _init_perf_amd_iommu(
+	struct perf_amd_iommu *perf_iommu, char *name)
+{
+	int ret;
+
+	raw_spin_lock_init(&perf_iommu->lock);
+
+	/* Init format attributes */
+	perf_iommu->format_group = &amd_iommu_format_group;
+
+	/* Init cpumask attributes to only core 0 */
+	cpumask_set_cpu(0, &iommu_cpumask);
+	perf_iommu->cpumask_group = &amd_iommu_cpumask_group;
+
+	/* Init events attributes */
+	if (_init_events_attrs(perf_iommu) != 0)
+		pr_err("perf: amd_iommu: Only support raw events.\n");
+
+	/* Init null attributes */
+	perf_iommu->null_group = NULL;
+	perf_iommu->pmu.attr_groups = perf_iommu->attr_groups;
+
+	ret = perf_pmu_register(&perf_iommu->pmu, name, -1);
+	if (ret) {
+		pr_err("perf: amd_iommu: Failed to initialized.\n");
+		amd_iommu_pc_exit();
+	} else {
+		pr_info("perf: amd_iommu: Detected. (%d banks, %d counters/bank)\n",
+			amd_iommu_pc_get_max_banks(IOMMU_BASE_DEVID),
+			amd_iommu_pc_get_max_counters(IOMMU_BASE_DEVID));
+	}
+
+	return ret;
+}
+
+static struct perf_amd_iommu __perf_iommu = {
+	.pmu = {
+		.event_init	= perf_iommu_event_init,
+		.add		= perf_iommu_add,
+		.del		= perf_iommu_del,
+		.start		= perf_iommu_start,
+		.stop		= perf_iommu_stop,
+		.read		= perf_iommu_read,
+	},
+	.max_banks		= 0x00,
+	.max_counters		= 0x00,
+	.cntr_assign_mask	= 0ULL,
+	.format_group		= NULL,
+	.cpumask_group		= NULL,
+	.events_group		= NULL,
+	.null_group		= NULL,
+};
+
+static __init int amd_iommu_pc_init(void)
+{
+	/* Make sure the IOMMU PC resource is available */
+	if (!amd_iommu_pc_supported()) {
+		pr_err("perf: amd_iommu PMU not installed. No support!\n");
+		return -ENODEV;
+	}
+
+	_init_perf_amd_iommu(&__perf_iommu, "amd_iommu");
+
+	return 0;
+}
+
+device_initcall(amd_iommu_pc_init);
diff --git a/arch/x86/kernel/cpu/perf_event_amd_iommu.h b/arch/x86/kernel/cpu/perf_event_amd_iommu.h
new file mode 100644
index 0000000..845d173
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_amd_iommu.h
@@ -0,0 +1,40 @@
+/*
+ * Copyright (C) 2013 Advanced Micro Devices, Inc.
+ *
+ * Author: Steven Kinney <Steven.Kinney@amd.com>
+ * Author: Suravee Suthikulpanit <Suraveee.Suthikulpanit@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _PERF_EVENT_AMD_IOMMU_H_
+#define _PERF_EVENT_AMD_IOMMU_H_
+
+/* iommu pc mmio region register indexes */
+#define IOMMU_PC_COUNTER_REG			0x00
+#define IOMMU_PC_COUNTER_SRC_REG		0x08
+#define IOMMU_PC_PASID_MATCH_REG		0x10
+#define IOMMU_PC_DOMID_MATCH_REG		0x18
+#define IOMMU_PC_DEVID_MATCH_REG		0x20
+#define IOMMU_PC_COUNTER_REPORT_REG		0x28
+
+/* maximun specified bank/counters */
+#define PC_MAX_SPEC_BNKS			64
+#define PC_MAX_SPEC_CNTRS			16
+
+/* iommu pc reg masks*/
+#define IOMMU_BASE_DEVID			0x0000
+
+/* amd_iommu_init.c external support functions */
+extern bool amd_iommu_pc_supported(void);
+
+extern u8 amd_iommu_pc_get_max_banks(u16 devid);
+
+extern u8 amd_iommu_pc_get_max_counters(u16 devid);
+
+extern int amd_iommu_pc_get_set_reg_val(u16 devid, u8 bank, u8 cntr,
+			u8 fxn, u64 *value, bool is_write);
+
+#endif /*_PERF_EVENT_AMD_IOMMU_H_*/
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index a9e2207..fbc9210 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/export.h>
 
+#include <asm/cpufeature.h>
 #include <asm/hardirq.h>
 #include <asm/apic.h>
 
@@ -190,6 +191,22 @@ struct attribute *snb_events_attrs[] = {
 	NULL,
 };
 
+static struct event_constraint intel_hsw_event_constraints[] = {
+	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
+	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
+	FIXED_EVENT_CONSTRAINT(0x0300, 2), /* CPU_CLK_UNHALTED.REF */
+	INTEL_EVENT_CONSTRAINT(0x48, 0x4), /* L1D_PEND_MISS.* */
+	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
+	INTEL_EVENT_CONSTRAINT(0xcd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
+	/* CYCLE_ACTIVITY.CYCLES_L1D_PENDING */
+	INTEL_EVENT_CONSTRAINT(0x08a3, 0x4),
+	/* CYCLE_ACTIVITY.STALLS_L1D_PENDING */
+	INTEL_EVENT_CONSTRAINT(0x0ca3, 0x4),
+	/* CYCLE_ACTIVITY.CYCLES_NO_EXECUTE */
+	INTEL_EVENT_CONSTRAINT(0x04a3, 0xf),
+	EVENT_CONSTRAINT_END
+};
+
 static u64 intel_pmu_event_map(int hw_event)
 {
 	return intel_perfmon_event_map[hw_event];
@@ -872,7 +889,8 @@ static inline bool intel_pmu_needs_lbr_smpl(struct perf_event *event)
 		return true;
 
 	/* implicit branch sampling to correct PEBS skid */
-	if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1)
+	if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1 &&
+	    x86_pmu.intel_cap.pebs_format < 2)
 		return true;
 
 	return false;
@@ -1167,15 +1185,11 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
 	/*
-	 * Some chipsets need to unmask the LVTPC in a particular spot
-	 * inside the nmi handler.  As a result, the unmasking was pushed
-	 * into all the nmi handlers.
-	 *
-	 * This handler doesn't seem to have any issues with the unmasking
-	 * so it was left at the top.
+	 * No known reason to not always do late ACK,
+	 * but just in case do it opt-in.
 	 */
-	apic_write(APIC_LVTPC, APIC_DM_NMI);
-
+	if (!x86_pmu.late_ack)
+		apic_write(APIC_LVTPC, APIC_DM_NMI);
 	intel_pmu_disable_all();
 	handled = intel_pmu_drain_bts_buffer();
 	status = intel_pmu_get_status();
@@ -1188,8 +1202,12 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 again:
 	intel_pmu_ack_status(status);
 	if (++loops > 100) {
-		WARN_ONCE(1, "perfevents: irq loop stuck!\n");
-		perf_event_print_debug();
+		static bool warned = false;
+		if (!warned) {
+			WARN(1, "perfevents: irq loop stuck!\n");
+			perf_event_print_debug();
+			warned = true;
+		}
 		intel_pmu_reset();
 		goto done;
 	}
@@ -1235,6 +1253,13 @@ again:
 
 done:
 	intel_pmu_enable_all(0);
+	/*
+	 * Only unmask the NMI after the overflow counters
+	 * have been reset. This avoids spurious NMIs on
+	 * Haswell CPUs.
+	 */
+	if (x86_pmu.late_ack)
+		apic_write(APIC_LVTPC, APIC_DM_NMI);
 	return handled;
 }
 
@@ -1425,7 +1450,6 @@ x86_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 	if (x86_pmu.event_constraints) {
 		for_each_event_constraint(c, x86_pmu.event_constraints) {
 			if ((event->hw.config & c->cmask) == c->code) {
-				/* hw.flags zeroed at initialization */
 				event->hw.flags |= c->flags;
 				return c;
 			}
@@ -1473,7 +1497,6 @@ intel_put_shared_regs_event_constraints(struct cpu_hw_events *cpuc,
 static void intel_put_event_constraints(struct cpu_hw_events *cpuc,
 					struct perf_event *event)
 {
-	event->hw.flags = 0;
 	intel_put_shared_regs_event_constraints(cpuc, event);
 }
 
@@ -1646,6 +1669,47 @@ static void core_pmu_enable_all(int added)
 	}
 }
 
+static int hsw_hw_config(struct perf_event *event)
+{
+	int ret = intel_pmu_hw_config(event);
+
+	if (ret)
+		return ret;
+	if (!boot_cpu_has(X86_FEATURE_RTM) && !boot_cpu_has(X86_FEATURE_HLE))
+		return 0;
+	event->hw.config |= event->attr.config & (HSW_IN_TX|HSW_IN_TX_CHECKPOINTED);
+
+	/*
+	 * IN_TX/IN_TX-CP filters are not supported by the Haswell PMU with
+	 * PEBS or in ANY thread mode. Since the results are non-sensical forbid
+	 * this combination.
+	 */
+	if ((event->hw.config & (HSW_IN_TX|HSW_IN_TX_CHECKPOINTED)) &&
+	     ((event->hw.config & ARCH_PERFMON_EVENTSEL_ANY) ||
+	      event->attr.precise_ip > 0))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+static struct event_constraint counter2_constraint =
+			EVENT_CONSTRAINT(0, 0x4, 0);
+
+static struct event_constraint *
+hsw_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
+{
+	struct event_constraint *c = intel_get_event_constraints(cpuc, event);
+
+	/* Handle special quirk on in_tx_checkpointed only in counter 2 */
+	if (event->hw.config & HSW_IN_TX_CHECKPOINTED) {
+		if (c->idxmsk64 & (1U << 2))
+			return &counter2_constraint;
+		return &emptyconstraint;
+	}
+
+	return c;
+}
+
 PMU_FORMAT_ATTR(event,	"config:0-7"	);
 PMU_FORMAT_ATTR(umask,	"config:8-15"	);
 PMU_FORMAT_ATTR(edge,	"config:18"	);
@@ -1653,6 +1717,8 @@ PMU_FORMAT_ATTR(pc,	"config:19"	);
 PMU_FORMAT_ATTR(any,	"config:21"	); /* v3 + */
 PMU_FORMAT_ATTR(inv,	"config:23"	);
 PMU_FORMAT_ATTR(cmask,	"config:24-31"	);
+PMU_FORMAT_ATTR(in_tx,  "config:32");
+PMU_FORMAT_ATTR(in_tx_cp, "config:33");
 
 static struct attribute *intel_arch_formats_attr[] = {
 	&format_attr_event.attr,
@@ -1807,6 +1873,8 @@ static struct attribute *intel_arch3_formats_attr[] = {
 	&format_attr_any.attr,
 	&format_attr_inv.attr,
 	&format_attr_cmask.attr,
+	&format_attr_in_tx.attr,
+	&format_attr_in_tx_cp.attr,
 
 	&format_attr_offcore_rsp.attr, /* XXX do NHM/WSM + SNB breakout */
 	&format_attr_ldlat.attr, /* PEBS load latency */
@@ -1966,6 +2034,15 @@ static __init void intel_nehalem_quirk(void)
 	}
 }
 
+EVENT_ATTR_STR(mem-loads,      mem_ld_hsw,     "event=0xcd,umask=0x1,ldlat=3");
+EVENT_ATTR_STR(mem-stores,     mem_st_hsw,     "event=0xd0,umask=0x82")
+
+static struct attribute *hsw_events_attrs[] = {
+	EVENT_PTR(mem_ld_hsw),
+	EVENT_PTR(mem_st_hsw),
+	NULL
+};
+
 __init int intel_pmu_init(void)
 {
 	union cpuid10_edx edx;
@@ -2189,6 +2266,30 @@ __init int intel_pmu_init(void)
 		break;
 
 
+	case 60: /* Haswell Client */
+	case 70:
+	case 71:
+	case 63:
+		x86_pmu.late_ack = true;
+		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids, sizeof(hw_cache_event_ids));
+		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
+
+		intel_pmu_lbr_init_snb();
+
+		x86_pmu.event_constraints = intel_hsw_event_constraints;
+		x86_pmu.pebs_constraints = intel_hsw_pebs_event_constraints;
+		x86_pmu.extra_regs = intel_snb_extra_regs;
+		x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
+		/* all extra regs are per-cpu when HT is on */
+		x86_pmu.er_flags |= ERF_HAS_RSP_1;
+		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
+
+		x86_pmu.hw_config = hsw_hw_config;
+		x86_pmu.get_event_constraints = hsw_get_event_constraints;
+		x86_pmu.cpu_events = hsw_events_attrs;
+		pr_cont("Haswell events, ");
+		break;
+
 	default:
 		switch (x86_pmu.version) {
 		case 1:
@@ -2227,7 +2328,7 @@ __init int intel_pmu_init(void)
 		 * counter, so do not extend mask to generic counters
 		 */
 		for_each_event_constraint(c, x86_pmu.event_constraints) {
-			if (c->cmask != X86_RAW_EVENT_MASK
+			if (c->cmask != FIXED_EVENT_FLAGS
 			    || c->idxmsk64 == INTEL_PMC_MSK_FIXED_REF_CYCLES) {
 				continue;
 			}
@@ -2237,5 +2338,12 @@ __init int intel_pmu_init(void)
 		}
 	}
 
+	/* Support full width counters using alternative MSR range */
+	if (x86_pmu.intel_cap.full_width_write) {
+		x86_pmu.max_period = x86_pmu.cntval_mask;
+		x86_pmu.perfctr = MSR_IA32_PMC0;
+		pr_cont("full-width counters, ");
+	}
+
 	return 0;
 }
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 60250f6..3065c57 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -107,6 +107,19 @@ static u64 precise_store_data(u64 status)
 	return val;
 }
 
+static u64 precise_store_data_hsw(u64 status)
+{
+	union perf_mem_data_src dse;
+
+	dse.val = 0;
+	dse.mem_op = PERF_MEM_OP_STORE;
+	dse.mem_lvl = PERF_MEM_LVL_NA;
+	if (status & 1)
+		dse.mem_lvl = PERF_MEM_LVL_L1;
+	/* Nothing else supported. Sorry. */
+	return dse.val;
+}
+
 static u64 load_latency_data(u64 status)
 {
 	union intel_x86_pebs_dse dse;
@@ -165,6 +178,22 @@ struct pebs_record_nhm {
 	u64 status, dla, dse, lat;
 };
 
+/*
+ * Same as pebs_record_nhm, with two additional fields.
+ */
+struct pebs_record_hsw {
+	struct pebs_record_nhm nhm;
+	/*
+	 * Real IP of the event. In the Intel documentation this
+	 * is called eventingrip.
+	 */
+	u64 real_ip;
+	/*
+	 * TSX tuning information field: abort cycles and abort flags.
+	 */
+	u64 tsx_tuning;
+};
+
 void init_debug_store_on_cpu(int cpu)
 {
 	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
@@ -548,6 +577,42 @@ struct event_constraint intel_ivb_pebs_event_constraints[] = {
         EVENT_CONSTRAINT_END
 };
 
+struct event_constraint intel_hsw_pebs_event_constraints[] = {
+	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
+	INTEL_PST_HSW_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
+	INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
+	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
+	INTEL_UEVENT_CONSTRAINT(0x01c5, 0xf), /* BR_MISP_RETIRED.CONDITIONAL */
+	INTEL_UEVENT_CONSTRAINT(0x04c5, 0xf), /* BR_MISP_RETIRED.ALL_BRANCHES */
+	INTEL_UEVENT_CONSTRAINT(0x20c5, 0xf), /* BR_MISP_RETIRED.NEAR_TAKEN */
+	INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.* */
+	/* MEM_UOPS_RETIRED.STLB_MISS_LOADS */
+	INTEL_UEVENT_CONSTRAINT(0x11d0, 0xf),
+	/* MEM_UOPS_RETIRED.STLB_MISS_STORES */
+	INTEL_UEVENT_CONSTRAINT(0x12d0, 0xf),
+	INTEL_UEVENT_CONSTRAINT(0x21d0, 0xf), /* MEM_UOPS_RETIRED.LOCK_LOADS */
+	INTEL_UEVENT_CONSTRAINT(0x41d0, 0xf), /* MEM_UOPS_RETIRED.SPLIT_LOADS */
+	/* MEM_UOPS_RETIRED.SPLIT_STORES */
+	INTEL_UEVENT_CONSTRAINT(0x42d0, 0xf),
+	INTEL_UEVENT_CONSTRAINT(0x81d0, 0xf), /* MEM_UOPS_RETIRED.ALL_LOADS */
+	INTEL_PST_HSW_CONSTRAINT(0x82d0, 0xf), /* MEM_UOPS_RETIRED.ALL_STORES */
+	INTEL_UEVENT_CONSTRAINT(0x01d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L1_HIT */
+	INTEL_UEVENT_CONSTRAINT(0x02d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L2_HIT */
+	INTEL_UEVENT_CONSTRAINT(0x04d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L3_HIT */
+	/* MEM_LOAD_UOPS_RETIRED.HIT_LFB */
+	INTEL_UEVENT_CONSTRAINT(0x40d1, 0xf),
+	/* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_MISS */
+	INTEL_UEVENT_CONSTRAINT(0x01d2, 0xf),
+	/* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_HIT */
+	INTEL_UEVENT_CONSTRAINT(0x02d2, 0xf),
+	/* MEM_LOAD_UOPS_LLC_MISS_RETIRED.LOCAL_DRAM */
+	INTEL_UEVENT_CONSTRAINT(0x01d3, 0xf),
+	INTEL_UEVENT_CONSTRAINT(0x04c8, 0xf), /* HLE_RETIRED.Abort */
+	INTEL_UEVENT_CONSTRAINT(0x04c9, 0xf), /* RTM_RETIRED.Abort */
+
+	EVENT_CONSTRAINT_END
+};
+
 struct event_constraint *intel_pebs_constraints(struct perf_event *event)
 {
 	struct event_constraint *c;
@@ -588,6 +653,12 @@ void intel_pmu_pebs_disable(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 
 	cpuc->pebs_enabled &= ~(1ULL << hwc->idx);
+
+	if (event->hw.constraint->flags & PERF_X86_EVENT_PEBS_LDLAT)
+		cpuc->pebs_enabled &= ~(1ULL << (hwc->idx + 32));
+	else if (event->hw.constraint->flags & PERF_X86_EVENT_PEBS_ST)
+		cpuc->pebs_enabled &= ~(1ULL << 63);
+
 	if (cpuc->enabled)
 		wrmsrl(MSR_IA32_PEBS_ENABLE, cpuc->pebs_enabled);
 
@@ -697,6 +768,7 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	 */
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct pebs_record_nhm *pebs = __pebs;
+	struct pebs_record_hsw *pebs_hsw = __pebs;
 	struct perf_sample_data data;
 	struct pt_regs regs;
 	u64 sample_type;
@@ -706,7 +778,8 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 		return;
 
 	fll = event->hw.flags & PERF_X86_EVENT_PEBS_LDLAT;
-	fst = event->hw.flags & PERF_X86_EVENT_PEBS_ST;
+	fst = event->hw.flags & (PERF_X86_EVENT_PEBS_ST |
+				 PERF_X86_EVENT_PEBS_ST_HSW);
 
 	perf_sample_data_init(&data, 0, event->hw.last_period);
 
@@ -717,9 +790,6 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	 * if PEBS-LL or PreciseStore
 	 */
 	if (fll || fst) {
-		if (sample_type & PERF_SAMPLE_ADDR)
-			data.addr = pebs->dla;
-
 		/*
 		 * Use latency for weight (only avail with PEBS-LL)
 		 */
@@ -732,6 +802,9 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 		if (sample_type & PERF_SAMPLE_DATA_SRC) {
 			if (fll)
 				data.data_src.val = load_latency_data(pebs->dse);
+			else if (event->hw.flags & PERF_X86_EVENT_PEBS_ST_HSW)
+				data.data_src.val =
+					precise_store_data_hsw(pebs->dse);
 			else
 				data.data_src.val = precise_store_data(pebs->dse);
 		}
@@ -753,11 +826,18 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	regs.bp = pebs->bp;
 	regs.sp = pebs->sp;
 
-	if (event->attr.precise_ip > 1 && intel_pmu_pebs_fixup_ip(&regs))
+	if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format >= 2) {
+		regs.ip = pebs_hsw->real_ip;
+		regs.flags |= PERF_EFLAGS_EXACT;
+	} else if (event->attr.precise_ip > 1 && intel_pmu_pebs_fixup_ip(&regs))
 		regs.flags |= PERF_EFLAGS_EXACT;
 	else
 		regs.flags &= ~PERF_EFLAGS_EXACT;
 
+	if ((event->attr.sample_type & PERF_SAMPLE_ADDR) &&
+		x86_pmu.intel_cap.pebs_format >= 1)
+		data.addr = pebs->dla;
+
 	if (has_branch_stack(event))
 		data.br_stack = &cpuc->lbr_stack;
 
@@ -806,35 +886,22 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 	__intel_pmu_pebs_event(event, iregs, at);
 }
 
-static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
+static void __intel_pmu_drain_pebs_nhm(struct pt_regs *iregs, void *at,
+					void *top)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct debug_store *ds = cpuc->ds;
-	struct pebs_record_nhm *at, *top;
 	struct perf_event *event = NULL;
 	u64 status = 0;
-	int bit, n;
-
-	if (!x86_pmu.pebs_active)
-		return;
-
-	at  = (struct pebs_record_nhm *)(unsigned long)ds->pebs_buffer_base;
-	top = (struct pebs_record_nhm *)(unsigned long)ds->pebs_index;
+	int bit;
 
 	ds->pebs_index = ds->pebs_buffer_base;
 
-	n = top - at;
-	if (n <= 0)
-		return;
-
-	/*
-	 * Should not happen, we program the threshold at 1 and do not
-	 * set a reset value.
-	 */
-	WARN_ONCE(n > x86_pmu.max_pebs_events, "Unexpected number of pebs records %d\n", n);
+	for (; at < top; at += x86_pmu.pebs_record_size) {
+		struct pebs_record_nhm *p = at;
 
-	for ( ; at < top; at++) {
-		for_each_set_bit(bit, (unsigned long *)&at->status, x86_pmu.max_pebs_events) {
+		for_each_set_bit(bit, (unsigned long *)&p->status,
+				 x86_pmu.max_pebs_events) {
 			event = cpuc->events[bit];
 			if (!test_bit(bit, cpuc->active_mask))
 				continue;
@@ -857,6 +924,61 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 	}
 }
 
+static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct debug_store *ds = cpuc->ds;
+	struct pebs_record_nhm *at, *top;
+	int n;
+
+	if (!x86_pmu.pebs_active)
+		return;
+
+	at  = (struct pebs_record_nhm *)(unsigned long)ds->pebs_buffer_base;
+	top = (struct pebs_record_nhm *)(unsigned long)ds->pebs_index;
+
+	ds->pebs_index = ds->pebs_buffer_base;
+
+	n = top - at;
+	if (n <= 0)
+		return;
+
+	/*
+	 * Should not happen, we program the threshold at 1 and do not
+	 * set a reset value.
+	 */
+	WARN_ONCE(n > x86_pmu.max_pebs_events,
+		  "Unexpected number of pebs records %d\n", n);
+
+	return __intel_pmu_drain_pebs_nhm(iregs, at, top);
+}
+
+static void intel_pmu_drain_pebs_hsw(struct pt_regs *iregs)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct debug_store *ds = cpuc->ds;
+	struct pebs_record_hsw *at, *top;
+	int n;
+
+	if (!x86_pmu.pebs_active)
+		return;
+
+	at  = (struct pebs_record_hsw *)(unsigned long)ds->pebs_buffer_base;
+	top = (struct pebs_record_hsw *)(unsigned long)ds->pebs_index;
+
+	n = top - at;
+	if (n <= 0)
+		return;
+	/*
+	 * Should not happen, we program the threshold at 1 and do not
+	 * set a reset value.
+	 */
+	WARN_ONCE(n > x86_pmu.max_pebs_events,
+		  "Unexpected number of pebs records %d\n", n);
+
+	return __intel_pmu_drain_pebs_nhm(iregs, at, top);
+}
+
 /*
  * BTS, PEBS probe and setup
  */
@@ -888,6 +1010,12 @@ void intel_ds_init(void)
 			x86_pmu.drain_pebs = intel_pmu_drain_pebs_nhm;
 			break;
 
+		case 2:
+			pr_cont("PEBS fmt2%c, ", pebs_type);
+			x86_pmu.pebs_record_size = sizeof(struct pebs_record_hsw);
+			x86_pmu.drain_pebs = intel_pmu_drain_pebs_hsw;
+			break;
+
 		default:
 			printk(KERN_CONT "no PEBS fmt%d%c, ", format, pebs_type);
 			x86_pmu.pebs = 0;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index d978353..d5be06a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -12,6 +12,16 @@ enum {
 	LBR_FORMAT_LIP		= 0x01,
 	LBR_FORMAT_EIP		= 0x02,
 	LBR_FORMAT_EIP_FLAGS	= 0x03,
+	LBR_FORMAT_EIP_FLAGS2	= 0x04,
+	LBR_FORMAT_MAX_KNOWN    = LBR_FORMAT_EIP_FLAGS2,
+};
+
+static enum {
+	LBR_EIP_FLAGS		= 1,
+	LBR_TSX			= 2,
+} lbr_desc[LBR_FORMAT_MAX_KNOWN + 1] = {
+	[LBR_FORMAT_EIP_FLAGS]  = LBR_EIP_FLAGS,
+	[LBR_FORMAT_EIP_FLAGS2] = LBR_EIP_FLAGS | LBR_TSX,
 };
 
 /*
@@ -56,6 +66,8 @@ enum {
 	 LBR_FAR)
 
 #define LBR_FROM_FLAG_MISPRED  (1ULL << 63)
+#define LBR_FROM_FLAG_IN_TX    (1ULL << 62)
+#define LBR_FROM_FLAG_ABORT    (1ULL << 61)
 
 #define for_each_branch_sample_type(x) \
 	for ((x) = PERF_SAMPLE_BRANCH_USER; \
@@ -81,9 +93,13 @@ enum {
 	X86_BR_JMP      = 1 << 9, /* jump */
 	X86_BR_IRQ      = 1 << 10,/* hw interrupt or trap or fault */
 	X86_BR_IND_CALL = 1 << 11,/* indirect calls */
+	X86_BR_ABORT    = 1 << 12,/* transaction abort */
+	X86_BR_IN_TX    = 1 << 13,/* in transaction */
+	X86_BR_NO_TX    = 1 << 14,/* not in transaction */
 };
 
 #define X86_BR_PLM (X86_BR_USER | X86_BR_KERNEL)
+#define X86_BR_ANYTX (X86_BR_NO_TX | X86_BR_IN_TX)
 
 #define X86_BR_ANY       \
 	(X86_BR_CALL    |\
@@ -95,6 +111,7 @@ enum {
 	 X86_BR_JCC     |\
 	 X86_BR_JMP	 |\
 	 X86_BR_IRQ	 |\
+	 X86_BR_ABORT	 |\
 	 X86_BR_IND_CALL)
 
 #define X86_BR_ALL (X86_BR_PLM | X86_BR_ANY)
@@ -270,21 +287,31 @@ static void intel_pmu_lbr_read_64(struct cpu_hw_events *cpuc)
 
 	for (i = 0; i < x86_pmu.lbr_nr; i++) {
 		unsigned long lbr_idx = (tos - i) & mask;
-		u64 from, to, mis = 0, pred = 0;
+		u64 from, to, mis = 0, pred = 0, in_tx = 0, abort = 0;
+		int skip = 0;
+		int lbr_flags = lbr_desc[lbr_format];
 
 		rdmsrl(x86_pmu.lbr_from + lbr_idx, from);
 		rdmsrl(x86_pmu.lbr_to   + lbr_idx, to);
 
-		if (lbr_format == LBR_FORMAT_EIP_FLAGS) {
+		if (lbr_flags & LBR_EIP_FLAGS) {
 			mis = !!(from & LBR_FROM_FLAG_MISPRED);
 			pred = !mis;
-			from = (u64)((((s64)from) << 1) >> 1);
+			skip = 1;
+		}
+		if (lbr_flags & LBR_TSX) {
+			in_tx = !!(from & LBR_FROM_FLAG_IN_TX);
+			abort = !!(from & LBR_FROM_FLAG_ABORT);
+			skip = 3;
 		}
+		from = (u64)((((s64)from) << skip) >> skip);
 
 		cpuc->lbr_entries[i].from	= from;
 		cpuc->lbr_entries[i].to		= to;
 		cpuc->lbr_entries[i].mispred	= mis;
 		cpuc->lbr_entries[i].predicted	= pred;
+		cpuc->lbr_entries[i].in_tx	= in_tx;
+		cpuc->lbr_entries[i].abort	= abort;
 		cpuc->lbr_entries[i].reserved	= 0;
 	}
 	cpuc->lbr_stack.nr = i;
@@ -310,7 +337,7 @@ void intel_pmu_lbr_read(void)
  * - in case there is no HW filter
  * - in case the HW filter has errata or limitations
  */
-static int intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
+static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 {
 	u64 br_type = event->attr.branch_sample_type;
 	int mask = 0;
@@ -318,11 +345,8 @@ static int intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 	if (br_type & PERF_SAMPLE_BRANCH_USER)
 		mask |= X86_BR_USER;
 
-	if (br_type & PERF_SAMPLE_BRANCH_KERNEL) {
-		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
-			return -EACCES;
+	if (br_type & PERF_SAMPLE_BRANCH_KERNEL)
 		mask |= X86_BR_KERNEL;
-	}
 
 	/* we ignore BRANCH_HV here */
 
@@ -337,13 +361,21 @@ static int intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 
 	if (br_type & PERF_SAMPLE_BRANCH_IND_CALL)
 		mask |= X86_BR_IND_CALL;
+
+	if (br_type & PERF_SAMPLE_BRANCH_ABORT_TX)
+		mask |= X86_BR_ABORT;
+
+	if (br_type & PERF_SAMPLE_BRANCH_IN_TX)
+		mask |= X86_BR_IN_TX;
+
+	if (br_type & PERF_SAMPLE_BRANCH_NO_TX)
+		mask |= X86_BR_NO_TX;
+
 	/*
 	 * stash actual user request into reg, it may
 	 * be used by fixup code for some CPU
 	 */
 	event->hw.branch_reg.reg = mask;
-
-	return 0;
 }
 
 /*
@@ -391,9 +423,7 @@ int intel_pmu_setup_lbr_filter(struct perf_event *event)
 	/*
 	 * setup SW LBR filter
 	 */
-	ret = intel_pmu_setup_sw_lbr_filter(event);
-	if (ret)
-		return ret;
+	intel_pmu_setup_sw_lbr_filter(event);
 
 	/*
 	 * setup HW LBR filter, if any
@@ -415,7 +445,7 @@ int intel_pmu_setup_lbr_filter(struct perf_event *event)
  * decoded (e.g., text page not present), then X86_BR_NONE is
  * returned.
  */
-static int branch_type(unsigned long from, unsigned long to)
+static int branch_type(unsigned long from, unsigned long to, int abort)
 {
 	struct insn insn;
 	void *addr;
@@ -435,6 +465,9 @@ static int branch_type(unsigned long from, unsigned long to)
 	if (from == 0 || to == 0)
 		return X86_BR_NONE;
 
+	if (abort)
+		return X86_BR_ABORT | to_plm;
+
 	if (from_plm == X86_BR_USER) {
 		/*
 		 * can happen if measuring at the user level only
@@ -581,7 +614,13 @@ intel_pmu_lbr_filter(struct cpu_hw_events *cpuc)
 		from = cpuc->lbr_entries[i].from;
 		to = cpuc->lbr_entries[i].to;
 
-		type = branch_type(from, to);
+		type = branch_type(from, to, cpuc->lbr_entries[i].abort);
+		if (type != X86_BR_NONE && (br_sel & X86_BR_ANYTX)) {
+			if (cpuc->lbr_entries[i].in_tx)
+				type |= X86_BR_IN_TX;
+			else
+				type |= X86_BR_NO_TX;
+		}
 
 		/* if type does not correspond, then discard */
 		if (type == X86_BR_NONE || (br_sel & type) != type) {
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 52441a2..9dd9975 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -536,7 +536,7 @@ __snbep_cbox_get_constraint(struct intel_uncore_box *box, struct perf_event *eve
 	if (!uncore_box_is_fake(box))
 		reg1->alloc |= alloc;
 
-	return 0;
+	return NULL;
 fail:
 	for (; i >= 0; i--) {
 		if (alloc & (0x1 << i))
@@ -644,7 +644,7 @@ snbep_pcu_get_constraint(struct intel_uncore_box *box, struct perf_event *event)
 	    (!uncore_box_is_fake(box) && reg1->alloc))
 		return NULL;
 again:
-	mask = 0xff << (idx * 8);
+	mask = 0xffULL << (idx * 8);
 	raw_spin_lock_irqsave(&er->lock, flags);
 	if (!__BITS_VALUE(atomic_read(&er->ref), idx, 8) ||
 	    !((config1 ^ er->config) & mask)) {
@@ -1923,7 +1923,7 @@ static u64 nhmex_mbox_alter_er(struct perf_event *event, int new_idx, bool modif
 {
 	struct hw_perf_event *hwc = &event->hw;
 	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
-	int idx, orig_idx = __BITS_VALUE(reg1->idx, 0, 8);
+	u64 idx, orig_idx = __BITS_VALUE(reg1->idx, 0, 8);
 	u64 config = reg1->config;
 
 	/* get the non-shared control bits and shift them */
@@ -2723,15 +2723,16 @@ static void uncore_put_event_constraint(struct intel_uncore_box *box, struct per
 static int uncore_assign_events(struct intel_uncore_box *box, int assign[], int n)
 {
 	unsigned long used_mask[BITS_TO_LONGS(UNCORE_PMC_IDX_MAX)];
-	struct event_constraint *c, *constraints[UNCORE_PMC_IDX_MAX];
+	struct event_constraint *c;
 	int i, wmin, wmax, ret = 0;
 	struct hw_perf_event *hwc;
 
 	bitmap_zero(used_mask, UNCORE_PMC_IDX_MAX);
 
 	for (i = 0, wmin = UNCORE_PMC_IDX_MAX, wmax = 0; i < n; i++) {
+		hwc = &box->event_list[i]->hw;
 		c = uncore_get_event_constraint(box, box->event_list[i]);
-		constraints[i] = c;
+		hwc->constraint = c;
 		wmin = min(wmin, c->weight);
 		wmax = max(wmax, c->weight);
 	}
@@ -2739,7 +2740,7 @@ static int uncore_assign_events(struct intel_uncore_box *box, int assign[], int
 	/* fastpath, try to reuse previous register */
 	for (i = 0; i < n; i++) {
 		hwc = &box->event_list[i]->hw;
-		c = constraints[i];
+		c = hwc->constraint;
 
 		/* never assigned */
 		if (hwc->idx == -1)
@@ -2759,7 +2760,8 @@ static int uncore_assign_events(struct intel_uncore_box *box, int assign[], int
 	}
 	/* slow path */
 	if (i != n)
-		ret = perf_assign_events(constraints, n, wmin, wmax, assign);
+		ret = perf_assign_events(box->event_list, n,
+					 wmin, wmax, assign);
 
 	if (!assign || ret) {
 		for (i = 0; i < n; i++)
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index f952891..47b3d00 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -337,10 +337,10 @@
 		 NHMEX_M_PMON_CTL_SET_FLAG_SEL_MASK)
 
 #define NHMEX_M_PMON_ZDP_CTL_FVC_MASK		(((1 << 11) - 1) | (1 << 23))
-#define NHMEX_M_PMON_ZDP_CTL_FVC_EVENT_MASK(n)	(0x7 << (11 + 3 * (n)))
+#define NHMEX_M_PMON_ZDP_CTL_FVC_EVENT_MASK(n)	(0x7ULL << (11 + 3 * (n)))
 
 #define WSMEX_M_PMON_ZDP_CTL_FVC_MASK		(((1 << 12) - 1) | (1 << 24))
-#define WSMEX_M_PMON_ZDP_CTL_FVC_EVENT_MASK(n)	(0x7 << (12 + 3 * (n)))
+#define WSMEX_M_PMON_ZDP_CTL_FVC_EVENT_MASK(n)	(0x7ULL << (12 + 3 * (n)))
 
 /*
  * use the 9~13 bits to select event If the 7th bit is not set,
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 6030805..0920212 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -14,6 +14,7 @@
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
 #include <linux/nmi.h>
+#include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/hardirq.h>
 #include <linux/slab.h>
@@ -29,6 +30,9 @@
 #include <asm/nmi.h>
 #include <asm/x86_init.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/nmi.h>
+
 struct nmi_desc {
 	spinlock_t lock;
 	struct list_head head;
@@ -82,6 +86,15 @@ __setup("unknown_nmi_panic", setup_unknown_nmi_panic);
 
 #define nmi_to_desc(type) (&nmi_desc[type])
 
+static u64 nmi_longest_ns = 1 * NSEC_PER_MSEC;
+static int __init nmi_warning_debugfs(void)
+{
+	debugfs_create_u64("nmi_longest_ns", 0644,
+			arch_debugfs_dir, &nmi_longest_ns);
+	return 0;
+}
+fs_initcall(nmi_warning_debugfs);
+
 static int __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2b)
 {
 	struct nmi_desc *desc = nmi_to_desc(type);
@@ -96,8 +109,27 @@ static int __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2
 	 * can be latched at any given time.  Walk the whole list
 	 * to handle those situations.
 	 */
-	list_for_each_entry_rcu(a, &desc->head, list)
-		handled += a->handler(type, regs);
+	list_for_each_entry_rcu(a, &desc->head, list) {
+		u64 before, delta, whole_msecs;
+		int decimal_msecs, thishandled;
+
+		before = local_clock();
+		thishandled = a->handler(type, regs);
+		handled += thishandled;
+		delta = local_clock() - before;
+		trace_nmi_handler(a->handler, (int)delta, thishandled);
+
+		if (delta < nmi_longest_ns)
+			continue;
+
+		nmi_longest_ns = delta;
+		whole_msecs = do_div(delta, (1000 * 1000));
+		decimal_msecs = do_div(delta, 1000) % 1000;
+		printk_ratelimited(KERN_INFO
+			"INFO: NMI handler (%ps) took too long to run: "
+			"%lld.%03d msecs\n", a->handler, whole_msecs,
+			decimal_msecs);
+	}
 
 	rcu_read_unlock();
 
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 6956299..cf91358 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -43,12 +43,6 @@
 
 #include <asm/sigframe.h>
 
-#ifdef CONFIG_X86_32
-# define FIX_EFLAGS	(__FIX_EFLAGS | X86_EFLAGS_RF)
-#else
-# define FIX_EFLAGS	__FIX_EFLAGS
-#endif
-
 #define COPY(x)			do {			\
 	get_user_ex(regs->x, &sc->x);			\
 } while (0)
@@ -668,15 +662,17 @@ handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 	if (!failed) {
 		/*
 		 * Clear the direction flag as per the ABI for function entry.
-		 */
-		regs->flags &= ~X86_EFLAGS_DF;
-		/*
+		 *
+		 * Clear RF when entering the signal handler, because
+		 * it might disable possible debug exception from the
+		 * signal handler.
+		 *
 		 * Clear TF when entering the signal handler, but
 		 * notify any tracer that was single-stepping it.
 		 * The tracer may want to single-step inside the
 		 * handler too.
 		 */
-		regs->flags &= ~X86_EFLAGS_TF;
+		regs->flags &= ~(X86_EFLAGS_DF|X86_EFLAGS_RF|X86_EFLAGS_TF);
 	}
 	signal_setup_done(failed, ksig, test_thread_flag(TIF_SINGLESTEP));
 }
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index bf51abb..7acbf35 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -99,7 +99,7 @@ struct ivhd_header {
 	u64 mmio_phys;
 	u16 pci_seg;
 	u16 info;
-	u32 reserved;
+	u32 efr;
 } __attribute__((packed));
 
 /*
@@ -154,6 +154,7 @@ bool amd_iommu_iotlb_sup __read_mostly = true;
 u32 amd_iommu_max_pasids __read_mostly = ~0;
 
 bool amd_iommu_v2_present __read_mostly;
+bool amd_iommu_pc_present __read_mostly;
 
 bool amd_iommu_force_isolation __read_mostly;
 
@@ -369,23 +370,23 @@ static void iommu_disable(struct amd_iommu *iommu)
  * mapping and unmapping functions for the IOMMU MMIO space. Each AMD IOMMU in
  * the system has one.
  */
-static u8 __iomem * __init iommu_map_mmio_space(u64 address)
+static u8 __iomem * __init iommu_map_mmio_space(u64 address, u64 end)
 {
-	if (!request_mem_region(address, MMIO_REGION_LENGTH, "amd_iommu")) {
-		pr_err("AMD-Vi: Can not reserve memory region %llx for mmio\n",
-			address);
+	if (!request_mem_region(address, end, "amd_iommu")) {
+		pr_err("AMD-Vi: Can not reserve memory region %llx-%llx for mmio\n",
+			address, end);
 		pr_err("AMD-Vi: This is a BIOS bug. Please contact your hardware vendor\n");
 		return NULL;
 	}
 
-	return (u8 __iomem *)ioremap_nocache(address, MMIO_REGION_LENGTH);
+	return (u8 __iomem *)ioremap_nocache(address, end);
 }
 
 static void __init iommu_unmap_mmio_space(struct amd_iommu *iommu)
 {
 	if (iommu->mmio_base)
 		iounmap(iommu->mmio_base);
-	release_mem_region(iommu->mmio_phys, MMIO_REGION_LENGTH);
+	release_mem_region(iommu->mmio_phys, iommu->mmio_phys_end);
 }
 
 /****************************************************************************
@@ -1085,7 +1086,18 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 	iommu->cap_ptr = h->cap_ptr;
 	iommu->pci_seg = h->pci_seg;
 	iommu->mmio_phys = h->mmio_phys;
-	iommu->mmio_base = iommu_map_mmio_space(h->mmio_phys);
+
+	/* Check if IVHD EFR contains proper max banks/counters */
+	if ((h->efr != 0) &&
+	    ((h->efr & (0xF << 13)) != 0) &&
+	    ((h->efr & (0x3F << 17)) != 0)) {
+		iommu->mmio_phys_end = MMIO_REG_END_OFFSET;
+	} else {
+		iommu->mmio_phys_end = MMIO_CNTR_CONF_OFFSET;
+	}
+
+	iommu->mmio_base = iommu_map_mmio_space(iommu->mmio_phys,
+						iommu->mmio_phys_end);
 	if (!iommu->mmio_base)
 		return -ENOMEM;
 
@@ -1160,6 +1172,33 @@ static int __init init_iommu_all(struct acpi_table_header *table)
 	return 0;
 }
 
+
+static void init_iommu_perf_ctr(struct amd_iommu *iommu)
+{
+	u64 val = 0xabcd, val2 = 0;
+
+	if (!iommu_feature(iommu, FEATURE_PC))
+		return;
+
+	amd_iommu_pc_present = true;
+
+	/* Check if the performance counters can be written to */
+	if ((0 != amd_iommu_pc_get_set_reg_val(0, 0, 0, 0, &val, true)) ||
+	    (0 != amd_iommu_pc_get_set_reg_val(0, 0, 0, 0, &val2, false)) ||
+	    (val != val2)) {
+		pr_err("AMD-Vi: Unable to write to IOMMU perf counter.\n");
+		amd_iommu_pc_present = false;
+		return;
+	}
+
+	pr_info("AMD-Vi: IOMMU performance counters supported\n");
+
+	val = readl(iommu->mmio_base + MMIO_CNTR_CONF_OFFSET);
+	iommu->max_banks = (u8) ((val >> 12) & 0x3f);
+	iommu->max_counters = (u8) ((val >> 7) & 0xf);
+}
+
+
 static int iommu_init_pci(struct amd_iommu *iommu)
 {
 	int cap_ptr = iommu->cap_ptr;
@@ -1226,6 +1265,8 @@ static int iommu_init_pci(struct amd_iommu *iommu)
 	if (iommu->cap & (1UL << IOMMU_CAP_NPCACHE))
 		amd_iommu_np_cache = true;
 
+	init_iommu_perf_ctr(iommu);
+
 	if (is_rd890_iommu(iommu->dev)) {
 		int i, j;
 
@@ -1278,7 +1319,7 @@ static void print_iommu_info(void)
 				if (iommu_feature(iommu, (1ULL << i)))
 					pr_cont(" %s", feat_str[i]);
 			}
-		pr_cont("\n");
+			pr_cont("\n");
 		}
 	}
 	if (irq_remapping_enabled)
@@ -2232,3 +2273,84 @@ bool amd_iommu_v2_supported(void)
 	return amd_iommu_v2_present;
 }
 EXPORT_SYMBOL(amd_iommu_v2_supported);
+
+/****************************************************************************
+ *
+ * IOMMU EFR Performance Counter support functionality. This code allows
+ * access to the IOMMU PC functionality.
+ *
+ ****************************************************************************/
+
+u8 amd_iommu_pc_get_max_banks(u16 devid)
+{
+	struct amd_iommu *iommu;
+	u8 ret = 0;
+
+	/* locate the iommu governing the devid */
+	iommu = amd_iommu_rlookup_table[devid];
+	if (iommu)
+		ret = iommu->max_banks;
+
+	return ret;
+}
+EXPORT_SYMBOL(amd_iommu_pc_get_max_banks);
+
+bool amd_iommu_pc_supported(void)
+{
+	return amd_iommu_pc_present;
+}
+EXPORT_SYMBOL(amd_iommu_pc_supported);
+
+u8 amd_iommu_pc_get_max_counters(u16 devid)
+{
+	struct amd_iommu *iommu;
+	u8 ret = 0;
+
+	/* locate the iommu governing the devid */
+	iommu = amd_iommu_rlookup_table[devid];
+	if (iommu)
+		ret = iommu->max_counters;
+
+	return ret;
+}
+EXPORT_SYMBOL(amd_iommu_pc_get_max_counters);
+
+int amd_iommu_pc_get_set_reg_val(u16 devid, u8 bank, u8 cntr, u8 fxn,
+				    u64 *value, bool is_write)
+{
+	struct amd_iommu *iommu;
+	u32 offset;
+	u32 max_offset_lim;
+
+	/* Make sure the IOMMU PC resource is available */
+	if (!amd_iommu_pc_present)
+		return -ENODEV;
+
+	/* Locate the iommu associated with the device ID */
+	iommu = amd_iommu_rlookup_table[devid];
+
+	/* Check for valid iommu and pc register indexing */
+	if (WARN_ON((iommu == NULL) || (fxn > 0x28) || (fxn & 7)))
+		return -ENODEV;
+
+	offset = (u32)(((0x40|bank) << 12) | (cntr << 8) | fxn);
+
+	/* Limit the offset to the hw defined mmio region aperture */
+	max_offset_lim = (u32)(((0x40|iommu->max_banks) << 12) |
+				(iommu->max_counters << 8) | 0x28);
+	if ((offset < MMIO_CNTR_REG_OFFSET) ||
+	    (offset > max_offset_lim))
+		return -EINVAL;
+
+	if (is_write) {
+		writel((u32)*value, iommu->mmio_base + offset);
+		writel((*value >> 32), iommu->mmio_base + offset + 4);
+	} else {
+		*value = readl(iommu->mmio_base + offset + 4);
+		*value <<= 32;
+		*value = readl(iommu->mmio_base + offset);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(amd_iommu_pc_get_set_reg_val);
diff --git a/drivers/iommu/amd_iommu_proto.h b/drivers/iommu/amd_iommu_proto.h
index c294961..95ed6de 100644
--- a/drivers/iommu/amd_iommu_proto.h
+++ b/drivers/iommu/amd_iommu_proto.h
@@ -56,6 +56,13 @@ extern int amd_iommu_domain_set_gcr3(struct iommu_domain *dom, int pasid,
 extern int amd_iommu_domain_clear_gcr3(struct iommu_domain *dom, int pasid);
 extern struct iommu_domain *amd_iommu_get_v2_domain(struct pci_dev *pdev);
 
+/* IOMMU Performance Counter functions */
+extern bool amd_iommu_pc_supported(void);
+extern u8 amd_iommu_pc_get_max_banks(u16 devid);
+extern u8 amd_iommu_pc_get_max_counters(u16 devid);
+extern int amd_iommu_pc_get_set_reg_val(u16 devid, u8 bank, u8 cntr, u8 fxn,
+				    u64 *value, bool is_write);
+
 #define PPR_SUCCESS			0x0
 #define PPR_INVALID			0x1
 #define PPR_FAILURE			0xf
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 0285a21..e400fbe 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -38,9 +38,6 @@
 #define ALIAS_TABLE_ENTRY_SIZE		2
 #define RLOOKUP_TABLE_ENTRY_SIZE	(sizeof(void *))
 
-/* Length of the MMIO region for the AMD IOMMU */
-#define MMIO_REGION_LENGTH       0x4000
-
 /* Capability offsets used by the driver */
 #define MMIO_CAP_HDR_OFFSET	0x00
 #define MMIO_RANGE_OFFSET	0x0c
@@ -78,6 +75,10 @@
 #define MMIO_STATUS_OFFSET	0x2020
 #define MMIO_PPR_HEAD_OFFSET	0x2030
 #define MMIO_PPR_TAIL_OFFSET	0x2038
+#define MMIO_CNTR_CONF_OFFSET	0x4000
+#define MMIO_CNTR_REG_OFFSET	0x40000
+#define MMIO_REG_END_OFFSET	0x80000
+
 
 
 /* Extended Feature Bits */
@@ -507,6 +508,10 @@ struct amd_iommu {
 
 	/* physical address of MMIO space */
 	u64 mmio_phys;
+
+	/* physical end address of MMIO space */
+	u64 mmio_phys_end;
+
 	/* virtual address of MMIO space */
 	u8 __iomem *mmio_base;
 
@@ -584,6 +589,10 @@ struct amd_iommu {
 
 	/* The l2 indirect registers */
 	u32 stored_l2[0x83];
+
+	/* The maximum PC banks and counters/bank (PCSup=1) */
+	u8 max_banks;
+	u8 max_counters;
 };
 
 struct devid_map {
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c5b6dbf..50b3efd 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -73,13 +73,18 @@ struct perf_raw_record {
  *
  * support for mispred, predicted is optional. In case it
  * is not supported mispred = predicted = 0.
+ *
+ *     in_tx: running in a hardware transaction
+ *     abort: aborting a hardware transaction
  */
 struct perf_branch_entry {
 	__u64	from;
 	__u64	to;
 	__u64	mispred:1,  /* target mispredicted */
 		predicted:1,/* target predicted */
-		reserved:62;
+		in_tx:1,    /* in transaction */
+		abort:1,    /* transaction abort */
+		reserved:60;
 };
 
 /*
@@ -113,6 +118,8 @@ struct hw_perf_event_extra {
 	int		idx;	/* index in shared_regs->regs[] */
 };
 
+struct event_constraint;
+
 /**
  * struct hw_perf_event - performance event hardware details:
  */
@@ -131,6 +138,8 @@ struct hw_perf_event {
 
 			struct hw_perf_event_extra extra_reg;
 			struct hw_perf_event_extra branch_reg;
+
+			struct event_constraint *constraint;
 		};
 		struct { /* software */
 			struct hrtimer	hrtimer;
@@ -188,12 +197,13 @@ struct pmu {
 
 	struct device			*dev;
 	const struct attribute_group	**attr_groups;
-	char				*name;
+	const char			*name;
 	int				type;
 
 	int * __percpu			pmu_disable_count;
 	struct perf_cpu_context * __percpu pmu_cpu_context;
 	int				task_ctx_nr;
+	int				hrtimer_interval_ms;
 
 	/*
 	 * Fully disable/enable this PMU, can be used to protect from the PMI
@@ -500,8 +510,9 @@ struct perf_cpu_context {
 	struct perf_event_context	*task_ctx;
 	int				active_oncpu;
 	int				exclusive;
+	struct hrtimer			hrtimer;
+	ktime_t				hrtimer_interval;
 	struct list_head		rotation_list;
-	int				jiffies_interval;
 	struct pmu			*unique_pmu;
 	struct perf_cgroup		*cgrp;
 };
@@ -517,7 +528,7 @@ struct perf_output_handle {
 
 #ifdef CONFIG_PERF_EVENTS
 
-extern int perf_pmu_register(struct pmu *pmu, char *name, int type);
+extern int perf_pmu_register(struct pmu *pmu, const char *name, int type);
 extern void perf_pmu_unregister(struct pmu *pmu);
 
 extern int perf_num_counters(void);
@@ -695,10 +706,17 @@ static inline void perf_callchain_store(struct perf_callchain_entry *entry, u64
 extern int sysctl_perf_event_paranoid;
 extern int sysctl_perf_event_mlock;
 extern int sysctl_perf_event_sample_rate;
+extern int sysctl_perf_cpu_time_max_percent;
+
+extern void perf_sample_event_took(u64 sample_len_ns);
 
 extern int perf_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos);
+extern int perf_cpu_time_max_percent_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos);
+
 
 static inline bool perf_paranoid_tracepoint_raw(void)
 {
@@ -742,6 +760,7 @@ extern unsigned int perf_output_skip(struct perf_output_handle *handle,
 				     unsigned int len);
 extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
+extern u64 perf_swevent_set_period(struct perf_event *event);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern int __perf_event_disable(void *info);
@@ -781,6 +800,7 @@ static inline void perf_event_fork(struct task_struct *tsk)		{ }
 static inline void perf_event_init(void)				{ }
 static inline int  perf_swevent_get_recursion_context(void)		{ return -1; }
 static inline void perf_swevent_put_recursion_context(int rctx)		{ }
+static inline u64 perf_swevent_set_period(struct perf_event *event)	{ return 0; }
 static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }
 static inline int __perf_event_disable(void *info)			{ return -1; }
diff --git a/include/trace/events/nmi.h b/include/trace/events/nmi.h
new file mode 100644
index 0000000..da3ee96
--- /dev/null
+++ b/include/trace/events/nmi.h
@@ -0,0 +1,37 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM nmi
+
+#if !defined(_TRACE_NMI_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_NMI_H
+
+#include <linux/ktime.h>
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(nmi_handler,
+
+	TP_PROTO(void *handler, s64 delta_ns, int handled),
+
+	TP_ARGS(handler, delta_ns, handled),
+
+	TP_STRUCT__entry(
+		__field(	void *,		handler	)
+		__field(	s64,		delta_ns)
+		__field(	int,		handled	)
+	),
+
+	TP_fast_assign(
+		__entry->handler = handler;
+		__entry->delta_ns = delta_ns;
+		__entry->handled = handled;
+	),
+
+	TP_printk("%ps() delta_ns: %lld handled: %d",
+		__entry->handler,
+		__entry->delta_ns,
+		__entry->handled)
+);
+
+#endif /* _TRACE_NMI_H */
+
+/* This part ust be outside protection */
+#include <trace/define_trace.h>
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index fb104e5..0b1df41 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -157,8 +157,11 @@ enum perf_branch_sample_type {
 	PERF_SAMPLE_BRANCH_ANY_CALL	= 1U << 4, /* any call branch */
 	PERF_SAMPLE_BRANCH_ANY_RETURN	= 1U << 5, /* any return branch */
 	PERF_SAMPLE_BRANCH_IND_CALL	= 1U << 6, /* indirect calls */
+	PERF_SAMPLE_BRANCH_ABORT_TX	= 1U << 7, /* transaction aborts */
+	PERF_SAMPLE_BRANCH_IN_TX	= 1U << 8, /* in transaction */
+	PERF_SAMPLE_BRANCH_NO_TX	= 1U << 9, /* not in transaction */
 
-	PERF_SAMPLE_BRANCH_MAX		= 1U << 7, /* non-ABI */
+	PERF_SAMPLE_BRANCH_MAX		= 1U << 10, /* non-ABI */
 };
 
 #define PERF_SAMPLE_BRANCH_PLM_ALL \
diff --git a/init/main.c b/init/main.c
index 9484f4b..ec54958 100644
--- a/init/main.c
+++ b/init/main.c
@@ -542,7 +542,6 @@ asmlinkage void __init start_kernel(void)
 	if (WARN(!irqs_disabled(), "Interrupts were enabled *very* early, fixing it\n"))
 		local_irq_disable();
 	idr_init_cache();
-	perf_event_init();
 	rcu_init();
 	tick_nohz_init();
 	radix_tree_init();
@@ -555,6 +554,7 @@ asmlinkage void __init start_kernel(void)
 	softirq_init();
 	timekeeping_init();
 	time_init();
+	perf_event_init();
 	profile_init();
 	call_function_init();
 	WARN(!irqs_disabled(), "Interrupts were enabled early\n");
diff --git a/kernel/events/core.c b/kernel/events/core.c
index b391907..1db3af9 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -165,10 +165,28 @@ int sysctl_perf_event_mlock __read_mostly = 512 + (PAGE_SIZE / 1024); /* 'free'
 /*
  * max perf event sample rate
  */
-#define DEFAULT_MAX_SAMPLE_RATE 100000
-int sysctl_perf_event_sample_rate __read_mostly = DEFAULT_MAX_SAMPLE_RATE;
-static int max_samples_per_tick __read_mostly =
-	DIV_ROUND_UP(DEFAULT_MAX_SAMPLE_RATE, HZ);
+#define DEFAULT_MAX_SAMPLE_RATE		100000
+#define DEFAULT_SAMPLE_PERIOD_NS	(NSEC_PER_SEC / DEFAULT_MAX_SAMPLE_RATE)
+#define DEFAULT_CPU_TIME_MAX_PERCENT	25
+
+int sysctl_perf_event_sample_rate __read_mostly	= DEFAULT_MAX_SAMPLE_RATE;
+
+static int max_samples_per_tick __read_mostly	= DIV_ROUND_UP(DEFAULT_MAX_SAMPLE_RATE, HZ);
+static int perf_sample_period_ns __read_mostly	= DEFAULT_SAMPLE_PERIOD_NS;
+
+static atomic_t perf_sample_allowed_ns __read_mostly =
+	ATOMIC_INIT( DEFAULT_SAMPLE_PERIOD_NS * DEFAULT_CPU_TIME_MAX_PERCENT / 100);
+
+void update_perf_cpu_limits(void)
+{
+	u64 tmp = perf_sample_period_ns;
+
+	tmp *= sysctl_perf_cpu_time_max_percent;
+	tmp = do_div(tmp, 100);
+	atomic_set(&perf_sample_allowed_ns, tmp);
+}
+
+static int perf_rotate_context(struct perf_cpu_context *cpuctx);
 
 int perf_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
@@ -180,10 +198,78 @@ int perf_proc_update_handler(struct ctl_table *table, int write,
 		return ret;
 
 	max_samples_per_tick = DIV_ROUND_UP(sysctl_perf_event_sample_rate, HZ);
+	perf_sample_period_ns = NSEC_PER_SEC / sysctl_perf_event_sample_rate;
+	update_perf_cpu_limits();
 
 	return 0;
 }
 
+int sysctl_perf_cpu_time_max_percent __read_mostly = DEFAULT_CPU_TIME_MAX_PERCENT;
+
+int perf_cpu_time_max_percent_handler(struct ctl_table *table, int write,
+				void __user *buffer, size_t *lenp,
+				loff_t *ppos)
+{
+	int ret = proc_dointvec(table, write, buffer, lenp, ppos);
+
+	if (ret || !write)
+		return ret;
+
+	update_perf_cpu_limits();
+
+	return 0;
+}
+
+/*
+ * perf samples are done in some very critical code paths (NMIs).
+ * If they take too much CPU time, the system can lock up and not
+ * get any real work done.  This will drop the sample rate when
+ * we detect that events are taking too long.
+ */
+#define NR_ACCUMULATED_SAMPLES 128
+DEFINE_PER_CPU(u64, running_sample_length);
+
+void perf_sample_event_took(u64 sample_len_ns)
+{
+	u64 avg_local_sample_len;
+	u64 local_samples_len = __get_cpu_var(running_sample_length);
+
+	if (atomic_read(&perf_sample_allowed_ns) == 0)
+		return;
+
+	/* decay the counter by 1 average sample */
+	local_samples_len = __get_cpu_var(running_sample_length);
+	local_samples_len -= local_samples_len/NR_ACCUMULATED_SAMPLES;
+	local_samples_len += sample_len_ns;
+	__get_cpu_var(running_sample_length) = local_samples_len;
+
+	/*
+	 * note: this will be biased artifically low until we have
+	 * seen NR_ACCUMULATED_SAMPLES.  Doing it this way keeps us
+	 * from having to maintain a count.
+	 */
+	avg_local_sample_len = local_samples_len/NR_ACCUMULATED_SAMPLES;
+
+	if (avg_local_sample_len <= atomic_read(&perf_sample_allowed_ns))
+		return;
+
+	if (max_samples_per_tick <= 1)
+		return;
+
+	max_samples_per_tick = DIV_ROUND_UP(max_samples_per_tick, 2);
+	sysctl_perf_event_sample_rate = max_samples_per_tick * HZ;
+	perf_sample_period_ns = NSEC_PER_SEC / sysctl_perf_event_sample_rate;
+
+	printk_ratelimited(KERN_WARNING
+			"perf samples too long (%lld > %d), lowering "
+			"kernel.perf_event_max_sample_rate to %d\n",
+			avg_local_sample_len,
+			atomic_read(&perf_sample_allowed_ns),
+			sysctl_perf_event_sample_rate);
+
+	update_perf_cpu_limits();
+}
+
 static atomic64_t perf_event_id;
 
 static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
@@ -655,6 +741,106 @@ perf_cgroup_mark_enabled(struct perf_event *event,
 }
 #endif
 
+/*
+ * set default to be dependent on timer tick just
+ * like original code
+ */
+#define PERF_CPU_HRTIMER (1000 / HZ)
+/*
+ * function must be called with interrupts disbled
+ */
+static enum hrtimer_restart perf_cpu_hrtimer_handler(struct hrtimer *hr)
+{
+	struct perf_cpu_context *cpuctx;
+	enum hrtimer_restart ret = HRTIMER_NORESTART;
+	int rotations = 0;
+
+	WARN_ON(!irqs_disabled());
+
+	cpuctx = container_of(hr, struct perf_cpu_context, hrtimer);
+
+	rotations = perf_rotate_context(cpuctx);
+
+	/*
+	 * arm timer if needed
+	 */
+	if (rotations) {
+		hrtimer_forward_now(hr, cpuctx->hrtimer_interval);
+		ret = HRTIMER_RESTART;
+	}
+
+	return ret;
+}
+
+/* CPU is going down */
+void perf_cpu_hrtimer_cancel(int cpu)
+{
+	struct perf_cpu_context *cpuctx;
+	struct pmu *pmu;
+	unsigned long flags;
+
+	if (WARN_ON(cpu != smp_processor_id()))
+		return;
+
+	local_irq_save(flags);
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(pmu, &pmus, entry) {
+		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+
+		if (pmu->task_ctx_nr == perf_sw_context)
+			continue;
+
+		hrtimer_cancel(&cpuctx->hrtimer);
+	}
+
+	rcu_read_unlock();
+
+	local_irq_restore(flags);
+}
+
+static void __perf_cpu_hrtimer_init(struct perf_cpu_context *cpuctx, int cpu)
+{
+	struct hrtimer *hr = &cpuctx->hrtimer;
+	struct pmu *pmu = cpuctx->ctx.pmu;
+	int timer;
+
+	/* no multiplexing needed for SW PMU */
+	if (pmu->task_ctx_nr == perf_sw_context)
+		return;
+
+	/*
+	 * check default is sane, if not set then force to
+	 * default interval (1/tick)
+	 */
+	timer = pmu->hrtimer_interval_ms;
+	if (timer < 1)
+		timer = pmu->hrtimer_interval_ms = PERF_CPU_HRTIMER;
+
+	cpuctx->hrtimer_interval = ns_to_ktime(NSEC_PER_MSEC * timer);
+
+	hrtimer_init(hr, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
+	hr->function = perf_cpu_hrtimer_handler;
+}
+
+static void perf_cpu_hrtimer_restart(struct perf_cpu_context *cpuctx)
+{
+	struct hrtimer *hr = &cpuctx->hrtimer;
+	struct pmu *pmu = cpuctx->ctx.pmu;
+
+	/* not for SW PMU */
+	if (pmu->task_ctx_nr == perf_sw_context)
+		return;
+
+	if (hrtimer_active(hr))
+		return;
+
+	if (!hrtimer_callback_running(hr))
+		__hrtimer_start_range_ns(hr, cpuctx->hrtimer_interval,
+					 0, HRTIMER_MODE_REL_PINNED, 0);
+}
+
 void perf_pmu_disable(struct pmu *pmu)
 {
 	int *count = this_cpu_ptr(pmu->pmu_disable_count);
@@ -1503,6 +1689,7 @@ group_sched_in(struct perf_event *group_event,
 
 	if (event_sched_in(group_event, cpuctx, ctx)) {
 		pmu->cancel_txn(pmu);
+		perf_cpu_hrtimer_restart(cpuctx);
 		return -EAGAIN;
 	}
 
@@ -1549,6 +1736,8 @@ group_error:
 
 	pmu->cancel_txn(pmu);
 
+	perf_cpu_hrtimer_restart(cpuctx);
+
 	return -EAGAIN;
 }
 
@@ -1804,8 +1993,10 @@ static int __perf_event_enable(void *info)
 		 * If this event can't go on and it's part of a
 		 * group, then the whole group has to come off.
 		 */
-		if (leader != event)
+		if (leader != event) {
 			group_sched_out(leader, cpuctx, ctx);
+			perf_cpu_hrtimer_restart(cpuctx);
+		}
 		if (leader->attr.pinned) {
 			update_group_times(leader);
 			leader->state = PERF_EVENT_STATE_ERROR;
@@ -2552,7 +2743,7 @@ static void rotate_ctx(struct perf_event_context *ctx)
  * because they're strictly cpu affine and rotate_start is called with IRQs
  * disabled, while rotate_context is called from IRQ context.
  */
-static void perf_rotate_context(struct perf_cpu_context *cpuctx)
+static int perf_rotate_context(struct perf_cpu_context *cpuctx)
 {
 	struct perf_event_context *ctx = NULL;
 	int rotate = 0, remove = 1;
@@ -2591,6 +2782,8 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
 done:
 	if (remove)
 		list_del_init(&cpuctx->rotation_list);
+
+	return rotate;
 }
 
 #ifdef CONFIG_NO_HZ_FULL
@@ -2622,10 +2815,6 @@ void perf_event_task_tick(void)
 		ctx = cpuctx->task_ctx;
 		if (ctx)
 			perf_adjust_freq_unthr_context(ctx, throttled);
-
-		if (cpuctx->jiffies_interval == 1 ||
-				!(jiffies % cpuctx->jiffies_interval))
-			perf_rotate_context(cpuctx);
 	}
 }
 
@@ -5036,7 +5225,7 @@ static DEFINE_PER_CPU(struct swevent_htable, swevent_htable);
  * sign as trigger.
  */
 
-static u64 perf_swevent_set_period(struct perf_event *event)
+u64 perf_swevent_set_period(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	u64 period = hwc->last_period;
@@ -5979,9 +6168,56 @@ type_show(struct device *dev, struct device_attribute *attr, char *page)
 	return snprintf(page, PAGE_SIZE-1, "%d\n", pmu->type);
 }
 
+static ssize_t
+perf_event_mux_interval_ms_show(struct device *dev,
+				struct device_attribute *attr,
+				char *page)
+{
+	struct pmu *pmu = dev_get_drvdata(dev);
+
+	return snprintf(page, PAGE_SIZE-1, "%d\n", pmu->hrtimer_interval_ms);
+}
+
+static ssize_t
+perf_event_mux_interval_ms_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	struct pmu *pmu = dev_get_drvdata(dev);
+	int timer, cpu, ret;
+
+	ret = kstrtoint(buf, 0, &timer);
+	if (ret)
+		return ret;
+
+	if (timer < 1)
+		return -EINVAL;
+
+	/* same value, noting to do */
+	if (timer == pmu->hrtimer_interval_ms)
+		return count;
+
+	pmu->hrtimer_interval_ms = timer;
+
+	/* update all cpuctx for this PMU */
+	for_each_possible_cpu(cpu) {
+		struct perf_cpu_context *cpuctx;
+		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
+		cpuctx->hrtimer_interval = ns_to_ktime(NSEC_PER_MSEC * timer);
+
+		if (hrtimer_active(&cpuctx->hrtimer))
+			hrtimer_forward_now(&cpuctx->hrtimer, cpuctx->hrtimer_interval);
+	}
+
+	return count;
+}
+
+#define __ATTR_RW(attr) __ATTR(attr, 0644, attr##_show, attr##_store)
+
 static struct device_attribute pmu_dev_attrs[] = {
-       __ATTR_RO(type),
-       __ATTR_NULL,
+	__ATTR_RO(type),
+	__ATTR_RW(perf_event_mux_interval_ms),
+	__ATTR_NULL,
 };
 
 static int pmu_bus_running;
@@ -6027,7 +6263,7 @@ free_dev:
 static struct lock_class_key cpuctx_mutex;
 static struct lock_class_key cpuctx_lock;
 
-int perf_pmu_register(struct pmu *pmu, char *name, int type)
+int perf_pmu_register(struct pmu *pmu, const char *name, int type)
 {
 	int cpu, ret;
 
@@ -6076,7 +6312,9 @@ skip_type:
 		lockdep_set_class(&cpuctx->ctx.lock, &cpuctx_lock);
 		cpuctx->ctx.type = cpu_context;
 		cpuctx->ctx.pmu = pmu;
-		cpuctx->jiffies_interval = 1;
+
+		__perf_cpu_hrtimer_init(cpuctx, cpu);
+
 		INIT_LIST_HEAD(&cpuctx->rotation_list);
 		cpuctx->unique_pmu = pmu;
 	}
@@ -6402,11 +6640,6 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 		if (!(mask & ~PERF_SAMPLE_BRANCH_PLM_ALL))
 			return -EINVAL;
 
-		/* kernel level capture: check permissions */
-		if ((mask & PERF_SAMPLE_BRANCH_PERM_PLM)
-		    && perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
-			return -EACCES;
-
 		/* propagate priv level, when not set for branch */
 		if (!(mask & PERF_SAMPLE_BRANCH_PLM_ALL)) {
 
@@ -6424,6 +6657,10 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 			 */
 			attr->branch_sample_type = mask;
 		}
+		/* privileged levels capture (kernel, hv): check permissions */
+		if ((mask & PERF_SAMPLE_BRANCH_PERM_PLM)
+		    && perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
+			return -EACCES;
 	}
 
 	if (attr->sample_type & PERF_SAMPLE_REGS_USER) {
@@ -7476,7 +7713,6 @@ perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 	case CPU_DOWN_PREPARE:
 		perf_event_exit_cpu(cpu);
 		break;
-
 	default:
 		break;
 	}
diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index 20185ea..1559fb0 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -46,23 +46,26 @@
 #include <linux/smp.h>
 
 #include <linux/hw_breakpoint.h>
-
-
 /*
  * Constraints data
  */
+struct bp_cpuinfo {
+	/* Number of pinned cpu breakpoints in a cpu */
+	unsigned int	cpu_pinned;
+	/* tsk_pinned[n] is the number of tasks having n+1 breakpoints */
+	unsigned int	*tsk_pinned;
+	/* Number of non-pinned cpu/task breakpoints in a cpu */
+	unsigned int	flexible; /* XXX: placeholder, see fetch_this_slot() */
+};
 
-/* Number of pinned cpu breakpoints in a cpu */
-static DEFINE_PER_CPU(unsigned int, nr_cpu_bp_pinned[TYPE_MAX]);
-
-/* Number of pinned task breakpoints in a cpu */
-static DEFINE_PER_CPU(unsigned int *, nr_task_bp_pinned[TYPE_MAX]);
-
-/* Number of non-pinned cpu/task breakpoints in a cpu */
-static DEFINE_PER_CPU(unsigned int, nr_bp_flexible[TYPE_MAX]);
-
+static DEFINE_PER_CPU(struct bp_cpuinfo, bp_cpuinfo[TYPE_MAX]);
 static int nr_slots[TYPE_MAX];
 
+static struct bp_cpuinfo *get_bp_info(int cpu, enum bp_type_idx type)
+{
+	return per_cpu_ptr(bp_cpuinfo + type, cpu);
+}
+
 /* Keep track of the breakpoints attached to tasks */
 static LIST_HEAD(bp_task_head);
 
@@ -96,8 +99,8 @@ static inline enum bp_type_idx find_slot_idx(struct perf_event *bp)
  */
 static unsigned int max_task_bp_pinned(int cpu, enum bp_type_idx type)
 {
+	unsigned int *tsk_pinned = get_bp_info(cpu, type)->tsk_pinned;
 	int i;
-	unsigned int *tsk_pinned = per_cpu(nr_task_bp_pinned[type], cpu);
 
 	for (i = nr_slots[type] - 1; i >= 0; i--) {
 		if (tsk_pinned[i] > 0)
@@ -127,6 +130,13 @@ static int task_bp_pinned(int cpu, struct perf_event *bp, enum bp_type_idx type)
 	return count;
 }
 
+static const struct cpumask *cpumask_of_bp(struct perf_event *bp)
+{
+	if (bp->cpu >= 0)
+		return cpumask_of(bp->cpu);
+	return cpu_possible_mask;
+}
+
 /*
  * Report the number of pinned/un-pinned breakpoints we have in
  * a given cpu (cpu > -1) or in all of them (cpu = -1).
@@ -135,25 +145,15 @@ static void
 fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
 		    enum bp_type_idx type)
 {
-	int cpu = bp->cpu;
-	struct task_struct *tsk = bp->hw.bp_target;
-
-	if (cpu >= 0) {
-		slots->pinned = per_cpu(nr_cpu_bp_pinned[type], cpu);
-		if (!tsk)
-			slots->pinned += max_task_bp_pinned(cpu, type);
-		else
-			slots->pinned += task_bp_pinned(cpu, bp, type);
-		slots->flexible = per_cpu(nr_bp_flexible[type], cpu);
-
-		return;
-	}
+	const struct cpumask *cpumask = cpumask_of_bp(bp);
+	int cpu;
 
-	for_each_possible_cpu(cpu) {
-		unsigned int nr;
+	for_each_cpu(cpu, cpumask) {
+		struct bp_cpuinfo *info = get_bp_info(cpu, type);
+		int nr;
 
-		nr = per_cpu(nr_cpu_bp_pinned[type], cpu);
-		if (!tsk)
+		nr = info->cpu_pinned;
+		if (!bp->hw.bp_target)
 			nr += max_task_bp_pinned(cpu, type);
 		else
 			nr += task_bp_pinned(cpu, bp, type);
@@ -161,8 +161,7 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
 		if (nr > slots->pinned)
 			slots->pinned = nr;
 
-		nr = per_cpu(nr_bp_flexible[type], cpu);
-
+		nr = info->flexible;
 		if (nr > slots->flexible)
 			slots->flexible = nr;
 	}
@@ -182,29 +181,19 @@ fetch_this_slot(struct bp_busy_slots *slots, int weight)
 /*
  * Add a pinned breakpoint for the given task in our constraint table
  */
-static void toggle_bp_task_slot(struct perf_event *bp, int cpu, bool enable,
+static void toggle_bp_task_slot(struct perf_event *bp, int cpu,
 				enum bp_type_idx type, int weight)
 {
-	unsigned int *tsk_pinned;
-	int old_count = 0;
-	int old_idx = 0;
-	int idx = 0;
-
-	old_count = task_bp_pinned(cpu, bp, type);
-	old_idx = old_count - 1;
-	idx = old_idx + weight;
-
-	/* tsk_pinned[n] is the number of tasks having n breakpoints */
-	tsk_pinned = per_cpu(nr_task_bp_pinned[type], cpu);
-	if (enable) {
-		tsk_pinned[idx]++;
-		if (old_count > 0)
-			tsk_pinned[old_idx]--;
-	} else {
-		tsk_pinned[idx]--;
-		if (old_count > 0)
-			tsk_pinned[old_idx]++;
-	}
+	unsigned int *tsk_pinned = get_bp_info(cpu, type)->tsk_pinned;
+	int old_idx, new_idx;
+
+	old_idx = task_bp_pinned(cpu, bp, type) - 1;
+	new_idx = old_idx + weight;
+
+	if (old_idx >= 0)
+		tsk_pinned[old_idx]--;
+	if (new_idx >= 0)
+		tsk_pinned[new_idx]++;
 }
 
 /*
@@ -214,33 +203,26 @@ static void
 toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type,
 	       int weight)
 {
-	int cpu = bp->cpu;
-	struct task_struct *tsk = bp->hw.bp_target;
+	const struct cpumask *cpumask = cpumask_of_bp(bp);
+	int cpu;
 
-	/* Pinned counter cpu profiling */
-	if (!tsk) {
+	if (!enable)
+		weight = -weight;
 
-		if (enable)
-			per_cpu(nr_cpu_bp_pinned[type], bp->cpu) += weight;
-		else
-			per_cpu(nr_cpu_bp_pinned[type], bp->cpu) -= weight;
+	/* Pinned counter cpu profiling */
+	if (!bp->hw.bp_target) {
+		get_bp_info(bp->cpu, type)->cpu_pinned += weight;
 		return;
 	}
 
 	/* Pinned counter task profiling */
-
-	if (!enable)
-		list_del(&bp->hw.bp_list);
-
-	if (cpu >= 0) {
-		toggle_bp_task_slot(bp, cpu, enable, type, weight);
-	} else {
-		for_each_possible_cpu(cpu)
-			toggle_bp_task_slot(bp, cpu, enable, type, weight);
-	}
+	for_each_cpu(cpu, cpumask)
+		toggle_bp_task_slot(bp, cpu, type, weight);
 
 	if (enable)
 		list_add_tail(&bp->hw.bp_list, &bp_task_head);
+	else
+		list_del(&bp->hw.bp_list);
 }
 
 /*
@@ -261,8 +243,8 @@ __weak void arch_unregister_hw_breakpoint(struct perf_event *bp)
  *
  *   - If attached to a single cpu, check:
  *
- *       (per_cpu(nr_bp_flexible, cpu) || (per_cpu(nr_cpu_bp_pinned, cpu)
- *           + max(per_cpu(nr_task_bp_pinned, cpu)))) < HBP_NUM
+ *       (per_cpu(info->flexible, cpu) || (per_cpu(info->cpu_pinned, cpu)
+ *           + max(per_cpu(info->tsk_pinned, cpu)))) < HBP_NUM
  *
  *       -> If there are already non-pinned counters in this cpu, it means
  *          there is already a free slot for them.
@@ -272,8 +254,8 @@ __weak void arch_unregister_hw_breakpoint(struct perf_event *bp)
  *
  *   - If attached to every cpus, check:
  *
- *       (per_cpu(nr_bp_flexible, *) || (max(per_cpu(nr_cpu_bp_pinned, *))
- *           + max(per_cpu(nr_task_bp_pinned, *)))) < HBP_NUM
+ *       (per_cpu(info->flexible, *) || (max(per_cpu(info->cpu_pinned, *))
+ *           + max(per_cpu(info->tsk_pinned, *)))) < HBP_NUM
  *
  *       -> This is roughly the same, except we check the number of per cpu
  *          bp for every cpu and we keep the max one. Same for the per tasks
@@ -284,16 +266,16 @@ __weak void arch_unregister_hw_breakpoint(struct perf_event *bp)
  *
  *   - If attached to a single cpu, check:
  *
- *       ((per_cpu(nr_bp_flexible, cpu) > 1) + per_cpu(nr_cpu_bp_pinned, cpu)
- *            + max(per_cpu(nr_task_bp_pinned, cpu))) < HBP_NUM
+ *       ((per_cpu(info->flexible, cpu) > 1) + per_cpu(info->cpu_pinned, cpu)
+ *            + max(per_cpu(info->tsk_pinned, cpu))) < HBP_NUM
  *
- *       -> Same checks as before. But now the nr_bp_flexible, if any, must keep
+ *       -> Same checks as before. But now the info->flexible, if any, must keep
  *          one register at least (or they will never be fed).
  *
  *   - If attached to every cpus, check:
  *
- *       ((per_cpu(nr_bp_flexible, *) > 1) + max(per_cpu(nr_cpu_bp_pinned, *))
- *            + max(per_cpu(nr_task_bp_pinned, *))) < HBP_NUM
+ *       ((per_cpu(info->flexible, *) > 1) + max(per_cpu(info->cpu_pinned, *))
+ *            + max(per_cpu(info->tsk_pinned, *))) < HBP_NUM
  */
 static int __reserve_bp_slot(struct perf_event *bp)
 {
@@ -518,8 +500,8 @@ register_wide_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered,
 			    void *context)
 {
-	struct perf_event * __percpu *cpu_events, **pevent, *bp;
-	long err;
+	struct perf_event * __percpu *cpu_events, *bp;
+	long err = 0;
 	int cpu;
 
 	cpu_events = alloc_percpu(typeof(*cpu_events));
@@ -528,31 +510,21 @@ register_wide_hw_breakpoint(struct perf_event_attr *attr,
 
 	get_online_cpus();
 	for_each_online_cpu(cpu) {
-		pevent = per_cpu_ptr(cpu_events, cpu);
 		bp = perf_event_create_kernel_counter(attr, cpu, NULL,
 						      triggered, context);
-
-		*pevent = bp;
-
 		if (IS_ERR(bp)) {
 			err = PTR_ERR(bp);
-			goto fail;
+			break;
 		}
-	}
-	put_online_cpus();
 
-	return cpu_events;
-
-fail:
-	for_each_online_cpu(cpu) {
-		pevent = per_cpu_ptr(cpu_events, cpu);
-		if (IS_ERR(*pevent))
-			break;
-		unregister_hw_breakpoint(*pevent);
+		per_cpu(*cpu_events, cpu) = bp;
 	}
 	put_online_cpus();
 
-	free_percpu(cpu_events);
+	if (likely(!err))
+		return cpu_events;
+
+	unregister_wide_hw_breakpoint(cpu_events);
 	return (void __percpu __force *)ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(register_wide_hw_breakpoint);
@@ -564,12 +536,10 @@ EXPORT_SYMBOL_GPL(register_wide_hw_breakpoint);
 void unregister_wide_hw_breakpoint(struct perf_event * __percpu *cpu_events)
 {
 	int cpu;
-	struct perf_event **pevent;
 
-	for_each_possible_cpu(cpu) {
-		pevent = per_cpu_ptr(cpu_events, cpu);
-		unregister_hw_breakpoint(*pevent);
-	}
+	for_each_possible_cpu(cpu)
+		unregister_hw_breakpoint(per_cpu(*cpu_events, cpu));
+
 	free_percpu(cpu_events);
 }
 EXPORT_SYMBOL_GPL(unregister_wide_hw_breakpoint);
@@ -612,6 +582,11 @@ static int hw_breakpoint_add(struct perf_event *bp, int flags)
 	if (!(flags & PERF_EF_START))
 		bp->hw.state = PERF_HES_STOPPED;
 
+	if (is_sampling_event(bp)) {
+		bp->hw.last_period = bp->hw.sample_period;
+		perf_swevent_set_period(bp);
+	}
+
 	return arch_install_hw_breakpoint(bp);
 }
 
@@ -650,7 +625,6 @@ static struct pmu perf_breakpoint = {
 
 int __init init_hw_breakpoint(void)
 {
-	unsigned int **task_bp_pinned;
 	int cpu, err_cpu;
 	int i;
 
@@ -659,10 +633,11 @@ int __init init_hw_breakpoint(void)
 
 	for_each_possible_cpu(cpu) {
 		for (i = 0; i < TYPE_MAX; i++) {
-			task_bp_pinned = &per_cpu(nr_task_bp_pinned[i], cpu);
-			*task_bp_pinned = kzalloc(sizeof(int) * nr_slots[i],
-						  GFP_KERNEL);
-			if (!*task_bp_pinned)
+			struct bp_cpuinfo *info = get_bp_info(cpu, i);
+
+			info->tsk_pinned = kcalloc(nr_slots[i], sizeof(int),
+							GFP_KERNEL);
+			if (!info->tsk_pinned)
 				goto err_alloc;
 		}
 	}
@@ -676,7 +651,7 @@ int __init init_hw_breakpoint(void)
  err_alloc:
 	for_each_possible_cpu(err_cpu) {
 		for (i = 0; i < TYPE_MAX; i++)
-			kfree(per_cpu(nr_task_bp_pinned[i], err_cpu));
+			kfree(get_bp_info(err_cpu, i)->tsk_pinned);
 		if (err_cpu == cpu)
 			break;
 	}
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 9edcf45..4ce13c3 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -120,7 +120,6 @@ extern int blk_iopoll_enabled;
 /* Constants used for minimum and  maximum */
 #ifdef CONFIG_LOCKUP_DETECTOR
 static int sixty = 60;
-static int neg_one = -1;
 #endif
 
 static int zero;
@@ -814,7 +813,7 @@ static struct ctl_table kern_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dowatchdog,
-		.extra1		= &neg_one,
+		.extra1		= &zero,
 		.extra2		= &sixty,
 	},
 	{
@@ -1044,6 +1043,15 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= perf_proc_update_handler,
 	},
+	{
+		.procname	= "perf_cpu_time_max_percent",
+		.data		= &sysctl_perf_cpu_time_max_percent,
+		.maxlen		= sizeof(sysctl_perf_cpu_time_max_percent),
+		.mode		= 0644,
+		.proc_handler	= perf_cpu_time_max_percent_handler,
+		.extra1		= &zero,
+		.extra2		= &one_hundred,
+	},
 #endif
 #ifdef CONFIG_KMEMCHECK
 	{
diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
index 926cbf3..2c5a197 100644
--- a/tools/lib/lk/Makefile
+++ b/tools/lib/lk/Makefile
@@ -1,5 +1,8 @@
 include ../../scripts/Makefile.include
 
+CC = $(CROSS_COMPILE)gcc
+AR = $(CROSS_COMPILE)ar
+
 # guard against environment variables
 LIB_H=
 LIB_OBJS=
diff --git a/tools/perf/Documentation/perf-archive.txt b/tools/perf/Documentation/perf-archive.txt
index fae174d..5032a14 100644
--- a/tools/perf/Documentation/perf-archive.txt
+++ b/tools/perf/Documentation/perf-archive.txt
@@ -13,7 +13,7 @@ SYNOPSIS
 DESCRIPTION
 -----------
 This command runs runs perf-buildid-list --with-hits, and collects the files
-with the buildids found so that analisys of perf.data contents can be possible
+with the buildids found so that analysis of perf.data contents can be possible
 on another machine.
 
 
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 7d5f4f3..66dab74 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -210,6 +210,10 @@ OPTIONS
 	Demangle symbol names to human readable form. It's enabled by default,
 	disable with --no-demangle.
 
+--percent-limit::
+	Do not show entries which have an overhead under that percent.
+	(Default: 0).
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-annotate[1]
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 9f1a2fe..7fdd190 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -155,6 +155,10 @@ Default is to monitor all CPUS.
 
 	Default: fractal,0.5,callee.
 
+--percent-limit::
+	Do not show entries which have an overhead under that percent.
+	(Default: 0).
+
 INTERACTIVE PROMPTING KEYS
 --------------------------
 
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b0f164b..203cb0e 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -51,189 +51,63 @@ include config/utilities.mak
 # Define NO_BACKTRACE if you do not want stack backtrace debug feature
 #
 # Define NO_LIBNUMA if you do not want numa perf benchmark
+#
+# Define NO_LIBAUDIT if you do not want libaudit support
+#
+# Define NO_LIBBIONIC if you do not want bionic support
 
-$(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
-	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
-
-uname_M := $(shell uname -m 2>/dev/null || echo not)
-
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
-				  -e s/arm.*/arm/ -e s/sa110/arm/ \
-				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
-				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
-				  -e s/sh[234].*/sh/ -e s/aarch64.*/arm64/ )
-NO_PERF_REGS := 1
-
-CC = $(CROSS_COMPILE)gcc
-AR = $(CROSS_COMPILE)ar
-
-# Additional ARCH settings for x86
-ifeq ($(ARCH),i386)
-	override ARCH := x86
-	NO_PERF_REGS := 0
-	LIBUNWIND_LIBS = -lunwind -lunwind-x86
-endif
-ifeq ($(ARCH),x86_64)
-	override ARCH := x86
-	IS_X86_64 := 0
-	ifeq (, $(findstring m32,$(EXTRA_CFLAGS)))
-		IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -x c - | tail -n 1)
-	endif
-	ifeq (${IS_X86_64}, 1)
-		RAW_ARCH := x86_64
-		ARCH_CFLAGS := -DARCH_X86_64
-		ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S ../../arch/x86/lib/memset_64.S
-	endif
-	NO_PERF_REGS := 0
-	LIBUNWIND_LIBS = -lunwind -lunwind-x86_64
-endif
-
-# Treat warnings as errors unless directed not to
-ifneq ($(WERROR),0)
-	CFLAGS_WERROR := -Werror
-endif
-
-ifeq ("$(origin DEBUG)", "command line")
-  PERF_DEBUG = $(DEBUG)
-endif
-ifndef PERF_DEBUG
-  CFLAGS_OPTIMIZE = -O6
+ifeq ($(srctree),)
+srctree := $(patsubst %/,%,$(dir $(shell pwd)))
+srctree := $(patsubst %/,%,$(dir $(srctree)))
+#$(info Determined 'srctree' to be $(srctree))
 endif
 
-ifdef PARSER_DEBUG
-	PARSER_DEBUG_BISON  := -t
-	PARSER_DEBUG_FLEX   := -d
-	PARSER_DEBUG_CFLAGS := -DPARSER_DEBUG
+ifneq ($(objtree),)
+#$(info Determined 'objtree' to be $(objtree))
 endif
 
-ifdef NO_NEWT
-	NO_SLANG=1
+ifneq ($(OUTPUT),)
+#$(info Determined 'OUTPUT' to be $(OUTPUT))
 endif
 
-CFLAGS = -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) $(PARSER_DEBUG_CFLAGS)
-EXTLIBS = -lpthread -lrt -lelf -lm
-ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
-ALL_LDFLAGS = $(LDFLAGS)
-STRIP ?= strip
-
-# Among the variables below, these:
-#   perfexecdir
-#   template_dir
-#   mandir
-#   infodir
-#   htmldir
-#   ETC_PERFCONFIG (but not sysconfdir)
-# can be specified as a relative path some/where/else;
-# this is interpreted as relative to $(prefix) and "perf" at
-# runtime figures out where they are based on the path to the executable.
-# This can help installing the suite in a relocatable way.
-
-# Make the path relative to DESTDIR, not to prefix
-ifndef DESTDIR
-prefix = $(HOME)
-endif
-bindir_relative = bin
-bindir = $(prefix)/$(bindir_relative)
-mandir = share/man
-infodir = share/info
-perfexecdir = libexec/perf-core
-sharedir = $(prefix)/share
-template_dir = share/perf-core/templates
-htmldir = share/doc/perf-doc
-ifeq ($(prefix),/usr)
-sysconfdir = /etc
-ETC_PERFCONFIG = $(sysconfdir)/perfconfig
-else
-sysconfdir = $(prefix)/etc
-ETC_PERFCONFIG = etc/perfconfig
-endif
-lib = lib
+$(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
+	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
 
-export prefix bindir sharedir sysconfdir
+CC = $(CROSS_COMPILE)gcc
+AR = $(CROSS_COMPILE)ar
 
-RM = rm -f
-MKDIR = mkdir
-FIND = find
+RM      = rm -f
+MKDIR   = mkdir
+FIND    = find
 INSTALL = install
-FLEX = flex
-BISON= bison
-
-# sparse is architecture-neutral, which means that we need to tell it
-# explicitly what architecture to check for. Fix this up for yours..
-SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
-
-ifneq ($(MAKECMDGOALS),clean)
-ifneq ($(MAKECMDGOALS),tags)
--include config/feature-tests.mak
-
-ifeq ($(call get-executable,$(FLEX)),)
-	dummy := $(error Error: $(FLEX) is missing on this system, please install it)
-endif
-
-ifeq ($(call get-executable,$(BISON)),)
-	dummy := $(error Error: $(BISON) is missing on this system, please install it)
-endif
+FLEX    = flex
+BISON   = bison
+STRIP   = strip
 
-ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
-	CFLAGS := $(CFLAGS) -fstack-protector-all
-endif
+LK_DIR          = $(srctree)/tools/lib/lk/
+TRACE_EVENT_DIR = $(srctree)/tools/lib/traceevent/
 
-ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wstack-protector,-Wstack-protector),y)
-       CFLAGS := $(CFLAGS) -Wstack-protector
-endif
+# include config/Makefile by default and rule out
+# non-config cases
+config := 1
 
-ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wvolatile-register-var,-Wvolatile-register-var),y)
-       CFLAGS := $(CFLAGS) -Wvolatile-register-var
-endif
+NON_CONFIG_TARGETS := clean TAGS tags cscope help
 
-ifndef PERF_DEBUG
-	ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -D_FORTIFY_SOURCE=2,-D_FORTIFY_SOURCE=2),y)
-		CFLAGS := $(CFLAGS) -D_FORTIFY_SOURCE=2
-	endif
+ifdef MAKECMDGOALS
+ifeq ($(filter-out $(NON_CONFIG_TARGETS),$(MAKECMDGOALS)),)
+  config := 0
 endif
-
-### --- END CONFIGURATION SECTION ---
-
-ifeq ($(srctree),)
-srctree := $(patsubst %/,%,$(dir $(shell pwd)))
-srctree := $(patsubst %/,%,$(dir $(srctree)))
-#$(info Determined 'srctree' to be $(srctree))
 endif
 
-ifneq ($(objtree),)
-#$(info Determined 'objtree' to be $(objtree))
+ifeq ($(config),1)
+include config/Makefile
 endif
 
-ifneq ($(OUTPUT),)
-#$(info Determined 'OUTPUT' to be $(OUTPUT))
-endif
+export prefix bindir sharedir sysconfdir
 
-BASIC_CFLAGS = \
-	-Iutil/include \
-	-Iarch/$(ARCH)/include \
-	$(if $(objtree),-I$(objtree)/arch/$(ARCH)/include/generated/uapi) \
-	-I$(srctree)/arch/$(ARCH)/include/uapi \
-	-I$(srctree)/arch/$(ARCH)/include \
-	$(if $(objtree),-I$(objtree)/include/generated/uapi) \
-	-I$(srctree)/include/uapi \
-	-I$(srctree)/include \
-	-I$(OUTPUT)util \
-	-Iutil \
-	-I. \
-	-I$(TRACE_EVENT_DIR) \
-	-I../lib/ \
-	-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
-
-BASIC_LDFLAGS =
-
-ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
-	BIONIC := 1
-	EXTLIBS := $(filter-out -lrt,$(EXTLIBS))
-	EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
-	BASIC_CFLAGS += -I.
-endif
-endif # MAKECMDGOALS != tags
-endif # MAKECMDGOALS != clean
+# sparse is architecture-neutral, which means that we need to tell it
+# explicitly what architecture to check for. Fix this up for yours..
+SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 
 # Guard against environment variables
 BUILTIN_OBJS =
@@ -247,20 +121,17 @@ SCRIPT_SH += perf-archive.sh
 grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
-LK_DIR = ../lib/lk/
-TRACE_EVENT_DIR = ../lib/traceevent/
-
 LK_PATH=$(LK_DIR)
 
 ifneq ($(OUTPUT),)
-	TE_PATH=$(OUTPUT)
+  TE_PATH=$(OUTPUT)
 ifneq ($(subdir),)
-	LK_PATH=$(OUTPUT)$(LK_DIR)
+  LK_PATH=$(OUTPUT)$(LK_DIR)
 else
-	LK_PATH=$(OUTPUT)
+  LK_PATH=$(OUTPUT)
 endif
 else
-	TE_PATH=$(TRACE_EVENT_DIR)
+  TE_PATH=$(TRACE_EVENT_DIR)
 endif
 
 LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
@@ -278,10 +149,10 @@ export PYTHON_EXTBUILD_LIB PYTHON_EXTBUILD_TMP
 python-clean := rm -rf $(PYTHON_EXTBUILD) $(OUTPUT)python/perf.so
 
 PYTHON_EXT_SRCS := $(shell grep -v ^\# util/python-ext-sources)
-PYTHON_EXT_DEPS := util/python-ext-sources util/setup.py $(LIBTRACEEVENT)
+PYTHON_EXT_DEPS := util/python-ext-sources util/setup.py $(LIBTRACEEVENT) $(LIBLK)
 
 $(OUTPUT)python/perf.so: $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
-	$(QUIET_GEN)CFLAGS='$(BASIC_CFLAGS)' $(PYTHON_WORD) util/setup.py \
+	$(QUIET_GEN)CFLAGS='$(CFLAGS)' $(PYTHON_WORD) util/setup.py \
 	  --quiet build_ext; \
 	mkdir -p $(OUTPUT)python && \
 	cp $(PYTHON_EXTBUILD_LIB)perf.so $(OUTPUT)python/
@@ -296,8 +167,6 @@ SCRIPTS = $(patsubst %.sh,%,$(SCRIPT_SH))
 #
 PROGRAMS += $(OUTPUT)perf
 
-LANG_BINDINGS =
-
 # what 'all' will build and 'install' will install, in perfexecdir
 ALL_PROGRAMS = $(PROGRAMS) $(SCRIPTS)
 
@@ -306,10 +175,10 @@ OTHER_PROGRAMS = $(OUTPUT)perf
 
 # Set paths to tools early so that they can be used for version tests.
 ifndef SHELL_PATH
-	SHELL_PATH = /bin/sh
+  SHELL_PATH = /bin/sh
 endif
 ifndef PERL_PATH
-	PERL_PATH = /usr/bin/perl
+  PERL_PATH = /usr/bin/perl
 endif
 
 export PERL_PATH
@@ -557,79 +426,14 @@ BUILTIN_OBJS += $(OUTPUT)builtin-mem.o
 
 PERFLIBS = $(LIB_FILE) $(LIBLK) $(LIBTRACEEVENT)
 
-#
-# Platform specific tweaks
-#
-ifneq ($(MAKECMDGOALS),clean)
-ifneq ($(MAKECMDGOALS),tags)
-
 # We choose to avoid "if .. else if .. else .. endif endif"
 # because maintaining the nesting to match is a pain.  If
 # we had "elif" things would have been much nicer...
 
-ifdef NO_LIBELF
-	NO_DWARF := 1
-	NO_DEMANGLE := 1
-	NO_LIBUNWIND := 1
-else
-FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
-ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF),libelf),y)
-	FLAGS_GLIBC=$(ALL_CFLAGS) $(ALL_LDFLAGS)
-	ifeq ($(call try-cc,$(SOURCE_GLIBC),$(FLAGS_GLIBC),glibc),y)
-		LIBC_SUPPORT := 1
-	endif
-	ifeq ($(BIONIC),1)
-		LIBC_SUPPORT := 1
-	endif
-	ifeq ($(LIBC_SUPPORT),1)
-		msg := $(warning No libelf found, disables 'probe' tool, please install elfutils-libelf-devel/libelf-dev);
-
-		NO_LIBELF := 1
-		NO_DWARF := 1
-		NO_DEMANGLE := 1
-	else
-		msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
-	endif
-else
-	# for linking with debug library, run like:
-	# make DEBUG=1 LIBDW_DIR=/opt/libdw/
-	ifdef LIBDW_DIR
-		LIBDW_CFLAGS  := -I$(LIBDW_DIR)/include
-		LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
-	endif
-
-	FLAGS_DWARF=$(ALL_CFLAGS) $(LIBDW_CFLAGS) -ldw -lelf $(LIBDW_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
-	ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF),libdw),y)
-		msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
-		NO_DWARF := 1
-	endif # Dwarf support
-endif # SOURCE_LIBELF
-endif # NO_LIBELF
-
-# There's only x86 (both 32 and 64) support for CFI unwind so far
-ifneq ($(ARCH),x86)
-	NO_LIBUNWIND := 1
-endif
-
-ifndef NO_LIBUNWIND
-# for linking with debug library, run like:
-# make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
-ifdef LIBUNWIND_DIR
-	LIBUNWIND_CFLAGS  := -I$(LIBUNWIND_DIR)/include
-	LIBUNWIND_LDFLAGS := -L$(LIBUNWIND_DIR)/lib
-endif
-
-FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(ALL_CFLAGS) $(LIBUNWIND_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
-ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND),libunwind),y)
-	msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99);
-	NO_LIBUNWIND := 1
-endif # Libunwind support
-endif # NO_LIBUNWIND
-
 -include arch/$(ARCH)/Makefile
 
 ifneq ($(OUTPUT),)
-	BASIC_CFLAGS += -I$(OUTPUT)
+  CFLAGS += -I$(OUTPUT)
 endif
 
 ifdef NO_LIBELF
@@ -647,281 +451,74 @@ BUILTIN_OBJS := $(filter-out $(OUTPUT)builtin-probe.o,$(BUILTIN_OBJS))
 LIB_OBJS += $(OUTPUT)util/symbol-minimal.o
 
 else # NO_LIBELF
-BASIC_CFLAGS += -DLIBELF_SUPPORT
-
-FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
-ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
-	BASIC_CFLAGS += -DLIBELF_MMAP
-endif
-
 ifndef NO_DWARF
-ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
-	msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
-else
-	BASIC_CFLAGS := -DDWARF_SUPPORT $(LIBDW_CFLAGS) $(BASIC_CFLAGS)
-	BASIC_LDFLAGS := $(LIBDW_LDFLAGS) $(BASIC_LDFLAGS)
-	EXTLIBS += -lelf -ldw
-	LIB_OBJS += $(OUTPUT)util/probe-finder.o
-	LIB_OBJS += $(OUTPUT)util/dwarf-aux.o
-endif # PERF_HAVE_DWARF_REGS
+  LIB_OBJS += $(OUTPUT)util/probe-finder.o
+  LIB_OBJS += $(OUTPUT)util/dwarf-aux.o
 endif # NO_DWARF
 endif # NO_LIBELF
 
 ifndef NO_LIBUNWIND
-	BASIC_CFLAGS += -DLIBUNWIND_SUPPORT
-	EXTLIBS += $(LIBUNWIND_LIBS)
-	BASIC_CFLAGS := $(LIBUNWIND_CFLAGS) $(BASIC_CFLAGS)
-	BASIC_LDFLAGS := $(LIBUNWIND_LDFLAGS) $(BASIC_LDFLAGS)
-	LIB_OBJS += $(OUTPUT)util/unwind.o
+  LIB_OBJS += $(OUTPUT)util/unwind.o
 endif
 
 ifndef NO_LIBAUDIT
-	FLAGS_LIBAUDIT = $(ALL_CFLAGS) $(ALL_LDFLAGS) -laudit
-	ifneq ($(call try-cc,$(SOURCE_LIBAUDIT),$(FLAGS_LIBAUDIT),libaudit),y)
-		msg := $(warning No libaudit.h found, disables 'trace' tool, please install audit-libs-devel or libaudit-dev);
-	else
-		BASIC_CFLAGS += -DLIBAUDIT_SUPPORT
-		BUILTIN_OBJS += $(OUTPUT)builtin-trace.o
-		EXTLIBS += -laudit
-	endif
+  BUILTIN_OBJS += $(OUTPUT)builtin-trace.o
 endif
 
 ifndef NO_SLANG
-	FLAGS_SLANG=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -I/usr/include/slang -lslang
-	ifneq ($(call try-cc,$(SOURCE_SLANG),$(FLAGS_SLANG),libslang),y)
-		msg := $(warning slang not found, disables TUI support. Please install slang-devel or libslang-dev);
-	else
-		# Fedora has /usr/include/slang/slang.h, but ubuntu /usr/include/slang.h
-		BASIC_CFLAGS += -I/usr/include/slang
-		BASIC_CFLAGS += -DSLANG_SUPPORT
-		EXTLIBS += -lslang
-		LIB_OBJS += $(OUTPUT)ui/browser.o
-		LIB_OBJS += $(OUTPUT)ui/browsers/annotate.o
-		LIB_OBJS += $(OUTPUT)ui/browsers/hists.o
-		LIB_OBJS += $(OUTPUT)ui/browsers/map.o
-		LIB_OBJS += $(OUTPUT)ui/browsers/scripts.o
-		LIB_OBJS += $(OUTPUT)ui/tui/setup.o
-		LIB_OBJS += $(OUTPUT)ui/tui/util.o
-		LIB_OBJS += $(OUTPUT)ui/tui/helpline.o
-		LIB_OBJS += $(OUTPUT)ui/tui/progress.o
-		LIB_H += ui/browser.h
-		LIB_H += ui/browsers/map.h
-		LIB_H += ui/keysyms.h
-		LIB_H += ui/libslang.h
-	endif
+  LIB_OBJS += $(OUTPUT)ui/browser.o
+  LIB_OBJS += $(OUTPUT)ui/browsers/annotate.o
+  LIB_OBJS += $(OUTPUT)ui/browsers/hists.o
+  LIB_OBJS += $(OUTPUT)ui/browsers/map.o
+  LIB_OBJS += $(OUTPUT)ui/browsers/scripts.o
+  LIB_OBJS += $(OUTPUT)ui/tui/setup.o
+  LIB_OBJS += $(OUTPUT)ui/tui/util.o
+  LIB_OBJS += $(OUTPUT)ui/tui/helpline.o
+  LIB_OBJS += $(OUTPUT)ui/tui/progress.o
+  LIB_H += ui/browser.h
+  LIB_H += ui/browsers/map.h
+  LIB_H += ui/keysyms.h
+  LIB_H += ui/libslang.h
 endif
 
 ifndef NO_GTK2
-	FLAGS_GTK2=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
-	ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2),gtk2),y)
-		msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
-	else
-		ifeq ($(call try-cc,$(SOURCE_GTK2_INFOBAR),$(FLAGS_GTK2),-DHAVE_GTK_INFO_BAR),y)
-			BASIC_CFLAGS += -DHAVE_GTK_INFO_BAR
-		endif
-		BASIC_CFLAGS += -DGTK2_SUPPORT
-		BASIC_CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
-		EXTLIBS += $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
-		LIB_OBJS += $(OUTPUT)ui/gtk/browser.o
-		LIB_OBJS += $(OUTPUT)ui/gtk/hists.o
-		LIB_OBJS += $(OUTPUT)ui/gtk/setup.o
-		LIB_OBJS += $(OUTPUT)ui/gtk/util.o
-		LIB_OBJS += $(OUTPUT)ui/gtk/helpline.o
-		LIB_OBJS += $(OUTPUT)ui/gtk/progress.o
-		LIB_OBJS += $(OUTPUT)ui/gtk/annotate.o
-	endif
+  LIB_OBJS += $(OUTPUT)ui/gtk/browser.o
+  LIB_OBJS += $(OUTPUT)ui/gtk/hists.o
+  LIB_OBJS += $(OUTPUT)ui/gtk/setup.o
+  LIB_OBJS += $(OUTPUT)ui/gtk/util.o
+  LIB_OBJS += $(OUTPUT)ui/gtk/helpline.o
+  LIB_OBJS += $(OUTPUT)ui/gtk/progress.o
+  LIB_OBJS += $(OUTPUT)ui/gtk/annotate.o
 endif
 
-ifdef NO_LIBPERL
-	BASIC_CFLAGS += -DNO_LIBPERL
-else
-       PERL_EMBED_LDOPTS = $(shell perl -MExtUtils::Embed -e ldopts 2>/dev/null)
-       PERL_EMBED_LDFLAGS = $(call strip-libs,$(PERL_EMBED_LDOPTS))
-       PERL_EMBED_LIBADD = $(call grep-libs,$(PERL_EMBED_LDOPTS))
-	PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
-	FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
-
-	ifneq ($(call try-cc,$(SOURCE_PERL_EMBED),$(FLAGS_PERL_EMBED),perl),y)
-		BASIC_CFLAGS += -DNO_LIBPERL
-	else
-               ALL_LDFLAGS += $(PERL_EMBED_LDFLAGS)
-               EXTLIBS += $(PERL_EMBED_LIBADD)
-		LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-perl.o
-		LIB_OBJS += $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o
-	endif
+ifndef NO_LIBPERL
+  LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-perl.o
+  LIB_OBJS += $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o
 endif
 
-disable-python = $(eval $(disable-python_code))
-define disable-python_code
-  BASIC_CFLAGS += -DNO_LIBPYTHON
-  $(if $(1),$(warning No $(1) was found))
-  $(warning Python support will not be built)
-endef
-
-override PYTHON := \
-  $(call get-executable-or-default,PYTHON,python)
-
-ifndef PYTHON
-  $(call disable-python,python interpreter)
-else
-
-  PYTHON_WORD := $(call shell-wordify,$(PYTHON))
-
-  ifdef NO_LIBPYTHON
-    $(call disable-python)
-  else
-
-    override PYTHON_CONFIG := \
-      $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)
-
-    ifndef PYTHON_CONFIG
-      $(call disable-python,python-config tool)
-    else
-
-      PYTHON_CONFIG_SQ := $(call shell-sq,$(PYTHON_CONFIG))
-
-      PYTHON_EMBED_LDOPTS := $(shell $(PYTHON_CONFIG_SQ) --ldflags 2>/dev/null)
-      PYTHON_EMBED_LDFLAGS := $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
-      PYTHON_EMBED_LIBADD := $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
-      PYTHON_EMBED_CCOPTS := $(shell $(PYTHON_CONFIG_SQ) --cflags 2>/dev/null)
-      FLAGS_PYTHON_EMBED := $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
-
-      ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED),python),y)
-        $(call disable-python,Python.h (for Python 2.x))
-      else
-
-        ifneq ($(call try-cc,$(SOURCE_PYTHON_VERSION),$(FLAGS_PYTHON_EMBED),python version),y)
-          $(warning Python 3 is not yet supported; please set)
-          $(warning PYTHON and/or PYTHON_CONFIG appropriately.)
-          $(warning If you also have Python 2 installed, then)
-          $(warning try something like:)
-          $(warning $(and ,))
-          $(warning $(and ,)  make PYTHON=python2)
-          $(warning $(and ,))
-          $(warning Otherwise, disable Python support entirely:)
-          $(warning $(and ,))
-          $(warning $(and ,)  make NO_LIBPYTHON=1)
-          $(warning $(and ,))
-          $(error   $(and ,))
-        else
-          ALL_LDFLAGS += $(PYTHON_EMBED_LDFLAGS)
-          EXTLIBS += $(PYTHON_EMBED_LIBADD)
-          LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-python.o
-          LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
-          LANG_BINDINGS += $(OUTPUT)python/perf.so
-        endif
-
-      endif
-    endif
-  endif
-endif
-
-ifdef NO_DEMANGLE
-	BASIC_CFLAGS += -DNO_DEMANGLE
-else
-        ifdef HAVE_CPLUS_DEMANGLE
-		EXTLIBS += -liberty
-		BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
-        else
-		FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
-		has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD),libbfd)
-		ifeq ($(has_bfd),y)
-			EXTLIBS += -lbfd
-		else
-			FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty
-			has_bfd_iberty := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY),liberty)
-			ifeq ($(has_bfd_iberty),y)
-				EXTLIBS += -lbfd -liberty
-			else
-				FLAGS_BFD_IBERTY_Z=$(FLAGS_BFD_IBERTY) -lz
-				has_bfd_iberty_z := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY_Z),libz)
-				ifeq ($(has_bfd_iberty_z),y)
-					EXTLIBS += -lbfd -liberty -lz
-				else
-					FLAGS_CPLUS_DEMANGLE=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -liberty
-					has_cplus_demangle := $(call try-cc,$(SOURCE_CPLUS_DEMANGLE),$(FLAGS_CPLUS_DEMANGLE),demangle)
-					ifeq ($(has_cplus_demangle),y)
-						EXTLIBS += -liberty
-						BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
-					else
-						msg := $(warning No bfd.h/libbfd found, install binutils-dev[el]/zlib-static to gain symbol demangling)
-						BASIC_CFLAGS += -DNO_DEMANGLE
-					endif
-				endif
-			endif
-		endif
-	endif
+ifndef NO_LIBPYTHON
+  LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-python.o
+  LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
 endif
 
 ifeq ($(NO_PERF_REGS),0)
-	ifeq ($(ARCH),x86)
-		LIB_H += arch/x86/include/perf_regs.h
-	endif
-	BASIC_CFLAGS += -DHAVE_PERF_REGS
-endif
-
-ifndef NO_STRLCPY
-	ifeq ($(call try-cc,$(SOURCE_STRLCPY),,-DHAVE_STRLCPY),y)
-		BASIC_CFLAGS += -DHAVE_STRLCPY
-	endif
-endif
-
-ifndef NO_ON_EXIT
-	ifeq ($(call try-cc,$(SOURCE_ON_EXIT),,-DHAVE_ON_EXIT),y)
-		BASIC_CFLAGS += -DHAVE_ON_EXIT
-	endif
-endif
-
-ifndef NO_BACKTRACE
-       ifeq ($(call try-cc,$(SOURCE_BACKTRACE),,-DBACKTRACE_SUPPORT),y)
-               BASIC_CFLAGS += -DBACKTRACE_SUPPORT
-       endif
+  ifeq ($(ARCH),x86)
+    LIB_H += arch/x86/include/perf_regs.h
+  endif
 endif
 
 ifndef NO_LIBNUMA
-	FLAGS_LIBNUMA = $(ALL_CFLAGS) $(ALL_LDFLAGS) -lnuma
-	ifneq ($(call try-cc,$(SOURCE_LIBNUMA),$(FLAGS_LIBNUMA),libnuma),y)
-		msg := $(warning No numa.h found, disables 'perf bench numa mem' benchmark, please install numa-libs-devel or libnuma-dev);
-	else
-		BASIC_CFLAGS += -DLIBNUMA_SUPPORT
-		BUILTIN_OBJS += $(OUTPUT)bench/numa.o
-		EXTLIBS += -lnuma
-	endif
+  BUILTIN_OBJS += $(OUTPUT)bench/numa.o
 endif
 
 ifdef ASCIIDOC8
-	export ASCIIDOC8
+  export ASCIIDOC8
 endif
 
-endif # MAKECMDGOALS != tags
-endif # MAKECMDGOALS != clean
-
-# Shell quote (do not use $(call) to accommodate ancient setups);
-
-ETC_PERFCONFIG_SQ = $(subst ','\'',$(ETC_PERFCONFIG))
-
-DESTDIR_SQ = $(subst ','\'',$(DESTDIR))
-bindir_SQ = $(subst ','\'',$(bindir))
-bindir_relative_SQ = $(subst ','\'',$(bindir_relative))
-mandir_SQ = $(subst ','\'',$(mandir))
-infodir_SQ = $(subst ','\'',$(infodir))
-perfexecdir_SQ = $(subst ','\'',$(perfexecdir))
-template_dir_SQ = $(subst ','\'',$(template_dir))
-htmldir_SQ = $(subst ','\'',$(htmldir))
-prefix_SQ = $(subst ','\'',$(prefix))
-sysconfdir_SQ = $(subst ','\'',$(sysconfdir))
-
-SHELL_PATH_SQ = $(subst ','\'',$(SHELL_PATH))
-
 LIBS = -Wl,--whole-archive $(PERFLIBS) -Wl,--no-whole-archive -Wl,--start-group $(EXTLIBS) -Wl,--end-group
 
-ALL_CFLAGS += $(BASIC_CFLAGS)
-ALL_CFLAGS += $(ARCH_CFLAGS)
-ALL_LDFLAGS += $(BASIC_LDFLAGS)
-
 export INSTALL SHELL_PATH
 
-
 ### Build rules
 
 SHELL = $(SHELL_PATH)
@@ -939,20 +536,20 @@ strip: $(PROGRAMS) $(OUTPUT)perf
 $(OUTPUT)perf.o: perf.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -include $(OUTPUT)PERF-VERSION-FILE \
 		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
-		$(ALL_CFLAGS) -c $(filter %.c,$^) -o $@
+		$(CFLAGS) -c $(filter %.c,$^) -o $@
 
 $(OUTPUT)perf: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS)
-	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) $(ALL_LDFLAGS) $(OUTPUT)perf.o \
+	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) $(OUTPUT)perf.o \
                $(BUILTIN_OBJS) $(LIBS) -o $@
 
 $(OUTPUT)builtin-help.o: builtin-help.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
 		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
 		'-DPERF_MAN_PATH="$(mandir_SQ)"' \
 		'-DPERF_INFO_PATH="$(infodir_SQ)"' $<
 
 $(OUTPUT)builtin-timechart.o: builtin-timechart.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
 		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
 		'-DPERF_MAN_PATH="$(mandir_SQ)"' \
 		'-DPERF_INFO_PATH="$(infodir_SQ)"' $<
@@ -977,77 +574,77 @@ $(OUTPUT)perf.o perf.spec \
 # over the general rule for .o
 
 $(OUTPUT)util/%-flex.o: $(OUTPUT)util/%-flex.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c -Iutil/ $(ALL_CFLAGS) -w $<
+	$(QUIET_CC)$(CC) -o $@ -c -Iutil/ $(CFLAGS) -w $<
 
 $(OUTPUT)util/%-bison.o: $(OUTPUT)util/%-bison.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c -Iutil/ $(ALL_CFLAGS) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -w $<
+	$(QUIET_CC)$(CC) -o $@ -c -Iutil/ $(CFLAGS) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -w $<
 
 $(OUTPUT)%.o: %.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $<
 $(OUTPUT)%.i: %.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -E $(ALL_CFLAGS) $<
+	$(QUIET_CC)$(CC) -o $@ -E $(CFLAGS) $<
 $(OUTPUT)%.s: %.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -S $(ALL_CFLAGS) $<
+	$(QUIET_CC)$(CC) -o $@ -S $(CFLAGS) $<
 $(OUTPUT)%.o: %.S
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $<
 $(OUTPUT)%.s: %.S
-	$(QUIET_CC)$(CC) -o $@ -E $(ALL_CFLAGS) $<
+	$(QUIET_CC)$(CC) -o $@ -E $(CFLAGS) $<
 
 $(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
 		'-DPERF_EXEC_PATH="$(perfexecdir_SQ)"' \
 		'-DPREFIX="$(prefix_SQ)"' \
 		$<
 
 $(OUTPUT)tests/attr.o: tests/attr.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
 		'-DBINDIR="$(bindir_SQ)"' -DPYTHON='"$(PYTHON_WORD)"' \
 		$<
 
 $(OUTPUT)tests/python-use.o: tests/python-use.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
 		-DPYTHONPATH='"$(OUTPUT)python"' \
 		-DPYTHON='"$(PYTHON_WORD)"' \
 		$<
 
 $(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
 $(OUTPUT)ui/browser.o: ui/browser.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
 $(OUTPUT)ui/browsers/annotate.o: ui/browsers/annotate.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
 $(OUTPUT)ui/browsers/hists.o: ui/browsers/hists.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
 $(OUTPUT)ui/browsers/map.o: ui/browsers/map.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
 $(OUTPUT)ui/browsers/scripts.o: ui/browsers/scripts.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
 $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Wno-unused-parameter -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-unused-parameter -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
 $(OUTPUT)util/parse-events.o: util/parse-events.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Wno-redundant-decls $<
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-redundant-decls $<
 
 $(OUTPUT)util/scripting-engines/trace-event-perl.o: util/scripting-engines/trace-event-perl.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
 
 $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o: scripts/perl/Perf-Trace-Util/Context.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs $<
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs $<
 
 $(OUTPUT)util/scripting-engines/trace-event-python.o: util/scripting-engines/trace-event-python.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
 
 $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o: scripts/python/Perf-Trace-Util/Context.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs $<
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs $<
 
 $(OUTPUT)perf-%: %.o $(PERFLIBS)
-	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) -o $@ $(ALL_LDFLAGS) $(filter %.o,$^) $(LIBS)
+	$(QUIET_LINK)$(CC) $(CFLAGS) -o $@ $(LDFLAGS) $(filter %.o,$^) $(LIBS)
 
 $(LIB_OBJS) $(BUILTIN_OBJS): $(LIB_H)
 $(patsubst perf-%,%.o,$(PROGRAMS)): $(LIB_H) $(wildcard */*.h)
@@ -1134,7 +731,7 @@ cscope:
 	$(FIND) . -name '*.[hcS]' -print | xargs cscope -b
 
 ### Detect prefix changes
-TRACK_CFLAGS = $(subst ','\'',$(ALL_CFLAGS)):\
+TRACK_CFLAGS = $(subst ','\'',$(CFLAGS)):\
              $(bindir_SQ):$(perfexecdir_SQ):$(template_dir_SQ):$(prefix_SQ)
 
 $(OUTPUT)PERF-CFLAGS: .FORCE-PERF-CFLAGS
@@ -1155,7 +752,7 @@ check: $(OUTPUT)common-cmds.h
 	then \
 		for i in *.c */*.c; \
 		do \
-			sparse $(ALL_CFLAGS) $(SPARSE_FLAGS) $$i || exit; \
+			sparse $(CFLAGS) $(SPARSE_FLAGS) $$i || exit; \
 		done; \
 	else \
 		exit 1; \
@@ -1163,13 +760,6 @@ check: $(OUTPUT)common-cmds.h
 
 ### Installation rules
 
-ifneq ($(filter /%,$(firstword $(perfexecdir))),)
-perfexec_instdir = $(perfexecdir)
-else
-perfexec_instdir = $(prefix)/$(perfexecdir)
-endif
-perfexec_instdir_SQ = $(subst ','\'',$(perfexec_instdir))
-
 install-bin: all
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
 	$(INSTALL) $(OUTPUT)perf '$(DESTDIR_SQ)$(bindir_SQ)'
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 2d0462d..da8f8eb 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -323,13 +323,20 @@ static void hists__baseline_only(struct hists *hists)
 
 static void hists__precompute(struct hists *hists)
 {
-	struct rb_node *next = rb_first(&hists->entries);
+	struct rb_root *root;
+	struct rb_node *next;
+
+	if (sort__need_collapse)
+		root = &hists->entries_collapsed;
+	else
+		root = hists->entries_in;
 
+	next = rb_first(root);
 	while (next != NULL) {
-		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node);
+		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node_in);
 		struct hist_entry *pair = hist_entry__next_pair(he);
 
-		next = rb_next(&he->rb_node);
+		next = rb_next(&he->rb_node_in);
 		if (!pair)
 			continue;
 
@@ -457,7 +464,7 @@ static void hists__process(struct hists *old, struct hists *new)
 		hists__output_resort(new);
 	}
 
-	hists__fprintf(new, true, 0, 0, stdout);
+	hists__fprintf(new, true, 0, 0, 0, stdout);
 }
 
 static int __cmd_diff(void)
@@ -611,9 +618,7 @@ int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	setup_pager();
 
-	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso", NULL);
-	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", NULL);
-	sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "symbol", NULL);
+	sort__setup_elide(NULL);
 
 	return __cmd_diff();
 }
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 533501e..24b78ae 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -328,6 +328,7 @@ static int kvm_events_hash_fn(u64 key)
 static bool kvm_event_expand(struct kvm_event *event, int vcpu_id)
 {
 	int old_max_vcpu = event->max_vcpu;
+	void *prev;
 
 	if (vcpu_id < event->max_vcpu)
 		return true;
@@ -335,9 +336,11 @@ static bool kvm_event_expand(struct kvm_event *event, int vcpu_id)
 	while (event->max_vcpu <= vcpu_id)
 		event->max_vcpu += DEFAULT_VCPU_NUM;
 
+	prev = event->vcpu;
 	event->vcpu = realloc(event->vcpu,
 			      event->max_vcpu * sizeof(*event->vcpu));
 	if (!event->vcpu) {
+		free(prev);
 		pr_err("Not enough memory\n");
 		return false;
 	}
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index cdf58ec..fff985c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -198,7 +198,6 @@ static void perf_record__sig_exit(int exit_status __maybe_unused, void *arg)
 		return;
 
 	signal(signr, SIG_DFL);
-	kill(getpid(), signr);
 }
 
 static bool perf_evlist__equal(struct perf_evlist *evlist,
@@ -404,6 +403,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
 	signal(SIGUSR1, sig_handler);
+	signal(SIGTERM, sig_handler);
 
 	if (!output_name) {
 		if (!fstat(STDOUT_FILENO, &st) && S_ISFIFO(st.st_mode))
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index bd0ca81..ca98d34 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -52,6 +52,7 @@ struct perf_report {
 	symbol_filter_t		annotate_init;
 	const char		*cpu_list;
 	const char		*symbol_filter_str;
+	float			min_percent;
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 };
 
@@ -61,6 +62,11 @@ static int perf_report_config(const char *var, const char *value, void *cb)
 		symbol_conf.event_group = perf_config_bool(var, value);
 		return 0;
 	}
+	if (!strcmp(var, "report.percent-limit")) {
+		struct perf_report *rep = cb;
+		rep->min_percent = strtof(value, NULL);
+		return 0;
+	}
 
 	return perf_default_config(var, value, cb);
 }
@@ -187,6 +193,9 @@ static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 	for (i = 0; i < sample->branch_stack->nr; i++) {
 		if (rep->hide_unresolved && !(bi[i].from.sym && bi[i].to.sym))
 			continue;
+
+		err = -ENOMEM;
+
 		/*
 		 * The report shows the percentage of total branches captured
 		 * and not events sampled. Thus we use a pseudo period of 1.
@@ -195,7 +204,6 @@ static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 				&bi[i], 1, 1);
 		if (he) {
 			struct annotation *notes;
-			err = -ENOMEM;
 			bx = he->branch_info;
 			if (bx->from.sym && use_browser == 1 && sort__has_sym) {
 				notes = symbol__annotation(bx->from.sym);
@@ -226,11 +234,12 @@ static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 			}
 			evsel->hists.stats.total_period += 1;
 			hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-			err = 0;
 		} else
-			return -ENOMEM;
+			goto out;
 	}
+	err = 0;
 out:
+	free(bi);
 	return err;
 }
 
@@ -294,6 +303,7 @@ static int process_sample_event(struct perf_tool *tool,
 {
 	struct perf_report *rep = container_of(tool, struct perf_report, tool);
 	struct addr_location al;
+	int ret;
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample,
 					  rep->annotate_init) < 0) {
@@ -308,28 +318,25 @@ static int process_sample_event(struct perf_tool *tool,
 	if (rep->cpu_list && !test_bit(sample->cpu, rep->cpu_bitmap))
 		return 0;
 
-	if (sort__branch_mode == 1) {
-		if (perf_report__add_branch_hist_entry(tool, &al, sample,
-						       evsel, machine)) {
+	if (sort__mode == SORT_MODE__BRANCH) {
+		ret = perf_report__add_branch_hist_entry(tool, &al, sample,
+							 evsel, machine);
+		if (ret < 0)
 			pr_debug("problem adding lbr entry, skipping event\n");
-			return -1;
-		}
 	} else if (rep->mem_mode == 1) {
-		if (perf_report__add_mem_hist_entry(tool, &al, sample,
-						    evsel, machine, event)) {
+		ret = perf_report__add_mem_hist_entry(tool, &al, sample,
+						      evsel, machine, event);
+		if (ret < 0)
 			pr_debug("problem adding mem entry, skipping event\n");
-			return -1;
-		}
 	} else {
 		if (al.map != NULL)
 			al.map->dso->hit = 1;
 
-		if (perf_evsel__add_hist_entry(evsel, &al, sample, machine)) {
+		ret = perf_evsel__add_hist_entry(evsel, &al, sample, machine);
+		if (ret < 0)
 			pr_debug("problem incrementing symbol period, skipping event\n");
-			return -1;
-		}
 	}
-	return 0;
+	return ret;
 }
 
 static int process_read_event(struct perf_tool *tool,
@@ -384,7 +391,7 @@ static int perf_report__setup_sample_type(struct perf_report *rep)
 			}
 	}
 
-	if (sort__branch_mode == 1) {
+	if (sort__mode == SORT_MODE__BRANCH) {
 		if (!self->fd_pipe &&
 		    !(sample_type & PERF_SAMPLE_BRANCH_STACK)) {
 			ui__error("Selected -b but no branch data. "
@@ -455,7 +462,7 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
 			continue;
 
 		hists__fprintf_nr_sample_events(rep, hists, evname, stdout);
-		hists__fprintf(hists, true, 0, 0, stdout);
+		hists__fprintf(hists, true, 0, 0, rep->min_percent, stdout);
 		fprintf(stdout, "\n\n");
 	}
 
@@ -574,8 +581,8 @@ static int __cmd_report(struct perf_report *rep)
 	if (use_browser > 0) {
 		if (use_browser == 1) {
 			ret = perf_evlist__tui_browse_hists(session->evlist,
-							help,
-							NULL,
+							help, NULL,
+							rep->min_percent,
 							&session->header.env);
 			/*
 			 * Usually "ret" is the last pressed key, and we only
@@ -586,7 +593,7 @@ static int __cmd_report(struct perf_report *rep)
 
 		} else if (use_browser == 2) {
 			perf_evlist__gtk_browse_hists(session->evlist, help,
-						      NULL);
+						      NULL, rep->min_percent);
 		}
 	} else
 		perf_evlist__tty_browse_hists(session->evlist, rep, help);
@@ -691,7 +698,19 @@ static int
 parse_branch_mode(const struct option *opt __maybe_unused,
 		  const char *str __maybe_unused, int unset)
 {
-	sort__branch_mode = !unset;
+	int *branch_mode = opt->value;
+
+	*branch_mode = !unset;
+	return 0;
+}
+
+static int
+parse_percent_limit(const struct option *opt, const char *str,
+		    int unset __maybe_unused)
+{
+	struct perf_report *rep = opt->value;
+
+	rep->min_percent = strtof(str, NULL);
 	return 0;
 }
 
@@ -700,6 +719,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	struct perf_session *session;
 	struct stat st;
 	bool has_br_stack = false;
+	int branch_mode = -1;
 	int ret = -1;
 	char callchain_default_opt[] = "fractal,0.5,callee";
 	const char * const report_usage[] = {
@@ -796,17 +816,19 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Show a column with the sum of periods"),
 	OPT_BOOLEAN(0, "group", &symbol_conf.event_group,
 		    "Show event group information together"),
-	OPT_CALLBACK_NOOPT('b', "branch-stack", &sort__branch_mode, "",
+	OPT_CALLBACK_NOOPT('b', "branch-stack", &branch_mode, "",
 		    "use branch records for histogram filling", parse_branch_mode),
 	OPT_STRING(0, "objdump", &objdump_path, "path",
 		   "objdump binary to use for disassembly and annotations"),
 	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
 		    "Disable symbol demangling"),
 	OPT_BOOLEAN(0, "mem-mode", &report.mem_mode, "mem access profile"),
+	OPT_CALLBACK(0, "percent-limit", &report, "percent",
+		     "Don't show entries under that percent", parse_percent_limit),
 	OPT_END()
 	};
 
-	perf_config(perf_report_config, NULL);
+	perf_config(perf_report_config, &report);
 
 	argc = parse_options(argc, argv, options, report_usage, 0);
 
@@ -846,11 +868,11 @@ repeat:
 	has_br_stack = perf_header__has_feat(&session->header,
 					     HEADER_BRANCH_STACK);
 
-	if (sort__branch_mode == -1 && has_br_stack)
-		sort__branch_mode = 1;
+	if (branch_mode == -1 && has_br_stack)
+		sort__mode = SORT_MODE__BRANCH;
 
-	/* sort__branch_mode could be 0 if --no-branch-stack */
-	if (sort__branch_mode == 1) {
+	/* sort__mode could be NORMAL if --no-branch-stack */
+	if (sort__mode == SORT_MODE__BRANCH) {
 		/*
 		 * if no sort_order is provided, then specify
 		 * branch-mode specific order
@@ -861,10 +883,12 @@ repeat:
 
 	}
 	if (report.mem_mode) {
-		if (sort__branch_mode == 1) {
+		if (sort__mode == SORT_MODE__BRANCH) {
 			fprintf(stderr, "branch and mem mode incompatible\n");
 			goto error;
 		}
+		sort__mode = SORT_MODE__MEMORY;
+
 		/*
 		 * if no sort_order is provided, then specify
 		 * branch-mode specific order
@@ -929,25 +953,7 @@ repeat:
 		report.symbol_filter_str = argv[0];
 	}
 
-	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", stdout);
-
-	if (sort__branch_mode == 1) {
-		sort_entry__setup_elide(&sort_dso_from, symbol_conf.dso_from_list, "dso_from", stdout);
-		sort_entry__setup_elide(&sort_dso_to, symbol_conf.dso_to_list, "dso_to", stdout);
-		sort_entry__setup_elide(&sort_sym_from, symbol_conf.sym_from_list, "sym_from", stdout);
-		sort_entry__setup_elide(&sort_sym_to, symbol_conf.sym_to_list, "sym_to", stdout);
-	} else {
-		if (report.mem_mode) {
-			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "symbol_daddr", stdout);
-			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso_daddr", stdout);
-			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "mem", stdout);
-			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "local_weight", stdout);
-			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "tlb", stdout);
-			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "snoop", stdout);
-		}
-		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso", stdout);
-		sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "symbol", stdout);
-	}
+	sort__setup_elide(stdout);
 
 	ret = __cmd_report(&report);
 	if (ret == K_SWITCH_INPUT_DATA) {
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 67bdb9f..f036af9 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -70,10 +70,11 @@
 
 static volatile int done;
 
+#define HEADER_LINE_NR  5
+
 static void perf_top__update_print_entries(struct perf_top *top)
 {
-	if (top->print_entries > 9)
-		top->print_entries -= 9;
+	top->print_entries = top->winsize.ws_row - HEADER_LINE_NR;
 }
 
 static void perf_top__sig_winch(int sig __maybe_unused,
@@ -82,13 +83,6 @@ static void perf_top__sig_winch(int sig __maybe_unused,
 	struct perf_top *top = arg;
 
 	get_term_dimensions(&top->winsize);
-	if (!top->print_entries
-	    || (top->print_entries+4) > top->winsize.ws_row) {
-		top->print_entries = top->winsize.ws_row;
-	} else {
-		top->print_entries += 4;
-		top->winsize.ws_row = top->print_entries;
-	}
 	perf_top__update_print_entries(top);
 }
 
@@ -251,8 +245,11 @@ static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 {
 	struct hist_entry *he;
 
+	pthread_mutex_lock(&evsel->hists.lock);
 	he = __hists__add_entry(&evsel->hists, al, NULL, sample->period,
 				sample->weight);
+	pthread_mutex_unlock(&evsel->hists.lock);
+
 	if (he == NULL)
 		return NULL;
 
@@ -290,16 +287,17 @@ static void perf_top__print_sym_table(struct perf_top *top)
 		return;
 	}
 
-	hists__collapse_resort_threaded(&top->sym_evsel->hists);
-	hists__output_resort_threaded(&top->sym_evsel->hists);
-	hists__decay_entries_threaded(&top->sym_evsel->hists,
-				      top->hide_user_symbols,
-				      top->hide_kernel_symbols);
+	hists__collapse_resort(&top->sym_evsel->hists);
+	hists__output_resort(&top->sym_evsel->hists);
+	hists__decay_entries(&top->sym_evsel->hists,
+			     top->hide_user_symbols,
+			     top->hide_kernel_symbols);
 	hists__output_recalc_col_len(&top->sym_evsel->hists,
-				     top->winsize.ws_row - 3);
+				     top->print_entries - printed);
 	putchar('\n');
 	hists__fprintf(&top->sym_evsel->hists, false,
-		       top->winsize.ws_row - 4 - printed, win_width, stdout);
+		       top->print_entries - printed, win_width,
+		       top->min_percent, stdout);
 }
 
 static void prompt_integer(int *target, const char *msg)
@@ -477,7 +475,6 @@ static bool perf_top__handle_keypress(struct perf_top *top, int c)
 				perf_top__sig_winch(SIGWINCH, NULL, top);
 				sigaction(SIGWINCH, &act, NULL);
 			} else {
-				perf_top__sig_winch(SIGWINCH, NULL, top);
 				signal(SIGWINCH, SIG_DFL);
 			}
 			break;
@@ -556,11 +553,11 @@ static void perf_top__sort_new_samples(void *arg)
 	if (t->evlist->selected != NULL)
 		t->sym_evsel = t->evlist->selected;
 
-	hists__collapse_resort_threaded(&t->sym_evsel->hists);
-	hists__output_resort_threaded(&t->sym_evsel->hists);
-	hists__decay_entries_threaded(&t->sym_evsel->hists,
-				      t->hide_user_symbols,
-				      t->hide_kernel_symbols);
+	hists__collapse_resort(&t->sym_evsel->hists);
+	hists__output_resort(&t->sym_evsel->hists);
+	hists__decay_entries(&t->sym_evsel->hists,
+			     t->hide_user_symbols,
+			     t->hide_kernel_symbols);
 }
 
 static void *display_thread_tui(void *arg)
@@ -584,7 +581,7 @@ static void *display_thread_tui(void *arg)
 	list_for_each_entry(pos, &top->evlist->entries, node)
 		pos->hists.uid_filter_str = top->record_opts.target.uid_str;
 
-	perf_evlist__tui_browse_hists(top->evlist, help, &hbt,
+	perf_evlist__tui_browse_hists(top->evlist, help, &hbt, top->min_percent,
 				      &top->session->header.env);
 
 	done = 1;
@@ -794,7 +791,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
 				return;
 		}
 
-		if (top->sort_has_symbols)
+		if (sort__has_sym)
 			perf_top__record_precise_ip(top, he, evsel->idx, ip);
 	}
 
@@ -912,9 +909,9 @@ out_err:
 	return -1;
 }
 
-static int perf_top__setup_sample_type(struct perf_top *top)
+static int perf_top__setup_sample_type(struct perf_top *top __maybe_unused)
 {
-	if (!top->sort_has_symbols) {
+	if (!sort__has_sym) {
 		if (symbol_conf.use_callchain) {
 			ui__error("Selected -g but \"sym\" not present in --sort/-s.");
 			return -EINVAL;
@@ -1025,6 +1022,16 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 	return record_parse_callchain_opt(opt, arg, unset);
 }
 
+static int
+parse_percent_limit(const struct option *opt, const char *arg,
+		    int unset __maybe_unused)
+{
+	struct perf_top *top = opt->value;
+
+	top->min_percent = strtof(arg, NULL);
+	return 0;
+}
+
 int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	int status;
@@ -1110,6 +1117,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_STRING('M', "disassembler-style", &disassembler_style, "disassembler style",
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
 	OPT_STRING('u', "uid", &target->uid_str, "user", "user to profile"),
+	OPT_CALLBACK(0, "percent-limit", &top, "percent",
+		     "Don't show entries under that percent", parse_percent_limit),
 	OPT_END()
 	};
 	const char * const top_usage[] = {
@@ -1133,6 +1142,9 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (setup_sorting() < 0)
 		usage_with_options(top_usage, options);
 
+	/* display thread wants entries to be collapsed in a different tree */
+	sort__need_collapse = 1;
+
 	if (top.use_stdio)
 		use_browser = 0;
 	else if (top.use_tui)
@@ -1200,15 +1212,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (symbol__init() < 0)
 		return -1;
 
-	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso", stdout);
-	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", stdout);
-	sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "symbol", stdout);
-
-	/*
-	 * Avoid annotation data structures overhead when symbols aren't on the
-	 * sort list.
-	 */
-	top.sort_has_symbols = sort_sym.list.next != NULL;
+	sort__setup_elide(stdout);
 
 	get_term_dimensions(&top.winsize);
 	if (top.print_entries == 0) {
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
new file mode 100644
index 0000000..f139dcd
--- /dev/null
+++ b/tools/perf/config/Makefile
@@ -0,0 +1,477 @@
+uname_M := $(shell uname -m 2>/dev/null || echo not)
+
+ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
+                                  -e s/arm.*/arm/ -e s/sa110/arm/ \
+                                  -e s/s390x/s390/ -e s/parisc64/parisc/ \
+                                  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
+                                  -e s/sh[234].*/sh/ -e s/aarch64.*/arm64/ )
+NO_PERF_REGS := 1
+CFLAGS := $(EXTRA_CFLAGS) $(EXTRA_WARNINGS)
+
+# Additional ARCH settings for x86
+ifeq ($(ARCH),i386)
+  override ARCH := x86
+  NO_PERF_REGS := 0
+  LIBUNWIND_LIBS = -lunwind -lunwind-x86
+endif
+
+ifeq ($(ARCH),x86_64)
+  override ARCH := x86
+  IS_X86_64 := 0
+  ifeq (, $(findstring m32,$(CFLAGS)))
+    IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -x c - | tail -n 1)
+  endif
+  ifeq (${IS_X86_64}, 1)
+    RAW_ARCH := x86_64
+    CFLAGS += -DARCH_X86_64
+    ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S ../../arch/x86/lib/memset_64.S
+  endif
+  NO_PERF_REGS := 0
+  LIBUNWIND_LIBS = -lunwind -lunwind-x86_64
+endif
+
+ifeq ($(NO_PERF_REGS),0)
+  CFLAGS += -DHAVE_PERF_REGS
+endif
+
+ifeq ($(src-perf),)
+src-perf := $(srctree)/tools/perf
+endif
+
+ifeq ($(obj-perf),)
+obj-perf := $(objtree)
+endif
+
+ifneq ($(obj-perf),)
+obj-perf := $(abspath $(obj-perf))/
+endif
+
+# include ARCH specific config
+-include $(src-perf)/arch/$(ARCH)/Makefile
+
+include $(src-perf)/config/feature-tests.mak
+include $(src-perf)/config/utilities.mak
+
+ifeq ($(call get-executable,$(FLEX)),)
+  dummy := $(error Error: $(FLEX) is missing on this system, please install it)
+endif
+
+ifeq ($(call get-executable,$(BISON)),)
+  dummy := $(error Error: $(BISON) is missing on this system, please install it)
+endif
+
+# Treat warnings as errors unless directed not to
+ifneq ($(WERROR),0)
+  CFLAGS += -Werror
+endif
+
+ifeq ("$(origin DEBUG)", "command line")
+  PERF_DEBUG = $(DEBUG)
+endif
+ifndef PERF_DEBUG
+  CFLAGS += -O6
+endif
+
+ifdef PARSER_DEBUG
+  PARSER_DEBUG_BISON := -t
+  PARSER_DEBUG_FLEX  := -d
+  CFLAGS             += -DPARSER_DEBUG
+endif
+
+CFLAGS += -fno-omit-frame-pointer
+CFLAGS += -ggdb3
+CFLAGS += -funwind-tables
+CFLAGS += -Wall
+CFLAGS += -Wextra
+CFLAGS += -std=gnu99
+
+EXTLIBS = -lpthread -lrt -lelf -lm
+
+ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
+  CFLAGS += -fstack-protector-all
+endif
+
+ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wstack-protector,-Wstack-protector),y)
+  CFLAGS += -Wstack-protector
+endif
+
+ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wvolatile-register-var,-Wvolatile-register-var),y)
+  CFLAGS += -Wvolatile-register-var
+endif
+
+ifndef PERF_DEBUG
+  ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -D_FORTIFY_SOURCE=2,-D_FORTIFY_SOURCE=2),y)
+    CFLAGS += -D_FORTIFY_SOURCE=2
+  endif
+endif
+
+CFLAGS += -I$(src-perf)/util/include
+CFLAGS += -I$(src-perf)/arch/$(ARCH)/include
+CFLAGS += -I$(srctree)/arch/$(ARCH)/include/uapi
+CFLAGS += -I$(srctree)/arch/$(ARCH)/include
+CFLAGS += -I$(srctree)/include/uapi
+CFLAGS += -I$(srctree)/include
+
+# $(obj-perf)      for generated common-cmds.h
+# $(obj-perf)/util for generated bison/flex headers
+ifneq ($(OUTPUT),)
+CFLAGS += -I$(obj-perf)/util
+CFLAGS += -I$(obj-perf)
+endif
+
+CFLAGS += -I$(src-perf)/util
+CFLAGS += -I$(src-perf)
+CFLAGS += -I$(TRACE_EVENT_DIR)
+CFLAGS += -I$(srctree)/tools/lib/
+
+CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
+
+ifndef NO_BIONIC
+ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
+  BIONIC := 1
+  EXTLIBS := $(filter-out -lrt,$(EXTLIBS))
+  EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
+endif
+endif # NO_BIONIC
+
+ifdef NO_LIBELF
+  NO_DWARF := 1
+  NO_DEMANGLE := 1
+  NO_LIBUNWIND := 1
+else
+FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
+ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF),libelf),y)
+  FLAGS_GLIBC=$(CFLAGS) $(LDFLAGS)
+  ifeq ($(call try-cc,$(SOURCE_GLIBC),$(FLAGS_GLIBC),glibc),y)
+    LIBC_SUPPORT := 1
+  endif
+  ifeq ($(BIONIC),1)
+    LIBC_SUPPORT := 1
+  endif
+  ifeq ($(LIBC_SUPPORT),1)
+    msg := $(warning No libelf found, disables 'probe' tool, please install elfutils-libelf-devel/libelf-dev);
+
+    NO_LIBELF := 1
+    NO_DWARF := 1
+    NO_DEMANGLE := 1
+  else
+    msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
+  endif
+else
+  # for linking with debug library, run like:
+  # make DEBUG=1 LIBDW_DIR=/opt/libdw/
+  ifdef LIBDW_DIR
+    LIBDW_CFLAGS  := -I$(LIBDW_DIR)/include
+    LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
+  endif
+
+  FLAGS_DWARF=$(CFLAGS) $(LIBDW_CFLAGS) -ldw -lelf $(LIBDW_LDFLAGS) $(LDFLAGS) $(EXTLIBS)
+  ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF),libdw),y)
+    msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
+    NO_DWARF := 1
+  endif # Dwarf support
+endif # SOURCE_LIBELF
+endif # NO_LIBELF
+
+ifndef NO_LIBELF
+CFLAGS += -DLIBELF_SUPPORT
+FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
+ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
+  CFLAGS += -DLIBELF_MMAP
+endif
+
+# include ARCH specific config
+-include $(src-perf)/arch/$(ARCH)/Makefile
+
+ifndef NO_DWARF
+ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
+  msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
+  NO_DWARF := 1
+else
+  CFLAGS += -DDWARF_SUPPORT $(LIBDW_CFLAGS)
+  LDFLAGS += $(LIBDW_LDFLAGS)
+  EXTLIBS += -lelf -ldw
+endif # PERF_HAVE_DWARF_REGS
+endif # NO_DWARF
+
+endif # NO_LIBELF
+
+ifndef NO_LIBELF
+CFLAGS += -DLIBELF_SUPPORT
+FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
+ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
+  CFLAGS += -DLIBELF_MMAP
+endif # try-cc
+endif # NO_LIBELF
+
+# There's only x86 (both 32 and 64) support for CFI unwind so far
+ifneq ($(ARCH),x86)
+  NO_LIBUNWIND := 1
+endif
+
+ifndef NO_LIBUNWIND
+# for linking with debug library, run like:
+# make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
+ifdef LIBUNWIND_DIR
+  LIBUNWIND_CFLAGS  := -I$(LIBUNWIND_DIR)/include
+  LIBUNWIND_LDFLAGS := -L$(LIBUNWIND_DIR)/lib
+endif
+
+FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(CFLAGS) $(LIBUNWIND_LDFLAGS) $(LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
+ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND),libunwind),y)
+  msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99);
+  NO_LIBUNWIND := 1
+endif # Libunwind support
+endif # NO_LIBUNWIND
+
+ifndef NO_LIBUNWIND
+  CFLAGS += -DLIBUNWIND_SUPPORT
+  EXTLIBS += $(LIBUNWIND_LIBS)
+  CFLAGS += $(LIBUNWIND_CFLAGS)
+  LDFLAGS += $(LIBUNWIND_LDFLAGS)
+endif # NO_LIBUNWIND
+
+ifndef NO_LIBAUDIT
+  FLAGS_LIBAUDIT = $(CFLAGS) $(LDFLAGS) -laudit
+  ifneq ($(call try-cc,$(SOURCE_LIBAUDIT),$(FLAGS_LIBAUDIT),libaudit),y)
+    msg := $(warning No libaudit.h found, disables 'trace' tool, please install audit-libs-devel or libaudit-dev);
+    NO_LIBAUDIT := 1
+  else
+    CFLAGS += -DLIBAUDIT_SUPPORT
+    EXTLIBS += -laudit
+  endif
+endif
+
+ifdef NO_NEWT
+  NO_SLANG=1
+endif
+
+ifndef NO_SLANG
+  FLAGS_SLANG=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) -I/usr/include/slang -lslang
+  ifneq ($(call try-cc,$(SOURCE_SLANG),$(FLAGS_SLANG),libslang),y)
+    msg := $(warning slang not found, disables TUI support. Please install slang-devel or libslang-dev);
+    NO_SLANG := 1
+  else
+    # Fedora has /usr/include/slang/slang.h, but ubuntu /usr/include/slang.h
+    CFLAGS += -I/usr/include/slang
+    CFLAGS += -DSLANG_SUPPORT
+    EXTLIBS += -lslang
+  endif
+endif
+
+ifndef NO_GTK2
+  FLAGS_GTK2=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
+  ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2),gtk2),y)
+    msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
+    NO_GTK2 := 1
+  else
+    ifeq ($(call try-cc,$(SOURCE_GTK2_INFOBAR),$(FLAGS_GTK2),-DHAVE_GTK_INFO_BAR),y)
+      CFLAGS += -DHAVE_GTK_INFO_BAR
+    endif
+    CFLAGS += -DGTK2_SUPPORT
+    CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
+    EXTLIBS += $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
+  endif
+endif
+
+grep-libs  = $(filter -l%,$(1))
+strip-libs = $(filter-out -l%,$(1))
+
+ifdef NO_LIBPERL
+  CFLAGS += -DNO_LIBPERL
+else
+  PERL_EMBED_LDOPTS = $(shell perl -MExtUtils::Embed -e ldopts 2>/dev/null)
+  PERL_EMBED_LDFLAGS = $(call strip-libs,$(PERL_EMBED_LDOPTS))
+  PERL_EMBED_LIBADD = $(call grep-libs,$(PERL_EMBED_LDOPTS))
+  PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
+  FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
+
+  ifneq ($(call try-cc,$(SOURCE_PERL_EMBED),$(FLAGS_PERL_EMBED),perl),y)
+    CFLAGS += -DNO_LIBPERL
+    NO_LIBPERL := 1
+  else
+    LDFLAGS += $(PERL_EMBED_LDFLAGS)
+    EXTLIBS += $(PERL_EMBED_LIBADD)
+  endif
+endif
+
+disable-python = $(eval $(disable-python_code))
+define disable-python_code
+  CFLAGS += -DNO_LIBPYTHON
+  $(if $(1),$(warning No $(1) was found))
+  $(warning Python support will not be built)
+  NO_LIBPYTHON := 1
+endef
+
+override PYTHON := \
+  $(call get-executable-or-default,PYTHON,python)
+
+ifndef PYTHON
+  $(call disable-python,python interpreter)
+else
+
+  PYTHON_WORD := $(call shell-wordify,$(PYTHON))
+
+  ifdef NO_LIBPYTHON
+    $(call disable-python)
+  else
+
+    override PYTHON_CONFIG := \
+      $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)
+
+    ifndef PYTHON_CONFIG
+      $(call disable-python,python-config tool)
+    else
+
+      PYTHON_CONFIG_SQ := $(call shell-sq,$(PYTHON_CONFIG))
+
+      PYTHON_EMBED_LDOPTS := $(shell $(PYTHON_CONFIG_SQ) --ldflags 2>/dev/null)
+      PYTHON_EMBED_LDFLAGS := $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
+      PYTHON_EMBED_LIBADD := $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
+      PYTHON_EMBED_CCOPTS := $(shell $(PYTHON_CONFIG_SQ) --cflags 2>/dev/null)
+      FLAGS_PYTHON_EMBED := $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
+
+      ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED),python),y)
+        $(call disable-python,Python.h (for Python 2.x))
+      else
+
+        ifneq ($(call try-cc,$(SOURCE_PYTHON_VERSION),$(FLAGS_PYTHON_EMBED),python version),y)
+          $(warning Python 3 is not yet supported; please set)
+          $(warning PYTHON and/or PYTHON_CONFIG appropriately.)
+          $(warning If you also have Python 2 installed, then)
+          $(warning try something like:)
+          $(warning $(and ,))
+          $(warning $(and ,)  make PYTHON=python2)
+          $(warning $(and ,))
+          $(warning Otherwise, disable Python support entirely:)
+          $(warning $(and ,))
+          $(warning $(and ,)  make NO_LIBPYTHON=1)
+          $(warning $(and ,))
+          $(error   $(and ,))
+        else
+          LDFLAGS += $(PYTHON_EMBED_LDFLAGS)
+          EXTLIBS += $(PYTHON_EMBED_LIBADD)
+          LANG_BINDINGS += $(obj-perf)python/perf.so
+        endif
+      endif
+    endif
+  endif
+endif
+
+ifdef NO_DEMANGLE
+  CFLAGS += -DNO_DEMANGLE
+else
+  ifdef HAVE_CPLUS_DEMANGLE
+    EXTLIBS += -liberty
+    CFLAGS += -DHAVE_CPLUS_DEMANGLE
+  else
+    FLAGS_BFD=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
+    has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD),libbfd)
+    ifeq ($(has_bfd),y)
+      EXTLIBS += -lbfd
+    else
+      FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty
+      has_bfd_iberty := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY),liberty)
+      ifeq ($(has_bfd_iberty),y)
+        EXTLIBS += -lbfd -liberty
+      else
+        FLAGS_BFD_IBERTY_Z=$(FLAGS_BFD_IBERTY) -lz
+        has_bfd_iberty_z := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY_Z),libz)
+        ifeq ($(has_bfd_iberty_z),y)
+          EXTLIBS += -lbfd -liberty -lz
+        else
+          FLAGS_CPLUS_DEMANGLE=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) -liberty
+          has_cplus_demangle := $(call try-cc,$(SOURCE_CPLUS_DEMANGLE),$(FLAGS_CPLUS_DEMANGLE),demangle)
+          ifeq ($(has_cplus_demangle),y)
+            EXTLIBS += -liberty
+            CFLAGS += -DHAVE_CPLUS_DEMANGLE
+          else
+            msg := $(warning No bfd.h/libbfd found, install binutils-dev[el]/zlib-static to gain symbol demangling)
+            CFLAGS += -DNO_DEMANGLE
+          endif
+        endif
+      endif
+    endif
+  endif
+endif
+
+ifndef NO_STRLCPY
+  ifeq ($(call try-cc,$(SOURCE_STRLCPY),,-DHAVE_STRLCPY),y)
+    CFLAGS += -DHAVE_STRLCPY
+  endif
+endif
+
+ifndef NO_ON_EXIT
+  ifeq ($(call try-cc,$(SOURCE_ON_EXIT),,-DHAVE_ON_EXIT),y)
+    CFLAGS += -DHAVE_ON_EXIT
+  endif
+endif
+
+ifndef NO_BACKTRACE
+  ifeq ($(call try-cc,$(SOURCE_BACKTRACE),,-DBACKTRACE_SUPPORT),y)
+    CFLAGS += -DBACKTRACE_SUPPORT
+  endif
+endif
+
+ifndef NO_LIBNUMA
+  FLAGS_LIBNUMA = $(CFLAGS) $(LDFLAGS) -lnuma
+  ifneq ($(call try-cc,$(SOURCE_LIBNUMA),$(FLAGS_LIBNUMA),libnuma),y)
+    msg := $(warning No numa.h found, disables 'perf bench numa mem' benchmark, please install numa-libs-devel or libnuma-dev);
+    NO_LIBNUMA := 1
+  else
+    CFLAGS += -DLIBNUMA_SUPPORT
+    EXTLIBS += -lnuma
+  endif
+endif
+
+# Among the variables below, these:
+#   perfexecdir
+#   template_dir
+#   mandir
+#   infodir
+#   htmldir
+#   ETC_PERFCONFIG (but not sysconfdir)
+# can be specified as a relative path some/where/else;
+# this is interpreted as relative to $(prefix) and "perf" at
+# runtime figures out where they are based on the path to the executable.
+# This can help installing the suite in a relocatable way.
+
+# Make the path relative to DESTDIR, not to prefix
+ifndef DESTDIR
+prefix = $(HOME)
+endif
+bindir_relative = bin
+bindir = $(prefix)/$(bindir_relative)
+mandir = share/man
+infodir = share/info
+perfexecdir = libexec/perf-core
+sharedir = $(prefix)/share
+template_dir = share/perf-core/templates
+htmldir = share/doc/perf-doc
+ifeq ($(prefix),/usr)
+sysconfdir = /etc
+ETC_PERFCONFIG = $(sysconfdir)/perfconfig
+else
+sysconfdir = $(prefix)/etc
+ETC_PERFCONFIG = etc/perfconfig
+endif
+lib = lib
+
+# Shell quote (do not use $(call) to accommodate ancient setups);
+ETC_PERFCONFIG_SQ = $(subst ','\'',$(ETC_PERFCONFIG))
+DESTDIR_SQ = $(subst ','\'',$(DESTDIR))
+bindir_SQ = $(subst ','\'',$(bindir))
+mandir_SQ = $(subst ','\'',$(mandir))
+infodir_SQ = $(subst ','\'',$(infodir))
+perfexecdir_SQ = $(subst ','\'',$(perfexecdir))
+template_dir_SQ = $(subst ','\'',$(template_dir))
+htmldir_SQ = $(subst ','\'',$(htmldir))
+prefix_SQ = $(subst ','\'',$(prefix))
+sysconfdir_SQ = $(subst ','\'',$(sysconfdir))
+
+ifneq ($(filter /%,$(firstword $(perfexecdir))),)
+perfexec_instdir = $(perfexecdir)
+else
+perfexec_instdir = $(prefix)/$(perfexecdir)
+endif
+perfexec_instdir_SQ = $(subst ','\'',$(perfexec_instdir))
diff --git a/tools/perf/tests/attr/base-record b/tools/perf/tests/attr/base-record
index b4fc835..e9bd639 100644
--- a/tools/perf/tests/attr/base-record
+++ b/tools/perf/tests/attr/base-record
@@ -27,8 +27,8 @@ watermark=0
 precise_ip=0
 mmap_data=0
 sample_id_all=1
-exclude_host=0
-exclude_guest=1
+exclude_host=0|1
+exclude_guest=0|1
 exclude_callchain_kernel=0
 exclude_callchain_user=0
 wakeup_events=0
diff --git a/tools/perf/tests/attr/base-stat b/tools/perf/tests/attr/base-stat
index 748ee94..91cd48b 100644
--- a/tools/perf/tests/attr/base-stat
+++ b/tools/perf/tests/attr/base-stat
@@ -27,8 +27,8 @@ watermark=0
 precise_ip=0
 mmap_data=0
 sample_id_all=0
-exclude_host=0
-exclude_guest=1
+exclude_host=0|1
+exclude_guest=0|1
 exclude_callchain_kernel=0
 exclude_callchain_user=0
 wakeup_events=0
diff --git a/tools/perf/tests/attr/test-record-data b/tools/perf/tests/attr/test-record-data
index 6627c3e..716e143 100644
--- a/tools/perf/tests/attr/test-record-data
+++ b/tools/perf/tests/attr/test-record-data
@@ -4,5 +4,8 @@ args    = -d kill >/dev/null 2>&1
 
 [event:base-record]
 sample_period=4000
-sample_type=271
+
+# sample_type = PERF_SAMPLE_IP | PERF_SAMPLE_TID | PERF_SAMPLE_TIME |
+# PERF_SAMPLE_ADDR | PERF_SAMPLE_PERIOD | PERF_SAMPLE_DATA_SRC
+sample_type=33039
 mmap_data=1
diff --git a/tools/perf/tests/bp_signal.c b/tools/perf/tests/bp_signal.c
index 68daa28..aba0954 100644
--- a/tools/perf/tests/bp_signal.c
+++ b/tools/perf/tests/bp_signal.c
@@ -4,6 +4,12 @@
  * (git://github.com/deater/perf_event_tests)
  */
 
+/*
+ * Powerpc needs __SANE_USERSPACE_TYPES__ before <linux/types.h> to select
+ * 'int-ll64.h' and avoid compile warnings when printing __u64 with %llu.
+ */
+#define __SANE_USERSPACE_TYPES__
+
 #include <stdlib.h>
 #include <stdio.h>
 #include <unistd.h>
diff --git a/tools/perf/tests/bp_signal_overflow.c b/tools/perf/tests/bp_signal_overflow.c
index fe7ed28..44ac821 100644
--- a/tools/perf/tests/bp_signal_overflow.c
+++ b/tools/perf/tests/bp_signal_overflow.c
@@ -3,6 +3,12 @@
  * perf_event_tests (git://github.com/deater/perf_event_tests)
  */
 
+/*
+ * Powerpc needs __SANE_USERSPACE_TYPES__ before <linux/types.h> to select
+ * 'int-ll64.h' and avoid compile warnings when printing __u64 with %llu.
+ */
+#define __SANE_USERSPACE_TYPES__
+
 #include <stdlib.h>
 #include <stdio.h>
 #include <unistd.h>
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 0918ada..35b45f1466 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -70,7 +70,7 @@ static struct test {
 		.func = test__attr,
 	},
 	{
-		.desc = "Test matching and linking mutliple hists",
+		.desc = "Test matching and linking multiple hists",
 		.func = test__hists_link,
 	},
 	{
diff --git a/tools/perf/tests/make b/tools/perf/tests/make
new file mode 100644
index 0000000..c441a28
--- /dev/null
+++ b/tools/perf/tests/make
@@ -0,0 +1,138 @@
+PERF := .
+MK   := Makefile
+
+# standard single make variable specified
+make_clean_all      := clean all
+make_python_perf_so := python/perf.so
+make_debug          := DEBUG=1
+make_no_libperl     := NO_LIBPERL=1
+make_no_libpython   := NO_LIBPYTHON=1
+make_no_scripts     := NO_LIBPYTHON=1 NO_LIBPERL=1
+make_no_newt        := NO_NEWT=1
+make_no_slang       := NO_SLANG=1
+make_no_gtk2        := NO_GTK2=1
+make_no_ui          := NO_NEWT=1 NO_SLANG=1 NO_GTK2=1
+make_no_demangle    := NO_DEMANGLE=1
+make_no_libelf      := NO_LIBELF=1
+make_no_libunwind   := NO_LIBUNWIND=1
+make_no_backtrace   := NO_BACKTRACE=1
+make_no_libnuma     := NO_LIBNUMA=1
+make_no_libaudit    := NO_LIBAUDIT=1
+make_no_libbionic   := NO_LIBBIONIC=1
+make_tags           := tags
+make_cscope         := cscope
+make_help           := help
+make_doc            := doc
+make_perf_o         := perf.o
+make_util_map_o     := util/map.o
+
+# all the NO_* variable combined
+make_minimal        := NO_LIBPERL=1 NO_LIBPYTHON=1 NO_NEWT=1 NO_GTK2=1
+make_minimal        += NO_DEMANGLE=1 NO_LIBELF=1 NO_LIBUNWIND=1 NO_BACKTRACE=1
+make_minimal        += NO_LIBNUMA=1 NO_LIBAUDIT=1 NO_LIBBIONIC=1
+
+# $(run) contains all available tests
+run := make_pure
+run += make_clean_all
+run += make_python_perf_so
+run += make_debug
+run += make_no_libperl
+run += make_no_libpython
+run += make_no_scripts
+run += make_no_newt
+run += make_no_slang
+run += make_no_gtk2
+run += make_no_ui
+run += make_no_demangle
+run += make_no_libelf
+run += make_no_libunwind
+run += make_no_backtrace
+run += make_no_libnuma
+run += make_no_libaudit
+run += make_no_libbionic
+run += make_tags
+run += make_cscope
+run += make_help
+run += make_doc
+run += make_perf_o
+run += make_util_map_o
+run += make_minimal
+
+# $(run_O) contains same portion of $(run) tests with '_O' attached
+# to distinguish O=... tests
+run_O := $(addsuffix _O,$(run))
+
+# disable some tests for O=...
+run_O := $(filter-out make_python_perf_so_O,$(run_O))
+
+# define test for each compile as 'test_NAME' variable
+# with the test itself as a value
+test_make_tags   = test -f tags
+test_make_cscope = test -f cscope.out
+
+test_make_tags_O   := $(test_make_tags)
+test_make_cscope_O := $(test_make_cscope)
+
+test_ok          := true
+test_make_help   := $(test_ok)
+test_make_doc    := $(test_ok)
+test_make_help_O := $(test_ok)
+test_make_doc_O  := $(test_ok)
+
+test_make_python_perf_so := test -f $(PERF)/python/perf.so
+
+test_make_perf_o     := test -f $(PERF)/perf.o
+test_make_util_map_o := test -f $(PERF)/util/map.o
+
+# Kbuild tests only
+#test_make_python_perf_so_O := test -f $$TMP/tools/perf/python/perf.so
+#test_make_perf_o_O         := test -f $$TMP/tools/perf/perf.o
+#test_make_util_map_o_O     := test -f $$TMP/tools/perf/util/map.o
+
+test_make_perf_o_O     := true
+test_make_util_map_o_O := true
+
+test_default = test -x $(PERF)/perf
+test = $(if $(test_$1),$(test_$1),$(test_default))
+
+test_default_O = test -x $$TMP/perf
+test_O = $(if $(test_$1),$(test_$1),$(test_default_O))
+
+all:
+
+ifdef DEBUG
+d := $(info run   $(run))
+d := $(info run_O $(run_O))
+endif
+
+MAKEFLAGS := --no-print-directory
+
+clean := @(cd $(PERF); make -s -f $(MK) clean >/dev/null)
+
+$(run):
+	$(call clean)
+	@cmd="cd $(PERF) && make -f $(MK) $($@)"; \
+	echo "- $@: $$cmd" && echo $$cmd > $@ && \
+	( eval $$cmd ) >> $@ 2>&1; \
+	echo "  test: $(call test,$@)"; \
+	$(call test,$@) && \
+	rm -f $@
+
+$(run_O):
+	$(call clean)
+	@TMP=$$(mktemp -d); \
+	cmd="cd $(PERF) && make -f $(MK) $($(patsubst %_O,%,$@)) O=$$TMP"; \
+	echo "- $@: $$cmd" && echo $$cmd > $@ && \
+	( eval $$cmd ) >> $@ 2>&1 && \
+	echo "  test: $(call test_O,$@)"; \
+	$(call test_O,$@) && \
+	rm -f $@ && \
+	rm -rf $$TMP
+
+all: $(run) $(run_O)
+	@echo OK
+
+out: $(run_O)
+	@echo OK
+
+.PHONY: all $(run) $(run_O) clean
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index d88a2d0..fc0bd38 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -25,7 +25,8 @@ struct hist_browser {
 	struct map_symbol   *selection;
 	int		     print_seq;
 	bool		     show_dso;
-	bool		     has_symbols;
+	float		     min_pcnt;
+	u64		     nr_pcnt_entries;
 };
 
 extern void hist_browser__init_hpp(void);
@@ -309,6 +310,8 @@ static void ui_browser__warn_lost_events(struct ui_browser *browser)
 		"Or reduce the sampling frequency.");
 }
 
+static void hist_browser__update_pcnt_entries(struct hist_browser *hb);
+
 static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 			     struct hist_browser_timer *hbt)
 {
@@ -318,6 +321,8 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 
 	browser->b.entries = &browser->hists->entries;
 	browser->b.nr_entries = browser->hists->nr_entries;
+	if (browser->min_pcnt)
+		browser->b.nr_entries = browser->nr_pcnt_entries;
 
 	hist_browser__refresh_dimensions(browser);
 	hists__browser_title(browser->hists, title, sizeof(title), ev_name);
@@ -330,9 +335,18 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 		key = ui_browser__run(&browser->b, delay_secs);
 
 		switch (key) {
-		case K_TIMER:
+		case K_TIMER: {
+			u64 nr_entries;
 			hbt->timer(hbt->arg);
-			ui_browser__update_nr_entries(&browser->b, browser->hists->nr_entries);
+
+			if (browser->min_pcnt) {
+				hist_browser__update_pcnt_entries(browser);
+				nr_entries = browser->nr_pcnt_entries;
+			} else {
+				nr_entries = browser->hists->nr_entries;
+			}
+
+			ui_browser__update_nr_entries(&browser->b, nr_entries);
 
 			if (browser->hists->stats.nr_lost_warned !=
 			    browser->hists->stats.nr_events[PERF_RECORD_LOST]) {
@@ -344,6 +358,7 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 			hists__browser_title(browser->hists, title, sizeof(title), ev_name);
 			ui_browser__show_title(&browser->b, title);
 			continue;
+		}
 		case 'D': { /* Debug */
 			static int seq;
 			struct hist_entry *h = rb_entry(browser->b.top,
@@ -796,10 +811,15 @@ static unsigned int hist_browser__refresh(struct ui_browser *browser)
 
 	for (nd = browser->top; nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+		float percent = h->stat.period * 100.0 /
+					hb->hists->stats.total_period;
 
 		if (h->filtered)
 			continue;
 
+		if (percent < hb->min_pcnt)
+			continue;
+
 		row += hist_browser__show_entry(hb, h, row);
 		if (row == browser->height)
 			break;
@@ -808,10 +828,18 @@ static unsigned int hist_browser__refresh(struct ui_browser *browser)
 	return row;
 }
 
-static struct rb_node *hists__filter_entries(struct rb_node *nd)
+static struct rb_node *hists__filter_entries(struct rb_node *nd,
+					     struct hists *hists,
+					     float min_pcnt)
 {
 	while (nd != NULL) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+		float percent = h->stat.period * 100.0 /
+					hists->stats.total_period;
+
+		if (percent < min_pcnt)
+			return NULL;
+
 		if (!h->filtered)
 			return nd;
 
@@ -821,11 +849,16 @@ static struct rb_node *hists__filter_entries(struct rb_node *nd)
 	return NULL;
 }
 
-static struct rb_node *hists__filter_prev_entries(struct rb_node *nd)
+static struct rb_node *hists__filter_prev_entries(struct rb_node *nd,
+						  struct hists *hists,
+						  float min_pcnt)
 {
 	while (nd != NULL) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		if (!h->filtered)
+		float percent = h->stat.period * 100.0 /
+					hists->stats.total_period;
+
+		if (!h->filtered && percent >= min_pcnt)
 			return nd;
 
 		nd = rb_prev(nd);
@@ -840,6 +873,9 @@ static void ui_browser__hists_seek(struct ui_browser *browser,
 	struct hist_entry *h;
 	struct rb_node *nd;
 	bool first = true;
+	struct hist_browser *hb;
+
+	hb = container_of(browser, struct hist_browser, b);
 
 	if (browser->nr_entries == 0)
 		return;
@@ -848,13 +884,15 @@ static void ui_browser__hists_seek(struct ui_browser *browser,
 
 	switch (whence) {
 	case SEEK_SET:
-		nd = hists__filter_entries(rb_first(browser->entries));
+		nd = hists__filter_entries(rb_first(browser->entries),
+					   hb->hists, hb->min_pcnt);
 		break;
 	case SEEK_CUR:
 		nd = browser->top;
 		goto do_offset;
 	case SEEK_END:
-		nd = hists__filter_prev_entries(rb_last(browser->entries));
+		nd = hists__filter_prev_entries(rb_last(browser->entries),
+						hb->hists, hb->min_pcnt);
 		first = false;
 		break;
 	default:
@@ -897,7 +935,8 @@ do_offset:
 					break;
 				}
 			}
-			nd = hists__filter_entries(rb_next(nd));
+			nd = hists__filter_entries(rb_next(nd), hb->hists,
+						   hb->min_pcnt);
 			if (nd == NULL)
 				break;
 			--offset;
@@ -930,7 +969,8 @@ do_offset:
 				}
 			}
 
-			nd = hists__filter_prev_entries(rb_prev(nd));
+			nd = hists__filter_prev_entries(rb_prev(nd), hb->hists,
+							hb->min_pcnt);
 			if (nd == NULL)
 				break;
 			++offset;
@@ -1099,14 +1139,17 @@ static int hist_browser__fprintf_entry(struct hist_browser *browser,
 
 static int hist_browser__fprintf(struct hist_browser *browser, FILE *fp)
 {
-	struct rb_node *nd = hists__filter_entries(rb_first(browser->b.entries));
+	struct rb_node *nd = hists__filter_entries(rb_first(browser->b.entries),
+						   browser->hists,
+						   browser->min_pcnt);
 	int printed = 0;
 
 	while (nd) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 
 		printed += hist_browser__fprintf_entry(browser, h, fp);
-		nd = hists__filter_entries(rb_next(nd));
+		nd = hists__filter_entries(rb_next(nd), browser->hists,
+					   browser->min_pcnt);
 	}
 
 	return printed;
@@ -1155,10 +1198,6 @@ static struct hist_browser *hist_browser__new(struct hists *hists)
 		browser->b.refresh = hist_browser__refresh;
 		browser->b.seek = ui_browser__hists_seek;
 		browser->b.use_navkeypressed = true;
-		if (sort__branch_mode == 1)
-			browser->has_symbols = sort_sym_from.list.next != NULL;
-		else
-			browser->has_symbols = sort_sym.list.next != NULL;
 	}
 
 	return browser;
@@ -1329,11 +1368,25 @@ close_file_and_continue:
 	return ret;
 }
 
+static void hist_browser__update_pcnt_entries(struct hist_browser *hb)
+{
+	u64 nr_entries = 0;
+	struct rb_node *nd = rb_first(&hb->hists->entries);
+
+	while (nd) {
+		nr_entries++;
+		nd = hists__filter_entries(rb_next(nd), hb->hists,
+					   hb->min_pcnt);
+	}
+
+	hb->nr_pcnt_entries = nr_entries;
+}
 
 static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 				    const char *helpline, const char *ev_name,
 				    bool left_exits,
 				    struct hist_browser_timer *hbt,
+				    float min_pcnt,
 				    struct perf_session_env *env)
 {
 	struct hists *hists = &evsel->hists;
@@ -1350,6 +1403,11 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	if (browser == NULL)
 		return -1;
 
+	if (min_pcnt) {
+		browser->min_pcnt = min_pcnt;
+		hist_browser__update_pcnt_entries(browser);
+	}
+
 	fstack = pstack__new(2);
 	if (fstack == NULL)
 		goto out;
@@ -1386,7 +1444,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			 */
 			goto out_free_stack;
 		case 'a':
-			if (!browser->has_symbols) {
+			if (!sort__has_sym) {
 				ui_browser__warning(&browser->b, delay_secs * 2,
 			"Annotation is only available for symbolic views, "
 			"include \"sym*\" in --sort to use it.");
@@ -1485,10 +1543,10 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			continue;
 		}
 
-		if (!browser->has_symbols)
+		if (!sort__has_sym)
 			goto add_exit_option;
 
-		if (sort__branch_mode == 1) {
+		if (sort__mode == SORT_MODE__BRANCH) {
 			bi = browser->he_selection->branch_info;
 			if (browser->selection != NULL &&
 			    bi &&
@@ -1689,6 +1747,7 @@ struct perf_evsel_menu {
 	struct ui_browser b;
 	struct perf_evsel *selection;
 	bool lost_events, lost_events_warned;
+	float min_pcnt;
 	struct perf_session_env *env;
 };
 
@@ -1782,6 +1841,7 @@ browse_hists:
 			ev_name = perf_evsel__name(pos);
 			key = perf_evsel__hists_browse(pos, nr_events, help,
 						       ev_name, true, hbt,
+						       menu->min_pcnt,
 						       menu->env);
 			ui_browser__show_title(&menu->b, title);
 			switch (key) {
@@ -1843,6 +1903,7 @@ static bool filter_group_entries(struct ui_browser *self __maybe_unused,
 static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
 					   int nr_entries, const char *help,
 					   struct hist_browser_timer *hbt,
+					   float min_pcnt,
 					   struct perf_session_env *env)
 {
 	struct perf_evsel *pos;
@@ -1856,6 +1917,7 @@ static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
 			.nr_entries = nr_entries,
 			.priv	    = evlist,
 		},
+		.min_pcnt = min_pcnt,
 		.env = env,
 	};
 
@@ -1874,6 +1936,7 @@ static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
 
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
 				  struct hist_browser_timer *hbt,
+				  float min_pcnt,
 				  struct perf_session_env *env)
 {
 	int nr_entries = evlist->nr_entries;
@@ -1885,7 +1948,8 @@ single_entry:
 		const char *ev_name = perf_evsel__name(first);
 
 		return perf_evsel__hists_browse(first, nr_entries, help,
-						ev_name, false, hbt, env);
+						ev_name, false, hbt, min_pcnt,
+						env);
 	}
 
 	if (symbol_conf.event_group) {
@@ -1901,5 +1965,5 @@ single_entry:
 	}
 
 	return __perf_evlist__tui_browse_hists(evlist, nr_entries, help,
-					       hbt, env);
+					       hbt, min_pcnt, env);
 }
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 6f259b3..9708dd5 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -124,7 +124,8 @@ void perf_gtk__init_hpp(void)
 				perf_gtk__hpp_color_overhead_guest_us;
 }
 
-static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
+static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
+				 float min_pcnt)
 {
 	struct perf_hpp_fmt *fmt;
 	GType col_types[MAX_COLUMNS];
@@ -189,10 +190,15 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 		GtkTreeIter iter;
+		float percent = h->stat.period * 100.0 /
+					hists->stats.total_period;
 
 		if (h->filtered)
 			continue;
 
+		if (percent < min_pcnt)
+			continue;
+
 		gtk_list_store_append(store, &iter);
 
 		col_idx = 0;
@@ -222,7 +228,8 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 
 int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 				  const char *help,
-				  struct hist_browser_timer *hbt __maybe_unused)
+				  struct hist_browser_timer *hbt __maybe_unused,
+				  float min_pcnt)
 {
 	struct perf_evsel *pos;
 	GtkWidget *vbox;
@@ -286,7 +293,7 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 							GTK_POLICY_AUTOMATIC,
 							GTK_POLICY_AUTOMATIC);
 
-		perf_gtk__show_hists(scrolled_window, hists);
+		perf_gtk__show_hists(scrolled_window, hists, min_pcnt);
 
 		tab_label = gtk_label_new(evname);
 
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index ff1f60c..ae7a754 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -334,7 +334,7 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 }
 
 size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
-		      int max_cols, FILE *fp)
+		      int max_cols, float min_pcnt, FILE *fp)
 {
 	struct perf_hpp_fmt *fmt;
 	struct sort_entry *se;
@@ -440,10 +440,15 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 print_entries:
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+		float percent = h->stat.period * 100.0 /
+					hists->stats.total_period;
 
 		if (h->filtered)
 			continue;
 
+		if (percent < min_pcnt)
+			continue;
+
 		ret += hist_entry__fprintf(h, max_cols, hists, fp);
 
 		if (max_rows && ++nr_rows >= max_rows)
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index f7c7278..99b43dd 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -776,6 +776,8 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 		if (pipe_output)
 			dup2(2, 1);
 
+		signal(SIGTERM, SIG_DFL);
+
 		close(child_ready_pipe[0]);
 		close(go_pipe[1]);
 		fcntl(go_pipe[0], F_SETFD, FD_CLOEXEC);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 07b1a3a..63b6f8c 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1514,7 +1514,7 @@ int perf_evsel__open_strerror(struct perf_evsel *evsel,
 	switch (err) {
 	case EPERM:
 	case EACCES:
-		return scnprintf(msg, size, "%s",
+		return scnprintf(msg, size,
 		 "You may not have permission to collect %sstats.\n"
 		 "Consider tweaking /proc/sys/kernel/perf_event_paranoid:\n"
 		 " -1 - Not paranoid at all\n"
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 326068a..738d3b8 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2391,7 +2391,6 @@ out_err_write:
 	}
 	lseek(fd, header->data_offset + header->data_size, SEEK_SET);
 
-	header->frozen = 1;
 	return 0;
 }
 
@@ -2871,7 +2870,6 @@ int perf_session__read_header(struct perf_session *session, int fd)
 						   session->pevent))
 		goto out_delete_evlist;
 
-	header->frozen = 1;
 	return 0;
 out_errno:
 	return -errno;
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index c9fc55c..16a3e83 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -84,7 +84,6 @@ struct perf_session_env {
 };
 
 struct perf_header {
-	int			frozen;
 	bool			needs_swap;
 	s64			attr_offset;
 	u64			data_offset;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 6b32721..b11a6cf 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -70,9 +70,17 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 	int symlen;
 	u16 len;
 
-	if (h->ms.sym)
-		hists__new_col_len(hists, HISTC_SYMBOL, h->ms.sym->namelen + 4);
-	else {
+	/*
+	 * +4 accounts for '[x] ' priv level info
+	 * +2 accounts for 0x prefix on raw addresses
+	 * +3 accounts for ' y ' symtab origin info
+	 */
+	if (h->ms.sym) {
+		symlen = h->ms.sym->namelen + 4;
+		if (verbose)
+			symlen += BITS_PER_LONG / 4 + 2 + 3;
+		hists__new_col_len(hists, HISTC_SYMBOL, symlen);
+	} else {
 		symlen = unresolved_col_width + 4 + 2;
 		hists__new_col_len(hists, HISTC_SYMBOL, symlen);
 		hists__set_unres_dso_col_len(hists, HISTC_DSO);
@@ -91,12 +99,10 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 		hists__new_col_len(hists, HISTC_PARENT, h->parent->namelen);
 
 	if (h->branch_info) {
-		/*
-		 * +4 accounts for '[x] ' priv level info
-		 * +2 account of 0x prefix on raw addresses
-		 */
 		if (h->branch_info->from.sym) {
 			symlen = (int)h->branch_info->from.sym->namelen + 4;
+			if (verbose)
+				symlen += BITS_PER_LONG / 4 + 2 + 3;
 			hists__new_col_len(hists, HISTC_SYMBOL_FROM, symlen);
 
 			symlen = dso__name_len(h->branch_info->from.map->dso);
@@ -109,6 +115,8 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 
 		if (h->branch_info->to.sym) {
 			symlen = (int)h->branch_info->to.sym->namelen + 4;
+			if (verbose)
+				symlen += BITS_PER_LONG / 4 + 2 + 3;
 			hists__new_col_len(hists, HISTC_SYMBOL_TO, symlen);
 
 			symlen = dso__name_len(h->branch_info->to.map->dso);
@@ -121,10 +129,6 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 	}
 
 	if (h->mem_info) {
-		/*
-		 * +4 accounts for '[x] ' priv level info
-		 * +2 account of 0x prefix on raw addresses
-		 */
 		if (h->mem_info->daddr.sym) {
 			symlen = (int)h->mem_info->daddr.sym->namelen + 4
 			       + unresolved_col_width + 2;
@@ -236,8 +240,7 @@ static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
 	return he->stat.period == 0;
 }
 
-static void __hists__decay_entries(struct hists *hists, bool zap_user,
-				   bool zap_kernel, bool threaded)
+void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel)
 {
 	struct rb_node *next = rb_first(&hists->entries);
 	struct hist_entry *n;
@@ -256,7 +259,7 @@ static void __hists__decay_entries(struct hists *hists, bool zap_user,
 		    !n->used) {
 			rb_erase(&n->rb_node, &hists->entries);
 
-			if (sort__need_collapse || threaded)
+			if (sort__need_collapse)
 				rb_erase(&n->rb_node_in, &hists->entries_collapsed);
 
 			hist_entry__free(n);
@@ -265,17 +268,6 @@ static void __hists__decay_entries(struct hists *hists, bool zap_user,
 	}
 }
 
-void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel)
-{
-	return __hists__decay_entries(hists, zap_user, zap_kernel, false);
-}
-
-void hists__decay_entries_threaded(struct hists *hists,
-				   bool zap_user, bool zap_kernel)
-{
-	return __hists__decay_entries(hists, zap_user, zap_kernel, true);
-}
-
 /*
  * histogram, sorted on item, collects periods
  */
@@ -292,6 +284,20 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 			he->ms.map->referenced = true;
 
 		if (he->branch_info) {
+			/*
+			 * This branch info is (a part of) allocated from
+			 * machine__resolve_bstack() and will be freed after
+			 * adding new entries.  So we need to save a copy.
+			 */
+			he->branch_info = malloc(sizeof(*he->branch_info));
+			if (he->branch_info == NULL) {
+				free(he);
+				return NULL;
+			}
+
+			memcpy(he->branch_info, template->branch_info,
+			       sizeof(*he->branch_info));
+
 			if (he->branch_info->from.map)
 				he->branch_info->from.map->referenced = true;
 			if (he->branch_info->to.map)
@@ -341,8 +347,6 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	struct hist_entry *he;
 	int cmp;
 
-	pthread_mutex_lock(&hists->lock);
-
 	p = &hists->entries_in->rb_node;
 
 	while (*p != NULL) {
@@ -360,6 +364,12 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 		if (!cmp) {
 			he_stat__add_period(&he->stat, period, weight);
 
+			/*
+			 * This mem info was allocated from machine__resolve_mem
+			 * and will not be used anymore.
+			 */
+			free(entry->mem_info);
+
 			/* If the map of an existing hist_entry has
 			 * become out-of-date due to an exec() or
 			 * similar, update it.  Otherwise we will
@@ -382,14 +392,12 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 
 	he = hist_entry__new(entry);
 	if (!he)
-		goto out_unlock;
+		return NULL;
 
 	rb_link_node(&he->rb_node_in, parent, p);
 	rb_insert_color(&he->rb_node_in, hists->entries_in);
 out:
 	hist_entry__add_cpumode_period(he, al->cpumode, period);
-out_unlock:
-	pthread_mutex_unlock(&hists->lock);
 	return he;
 }
 
@@ -589,13 +597,13 @@ static void hists__apply_filters(struct hists *hists, struct hist_entry *he)
 	hists__filter_entry_by_symbol(hists, he);
 }
 
-static void __hists__collapse_resort(struct hists *hists, bool threaded)
+void hists__collapse_resort(struct hists *hists)
 {
 	struct rb_root *root;
 	struct rb_node *next;
 	struct hist_entry *n;
 
-	if (!sort__need_collapse && !threaded)
+	if (!sort__need_collapse)
 		return;
 
 	root = hists__get_rotate_entries_in(hists);
@@ -617,16 +625,6 @@ static void __hists__collapse_resort(struct hists *hists, bool threaded)
 	}
 }
 
-void hists__collapse_resort(struct hists *hists)
-{
-	return __hists__collapse_resort(hists, false);
-}
-
-void hists__collapse_resort_threaded(struct hists *hists)
-{
-	return __hists__collapse_resort(hists, true);
-}
-
 /*
  * reverse the map, sort on period.
  */
@@ -713,7 +711,7 @@ static void __hists__insert_output_entry(struct rb_root *entries,
 	rb_insert_color(&he->rb_node, entries);
 }
 
-static void __hists__output_resort(struct hists *hists, bool threaded)
+void hists__output_resort(struct hists *hists)
 {
 	struct rb_root *root;
 	struct rb_node *next;
@@ -722,7 +720,7 @@ static void __hists__output_resort(struct hists *hists, bool threaded)
 
 	min_callchain_hits = hists->stats.total_period * (callchain_param.min_percent / 100);
 
-	if (sort__need_collapse || threaded)
+	if (sort__need_collapse)
 		root = &hists->entries_collapsed;
 	else
 		root = hists->entries_in;
@@ -743,16 +741,6 @@ static void __hists__output_resort(struct hists *hists, bool threaded)
 	}
 }
 
-void hists__output_resort(struct hists *hists)
-{
-	return __hists__output_resort(hists, false);
-}
-
-void hists__output_resort_threaded(struct hists *hists)
-{
-	return __hists__output_resort(hists, true);
-}
-
 static void hists__remove_entry_filter(struct hists *hists, struct hist_entry *h,
 				       enum hist_filter filter)
 {
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 14c2fe2..2d3790f 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -43,12 +43,12 @@ enum hist_column {
 	HISTC_COMM,
 	HISTC_PARENT,
 	HISTC_CPU,
+	HISTC_SRCLINE,
 	HISTC_MISPREDICT,
 	HISTC_SYMBOL_FROM,
 	HISTC_SYMBOL_TO,
 	HISTC_DSO_FROM,
 	HISTC_DSO_TO,
-	HISTC_SRCLINE,
 	HISTC_LOCAL_WEIGHT,
 	HISTC_GLOBAL_WEIGHT,
 	HISTC_MEM_DADDR_SYMBOL,
@@ -104,13 +104,9 @@ struct hist_entry *__hists__add_mem_entry(struct hists *self,
 					  u64 weight);
 
 void hists__output_resort(struct hists *self);
-void hists__output_resort_threaded(struct hists *hists);
 void hists__collapse_resort(struct hists *self);
-void hists__collapse_resort_threaded(struct hists *hists);
 
 void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel);
-void hists__decay_entries_threaded(struct hists *hists, bool zap_user,
-				   bool zap_kernel);
 void hists__output_recalc_col_len(struct hists *hists, int max_rows);
 
 void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h);
@@ -119,7 +115,7 @@ void events_stats__inc(struct events_stats *stats, u32 type);
 size_t events_stats__fprintf(struct events_stats *stats, FILE *fp);
 
 size_t hists__fprintf(struct hists *self, bool show_header, int max_rows,
-		      int max_cols, FILE *fp);
+		      int max_cols, float min_pcnt, FILE *fp);
 
 int hist_entry__inc_addr_samples(struct hist_entry *self, int evidx, u64 addr);
 int hist_entry__annotate(struct hist_entry *self, size_t privsize);
@@ -199,6 +195,7 @@ int hist_entry__tui_annotate(struct hist_entry *he, struct perf_evsel *evsel,
 
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
 				  struct hist_browser_timer *hbt,
+				  float min_pcnt,
 				  struct perf_session_env *env);
 int script_browse(const char *script_opt);
 #else
@@ -206,6 +203,7 @@ static inline
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist __maybe_unused,
 				  const char *help __maybe_unused,
 				  struct hist_browser_timer *hbt __maybe_unused,
+				  float min_pcnt __maybe_unused,
 				  struct perf_session_env *env __maybe_unused)
 {
 	return 0;
@@ -233,12 +231,14 @@ static inline int script_browse(const char *script_opt __maybe_unused)
 
 #ifdef GTK2_SUPPORT
 int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist, const char *help,
-				  struct hist_browser_timer *hbt __maybe_unused);
+				  struct hist_browser_timer *hbt __maybe_unused,
+				  float min_pcnt);
 #else
 static inline
 int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist __maybe_unused,
 				  const char *help __maybe_unused,
-				  struct hist_browser_timer *hbt __maybe_unused)
+				  struct hist_browser_timer *hbt __maybe_unused,
+				  float min_pcnt __maybe_unused)
 {
 	return 0;
 }
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 6fcb9de..8bcdf9e 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -21,6 +21,7 @@ const char *map_type__name[MAP__NR_TYPES] = {
 static inline int is_anon_memory(const char *filename)
 {
 	return !strcmp(filename, "//anon") ||
+	       !strcmp(filename, "/dev/zero (deleted)") ||
 	       !strcmp(filename, "/anon_hugepage (deleted)");
 }
 
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 6b51d47..f3b235e 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -37,7 +37,6 @@ struct perf_session {
 	int			fd;
 	bool			fd_pipe;
 	bool			repipe;
-	int			cwdlen;
 	char			*cwd;
 	struct ordered_samples	ordered_samples;
 	char			filename[1];
diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index 6b0ed32..58ea5ca 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -18,8 +18,9 @@ class install_lib(_install_lib):
         self.build_dir = build_lib
 
 
-cflags = ['-fno-strict-aliasing', '-Wno-write-strings']
-cflags += getenv('CFLAGS', '').split()
+cflags = getenv('CFLAGS', '').split()
+# switch off several checks (need to be at the end of cflags list)
+cflags += ['-fno-strict-aliasing', '-Wno-write-strings', '-Wno-unused-parameter' ]
 
 build_lib = getenv('PYTHON_EXTBUILD_LIB')
 build_tmp = getenv('PYTHON_EXTBUILD_TMP')
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 5f52d49..313a5a7 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1,5 +1,6 @@
 #include "sort.h"
 #include "hist.h"
+#include "symbol.h"
 
 regex_t		parent_regex;
 const char	default_parent_pattern[] = "^sys_|^do_page_fault";
@@ -9,7 +10,7 @@ const char	*sort_order = default_sort_order;
 int		sort__need_collapse = 0;
 int		sort__has_parent = 0;
 int		sort__has_sym = 0;
-int		sort__branch_mode = -1; /* -1 = means not set */
+enum sort_mode	sort__mode = SORT_MODE__NORMAL;
 
 enum sort_type	sort__first_dimension;
 
@@ -194,7 +195,7 @@ static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
 	if (verbose) {
 		char o = map ? dso__symtab_origin(map->dso) : '!';
 		ret += repsep_snprintf(bf, size, "%-#*llx %c ",
-				       BITS_PER_LONG / 4, ip, o);
+				       BITS_PER_LONG / 4 + 2, ip, o);
 	}
 
 	ret += repsep_snprintf(bf + ret, size - ret, "[%c] ", level);
@@ -871,14 +872,6 @@ static struct sort_dimension common_sort_dimensions[] = {
 	DIM(SORT_PARENT, "parent", sort_parent),
 	DIM(SORT_CPU, "cpu", sort_cpu),
 	DIM(SORT_SRCLINE, "srcline", sort_srcline),
-	DIM(SORT_LOCAL_WEIGHT, "local_weight", sort_local_weight),
-	DIM(SORT_GLOBAL_WEIGHT, "weight", sort_global_weight),
-	DIM(SORT_MEM_DADDR_SYMBOL, "symbol_daddr", sort_mem_daddr_sym),
-	DIM(SORT_MEM_DADDR_DSO, "dso_daddr", sort_mem_daddr_dso),
-	DIM(SORT_MEM_LOCKED, "locked", sort_mem_locked),
-	DIM(SORT_MEM_TLB, "tlb", sort_mem_tlb),
-	DIM(SORT_MEM_LVL, "mem", sort_mem_lvl),
-	DIM(SORT_MEM_SNOOP, "snoop", sort_mem_snoop),
 };
 
 #undef DIM
@@ -895,6 +888,36 @@ static struct sort_dimension bstack_sort_dimensions[] = {
 
 #undef DIM
 
+#define DIM(d, n, func) [d - __SORT_MEMORY_MODE] = { .name = n, .entry = &(func) }
+
+static struct sort_dimension memory_sort_dimensions[] = {
+	DIM(SORT_LOCAL_WEIGHT, "local_weight", sort_local_weight),
+	DIM(SORT_GLOBAL_WEIGHT, "weight", sort_global_weight),
+	DIM(SORT_MEM_DADDR_SYMBOL, "symbol_daddr", sort_mem_daddr_sym),
+	DIM(SORT_MEM_DADDR_DSO, "dso_daddr", sort_mem_daddr_dso),
+	DIM(SORT_MEM_LOCKED, "locked", sort_mem_locked),
+	DIM(SORT_MEM_TLB, "tlb", sort_mem_tlb),
+	DIM(SORT_MEM_LVL, "mem", sort_mem_lvl),
+	DIM(SORT_MEM_SNOOP, "snoop", sort_mem_snoop),
+};
+
+#undef DIM
+
+static void __sort_dimension__add(struct sort_dimension *sd, enum sort_type idx)
+{
+	if (sd->taken)
+		return;
+
+	if (sd->entry->se_collapse)
+		sort__need_collapse = 1;
+
+	if (list_empty(&hist_entry__sort_list))
+		sort__first_dimension = idx;
+
+	list_add_tail(&sd->entry->list, &hist_entry__sort_list);
+	sd->taken = 1;
+}
+
 int sort_dimension__add(const char *tok)
 {
 	unsigned int i;
@@ -915,25 +938,11 @@ int sort_dimension__add(const char *tok)
 				return -EINVAL;
 			}
 			sort__has_parent = 1;
-		} else if (sd->entry == &sort_sym ||
-			   sd->entry == &sort_sym_from ||
-			   sd->entry == &sort_sym_to ||
-			   sd->entry == &sort_mem_daddr_sym) {
+		} else if (sd->entry == &sort_sym) {
 			sort__has_sym = 1;
 		}
 
-		if (sd->taken)
-			return 0;
-
-		if (sd->entry->se_collapse)
-			sort__need_collapse = 1;
-
-		if (list_empty(&hist_entry__sort_list))
-			sort__first_dimension = i;
-
-		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
-		sd->taken = 1;
-
+		__sort_dimension__add(sd, i);
 		return 0;
 	}
 
@@ -943,24 +952,29 @@ int sort_dimension__add(const char *tok)
 		if (strncasecmp(tok, sd->name, strlen(tok)))
 			continue;
 
-		if (sort__branch_mode != 1)
+		if (sort__mode != SORT_MODE__BRANCH)
 			return -EINVAL;
 
 		if (sd->entry == &sort_sym_from || sd->entry == &sort_sym_to)
 			sort__has_sym = 1;
 
-		if (sd->taken)
-			return 0;
+		__sort_dimension__add(sd, i + __SORT_BRANCH_STACK);
+		return 0;
+	}
 
-		if (sd->entry->se_collapse)
-			sort__need_collapse = 1;
+	for (i = 0; i < ARRAY_SIZE(memory_sort_dimensions); i++) {
+		struct sort_dimension *sd = &memory_sort_dimensions[i];
 
-		if (list_empty(&hist_entry__sort_list))
-			sort__first_dimension = i + __SORT_BRANCH_STACK;
+		if (strncasecmp(tok, sd->name, strlen(tok)))
+			continue;
 
-		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
-		sd->taken = 1;
+		if (sort__mode != SORT_MODE__MEMORY)
+			return -EINVAL;
+
+		if (sd->entry == &sort_mem_daddr_sym)
+			sort__has_sym = 1;
 
+		__sort_dimension__add(sd, i + __SORT_MEMORY_MODE);
 		return 0;
 	}
 
@@ -993,8 +1007,9 @@ int setup_sorting(void)
 	return ret;
 }
 
-void sort_entry__setup_elide(struct sort_entry *self, struct strlist *list,
-			     const char *list_name, FILE *fp)
+static void sort_entry__setup_elide(struct sort_entry *self,
+				    struct strlist *list,
+				    const char *list_name, FILE *fp)
 {
 	if (list && strlist__nr_entries(list) == 1) {
 		if (fp != NULL)
@@ -1003,3 +1018,42 @@ void sort_entry__setup_elide(struct sort_entry *self, struct strlist *list,
 		self->elide = true;
 	}
 }
+
+void sort__setup_elide(FILE *output)
+{
+	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
+				"dso", output);
+	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list,
+				"comm", output);
+	sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list,
+				"symbol", output);
+
+	if (sort__mode == SORT_MODE__BRANCH) {
+		sort_entry__setup_elide(&sort_dso_from,
+					symbol_conf.dso_from_list,
+					"dso_from", output);
+		sort_entry__setup_elide(&sort_dso_to,
+					symbol_conf.dso_to_list,
+					"dso_to", output);
+		sort_entry__setup_elide(&sort_sym_from,
+					symbol_conf.sym_from_list,
+					"sym_from", output);
+		sort_entry__setup_elide(&sort_sym_to,
+					symbol_conf.sym_to_list,
+					"sym_to", output);
+	} else if (sort__mode == SORT_MODE__MEMORY) {
+		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
+					"symbol_daddr", output);
+		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
+					"dso_daddr", output);
+		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
+					"mem", output);
+		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
+					"local_weight", output);
+		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
+					"tlb", output);
+		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
+					"snoop", output);
+	}
+
+}
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index f24bdf6..45ac84c 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -32,7 +32,7 @@ extern const char default_sort_order[];
 extern int sort__need_collapse;
 extern int sort__has_parent;
 extern int sort__has_sym;
-extern int sort__branch_mode;
+extern enum sort_mode sort__mode;
 extern struct sort_entry sort_comm;
 extern struct sort_entry sort_dso;
 extern struct sort_entry sort_sym;
@@ -117,12 +117,18 @@ static inline struct hist_entry *hist_entry__next_pair(struct hist_entry *he)
 	return NULL;
 }
 
-static inline void hist_entry__add_pair(struct hist_entry *he,
-					struct hist_entry *pair)
+static inline void hist_entry__add_pair(struct hist_entry *pair,
+					struct hist_entry *he)
 {
-	list_add_tail(&he->pairs.head, &pair->pairs.node);
+	list_add_tail(&pair->pairs.node, &he->pairs.head);
 }
 
+enum sort_mode {
+	SORT_MODE__NORMAL,
+	SORT_MODE__BRANCH,
+	SORT_MODE__MEMORY,
+};
+
 enum sort_type {
 	/* common sort keys */
 	SORT_PID,
@@ -132,14 +138,6 @@ enum sort_type {
 	SORT_PARENT,
 	SORT_CPU,
 	SORT_SRCLINE,
-	SORT_LOCAL_WEIGHT,
-	SORT_GLOBAL_WEIGHT,
-	SORT_MEM_DADDR_SYMBOL,
-	SORT_MEM_DADDR_DSO,
-	SORT_MEM_LOCKED,
-	SORT_MEM_TLB,
-	SORT_MEM_LVL,
-	SORT_MEM_SNOOP,
 
 	/* branch stack specific sort keys */
 	__SORT_BRANCH_STACK,
@@ -148,6 +146,17 @@ enum sort_type {
 	SORT_SYM_FROM,
 	SORT_SYM_TO,
 	SORT_MISPREDICT,
+
+	/* memory mode specific sort keys */
+	__SORT_MEMORY_MODE,
+	SORT_LOCAL_WEIGHT = __SORT_MEMORY_MODE,
+	SORT_GLOBAL_WEIGHT,
+	SORT_MEM_DADDR_SYMBOL,
+	SORT_MEM_DADDR_DSO,
+	SORT_MEM_LOCKED,
+	SORT_MEM_TLB,
+	SORT_MEM_LVL,
+	SORT_MEM_SNOOP,
 };
 
 /*
@@ -172,7 +181,6 @@ extern struct list_head hist_entry__sort_list;
 
 int setup_sorting(void);
 extern int sort_dimension__add(const char *);
-void sort_entry__setup_elide(struct sort_entry *self, struct strlist *list,
-			     const char *list_name, FILE *fp);
+void sort__setup_elide(FILE *fp);
 
 #endif	/* __PERF_SORT_H */
diff --git a/tools/perf/util/stat.c b/tools/perf/util/stat.c
index 2374212..7c59c28 100644
--- a/tools/perf/util/stat.c
+++ b/tools/perf/util/stat.c
@@ -37,7 +37,7 @@ double stddev_stats(struct stats *stats)
 {
 	double variance, variance_mean;
 
-	if (!stats->n)
+	if (stats->n < 2)
 		return 0.0;
 
 	variance = stats->M2 / (stats->n - 1);
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 632e40e..40399cb 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -14,6 +14,7 @@ struct thread *thread__new(pid_t pid)
 	if (self != NULL) {
 		map_groups__init(&self->mg);
 		self->pid = pid;
+		self->ppid = -1;
 		self->comm = malloc(32);
 		if (self->comm)
 			snprintf(self->comm, 32, ":%d", self->pid);
@@ -82,5 +83,8 @@ int thread__fork(struct thread *self, struct thread *parent)
 	for (i = 0; i < MAP__NR_TYPES; ++i)
 		if (map_groups__clone(&self->mg, &parent->mg, i) < 0)
 			return -ENOMEM;
+
+	self->ppid = parent->pid;
+
 	return 0;
 }
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 5ad2664..eeb7ac6 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -13,6 +13,7 @@ struct thread {
 	};
 	struct map_groups	mg;
 	pid_t			pid;
+	pid_t			ppid;
 	char			shortname[3];
 	bool			comm_set;
 	char			*comm;
diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index 54d37a4..f857b51 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -23,20 +23,31 @@
 
 size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
 {
-	float samples_per_sec = top->samples / top->delay_secs;
-	float ksamples_per_sec = top->kernel_samples / top->delay_secs;
-	float esamples_percent = (100.0 * top->exact_samples) / top->samples;
+	float samples_per_sec;
+	float ksamples_per_sec;
+	float esamples_percent;
 	struct perf_record_opts *opts = &top->record_opts;
 	struct perf_target *target = &opts->target;
 	size_t ret = 0;
 
+	if (top->samples) {
+		samples_per_sec = top->samples / top->delay_secs;
+		ksamples_per_sec = top->kernel_samples / top->delay_secs;
+		esamples_percent = (100.0 * top->exact_samples) / top->samples;
+	} else {
+		samples_per_sec = ksamples_per_sec = esamples_percent = 0.0;
+	}
+
 	if (!perf_guest) {
+		float ksamples_percent = 0.0;
+
+		if (samples_per_sec)
+			ksamples_percent = (100.0 * ksamples_per_sec) /
+							samples_per_sec;
 		ret = SNPRINTF(bf, size,
 			       "   PerfTop:%8.0f irqs/sec  kernel:%4.1f%%"
 			       "  exact: %4.1f%% [", samples_per_sec,
-			       100.0 - (100.0 * ((samples_per_sec - ksamples_per_sec) /
-					samples_per_sec)),
-				esamples_percent);
+			       ksamples_percent, esamples_percent);
 	} else {
 		float us_samples_per_sec = top->us_samples / top->delay_secs;
 		float guest_kernel_samples_per_sec = top->guest_kernel_samples / top->delay_secs;
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index 7ebf357..df46be9 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -26,7 +26,6 @@ struct perf_top {
 	int		   print_entries, count_filter, delay_secs;
 	bool		   hide_kernel_symbols, hide_user_symbols, zero;
 	bool		   use_tui, use_stdio;
-	bool		   sort_has_symbols;
 	bool		   kptr_restrict_warned;
 	bool		   vmlinux_warned;
 	bool		   dump_symtab;
@@ -37,6 +36,7 @@ struct perf_top {
 	int		   realtime_prio;
 	int		   sym_pcnt_filter;
 	const char	   *sym_filter;
+	float		   min_percent;
 };
 
 size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size);
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index a45710b..7a484c9 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -221,8 +221,8 @@ extern unsigned char sane_ctype[256];
 #define isalpha(x) sane_istest(x,GIT_ALPHA)
 #define isalnum(x) sane_istest(x,GIT_ALPHA | GIT_DIGIT)
 #define isprint(x) sane_istest(x,GIT_PRINT)
-#define islower(x) (sane_istest(x,GIT_ALPHA) && sane_istest(x,0x20))
-#define isupper(x) (sane_istest(x,GIT_ALPHA) && !sane_istest(x,0x20))
+#define islower(x) (sane_istest(x,GIT_ALPHA) && (x & 0x20))
+#define isupper(x) (sane_istest(x,GIT_ALPHA) && !(x & 0x20))
 #define tolower(x) sane_case((unsigned char)(x), 0x20)
 #define toupper(x) sane_case((unsigned char)(x), 0)
 
