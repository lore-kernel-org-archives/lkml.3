Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbaEPKqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 06:46:33 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54338 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756907AbaEPKq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 06:46:27 -0400
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Mike Turquette <mturquette@linaro.org>, Tero Kristo <t-kristo@ti.com>,
        Paul <paul@pwsan.com>
CC: Nishanth Menon <nm@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>
Subject: [PATCH 3/3] ARM: dts: OMAP5/DRA7: use omap5-mpu-dpll-clock capable of dealing with higher frequencies
Date: Fri, 16 May 2014 05:46:00 -0500
Message-ID: <1400237160-25125-4-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400237160-25125-1-git-send-email-nm@ti.com>
References: <1400237160-25125-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP5432, DRA75x and DRA72x have MPU DPLLs that need Duty Cycle
Correction(DCC) to operate safely at frequencies >= 1.4GHz.

Switch to "ti,omap5-mpu-dpll-clock" compatible property which provides
this support.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/dra7xx-clocks.dtsi   |    2 +-
 arch/arm/boot/dts/omap54xx-clocks.dtsi |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/dra7xx-clocks.dtsi b/arch/arm/boot/dts/dra7xx-clocks.dtsi
index cfb8fc7..aac5522 100644
--- a/arch/arm/boot/dts/dra7xx-clocks.dtsi
+++ b/arch/arm/boot/dts/dra7xx-clocks.dtsi
@@ -277,7 +277,7 @@
 
 	dpll_mpu_ck: dpll_mpu_ck {
 		#clock-cells = <0>;
-		compatible = "ti,omap4-dpll-clock";
+		compatible = "ti,omap5-mpu-dpll-clock";
 		clocks = <&sys_clkin1>, <&mpu_dpll_hs_clk_div>;
 		reg = <0x0160>, <0x0164>, <0x016c>, <0x0168>;
 	};
diff --git a/arch/arm/boot/dts/omap54xx-clocks.dtsi b/arch/arm/boot/dts/omap54xx-clocks.dtsi
index d487fda..465505c 100644
--- a/arch/arm/boot/dts/omap54xx-clocks.dtsi
+++ b/arch/arm/boot/dts/omap54xx-clocks.dtsi
@@ -362,7 +362,7 @@
 
 	dpll_mpu_ck: dpll_mpu_ck {
 		#clock-cells = <0>;
-		compatible = "ti,omap4-dpll-clock";
+		compatible = "ti,omap5-mpu-dpll-clock";
 		clocks = <&sys_clkin>, <&mpu_dpll_hs_clk_div>;
 		reg = <0x0160>, <0x0164>, <0x016c>, <0x0168>;
 	};
-- 
1.7.9.5

