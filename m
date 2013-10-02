Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab3JBAQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 20:16:23 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:58243 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562Ab3JBAPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 20:15:32 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH 3/9][v5] powerpc/perf: Add Power8 event PM_MRK_GRP_CMPL to sysfs.
Date: Tue,  1 Oct 2013 17:15:04 -0700
Message-Id: <1380672911-12812-4-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380672911-12812-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1380672911-12812-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100200-0320-0000-0000-00000133BA1B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf event PM_MRK_GRP_CMPL is useful in analyzing memory hierarchy
of applications.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Reviewed-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/perf/power8-pmu.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/powerpc/perf/power8-pmu.c b/arch/powerpc/perf/power8-pmu.c
index b991b2e..fc7ba38 100644
--- a/arch/powerpc/perf/power8-pmu.c
+++ b/arch/powerpc/perf/power8-pmu.c
@@ -24,6 +24,7 @@
 #define PME_PM_INST_CMPL			0x00002
 #define PME_PM_BRU_FIN				0x10068
 #define PME_PM_BR_MPRED_CMPL			0x400f6
+#define PME_PM_MRK_GRP_CMPL			0x40130
 
 
 /*
@@ -517,6 +518,8 @@ GENERIC_EVENT_ATTR(instructions,		PM_INST_CMPL);
 GENERIC_EVENT_ATTR(branch-instructions,		PM_BRU_FIN);
 GENERIC_EVENT_ATTR(branch-misses,		PM_BR_MPRED_CMPL);
 
+POWER_EVENT_ATTR(PM_MRK_GRP_CMPL,		PM_MRK_GRP_CMPL);
+
 static struct attribute *power8_events_attr[] = {
 	GENERIC_EVENT_PTR(PM_CYC),
 	GENERIC_EVENT_PTR(PM_GCT_NOSLOT_CYC),
@@ -524,6 +527,8 @@ static struct attribute *power8_events_attr[] = {
 	GENERIC_EVENT_PTR(PM_INST_CMPL),
 	GENERIC_EVENT_PTR(PM_BRU_FIN),
 	GENERIC_EVENT_PTR(PM_BR_MPRED_CMPL),
+
+	POWER_EVENT_PTR(PM_MRK_GRP_CMPL),
 	NULL
 };
 
-- 
1.7.9.5

