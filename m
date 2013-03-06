Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab3CFQRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 11:17:25 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54706 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab3CFQP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 11:15:26 -0500
From: Matt Porter <mporter@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
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
Subject: [PATCH v9 6/9] ARM: dts: add AM33XX EDMA support
Date: Wed,  6 Mar 2013 11:15:36 -0500
Message-Id: <1362586540-10393-7-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362586540-10393-1-git-send-email-mporter@ti.com>
References: <1362586540-10393-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds AM33XX EDMA support to the am33xx.dtsi as documented in
Documentation/devicetree/bindings/dma/ti-edma.txt

Signed-off-by: Matt Porter <mporter@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 0957645..cbea5ab 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -87,6 +87,25 @@
 			reg = <0x48200000 0x1000>;
 		};
 
+		edma: edma@49000000 {
+			compatible = "ti,edma3";
+			ti,hwmods = "tpcc", "tptc0", "tptc1", "tptc2";
+			reg =	<0x49000000 0x10000>,
+				<0x44e10f90 0x10>;
+			interrupts = <12 13 14>;
+			#dma-cells = <1>;
+			dma-channels = <64>;
+			ti,edma-regions = <4>;
+			ti,edma-slots = <256>;
+			ti,edma-queue-tc-map = <0 0
+						1 1
+						2 2>;
+			ti,edma-queue-priority-map = <0 0
+						      1 1
+						      2 2>;
+			ti,edma-default-queue = <0>;
+		};
+
 		gpio1: gpio@44e07000 {
 			compatible = "ti,omap4-gpio";
 			ti,hwmods = "gpio1";
-- 
1.7.9.5

