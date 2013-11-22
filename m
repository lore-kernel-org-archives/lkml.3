Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab3KVQXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:23:54 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:61533 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab3KVQXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:23:51 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org, angus.clark@st.com
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 11/23] ARM: STi: Add support for the FSM Serial Flash Controller
Date: Fri, 22 Nov 2013 16:22:48 +0000
Message-Id: <1385137380-28968-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385137380-28968-1-git-send-email-lee.jones@linaro.org>
References: <1385137380-28968-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we add the necessary device nodes required for successful device
probing and Pinctrl setup for the FSM.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih416-b2105.dts    | 14 ++++++++++++++
 arch/arm/boot/dts/stih416-pinctrl.dtsi | 12 ++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/arch/arm/boot/dts/stih416-b2105.dts b/arch/arm/boot/dts/stih416-b2105.dts
index e518eb0..7acdfdf 100644
--- a/arch/arm/boot/dts/stih416-b2105.dts
+++ b/arch/arm/boot/dts/stih416-b2105.dts
@@ -33,6 +33,20 @@
 			status = "okay";
 		};
 
+		/* FSM */
+		spifsm: spifsm@fe902000{
+		        compatible         = "st,spi-fsm", "simple-bus";
+		        reg                =  <0xfe902000 0x1000>;
+		        reg-names          = "spi-fsm";
+		        pinctrl-0          = <&pinctrl_fsm>;
+
+			st,syscfg	   = <&syscfg_rear>;
+		        st,boot-device-reg = <0x958>;
+		        st,boot-device-spi = <0x1a>;
+
+		        status = "okay";
+		};
+
 		leds {
 			compatible	= "gpio-leds";
 			fp_led {
diff --git a/arch/arm/boot/dts/stih416-pinctrl.dtsi b/arch/arm/boot/dts/stih416-pinctrl.dtsi
index 10bb4df..9a48710 100644
--- a/arch/arm/boot/dts/stih416-pinctrl.dtsi
+++ b/arch/arm/boot/dts/stih416-pinctrl.dtsi
@@ -235,6 +235,18 @@
 				};
 			};
 
+			fsm {
+				pinctrl_fsm: fsm {
+					st,pins {
+						spi-fsm-clk     = <&PIO12 2     OUT     ALT1>;
+						spi-fsm-cs      = <&PIO12 3     OUT     ALT1>;
+						spi-fsm-mosi    = <&PIO12 4     OUT     ALT1>;
+						spi-fsm-miso    = <&PIO12 5     IN      ALT1>;
+						spi-fsm-hol     = <&PIO12 6     OUT     ALT1>;
+						spi-fsm-wp      = <&PIO12 7     OUT     ALT1>;
+					};
+				};
+			};
 		};
 
 		pin-controller-rear {
-- 
1.8.1.2

