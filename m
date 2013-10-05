Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab3JETFr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 15:05:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42295 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab3JETFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 15:05:09 -0400
From: Joel Fernandes <joelf@ti.com>
To: Mark Rutland <mark.rutland@arm.com>,
        Benoit Cousson <bcousson@baylibre.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Paul Walmsley <paul@pwsan.com>
Subject: [PATCH v3 1/3] ARM: dts: AM33XX: Add SHAM data and documentation
Date: Sat, 5 Oct 2013 14:04:35 -0500
Message-ID: <1380999877-20884-2-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380999877-20884-1-git-send-email-joelf@ti.com>
References: <1380999877-20884-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Mark A. Greer" <mgreer@animalcreek.com>

Add the generic AM33XX SHAM module's device tree data and
enable it for the am335x-evm, am335x-evmsk, and am335x-bone
platforms.  Also add Documentation file describing the data
for the SHAM module.

[joelf@ti.com: Dropped interrupt-parrent property, documentation fixups]
CC: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
---
 .../devicetree/bindings/crypto/omap-sham.txt       | 28 ++++++++++++++++++++++
 arch/arm/boot/dts/am335x-bone.dts                  |  4 ++++
 arch/arm/boot/dts/am335x-evm.dts                   |  4 ++++
 arch/arm/boot/dts/am335x-evmsk.dts                 |  4 ++++
 arch/arm/boot/dts/am33xx.dtsi                      |  9 +++++++
 5 files changed, 49 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/omap-sham.txt

diff --git a/Documentation/devicetree/bindings/crypto/omap-sham.txt b/Documentation/devicetree/bindings/crypto/omap-sham.txt
new file mode 100644
index 0000000..f839acd
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/omap-sham.txt
@@ -0,0 +1,28 @@
+OMAP SoC SHA crypto Module
+
+Required properties:
+
+- compatible : Should contain entries for this and backward compatible
+  SHAM versions:
+  - "ti,omap2-sham" for OMAP2 & OMAP3.
+  - "ti,omap4-sham" for OMAP4 and AM33XX.
+  Note that these two versions are incompatible.
+- ti,hwmods: Name of the hwmod associated with the SHAM module
+- reg : Offset and length of the register set for the module
+- interrupts : the interrupt-specifier for the SHAM module.
+
+Optional properties:
+- dmas: DMA specifiers for the rx dma. See the DMA client binding,
+	Documentation/devicetree/bindings/dma/dma.txt
+- dma-names: DMA request name. Should be "rx" if a dma is present.
+
+Example:
+	/* AM335x */
+	sham: sham@53100000 {
+		compatible = "ti,omap4-sham";
+		ti,hwmods = "sham";
+		reg = <0x53100000 0x200>;
+		interrupts = <109>;
+		dmas = <&edma 36>;
+		dma-names = "rx";
+	};
diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone.dts
index 0d63348..8a9802e 100644
--- a/arch/arm/boot/dts/am335x-bone.dts
+++ b/arch/arm/boot/dts/am335x-bone.dts
@@ -19,3 +19,7 @@
 &mmc1 {
 	vmmc-supply = <&ldo3_reg>;
 };
+
+&sham {
+	status = "okay";
+};
diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index 23b0a3e..d59e51c 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -522,3 +522,7 @@
 	status = "okay";
 	vmmc-supply = <&vmmc_reg>;
 };
+
+&sham {
+	status = "okay";
+};
diff --git a/arch/arm/boot/dts/am335x-evmsk.dts b/arch/arm/boot/dts/am335x-evmsk.dts
index bc93895..d45a330 100644
--- a/arch/arm/boot/dts/am335x-evmsk.dts
+++ b/arch/arm/boot/dts/am335x-evmsk.dts
@@ -424,3 +424,7 @@
 	status = "okay";
 	vmmc-supply = <&vmmc_reg>;
 };
+
+&sham {
+	status = "okay";
+};
diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 553adc6..299710b 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -710,5 +710,14 @@
 			#size-cells = <1>;
 			status = "disabled";
 		};
+
+		sham: sham@53100000 {
+			compatible = "ti,omap4-sham";
+			ti,hwmods = "sham";
+			reg = <0x53100000 0x200>;
+			interrupts = <109>;
+			dmas = <&edma 36>;
+			dma-names = "rx";
+		};
 	};
 };
-- 
1.8.1.2

