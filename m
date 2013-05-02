Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760719Ab3EBQaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 12:30:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65121 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760193Ab3EBQa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 12:30:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH v2] thermal: cpu_cooling: fix stub function
Date: Thu, 2 May 2013 18:29:37 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel kachhap <amit.daniel@samsung.com>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de> <1367507786-505303-13-git-send-email-arnd@arndb.de> <51828A45.60909@ti.com>
In-Reply-To: <51828A45.60909@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305021829.37343.arnd@arndb.de>
X-Provags-ID: V02:K0:Rpd4T8JJJiBekT3Pf4jXCE7ecy2TDs9NYT/iO9NL93Q
 1TfdqSqmi/Mu6t/i1ZWmpyV1XyHwpc9UQ4ZLLNjO84SpEEMUpB
 rjIXpcBZsMqgBGIYbJ3cwr3kqjfn1e1hBwjbnABSumYbF8Dime
 pPEXucT+Mbtk6irowQ7x5r2pH54A92nK6OEqsCbii7IhsP5oOj
 gkV2zD6Who/TCvEPNfId+h7KPBo2LrV++Z2aGsQVbbYYHMCbp/
 vjcEKOiiK/pwNca1wYXJHkAzm4ozcvPJYQ8j6RMk82yYa1qYQi
 g++rxKXI5NOKocEf+DzVRoyRwpDwilD6EcnbyligGDVtxCVs9Y
 qW96IjWm6ZKjuRhvNP2I=
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

Cc: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Amit Daniel kachhap <amit.daniel@samsung.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>

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


