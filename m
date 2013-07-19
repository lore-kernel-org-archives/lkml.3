Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147Ab3GSJOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 05:14:17 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.98]:47672 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760115Ab3GSJOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 05:14:08 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-10.tower-200.messagelabs.com!1374225243!16108572!9
X-Originating-IP: [66.77.174.13]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: Hector Palacios <hector.palacios@digi.com>
To: <linux-iio@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <marex@denx.de>, <alexandre.belloni@free-electrons.com>,
        <jic23@kernel.org>, <lars@metafoo.de>, <fabio.estevam@freescale.com>,
        <hector.palacios@digi.com>
Subject: [PATCH v2 2/5] ARM: dts: add reference voltage property for MXS LRADC
Date: Fri, 19 Jul 2013 11:13:25 +0200
Message-ID: <1374225208-28940-3-git-send-email-hector.palacios@digi.com>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1374225208-28940-1-git-send-email-hector.palacios@digi.com>
References: <1374225208-28940-1-git-send-email-hector.palacios@digi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some LRADC channels have fixed pre-dividers so they can measure
different voltages at full scale. The reference voltage allows to
expose a scaling attribute through the IIO sysfs so that a user can
compute the real voltage out of a measured sample value.

Signed-off-by: Hector Palacios <hector.palacios@digi.com>
---
 Documentation/devicetree/bindings/staging/iio/adc/mxs-lradc.txt | 9 ++++++++-
 arch/arm/boot/dts/imx23.dtsi                                    | 4 ++++
 arch/arm/boot/dts/imx28.dtsi                                    | 4 ++++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/staging/iio/adc/mxs-lradc.txt b/Documentation/devicetree/bindings/staging/iio/adc/mxs-lradc.txt
index 4688205..6ec485c 100644
--- a/Documentation/devicetree/bindings/staging/iio/adc/mxs-lradc.txt
+++ b/Documentation/devicetree/bindings/staging/iio/adc/mxs-lradc.txt
@@ -1,9 +1,12 @@
 * Freescale i.MX28 LRADC device driver
 
 Required properties:
-- compatible: Should be "fsl,imx28-lradc"
+- compatible: "fsl,imx28-lradc", "fsl,imx23-lradc"
 - reg: Address and length of the register set for the device
 - interrupts: Should contain the LRADC interrupts
+- fsl,vref: Reference voltage (in mV) for each LRADC channel. This is the
+	    maximum voltage that can be measured at full scale in each channel
+	    considering fixed pre-dividers.
 
 Optional properties:
 - fsl,lradc-touchscreen-wires: Number of wires used to connect the touchscreen
@@ -18,4 +21,8 @@ Examples:
 		reg = <0x80050000 0x2000>;
 		interrupts = <10 14 15 16 17 18 19
 				20 21 22 23 24 25>;
+		fsl,vref = <1850 1850 1850 1850
+			    1850 1850 1850 7400
+			    1850 1850 3700 1850
+			    3700 1850 1850 7400>
 	};
diff --git a/arch/arm/boot/dts/imx23.dtsi b/arch/arm/boot/dts/imx23.dtsi
index 587ceef..e212902 100644
--- a/arch/arm/boot/dts/imx23.dtsi
+++ b/arch/arm/boot/dts/imx23.dtsi
@@ -430,6 +430,10 @@
 				compatible = "fsl,imx23-lradc";
 				reg = <0x80050000 0x2000>;
 				interrupts = <36 37 38 39 40 41 42 43 44>;
+				fsl,vref = <1850 1850 1850 1850
+					    1850 1850 3700 7400
+					    1850 1850 1850 1850
+					    1850 1850 1850 7400>;
 				status = "disabled";
 			};
 
diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.dtsi
index 6a8acb0..c1b3724 100644
--- a/arch/arm/boot/dts/imx28.dtsi
+++ b/arch/arm/boot/dts/imx28.dtsi
@@ -865,6 +865,10 @@
 				reg = <0x80050000 0x2000>;
 				interrupts = <10 14 15 16 17 18 19
 						20 21 22 23 24 25>;
+				fsl,vref = <1850 1850 1850 1850
+					    1850 1850 1850 7400
+					    1850 1850 3700 1850
+					    3700 1850 1850 7400>;
 				status = "disabled";
 			};
 
