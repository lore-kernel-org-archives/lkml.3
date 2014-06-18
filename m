Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbaFRP2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:28:34 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:34770 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbaFRP2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:28:31 -0400
Date: Wed, 18 Jun 2014 16:28:24 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: kernel@stlinux.com, thierry.reding@gmail.com, linux-pwm@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, devicetree@vger.kernel.org,
        ajitpal.singh@st.com
Subject: [PATCH v2 3/7] ARM: stih416: Add DT nodes for PWM
Message-ID: <20140618152824.GF15956@lee--X1>
References: <1403103172-19856-1-git-send-email-lee.jones@linaro.org>
 <1403103172-19856-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403103172-19856-3-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM: stih416: Add DT nodes for PWM

Supply top level nodes for the STiH416 based development boards.
The Pinctrl configuration has already been applied, so the only
missing piece of the DT puzzle is for a board's DTB to enable
the nodes.

Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index 06473c5..f95e469 100644
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
@@ -236,5 +236,45 @@
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
+		};
 	};
 };
