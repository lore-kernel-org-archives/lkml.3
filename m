Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbaBUAQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:16:18 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:7878 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186AbaBUAQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 19:16:14 -0500
X-IronPort-AV: E=Sophos;i="4.97,515,1389772800"; 
   d="scan'208";a="15974529"
From: Markus Mayer <markus.mayer@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>
CC: ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: bcm2835: Move to mach-bcm directory
Date: Thu, 20 Feb 2014 16:16:11 -0800
Message-ID: <1392941771-15774-1-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the bcm2835 board file into the mach-bcm directory. This allows us
to get rid of the mach-bcm2835 directory with the associated Kconfig
and Makefile.

Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
---
 MAINTAINERS                                        |    2 +-
 arch/arm/Kconfig                                   |    2 --
 arch/arm/Makefile                                  |    1 -
 arch/arm/mach-bcm/Kconfig                          |   16 ++++++++++++++++
 arch/arm/mach-bcm/Makefile                         |    2 ++
 .../bcm2835.c => mach-bcm/board_bcm2835.c}         |    0
 arch/arm/mach-bcm2835/Kconfig                      |   15 ---------------
 arch/arm/mach-bcm2835/Makefile                     |    1 -
 8 files changed, 19 insertions(+), 20 deletions(-)
 rename arch/arm/{mach-bcm2835/bcm2835.c => mach-bcm/board_bcm2835.c} (100%)
 delete mode 100644 arch/arm/mach-bcm2835/Kconfig
 delete mode 100644 arch/arm/mach-bcm2835/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index fb08dce..6e94e26 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1875,7 +1875,7 @@ M:	Stephen Warren <swarren@wwwdotorg.org>
 L:	linux-rpi-kernel@lists.infradead.org (moderated for non-subscribers)
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-rpi.git
 S:	Maintained
-F:	arch/arm/mach-bcm2835/
+F:	arch/arm/mach-bcm/board_bcm2835.c
 F:	arch/arm/boot/dts/bcm2835*
 F:	arch/arm/configs/bcm2835_defconfig
 F:	drivers/*/*bcm2835*
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e254198..bde2237 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -936,8 +936,6 @@ source "arch/arm/mach-at91/Kconfig"
 
 source "arch/arm/mach-bcm/Kconfig"
 
-source "arch/arm/mach-bcm2835/Kconfig"
-
 source "arch/arm/mach-berlin/Kconfig"
 
 source "arch/arm/mach-clps711x/Kconfig"
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 08a9ef5..7743fb9 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -143,7 +143,6 @@ textofs-$(CONFIG_ARCH_MSM8960) := 0x00208000
 # by CONFIG_* macro name.
 machine-$(CONFIG_ARCH_AT91)		+= at91
 machine-$(CONFIG_ARCH_BCM)		+= bcm
-machine-$(CONFIG_ARCH_BCM2835)		+= bcm2835
 machine-$(CONFIG_ARCH_BERLIN)		+= berlin
 machine-$(CONFIG_ARCH_CLPS711X)		+= clps711x
 machine-$(CONFIG_ARCH_CNS3XXX)		+= cns3xxx
diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
index b1aa6a9..4e466e9 100644
--- a/arch/arm/mach-bcm/Kconfig
+++ b/arch/arm/mach-bcm/Kconfig
@@ -32,6 +32,22 @@ config ARCH_BCM_MOBILE
 	  BCM11130, BCM11140, BCM11351, BCM28145 and
 	  BCM28155 variants.
 
+config ARCH_BCM2835
+	bool "Broadcom BCM2835 family" if ARCH_MULTI_V6
+	select ARCH_REQUIRE_GPIOLIB
+	select ARM_AMBA
+	select ARM_ERRATA_411920
+	select ARM_TIMER_SP804
+	select CLKDEV_LOOKUP
+	select CLKSRC_OF
+	select CPU_V6
+	select GENERIC_CLOCKEVENTS
+	select PINCTRL
+	select PINCTRL_BCM2835
+	help
+	  This enables support for the Broadcom BCM2835 SoC. This SoC is
+	  used in the Raspberry Pi and Roku 2 devices.
+
 endmenu
 
 endif
diff --git a/arch/arm/mach-bcm/Makefile b/arch/arm/mach-bcm/Makefile
index c2ccd5a..0ad2938 100644
--- a/arch/arm/mach-bcm/Makefile
+++ b/arch/arm/mach-bcm/Makefile
@@ -11,5 +11,7 @@
 # GNU General Public License for more details.
 
 obj-$(CONFIG_ARCH_BCM_MOBILE)	:= board_bcm281xx.o bcm_kona_smc.o bcm_kona_smc_asm.o kona.o
+obj-$(CONFIG_ARCH_BCM2835)	+= board_bcm2835.o
+
 plus_sec := $(call as-instr,.arch_extension sec,+sec)
 AFLAGS_bcm_kona_smc_asm.o	:=-Wa,-march=armv7-a$(plus_sec)
diff --git a/arch/arm/mach-bcm2835/bcm2835.c b/arch/arm/mach-bcm/board_bcm2835.c
similarity index 100%
rename from arch/arm/mach-bcm2835/bcm2835.c
rename to arch/arm/mach-bcm/board_bcm2835.c
diff --git a/arch/arm/mach-bcm2835/Kconfig b/arch/arm/mach-bcm2835/Kconfig
deleted file mode 100644
index d1f9612..0000000
--- a/arch/arm/mach-bcm2835/Kconfig
+++ /dev/null
@@ -1,15 +0,0 @@
-config ARCH_BCM2835
-	bool "Broadcom BCM2835 family" if ARCH_MULTI_V6
-	select ARCH_REQUIRE_GPIOLIB
-	select ARM_AMBA
-	select ARM_ERRATA_411920
-	select ARM_TIMER_SP804
-	select CLKDEV_LOOKUP
-	select CLKSRC_OF
-	select CPU_V6
-	select GENERIC_CLOCKEVENTS
-	select PINCTRL
-	select PINCTRL_BCM2835
-	help
-	  This enables support for the Broadcom BCM2835 SoC. This SoC is
-	  used in the Raspberry Pi and Roku 2 devices.
diff --git a/arch/arm/mach-bcm2835/Makefile b/arch/arm/mach-bcm2835/Makefile
deleted file mode 100644
index 4c3892f..0000000
--- a/arch/arm/mach-bcm2835/Makefile
+++ /dev/null
@@ -1 +0,0 @@
-obj-y += bcm2835.o
-- 
1.7.9.5

