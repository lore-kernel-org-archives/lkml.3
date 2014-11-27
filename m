Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbaK0UfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 15:35:00 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:65398 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaK0Ue6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 15:34:58 -0500
From: Philippe Reynes <tremyfr@gmail.com>
To: linux-arm-kernel@lists.infradead.org, shawn.guo@linaro.org,
        kernel@pengutronix.de
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Philippe Reynes <tremyfr@gmail.com>
Subject: [PATCH] apf27dev: add max5821 to the dts
Date: Thu, 27 Nov 2014 21:33:59 +0100
Message-Id: <1417120439-11784-1-git-send-email-tremyfr@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Philippe Reynes <tremyfr@gmail.com>
---
 arch/arm/boot/dts/imx27-apf27dev.dts |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/imx27-apf27dev.dts b/arch/arm/boot/dts/imx27-apf27dev.dts
index da306c5..bba3f41 100644
--- a/arch/arm/boot/dts/imx27-apf27dev.dts
+++ b/arch/arm/boot/dts/imx27-apf27dev.dts
@@ -59,6 +59,21 @@
 			linux,default-trigger = "heartbeat";
 		};
 	};
+
+	regulators {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		reg_max5821: regulator@0 {
+			compatible = "regulator-fixed";
+			reg = <0>;
+			regulator-name = "max5821-reg";
+			regulator-min-microvolt = <2500000>;
+			regulator-max-microvolt = <2500000>;
+			regulator-always-on;
+		};
+	};
 };
 
 &cspi1 {
@@ -107,6 +122,12 @@
 		compatible = "dallas,ds1374";
 		reg = <0x68>;
 	};
+
+	max5821@38 {
+		compatible = "maxim,max5821";
+		reg = <0x38>;
+		vref-supply = <&reg_max5821>;
+	};
 };
 
 &i2c2 {
-- 
1.7.4.4

