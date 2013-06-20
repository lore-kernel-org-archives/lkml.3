Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422700Ab3FTS6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 14:58:15 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:50396 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422666Ab3FTS6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 14:58:12 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>, Grant Likely <grant.likely@secretlab.ca>
Cc: jimwall@q.com, brian@crystalfontz.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Jonathan Cameron <jic23@cam.ac.uk>, Rob Landley <rob@landley.net>,
        Rob Herring <rob.herring@calxeda.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2 3/3] ARM: mxs: cfa10049: Add NAU7802 ADCs to the device tree
Date: Thu, 20 Jun 2013 20:57:55 +0200
Message-Id: <1371754675-12242-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371754675-12242-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1371754675-12242-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Ripard <maxime.ripard@free-electrons.com>

Since these ADCs share the same non-configurable address on the I2C bus,
they have to be put behind a muxer.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/imx28-cfa10049.dts | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/imx28-cfa10049.dts b/arch/arm/boot/dts/imx28-cfa10049.dts
index d3758c2..efc4213 100644
--- a/arch/arm/boot/dts/imx28-cfa10049.dts
+++ b/arch/arm/boot/dts/imx28-cfa10049.dts
@@ -356,18 +356,36 @@
 			reg = <0>;
 			#address-cells = <1>;
 			#size-cells = <0>;
+
+			adc0: nau7802@2a {
+				compatible = "nuvoton,nau7802";
+				reg = <0x2a>;
+				nuvoton,vldo = <3000>;
+			};
 		};
 
 		i2c@1 {
 			reg = <1>;
 			#address-cells = <1>;
 			#size-cells = <0>;
+
+			adc1: nau7802@2a {
+				compatible = "nuvoton,nau7802";
+				reg = <0x2a>;
+				nuvoton,vldo = <3000>;
+			};
 		};
 
 		i2c@2 {
 			reg = <2>;
 			#address-cells = <1>;
 			#size-cells = <0>;
+
+			adc2: nau7802@2a {
+				compatible = "nuvoton,nau7802";
+				reg = <0x2a>;
+				nuvoton,vldo = <3000>;
+			};
 		};
 
 		i2c@3 {
-- 
1.8.1.2

