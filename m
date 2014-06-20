Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727AbaFTTjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:39:32 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:37679 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965515AbaFTTbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:31:41 -0400
Message-Id: <20140620193125.567452655@linux.com>
Date: Fri, 20 Jun 2014 14:31:21 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 06/31] drivers/cpuidle: Replace __get_cpu_var uses for address calculation
References: <20140620193115.547427118@linux.com>
Content-Type: text/plain; charset=UTF-8
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
--- linux.orig/drivers/cpuidle/governors/ladder.c	2014-05-21 22:47:23.951916206 -0500
+++ linux/drivers/cpuidle/governors/ladder.c	2014-05-21 22:47:23.943916368 -0500
@@ -66,7 +66,7 @@
 static int ladder_select_state(struct cpuidle_driver *drv,
 				struct cpuidle_device *dev)
 {
-	struct ladder_device *ldev = &__get_cpu_var(ladder_devices);
+	struct ladder_device *ldev = this_cpu_ptr(&ladder_devices);
 	struct ladder_device_state *last_state;
 	int last_residency, last_idx = ldev->last_state_idx;
 	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
@@ -170,7 +170,7 @@
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
--- linux.orig/drivers/cpuidle/governors/menu.c	2014-05-21 22:47:23.951916206 -0500
+++ linux/drivers/cpuidle/governors/menu.c	2014-05-21 22:47:23.943916368 -0500
@@ -285,7 +285,7 @@
  */
 static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 {
-	struct menu_device *data = &__get_cpu_var(menu_devices);
+	struct menu_device *data = this_cpu_ptr(&menu_devices);
 	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
 	int i;
 	unsigned int interactivity_req;
@@ -370,7 +370,7 @@
  */
 static void menu_reflect(struct cpuidle_device *dev, int index)
 {
-	struct menu_device *data = &__get_cpu_var(menu_devices);
+	struct menu_device *data = this_cpu_ptr(&menu_devices);
 	data->last_state_idx = index;
 	if (index >= 0)
 		data->needs_update = 1;
@@ -383,7 +383,7 @@
  */
 static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 {
-	struct menu_device *data = &__get_cpu_var(menu_devices);
+	struct menu_device *data = this_cpu_ptr(&menu_devices);
 	int last_idx = data->last_state_idx;
 	struct cpuidle_state *target = &drv->states[last_idx];
 	unsigned int measured_us;

