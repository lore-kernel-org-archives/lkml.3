Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbbAIJl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 04:41:57 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:62672 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbbAIJly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 04:41:54 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: pass -DDEBUG in subdirs
Date: Fri,  9 Jan 2015 10:41:46 +0100
Message-Id: <1420796506-10402-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When drivers are compiled in subdirectories the -DDEBUG flag need
to be passed in the individual Makefiles.

Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/berlin/Makefile    | 1 +
 drivers/pinctrl/freescale/Makefile | 1 +
 drivers/pinctrl/mvebu/Makefile     | 1 +
 drivers/pinctrl/nomadik/Makefile   | 1 +
 drivers/pinctrl/qcom/Makefile      | 1 +
 drivers/pinctrl/samsung/Makefile   | 2 +-
 drivers/pinctrl/sh-pfc/Makefile    | 1 +
 drivers/pinctrl/sirf/Makefile      | 2 +-
 drivers/pinctrl/spear/Makefile     | 2 +-
 drivers/pinctrl/sunxi/Makefile     | 1 +
 drivers/pinctrl/vt8500/Makefile    | 2 +-
 11 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/berlin/Makefile b/drivers/pinctrl/berlin/Makefile
index deb0c6baf316..219179d7a4df 100644
--- a/drivers/pinctrl/berlin/Makefile
+++ b/drivers/pinctrl/berlin/Makefile
@@ -1,3 +1,4 @@
+ccflags-$(CONFIG_DEBUG_PINCTRL)		+= -DDEBUG
 obj-$(CONFIG_PINCTRL_BERLIN)		+= berlin.o
 obj-$(CONFIG_PINCTRL_BERLIN_BG2)	+= berlin-bg2.o
 obj-$(CONFIG_PINCTRL_BERLIN_BG2CD)	+= berlin-bg2cd.o
diff --git a/drivers/pinctrl/freescale/Makefile b/drivers/pinctrl/freescale/Makefile
index bba73c22f043..73f6e07357e1 100644
--- a/drivers/pinctrl/freescale/Makefile
+++ b/drivers/pinctrl/freescale/Makefile
@@ -1,4 +1,5 @@
 # Freescale pin control drivers
+ccflags-$(CONFIG_DEBUG_PINCTRL)	+= -DDEBUG
 obj-$(CONFIG_PINCTRL_IMX)	+= pinctrl-imx.o
 obj-$(CONFIG_PINCTRL_IMX1_CORE)	+= pinctrl-imx1-core.o
 obj-$(CONFIG_PINCTRL_IMX1)	+= pinctrl-imx1.o
diff --git a/drivers/pinctrl/mvebu/Makefile b/drivers/pinctrl/mvebu/Makefile
index a0818e96374b..0ffeb6ec5c0a 100644
--- a/drivers/pinctrl/mvebu/Makefile
+++ b/drivers/pinctrl/mvebu/Makefile
@@ -1,3 +1,4 @@
+ccflags-$(CONFIG_DEBUG_PINCTRL)	+= -DDEBUG
 obj-$(CONFIG_PINCTRL_MVEBU)	+= pinctrl-mvebu.o
 obj-$(CONFIG_PINCTRL_DOVE)	+= pinctrl-dove.o
 obj-$(CONFIG_PINCTRL_KIRKWOOD)	+= pinctrl-kirkwood.o
diff --git a/drivers/pinctrl/nomadik/Makefile b/drivers/pinctrl/nomadik/Makefile
index 30b27f18cd52..459d20888462 100644
--- a/drivers/pinctrl/nomadik/Makefile
+++ b/drivers/pinctrl/nomadik/Makefile
@@ -1,4 +1,5 @@
 # Nomadik family pin control drivers
+ccflags-$(CONFIG_DEBUG_PINCTRL)	+= -DDEBUG
 obj-$(CONFIG_PINCTRL_ABX500)	+= pinctrl-abx500.o
 obj-$(CONFIG_PINCTRL_AB8500)	+= pinctrl-ab8500.o
 obj-$(CONFIG_PINCTRL_AB8540)	+= pinctrl-ab8540.o
diff --git a/drivers/pinctrl/qcom/Makefile b/drivers/pinctrl/qcom/Makefile
index bfd79af5f982..5d81cdd981e0 100644
--- a/drivers/pinctrl/qcom/Makefile
+++ b/drivers/pinctrl/qcom/Makefile
@@ -1,4 +1,5 @@
 # Qualcomm pin control drivers
