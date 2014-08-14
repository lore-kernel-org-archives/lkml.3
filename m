Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbaHNFvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 01:51:39 -0400
Received: from regular1.263xmail.com ([211.150.99.134]:60882 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaHNFvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 01:51:38 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <29e7ee190b21c16db758e4990f708331>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Addy Ke <addy.ke@rock-chips.com>
To: heiko@sntech.de, dianders@chromium.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        olof@lixom.net, hj@rock-chips.com, kever.yang@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, zhenfu.fang@rock-chips.com, cf@rock-chips.com,
        zhangqing@rock-chips.com, hl@rock-chips.com, wei.luo@rock-chips.com,
        Addy Ke <addy.ke@rock-chips.com>
Subject: [PATCH] ARM: dts: Add sdio0 and sdio1 to the rk3288
Date: Thu, 14 Aug 2014 13:49:20 +0800
Message-Id: <1407995360-26009-1-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
---
 arch/arm/boot/dts/rk3288.dtsi | 76 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 7a9173d..a440869 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -120,6 +120,32 @@
 		//fifo-depth = <0x100>;
 	};
 
+	sdio0: dwmmc@ff0d0000 {
+		compatible = "rockchip,rk3288-dw-mshc";
+		reg = <0xff0d0000 0x4000>;
+		interrupts = <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		clocks = <&cru HCLK_SDIO0>, <&cru SCLK_SDIO0>;
+		clock-names = "biu", "ciu";
+
+		fifo-depth = <0x100>;
+	};
+
+	sdio1: dwmmc@ff0e0000 {
+		compatible = "rockchip,rk3288-dw-mshc";
+		reg = <0xff0e0000 0x4000>;
+		interrupts = <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		clocks = <&cru HCLK_SDIO1>, <&cru SCLK_SDIO1>;
+		clock-names = "biu", "ciu";
+
+		fifo-depth = <0x100>;
+	};
+
 	emmc: dwmmc@ff0f0000 {
 		compatible = "rockchip,rk3288-dw-mshc";
 		reg = <0xff0f0000 0x4000>;
@@ -589,6 +615,56 @@
 			};
 		};
 
+		sdio0 {
+			sdio0_clk: sdio0-clk {
+				rockchip,pins = <4 25 RK_FUNC_1 &pcfg_pull_none>;
+			};
+
+			sdio0_cmd: sdio0-cmd {
+				rockchip,pins = <4 24 RK_FUNC_1 &pcfg_pull_up>;
+			};
+
+			sdio0_pwr: sdio0-pwr {
+				rockchip,pins = <4 28 RK_FUNC_1 &pcfg_pull_up>;
+			};
+
+			sdio0_bus1: sdio0-bus1 {
+				rockchip,pins = <4 20 RK_FUNC_1 &pcfg_pull_up>;
+			};
+
+			sdio0_bus4: sdio0-bus4 {
+				rockchip,pins = <4 20 RK_FUNC_1 &pcfg_pull_up>,
+						<4 21 RK_FUNC_1 &pcfg_pull_up>,
+						<4 22 RK_FUNC_1 &pcfg_pull_up>,
+						<4 23 RK_FUNC_1 &pcfg_pull_up>;
+			};
+		};
+
+		sdio1 {
+			sdio1_clk: sdio1-clk {
+				rockchip,pins = <4 7 RK_FUNC_4 &pcfg_pull_none>;
+			};
+
+			sdio1_cmd: sdio1-cmd {
+				rockchip,pins = <4 6 RK_FUNC_4 &pcfg_pull_up>;
+			};
+
+			sdio1_pwr: sdio1-pwr {
+				rockchip,pins = <4 9 RK_FUNC_4 &pcfg_pull_up>;
+			};
+
+			sdio1_bus1: sdio1-bus1 {
+				rockchip,pins = <4 24 RK_FUNC_4 &pcfg_pull_up>;
+			};
+
+			sdio1_bus4: sdio1-bus4 {
+				rockchip,pins = <3 24 RK_FUNC_4 &pcfg_pull_up>,
+						<3 25 RK_FUNC_4 &pcfg_pull_up>,
+						<3 26 RK_FUNC_4 &pcfg_pull_up>,
+						<3 27 RK_FUNC_4 &pcfg_pull_up>;
+			};
+		};
+
 		emmc {
 			emmc_clk: emmc-clk {
 				rockchip,pins = <3 18 RK_FUNC_2 &pcfg_pull_none>;
-- 
1.8.3.2


