Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbaGIL6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:58:21 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:47013 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaGIL6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:58:19 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH] pinctrl: msm: move all qualcomm drivers to subdir
Date: Wed,  9 Jul 2014 13:57:32 +0200
Message-Id: <1404907052-14454-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have four Qualcomm-related pin control drivers, and now there
are drivers coming in for the PMICs on these systems, so let's
create a qcom subdirectory to hold all the Qualcomm stuff.

Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Ivan T. Ivanov <iivanov@mm-sol.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/Kconfig                      | 40 +---------------------------
 drivers/pinctrl/Makefile                     |  5 ----
 drivers/pinctrl/{ => qcom}/pinctrl-apq8064.c |  0
 drivers/pinctrl/{ => qcom}/pinctrl-ipq8064.c |  0
 drivers/pinctrl/{ => qcom}/pinctrl-msm.c     |  0
 drivers/pinctrl/{ => qcom}/pinctrl-msm8960.c |  0
 drivers/pinctrl/{ => qcom}/pinctrl-msm8x74.c |  0
 7 files changed, 1 insertion(+), 44 deletions(-)
 rename drivers/pinctrl/{ => qcom}/pinctrl-apq8064.c (100%)
 rename drivers/pinctrl/{ => qcom}/pinctrl-ipq8064.c (100%)
 rename drivers/pinctrl/{ => qcom}/pinctrl-msm.c (100%)
 rename drivers/pinctrl/{ => qcom}/pinctrl-msm8960.c (100%)
 rename drivers/pinctrl/{ => qcom}/pinctrl-msm8x74.c (100%)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index c0f49fb3276c..e2c7e09783fa 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -233,45 +233,6 @@ config PINCTRL_IMX28
 	bool
 	select PINCTRL_MXS
 
-config PINCTRL_MSM
-	bool
-	select PINMUX
-	select PINCONF
-	select GENERIC_PINCONF
-	select GPIOLIB_IRQCHIP
-
-config PINCTRL_APQ8064
-	tristate "Qualcomm APQ8064 pin controller driver"
-	depends on GPIOLIB && OF
-	select PINCTRL_MSM
-	help
-	  This is the pinctrl, pinmux, pinconf and gpiolib driver for the
-	  Qualcomm TLMM block found in the Qualcomm APQ8064 platform.
-
-config PINCTRL_IPQ8064
-	tristate "Qualcomm IPQ8064 pin controller driver"
-	depends on GPIOLIB && OF
-	select PINCTRL_MSM
-	help
-	  This is the pinctrl, pinmux, pinconf and gpiolib driver for the
-	  Qualcomm TLMM block found in the Qualcomm IPQ8064 platform.
-
-config PINCTRL_MSM8960
-	tristate "Qualcomm 8960 pin controller driver"
-	depends on GPIOLIB && OF
-	select PINCTRL_MSM
-	help
-	  This is the pinctrl, pinmux, pinconf and gpiolib driver for the
-	  Qualcomm TLMM block found in the Qualcomm 8960 platform.
-
-config PINCTRL_MSM8X74
-	tristate "Qualcomm 8x74 pin controller driver"
-	depends on GPIOLIB && OF && (ARCH_QCOM || COMPILE_TEST)
-	select PINCTRL_MSM
-	help
-	  This is the pinctrl, pinmux, pinconf and gpiolib driver for the
-	  Qualcomm TLMM block found in the Qualcomm 8974 platform.
-
 config PINCTRL_NOMADIK
 	bool "Nomadik pin controller driver"
 	depends on ARCH_U8500 || ARCH_NOMADIK
@@ -410,6 +371,7 @@ config PINCTRL_S3C64XX
 
 source "drivers/pinctrl/berlin/Kconfig"
 source "drivers/pinctrl/mvebu/Kconfig"
+source "drivers/pinctrl/qcom/Kconfig"
 source "drivers/pinctrl/sh-pfc/Kconfig"
 source "drivers/pinctrl/spear/Kconfig"
 source "drivers/pinctrl/sunxi/Kconfig"
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index 80bced77446a..a7b8a9e62a14 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -39,11 +39,6 @@ obj-$(CONFIG_PINCTRL_MXS)	+= pinctrl-mxs.o
 obj-$(CONFIG_PINCTRL_IMX23)	+= pinctrl-imx23.o
 obj-$(CONFIG_PINCTRL_IMX25)	+= pinctrl-imx25.o
 obj-$(CONFIG_PINCTRL_IMX28)	+= pinctrl-imx28.o
-obj-$(CONFIG_PINCTRL_MSM)	+= pinctrl-msm.o
-obj-$(CONFIG_PINCTRL_APQ8064)	+= pinctrl-apq8064.o
-obj-$(CONFIG_PINCTRL_IPQ8064)	+= pinctrl-ipq8064.o
-obj-$(CONFIG_PINCTRL_MSM8960)	+= pinctrl-msm8960.o
-obj-$(CONFIG_PINCTRL_MSM8X74)	+= pinctrl-msm8x74.o
 obj-$(CONFIG_PINCTRL_NOMADIK)	+= pinctrl-nomadik.o
 obj-$(CONFIG_PINCTRL_STN8815)	+= pinctrl-nomadik-stn8815.o
 obj-$(CONFIG_PINCTRL_DB8500)	+= pinctrl-nomadik-db8500.o
diff --git a/drivers/pinctrl/pinctrl-apq8064.c b/drivers/pinctrl/qcom/pinctrl-apq8064.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-apq8064.c
rename to drivers/pinctrl/qcom/pinctrl-apq8064.c
diff --git a/drivers/pinctrl/pinctrl-ipq8064.c b/drivers/pinctrl/qcom/pinctrl-ipq8064.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-ipq8064.c
rename to drivers/pinctrl/qcom/pinctrl-ipq8064.c
diff --git a/drivers/pinctrl/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-msm.c
rename to drivers/pinctrl/qcom/pinctrl-msm.c
diff --git a/drivers/pinctrl/pinctrl-msm8960.c b/drivers/pinctrl/qcom/pinctrl-msm8960.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-msm8960.c
rename to drivers/pinctrl/qcom/pinctrl-msm8960.c
diff --git a/drivers/pinctrl/pinctrl-msm8x74.c b/drivers/pinctrl/qcom/pinctrl-msm8x74.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-msm8x74.c
rename to drivers/pinctrl/qcom/pinctrl-msm8x74.c
-- 
1.9.3

