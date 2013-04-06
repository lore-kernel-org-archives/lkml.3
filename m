Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab3DFQs5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 12:48:57 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58802 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab3DFQsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 12:48:55 -0400
Date: Sat, 6 Apr 2013 09:48:03 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] perf: Power7: Make CPI stack events available in sysfs
Message-ID: <20130406164803.GA408@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040616-5806-0000-0000-000020A053E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From bdeacf7175241f6c79b5b2be0fa6b20b0d0b7d1c Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Sat, 6 Apr 2013 08:48:26 -0700
Subject: [PATCH] perf: Power7: Make CPI stack events available in sysfs

A set of Power7 events are often used for Cycles Per Instruction (CPI) stack
analysis. Make these events available in sysfs (/sys/devices/cpu/events/) so
they can be identified using their symbolic names:

	perf stat -e 'cpu/PM_CMPLU_STALL_DCACHE_MISS/' /bin/ls

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 arch/powerpc/perf/power7-pmu.c |   73 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/perf/power7-pmu.c b/arch/powerpc/perf/power7-pmu.c
index 3c475d6..13c3f0e 100644
--- a/arch/powerpc/perf/power7-pmu.c
+++ b/arch/powerpc/perf/power7-pmu.c
@@ -62,6 +62,29 @@
 #define	PME_PM_BRU_FIN			0x10068
 #define	PME_PM_BRU_MPRED		0x400f6
 
