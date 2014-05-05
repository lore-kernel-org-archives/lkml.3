Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbaEEPlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:41:04 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:60919 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753739AbaEEPk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:40:56 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Giuseppe Condorelli <giuseppe.condorelli@st.com>
Subject: [PATCH 2/4] ARM: STi: DT: add keyscan for stih416
Date: Mon,  5 May 2014 17:38:38 +0200
Message-Id: <1399304320-18197-3-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399304320-18197-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1399304320-18197-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-05_02:2014-05-05,2014-05-05,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add keyscan support for stih416.
It is disabled by default given that it is not enabled on all boards.
Also there are PIOs conflict with already claimed lines.

Signed-off-by: Giuseppe Condorelli <giuseppe.condorelli@st.com>
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
---
 arch/arm/boot/dts/stih416-pinctrl.dtsi | 16 ++++++++++++++++
 arch/arm/boot/dts/stih416.dtsi         | 12 ++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/arch/arm/boot/dts/stih416-pinctrl.dtsi b/arch/arm/boot/dts/stih416-pinctrl.dtsi
index 250d5ec..ee6c119 100644
--- a/arch/arm/boot/dts/stih416-pinctrl.dtsi
+++ b/arch/arm/boot/dts/stih416-pinctrl.dtsi
@@ -122,6 +122,22 @@
 				};
 			};
 
+			keyscan {
+				pinctrl_keyscan: keyscan {
+					st,pins {
+						keyin0 = <&PIO0 2 ALT2 IN>;
+						keyin1 = <&PIO0 3 ALT2 IN>;
+						keyin2 = <&PIO0 4 ALT2 IN>;
+						keyin3 = <&PIO2 6 ALT2 IN>;
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
diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index 78746d2..d3bc263 100644
--- a/arch/arm/boot/dts/stih416.dtsi
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -224,5 +224,17 @@
 
 			status = "disabled";
 		};
+
+		keyscan: keyscan@fe4b0000 {
+			compatible = "st,sti-keyscan";
+			status = "disabled";
+			reg = <0xfe4b0000 0x2000>;
+			interrupts = <GIC_SPI 212 IRQ_TYPE_NONE>;
+			clocks = <&CLK_SYSIN>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_keyscan>;
+			resets	= <&powerdown STIH416_KEYSCAN_POWERDOWN>,
+				  <&softreset STIH416_KEYSCAN_SOFTRESET>;
+		};
 	};
 };
-- 
1.9.1

