Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaFRP1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:27:06 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:48592 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbaFRP1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:27:03 -0400
Date: Wed, 18 Jun 2014 16:26:56 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: kernel@stlinux.com, thierry.reding@gmail.com, linux-pwm@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, devicetree@vger.kernel.org,
        ajitpal.singh@st.com
Subject: [PATCH v2 1/7] ARM: stih407: Add DT nodes for for PWM
Message-ID: <20140618152656.GE15956@lee--X1>
References: <1403103172-19856-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403103172-19856-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM: stih407: Add DT nodes for for PWM

Supply top level nodes for the STiH407 based development boards.
The Pinctrl configuration has already been applied, so the only
missing piece of the DT puzzle is for a board's DTB to enable
the nodes.

Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/arch/arm/boot/dts/stih407.dtsi b/arch/arm/boot/dts/stih407.dtsi
index 4f9024f..e9766a4 100644
--- a/arch/arm/boot/dts/stih407.dtsi
+++ b/arch/arm/boot/dts/stih407.dtsi
@@ -259,5 +259,32 @@
 
 			status = "disabled";
 		};
+
+		/* COMMS PWM Module */
+		pwm0: pwm@9810000 {
+			compatible	= "st,sti-pwm";
+			status		= "disabled";
+			#pwm-cells	= <2>;
+			reg		= <0x9810000 0x68>;
+			pinctrl-names	= "default";
+			pinctrl-0	= <&pinctrl_pwm0_chan0_default>;
+			clock-names	= "pwm";
+			clocks		= <&clk_sysin>;
+		};
+
+		/* SBC PWM Module */
+		pwm1: pwm@9510000 {
+			compatible	= "st,sti-pwm";
+			status		= "disabled";
+			#pwm-cells	= <2>;
+			reg		= <0x9510000 0x68>;
+			pinctrl-names	= "default";
+			pinctrl-0	= <&pinctrl_pwm1_chan0_default
+					&pinctrl_pwm1_chan1_default
+					&pinctrl_pwm1_chan2_default
+					&pinctrl_pwm1_chan3_default>;
+			clock-names	= "pwm";
+			clocks		= <&clk_sysin>;
+		};
 	};
 };
