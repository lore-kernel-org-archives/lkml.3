Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab3IJTZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 15:25:56 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51444 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab3IJTZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 15:25:51 -0400
From: Joel Fernandes <joelf@ti.com>
To: Benoit Cousson <bcousson@baylibre.com>
CC: Nishanth Menon <nm@ti.com>,
        Devicetree Discuss <devicetree@vger.kernel.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>
Subject: [PATCH 1/3] ARM: dts: add AM33XX EDMA support
Date: Tue, 10 Sep 2013 14:24:37 -0500
Message-ID: <1378841079-15796-2-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378841079-15796-1-git-send-email-joelf@ti.com>
References: <1378841079-15796-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Porter <mdp@ti.com>

Adds AM33XX EDMA support to the am33xx.dtsi as documented in
Documentation/devicetree/bindings/dma/ti-edma.txt

[Joel Fernandes <joelf@ti.com>]
Drop DT entries that are non-hardware-description as discussed in [1]

[1] https://patchwork.kernel.org/patch/2226761/

Signed-off-by: Matt Porter <mporter@ti.com>
Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index f9c5da9..19a1c1d 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -100,6 +100,18 @@
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
+		};
+
 		gpio0: gpio@44e07000 {
 			compatible = "ti,omap4-gpio";
 			ti,hwmods = "gpio1";
-- 
1.8.1.2

