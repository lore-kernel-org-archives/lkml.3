Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab3IYQNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:13:16 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38974 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756095Ab3IYQNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:13:14 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        Emilio Lopez <emilio@elopez.com.ar>, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 5/5] ARM: sun7i: a20: Add support for the High Speed Timers
Date: Wed, 25 Sep 2013 17:03:10 +0300
Message-Id: <1380117790-19390-6-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380117790-19390-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1380117790-19390-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A20 has support for four high speed timers. Apart for the
number of timers (4 vs 2), it's basically the same logic than the high
speed timers found in the sun5i chips.

Now that we have a driver to support it, we can enable them in the
device tree.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun7i-a20.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index e46cfed..ee6cec7 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -395,6 +395,16 @@
 			status = "disabled";
 		};
 
+		hstimer@01c60000 {
+			compatible = "allwinner,sun7i-a20-hstimer";
+			reg = <0x01c60000 0x1000>;
+			interrupts = <0 81 1>,
+				     <0 82 1>,
+				     <0 83 1>,
+				     <0 84 1>;
+			clocks = <&ahb_gates 28>;
+		};
+
 		gic: interrupt-controller@01c81000 {
 			compatible = "arm,cortex-a7-gic", "arm,cortex-a15-gic";
 			reg = <0x01c81000 0x1000>,
-- 
1.8.4

