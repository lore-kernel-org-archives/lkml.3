Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbaCMPN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:13:26 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51024 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417AbaCMPNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:13:20 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC: <balbi@ti.com>, <rogerq@ti.com>, <kishon@ti.com>, <rob@landley.net>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        <tony@atomide.com>, <anatol.pomozov@gmail.com>,
        <bcousson@baylibre.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH v4 2/5] ARM: dts: am43xx clock data
Date: Thu, 13 Mar 2014 20:41:13 +0530
Message-ID: <1394723476-8580-3-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1394723476-8580-1-git-send-email-george.cherian@ti.com>
References: <1394723476-8580-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add USB and USB PHY reference clock data

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 arch/arm/boot/dts/am43xx-clocks.dtsi | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/arm/boot/dts/am43xx-clocks.dtsi b/arch/arm/boot/dts/am43xx-clocks.dtsi
index 142009c..c74d45c 100644
--- a/arch/arm/boot/dts/am43xx-clocks.dtsi
+++ b/arch/arm/boot/dts/am43xx-clocks.dtsi
@@ -653,4 +653,36 @@
 		clocks = <&clk_32768_ck>, <&clk_32k_tpm_ck>;
 		reg = <0x4260>;
 	};
+
+	usb_phy0_always_on_clk32k: usb_phy0_always_on_clk32k {
+		#clock-cells = <0>;
+		compatible = "fixed-factor-clock";
+		clocks = <&clk_32768_ck>;
+		clock-mult = <1>;
+		clock-div = <1>;
+	};
+
+	usb_phy1_always_on_clk32k: usb_phy1_always_on_clk32k {
+		#clock-cells = <0>;
+		compatible = "fixed-factor-clock";
+		clocks = <&clk_32768_ck>;
+		clock-mult = <1>;
+		clock-div = <1>;
+	};
+
+	usb_otg_ss0_refclk960m: usb_otg_ss0_refclk960m {
+		#clock-cells = <0>;
+	        compatible = "ti,gate-clock";
+		clocks = <&dpll_per_clkdcoldo>;
+	        ti,bit-shift = <8>;
+	        reg = <0x8a60>;
+	};
+
+	usb_otg_ss1_refclk960m: usb_otg_ss1_refclk960m {
+		#clock-cells = <0>;
+	        compatible = "ti,gate-clock";
+		clocks = <&dpll_per_clkdcoldo>;
+	        ti,bit-shift = <8>;
+		reg = <0x8a68>;
+	};
 };
-- 
1.8.3.1

