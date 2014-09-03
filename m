Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894AbaICQDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 12:03:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53643 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932547AbaICQDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 12:03:38 -0400
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>
CC: Tom Rini <trini@ti.com>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH] ARM: dts: am335x-bone*: Fix model name and update compatibility information
Date: Wed, 3 Sep 2014 11:03:10 -0500
Message-ID: <1409760190-17275-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Beaglebone white and beaglebone black differ in tiny little aspects.
This is the reason why we maintain seperate dts for these platforms.
However, there is no real way to decode from dtb which platform it is
since compatible and model name are the same for both platforms.

Fix this so that beaglebone black and beaglebone are identifiable,
while maintaining compatibility for older zImages which might use old
beaglebone compatible flag for black as well.

Reported-by: Tom Rini <trini@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
Based on v3.17-rc1:
Before:
beaglebone-black:  Boot PASS: http://paste.ubuntu.org.cn/1473558
beaglebone:  Boot PASS: http://paste.ubuntu.org.cn/1473559

After:
beaglebone-black:  Boot PASS: http://paste.ubuntu.org.cn/1473480
beaglebone:  Boot PASS: http://paste.ubuntu.org.cn/1473481

Side notes: Sorry, new IT policies, new paste website needed :(

 arch/arm/boot/dts/am335x-bone-common.dtsi |    3 ---
 arch/arm/boot/dts/am335x-bone.dts         |    5 +++++
 arch/arm/boot/dts/am335x-boneblack.dts    |    5 +++++
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi b/arch/arm/boot/dts/am335x-bone-common.dtsi
index bde1777..d9d9869 100644
--- a/arch/arm/boot/dts/am335x-bone-common.dtsi
+++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
@@ -7,9 +7,6 @@
  */
 
 / {
-	model = "TI AM335x BeagleBone";
-	compatible = "ti,am335x-bone", "ti,am33xx";
-
 	cpus {
 		cpu@0 {
 			cpu0-supply = <&dcdc2_reg>;
diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone.dts
index 94ee427..83d40f7 100644
--- a/arch/arm/boot/dts/am335x-bone.dts
+++ b/arch/arm/boot/dts/am335x-bone.dts
@@ -10,6 +10,11 @@
 #include "am33xx.dtsi"
 #include "am335x-bone-common.dtsi"
 
+/ {
+	model = "TI AM335x BeagleBone";
+	compatible = "ti,am335x-bone", "ti,am33xx";
+};
+
 &ldo3_reg {
 	regulator-min-microvolt = <1800000>;
 	regulator-max-microvolt = <3300000>;
diff --git a/arch/arm/boot/dts/am335x-boneblack.dts b/arch/arm/boot/dts/am335x-boneblack.dts
index 305975d..901739f 100644
--- a/arch/arm/boot/dts/am335x-boneblack.dts
+++ b/arch/arm/boot/dts/am335x-boneblack.dts
@@ -10,6 +10,11 @@
 #include "am33xx.dtsi"
 #include "am335x-bone-common.dtsi"
 
+/ {
+	model = "TI AM335x BeagleBone Black";
+	compatible = "ti,am335x-bone-black", "ti,am335x-bone", "ti,am33xx";
+};
+
 &ldo3_reg {
 	regulator-min-microvolt = <1800000>;
 	regulator-max-microvolt = <1800000>;
-- 
1.7.9.5

