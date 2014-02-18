Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbaBRXSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:18:49 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:53879 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387AbaBRXRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:17:22 -0500
From: Matt Porter <mporter@linaro.org>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Christian Daudt <bcm@fixthebug.org>
Cc: Devicetree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/5] mfd: add bcm590xx pmu DT binding
Date: Tue, 18 Feb 2014 18:17:08 -0500
Message-Id: <1392765432-9111-2-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1392765432-9111-1-git-send-email-mporter@linaro.org>
References: <1392765432-9111-1-git-send-email-mporter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a DT binding for the BCM590xx PMUs. The binding inherits from
the generic regulator bindings.

Signed-off-by: Matt Porter <mporter@linaro.org>
Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
---
 Documentation/devicetree/bindings/mfd/bcm590xx.txt | 49 ++++++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/bcm590xx.txt

diff --git a/Documentation/devicetree/bindings/mfd/bcm590xx.txt b/Documentation/devicetree/bindings/mfd/bcm590xx.txt
new file mode 100644
index 0000000..a4a8039
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/bcm590xx.txt
@@ -0,0 +1,49 @@
+-------------------------------
+BCM590xx Power Management Units
+-------------------------------
+
+Required properties:
+- compatible: "brcm,bcm59056"
+- reg: I2C slave address
+- interrupts: interrupt for the PMU. Generic interrupt client node bindings
+  are described in interrupt-controller/interrupts.txt
+
+-----------------------
+BCM590xx PMU Regulators
+-----------------------
+
+Required properties:
+- compatible: "brcm,bcm59056-regs"
+
+Optional properties:
+- regulators: This is the list of child nodes that specify the regulator
+  initialization data for defined regulators.  Generic regulator bindings
+  are described in regulator/regulator.txt.
+
+  The valid regulator-compatible values for BCM59056 are:
+  	rfldo, camldo1, camldo2, simldo1, simlso2, sdldo, sdxldo,
+	mmcldo1, mmcldo2, audldo, micldo, usbldo, vibldo,
+	csr, iosr1, iosr2, msr, sdsr1, sdsr2, vsr
+
+Example:
+	pmu: bcm59056@8 {
+		compatible = "brcm,bcm59056";
+		reg = <0x08>;
+		interrupts = <GIC_SPI 215 IRQ_TYPE_LEVEL_HIGH>;
+		regs {
+			compatible = "brcm,bcm59056-regs";
+			regulators {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				rfldo_reg: regulator@0 {
+					reg = <0>;
+					regulator-compatible = "rfldo";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <3300000>;
+				};
+
+				...
+			};
+		};
+	};
-- 
1.8.4

