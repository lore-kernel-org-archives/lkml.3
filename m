Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbaFKLSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 07:18:08 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.170]:45982 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751311AbaFKLSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 07:18:04 -0400
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-12.tower-39.messagelabs.com!1402485084!20029648!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <1cd1f7ea5d3a5a799bccbafda9672012c3b55bba.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Wed, 11 Jun 2014 12:11:21 +0100
Subject: [PATCH 2/8] mfd: da9150: Add DT binding documentation for core
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>, <linux-iio@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <support.opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
---
 Documentation/devicetree/bindings/mfd/da9150.txt | 53 ++++++++++++++++++++++++
 1 file changed, 53 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/da9150.txt

diff --git a/Documentation/devicetree/bindings/mfd/da9150.txt b/Documentation/devicetree/bindings/mfd/da9150.txt
new file mode 100644
index 0000000..5c9adc3
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/da9150.txt
@@ -0,0 +1,53 @@
+Dialog Semiconductor DA9150 Combined Charger/Fuel-Gauge MFD bindings
+
+DA9150 consists of a group of sub-devices (I2C Only):
+
+Device			 Description
+------			 -----------
+da9150-gpio		: GPIOs
+da9150-gpadc		: IIO - GPADC
+da9150-charger		: Power Supply (Charger)
+da9150-fg		: Power Supply (Fuel-Gauge)
+
+======
+
+Required properties:
+- compatible : Should be "dlg,da9150"
+- reg: Specifies the I2C slave address
+- interrupt-parent: Specifies the phandle of the interrupt controller to which
+  the IRQs from da9150 are delivered to.
+- interrupts: IRQ line info for da9150 chip.
+- interrupt-controller: da9150 has internal IRQs (own IRQ domain).
+
+Sub-devices:
+- da9150-gpio: See Documentation/devicetree/bindings/gpio/gpio-da9150.txt
+- da9150-gpadc: See Documentation/devicetree/bindings/iio/da9150-gpadc.txt
+- da9150-charger: See Documentation/devicetree/bindings/power/da9150-charger.txt
+- da9150-fg: See Documentation/devicetree/bindings/power/da9150-fg.txt
+
+
+Example:
+
+	charger_fg: da9150@58 {
+		compatible = "dlg,da9150";
+		reg = <0x58>;
+		interrupt-parent = <&gpio6>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-controller;
+
+		da9150-gpio {
+			...
+		};
+
+		gpadc: da9150-gpadc {
+			...
+		};
+
+		da9150-charger {
+			...
+		};
+
+		da9150-fg {
+			...
+		};
+	};
--
1.9.3

