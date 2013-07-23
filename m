Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934944Ab3GWW2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:28:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41916 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934856Ab3GWW2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:28:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel kachhap <amit.daniel@samsung.com>
Subject: [ 090/103] thermal: cpu_cooling: fix stub function
Date: Tue, 23 Jul 2013 15:26:41 -0700
Message-Id: <20130723220431.218094285@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit e8d39240d635ed9bcaddbec898b1c9f063c5dbb2 upstream.

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
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/cpu_cooling.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/cpu_cooling.h
+++ b/include/linux/cpu_cooling.h
@@ -41,7 +41,7 @@ cpufreq_cooling_register(const struct cp
  */
 void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev);
 
-unsigned long cpufreq_cooling_get_level(unsigned int, unsigned int);
+unsigned long cpufreq_cooling_get_level(unsigned int cpu, unsigned int freq);
 #else /* !CONFIG_CPU_THERMAL */
 static inline struct thermal_cooling_device *
 cpufreq_cooling_register(const struct cpumask *clip_cpus)
@@ -54,7 +54,7 @@ void cpufreq_cooling_unregister(struct t
 	return;
 }
 static inline
-unsigned long cpufreq_cooling_get_level(unsigned int, unsigned int)
+unsigned long cpufreq_cooling_get_level(unsigned int cpu, unsigned int freq)
 {
 	return THERMAL_CSTATE_INVALID;
 }


