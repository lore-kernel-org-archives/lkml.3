Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaB0V3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:29:38 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:58820 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaB0V2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:28:19 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Chris Ball <chris@printf.net>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Wim Van Sebroeck <wim@iguana.be>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        alsa-devel@alsa-project.org, linux-watchdog@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] ARM: dove: prepare new Dove DT Kconfig variable
Date: Thu, 27 Feb 2014 22:28:03 +0100
Message-Id: <1393536486-3827-3-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1393536486-3827-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1393536486-3827-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DT-enabled Dove will move over from ARCH_DOVE in mach-dove to MACH_DOVE in
mach-mvebu. As non-DT ARCH_DOVE will stay to rot for a while, add a new
DT-only MACH_DOVE to mmc, thermal, wdt, and asoc Kconfigs.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Chris Ball <chris@printf.net>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: alsa-devel@alsa-project.org
Cc: linux-watchdog@vger.kernel.org
Cc: linux-pm@vger.kernel.org
Cc: linux-mmc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/mmc/host/Kconfig   | 2 +-
 drivers/thermal/Kconfig    | 2 +-
 drivers/watchdog/Kconfig   | 2 +-
 sound/soc/kirkwood/Kconfig | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 1384f67abe21..a69e48b582e5 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -168,7 +168,7 @@ config MMC_SDHCI_ESDHC_IMX
 
 config MMC_SDHCI_DOVE
 	tristate "SDHCI support on Marvell's Dove SoC"
-	depends on ARCH_DOVE
+	depends on ARCH_DOVE || MACH_DOVE
 	depends on MMC_SDHCI_PLTFM
 	select MMC_SDHCI_IO_ACCESSORS
 	help
diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 35c066489a19..07b5e56e9a97 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -150,7 +150,7 @@ config KIRKWOOD_THERMAL
 
 config DOVE_THERMAL
 	tristate "Temperature sensor on Marvell Dove SoCs"
-	depends on ARCH_DOVE
+	depends on ARCH_DOVE || MACH_DOVE
 	depends on OF
 	help
 	  Support for the Dove thermal sensor driver in the Linux thermal
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 79d25894343a..5659c62a175c 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -292,7 +292,7 @@ config DAVINCI_WATCHDOG
 
 config ORION_WATCHDOG
 	tristate "Orion watchdog"
-	depends on ARCH_ORION5X || ARCH_KIRKWOOD || ARCH_DOVE
+	depends on ARCH_ORION5X || ARCH_KIRKWOOD || ARCH_DOVE || MACH_DOVE
 	select WATCHDOG_CORE
 	help
 	  Say Y here if to include support for the watchdog timer
diff --git a/sound/soc/kirkwood/Kconfig b/sound/soc/kirkwood/Kconfig
index 78ed4a42ad21..a1506d57e646 100644
--- a/sound/soc/kirkwood/Kconfig
+++ b/sound/soc/kirkwood/Kconfig
@@ -1,6 +1,6 @@
 config SND_KIRKWOOD_SOC
 	tristate "SoC Audio for the Marvell Kirkwood and Dove chips"
-	depends on ARCH_KIRKWOOD || ARCH_DOVE || COMPILE_TEST
+	depends on ARCH_KIRKWOOD || ARCH_DOVE || MACH_DOVE || COMPILE_TEST
 	help
 	  Say Y or M if you want to add support for codecs attached to
 	  the Kirkwood I2S interface. You will also need to select the
-- 
1.8.5.3

