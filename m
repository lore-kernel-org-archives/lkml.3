Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbbATQCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:02:15 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:44965 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbbATQCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:02:10 -0500
From: Stefan Agner <stefan@agner.ch>
To: jic23@kernel.org
Cc: shawn.guo@linaro.org, B38611@freescale.com, maitysanchayan@gmail.com,
        linux-iio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH 3/3] ARM: dts: add property for maximum ADC clock frequencies
Date: Tue, 20 Jan 2015 17:02:03 +0100
Message-Id: <1421769723-28677-4-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421769723-28677-1-git-send-email-stefan@agner.ch>
References: <1421769723-28677-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ADC clock frequency is limited depending on modes used. Add
device tree property which allow to set the mode used and the
maximum frequency ratings for the instance. These allows to
set the ADC clock to a frequency which is within specification
according to the actual mode used.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 Documentation/devicetree/bindings/iio/adc/vf610-adc.txt | 9 +++++++++
 arch/arm/boot/dts/vfxxx.dtsi                            | 4 ++++
 2 files changed, 13 insertions(+)

diff --git a/Documentation/devicetree/bindings/iio/adc/vf610-adc.txt b/Documentation/devicetree/bindings/iio/adc/vf610-adc.txt
index 1a4a43d..3eb40e2 100644
--- a/Documentation/devicetree/bindings/iio/adc/vf610-adc.txt
+++ b/Documentation/devicetree/bindings/iio/adc/vf610-adc.txt
@@ -11,6 +11,13 @@ Required properties:
 - clock-names: Must contain "adc", matching entry in the clocks property.
 - vref-supply: The regulator supply ADC reference voltage.
 
+Recommended properties:
+- fsl,adck-max-frequency: Maximum frequencies according to datasheets operating
+  requirements. Three values are required, depending on conversion mode:
+  - Frequency in normal mode (ADLPC=0, ADHSC=0)
+  - Frequency in high-speed mode (ADLPC=0, ADHSC=1)
+  - Frequency in low-power mode (ADLPC=1, ADHSC=0)
+
 Example:
 adc0: adc@4003b000 {
 	compatible = "fsl,vf610-adc";
@@ -18,5 +25,7 @@ adc0: adc@4003b000 {
 	interrupts = <0 53 0x04>;
 	clocks = <&clks VF610_CLK_ADC0>;
 	clock-names = "adc";
+	fsl,adck-max-frequency = <30000000>, <40000000>,
+				<20000000>;
 	vref-supply = <&reg_vcc_3v3_mcu>;
 };
diff --git a/arch/arm/boot/dts/vfxxx.dtsi b/arch/arm/boot/dts/vfxxx.dtsi
index 505969a..7584e0a 100644
--- a/arch/arm/boot/dts/vfxxx.dtsi
+++ b/arch/arm/boot/dts/vfxxx.dtsi
@@ -182,6 +182,8 @@
 				clocks = <&clks VF610_CLK_ADC0>;
 				clock-names = "adc";
 				status = "disabled";
+				fsl,adck-max-frequency = <30000000>, <40000000>,
+							<20000000>;
 			};
 
 			wdog@4003e000 {
@@ -361,6 +363,8 @@
 				clocks = <&clks VF610_CLK_ADC1>;
 				clock-names = "adc";
 				status = "disabled";
+				fsl,adck-max-frequency = <30000000>, <40000000>,
+							<20000000>;
 			};
 
 			esdhc1: esdhc@400b2000 {
-- 
2.2.2

