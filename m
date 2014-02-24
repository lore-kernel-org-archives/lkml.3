Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbaBXQZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:25:35 -0500
Received: from top.free-electrons.com ([176.31.233.9]:54505 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753161AbaBXQZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:25:10 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 5/5] ARM: sun6i: dt: Add A31 DMA controller to DTSI
Date: Mon, 24 Feb 2014 17:22:47 +0100
Message-Id: <1393258967-4843-6-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393258967-4843-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1393258967-4843-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have a DMA driver, we can add the DMA bindings in the DTSI for the
controller and the devices supported that can use DMA.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun6i-a31.dtsi | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index af6f87c..ad6476a 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -237,6 +237,15 @@
 		#size-cells = <1>;
 		ranges;
 
+		dma: dma-controller@01c02000 {
+			compatible = "allwinner,sun6i-a31-dma";
+			reg = <0x01c02000 0x1000>;
+			interrupts = <0 50 4>;
+			clocks = <&ahb1_gates 6>;
+			resets = <&ahb1_rst 6>;
+			#dma-cells = <1>;
+		};
+
 		pio: pinctrl@01c20800 {
 			compatible = "allwinner,sun6i-a31-pinctrl";
 			reg = <0x01c20800 0x400>;
@@ -301,6 +310,8 @@
 			reg-io-width = <4>;
 			clocks = <&apb2_gates 16>;
 			resets = <&apb2_rst 16>;
+			dmas = <&dma 6>, <&dma 6>;
+			dma-names = "rx", "tx";
 			status = "disabled";
 		};
 
@@ -312,6 +323,8 @@
 			reg-io-width = <4>;
 			clocks = <&apb2_gates 17>;
 			resets = <&apb2_rst 17>;
+			dmas = <&dma 7>, <&dma 7>;
+			dma-names = "rx", "tx";
 			status = "disabled";
 		};
 
@@ -323,6 +336,8 @@
 			reg-io-width = <4>;
 			clocks = <&apb2_gates 18>;
 			resets = <&apb2_rst 18>;
+			dmas = <&dma 8>, <&dma 8>;
+			dma-names = "rx", "tx";
 			status = "disabled";
 		};
 
@@ -334,6 +349,8 @@
 			reg-io-width = <4>;
 			clocks = <&apb2_gates 19>;
 			resets = <&apb2_rst 19>;
+			dmas = <&dma 9>, <&dma 9>;
+			dma-names = "rx", "tx";
 			status = "disabled";
 		};
 
@@ -345,6 +362,8 @@
 			reg-io-width = <4>;
 			clocks = <&apb2_gates 20>;
 			resets = <&apb2_rst 20>;
+			dmas = <&dma 10>, <&dma 10>;
+			dma-names = "rx", "tx";
 			status = "disabled";
 		};
 
@@ -356,6 +375,8 @@
 			reg-io-width = <4>;
 			clocks = <&apb2_gates 21>;
 			resets = <&apb2_rst 21>;
+			dmas = <&dma 22>, <&dma 22>;
+			dma-names = "rx", "tx";
 			status = "disabled";
 		};
 
@@ -365,6 +386,8 @@
 			interrupts = <0 65 4>;
 			clocks = <&ahb1_gates 20>, <&spi0_clk>;
 			clock-names = "ahb", "mod";
+			dmas = <&dma 23>, <&dma 23>;
+			dma-names = "rx", "tx";
 			resets = <&ahb1_rst 20>;
 			status = "disabled";
 		};
@@ -375,6 +398,8 @@
 			interrupts = <0 66 4>;
 			clocks = <&ahb1_gates 21>, <&spi1_clk>;
 			clock-names = "ahb", "mod";
+			dmas = <&dma 24>, <&dma 24>;
+			dma-names = "rx", "tx";
 			resets = <&ahb1_rst 21>;
 			status = "disabled";
 		};
@@ -385,6 +410,8 @@
 			interrupts = <0 67 4>;
 			clocks = <&ahb1_gates 22>, <&spi2_clk>;
 			clock-names = "ahb", "mod";
+			dmas = <&dma 25>, <&dma 25>;
+			dma-names = "rx", "tx";
 			resets = <&ahb1_rst 22>;
 			status = "disabled";
 		};
@@ -395,6 +422,8 @@
 			interrupts = <0 68 4>;
 			clocks = <&ahb1_gates 23>, <&spi3_clk>;
 			clock-names = "ahb", "mod";
+			dmas = <&dma 26>, <&dma 26>;
+			dma-names = "rx", "tx";
 			resets = <&ahb1_rst 23>;
 			status = "disabled";
 		};
-- 
1.9.0

