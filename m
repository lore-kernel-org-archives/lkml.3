Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbaGNOeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:34:05 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:34720 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706AbaGNOdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:33:51 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, thierry.reding@gmail.com,
        linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        ajitpal.singh@st.com
Subject: [PATCH v2 03/11] ARM: stih416: Add DT nodes for PWM
Date: Mon, 14 Jul 2014 15:33:24 +0100
Message-Id: <1405348412-7352-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405348412-7352-1-git-send-email-lee.jones@linaro.org>
References: <1405348412-7352-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Supply top level nodes for the STiH416 based development boards.
The Pinctrl configuration has already been applied, so the only
missing piece of the DT puzzle is for a board's DTB to enable
the nodes.

Signed-off-by: Ajit Pal Singh <ajitpal.singh@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih416.dtsi | 44 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index 84758d7..c28ef85 100644
--- a/arch/arm/boot/dts/stih416.dtsi
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -102,7 +102,7 @@
 			interrupts	= <0 210 0>;
 			pinctrl-names 	= "default";
 			pinctrl-0 	= <&pinctrl_sbc_serial1>;
-			clocks          = <&clk_sysin>;
+			clocks		= <&clk_sysin>;
 		};
 
 		i2c@fed40000 {
@@ -236,5 +236,47 @@
 			resets	= <&powerdown STIH416_KEYSCAN_POWERDOWN>,
 				  <&softreset STIH416_KEYSCAN_SOFTRESET>;
 		};
+
+		/* SAS PWM Module */
+		pwm0: pwm@fed10000 {
+			compatible	= "st,sti-pwm";
+			status		= "disabled";
+			#pwm-cells	= <2>;
+			reg		= <0xfed10000 0x68>;
+
+			pinctrl-names	= "default";
+			pinctrl-0 = 	<&pinctrl_pwm0_chan0_default
+					&pinctrl_pwm0_chan1_default
+					&pinctrl_pwm0_chan2_default
+					&pinctrl_pwm0_chan3_default>;
+
+			clock-names	= "pwm";
+			clocks		= <&clk_sysin>;
+			st,pwm-num-chan = <4>;
+		};
+
+		/* SBC PWM Module */
+		pwm1: pwm@fe510000 {
+			compatible	= "st,sti-pwm";
+			status		= "disabled";
+			#pwm-cells	= <2>;
+			reg		= <0xfe510000 0x68>;
+
+			pinctrl-names	= "default";
+			pinctrl-0	= <&pinctrl_pwm1_chan0_default
+					/*
+					 * Shared with SBC_OBS_NOTRST.  Don't
+					 * enable unless you really know what
+					 * you're doing.
+					 *
+					 * &pinctrl_pwm1_chan1_default
+					 */
+					&pinctrl_pwm1_chan2_default
+					&pinctrl_pwm1_chan3_default>;
+
+			clock-names	= "pwm";
+			clocks		= <&clk_sysin>;
+			st,pwm-num-chan = <3>;
+		};
 	};
 };
-- 
1.8.3.2

