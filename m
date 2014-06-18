Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274AbaFROxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:53:09 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:36098 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaFROxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:53:07 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, thierry.reding@gmail.com,
        linux-pwm@vger.kernel.org, maxime.coquelin@st.com,
        patrice.chotard@st.com, srinivas.kandagatla@gmail.com,
        devicetree@vger.kernel.org, ajitpal.singh@st.com
Subject: [PATCH 1/7] ARM: stih407: Add DT nodes for for PWM
Date: Wed, 18 Jun 2014 15:52:46 +0100
Message-Id: <1403103172-19856-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Supply top level nodes for the STiH407 based development boards.
The Pinctrl configuration has already been applied, so the only
missing piece of the DT puzzle is for a board's DTB to enable
the nodes.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih407.dtsi | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/arm/boot/dts/stih407.dtsi b/arch/arm/boot/dts/stih407.dtsi
index 4f9024f..6b43ba2 100644
--- a/arch/arm/boot/dts/stih407.dtsi
+++ b/arch/arm/boot/dts/stih407.dtsi
@@ -259,5 +259,32 @@
 
 			status = "disabled";
 		};
+
+		/* COMMS PWM Module */
+		pwm0: pwm@9810000 {
+			compatible      = "st,sti-pwm";
+			status		= "disabled";
+			#pwm-cells	= <2>;
+			reg		= <0x9810000 0x68>;
+			pinctrl-names	= "default";
+                        pinctrl-0	= <&pinctrl_pwm0_chan0_default>;
+			clock-names	= "pwm";
+			clocks          = <&clk_sysin>;
+		};
+
+		/* SBC PWM Module */
+		pwm1: pwm@9510000 {
+			compatible	= "st,sti-pwm";
+			status		= "disabled";
+			#pwm-cells	= <2>;
+			reg		= <0x9510000 0x68>;
+			pinctrl-names	= "default";
+		        pinctrl-0	= <&pinctrl_pwm1_chan0_default
+					&pinctrl_pwm1_chan1_default
+					&pinctrl_pwm1_chan2_default
+					&pinctrl_pwm1_chan3_default>;
+			clock-names	= "pwm";
+			clocks          = <&clk_sysin>;
+		};
 	};
 };
-- 
1.8.3.2

