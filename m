Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbaFWOQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:16:58 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49165 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753932AbaFWOQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:16:56 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: sergei.shtylyov@cogentembedded.com,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: mvebu: Fix the improper use of the compatible string armada38x using a wildcard
Date: Mon, 23 Jun 2014 16:16:51 +0200
Message-Id: <1403533011-21339-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wildcards in compatible strings should be avoid. "marvell,armada38x"
was recently introduced but was not yet used.

The armada 385 SoC is a superset of the armada 380 SoC (with more CPUs
and more PCIe slots). So this patch replaces the use of
"marvell,armada38x" by the "marvell,armada380" string.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
Hi,

This fix should be merged in 3.16 and maybe sent as a fix for 3.15
too.

The initial patch (ARM: mvebu: Fix missing binding documentation for
Armada 38x) was re-written after the review about the use of the
wildcards here:
http://thread.gmane.org/gmane.linux.kernel/1728755/focus=79339 and
there:
http://thread.gmane.org/gmane.linux.ports.arm.kernel/334225/focus=334311


Thanks,
Gregory

 Documentation/devicetree/bindings/arm/armada-38x.txt | 14 ++++++++++++--
 arch/arm/boot/dts/armada-380.dtsi                    |  2 +-
 arch/arm/boot/dts/armada-385-db.dts                  |  2 +-
 arch/arm/boot/dts/armada-385-rd.dts                  |  2 +-
 arch/arm/boot/dts/armada-385.dtsi                    |  2 +-
 arch/arm/boot/dts/armada-38x.dtsi                    |  2 +-
 6 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/armada-38x.txt b/Documentation/devicetree/bindings/arm/armada-38x.txt
index 11f2330a6554..ad9f8ed4d9bd 100644
--- a/Documentation/devicetree/bindings/arm/armada-38x.txt
+++ b/Documentation/devicetree/bindings/arm/armada-38x.txt
@@ -6,5 +6,15 @@ following property:
 
 Required root node property:
 
- - compatible: must contain either "marvell,armada380" or
-   "marvell,armada385" depending on the variant of the SoC being used.
+ - compatible: must contain "marvell,armada380"
+
+In addition, boards using the Marvell Armada 385 SoC shall have the
+following property before the previous one:
+
+Required root node property:
+
+compatible: must contain "marvell,armada385"
+
+Example:
+
+compatible = "marvell,a385-rd", "marvell,armada385", "marvell,armada380";
diff --git a/arch/arm/boot/dts/armada-380.dtsi b/arch/arm/boot/dts/armada-380.dtsi
index e69bc6759c39..4173a8ab34e7 100644
--- a/arch/arm/boot/dts/armada-380.dtsi
+++ b/arch/arm/boot/dts/armada-380.dtsi
@@ -16,7 +16,7 @@
 
 / {
 	model = "Marvell Armada 380 family SoC";
-	compatible = "marvell,armada380", "marvell,armada38x";
+	compatible = "marvell,armada380";
 
 	cpus {
 		#address-cells = <1>;
diff --git a/arch/arm/boot/dts/armada-385-db.dts b/arch/arm/boot/dts/armada-385-db.dts
index ff9637dd8d0f..4be6a2838a41 100644
--- a/arch/arm/boot/dts/armada-385-db.dts
+++ b/arch/arm/boot/dts/armada-385-db.dts
@@ -16,7 +16,7 @@
 
 / {
 	model = "Marvell Armada 385 Development Board";
-	compatible = "marvell,a385-db", "marvell,armada385", "marvell,armada38x";
+	compatible = "marvell,a385-db", "marvell,armada385", "marvell,armada380";
 
 	chosen {
 		bootargs = "console=ttyS0,115200 earlyprintk";
diff --git a/arch/arm/boot/dts/armada-385-rd.dts b/arch/arm/boot/dts/armada-385-rd.dts
index 40893255a3f0..aaca2861dc87 100644
--- a/arch/arm/boot/dts/armada-385-rd.dts
+++ b/arch/arm/boot/dts/armada-385-rd.dts
@@ -17,7 +17,7 @@
 
 / {
 	model = "Marvell Armada 385 Reference Design";
-	compatible = "marvell,a385-rd", "marvell,armada385", "marvell,armada38x";
+	compatible = "marvell,a385-rd", "marvell,armada385", "marvell,armada380";
 
 	chosen {
 		bootargs = "console=ttyS0,115200 earlyprintk";
diff --git a/arch/arm/boot/dts/armada-385.dtsi b/arch/arm/boot/dts/armada-385.dtsi
index f011009bf4cf..6283d7912f71 100644
--- a/arch/arm/boot/dts/armada-385.dtsi
+++ b/arch/arm/boot/dts/armada-385.dtsi
@@ -16,7 +16,7 @@
 
 / {
 	model = "Marvell Armada 385 family SoC";
-	compatible = "marvell,armada385", "marvell,armada38x";
+	compatible = "marvell,armada385", "marvell,armada380";
 
 	cpus {
 		#address-cells = <1>;
diff --git a/arch/arm/boot/dts/armada-38x.dtsi b/arch/arm/boot/dts/armada-38x.dtsi
index 3de364e81b52..689fa1a46728 100644
--- a/arch/arm/boot/dts/armada-38x.dtsi
+++ b/arch/arm/boot/dts/armada-38x.dtsi
@@ -20,7 +20,7 @@
 
 / {
 	model = "Marvell Armada 38x family SoC";
-	compatible = "marvell,armada38x";
+	compatible = "marvell,armada380";
 
 	aliases {
 		gpio0 = &gpio0;
-- 
1.8.1.2

