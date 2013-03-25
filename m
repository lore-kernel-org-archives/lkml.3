Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab3CYQzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 12:55:16 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:50098 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329Ab3CYQzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 12:55:11 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: arvind.chauhan@arm.com, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd.bergmann@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        hans-christian.egtvedt@atmel.com,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: [PATCH 1/9] AVR32: cpufreq:  move cpufreq driver to drivers/cpufreq
Date: Mon, 25 Mar 2013 22:24:37 +0530
Message-Id: <60261de9edc02fa85ef16fb07abc4dfc49c8b333.1364229828.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1364229828.git.viresh.kumar@linaro.org>
References: <cover.1364229828.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1364229828.git.viresh.kumar@linaro.org>
References: <cover.1364229828.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves cpufreq driver of AVR32 based at32ap platform to
drivers/cpufreq.

Cc: hans-christian.egtvedt@atmel.com
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/avr32/Kconfig                                          | 13 -------------
 arch/avr32/configs/atngw100_defconfig                       |  2 +-
 arch/avr32/configs/atngw100_evklcd100_defconfig             |  2 +-
 arch/avr32/configs/atngw100_evklcd101_defconfig             |  2 +-
 arch/avr32/configs/atngw100_mrmt_defconfig                  |  2 +-
 arch/avr32/configs/atngw100mkii_defconfig                   |  2 +-
 arch/avr32/configs/atngw100mkii_evklcd100_defconfig         |  2 +-
 arch/avr32/configs/atngw100mkii_evklcd101_defconfig         |  2 +-
 arch/avr32/configs/atstk1002_defconfig                      |  2 +-
 arch/avr32/configs/atstk1003_defconfig                      |  2 +-
 arch/avr32/configs/atstk1004_defconfig                      |  2 +-
 arch/avr32/configs/atstk1006_defconfig                      |  2 +-
 arch/avr32/configs/favr-32_defconfig                        |  2 +-
 arch/avr32/configs/hammerhead_defconfig                     |  2 +-
 arch/avr32/configs/mimc200_defconfig                        |  2 +-
 arch/avr32/mach-at32ap/Makefile                             |  1 -
 drivers/cpufreq/Kconfig                                     | 13 +++++++++++++
 drivers/cpufreq/Makefile                                    |  4 ++++
 .../cpufreq.c => drivers/cpufreq/at32ap-cpufreq.c           |  0
 19 files changed, 31 insertions(+), 28 deletions(-)
 rename arch/avr32/mach-at32ap/cpufreq.c => drivers/cpufreq/at32ap-cpufreq.c (100%)

diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index c1a868d..22c4030 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -250,20 +250,7 @@ config ARCH_SUSPEND_POSSIBLE
 	def_bool y
 
 menu "CPU Frequency scaling"
-
 source "drivers/cpufreq/Kconfig"
-
-config CPU_FREQ_AT32AP
-	bool "CPU frequency driver for AT32AP"
-	depends on CPU_FREQ && PLATFORM_AT32AP
-	default n
-	help
-	  This enables the CPU frequency driver for AT32AP processors.
-
-	  For details, take a look in <file:Documentation/cpu-freq>.
-
-	  If in doubt, say N.
-
 endmenu
 
 endmenu
diff --git a/arch/avr32/configs/atngw100_defconfig b/arch/avr32/configs/atngw100_defconfig
index f4025db..d5aff36 100644
--- a/arch/avr32/configs/atngw100_defconfig
+++ b/arch/avr32/configs/atngw100_defconfig
@@ -26,7 +26,7 @@ CONFIG_CPU_FREQ=y
 # CONFIG_CPU_FREQ_STAT is not set
 CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
 CONFIG_CPU_FREQ_GOV_USERSPACE=y
-CONFIG_CPU_FREQ_AT32AP=y
+CONFIG_AVR32_AT32AP_CPUFREQ=y
 CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
 CONFIG_NET=y
 CONFIG_PACKET=y
