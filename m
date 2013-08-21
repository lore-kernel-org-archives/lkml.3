Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab3HUDKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 23:10:48 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:17083
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752036Ab3HUDKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 23:10:43 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <r65073@freescale.com>, <thierry.reding@gmail.com>
CC: <grant.likely@linaro.org>, <linux@arm.linux.org.uk>, <rob@landley.net>,
        <ian.campbell@citrix.com>, <swarren@wwwdotorg.org>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-pwm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>
Subject: [PATCH 2/4] ARM: dts: Add Freescale ftm pwm node for VF610.
Date: Wed, 21 Aug 2013 11:07:40 +0800
Message-ID: <1377054462-6283-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com>
References: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 arch/arm/boot/dts/vf610.dtsi | 83 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 82 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
index 67d929c..b3a0b6e 100644
--- a/arch/arm/boot/dts/vf610.dtsi
+++ b/arch/arm/boot/dts/vf610.dtsi
@@ -140,6 +140,17 @@
 				clock-names = "pit";
 			};
 
+			pwm0: pwm@40038000 {
+				compatible = "fsl,vf610-ftm-pwm";
+				#pwm-cells = <3>;
+				reg = <0x40038000 0x1000>;
+				clocks = <&clks VF610_CLK_FTM0_EXT_FIX_EN>,
+					<&clks VF610_CLK_FTM0_EXT_SEL>,
+					<&clks VF610_CLK_FTM0>;
+				clock-names = "ftm0_ext_fix_en", "ftm0_ext_sel", "ftm0";
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
+					pinctrl_pwm0_ch0_en: pwm0grp_ch0_en {
 						fsl,pins = <
 						VF610_PAD_PTB0__FTM0_CH0	0x1582
+						>;
+					};
+					pinctrl_pwm0_ch0_ds: pwm0grp_ch0_ds {
+						fsl,pins = <
+						VF610_PAD_PTB0__FTM0_CH0	0x0000
+						>;
+					};
+					pinctrl_pwm0_ch1_en: pwm0grp_ch1_en {
+						fsl,pins = <
 						VF610_PAD_PTB1__FTM0_CH1	0x1582
+						>;
+					};
+					pinctrl_pwm0_ch1_ds: pwm0grp_ch1_ds {
+						fsl,pins = <
+						VF610_PAD_PTB1__FTM0_CH1	0x0000
+						>;
+					};
+					pinctrl_pwm0_ch2_en: pwm0grp_ch2_en {
+						fsl,pins = <
 						VF610_PAD_PTB2__FTM0_CH2	0x1582
+						>;
+					};
+					pinctrl_pwm0_ch2_ds: pwm0grp_ch2_ds {
+						fsl,pins = <
+						VF610_PAD_PTB2__FTM0_CH2	0x0000
+						>;
+					};
+					pinctrl_pwm0_ch3_en: pwm0grp_ch3_en {
+						fsl,pins = <
 						VF610_PAD_PTB3__FTM0_CH3	0x1582
+						>;
+					};
+					pinctrl_pwm0_ch3_ds: pwm0grp_ch3_ds {
+						fsl,pins = <
+						VF610_PAD_PTB3__FTM0_CH3	0x0000
+						>;
+					};
+					pinctrl_pwm0_ch4_en: pwm0grp_ch4_en {
+						fsl,pins = <
+						VF610_PAD_PTB4__FTM0_CH4	0x1582
+						>;
+					};
+					pinctrl_pwm0_ch4_ds: pwm0grp_ch4_ds {
+						fsl,pins = <
+						VF610_PAD_PTB4__FTM0_CH4	0x0000
+						>;
+					};
+					pinctrl_pwm0_ch5_en: pwm0grp_ch5_en {
+						fsl,pins = <
+						VF610_PAD_PTB5__FTM0_CH5	0x1582
+						>;
+					};
+					pinctrl_pwm0_ch5_ds: pwm0grp_ch5_ds {
+						fsl,pins = <
+						VF610_PAD_PTB5__FTM0_CH5	0x0000
+						>;
+					};
+					pinctrl_pwm0_ch6_en: pwm0grp_ch6_en {
+						fsl,pins = <
 						VF610_PAD_PTB6__FTM0_CH6	0x1582
+						>;
+					};
+					pinctrl_pwm0_ch6_ds: pwm0grp_ch6_ds {
+						fsl,pins = <
+						VF610_PAD_PTB6__FTM0_CH6	0x0000
+						>;
+					};
+					pinctrl_pwm0_ch7_en: pwm0grp_ch7_en {
+						fsl,pins = <
 						VF610_PAD_PTB7__FTM0_CH7	0x1582
 						>;
 					};
+					pinctrl_pwm0_ch7_ds: pwm0grp_ch7_ds {
+						fsl,pins = <
+						VF610_PAD_PTB7__FTM0_CH7	0x0000
+						>;
+					};
 				};
 
 				qspi0 {
-- 
1.8.0


