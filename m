Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbaIZNOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 09:14:32 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:36013 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbaIZNO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 09:14:29 -0400
From: Sanchayan Maity <maitysanchayan@gmail.com>
To: kernel@pengutronix.de, a.zummo@towertech.it
Cc: b35083@freescale.com, rtc-linux@googlegroups.com, shawn.guo@freescale.com,
        stefan@agner.ch, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sanchayan Maity <maitysanchayan@gmail.com>
Subject: [PATCH 2/3] ARM: dts: vf610: Add SNVS node
Date: Fri, 26 Sep 2014 18:44:00 +0530
Message-Id: <49cb7f5fc8319fc47dc2919a2ccbff981196d4ff.1411736171.git.maitysanchayan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1411736171.git.maitysanchayan@gmail.com>
References: <cover.1411736171.git.maitysanchayan@gmail.com>
In-Reply-To: <cover.1411736171.git.maitysanchayan@gmail.com>
References: <cover.1411736171.git.maitysanchayan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a devicetree node for RTC support
for the VF610 platform.

Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
---
 arch/arm/boot/dts/vf610.dtsi |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
index 4d2ec32..3c0c757 100644
--- a/arch/arm/boot/dts/vf610.dtsi
+++ b/arch/arm/boot/dts/vf610.dtsi
@@ -381,6 +381,21 @@
 					<&clks VF610_CLK_DMAMUX3>;
 			};
 
+			snvs0: snvs@400a7000 {
+				compatible = "fsl,sec-v4.0-mon", "simple-bus";
+				#address-cells = <1>;
+				#size-cells = <1>;
+				ranges = <0 0x400a7000 0x2000>;
+
+				snvs-rtc-lp@34 {
+					compatible = "fsl,sec-v4.0-mon-rtc-lp";
+					reg = <0x34 0x58>;
+					interrupts = <0 100 IRQ_TYPE_LEVEL_HIGH>;
+					clocks = <&clks VF610_CLK_SNVS>;
+					clock-names = "snvs";
+				};
+			};
+
 			uart4: serial@400a9000 {
 				compatible = "fsl,vf610-lpuart";
 				reg = <0x400a9000 0x1000>;
-- 
1.7.9.5

