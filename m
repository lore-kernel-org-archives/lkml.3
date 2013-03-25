Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab3CYKMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:12:17 -0400
Received: from service87.mimecast.com ([91.220.42.44]:58982 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893Ab3CYKMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:12:12 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: arvind.chauhan@arm.com, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd.bergmann@linaro.org, linux@arm.linux.org.uk,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 9/9] cpufreq: sa11x0: move cpufreq driver to drivers/cpufreq
Date: Mon, 25 Mar 2013 15:41:40 +0530
Message-Id: <87d2cd71a29fb826efe15a3d97cc3444031387c0.1364205812.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1364205812.git.viresh.kumar@linaro.org>
References: <cover.1364205812.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1364205812.git.viresh.kumar@linaro.org>
References: <cover.1364205812.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 25 Mar 2013 10:12:08.0766 (UTC) FILETIME=[35822DE0:01CE2941]
X-MC-Unique: 113032510121017201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r2PACN1G026792

This patch moves cpufreq driver of ARM based sa11x0 platform to drivers/cpufreq.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/Kconfig                                   |  8 -------
 arch/arm/mach-sa1100/Kconfig                       | 26 +++++++++++-----------
 arch/arm/mach-sa1100/Makefile                      |  3 ---
 arch/arm/mach-sa1100/include/mach/generic.h        |  1 +
 drivers/cpufreq/Kconfig.arm                        |  6 +++++
 drivers/cpufreq/Makefile                           |  2 ++
 .../cpufreq/sa1100-cpufreq.c                       |  3 +--
 .../cpufreq/sa1110-cpufreq.c                       |  3 +--
 8 files changed, 24 insertions(+), 28 deletions(-)
 create mode 100644 arch/arm/mach-sa1100/include/mach/generic.h
 rename arch/arm/mach-sa1100/cpu-sa1100.c => drivers/cpufreq/sa1100-cpufreq.c (99%)
 rename arch/arm/mach-sa1100/cpu-sa1110.c => drivers/cpufreq/sa1110-cpufreq.c (99%)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index cdbe688..8d73413 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -2153,15 +2153,7 @@ endmenu
 menu "CPU Power Management"
 
 if ARCH_HAS_CPUFREQ
-
 source "drivers/cpufreq/Kconfig"
-
-config CPU_FREQ_SA1100
-	bool
-
-config CPU_FREQ_SA1110
-	bool
-
 endif
 
 source "drivers/cpuidle/Kconfig"
diff --git a/arch/arm/mach-sa1100/Kconfig b/arch/arm/mach-sa1100/Kconfig
index ca14dbd..04f9784 100644
--- a/arch/arm/mach-sa1100/Kconfig
+++ b/arch/arm/mach-sa1100/Kconfig
@@ -4,7 +4,7 @@ menu "SA11x0 Implementations"
 
 config SA1100_ASSABET
 	bool "Assabet"
-	select CPU_FREQ_SA1110
+	select ARM_SA1110_CPUFREQ
 	help
 	  Say Y here if you are using the Intel(R) StrongARM(R) SA-1110
 	  Microprocessor Development Board (also known as the Assabet).
@@ -20,7 +20,7 @@ config ASSABET_NEPONSET
 
 config SA1100_CERF
 	bool "CerfBoard"
-	select CPU_FREQ_SA1110
+	select ARM_SA1110_CPUFREQ
 	help
 	  The Intrinsyc CerfBoard is based on the StrongARM 1110 (Discontinued).
 	  More information is available at:
@@ -47,7 +47,7 @@ endchoice
 
 config SA1100_COLLIE
 	bool "Sharp Zaurus SL5500"
-	# FIXME: select CPU_FREQ_SA11x0
+	# FIXME: select ARM_SA11x0_CPUFREQ
 	select SHARP_LOCOMO
 	select SHARP_PARAM
 	select SHARP_SCOOP
@@ -56,7 +56,7 @@ config SA1100_COLLIE
 
 config SA1100_H3100
 	bool "Compaq iPAQ H3100"
-	select CPU_FREQ_SA1110
+	select ARM_SA1110_CPUFREQ
 	select HTC_EGPIO
 	help
 	  Say Y here if you intend to run this kernel on the Compaq iPAQ
@@ -67,7 +67,7 @@ config SA1100_H3100
 
 config SA1100_H3600
 	bool "Compaq iPAQ H3600/H3700"
-	select CPU_FREQ_SA1110
+	select ARM_SA1110_CPUFREQ
 	select HTC_EGPIO
 	help
 	  Say Y here if you intend to run this kernel on the Compaq iPAQ
@@ -78,7 +78,7 @@ config SA1100_H3600
 
 config SA1100_BADGE4
 	bool "HP Labs BadgePAD 4"
-	select CPU_FREQ_SA1100
+	select ARM_SA1100_CPUFREQ
 	select SA1111
 	help
 	  Say Y here if you want to build a kernel for the HP Laboratories
@@ -86,7 +86,7 @@ config SA1100_BADGE4
 
 config SA1100_JORNADA720
 	bool "HP Jornada 720"
-	# FIXME: select CPU_FREQ_SA11x0
+	# FIXME: select ARM_SA11x0_CPUFREQ
 	select SA1111
 	help
 	  Say Y here if you want to build a kernel for the HP Jornada 720
@@ -105,14 +105,14 @@ config SA1100_JORNADA720_SSP
 
 config SA1100_HACKKIT
 	bool "HackKit Core CPU Board"
-	select CPU_FREQ_SA1100
+	select ARM_SA1100_CPUFREQ
 	help
 	  Say Y here to support the HackKit Core CPU Board
 	  <http://hackkit.eletztrick.de>;
 
 config SA1100_LART
 	bool "LART"
