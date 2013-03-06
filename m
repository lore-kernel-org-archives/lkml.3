Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab3CFQQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 11:16:45 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:39212 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab3CFQPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 11:15:31 -0500
From: Matt Porter <mporter@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v9 8/9] spi: omap2-mcspi: add generic DMA request support to the DT binding
Date: Wed,  6 Mar 2013 11:15:38 -0500
Message-Id: <1362586540-10393-9-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362586540-10393-1-git-send-email-mporter@ti.com>
References: <1362586540-10393-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The binding definition is based on the generic DMA request binding

Signed-off-by: Matt Porter <mporter@ti.com>
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

