Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab3HGPzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 11:55:18 -0400
Received: from smtp161.dfw.emailsrvr.com ([67.192.241.161]:35547 "EHLO
	smtp161.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023Ab3HGPx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 11:53:56 -0400
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, tj@kernel.org,
        devicetree@vger.kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob.herring@calxeda.com, sergei.shtylyov@cogentembedded.com
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: [PATCH v3 3/5] devicetree: create a separate binding description for sata_highbank
Date: Wed,  7 Aug 2013 10:52:36 -0500
Message-Id: <1375890758-30265-3-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375890758-30265-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1375890758-30265-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Calxeda sata_highbank driver has been adding its descriptions to the
ahci driver. Separate them properly.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
Acked-by: Rob Herring <rob.herring@calxeda.com>
---
Changes from v2
	Fixed some indenting.
Changes from v1
	None.

 .../devicetree/bindings/ata/ahci-platform.txt      | 18 +++---------
 .../devicetree/bindings/ata/sata_highbank.txt      | 32 ++++++++++++++++++++++
 2 files changed, 36 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/sata_highbank.txt

diff --git a/Documentation/devicetree/bindings/ata/ahci-platform.txt b/Documentation/devicetree/bindings/ata/ahci-platform.txt
index 3ec0c5c..89de156 100644
--- a/Documentation/devicetree/bindings/ata/ahci-platform.txt
+++ b/Documentation/devicetree/bindings/ata/ahci-platform.txt
@@ -4,27 +4,17 @@ SATA nodes are defined to describe on-chip Serial ATA controllers.
 Each SATA controller should have its own node.
 
 Required properties:
-- compatible        : compatible list, contains "calxeda,hb-ahci" or "snps,spear-ahci"
+- compatible        : compatible list, contains "snps,spear-ahci"
 - interrupts        : <interrupt mapping for SATA IRQ>
 - reg               : <registers mapping>
 
 Optional properties:
-- calxeda,port-phys: phandle-combophy and lane assignment, which maps each
-			SATA port to a combophy and a lane within that
-			combophy
-- calxeda,sgpio-gpio: phandle-gpio bank, bit offset, and default on or off,
-			which indicates that the driver supports SGPIO
-			indicator lights using the indicated GPIOs
-- calxeda,led-order : a u32 array that map port numbers to offsets within the
-			SGPIO bitstream.
 - dma-coherent      : Present if dma operations are coherent
 
 Example:
         sata@ffe08000 {
-		compatible = "calxeda,hb-ahci";
-                reg = <0xffe08000 0x1000>;
-                interrupts = <115>;
-		calxeda,port-phys = <&combophy5 0 &combophy0 0 &combophy0 1
-					&combophy0 2 &combophy0 3>;
+		compatible = "snps,spear-ahci";
+		reg = <0xffe08000 0x1000>;
+		interrupts = <115>;
 
         };
diff --git a/Documentation/devicetree/bindings/ata/sata_highbank.txt b/Documentation/devicetree/bindings/ata/sata_highbank.txt
new file mode 100644
index 0000000..1ac6d3d
--- /dev/null
+++ b/Documentation/devicetree/bindings/ata/sata_highbank.txt
@@ -0,0 +1,32 @@
+* Calxeda AHCI SATA Controller
+
+SATA nodes are defined to describe on-chip Serial ATA controllers.
+The Calxeda SATA controller mostly conforms to the AHCI interface
+with some special extensions to add functionality.
+Each SATA controller should have its own node.
+
+Required properties:
+- compatible        : compatible list, contains "calxeda,hb-ahci"
+- interrupts        : <interrupt mapping for SATA IRQ>
+- reg               : <registers mapping>
+
+Optional properties:
+- dma-coherent      : Present if dma operations are coherent
+- calxeda,port-phys: phandle-combophy and lane assignment, which maps each
+			SATA port to a combophy and a lane within that
+			combophy
+- calxeda,sgpio-gpio: phandle-gpio bank, bit offset, and default on or off,
+			which indicates that the driver supports SGPIO
+			indicator lights using the indicated GPIOs
+- calxeda,led-order : a u32 array that map port numbers to offsets within the
+			SGPIO bitstream.
+
+Example:
+        sata@ffe08000 {
+		compatible = "calxeda,hb-ahci";
+		reg = <0xffe08000 0x1000>;
+		interrupts = <115>;
+		calxeda,port-phys = <&combophy5 0 &combophy0 0 &combophy0 1
+					&combophy0 2 &combophy0 3>;
+
+        };
-- 
1.8.1.2