diff --git a/arch/avr32/configs/atngw100_evklcd100_defconfig b/arch/avr32/configs/atngw100_evklcd100_defconfig
index c76a49b..4abcf43 100644
--- a/arch/avr32/configs/atngw100_evklcd100_defconfig
+++ b/arch/avr32/configs/atngw100_evklcd100_defconfig
@@ -28,7 +28,7 @@ CONFIG_CPU_FREQ=y
 # CONFIG_CPU_FREQ_STAT is not set
 CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
 CONFIG_CPU_FREQ_GOV_USERSPACE=y
-CONFIG_CPU_FREQ_AT32AP=y
+CONFIG_AVR32_AT32AP_CPUFREQ=y
 CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
 CONFIG_NET=y
 CONFIG_PACKET=y
diff --git a/arch/avr32/configs/atngw100_evklcd101_defconfig b/arch/avr32/configs/atngw100_evklcd101_defconfig
index 2d8ab08..18f3fa0 100644
--- a/arch/avr32/configs/atngw100_evklcd101_defconfig
+++ b/arch/avr32/configs/atngw100_evklcd101_defconfig
@@ -27,7 +27,7 @@ CONFIG_CPU_FREQ=y
 # CONFIG_CPU_FREQ_STAT is not set
 CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
 CONFIG_CPU_FREQ_GOV_USERSPACE=y
-CONFIG_CPU_FREQ_AT32AP=y
+CONFIG_AVR32_AT32AP_CPUFREQ=y
 CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
 CONFIG_NET=y
 CONFIG_PACKET=y
diff --git a/arch/avr32/configs/atngw100_mrmt_defconfig b/arch/avr32/configs/atngw100_mrmt_defconfig
index b189e0c..06e389c 100644
--- a/arch/avr32/configs/atngw100_mrmt_defconfig
+++ b/arch/avr32/configs/atngw100_mrmt_defconfig
@@ -23,7 +23,7 @@ CONFIG_CPU_FREQ=y
 CONFIG_CPU_FREQ_GOV_POWERSAVE=y
 CONFIG_CPU_FREQ_GOV_USERSPACE=y
 CONFIG_CPU_FREQ_GOV_ONDEMAND=y
-CONFIG_CPU_FREQ_AT32AP=y
+CONFIG_AVR32_AT32AP_CPUFREQ=y
 CONFIG_NET=y
 CONFIG_PACKET=y
 CONFIG_UNIX=y
diff --git a/arch/avr32/configs/atngw100mkii_defconfig b/arch/avr32/configs/atngw100mkii_defconfig
index 2e4de42..2518a13 100644
--- a/arch/avr32/configs/atngw100mkii_defconfig
+++ b/arch/avr32/configs/atngw100mkii_defconfig
@@ -26,7 +26,7 @@ CONFIG_CPU_FREQ=y
 # CONFIG_CPU_FREQ_STAT is not set
 CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
 CONFIG_CPU_FREQ_GOV_USERSPACE=y
-CONFIG_CPU_FREQ_AT32AP=y
+CONFIG_AVR32_AT32AP_CPUFREQ=y
 CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
 CONFIG_NET=y
 CONFIG_PACKET=y
diff --git a/arch/avr32/configs/atngw100mkii_evklcd100_defconfig b/arch/avr32/configs/atngw100mkii_evklcd100_defconfig
index fad3cd2..245ef6b 100644
--- a/arch/avr32/configs/atngw100mkii_evklcd100_defconfig
+++ b/arch/avr32/configs/atngw100mkii_evklcd100_defconfig
@@ -29,7 +29,7 @@ CONFIG_CPU_FREQ=y
 # CONFIG_CPU_FREQ_STAT is not set
 CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
 CONFIG_CPU_FREQ_GOV_USERSPACE=y
-CONFIG_CPU_FREQ_AT32AP=y
+CONFIG_AVR32_AT32AP_CPUFREQ=y
 CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
 CONFIG_NET=y
 CONFIG_PACKET=y
