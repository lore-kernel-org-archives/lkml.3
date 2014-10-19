Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbaJSJkJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 05:40:09 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:53831 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbaJSJj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 05:39:58 -0400
Date: Sun, 19 Oct 2014 11:39:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf updates for v3.18, part 2
Message-ID: <20141019093952.GA30797@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   # HEAD: 3b10ea7f922b538ba5dcb3d979a6b6b4d07daae2 Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent

A second (and last) round of late coming fixes and changes, 
almost all of them in perf tooling:

 User visible tooling changes:

  * Add period data column and make it default in 'perf script' (Jiri Olsa)

  * Add a visual cue for toggle zeroing of samples in 'perf top' (Taeung Song)

  * Improve callchains when using libunwind (Namhyung Kim)

 Tooling fixes and infrastructure changes:

  * Fix for double free in 'perf stat' when using some specific invalid
    command line combo (Yasser Shalabi)

  * Fix off-by-one bugs in map->end handling (Stephane Eranian)

  * Fix off-by-one bug in maps__find(), also related to map->end handling (Namhyung Kim)

  * Make struct symbol->end be the first addr after the symbol range, to make it
    match the convention used for struct map->end. (Arnaldo Carvalho de Melo)

  * Fix perf_evlist__add_pollfd() error handling in 'perf kvm stat live' (Jiri Olsa)

  * Fix python test build by moving callchain_param to an object linked into the
    python binding (Jiri Olsa)

  * Document sysfs events/ interfaces (Cody P Schafer)

  * Fix typos in perf/Documentation (Masanari Iida)

  * Add missing 'struct option' forward declaration (Arnaldo Carvalho de Melo)

  * Add option to copy events when queuing for sorting across cpu buffers
    and enable it for 'perf kvm stat live', to avoid having events left
    in the queue pointing to the ring buffer be rewritten in high volume
    sessions.  (Alexander Yarygin, improving work done by David Ahern):

  * Do not include a struct hists per perf_evsel, untangling the histogram code
    from perf_evsel, to pave the way for exporting a minimalistic
    tools/lib/api/perf/ library usable by tools/perf and initially by the rasd
    daemon being developed by Borislav Petkov, Robert Richter and Jean Pihet.
    (Arnaldo Carvalho de Melo)

  * Make perf_evlist__open(evlist, NULL, NULL), i.e. without cpu and thread
    maps mean syswide monitoring, reducing the boilerplate for tools that
    only want system wide mode. (Arnaldo Carvalho de Melo)
   * Move exit stuff from perf_evsel__delete to perf_evsel__exit, delete
    should be just a front end for exit + free (Arnaldo Carvalho de Melo)

  * Add support to new style format of kernel PMU event. (Kan Liang)

and other misc fixes.

 Thanks,

	Ingo

------------------>
Alexander Yarygin (2):
      perf session: Add option to copy events when queueing
      perf kvm stat live: Enable events copying

Anton Blanchard (1):
      kprobes/x86: Remove stale ARCH_SUPPORTS_KPROBES_ON_FTRACE define

Arnaldo Carvalho de Melo (21):
      perf sched: Stop updating hists stats, not used
      perf script: Stop updating hists stats, not used
      perf evsel: Add hists helper
      perf session: Don't count per evsel events
      perf tools: Move events_stats struct to event.h
      perf ui browsers: Add missing include
      perf session: Remove last reference to hists struct
      perf evsel: Subclassing
      perf callchain: Move the callchain_param extern to callchain.h
      perf tools: Remove hists from evsel
      perf thread_map: Create dummy constructor out of open coded equivalent
      perf evlist: Check that there is a thread_map when preparing a workload
      perf evlist: Default to syswide target when no thread/cpu maps set
      perf evsel: Add missing 'target' struct forward declaration
      perf evsel: Make some exit routines static
      perf machine: Add missing dsos->root rbtree root initialization
      perf symbols: Fix map->end fixup
      perf symbols: Make sym->end be the first address after the symbol range
      perf evsel: Move exit stuff from __delete to __exit
      perf evlist: Add missing 'struct option' forward declaration
      perf evsel: No need to drag util/cgroup.h

Cody P Schafer (2):
      perf Documentation: sysfs events/ interfaces
      perf Documentation: Remove Ruplicated docs for powerpc cpu specific events

Jiri Olsa (6):
      perf kvm stat live: Fix perf_evlist__add_pollfd error handling
      perf kvm stat live: Use perf_evlist__add_pollfd return fd position
      perf kvm stat live: Use fdarray object instead of pollfd
      perf callchain: Move callchain_param to util object in to fix python test
      perf script: Add period data column
      perf script: Add period as a default output column

Kan Liang (4):
      Revert "perf tools: Default to cpu// for events v5"
      perf tools: Parse the pmu event prefix and suffix
      perf tools: Add support to new style format of kernel PMU event
      perf test: Add test case for pmu event new style format

Masanari Iida (1):
      perf Documentation: Fix typos in perf/Documentation

Namhyung Kim (5):
      perf tools: Fixup off-by-one comparision in maps__find
      perf report: Set callchain_param.record_mode for future use
      perf callchain: Create an address space per thread
      perf kvm: Use thread_{,_set}_priv helpers
      perf trace: Use thread_{,_set}_priv helpers

Stephane Eranian (1):
      perf tools: fix off-by-one error in maps

Taeung Song (1):
      perf top: Add a visual cue for toggle zeroing of samples

Yasser Shalabi (1):
      perf evlist: Fix for double free in tools/perf stat


 .../testing/sysfs-bus-event_source-devices-events  | 611 ++-------------------
 arch/x86/include/asm/kprobes.h                     |   1 -
 tools/perf/Documentation/perf-diff.txt             |   6 +-
 tools/perf/Documentation/perf-kvm.txt              |   4 +-
 tools/perf/Documentation/perf-list.txt             |   2 +-
 tools/perf/Documentation/perf-record.txt           |   2 +-
 tools/perf/Documentation/perf-script-perl.txt      |   4 +-
 tools/perf/Documentation/perf-script-python.txt    |   6 +-
 tools/perf/Documentation/perf-script.txt           |   4 +-
 tools/perf/Documentation/perf-test.txt             |   2 +-
 tools/perf/Documentation/perf-trace.txt            |   2 +-
 tools/perf/builtin-annotate.c                      |  14 +-
 tools/perf/builtin-diff.c                          |  21 +-
 tools/perf/builtin-kvm.c                           |  29 +-
 tools/perf/builtin-record.c                        |   2 +
 tools/perf/builtin-report.c                        |  31 +-
 tools/perf/builtin-sched.c                         |   3 -
 tools/perf/builtin-script.c                        |  22 +-
 tools/perf/builtin-stat.c                          |   1 +
 tools/perf/builtin-top.c                           |  60 +-
 tools/perf/builtin-trace.c                         |  16 +-
 tools/perf/tests/builtin-test.c                    |   5 +
 tools/perf/tests/dwarf-unwind.c                    |   3 +
 tools/perf/tests/hists_cumulate.c                  |   8 +-
 tools/perf/tests/hists_filter.c                    |  23 +-
 tools/perf/tests/hists_link.c                      |  23 +-
 tools/perf/tests/hists_output.c                    |  20 +-
 tools/perf/tests/parse-events.c                    |  36 ++
 tools/perf/ui/browsers/header.c                    |   1 +
 tools/perf/ui/browsers/hists.c                     |  52 +-
 tools/perf/ui/gtk/hists.c                          |   2 +-
 tools/perf/util/annotate.c                         |   8 +-
 tools/perf/util/callchain.h                        |   2 +
 tools/perf/util/event.h                            |  26 +
 tools/perf/util/evlist.c                           |  49 +-
 tools/perf/util/evlist.h                           |   2 +
 tools/perf/util/evsel.c                            |  77 ++-
 tools/perf/util/evsel.h                            |  17 +-
 tools/perf/util/hist.c                             |  73 ++-
 tools/perf/util/hist.h                             |  49 +-
 tools/perf/util/include/linux/string.h             |   1 -
 tools/perf/util/machine.c                          |  10 +-
 tools/perf/util/map.c                              |   8 +-
 tools/perf/util/ordered-events.c                   |  49 +-
 tools/perf/util/ordered-events.h                   |  10 +-
 tools/perf/util/parse-events.c                     | 133 ++++-
 tools/perf/util/parse-events.h                     |  14 +
 tools/perf/util/parse-events.l                     |  30 +-
 tools/perf/util/parse-events.y                     |  40 ++
 tools/perf/util/pmu.c                              |  10 -
 tools/perf/util/pmu.h                              |  10 +
 .../util/scripting-engines/trace-event-python.c    |   1 +
 tools/perf/util/session.c                          |  28 +-
 tools/perf/util/session.h                          |   1 -
 tools/perf/util/sort.c                             |   4 +-
 tools/perf/util/string.c                           |  24 -
 tools/perf/util/symbol.c                           |   8 +-
 tools/perf/util/symbol.h                           |   2 +-
 tools/perf/util/thread.c                           |   6 +
 tools/perf/util/thread_map.c                       |  21 +-
 tools/perf/util/thread_map.h                       |   1 +
 tools/perf/util/unwind-libunwind.c                 |  37 +-
 tools/perf/util/unwind.h                           |  17 +
 tools/perf/util/util.c                             |   8 +
 64 files changed, 882 insertions(+), 910 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-events b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
index 7b40a3cbc26a..20979f8b3edb 100644
--- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
@@ -27,575 +27,62 @@ Description:	Generic performance monitoring events
 		"basename".
 
 
