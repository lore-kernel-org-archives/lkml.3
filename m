Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759106Ab3BTUka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:40:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab3BTUk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:40:28 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH] perf x86: Change SandyBridge and IvyBrige instructions event to be precise
Date: Wed, 20 Feb 2013 21:39:54 +0100
Message-Id: <1361392794-16552-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing the default 'instructions' HW event for SandyBridge and
IvyBrige to use the available precise 'instructions' event.

The precise event is defined in Intel SDM as:

INST_RETIRED.ALL - Precise instruction retired event with HW to
reduce effect of PEBS shadow in IP distribution

for both SandyBridge and IvyBrige micro-archs. It allows to use
precise modifier on 'instructions' event on SandyBridge and
IvyBrige micro-archs which is not possible now.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 529c893..3bc3592 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2104,6 +2104,9 @@ __init int intel_pmu_init(void)
 		/* UOPS_DISPATCHED.THREAD,c=1,i=1 to count stall cycles*/
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] =
 			X86_CONFIG(.event=0xb1, .umask=0x01, .inv=1, .cmask=1);
+		/* INST_RETIRED.ALL to count precise instructions */
+		intel_perfmon_event_map[PERF_COUNT_HW_INSTRUCTIONS] =
+			X86_CONFIG(.event=0xc0, .umask=0x01);
 
 		pr_cont("SandyBridge events, ");
 		break;
@@ -2127,6 +2130,9 @@ __init int intel_pmu_init(void)
 		/* UOPS_ISSUED.ANY,c=1,i=1 to count stall cycles */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =
 			X86_CONFIG(.event=0x0e, .umask=0x01, .inv=1, .cmask=1);
+		/* INST_RETIRED.ALL to count precise instructions */
+		intel_perfmon_event_map[PERF_COUNT_HW_INSTRUCTIONS] =
+			X86_CONFIG(.event=0xc0, .umask=0x01);
 
 		pr_cont("IvyBridge events, ");
 		break;
-- 
1.7.11.7

