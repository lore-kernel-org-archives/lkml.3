Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933997Ab3CMUkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 16:40:17 -0400
Received: from mail-ye0-f202.google.com ([209.85.213.202]:37975 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437Ab3CMUkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 16:40:14 -0400
From: Doug Anderson <dianders@chromium.org>
To: Jonathan Cameron <jic23@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Olof Johansson <olof@lixom.net>, Guenter Roeck <linux@roeck-us.net>,
        Doug Anderson <dianders@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] iio: adc: Document the regulator/clocks for exynos-adc
Date: Wed, 13 Mar 2013 13:39:59 -0700
Message-Id: <1363207202-10858-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363207202-10858-1-git-send-email-dianders@chromium.org>
References: <1363129994-10438-1-git-send-email-dianders@chromium.org>
 <1363207202-10858-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The exynos ADC won't work without a regulator called "vdd" and a clock
called "adc".  Document this fact in the device tree bindings.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v2: None

 Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
index f686378..96db940 100644
--- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
+++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
@@ -20,6 +20,9 @@ Required properties:
 			format is being dependent on which interrupt controller
 			the Samsung device uses.
 - #io-channel-cells = <1>; As ADC has multiple outputs
+- clocks		From common clock binding: handle to adc clock.
+- clock-names		From common clock binding: Shall be "adc".
+- vdd-supply		VDD input supply.
 
 Note: child nodes can be added for auto probing from device tree.
 
@@ -31,6 +34,11 @@ adc: adc@12D10000 {
 	interrupts = <0 106 0>;
 	#io-channel-cells = <1>;
 	io-channel-ranges;
+
+	clocks = <&clock 303>;
+	clock-names = "adc";
+
+	vdd-supply = <&buck5_reg>;
 };
 
 
-- 
1.8.1.3

