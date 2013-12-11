Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab3LKLQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:16:35 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:61605 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab3LKLQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:16:22 -0500
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 5/5] dt/bindings: Remove device_type "serial" from marvell,mv64360-mpsc
Date: Wed, 11 Dec 2013 11:15:55 +0000
Message-Id: <1386760555-22732-6-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386760555-22732-1-git-send-email-grant.likely@linaro.org>
References: <1386760555-22732-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_type is deprecated. There is no need to check for it in device
driver code and no need to specify it in the device tree. Remove the
property from stock .dts files and remove the check for it from device
drivers. This change should be 100% backwards compatible with old device
trees.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 Documentation/devicetree/bindings/marvell.txt | 2 --
 arch/powerpc/boot/dts/c2k.dts                 | 2 --
 arch/powerpc/boot/dts/prpmc2800.dts           | 2 --
 arch/powerpc/sysdev/mv64x60_dev.c             | 2 +-
 arch/powerpc/sysdev/mv64x60_udbg.c            | 2 +-
 5 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/marvell.txt b/Documentation/devicetree/bindings/marvell.txt
index bc287efea475..ea2b16ced49b 100644
--- a/Documentation/devicetree/bindings/marvell.txt
+++ b/Documentation/devicetree/bindings/marvell.txt
@@ -265,7 +265,6 @@ prefixed with the string "marvell,", for Marvell Technology Group Ltd.
    serial port.
 
    Required properties:
-     - device_type : "serial"
      - compatible : "marvell,mv64360-mpsc"
      - reg : Offset and length of the register set for this device
      - sdma : the phandle for the SDMA node used by this port
@@ -282,7 +281,6 @@ prefixed with the string "marvell,", for Marvell Technology Group Ltd.
 
    Example Discovery MPSCINTR node:
      mpsc@8000 {
-	     device_type = "serial";
 	     compatible = "marvell,mv64360-mpsc";
 	     reg = <0x8000 0x38>;
 	     virtual-reg = <0xf1008000>;
diff --git a/arch/powerpc/boot/dts/c2k.dts b/arch/powerpc/boot/dts/c2k.dts
index de2044b33336..1e32903cb0a8 100644
--- a/arch/powerpc/boot/dts/c2k.dts
+++ b/arch/powerpc/boot/dts/c2k.dts
@@ -171,7 +171,6 @@
 		};
 
 		MPSC0: mpsc@8000 {
-			device_type = "serial";
 			compatible = "marvell,mv64360-mpsc";
 			reg = <0x8000 0x38>;
 			virtual-reg = <0xd8008000>;
@@ -186,7 +185,6 @@
 		};
 
 		MPSC1: mpsc@9000 {
-			device_type = "serial";
 			compatible = "marvell,mv64360-mpsc";
 			reg = <0x9000 0x38>;
 			virtual-reg = <0xd8009000>;
diff --git a/arch/powerpc/boot/dts/prpmc2800.dts b/arch/powerpc/boot/dts/prpmc2800.dts
index 77c8db238d1c..00afaacf8c8c 100644
--- a/arch/powerpc/boot/dts/prpmc2800.dts
+++ b/arch/powerpc/boot/dts/prpmc2800.dts
@@ -159,7 +159,6 @@
 		};
 
 		MPSC0: mpsc@8000 {
-			device_type = "serial";
 			compatible = "marvell,mv64360-mpsc";
 			reg = <0x8000 0x38>;
 			virtual-reg = <0xf1008000>;
@@ -174,7 +173,6 @@
 		};
 
 		MPSC1: mpsc@9000 {
-			device_type = "serial";
 			compatible = "marvell,mv64360-mpsc";
 			reg = <0x9000 0x38>;
 			virtual-reg = <0xf1009000>;
diff --git a/arch/powerpc/sysdev/mv64x60_dev.c b/arch/powerpc/sysdev/mv64x60_dev.c
index a3a8fad8537d..c2dba7db71ad 100644
--- a/arch/powerpc/sysdev/mv64x60_dev.c
+++ b/arch/powerpc/sysdev/mv64x60_dev.c
@@ -448,7 +448,7 @@ static int __init mv64x60_device_setup(void)
 	int err;
 
 	id = 0;
-	for_each_compatible_node(np, "serial", "marvell,mv64360-mpsc") {
+	for_each_compatible_node(np, NULL, "marvell,mv64360-mpsc") {
 		err = mv64x60_mpsc_device_setup(np, id++);
 		if (err)
 			printk(KERN_ERR "Failed to initialize MV64x60 "
diff --git a/arch/powerpc/sysdev/mv64x60_udbg.c b/arch/powerpc/sysdev/mv64x60_udbg.c
index 50a81387e9b1..3b8734b870e9 100644
--- a/arch/powerpc/sysdev/mv64x60_udbg.c
+++ b/arch/powerpc/sysdev/mv64x60_udbg.c
@@ -85,7 +85,7 @@ static void mv64x60_udbg_init(void)
 	if (!stdout)
 		return;
 
-	for_each_compatible_node(np, "serial", "marvell,mv64360-mpsc") {
+	for_each_compatible_node(np, NULL, "marvell,mv64360-mpsc") {
 		if (np == stdout)
 			break;
 	}
-- 
1.8.3.2

