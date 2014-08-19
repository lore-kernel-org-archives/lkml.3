Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaHSCcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 22:32:12 -0400
Received: from regular1.263xmail.com ([211.150.99.140]:38194 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbaHSCcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 22:32:11 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <1b2666bacb839ed505aaeca76ee1eac9>
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
        zhangqing@rock-chips.com, hl@rock-chips.com,
        Addy Ke <addy.ke@rock-chips.com>
Subject: [PATCH v2] ARM: dts: Add sdio0 and sdio1 to the rk3288
Date: Tue, 19 Aug 2014 10:31:52 +0800
Message-Id: <1408415512-17275-1-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1407995360-26009-1-git-send-email-addy.ke@rock-chips.com>
References: <1407995360-26009-1-git-send-email-addy.ke@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch requires that <https://patchwork.kernel.org/patch/4701721/>
land in order to compile.

Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
---
Changes in v2:
- repost patch to match what's in Heiko's "wip/v3.18-next/dts" tree
  for the other dwmmc controllers
- add "cd" and "int" line, suggested by Doug Anderson
- fix up sdio1 configuration error 

 arch/arm/boot/dts/rk3288.dtsi | 86 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 36be7bb..91576ae 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -88,6 +88,26 @@
 		status = "disabled";
 	};
 
+	sdio0: dwmmc@ff0d0000 {
+		compatible = "rockchip,rk3288-dw-mshc";
+		clocks = <&cru HCLK_SDIO0>, <&cru SCLK_SDIO0>;
+		clock-names = "biu", "ciu";
+		fifo-depth = <0x100>;
+		interrupts = <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>;
+		reg = <0xff0d0000 0x4000>;
+		status = "disabled";
+	};
+
+	sdio1: dwmmc@ff0e0000 {
+		compatible = "rockchip,rk3288-dw-mshc";
+		clocks = <&cru HCLK_SDIO1>, <&cru SCLK_SDIO1>;
+		clock-names = "biu", "ciu";
+		fifo-depth = <0x100>;
+		interrupts = <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>;
+		reg = <0xff0e0000 0x4000>;
+		status = "disabled";
+	};
+
 	emmc: dwmmc@ff0f0000 {
 		compatible = "rockchip,rk3288-dw-mshc";
 		clocks = <&cru HCLK_EMMC>, <&cru SCLK_EMMC>;
@@ -508,6 +528,72 @@
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
+			sdio0_cd: sdio0-cd {
+				rockchip,pins = <4 26 RK_FUNC_1 &pcfg_pull_up>;
+			};
+
+			sdio0_pwr: sdio0-pwr {
+				rockchip,pins = <4 28 RK_FUNC_1 &pcfg_pull_up>;
+			};
+
+			sdio0_int: sdio0-int {
+				rockchip,pins = <4 30 RK_FUNC_1 &pcfg_pull_up>;
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
+			sdio1_cd: sdio1-cd {
+				rockchip,pins = <3 28 RK_FUNC_4 &pcfg_pull_up>;
+			};
+
+			sdio1_pwr: sdio1-pwr {
+				rockchip,pins = <4 9 RK_FUNC_4 &pcfg_pull_up>;
+			};
+
+			sdio1_int: sdio1-int {
+				rockchip,pins = <3 31 RK_FUNC_4 &pcfg_pull_up>;
+			};
+
+			sdio1_bus1: sdio1-bus1 {
+				rockchip,pins = <3 24 RK_FUNC_4 &pcfg_pull_up>;
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


