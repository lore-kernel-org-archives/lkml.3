Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab3AaR0D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 12:26:03 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60110
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755951Ab3AaRZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 12:25:50 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, Anton Blanchard <anton@au1.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>, linuxppc-dev@ozlabs.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 21/25] perf/Power7: Use macros to identify perf events
Date: Thu, 31 Jan 2013 14:25:24 -0300
Message-Id: <1359653128-10433-22-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359653128-10433-1-git-send-email-acme@infradead.org>
References: <1359653128-10433-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

Define and use macros to identify perf events codes This would make it
easier and more readable when these event codes need to be used in more
than one place.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: linuxppc-dev@ozlabs.org
Link: http://lkml.kernel.org/r/20130123062353.GB13720@us.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 arch/powerpc/perf/power7-pmu.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/perf/power7-pmu.c b/arch/powerpc/perf/power7-pmu.c
index 2ee01e3..eebb36d 100644
--- a/arch/powerpc/perf/power7-pmu.c
+++ b/arch/powerpc/perf/power7-pmu.c
@@ -51,6 +51,18 @@
 #define MMCR1_PMCSEL_MSK	0xff
 
 /*
+ * Power7 event codes.
+ */
+#define	PME_PM_CYC			0x1e
+#define	PME_PM_GCT_NOSLOT_CYC		0x100f8
+#define	PME_PM_CMPLU_STALL		0x4000a
+#define	PME_PM_INST_CMPL		0x2
+#define	PME_PM_LD_REF_L1		0xc880
+#define	PME_PM_LD_MISS_L1		0x400f0
+#define	PME_PM_BRU_FIN			0x10068
+#define	PME_PM_BRU_MPRED		0x400f6
+
+/*
  * Layout of constraint bits:
  * 6666555555555544444444443333333333222222222211111111110000000000
  * 3210987654321098765432109876543210987654321098765432109876543210
@@ -307,14 +319,14 @@ static void power7_disable_pmc(unsigned int pmc, unsigned long mmcr[])
 }
 
 static int power7_generic_events[] = {
-	[PERF_COUNT_HW_CPU_CYCLES] = 0x1e,
-	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x100f8, /* GCT_NOSLOT_CYC */
-	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x4000a,  /* CMPLU_STALL */
-	[PERF_COUNT_HW_INSTRUCTIONS] = 2,
-	[PERF_COUNT_HW_CACHE_REFERENCES] = 0xc880,	/* LD_REF_L1_LSU*/
-	[PERF_COUNT_HW_CACHE_MISSES] = 0x400f0,		/* LD_MISS_L1	*/
-	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] = 0x10068,	/* BRU_FIN	*/
-	[PERF_COUNT_HW_BRANCH_MISSES] = 0x400f6,	/* BR_MPRED	*/
+	[PERF_COUNT_HW_CPU_CYCLES] =			PME_PM_CYC,
+	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =	PME_PM_GCT_NOSLOT_CYC,
+	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] =	PME_PM_CMPLU_STALL,
+	[PERF_COUNT_HW_INSTRUCTIONS] =			PME_PM_INST_CMPL,
+	[PERF_COUNT_HW_CACHE_REFERENCES] =		PME_PM_LD_REF_L1,
+	[PERF_COUNT_HW_CACHE_MISSES] =			PME_PM_LD_MISS_L1,
+	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] =		PME_PM_BRU_FIN,
+	[PERF_COUNT_HW_BRANCH_MISSES] =			PME_PM_BRU_MPRED,
 };
 
 #define C(x)	PERF_COUNT_HW_CACHE_##x
-- 
1.8.1.1.361.gec3ae6e