+#define PME_PM_CMPLU_STALL_FXU			0x20014
+#define PME_PM_CMPLU_STALL_DIV			0x40014
+#define PME_PM_CMPLU_STALL_SCALAR		0x40012
+#define PME_PM_CMPLU_STALL_SCALAR_LONG		0x20018
+#define PME_PM_CMPLU_STALL_VECTOR		0x2001c
+#define PME_PM_CMPLU_STALL_VECTOR_LONG		0x4004a
+#define PME_PM_CMPLU_STALL_LSU			0x20012
+#define PME_PM_CMPLU_STALL_REJECT		0x40016
+#define PME_PM_CMPLU_STALL_ERAT_MISS		0x40018
+#define PME_PM_CMPLU_STALL_DCACHE_MISS		0x20016
+#define PME_PM_CMPLU_STALL_STORE		0x2004a
+#define PME_PM_CMPLU_STALL_THRD			0x1001c
+#define PME_PM_CMPLU_STALL_IFU			0x4004c
+#define PME_PM_CMPLU_STALL_BRU			0x4004e
+#define PME_PM_GCT_NOSLOT_IC_MISS		0x2001a
+#define PME_PM_GCT_NOSLOT_BR_MPRED		0x4001a
+#define PME_PM_GCT_NOSLOT_BR_MPRED_IC_MISS	0x4001c
+#define PME_PM_GRP_CMPL				0x30004
+#define PME_PM_1PLUS_PPC_CMPL			0x100f2
+#define PME_PM_CMPLU_STALL_DFU			0x2003c
+#define PME_PM_RUN_CYC				0x200f4
+#define PME_PM_RUN_INST_CMPL			0x400fa
+
 /*
  * Layout of constraint bits:
  * 6666555555555544444444443333333333222222222211111111110000000000
@@ -393,6 +416,31 @@ POWER_EVENT_ATTR(LD_MISS_L1,			LD_MISS_L1);
 POWER_EVENT_ATTR(BRU_FIN,			BRU_FIN)
 POWER_EVENT_ATTR(BRU_MPRED,			BRU_MPRED);
 
+POWER_EVENT_ATTR(CMPLU_STALL_FXU,		CMPLU_STALL_FXU);
+POWER_EVENT_ATTR(CMPLU_STALL_DIV,		CMPLU_STALL_DIV);
+POWER_EVENT_ATTR(CMPLU_STALL_SCALAR,		CMPLU_STALL_SCALAR);
+POWER_EVENT_ATTR(CMPLU_STALL_SCALAR_LONG,	CMPLU_STALL_SCALAR_LONG);
+POWER_EVENT_ATTR(CMPLU_STALL_VECTOR,		CMPLU_STALL_VECTOR);
+POWER_EVENT_ATTR(CMPLU_STALL_VECTOR_LONG,	CMPLU_STALL_VECTOR_LONG);
+POWER_EVENT_ATTR(CMPLU_STALL_LSU,		CMPLU_STALL_LSU);
+POWER_EVENT_ATTR(CMPLU_STALL_REJECT,		CMPLU_STALL_REJECT);
+
+POWER_EVENT_ATTR(CMPLU_STALL_ERAT_MISS,		CMPLU_STALL_ERAT_MISS);
+POWER_EVENT_ATTR(CMPLU_STALL_DCACHE_MISS,	CMPLU_STALL_DCACHE_MISS);
+POWER_EVENT_ATTR(CMPLU_STALL_STORE,		CMPLU_STALL_STORE);
+POWER_EVENT_ATTR(CMPLU_STALL_THRD,		CMPLU_STALL_THRD);
+POWER_EVENT_ATTR(CMPLU_STALL_IFU,		CMPLU_STALL_IFU);
+POWER_EVENT_ATTR(CMPLU_STALL_BRU,		CMPLU_STALL_BRU);
+POWER_EVENT_ATTR(GCT_NOSLOT_IC_MISS,		GCT_NOSLOT_IC_MISS);
+
+POWER_EVENT_ATTR(GCT_NOSLOT_BR_MPRED,		GCT_NOSLOT_BR_MPRED);
+POWER_EVENT_ATTR(GCT_NOSLOT_BR_MPRED_IC_MISS,	GCT_NOSLOT_BR_MPRED_IC_MISS);
+POWER_EVENT_ATTR(GRP_CMPL,			GRP_CMPL);
+POWER_EVENT_ATTR(1PLUS_PPC_CMPL,		1PLUS_PPC_CMPL);
+POWER_EVENT_ATTR(CMPLU_STALL_DFU,		CMPLU_STALL_DFU);
+POWER_EVENT_ATTR(RUN_CYC,			RUN_CYC);
+POWER_EVENT_ATTR(RUN_INST_CMPL,			RUN_INST_CMPL);
+
 static struct attribute *power7_events_attr[] = {
 	GENERIC_EVENT_PTR(CYC),
 	GENERIC_EVENT_PTR(GCT_NOSLOT_CYC),
@@ -411,6 +459,31 @@ static struct attribute *power7_events_attr[] = {
 	POWER_EVENT_PTR(LD_MISS_L1),
 	POWER_EVENT_PTR(BRU_FIN),
 	POWER_EVENT_PTR(BRU_MPRED),
+
+	POWER_EVENT_PTR(CMPLU_STALL_FXU),
+	POWER_EVENT_PTR(CMPLU_STALL_DIV),
+	POWER_EVENT_PTR(CMPLU_STALL_SCALAR),
+	POWER_EVENT_PTR(CMPLU_STALL_SCALAR_LONG),
+	POWER_EVENT_PTR(CMPLU_STALL_VECTOR),
+	POWER_EVENT_PTR(CMPLU_STALL_VECTOR_LONG),
+	POWER_EVENT_PTR(CMPLU_STALL_LSU),
+	POWER_EVENT_PTR(CMPLU_STALL_REJECT),
+
+	POWER_EVENT_PTR(CMPLU_STALL_ERAT_MISS),
+	POWER_EVENT_PTR(CMPLU_STALL_DCACHE_MISS),
+	POWER_EVENT_PTR(CMPLU_STALL_STORE),
+	POWER_EVENT_PTR(CMPLU_STALL_THRD),
+	POWER_EVENT_PTR(CMPLU_STALL_IFU),
+	POWER_EVENT_PTR(CMPLU_STALL_BRU),
+	POWER_EVENT_PTR(GCT_NOSLOT_IC_MISS),
+	POWER_EVENT_PTR(GCT_NOSLOT_BR_MPRED),
+
+	POWER_EVENT_PTR(GCT_NOSLOT_BR_MPRED_IC_MISS),
+	POWER_EVENT_PTR(GRP_CMPL),
+	POWER_EVENT_PTR(1PLUS_PPC_CMPL),
+	POWER_EVENT_PTR(CMPLU_STALL_DFU),
+	POWER_EVENT_PTR(RUN_CYC),
+	POWER_EVENT_PTR(RUN_INST_CMPL),
 	NULL
 };
 
-- 
1.7.1

