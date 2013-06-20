Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965609Ab3FTVJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 17:09:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37427 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422849Ab3FTVIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 17:08:01 -0400
From: Joel A Fernandes <joelagnel@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>
CC: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Joel A Fernandes <joelagnel@ti.com>
Subject: [PATCH v12 08/11] spi: omap2-mcspi: add generic DMA request support to the DT binding
Date: Thu, 20 Jun 2013 16:06:44 -0500
Message-ID: <1371762407-24544-9-git-send-email-joelagnel@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1371762407-24544-1-git-send-email-joelagnel@ti.com>
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Porter <mporter@ti.com>

The binding definition is based on the generic DMA request binding

Signed-off-by: Matt Porter <mporter@ti.com>
Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
---
 Documentation/devicetree/bindings/spi/omap-spi.txt |   27 +++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/spi/omap-spi.txt b/Documentation/devicetree/bindings/spi/omap-spi.txt
index 938809c..4c85c4c 100644
--- a/Documentation/devicetree/bindings/spi/omap-spi.txt
+++ b/Documentation/devicetree/bindings/spi/omap-spi.txt
@@ -10,7 +10,18 @@ Required properties:
 			  input. The default is D0 as input and
 			  D1 as output.
 
-Example:
+Optional properties:
+- dmas: List of DMA specifiers with the controller specific format
+	as described in the generic DMA client binding. A tx and rx
+	specifier is required for each chip select.
+- dma-names: List of DMA request names. These strings correspond
+	1:1 with the DMA specifiers listed in dmas. The string naming
+	is to be "rxN" and "txN" for RX and TX requests,
+	respectively, where N equals the chip select number.
+
+Examples:
+
+[hwmod populated DMA resources]
 
 mcspi1: mcspi@1 {
     #address-cells = <1>;
@@ -20,3 +31,17 @@ mcspi1: mcspi@1 {
     ti,spi-num-cs = <4>;
 };
 
+[generic DMA request binding]
+
+mcspi1: mcspi@1 {
+    #address-cells = <1>;
+    #size-cells = <0>;
+    compatible = "ti,omap4-mcspi";
+    ti,hwmods = "mcspi1";
+    ti,spi-num-cs = <2>;
+    dmas = <&edma 42
+	    &edma 43
+	    &edma 44
+	    &edma 45>;
+    dma-names = "tx0", "rx0", "tx1", "rx1";
+};
-- 
1.7.9.5

