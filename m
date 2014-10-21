Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbaJUJZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:25:59 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:58010 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730AbaJUJW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:22:56 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 10/12] ARM: dts: berlin: Add SDHCI controller nodes to BG2/BG2CD
Date: Tue, 21 Oct 2014 11:22:42 +0200
Message-Id: <1413883364-681-11-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1413883364-681-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1413883364-681-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marvell Berlin BG2 has three, BG2CD just one pxav3 compatible
sdhci controllers, add them to the corresponding DT SoC
includes.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Chris Ball <chris@printf.net>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: "Antoine Ténart" <antoine.tenart@free-electrons.com>
Cc: linux-mmc@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/berlin2.dtsi   | 34 ++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/berlin2cd.dtsi |  9 +++++++++
 2 files changed, 43 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2.dtsi b/arch/arm/boot/dts/berlin2.dtsi
index 9d7c810ebd0b..504f1add1938 100644
--- a/arch/arm/boot/dts/berlin2.dtsi
+++ b/arch/arm/boot/dts/berlin2.dtsi
@@ -53,6 +53,35 @@
 
 		ranges = <0 0xf7000000 0x1000000>;
 
+		sdhci0: sdhci@ab0000 {
+			compatible = "mrvl,pxav3-mmc";
+			reg = <0xab0000 0x200>;
+			clocks = <&chip CLKID_SDIO0XIN>, <&chip CLKID_SDIO0>;
+			clock-names = "io", "core";
+			interrupts = <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
+			status = "disabled";
+		};
+
+		sdhci1: sdhci@ab0800 {
+			compatible = "mrvl,pxav3-mmc";
+			reg = <0xab0800 0x200>;
+			clocks = <&chip CLKID_SDIO1XIN>, <&chip CLKID_SDIO1>;
+			clock-names = "io", "core";
+			interrupts = <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
+			status = "disabled";
+		};
+
+		sdhci2: sdhci@ab1000 {
+			compatible = "mrvl,pxav3-mmc";
+			reg = <0xab1000 0x200>;
+			interrupts = <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&chip CLKID_NFC_ECC>, <&chip CLKID_NFC>;
+			clock-names = "io", "core";
+			pinctrl-0 = <&emmc_pmux>;
+			pinctrl-names = "default";
+			status = "disabled";
+		};
+
 		l2: l2-cache-controller@ac0000 {
 			compatible = "marvell,tauros3-cache", "arm,pl310-cache";
 			reg = <0xac0000 0x1000>;
@@ -252,6 +281,11 @@
 			reg = <0xea0000 0x400>;
 			clocks = <&refclk>;
 			clock-names = "refclk";
+
+			emmc_pmux: emmc-pmux {
+				groups = "G26";
+				function = "emmc";
+			};
 		};
 
 		apb@fc0000 {
diff --git a/arch/arm/boot/dts/berlin2cd.dtsi b/arch/arm/boot/dts/berlin2cd.dtsi
index cc1df65da504..5a19017b5d71 100644
--- a/arch/arm/boot/dts/berlin2cd.dtsi
+++ b/arch/arm/boot/dts/berlin2cd.dtsi
@@ -45,6 +45,15 @@
 
 		ranges = <0 0xf7000000 0x1000000>;
 
+		sdhci0: sdhci@ab0000 {
+			compatible = "mrvl,pxav3-mmc";
+			reg = <0xab0000 0x200>;
+			clocks = <&chip CLKID_SDIO0XIN>, <&chip CLKID_SDIO0>;
+			clock-names = "io", "core";
+			interrupts = <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
+			status = "disabled";
+		};
+
 		l2: l2-cache-controller@ac0000 {
 			compatible = "arm,pl310-cache";
 			reg = <0xac0000 0x1000>;
-- 
2.1.1

