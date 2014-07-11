Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbaGKNBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:01:12 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:49994 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbaGKNBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:01:10 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: nomadik: move all Nomadik drivers to subdir
Date: Fri, 11 Jul 2014 15:00:37 +0200
Message-Id: <1405083637-1912-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a bunch of Nomadik family pin control drivers, so let's
move them into their own subdirectory.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/Kconfig                            | 45 +------------------
 drivers/pinctrl/Makefile                           | 10 +----
 drivers/pinctrl/nomadik/Kconfig                    | 51 ++++++++++++++++++++++
 drivers/pinctrl/nomadik/Makefile                   | 10 +++++
 drivers/pinctrl/{ => nomadik}/pinctrl-ab8500.c     |  0
 drivers/pinctrl/{ => nomadik}/pinctrl-ab8505.c     |  0
 drivers/pinctrl/{ => nomadik}/pinctrl-ab8540.c     |  0
 drivers/pinctrl/{ => nomadik}/pinctrl-ab9540.c     |  0
 drivers/pinctrl/{ => nomadik}/pinctrl-abx500.c     |  4 +-
 drivers/pinctrl/{ => nomadik}/pinctrl-abx500.h     |  0
 .../pinctrl/{ => nomadik}/pinctrl-nomadik-db8500.c |  0
 .../pinctrl/{ => nomadik}/pinctrl-nomadik-db8540.c |  0
 .../{ => nomadik}/pinctrl-nomadik-stn8815.c        |  0
 drivers/pinctrl/{ => nomadik}/pinctrl-nomadik.c    |  2 +-
 drivers/pinctrl/{ => nomadik}/pinctrl-nomadik.h    |  0
 15 files changed, 66 insertions(+), 56 deletions(-)
 create mode 100644 drivers/pinctrl/nomadik/Kconfig
 create mode 100644 drivers/pinctrl/nomadik/Makefile
 rename drivers/pinctrl/{ => nomadik}/pinctrl-ab8500.c (100%)
 rename drivers/pinctrl/{ => nomadik}/pinctrl-ab8505.c (100%)
 rename drivers/pinctrl/{ => nomadik}/pinctrl-ab8540.c (100%)
 rename drivers/pinctrl/{ => nomadik}/pinctrl-ab9540.c (100%)
 rename drivers/pinctrl/{ => nomadik}/pinctrl-abx500.c (99%)
 rename drivers/pinctrl/{ => nomadik}/pinctrl-abx500.h (100%)
 rename drivers/pinctrl/{ => nomadik}/pinctrl-nomadik-db8500.c (100%)
 rename drivers/pinctrl/{ => nomadik}/pinctrl-nomadik-db8540.c (100%)
 rename drivers/pinctrl/{ => nomadik}/pinctrl-nomadik-stn8815.c (100%)
 rename drivers/pinctrl/{ => nomadik}/pinctrl-nomadik.c (99%)
 rename drivers/pinctrl/{ => nomadik}/pinctrl-nomadik.h (100%)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 53e07c70951f..3d94e47546ec 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -26,29 +26,6 @@ config DEBUG_PINCTRL
 	help
 	  Say Y here to add some extra checks and diagnostics to PINCTRL calls.
 
-config PINCTRL_ABX500
-	bool "ST-Ericsson ABx500 family Mixed Signal Circuit gpio functions"
-	depends on AB8500_CORE
-	select GENERIC_PINCONF
-	help
-	  Select this to enable the ABx500 family IC GPIO driver
-
-config PINCTRL_AB8500
-	bool "AB8500 pin controller driver"
-	depends on PINCTRL_ABX500 && ARCH_U8500
-
-config PINCTRL_AB8540
-	bool "AB8540 pin controller driver"
-	depends on PINCTRL_ABX500 && ARCH_U8500
-
-config PINCTRL_AB9540
-	bool "AB9540 pin controller driver"
-	depends on PINCTRL_ABX500 && ARCH_U8500
-
-config PINCTRL_AB8505
-	bool "AB8505 pin controller driver"
-	depends on PINCTRL_ABX500 && ARCH_U8500
-
 config PINCTRL_ADI2
 	bool "ADI pin controller driver"
 	depends on BLACKFIN