-What: 		/sys/devices/cpu/events/PM_1PLUS_PPC_CMPL
-		/sys/devices/cpu/events/PM_BRU_FIN
-		/sys/devices/cpu/events/PM_BR_MPRED
-		/sys/devices/cpu/events/PM_CMPLU_STALL
-		/sys/devices/cpu/events/PM_CMPLU_STALL_BRU
-		/sys/devices/cpu/events/PM_CMPLU_STALL_DCACHE_MISS
-		/sys/devices/cpu/events/PM_CMPLU_STALL_DFU
-		/sys/devices/cpu/events/PM_CMPLU_STALL_DIV
-		/sys/devices/cpu/events/PM_CMPLU_STALL_ERAT_MISS
-		/sys/devices/cpu/events/PM_CMPLU_STALL_FXU
-		/sys/devices/cpu/events/PM_CMPLU_STALL_IFU
-		/sys/devices/cpu/events/PM_CMPLU_STALL_LSU
-		/sys/devices/cpu/events/PM_CMPLU_STALL_REJECT
-		/sys/devices/cpu/events/PM_CMPLU_STALL_SCALAR
-		/sys/devices/cpu/events/PM_CMPLU_STALL_SCALAR_LONG
-		/sys/devices/cpu/events/PM_CMPLU_STALL_STORE
-		/sys/devices/cpu/events/PM_CMPLU_STALL_THRD
-		/sys/devices/cpu/events/PM_CMPLU_STALL_VECTOR
-		/sys/devices/cpu/events/PM_CMPLU_STALL_VECTOR_LONG
-		/sys/devices/cpu/events/PM_CYC
-		/sys/devices/cpu/events/PM_GCT_NOSLOT_BR_MPRED
-		/sys/devices/cpu/events/PM_GCT_NOSLOT_BR_MPRED_IC_MISS
-		/sys/devices/cpu/events/PM_GCT_NOSLOT_CYC
-		/sys/devices/cpu/events/PM_GCT_NOSLOT_IC_MISS
-		/sys/devices/cpu/events/PM_GRP_CMPL
-		/sys/devices/cpu/events/PM_INST_CMPL
-		/sys/devices/cpu/events/PM_LD_MISS_L1
-		/sys/devices/cpu/events/PM_LD_REF_L1
-		/sys/devices/cpu/events/PM_RUN_CYC
-		/sys/devices/cpu/events/PM_RUN_INST_CMPL
-		/sys/devices/cpu/events/PM_IC_DEMAND_L2_BR_ALL
-		/sys/devices/cpu/events/PM_GCT_UTIL_7_TO_10_SLOTS
-		/sys/devices/cpu/events/PM_PMC2_SAVED
-		/sys/devices/cpu/events/PM_VSU0_16FLOP
-		/sys/devices/cpu/events/PM_MRK_LSU_DERAT_MISS
-		/sys/devices/cpu/events/PM_MRK_ST_CMPL
-		/sys/devices/cpu/events/PM_NEST_PAIR3_ADD
-		/sys/devices/cpu/events/PM_L2_ST_DISP
-		/sys/devices/cpu/events/PM_L2_CASTOUT_MOD
-		/sys/devices/cpu/events/PM_ISEG
-		/sys/devices/cpu/events/PM_MRK_INST_TIMEO
-		/sys/devices/cpu/events/PM_L2_RCST_DISP_FAIL_ADDR
-		/sys/devices/cpu/events/PM_LSU1_DC_PREF_STREAM_CONFIRM
-		/sys/devices/cpu/events/PM_IERAT_WR_64K
-		/sys/devices/cpu/events/PM_MRK_DTLB_MISS_16M
-		/sys/devices/cpu/events/PM_IERAT_MISS
-		/sys/devices/cpu/events/PM_MRK_PTEG_FROM_LMEM
-		/sys/devices/cpu/events/PM_FLOP
-		/sys/devices/cpu/events/PM_THRD_PRIO_4_5_CYC
-		/sys/devices/cpu/events/PM_BR_PRED_TA
-		/sys/devices/cpu/events/PM_EXT_INT
-		/sys/devices/cpu/events/PM_VSU_FSQRT_FDIV
-		/sys/devices/cpu/events/PM_MRK_LD_MISS_EXPOSED_CYC
-		/sys/devices/cpu/events/PM_LSU1_LDF
-		/sys/devices/cpu/events/PM_IC_WRITE_ALL
-		/sys/devices/cpu/events/PM_LSU0_SRQ_STFWD
-		/sys/devices/cpu/events/PM_PTEG_FROM_RL2L3_MOD
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_L31_SHR
-		/sys/devices/cpu/events/PM_DATA_FROM_L21_MOD
-		/sys/devices/cpu/events/PM_VSU1_SCAL_DOUBLE_ISSUED
-		/sys/devices/cpu/events/PM_VSU0_8FLOP
-		/sys/devices/cpu/events/PM_POWER_EVENT1
-		/sys/devices/cpu/events/PM_DISP_CLB_HELD_BAL
-		/sys/devices/cpu/events/PM_VSU1_2FLOP
-		/sys/devices/cpu/events/PM_LWSYNC_HELD
-		/sys/devices/cpu/events/PM_PTEG_FROM_DL2L3_SHR
-		/sys/devices/cpu/events/PM_INST_FROM_L21_MOD
-		/sys/devices/cpu/events/PM_IERAT_XLATE_WR_16MPLUS
-		/sys/devices/cpu/events/PM_IC_REQ_ALL
-		/sys/devices/cpu/events/PM_DSLB_MISS
-		/sys/devices/cpu/events/PM_L3_MISS
-		/sys/devices/cpu/events/PM_LSU0_L1_PREF
-		/sys/devices/cpu/events/PM_VSU_SCALAR_SINGLE_ISSUED
-		/sys/devices/cpu/events/PM_LSU1_DC_PREF_STREAM_CONFIRM_STRIDE
-		/sys/devices/cpu/events/PM_L2_INST
-		/sys/devices/cpu/events/PM_VSU0_FRSP
-		/sys/devices/cpu/events/PM_FLUSH_DISP
-		/sys/devices/cpu/events/PM_PTEG_FROM_L2MISS
-		/sys/devices/cpu/events/PM_VSU1_DQ_ISSUED
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_DMEM
-		/sys/devices/cpu/events/PM_LSU_FLUSH_ULD
-		/sys/devices/cpu/events/PM_PTEG_FROM_LMEM
-		/sys/devices/cpu/events/PM_MRK_DERAT_MISS_16M
-		/sys/devices/cpu/events/PM_THRD_ALL_RUN_CYC
-		/sys/devices/cpu/events/PM_MEM0_PREFETCH_DISP
-		/sys/devices/cpu/events/PM_MRK_STALL_CMPLU_CYC_COUNT
-		/sys/devices/cpu/events/PM_DATA_FROM_DL2L3_MOD
-		/sys/devices/cpu/events/PM_VSU_FRSP
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_L21_MOD
-		/sys/devices/cpu/events/PM_PMC1_OVERFLOW
-		/sys/devices/cpu/events/PM_VSU0_SINGLE
-		/sys/devices/cpu/events/PM_MRK_PTEG_FROM_L3MISS
-		/sys/devices/cpu/events/PM_MRK_PTEG_FROM_L31_SHR
-		/sys/devices/cpu/events/PM_VSU0_VECTOR_SP_ISSUED
-		/sys/devices/cpu/events/PM_VSU1_FEST
-		/sys/devices/cpu/events/PM_MRK_INST_DISP
-		/sys/devices/cpu/events/PM_VSU0_COMPLEX_ISSUED
-		/sys/devices/cpu/events/PM_LSU1_FLUSH_UST
-		/sys/devices/cpu/events/PM_FXU_IDLE
-		/sys/devices/cpu/events/PM_LSU0_FLUSH_ULD
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_DL2L3_MOD
-		/sys/devices/cpu/events/PM_LSU_LMQ_SRQ_EMPTY_ALL_CYC
-		/sys/devices/cpu/events/PM_LSU1_REJECT_LMQ_FULL
-		/sys/devices/cpu/events/PM_INST_PTEG_FROM_L21_MOD
-		/sys/devices/cpu/events/PM_INST_FROM_RL2L3_MOD
-		/sys/devices/cpu/events/PM_SHL_CREATED
-		/sys/devices/cpu/events/PM_L2_ST_HIT
-		/sys/devices/cpu/events/PM_DATA_FROM_DMEM
-		/sys/devices/cpu/events/PM_L3_LD_MISS
-		/sys/devices/cpu/events/PM_FXU1_BUSY_FXU0_IDLE
-		/sys/devices/cpu/events/PM_DISP_CLB_HELD_RES
-		/sys/devices/cpu/events/PM_L2_SN_SX_I_DONE
-		/sys/devices/cpu/events/PM_STCX_CMPL
-		/sys/devices/cpu/events/PM_VSU0_2FLOP
-		/sys/devices/cpu/events/PM_L3_PREF_MISS
-		/sys/devices/cpu/events/PM_LSU_SRQ_SYNC_CYC
-		/sys/devices/cpu/events/PM_LSU_REJECT_ERAT_MISS
-		/sys/devices/cpu/events/PM_L1_ICACHE_MISS
-		/sys/devices/cpu/events/PM_LSU1_FLUSH_SRQ
-		/sys/devices/cpu/events/PM_LD_REF_L1_LSU0
-		/sys/devices/cpu/events/PM_VSU0_FEST
-		/sys/devices/cpu/events/PM_VSU_VECTOR_SINGLE_ISSUED
-		/sys/devices/cpu/events/PM_FREQ_UP
-		/sys/devices/cpu/events/PM_DATA_FROM_LMEM
-		/sys/devices/cpu/events/PM_LSU1_LDX
-		/sys/devices/cpu/events/PM_PMC3_OVERFLOW
-		/sys/devices/cpu/events/PM_MRK_BR_MPRED
-		/sys/devices/cpu/events/PM_SHL_MATCH
-		/sys/devices/cpu/events/PM_MRK_BR_TAKEN
-		/sys/devices/cpu/events/PM_ISLB_MISS
-		/sys/devices/cpu/events/PM_DISP_HELD_THERMAL
-		/sys/devices/cpu/events/PM_INST_PTEG_FROM_RL2L3_SHR
-		/sys/devices/cpu/events/PM_LSU1_SRQ_STFWD
-		/sys/devices/cpu/events/PM_PTEG_FROM_DMEM
-		/sys/devices/cpu/events/PM_VSU_2FLOP
-		/sys/devices/cpu/events/PM_GCT_FULL_CYC
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_L3_CYC
-		/sys/devices/cpu/events/PM_LSU_SRQ_S0_ALLOC
-		/sys/devices/cpu/events/PM_MRK_DERAT_MISS_4K
-		/sys/devices/cpu/events/PM_BR_MPRED_TA
-		/sys/devices/cpu/events/PM_INST_PTEG_FROM_L2MISS
-		/sys/devices/cpu/events/PM_DPU_HELD_POWER
-		/sys/devices/cpu/events/PM_MRK_VSU_FIN
-		/sys/devices/cpu/events/PM_LSU_SRQ_S0_VALID
-		/sys/devices/cpu/events/PM_GCT_EMPTY_CYC
-		/sys/devices/cpu/events/PM_IOPS_DISP
-		/sys/devices/cpu/events/PM_RUN_SPURR
-		/sys/devices/cpu/events/PM_PTEG_FROM_L21_MOD
-		/sys/devices/cpu/events/PM_VSU0_1FLOP
-		/sys/devices/cpu/events/PM_SNOOP_TLBIE
-		/sys/devices/cpu/events/PM_DATA_FROM_L3MISS
-		/sys/devices/cpu/events/PM_VSU_SINGLE
-		/sys/devices/cpu/events/PM_DTLB_MISS_16G
-		/sys/devices/cpu/events/PM_FLUSH
-		/sys/devices/cpu/events/PM_L2_LD_HIT
-		/sys/devices/cpu/events/PM_NEST_PAIR2_AND
-		/sys/devices/cpu/events/PM_VSU1_1FLOP
-		/sys/devices/cpu/events/PM_IC_PREF_REQ
-		/sys/devices/cpu/events/PM_L3_LD_HIT
-		/sys/devices/cpu/events/PM_DISP_HELD
-		/sys/devices/cpu/events/PM_L2_LD
-		/sys/devices/cpu/events/PM_LSU_FLUSH_SRQ
-		/sys/devices/cpu/events/PM_BC_PLUS_8_CONV
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_L31_MOD_CYC
-		/sys/devices/cpu/events/PM_L2_RCST_BUSY_RC_FULL
-		/sys/devices/cpu/events/PM_TB_BIT_TRANS
-		/sys/devices/cpu/events/PM_THERMAL_MAX
-		/sys/devices/cpu/events/PM_LSU1_FLUSH_ULD
-		/sys/devices/cpu/events/PM_LSU1_REJECT_LHS
-		/sys/devices/cpu/events/PM_LSU_LRQ_S0_ALLOC
-		/sys/devices/cpu/events/PM_L3_CO_L31
-		/sys/devices/cpu/events/PM_POWER_EVENT4
-		/sys/devices/cpu/events/PM_DATA_FROM_L31_SHR
-		/sys/devices/cpu/events/PM_BR_UNCOND
-		/sys/devices/cpu/events/PM_LSU1_DC_PREF_STREAM_ALLOC
-		/sys/devices/cpu/events/PM_PMC4_REWIND
-		/sys/devices/cpu/events/PM_L2_RCLD_DISP
-		/sys/devices/cpu/events/PM_THRD_PRIO_2_3_CYC
-		/sys/devices/cpu/events/PM_MRK_PTEG_FROM_L2MISS
-		/sys/devices/cpu/events/PM_IC_DEMAND_L2_BHT_REDIRECT
-		/sys/devices/cpu/events/PM_DATA_FROM_L31_SHR
-		/sys/devices/cpu/events/PM_IC_PREF_CANCEL_L2
-		/sys/devices/cpu/events/PM_MRK_FIN_STALL_CYC_COUNT
-		/sys/devices/cpu/events/PM_BR_PRED_CCACHE
-		/sys/devices/cpu/events/PM_GCT_UTIL_1_TO_2_SLOTS
-		/sys/devices/cpu/events/PM_MRK_ST_CMPL_INT
-		/sys/devices/cpu/events/PM_LSU_TWO_TABLEWALK_CYC
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_L3MISS
-		/sys/devices/cpu/events/PM_LSU_SET_MPRED
-		/sys/devices/cpu/events/PM_FLUSH_DISP_TLBIE
-		/sys/devices/cpu/events/PM_VSU1_FCONV
-		/sys/devices/cpu/events/PM_DERAT_MISS_16G
-		/sys/devices/cpu/events/PM_INST_FROM_LMEM
-		/sys/devices/cpu/events/PM_IC_DEMAND_L2_BR_REDIRECT
-		/sys/devices/cpu/events/PM_INST_PTEG_FROM_L2
-		/sys/devices/cpu/events/PM_PTEG_FROM_L2
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_L21_SHR_CYC
-		/sys/devices/cpu/events/PM_MRK_DTLB_MISS_4K
-		/sys/devices/cpu/events/PM_VSU0_FPSCR
-		/sys/devices/cpu/events/PM_VSU1_VECT_DOUBLE_ISSUED
-		/sys/devices/cpu/events/PM_MRK_PTEG_FROM_RL2L3_MOD
-		/sys/devices/cpu/events/PM_MEM0_RQ_DISP
-		/sys/devices/cpu/events/PM_L2_LD_MISS
-		/sys/devices/cpu/events/PM_VMX_RESULT_SAT_1
-		/sys/devices/cpu/events/PM_L1_PREF
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_LMEM_CYC
-		/sys/devices/cpu/events/PM_GRP_IC_MISS_NONSPEC
-		/sys/devices/cpu/events/PM_PB_NODE_PUMP
-		/sys/devices/cpu/events/PM_SHL_MERGED
-		/sys/devices/cpu/events/PM_NEST_PAIR1_ADD
-		/sys/devices/cpu/events/PM_DATA_FROM_L3
-		/sys/devices/cpu/events/PM_LSU_FLUSH
-		/sys/devices/cpu/events/PM_LSU_SRQ_SYNC_COUNT
-		/sys/devices/cpu/events/PM_PMC2_OVERFLOW
-		/sys/devices/cpu/events/PM_LSU_LDF
-		/sys/devices/cpu/events/PM_POWER_EVENT3
-		/sys/devices/cpu/events/PM_DISP_WT
-		/sys/devices/cpu/events/PM_IC_BANK_CONFLICT
-		/sys/devices/cpu/events/PM_BR_MPRED_CR_TA
-		/sys/devices/cpu/events/PM_L2_INST_MISS
-		/sys/devices/cpu/events/PM_NEST_PAIR2_ADD
-		/sys/devices/cpu/events/PM_MRK_LSU_FLUSH
-		/sys/devices/cpu/events/PM_L2_LDST
-		/sys/devices/cpu/events/PM_INST_FROM_L31_SHR
-		/sys/devices/cpu/events/PM_VSU0_FIN
-		/sys/devices/cpu/events/PM_VSU1_FCONV
-		/sys/devices/cpu/events/PM_INST_FROM_RMEM
-		/sys/devices/cpu/events/PM_DISP_CLB_HELD_TLBIE
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_DMEM_CYC
-		/sys/devices/cpu/events/PM_BR_PRED_CR
-		/sys/devices/cpu/events/PM_LSU_REJECT
-		/sys/devices/cpu/events/PM_GCT_UTIL_3_TO_6_SLOTS
-		/sys/devices/cpu/events/PM_CMPLU_STALL_END_GCT_NOSLOT
-		/sys/devices/cpu/events/PM_LSU0_REJECT_LMQ_FULL
-		/sys/devices/cpu/events/PM_VSU_FEST
-		/sys/devices/cpu/events/PM_NEST_PAIR0_AND
-		/sys/devices/cpu/events/PM_PTEG_FROM_L3
-		/sys/devices/cpu/events/PM_POWER_EVENT2
-		/sys/devices/cpu/events/PM_IC_PREF_CANCEL_PAGE
-		/sys/devices/cpu/events/PM_VSU0_FSQRT_FDIV
-		/sys/devices/cpu/events/PM_MRK_GRP_CMPL
-		/sys/devices/cpu/events/PM_VSU0_SCAL_DOUBLE_ISSUED
-		/sys/devices/cpu/events/PM_GRP_DISP
-		/sys/devices/cpu/events/PM_LSU0_LDX
-		/sys/devices/cpu/events/PM_DATA_FROM_L2
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_RL2L3_MOD
-		/sys/devices/cpu/events/PM_VSU0_VECT_DOUBLE_ISSUED
-		/sys/devices/cpu/events/PM_VSU1_2FLOP_DOUBLE
-		/sys/devices/cpu/events/PM_THRD_PRIO_6_7_CYC
-		/sys/devices/cpu/events/PM_BC_PLUS_8_RSLV_TAKEN
-		/sys/devices/cpu/events/PM_BR_MPRED_CR
-		/sys/devices/cpu/events/PM_L3_CO_MEM
-		/sys/devices/cpu/events/PM_DATA_FROM_RL2L3_MOD
-		/sys/devices/cpu/events/PM_LSU_SRQ_FULL_CYC
-		/sys/devices/cpu/events/PM_TABLEWALK_CYC
-		/sys/devices/cpu/events/PM_MRK_PTEG_FROM_RMEM
-		/sys/devices/cpu/events/PM_LSU_SRQ_STFWD
-		/sys/devices/cpu/events/PM_INST_PTEG_FROM_RMEM
-		/sys/devices/cpu/events/PM_FXU0_FIN
-		/sys/devices/cpu/events/PM_LSU1_L1_SW_PREF
-		/sys/devices/cpu/events/PM_PTEG_FROM_L31_MOD
-		/sys/devices/cpu/events/PM_PMC5_OVERFLOW
-		/sys/devices/cpu/events/PM_LD_REF_L1_LSU1
-		/sys/devices/cpu/events/PM_INST_PTEG_FROM_L21_SHR
-		/sys/devices/cpu/events/PM_DATA_FROM_RMEM
-		/sys/devices/cpu/events/PM_VSU0_SCAL_SINGLE_ISSUED
-		/sys/devices/cpu/events/PM_BR_MPRED_LSTACK
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_RL2L3_MOD_CYC
-		/sys/devices/cpu/events/PM_LSU0_FLUSH_UST
-		/sys/devices/cpu/events/PM_LSU_NCST
-		/sys/devices/cpu/events/PM_BR_TAKEN
-		/sys/devices/cpu/events/PM_INST_PTEG_FROM_LMEM
-		/sys/devices/cpu/events/PM_DTLB_MISS_4K
-		/sys/devices/cpu/events/PM_PMC4_SAVED
-		/sys/devices/cpu/events/PM_VSU1_PERMUTE_ISSUED
-		/sys/devices/cpu/events/PM_SLB_MISS
-		/sys/devices/cpu/events/PM_LSU1_FLUSH_LRQ
-		/sys/devices/cpu/events/PM_DTLB_MISS
-		/sys/devices/cpu/events/PM_VSU1_FRSP
-		/sys/devices/cpu/events/PM_VSU_VECTOR_DOUBLE_ISSUED
-		/sys/devices/cpu/events/PM_L2_CASTOUT_SHR
-		/sys/devices/cpu/events/PM_DATA_FROM_DL2L3_SHR
-		/sys/devices/cpu/events/PM_VSU1_STF
-		/sys/devices/cpu/events/PM_ST_FIN
-		/sys/devices/cpu/events/PM_PTEG_FROM_L21_SHR
-		/sys/devices/cpu/events/PM_L2_LOC_GUESS_WRONG
-		/sys/devices/cpu/events/PM_MRK_STCX_FAIL
-		/sys/devices/cpu/events/PM_LSU0_REJECT_LHS
-		/sys/devices/cpu/events/PM_IC_PREF_CANCEL_HIT
-		/sys/devices/cpu/events/PM_L3_PREF_BUSY
-		/sys/devices/cpu/events/PM_MRK_BRU_FIN
-		/sys/devices/cpu/events/PM_LSU1_NCLD
-		/sys/devices/cpu/events/PM_INST_PTEG_FROM_L31_MOD
-		/sys/devices/cpu/events/PM_LSU_NCLD
-		/sys/devices/cpu/events/PM_LSU_LDX
-		/sys/devices/cpu/events/PM_L2_LOC_GUESS_CORRECT
-		/sys/devices/cpu/events/PM_THRESH_TIMEO
-		/sys/devices/cpu/events/PM_L3_PREF_ST
-		/sys/devices/cpu/events/PM_DISP_CLB_HELD_SYNC
-		/sys/devices/cpu/events/PM_VSU_SIMPLE_ISSUED
-		/sys/devices/cpu/events/PM_VSU1_SINGLE
-		/sys/devices/cpu/events/PM_DATA_TABLEWALK_CYC
-		/sys/devices/cpu/events/PM_L2_RC_ST_DONE
-		/sys/devices/cpu/events/PM_MRK_PTEG_FROM_L21_MOD
-		/sys/devices/cpu/events/PM_LARX_LSU1
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_RMEM
-		/sys/devices/cpu/events/PM_DISP_CLB_HELD
-		/sys/devices/cpu/events/PM_DERAT_MISS_4K
-		/sys/devices/cpu/events/PM_L2_RCLD_DISP_FAIL_ADDR
-		/sys/devices/cpu/events/PM_SEG_EXCEPTION
-		/sys/devices/cpu/events/PM_FLUSH_DISP_SB
-		/sys/devices/cpu/events/PM_L2_DC_INV
-		/sys/devices/cpu/events/PM_PTEG_FROM_DL2L3_MOD
-		/sys/devices/cpu/events/PM_DSEG
-		/sys/devices/cpu/events/PM_BR_PRED_LSTACK
-		/sys/devices/cpu/events/PM_VSU0_STF
-		/sys/devices/cpu/events/PM_LSU_FX_FIN
-		/sys/devices/cpu/events/PM_DERAT_MISS_16M
-		/sys/devices/cpu/events/PM_MRK_PTEG_FROM_DL2L3_MOD
-		/sys/devices/cpu/events/PM_GCT_UTIL_11_PLUS_SLOTS
-		/sys/devices/cpu/events/PM_INST_FROM_L3
-		/sys/devices/cpu/events/PM_MRK_IFU_FIN
-		/sys/devices/cpu/events/PM_ITLB_MISS
-		/sys/devices/cpu/events/PM_VSU_STF
-		/sys/devices/cpu/events/PM_LSU_FLUSH_UST
-		/sys/devices/cpu/events/PM_L2_LDST_MISS
-		/sys/devices/cpu/events/PM_FXU1_FIN
-		/sys/devices/cpu/events/PM_SHL_DEALLOCATED
-		/sys/devices/cpu/events/PM_L2_SN_M_WR_DONE
-		/sys/devices/cpu/events/PM_LSU_REJECT_SET_MPRED
-		/sys/devices/cpu/events/PM_L3_PREF_LD
-		/sys/devices/cpu/events/PM_L2_SN_M_RD_DONE
-		/sys/devices/cpu/events/PM_MRK_DERAT_MISS_16G
-		/sys/devices/cpu/events/PM_VSU_FCONV
-		/sys/devices/cpu/events/PM_ANY_THRD_RUN_CYC
-		/sys/devices/cpu/events/PM_LSU_LMQ_FULL_CYC
-		/sys/devices/cpu/events/PM_MRK_LSU_REJECT_LHS
-		/sys/devices/cpu/events/PM_MRK_LD_MISS_L1_CYC
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_L2_CYC
-		/sys/devices/cpu/events/PM_INST_IMC_MATCH_DISP
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_RMEM_CYC
-		/sys/devices/cpu/events/PM_VSU0_SIMPLE_ISSUED
-		/sys/devices/cpu/events/PM_MRK_PTEG_FROM_RL2L3_SHR
-		/sys/devices/cpu/events/PM_VSU_FMA_DOUBLE
-		/sys/devices/cpu/events/PM_VSU_4FLOP
-		/sys/devices/cpu/events/PM_VSU1_FIN
-		/sys/devices/cpu/events/PM_NEST_PAIR1_AND
-		/sys/devices/cpu/events/PM_INST_PTEG_FROM_RL2L3_MOD
-		/sys/devices/cpu/events/PM_PTEG_FROM_RMEM
-		/sys/devices/cpu/events/PM_LSU_LRQ_S0_VALID
-		/sys/devices/cpu/events/PM_LSU0_LDF
-		/sys/devices/cpu/events/PM_FLUSH_COMPLETION
-		/sys/devices/cpu/events/PM_ST_MISS_L1
-		/sys/devices/cpu/events/PM_L2_NODE_PUMP
-		/sys/devices/cpu/events/PM_INST_FROM_DL2L3_SHR
-		/sys/devices/cpu/events/PM_MRK_STALL_CMPLU_CYC
-		/sys/devices/cpu/events/PM_VSU1_DENORM
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_L31_SHR_CYC
-		/sys/devices/cpu/events/PM_NEST_PAIR0_ADD
-		/sys/devices/cpu/events/PM_INST_FROM_L3MISS
-		/sys/devices/cpu/events/PM_EE_OFF_EXT_INT
-		/sys/devices/cpu/events/PM_INST_PTEG_FROM_DMEM
-		/sys/devices/cpu/events/PM_INST_FROM_DL2L3_MOD
-		/sys/devices/cpu/events/PM_PMC6_OVERFLOW
-		/sys/devices/cpu/events/PM_VSU_2FLOP_DOUBLE
-		/sys/devices/cpu/events/PM_TLB_MISS
-		/sys/devices/cpu/events/PM_FXU_BUSY
-		/sys/devices/cpu/events/PM_L2_RCLD_DISP_FAIL_OTHER
-		/sys/devices/cpu/events/PM_LSU_REJECT_LMQ_FULL
-		/sys/devices/cpu/events/PM_IC_RELOAD_SHR
-		/sys/devices/cpu/events/PM_GRP_MRK
-		/sys/devices/cpu/events/PM_MRK_ST_NEST
-		/sys/devices/cpu/events/PM_VSU1_FSQRT_FDIV
-		/sys/devices/cpu/events/PM_LSU0_FLUSH_LRQ
-		/sys/devices/cpu/events/PM_LARX_LSU0
-		/sys/devices/cpu/events/PM_IBUF_FULL_CYC
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_DL2L3_SHR_CYC
-		/sys/devices/cpu/events/PM_LSU_DC_PREF_STREAM_ALLOC
-		/sys/devices/cpu/events/PM_GRP_MRK_CYC
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_RL2L3_SHR_CYC
-		/sys/devices/cpu/events/PM_L2_GLOB_GUESS_CORRECT
-		/sys/devices/cpu/events/PM_LSU_REJECT_LHS
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_LMEM
-		/sys/devices/cpu/events/PM_INST_PTEG_FROM_L3
-		/sys/devices/cpu/events/PM_FREQ_DOWN
-		/sys/devices/cpu/events/PM_PB_RETRY_NODE_PUMP
-		/sys/devices/cpu/events/PM_INST_FROM_RL2L3_SHR
-		/sys/devices/cpu/events/PM_MRK_INST_ISSUED
-		/sys/devices/cpu/events/PM_PTEG_FROM_L3MISS
-		/sys/devices/cpu/events/PM_RUN_PURR
-		/sys/devices/cpu/events/PM_MRK_GRP_IC_MISS
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_L3
-		/sys/devices/cpu/events/PM_PTEG_FROM_RL2L3_SHR
-		/sys/devices/cpu/events/PM_LSU_FLUSH_LRQ
-		/sys/devices/cpu/events/PM_MRK_DERAT_MISS_64K
-		/sys/devices/cpu/events/PM_INST_PTEG_FROM_DL2L3_MOD
-		/sys/devices/cpu/events/PM_L2_ST_MISS
-		/sys/devices/cpu/events/PM_MRK_PTEG_FROM_L21_SHR
-		/sys/devices/cpu/events/PM_LWSYNC
-		/sys/devices/cpu/events/PM_LSU0_DC_PREF_STREAM_CONFIRM_STRIDE
-		/sys/devices/cpu/events/PM_MRK_LSU_FLUSH_LRQ
-		/sys/devices/cpu/events/PM_INST_IMC_MATCH_CMPL
-		/sys/devices/cpu/events/PM_NEST_PAIR3_AND
-		/sys/devices/cpu/events/PM_PB_RETRY_SYS_PUMP
-		/sys/devices/cpu/events/PM_MRK_INST_FIN
-		/sys/devices/cpu/events/PM_MRK_PTEG_FROM_DL2L3_SHR
-		/sys/devices/cpu/events/PM_INST_FROM_L31_MOD
-		/sys/devices/cpu/events/PM_MRK_DTLB_MISS_64K
-		/sys/devices/cpu/events/PM_LSU_FIN
-		/sys/devices/cpu/events/PM_MRK_LSU_REJECT
-		/sys/devices/cpu/events/PM_L2_CO_FAIL_BUSY
-		/sys/devices/cpu/events/PM_MEM0_WQ_DISP
-		/sys/devices/cpu/events/PM_DATA_FROM_L31_MOD
-		/sys/devices/cpu/events/PM_THERMAL_WARN
-		/sys/devices/cpu/events/PM_VSU0_4FLOP
-		/sys/devices/cpu/events/PM_BR_MPRED_CCACHE
-		/sys/devices/cpu/events/PM_L1_DEMAND_WRITE
-		/sys/devices/cpu/events/PM_FLUSH_BR_MPRED
-		/sys/devices/cpu/events/PM_MRK_DTLB_MISS_16G
-		/sys/devices/cpu/events/PM_MRK_PTEG_FROM_DMEM
-		/sys/devices/cpu/events/PM_L2_RCST_DISP
-		/sys/devices/cpu/events/PM_LSU_PARTIAL_CDF
-		/sys/devices/cpu/events/PM_DISP_CLB_HELD_SB
-		/sys/devices/cpu/events/PM_VSU0_FMA_DOUBLE
-		/sys/devices/cpu/events/PM_FXU0_BUSY_FXU1_IDLE
-		/sys/devices/cpu/events/PM_IC_DEMAND_CYC
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_L21_SHR
-		/sys/devices/cpu/events/PM_MRK_LSU_FLUSH_UST
-		/sys/devices/cpu/events/PM_INST_PTEG_FROM_L3MISS
-		/sys/devices/cpu/events/PM_VSU_DENORM
-		/sys/devices/cpu/events/PM_MRK_LSU_PARTIAL_CDF
-		/sys/devices/cpu/events/PM_INST_FROM_L21_SHR
-		/sys/devices/cpu/events/PM_IC_PREF_WRITE
-		/sys/devices/cpu/events/PM_BR_PRED
-		/sys/devices/cpu/events/PM_INST_FROM_DMEM
-		/sys/devices/cpu/events/PM_IC_PREF_CANCEL_ALL
-		/sys/devices/cpu/events/PM_LSU_DC_PREF_STREAM_CONFIRM
-		/sys/devices/cpu/events/PM_MRK_LSU_FLUSH_SRQ
-		/sys/devices/cpu/events/PM_MRK_FIN_STALL_CYC
-		/sys/devices/cpu/events/PM_L2_RCST_DISP_FAIL_OTHER
-		/sys/devices/cpu/events/PM_VSU1_DD_ISSUED
-		/sys/devices/cpu/events/PM_PTEG_FROM_L31_SHR
-		/sys/devices/cpu/events/PM_DATA_FROM_L21_SHR
-		/sys/devices/cpu/events/PM_LSU0_NCLD
-		/sys/devices/cpu/events/PM_VSU1_4FLOP
-		/sys/devices/cpu/events/PM_VSU1_8FLOP
-		/sys/devices/cpu/events/PM_VSU_8FLOP
-		/sys/devices/cpu/events/PM_LSU_LMQ_SRQ_EMPTY_CYC
-		/sys/devices/cpu/events/PM_DTLB_MISS_64K
-		/sys/devices/cpu/events/PM_THRD_CONC_RUN_INST
-		/sys/devices/cpu/events/PM_MRK_PTEG_FROM_L2
-		/sys/devices/cpu/events/PM_PB_SYS_PUMP
-		/sys/devices/cpu/events/PM_VSU_FIN
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_L31_MOD
-		/sys/devices/cpu/events/PM_THRD_PRIO_0_1_CYC
-		/sys/devices/cpu/events/PM_DERAT_MISS_64K
-		/sys/devices/cpu/events/PM_PMC2_REWIND
-		/sys/devices/cpu/events/PM_INST_FROM_L2
-		/sys/devices/cpu/events/PM_GRP_BR_MPRED_NONSPEC
-		/sys/devices/cpu/events/PM_INST_DISP
-		/sys/devices/cpu/events/PM_MEM0_RD_CANCEL_TOTAL
-		/sys/devices/cpu/events/PM_LSU0_DC_PREF_STREAM_CONFIRM
-		/sys/devices/cpu/events/PM_L1_DCACHE_RELOAD_VALID
-		/sys/devices/cpu/events/PM_VSU_SCALAR_DOUBLE_ISSUED
-		/sys/devices/cpu/events/PM_L3_PREF_HIT
-		/sys/devices/cpu/events/PM_MRK_PTEG_FROM_L31_MOD
-		/sys/devices/cpu/events/PM_MRK_FXU_FIN
-		/sys/devices/cpu/events/PM_PMC4_OVERFLOW
-		/sys/devices/cpu/events/PM_MRK_PTEG_FROM_L3
-		/sys/devices/cpu/events/PM_LSU0_LMQ_LHR_MERGE
-		/sys/devices/cpu/events/PM_BTAC_HIT
-		/sys/devices/cpu/events/PM_L3_RD_BUSY
-		/sys/devices/cpu/events/PM_LSU0_L1_SW_PREF
-		/sys/devices/cpu/events/PM_INST_FROM_L2MISS
-		/sys/devices/cpu/events/PM_LSU0_DC_PREF_STREAM_ALLOC
-		/sys/devices/cpu/events/PM_L2_ST
-		/sys/devices/cpu/events/PM_VSU0_DENORM
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_DL2L3_SHR
-		/sys/devices/cpu/events/PM_BR_PRED_CR_TA
-		/sys/devices/cpu/events/PM_VSU0_FCONV
-		/sys/devices/cpu/events/PM_MRK_LSU_FLUSH_ULD
-		/sys/devices/cpu/events/PM_BTAC_MISS
-		/sys/devices/cpu/events/PM_MRK_LD_MISS_EXPOSED_CYC_COUNT
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_L2
-		/sys/devices/cpu/events/PM_LSU_DCACHE_RELOAD_VALID
-		/sys/devices/cpu/events/PM_VSU_FMA
-		/sys/devices/cpu/events/PM_LSU0_FLUSH_SRQ
-		/sys/devices/cpu/events/PM_LSU1_L1_PREF
-		/sys/devices/cpu/events/PM_IOPS_CMPL
-		/sys/devices/cpu/events/PM_L2_SYS_PUMP
-		/sys/devices/cpu/events/PM_L2_RCLD_BUSY_RC_FULL
-		/sys/devices/cpu/events/PM_LSU_LMQ_S0_ALLOC
-		/sys/devices/cpu/events/PM_FLUSH_DISP_SYNC
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_DL2L3_MOD_CYC
-		/sys/devices/cpu/events/PM_L2_IC_INV
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_L21_MOD_CYC
-		/sys/devices/cpu/events/PM_L3_PREF_LDST
-		/sys/devices/cpu/events/PM_LSU_SRQ_EMPTY_CYC
-		/sys/devices/cpu/events/PM_LSU_LMQ_S0_VALID
-		/sys/devices/cpu/events/PM_FLUSH_PARTIAL
-		/sys/devices/cpu/events/PM_VSU1_FMA_DOUBLE
-		/sys/devices/cpu/events/PM_1PLUS_PPC_DISP
-		/sys/devices/cpu/events/PM_DATA_FROM_L2MISS
-		/sys/devices/cpu/events/PM_SUSPENDED
-		/sys/devices/cpu/events/PM_VSU0_FMA
-		/sys/devices/cpu/events/PM_STCX_FAIL
-		/sys/devices/cpu/events/PM_VSU0_FSQRT_FDIV_DOUBLE
-		/sys/devices/cpu/events/PM_DC_PREF_DST
-		/sys/devices/cpu/events/PM_VSU1_SCAL_SINGLE_ISSUED
-		/sys/devices/cpu/events/PM_L3_HIT
-		/sys/devices/cpu/events/PM_L2_GLOB_GUESS_WRONG
-		/sys/devices/cpu/events/PM_MRK_DFU_FIN
-		/sys/devices/cpu/events/PM_INST_FROM_L1
-		/sys/devices/cpu/events/PM_IC_DEMAND_REQ
-		/sys/devices/cpu/events/PM_VSU1_FSQRT_FDIV_DOUBLE
-		/sys/devices/cpu/events/PM_VSU1_FMA
-		/sys/devices/cpu/events/PM_MRK_LD_MISS_L1
-		/sys/devices/cpu/events/PM_VSU0_2FLOP_DOUBLE
-		/sys/devices/cpu/events/PM_LSU_DC_PREF_STRIDED_STREAM_CONFIRM
-		/sys/devices/cpu/events/PM_INST_PTEG_FROM_L31_SHR
-		/sys/devices/cpu/events/PM_MRK_LSU_REJECT_ERAT_MISS
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_L2MISS
-		/sys/devices/cpu/events/PM_DATA_FROM_RL2L3_SHR
-		/sys/devices/cpu/events/PM_INST_FROM_PREF
-		/sys/devices/cpu/events/PM_VSU1_SQ
-		/sys/devices/cpu/events/PM_L2_LD_DISP
-		/sys/devices/cpu/events/PM_L2_DISP_ALL
-		/sys/devices/cpu/events/PM_THRD_GRP_CMPL_BOTH_CYC
-		/sys/devices/cpu/events/PM_VSU_FSQRT_FDIV_DOUBLE
-		/sys/devices/cpu/events/PM_INST_PTEG_FROM_DL2L3_SHR
-		/sys/devices/cpu/events/PM_VSU_1FLOP
-		/sys/devices/cpu/events/PM_HV_CYC
-		/sys/devices/cpu/events/PM_MRK_LSU_FIN
-		/sys/devices/cpu/events/PM_MRK_DATA_FROM_RL2L3_SHR
-		/sys/devices/cpu/events/PM_DTLB_MISS_16M
-		/sys/devices/cpu/events/PM_LSU1_LMQ_LHR_MERGE
-		/sys/devices/cpu/events/PM_IFU_FIN
-		/sys/devices/cpu/events/PM_1THRD_CON_RUN_INSTR
-		/sys/devices/cpu/events/PM_CMPLU_STALL_COUNT
-		/sys/devices/cpu/events/PM_MEM0_PB_RD_CL
-		/sys/devices/cpu/events/PM_THRD_1_RUN_CYC
-		/sys/devices/cpu/events/PM_THRD_2_CONC_RUN_INSTR
-		/sys/devices/cpu/events/PM_THRD_2_RUN_CYC
-		/sys/devices/cpu/events/PM_THRD_3_CONC_RUN_INST
-		/sys/devices/cpu/events/PM_THRD_3_RUN_CYC
-		/sys/devices/cpu/events/PM_THRD_4_CONC_RUN_INST
-		/sys/devices/cpu/events/PM_THRD_4_RUN_CYC
+What: /sys/bus/event_source/devices/<pmu>/events/<event>
+Date: 2014/02/24
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	Per-pmu performance monitoring events specific to the running system
 
