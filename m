Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaILIOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 04:14:20 -0400
Received: from regular1.263xmail.com ([211.150.99.131]:36720 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbaILIOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 04:14:17 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: robh+dt@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <39776fcdba40666d108dcad50936e7c0>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Jianqun <jay.xu@rock-chips.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, heiko@sntech.de,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org
Cc: huangtao@rock-chips.com, cf@rock-chips.com,
        Jianqun <jay.xu@rock-chips.com>
Subject: [PATCH] ARM: dts: add rk3288 i2s controller
Date: Fri, 12 Sep 2014 16:11:51 +0800
Message-Id: <1410509511-16667-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dt for rk3288 i2s controller, since i2s clock pins and data pins
default to be GPIO, this patch also add pinctrl to mux them.

Tested on RK3288 board.

Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
---
 arch/arm/boot/dts/rk3288.dtsi | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 5950b0a..0e2a815 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -130,6 +130,21 @@
 		status = "disabled";
 	};
 
+	i2s: i2s@ff890000 {
+		compatible = "rockchip,rk3288-i2s", "rockchip,rk3066-i2s";
+		reg = <0xff890000 0x10000>;
+		interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		dmas = <&dmac_bus_s 0>, <&dmac_bus_s 1>;
+		dma-names = "tx", "rx";
+		clock-names = "i2s_hclk", "i2s_clk";
+		clocks = <&cru HCLK_I2S0>, <&cru SCLK_I2S0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2s0_clk>;
+		status = "disabled";
+	};
+
 	uart0: serial@ff180000 {
 		compatible = "rockchip,rk3288-uart", "snps,dw-apb-uart";
 		reg = <0xff180000 0x100>;
@@ -463,6 +478,17 @@
 			};
 		};
 
+		i2s0 {
+			i2s0_clk: i2s0_clk {
+				rockchip,pins = <6 0 RK_FUNC_1 &pcfg_pull_none>,
+						<6 1 RK_FUNC_1 &pcfg_pull_none>,
+						<6 2 RK_FUNC_1 &pcfg_pull_none>,
+						<6 3 RK_FUNC_1 &pcfg_pull_none>,
+						<6 4 RK_FUNC_1 &pcfg_pull_none>,
+						<6 8 RK_FUNC_1 &pcfg_pull_none>;
+			};
+		};
+
 		sdmmc {
 			sdmmc_clk: sdmmc-clk {
 				rockchip,pins = <6 20 RK_FUNC_1 &pcfg_pull_none>;
-- 
1.9.1


