Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941AbaDXTFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 15:05:31 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43975 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758886AbaDXTE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 15:04:27 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2 5/5] ARM: berlin/dt: add sdio clocks to BG2Q
Date: Thu, 24 Apr 2014 21:04:12 +0200
Message-Id: <1398366252-19582-6-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398366252-19582-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1398366252-19582-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sdio clocks to the berlin2q.dtsi
Also reorder the syspll node

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/berlin2q.dtsi | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
index 5925e6a16749..559819b89ea1 100644
--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -102,13 +102,6 @@
 			reg = <0xdd0170 0x8>;
 		};
 
-		syspll: syspll@ea0030 {
-			compatible = "marvell,berlin2q-pll";
-			clocks = <&smclk>;
-			#clock-cells = <0>;
-			reg = <0xea0030 0x8>;
-		};
-
 		apb@e80000 {
 			compatible = "simple-bus";
 			#address-cells = <1>;
@@ -191,6 +184,27 @@
 			};
 		};
 
+		syspll: syspll@ea0030 {
+			compatible = "marvell,berlin2q-pll";
+			clocks = <&smclk>;
+			#clock-cells = <0>;
+			reg = <0xea0030 0x8>;
+		};
+
+		sdio0xinclk: sdio0xinclk@ea0158 {
+			compatible = "marvell,berlin-clk";
+			clocks = <&syspll>;
+			#clock-cells = <0>;
+			reg = <0xea0158 0x4>;
+		};
+
+		sdio1xinclk: sdio1xinclk@ea015c {
+			compatible = "marvell,berlin-clk";
+			clocks = <&syspll>;
+			#clock-cells = <0>;
+			reg = <0xea015c 0x4>;
+		};
+
 		apb@fc0000 {
 			compatible = "simple-bus";
 			#address-cells = <1>;
-- 
1.9.1

