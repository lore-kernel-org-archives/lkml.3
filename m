Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaAPPoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 10:44:13 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:45606 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634AbaAPPoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 10:44:07 -0500
From: <srinivas.kandagatla@st.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srinivas.kandagatla@st.com>
Subject: [PATCH v2 4/4] ARM:STi: STiH415: Add interrupt support for pin controller
Date: Thu, 16 Jan 2014 15:37:45 +0000
Message-ID: <1389886665-32076-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1389886545-31498-1-git-send-email-srinivas.kandagatla@st.com>
References: <1389886545-31498-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch adds interrupt support for STiH415 pin controllers.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 arch/arm/boot/dts/stih415-pinctrl.dtsi |   75 ++++++++++++++++++++++++++++++++
 1 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/stih415-pinctrl.dtsi b/arch/arm/boot/dts/stih415-pinctrl.dtsi
index a9324fa..21b3b53 100644
--- a/arch/arm/boot/dts/stih415-pinctrl.dtsi
+++ b/arch/arm/boot/dts/stih415-pinctrl.dtsi
@@ -7,6 +7,7 @@
  * publishhed by the Free Software Foundation.
  */
 #include "st-pincfg.h"
+#include <dt-bindings/interrupt-controller/arm-gic.h>
 / {
 
 	aliases {
@@ -45,35 +46,49 @@
 			#size-cells	= <1>;
 			compatible	= "st,stih415-sbc-pinctrl";
 			st,syscfg	= <&syscfg_sbc>;
+			reg 		= <0xfe61f080 0x4>;
+			reg-names	= "irqmux";
+			interrupts 	= <GIC_SPI 180 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts-names = "irqmux";
 			ranges 		= <0 0xfe610000 0x5000>;
 
 			PIO0: gpio@fe610000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0 0x100>;
 				st,bank-name	= "PIO0";
 			};
 			PIO1: gpio@fe611000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0x1000 0x100>;
 				st,bank-name	= "PIO1";
 			};
 			PIO2: gpio@fe612000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0x2000 0x100>;
 				st,bank-name	= "PIO2";
 			};
 			PIO3: gpio@fe613000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0x3000 0x100>;
 				st,bank-name	= "PIO3";
 			};
 			PIO4: gpio@fe614000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0x4000 0x100>;
 				st,bank-name	= "PIO4";
 			};
@@ -169,53 +184,73 @@
 			#size-cells	= <1>;
 			compatible	= "st,stih415-front-pinctrl";
 			st,syscfg	= <&syscfg_front>;
+			reg 		= <0xfee0f080 0x4>;
+			reg-names	= "irqmux";
+			interrupts 	= <GIC_SPI 181 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts-names = "irqmux";
 			ranges		= <0 0xfee00000 0x8000>;
 
 			PIO5: gpio@fee00000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0 0x100>;
 				st,bank-name	= "PIO5";
 			};
 			PIO6: gpio@fee01000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0x1000 0x100>;
 				st,bank-name	= "PIO6";
 			};
 			PIO7: gpio@fee02000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0x2000 0x100>;
 				st,bank-name	= "PIO7";
 			};
 			PIO8: gpio@fee03000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0x3000 0x100>;
 				st,bank-name	= "PIO8";
 			};
 			PIO9: gpio@fee04000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0x4000 0x100>;
 				st,bank-name	= "PIO9";
 			};
 			PIO10: gpio@fee05000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0x5000 0x100>;
 				st,bank-name	= "PIO10";
 			};
 			PIO11: gpio@fee06000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0x6000 0x100>;
 				st,bank-name	= "PIO11";
 			};
 			PIO12: gpio@fee07000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0x7000 0x100>;
 				st,bank-name	= "PIO12";
 			};
@@ -244,41 +279,57 @@
 			#size-cells	= <1>;
 			compatible	= "st,stih415-rear-pinctrl";
 			st,syscfg	= <&syscfg_rear>;
+			reg 		= <0xfe82f080 0x4>;
+			reg-names	= "irqmux";
+			interrupts 	= <GIC_SPI 182 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts-names = "irqmux";
 			ranges		= <0 0xfe820000 0x8000>;
 
 			PIO13: gpio@fe820000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0 0x100>;
 				st,bank-name	= "PIO13";
 			};
 			PIO14: gpio@fe821000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0x1000 0x100>;
 				st,bank-name	= "PIO14";
 			};
 			PIO15: gpio@fe822000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0x2000 0x100>;
 				st,bank-name	= "PIO15";
 			};
 			PIO16: gpio@fe823000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0x3000 0x100>;
 				st,bank-name	= "PIO16";
 			};
 			PIO17: gpio@fe824000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0x4000 0x100>;
 				st,bank-name	= "PIO17";
 			};
 			PIO18: gpio@fe825000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0x5000 0x100>;
 				st,bank-name	= "PIO18";
 			};
@@ -329,23 +380,33 @@
 			#size-cells	= <1>;
 			compatible	= "st,stih415-left-pinctrl";
 			st,syscfg	= <&syscfg_left>;
+			reg 		= <0xfd6bf080 0x4>;
+			reg-names	= "irqmux";
+			interrupts 	= <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts-names = "irqmux";
 			ranges		= <0 0xfd6b0000 0x3000>;
 
 			PIO100: gpio@fd6b0000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0 0x100>;
 				st,bank-name	= "PIO100";
 			};
 			PIO101: gpio@fd6b1000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0x1000 0x100>;
 				st,bank-name	= "PIO101";
 			};
 			PIO102: gpio@fd6b2000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0x2000 0x100>;
 				st,bank-name	= "PIO102";
 			};
@@ -356,35 +417,49 @@
 			#size-cells	= <1>;
 			compatible	= "st,stih415-right-pinctrl";
 			st,syscfg	= <&syscfg_right>;
+			reg 		= <0xfd33f080 0x4>;
+			reg-names	= "irqmux";
+			interrupts 	= <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts-names = "irqmux";
 			ranges		= <0 0xfd330000 0x5000>;
 
 			PIO103: gpio@fd330000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0 0x100>;
 				st,bank-name	= "PIO103";
 			};
 			PIO104: gpio@fd331000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0x1000 0x100>;
 				st,bank-name	= "PIO104";
 			};
 			PIO105: gpio@fd332000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0x2000 0x100>;
 				st,bank-name	= "PIO105";
 			};
 			PIO106: gpio@fd333000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0x3000 0x100>;
 				st,bank-name	= "PIO106";
 			};
 			PIO107: gpio@fd334000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0x4000 0x100>;
 				st,bank-name	= "PIO107";
 			};
-- 
1.7.6.5

