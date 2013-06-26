Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab3FZB0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 21:26:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45644 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989Ab3FZBZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 21:25:38 -0400
From: Joel A Fernandes <joelagnel@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>, Balaji TK <balajitk@ti.com>,
        Chris Ball <cjb@laptop.org>
CC: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/5] ARM: dts: am33xx: Add interrupts and memory resources for MMC
Date: Tue, 25 Jun 2013 20:24:48 -0500
Message-ID: <1372209888-6649-1-git-send-email-joelagnel@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joel A Fernandes <agnel.joel@gmail.com>

HWMOD irq entries for MMC were removed. We provide the same from DT for MMC.

This fixes issue where memory resource could not be found during probe.
Also, added the reg-offset property to account for the offset from start.

Signed-off-by: Joel A Fernandes <agnel.joel@gmail.com>
---
 arch/arm/boot/dts/am33xx.dtsi |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 119f8a9..e0a5741 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -237,6 +237,10 @@
 			dmas = <&edma 24
 				&edma 25>;
 			dma-names = "tx", "rx";
+			interrupts = <64>;
+			interrupt-parent = <&intc>;
+			reg = <0x48060000 0x1000>;
+			reg-offset = <0x100>;
 			status = "disabled";
 		};
 
@@ -247,6 +251,10 @@
 			dmas = <&edma 2
 				&edma 3>;
 			dma-names = "tx", "rx";
+			interrupts = <24>;
+			interrupt-parent = <&intc>;
+			reg = <0x481d8000 0x1000>;
+			reg-offset = <0x100>;
 			status = "disabled";
 		};
 
@@ -254,6 +262,10 @@
 			compatible = "ti,omap3-hsmmc";
 			ti,hwmods = "mmc3";
 			ti,needs-special-reset;
+			interrupts = <25>;
+			interrupt-parent = <&intc>;
+			reg = <0x47810000 0x1000>;
+			reg-offset = <0x100>;
 			status = "disabled";
 		};
 
-- 
1.7.9.5

