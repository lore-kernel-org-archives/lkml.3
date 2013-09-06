Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750999Ab3IFIMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 04:12:50 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:54697
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750946Ab3IFIMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 04:12:47 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z551bizzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <r65073@freescale.com>, <thierry.reding@gmail.com>
CC: <grant.likely@linaro.org>, <linux@arm.linux.org.uk>, <rob@landley.net>,
        <ian.campbell@citrix.com>, <swarren@wwwdotorg.org>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-pwm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>
Subject: [PATCHv3 2/4] ARM: dts: Add Freescale FTM PWM node for VF610.
Date: Fri, 6 Sep 2013 16:08:25 +0800
Message-ID: <1378454907-22728-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1378454907-22728-1-git-send-email-Li.Xiubo@freescale.com>
References: <1378454907-22728-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds devicetree node for VF610, and there are 8 channels supported
by default.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 arch/arm/boot/dts/vf610.dtsi | 103 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 102 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
index 67d929c..44787b5 100644
--- a/arch/arm/boot/dts/vf610.dtsi
+++ b/arch/arm/boot/dts/vf610.dtsi
@@ -140,6 +140,37 @@
 				clock-names = "pit";
 			};
 
+			pwm0: pwm@40038000 {
+				compatible = "fsl,vf610-ftm-pwm";
+				#pwm-cells = <3>;
+				reg = <0x40038000 0x1000>;
+				clock-names = "ftm0", "ftm0_fix_sel", "ftm0_ext_sel";
+				clocks = <&clks VF610_CLK_FTM0>,
+					<&clks VF610_CLK_FTM0_FIX_SEL>,
+					<&clks VF610_CLK_FTM0_EXT_SEL>;
+				pinctrl-names = "ch0-active", "ch0-idle", "ch1-active", "ch1-idle",
+						"ch2-active", "ch2-idle", "ch3-active", "ch3-idle",
+						"ch4-active", "ch4-idle", "ch5-active", "ch5-idle",
+						"ch6-active", "ch6-idle", "ch7-active", "ch7-idle";
+				pinctrl-0 = <&pinctrl_pwm0_ch0_active>;
+				pinctrl-1 = <&pinctrl_pwm0_ch0_idle>;
+				pinctrl-2 = <&pinctrl_pwm0_ch1_active>;
+				pinctrl-3 = <&pinctrl_pwm0_ch1_idle>;
+				pinctrl-4 = <&pinctrl_pwm0_ch2_active>;
+				pinctrl-5 = <&pinctrl_pwm0_ch2_idle>;
+				pinctrl-6 = <&pinctrl_pwm0_ch3_active>;
+				pinctrl-7 = <&pinctrl_pwm0_ch3_idle>;
+				pinctrl-8 = <&pinctrl_pwm0_ch4_active>;
+				pinctrl-9 = <&pinctrl_pwm0_ch4_idle>;
+				pinctrl-10 = <&pinctrl_pwm0_ch5_active>;
+				pinctrl-11 = <&pinctrl_pwm0_ch5_idle>;
+				pinctrl-12 = <&pinctrl_pwm0_ch6_active>;
+				pinctrl-13 = <&pinctrl_pwm0_ch6_idle>;
+				pinctrl-14 = <&pinctrl_pwm0_ch7_active>;
+				pinctrl-15 = <&pinctrl_pwm0_ch7_idle>;
+				status = "disabled";
+			};
+
 			wdog@4003e000 {
 				compatible = "fsl,vf610-wdt", "fsl,imx21-wdt";
 				reg = <0x4003e000 0x1000>;
@@ -270,16 +301,86 @@
 				};
 
 				pwm0 {
-					pinctrl_pwm0_1: pwm0grp_1 {
+					pinctrl_pwm0_ch0_active: pwm0grp_ch0_active {
 						fsl,pins = <
 						VF610_PAD_PTB0__FTM0_CH0	0x1582
+						>;
+					};
+					pinctrl_pwm0_ch0_idle: pwm0grp_ch0_idle {
+						fsl,pins = <
+						VF610_PAD_PTB0__FTM0_CH0	0x0000
+						>;
+					};
+					pinctrl_pwm0_ch1_active: pwm0grp_ch1_active {
+						fsl,pins = <
 						VF610_PAD_PTB1__FTM0_CH1	0x1582
+						>;
+					};
+					pinctrl_pwm0_ch1_idle: pwm0grp_ch1_idle {
+						fsl,pins = <
+						VF610_PAD_PTB1__FTM0_CH1	0x0000
+						>;
+					};
+					pinctrl_pwm0_ch2_active: pwm0grp_ch2_active {
+						fsl,pins = <
 						VF610_PAD_PTB2__FTM0_CH2	0x1582
+						>;
+					};
+					pinctrl_pwm0_ch2_idle: pwm0grp_ch2_idle {
+						fsl,pins = <
+						VF610_PAD_PTB2__FTM0_CH2	0x0000
+						>;
+					};
+					pinctrl_pwm0_ch3_active: pwm0grp_ch3_active {
+						fsl,pins = <
 						VF610_PAD_PTB3__FTM0_CH3	0x1582
+						>;
+					};
+					pinctrl_pwm0_ch3_idle: pwm0grp_ch3_idle {
+						fsl,pins = <
+						VF610_PAD_PTB3__FTM0_CH3	0x0000
+						>;
+					};
+					pinctrl_pwm0_ch4_active: pwm0grp_ch4_active {
+						fsl,pins = <
+						VF610_PAD_PTB4__FTM0_CH4	0x1582
+						>;
+					};
+					pinctrl_pwm0_ch4_idle: pwm0grp_ch4_idle {
+						fsl,pins = <
+						VF610_PAD_PTB4__FTM0_CH4	0x0000
+						>;
+					};
+					pinctrl_pwm0_ch5_active: pwm0grp_ch5_active {
+						fsl,pins = <
+						VF610_PAD_PTB5__FTM0_CH5	0x1582
+						>;
+					};
+					pinctrl_pwm0_ch5_idle: pwm0grp_ch5_idle {
+						fsl,pins = <
+						VF610_PAD_PTB5__FTM0_CH5	0x0000
+						>;
+					};
+					pinctrl_pwm0_ch6_active: pwm0grp_ch6_active {
+						fsl,pins = <
 						VF610_PAD_PTB6__FTM0_CH6	0x1582
+						>;
+					};
+					pinctrl_pwm0_ch6_idle: pwm0grp_ch6_idle {
+						fsl,pins = <
+						VF610_PAD_PTB6__FTM0_CH6	0x0000
+						>;
+					};
+					pinctrl_pwm0_ch7_active: pwm0grp_ch7_active {
+						fsl,pins = <
 						VF610_PAD_PTB7__FTM0_CH7	0x1582
 						>;
 					};
+					pinctrl_pwm0_ch7_idle: pwm0grp_ch7_idle {
+						fsl,pins = <
+						VF610_PAD_PTB7__FTM0_CH7	0x0000
+						>;
+					};
 				};
 
 				qspi0 {
-- 
1.8.0


