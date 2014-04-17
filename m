Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbaDQJKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:10:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54648 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752463AbaDQJKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:10:07 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v3 2/2] ARM: sun6i: a31: Add support for the High Speed Timers
Date: Thu, 17 Apr 2014 11:06:46 +0200
Message-Id: <1397725606-18000-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397725606-18000-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1397725606-18000-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A31 has support for four high speed timers. Apart for the
number of timers (4 vs 2), it's basically the same logic than the high
speed timers found in the sun5i chips.

Now that we have a driver to support it, we can enable them in the
device tree.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun6i-a31.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index bc46814d2ff0..2af6ca205cc2 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -428,6 +428,17 @@
 			status = "disabled";
 		};
 
+		timer@01c60000 {
+			compatible = "allwinner,sun6i-a31-hstimer", "allwinner,sun7i-a20-hstimer";
+			reg = <0x01c60000 0x1000>;
+			interrupts = <0 51 4>,
+				     <0 52 4>,
+				     <0 53 4>,
+				     <0 54 4>;
+			clocks = <&ahb1_gates 19>;
+			resets = <&ahb1_rst 19>;
+		};
+
 		spi0: spi@01c68000 {
 			compatible = "allwinner,sun6i-a31-spi";
 			reg = <0x01c68000 0x1000>;
-- 
1.9.1

