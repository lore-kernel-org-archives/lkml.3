Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbaIVSSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:18:21 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:33700 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbaIVSSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:18:20 -0400
From: Johannes Pointner <johannes.pointner@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        AnilKumar Ch <anilkumar@ti.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: tps65217: add compatible string for subdevices
Date: Mon, 22 Sep 2014 20:18:15 +0200
Message-ID: <5439652.jHp5aCCfrZ@lenovobook>
User-Agent: KMail/4.14 (Linux/3.16.3-1-ARCH; KDE/4.14.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TPS65217 is missing of_compatible string in the mfd_cell for its
subdevices. This compatible string is necessary to use functions like
of_find_backlight_by_node in backlight.c.

Signed-off-by: Johannes Pointner <johannes.pointner@br-automation.com>
---
 Documentation/devicetree/bindings/regulator/tps65217.txt            | 5 ++++-
 .../devicetree/bindings/video/backlight/tps65217-backlight.txt      | 6 +++---
 drivers/mfd/tps65217.c                                              | 2 ++
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/tps65217.txt b/Documentation/devicetree/bindings/regulator/tps65217.txt
index 4f05d20..ba835e2 100644
--- a/Documentation/devicetree/bindings/regulator/tps65217.txt
+++ b/Documentation/devicetree/bindings/regulator/tps65217.txt
@@ -5,6 +5,7 @@ Required properties:
 - reg: I2C slave address
 - regulators: list of regulators provided by this controller, must be named
   after their hardware counterparts: dcdc[1-3] and ldo[1-4]
+- compatible: "ti,tps65217-pmic"
 - regulators: This is the list of child nodes that specify the regulator
   initialization data for defined regulators. Not all regulators for the given
   device need to be present. The definition for each of these nodes is defined
@@ -23,9 +24,11 @@ Example:
 
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
index 5fb9279..c3fb649 100644
--- a/Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt
+++ b/Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt
@@ -7,18 +7,18 @@ Required properties:
 - compatible: "ti,tps65217"
 - reg: I2C slave address
 - backlight: node for specifying WLED1 and WLED2 lines in TPS65217
+- compatible: "ti,tps65217-bl"
 - isel: selection bit, valid values: 1 for ISEL1 (low-level) and 2 for ISEL2 (high-level)
 - fdim: PWM dimming frequency, valid values: 100, 200, 500, 1000
 - default-brightness: valid values: 0-100
 
-Each regulator is defined using the standard binding for regulators.
-
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
diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
index 3cc4c70..77708f9 100644
--- a/drivers/mfd/tps65217.c
+++ b/drivers/mfd/tps65217.c
@@ -33,9 +33,11 @@
 static const struct mfd_cell tps65217s[] = {
 	{
 		.name = "tps65217-pmic",
+		.of_compatible = "ti,tps65217-pmic",
 	},
 	{
 		.name = "tps65217-bl",
+		.of_compatible = "ti,tps65217-bl",
 	},
 };
 
-- 
2.1.0


