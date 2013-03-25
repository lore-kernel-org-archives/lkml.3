Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab3CYKMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:12:08 -0400
Received: from service87.mimecast.com ([91.220.42.44]:51745 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476Ab3CYKMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:12:02 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: arvind.chauhan@arm.com, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd.bergmann@linaro.org, linux@arm.linux.org.uk,
        Viresh Kumar <viresh.kumar@linaro.org>, Sekhar Nori <nsekhar@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com
Subject: [PATCH 3/9] cpufreq: davinci: move cpufreq driver to drivers/cpufreq
Date: Mon, 25 Mar 2013 15:41:34 +0530
Message-Id: <ef225dbf63b1d834761773384d3f70cb4ac7b611.1364205812.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1364205812.git.viresh.kumar@linaro.org>
References: <cover.1364205812.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1364205812.git.viresh.kumar@linaro.org>
References: <cover.1364205812.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 25 Mar 2013 10:11:58.0657 (UTC) FILETIME=[2F7BAB10:01CE2941]
X-MC-Unique: 113032510120018501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r2PACBIR026788

This patch moves cpufreq driver of ARM based davinci platform to
drivers/cpufreq.

Cc: Sekhar Nori <nsekhar@ti.com>
Cc: davinci-linux-open-source@linux.davincidsp.com
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/mach-davinci/Makefile                                       | 1 -
 drivers/cpufreq/Makefile                                             | 1 +
 arch/arm/mach-davinci/cpufreq.c => drivers/cpufreq/davinci-cpufreq.c | 2 --
 3 files changed, 1 insertion(+), 3 deletions(-)
 rename arch/arm/mach-davinci/cpufreq.c => drivers/cpufreq/davinci-cpufreq.c (99%)

diff --git a/arch/arm/mach-davinci/Makefile b/arch/arm/mach-davinci/Makefile
index fb5c1aa..dd1ffcc 100644
--- a/arch/arm/mach-davinci/Makefile
+++ b/arch/arm/mach-davinci/Makefile
@@ -37,7 +37,6 @@ obj-$(CONFIG_MACH_MITYOMAPL138)		+= board-mityomapl138.o
 obj-$(CONFIG_MACH_OMAPL138_HAWKBOARD)	+= board-omapl138-hawk.o
 
 # Power Management
-obj-$(CONFIG_CPU_FREQ)			+= cpufreq.o
 obj-$(CONFIG_CPU_IDLE)			+= cpuidle.o
 obj-$(CONFIG_SUSPEND)			+= pm.o sleep.o
 obj-$(CONFIG_HAVE_CLK)			+= pm_domain.o
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 966ea28..efce6c7 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -44,6 +44,7 @@ obj-$(CONFIG_X86_INTEL_PSTATE)		+= intel_pstate.o
 
 ##################################################################################
 # ARM SoC drivers
+obj-$(CONFIG_ARCH_DAVINCI_DA850)	+= davinci-cpufreq.o
 obj-$(CONFIG_UX500_SOC_DB8500)		+= dbx500-cpufreq.o
 obj-$(CONFIG_ARM_EXYNOS_CPUFREQ)	+= exynos-cpufreq.o
 obj-$(CONFIG_ARM_EXYNOS4210_CPUFREQ)	+= exynos4210-cpufreq.o
diff --git a/arch/arm/mach-davinci/cpufreq.c b/drivers/cpufreq/davinci-cpufreq.c
similarity index 99%
rename from arch/arm/mach-davinci/cpufreq.c
rename to drivers/cpufreq/davinci-cpufreq.c
index 8fb0c2a..5b34f61 100644
--- a/arch/arm/mach-davinci/cpufreq.c
+++ b/drivers/cpufreq/davinci-cpufreq.c
@@ -30,8 +30,6 @@
 #include <mach/cpufreq.h>
 #include <mach/common.h>
 
-#include "clock.h"
-
 struct davinci_cpufreq {
 	struct device *dev;
 	struct clk *armclk;
-- 
1.7.12.rc2.18.g61b472e


