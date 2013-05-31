Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab3EaWYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:24:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57468 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757644Ab3EaWXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:23:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: patches@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel kachhap <amit.daniel@samsung.com>
Subject: [PATCH 08/15] thermal: cpu_cooling: fix stub function
Date: Sat,  1 Jun 2013 00:22:45 +0200
Message-Id: <1370038972-2318779-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:W1xtejhJFIYTn27aBKibIdJWwqfNjSUoiq9FBd1ko7S
 TYUY81mIRGCmg6FFV/5DsOQsELPBXRQGdPEBHtsuDdakS6S5ZS
 5MW+c7LWzf6VT5q9HSlUaW/EeEgvUY/DMDdBgCdx+OvY3h2nIS
 P/BC1Ba0jDofkIzq/RD0aEY+ZWEa5zIH4aKfaG9lfEBAG/b9PZ
 Si6yY1GKk0dpuGxxxyC7rWrhcmb5GIeyuQF/fdE33XvIW349NO
 ccfy5cqn8MK9bAC+2xhoFNVg/QrxQJdB9/02ffqj0b3vcH6YB+
 W6a1cgZhvZ4Pd38jPxiymMzENpJr/BcjLbYB4AruxmDoC69WM9
 Mi8vXQc+zwSsqeaspI781cMVFoU2XJfJhCsTiNeil
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function stub for cpufreq_cooling_get_level introduced
in 57df81069 "Thermal: exynos: fix cooling state translation"
is not syntactically correct C and needs to be fixed to avoid
this error:

In file included from drivers/thermal/db8500_thermal.c:20:0:
 include/linux/cpu_cooling.h: In function 'cpufreq_cooling_get_level':
include/linux/cpu_cooling.h:57:1:
 error: parameter name omitted  unsigned long cpufreq_cooling_get_level(unsigned int, unsigned int)  ^
 include/linux/cpu_cooling.h:57:1: error: parameter name omitted

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Amit Daniel kachhap <amit.daniel@samsung.com>
---
 include/linux/cpu_cooling.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/cpu_cooling.h b/include/linux/cpu_cooling.h
index 282e270..a5d52ee 100644
--- a/include/linux/cpu_cooling.h
+++ b/include/linux/cpu_cooling.h
@@ -41,7 +41,7 @@ cpufreq_cooling_register(const struct cpumask *clip_cpus);
  */
 void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev);
 
-unsigned long cpufreq_cooling_get_level(unsigned int, unsigned int);
+unsigned long cpufreq_cooling_get_level(unsigned int cpu, unsigned int freq);
 #else /* !CONFIG_CPU_THERMAL */
 static inline struct thermal_cooling_device *
 cpufreq_cooling_register(const struct cpumask *clip_cpus)
@@ -54,7 +54,7 @@ void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
 	return;
 }
 static inline
-unsigned long cpufreq_cooling_get_level(unsigned int, unsigned int)
+unsigned long cpufreq_cooling_get_level(unsigned int cpu, unsigned int freq)
 {
 	return THERMAL_CSTATE_INVALID;
 }
-- 
1.8.1.2

