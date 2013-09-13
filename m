Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab3IMGDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 02:03:53 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:8955 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754710Ab3IMGDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 02:03:09 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z551bizzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <r65073@freescale.com>, <thierry.reding@gmail.com>
CC: <s.hauer@pengutronix.de>, <swarren@wwwdotorg.org>, <t.figa@samsung.com>,
        <grant.likely@linaro.org>, <linux@arm.linux.org.uk>, <rob@landley.net>,
        <ian.campbell@citrix.com>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <rob.herring@calxeda.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pwm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
Subject: [PATCHv4 2/4] ARM: dts: Add Freescale FTM PWM node for VF610.
Date: Fri, 13 Sep 2013 13:58:40 +0800
Message-ID: <1379051922-4930-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1379051922-4930-1-git-send-email-Li.Xiubo@freescale.com>
References: <1379051922-4930-1-git-send-email-Li.Xiubo@freescale.com>
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
 arch/arm/boot/dts/vf610.dtsi | 83 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 82 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
index 67d929c..9b200ef 100644
--- a/arch/arm/boot/dts/vf610.dtsi
+++ b/arch/arm/boot/dts/vf610.dtsi
@@ -140,6 +140,17 @@
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
+				status = "disabled";
+			};
+
 			wdog@4003e000 {
 				compatible = "fsl,vf610-wdt", "fsl,imx21-wdt";
 				reg = <0x4003e000 0x1000>;
@@ -270,16 +281,86 @@
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


