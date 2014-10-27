Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaJ0IJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 04:09:39 -0400
Received: from mga14.intel.com ([192.55.52.115]:33074 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbaJ0IJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 04:09:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,794,1406617200"; 
   d="scan'208";a="611931009"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Ning Li <ning.li@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] pinctrl: Move Intel Baytrail pinctrl driver under intel directory
Date: Mon, 27 Oct 2014 10:08:30 +0200
Message-Id: <1414397312-94609-3-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414397312-94609-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1414397312-94609-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are going to have more pinctrl drivers for Intel hardware so separate
all our pin controller drivers to own directory.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
Mathias, can you ACK this if you are happy with the change?

 drivers/pinctrl/Kconfig                        | 13 +------------
 drivers/pinctrl/Makefile                       |  2 +-
 drivers/pinctrl/intel/Kconfig                  | 15 +++++++++++++++
 drivers/pinctrl/intel/Makefile                 |  3 +++
 drivers/pinctrl/{ => intel}/pinctrl-baytrail.c |  0
 5 files changed, 20 insertions(+), 13 deletions(-)
 create mode 100644 drivers/pinctrl/intel/Kconfig
 create mode 100644 drivers/pinctrl/intel/Makefile
 rename drivers/pinctrl/{ => intel}/pinctrl-baytrail.c (100%)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index c6a66de6ed72..d014f22f387a 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -67,18 +67,6 @@ config PINCTRL_AT91
 	help
 	  Say Y here to enable the at91 pinctrl driver
 
-config PINCTRL_BAYTRAIL
-	bool "Intel Baytrail GPIO pin control"
-	depends on GPIOLIB && ACPI && X86
-	select GPIOLIB_IRQCHIP
-	help
-	  driver for memory mapped GPIO functionality on Intel Baytrail
-	  platforms. Supports 3 banks with 102, 28 and 44 gpios.
-	  Most pins are usually muxed to some other functionality by firmware,
-	  so only a small amount is available for gpio use.
-
-	  Requires ACPI device enumeration code to set up a platform device.
-
 config PINCTRL_BCM2835
 	bool
 	select PINMUX
@@ -205,6 +193,7 @@ config PINCTRL_PALMAS
 
 source "drivers/pinctrl/berlin/Kconfig"
 source "drivers/pinctrl/freescale/Kconfig"
+source "drivers/pinctrl/intel/Kconfig"
 source "drivers/pinctrl/mvebu/Kconfig"
 source "drivers/pinctrl/nomadik/Kconfig"
 source "drivers/pinctrl/qcom/Kconfig"
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index 51f52d32859e..c030b3db8034 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -15,7 +15,6 @@ obj-$(CONFIG_PINCTRL_BF54x)	+= pinctrl-adi2-bf54x.o
 obj-$(CONFIG_PINCTRL_BF60x)	+= pinctrl-adi2-bf60x.o
 obj-$(CONFIG_PINCTRL_AT91)	+= pinctrl-at91.o
 obj-$(CONFIG_PINCTRL_BCM2835)	+= pinctrl-bcm2835.o
-obj-$(CONFIG_PINCTRL_BAYTRAIL)	+= pinctrl-baytrail.o
 obj-$(CONFIG_PINCTRL_BCM281XX)	+= pinctrl-bcm281xx.o
 obj-$(CONFIG_PINCTRL_FALCON)	+= pinctrl-falcon.o
 obj-$(CONFIG_PINCTRL_PALMAS)	+= pinctrl-palmas.o
@@ -39,6 +38,7 @@ obj-$(CONFIG_PINCTRL_ST) 	+= pinctrl-st.o
 
 obj-$(CONFIG_ARCH_BERLIN)	+= berlin/
 obj-y				+= freescale/
+obj-$(CONFIG_X86)		+= intel/
 obj-$(CONFIG_PLAT_ORION)        += mvebu/
 obj-y				+= nomadik/
 obj-$(CONFIG_ARCH_QCOM)		+= qcom/
diff --git a/drivers/pinctrl/intel/Kconfig b/drivers/pinctrl/intel/Kconfig
new file mode 100644
index 000000000000..957c90386307
--- /dev/null
+++ b/drivers/pinctrl/intel/Kconfig
@@ -0,0 +1,15 @@
+#
+# Intel pin control drivers
+#
+
+config PINCTRL_BAYTRAIL
+	bool "Intel Baytrail GPIO pin control"
+	depends on GPIOLIB && ACPI
+	select GPIOLIB_IRQCHIP
+	help
+	  driver for memory mapped GPIO functionality on Intel Baytrail
+	  platforms. Supports 3 banks with 102, 28 and 44 gpios.
+	  Most pins are usually muxed to some other functionality by firmware,
+	  so only a small amount is available for gpio use.
+
+	  Requires ACPI device enumeration code to set up a platform device.
diff --git a/drivers/pinctrl/intel/Makefile b/drivers/pinctrl/intel/Makefile
new file mode 100644
index 000000000000..d049b769e327
--- /dev/null
+++ b/drivers/pinctrl/intel/Makefile
@@ -0,0 +1,3 @@
+# Intel pin control drivers
+
+obj-$(CONFIG_PINCTRL_BAYTRAIL)		+= pinctrl-baytrail.o
diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/intel/pinctrl-baytrail.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-baytrail.c
rename to drivers/pinctrl/intel/pinctrl-baytrail.c
-- 
2.1.1

