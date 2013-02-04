Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab3BDNlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:41:13 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15059 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab3BDNlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:41:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 04 Feb 2013 05:40:50 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] clocksource: tegra: move to of_clk_get
Date: Mon, 4 Feb 2013 15:40:30 +0200
Message-ID: <1359985230-11506-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new clockframework introduced DT IDs for each clock. To be able to remove
the device registrations, this driver needs to be updated to use the DT IDs.
Note that the actual removal of the clk_register_clkdev() calls will be done
in a later series.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/boot/dts/tegra20.dtsi      |    2 ++
 arch/arm/boot/dts/tegra30.dtsi      |    2 ++
 drivers/clocksource/tegra20_timer.c |    4 ++--
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 63b0d81..6e41a4f 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -144,6 +144,7 @@
 			      0 1 0x04
 			      0 41 0x04
 			      0 42 0x04>;
+		clocks = <&tegra_car 5>;
 	};
 
 	tegra_car: clock {
@@ -308,6 +309,7 @@
 		compatible = "nvidia,tegra20-rtc";
 		reg = <0x7000e000 0x100>;
 		interrupts = <0 2 0x04>;
+		clocks = <&tegra_car 4>;
 	};
 
 	i2c@7000c000 {
diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index 313fa71..7bc07e6 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -147,6 +147,7 @@
 			      0 42 0x04
 			      0 121 0x04
 			      0 122 0x04>;
+		clocks = <&tegra_car 5>;
 	};
 
 	tegra_car: clock {
@@ -295,6 +296,7 @@
 		compatible = "nvidia,tegra30-rtc", "nvidia,tegra20-rtc";
 		reg = <0x7000e000 0x100>;
 		interrupts = <0 2 0x04>;
+		clocks = <&tegra_car 4>;
 	};
 
 	i2c@7000c000 {
diff --git a/drivers/clocksource/tegra20_timer.c b/drivers/clocksource/tegra20_timer.c
index 5bc1429..546c537 100644
--- a/drivers/clocksource/tegra20_timer.c
+++ b/drivers/clocksource/tegra20_timer.c
@@ -189,7 +189,7 @@ static void __init tegra20_init_timer(void)
 		BUG();
 	}
 
-	clk = clk_get_sys("timer", NULL);
+	clk = of_clk_get(np, 0);
 	if (IS_ERR(clk)) {
 		pr_warn("Unable to get timer clock. Assuming 12Mhz input clock.\n");
 		rate = 12000000;
@@ -216,7 +216,7 @@ static void __init tegra20_init_timer(void)
 	 * rtc registers are used by read_persistent_clock, keep the rtc clock
 	 * enabled
 	 */
-	clk = clk_get_sys("rtc-tegra", NULL);
+	clk = of_clk_get(np, 0);
 	if (IS_ERR(clk))
 		pr_warn("Unable to get rtc-tegra clock\n");
 	else

