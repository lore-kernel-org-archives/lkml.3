Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab3A0Rdk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 12:33:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096Ab3A0Rdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 12:33:38 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [RFC/PATCH] perf x86: Add off-core event constraints for Sandy/IvyBridge micro architecture
Date: Sun, 27 Jan 2013 18:33:15 +0100
Message-Id: <1359307995-30640-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
I was looking at the offcore stuff and it looks like we might
be missing some constraints for offcore response events on
Sandy/IvyBridge.

The table 18.8.5 (Off-core Response Performance Monitoring)
in Intel SDM states PMC0 for 0xb7 and PMC3 for 0xbb, but
there's no other explanation or related description.

I can't say/ack if the counters looks bad or right with or
without the patch so far.. so just curious ;-)

thanks,
jirka

---
The Intel SDM (18.8.5 Off-core Response Performance Monitoring)
states the off-core events MSR_OFFCORE_RSP_0/MSR_OFFCORE_RSP_03
to be defined only for PMC0/PMC3 respectively.  

Adding related constraints.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 5dc54fc..d1f240f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -105,6 +105,8 @@ static struct event_constraint intel_snb_event_constraints[] __read_mostly =
 	INTEL_EVENT_CONSTRAINT(0x48, 0x4), /* L1D_PEND_MISS.PENDING */
 	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
 	INTEL_EVENT_CONSTRAINT(0xcd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
+	INTEL_EVENT_CONSTRAINT(0xb7, 0x1), /* MSR_OFFCORE_RSP_0 - PMC0 only*/
+	INTEL_EVENT_CONSTRAINT(0xbb, 0x8), /* MSR_OFFCORE_RSP_1 - PMC3 only*/
 	EVENT_CONSTRAINT_END
 };
 
-- 
1.7.11.7

