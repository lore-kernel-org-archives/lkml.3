Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760789AbaCULdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 07:33:18 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:53671 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760766AbaCULdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 07:33:16 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, srinivas.kandagatla@st.com
Subject: [PATCH RESEND for ARM-SoC 1/2] ARM: STi: stih416: Add support for the FSM Serial Flash Controller
Date: Fri, 21 Mar 2014 11:33:07 +0000
Message-Id: <1395401588-8825-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395401588-8825-1-git-send-email-lee.jones@linaro.org>
References: <1395401588-8825-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we add the necessary device nodes required for successful device
probing and Pinctrl setup for the FSM when booting on an STiH416 (Orly2).

Acked-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Acked-by Angus Clark <angus.clark@st.com>
Acked-by: Brian Norris <computersforpeace@gmail.com>
Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih416-pinctrl.dtsi | 13 +++++++++++++
 arch/arm/boot/dts/stih416.dtsi         | 13 +++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/arch/arm/boot/dts/stih416-pinctrl.dtsi b/arch/arm/boot/dts/stih416-pinctrl.dtsi
index b29ff4b..81df8e7 100644
--- a/arch/arm/boot/dts/stih416-pinctrl.dtsi
+++ b/arch/arm/boot/dts/stih416-pinctrl.dtsi
@@ -210,6 +210,19 @@
 					};
 				};
 			};
+
+			fsm {
+				pinctrl_fsm: fsm {
+					st,pins {
+						spi-fsm-clk  = <&PIO12 2 ALT1 OUT>;
+						spi-fsm-cs   = <&PIO12 3 ALT1 OUT>;
+						spi-fsm-mosi = <&PIO12 4 ALT1 OUT>;
+						spi-fsm-miso = <&PIO12 5 ALT1 IN>;
+						spi-fsm-hol  = <&PIO12 6 ALT1 OUT>;
+						spi-fsm-wp   = <&PIO12 7 ALT1 OUT>;
+					};
+				};
+			};
 		};
 
 		pin-controller-rear {
diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index b7ab47b..1e24b9e 100644
--- a/arch/arm/boot/dts/stih416.dtsi
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -145,5 +145,18 @@
 
 			status		= "disabled";
 		};
+
+		/* FSM */
+		spifsm: spifsm@fe902000 {
+			compatible	   = "st,spi-fsm";
+			reg		   = <0xfe902000 0x1000>;
+			pinctrl-0	   = <&pinctrl_fsm>;
+
+			st,syscfg	   = <&syscfg_rear>;
+			st,boot-device-reg = <0x958>;
+			st,boot-device-spi = <0x1a>;
+
+			status = "disabled";
+		};
 	};
 };
-- 
1.8.3.2

