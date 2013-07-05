Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab3GEPk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 11:40:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62786 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab3GEPk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 11:40:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH] thermal: cpu_cooling: fix stub function
Date: Fri, 5 Jul 2013 17:40:13 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel kachhap <amit.daniel@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307051740.13692.arnd@arndb.de>
X-Provags-ID: V02:K0:FzAABFhe1ZsQ1cAnZJw6VcyWweBac5Iehw2LaXRav8Q
 KUkvKKroeuYe6lJsOeG39krB9tcSeJkArxvV7rFrJQ/IiRgigI
 Jx0LtrWDXxX3r5ID7ruXVJJc8ThAAXtyoJv7zz7WlUQNUjtkEM
 /kaTd3FXHfmw1D1dNL8elFz/w/RqsxW7LAhkFBtd44cpDlD08/
 Td9xYiH4uizeexoALbWkl7noq/HyD3G/vT7HhRqNTE7jgRooCH
 qskck18ORrfjwkPCS9VRZwRqn1IKyqYffd8aOI0se0g2034rgo
 UAVWJME2ra4c1z50XYgVplj7Nj4PCjxy2YlowjS4pV5v25BPQm
 QFZHQG7aDtQMtv8SRG9s=
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
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Amit Daniel kachhap <amit.daniel@samsung.com>
Cc: stable@vger.kernel.org
---
This is now needed for stable, since 3.10 is out.

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
