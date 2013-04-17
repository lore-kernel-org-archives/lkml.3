Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966273Ab3DQRYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:24:14 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41890 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965917Ab3DQRYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:24:11 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <amit.kachhap@linaro.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/30] thermal: cpu_cooling: alignment improvements
Date: Wed, 17 Apr 2013 13:12:11 -0400
Message-ID: <1366218743-20841-19-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve code readiness by changing alignments so that
they match open parenthesis, like checkpatch.pl --strict
suggests.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/cpu_cooling.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index b5de9d4..35b5835 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -273,7 +273,7 @@ static unsigned int get_cpu_frequency(unsigned int cpu, unsigned long level)
  * cooling state).
  */
 static int cpufreq_apply_cooling(struct cpufreq_cooling_device *cpufreq_device,
-				unsigned long cooling_state)
+				 unsigned long cooling_state)
 {
 	unsigned int cpuid, clip_freq;
 	struct cpumask *mask = &cpufreq_device->allowed_cpus;
@@ -315,7 +315,7 @@ static int cpufreq_apply_cooling(struct cpufreq_cooling_device *cpufreq_device,
  * Return: 0 (success)
  */
 static int cpufreq_thermal_notifier(struct notifier_block *nb,
-					unsigned long event, void *data)
+				    unsigned long event, void *data)
 {
 	struct cpufreq_policy *policy = data;
 	unsigned long max_freq = 0;
@@ -406,8 +406,8 @@ static struct notifier_block thermal_cpufreq_notifier_block = {
  * cpufreq_cooling_register - function to create cpufreq cooling device.
  * @clip_cpus: cpumask of cpus where the frequency constraints will happen.
  */
-struct thermal_cooling_device *cpufreq_cooling_register(
-	const struct cpumask *clip_cpus)
+struct thermal_cooling_device *
+cpufreq_cooling_register(const struct cpumask *clip_cpus)
 {
 	struct thermal_cooling_device *cool_dev;
 	struct cpufreq_cooling_device *cpufreq_dev = NULL;
@@ -426,12 +426,12 @@ struct thermal_cooling_device *cpufreq_cooling_register(
 			max = policy.cpuinfo.max_freq;
 		} else {
 			if (min != policy.cpuinfo.min_freq ||
-				max != policy.cpuinfo.max_freq)
+			    max != policy.cpuinfo.max_freq)
 				return ERR_PTR(-EINVAL);
 		}
 	}
 	cpufreq_dev = kzalloc(sizeof(struct cpufreq_cooling_device),
-			GFP_KERNEL);
+			      GFP_KERNEL);
 	if (!cpufreq_dev)
 		return ERR_PTR(-ENOMEM);
 
@@ -446,7 +446,7 @@ struct thermal_cooling_device *cpufreq_cooling_register(
 	sprintf(dev_name, "thermal-cpufreq-%d", cpufreq_dev->id);
 
 	cool_dev = thermal_cooling_device_register(dev_name, cpufreq_dev,
-						&cpufreq_cooling_ops);
+						   &cpufreq_cooling_ops);
 	if (!cool_dev) {
 		release_idr(&cpufreq_idr, cpufreq_dev->id);
 		kfree(cpufreq_dev);
@@ -459,7 +459,7 @@ struct thermal_cooling_device *cpufreq_cooling_register(
 	/* Register the notifier for first cpufreq cooling device */
 	if (cpufreq_dev_count == 0)
 		cpufreq_register_notifier(&thermal_cpufreq_notifier_block,
-						CPUFREQ_POLICY_NOTIFIER);
+					  CPUFREQ_POLICY_NOTIFIER);
 	cpufreq_dev_count++;
 
 	mutex_unlock(&cooling_cpufreq_lock);
@@ -482,7 +482,7 @@ void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
 	/* Unregister the notifier for the last cpufreq cooling device */
 	if (cpufreq_dev_count == 0) {
 		cpufreq_unregister_notifier(&thermal_cpufreq_notifier_block,
-					CPUFREQ_POLICY_NOTIFIER);
+					    CPUFREQ_POLICY_NOTIFIER);
 	}
 	mutex_unlock(&cooling_cpufreq_lock);
 
-- 
1.8.2.1.342.gfa7285d

