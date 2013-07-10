Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab3GJTUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 15:20:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56904 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab3GJTUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 15:20:10 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        icycoder@gmail.com, linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <michael@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>, Runzhen Wang <runzhew@clemson.edu>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/23] perf tools: fix a typo of a Power7 event name
Date: Wed, 10 Jul 2013 16:19:12 -0300
Message-Id: <1373483963-19277-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373483963-19277-1-git-send-email-acme@infradead.org>
References: <1373483963-19277-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Runzhen Wang <runzhen@linux.vnet.ibm.com>

In the Power7 PMU guide:
https://www.power.org/documentation/commonly-used-metrics-for-performance-analysis/
PM_BRU_MPRED is referred to as PM_BR_MPRED.

It fixed the typo by changing the name of the event in kernel and
documentation accordingly.

This patch changes the ABI, there are some reasons I think it's ok:

- It is relatively new interface, specific to the Power7 platform.

- No tools that we know of actually use this interface at this point
 (none are listed near the interface).

- Users of this interface (eg oprofile users migrating to perf)
  would be more used to the "PM_BR_MPRED" rather than "PM_BRU_MPRED".

- These are in the ABI/testing at this point rather than ABI/stable,
  so hoping we have some wiggle room.

Signed-off-by: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Acked-by: Michael Ellerman <michael@ellerman.id.au>
Cc: icycoder@gmail.com
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Runzhen Wang <runzhew@clemson.edu>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1372407297-6996-2-git-send-email-runzhen@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../ABI/testing/sysfs-bus-event_source-devices-events        |  2 +-
 arch/powerpc/perf/power7-pmu.c                               | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-events b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
index 8b25ffb..3c1cc24 100644
--- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
@@ -29,7 +29,7 @@ Description:	Generic performance monitoring events
 
 What: 		/sys/devices/cpu/events/PM_1PLUS_PPC_CMPL
 		/sys/devices/cpu/events/PM_BRU_FIN
-		/sys/devices/cpu/events/PM_BRU_MPRED
+		/sys/devices/cpu/events/PM_BR_MPRED
 		/sys/devices/cpu/events/PM_CMPLU_STALL
 		/sys/devices/cpu/events/PM_CMPLU_STALL_BRU
 		/sys/devices/cpu/events/PM_CMPLU_STALL_DCACHE_MISS
diff --git a/arch/powerpc/perf/power7-pmu.c b/arch/powerpc/perf/power7-pmu.c
index 13c3f0e..d1821b8 100644
--- a/arch/powerpc/perf/power7-pmu.c
+++ b/arch/powerpc/perf/power7-pmu.c
@@ -60,7 +60,7 @@
 #define	PME_PM_LD_REF_L1		0xc880
 #define	PME_PM_LD_MISS_L1		0x400f0
 #define	PME_PM_BRU_FIN			0x10068
-#define	PME_PM_BRU_MPRED		0x400f6
+#define	PME_PM_BR_MPRED			0x400f6
 
 #define PME_PM_CMPLU_STALL_FXU			0x20014
 #define PME_PM_CMPLU_STALL_DIV			0x40014
@@ -349,7 +349,7 @@ static int power7_generic_events[] = {
 	[PERF_COUNT_HW_CACHE_REFERENCES] =		PME_PM_LD_REF_L1,
 	[PERF_COUNT_HW_CACHE_MISSES] =			PME_PM_LD_MISS_L1,
 	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] =		PME_PM_BRU_FIN,
-	[PERF_COUNT_HW_BRANCH_MISSES] =			PME_PM_BRU_MPRED,
+	[PERF_COUNT_HW_BRANCH_MISSES] =			PME_PM_BR_MPRED,
 };
 
 #define C(x)	PERF_COUNT_HW_CACHE_##x
@@ -405,7 +405,7 @@ GENERIC_EVENT_ATTR(instructions,		INST_CMPL);
 GENERIC_EVENT_ATTR(cache-references,		LD_REF_L1);
 GENERIC_EVENT_ATTR(cache-misses,		LD_MISS_L1);
 GENERIC_EVENT_ATTR(branch-instructions,		BRU_FIN);
-GENERIC_EVENT_ATTR(branch-misses,		BRU_MPRED);
+GENERIC_EVENT_ATTR(branch-misses,		BR_MPRED);
 
 POWER_EVENT_ATTR(CYC,				CYC);
 POWER_EVENT_ATTR(GCT_NOSLOT_CYC,		GCT_NOSLOT_CYC);
@@ -414,7 +414,7 @@ POWER_EVENT_ATTR(INST_CMPL,			INST_CMPL);
 POWER_EVENT_ATTR(LD_REF_L1,			LD_REF_L1);
 POWER_EVENT_ATTR(LD_MISS_L1,			LD_MISS_L1);
 POWER_EVENT_ATTR(BRU_FIN,			BRU_FIN)
-POWER_EVENT_ATTR(BRU_MPRED,			BRU_MPRED);
+POWER_EVENT_ATTR(BR_MPRED,			BR_MPRED);
 
 POWER_EVENT_ATTR(CMPLU_STALL_FXU,		CMPLU_STALL_FXU);
 POWER_EVENT_ATTR(CMPLU_STALL_DIV,		CMPLU_STALL_DIV);
@@ -449,7 +449,7 @@ static struct attribute *power7_events_attr[] = {
 	GENERIC_EVENT_PTR(LD_REF_L1),
 	GENERIC_EVENT_PTR(LD_MISS_L1),
 	GENERIC_EVENT_PTR(BRU_FIN),
-	GENERIC_EVENT_PTR(BRU_MPRED),
+	GENERIC_EVENT_PTR(BR_MPRED),
 
 	POWER_EVENT_PTR(CYC),
 	POWER_EVENT_PTR(GCT_NOSLOT_CYC),
@@ -458,7 +458,7 @@ static struct attribute *power7_events_attr[] = {
 	POWER_EVENT_PTR(LD_REF_L1),
 	POWER_EVENT_PTR(LD_MISS_L1),
 	POWER_EVENT_PTR(BRU_FIN),
-	POWER_EVENT_PTR(BRU_MPRED),
+	POWER_EVENT_PTR(BR_MPRED),
 
 	POWER_EVENT_PTR(CMPLU_STALL_FXU),
 	POWER_EVENT_PTR(CMPLU_STALL_DIV),
-- 
1.8.1.4