@@ -233,27 +210,6 @@ config PINCTRL_IMX28
 	bool
 	select PINCTRL_MXS
 
-config PINCTRL_NOMADIK
-	bool "Nomadik pin controller driver"
-	depends on ARCH_U8500 || ARCH_NOMADIK
-	select PINMUX
-	select PINCONF
-	select GPIOLIB
-	select OF_GPIO
-	select GPIOLIB_IRQCHIP
-
-config PINCTRL_STN8815
-	bool "STN8815 pin controller driver"
-	depends on PINCTRL_NOMADIK && ARCH_NOMADIK
-
-config PINCTRL_DB8500
-	bool "DB8500 pin controller driver"
-	depends on PINCTRL_NOMADIK && ARCH_U8500
-
-config PINCTRL_DB8540
-	bool "DB8540 pin controller driver"
-	depends on PINCTRL_NOMADIK && ARCH_U8500
-
 config PINCTRL_ROCKCHIP
 	bool
 	select PINMUX
@@ -345,6 +301,7 @@ config PINCTRL_PALMAS
 
 source "drivers/pinctrl/berlin/Kconfig"
 source "drivers/pinctrl/mvebu/Kconfig"
+source "drivers/pinctrl/nomadik/Kconfig"
 source "drivers/pinctrl/qcom/Kconfig"
 source "drivers/pinctrl/samsung/Kconfig"
 source "drivers/pinctrl/sh-pfc/Kconfig"
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index df6099df7aad..e90817c1f584 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -9,11 +9,6 @@ ifeq ($(CONFIG_OF),y)
 obj-$(CONFIG_PINCTRL)		+= devicetree.o
 endif
 obj-$(CONFIG_GENERIC_PINCONF)	+= pinconf-generic.o
-obj-$(CONFIG_PINCTRL_ABX500)	+= pinctrl-abx500.o
-obj-$(CONFIG_PINCTRL_AB8500)	+= pinctrl-ab8500.o
-obj-$(CONFIG_PINCTRL_AB8540)	+= pinctrl-ab8540.o
-obj-$(CONFIG_PINCTRL_AB9540)	+= pinctrl-ab9540.o
-obj-$(CONFIG_PINCTRL_AB8505)	+= pinctrl-ab8505.o
 obj-$(CONFIG_PINCTRL_ADI2)	+= pinctrl-adi2.o
 obj-$(CONFIG_PINCTRL_AS3722)	+= pinctrl-as3722.o
 obj-$(CONFIG_PINCTRL_BF54x)	+= pinctrl-adi2-bf54x.o
@@ -39,10 +34,6 @@ obj-$(CONFIG_PINCTRL_MXS)	+= pinctrl-mxs.o
 obj-$(CONFIG_PINCTRL_IMX23)	+= pinctrl-imx23.o
 obj-$(CONFIG_PINCTRL_IMX25)	+= pinctrl-imx25.o
 obj-$(CONFIG_PINCTRL_IMX28)	+= pinctrl-imx28.o
-obj-$(CONFIG_PINCTRL_NOMADIK)	+= pinctrl-nomadik.o
-obj-$(CONFIG_PINCTRL_STN8815)	+= pinctrl-nomadik-stn8815.o
-obj-$(CONFIG_PINCTRL_DB8500)	+= pinctrl-nomadik-db8500.o
-obj-$(CONFIG_PINCTRL_DB8540)	+= pinctrl-nomadik-db8540.o
 obj-$(CONFIG_PINCTRL_PALMAS)	+= pinctrl-palmas.o
 obj-$(CONFIG_PINCTRL_ROCKCHIP)	+= pinctrl-rockchip.o
 obj-$(CONFIG_PINCTRL_SINGLE)	+= pinctrl-single.o
