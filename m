Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab3IYQNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:13:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38953 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753492Ab3IYQNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:13:06 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        Emilio Lopez <emilio@elopez.com.ar>, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 3/5] ARM: sun5i: a10s: Add support for the High Speed Timers
Date: Wed, 25 Sep 2013 17:03:08 +0300
Message-Id: <1380117790-19390-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380117790-19390-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1380117790-19390-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A10s has support for two high speed timers. Now that we
have a driver to support it, we can enable them in the device tree.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun5i-a10s.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/sun5i-a10s.dtsi b/arch/arm/boot/dts/sun5i-a10s.dtsi
index 5247674..317490c 100644
--- a/arch/arm/boot/dts/sun5i-a10s.dtsi
+++ b/arch/arm/boot/dts/sun5i-a10s.dtsi
@@ -332,5 +332,12 @@
 			clock-frequency = <100000>;
 			status = "disabled";
 		};
+
+		hstimer@01c60000 {
+			compatible = "allwinner,sun5i-a13-hstimer";
+			reg = <0x01c60000 0x1000>;
+			interrupts = <82>, <83>;
+			clocks = <&ahb_gates 28>;
+		};
 	};
 };
-- 
1.8.4

