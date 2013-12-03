Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab3LCXjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:39:13 -0500
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:55066
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754662Ab3LCXi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:38:56 -0500
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Dec 2013 18:38:53 EST
Message-Id: <20131203233248.017658450@linux.com>
User-Agent: quilt/0.60-1
Date: Tue, 03 Dec 2013 17:32:38 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 06/41] drivers/cpuidle: Replace __get_cpu_var uses for address calculation
References: <20131203233232.928771708@linux.com>
Content-Disposition: inline; filename=this_drivers_cpuidle
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of these are for address calculation. Replace with
this_cpu_ptr().

Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-pm@vger.kernel.org
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
[cpufreq changes]
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/drivers/cpuidle/governors/ladder.c
===================================================================
--- linux.orig/drivers/cpuidle/governors/ladder.c	2013-12-02 16:07:48.284675507 -0600
+++ linux/drivers/cpuidle/governors/ladder.c	2013-12-02 16:07:48.274675782 -0600
@@ -66,7 +66,7 @@ static inline void ladder_do_selection(s
 static int ladder_select_state(struct cpuidle_driver *drv,
 				struct cpuidle_device *dev)
 {
-	struct ladder_device *ldev = &__get_cpu_var(ladder_devices);
+	struct ladder_device *ldev = this_cpu_ptr(&ladder_devices);
 	struct ladder_device_state *last_state;
 	int last_residency, last_idx = ldev->last_state_idx;
 	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
@@ -170,7 +170,7 @@ static int ladder_enable_device(struct c
  */
 static void ladder_reflect(struct cpuidle_device *dev, int index)
 {
-	struct ladder_device *ldev = &__get_cpu_var(ladder_devices);
+	struct ladder_device *ldev = this_cpu_ptr(&ladder_devices);
 	if (index > 0)
 		ldev->last_state_idx = index;
 }
Index: linux/drivers/cpuidle/governors/menu.c
===================================================================
--- linux.orig/drivers/cpuidle/governors/menu.c	2013-12-02 16:07:48.284675507 -0600
+++ linux/drivers/cpuidle/governors/menu.c	2013-12-02 16:07:48.274675782 -0600
@@ -286,7 +286,7 @@ again:
  */
 static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 {
-	struct menu_device *data = &__get_cpu_var(menu_devices);
+	struct menu_device *data = this_cpu_ptr(&menu_devices);
 	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
 	int i;
 	int multiplier;
@@ -375,7 +375,7 @@ static int menu_select(struct cpuidle_dr
  */
 static void menu_reflect(struct cpuidle_device *dev, int index)
 {
-	struct menu_device *data = &__get_cpu_var(menu_devices);
+	struct menu_device *data = this_cpu_ptr(&menu_devices);
 	data->last_state_idx = index;
 	if (index >= 0)
 		data->needs_update = 1;
@@ -388,7 +388,7 @@ static void menu_reflect(struct cpuidle_
  */
 static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 {
-	struct menu_device *data = &__get_cpu_var(menu_devices);
+	struct menu_device *data = this_cpu_ptr(&menu_devices);
 	int last_idx = data->last_state_idx;
 	unsigned int last_idle_us = cpuidle_get_last_residency(dev);
 	struct cpuidle_state *target = &drv->states[last_idx];

