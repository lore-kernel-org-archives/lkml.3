Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301AbaKZJe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 04:34:28 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:64314 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaKZJe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 04:34:26 -0500
From: Johan Hovold <johan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, Felipe Balbi <balbi@ti.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH] rtc: omap: drop vendor-prefix from power-controller dt property
Date: Wed, 26 Nov 2014 10:33:35 +0100
Message-Id: <1416994415-22367-1-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop the vendor-prefix from the "ti,system-power-controller" device-tree
property name.

It has been agreed to make "system-power-controller" a standard property
and to drop the vendor-prefix that is currently used by several drivers.

Note that drivers that have used "<vendor>,system-power-controller" in a
released kernel will need to support both versions.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 Documentation/devicetree/bindings/rtc/rtc-omap.txt | 4 ++--
 arch/arm/boot/dts/am335x-boneblack.dts             | 2 +-
 drivers/rtc/rtc-omap.c                             | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/rtc/rtc-omap.txt b/Documentation/devicetree/bindings/rtc/rtc-omap.txt
index 750efd40c72e..4ba4dbd34289 100644
--- a/Documentation/devicetree/bindings/rtc/rtc-omap.txt
+++ b/Documentation/devicetree/bindings/rtc/rtc-omap.txt
@@ -13,7 +13,7 @@ Required properties:
 - interrupt-parent: phandle for the interrupt controller
 
 Optional properties:
-- ti,system-power-controller: whether the rtc is controlling the system power
+- system-power-controller: whether the rtc is controlling the system power
   through pmic_power_en
 
 Example:
@@ -24,5 +24,5 @@ rtc@1c23000 {
 	interrupts = <19
 		      19>;
 	interrupt-parent = <&intc>;
-	ti,system-power-controller;
+	system-power-controller;
 };
diff --git a/arch/arm/boot/dts/am335x-boneblack.dts b/arch/arm/boot/dts/am335x-boneblack.dts
index 0c8cdc9520b7..d4affb7e3b61 100644
--- a/arch/arm/boot/dts/am335x-boneblack.dts
+++ b/arch/arm/boot/dts/am335x-boneblack.dts
@@ -77,5 +77,5 @@
 };
 
 &rtc {
-	ti,system-power-controller;
+	system-power-controller;
 };
diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index fba13e53c278..4f1c6ca97211 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -502,7 +502,7 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 		rtc->type = of_id->data;
 		rtc->is_pmic_controller = rtc->type->has_pmic_mode &&
 				of_property_read_bool(pdev->dev.of_node,
-						"ti,system-power-controller");
+						"system-power-controller");
 	} else {
 		id_entry = platform_get_device_id(pdev);
 		rtc->type = (void *)id_entry->driver_data;
-- 
2.0.4

