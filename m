Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbaICMOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:14:07 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:36127 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144AbaICMOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:14:03 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Alexander Shiyan <shc_work@mail.ru>, Shawn Guo <shawn.guo@linaro.org>,
        Anson Huang <b20788@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Denis Carikli <denis@eukrea.com>, Markus Pargmann <mpa@pengutronix.de>,
        Greg Ungerer <gerg@uclinux.org>, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH v2] pinctrl: imx/mxs: move freescale drivers to subdir
Date: Wed,  3 Sep 2014 14:13:56 +0200
Message-Id: <1409746436-23094-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves all the Freescale-related drivers (i.MX and MXS) to
its own subdirectory to clear the view.

Cc: Alexander Shiyan <shc_work@mail.ru>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Anson Huang <b20788@freescale.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Denis Carikli <denis@eukrea.com>
Cc: Markus Pargmann <mpa@pengutronix.de>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Add the missing Kconfig and Makefiles from the new subdir.
  Sloppy me. (Thanks Markus.)
---
 drivers/pinctrl/Kconfig                            | 110 +--------------------
 drivers/pinctrl/Makefile                           |  19 +---
 drivers/pinctrl/freescale/Kconfig                  | 108 ++++++++++++++++++++
 drivers/pinctrl/freescale/Makefile                 |  19 ++++
 drivers/pinctrl/{ => freescale}/pinctrl-imx.c      |   2 +-
 drivers/pinctrl/{ => freescale}/pinctrl-imx.h      |   0
 .../pinctrl/{ => freescale}/pinctrl-imx1-core.c    |   2 +-
 drivers/pinctrl/{ => freescale}/pinctrl-imx1.c     |   0
 drivers/pinctrl/{ => freescale}/pinctrl-imx1.h     |   0
 drivers/pinctrl/{ => freescale}/pinctrl-imx21.c    |   0
 drivers/pinctrl/{ => freescale}/pinctrl-imx23.c    |   0
 drivers/pinctrl/{ => freescale}/pinctrl-imx25.c    |   0
 drivers/pinctrl/{ => freescale}/pinctrl-imx27.c    |   0
 drivers/pinctrl/{ => freescale}/pinctrl-imx28.c    |   0
 drivers/pinctrl/{ => freescale}/pinctrl-imx35.c    |   0
 drivers/pinctrl/{ => freescale}/pinctrl-imx50.c    |   0
 drivers/pinctrl/{ => freescale}/pinctrl-imx51.c    |   0
 drivers/pinctrl/{ => freescale}/pinctrl-imx53.c    |   0
 drivers/pinctrl/{ => freescale}/pinctrl-imx6dl.c   |   0
 drivers/pinctrl/{ => freescale}/pinctrl-imx6q.c    |   0
 drivers/pinctrl/{ => freescale}/pinctrl-imx6sl.c   |   0
 drivers/pinctrl/{ => freescale}/pinctrl-imx6sx.c   |   0
 drivers/pinctrl/{ => freescale}/pinctrl-mxs.c      |   2 +-
 drivers/pinctrl/{ => freescale}/pinctrl-mxs.h      |   0
 drivers/pinctrl/{ => freescale}/pinctrl-vf610.c    |   0
 25 files changed, 132 insertions(+), 130 deletions(-)
 create mode 100644 drivers/pinctrl/freescale/Kconfig
 create mode 100644 drivers/pinctrl/freescale/Makefile
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx.c (99%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx.h (100%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx1-core.c (99%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx1.c (100%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx1.h (100%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx21.c (100%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx23.c (100%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx25.c (100%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx27.c (100%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx28.c (100%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx35.c (100%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx50.c (100%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx51.c (100%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx53.c (100%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx6dl.c (100%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx6q.c (100%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx6sl.c (100%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-imx6sx.c (100%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-mxs.c (99%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-mxs.h (100%)
 rename drivers/pinctrl/{ => freescale}/pinctrl-vf610.c (100%)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index e1c5a87c80cd..64d06b52f98a 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -97,102 +97,6 @@ config PINCTRL_BCM281XX
 	  BCM28145, and BCM28155 SoCs.  This driver requires the pinctrl
 	  framework.  GPIO is provided by a separate GPIO driver.
 
-config PINCTRL_IMX
-	bool
-	select PINMUX
-	select PINCONF
-
-config PINCTRL_IMX1_CORE
-	bool
-	select PINMUX
-	select PINCONF
-
-config PINCTRL_IMX1
-	bool "IMX1 pinctrl driver"
-	depends on SOC_IMX1
-	select PINCTRL_IMX1_CORE
-	help
-	  Say Y here to enable the imx1 pinctrl driver
-
-config PINCTRL_IMX21
-	bool "i.MX21 pinctrl driver"
-	depends on SOC_IMX21
-	select PINCTRL_IMX1_CORE
-	help
-	  Say Y here to enable the i.MX21 pinctrl driver
-
-config PINCTRL_IMX27
-	bool "IMX27 pinctrl driver"
-	depends on SOC_IMX27
-	select PINCTRL_IMX1_CORE
-	help
-	  Say Y here to enable the imx27 pinctrl driver
-
-
-config PINCTRL_IMX25
-        bool "IMX25 pinctrl driver"
-        depends on OF
-        depends on SOC_IMX25
-        select PINCTRL_IMX
-        help
-          Say Y here to enable the imx25 pinctrl driver
-
-config PINCTRL_IMX35
-	bool "IMX35 pinctrl driver"
-	depends on SOC_IMX35
-	select PINCTRL_IMX
-	help
-	  Say Y here to enable the imx35 pinctrl driver
-
-config PINCTRL_IMX50
-	bool "IMX50 pinctrl driver"
-	depends on SOC_IMX50
-	select PINCTRL_IMX
-	help
-	  Say Y here to enable the imx50 pinctrl driver
-
-config PINCTRL_IMX51
-	bool "IMX51 pinctrl driver"
-	depends on SOC_IMX51
-	select PINCTRL_IMX
-	help
-	  Say Y here to enable the imx51 pinctrl driver
-
-config PINCTRL_IMX53
-	bool "IMX53 pinctrl driver"
-	depends on SOC_IMX53
-	select PINCTRL_IMX
-	help
-	  Say Y here to enable the imx53 pinctrl driver
-
-config PINCTRL_IMX6Q
-	bool "IMX6Q/DL pinctrl driver"
-	depends on SOC_IMX6Q
-	select PINCTRL_IMX
-	help
-	  Say Y here to enable the imx6q/dl pinctrl driver
-
-config PINCTRL_IMX6SL
-	bool "IMX6SL pinctrl driver"
-	depends on SOC_IMX6SL
-	select PINCTRL_IMX
-	help
-	  Say Y here to enable the imx6sl pinctrl driver
-
-config PINCTRL_IMX6SX
-	bool "IMX6SX pinctrl driver"
-	depends on SOC_IMX6SX
-	select PINCTRL_IMX
-	help
-	  Say Y here to enable the imx6sx pinctrl driver
-
-config PINCTRL_VF610
-	bool "Freescale Vybrid VF610 pinctrl driver"
-	depends on SOC_VF610
-	select PINCTRL_IMX
-	help
-	  Say Y here to enable the Freescale Vybrid VF610 pinctrl driver
-
 config PINCTRL_LANTIQ
 	bool
 	depends on LANTIQ
@@ -204,19 +108,6 @@ config PINCTRL_FALCON
 	depends on SOC_FALCON
 	depends on PINCTRL_LANTIQ
 
-config PINCTRL_MXS
-	bool
-	select PINMUX
-	select PINCONF
-
-config PINCTRL_IMX23
-	bool
-	select PINCTRL_MXS
-
-config PINCTRL_IMX28
-	bool
-	select PINCTRL_MXS
-
 config PINCTRL_ROCKCHIP
 	bool
 	select PINMUX
@@ -313,6 +204,7 @@ config PINCTRL_PALMAS
 	  TPS65913, TPS80036 etc.
 
 source "drivers/pinctrl/berlin/Kconfig"
+source "drivers/pinctrl/freescale/Kconfig"
 source "drivers/pinctrl/mvebu/Kconfig"
 source "drivers/pinctrl/nomadik/Kconfig"
 source "drivers/pinctrl/qcom/Kconfig"
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index 0ffe1f608c67..51f52d32859e 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -17,24 +17,7 @@ obj-$(CONFIG_PINCTRL_AT91)	+= pinctrl-at91.o
 obj-$(CONFIG_PINCTRL_BCM2835)	+= pinctrl-bcm2835.o
 obj-$(CONFIG_PINCTRL_BAYTRAIL)	+= pinctrl-baytrail.o
 obj-$(CONFIG_PINCTRL_BCM281XX)	+= pinctrl-bcm281xx.o
-obj-$(CONFIG_PINCTRL_IMX)	+= pinctrl-imx.o
-obj-$(CONFIG_PINCTRL_IMX1_CORE)	+= pinctrl-imx1-core.o
-obj-$(CONFIG_PINCTRL_IMX1)	+= pinctrl-imx1.o
-obj-$(CONFIG_PINCTRL_IMX21)	+= pinctrl-imx21.o
-obj-$(CONFIG_PINCTRL_IMX27)	+= pinctrl-imx27.o
-obj-$(CONFIG_PINCTRL_IMX35)	+= pinctrl-imx35.o
-obj-$(CONFIG_PINCTRL_IMX50)	+= pinctrl-imx50.o
-obj-$(CONFIG_PINCTRL_IMX51)	+= pinctrl-imx51.o
-obj-$(CONFIG_PINCTRL_IMX53)	+= pinctrl-imx53.o
-obj-$(CONFIG_PINCTRL_IMX6Q)	+= pinctrl-imx6q.o
-obj-$(CONFIG_PINCTRL_IMX6Q)	+= pinctrl-imx6dl.o
-obj-$(CONFIG_PINCTRL_IMX6SL)	+= pinctrl-imx6sl.o
-obj-$(CONFIG_PINCTRL_IMX6SX)	+= pinctrl-imx6sx.o
 obj-$(CONFIG_PINCTRL_FALCON)	+= pinctrl-falcon.o
-obj-$(CONFIG_PINCTRL_MXS)	+= pinctrl-mxs.o
-obj-$(CONFIG_PINCTRL_IMX23)	+= pinctrl-imx23.o
-obj-$(CONFIG_PINCTRL_IMX25)	+= pinctrl-imx25.o
-obj-$(CONFIG_PINCTRL_IMX28)	+= pinctrl-imx28.o
 obj-$(CONFIG_PINCTRL_PALMAS)	+= pinctrl-palmas.o
 obj-$(CONFIG_PINCTRL_ROCKCHIP)	+= pinctrl-rockchip.o
 obj-$(CONFIG_PINCTRL_SINGLE)	+= pinctrl-single.o
@@ -53,9 +36,9 @@ obj-$(CONFIG_PINCTRL_XWAY)	+= pinctrl-xway.o
 obj-$(CONFIG_PINCTRL_LANTIQ)	+= pinctrl-lantiq.o
 obj-$(CONFIG_PINCTRL_TB10X)	+= pinctrl-tb10x.o
 obj-$(CONFIG_PINCTRL_ST) 	+= pinctrl-st.o
-obj-$(CONFIG_PINCTRL_VF610)	+= pinctrl-vf610.o
 
 obj-$(CONFIG_ARCH_BERLIN)	+= berlin/
+obj-y				+= freescale/
 obj-$(CONFIG_PLAT_ORION)        += mvebu/
 obj-y				+= nomadik/
 obj-$(CONFIG_ARCH_QCOM)		+= qcom/
diff --git a/drivers/pinctrl/freescale/Kconfig b/drivers/pinctrl/freescale/Kconfig
new file mode 100644
index 000000000000..16aac38793fe
--- /dev/null
+++ b/drivers/pinctrl/freescale/Kconfig
@@ -0,0 +1,108 @@
+config PINCTRL_IMX
+	bool
+	select PINMUX
+	select PINCONF
+
+config PINCTRL_IMX1_CORE
+	bool
+	select PINMUX
+	select PINCONF
+
+config PINCTRL_IMX1
+	bool "IMX1 pinctrl driver"
+	depends on SOC_IMX1
+	select PINCTRL_IMX1_CORE
+	help
+	  Say Y here to enable the imx1 pinctrl driver
+
+config PINCTRL_IMX21
+	bool "i.MX21 pinctrl driver"
+	depends on SOC_IMX21
+	select PINCTRL_IMX1_CORE
+	help
+	  Say Y here to enable the i.MX21 pinctrl driver
+
+config PINCTRL_IMX27
+	bool "IMX27 pinctrl driver"
+	depends on SOC_IMX27
+	select PINCTRL_IMX1_CORE
+	help
+	  Say Y here to enable the imx27 pinctrl driver
+
+
+config PINCTRL_IMX25
+        bool "IMX25 pinctrl driver"
+        depends on OF
+        depends on SOC_IMX25
+        select PINCTRL_IMX
+        help
+          Say Y here to enable the imx25 pinctrl driver
+
+config PINCTRL_IMX35
+	bool "IMX35 pinctrl driver"
+	depends on SOC_IMX35
+	select PINCTRL_IMX
+	help
+	  Say Y here to enable the imx35 pinctrl driver
+
+config PINCTRL_IMX50
+	bool "IMX50 pinctrl driver"
+	depends on SOC_IMX50
+	select PINCTRL_IMX
+	help
+	  Say Y here to enable the imx50 pinctrl driver
+
+config PINCTRL_IMX51
+	bool "IMX51 pinctrl driver"
+	depends on SOC_IMX51
+	select PINCTRL_IMX
+	help
+	  Say Y here to enable the imx51 pinctrl driver
+
+config PINCTRL_IMX53
+	bool "IMX53 pinctrl driver"
+	depends on SOC_IMX53
+	select PINCTRL_IMX
+	help
+	  Say Y here to enable the imx53 pinctrl driver
+
+config PINCTRL_IMX6Q
+	bool "IMX6Q/DL pinctrl driver"
+	depends on SOC_IMX6Q
+	select PINCTRL_IMX
+	help
+	  Say Y here to enable the imx6q/dl pinctrl driver
+
+config PINCTRL_IMX6SL
+	bool "IMX6SL pinctrl driver"
+	depends on SOC_IMX6SL
+	select PINCTRL_IMX
+	help
+	  Say Y here to enable the imx6sl pinctrl driver
+
+config PINCTRL_IMX6SX
+	bool "IMX6SX pinctrl driver"
+	depends on SOC_IMX6SX
+	select PINCTRL_IMX
+	help
+	  Say Y here to enable the imx6sx pinctrl driver
+
+config PINCTRL_VF610
+	bool "Freescale Vybrid VF610 pinctrl driver"
+	depends on SOC_VF610
+	select PINCTRL_IMX
+	help
+	  Say Y here to enable the Freescale Vybrid VF610 pinctrl driver
+
+config PINCTRL_MXS
+	bool
+	select PINMUX
+	select PINCONF
+
+config PINCTRL_IMX23
+	bool
+	select PINCTRL_MXS
+
+config PINCTRL_IMX28
+	bool
+	select PINCTRL_MXS
diff --git a/drivers/pinctrl/freescale/Makefile b/drivers/pinctrl/freescale/Makefile
new file mode 100644
index 000000000000..bba73c22f043
--- /dev/null
+++ b/drivers/pinctrl/freescale/Makefile
@@ -0,0 +1,19 @@
+# Freescale pin control drivers
+obj-$(CONFIG_PINCTRL_IMX)	+= pinctrl-imx.o
+obj-$(CONFIG_PINCTRL_IMX1_CORE)	+= pinctrl-imx1-core.o
+obj-$(CONFIG_PINCTRL_IMX1)	+= pinctrl-imx1.o
+obj-$(CONFIG_PINCTRL_IMX21)	+= pinctrl-imx21.o
+obj-$(CONFIG_PINCTRL_IMX27)	+= pinctrl-imx27.o
+obj-$(CONFIG_PINCTRL_IMX35)	+= pinctrl-imx35.o
+obj-$(CONFIG_PINCTRL_IMX50)	+= pinctrl-imx50.o
+obj-$(CONFIG_PINCTRL_IMX51)	+= pinctrl-imx51.o
+obj-$(CONFIG_PINCTRL_IMX53)	+= pinctrl-imx53.o
+obj-$(CONFIG_PINCTRL_IMX6Q)	+= pinctrl-imx6q.o
+obj-$(CONFIG_PINCTRL_IMX6Q)	+= pinctrl-imx6dl.o
+obj-$(CONFIG_PINCTRL_IMX6SL)	+= pinctrl-imx6sl.o
+obj-$(CONFIG_PINCTRL_IMX6SX)	+= pinctrl-imx6sx.o
+obj-$(CONFIG_PINCTRL_VF610)	+= pinctrl-vf610.o
+obj-$(CONFIG_PINCTRL_MXS)	+= pinctrl-mxs.o
+obj-$(CONFIG_PINCTRL_IMX23)	+= pinctrl-imx23.o
+obj-$(CONFIG_PINCTRL_IMX25)	+= pinctrl-imx25.o
+obj-$(CONFIG_PINCTRL_IMX28)	+= pinctrl-imx28.o
diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/freescale/pinctrl-imx.c
similarity index 99%
rename from drivers/pinctrl/pinctrl-imx.c
rename to drivers/pinctrl/freescale/pinctrl-imx.c
index 570e5acb4a6a..e89268c09e4c 100644
--- a/drivers/pinctrl/pinctrl-imx.c
+++ b/drivers/pinctrl/freescale/pinctrl-imx.c
@@ -24,7 +24,7 @@
 #include <linux/pinctrl/pinmux.h>
 #include <linux/slab.h>
 
-#include "core.h"
+#include "../core.h"
 #include "pinctrl-imx.h"
 
 /* The bits in CONFIG cell defined in binding doc*/
diff --git a/drivers/pinctrl/pinctrl-imx.h b/drivers/pinctrl/freescale/pinctrl-imx.h
similarity index 100%
rename from drivers/pinctrl/pinctrl-imx.h
rename to drivers/pinctrl/freescale/pinctrl-imx.h
diff --git a/drivers/pinctrl/pinctrl-imx1-core.c b/drivers/pinctrl/freescale/pinctrl-imx1-core.c
similarity index 99%
rename from drivers/pinctrl/pinctrl-imx1-core.c
rename to drivers/pinctrl/freescale/pinctrl-imx1-core.c
index 176a3e62f1cf..5ac59fbb2440 100644
--- a/drivers/pinctrl/pinctrl-imx1-core.c
+++ b/drivers/pinctrl/freescale/pinctrl-imx1-core.c
@@ -28,7 +28,7 @@
 #include <linux/pinctrl/pinmux.h>
 #include <linux/slab.h>
 
-#include "core.h"
+#include "../core.h"
 #include "pinctrl-imx1.h"
 
 struct imx1_pinctrl {
diff --git a/drivers/pinctrl/pinctrl-imx1.c b/drivers/pinctrl/freescale/pinctrl-imx1.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-imx1.c
rename to drivers/pinctrl/freescale/pinctrl-imx1.c
diff --git a/drivers/pinctrl/pinctrl-imx1.h b/drivers/pinctrl/freescale/pinctrl-imx1.h
similarity index 100%
rename from drivers/pinctrl/pinctrl-imx1.h
rename to drivers/pinctrl/freescale/pinctrl-imx1.h
diff --git a/drivers/pinctrl/pinctrl-imx21.c b/drivers/pinctrl/freescale/pinctrl-imx21.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-imx21.c
rename to drivers/pinctrl/freescale/pinctrl-imx21.c
diff --git a/drivers/pinctrl/pinctrl-imx23.c b/drivers/pinctrl/freescale/pinctrl-imx23.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-imx23.c
rename to drivers/pinctrl/freescale/pinctrl-imx23.c
diff --git a/drivers/pinctrl/pinctrl-imx25.c b/drivers/pinctrl/freescale/pinctrl-imx25.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-imx25.c
rename to drivers/pinctrl/freescale/pinctrl-imx25.c
diff --git a/drivers/pinctrl/pinctrl-imx27.c b/drivers/pinctrl/freescale/pinctrl-imx27.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-imx27.c
rename to drivers/pinctrl/freescale/pinctrl-imx27.c
diff --git a/drivers/pinctrl/pinctrl-imx28.c b/drivers/pinctrl/freescale/pinctrl-imx28.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-imx28.c
rename to drivers/pinctrl/freescale/pinctrl-imx28.c
diff --git a/drivers/pinctrl/pinctrl-imx35.c b/drivers/pinctrl/freescale/pinctrl-imx35.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-imx35.c
rename to drivers/pinctrl/freescale/pinctrl-imx35.c
diff --git a/drivers/pinctrl/pinctrl-imx50.c b/drivers/pinctrl/freescale/pinctrl-imx50.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-imx50.c
rename to drivers/pinctrl/freescale/pinctrl-imx50.c
diff --git a/drivers/pinctrl/pinctrl-imx51.c b/drivers/pinctrl/freescale/pinctrl-imx51.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-imx51.c
rename to drivers/pinctrl/freescale/pinctrl-imx51.c
diff --git a/drivers/pinctrl/pinctrl-imx53.c b/drivers/pinctrl/freescale/pinctrl-imx53.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-imx53.c
rename to drivers/pinctrl/freescale/pinctrl-imx53.c
diff --git a/drivers/pinctrl/pinctrl-imx6dl.c b/drivers/pinctrl/freescale/pinctrl-imx6dl.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-imx6dl.c
rename to drivers/pinctrl/freescale/pinctrl-imx6dl.c
diff --git a/drivers/pinctrl/pinctrl-imx6q.c b/drivers/pinctrl/freescale/pinctrl-imx6q.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-imx6q.c
rename to drivers/pinctrl/freescale/pinctrl-imx6q.c
diff --git a/drivers/pinctrl/pinctrl-imx6sl.c b/drivers/pinctrl/freescale/pinctrl-imx6sl.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-imx6sl.c
rename to drivers/pinctrl/freescale/pinctrl-imx6sl.c
diff --git a/drivers/pinctrl/pinctrl-imx6sx.c b/drivers/pinctrl/freescale/pinctrl-imx6sx.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-imx6sx.c
rename to drivers/pinctrl/freescale/pinctrl-imx6sx.c
diff --git a/drivers/pinctrl/pinctrl-mxs.c b/drivers/pinctrl/freescale/pinctrl-mxs.c
similarity index 99%
rename from drivers/pinctrl/pinctrl-mxs.c
rename to drivers/pinctrl/freescale/pinctrl-mxs.c
index 67035091f8fd..f98c6bb0f769 100644
--- a/drivers/pinctrl/pinctrl-mxs.c
+++ b/drivers/pinctrl/freescale/pinctrl-mxs.c
@@ -21,7 +21,7 @@
 #include <linux/pinctrl/pinmux.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
-#include "core.h"
+#include "../core.h"
 #include "pinctrl-mxs.h"
 
 #define SUFFIX_LEN	4
diff --git a/drivers/pinctrl/pinctrl-mxs.h b/drivers/pinctrl/freescale/pinctrl-mxs.h
similarity index 100%
rename from drivers/pinctrl/pinctrl-mxs.h
rename to drivers/pinctrl/freescale/pinctrl-mxs.h
diff --git a/drivers/pinctrl/pinctrl-vf610.c b/drivers/pinctrl/freescale/pinctrl-vf610.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-vf610.c
rename to drivers/pinctrl/freescale/pinctrl-vf610.c
-- 
1.9.3

