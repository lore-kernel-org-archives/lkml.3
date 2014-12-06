Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbaLFRfb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 12:35:31 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52270 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaLFRf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 12:35:29 -0500
Date: Sat, 6 Dec 2014 18:35:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg
Subject: N900: fixing MMC at boot
Message-ID: <20141206173526.GA7964@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

For a long time, MMC was not working during boot... (making the box
unusable without nfsroot). It seems problem is in the regulators,
because with diff below, I was able to mount root on SD card for a
first time ... in a long time.

Signed-off-by: Pavel Machek <pavel@ucw.cz> [but not for upstream]

diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
index 8607433..07791c6 100644
--- a/Documentation/devicetree/bindings/regulator/regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -4,7 +4,8 @@ Optional properties:
 - regulator-name: A string used as a descriptive name for regulator outputs
 - regulator-min-microvolt: smallest voltage consumers may set
 - regulator-max-microvolt: largest voltage consumers may set
-- regulator-microvolt-offset: Offset applied to voltages to compensate for voltage drops
+- regulator-microvolt-offset: Offset applied to voltages to compensate for 
+  voltage drops
 - regulator-min-microamp: smallest current consumers may set
 - regulator-max-microamp: largest current consumers may set
 - regulator-always-on: boolean, regulator should never be disabled
diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 11d8afd..707928d 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -287,31 +287,35 @@
 	regulator-name = "V28";
 	regulator-min-microvolt = <2800000>;
 	regulator-max-microvolt = <2800000>;
-	regulator-always-on; /* due battery cover sensor */
+	regulator-always-on; /* due to battery cover sensor */
 };
 
 &vaux2 {
 	regulator-name = "VCSI";
 	regulator-min-microvolt = <1800000>;
 	regulator-max-microvolt = <1800000>;
+	regulator-always-on; /* FIXME */
 };
 
 &vaux3 {
 	regulator-name = "VMMC2_30";
 	regulator-min-microvolt = <2800000>;
 	regulator-max-microvolt = <3000000>;
+	regulator-always-on; /* FIXME */
 };
 
 &vaux4 {
 	regulator-name = "VCAM_ANA_28";
 	regulator-min-microvolt = <2800000>;
 	regulator-max-microvolt = <2800000>;
+	regulator-always-on; /* FIXME */
 };
 
 &vmmc1 {
 	regulator-name = "VMMC1";
 	regulator-min-microvolt = <1850000>;
 	regulator-max-microvolt = <3150000>;
+	regulator-always-on; /* FIXME */
 };
 
 &vmmc2 {
@@ -339,13 +343,14 @@
 	regulator-name = "VMMC2_IO_18";
 	regulator-min-microvolt = <1800000>;
 	regulator-max-microvolt = <1800000>;
+	regulator-always-on; /* FIXME */
 };
 
 &vio {
 	regulator-name = "VIO";
 	regulator-min-microvolt = <1800000>;
 	regulator-max-microvolt = <1800000>;
-
+	regulator-always-on; /* FIXME */
 };
 
 &vintana1 {

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
