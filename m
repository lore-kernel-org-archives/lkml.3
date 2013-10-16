Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027Ab3JPCIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 22:08:49 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:40939 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759021Ab3JPCHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 22:07:14 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH 05/10][v6] powerpc/perf: Remove PME_ prefix for power7 events
Date: Tue, 15 Oct 2013 19:06:37 -0700
Message-Id: <1381889202-16826-6-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381889202-16826-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1381889202-16826-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101602-9332-0000-0000-000001C8BE92
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We used the PME_ prefix earlier to avoid some macro/variable name
collisions.  We have since changed the way we define/use the event
macros so we no longer need the prefix.

By dropping the prefix, we keep the the event macros consistent with
their official names.

Reported-by: Michael Ellerman <ellerman@au1.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/perf_event_server.h |    2 +-
 arch/powerpc/perf/power7-pmu.c               |   18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/include/asm/perf_event_server.h b/arch/powerpc/include/asm/perf_event_server.h
index 3fd2f1b..d7b3419 100644
--- a/arch/powerpc/include/asm/perf_event_server.h
+++ b/arch/powerpc/include/asm/perf_event_server.h
@@ -138,7 +138,7 @@ extern ssize_t power_events_sysfs_show(struct device *dev,
 #define	EVENT_PTR(_id, _suffix)		&EVENT_VAR(_id, _suffix).attr.attr
 
 #define	EVENT_ATTR(_name, _id, _suffix)					\
-	PMU_EVENT_ATTR(_name, EVENT_VAR(_id, _suffix), PME_##_id,	\
+	PMU_EVENT_ATTR(_name, EVENT_VAR(_id, _suffix), _id,		\
 			power_events_sysfs_show)
 
 #define	GENERIC_EVENT_ATTR(_name, _id)	EVENT_ATTR(_name, _id, _g)
diff --git a/arch/powerpc/perf/power7-pmu.c b/arch/powerpc/perf/power7-pmu.c
index 56c67bc..ae24dfc 100644
--- a/arch/powerpc/perf/power7-pmu.c
+++ b/arch/powerpc/perf/power7-pmu.c
@@ -54,7 +54,7 @@
  * Power7 event codes.
  */
 #define EVENT(_name, _code) \
-	PME_##_name = _code,
+	_name = _code,
 
 enum {
 #include "power7-events-list.h"
@@ -318,14 +318,14 @@ static void power7_disable_pmc(unsigned int pmc, unsigned long mmcr[])
 }
 
 static int power7_generic_events[] = {
-	[PERF_COUNT_HW_CPU_CYCLES] =			PME_PM_CYC,
-	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =	PME_PM_GCT_NOSLOT_CYC,
-	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] =	PME_PM_CMPLU_STALL,
-	[PERF_COUNT_HW_INSTRUCTIONS] =			PME_PM_INST_CMPL,
-	[PERF_COUNT_HW_CACHE_REFERENCES] =		PME_PM_LD_REF_L1,
-	[PERF_COUNT_HW_CACHE_MISSES] =			PME_PM_LD_MISS_L1,
-	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] =		PME_PM_BRU_FIN,
-	[PERF_COUNT_HW_BRANCH_MISSES] =			PME_PM_BR_MPRED,
+	[PERF_COUNT_HW_CPU_CYCLES] =			PM_CYC,
+	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =	PM_GCT_NOSLOT_CYC,
+	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] =	PM_CMPLU_STALL,
+	[PERF_COUNT_HW_INSTRUCTIONS] =			PM_INST_CMPL,
+	[PERF_COUNT_HW_CACHE_REFERENCES] =		PM_LD_REF_L1,
+	[PERF_COUNT_HW_CACHE_MISSES] =			PM_LD_MISS_L1,
+	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] =		PM_BRU_FIN,
+	[PERF_COUNT_HW_BRANCH_MISSES] =			PM_BR_MPRED,
 };
 
 #define C(x)	PERF_COUNT_HW_CACHE_##x
-- 
1.7.9.5