-	select CPU_FREQ_SA1100
+	select ARM_SA1100_CPUFREQ
 	help
 	  Say Y here if you are using the Linux Advanced Radio Terminal
 	  (also known as the LART).  See <http://www.lartmaker.nl/> for
@@ -120,7 +120,7 @@ config SA1100_LART
 
 config SA1100_NANOENGINE
 	bool "nanoEngine"
-	select CPU_FREQ_SA1110
+	select ARM_SA1110_CPUFREQ
 	select PCI
 	select PCI_NANOENGINE
 	help
@@ -130,7 +130,7 @@ config SA1100_NANOENGINE
 
 config SA1100_PLEB
 	bool "PLEB"
-	select CPU_FREQ_SA1100
+	select ARM_SA1100_CPUFREQ
 	help
 	  Say Y here if you are using version 1 of the Portable Linux
 	  Embedded Board (also known as PLEB).
@@ -139,7 +139,7 @@ config SA1100_PLEB
 
 config SA1100_SHANNON
 	bool "Shannon"
-	select CPU_FREQ_SA1100
+	select ARM_SA1100_CPUFREQ
 	help
 	  The Shannon (also known as a Tuxscreen, and also as a IS2630) was a
 	  limited edition webphone produced by Philips. The Shannon is a SA1100
@@ -148,7 +148,7 @@ config SA1100_SHANNON
 
 config SA1100_SIMPAD
 	bool "Simpad"
-	select CPU_FREQ_SA1110
+	select ARM_SA1110_CPUFREQ
 	help
 	  The SIEMENS webpad SIMpad is based on the StrongARM 1110. There
 	  are two different versions CL4 and SL4. CL4 has 32MB RAM and 16MB
diff --git a/arch/arm/mach-sa1100/Makefile b/arch/arm/mach-sa1100/Makefile
index 1aed9e7..2732eef 100644
--- a/arch/arm/mach-sa1100/Makefile
+++ b/arch/arm/mach-sa1100/Makefile
@@ -8,9 +8,6 @@ obj-m :=
 obj-n :=
 obj-  :=
 
-obj-$(CONFIG_CPU_FREQ_SA1100)		+= cpu-sa1100.o
-obj-$(CONFIG_CPU_FREQ_SA1110)		+= cpu-sa1110.o
-
 # Specific board support
 obj-$(CONFIG_SA1100_ASSABET)		+= assabet.o
 obj-$(CONFIG_ASSABET_NEPONSET)		+= neponset.o
diff --git a/arch/arm/mach-sa1100/include/mach/generic.h b/arch/arm/mach-sa1100/include/mach/generic.h
new file mode 100644
index 0000000..665542e
--- /dev/null
+++ b/arch/arm/mach-sa1100/include/mach/generic.h
@@ -0,0 +1 @@
+#include "../../generic.h"
diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 3021e35..cdaadcb 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -180,6 +180,12 @@ config ARM_S5PV210_CPUFREQ
 
 	  If in doubt, say N.
 
+config ARM_SA1100_CPUFREQ
+	bool
+
+config ARM_SA1110_CPUFREQ
+	bool
+
 config ARM_SPEAR_CPUFREQ
 	bool "SPEAr CPUFreq support"
 	depends on PLAT_SPEAR
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 3886eda..c113af2 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -67,6 +67,8 @@ obj-$(CONFIG_ARM_S3C2416_CPUFREQ)	+= s3c2416-cpufreq.o
 obj-$(CONFIG_ARM_S3C2440_CPUFREQ)	+= s3c2440-cpufreq.o
 obj-$(CONFIG_ARM_S3C64XX_CPUFREQ)	+= s3c64xx-cpufreq.o
 obj-$(CONFIG_ARM_S5PV210_CPUFREQ)	+= s5pv210-cpufreq.o
+obj-$(CONFIG_ARM_SA1100_CPUFREQ)	+= sa1100-cpufreq.o
+obj-$(CONFIG_ARM_SA1110_CPUFREQ)	+= sa1110-cpufreq.o
 obj-$(CONFIG_ARM_SPEAR_CPUFREQ)		+= spear-cpufreq.o
 obj-$(CONFIG_ARCH_TEGRA)		+= tegra-cpufreq.o
 
diff --git a/arch/arm/mach-sa1100/cpu-sa1100.c b/drivers/cpufreq/sa1100-cpufreq.c
similarity index 99%
rename from arch/arm/mach-sa1100/cpu-sa1100.c
rename to drivers/cpufreq/sa1100-cpufreq.c
index 3268761..cff18e8 100644
--- a/arch/arm/mach-sa1100/cpu-sa1100.c
+++ b/drivers/cpufreq/sa1100-cpufreq.c
@@ -91,10 +91,9 @@
 
 #include <asm/cputype.h>
 
+#include <mach/generic.h>
 #include <mach/hardware.h>
 
-#include "generic.h"
-
 struct sa1100_dram_regs {
 	int speed;
 	u32 mdcnfg;
diff --git a/arch/arm/mach-sa1100/cpu-sa1110.c b/drivers/cpufreq/sa1110-cpufreq.c
similarity index 99%
rename from arch/arm/mach-sa1100/cpu-sa1110.c
rename to drivers/cpufreq/sa1110-cpufreq.c
index 38a7733..39c90b6 100644
--- a/arch/arm/mach-sa1100/cpu-sa1110.c
+++ b/drivers/cpufreq/sa1110-cpufreq.c
@@ -27,10 +27,9 @@
 #include <asm/cputype.h>
 #include <asm/mach-types.h>
 
+#include <mach/generic.h>
 #include <mach/hardware.h>
 
-#include "generic.h"
-
 #undef DEBUG
 
 struct sdram_params {
-- 
1.7.12.rc2.18.g61b472e


