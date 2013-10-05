Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab3JETFM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 15:05:12 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45520 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab3JETFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 15:05:06 -0400
From: Joel Fernandes <joelf@ti.com>
To: Mark Rutland <mark.rutland@arm.com>,
        Benoit Cousson <bcousson@baylibre.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Paul Walmsley <paul@pwsan.com>
Subject: [PATCH v3 2/3] ARM: dts: AM33XX: Add AES data and documentation
Date: Sat, 5 Oct 2013 14:04:36 -0500
Message-ID: <1380999877-20884-3-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380999877-20884-1-git-send-email-joelf@ti.com>
References: <1380999877-20884-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Mark A. Greer" <mgreer@animalcreek.com>

Add the generic AM33XX AES module's device tree data and
enable it for the am335x-evm, am335x-evmsk, and am335x-bone
platforms.  Also add Documentation file describing the data
for the AES module.

[joelf@ti.com: Dropped interrupt-parent propert, documentation fixups]

CC: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
---
 .../devicetree/bindings/crypto/omap-aes.txt        | 31 ++++++++++++++++++++++
 arch/arm/boot/dts/am335x-bone.dts                  |  4 +++
 arch/arm/boot/dts/am335x-evm.dts                   |  4 +++
 arch/arm/boot/dts/am335x-evmsk.dts                 |  4 +++
 arch/arm/boot/dts/am33xx.dtsi                      | 10 +++++++
 5 files changed, 53 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/omap-aes.txt

diff --git a/Documentation/devicetree/bindings/crypto/omap-aes.txt b/Documentation/devicetree/bindings/crypto/omap-aes.txt
new file mode 100644
index 0000000..fd97176
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/omap-aes.txt
@@ -0,0 +1,31 @@
+OMAP SoC AES crypto Module
+
+Required properties:
+
+- compatible : Should contain entries for this and backward compatible
+  AES versions:
+  - "ti,omap2-aes" for OMAP2.
+  - "ti,omap3-aes" for OMAP3.
+  - "ti,omap4-aes" for OMAP4 and AM33XX.
+  Note that the OMAP2 and 3 versions are compatible (OMAP3 supports
+  more algorithms) but they are incompatible with OMAP4.
+- ti,hwmods: Name of the hwmod associated with the AES module
+- reg : Offset and length of the register set for the module
+- interrupts : the interrupt-specifier for the AES module.
+
+Optional properties:
+- dmas: DMA specifiers for tx and rx dma. See the DMA client binding,
+	Documentation/devicetree/bindings/dma/dma.txt
+- dma-names: DMA request names should include "tx" and "rx" if present.
+
+Example:
+	/* AM335x */
+	aes: aes@53500000 {
+		compatible = "ti,omap4-aes";
+		ti,hwmods = "aes";
+		reg = <0x53500000 0xa0>;
+		interrupts = <102>;
+		dmas = <&edma 6>,
+		       <&edma 5>;
+		dma-names = "tx", "rx";
+	};
diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone.dts
index 8a9802e..94ee427 100644
--- a/arch/arm/boot/dts/am335x-bone.dts
+++ b/arch/arm/boot/dts/am335x-bone.dts
@@ -23,3 +23,7 @@
 &sham {
 	status = "okay";
 };
+
+&aes {
+	status = "okay";
+};
diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index d59e51c..86463fa 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -526,3 +526,7 @@
 &sham {
 	status = "okay";
 };
+
+&aes {
+	status = "okay";
+};
diff --git a/arch/arm/boot/dts/am335x-evmsk.dts b/arch/arm/boot/dts/am335x-evmsk.dts
index d45a330..f577e65 100644
--- a/arch/arm/boot/dts/am335x-evmsk.dts
+++ b/arch/arm/boot/dts/am335x-evmsk.dts
@@ -428,3 +428,7 @@
 &sham {
 	status = "okay";
 };
+
+&aes {
+	status = "okay";
+};
diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 299710b..2664da9 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -719,5 +719,15 @@
 			dmas = <&edma 36>;
 			dma-names = "rx";
 		};
+
+		aes: aes@53500000 {
+			compatible = "ti,omap4-aes";
+			ti,hwmods = "aes";
+			reg = <0x53500000 0xa0>;
+			interrupts = <102>;
+			dmas = <&edma 6>,
+			       <&edma 5>;
+			dma-names = "tx", "rx";
+		};
 	};
 };
-- 
1.8.1.2