+ccflags-$(CONFIG_DEBUG_PINCTRL)	+= -DDEBUG
 obj-$(CONFIG_PINCTRL_MSM)	+= pinctrl-msm.o
 obj-$(CONFIG_PINCTRL_APQ8064)	+= pinctrl-apq8064.o
 obj-$(CONFIG_PINCTRL_APQ8084)	+= pinctrl-apq8084.o
diff --git a/drivers/pinctrl/samsung/Makefile b/drivers/pinctrl/samsung/Makefile
index 70160c059edd..156d9aff06f5 100644
--- a/drivers/pinctrl/samsung/Makefile
+++ b/drivers/pinctrl/samsung/Makefile
@@ -1,5 +1,5 @@
 # Samsung pin control drivers
-
+ccflags-$(CONFIG_DEBUG_PINCTRL)	+= -DDEBUG
 obj-$(CONFIG_PINCTRL_SAMSUNG)	+= pinctrl-samsung.o
 obj-$(CONFIG_PINCTRL_EXYNOS)	+= pinctrl-exynos.o
 obj-$(CONFIG_PINCTRL_EXYNOS5440)	+= pinctrl-exynos5440.o
diff --git a/drivers/pinctrl/sh-pfc/Makefile b/drivers/pinctrl/sh-pfc/Makefile
index ad8f4cf9faaa..55d7ad4ecae7 100644
--- a/drivers/pinctrl/sh-pfc/Makefile
+++ b/drivers/pinctrl/sh-pfc/Makefile
@@ -1,3 +1,4 @@
+ccflags-$(CONFIG_DEBUG_PINCTRL)	+= -DDEBUG
 sh-pfc-objs			= core.o pinctrl.o
 ifeq ($(CONFIG_GPIO_SH_PFC),y)
 sh-pfc-objs			+= gpio.o
diff --git a/drivers/pinctrl/sirf/Makefile b/drivers/pinctrl/sirf/Makefile
index 3ffc475ce40c..e761b1fd9fa9 100644
--- a/drivers/pinctrl/sirf/Makefile
+++ b/drivers/pinctrl/sirf/Makefile
@@ -1,5 +1,5 @@
 # CSR SiRFsoc pinmux support
-
+ccflags-$(CONFIG_DEBUG_PINCTRL)	+= -DDEBUG
 obj-y	+= pinctrl-sirf.o
 obj-y	+= pinctrl-prima2.o
 obj-y	+= pinctrl-atlas6.o
diff --git a/drivers/pinctrl/spear/Makefile b/drivers/pinctrl/spear/Makefile
index 0e400ebeb8ff..9ef35de6a2a0 100644
--- a/drivers/pinctrl/spear/Makefile
+++ b/drivers/pinctrl/spear/Makefile
@@ -1,5 +1,5 @@
 # SPEAr pinmux support
-
+ccflags-$(CONFIG_DEBUG_PINCTRL)		+= -DDEBUG
 obj-$(CONFIG_PINCTRL_SPEAR_PLGPIO)	+= pinctrl-plgpio.o
 obj-$(CONFIG_PINCTRL_SPEAR)	+= pinctrl-spear.o
 obj-$(CONFIG_PINCTRL_SPEAR3XX)	+= pinctrl-spear3xx.o
diff --git a/drivers/pinctrl/sunxi/Makefile b/drivers/pinctrl/sunxi/Makefile
index c7d92e4673b5..b440b24ac9ac 100644
--- a/drivers/pinctrl/sunxi/Makefile
+++ b/drivers/pinctrl/sunxi/Makefile
@@ -1,4 +1,5 @@
 # Core
+ccflags-$(CONFIG_DEBUG_PINCTRL)		+= -DDEBUG
 obj-$(CONFIG_PINCTRL_SUNXI_COMMON)	+= pinctrl-sunxi.o
 
 # SoC Drivers
diff --git a/drivers/pinctrl/vt8500/Makefile b/drivers/pinctrl/vt8500/Makefile
index 24ec45dd0d80..55a140aa7803 100644
--- a/drivers/pinctrl/vt8500/Makefile
+++ b/drivers/pinctrl/vt8500/Makefile
@@ -1,5 +1,5 @@
 # VIA/Wondermedia pinctrl support
-
+ccflags-$(CONFIG_DEBUG_PINCTRL)	+= -DDEBUG
 obj-$(CONFIG_PINCTRL_WMT)	+= pinctrl-wmt.o
 obj-$(CONFIG_PINCTRL_VT8500)	+= pinctrl-vt8500.o
 obj-$(CONFIG_PINCTRL_WM8505)	+= pinctrl-wm8505.o
-- 
1.9.3

