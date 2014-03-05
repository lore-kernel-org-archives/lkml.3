Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbaCEDm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 22:42:58 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:33646 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755761AbaCEDlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:41:45 -0500
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org, kernel@stlinux.com,
        Lee Jones <lee.jones@linaro.org>,
        Giuseppe CONDORELLI <giuseppe.condorelli@st.com>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Subject: [PATCH 2/5] ARM: STi: DT: add keyscan for stih415
Date: Wed,  5 Mar 2014 04:39:29 +0100
Message-Id: <1393990772-9567-3-git-send-email-gabriel.fernandez@st.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393990772-9567-1-git-send-email-gabriel.fernandez@st.com>
References: <1393990772-9567-1-git-send-email-gabriel.fernandez@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Giuseppe CONDORELLI <giuseppe.condorelli@st.com>

Add keyscan support for stih415.
It is put disabled by default because it is not enabled on all boards
Also there are PIOs conflict with already claimed lines.

Signed-off-by: Giuseppe Condorelli <giuseppe.condorelli@st.com>
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
---
 arch/arm/boot/dts/stih415-pinctrl.dtsi | 16 ++++++++++++++++
 arch/arm/boot/dts/stih415.dtsi         | 10 ++++++++++
 2 files changed, 26 insertions(+)

diff --git a/arch/arm/boot/dts/stih415-pinctrl.dtsi b/arch/arm/boot/dts/stih415-pinctrl.dtsi
index e56449d..731e4b1 100644
--- a/arch/arm/boot/dts/stih415-pinctrl.dtsi
+++ b/arch/arm/boot/dts/stih415-pinctrl.dtsi
@@ -87,6 +87,22 @@
 				};
 			};
 
+			keyscan {
+				pinctrl_keyscan: keyscan {
+					st,pins {
+						keyin0  = <&PIO0 2 ALT2 IN>;
+						keyin1  = <&PIO0 3 ALT2 IN>;
+						keyin2  = <&PIO0 4 ALT2 IN>;
+						keyin3  = <&PIO2 6 ALT2 IN>;
+
+						keyout0 = <&PIO1 6 ALT2 OUT>;
+						keyout1 = <&PIO1 7 ALT2 OUT>;
+						keyout2 = <&PIO0 6 ALT2 OUT>;
+						keyout3 = <&PIO2 7 ALT2 OUT>;
+					};
+				};
+			};
+
 			sbc_i2c0 {
 				pinctrl_sbc_i2c0_default: sbc_i2c0-default {
 					st,pins {
diff --git a/arch/arm/boot/dts/stih415.dtsi b/arch/arm/boot/dts/stih415.dtsi
index d9c7dd1..5930467 100644
--- a/arch/arm/boot/dts/stih415.dtsi
+++ b/arch/arm/boot/dts/stih415.dtsi
@@ -136,5 +136,15 @@
 
 			status		= "disabled";
 		};
+
+		keyscan: keyscan@fe4b0000 {
+			compatible = "st,keypad";
+			status = "disabled";
+			reg = <0xfe4b0000 0x2000>;
+			interrupts = <GIC_SPI 212 IRQ_TYPE_NONE>;
+			clocks	= <&CLK_SYSIN>;
+			pinctrl-names	= "default";
+			pinctrl-0 = <&pinctrl_keyscan>;
+		};
 	};
 };
-- 
1.9.0

