Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaIYGcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 02:32:55 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:63626 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaIYGcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 02:32:53 -0400
From: Johannes Pointner <johannes.pointner@gmail.com>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] dt: bindings: tps65217: add compatible property for  subnodes
Date: Thu, 25 Sep 2014 08:31:46 +0200
Message-ID: <1660410.j399mvljTo@lenovobook>
User-Agent: KMail/4.14 (Linux/3.16.3-1-ARCH; KDE/4.14.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for compatible property of subnodes.

Signed-off-by: Johannes Pointner <johannes.pointner@br-automation.com>
---
 Documentation/devicetree/bindings/regulator/tps65217.txt         | 7 ++++++-
 .../devicetree/bindings/video/backlight/tps65217-backlight.txt   | 9 ++++++---
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/tps65217.txt b/Documentation/devicetree/bindings/regulator/tps65217.txt
index 4f05d20..8ae3a3b 100644
--- a/Documentation/devicetree/bindings/regulator/tps65217.txt
+++ b/Documentation/devicetree/bindings/regulator/tps65217.txt
@@ -14,6 +14,9 @@ Required properties:
 Optional properties:
 - ti,pmic-shutdown-controller: Telling the PMIC to shutdown on PWR_EN toggle.
 
+Required subnode properties:
+- compatible: "ti,tps65217-pmic"
+
   The valid names for regulators are:
   tps65217: dcdc1, dcdc2, dcdc3, ldo1, ldo2, ldo3 and ldo4
 
@@ -23,9 +26,11 @@ Example:
 
 	tps: tps@24 {
 		compatible = "ti,tps65217";
+		reg = <0x24>;
 		ti,pmic-shutdown-controller;
 
-		regulators {
+		tps_pmic: regulators {
+			compatible = "ti,tps65217-pmic";
 			dcdc1_reg: dcdc1 {
 				regulator-min-microvolt = <900000>;
 				regulator-max-microvolt = <1800000>;
diff --git a/Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt b/Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt
index 5fb9279..f92f154 100644
--- a/Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt
+++ b/Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt
@@ -6,19 +6,22 @@ used to drive LEDs for use as backlights.
 Required properties:
 - compatible: "ti,tps65217"
 - reg: I2C slave address
-- backlight: node for specifying WLED1 and WLED2 lines in TPS65217
+- backlight: subnode for specifying WLED1 and WLED2 lines in TPS65217
+
+Required subnode properties:
+- compatible: "ti,tps65217-bl"
 - isel: selection bit, valid values: 1 for ISEL1 (low-level) and 2 for ISEL2 (high-level)
 - fdim: PWM dimming frequency, valid values: 100, 200, 500, 1000
 - default-brightness: valid values: 0-100
 
-Each regulator is defined using the standard binding for regulators.
 
 Example:
 
 	tps: tps@24 {
 		reg = <0x24>;
 		compatible = "ti,tps65217";
-		backlight {
+		tps_bl: backlight {
+			compatible = "ti,tps65217-bl";
 			isel = <1>;  /* 1 - ISET1, 2 ISET2 */
 			fdim = <100>; /* TPS65217_BL_FDIM_100HZ */
 			default-brightness = <50>;
-- 
2.1.0
