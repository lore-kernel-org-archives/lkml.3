Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbaDPMk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 08:40:26 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47886 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755871AbaDPMkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 08:40:17 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, chris@printf.net, anton@enomsg.org
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] ARM: dts: berlin: add the SDHCI nodes for the BG2Q
Date: Wed, 16 Apr 2014 14:40:10 +0200
Message-Id: <1397652011-21284-4-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397652011-21284-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1397652011-21284-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the SDHCI nodes for the Marvell Berlin BG2Q, using the berlin-sdhci
driver.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 arch/arm/boot/dts/berlin2q.dtsi | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
index 5925e6a16749..8f897d461460 100644
--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -67,6 +67,14 @@
 		clock-div = <3>;
 	};
 
+	sdio1clk: sdio1clk {
+		compatible = "fixed-factor-clock";
+		#clock-cells = <0>;
+		clocks = <&syspll>;
+		clock-mult = <1>;
+		clock-div = <4>;
+	};
+
 	soc {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -75,6 +83,38 @@
 		ranges = <0 0xf7000000 0x1000000>;
 		interrupt-parent = <&gic>;
 
+		sdhci0: sdhci@ab0000 {
+			compatible = "marvell,berlin2q-sdhci";
+			reg = <0xab0000 0x200>;
+			clocks = <&sdio1clk>;
+			interrupts = <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
+			keep-power-in-suspend;
+			enable-sdio-wakeup;
+			broken-cd;
+			status = "disabled";
+		};
+
+		sdhci1: sdhci@ab0800 {
+			compatible = "marvell,berlin2q-sdhci";
+			reg = <0xab0800 0x200>;
+			clocks = <&sdio1clk>;
+			interrupts = <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
+			keep-power-in-suspend;
+			enable-sdio-wakeup;
+			status = "disabled";
+		};
+
+		sdhci2: sdhci@ab1000 {
+			compatible = "marvell,berlin2q-sdhci";
+			reg = <0xab1000 0x200>;
+			interrupts = <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&sdio1clk>;
+			keep-power-in-suspend;
+			enable-sdio-wakeup;
+			broken-cd;
+			status = "disabled";
+		};
+
 		l2: l2-cache-controller@ac0000 {
 			compatible = "arm,pl310-cache";
 			reg = <0xac0000 0x1000>;
-- 
1.8.3.2

