Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaHQRbG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 13:31:06 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:57593
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751712AbaHQRav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 13:30:51 -0400
Message-Id: <20140817173034.022788940@linux.com>
Date: Sun, 17 Aug 2014 12:30:30 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 07/35] [PATCH 07/36] drivers/cpuidle: Replace __get_cpu_var uses for address
 calculation
References: <20140817173023.439660246@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0007-drivers-cpuidle-Replace-__get_cpu_var-uses-for-addre.patch
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
---
 drivers/cpuidle/governors/ladder.c | 4 ++--
 drivers/cpuidle/governors/menu.c   | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

Index: linux/drivers/cpuidle/governors/ladder.c
===================================================================
--- linux.orig/drivers/cpuidle/governors/ladder.c
+++ linux/drivers/cpuidle/governors/ladder.c
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
--- linux.orig/drivers/cpuidle/governors/menu.c
+++ linux/drivers/cpuidle/governors/menu.c
@@ -284,7 +284,7 @@ again:
  */
 static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 {
-	struct menu_device *data = &__get_cpu_var(menu_devices);
+	struct menu_device *data = this_cpu_ptr(&menu_devices);
 	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
 	int i;
 	unsigned int interactivity_req;
@@ -369,7 +369,7 @@ static int menu_select(struct cpuidle_dr
  */
 static void menu_reflect(struct cpuidle_device *dev, int index)
 {
-	struct menu_device *data = &__get_cpu_var(menu_devices);
+	struct menu_device *data = this_cpu_ptr(&menu_devices);
 	data->last_state_idx = index;
 	if (index >= 0)
 		data->needs_update = 1;
@@ -382,7 +382,7 @@ static void menu_reflect(struct cpuidle_
  */
 static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 {
-	struct menu_device *data = &__get_cpu_var(menu_devices);
+	struct menu_device *data = this_cpu_ptr(&menu_devices);
 	int last_idx = data->last_state_idx;
 	struct cpuidle_state *target = &drv->states[last_idx];
 	unsigned int measured_us;