diff --git a/arch/avr32/configs/atngw100mkii_evklcd101_defconfig b/arch/avr32/configs/atngw100mkii_evklcd101_defconfig
index 2998623..fa6cbac 100644
--- a/arch/avr32/configs/atngw100mkii_evklcd101_defconfig
+++ b/arch/avr32/configs/atngw100mkii_evklcd101_defconfig
@@ -28,7 +28,7 @@ CONFIG_CPU_FREQ=y
 # CONFIG_CPU_FREQ_STAT is not set
 CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
 CONFIG_CPU_FREQ_GOV_USERSPACE=y
-CONFIG_CPU_FREQ_AT32AP=y
+CONFIG_AVR32_AT32AP_CPUFREQ=y
 CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
 CONFIG_NET=y
 CONFIG_PACKET=y
diff --git a/arch/avr32/configs/atstk1002_defconfig b/arch/avr32/configs/atstk1002_defconfig
index a582465..bbd5131 100644
--- a/arch/avr32/configs/atstk1002_defconfig
+++ b/arch/avr32/configs/atstk1002_defconfig
@@ -25,7 +25,7 @@ CONFIG_CPU_FREQ=y
 # CONFIG_CPU_FREQ_STAT is not set
 CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
 CONFIG_CPU_FREQ_GOV_USERSPACE=y
-CONFIG_CPU_FREQ_AT32AP=y
+CONFIG_AVR32_AT32AP_CPUFREQ=y
 CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
 CONFIG_NET=y
 CONFIG_PACKET=y
diff --git a/arch/avr32/configs/atstk1003_defconfig b/arch/avr32/configs/atstk1003_defconfig
index 57a79df..c1cd726 100644
--- a/arch/avr32/configs/atstk1003_defconfig
+++ b/arch/avr32/configs/atstk1003_defconfig
@@ -26,7 +26,7 @@ CONFIG_CPU_FREQ=y
 # CONFIG_CPU_FREQ_STAT is not set
 CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
 CONFIG_CPU_FREQ_GOV_USERSPACE=y
-CONFIG_CPU_FREQ_AT32AP=y
+CONFIG_AVR32_AT32AP_CPUFREQ=y
 CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
 CONFIG_NET=y
 CONFIG_PACKET=y
diff --git a/arch/avr32/configs/atstk1004_defconfig b/arch/avr32/configs/atstk1004_defconfig
index 1a49bd8..754ae56 100644
--- a/arch/avr32/configs/atstk1004_defconfig
+++ b/arch/avr32/configs/atstk1004_defconfig
@@ -26,7 +26,7 @@ CONFIG_CPU_FREQ=y
 # CONFIG_CPU_FREQ_STAT is not set
 CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
 CONFIG_CPU_FREQ_GOV_USERSPACE=y
-CONFIG_CPU_FREQ_AT32AP=y
+CONFIG_AVR32_AT32AP_CPUFREQ=y
 CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
 CONFIG_NET=y
 CONFIG_PACKET=y
diff --git a/arch/avr32/configs/atstk1006_defconfig b/arch/avr32/configs/atstk1006_defconfig
index 206a1b6..58589d8 100644
--- a/arch/avr32/configs/atstk1006_defconfig
+++ b/arch/avr32/configs/atstk1006_defconfig
@@ -26,7 +26,7 @@ CONFIG_CPU_FREQ=y
 # CONFIG_CPU_FREQ_STAT is not set
 CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
 CONFIG_CPU_FREQ_GOV_USERSPACE=y
-CONFIG_CPU_FREQ_AT32AP=y
+CONFIG_AVR32_AT32AP_CPUFREQ=y
 CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
 CONFIG_NET=y
 CONFIG_PACKET=y
diff --git a/arch/avr32/configs/favr-32_defconfig b/arch/avr32/configs/favr-32_defconfig
index 0421498..57788a4 100644
--- a/arch/avr32/configs/favr-32_defconfig
+++ b/arch/avr32/configs/favr-32_defconfig
@@ -27,7 +27,7 @@ CONFIG_CPU_FREQ=y
 # CONFIG_CPU_FREQ_STAT is not set
 CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
 CONFIG_CPU_FREQ_GOV_USERSPACE=y
