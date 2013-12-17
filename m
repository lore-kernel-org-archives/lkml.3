Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab3LQQQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 11:16:29 -0500
Received: from 3.mo3.mail-out.ovh.net ([46.105.44.175]:50137 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753185Ab3LQQQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 11:16:26 -0500
X-Greylist: delayed 18443 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Dec 2013 11:16:26 EST
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Landley <rob@landley.net>, Jonathan Cameron <jic23@kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, Arnd Bergmann <arnd@arndb.de>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org, Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH] iio: at91: document ADC clock properties
Date: Tue, 17 Dec 2013 17:16:13 +0100
Message-Id: <1387296973-7779-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 8710806105196099682
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the clock properties required by the at91 ADC driver.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 .../devicetree/bindings/arm/atmel-adc.txt          |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/atmel-adc.txt b/Documentation/devicetree/bindings/arm/atmel-adc.txt
index d106146..9a1175b 100644
--- a/Documentation/devicetree/bindings/arm/atmel-adc.txt
+++ b/Documentation/devicetree/bindings/arm/atmel-adc.txt
@@ -5,6 +5,9 @@ Required properties:
     <chip> can be "at91sam9260", "at91sam9g45" or "at91sam9x5"
   - reg: Should contain ADC registers location and length
   - interrupts: Should contain the IRQ line for the ADC
+  - clock-names: tuple listing input clock names.
+	Required elements: "adc_clk", "adc_op_clk".
+  - clocks: phandles to input clocks.
   - atmel,adc-channels-used: Bitmask of the channels muxed and enable for this
     device
   - atmel,adc-startup-time: Startup Time of the ADC in microseconds as
@@ -44,6 +47,8 @@ adc0: adc@fffb0000 {
 	compatible = "atmel,at91sam9260-adc";
 	reg = <0xfffb0000 0x100>;
 	interrupts = <20 4>;
+	clocks = <&adc_clk>, <&adc_op_clk>;
+	clock-names = "adc_clk", "adc_op_clk";
 	atmel,adc-channel-base = <0x30>;
 	atmel,adc-channels-used = <0xff>;
 	atmel,adc-drdy-mask = <0x10000>;
-- 
1.7.9.5

