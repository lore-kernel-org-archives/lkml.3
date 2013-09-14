Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab3INAt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 20:49:26 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:58545 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755984Ab3INAtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 20:49:22 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: <linux-kernel@vger.kernel.org>
Cc: linuxppc-dev@ozlabs.org, Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH 2/8][v4] powerpc/perf: Export Power8 generic events in sysfs
Date: Fri, 13 Sep 2013 17:49:09 -0700
Message-Id: <1379119755-21025-3-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379119755-21025-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1379119755-21025-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091400-0320-0000-0000-000001011533
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export generic perf events for Power8 in sysfs.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 arch/powerpc/perf/power8-pmu.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/powerpc/perf/power8-pmu.c b/arch/powerpc/perf/power8-pmu.c
index 30c6b12..ff98fb8 100644
--- a/arch/powerpc/perf/power8-pmu.c
+++ b/arch/powerpc/perf/power8-pmu.c
@@ -510,6 +510,28 @@ static void power8_disable_pmc(unsigned int pmc, unsigned long mmcr[])
 		mmcr[1] &= ~(0xffUL << MMCR1_PMCSEL_SHIFT(pmc + 1));
 }
 
+GENERIC_EVENT_ATTR(cpu-cyles,			PM_CYC);
+GENERIC_EVENT_ATTR(stalled-cycles-frontend,	PM_GCT_NOSLOT_CYC);
+GENERIC_EVENT_ATTR(stalled-cycles-backend,	PM_CMPLU_STALL);
+GENERIC_EVENT_ATTR(instructions,		PM_INST_CMPL);
+GENERIC_EVENT_ATTR(branch-instructions,		PM_BRU_FIN);
+GENERIC_EVENT_ATTR(branch-misses,		PM_BR_MPRED_CMPL);
+
+static struct attribute *power8_events_attr[] = {
+	GENERIC_EVENT_PTR(PM_CYC),
+	GENERIC_EVENT_PTR(PM_GCT_NOSLOT_CYC),
+	GENERIC_EVENT_PTR(PM_CMPLU_STALL),
+	GENERIC_EVENT_PTR(PM_INST_CMPL),
+	GENERIC_EVENT_PTR(PM_BRU_FIN),
+	GENERIC_EVENT_PTR(PM_BR_MPRED_CMPL),
+	NULL
+};
+
+static struct attribute_group power8_pmu_events_group = {
+	.name = "events",
+	.attrs = power8_events_attr,
+};
+
 PMU_FORMAT_ATTR(event,		"config:0-49");
 PMU_FORMAT_ATTR(pmcxsel,	"config:0-7");
 PMU_FORMAT_ATTR(mark,		"config:8");
@@ -546,6 +568,7 @@ struct attribute_group power8_pmu_format_group = {
 
 static const struct attribute_group *power8_pmu_attr_groups[] = {
 	&power8_pmu_format_group,
+	&power8_pmu_events_group,
 	NULL,
 };
 
-- 
1.7.9.5

