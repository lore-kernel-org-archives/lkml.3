Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab3L3KYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 05:24:03 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:58519 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630Ab3L3KTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 05:19:51 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@kernel.org, tglx@linutronix.de
Cc: axel.lin@ingics.com, ezequiel.garcia@free-electrons.com,
        jg1.han@samsung.com, laurent.pinchart+renesas@ideasonboard.com,
        linus.walleij@linaro.org, maxime.ripard@free-electrons.com,
        michael.opdenacker@free-electrons.com, sboyd@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 05/20] ARM: sun5i: a10s: Add support for the High Speed Timers
Date: Mon, 30 Dec 2013 11:19:24 +0100
Message-Id: <1388398779-11222-5-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1388398779-11222-1-git-send-email-daniel.lezcano@linaro.org>
References: <52C1479E.80808@linaro.org>
 <1388398779-11222-1-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Ripard <maxime.ripard@free-electrons.com>

The Allwinner A10s has support for two high speed timers. Now that we
have a driver to support it, we can enable them in the device tree.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Tested-by: Emilio López <emilio@elopez.com.ar>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/arm/boot/dts/sun5i-a10s.dtsi |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/sun5i-a10s.dtsi b/arch/arm/boot/dts/sun5i-a10s.dtsi
index 5247674..e674c94 100644
--- a/arch/arm/boot/dts/sun5i-a10s.dtsi
+++ b/arch/arm/boot/dts/sun5i-a10s.dtsi
@@ -332,5 +332,12 @@
 			clock-frequency = <100000>;
 			status = "disabled";
 		};
+
+		timer@01c60000 {
+			compatible = "allwinner,sun5i-a13-hstimer";
+			reg = <0x01c60000 0x1000>;
+			interrupts = <82>, <83>;
+			clocks = <&ahb_gates 28>;
+		};
 	};
 };
-- 
1.7.9.5