-Date:		2013/01/08
+		Each file (except for some of those with a '.' in them, '.unit'
+		and '.scale') in the 'events' directory describes a single
+		performance monitoring event supported by the <pmu>. The name
+		of the file is the name of the event.
+
+		File contents:
+
+			<term>[=<value>][,<term>[=<value>]]...
+
+		Where <term> is one of the terms listed under
+		/sys/bus/event_source/devices/<pmu>/format/ and <value> is
+		a number is base-16 format with a '0x' prefix (lowercase only).
+		If a <term> is specified alone (without an assigned value), it
+		is implied that 0x1 is assigned to that <term>.
 
+		Examples (each of these lines would be in a seperate file):
+
+			event=0x2abc
+			event=0x423,inv,cmask=0x3
+			domain=0x1,offset=0x8,starting_index=0xffff
+
+		Each of the assignments indicates a value to be assigned to a
+		particular set of bits (as defined by the format file
+		corresponding to the <term>) in the perf_event structure passed
+		to the perf_open syscall.
+
+What: /sys/bus/event_source/devices/<pmu>/events/<event>.unit
+Date: 2014/02/24
 Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
-		Linux Powerpc mailing list <linuxppc-dev@ozlabs.org>
+Description:	Perf event units
 
-Description:	POWER-systems specific performance monitoring events
+		A string specifying the English plural numerical unit that <event>
+		(once multiplied by <event>.scale) represents.
 
-		A collection of performance monitoring events that may be
-		supported by the POWER CPU. These events can be monitored
-		using the 'perf(1)' tool.
+		Example:
 
-		These events may not be supported by other CPUs.
+			Joules
 
-		The contents of each file would look like:
+What: /sys/bus/event_source/devices/<pmu>/events/<event>.scale
+Date: 2014/02/24
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	Perf event scaling factors
 
-			event=0xNNNN
+		A string representing a floating point value expressed in
+		scientific notation to be multiplied by the event count
+		recieved from the kernel to match the unit specified in the
+		<event>.unit file.
 
-		where 'N' is a hex digit and the number '0xNNNN' shows the
-		"raw code" for the perf event identified by the file's
-		"basename".
+		Example:
+
+			2.3283064365386962890625e-10
 
-		Further, multiple terms like 'event=0xNNNN' can be specified
-		and separated with comma. All available terms are defined in
-		the /sys/bus/event_source/devices/<dev>/format file.
+		This is provided to avoid performing floating point arithmetic
+		in the kernel.
diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index 53cdfb2857ab..4421b5da409d 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -27,7 +27,6 @@
 #include <asm/insn.h>
 
 #define  __ARCH_WANT_KPROBES_INSN_SLOT
-#define  ARCH_SUPPORTS_KPROBES_ON_FTRACE
 
 struct pt_regs;
 struct kprobe;
diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index b3b8abae62b8..e463caa3eb49 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -196,10 +196,10 @@ wdiff:WEIGHT-B,WEIGHT-A
 
   - period being the hist entry period value
 
-  - WEIGHT-A/WEIGHT-B being user suplied weights in the the '-c' option
+  - WEIGHT-A/WEIGHT-B being user supplied weights in the the '-c' option
     behind ':' separator like '-c wdiff:1,2'.
-    - WIEGHT-A being the weight of the data file
-    - WIEGHT-B being the weight of the baseline data file
+    - WEIGHT-A being the weight of the data file
+    - WEIGHT-B being the weight of the baseline data file
 
 SEE ALSO
 --------
diff --git a/tools/perf/Documentation/perf-kvm.txt b/tools/perf/Documentation/perf-kvm.txt
index 6e689dc89a2f..6252e776009c 100644
--- a/tools/perf/Documentation/perf-kvm.txt
+++ b/tools/perf/Documentation/perf-kvm.txt
@@ -100,7 +100,7 @@ OPTIONS
 STAT REPORT OPTIONS
 -------------------
 --vcpu=<value>::
-       analyze events which occures on this vcpu. (default: all vcpus)
+       analyze events which occur on this vcpu. (default: all vcpus)
 
 --event=<value>::
        event to be analyzed. Possible values: vmexit, mmio (x86 only),
@@ -134,7 +134,7 @@ STAT LIVE OPTIONS
     Analyze events only for given process ID(s) (comma separated list).
 
 --vcpu=<value>::
-       analyze events which occures on this vcpu. (default: all vcpus)
+       analyze events which occur on this vcpu. (default: all vcpus)
 
 
 --event=<value>::
diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index 6fce6a622206..cbb4f743d921 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -19,7 +19,7 @@ various perf commands with the -e option.
 EVENT MODIFIERS
 ---------------
 
-Events can optionally have a modifer by appending a colon and one or
+Events can optionally have a modifier by appending a colon and one or
 more modifiers. Modifiers allow the user to restrict the events to be
 counted. The following modifiers exist:
 
diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index d460049cae8e..398f8d53bd6d 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -146,7 +146,7 @@ the thread executes on the designated CPUs. Default is to monitor all CPUs.
 
 -N::
 --no-buildid-cache::
-Do not update the builid cache. This saves some overhead in situations
+Do not update the buildid cache. This saves some overhead in situations
 where the information in the perf.data file (which includes buildids)
 is sufficient.
 
diff --git a/tools/perf/Documentation/perf-script-perl.txt b/tools/perf/Documentation/perf-script-perl.txt
index d00bef231340..dfbb506d2c34 100644
--- a/tools/perf/Documentation/perf-script-perl.txt
+++ b/tools/perf/Documentation/perf-script-perl.txt
@@ -181,8 +181,8 @@ strings for flag and symbolic fields.  These correspond to the strings
 and values parsed from the 'print fmt' fields of the event format
 files:
 
-  flag_str($event_name, $field_name, $field_value) - returns the string represention corresponding to $field_value for the flag field $field_name of event $event_name
-  symbol_str($event_name, $field_name, $field_value) - returns the string represention corresponding to $field_value for the symbolic field $field_name of event $event_name
+  flag_str($event_name, $field_name, $field_value) - returns the string representation corresponding to $field_value for the flag field $field_name of event $event_name
+  symbol_str($event_name, $field_name, $field_value) - returns the string representation corresponding to $field_value for the symbolic field $field_name of event $event_name
 
 Perf::Trace::Context Module
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~
diff --git a/tools/perf/Documentation/perf-script-python.txt b/tools/perf/Documentation/perf-script-python.txt
index 9f1f054b8432..54acba221558 100644
--- a/tools/perf/Documentation/perf-script-python.txt
+++ b/tools/perf/Documentation/perf-script-python.txt
@@ -263,7 +263,7 @@ and having the counts we've tallied as values.
 
 The print_syscall_totals() function iterates over the entries in the
 dictionary and displays a line for each entry containing the syscall
-name (the dictonary keys contain the syscall ids, which are passed to
+name (the dictionary keys contain the syscall ids, which are passed to
 the Util function syscall_name(), which translates the raw syscall
 numbers to the corresponding syscall name strings).  The output is
 displayed after all the events in the trace have been processed, by
@@ -576,8 +576,8 @@ strings for flag and symbolic fields.  These correspond to the strings
 and values parsed from the 'print fmt' fields of the event format
 files:
 
-  flag_str(event_name, field_name, field_value) - returns the string represention corresponding to field_value for the flag field field_name of event event_name
-  symbol_str(event_name, field_name, field_value) - returns the string represention corresponding to field_value for the symbolic field field_name of event event_name
+  flag_str(event_name, field_name, field_value) - returns the string representation corresponding to field_value for the flag field field_name of event event_name
+  symbol_str(event_name, field_name, field_value) - returns the string representation corresponding to field_value for the symbolic field field_name of event event_name
 
 The *autodict* function returns a special kind of Python
 dictionary that implements Perl's 'autovivifying' hashes in Python
diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index 05f9a0a6784c..21494806c0ab 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -115,7 +115,7 @@ OPTIONS
 -f::
 --fields::
         Comma separated list of fields to print. Options are:
-        comm, tid, pid, time, cpu, event, trace, ip, sym, dso, addr, symoff, srcline.
+        comm, tid, pid, time, cpu, event, trace, ip, sym, dso, addr, symoff, srcline, period.
         Field list can be prepended with the type, trace, sw or hw,
         to indicate to which event type the field list applies.
         e.g., -f sw:comm,tid,time,ip,sym  and -f trace:time,cpu,trace
@@ -140,7 +140,7 @@ OPTIONS
     
 		"Overriding previous field request for all events."
     
-	Alternativey, consider the order:
+	Alternatively, consider the order:
     
 		-f comm,tid,time,ip,sym -f trace:
     
diff --git a/tools/perf/Documentation/perf-test.txt b/tools/perf/Documentation/perf-test.txt
index d1d3e5121f89..31a5c3ea7f74 100644
--- a/tools/perf/Documentation/perf-test.txt
+++ b/tools/perf/Documentation/perf-test.txt
@@ -25,7 +25,7 @@ OPTIONS
 -------
 -s::
 --skip::
-	Tests to skip (comma separater numeric list).
+	Tests to skip (comma separated numeric list).
 
 -v::
 --verbose::
diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index 02aac831bdd9..7e1b1f2bb83c 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -20,7 +20,7 @@ scheduling events, etc.
 This is a live mode tool in addition to working with perf.data files like
 the other perf tools. Files can be generated using the 'perf record' command
 but the session needs to include the raw_syscalls events (-e 'raw_syscalls:*').
-Alernatively, the 'perf trace record' can be used as a shortcut to
+Alternatively, 'perf trace record' can be used as a shortcut to
 automatically include the raw_syscalls events when writing events to a file.
 
 The following options apply to perf trace; options to perf trace record are
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index be5939418425..e7417fe97a97 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -51,6 +51,7 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 				  struct addr_location *al,
 				  struct perf_annotate *ann)
 {
+	struct hists *hists = evsel__hists(evsel);
 	struct hist_entry *he;
 	int ret;
 
@@ -66,13 +67,12 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 		return 0;
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, NULL, NULL, NULL, 1, 1, 0,
-				true);
+	he = __hists__add_entry(hists, al, NULL, NULL, NULL, 1, 1, 0, true);
 	if (he == NULL)
 		return -ENOMEM;
 
 	ret = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
-	hists__inc_nr_samples(&evsel->hists, true);
+	hists__inc_nr_samples(hists, true);
 	return ret;
 }
 
@@ -214,6 +214,7 @@ static int __cmd_annotate(struct perf_annotate *ann)
 
 	if (dump_trace) {
 		perf_session__fprintf_nr_events(session, stdout);
+		perf_evlist__fprintf_nr_events(session->evlist, stdout);
 		goto out;
 	}
 
