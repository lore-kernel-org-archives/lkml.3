Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab3GIM3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 08:29:21 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:48325 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab3GIM3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 08:29:19 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Mark Brown <broonie@kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc: Bo Shen <voice.shen@atmel.com>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree-discuss@lists.ozlabs.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH v3 3/7] Documentation: DT: update atmel SSC with DMA binding
Date: Tue,  9 Jul 2013 14:28:45 +0200
Message-Id: <1373372929-17800-4-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1373372929-17800-1-git-send-email-richard.genoud@gmail.com>
References: <1373290193-25300-1-git-send-email-richard.genoud@gmail.com>
 <1373372929-17800-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As atmel-ssc can be used with DMA, the documentation should be updated.
Also, a configuration DMA example is given.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 .../devicetree/bindings/misc/atmel-ssc.txt         |   24 ++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/misc/atmel-ssc.txt b/Documentation/devicetree/bindings/misc/atmel-ssc.txt
index 38e51ad..96958ca 100644
--- a/Documentation/devicetree/bindings/misc/atmel-ssc.txt
+++ b/Documentation/devicetree/bindings/misc/atmel-ssc.txt
@@ -6,10 +6,30 @@ Required properties:
 	- atmel,at91sam9g45-ssc: support dma transfer
 - reg: Should contain SSC registers location and length
 - interrupts: Should contain SSC interrupt
+For dma transfer:
+- dmas: DMA specifier, consisting of a phandle to DMA controller node,
+  the memory interface and SSC DMA channel ID (for tx and rx).
+  See Documentation/devicetree/bindings/dma/atmel-dma.txt for details.
+- dma-names: Must be "tx", "rx".
 
-Example:
+
+Examples:
 ssc0: ssc@fffbc000 {
 	compatible = "atmel,at91rm9200-ssc";
 	reg = <0xfffbc000 0x4000>;
-	interrupts = <14 4 5>;
+	interrupts = <14 IRQ_TYPE_LEVEL_HIGH 5>;
 };
+
+
+ssc0: ssc@f0010000 {
+      compatible = "atmel,at91sam9g45-ssc";
+      reg = <0xf0010000 0x4000>;
+      interrupts = <28 IRQ_TYPE_LEVEL_HIGH 5>;
+      dmas = <&dma0 1 AT91_DMA_CFG_PER_ID(13)>,
+	     <&dma0 1 AT91_DMA_CFG_PER_ID(14)>;
+      dma-names = "tx", "rx";
+      pinctrl-names = "default";
+      pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
+      status = "disabled";
+};
+
-- 
1.7.10.4

