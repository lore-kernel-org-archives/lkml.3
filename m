Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbaBNUYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:24:54 -0500
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:47242 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753355AbaBNUU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:20:29 -0500
Message-Id: <20140214201907.871760752@linux.com>
Date: Fri, 14 Feb 2014 14:19:18 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 37/48] s390: Handle new __get_cpu_var calls added in 3.14
References: <20140214201841.826179349@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=s390_new
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/s390/kernel/perf_cpum_sf.c
===================================================================
--- linux.orig/arch/s390/kernel/perf_cpum_sf.c	2014-01-20 16:18:06.634974387 -0600
+++ linux/arch/s390/kernel/perf_cpum_sf.c	2014-02-03 14:20:50.982932405 -0600
@@ -562,7 +562,7 @@
 static void setup_pmc_cpu(void *flags)
 {
 	int err;
-	struct cpu_hw_sf *cpusf = &__get_cpu_var(cpu_hw_sf);
+	struct cpu_hw_sf *cpusf = this_cpu_ptr(&cpu_hw_sf);
 
 	err = 0;
 	switch (*((int *) flags)) {
@@ -849,7 +849,7 @@
 
 static void cpumsf_pmu_enable(struct pmu *pmu)
 {
-	struct cpu_hw_sf *cpuhw = &__get_cpu_var(cpu_hw_sf);
+	struct cpu_hw_sf *cpuhw = this_cpu_ptr(&cpu_hw_sf);
 	struct hw_perf_event *hwc;
 	int err;
 
@@ -898,7 +898,7 @@
 
 static void cpumsf_pmu_disable(struct pmu *pmu)
 {
-	struct cpu_hw_sf *cpuhw = &__get_cpu_var(cpu_hw_sf);
+	struct cpu_hw_sf *cpuhw = this_cpu_ptr(&cpu_hw_sf);
 	struct hws_lsctl_request_block inactive;
 	struct hws_qsi_info_block si;
 	int err;
@@ -1306,7 +1306,7 @@
  */
 static void cpumsf_pmu_start(struct perf_event *event, int flags)
 {
-	struct cpu_hw_sf *cpuhw = &__get_cpu_var(cpu_hw_sf);
+	struct cpu_hw_sf *cpuhw = this_cpu_ptr(&cpu_hw_sf);
 
 	if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
 		return;
@@ -1327,7 +1327,7 @@
  */
 static void cpumsf_pmu_stop(struct perf_event *event, int flags)
 {
-	struct cpu_hw_sf *cpuhw = &__get_cpu_var(cpu_hw_sf);
+	struct cpu_hw_sf *cpuhw = this_cpu_ptr(&cpu_hw_sf);
 
 	if (event->hw.state & PERF_HES_STOPPED)
 		return;
@@ -1346,7 +1346,7 @@
 
 static int cpumsf_pmu_add(struct perf_event *event, int flags)
 {
-	struct cpu_hw_sf *cpuhw = &__get_cpu_var(cpu_hw_sf);
+	struct cpu_hw_sf *cpuhw = this_cpu_ptr(&cpu_hw_sf);
 	int err;
 
 	if (cpuhw->flags & PMU_F_IN_USE)
@@ -1397,7 +1397,7 @@
 
 static void cpumsf_pmu_del(struct perf_event *event, int flags)
 {
-	struct cpu_hw_sf *cpuhw = &__get_cpu_var(cpu_hw_sf);
+	struct cpu_hw_sf *cpuhw = this_cpu_ptr(&cpu_hw_sf);
 
 	perf_pmu_disable(event->pmu);
 	cpumsf_pmu_stop(event, PERF_EF_UPDATE);
@@ -1470,7 +1470,7 @@
 	if (!(alert & CPU_MF_INT_SF_MASK))
 		return;
 	inc_irq_stat(IRQEXT_CMS);
-	cpuhw = &__get_cpu_var(cpu_hw_sf);
+	cpuhw = this_cpu_ptr(&cpu_hw_sf);
 
 	/* Measurement alerts are shared and might happen when the PMU
 	 * is not reserved.  Ignore these alerts in this case. */

