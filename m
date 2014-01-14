Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaANO7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:59:42 -0500
Received: from eu1sys200aog124.obsmtp.com ([207.126.144.157]:50612 "EHLO
	eu1sys200aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751576AbaANO6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:58:32 -0500
From: <srinivas.kandagatla@st.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srinivas.kandagatla@st.com>
Subject: [PATCH v1 4/5] ARM:STi: STiH416: Add interrupt support for pin controller
Date: Tue, 14 Jan 2014 14:52:27 +0000
Message-ID: <1389711147-21130-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1389711077-20949-1-git-send-email-srinivas.kandagatla@st.com>
References: <1389711077-20949-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch adds interrupt support for STiH416 pin controllers.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 arch/arm/boot/dts/stih416-pinctrl.dtsi |   81 ++++++++++++++++++++++++++++++++
 1 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/stih416-pinctrl.dtsi b/arch/arm/boot/dts/stih416-pinctrl.dtsi
index 74f8cfc..3adbd98 100644
--- a/arch/arm/boot/dts/stih416-pinctrl.dtsi
+++ b/arch/arm/boot/dts/stih416-pinctrl.dtsi
@@ -8,6 +8,7 @@
  * publishhed by the Free Software Foundation.
  */
 #include "st-pincfg.h"
+#include <dt-bindings/interrupt-controller/arm-gic.h>
 / {
 
 	aliases {
@@ -49,41 +50,57 @@
 			#size-cells	= <1>;
 			compatible	= "st,stih416-sbc-pinctrl";
 			st,syscfg	= <&syscfg_sbc>;
+			reg 		= <0xfe61f080 0x4>;
+			reg-names	= "irqmux";
+			interrupts 	= <GIC_SPI 182 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts-names = "irqmux";
 			ranges		= <0 0xfe610000 0x6000>;
 
 			PIO0: gpio@fe610000 {
 				gpio-controller;
 				#gpio-cells = <1>;
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
 			PIO40: gpio@fe615000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0x5000 0x100>;
 				st,bank-name	= "PIO40";
 				st,retime-pin-mask = <0x7f>;
@@ -181,65 +198,89 @@
 			#size-cells	= <1>;
 			compatible	= "st,stih416-front-pinctrl";
 			st,syscfg	= <&syscfg_front>;
+			reg 		= <0xfee0f080 0x4>;
+			reg-names	= "irqmux";
+			interrupts 	= <GIC_SPI 183 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts-names = "irqmux";
 			ranges		= <0 0xfee00000 0x10000>;
 
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
 			PIO30: gpio@fee08000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0x8000 0x100>;
 				st,bank-name	= "PIO30";
 			};
 			PIO31: gpio@fee09000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0x9000 0x100>;
 				st,bank-name	= "PIO31";
 			};
@@ -276,41 +317,57 @@
 			#size-cells	= <1>;
 			compatible	= "st,stih416-rear-pinctrl";
 			st,syscfg	= <&syscfg_rear>;
+			reg 		= <0xfe82f080 0x4>;
+			reg-names	= "irqmux";
+			interrupts 	= <GIC_SPI 184 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts-names = "irqmux";
 			ranges 		= <0 0xfe820000 0x6000>;
 
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
 				st,retime-pin-mask = <0xf>;
@@ -384,23 +441,33 @@
 			#size-cells	= <1>;
 			compatible	= "st,stih416-fvdp-fe-pinctrl";
 			st,syscfg	= <&syscfg_fvdp_fe>;
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
@@ -411,29 +478,41 @@
 			#size-cells	= <1>;
 			compatible	= "st,stih416-fvdp-lite-pinctrl";
 			st,syscfg		= <&syscfg_fvdp_lite>;
+			reg 		= <0xfd33f080 0x4>;
+			reg-names	= "irqmux";
+			interrupts 	= <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts-names = "irqmux";
 			ranges			= <0 0xfd330000 0x5000>;
 
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
@@ -441,6 +520,8 @@
 			PIO107: gpio@fd334000 {
 				gpio-controller;
 				#gpio-cells	= <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 				reg		= <0x4000 0x100>;
 				st,bank-name	= "PIO107";
 				st,retime-pin-mask = <0xf>;
-- 
1.7.6.5