@@ -225,7 +226,7 @@ static int __cmd_annotate(struct perf_annotate *ann)
 
 	total_nr_samples = 0;
 	evlist__for_each(session->evlist, pos) {
-		struct hists *hists = &pos->hists;
+		struct hists *hists = evsel__hists(pos);
 		u32 nr_samples = hists->stats.nr_events[PERF_RECORD_SAMPLE];
 
 		if (nr_samples > 0) {
@@ -325,7 +326,10 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Show event group information together"),
 	OPT_END()
 	};
-	int ret;
+	int ret = hists__init();
+
+	if (ret < 0)
+		return ret;
 
 	argc = parse_options(argc, argv, options, annotate_usage, 0);
 
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index a3ce19f7aebd..8c5c11ca8c53 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -327,6 +327,7 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
 				      struct machine *machine)
 {
 	struct addr_location al;
+	struct hists *hists = evsel__hists(evsel);
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
 		pr_warning("problem processing %d event, skipping it.\n",
@@ -334,7 +335,7 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
 		return -1;
 	}
 
-	if (hists__add_entry(&evsel->hists, &al, sample->period,
+	if (hists__add_entry(hists, &al, sample->period,
 			     sample->weight, sample->transaction)) {
 		pr_warning("problem incrementing symbol period, skipping event\n");
 		return -1;
@@ -346,9 +347,9 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
 	 * hists__output_resort() and precompute needs the total
 	 * period in order to sort entries by percentage delta.
 	 */
-	evsel->hists.stats.total_period += sample->period;
+	hists->stats.total_period += sample->period;
 	if (!al.filtered)
-		evsel->hists.stats.total_non_filtered_period += sample->period;
+		hists->stats.total_non_filtered_period += sample->period;
 
 	return 0;
 }
@@ -382,7 +383,7 @@ static void perf_evlist__collapse_resort(struct perf_evlist *evlist)
 	struct perf_evsel *evsel;
 
 	evlist__for_each(evlist, evsel) {
-		struct hists *hists = &evsel->hists;
+		struct hists *hists = evsel__hists(evsel);
 
 		hists__collapse_resort(hists, NULL);
 	}
@@ -631,24 +632,26 @@ static void data_process(void)
 	bool first = true;
 
 	evlist__for_each(evlist_base, evsel_base) {
+		struct hists *hists_base = evsel__hists(evsel_base);
 		struct data__file *d;
 		int i;
 
 		data__for_each_file_new(i, d) {
 			struct perf_evlist *evlist = d->session->evlist;
 			struct perf_evsel *evsel;
+			struct hists *hists;
 
 			evsel = evsel_match(evsel_base, evlist);
 			if (!evsel)
 				continue;
 
-			d->hists = &evsel->hists;
+			hists = evsel__hists(evsel);
+			d->hists = hists;
 
-			hists__match(&evsel_base->hists, &evsel->hists);
+			hists__match(hists_base, hists);
 
 			if (!show_baseline_only)
-				hists__link(&evsel_base->hists,
-					    &evsel->hists);
+				hists__link(hists_base, hists);
 		}
 
 		fprintf(stdout, "%s# Event '%s'\n#\n", first ? "" : "\n",
@@ -659,7 +662,7 @@ static void data_process(void)
 		if (verbose || data__files_cnt > 2)
 			data__fprintf();
 
-		hists__process(&evsel_base->hists);
+		hists__process(hists_base);
 	}
 }
 
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index d8bf2271f4ea..b65eb0507b38 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -376,7 +376,7 @@ struct vcpu_event_record *per_vcpu_record(struct thread *thread,
 					  struct perf_sample *sample)
 {
 	/* Only kvm_entry records vcpu id. */
-	if (!thread->priv && kvm_entry_event(evsel)) {
+	if (!thread__priv(thread) && kvm_entry_event(evsel)) {
 		struct vcpu_event_record *vcpu_record;
 
 		vcpu_record = zalloc(sizeof(*vcpu_record));
@@ -386,10 +386,10 @@ struct vcpu_event_record *per_vcpu_record(struct thread *thread,
 		}
 
 		vcpu_record->vcpu_id = perf_evsel__intval(evsel, sample, VCPU_ID);
-		thread->priv = vcpu_record;
+		thread__set_priv(thread, vcpu_record);
 	}
 
-	return thread->priv;
+	return thread__priv(thread);
 }
 
 static bool handle_kvm_event(struct perf_kvm_stat *kvm,
@@ -896,8 +896,7 @@ static int perf_kvm__handle_stdin(void)
 
 static int kvm_events_live_report(struct perf_kvm_stat *kvm)
 {
-	struct pollfd *pollfds = NULL;
-	int nr_fds, nr_stdin, ret, err = -EINVAL;
+	int nr_stdin, ret, err = -EINVAL;
 	struct termios save;
 
 	/* live flag must be set first */
@@ -919,34 +918,27 @@ static int kvm_events_live_report(struct perf_kvm_stat *kvm)
 	signal(SIGINT, sig_handler);
 	signal(SIGTERM, sig_handler);
 
-	/* use pollfds -- need to add timerfd and stdin */
-	nr_fds = kvm->evlist->pollfd.nr;
-
 	/* add timer fd */
 	if (perf_kvm__timerfd_create(kvm) < 0) {
 		err = -1;
 		goto out;
 	}
 
-	if (perf_evlist__add_pollfd(kvm->evlist, kvm->timerfd))
+	if (perf_evlist__add_pollfd(kvm->evlist, kvm->timerfd) < 0)
 		goto out;
 
-	nr_fds++;
-
-	if (perf_evlist__add_pollfd(kvm->evlist, fileno(stdin)))
+	nr_stdin = perf_evlist__add_pollfd(kvm->evlist, fileno(stdin));
+	if (nr_stdin < 0)
 		goto out;
 
-	nr_stdin = nr_fds;
-	nr_fds++;
 	if (fd_set_nonblock(fileno(stdin)) != 0)
 		goto out;
 
-	pollfds	 = kvm->evlist->pollfd.entries;
-
 	/* everything is good - enable the events and process */
 	perf_evlist__enable(kvm->evlist);
 
 	while (!done) {
+		struct fdarray *fda = &kvm->evlist->pollfd;
 		int rc;
 
 		rc = perf_kvm__mmap_read(kvm);
@@ -957,11 +949,11 @@ static int kvm_events_live_report(struct perf_kvm_stat *kvm)
 		if (err)
 			goto out;
 
-		if (pollfds[nr_stdin].revents & POLLIN)
+		if (fda->entries[nr_stdin].revents & POLLIN)
 			done = perf_kvm__handle_stdin();
 
 		if (!rc && !done)
-			err = poll(pollfds, nr_fds, 100);
+			err = fdarray__poll(fda, 100);
 	}
 
 	perf_evlist__disable(kvm->evlist);
@@ -1366,6 +1358,7 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
 	}
 	kvm->session->evlist = kvm->evlist;
 	perf_session__set_id_hdr_size(kvm->session);
+	ordered_events__set_copy_on_queue(&kvm->session->ordered_events, true);
 	machine__synthesize_threads(&kvm->session->machines.host, &kvm->opts.target,
 				    kvm->evlist->threads, false);
 	err = kvm_live_open_events(kvm);
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 44c6f3d55ce7..2583a9b04317 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -14,6 +14,8 @@
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 
+#include "util/callchain.h"
+#include "util/cgroup.h"
 #include "util/header.h"
 #include "util/event.h"
 #include "util/evlist.h"
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ac145fae0521..140a6cd88351 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -257,6 +257,13 @@ static int report__setup_sample_type(struct report *rep)
 		}
 	}
 
+	if (symbol_conf.use_callchain || symbol_conf.cumulate_callchain) {
+		if ((sample_type & PERF_SAMPLE_REGS_USER) &&
+		    (sample_type & PERF_SAMPLE_STACK_USER))
+			callchain_param.record_mode = CALLCHAIN_DWARF;
+		else
+			callchain_param.record_mode = CALLCHAIN_FP;
+	}
 	return 0;
 }
 
@@ -288,12 +295,14 @@ static size_t hists__fprintf_nr_sample_events(struct hists *hists, struct report
 		evname = buf;
 
 		for_each_group_member(pos, evsel) {
+			const struct hists *pos_hists = evsel__hists(pos);
+
 			if (symbol_conf.filter_relative) {
-				nr_samples += pos->hists.stats.nr_non_filtered_samples;
-				nr_events += pos->hists.stats.total_non_filtered_period;
+				nr_samples += pos_hists->stats.nr_non_filtered_samples;
+				nr_events += pos_hists->stats.total_non_filtered_period;
 			} else {
-				nr_samples += pos->hists.stats.nr_events[PERF_RECORD_SAMPLE];
-				nr_events += pos->hists.stats.total_period;
+				nr_samples += pos_hists->stats.nr_events[PERF_RECORD_SAMPLE];
+				nr_events += pos_hists->stats.total_period;
 			}
 		}
 	}
@@ -318,7 +327,7 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
 	struct perf_evsel *pos;
 
 	evlist__for_each(evlist, pos) {
-		struct hists *hists = &pos->hists;
+		struct hists *hists = evsel__hists(pos);
 		const char *evname = perf_evsel__name(pos);
 
 		if (symbol_conf.event_group &&
@@ -427,7 +436,7 @@ static void report__collapse_hists(struct report *rep)
 	ui_progress__init(&prog, rep->nr_entries, "Merging related events...");
 
 	evlist__for_each(rep->session->evlist, pos) {
-		struct hists *hists = &pos->hists;
+		struct hists *hists = evsel__hists(pos);
 
 		if (pos->idx == 0)
 			hists->symbol_filter_str = rep->symbol_filter_str;
@@ -437,7 +446,7 @@ static void report__collapse_hists(struct report *rep)
 		/* Non-group events are considered as leader */
 		if (symbol_conf.event_group &&
 		    !perf_evsel__is_group_leader(pos)) {
-			struct hists *leader_hists = &pos->leader->hists;
+			struct hists *leader_hists = evsel__hists(pos->leader);
 
 			hists__match(leader_hists, hists);
 			hists__link(leader_hists, hists);
@@ -485,6 +494,7 @@ static int __cmd_report(struct report *rep)
 
 		if (dump_trace) {
 			perf_session__fprintf_nr_events(session, stdout);
+			perf_evlist__fprintf_nr_events(session->evlist, stdout);
 			return 0;
 		}
 	}
@@ -500,7 +510,7 @@ static int __cmd_report(struct report *rep)
 	}
 
 	evlist__for_each(session->evlist, pos)
-		hists__output_resort(&pos->hists);
+		hists__output_resort(evsel__hists(pos));
 
 	return report__browse_hists(rep);
 }
@@ -565,7 +575,6 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	struct stat st;
 	bool has_br_stack = false;
 	int branch_mode = -1;
-	int ret = -1;
 	char callchain_default_opt[] = "fractal,0.5,callee";
 	const char * const report_usage[] = {
 		"perf report [<options>]",
@@ -692,6 +701,10 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	struct perf_data_file file = {
 		.mode  = PERF_DATA_MODE_READ,
 	};
+	int ret = hists__init();
+
+	if (ret < 0)
+		return ret;
 
 	perf_config(report__config, &report);
 
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 9c9287fbf8e9..891c3930080e 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1431,9 +1431,6 @@ static int perf_sched__process_tracepoint_sample(struct perf_tool *tool __maybe_
 {
 	int err = 0;
 
-	evsel->hists.stats.total_period += sample->period;
-	hists__inc_nr_samples(&evsel->hists, true);
-
 	if (evsel->handler != NULL) {
 		tracepoint_handler f = evsel->handler;
 		err = f(tool, evsel, sample, machine);
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index b9b9e58a6c39..9708a1290571 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -44,6 +44,7 @@ enum perf_output_field {
 	PERF_OUTPUT_ADDR            = 1U << 10,
 	PERF_OUTPUT_SYMOFFSET       = 1U << 11,
 	PERF_OUTPUT_SRCLINE         = 1U << 12,
+	PERF_OUTPUT_PERIOD          = 1U << 13,
 };
 
 struct output_option {
@@ -63,6 +64,7 @@ struct output_option {
 	{.str = "addr",  .field = PERF_OUTPUT_ADDR},
 	{.str = "symoff", .field = PERF_OUTPUT_SYMOFFSET},
 	{.str = "srcline", .field = PERF_OUTPUT_SRCLINE},
+	{.str = "period", .field = PERF_OUTPUT_PERIOD},
 };
 
 /* default set to maintain compatibility with current format */
@@ -80,7 +82,8 @@ static struct {
 		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
 			      PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
 			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_IP |
-				  PERF_OUTPUT_SYM | PERF_OUTPUT_DSO,
+			      PERF_OUTPUT_SYM | PERF_OUTPUT_DSO |
+			      PERF_OUTPUT_PERIOD,
 
 		.invalid_fields = PERF_OUTPUT_TRACE,
 	},
@@ -91,7 +94,8 @@ static struct {
 		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
 			      PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
 			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_IP |
-				  PERF_OUTPUT_SYM | PERF_OUTPUT_DSO,
+			      PERF_OUTPUT_SYM | PERF_OUTPUT_DSO |
+			      PERF_OUTPUT_PERIOD,
 
 		.invalid_fields = PERF_OUTPUT_TRACE,
 	},
@@ -110,7 +114,8 @@ static struct {
 		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
 			      PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
 			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_IP |
-				  PERF_OUTPUT_SYM | PERF_OUTPUT_DSO,
+			      PERF_OUTPUT_SYM | PERF_OUTPUT_DSO |
+			      PERF_OUTPUT_PERIOD,
 
 		.invalid_fields = PERF_OUTPUT_TRACE,
 	},
@@ -229,6 +234,11 @@ static int perf_evsel__check_attr(struct perf_evsel *evsel,
 					PERF_OUTPUT_CPU))
 		return -EINVAL;
 
+	if (PRINT_FIELD(PERIOD) &&
+		perf_evsel__check_stype(evsel, PERF_SAMPLE_PERIOD, "PERIOD",
+					PERF_OUTPUT_PERIOD))
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -448,6 +458,9 @@ static void process_event(union perf_event *event, struct perf_sample *sample,
 
 	print_sample_start(sample, thread, evsel);
 
+	if (PRINT_FIELD(PERIOD))
+		printf("%10" PRIu64 " ", sample->period);
+
 	if (PRINT_FIELD(EVNAME)) {
 		const char *evname = perf_evsel__name(evsel);
 		printf("%s: ", evname ? evname : "[unknown]");
@@ -572,7 +585,6 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 
 	scripting_ops->process_event(event, sample, evsel, thread, &al);
 
-	evsel->hists.stats.total_period += sample->period;
 	return 0;
 }
 
@@ -1544,7 +1556,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 		     "comma separated output fields prepend with 'type:'. "
 		     "Valid types: hw,sw,trace,raw. "
 		     "Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso,"
-		     "addr,symoff", parse_output_fields),
+		     "addr,symoff,period", parse_output_fields),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
 		    "system-wide collection from all CPUs"),
 	OPT_STRING('S', "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index b22c62f80078..055ce9232c9e 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -43,6 +43,7 @@
 
 #include "perf.h"
 #include "builtin.h"
+#include "util/cgroup.h"
 #include "util/util.h"
 #include "util/parse-options.h"
 #include "util/parse-events.h"
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index fc3d55f832ac..0aa7747ff139 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -251,6 +251,7 @@ static void perf_top__print_sym_table(struct perf_top *top)
 	char bf[160];
 	int printed = 0;
 	const int win_width = top->winsize.ws_col - 1;
+	struct hists *hists = evsel__hists(top->sym_evsel);
 
 	puts(CONSOLE_CLEAR);
 
@@ -261,13 +262,13 @@ static void perf_top__print_sym_table(struct perf_top *top)
 
 	printf("%-*.*s\n", win_width, win_width, graph_dotted_line);
 
-	if (top->sym_evsel->hists.stats.nr_lost_warned !=
-	    top->sym_evsel->hists.stats.nr_events[PERF_RECORD_LOST]) {
-		top->sym_evsel->hists.stats.nr_lost_warned =
-			top->sym_evsel->hists.stats.nr_events[PERF_RECORD_LOST];
+	if (hists->stats.nr_lost_warned !=
+	    hists->stats.nr_events[PERF_RECORD_LOST]) {
+		hists->stats.nr_lost_warned =
+			      hists->stats.nr_events[PERF_RECORD_LOST];
 		color_fprintf(stdout, PERF_COLOR_RED,
 			      "WARNING: LOST %d chunks, Check IO/CPU overload",
-			      top->sym_evsel->hists.stats.nr_lost_warned);
+			      hists->stats.nr_lost_warned);
 		++printed;
 	}
 
@@ -277,21 +278,18 @@ static void perf_top__print_sym_table(struct perf_top *top)
 	}
 
 	if (top->zero) {
-		hists__delete_entries(&top->sym_evsel->hists);
+		hists__delete_entries(hists);
 	} else {
-		hists__decay_entries(&top->sym_evsel->hists,
-				     top->hide_user_symbols,
+		hists__decay_entries(hists, top->hide_user_symbols,
 				     top->hide_kernel_symbols);
 	}
 
-	hists__collapse_resort(&top->sym_evsel->hists, NULL);
-	hists__output_resort(&top->sym_evsel->hists);
+	hists__collapse_resort(hists, NULL);
+	hists__output_resort(hists);
 
-	hists__output_recalc_col_len(&top->sym_evsel->hists,
-				     top->print_entries - printed);
+	hists__output_recalc_col_len(hists, top->print_entries - printed);
 	putchar('\n');
-	hists__fprintf(&top->sym_evsel->hists, false,
-		       top->print_entries - printed, win_width,
+	hists__fprintf(hists, false, top->print_entries - printed, win_width,
 		       top->min_percent, stdout);
 }
 
@@ -334,6 +332,7 @@ static void perf_top__prompt_symbol(struct perf_top *top, const char *msg)
 {
 	char *buf = malloc(0), *p;
 	struct hist_entry *syme = top->sym_filter_entry, *n, *found = NULL;
+	struct hists *hists = evsel__hists(top->sym_evsel);
 	struct rb_node *next;
 	size_t dummy = 0;
 
@@ -351,7 +350,7 @@ static void perf_top__prompt_symbol(struct perf_top *top, const char *msg)
 	if (p)
 		*p = 0;
 
-	next = rb_first(&top->sym_evsel->hists.entries);
+	next = rb_first(&hists->entries);
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node);
 		if (n->ms.sym && !strcmp(buf, n->ms.sym->name)) {
@@ -538,21 +537,24 @@ static bool perf_top__handle_keypress(struct perf_top *top, int c)
 static void perf_top__sort_new_samples(void *arg)
 {
 	struct perf_top *t = arg;
+	struct hists *hists;
+
 	perf_top__reset_sample_counters(t);
 
 	if (t->evlist->selected != NULL)
 		t->sym_evsel = t->evlist->selected;
 
+	hists = evsel__hists(t->sym_evsel);
+
 	if (t->zero) {
-		hists__delete_entries(&t->sym_evsel->hists);
+		hists__delete_entries(hists);
 	} else {
-		hists__decay_entries(&t->sym_evsel->hists,
-				     t->hide_user_symbols,
+		hists__decay_entries(hists, t->hide_user_symbols,
 				     t->hide_kernel_symbols);
 	}
 
-	hists__collapse_resort(&t->sym_evsel->hists, NULL);
-	hists__output_resort(&t->sym_evsel->hists);
+	hists__collapse_resort(hists, NULL);
+	hists__output_resort(hists);
 }
 
 static void *display_thread_tui(void *arg)
@@ -573,8 +575,10 @@ static void *display_thread_tui(void *arg)
 	 * Zooming in/out UIDs. For now juse use whatever the user passed
 	 * via --uid.
 	 */
-	evlist__for_each(top->evlist, pos)
-		pos->hists.uid_filter_str = top->record_opts.target.uid_str;
+	evlist__for_each(top->evlist, pos) {
+		struct hists *hists = evsel__hists(pos);
+		hists->uid_filter_str = top->record_opts.target.uid_str;
+	}
 
 	perf_evlist__tui_browse_hists(top->evlist, help, &hbt, top->min_percent,
 				      &top->session->header.env);
@@ -768,6 +772,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
 	}
 
 	if (al.sym == NULL || !al.sym->ignore) {
+		struct hists *hists = evsel__hists(evsel);
 		struct hist_entry_iter iter = {
 			.add_entry_cb = hist_iter__top_callback,
 		};
@@ -777,14 +782,14 @@ static void perf_event__process_sample(struct perf_tool *tool,
 		else
 			iter.ops = &hist_iter_normal;
 
-		pthread_mutex_lock(&evsel->hists.lock);
+		pthread_mutex_lock(&hists->lock);
 
 		err = hist_entry_iter__add(&iter, &al, evsel, sample,
 					   top->max_stack, top);
 		if (err < 0)
 			pr_err("Problem incrementing symbol period, skipping event\n");
 
-		pthread_mutex_unlock(&evsel->hists.lock);
+		pthread_mutex_unlock(&hists->lock);
 	}
 
 	return;
@@ -849,7 +854,7 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 			perf_event__process_sample(&top->tool, event, evsel,
 						   &sample, machine);
 		} else if (event->header.type < PERF_RECORD_MAX) {
-			hists__inc_nr_events(&evsel->hists, event->header.type);
+			hists__inc_nr_events(evsel__hists(evsel), event->header.type);
 			machine__process_event(machine, event, &sample);
 		} else
 			++session->stats.nr_unknown_events;
@@ -1042,7 +1047,6 @@ parse_percent_limit(const struct option *opt, const char *arg,
 
 int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 {
-	int status = -1;
 	char errbuf[BUFSIZ];
 	struct perf_top top = {
 		.count_filter	     = 5,
@@ -1160,6 +1164,10 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		"perf top [<options>]",
 		NULL
 	};
+	int status = hists__init();
+
+	if (status < 0)
+		return status;
 
 	top.evlist = perf_evlist__new();
 	if (top.evlist == NULL)
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 09bcf2393910..fb126459b134 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1189,13 +1189,13 @@ static struct thread_trace *thread__trace(struct thread *thread, FILE *fp)
 	if (thread == NULL)
 		goto fail;
 
-	if (thread->priv == NULL)
-		thread->priv = thread_trace__new();
+	if (thread__priv(thread) == NULL)
+		thread__set_priv(thread, thread_trace__new());
 		
-	if (thread->priv == NULL)
+	if (thread__priv(thread) == NULL)
 		goto fail;
 
-	ttrace = thread->priv;
+	ttrace = thread__priv(thread);
 	++ttrace->nr_events;
 
 	return ttrace;
@@ -1248,7 +1248,7 @@ struct trace {
 
 static int trace__set_fd_pathname(struct thread *thread, int fd, const char *pathname)
 {
-	struct thread_trace *ttrace = thread->priv;
+	struct thread_trace *ttrace = thread__priv(thread);
 
 	if (fd > ttrace->paths.max) {
 		char **npath = realloc(ttrace->paths.table, (fd + 1) * sizeof(char *));
@@ -1301,7 +1301,7 @@ static int thread__read_fd_path(struct thread *thread, int fd)
 static const char *thread__fd_path(struct thread *thread, int fd,
 				   struct trace *trace)
 {
-	struct thread_trace *ttrace = thread->priv;
+	struct thread_trace *ttrace = thread__priv(thread);
 
 	if (ttrace == NULL)
 		return NULL;
@@ -1338,7 +1338,7 @@ static size_t syscall_arg__scnprintf_close_fd(char *bf, size_t size,
 {
 	int fd = arg->val;
 	size_t printed = syscall_arg__scnprintf_fd(bf, size, arg);
-	struct thread_trace *ttrace = arg->thread->priv;
+	struct thread_trace *ttrace = thread__priv(arg->thread);
 
 	if (ttrace && fd >= 0 && fd <= ttrace->paths.max)
 		zfree(&ttrace->paths.table[fd]);
@@ -2381,7 +2381,7 @@ static int trace__fprintf_one_thread(struct thread *thread, void *priv)
 	FILE *fp = data->fp;
 	size_t printed = data->printed;
 	struct trace *trace = data->trace;
-	struct thread_trace *ttrace = thread->priv;
+	struct thread_trace *ttrace = thread__priv(thread);
 	double ratio;
 
 	if (ttrace == NULL)
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index ac655b0700e7..162c978f1491 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -6,6 +6,7 @@
 #include <unistd.h>
 #include <string.h>
 #include "builtin.h"
+#include "hist.h"
 #include "intlist.h"
 #include "tests.h"
 #include "debug.h"
@@ -302,6 +303,10 @@ int cmd_test(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_END()
 	};
 	struct intlist *skiplist = NULL;
+        int ret = hists__init();
+
+        if (ret < 0)
+                return ret;
 
 	argc = parse_options(argc, argv, test_options, test_usage, 0);
 	if (argc >= 1 && !strcmp(argv[0], "list"))
diff --git a/tools/perf/tests/dwarf-unwind.c b/tools/perf/tests/dwarf-unwind.c
index 96adb730b744..fc25e57f4a5d 100644
--- a/tools/perf/tests/dwarf-unwind.c
+++ b/tools/perf/tests/dwarf-unwind.c
@@ -9,6 +9,7 @@
 #include "perf_regs.h"
 #include "map.h"
 #include "thread.h"
+#include "callchain.h"
 
 static int mmap_handler(struct perf_tool *tool __maybe_unused,
 			union perf_event *event,
@@ -120,6 +121,8 @@ int test__dwarf_unwind(void)
 		return -1;
 	}
 
+	callchain_param.record_mode = CALLCHAIN_DWARF;
+
 	if (init_live_machine(machine)) {
 		pr_err("Could not init machine\n");
 		goto out;
diff --git a/tools/perf/tests/hists_cumulate.c b/tools/perf/tests/hists_cumulate.c
index 0ac240db2e24..614d5c4978ab 100644
--- a/tools/perf/tests/hists_cumulate.c
+++ b/tools/perf/tests/hists_cumulate.c
@@ -245,7 +245,7 @@ static int do_test(struct hists *hists, struct result *expected, size_t nr_expec
 static int test1(struct perf_evsel *evsel, struct machine *machine)
 {
 	int err;
-	struct hists *hists = &evsel->hists;
+	struct hists *hists = evsel__hists(evsel);
 	/*
 	 * expected output:
 	 *
@@ -295,7 +295,7 @@ static int test1(struct perf_evsel *evsel, struct machine *machine)
 static int test2(struct perf_evsel *evsel, struct machine *machine)
 {
 	int err;
-	struct hists *hists = &evsel->hists;
+	struct hists *hists = evsel__hists(evsel);
 	/*
 	 * expected output:
 	 *
@@ -442,7 +442,7 @@ static int test2(struct perf_evsel *evsel, struct machine *machine)
 static int test3(struct perf_evsel *evsel, struct machine *machine)
 {
 	int err;
-	struct hists *hists = &evsel->hists;
+	struct hists *hists = evsel__hists(evsel);
 	/*
 	 * expected output:
 	 *
@@ -498,7 +498,7 @@ static int test3(struct perf_evsel *evsel, struct machine *machine)
 static int test4(struct perf_evsel *evsel, struct machine *machine)
 {
 	int err;
-	struct hists *hists = &evsel->hists;
+	struct hists *hists = evsel__hists(evsel);
 	/*
 	 * expected output:
 	 *
diff --git a/tools/perf/tests/hists_filter.c b/tools/perf/tests/hists_filter.c
index 821f581fd930..5a31787cc6b9 100644
--- a/tools/perf/tests/hists_filter.c
+++ b/tools/perf/tests/hists_filter.c
@@ -66,11 +66,12 @@ static int add_hist_entries(struct perf_evlist *evlist,
 				.ops = &hist_iter_normal,
 				.hide_unresolved = false,
 			};
+			struct hists *hists = evsel__hists(evsel);
 
 			/* make sure it has no filter at first */
-			evsel->hists.thread_filter = NULL;
-			evsel->hists.dso_filter = NULL;
-			evsel->hists.symbol_filter_str = NULL;
+			hists->thread_filter = NULL;
+			hists->dso_filter = NULL;
+			hists->symbol_filter_str = NULL;
 
 			sample.pid = fake_samples[i].pid;
 			sample.tid = fake_samples[i].pid;
@@ -134,7 +135,7 @@ int test__hists_filter(void)
 		goto out;
 
 	evlist__for_each(evlist, evsel) {
-		struct hists *hists = &evsel->hists;
+		struct hists *hists = evsel__hists(evsel);
 
 		hists__collapse_resort(hists, NULL);
 		hists__output_resort(hists);
@@ -160,7 +161,7 @@ int test__hists_filter(void)
 				hists->stats.total_non_filtered_period);
 
 		/* now applying thread filter for 'bash' */
-		evsel->hists.thread_filter = fake_samples[9].thread;
+		hists->thread_filter = fake_samples[9].thread;
 		hists__filter_by_thread(hists);
 
 		if (verbose > 2) {
@@ -185,11 +186,11 @@ int test__hists_filter(void)
 				hists->stats.total_non_filtered_period == 400);
 
 		/* remove thread filter first */
-		evsel->hists.thread_filter = NULL;
+		hists->thread_filter = NULL;
 		hists__filter_by_thread(hists);
 
 		/* now applying dso filter for 'kernel' */
-		evsel->hists.dso_filter = fake_samples[0].map->dso;
+		hists->dso_filter = fake_samples[0].map->dso;
 		hists__filter_by_dso(hists);
 
 		if (verbose > 2) {
@@ -214,7 +215,7 @@ int test__hists_filter(void)
 				hists->stats.total_non_filtered_period == 300);
 
 		/* remove dso filter first */
-		evsel->hists.dso_filter = NULL;
+		hists->dso_filter = NULL;
 		hists__filter_by_dso(hists);
 
 		/*
@@ -224,7 +225,7 @@ int test__hists_filter(void)
 		 * be counted as a separate entry but the sample count and
 		 * total period will be remained.
 		 */
-		evsel->hists.symbol_filter_str = "main";
+		hists->symbol_filter_str = "main";
 		hists__filter_by_symbol(hists);
 
 		if (verbose > 2) {
@@ -249,8 +250,8 @@ int test__hists_filter(void)
 				hists->stats.total_non_filtered_period == 300);
 
 		/* now applying all filters at once. */
-		evsel->hists.thread_filter = fake_samples[1].thread;
-		evsel->hists.dso_filter = fake_samples[1].map->dso;
+		hists->thread_filter = fake_samples[1].thread;
+		hists->dso_filter = fake_samples[1].map->dso;
 		hists__filter_by_thread(hists);
 		hists__filter_by_dso(hists);
 
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index d4b34b0f50a2..278ba8344c23 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -73,6 +73,8 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 	 * "bash [libc] malloc" so total 9 entries will be in the tree.
 	 */
 	evlist__for_each(evlist, evsel) {
+		struct hists *hists = evsel__hists(evsel);
+
 		for (k = 0; k < ARRAY_SIZE(fake_common_samples); k++) {
 			const union perf_event event = {
 				.header = {
@@ -87,7 +89,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 							  &sample) < 0)
 				goto out;
 
-			he = __hists__add_entry(&evsel->hists, &al, NULL,
+			he = __hists__add_entry(hists, &al, NULL,
 						NULL, NULL, 1, 1, 0, true);
 			if (he == NULL)
 				goto out;
@@ -111,7 +113,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 							  &sample) < 0)
 				goto out;
 
-			he = __hists__add_entry(&evsel->hists, &al, NULL,
+			he = __hists__add_entry(hists, &al, NULL,
 						NULL, NULL, 1, 1, 0, true);
 			if (he == NULL)
 				goto out;
@@ -271,6 +273,7 @@ static int validate_link(struct hists *leader, struct hists *other)
 int test__hists_link(void)
 {
 	int err = -1;
+	struct hists *hists, *first_hists;
 	struct machines machines;
 	struct machine *machine = NULL;
 	struct perf_evsel *evsel, *first;
@@ -306,24 +309,28 @@ int test__hists_link(void)
 		goto out;
 
 	evlist__for_each(evlist, evsel) {
-		hists__collapse_resort(&evsel->hists, NULL);
+		hists = evsel__hists(evsel);
+		hists__collapse_resort(hists, NULL);
 
 		if (verbose > 2)
-			print_hists_in(&evsel->hists);
+			print_hists_in(hists);
 	}
 
 	first = perf_evlist__first(evlist);
 	evsel = perf_evlist__last(evlist);
 
+	first_hists = evsel__hists(first);
+	hists = evsel__hists(evsel);
+
 	/* match common entries */
-	hists__match(&first->hists, &evsel->hists);
-	err = validate_match(&first->hists, &evsel->hists);
+	hists__match(first_hists, hists);
+	err = validate_match(first_hists, hists);
 	if (err)
 		goto out;
 
 	/* link common and/or dummy entries */
-	hists__link(&first->hists, &evsel->hists);
-	err = validate_link(&first->hists, &evsel->hists);
+	hists__link(first_hists, hists);
+	err = validate_link(first_hists, hists);
 	if (err)
 		goto out;
 
diff --git a/tools/perf/tests/hists_output.c b/tools/perf/tests/hists_output.c
index e3bbd6c54c1b..a748f2be1222 100644
--- a/tools/perf/tests/hists_output.c
+++ b/tools/perf/tests/hists_output.c
@@ -122,7 +122,7 @@ typedef int (*test_fn_t)(struct perf_evsel *, struct machine *);
 static int test1(struct perf_evsel *evsel, struct machine *machine)
 {
 	int err;
-	struct hists *hists = &evsel->hists;
+	struct hists *hists = evsel__hists(evsel);
 	struct hist_entry *he;
 	struct rb_root *root;
 	struct rb_node *node;
@@ -159,7 +159,7 @@ static int test1(struct perf_evsel *evsel, struct machine *machine)
 		print_hists_out(hists);
 	}
 
-	root = &evsel->hists.entries;
+	root = &hists->entries;
 	node = rb_first(root);
 	he = rb_entry(node, struct hist_entry, rb_node);
 	TEST_ASSERT_VAL("Invalid hist entry",
@@ -224,7 +224,7 @@ static int test1(struct perf_evsel *evsel, struct machine *machine)
 static int test2(struct perf_evsel *evsel, struct machine *machine)
 {
 	int err;
-	struct hists *hists = &evsel->hists;
+	struct hists *hists = evsel__hists(evsel);
 	struct hist_entry *he;
 	struct rb_root *root;
 	struct rb_node *node;
@@ -259,7 +259,7 @@ static int test2(struct perf_evsel *evsel, struct machine *machine)
 		print_hists_out(hists);
 	}
 
-	root = &evsel->hists.entries;
+	root = &hists->entries;
 	node = rb_first(root);
 	he = rb_entry(node, struct hist_entry, rb_node);
 	TEST_ASSERT_VAL("Invalid hist entry",
@@ -280,7 +280,7 @@ static int test2(struct perf_evsel *evsel, struct machine *machine)
 static int test3(struct perf_evsel *evsel, struct machine *machine)
 {
 	int err;
-	struct hists *hists = &evsel->hists;
+	struct hists *hists = evsel__hists(evsel);
 	struct hist_entry *he;
 	struct rb_root *root;
 	struct rb_node *node;
@@ -313,7 +313,7 @@ static int test3(struct perf_evsel *evsel, struct machine *machine)
 		print_hists_out(hists);
 	}
 
-	root = &evsel->hists.entries;
+	root = &hists->entries;
 	node = rb_first(root);
 	he = rb_entry(node, struct hist_entry, rb_node);
 	TEST_ASSERT_VAL("Invalid hist entry",
@@ -354,7 +354,7 @@ static int test3(struct perf_evsel *evsel, struct machine *machine)
 static int test4(struct perf_evsel *evsel, struct machine *machine)
 {
 	int err;
-	struct hists *hists = &evsel->hists;
+	struct hists *hists = evsel__hists(evsel);
 	struct hist_entry *he;
 	struct rb_root *root;
 	struct rb_node *node;
@@ -391,7 +391,7 @@ static int test4(struct perf_evsel *evsel, struct machine *machine)
 		print_hists_out(hists);
 	}
 
-	root = &evsel->hists.entries;
+	root = &hists->entries;
 	node = rb_first(root);
 	he = rb_entry(node, struct hist_entry, rb_node);
 	TEST_ASSERT_VAL("Invalid hist entry",
@@ -456,7 +456,7 @@ static int test4(struct perf_evsel *evsel, struct machine *machine)
 static int test5(struct perf_evsel *evsel, struct machine *machine)
 {
 	int err;
-	struct hists *hists = &evsel->hists;
+	struct hists *hists = evsel__hists(evsel);
 	struct hist_entry *he;
 	struct rb_root *root;
 	struct rb_node *node;
@@ -494,7 +494,7 @@ static int test5(struct perf_evsel *evsel, struct machine *machine)
 		print_hists_out(hists);
 	}
 
-	root = &evsel->hists.entries;
+	root = &hists->entries;
 	node = rb_first(root);
 	he = rb_entry(node, struct hist_entry, rb_node);
 
diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 5941927a4b7f..7f2f51f93619 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -457,6 +457,36 @@ static int test__checkevent_pmu_events(struct perf_evlist *evlist)
 	return 0;
 }
 
+
+static int test__checkevent_pmu_events_mix(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	/* pmu-event:u */
+	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong exclude_user",
+			!evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel",
+			evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong pinned", !evsel->attr.pinned);
+
+	/* cpu/pmu-event/u*/
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong exclude_user",
+			!evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel",
+			evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong pinned", !evsel->attr.pinned);
+
+	return 0;
+}
+
 static int test__checkterms_simple(struct list_head *terms)
 {
 	struct parse_events_term *term;
@@ -1554,6 +1584,12 @@ static int test_pmu_events(void)
 		e.check = test__checkevent_pmu_events;
 
 		ret = test_event(&e);
+		if (ret)
+			break;
+		snprintf(name, MAX_NAME, "%s:u,cpu/event=%s/u", ent->d_name, ent->d_name);
+		e.name  = name;
+		e.check = test__checkevent_pmu_events_mix;
+		ret = test_event(&e);
 #undef MAX_NAME
 	}
 
diff --git a/tools/perf/ui/browsers/header.c b/tools/perf/ui/browsers/header.c
index 89c16b988618..e8278c558d4a 100644
--- a/tools/perf/ui/browsers/header.c
+++ b/tools/perf/ui/browsers/header.c
@@ -1,6 +1,7 @@
 #include "util/cache.h"
 #include "util/debug.h"
 #include "ui/browser.h"
+#include "ui/keysyms.h"
 #include "ui/ui.h"
 #include "ui/util.h"
 #include "ui/libslang.h"
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 8f60a970404f..cfb976b3de3a 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -35,7 +35,9 @@ struct hist_browser {
 
 extern void hist_browser__init_hpp(void);
 
-static int hists__browser_title(struct hists *hists, char *bf, size_t size);
+static int hists__browser_title(struct hists *hists,
+				struct hist_browser_timer *hbt,
+				char *bf, size_t size);
 static void hist_browser__update_nr_entries(struct hist_browser *hb);
 
 static struct rb_node *hists__filter_entries(struct rb_node *nd,
@@ -390,7 +392,7 @@ static int hist_browser__run(struct hist_browser *browser,
 	browser->b.entries = &browser->hists->entries;
 	browser->b.nr_entries = hist_browser__nr_entries(browser);
 
-	hists__browser_title(browser->hists, title, sizeof(title));
+	hists__browser_title(browser->hists, hbt, title, sizeof(title));
 
 	if (ui_browser__show(&browser->b, title,
 			     "Press '?' for help on key bindings") < 0)
@@ -417,7 +419,8 @@ static int hist_browser__run(struct hist_browser *browser,
 				ui_browser__warn_lost_events(&browser->b);
 			}
 
-			hists__browser_title(browser->hists, title, sizeof(title));
+			hists__browser_title(browser->hists,
+					     hbt, title, sizeof(title));
 			ui_browser__show_title(&browser->b, title);
 			continue;
 		}
@@ -1204,7 +1207,15 @@ static struct thread *hist_browser__selected_thread(struct hist_browser *browser
 	return browser->he_selection->thread;
 }
 
-static int hists__browser_title(struct hists *hists, char *bf, size_t size)
+/* Check whether the browser is for 'top' or 'report' */
+static inline bool is_report_browser(void *timer)
+{
+	return timer == NULL;
+}
+
+static int hists__browser_title(struct hists *hists,
+				struct hist_browser_timer *hbt,
+				char *bf, size_t size)
 {
 	char unit;
 	int printed;
@@ -1229,12 +1240,14 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size)
 		ev_name = buf;
 
 		for_each_group_member(pos, evsel) {
+			struct hists *pos_hists = evsel__hists(pos);
+
 			if (symbol_conf.filter_relative) {
-				nr_samples += pos->hists.stats.nr_non_filtered_samples;
-				nr_events += pos->hists.stats.total_non_filtered_period;
+				nr_samples += pos_hists->stats.nr_non_filtered_samples;
+				nr_events += pos_hists->stats.total_non_filtered_period;
 			} else {
-				nr_samples += pos->hists.stats.nr_events[PERF_RECORD_SAMPLE];
-				nr_events += pos->hists.stats.total_period;
+				nr_samples += pos_hists->stats.nr_events[PERF_RECORD_SAMPLE];
+				nr_events += pos_hists->stats.total_period;
 			}
 		}
 	}
@@ -1256,6 +1269,13 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size)
 	if (dso)
 		printed += scnprintf(bf + printed, size - printed,
 				    ", DSO: %s", dso->short_name);
+	if (!is_report_browser(hbt)) {
+		struct perf_top *top = hbt->arg;
+
+		if (top->zero)
+			printed += scnprintf(bf + printed, size - printed, " [z]");
+	}
+
 	return printed;
 }
 
@@ -1267,12 +1287,6 @@ static inline void free_popup_options(char **options, int n)
 		zfree(&options[i]);
 }
 
-/* Check whether the browser is for 'top' or 'report' */
-static inline bool is_report_browser(void *timer)
-{
-	return timer == NULL;
-}
-
 /*
  * Only runtime switching of perf data file will make "input_name" point
  * to a malloced buffer. So add "is_input_name_malloced" flag to decide
@@ -1387,7 +1401,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 				    float min_pcnt,
 				    struct perf_session_env *env)
 {
-	struct hists *hists = &evsel->hists;
+	struct hists *hists = evsel__hists(evsel);
 	struct hist_browser *browser = hist_browser__new(hists);
 	struct branch_info *bi;
 	struct pstack *fstack;
@@ -1802,8 +1816,9 @@ static void perf_evsel_menu__write(struct ui_browser *browser,
 	struct perf_evsel_menu *menu = container_of(browser,
 						    struct perf_evsel_menu, b);
 	struct perf_evsel *evsel = list_entry(entry, struct perf_evsel, node);
+	struct hists *hists = evsel__hists(evsel);
 	bool current_entry = ui_browser__is_current_entry(browser, row);
-	unsigned long nr_events = evsel->hists.stats.nr_events[PERF_RECORD_SAMPLE];
+	unsigned long nr_events = hists->stats.nr_events[PERF_RECORD_SAMPLE];
 	const char *ev_name = perf_evsel__name(evsel);
 	char bf[256], unit;
 	const char *warn = " ";
@@ -1818,7 +1833,8 @@ static void perf_evsel_menu__write(struct ui_browser *browser,
 		ev_name = perf_evsel__group_name(evsel);
 
 		for_each_group_member(pos, evsel) {
-			nr_events += pos->hists.stats.nr_events[PERF_RECORD_SAMPLE];
+			struct hists *pos_hists = evsel__hists(pos);
+			nr_events += pos_hists->stats.nr_events[PERF_RECORD_SAMPLE];
 		}
 	}
 
@@ -1827,7 +1843,7 @@ static void perf_evsel_menu__write(struct ui_browser *browser,
 			   unit, unit == ' ' ? "" : " ", ev_name);
 	slsmg_printf("%s", bf);
 
-	nr_events = evsel->hists.stats.nr_events[PERF_RECORD_LOST];
+	nr_events = hists->stats.nr_events[PERF_RECORD_LOST];
 	if (nr_events != 0) {
 		menu->lost_events = true;
 		if (!current_entry)
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index f3fa4258b256..fc654fb77ace 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -319,7 +319,7 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 	gtk_container_add(GTK_CONTAINER(window), vbox);
 
 	evlist__for_each(evlist, pos) {
-		struct hists *hists = &pos->hists;
+		struct hists *hists = evsel__hists(pos);
 		const char *evname = perf_evsel__name(pos);
 		GtkWidget *scrolled_window;
 		GtkWidget *tab_label;
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 36437527dbb3..7dabde14ea54 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -478,7 +478,7 @@ static int __symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 
 	pr_debug3("%s: addr=%#" PRIx64 "\n", __func__, map->unmap_ip(map, addr));
 
-	if (addr < sym->start || addr > sym->end)
+	if (addr < sym->start || addr >= sym->end)
 		return -ERANGE;
 
 	offset = addr - sym->start;
@@ -836,7 +836,7 @@ static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
 		    end = map__rip_2objdump(map, sym->end);
 
 		offset = line_ip - start;
-		if ((u64)line_ip < start || (u64)line_ip > end)
+		if ((u64)line_ip < start || (u64)line_ip >= end)
 			offset = -1;
 		else
 			parsed_line = tmp2 + 1;
@@ -966,7 +966,7 @@ int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize)
 		kce.kcore_filename = symfs_filename;
 		kce.addr = map__rip_2objdump(map, sym->start);
 		kce.offs = sym->start;
-		kce.len = sym->end + 1 - sym->start;
+		kce.len = sym->end - sym->start;
 		if (!kcore_extract__create(&kce)) {
 			delete_extract = true;
 			strlcpy(symfs_filename, kce.extract_filename,
@@ -987,7 +987,7 @@ int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize)
 		 disassembler_style ? "-M " : "",
 		 disassembler_style ? disassembler_style : "",
 		 map__rip_2objdump(map, sym->start),
-		 map__rip_2objdump(map, sym->end+1),
+		 map__rip_2objdump(map, sym->end),
 		 symbol_conf.annotate_asm_raw ? "" : "--no-show-raw",
 		 symbol_conf.annotate_src ? "-S" : "",
 		 symfs_filename, filename);
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 2a1f5a46543a..94cfefddf4db 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -65,6 +65,8 @@ struct callchain_param {
 	enum chain_key		key;
 };
 
+extern struct callchain_param callchain_param;
+
 struct callchain_list {
 	u64			ip;
 	struct map_symbol	ms;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 7eb7107731ec..5699e7e2a790 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -190,6 +190,32 @@ enum perf_user_event_type { /* above any possible kernel type */
 	PERF_RECORD_HEADER_MAX
 };
 
+/*
+ * The kernel collects the number of events it couldn't send in a stretch and
+ * when possible sends this number in a PERF_RECORD_LOST event. The number of
+ * such "chunks" of lost events is stored in .nr_events[PERF_EVENT_LOST] while
+ * total_lost tells exactly how many events the kernel in fact lost, i.e. it is
+ * the sum of all struct lost_event.lost fields reported.
+ *
+ * The total_period is needed because by default auto-freq is used, so
+ * multipling nr_events[PERF_EVENT_SAMPLE] by a frequency isn't possible to get
+ * the total number of low level events, it is necessary to to sum all struct
+ * sample_event.period and stash the result in total_period.
+ */
+struct events_stats {
+	u64 total_period;
+	u64 total_non_filtered_period;
+	u64 total_lost;
+	u64 total_invalid_chains;
+	u32 nr_events[PERF_RECORD_HEADER_MAX];
+	u32 nr_non_filtered_samples;
+	u32 nr_lost_warned;
+	u32 nr_unknown_events;
+	u32 nr_invalid_chains;
+	u32 nr_unknown_id;
+	u32 nr_unprocessable_samples;
+};
+
 struct attr_event {
 	struct perf_event_header header;
 	struct perf_event_attr attr;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 3cebc9a8d52e..3c9e77d6b4c2 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1003,6 +1003,7 @@ int perf_evlist__create_maps(struct perf_evlist *evlist, struct target *target)
 
 out_delete_threads:
 	thread_map__delete(evlist->threads);
+	evlist->threads = NULL;
 	return -1;
 }
 
@@ -1175,11 +1176,51 @@ void perf_evlist__close(struct perf_evlist *evlist)
 	}
 }
 
+static int perf_evlist__create_syswide_maps(struct perf_evlist *evlist)
+{
+	int err = -ENOMEM;
+
+	/*
+	 * Try reading /sys/devices/system/cpu/online to get
+	 * an all cpus map.
+	 *
+	 * FIXME: -ENOMEM is the best we can do here, the cpu_map
+	 * code needs an overhaul to properly forward the
+	 * error, and we may not want to do that fallback to a
+	 * default cpu identity map :-\
+	 */
+	evlist->cpus = cpu_map__new(NULL);
+	if (evlist->cpus == NULL)
+		goto out;
+
+	evlist->threads = thread_map__new_dummy();
+	if (evlist->threads == NULL)
+		goto out_free_cpus;
+
+	err = 0;
+out:
+	return err;
+out_free_cpus:
+	cpu_map__delete(evlist->cpus);
+	evlist->cpus = NULL;
+	goto out;
+}
+
 int perf_evlist__open(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel;
 	int err;
 
+	/*
+	 * Default: one fd per CPU, all threads, aka systemwide
+	 * as sys_perf_event_open(cpu = -1, thread = -1) is EINVAL
+	 */
+	if (evlist->threads == NULL && evlist->cpus == NULL) {
+		err = perf_evlist__create_syswide_maps(evlist);
+		if (err < 0)
+			goto out_err;
+	}
+
 	perf_evlist__update_id_pos(evlist);
 
 	evlist__for_each(evlist, evsel) {
@@ -1276,8 +1317,14 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist, struct target *tar
 		sigaction(SIGUSR1, &act, NULL);
 	}
 
-	if (target__none(target))
+	if (target__none(target)) {
+		if (evlist->threads == NULL) {
+			fprintf(stderr, "FATAL: evlist->threads need to be set at this point (%s:%d).\n",
+				__func__, __LINE__);
+			goto out_close_pipes;
+		}
 		evlist->threads->map[0] = evlist->workload.pid;
+	}
 
 	close(child_ready_pipe[1]);
 	close(go_pipe[0]);
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index bd312b01e876..649b0c597283 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -117,6 +117,8 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 						     void *ucontext));
 int perf_evlist__start_workload(struct perf_evlist *evlist);
 
+struct option;
+
 int perf_evlist__parse_mmap_pages(const struct option *opt,
 				  const char *str,
 				  int unset);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index e0868a901c4a..2f9e68025ede 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -15,6 +15,8 @@
 #include <linux/perf_event.h>
 #include <sys/resource.h>
 #include "asm/bug.h"
+#include "callchain.h"
+#include "cgroup.h"
 #include "evsel.h"
 #include "evlist.h"
 #include "util.h"
@@ -32,6 +34,48 @@ static struct {
 	bool cloexec;
 } perf_missing_features;
 
+static int perf_evsel__no_extra_init(struct perf_evsel *evsel __maybe_unused)
+{
+	return 0;
+}
+
+static void perf_evsel__no_extra_fini(struct perf_evsel *evsel __maybe_unused)
+{
+}
+
+static struct {
+	size_t	size;
+	int	(*init)(struct perf_evsel *evsel);
+	void	(*fini)(struct perf_evsel *evsel);
+} perf_evsel__object = {
+	.size = sizeof(struct perf_evsel),
+	.init = perf_evsel__no_extra_init,
+	.fini = perf_evsel__no_extra_fini,
+};
+
+int perf_evsel__object_config(size_t object_size,
+			      int (*init)(struct perf_evsel *evsel),
+			      void (*fini)(struct perf_evsel *evsel))
+{
+
+	if (object_size == 0)
+		goto set_methods;
+
+	if (perf_evsel__object.size > object_size)
+		return -EINVAL;
+
+	perf_evsel__object.size = object_size;
+
+set_methods:
+	if (init != NULL)
+		perf_evsel__object.init = init;
+
+	if (fini != NULL)
+		perf_evsel__object.fini = fini;
+
+	return 0;
+}
+
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 
 int __perf_evsel__sample_size(u64 sample_type)
@@ -116,16 +160,6 @@ void perf_evsel__calc_id_pos(struct perf_evsel *evsel)
 	evsel->is_pos = __perf_evsel__calc_is_pos(evsel->attr.sample_type);
 }
 
-void hists__init(struct hists *hists)
-{
-	memset(hists, 0, sizeof(*hists));
-	hists->entries_in_array[0] = hists->entries_in_array[1] = RB_ROOT;
-	hists->entries_in = &hists->entries_in_array[0];
-	hists->entries_collapsed = RB_ROOT;
-	hists->entries = RB_ROOT;
-	pthread_mutex_init(&hists->lock, NULL);
-}
-
 void __perf_evsel__set_sample_bit(struct perf_evsel *evsel,
 				  enum perf_event_sample_format bit)
 {
@@ -168,14 +202,14 @@ void perf_evsel__init(struct perf_evsel *evsel,
 	evsel->unit	   = "";
 	evsel->scale	   = 1.0;
 	INIT_LIST_HEAD(&evsel->node);
-	hists__init(&evsel->hists);
+	perf_evsel__object.init(evsel);
 	evsel->sample_size = __perf_evsel__sample_size(attr->sample_type);
 	perf_evsel__calc_id_pos(evsel);
 }
 
 struct perf_evsel *perf_evsel__new_idx(struct perf_event_attr *attr, int idx)
 {
-	struct perf_evsel *evsel = zalloc(sizeof(*evsel));
+	struct perf_evsel *evsel = zalloc(perf_evsel__object.size);
 
 	if (evsel != NULL)
 		perf_evsel__init(evsel, attr, idx);
@@ -185,7 +219,7 @@ struct perf_evsel *perf_evsel__new_idx(struct perf_event_attr *attr, int idx)
 
 struct perf_evsel *perf_evsel__newtp_idx(const char *sys, const char *name, int idx)
 {
-	struct perf_evsel *evsel = zalloc(sizeof(*evsel));
+	struct perf_evsel *evsel = zalloc(perf_evsel__object.size);
 
 	if (evsel != NULL) {
 		struct perf_event_attr attr = {
@@ -692,7 +726,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 	}
 }
 
-int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
+static int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
 {
 	int cpu, thread;
 
@@ -780,13 +814,13 @@ int perf_evsel__alloc_counts(struct perf_evsel *evsel, int ncpus)
 	return evsel->counts != NULL ? 0 : -ENOMEM;
 }
 
-void perf_evsel__free_fd(struct perf_evsel *evsel)
+static void perf_evsel__free_fd(struct perf_evsel *evsel)
 {
 	xyarray__delete(evsel->fd);
 	evsel->fd = NULL;
 }
 
-void perf_evsel__free_id(struct perf_evsel *evsel)
+static void perf_evsel__free_id(struct perf_evsel *evsel)
 {
 	xyarray__delete(evsel->sample_id);
 	evsel->sample_id = NULL;
@@ -817,16 +851,17 @@ void perf_evsel__exit(struct perf_evsel *evsel)
 	assert(list_empty(&evsel->node));
 	perf_evsel__free_fd(evsel);
 	perf_evsel__free_id(evsel);
-}
-
-void perf_evsel__delete(struct perf_evsel *evsel)
-{
-	perf_evsel__exit(evsel);
 	close_cgroup(evsel->cgrp);
 	zfree(&evsel->group_name);
 	if (evsel->tp_format)
 		pevent_free_format(evsel->tp_format);
 	zfree(&evsel->name);
+	perf_evsel__object.fini(evsel);
+}
+
+void perf_evsel__delete(struct perf_evsel *evsel)
+{
+	perf_evsel__exit(evsel);
 	free(evsel);
 }
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 7bc314be6a7b..163c5604e5d1 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -7,8 +7,6 @@
 #include <linux/perf_event.h>
 #include <linux/types.h>
 #include "xyarray.h"
-#include "cgroup.h"
-#include "hist.h"
 #include "symbol.h"
 
 struct perf_counts_values {
@@ -43,6 +41,8 @@ struct perf_sample_id {
 	u64			period;
 };
 
+struct cgroup_sel;
+
 /** struct perf_evsel - event selector
  *
  * @name - Can be set to retain the original event name passed by the user,
@@ -66,7 +66,6 @@ struct perf_evsel {
 	struct perf_counts	*prev_raw_counts;
 	int			idx;
 	u32			ids;
-	struct hists		hists;
 	char			*name;
 	double			scale;
 	const char		*unit;
@@ -100,13 +99,16 @@ union u64_swap {
 	u32 val32[2];
 };
 
-#define hists_to_evsel(h) container_of(h, struct perf_evsel, hists)
-
 struct cpu_map;
+struct target;
 struct thread_map;
 struct perf_evlist;
 struct record_opts;
 
+int perf_evsel__object_config(size_t object_size,
+			      int (*init)(struct perf_evsel *evsel),
+			      void (*fini)(struct perf_evsel *evsel));
+
 struct perf_evsel *perf_evsel__new_idx(struct perf_event_attr *attr, int idx);
 
 static inline struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr)
@@ -153,12 +155,9 @@ const char *perf_evsel__name(struct perf_evsel *evsel);
 const char *perf_evsel__group_name(struct perf_evsel *evsel);
 int perf_evsel__group_desc(struct perf_evsel *evsel, char *buf, size_t size);
 
-int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads);
 int perf_evsel__alloc_counts(struct perf_evsel *evsel, int ncpus);
 void perf_evsel__reset_counts(struct perf_evsel *evsel, int ncpus);
-void perf_evsel__free_fd(struct perf_evsel *evsel);
-void perf_evsel__free_id(struct perf_evsel *evsel);
 void perf_evsel__free_counts(struct perf_evsel *evsel);
 void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 
@@ -281,8 +280,6 @@ static inline int perf_evsel__read_scaled(struct perf_evsel *evsel,
 	return __perf_evsel__read(evsel, ncpus, nthreads, true);
 }
 
-void hists__init(struct hists *hists);
-
 int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 			     struct perf_sample *sample);
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 86569fa3651d..6e88b9e395df 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -3,6 +3,7 @@
 #include "hist.h"
 #include "session.h"
 #include "sort.h"
+#include "evlist.h"
 #include "evsel.h"
 #include "annotate.h"
 #include <math.h>
@@ -14,13 +15,6 @@ static bool hists__filter_entry_by_thread(struct hists *hists,
 static bool hists__filter_entry_by_symbol(struct hists *hists,
 					  struct hist_entry *he);
 
-struct callchain_param	callchain_param = {
-	.mode	= CHAIN_GRAPH_REL,
-	.min_percent = 0.5,
-	.order  = ORDER_CALLEE,
-	.key	= CCKEY_FUNCTION
-};
-
 u16 hists__col_len(struct hists *hists, enum hist_column col)
 {
 	return hists->col_len[col];
@@ -516,6 +510,7 @@ iter_add_single_mem_entry(struct hist_entry_iter *iter, struct addr_location *al
 {
 	u64 cost;
 	struct mem_info *mi = iter->priv;
+	struct hists *hists = evsel__hists(iter->evsel);
 	struct hist_entry *he;
 
 	if (mi == NULL)
@@ -532,7 +527,7 @@ iter_add_single_mem_entry(struct hist_entry_iter *iter, struct addr_location *al
 	 * and this is indirectly achieved by passing period=weight here
 	 * and the he_stat__add_period() function.
 	 */
-	he = __hists__add_entry(&iter->evsel->hists, al, iter->parent, NULL, mi,
+	he = __hists__add_entry(hists, al, iter->parent, NULL, mi,
 				cost, cost, 0, true);
 	if (!he)
 		return -ENOMEM;
@@ -546,13 +541,14 @@ iter_finish_mem_entry(struct hist_entry_iter *iter,
 		      struct addr_location *al __maybe_unused)
 {
 	struct perf_evsel *evsel = iter->evsel;
+	struct hists *hists = evsel__hists(evsel);
 	struct hist_entry *he = iter->he;
 	int err = -EINVAL;
 
 	if (he == NULL)
 		goto out;
 
-	hists__inc_nr_samples(&evsel->hists, he->filtered);
+	hists__inc_nr_samples(hists, he->filtered);
 
 	err = hist_entry__append_callchain(he, iter->sample);
 
@@ -618,6 +614,7 @@ iter_add_next_branch_entry(struct hist_entry_iter *iter, struct addr_location *a
 {
 	struct branch_info *bi;
 	struct perf_evsel *evsel = iter->evsel;
+	struct hists *hists = evsel__hists(evsel);
 	struct hist_entry *he = NULL;
 	int i = iter->curr;
 	int err = 0;
@@ -631,12 +628,12 @@ iter_add_next_branch_entry(struct hist_entry_iter *iter, struct addr_location *a
 	 * The report shows the percentage of total branches captured
 	 * and not events sampled. Thus we use a pseudo period of 1.
 	 */
-	he = __hists__add_entry(&evsel->hists, al, iter->parent, &bi[i], NULL,
+	he = __hists__add_entry(hists, al, iter->parent, &bi[i], NULL,
 				1, 1, 0, true);
 	if (he == NULL)
 		return -ENOMEM;
 
-	hists__inc_nr_samples(&evsel->hists, he->filtered);
+	hists__inc_nr_samples(hists, he->filtered);
 
 out:
 	iter->he = he;
@@ -668,7 +665,7 @@ iter_add_single_normal_entry(struct hist_entry_iter *iter, struct addr_location
 	struct perf_sample *sample = iter->sample;
 	struct hist_entry *he;
 
-	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
+	he = __hists__add_entry(evsel__hists(evsel), al, iter->parent, NULL, NULL,
 				sample->period, sample->weight,
 				sample->transaction, true);
 	if (he == NULL)
@@ -691,7 +688,7 @@ iter_finish_normal_entry(struct hist_entry_iter *iter,
 
 	iter->he = NULL;
 
-	hists__inc_nr_samples(&evsel->hists, he->filtered);
+	hists__inc_nr_samples(evsel__hists(evsel), he->filtered);
 
 	return hist_entry__append_callchain(he, sample);
 }
@@ -724,12 +721,13 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 				 struct addr_location *al)
 {
 	struct perf_evsel *evsel = iter->evsel;
+	struct hists *hists = evsel__hists(evsel);
 	struct perf_sample *sample = iter->sample;
 	struct hist_entry **he_cache = iter->priv;
 	struct hist_entry *he;
 	int err = 0;
 
-	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
+	he = __hists__add_entry(hists, al, iter->parent, NULL, NULL,
 				sample->period, sample->weight,
 				sample->transaction, true);
 	if (he == NULL)
@@ -746,7 +744,7 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 	 */
 	callchain_cursor_commit(&callchain_cursor);
 
-	hists__inc_nr_samples(&evsel->hists, he->filtered);
+	hists__inc_nr_samples(hists, he->filtered);
 
 	return err;
 }
@@ -802,7 +800,7 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 		}
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
+	he = __hists__add_entry(evsel__hists(evsel), al, iter->parent, NULL, NULL,
 				sample->period, sample->weight,
 				sample->transaction, false);
 	if (he == NULL)
@@ -1408,6 +1406,21 @@ int hists__link(struct hists *leader, struct hists *other)
 	return 0;
 }
 
+
+size_t perf_evlist__fprintf_nr_events(struct perf_evlist *evlist, FILE *fp)
+{
+	struct perf_evsel *pos;
+	size_t ret = 0;
+
+	evlist__for_each(evlist, pos) {
+		ret += fprintf(fp, "%s stats:\n", perf_evsel__name(pos));
+		ret += events_stats__fprintf(&evsel__hists(pos)->stats, fp);
+	}
+
+	return ret;
+}
+
+
 u64 hists__total_period(struct hists *hists)
 {
 	return symbol_conf.filter_relative ? hists->stats.total_non_filtered_period :
@@ -1434,3 +1447,31 @@ int perf_hist_config(const char *var, const char *value)
 
 	return 0;
 }
+
+static int hists_evsel__init(struct perf_evsel *evsel)
+{
+	struct hists *hists = evsel__hists(evsel);
+
+	memset(hists, 0, sizeof(*hists));
+	hists->entries_in_array[0] = hists->entries_in_array[1] = RB_ROOT;
+	hists->entries_in = &hists->entries_in_array[0];
+	hists->entries_collapsed = RB_ROOT;
+	hists->entries = RB_ROOT;
+	pthread_mutex_init(&hists->lock, NULL);
+	return 0;
+}
+
+/*
+ * XXX We probably need a hists_evsel__exit() to free the hist_entries
+ * stored in the rbtree...
+ */
+
+int hists__init(void)
+{
+	int err = perf_evsel__object_config(sizeof(struct hists_evsel),
+					    hists_evsel__init, NULL);
+	if (err)
+		fputs("FATAL ERROR: Couldn't setup hists class\n", stderr);
+
+	return err;
+}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 8c9c70e18cbb..d0ef9a19a744 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -4,12 +4,11 @@
 #include <linux/types.h>
 #include <pthread.h>
 #include "callchain.h"
+#include "evsel.h"
 #include "header.h"
 #include "color.h"
 #include "ui/progress.h"
 
-extern struct callchain_param callchain_param;
-
 struct hist_entry;
 struct addr_location;
 struct symbol;
@@ -23,32 +22,6 @@ enum hist_filter {
 	HIST_FILTER__HOST,
 };
 
-/*
- * The kernel collects the number of events it couldn't send in a stretch and
- * when possible sends this number in a PERF_RECORD_LOST event. The number of
- * such "chunks" of lost events is stored in .nr_events[PERF_EVENT_LOST] while
- * total_lost tells exactly how many events the kernel in fact lost, i.e. it is
- * the sum of all struct lost_event.lost fields reported.
- *
- * The total_period is needed because by default auto-freq is used, so
- * multipling nr_events[PERF_EVENT_SAMPLE] by a frequency isn't possible to get
- * the total number of low level events, it is necessary to to sum all struct
- * sample_event.period and stash the result in total_period.
- */
-struct events_stats {
-	u64 total_period;
-	u64 total_non_filtered_period;
-	u64 total_lost;
-	u64 total_invalid_chains;
-	u32 nr_events[PERF_RECORD_HEADER_MAX];
-	u32 nr_non_filtered_samples;
-	u32 nr_lost_warned;
-	u32 nr_unknown_events;
-	u32 nr_invalid_chains;
-	u32 nr_unknown_id;
-	u32 nr_unprocessable_samples;
-};
-
 enum hist_column {
 	HISTC_SYMBOL,
 	HISTC_DSO,
@@ -165,6 +138,7 @@ size_t events_stats__fprintf(struct events_stats *stats, FILE *fp);
 
 size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		      int max_cols, float min_pcnt, FILE *fp);
+size_t perf_evlist__fprintf_nr_events(struct perf_evlist *evlist, FILE *fp);
 
 void hists__filter_by_dso(struct hists *hists);
 void hists__filter_by_thread(struct hists *hists);
@@ -185,6 +159,25 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *he);
 void hists__match(struct hists *leader, struct hists *other);
 int hists__link(struct hists *leader, struct hists *other);
 
+struct hists_evsel {
+	struct perf_evsel evsel;
+	struct hists	  hists;
+};
+
+static inline struct perf_evsel *hists_to_evsel(struct hists *hists)
+{
+	struct hists_evsel *hevsel = container_of(hists, struct hists_evsel, hists);
+	return &hevsel->evsel;
+}
+
+static inline struct hists *evsel__hists(struct perf_evsel *evsel)
+{
+	struct hists_evsel *hevsel = (struct hists_evsel *)evsel;
+	return &hevsel->hists;
+}
+
+int hists__init(void);
+
 struct perf_hpp {
 	char *buf;
 	size_t size;
diff --git a/tools/perf/util/include/linux/string.h b/tools/perf/util/include/linux/string.h
index 97a800738226..6f19c548ecc0 100644
--- a/tools/perf/util/include/linux/string.h
+++ b/tools/perf/util/include/linux/string.h
@@ -1,4 +1,3 @@
 #include <string.h>
 
 void *memdup(const void *src, size_t len);
-int str_append(char **s, int *len, const char *a);
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index b7d477fbda02..34fc7c8672e4 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -13,12 +13,18 @@
 #include <symbol/kallsyms.h>
 #include "unwind.h"
 
+static void dsos__init(struct dsos *dsos)
+{
+	INIT_LIST_HEAD(&dsos->head);
+	dsos->root = RB_ROOT;
+}
+
 int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 {
 	map_groups__init(&machine->kmaps);
 	RB_CLEAR_NODE(&machine->rb_node);
-	INIT_LIST_HEAD(&machine->user_dsos.head);
-	INIT_LIST_HEAD(&machine->kernel_dsos.head);
+	dsos__init(&machine->user_dsos);
+	dsos__init(&machine->kernel_dsos);
 
 	machine->threads = RB_ROOT;
 	INIT_LIST_HEAD(&machine->dead_threads);
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index b7090596ac50..2137c4596ec7 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -556,7 +556,7 @@ struct symbol *map_groups__find_symbol_by_name(struct map_groups *mg,
 
 int map_groups__find_ams(struct addr_map_symbol *ams, symbol_filter_t filter)
 {
-	if (ams->addr < ams->map->start || ams->addr > ams->map->end) {
+	if (ams->addr < ams->map->start || ams->addr >= ams->map->end) {
 		if (ams->map->groups == NULL)
 			return -1;
 		ams->map = map_groups__find(ams->map->groups, ams->map->type,
@@ -664,7 +664,7 @@ int map_groups__fixup_overlappings(struct map_groups *mg, struct map *map,
 				goto move_map;
 			}
 
-			before->end = map->start - 1;
+			before->end = map->start;
 			map_groups__insert(mg, before);
 			if (verbose >= 2)
 				map__fprintf(before, fp);
@@ -678,7 +678,7 @@ int map_groups__fixup_overlappings(struct map_groups *mg, struct map *map,
 				goto move_map;
 			}
 
-			after->start = map->end + 1;
+			after->start = map->end;
 			map_groups__insert(mg, after);
 			if (verbose >= 2)
 				map__fprintf(after, fp);
@@ -752,7 +752,7 @@ struct map *maps__find(struct rb_root *maps, u64 ip)
 		m = rb_entry(parent, struct map, rb_node);
 		if (ip < m->start)
 			p = &(*p)->rb_left;
-		else if (ip > m->end)
+		else if (ip >= m->end)
 			p = &(*p)->rb_right;
 		else
 			return m;
diff --git a/tools/perf/util/ordered-events.c b/tools/perf/util/ordered-events.c
index 706ce1a66169..fd4be94125fb 100644
--- a/tools/perf/util/ordered-events.c
+++ b/tools/perf/util/ordered-events.c
@@ -1,5 +1,6 @@
 #include <linux/list.h>
 #include <linux/compiler.h>
+#include <linux/string.h>
 #include "ordered-events.h"
 #include "evlist.h"
 #include "session.h"
@@ -57,11 +58,45 @@ static void queue_event(struct ordered_events *oe, struct ordered_event *new)
 	}
 }
 
+static union perf_event *__dup_event(struct ordered_events *oe,
+				     union perf_event *event)
+{
+	union perf_event *new_event = NULL;
+
+	if (oe->cur_alloc_size < oe->max_alloc_size) {
+		new_event = memdup(event, event->header.size);
+		if (new_event)
+			oe->cur_alloc_size += event->header.size;
+	}
+
+	return new_event;
+}
+
+static union perf_event *dup_event(struct ordered_events *oe,
+				   union perf_event *event)
+{
+	return oe->copy_on_queue ? __dup_event(oe, event) : event;
+}
+
+static void free_dup_event(struct ordered_events *oe, union perf_event *event)
+{
+	if (oe->copy_on_queue) {
+		oe->cur_alloc_size -= event->header.size;
+		free(event);
+	}
+}
+
 #define MAX_SAMPLE_BUFFER	(64 * 1024 / sizeof(struct ordered_event))
-static struct ordered_event *alloc_event(struct ordered_events *oe)
+static struct ordered_event *alloc_event(struct ordered_events *oe,
+					 union perf_event *event)
 {
 	struct list_head *cache = &oe->cache;
 	struct ordered_event *new = NULL;
+	union perf_event *new_event;
+
+	new_event = dup_event(oe, event);
+	if (!new_event)
+		return NULL;
 
 	if (!list_empty(cache)) {
 		new = list_entry(cache->next, struct ordered_event, list);
@@ -74,8 +109,10 @@ static struct ordered_event *alloc_event(struct ordered_events *oe)
 		size_t size = MAX_SAMPLE_BUFFER * sizeof(*new);
 
 		oe->buffer = malloc(size);
-		if (!oe->buffer)
+		if (!oe->buffer) {
+			free_dup_event(oe, new_event);
 			return NULL;
+		}
 
 		pr("alloc size %" PRIu64 "B (+%zu), max %" PRIu64 "B\n",
 		   oe->cur_alloc_size, size, oe->max_alloc_size);
@@ -90,15 +127,17 @@ static struct ordered_event *alloc_event(struct ordered_events *oe)
 		pr("allocation limit reached %" PRIu64 "B\n", oe->max_alloc_size);
 	}
 
+	new->event = new_event;
 	return new;
 }
 
 struct ordered_event *
-ordered_events__new(struct ordered_events *oe, u64 timestamp)
+ordered_events__new(struct ordered_events *oe, u64 timestamp,
+		    union perf_event *event)
 {
 	struct ordered_event *new;
 
-	new = alloc_event(oe);
+	new = alloc_event(oe, event);
 	if (new) {
 		new->timestamp = timestamp;
 		queue_event(oe, new);
@@ -111,6 +150,7 @@ void ordered_events__delete(struct ordered_events *oe, struct ordered_event *eve
 {
 	list_move(&event->list, &oe->cache);
 	oe->nr_events--;
+	free_dup_event(oe, event->event);
 }
 
 static int __ordered_events__flush(struct perf_session *s,
@@ -240,6 +280,7 @@ void ordered_events__free(struct ordered_events *oe)
 
 		event = list_entry(oe->to_free.next, struct ordered_event, list);
 		list_del(&event->list);
+		free_dup_event(oe, event->event);
 		free(event);
 	}
 }
diff --git a/tools/perf/util/ordered-events.h b/tools/perf/util/ordered-events.h
index 3b2f20542a01..7b8f9b011f38 100644
--- a/tools/perf/util/ordered-events.h
+++ b/tools/perf/util/ordered-events.h
@@ -34,9 +34,11 @@ struct ordered_events {
 	int			buffer_idx;
 	unsigned int		nr_events;
 	enum oe_flush		last_flush_type;
+	bool                    copy_on_queue;
 };
 
-struct ordered_event *ordered_events__new(struct ordered_events *oe, u64 timestamp);
+struct ordered_event *ordered_events__new(struct ordered_events *oe, u64 timestamp,
+					  union perf_event *event);
 void ordered_events__delete(struct ordered_events *oe, struct ordered_event *event);
 int ordered_events__flush(struct perf_session *s, struct perf_tool *tool,
 			  enum oe_flush how);
@@ -48,4 +50,10 @@ void ordered_events__set_alloc_size(struct ordered_events *oe, u64 size)
 {
 	oe->max_alloc_size = size;
 }
+
+static inline
+void ordered_events__set_copy_on_queue(struct ordered_events *oe, bool copy)
+{
+	oe->copy_on_queue = copy;
+}
 #endif /* __ORDERED_EVENTS_H */
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index d76aa30cb1fb..c659a3ca1283 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -6,7 +6,7 @@
 #include "parse-options.h"
 #include "parse-events.h"
 #include "exec_cmd.h"
-#include "linux/string.h"
+#include "string.h"
 #include "symbol.h"
 #include "cache.h"
 #include "header.h"
@@ -30,6 +30,15 @@ extern int parse_events_debug;
 #endif
 int parse_events_parse(void *data, void *scanner);
 
+static struct perf_pmu_event_symbol *perf_pmu_events_list;
+/*
+ * The variable indicates the number of supported pmu event symbols.
+ * 0 means not initialized and ready to init
+ * -1 means failed to init, don't try anymore
+ * >0 is the number of supported pmu event symbols
+ */
+static int perf_pmu_events_list_num;
+
 static struct event_symbol event_symbols_hw[PERF_COUNT_HW_MAX] = {
 	[PERF_COUNT_HW_CPU_CYCLES] = {
 		.symbol = "cpu-cycles",
@@ -863,30 +872,111 @@ int parse_events_name(struct list_head *list, char *name)
 	return 0;
 }
 
-static int parse_events__scanner(const char *str, void *data, int start_token);
+static int
+comp_pmu(const void *p1, const void *p2)
+{
+	struct perf_pmu_event_symbol *pmu1 = (struct perf_pmu_event_symbol *) p1;
+	struct perf_pmu_event_symbol *pmu2 = (struct perf_pmu_event_symbol *) p2;
 
-static int parse_events_fixup(int ret, const char *str, void *data,
-			      int start_token)
+	return strcmp(pmu1->symbol, pmu2->symbol);
+}
+
+static void perf_pmu__parse_cleanup(void)
 {
-	char *o = strdup(str);
-	char *s = NULL;
-	char *t = o;
-	char *p;
+	if (perf_pmu_events_list_num > 0) {
+		struct perf_pmu_event_symbol *p;
+		int i;
+
+		for (i = 0; i < perf_pmu_events_list_num; i++) {
+			p = perf_pmu_events_list + i;
+			free(p->symbol);
+		}
+		free(perf_pmu_events_list);
+		perf_pmu_events_list = NULL;
+		perf_pmu_events_list_num = 0;
+	}
+}
+
+#define SET_SYMBOL(str, stype)		\
+do {					\
+	p->symbol = str;		\
+	if (!p->symbol)			\
+		goto err;		\
+	p->type = stype;		\
+} while (0)
+
+/*
+ * Read the pmu events list from sysfs
+ * Save it into perf_pmu_events_list
+ */
+static void perf_pmu__parse_init(void)
+{
+
+	struct perf_pmu *pmu = NULL;
+	struct perf_pmu_alias *alias;
 	int len = 0;
 
-	if (!o)
-		return ret;
-	while ((p = strsep(&t, ",")) != NULL) {
-		if (s)
-			str_append(&s, &len, ",");
-		str_append(&s, &len, "cpu/");
-		str_append(&s, &len, p);
-		str_append(&s, &len, "/");
+	pmu = perf_pmu__find("cpu");
+	if ((pmu == NULL) || list_empty(&pmu->aliases)) {
+		perf_pmu_events_list_num = -1;
+		return;
 	}
-	free(o);
-	if (!s)
-		return -ENOMEM;
-	return parse_events__scanner(s, data, start_token);
+	list_for_each_entry(alias, &pmu->aliases, list) {
+		if (strchr(alias->name, '-'))
+			len++;
+		len++;
+	}
+	perf_pmu_events_list = malloc(sizeof(struct perf_pmu_event_symbol) * len);
+	if (!perf_pmu_events_list)
+		return;
+	perf_pmu_events_list_num = len;
+
+	len = 0;
+	list_for_each_entry(alias, &pmu->aliases, list) {
+		struct perf_pmu_event_symbol *p = perf_pmu_events_list + len;
+		char *tmp = strchr(alias->name, '-');
+
+		if (tmp != NULL) {
+			SET_SYMBOL(strndup(alias->name, tmp - alias->name),
+					PMU_EVENT_SYMBOL_PREFIX);
+			p++;
+			SET_SYMBOL(strdup(++tmp), PMU_EVENT_SYMBOL_SUFFIX);
+			len += 2;
+		} else {
+			SET_SYMBOL(strdup(alias->name), PMU_EVENT_SYMBOL);
+			len++;
+		}
+	}
+	qsort(perf_pmu_events_list, len,
+		sizeof(struct perf_pmu_event_symbol), comp_pmu);
+
+	return;
+err:
+	perf_pmu__parse_cleanup();
+}
+
+enum perf_pmu_event_symbol_type
+perf_pmu__parse_check(const char *name)
+{
+	struct perf_pmu_event_symbol p, *r;
+
+	/* scan kernel pmu events from sysfs if needed */
+	if (perf_pmu_events_list_num == 0)
+		perf_pmu__parse_init();
+	/*
+	 * name "cpu" could be prefix of cpu-cycles or cpu// events.
+	 * cpu-cycles has been handled by hardcode.
+	 * So it must be cpu// events, not kernel pmu event.
+	 */
+	if ((perf_pmu_events_list_num <= 0) || !strcmp(name, "cpu"))
+		return PMU_EVENT_SYMBOL_ERR;
+
+	p.symbol = strdup(name);
+	r = bsearch(&p, perf_pmu_events_list,
+			(size_t) perf_pmu_events_list_num,
+			sizeof(struct perf_pmu_event_symbol), comp_pmu);
+	free(p.symbol);
+	return r ? r->type : PMU_EVENT_SYMBOL_ERR;
 }
 
 static int parse_events__scanner(const char *str, void *data, int start_token)
@@ -909,8 +999,6 @@ static int parse_events__scanner(const char *str, void *data, int start_token)
 	parse_events__flush_buffer(buffer, scanner);
 	parse_events__delete_buffer(buffer, scanner);
 	parse_events_lex_destroy(scanner);
-	if (ret && !strchr(str, '/'))
-		ret = parse_events_fixup(ret, str, data, start_token);
 	return ret;
 }
 
@@ -945,6 +1033,7 @@ int parse_events(struct perf_evlist *evlist, const char *str)
 	int ret;
 
 	ret = parse_events__scanner(str, &data, PE_START_EVENTS);
+	perf_pmu__parse_cleanup();
 	if (!ret) {
 		int entries = data.idx - evlist->nr_entries;
 		perf_evlist__splice_list_tail(evlist, &data.list, entries);
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index df094b4ed5ed..db2cf78ff0f3 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -35,6 +35,18 @@ extern int parse_filter(const struct option *opt, const char *str, int unset);
 
 #define EVENTS_HELP_MAX (128*1024)
 
+enum perf_pmu_event_symbol_type {
+	PMU_EVENT_SYMBOL_ERR,		/* not a PMU EVENT */
+	PMU_EVENT_SYMBOL,		/* normal style PMU event */
+	PMU_EVENT_SYMBOL_PREFIX,	/* prefix of pre-suf style event */
+	PMU_EVENT_SYMBOL_SUFFIX,	/* suffix of pre-suf style event */
+};
+
+struct perf_pmu_event_symbol {
+	char	*symbol;
+	enum perf_pmu_event_symbol_type	type;
+};
+
 enum {
 	PARSE_EVENTS__TERM_TYPE_NUM,
 	PARSE_EVENTS__TERM_TYPE_STR,
@@ -95,6 +107,8 @@ int parse_events_add_breakpoint(struct list_head *list, int *idx,
 				void *ptr, char *type);
 int parse_events_add_pmu(struct list_head *list, int *idx,
 			 char *pmu , struct list_head *head_config);
+enum perf_pmu_event_symbol_type
+perf_pmu__parse_check(const char *name);
 void parse_events__set_leader(char *name, struct list_head *list);
 void parse_events_update_lists(struct list_head *list_event,
 			       struct list_head *list_all);
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 343299575b30..906630bbf8eb 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -51,6 +51,24 @@ static int str(yyscan_t scanner, int token)
 	return token;
 }
 
+static int pmu_str_check(yyscan_t scanner)
+{
+	YYSTYPE *yylval = parse_events_get_lval(scanner);
+	char *text = parse_events_get_text(scanner);
+
+	yylval->str = strdup(text);
+	switch (perf_pmu__parse_check(text)) {
+		case PMU_EVENT_SYMBOL_PREFIX:
+			return PE_PMU_EVENT_PRE;
+		case PMU_EVENT_SYMBOL_SUFFIX:
+			return PE_PMU_EVENT_SUF;
+		case PMU_EVENT_SYMBOL:
+			return PE_KERNEL_PMU_EVENT;
+		default:
+			return PE_NAME;
+	}
+}
+
 static int sym(yyscan_t scanner, int type, int config)
 {
 	YYSTYPE *yylval = parse_events_get_lval(scanner);
@@ -178,6 +196,16 @@ alignment-faults				{ return sym(yyscanner, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_AL
 emulation-faults				{ return sym(yyscanner, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_EMULATION_FAULTS); }
 dummy						{ return sym(yyscanner, PERF_TYPE_SOFTWARE, PERF_COUNT_SW_DUMMY); }
 
+	/*
+	 * We have to handle the kernel PMU event cycles-ct/cycles-t/mem-loads/mem-stores separately.
+	 * Because the prefix cycles is mixed up with cpu-cycles.
+	 * loads and stores are mixed up with cache event
+	 */
+cycles-ct					{ return str(yyscanner, PE_KERNEL_PMU_EVENT); }
+cycles-t					{ return str(yyscanner, PE_KERNEL_PMU_EVENT); }
+mem-loads					{ return str(yyscanner, PE_KERNEL_PMU_EVENT); }
+mem-stores					{ return str(yyscanner, PE_KERNEL_PMU_EVENT); }
+
 L1-dcache|l1-d|l1d|L1-data		|
 L1-icache|l1-i|l1i|L1-instruction	|
 LLC|L2					|
@@ -199,7 +227,7 @@ r{num_raw_hex}		{ return raw(yyscanner); }
 {num_hex}		{ return value(yyscanner, 16); }
 
 {modifier_event}	{ return str(yyscanner, PE_MODIFIER_EVENT); }
-{name}			{ return str(yyscanner, PE_NAME); }
+{name}			{ return pmu_str_check(yyscanner); }
 "/"			{ BEGIN(config); return '/'; }
 -			{ return '-'; }
 ,			{ BEGIN(event); return ','; }
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 55fab6ad609a..93c4c9fbc922 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -47,6 +47,7 @@ static inc_group_count(struct list_head *list,
 %token PE_NAME_CACHE_TYPE PE_NAME_CACHE_OP_RESULT
 %token PE_PREFIX_MEM PE_PREFIX_RAW PE_PREFIX_GROUP
 %token PE_ERROR
+%token PE_PMU_EVENT_PRE PE_PMU_EVENT_SUF PE_KERNEL_PMU_EVENT
 %type <num> PE_VALUE
 %type <num> PE_VALUE_SYM_HW
 %type <num> PE_VALUE_SYM_SW
@@ -58,6 +59,7 @@ static inc_group_count(struct list_head *list,
 %type <str> PE_MODIFIER_EVENT
 %type <str> PE_MODIFIER_BP
 %type <str> PE_EVENT_NAME
+%type <str> PE_PMU_EVENT_PRE PE_PMU_EVENT_SUF PE_KERNEL_PMU_EVENT
 %type <num> value_sym
 %type <head> event_config
 %type <term> event_term
@@ -220,6 +222,44 @@ PE_NAME '/' '/'
 	ABORT_ON(parse_events_add_pmu(list, &data->idx, $1, NULL));
 	$$ = list;
 }
+|
+PE_KERNEL_PMU_EVENT sep_dc
+{
+	struct parse_events_evlist *data = _data;
+	struct list_head *head;
+	struct parse_events_term *term;
+	struct list_head *list;
+
+	ALLOC_LIST(head);
+	ABORT_ON(parse_events_term__num(&term, PARSE_EVENTS__TERM_TYPE_USER,
+					$1, 1));
+	list_add_tail(&term->list, head);
+
+	ALLOC_LIST(list);
+	ABORT_ON(parse_events_add_pmu(list, &data->idx, "cpu", head));
+	parse_events__free_terms(head);
+	$$ = list;
+}
+|
+PE_PMU_EVENT_PRE '-' PE_PMU_EVENT_SUF sep_dc
+{
+	struct parse_events_evlist *data = _data;
+	struct list_head *head;
+	struct parse_events_term *term;
+	struct list_head *list;
+	char pmu_name[128];
+	snprintf(&pmu_name, 128, "%s-%s", $1, $3);
+
+	ALLOC_LIST(head);
+	ABORT_ON(parse_events_term__num(&term, PARSE_EVENTS__TERM_TYPE_USER,
+					&pmu_name, 1));
+	list_add_tail(&term->list, head);
+
+	ALLOC_LIST(list);
+	ABORT_ON(parse_events_add_pmu(list, &data->idx, "cpu", head));
+	parse_events__free_terms(head);
+	$$ = list;
+}
 
 value_sym:
 PE_VALUE_SYM_HW
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 93a41ca96b8e..e243ad962a4d 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -12,16 +12,6 @@
 #include "parse-events.h"
 #include "cpumap.h"
 
-#define UNIT_MAX_LEN	31 /* max length for event unit name */
-
-struct perf_pmu_alias {
-	char *name;
-	struct list_head terms; /* HEAD struct parse_events_term -> list */
-	struct list_head list;  /* ELEM */
-	char unit[UNIT_MAX_LEN+1];
-	double scale;
-};
-
 struct perf_pmu_format {
 	char *name;
 	int value;
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index fe90a012c003..fe9dfbee8eed 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -30,6 +30,16 @@ struct perf_pmu_info {
 	double scale;
 };
 
+#define UNIT_MAX_LEN	31 /* max length for event unit name */
+
+struct perf_pmu_alias {
+	char *name;
+	struct list_head terms; /* HEAD struct parse_events_term -> list */
+	struct list_head list;  /* ELEM */
+	char unit[UNIT_MAX_LEN+1];
+	double scale;
+};
+
 struct perf_pmu *perf_pmu__find(const char *name);
 int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
 		     struct list_head *head_terms);
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 56ba07cce549..496f21cadd97 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -28,6 +28,7 @@
 
 #include "../../perf.h"
 #include "../debug.h"
+#include "../callchain.h"
 #include "../evsel.h"
 #include "../util.h"
 #include "../event.h"
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 883406f4b381..6702ac28754b 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -532,17 +532,16 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 			return -EINVAL;
 	}
 
-	new = ordered_events__new(oe, timestamp);
+	new = ordered_events__new(oe, timestamp, event);
 	if (!new) {
 		ordered_events__flush(s, tool, OE_FLUSH__HALF);
-		new = ordered_events__new(oe, timestamp);
+		new = ordered_events__new(oe, timestamp, event);
 	}
 
 	if (!new)
 		return -ENOMEM;
 
 	new->file_offset = file_offset;
-	new->event = event;
 	return 0;
 }
 
@@ -813,22 +812,6 @@ int perf_session__deliver_event(struct perf_session *session,
 	dump_event(session, event, file_offset, sample);
 
 	evsel = perf_evlist__id2evsel(session->evlist, sample->id);
-	if (evsel != NULL && event->header.type != PERF_RECORD_SAMPLE) {
-		/*
-		 * XXX We're leaving PERF_RECORD_SAMPLE unnacounted here
-		 * because the tools right now may apply filters, discarding
-		 * some of the samples. For consistency, in the future we
-		 * should have something like nr_filtered_samples and remove
-		 * the sample->period from total_sample_period, etc, KISS for
-		 * now tho.
-		 *
-		 * Also testing against NULL allows us to handle files without
-		 * attr.sample_id_all and/or without PERF_SAMPLE_ID. In the
-		 * future probably it'll be a good idea to restrict event
-		 * processing via perf_session to files with both set.
-		 */
-		hists__inc_nr_events(&evsel->hists, event->header.type);
-	}
 
 	machine = perf_session__find_machine_for_cpumode(session, event,
 							 sample);
@@ -1391,16 +1374,9 @@ size_t perf_session__fprintf_dsos_buildid(struct perf_session *session, FILE *fp
 
 size_t perf_session__fprintf_nr_events(struct perf_session *session, FILE *fp)
 {
-	struct perf_evsel *pos;
 	size_t ret = fprintf(fp, "Aggregated stats:\n");
 
 	ret += events_stats__fprintf(&session->stats, fp);
-
-	evlist__for_each(session->evlist, pos) {
-		ret += fprintf(fp, "%s stats:\n", perf_evsel__name(pos));
-		ret += events_stats__fprintf(&pos->hists.stats, fp);
-	}
-
 	return ret;
 }
 
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index ffb440462008..a4be851f1a90 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -2,7 +2,6 @@
 #define __PERF_SESSION_H
 
 #include "trace-event.h"
-#include "hist.h"
 #include "event.h"
 #include "header.h"
 #include "machine.h"
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 289df9d1e65a..4906cd81cb56 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1218,7 +1218,7 @@ static int __sort__hpp_header(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
 	hse = container_of(fmt, struct hpp_sort_entry, hpp);
 
 	if (!len)
-		len = hists__col_len(&evsel->hists, hse->se->se_width_idx);
+		len = hists__col_len(evsel__hists(evsel), hse->se->se_width_idx);
 
 	return scnprintf(hpp->buf, hpp->size, "%-*.*s", len, len, fmt->name);
 }
@@ -1233,7 +1233,7 @@ static int __sort__hpp_width(struct perf_hpp_fmt *fmt,
 	hse = container_of(fmt, struct hpp_sort_entry, hpp);
 
 	if (!len)
-		len = hists__col_len(&evsel->hists, hse->se->se_width_idx);
+		len = hists__col_len(evsel__hists(evsel), hse->se->se_width_idx);
 
 	return len;
 }
diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index d87767f76903..6afd6106ceb5 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -357,27 +357,3 @@ void *memdup(const void *src, size_t len)
 
 	return p;
 }
-
-/**
- * str_append - reallocate string and append another
- * @s: pointer to string pointer
- * @len: pointer to len (initialized)
- * @a: string to append.
- */
-int str_append(char **s, int *len, const char *a)
-{
-	int olen = *s ? strlen(*s) : 0;
-	int nlen = olen + strlen(a) + 1;
-	if (*len < nlen) {
-		*len = *len * 2;
-		if (*len < nlen)
-			*len = nlen;
-		*s = realloc(*s, *len);
-		if (!*s)
-			return -ENOMEM;
-		if (olen == 0)
-			**s = 0;
-	}
-	strcat(*s, a);
-	return 0;
-}
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index be84f7a9838b..078331140d8c 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -186,7 +186,7 @@ void symbols__fixup_end(struct rb_root *symbols)
 		curr = rb_entry(nd, struct symbol, rb_node);
 
 		if (prev->end == prev->start && prev->end != curr->start)
-			prev->end = curr->start - 1;
+			prev->end = curr->start;
 	}
 
 	/* Last entry */
@@ -207,7 +207,7 @@ void __map_groups__fixup_end(struct map_groups *mg, enum map_type type)
 	for (nd = rb_next(prevnd); nd; nd = rb_next(nd)) {
 		prev = curr;
 		curr = rb_entry(nd, struct map, rb_node);
-		prev->end = curr->start - 1;
+		prev->end = curr->start;
 	}
 
 	/*
@@ -229,7 +229,7 @@ struct symbol *symbol__new(u64 start, u64 len, u8 binding, const char *name)
 		sym = ((void *)sym) + symbol_conf.priv_size;
 
 	sym->start   = start;
-	sym->end     = len ? start + len - 1 : start;
+	sym->end     = len ? start + len : start;
 	sym->binding = binding;
 	sym->namelen = namelen - 1;
 
@@ -325,7 +325,7 @@ static struct symbol *symbols__find(struct rb_root *symbols, u64 ip)
 
 		if (ip < s->start)
 			n = n->rb_left;
-		else if (ip > s->end)
+		else if (ip >= s->end)
 			n = n->rb_right;
 		else
 			return s;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index bec4b7bd09de..eb2c19bf8d90 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -95,7 +95,7 @@ void symbols__delete(struct rb_root *symbols);
 
 static inline size_t symbol__size(const struct symbol *sym)
 {
-	return sym->end - sym->start + 1;
+	return sym->end - sym->start;
 }
 
 struct strlist;
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index a9df7f2c6dc9..2b7b2d91c016 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -7,6 +7,7 @@
 #include "util.h"
 #include "debug.h"
 #include "comm.h"
+#include "unwind.h"
 
 int thread__init_map_groups(struct thread *thread, struct machine *machine)
 {
@@ -37,6 +38,9 @@ struct thread *thread__new(pid_t pid, pid_t tid)
 		thread->cpu = -1;
 		INIT_LIST_HEAD(&thread->comm_list);
 
+		if (unwind__prepare_access(thread) < 0)
+			goto err_thread;
+
 		comm_str = malloc(32);
 		if (!comm_str)
 			goto err_thread;
@@ -48,6 +52,7 @@ struct thread *thread__new(pid_t pid, pid_t tid)
 			goto err_thread;
 
 		list_add(&comm->list, &thread->comm_list);
+
 	}
 
 	return thread;
@@ -69,6 +74,7 @@ void thread__delete(struct thread *thread)
 		list_del(&comm->list);
 		comm__free(comm);
 	}
+	unwind__finish_access(thread);
 
 	free(thread);
 }
diff --git a/tools/perf/util/thread_map.c b/tools/perf/util/thread_map.c
index 5d3215912105..f93b9734735b 100644
--- a/tools/perf/util/thread_map.c
+++ b/tools/perf/util/thread_map.c
@@ -214,6 +214,17 @@ static struct thread_map *thread_map__new_by_pid_str(const char *pid_str)
 	goto out;
 }
 
+struct thread_map *thread_map__new_dummy(void)
+{
+	struct thread_map *threads = malloc(sizeof(*threads) + sizeof(pid_t));
+
+	if (threads != NULL) {
+		threads->map[0]	= -1;
+		threads->nr	= 1;
+	}
+	return threads;
+}
+
 static struct thread_map *thread_map__new_by_tid_str(const char *tid_str)
 {
 	struct thread_map *threads = NULL, *nt;
@@ -224,14 +235,8 @@ static struct thread_map *thread_map__new_by_tid_str(const char *tid_str)
 	struct strlist *slist;
 
 	/* perf-stat expects threads to be generated even if tid not given */
-	if (!tid_str) {
-		threads = malloc(sizeof(*threads) + sizeof(pid_t));
-		if (threads != NULL) {
-			threads->map[0] = -1;
-			threads->nr	= 1;
-		}
-		return threads;
-	}
+	if (!tid_str)
+		return thread_map__new_dummy();
 
 	slist = strlist__new(false, tid_str);
 	if (!slist)
diff --git a/tools/perf/util/thread_map.h b/tools/perf/util/thread_map.h
index 0cd8b3108084..95313f43cc0f 100644
--- a/tools/perf/util/thread_map.h
+++ b/tools/perf/util/thread_map.h
@@ -9,6 +9,7 @@ struct thread_map {
 	pid_t map[];
 };
 
+struct thread_map *thread_map__new_dummy(void);
 struct thread_map *thread_map__new_by_pid(pid_t pid);
 struct thread_map *thread_map__new_by_tid(pid_t tid);
 struct thread_map *thread_map__new_by_uid(uid_t uid);
diff --git a/tools/perf/util/unwind-libunwind.c b/tools/perf/util/unwind-libunwind.c
index 92b56db52471..e060386165c5 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -24,6 +24,7 @@
 #include <linux/list.h>
 #include <libunwind.h>
 #include <libunwind-ptrace.h>
+#include "callchain.h"
 #include "thread.h"
 #include "session.h"
 #include "perf_regs.h"
@@ -525,12 +526,12 @@ static unw_accessors_t accessors = {
 	.get_proc_name		= get_proc_name,
 };
 
-static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
-		       void *arg, int max_stack)
+int unwind__prepare_access(struct thread *thread)
 {
 	unw_addr_space_t addr_space;
-	unw_cursor_t c;
-	int ret;
+
+	if (callchain_param.record_mode != CALLCHAIN_DWARF)
+		return 0;
 
 	addr_space = unw_create_addr_space(&accessors, 0);
 	if (!addr_space) {
@@ -538,6 +539,33 @@ static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
 		return -ENOMEM;
 	}
 
+	thread__set_priv(thread, addr_space);
+
+	return 0;
+}
+
+void unwind__finish_access(struct thread *thread)
+{
+	unw_addr_space_t addr_space;
+
+	if (callchain_param.record_mode != CALLCHAIN_DWARF)
+		return;
+
+	addr_space = thread__priv(thread);
+	unw_destroy_addr_space(addr_space);
+}
+
+static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
+		       void *arg, int max_stack)
+{
+	unw_addr_space_t addr_space;
+	unw_cursor_t c;
+	int ret;
+
+	addr_space = thread__priv(ui->thread);
+	if (addr_space == NULL)
+		return -1;
+
 	ret = unw_init_remote(&c, addr_space, ui);
 	if (ret)
 		display_error(ret);
@@ -549,7 +577,6 @@ static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
 		ret = ip ? entry(ip, ui->thread, ui->machine, cb, arg) : 0;
 	}
 
-	unw_destroy_addr_space(addr_space);
 	return ret;
 }
 
diff --git a/tools/perf/util/unwind.h b/tools/perf/util/unwind.h
index f03061260b4e..c17c4855bdbc 100644
--- a/tools/perf/util/unwind.h
+++ b/tools/perf/util/unwind.h
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 #include "event.h"
 #include "symbol.h"
+#include "thread.h"
 
 struct unwind_entry {
 	struct map	*map;
@@ -21,6 +22,15 @@ int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 /* libunwind specific */
 #ifdef HAVE_LIBUNWIND_SUPPORT
 int libunwind__arch_reg_id(int regnum);
+int unwind__prepare_access(struct thread *thread);
+void unwind__finish_access(struct thread *thread);
+#else
+static inline int unwind__prepare_access(struct thread *thread __maybe_unused)
+{
+	return 0;
+}
+
+static inline void unwind__finish_access(struct thread *thread __maybe_unused) {}
 #endif
 #else
 static inline int
@@ -33,5 +43,12 @@ unwind__get_entries(unwind_entry_cb_t cb __maybe_unused,
 {
 	return 0;
 }
+
+static inline int unwind__prepare_access(struct thread *thread __maybe_unused)
+{
+	return 0;
+}
+
+static inline void unwind__finish_access(struct thread *thread __maybe_unused) {}
 #endif /* HAVE_DWARF_UNWIND_SUPPORT */
 #endif /* __UNWIND_H */
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 24e8d871b74e..d5eab3f3323f 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -14,6 +14,14 @@
 #include <byteswap.h>
 #include <linux/kernel.h>
 #include <unistd.h>
+#include "callchain.h"
+
+struct callchain_param	callchain_param = {
+	.mode	= CHAIN_GRAPH_REL,
+	.min_percent = 0.5,
+	.order  = ORDER_CALLEE,
+	.key	= CCKEY_FUNCTION
+};
 
 /*
  * XXX We need to find a better place for these things...
