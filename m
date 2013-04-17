Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966149Ab3DQRXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:23:49 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58354 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965461Ab3DQRXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:23:47 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <amit.kachhap@linaro.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 30/30] thermal: cpu_cooling: improve line breaking
Date: Wed, 17 Apr 2013 13:12:23 -0400
Message-ID: <1366218743-20841-31-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To improve code readiness, change the way the lines
are broken in this file.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 include/linux/cpu_cooling.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/cpu_cooling.h b/include/linux/cpu_cooling.h
index f48f6fb..282e270 100644
--- a/include/linux/cpu_cooling.h
+++ b/include/linux/cpu_cooling.h
@@ -32,8 +32,8 @@
  * cpufreq_cooling_register - function to create cpufreq cooling device.
  * @clip_cpus: cpumask of cpus where the frequency constraints will happen
  */
-struct thermal_cooling_device *cpufreq_cooling_register(
-		const struct cpumask *clip_cpus);
+struct thermal_cooling_device *
+cpufreq_cooling_register(const struct cpumask *clip_cpus);
 
 /**
  * cpufreq_cooling_unregister - function to remove cpufreq cooling device.
@@ -43,18 +43,18 @@ void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev);
 
 unsigned long cpufreq_cooling_get_level(unsigned int, unsigned int);
 #else /* !CONFIG_CPU_THERMAL */
-static inline struct thermal_cooling_device *cpufreq_cooling_register(
-	const struct cpumask *clip_cpus)
+static inline struct thermal_cooling_device *
+cpufreq_cooling_register(const struct cpumask *clip_cpus)
 {
 	return NULL;
 }
-static inline void cpufreq_cooling_unregister(
-		struct thermal_cooling_device *cdev)
+static inline
+void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
 {
 	return;
 }
-static inline unsigned long cpufreq_cooling_get_level(unsigned int,
-						 unsigned int)
+static inline
+unsigned long cpufreq_cooling_get_level(unsigned int, unsigned int)
 {
 	return THERMAL_CSTATE_INVALID;
 }
-- 
1.8.2.1.342.gfa7285d

