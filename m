Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965028Ab3GLNps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 09:45:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61557 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964853Ab3GLNoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 09:44:03 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>, Vinod Koul <vinod.koul@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH 8/8] ARM: shmobile: r8a7740: add DT nodes and clock aliases for three DMAC instances
Date: Fri, 12 Jul 2013 15:43:58 +0200
Message-Id: <1373636638-18496-9-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1373636638-18496-1-git-send-email-g.liakhovetski@gmx.de>
References: <1373636638-18496-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:aw0XiOM2hp6yzbLIcU9FoTG+hKxNZlvCVPs20JnJkDZ
 1o/7CssVCja5621/o+WCetrV7vdFuoAItCW4hjtBAvLsWPhxzE
 /IZTgEReODbF7IJF5ipi8j+CS8Az151X/TP8aHlZhefcqtkOPA
 IFOMC+dHLn0DjyemR8M4/Al50IgoMi8l6Xu3+Rtrm7qkSSxX1P
 oobJ6vDVNrUnmUAiUAQlscI79qSyNse+p72LqQkyAtihntoCzJ
 o1ybSMpORtQ18YauOa+y+UKyuI8BIp3gMz3PeVFcRL/dVZlU0w
 wqCFZjbQUQ1Of/HrONuHLL6oz4qxeM1MUGRkcTfelfl5Lkwxh0
 jNyaCul/Ghegef9qBhNaXoHOROQgo8Y+1+DG4TnihlRm++S8MI
 83eZzf2yinT7g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Device Tree support for the three generic DMA controller
instances on r8a7740 in a DMA multiplexer node.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 arch/arm/boot/dts/r8a7740.dtsi         |   61 ++++++++++++++++++++++++++++++++
 arch/arm/mach-shmobile/clock-r8a7740.c |    3 ++
 2 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/r8a7740.dtsi b/arch/arm/boot/dts/r8a7740.dtsi
index 25dc930..39b596f 100644
--- a/arch/arm/boot/dts/r8a7740.dtsi
+++ b/arch/arm/boot/dts/r8a7740.dtsi
@@ -112,6 +112,67 @@
 			      0 149 0x4>;
 	};
 
+	dmac: dma-mux0 {
+		compatible = "renesas,shdma-mux";
+		#dma-cells = <1>;
+		dma-channels = <6>;
+		dma-requests = <256>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		dma0: shdma@fe008020 {
+			compatible = "renesas,shdma-r8a7740";
+			reg = <0xfe008020 0x270>,
+				<0xfe009000 0xc>;
+			interrupt-parent = <&gic>;
+			interrupts = <0 34 4
+					0 28 4
+					0 29 4
+					0 30 4
+					0 31 4
+					0 32 4
+					0 33 4>;
+			interrupt-names = "error",
+					"ch0", "ch1", "ch2", "ch3",
+					"ch4", "ch5";
+		};
+
+		dma1: shdma@fe018020 {
+			compatible = "renesas,shdma-r8a7740";
+			reg = <0xfe018020 0x270>,
+				<0xfe019000 0xc>;
+			interrupt-parent = <&gic>;
+			interrupts = <0 41 4
+					0 35 4
+					0 36 4
+					0 37 4
+					0 38 4
+					0 39 4
+					0 40 4>;
+			interrupt-names = "error",
+					"ch0", "ch1", "ch2", "ch3",
+					"ch4", "ch5";
+		};
+
+		dma2: shdma@fe028020 {
+			compatible = "renesas,shdma-r8a7740";
+			reg = <0xfe028020 0x270>,
+				<0xfe029000 0xc>;
+			interrupt-parent = <&gic>;
+			interrupts = <0 48 4
+					0 42 4
+					0 43 4
+					0 44 4
+					0 45 4
+					0 46 4
+					0 47 4>;
+			interrupt-names = "error",
+					"ch0", "ch1", "ch2", "ch3",
+					"ch4", "ch5";
+		};
+	};
+
 	i2c0: i2c@fff20000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
diff --git a/arch/arm/mach-shmobile/clock-r8a7740.c b/arch/arm/mach-shmobile/clock-r8a7740.c
index 0abe58a..38ce209 100644
--- a/arch/arm/mach-shmobile/clock-r8a7740.c
+++ b/arch/arm/mach-shmobile/clock-r8a7740.c
@@ -576,8 +576,11 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_DEV_ID("e6cb0000.sci",		&mstp_clks[MSTP207]),
 	CLKDEV_DEV_ID("sh-dma-engine.3",	&mstp_clks[MSTP214]),
 	CLKDEV_DEV_ID("shdma-r8a7740.2",	&mstp_clks[MSTP216]),
+	CLKDEV_DEV_ID("fe028020.shdma",		&mstp_clks[MSTP216]),
 	CLKDEV_DEV_ID("shdma-r8a7740.1",	&mstp_clks[MSTP217]),
+	CLKDEV_DEV_ID("fe018020.shdma",		&mstp_clks[MSTP217]),
 	CLKDEV_DEV_ID("shdma-r8a7740.0",	&mstp_clks[MSTP218]),
+	CLKDEV_DEV_ID("fe008020.shdma",		&mstp_clks[MSTP218]),
 	CLKDEV_DEV_ID("sh-sci.7",		&mstp_clks[MSTP222]),
 	CLKDEV_DEV_ID("e6cd0000.sci",		&mstp_clks[MSTP222]),
 	CLKDEV_DEV_ID("sh-sci.6",		&mstp_clks[MSTP230]),
-- 
1.7.2.5

