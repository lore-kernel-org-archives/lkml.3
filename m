Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab3HPKOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 06:14:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48537 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583Ab3HPKO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 06:14:26 -0400
From: George Cherian <george.cherian@ti.com>
To: <balbi@ti.com>, <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <grant.likely@linaro.org>,
        <rob@landley.net>, <ian.campbell@citrix.com>, <swarren@wwwdotorg.org>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <bcousson@baylibre.com>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 2/2] arm: dts: dra7-evm: Add extcon dt nodes for USB ID detection
Date: Fri, 16 Aug 2013 15:43:49 +0530
Message-ID: <1376648029-30659-3-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376648029-30659-1-git-send-email-george.cherian@ti.com>
References: <1376648029-30659-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding extcon dt nodes for USB ID detection.
ID pin is routed via the gpio expander , so adding pcf8575 nodes.
Changing otg mode to peripheral mode for usb1

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 arch/arm/boot/dts/dra7-evm.dts | 42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
index acd3c09..fc9a506 100644
--- a/arch/arm/boot/dts/dra7-evm.dts
+++ b/arch/arm/boot/dts/dra7-evm.dts
@@ -17,6 +17,23 @@
 		device_type = "memory";
 		reg = <0x80000000 0x60000000>; /* 1536 MB */
 	};
+
+	extcon1: dra7x_extcon1 {
+		compatible = "ti,dra7xx-usb";
+		gpios = <&pcf_usb 1 0>,
+			<&gpio6 11 2>;
+		interrupt-parent = <&gpio6>;
+		interrupts = <11>;
+	};
+
+	extcon2: dra7x_extcon2 {
+		compatible = "ti,dra7xx-usb";
+		gpios = <&pcf_usb 2 0>,
+			<&gpio6 11 2>;
+		interrupt-parent = <&gpio6>;
+		interrupts = <11>;
+	};
+
 };
 
 &dra7_pmx_core {
@@ -33,10 +50,33 @@
         };
 };
 
+&i2c1 {
+	clock-frequency = <400000>;
+
+	pcf_lcd: pcf8575@20 {
+		compatible = "ti,pcf8575";
+		reg = <0x20>;
+		n_latch = <0xbc50>;
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	pcf_usb: pcf8575@21 {
+		compatible = "ti,pcf8575";
+		reg = <0x21>;
+		n_latch = <0xffff>;
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+};
+
 &dwc3_1 {
-	dr_mode = "otg";
+	dr_mode = "peripheral";
+	extcon = <&extcon1>;
 };
 
 &dwc3_2 {
 	dr_mode = "host";
+	extcon = <&extcon2>;
 };
-- 
1.8.1.4

