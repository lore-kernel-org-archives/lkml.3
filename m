Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab3JYNKI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:10:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54944 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754527Ab3JYNKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:10:06 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: daniel.lezcano@linaro.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        sboyd@codeaurora.org, kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 5/5] ARM: sun7i: a20: Add support for the High Speed Timers
Date: Fri, 25 Oct 2013 14:07:43 +0100
Message-Id: <1382706463-3892-6-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1382706463-3892-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1382706463-3892-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A20 has support for four high speed timers. Apart for the
number of timers (4 vs 2), it's basically the same logic than the high
speed timers found in the sun5i chips.

Now that we have a driver to support it, we can enable them in the
device tree.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Tested-by: Emilio López <emilio@elopez.com.ar>
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

