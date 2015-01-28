Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbbA2JAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:00:16 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754970AbbA2JAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:06 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 152/176] ARM: dts: imx25: Fix PWM "per" clocks
Date: Wed, 28 Jan 2015 15:29:42 +0100
Message-Id: <b9b27df6e95bfe205a5fca8956d18e590686c424.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7ecd0bde5bfea524a843ad8fa8cb66ccbce68779 upstream.

Currently PWM functionality is broken on mx25 due to the wrong assignment of the
PWM "per" clock.

According to Documentation/devicetree/bindings/clock/imx25-clock.txt:
	pwm_ipg_per		52

,so update the pwm "per" to use 'pwm_ipg_per' instead of 'per10' clock.

With this change PWM can work fine on mx25.

Reported-by: Carlos Soto <csotoalonso@gmail.com>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/boot/dts/imx25.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/imx25.dtsi b/arch/arm/boot/dts/imx25.dtsi
index 6a26e79f0ef4..cf3300a3071d 100644
--- a/arch/arm/boot/dts/imx25.dtsi
+++ b/arch/arm/boot/dts/imx25.dtsi
@@ -352,7 +352,7 @@
 				compatible = "fsl,imx25-pwm", "fsl,imx27-pwm";
 				#pwm-cells = <2>;
 				reg = <0x53fa0000 0x4000>;
-				clocks = <&clks 106>, <&clks 36>;
+				clocks = <&clks 106>, <&clks 52>;
 				clock-names = "ipg", "per";
 				interrupts = <36>;
 			};
@@ -371,7 +371,7 @@
 				compatible = "fsl,imx25-pwm", "fsl,imx27-pwm";
 				#pwm-cells = <2>;
 				reg = <0x53fa8000 0x4000>;
-				clocks = <&clks 107>, <&clks 36>;
+				clocks = <&clks 107>, <&clks 52>;
 				clock-names = "ipg", "per";
 				interrupts = <41>;
 			};
@@ -412,7 +412,7 @@
 			pwm4: pwm@53fc8000 {
 				compatible = "fsl,imx25-pwm", "fsl,imx27-pwm";
 				reg = <0x53fc8000 0x4000>;
-				clocks = <&clks 108>, <&clks 36>;
+				clocks = <&clks 108>, <&clks 52>;
 				clock-names = "ipg", "per";
 				interrupts = <42>;
 			};
@@ -458,7 +458,7 @@
 				compatible = "fsl,imx25-pwm", "fsl,imx27-pwm";
 				#pwm-cells = <2>;
 				reg = <0x53fe0000 0x4000>;
-				clocks = <&clks 105>, <&clks 36>;
+				clocks = <&clks 105>, <&clks 52>;
 				clock-names = "ipg", "per";
 				interrupts = <26>;
 			};
-- 
2.2.2

