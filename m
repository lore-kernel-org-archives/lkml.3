Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab3LWQ0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:26:25 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39652 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757446Ab3LWQYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:24:09 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, arm@kernel.org,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: [RFC 12/18] clk: versatile: Split config options for sp810 and vexpress_osc
Date: Mon, 23 Dec 2013 16:23:44 +0000
Message-Id: <1387815830-8794-13-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
X-OriginalArrivalTime: 23 Dec 2013 16:24:06.0603 (UTC) FILETIME=[66BF99B0:01CEFFFB]
X-MC-Unique: 113122316240806401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id rBNGQkWb026629

Move the Kconfig entry for Versatile (& Express) clock drivers
into a separate file and add individual options for sp810
and vexpress_osc drivers, as they are optional in some
configurations and may have separate dependencies.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
Cc: Mike Turquette <mturquette@linaro.org>
---
 drivers/clk/Kconfig            |  9 +--------
 drivers/clk/versatile/Kconfig  | 26 ++++++++++++++++++++++++++
 drivers/clk/versatile/Makefile |  5 +++--
 3 files changed, 30 insertions(+), 10 deletions(-)
 create mode 100644 drivers/clk/versatile/Kconfig

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 5c51115..f5486a4 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -40,14 +40,7 @@ config COMMON_CLK_WM831X
           Supports the clocking subsystem of the WM831x/2x series of
 	  PMICs from Wolfson Microlectronics.
 
-config COMMON_CLK_VERSATILE
-	bool "Clock driver for ARM Reference designs"
-	depends on ARCH_INTEGRATOR || ARCH_REALVIEW || ARCH_VEXPRESS || ARM64
-	---help---
-          Supports clocking on ARM Reference designs:
-	  - Integrator/AP and Integrator/CP
-	  - RealView PB1176, EB, PB11MP and PBX
-	  - Versatile Express
+source "drivers/clk/versatile/Kconfig"
 
 config COMMON_CLK_MAX77686
 	tristate "Clock driver for Maxim 77686 MFD"
diff --git a/drivers/clk/versatile/Kconfig b/drivers/clk/versatile/Kconfig
new file mode 100644
index 0000000..1530c93
--- /dev/null
+++ b/drivers/clk/versatile/Kconfig
@@ -0,0 +1,26 @@
+config COMMON_CLK_VERSATILE
+	bool "Clock driver for ARM Reference designs"
+	depends on ARCH_INTEGRATOR || ARCH_REALVIEW || ARCH_VEXPRESS || ARM64
+	---help---
+          Supports clocking on ARM Reference designs:
+	  - Integrator/AP and Integrator/CP
+	  - RealView PB1176, EB, PB11MP and PBX
+	  - Versatile Express
+
+config CLK_SP810
+	bool "Clock driver for ARM SP810 System Controller"
+	depends on COMMON_CLK_VERSATILE
+	default y if ARCH_VEXPRESS
+	---help---
+	  Supports clock muxing (REFCLK/TIMCLK to TIMERCLKEN0-3) capabilities
+	  of the ARM SP810 System Controller cell.
+
+config CLK_VEXPRESS_OSC
+	bool "Clock driver for Versatile Express OSC clock generators"
+	depends on COMMON_CLK_VERSATILE
+	depends on VEXPRESS_CONFIG
+	default y if ARCH_VEXPRESS
+	---help---
+	  Simple regmap-based driver driving clock generators on Versatile
+	  Express platforms hidden behind its configuration infrastructure,
+	  commonly known as OSCs.
diff --git a/drivers/clk/versatile/Makefile b/drivers/clk/versatile/Makefile
index c16ca78..fd449f9 100644
--- a/drivers/clk/versatile/Makefile
+++ b/drivers/clk/versatile/Makefile
@@ -3,5 +3,6 @@ obj-$(CONFIG_ICST)		+= clk-icst.o
 obj-$(CONFIG_ARCH_INTEGRATOR)	+= clk-integrator.o
 obj-$(CONFIG_INTEGRATOR_IMPD1)	+= clk-impd1.o
 obj-$(CONFIG_ARCH_REALVIEW)	+= clk-realview.o
-obj-$(CONFIG_ARCH_VEXPRESS)	+= clk-vexpress.o clk-sp810.o
-obj-$(CONFIG_VEXPRESS_CONFIG)	+= clk-vexpress-osc.o
+obj-$(CONFIG_ARCH_VEXPRESS)	+= clk-vexpress.o
+obj-$(CONFIG_CLK_SP810)		+= clk-sp810.o
+obj-$(CONFIG_CLK_VEXPRESS_OSC)	+= clk-vexpress-osc.o
-- 
1.8.3.2


