Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab3DUOdF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 10:33:05 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:35678 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753538Ab3DUOdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 10:33:02 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dIc85fh1432I4015Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz177df4h17326ah8275bh8275dh8275chz2dh668h839hd25hd2bhf0ah1288h12a5h12bdh137ah1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1bceh34h1155h)
X-WSS-ID: 0MLM0EQ-02-G2S-02
X-M-MSG: 
Date: Sun, 21 Apr 2013 09:32:52 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: <mingo@kernel.org>, <hpa@zytor.com>, <eranian@google.com>,
        <linux-kernel@vger.kernel.org>, <a.p.zijlstra@chello.nl>,
        <acme@ghostprotocols.net>, <jolsa@redhat.com>, <tglx@linutronix.de>
CC: <linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:perf/core] perf/x86/amd: Add support for AMD NB and L2I "
 uncore" counters
Message-ID: <20130421143252.GA306@jshin-Toonie>
References: <20130419213428.GA8229@jshin-Toonie>
 <tip-c43ca5091a374c1f6778bd7e4a39a5a10735a917@git.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <tip-c43ca5091a374c1f6778bd7e4a39a5a10735a917@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jRHKVT23PllUwdXP
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Sun, Apr 21, 2013 at 05:48:36AM -0700, tip-bot for Jacob Shin wrote:
> Commit-ID:  c43ca5091a374c1f6778bd7e4a39a5a10735a917
> Gitweb:     http://git.kernel.org/tip/c43ca5091a374c1f6778bd7e4a39a5a10735a917
> Author:     Jacob Shin <jacob.shin@amd.com>
> AuthorDate: Fri, 19 Apr 2013 16:34:28 -0500
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Sun, 21 Apr 2013 11:01:24 +0200
> 
> perf/x86/amd: Add support for AMD NB and L2I "uncore" counters
> 
> Add support for AMD Family 15h [and above] northbridge
> performance counters. MSRs 0xc0010240 ~ 0xc0010247 are shared
> across all cores that share a common northbridge.
> 
> Add support for AMD Family 16h L2 performance counters. MSRs
> 0xc0010230 ~ 0xc0010237 are shared across all cores that share a
> common L2 cache.
> 
> We do not enable counter overflow interrupts. Sampling mode and
> per-thread events are not supported.
> 
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/r/20130419213428.GA8229@jshin-Toonie
> Signed-off-by: Ingo Molnar <mingo@kernel.org>

Thanks Ingo.

This is [PATCH 2/2],
There is also [PATCH 1/2] which removes NB counter support from
perf_event_amd.c that is needed:

  http://lkml.org/lkml/2013/4/15/421

(Also .mbox attached)

Thanks,

-Jacob

--jRHKVT23PllUwdXP
Content-Type: text/plain; charset="us-ascii"; name="patch1.mbox"
Content-Disposition: attachment; filename="patch1.mbox"
Content-Description: patch1.mbox

>From jacob.shin@amd.com Mon Apr 15 12:21:32 2013
Received: from jshin-Dinar.amd.com (163.181.55.254) by sausexdag04.amd.com
 (163.181.55.4) with Microsoft SMTP Server id 14.2.328.9; Mon, 15 Apr 2013
 12:21:32 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
	<x86@kernel.org>, Stephane Eranian <eranian@google.com>, Jiri Olsa
	<jolsa@redhat.com>, <linux-kernel@vger.kernel.org>, Jacob Shin
	<jacob.shin@amd.com>
Subject: [PATCH 1/2] perf, amd: remove NB counter support from perf_event_amd.c
Date: Mon, 15 Apr 2013 12:21:22 -0500
Message-ID: <1366046483-1765-2-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1366046483-1765-1-git-send-email-jacob.shin@amd.com>
References: <1366046483-1765-1-git-send-email-jacob.shin@amd.com>
Content-Type: text/plain
Return-Path: jacob.shin@amd.com
X-MS-Exchange-Organization-AuthSource: sausexdag04.amd.com
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-AVStamp-Mailbox: MSFTFF;1;0;0 0 0
MIME-Version: 1.0
Status: RO
Content-Length: 8080
Lines: 268

Support for NB counters, MSRs 0xc0010240 ~ 0xc0010247, will be moved
to perf_event_amd_uncore.c in a follow up patch. AMD Family 10h NB
events (events 0xe0 ~ 0xff, on MSRs 0xc001000 ~ 0xc001007) will still
continue to be handled by perf_event_amd.c

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd.c |  138 ++--------------------------------
 1 file changed, 5 insertions(+), 133 deletions(-)

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
-- 
1.7.9.5



--jRHKVT23PllUwdXP--