@@ -64,6 +55,7 @@ obj-$(CONFIG_PINCTRL_VF610)	+= pinctrl-vf610.o
 
 obj-$(CONFIG_ARCH_BERLIN)	+= berlin/
 obj-$(CONFIG_PLAT_ORION)        += mvebu/
+obj-y				+= nomadik/
 obj-$(CONFIG_ARCH_QCOM)		+= qcom/
 obj-$(CONFIG_PLAT_SAMSUNG)	+= samsung/
 obj-$(CONFIG_ARCH_SHMOBILE)	+= sh-pfc/
diff --git a/drivers/pinctrl/nomadik/Kconfig b/drivers/pinctrl/nomadik/Kconfig
new file mode 100644
index 000000000000..d48a5aa24a29
--- /dev/null
+++ b/drivers/pinctrl/nomadik/Kconfig
@@ -0,0 +1,51 @@
+if ARCH_U8500
+
+config PINCTRL_ABX500
+	bool "ST-Ericsson ABx500 family Mixed Signal Circuit gpio functions"
+	depends on AB8500_CORE
+	select GENERIC_PINCONF
+	help
+	  Select this to enable the ABx500 family IC GPIO driver
+
+config PINCTRL_AB8500
+	bool "AB8500 pin controller driver"
+	depends on PINCTRL_ABX500 && ARCH_U8500
+
+config PINCTRL_AB8540
+	bool "AB8540 pin controller driver"
+	depends on PINCTRL_ABX500 && ARCH_U8500
+
+config PINCTRL_AB9540
+	bool "AB9540 pin controller driver"
+	depends on PINCTRL_ABX500 && ARCH_U8500
+
+config PINCTRL_AB8505
+	bool "AB8505 pin controller driver"
+	depends on PINCTRL_ABX500 && ARCH_U8500
+
+endif
+
+if (ARCH_U8500 || ARCH_NOMADIK)
+
+config PINCTRL_NOMADIK
+	bool "Nomadik pin controller driver"
+	depends on ARCH_U8500 || ARCH_NOMADIK
+	select PINMUX
+	select PINCONF
+	select GPIOLIB
+	select OF_GPIO
+	select GPIOLIB_IRQCHIP
+
+config PINCTRL_STN8815
+	bool "STN8815 pin controller driver"
+	depends on PINCTRL_NOMADIK && ARCH_NOMADIK
+
+config PINCTRL_DB8500
+	bool "DB8500 pin controller driver"
+	depends on PINCTRL_NOMADIK && ARCH_U8500
+
+config PINCTRL_DB8540
+	bool "DB8540 pin controller driver"
+	depends on PINCTRL_NOMADIK && ARCH_U8500
+
+endif
diff --git a/drivers/pinctrl/nomadik/Makefile b/drivers/pinctrl/nomadik/Makefile
new file mode 100644
index 000000000000..30b27f18cd52
--- /dev/null
+++ b/drivers/pinctrl/nomadik/Makefile
@@ -0,0 +1,10 @@
+# Nomadik family pin control drivers
+obj-$(CONFIG_PINCTRL_ABX500)	+= pinctrl-abx500.o
+obj-$(CONFIG_PINCTRL_AB8500)	+= pinctrl-ab8500.o
+obj-$(CONFIG_PINCTRL_AB8540)	+= pinctrl-ab8540.o
+obj-$(CONFIG_PINCTRL_AB9540)	+= pinctrl-ab9540.o
+obj-$(CONFIG_PINCTRL_AB8505)	+= pinctrl-ab8505.o
+obj-$(CONFIG_PINCTRL_NOMADIK)	+= pinctrl-nomadik.o
+obj-$(CONFIG_PINCTRL_STN8815)	+= pinctrl-nomadik-stn8815.o
+obj-$(CONFIG_PINCTRL_DB8500)	+= pinctrl-nomadik-db8500.o
+obj-$(CONFIG_PINCTRL_DB8540)	+= pinctrl-nomadik-db8540.o
diff --git a/drivers/pinctrl/pinctrl-ab8500.c b/drivers/pinctrl/nomadik/pinctrl-ab8500.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-ab8500.c
rename to drivers/pinctrl/nomadik/pinctrl-ab8500.c
diff --git a/drivers/pinctrl/pinctrl-ab8505.c b/drivers/pinctrl/nomadik/pinctrl-ab8505.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-ab8505.c
rename to drivers/pinctrl/nomadik/pinctrl-ab8505.c
diff --git a/drivers/pinctrl/pinctrl-ab8540.c b/drivers/pinctrl/nomadik/pinctrl-ab8540.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-ab8540.c
rename to drivers/pinctrl/nomadik/pinctrl-ab8540.c
diff --git a/drivers/pinctrl/pinctrl-ab9540.c b/drivers/pinctrl/nomadik/pinctrl-ab9540.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-ab9540.c
rename to drivers/pinctrl/nomadik/pinctrl-ab9540.c
diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/nomadik/pinctrl-abx500.c
similarity index 99%
rename from drivers/pinctrl/pinctrl-abx500.c
rename to drivers/pinctrl/nomadik/pinctrl-abx500.c
index f3f8b24efe54..a53a689a2bfa 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/nomadik/pinctrl-abx500.c
@@ -32,8 +32,8 @@
 #include <linux/pinctrl/machine.h>
 
 #include "pinctrl-abx500.h"
