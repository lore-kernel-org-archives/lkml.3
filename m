Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161223Ab3BAK7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:59:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52217 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161218Ab3BAK7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:59:40 -0500
Date: Fri, 1 Feb 2013 02:59:15 -0800
From: tip-bot for Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Message-ID: <tip-bbdc7aa442630a84feae45f4ca2dd7ed01abc868@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, robert.richter@amd.com,
        anton@au1.ibm.com, ak@linux.intel.com, tglx@linutronix.de,
        sukadev@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, robert.richter@amd.com,
        anton@au1.ibm.com, ak@linux.intel.com, sukadev@linux.vnet.ibm.com,
        tglx@linutronix.de
In-Reply-To: <20130123062353.GB13720@us.ibm.com>
References: <20130123062353.GB13720@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/Power7: Use macros to identify perf events
Git-Commit-ID: bbdc7aa442630a84feae45f4ca2dd7ed01abc868
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 01 Feb 2013 02:59:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bbdc7aa442630a84feae45f4ca2dd7ed01abc868
Gitweb:     http://git.kernel.org/tip/bbdc7aa442630a84feae45f4ca2dd7ed01abc868
Author:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
AuthorDate: Tue, 22 Jan 2013 22:23:53 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 Jan 2013 13:07:50 -0300

perf/Power7: Use macros to identify perf events

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
