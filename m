Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab3LKLRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:17:19 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:56190 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab3LKLQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:16:24 -0500
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3/5] dt/bindings: remove users of device_type "mdio"
Date: Wed, 11 Dec 2013 11:15:53 +0000
Message-Id: <1386760555-22732-4-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386760555-22732-1-git-send-email-grant.likely@linaro.org>
References: <1386760555-22732-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_type is a deprecated property, but some MDIO bus nodes still have
it. Except for a couple of old binding (compatible="gianfar" and
compatible="ucc_geth_phy") the kernel doesn't look for
device_type="mdio" at all.

This patch removes all instances of device_type="mdio" from the binding
documentation and the .dts files.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 Documentation/devicetree/bindings/marvell.txt                    | 2 --
 Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/network.txt | 1 -
 arch/powerpc/boot/dts/ep8248e.dts                                | 1 -
 arch/powerpc/boot/dts/holly.dts                                  | 1 -
 arch/powerpc/boot/dts/mpc7448hpc2.dts                            | 1 -
 arch/powerpc/boot/dts/mpc8272ads.dts                             | 1 -
 arch/powerpc/boot/dts/pq2fads.dts                                | 1 -
 arch/powerpc/boot/dts/prpmc2800.dts                              | 1 -
 8 files changed, 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/marvell.txt b/Documentation/devicetree/bindings/marvell.txt
index 73a3d251acb1..a5409ca27bc2 100644
--- a/Documentation/devicetree/bindings/marvell.txt
+++ b/Documentation/devicetree/bindings/marvell.txt
@@ -79,7 +79,6 @@ prefixed with the string "marvell,", for Marvell Technology Group Ltd.
    Required properties:
      - #address-cells : Should be <1>
      - #size-cells : Should be <0>
-     - device_type : Should be "mdio"
      - compatible : Should be "marvell,mv64360-mdio"
 
    Example:
@@ -87,7 +86,6 @@ prefixed with the string "marvell,", for Marvell Technology Group Ltd.
      mdio {
 	     #address-cells = <1>;
 	     #size-cells = <0>;
-	     device_type = "mdio";
 	     compatible = "marvell,mv64360-mdio";
 
 	     ethernet-phy@0 {
diff --git a/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/network.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/network.txt
index 0e4269446580..38cc6c9849ec 100644
--- a/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/network.txt
+++ b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/network.txt
@@ -33,7 +33,6 @@ fsl,mdc-pin : pin of port C controlling mdio clock
 
 Example:
 	mdio@10d40 {
-		device_type = "mdio";
 		compatible = "fsl,mpc8272ads-mdio-bitbang",
 			     "fsl,mpc8272-mdio-bitbang",
 			     "fsl,cpm2-mdio-bitbang";
diff --git a/arch/powerpc/boot/dts/ep8248e.dts b/arch/powerpc/boot/dts/ep8248e.dts
index 244934fa2419..8b3a49f34f5a 100644
--- a/arch/powerpc/boot/dts/ep8248e.dts
+++ b/arch/powerpc/boot/dts/ep8248e.dts
@@ -67,7 +67,6 @@
 			ranges;
 
 			mdio {
-				device_type = "mdio";
 				compatible = "fsl,ep8248e-mdio-bitbang";
 				#address-cells = <1>;
 				#size-cells = <0>;
diff --git a/arch/powerpc/boot/dts/holly.dts b/arch/powerpc/boot/dts/holly.dts
index c6e11ebecebb..43e6f0c8e449 100644
--- a/arch/powerpc/boot/dts/holly.dts
+++ b/arch/powerpc/boot/dts/holly.dts
@@ -58,7 +58,6 @@
 		};
 
 		MDIO: mdio@6000 {
-			device_type = "mdio";
 			compatible = "tsi109-mdio", "tsi108-mdio";
 			reg = <0x00006000 0x00000050>;
 			#address-cells = <1>;
diff --git a/arch/powerpc/boot/dts/mpc7448hpc2.dts b/arch/powerpc/boot/dts/mpc7448hpc2.dts
index 2544f3ecd6e9..20a0d22df473 100644
--- a/arch/powerpc/boot/dts/mpc7448hpc2.dts
+++ b/arch/powerpc/boot/dts/mpc7448hpc2.dts
@@ -68,7 +68,6 @@
 		};
 
 		MDIO: mdio@6000 {
-			device_type = "mdio";
 			compatible = "tsi108-mdio";
 			reg = <0x6000 0x50>;
 			#address-cells = <1>;
diff --git a/arch/powerpc/boot/dts/mpc8272ads.dts b/arch/powerpc/boot/dts/mpc8272ads.dts
index 0c92de74d065..6d2cddf64cfd 100644
--- a/arch/powerpc/boot/dts/mpc8272ads.dts
+++ b/arch/powerpc/boot/dts/mpc8272ads.dts
@@ -182,7 +182,6 @@
 			};
 
 			mdio@10d40 {
-				device_type = "mdio";
 				compatible = "fsl,mpc8272ads-mdio-bitbang",
 				             "fsl,mpc8272-mdio-bitbang",
 				             "fsl,cpm2-mdio-bitbang";
diff --git a/arch/powerpc/boot/dts/pq2fads.dts b/arch/powerpc/boot/dts/pq2fads.dts
index 9d065cdeb5eb..0c525ff0c257 100644
--- a/arch/powerpc/boot/dts/pq2fads.dts
+++ b/arch/powerpc/boot/dts/pq2fads.dts
@@ -198,7 +198,6 @@
 			};
 
 			mdio@10d40 {
-				device_type = "mdio";
 				compatible = "fsl,pq2fads-mdio-bitbang",
 				             "fsl,mpc8280-mdio-bitbang",
 				             "fsl,cpm2-mdio-bitbang";
diff --git a/arch/powerpc/boot/dts/prpmc2800.dts b/arch/powerpc/boot/dts/prpmc2800.dts
index 909e8b0ead26..77c8db238d1c 100644
--- a/arch/powerpc/boot/dts/prpmc2800.dts
+++ b/arch/powerpc/boot/dts/prpmc2800.dts
@@ -73,7 +73,6 @@
 		mdio {
 			#address-cells = <1>;
 			#size-cells = <0>;
-			device_type = "mdio";
 			compatible = "marvell,mv64360-mdio";
 			PHY0: ethernet-phy@1 {
 				compatible = "broadcom,bcm5421";
-- 
1.8.3.2

