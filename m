Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab3JBAQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 20:16:17 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:58844 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab3JBAPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 20:15:33 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH 1/9][v5] powerpc/perf: Rename Power8 macros to start with PME
Date: Tue,  1 Oct 2013 17:15:02 -0700
Message-Id: <1380672911-12812-2-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380672911-12812-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1380672911-12812-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100200-6688-0000-0000-0000022822E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use helpers like GENERIC_EVENT_ATTR() to list the generic events in
sysfs. To avoid name collisions, GENERIC_EVENT_ATTR() requires the perf
event macros to start with PME.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Reviewed-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/perf/power8-pmu.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/perf/power8-pmu.c b/arch/powerpc/perf/power8-pmu.c
index 2ee4a70..976c203 100644
--- a/arch/powerpc/perf/power8-pmu.c
+++ b/arch/powerpc/perf/power8-pmu.c
@@ -18,12 +18,12 @@
 /*
  * Some power8 event codes.
  */
-#define PM_CYC				0x0001e
-#define PM_GCT_NOSLOT_CYC		0x100f8
-#define PM_CMPLU_STALL			0x4000a
-#define PM_INST_CMPL			0x00002
-#define PM_BRU_FIN			0x10068
-#define PM_BR_MPRED_CMPL		0x400f6
+#define PME_PM_CYC				0x0001e
+#define PME_PM_GCT_NOSLOT_CYC			0x100f8
+#define PME_PM_CMPLU_STALL			0x4000a
+#define PME_PM_INST_CMPL			0x00002
+#define PME_PM_BRU_FIN				0x10068
+#define PME_PM_BR_MPRED_CMPL			0x400f6
 
 
 /*
@@ -550,12 +550,12 @@ static const struct attribute_group *power8_pmu_attr_groups[] = {
 };
 
 static int power8_generic_events[] = {
-	[PERF_COUNT_HW_CPU_CYCLES] =			PM_CYC,
-	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =	PM_GCT_NOSLOT_CYC,
-	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] =	PM_CMPLU_STALL,
-	[PERF_COUNT_HW_INSTRUCTIONS] =			PM_INST_CMPL,
-	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] =		PM_BRU_FIN,
-	[PERF_COUNT_HW_BRANCH_MISSES] =			PM_BR_MPRED_CMPL,
+	[PERF_COUNT_HW_CPU_CYCLES] =			PME_PM_CYC,
+	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =	PME_PM_GCT_NOSLOT_CYC,
+	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] =	PME_PM_CMPLU_STALL,
+	[PERF_COUNT_HW_INSTRUCTIONS] =			PME_PM_INST_CMPL,
+	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] =		PME_PM_BRU_FIN,
+	[PERF_COUNT_HW_BRANCH_MISSES] =			PME_PM_BR_MPRED_CMPL,
 };
 
 static u64 power8_bhrb_filter_map(u64 branch_sample_type)
-- 
1.7.9.5