-CONFIG_CPU_FREQ_AT32AP=y
+CONFIG_AVR32_AT32AP_CPUFREQ=y
 CONFIG_NET=y
 CONFIG_PACKET=y
 CONFIG_UNIX=y
diff --git a/arch/avr32/configs/hammerhead_defconfig b/arch/avr32/configs/hammerhead_defconfig
index 82f24eb..ba7c31e 100644
--- a/arch/avr32/configs/hammerhead_defconfig
+++ b/arch/avr32/configs/hammerhead_defconfig
@@ -31,7 +31,7 @@ CONFIG_CPU_FREQ=y
 # CONFIG_CPU_FREQ_STAT is not set
 CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
 CONFIG_CPU_FREQ_GOV_USERSPACE=y
-CONFIG_CPU_FREQ_AT32AP=y
+CONFIG_AVR32_AT32AP_CPUFREQ=y
 CONFIG_NET=y
 CONFIG_PACKET=y
 CONFIG_UNIX=y
diff --git a/arch/avr32/configs/mimc200_defconfig b/arch/avr32/configs/mimc200_defconfig
index 1bee51f..0a8bfdc 100644
--- a/arch/avr32/configs/mimc200_defconfig
+++ b/arch/avr32/configs/mimc200_defconfig
@@ -24,7 +24,7 @@ CONFIG_CPU_FREQ=y
 # CONFIG_CPU_FREQ_STAT is not set
 CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
 CONFIG_CPU_FREQ_GOV_USERSPACE=y
-CONFIG_CPU_FREQ_AT32AP=y
+CONFIG_AVR32_AT32AP_CPUFREQ=y
 CONFIG_NET=y
 CONFIG_PACKET=y
 CONFIG_UNIX=y
diff --git a/arch/avr32/mach-at32ap/Makefile b/arch/avr32/mach-at32ap/Makefile
index 514c9a9..fc09ec4 100644
--- a/arch/avr32/mach-at32ap/Makefile
+++ b/arch/avr32/mach-at32ap/Makefile
@@ -1,7 +1,6 @@
 obj-y				+= pdc.o clock.o intc.o extint.o pio.o hsmc.o
 obj-y				+= hmatrix.o
 obj-$(CONFIG_CPU_AT32AP700X)	+= at32ap700x.o pm-at32ap700x.o
-obj-$(CONFIG_CPU_FREQ_AT32AP)	+= cpufreq.o
 obj-$(CONFIG_PM)		+= pm.o
 
 ifeq ($(CONFIG_PM_DEBUG),y)
diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index cbcb21e..d7ce6cc 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -205,6 +205,19 @@ depends on ARM
 source "drivers/cpufreq/Kconfig.arm"
 endmenu
 
+menu "AVR32 CPU frequency scaling drivers"
+depends on AVR32
+
+config AVR32_AT32AP_CPUFREQ
+	bool "CPU frequency driver for AT32AP"
+	depends on PLATFORM_AT32AP
+	default n
+	help
+	  This enables the CPU frequency driver for AT32AP processors.
+	  If in doubt, say N.
+
+endmenu
+
 menu "PowerPC CPU frequency scaling drivers"
 depends on PPC32 || PPC64
 source "drivers/cpufreq/Kconfig.powerpc"
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index c113af2..7573c22 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -75,3 +75,7 @@ obj-$(CONFIG_ARCH_TEGRA)		+= tegra-cpufreq.o
 ##################################################################################
 # PowerPC platform drivers
 obj-$(CONFIG_CPU_FREQ_MAPLE)		+= maple-cpufreq.o
+
+##################################################################################
+# Other platform drivers
+obj-$(CONFIG_AVR32_AT32AP_CPUFREQ)	+= at32ap-cpufreq.o
diff --git a/arch/avr32/mach-at32ap/cpufreq.c b/drivers/cpufreq/at32ap-cpufreq.c
similarity index 100%
rename from arch/avr32/mach-at32ap/cpufreq.c
rename to drivers/cpufreq/at32ap-cpufreq.c
-- 
1.7.12.rc2.18.g61b472e

