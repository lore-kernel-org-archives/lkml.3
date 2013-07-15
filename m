Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964Ab3GOPZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 11:25:46 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:51189 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932602Ab3GOPZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 11:25:33 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: sameo@linux.intel.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org
Subject: [PATCH] typo fixes (coordiante -> coordinate) in am335x
Date: Mon, 15 Jul 2013 16:25:28 +0100
Message-Id: <1373901928-19605-1-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Did a grep for coordiante and replaced them all
with coordinate.

This applies to the mfd-next tree.

Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 .../bindings/input/touchscreen/ti-tsc-adc.txt      |    4 ++--
 arch/arm/boot/dts/am335x-evm.dts                   |    2 +-
 drivers/input/touchscreen/ti_am335x_tsc.c          |    2 +-
 drivers/mfd/ti_am335x_tscadc.c                     |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt b/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
index 491c97b..3e22aec 100644
--- a/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
+++ b/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
@@ -6,7 +6,7 @@ Required properties:
 	ti,wires: Wires refer to application modes i.e. 4/5/8 wire touchscreen
 		  support on the platform.
 	ti,x-plate-resistance: X plate resistance
-	ti,coordiante-readouts: The sequencer supports a total of 16
+	ti,coordinate-readouts: The sequencer supports a total of 16
 				programmable steps each step is used to
 				read a single coordinate. A single
                                 readout is enough but multiple reads can
@@ -34,7 +34,7 @@ Example:
 		tsc {
 			ti,wires = <4>;
 			ti,x-plate-resistance = <200>;
-			ti,coordiante-readouts = <5>;
+			ti,coordinate-readouts = <5>;
 			ti,wire-config = <0x00 0x11 0x22 0x33>;
 		};
 
diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index 0fa4c7f..e50b781 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -250,7 +250,7 @@
 	tsc {
 		ti,wires = <4>;
 		ti,x-plate-resistance = <200>;
-		ti,coordiante-readouts = <5>;
+		ti,coordinate-readouts = <5>;
 		ti,wire-config = <0x00 0x11 0x22 0x33>;
 	};
 
diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index 0e9f02a..6422f65 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -348,7 +348,7 @@ static int titsc_parse_dt(struct platform_device *pdev,
 	if (err < 0)
 		return err;
 
-	err = of_property_read_u32(node, "ti,coordiante-readouts",
+	err = of_property_read_u32(node, "ti,coordinate-readouts",
 			&ts_dev->coordinate_readouts);
 	if (err < 0)
 		return err;
diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index b003a16..dd31e23 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -106,7 +106,7 @@ static	int ti_tscadc_probe(struct platform_device *pdev)
 
 	node = of_get_child_by_name(pdev->dev.of_node, "tsc");
 	of_property_read_u32(node, "ti,wires", &tsc_wires);
-	of_property_read_u32(node, "ti,coordiante-readouts", &readouts);
+	of_property_read_u32(node, "ti,coordinate-readouts", &readouts);
 
 	node = of_get_child_by_name(pdev->dev.of_node, "adc");
 	of_property_for_each_u32(node, "ti,adc-channels", prop, cur, val) {
-- 
1.7.9.5

