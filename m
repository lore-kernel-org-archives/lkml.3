Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761060Ab3DDM50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:57:26 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:59298 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760241Ab3DDM5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:57:23 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH 16/18] cpufreq: sparc: move cpufreq driver to drivers/cpufreq
Date: Thu,  4 Apr 2013 18:24:24 +0530
Message-Id: <fee212b46046002517012dd1bc7f9ef209f83651.1365079581.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1365079581.git.viresh.kumar@linaro.org>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1365079581.git.viresh.kumar@linaro.org>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves cpufreq driver of SPARC architecture to drivers/cpufreq.

Cc: David S. Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/Kconfig                                 | 23 ----------------------
 arch/sparc/kernel/Makefile                         |  3 ---
 drivers/cpufreq/Kconfig                            | 23 ++++++++++++++++++++++
 drivers/cpufreq/Makefile                           |  2 ++
 .../cpufreq/sparc-us2e-cpufreq.c                   |  0
 .../cpufreq/sparc-us3-cpufreq.c                    |  0
 6 files changed, 25 insertions(+), 26 deletions(-)
 rename arch/sparc/kernel/us2e_cpufreq.c => drivers/cpufreq/sparc-us2e-cpufreq.c (100%)
 rename arch/sparc/kernel/us3_cpufreq.c => drivers/cpufreq/sparc-us3-cpufreq.c (100%)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 3d361f2..c85b761 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -254,29 +254,6 @@ config HOTPLUG_CPU
 
 if SPARC64
 source "drivers/cpufreq/Kconfig"
-
-config US3_FREQ
-	tristate "UltraSPARC-III CPU Frequency driver"
-	depends on CPU_FREQ
-	select CPU_FREQ_TABLE
-	help
-	  This adds the CPUFreq driver for UltraSPARC-III processors.
-
-	  For details, take a look at <file:Documentation/cpu-freq>.
-
-	  If in doubt, say N.
-
-config US2E_FREQ
-	tristate "UltraSPARC-IIe CPU Frequency driver"
-	depends on CPU_FREQ
-	select CPU_FREQ_TABLE
-	help
-	  This adds the CPUFreq driver for UltraSPARC-IIe processors.
-
-	  For details, take a look at <file:Documentation/cpu-freq>.
-
-	  If in doubt, say N.
-
 endif
 
 config US3_MC
diff --git a/arch/sparc/kernel/Makefile b/arch/sparc/kernel/Makefile
index 6cf591b..5276fd4 100644
--- a/arch/sparc/kernel/Makefile
+++ b/arch/sparc/kernel/Makefile
@@ -102,9 +102,6 @@ obj-$(CONFIG_PCI_MSI)        += pci_msi.o
 
 obj-$(CONFIG_COMPAT)         += sys32.o sys_sparc32.o signal32.o
 
-# sparc64 cpufreq
-obj-$(CONFIG_US3_FREQ)  += us3_cpufreq.o
-obj-$(CONFIG_US2E_FREQ) += us2e_cpufreq.o
 obj-$(CONFIG_US3_MC)    += chmc.o
 
 obj-$(CONFIG_KPROBES)   += kprobes.o
diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 602d5db..a1488f5 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -258,6 +258,29 @@ depends on PPC32 || PPC64
 source "drivers/cpufreq/Kconfig.powerpc"
 endmenu
 
+menu "SPARC CPU frequency scaling drivers"
+depends on SPARC64
+config SPARC_US3_CPUFREQ
+	tristate "UltraSPARC-III CPU Frequency driver"
+	select CPU_FREQ_TABLE
+	help
+	  This adds the CPUFreq driver for UltraSPARC-III processors.
+
+	  For details, take a look at <file:Documentation/cpu-freq>.
+
+	  If in doubt, say N.
+
+config SPARC_US2E_CPUFREQ
+	tristate "UltraSPARC-IIe CPU Frequency driver"
+	select CPU_FREQ_TABLE
+	help
+	  This adds the CPUFreq driver for UltraSPARC-IIe processors.
+
+	  For details, take a look at <file:Documentation/cpu-freq>.
+
+	  If in doubt, say N.
+endmenu
+
 menu "SH CPU Frequency scaling"
 depends on SUPERH
 config SH_CPU_FREQ
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index e47acff..db96d74 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -89,4 +89,6 @@ obj-$(CONFIG_ETRAXFS)			+= cris-etraxfs-cpufreq.o
 obj-$(CONFIG_IA64_ACPI_CPUFREQ)		+= ia64-acpi-cpufreq.o
 obj-$(CONFIG_LOONGSON2_CPUFREQ)		+= loongson2_cpufreq.o
 obj-$(CONFIG_SH_CPU_FREQ)		+= sh-cpufreq.o
+obj-$(CONFIG_SPARC_US2E_CPUFREQ)	+= sparc-us2e-cpufreq.o
+obj-$(CONFIG_SPARC_US3_CPUFREQ)		+= sparc-us3-cpufreq.o
 obj-$(CONFIG_UNICORE32)			+= unicore2-cpufreq.o
diff --git a/arch/sparc/kernel/us2e_cpufreq.c b/drivers/cpufreq/sparc-us2e-cpufreq.c
similarity index 100%
rename from arch/sparc/kernel/us2e_cpufreq.c
rename to drivers/cpufreq/sparc-us2e-cpufreq.c
diff --git a/arch/sparc/kernel/us3_cpufreq.c b/drivers/cpufreq/sparc-us3-cpufreq.c
similarity index 100%
rename from arch/sparc/kernel/us3_cpufreq.c
rename to drivers/cpufreq/sparc-us3-cpufreq.c
-- 
1.7.12.rc2.18.g61b472e

