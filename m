Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab3EHTG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 15:06:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59203 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012Ab3EHTG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 15:06:57 -0400
From: Nishanth Menon <nm@ti.com>
To: Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Mike Turquette <mturquette@linaro.org>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Nishanth Menon <nm@ti.com>, Paul Walmsley <paul@pwsan.com>
Subject: [PATCH V5 4/6] ARM: dts: AM33XX: add clock nodes for CPU
Date: Wed, 8 May 2013 14:06:14 -0500
Message-ID: <1368039976-29648-5-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368039976-29648-1-git-send-email-nm@ti.com>
References: <1368039976-29648-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AM33XX based platforms use dpll_mpu clock. Add same to common dtsi
and remove the dummy clock node entry as AM33XX platform supports
only device tree based boot.

Cc: Benoit Cousson <b-cousson@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
Change in this revision from previous:
	- rebase, no functional change.
Previous version: http://marc.info/?l=linux-kernel&m=136580755324232&w=2

 arch/arm/boot/dts/am33xx.dtsi         |    7 +++++++
 arch/arm/mach-omap2/cclock33xx_data.c |    1 -
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index d110110..27f6eb1 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -42,6 +42,8 @@
 				275000  1125000
 			>;
 			voltage-tolerance = <2>; /* 2 percentage */
+			clocks = <&dpll_mpu>;
+			clock-names = "cpu";
 			clock-latency = <300000>; /* From omap-cpufreq driver */
 		};
 	};
@@ -89,6 +91,11 @@
 			reg = <0x48200000 0x1000>;
 		};
 
+		dpll_mpu: dpll_mpu {
+			#clock-cells = <0>;
+			compatible = "ti,omap-clock";
+		};
+
 		gpio0: gpio@44e07000 {
 			compatible = "ti,omap4-gpio";
 			ti,hwmods = "gpio1";
diff --git a/arch/arm/mach-omap2/cclock33xx_data.c b/arch/arm/mach-omap2/cclock33xx_data.c
index 6ebc780..4e39171 100644
--- a/arch/arm/mach-omap2/cclock33xx_data.c
+++ b/arch/arm/mach-omap2/cclock33xx_data.c
@@ -860,7 +860,6 @@ static struct omap_clk am33xx_clks[] = {
 	CLK(NULL,	"dpll_core_m5_ck",	&dpll_core_m5_ck),
 	CLK(NULL,	"dpll_core_m6_ck",	&dpll_core_m6_ck),
 	CLK(NULL,	"dpll_mpu_ck",		&dpll_mpu_ck),
-	CLK("cpu0",	NULL,			&dpll_mpu_ck),
 	CLK(NULL,	"dpll_mpu_m2_ck",	&dpll_mpu_m2_ck),
 	CLK(NULL,	"dpll_ddr_ck",		&dpll_ddr_ck),
 	CLK(NULL,	"dpll_ddr_m2_ck",	&dpll_ddr_m2_ck),
-- 
1.7.9.5

