Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab3AZUFV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 15:05:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363Ab3AZUEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 15:04:48 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 7/8] perf tools: Add non arch events for IvyBridge micro architecture
Date: Sat, 26 Jan 2013 21:04:09 +0100
Message-Id: <1359230650-10415-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1359230650-10415-1-git-send-email-jolsa@redhat.com>
References: <1359230650-10415-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding non architectural event aliases for IvyBridge
micro architecture.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/arch/x86/events/intel/ivb | 248 +++++++++++++++++++++++++++++++++++
 tools/perf/arch/x86/util/pmu.c       |   2 +
 2 files changed, 250 insertions(+)
 create mode 100644 tools/perf/arch/x86/events/intel/ivb

diff --git a/tools/perf/arch/x86/events/intel/ivb b/tools/perf/arch/x86/events/intel/ivb
new file mode 100644
index 0000000..b07535d
--- /dev/null
+++ b/tools/perf/arch/x86/events/intel/ivb
@@ -0,0 +1,248 @@
+name=ARITH.FPU_DIV_ACTIVE,event=0x14,umask=0x1
+name=ARITH.FPU_DIV,event=0x14,umask=0x10401
+name=BACLEARS.ANY,event=0xe6,umask=0x1f
+name=BR_INST_EXEC.NONTAKEN_COND,event=0x88,umask=0x41
+name=BR_INST_EXEC.TAKEN_COND,event=0x88,umask=0x81
+name=BR_INST_EXEC.NONTAKEN_DIRECT_JUMP,event=0x88,umask=0x42
+name=BR_INST_EXEC.TAKEN_DIRECT_JUMP,event=0x88,umask=0x82
+name=BR_INST_EXEC.NONTAKEN_INDIRECT_JUMP_NON_CALL_RET,event=0x88,umask=0x44
+name=BR_INST_EXEC.TAKEN_INDIRECT_JUMP_NON_CALL_RET,event=0x88,umask=0x84
+name=BR_INST_EXEC.TAKEN_NEAR_RETURN,event=0x88,umask=0x88
+name=BR_INST_EXEC.TAKEN_DIRECT_NEAR_CALL,event=0x88,umask=0x90
+name=BR_INST_EXEC.TAKEN_INDIRECT_NEAR_CALL,event=0x88,umask=0xa0
+name=BR_INST_EXEC.ALL_BRANCHES,event=0x88,umask=0xff
+name=BR_INST_EXEC.ALL_COND,event=0x88,umask=0xc1
+name=BR_INST_EXEC.ANY_COND,event=0x88,umask=0xc1
+name=BR_INST_EXEC.ANY_INDIRECT_JUMP_NON_CALL_RET,event=0x88,umask=0xc4
+name=BR_INST_EXEC.ANY_DIRECT_NEAR_CALL,event=0x88,umask=0xd0
+name=BR_INST_RETIRED.ALL_BRANCHES,event=0xc4,umask=0x4,precise
+name=BR_INST_RETIRED.COND,event=0xc4,umask=0x1,precise
+name=BR_INST_RETIRED.FAR_BRANCH,event=0xc4,umask=0x40,precise
+name=BR_INST_RETIRED.NEAR_CALL,event=0xc4,umask=0x2,precise
+name=BR_INST_RETIRED.NEAR_RETURN,event=0xc4,umask=0x8,precise
+name=BR_INST_RETIRED.NEAR_TAKEN,event=0xc4,umask=0x20,precise
+name=BR_INST_RETIRED.NOT_TAKEN,event=0xc4,umask=0x10,precise
+name=BR_MISP_EXEC.NONTAKEN_COND,event=0x89,umask=0x41
+name=BR_MISP_EXEC.TAKEN_COND,event=0x89,umask=0x81
+name=BR_MISP_EXEC.NONTAKEN_INDIRECT_JUMP_NON_CALL_RET,event=0x89,umask=0x44
+name=BR_MISP_EXEC.TAKEN_INDIRECT_JUMP_NON_CALL_RET,event=0x89,umask=0x84
+name=BR_MISP_EXEC.NONTAKEN_NEAR_RETURN,event=0x89,umask=0x48
+name=BR_MISP_EXEC.TAKEN_NEAR_RETURN,event=0x89,umask=0x88
+name=BR_MISP_EXEC.NONTAKEN_DIRECT_NEAR_CALL,event=0x89,umask=0x50
+name=BR_MISP_EXEC.TAKEN_DIRECT_NEAR_CALL,event=0x89,umask=0x90
+name=BR_MISP_EXEC.NONTAKEN_INDIRECT_NEAR_CALL,event=0x89,umask=0x60
+name=BR_MISP_EXEC.TAKEN_INDIRECT_NEAR_CALL,event=0x89,umask=0xa0
+name=BR_MISP_EXEC.ANY_COND,event=0x89,umask=0xc1
+name=BR_MISP_EXEC.ANY_RETURN_NEAR,event=0x89,umask=0xc8
+name=BR_MISP_EXEC.ANY_DIRECT_NEAR_CALL,event=0x89,umask=0xd0
+name=BR_MISP_EXEC.ANY_INDIRECT_JUMP_NON_CALL_RET,event=0x89,umask=0xc4
+name=BR_MISP_EXEC.ALL_BRANCHES,event=0x89,umask=0xff
+name=BR_MISP_RETIRED.ALL_BRANCHES,event=0xc5,umask=0x4,precise
+name=BR_MISP_RETIRED.COND,event=0xc5,umask=0x1,precise
+name=BR_MISP_RETIRED.NEAR_CALL,event=0xc5,umask=0x2,precise
+name=BR_MISP_RETIRED.NOT_TAKEN,event=0xc5,umask=0x10,precise
+name=BR_MISP_RETIRED.TAKEN,event=0xc5,umask=0x20,precise
+name=LOCK_CYCLES.SPLIT_LOCK_UC_LOCK_DURATION,event=0x63,umask=0x1
+name=LOCK_CYCLES.CACHE_LOCK_DURATION,event=0x63,umask=0x2
+name=CPL_CYCLES.RING0,event=0x5c,umask=0x1
+name=CPL_CYCLES.RING0_TRANS,event=0x5c,umask=0x10401
+name=CPL_CYCLES.RING123,event=0x5c,umask=0x2
+name=CPU_CLK_UNHALTED.REF_P,event=0x3c,umask=0x1
+name=CPU_CLK_UNHALTED.REF_XCLK,event=0x3c,umask=0x1
+name=CPU_CLK_UNHALTED.THREAD_P,event=0x3c,umask=0x0
+name=DSB2MITE_SWITCHES.COUNT,event=0xab,umask=0x1
+name=DSB2MITE_SWITCHES.PENALTY_CYCLES,event=0xab,umask=0x2
+name=DSB_FILL.EXCEED_DSB_LINES,event=0xac,umask=0x8
+name=DTLB_LOAD_MISSES.DEMAND_LD_MISS_CAUSES_A_WALK,event=0x8,umask=0x81
+name=DTLB_LOAD_MISSES.DEMAND_LD_WALK_COMPLETED,event=0x8,umask=0x82
+name=DTLB_LOAD_MISSES.DEMAND_LD_WALK_DURATION,event=0x8,umask=0x84
+name=DTLB_STORE_MISSES.MISS_CAUSES_A_WALK,event=0x49,umask=0x1
+name=DTLB_STORE_MISSES.CAUSES_A_WALK,event=0x49,umask=0x1
+name=DTLB_STORE_MISSES.STLB_HIT,event=0x49,umask=0x10
+name=DTLB_STORE_MISSES.WALK_COMPLETED,event=0x49,umask=0x2
+name=DTLB_STORE_MISSES.WALK_DURATION,event=0x49,umask=0x4
+name=FP_ASSIST.ANY,event=0xca,umask=0x1e
+name=FP_ASSIST.SIMD_INPUT,event=0xca,umask=0x10
+name=FP_ASSIST.SIMD_OUTPUT,event=0xca,umask=0x8
+name=FP_ASSIST.X87_INPUT,event=0xca,umask=0x4
+name=FP_ASSIST.X87_OUTPUT,event=0xca,umask=0x2
+name=HW_INTERRUPTS.RECEIVED,event=0xcb,umask=0x1
+name=ICACHE.MISSES,event=0x80,umask=0x2
+name=IDQ.EMPTY,event=0x79,umask=0x2
+name=IDQ.MITE_UOPS,event=0x79,umask=0x4
+name=IDQ.DSB_UOPS,event=0x79,umask=0x8
+name=IDQ.MS_DSB_UOPS,event=0x79,umask=0x10
+name=IDQ.MS_MITE_UOPS,event=0x79,umask=0x20
+name=IDQ.MS_UOPS,event=0x79,umask=0x30
+name=IDQ.MITE_UOPS_CYCLES,event=0x79,umask=0x10004
+name=IDQ.DSB_UOPS_CYCLES,event=0x79,umask=0x10008
+name=IDQ.MS_DSB_UOPS_CYCLES,event=0x79,umask=0x10010
+name=IDQ.MS_MITE_UOPS_CYCLES,event=0x79,umask=0x10020
+name=IDQ.MS_UOPS_CYCLES,event=0x79,umask=0x10030
+name=IDQ.ALL_DSB_UOPS,event=0x79,umask=0x18
+name=IDQ.ALL_DSB_CYCLES,event=0x79,umask=0x10018
+name=IDQ.ALL_DSB_CYCLES_4_UOPS,event=0x79,umask=0x40018
+name=IDQ.ALL_MITE_UOPS,event=0x79,umask=0x24
+name=IDQ.ALL_MITE_CYCLES,event=0x79,umask=0x10024
+name=IDQ.ANY_UOPS,event=0x79,umask=0x3c
+name=IDQ.MS_DSB_UOPS_OCCUR,event=0x79,umask=0x10410
+name=IDQ_UOPS_NOT_DELIVERED.CORE,event=0x9c,umask=0x1
+name=ILD_STALL.LCP,event=0x87,umask=0x1
+name=ILD_STALL.IQ_FULL,event=0x87,umask=0x4
+name=INST_RETIRED.ANY_P,event=0xc0,umask=0x0
+name=INST_RETIRED.ALL,event=0xc0,umask=0x1,precise
+name=INST_RETIRED.PREC_DIST,event=0xc0,umask=0x1,precise
+name=ITLB.ITLB_FLUSH,event=0xae,umask=0x1
+name=ITLB.FLUSH,event=0xae,umask=0x1
+name=ITLB_MISSES.MISS_CAUSES_A_WALK,event=0x85,umask=0x1
+name=ITLB_MISSES.CAUSES_A_WALK,event=0x85,umask=0x1
+name=ITLB_MISSES.STLB_HIT,event=0x85,umask=0x10
+name=ITLB_MISSES.WALK_COMPLETED,event=0x85,umask=0x2
+name=ITLB_MISSES.WALK_DURATION,event=0x85,umask=0x4
+name=L1D.REPLACEMENT,event=0x51,umask=0x1
+name=MOVE_ELIMINATION.INT_NOT_ELIMINATED,event=0x58,umask=0x1
+name=MOVE_ELIMINATION.SIMD_NOT_ELIMINATED,event=0x58,umask=0x2
+name=MOVE_ELIMINATION.INT_ELIMINATED,event=0x58,umask=0x4
+name=MOVE_ELIMINATION.SIMD_ELIMINATED,event=0x58,umask=0x2
+name=L1D_PEND_MISS.OCCURRENCES,event=0x48,umask=0x10401
+name=L1D_PEND_MISS.EDGE,event=0x48,umask=0x10401
+name=L1D_PEND_MISS.PENDING,event=0x48,umask=0x1
+name=L1D_PEND_MISS.PENDING_CYCLES,event=0x48,umask=0x10001
+name=L2_L1D_WB_RQSTS.HIT_E,event=0x28,umask=0x4
+name=L2_L1D_WB_RQSTS.HIT_M,event=0x28,umask=0x8
+name=L2_L1D_WB_RQSTS.MISS,event=0x28,umask=0x1
+name=L2_L1D_WB_RQSTS.ALL,event=0x28,umask=0xf
+name=L2_LINES_IN.ANY,event=0xf1,umask=0x7
+name=L2_LINES_IN.ALL,event=0xf1,umask=0x7
+name=L2_LINES_IN.E,event=0xf1,umask=0x4
+name=L2_LINES_IN.I,event=0xf1,umask=0x1
+name=L2_LINES_IN.S,event=0xf1,umask=0x2
+name=L2_LINES_OUT.DEMAND_CLEAN,event=0xf2,umask=0x1
+name=L2_LINES_OUT.DEMAND_DIRTY,event=0xf2,umask=0x2
+name=L2_LINES_OUT.PREFETCH_CLEAN,event=0xf2,umask=0x4
+name=L2_LINES_OUT.PF_CLEAN,event=0xf2,umask=0x4
+name=L2_LINES_OUT.PREFETCH_DIRTY,event=0xf2,umask=0x8
+name=L2_LINES_OUT.PF_DIRTY,event=0xf2,umask=0x8
+name=L2_LINES_OUT.DIRTY_ANY,event=0xf2,umask=0xa
+name=L2_LINES_OUT.DIRTY_ALL,event=0xf2,umask=0xa
+name=L2_RQSTS.ALL_CODE_RD,event=0x24,umask=0x30
+name=L2_RQSTS.CODE_RD_HIT,event=0x24,umask=0x10
+name=L2_RQSTS.CODE_RD_MISS,event=0x24,umask=0x20
+name=L2_RQSTS.ALL_DEMAND_DATA_RD,event=0x24,umask=0x3
+name=L2_RQSTS.DEMAND_DATA_RD_HIT,event=0x24,umask=0x1
+name=L2_RQSTS.ALL_PF,event=0x24,umask=0xc0
+name=L2_RQSTS.PF_HIT,event=0x24,umask=0x40
+name=L2_RQSTS.PF_MISS,event=0x24,umask=0x80
+name=L2_RQSTS.ALL_RFO,event=0x24,umask=0xc
+name=L2_RQSTS.RFO_HIT,event=0x24,umask=0x4
+name=L2_RQSTS.RFO_MISS,event=0x24,umask=0x8
+name=L2_STORE_LOCK_RQSTS.MISS,event=0x27,umask=0x1
+name=L2_STORE_LOCK_RQSTS.HIT_M,event=0x27,umask=0x8
+name=L2_STORE_LOCK_RQSTS.ALL,event=0x27,umask=0xf
+name=L2_TRANS.ALL,event=0xf0,umask=0x80
+name=L2_TRANS.CODE_RD,event=0xf0,umask=0x4
+name=L2_TRANS.L1D_WB,event=0xf0,umask=0x10
+name=L2_TRANS.DMND_DATA_RD,event=0xf0,umask=0x1
+name=L2_TRANS.L2_FILL,event=0xf0,umask=0x20
+name=L2_TRANS.L2_WB,event=0xf0,umask=0x40
+name=L2_TRANS.ALL_PREFETCH,event=0xf0,umask=0x8
+name=L2_TRANS.ALL_PF,event=0xf0,umask=0x8
+name=L2_TRANS.RFO,event=0xf0,umask=0x2
+name=LD_BLOCKS.STORE_FORWARD,event=0x3,umask=0x2
+name=LD_BLOCKS_PARTIAL.ADDRESS_ALIAS,event=0x7,umask=0x1
+name=LOAD_HIT_PRE.HW_PF,event=0x4c,umask=0x2
+name=LOAD_HIT_PRE.SW_PF,event=0x4c,umask=0x1
+name=L3_LAT_CACHE.MISS,event=0x2e,umask=0x41
+name=L3_LAT_CACHE.REFERENCE,event=0x2e,umask=0x4f
+name=MACHINE_CLEARS.MASKMOV,event=0xc3,umask=0x20
+name=MACHINE_CLEARS.MEMORY_ORDERING,event=0xc3,umask=0x2
+name=MACHINE_CLEARS.SMC,event=0xc3,umask=0x4
+name=MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_HIT,event=0xd2,umask=0x2,precise
+name=MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_HITM,event=0xd2,umask=0x4,precise
+name=MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_MISS,event=0xd2,umask=0x1,precise
+name=MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_NONE,event=0xd2,umask=0x8,precise
+name=MEM_LOAD_LLC_HIT_RETIRED.XSNP_HIT,event=0xd2,umask=0x2,precise
+name=MEM_LOAD_LLC_HIT_RETIRED.XSNP_HITM,event=0xd2,umask=0x4,precise
+name=MEM_LOAD_LLC_HIT_RETIRED.XSNP_MISS,event=0xd2,umask=0x1,precise
+name=MEM_LOAD_LLC_HIT_RETIRED.XSNP_NONE,event=0xd2,umask=0x8,precise
+name=MEM_LOAD_UOPS_LLC_MISS_RETIRED.LOCAL_DRAM,event=0xd3,umask=0x1,precise
+name=MEM_LOAD_UOPS_RETIRED.HIT_LFB,event=0xd1,umask=0x40,precise
+name=MEM_LOAD_UOPS_RETIRED.L1_HIT,event=0xd1,umask=0x1,precise
+name=MEM_LOAD_UOPS_RETIRED.L2_HIT,event=0xd1,umask=0x2,precise
+name=MEM_LOAD_UOPS_RETIRED.L3_HIT,event=0xd1,umask=0x4,precise
+name=MEM_LOAD_RETIRED.HIT_LFB,event=0xd1,umask=0x40,precise
+name=MEM_LOAD_RETIRED.L1_HIT,event=0xd1,umask=0x1,precise
+name=MEM_LOAD_RETIRED.L2_HIT,event=0xd1,umask=0x2,precise
+name=MEM_LOAD_RETIRED.L3_HIT,event=0xd1,umask=0x4,precise
+name=MEM_TRANS_RETIRED.LATENCY_ABOVE_THRESHOLD,event=0xcd,umask=0x1,precise
+name=MEM_TRANS_RETIRED.PRECISE_STORE,event=0xcd,umask=0x2,precise
+name=MEM_UOPS_RETIRED.ALL_LOADS,event=0xd0,umask=0x81,precise
+name=MEM_UOPS_RETIRED.ANY_LOADS,event=0xd0,umask=0x81,precise
+name=MEM_UOPS_RETIRED.ALL_STORES,event=0xd0,umask=0x82,precise
+name=MEM_UOPS_RETIRED.ANY_STORES,event=0xd0,umask=0x82,precise
+name=MEM_UOPS_RETIRED.LOCK_LOADS,event=0xd0,umask=0x21,precise
+name=MEM_UOPS_RETIRED.LOCK_STORES,event=0xd0,umask=0x22,precise
+name=MEM_UOPS_RETIRED.SPLIT_LOADS,event=0xd0,umask=0x41,precise
+name=MEM_UOPS_RETIRED.SPLIT_STORES,event=0xd0,umask=0x42,precise
+name=MEM_UOPS_RETIRED.STLB_MISS_LOADS,event=0xd0,umask=0x11,precise
+name=MEM_UOPS_RETIRED.STLB_MISS_STORES,event=0xd0,umask=0x12,precise
+name=MEM_UOP_RETIRED.ALL_LOADS,event=0xd0,umask=0x81,precise
+name=MEM_UOP_RETIRED.ANY_LOADS,event=0xd0,umask=0x81,precise
+name=MEM_UOP_RETIRED.ALL_STORES,event=0xd0,umask=0x82,precise
+name=MEM_UOP_RETIRED.ANY_STORES,event=0xd0,umask=0x82,precise
+name=MEM_UOP_RETIRED.LOCK_LOADS,event=0xd0,umask=0x21,precise
+name=MEM_UOP_RETIRED.LOCK_STORES,event=0xd0,umask=0x22,precise
+name=MEM_UOP_RETIRED.SPLIT_LOADS,event=0xd0,umask=0x41,precise
+name=MEM_UOP_RETIRED.SPLIT_STORES,event=0xd0,umask=0x42,precise
+name=MEM_UOP_RETIRED.STLB_MISS_LOADS,event=0xd0,umask=0x11,precise
+name=MEM_UOP_RETIRED.STLB_MISS_STORES,event=0xd0,umask=0x12,precise
+name=MISALIGN_MEM_REF.LOADS,event=0x5,umask=0x1
+name=MISALIGN_MEM_REF.STORES,event=0x5,umask=0x2
+name=OFFCORE_REQUESTS.ALL_DATA_RD,event=0xb0,umask=0x8
+name=OFFCORE_REQUESTS.ALL_DATA_READ,event=0xb0,umask=0x8
+name=OFFCORE_REQUESTS.DEMAND_CODE_RD,event=0xb0,umask=0x2
+name=OFFCORE_REQUESTS.DEMAND_DATA_RD,event=0xb0,umask=0x1
+name=OFFCORE_REQUESTS.DEMAND_RFO,event=0xb0,umask=0x4
+name=OFFCORE_REQUESTS_OUTSTANDING.ALL_DATA_RD_CYCLES,event=0x60,umask=0x10008
+name=OFFCORE_REQUESTS_OUTSTANDING.DEMAND_CODE_RD_CYCLES,event=0x60,umask=0x10002
+name=OFFCORE_REQUESTS_OUTSTANDING.DEMAND_DATA_RD_CYCLES,event=0x60,umask=0x10001
+name=OFFCORE_REQUESTS_OUTSTANDING.ALL_DATA_RD,event=0x60,umask=0x8
+name=OFFCORE_REQUESTS_OUTSTANDING.DEMAND_CODE_RD,event=0x60,umask=0x2
+name=OFFCORE_REQUESTS_OUTSTANDING.DEMAND_DATA_RD,event=0x60,umask=0x1
+name=OFFCORE_REQUESTS_OUTSTANDING.DEMAND_RFO,event=0x60,umask=0x4
+name=OFFCORE_REQUESTS_OUTSTANDING.DEMAND_RFO_CYCLES,event=0x60,umask=0x10004
+name=OTHER_ASSISTS.ITLB_MISS_RETIRED,event=0xc1,umask=0x2
+name=OTHER_ASSISTS.AVX_TO_SSE,event=0xc1,umask=0x10
+name=OTHER_ASSISTS.SSE_TO_AVX,event=0xc1,umask=0x20
+name=OTHER_ASSISTS.AVX_STORE,event=0xc1,umask=0x8
+name=RESOURCE_STALLS.ANY,event=0xa2,umask=0x1
+name=RESOURCE_STALLS.RS,event=0xa2,umask=0x4
+name=RESOURCE_STALLS.SB,event=0xa2,umask=0x8
+name=RESOURCE_STALLS.ROB,event=0xa2,umask=0x10
+name=ROB_MISC_EVENTS.LBR_INSERTS,event=0xcc,umask=0x20
+name=RS_EVENTS.EMPTY_CYCLES,event=0x5e,umask=0x1
+name=TLB_ACCESS.LOAD_STLB_HIT,event=0x5f,umask=0x1
+name=TLB_FLUSH.DTLB_THREAD,event=0xbd,umask=0x1
+name=TLB_FLUSH.STLB_ANY,event=0xbd,umask=0x20
+name=UOPS_EXECUTED.CORE,event=0xb1,umask=0x2
+name=UOPS_DISPATCHED_PORT.PORT_0,event=0xa1,umask=0x1
+name=UOPS_DISPATCHED_PORT.PORT_1,event=0xa1,umask=0x2
+name=UOPS_DISPATCHED_PORT.PORT_2_LD,event=0xa1,umask=0x4
+name=UOPS_DISPATCHED_PORT.PORT_2_STA,event=0xa1,umask=0x8
+name=UOPS_DISPATCHED_PORT.PORT_2,event=0xa1,umask=0xc
+name=UOPS_DISPATCHED_PORT.PORT_3_LD,event=0xa1,umask=0x10
+name=UOPS_DISPATCHED_PORT.PORT_3_STA,event=0xa1,umask=0x20
+name=UOPS_DISPATCHED_PORT.PORT_3,event=0xa1,umask=0x30
+name=UOPS_DISPATCHED_PORT.PORT_4,event=0xa1,umask=0x40
+name=UOPS_DISPATCHED_PORT.PORT_5,event=0xa1,umask=0x80
+name=UOPS_ISSUED.ANY,event=0xe,umask=0x1
+name=UOPS_ISSUED.CORE_STALL_CYCLES,event=0xe,umask=0x1a001
+name=UOPS_ISSUED.STALL_CYCLES,event=0xe,umask=0x18001
+name=UOPS_ISSUED.FLAGS_MERGE,event=0xe,umask=0x10
+name=UOPS_ISSUED.SLOW_LEA,event=0xe,umask=0x20
+name=UOPS_ISSUED.SINGLE_MUL,event=0xe,umask=0x40
+name=UOPS_RETIRED.ALL,event=0xc2,umask=0x1,precise
+name=UOPS_RETIRED.ANY,event=0xc2,umask=0x1,precise
+name=UOPS_RETIRED.RETIRE_SLOTS,event=0xc2,umask=0x2,precise
+name=UOPS_RETIRED.STALL_CYCLES,event=0xc2,umask=0x18001,precise
+name=UOPS_RETIRED.TOTAL_CYCLES,event=0xc2,umask=0x100001,precise
diff --git a/tools/perf/arch/x86/util/pmu.c b/tools/perf/arch/x86/util/pmu.c
index cac67d3..d6250f4 100644
--- a/tools/perf/arch/x86/util/pmu.c
+++ b/tools/perf/arch/x86/util/pmu.c
@@ -59,6 +59,8 @@ static int intel_aliases(struct list_head *head, unsigned model)
 	case 42: /* Sandy Bridge (Core i7 26xx, 25xx) */
 	case 45: /* Sandy Bridge EP */
 		ADD_ALIASES("snb");
+	case 58: /* IvyBridge */
+		ADD_ALIASES("ivb");
 	default:
 		break;
 	}
-- 
1.7.11.7

