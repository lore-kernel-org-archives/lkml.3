Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaIGLia (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 07:38:30 -0400
Received: from www.augenpunkt.de ([213.239.207.9]:34471 "EHLO
	www.augenpunkt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaIGLiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 07:38:12 -0400
From: Stefan Wahren <info@lategoodbye.de>
To: lgirdwood@gmail.com, broonie@kernel.org, shawn.guo@linaro.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: festevam@gmail.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        stefan.wahren@i2se.com, Stefan Wahren <info@lategoodbye.de>
Subject: [PATCH RFC 3/3] DT: ARM: mxs: enable regulator support for i.MX28
Date: Sun,  7 Sep 2014 13:37:49 +0200
Message-Id: <1410089869-6611-4-git-send-email-info@lategoodbye.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1410089869-6611-1-git-send-email-info@lategoodbye.de>
References: <1410089869-6611-1-git-send-email-info@lategoodbye.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the regulator support for i.MX28.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
---
 arch/arm/boot/dts/imx28.dtsi | 50 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.dtsi
index a95cc53..10c7cdf 100644
--- a/arch/arm/boot/dts/imx28.dtsi
+++ b/arch/arm/boot/dts/imx28.dtsi
@@ -979,8 +979,56 @@
 			};
 
 			power: power@80044000 {
+				compatible = "fsl,imx28-power";
+				#address-cells = <1>;
+				#size-cells = <0>;
 				reg = <0x80044000 0x2000>;
-				status = "disabled";
+
+				/*
+				reg_curr: regulator-overall_current@80044010 {
+					reg = <0x80044010>;
+					compatible = "fsl,mxs-regulator";
+					regulator-name = "overall_current";
+					regulator-min-microvolt = <>;
+					regulator-max-microvolt = <>;
+					regulator-min-microamp = <>;
+					regulator-max-microamp = <>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+				*/
+
+				reg_vddd: regulator-vddd@80044040 {
+					reg = <0x80044040>;
+					compatible = "fsl,mxs-regulator";
+					regulator-name = "vddd";
+					regulator-min-microvolt = <800000>;
+					regulator-max-microvolt = <1575000>;
+					regulator-always-on;
+					mxs-max-reg-val = <0x1f>;
+				};
+
+				reg_vdda: regulator-vdda@80044050 {
+					reg = <0x80044050>;
+					compatible = "fsl,mxs-regulator";
+					regulator-name = "vdda";
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <2275000>;
+					regulator-always-on;
+					mxs-max-reg-val = <0x1f>;
+				};
+
+				reg_vddio: regulator-vddio@80044060 {
+					reg = <0x80044060>;
+					compatible = "fsl,mxs-regulator";
+					regulator-name = "vddio";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <3600000>;
+					regulator-microvolt-offset = <80000>;
+					regulator-always-on;
+					mxs-max-reg-val = <0x10>;
+					mxs-default-microvolt = <3300000>;
+				};
 			};
 
 			saif1: saif@80046000 {
-- 
1.8.1.4

