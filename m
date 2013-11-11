Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab3KKRNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:13:49 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45410 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab3KKRNk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:13:40 -0500
From: "Khoronzhuk, Ivan" <ivan.khoronzhuk@ti.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>
Subject: [PATCH 12/12] arm: dts: keystone: add AEMIF/NAND device entry
Thread-Topic: [PATCH 12/12] arm: dts: keystone: add AEMIF/NAND device entry
Thread-Index: AQHO3vrlXypMatxiDEiJPeSKB85waZogRHJ9
Date: Mon, 11 Nov 2013 17:13:01 +0000
Message-ID: <4F5844B3A985794BA902E12C070812375F8D71@DNCE04.ent.ti.com>
References: <1384187188-5776-1-git-send-email-ivan.khoronzhuk@ti.com>,<1384187188-5776-13-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1384187188-5776-13-git-send-email-ivan.khoronzhuk@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.56]
x-exclaimer-md-config: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add AEMIF/NAND device entry.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 arch/arm/boot/dts/keystone.dts |   63 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/arch/arm/boot/dts/keystone.dts b/arch/arm/boot/dts/keystone.dts
index 100bdf5..998da98 100644
--- a/arch/arm/boot/dts/keystone.dts
+++ b/arch/arm/boot/dts/keystone.dts
@@ -179,5 +179,68 @@
                        interrupts = <GIC_SPI 300 IRQ_TYPE_EDGE_RISING>;
                        clocks = <&clkspi>;
                };
+
+               aemif@021000A00 {
+                       compatible = "ti,keystone-aemif";
+                       #address-cells = <2>;
+                       #size-cells = <1>;
+                       clocks = <&clkaemif>;
+                       clock-names = "aemif";
+                       clock-ranges;
+
+                       reg = <0x2100A00 0x00000100>;
+                       ranges = <0 0 0x30000000 0x10000000
+                                 1 0 0x21000A00 0x00000100>;
+
+                       nand:cs0 {
+                               compatible = "ti,davinci-cs";
+                               #address-cells = <2>;
+                               #size-cells = <1>;
+                               clock-ranges;
+                               ranges;
+
+                               /* all timings in nanoseconds */
+                               ti,davinci-cs-ta = <12>;
+                               ti,davinci-cs-rhold = <6>;
+                               ti,davinci-cs-rstrobe = <23>;
+                               ti,davinci-cs-rsetup = <9>;
+                               ti,davinci-cs-whold = <8>;
+                               ti,davinci-cs-wstrobe = <23>;
+                               ti,davinci-cs-wsetup = <8>;
+
+                               nand@0,0 {
+                                       compatible = "ti,keystone-nand";
+                                       #address-cells = <1>;
+                                       #size-cells = <1>;
+                                       reg = <0 0 0x4000000
+                                              1 0 0x0000100>;
+
+                                       ti,davinci-chipselect = <0>;
+                                       ti,davinci-mask-ale = <0x2000>;
+                                       ti,davinci-mask-cle = <0x4000>;
+                                       ti,davinci-mask-chipsel = <0>;
+                                       nand-ecc-mode = "hw";
+                                       ti,davinci-ecc-bits = <4>;
+                                       nand-on-flash-bbt;
+
+                                       partition@0 {
+                                               label = "u-boot";
+                                               reg = <0x0 0x100000>;
+                                               read-only;
+                                       };
+
+                                       partition@100000 {
+                                               label = "params";
+                                               reg = <0x100000 0x80000>;
+                                               read-only;
+                                       };
+
+                                       partition@180000 {
+                                               label = "ubifs";
+                                               reg = <0x180000 0x7E80000>;
+                                       };
+                               };
+                       };
+               };
        };
 };
--
1.7.9.5