-#include "core.h"
-#include "pinconf.h"
+#include "../core.h"
+#include "../pinconf.h"
 
 /*
  * The AB9540 and AB8540 GPIO support are extended versions
diff --git a/drivers/pinctrl/pinctrl-abx500.h b/drivers/pinctrl/nomadik/pinctrl-abx500.h
similarity index 100%
rename from drivers/pinctrl/pinctrl-abx500.h
rename to drivers/pinctrl/nomadik/pinctrl-abx500.h
diff --git a/drivers/pinctrl/pinctrl-nomadik-db8500.c b/drivers/pinctrl/nomadik/pinctrl-nomadik-db8500.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-nomadik-db8500.c
rename to drivers/pinctrl/nomadik/pinctrl-nomadik-db8500.c
diff --git a/drivers/pinctrl/pinctrl-nomadik-db8540.c b/drivers/pinctrl/nomadik/pinctrl-nomadik-db8540.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-nomadik-db8540.c
rename to drivers/pinctrl/nomadik/pinctrl-nomadik-db8540.c
diff --git a/drivers/pinctrl/pinctrl-nomadik-stn8815.c b/drivers/pinctrl/nomadik/pinctrl-nomadik-stn8815.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-nomadik-stn8815.c
rename to drivers/pinctrl/nomadik/pinctrl-nomadik-stn8815.c
diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/nomadik/pinctrl-nomadik.c
similarity index 99%
rename from drivers/pinctrl/pinctrl-nomadik.c
rename to drivers/pinctrl/nomadik/pinctrl-nomadik.c
index a564251fe093..e7cab07eef47 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/nomadik/pinctrl-nomadik.c
@@ -31,7 +31,7 @@
 /* Since we request GPIOs from ourself */
 #include <linux/pinctrl/consumer.h>
 #include "pinctrl-nomadik.h"
-#include "core.h"
+#include "../core.h"
 
 /*
  * The GPIO module in the Nomadik family of Systems-on-Chip is an
diff --git a/drivers/pinctrl/pinctrl-nomadik.h b/drivers/pinctrl/nomadik/pinctrl-nomadik.h
similarity index 100%
rename from drivers/pinctrl/pinctrl-nomadik.h
rename to drivers/pinctrl/nomadik/pinctrl-nomadik.h
-- 
1.9.3

