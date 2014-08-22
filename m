Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769AbaHVRMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 13:12:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52526 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932297AbaHVRMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 13:12:48 -0400
From: Dan Murphy <dmurphy@ti.com>
To: <devicetree@vger.kernel.org>, <linux-input@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <dmitry.torokhov@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH v2] doc: dt/bindings: input: Fix drv260x binding document
Date: Fri, 22 Aug 2014 12:12:19 -0500
Message-ID: <1408727539-15996-1-git-send-email-dmurphy@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the drv260x dt binding document:
- Change the node name to the devices function not the
device name.
- Add vbat-supply to the example.
- Fix indentation of the example.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---

v2 - Address comments on indentation, node declaration, add vbat-supply,
removed description as it did not make sense - https://patchwork.kernel.org/patch/4765141/

 .../devicetree/bindings/input/ti,drv260x.txt       |   23 ++++++++++----------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/input/ti,drv260x.txt b/Documentation/devicetree/bindings/input/ti,drv260x.txt
index a9c8519..ee09c8f 100644
--- a/Documentation/devicetree/bindings/input/ti,drv260x.txt
+++ b/Documentation/devicetree/bindings/input/ti,drv260x.txt
@@ -1,6 +1,4 @@
-Texas Instruments - drv260x Haptics driver family
-
-The drv260x family serial control bus communicates through I2C protocols
+* Texas Instruments - drv260x Haptics driver family
 
 Required properties:
 	- compatible - One of:
@@ -37,15 +35,16 @@ Optional properties:
 			  3.2 v.
 Example:
 
-drv2605l: drv2605l@5a {
-		compatible = "ti,drv2605l";
-		reg = <0x5a>;
-		enable-gpio = <&gpio1 28 GPIO_ACTIVE_HIGH>;
-		mode = <DRV260X_LRA_MODE>;
-		library-sel = <DRV260X_LIB_LRA>;
-		vib-rated-mv = <3200>;
-		vib-overdriver-mv = <3200>;
-};
+haptics: haptics@5a {
+	compatible = "ti,drv2605l";
+	reg = <0x5a>;
+	vbat-supply = <&vbat>;
+	enable-gpio = <&gpio1 28 GPIO_ACTIVE_HIGH>;
+	mode = <DRV260X_LRA_MODE>;
+	library-sel = <DRV260X_LIB_LRA>;
+	vib-rated-mv = <3200>;
+	vib-overdriver-mv = <3200>;
+}
 
 For more product information please see the link below:
 http://www.ti.com/product/drv2605
-- 
1.7.9.5

