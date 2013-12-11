Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab3LKLRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:17:22 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:60418 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3LKLQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:16:23 -0500
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 4/5] dt/bindings: remove device_type "network" references
Date: Wed, 11 Dec 2013 11:15:54 +0000
Message-Id: <1386760555-22732-5-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386760555-22732-1-git-send-email-grant.likely@linaro.org>
References: <1386760555-22732-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_type is deprecated and the kernel doesn't require it in most
cases. The only exceptions for flat tree users are the "gianfar",
"ucc_geth" and "ibm,emac" bindings, and arguably that requirement could
be relaxed for ucc_geth and ibm,emac (that is a task for separate
patches though).

This patch removes references to device_type="network" from the binding
documentation where possible and removes the properties from ARM and
microblaze dts files. This patch does not modify the powerpc .dts files
since there are a much larger number of them affected and I think the
ucc_geth, ibm,emac and gianfar users should be addressed before clearing
out the references to reduce the chance of breakage.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Michal Simek <monstr@monstr.eu>
---
 Documentation/devicetree/bindings/marvell.txt                    | 2 --
 Documentation/devicetree/bindings/net/marvell-orion-net.txt      | 2 --
 Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/network.txt | 1 -
 arch/arm/boot/dts/dove.dtsi                                      | 1 -
 arch/arm/boot/dts/kirkwood.dtsi                                  | 2 --
 arch/arm/boot/dts/orion5x.dtsi                                   | 1 -
 arch/microblaze/platform/generic/system.dts                      | 1 -
 7 files changed, 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/marvell.txt b/Documentation/devicetree/bindings/marvell.txt
index a5409ca27bc2..bc287efea475 100644
--- a/Documentation/devicetree/bindings/marvell.txt
+++ b/Documentation/devicetree/bindings/marvell.txt
@@ -130,7 +130,6 @@ prefixed with the string "marvell,", for Marvell Technology Group Ltd.
    Ethernet port node
 
    Required properties:
-     - device_type : Should be "network".
      - compatible : Should be "marvell,mv64360-eth".
      - reg : Should be <0>, <1>, or <2>, according to which registers
        within the silicon block the device uses.
@@ -143,7 +142,6 @@ prefixed with the string "marvell,", for Marvell Technology Group Ltd.
 
    Example Discovery Ethernet port node:
      ethernet@0 {
-	     device_type = "network";
 	     compatible = "marvell,mv64360-eth";
 	     reg = <0>;
 	     interrupts = <32>;
diff --git a/Documentation/devicetree/bindings/net/marvell-orion-net.txt b/Documentation/devicetree/bindings/net/marvell-orion-net.txt
index 4a10716ff59d..c233b6114242 100644
--- a/Documentation/devicetree/bindings/net/marvell-orion-net.txt
+++ b/Documentation/devicetree/bindings/net/marvell-orion-net.txt
@@ -32,7 +32,6 @@ Optional controller properties:
 * Ethernet port node
 
 Required port properties:
- - device_type: shall be "network".
  - compatible: shall be one of "marvell,orion-eth-port",
       "marvell,kirkwood-eth-port".
  - reg: port number relative to ethernet controller, shall be 0, 1, or 2.
@@ -74,7 +73,6 @@ eth: ethernet-controller@72000 {
 	marvell,tx-checksum-limit = <1600>;
 
 	ethernet@0 {
-		device_type = "network";
 		compatible = "marvell,orion-eth-port";
 		reg = <0>;
 		interrupts = <29>;
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/network.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/network.txt
index 38cc6c9849ec..29b28b8f9a89 100644
--- a/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/network.txt
+++ b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/network.txt
@@ -10,7 +10,6 @@ Currently defined compatibles:
 Example:
 
 	ethernet@11300 {
-		device_type = "network";
 		compatible = "fsl,mpc8272-fcc-enet",
 			     "fsl,cpm2-fcc-enet";
 		reg = <11300 20 8400 100 11390 1>;
diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index 9311edf441c6..39ffabe04cc5 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -573,7 +573,6 @@
 				status = "disabled";
 
 				ethernet-port@0 {
-					device_type = "network";
 					compatible = "marvell,orion-eth-port";
 					reg = <0>;
 					interrupts = <29>;
diff --git a/arch/arm/boot/dts/kirkwood.dtsi b/arch/arm/boot/dts/kirkwood.dtsi
index 8b73c80f1dad..2c9d3808d61d 100644
--- a/arch/arm/boot/dts/kirkwood.dtsi
+++ b/arch/arm/boot/dts/kirkwood.dtsi
@@ -253,7 +253,6 @@
 			status = "disabled";
 
 			ethernet0-port@0 {
-				device_type = "network";
 				compatible = "marvell,kirkwood-eth-port";
 				reg = <0>;
 				interrupts = <11>;
@@ -273,7 +272,6 @@
 			status = "disabled";
 
 			ethernet1-port@0 {
-				device_type = "network";
 				compatible = "marvell,kirkwood-eth-port";
 				reg = <0>;
 				interrupts = <15>;
diff --git a/arch/arm/boot/dts/orion5x.dtsi b/arch/arm/boot/dts/orion5x.dtsi
index e06c37e91ac6..b1645462e270 100644
--- a/arch/arm/boot/dts/orion5x.dtsi
+++ b/arch/arm/boot/dts/orion5x.dtsi
@@ -154,7 +154,6 @@
 			status = "disabled";
 
 			ethernet-port@0 {
-				device_type = "network";
 				compatible = "marvell,orion-eth-port";
 				reg = <0>;
 				/* overwrite MAC address in bootloader */
diff --git a/arch/microblaze/platform/generic/system.dts b/arch/microblaze/platform/generic/system.dts
index 3f85df2b73b3..b620da23febb 100644
--- a/arch/microblaze/platform/generic/system.dts
+++ b/arch/microblaze/platform/generic/system.dts
@@ -222,7 +222,6 @@
 			ranges ;
 			ethernet@81c00000 {
 				compatible = "xlnx,xps-ll-temac-1.01.b", "xlnx,xps-ll-temac-1.00.a";
-				device_type = "network";
 				interrupt-parent = <&xps_intc_0>;
 				interrupts = < 5 2 >;
 				llink-connected = <&PIM3>;
-- 
1.8.3.2

