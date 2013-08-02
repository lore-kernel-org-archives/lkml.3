Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab3HBOvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:51:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49845 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab3HBOuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:50:51 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH v5 6/7] ARM: shmobile: r8a73a4: add a DT node and a clock alias for the DMAC
Date: Fri,  2 Aug 2013 16:50:41 +0200
Message-Id: <1375455042-24093-7-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1375455042-24093-1-git-send-email-g.liakhovetski@gmx.de>
References: <1375455042-24093-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:Df3aRJcnTJR2zWd6OPpqM5N9YcU27QeSftKaE2POwCx
 9B6m0x9NSS6ckzErvqnkWSOg54y1+vxWP14YkD16PZrNWE8Lhy
 wdkjIbiDEtjtYN+vsyZDRDcG9EoEw3tm7XGJaaFuB3otmnKtGL
 b/VCqc9Qxt0KIgQxYyT6IC2CVv9hR3nXiYZJkz4Bnug0qS9URj
 a0cLMHxVutOpy+GduAjtAiMUYYaz7pGE3jJXi4BSPphXBjSdR1
 cNavXreqhzX8ydD7zOfSluJs6W28GTNGADgHVbLQoRVFquidZN
 BABpPXqx/gwe+2FJcEcDIB8Af+o6JSANUk/s2Ist34s4bazOBF
 aVXLukI3OG0duWedmRXPdctowoN9LwO2yDkJ3h+T8E3OZan2e0
 tlFu9BUxaQW3g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a DT node for the only system DMAC instance on r8a73a4. The RT DMAC
can be added later under the same multiplexer, because they can serve the
same slaves and use the same MID-RID values. Configuration data is
supplied to the driver, using a compatibility match string.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 arch/arm/boot/dts/r8a73a4.dtsi         |   43 ++++++++++++++++++++++++++++++++
 arch/arm/mach-shmobile/clock-r8a73a4.c |    1 +
 2 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/r8a73a4.dtsi b/arch/arm/boot/dts/r8a73a4.dtsi
index e344b10..3c9c7f2 100644
--- a/arch/arm/boot/dts/r8a73a4.dtsi
+++ b/arch/arm/boot/dts/r8a73a4.dtsi
@@ -78,6 +78,49 @@
 				<0 56 4>, <0 57 4>;
 	};
 
+	dmac: dma-multiplexer@0 {
+		compatible = "renesas,shdma-mux";
+		#dma-cells = <1>;
+		dma-channels = <20>;
+		dma-requests = <256>;
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
+
+		dma0: dma-controller@e6700020 {
+			compatible = "renesas,shdma-r8a73a4";
+			reg = <0 0xe6700020 0 0x89e0>;
+			interrupt-parent = <&gic>;
+			interrupts = <0 220 4
+					0 200 4
+					0 201 4
+					0 202 4
+					0 203 4
+					0 204 4
+					0 205 4
+					0 206 4
+					0 207 4
+					0 208 4
+					0 209 4
+					0 210 4
+					0 211 4
+					0 212 4
+					0 213 4
+					0 214 4
+					0 215 4
+					0 216 4
+					0 217 4
+					0 218 4
+					0 219 4>;
+			interrupt-names = "error",
+					"ch0", "ch1", "ch2", "ch3",
+					"ch4", "ch5", "ch6", "ch7",
+					"ch8", "ch9", "ch10", "ch11",
+					"ch12", "ch13", "ch14", "ch15",
+					"ch16", "ch17", "ch18", "ch19";
+		};
+	};
+
 	thermal@e61f0000 {
 		compatible = "renesas,rcar-thermal";
 		reg = <0 0xe61f0000 0 0x14>, <0 0xe61f0100 0 0x38>,
diff --git a/arch/arm/mach-shmobile/clock-r8a73a4.c b/arch/arm/mach-shmobile/clock-r8a73a4.c
index 357b9bc..74841ed 100644
--- a/arch/arm/mach-shmobile/clock-r8a73a4.c
+++ b/arch/arm/mach-shmobile/clock-r8a73a4.c
@@ -580,6 +580,7 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_DEV_ID("sh-sci.4", &mstp_clks[MSTP216]),
 	CLKDEV_DEV_ID("sh-sci.5", &mstp_clks[MSTP217]),
 	CLKDEV_DEV_ID("sh-dma-engine.0", &mstp_clks[MSTP218]),
+	CLKDEV_DEV_ID("e6700020.dma-controller", &mstp_clks[MSTP218]),
 	CLKDEV_DEV_ID("rcar_thermal", &mstp_clks[MSTP522]),
 	CLKDEV_DEV_ID("e6520000.i2c", &mstp_clks[MSTP300]),
 	CLKDEV_DEV_ID("sh_mmcif.1", &mstp_clks[MSTP305]),
-- 
1.7.2.5

