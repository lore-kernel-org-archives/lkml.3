Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaLDCuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 21:50:10 -0500
Received: from regular1.263xmail.com ([211.150.99.139]:60538 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbaLDCuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 21:50:08 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <b23583bbd36d81664cef331d16dabec0>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Addy Ke <addy.ke@rock-chips.com>
To: heiko@sntech.de, dianders@chromium.org, amstan@chromium.org,
        sonnyrao@chromium.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org
Cc: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org, olof@lixom.net, hj@rock-chips.com,
        kever.yang@rock-chips.com, xjq@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, zhangqing@rock-chips.com, hl@rock-chips.com,
        wei.luo@rock-chips.com, Addy Ke <addy.ke@rock-chips.com>
Subject: [PATCH] ARM: dts: rockchip: set dw_mmc max-freq 150Mhz
Date: Thu,  4 Dec 2014 10:49:35 +0800
Message-Id: <1417661375-2872-1-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of mmc controllers include SDMMC, SDIO0, SDIO1, and EMMC on RK3288
are limited to 150Mhz. It was mainly caused by two reasons:
- RK3288's IO pad(except DDR IO pad) is generic, which can only support
  the max of 150Mhz.
- Mmc controller was designed at 150Mhz, and the pressure test by IC team
  was based on this freequency point.

Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
---
 arch/arm/boot/dts/rk3288.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index acb6a2f..9c35a1d 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -149,6 +149,7 @@
 
 	sdmmc: dwmmc@ff0c0000 {
 		compatible = "rockchip,rk3288-dw-mshc";
+		clock-freq-min-max = <400000 150000000>;
 		clocks = <&cru HCLK_SDMMC>, <&cru SCLK_SDMMC>;
 		clock-names = "biu", "ciu";
 		fifo-depth = <0x100>;
@@ -159,6 +160,7 @@
 
 	sdio0: dwmmc@ff0d0000 {
 		compatible = "rockchip,rk3288-dw-mshc";
+		clock-freq-min-max = <400000 150000000>;
 		clocks = <&cru HCLK_SDIO0>, <&cru SCLK_SDIO0>;
 		clock-names = "biu", "ciu";
 		fifo-depth = <0x100>;
@@ -169,6 +171,7 @@
 
 	sdio1: dwmmc@ff0e0000 {
 		compatible = "rockchip,rk3288-dw-mshc";
+		clock-freq-min-max = <400000 150000000>;
 		clocks = <&cru HCLK_SDIO1>, <&cru SCLK_SDIO1>;
 		clock-names = "biu", "ciu";
 		fifo-depth = <0x100>;
@@ -179,6 +182,7 @@
 
 	emmc: dwmmc@ff0f0000 {
 		compatible = "rockchip,rk3288-dw-mshc";
+		clock-freq-min-max = <400000 150000000>;
 		clocks = <&cru HCLK_EMMC>, <&cru SCLK_EMMC>;
 		clock-names = "biu", "ciu";
 		fifo-depth = <0x100>;
-- 
1.8.3.2


