Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760971Ab3DDM5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:57:10 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:46197 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760805Ab3DDM5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:57:07 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: [PATCH 14/18] cpufreq: sh: move cpufreq driver to drivers/cpufreq
Date: Thu,  4 Apr 2013 18:24:22 +0530
Message-Id: <3167220d1e262ff22078993a5beec55e82dfd951.1365079581.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1365079581.git.viresh.kumar@linaro.org>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1365079581.git.viresh.kumar@linaro.org>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves cpufreq driver of SUPERH architecture to drivers/cpufreq.

Cc: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/Kconfig                                        | 18 ------------------
 arch/sh/kernel/Makefile                                |  1 -
 drivers/cpufreq/Kconfig                                | 18 ++++++++++++++++++
 drivers/cpufreq/Makefile                               |  1 +
 .../kernel/cpufreq.c => drivers/cpufreq/sh-cpufreq.c   |  2 --
 5 files changed, 19 insertions(+), 21 deletions(-)
 rename arch/sh/kernel/cpufreq.c => drivers/cpufreq/sh-cpufreq.c (99%)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 5e85963..06e3163 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -624,25 +624,7 @@ config SH_CLK_CPG_LEGACY
 endmenu
 
 menu "CPU Frequency scaling"
-
 source "drivers/cpufreq/Kconfig"
-
-config SH_CPU_FREQ
-	tristate "SuperH CPU Frequency driver"
-	depends on CPU_FREQ
-	select CPU_FREQ_TABLE
-	help
-	  This adds the cpufreq driver for SuperH. Any CPU that supports
-	  clock rate rounding through the clock framework can use this
-	  driver. While it will make the kernel slightly larger, this is
-	  harmless for CPUs that don't support rate rounding. The driver
-	  will also generate a notice in the boot log before disabling
-	  itself if the CPU in question is not capable of rate rounding.
-
-	  For details, take a look at <file:Documentation/cpu-freq>.
-
-	  If unsure, say N.
-
 endmenu
 
 source "arch/sh/drivers/Kconfig"
diff --git a/arch/sh/kernel/Makefile b/arch/sh/kernel/Makefile
index f259b37..261c8bf 100644
--- a/arch/sh/kernel/Makefile
+++ b/arch/sh/kernel/Makefile
@@ -31,7 +31,6 @@ obj-$(CONFIG_VSYSCALL)		+= vsyscall/
 obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_SH_STANDARD_BIOS)	+= sh_bios.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
-obj-$(CONFIG_SH_CPU_FREQ)	+= cpufreq.o
 obj-$(CONFIG_MODULES)		+= sh_ksyms_$(BITS).o module.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 5030df5..602d5db 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -258,5 +258,23 @@ depends on PPC32 || PPC64
 source "drivers/cpufreq/Kconfig.powerpc"
 endmenu
 
+menu "SH CPU Frequency scaling"
+depends on SUPERH
+config SH_CPU_FREQ
+	tristate "SuperH CPU Frequency driver"
+	select CPU_FREQ_TABLE
+	help
+	  This adds the cpufreq driver for SuperH. Any CPU that supports
+	  clock rate rounding through the clock framework can use this
+	  driver. While it will make the kernel slightly larger, this is
+	  harmless for CPUs that don't support rate rounding. The driver
+	  will also generate a notice in the boot log before disabling
+	  itself if the CPU in question is not capable of rate rounding.
+
+	  For details, take a look at <file:Documentation/cpu-freq>.
+
+	  If unsure, say N.
+endmenu
+
 endif
 endmenu
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index f6226d1..12607d9 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -88,3 +88,4 @@ obj-$(CONFIG_CRIS_MACH_ARTPEC3)		+= cris-artpec3-cpufreq.o
 obj-$(CONFIG_ETRAXFS)			+= cris-etraxfs-cpufreq.o
 obj-$(CONFIG_IA64_ACPI_CPUFREQ)		+= ia64-acpi-cpufreq.o
 obj-$(CONFIG_LOONGSON2_CPUFREQ)		+= loongson2_cpufreq.o
+obj-$(CONFIG_SH_CPU_FREQ)		+= sh-cpufreq.o
diff --git a/arch/sh/kernel/cpufreq.c b/drivers/cpufreq/sh-cpufreq.c
similarity index 99%
rename from arch/sh/kernel/cpufreq.c
rename to drivers/cpufreq/sh-cpufreq.c
index 88c8fee..73adb64 100644
--- a/arch/sh/kernel/cpufreq.c
+++ b/drivers/cpufreq/sh-cpufreq.c
@@ -1,6 +1,4 @@
 /*
- * arch/sh/kernel/cpufreq.c
- *
  * cpufreq driver for the SuperH processors.
  *
  * Copyright (C) 2002 - 2012 Paul Mundt
-- 
1.7.12.rc2.18.g61b472e

