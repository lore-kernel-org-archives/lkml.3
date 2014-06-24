Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaFXEFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 00:05:11 -0400
Received: from regular2.263xmail.com ([211.157.152.4]:53631 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaFXEFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 00:05:08 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: addy.ke@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <49c2d1b0cff58d33cf93caf4329a421d>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: addy ke <addy.ke@rock-chips.com>
To: broonie@kernel.org, heiko@sntech.de, grant.likely@linaro.org,
        robh+dt@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        olof@lixom.net, hj@rock-chips.com, kever.yang@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, zhenfu.fang@rock-chips.com, cf@rock-chips.com,
        addy ke <addy.ke@rock-chips.com>
Subject: [PATCH 1/2] documentation: add rockchip spi documentation
Date: Tue, 24 Jun 2014 11:58:43 +0800
Message-Id: <1403582324-9485-2-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1403582324-9485-1-git-send-email-addy.ke@rock-chips.com>
References: <1403582324-9485-1-git-send-email-addy.ke@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: addy ke <addy.ke@rock-chips.com>
---
 .../devicetree/bindings/spi/spi-rockchip.txt       | 51 ++++++++++++++++++++++
 1 file changed, 51 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spi/spi-rockchip.txt

diff --git a/Documentation/devicetree/bindings/spi/spi-rockchip.txt b/Documentation/devicetree/bindings/spi/spi-rockchip.txt
new file mode 100644
index 0000000..ce9c881
--- /dev/null
+++ b/Documentation/devicetree/bindings/spi/spi-rockchip.txt
@@ -0,0 +1,51 @@
+* Rockchip SPI Controller
+
+The Rockchip SPI controller is used to interface with various devices such as flash
+and display controllers using the SPI communication interface.
+
+Required SoC Specific Properties:
+
+- compatible: should be one of the following.
+    - rockchip,rk3066-spi: for rk3066, rk3188 and rk3288 platforms.
+- reg: physical base address of the controller and length of memory mapped
+       region.
+- interrupts: The interrupt number to the cpu. The interrupt specifier format
+              depends on the interrupt controller.
+- clocks: Must contain an entry for each entry in clock-names.
+- clock-names: Shall be "spiclk" for the transfer-clock, and "apb_pclk" for
+			   the peripheral clock.
+
+Optional properties:
+- dmas: DMA specifiers for tx and rx dma. See the DMA client binding,
+		Documentation/devicetree/bindings/dma/dma.txt
+- dma-names: DMA request names should include "tx" and "rx" if present.
+
+Example:
+
+- SoC Specific Portion:
+
+	spi0: spi@ff110000 {
+		compatible = "rockchip,rockchip-spi";
+		reg = <0xff110000 0x1000>;
+		dmas = <&pdma1 11>, <&pdma1 12>;
+		dma-names = "tx", "rx";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&spi0_clk &spi0_tx &spi0_rx &spi0_cs0 &spi0_cs1>;
+		clocks = <&cru SCLK_SPI0>, <&cru PCLK_SPI0>;
+		clock-names = "spiclk", "apb_pclk";
+		status = "disabled";
+	};
+
+- Board Specific Portion:
+
+	&spi0 {
+		status = "okay";
+		spi_test@00 {
+			compatible = "rockchip,spi_test";
+			reg = <0>;
+			spi-max-frequency = <24000000>;
+		};
+	};
-- 
1.8.3.2


