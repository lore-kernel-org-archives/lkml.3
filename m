Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab3KNOXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 09:23:41 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:50269 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab3KNOXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 09:23:13 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, angus.clark@st.com,
        Lee Jones <lee.jones@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: [PATCH 10/10] ARM: STi: Add support for the FSM Serial Flash Controller
Date: Thu, 14 Nov 2013 14:22:36 +0000
Message-Id: <1384438956-31153-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1384438956-31153-1-git-send-email-lee.jones@linaro.org>
References: <1384438956-31153-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we add the necessary device nodes required for successful device
probing and Pinctrl setup for the FSM.

Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih416-b2105.dts    | 10 ++++++++++
 arch/arm/boot/dts/stih416-pinctrl.dtsi | 12 ++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/arm/boot/dts/stih416-b2105.dts b/arch/arm/boot/dts/stih416-b2105.dts
index f14eec3..29b09ab 100644
--- a/arch/arm/boot/dts/stih416-b2105.dts
+++ b/arch/arm/boot/dts/stih416-b2105.dts
@@ -32,6 +32,16 @@
 			status = "okay";
 		};
 
+		/* FSM */
+		spifsm: spifsm@fe902000{
+		        compatible      = "st,spi-fsm", "simple-bus";
+		        reg             =  <0xfe902000 0x1000>;
+		        reg-names       = "spi-fsm";
+		        pinctrl-0       = <&pinctrl_fsm>;
+
+		        status = "okay";
+		};
+
 		leds {
 			compatible	= "gpio-leds";
 			fp_led {
diff --git a/arch/arm/boot/dts/stih416-pinctrl.dtsi b/arch/arm/boot/dts/stih416-pinctrl.dtsi
index eb426a1..3106ea2 100644
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

