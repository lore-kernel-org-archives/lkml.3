Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965831AbaH1Kzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 06:55:42 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.163]:42408 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965764AbaH1Kzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 06:55:38 -0400
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-12.tower-39.messagelabs.com!1409222936!21508801!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <1d00ebc542bc2be18070e2b145741ebce1c631fe.1409145187.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1409145187.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1409145187.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Thu, 28 Aug 2014 11:48:52 +0100
Subject: [PATCH v2 2/7] mfd: da9150: Add DT binding documentation for core
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>, <linux-iio@vger.kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
CC: <linux-kernel@vger.kernel.org>, <support.opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
---
 Documentation/devicetree/bindings/mfd/da9150.txt | 41 ++++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/da9150.txt

diff --git a/Documentation/devicetree/bindings/mfd/da9150.txt b/Documentation/devicetree/bindings/mfd/da9150.txt
new file mode 100644
index 0000000..d7de150
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/da9150.txt
@@ -0,0 +1,41 @@
+Dialog Semiconductor DA9150 Combined Charger/Fuel-Gauge MFD bindings
+
+DA9150 consists of a group of sub-devices (I2C Only):
+
+Device			 Description
+------			 -----------
+da9150-gpadc		: IIO - GPADC
+da9150-charger		: Power Supply (Charger)
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
+- da9150-gpadc: See Documentation/devicetree/bindings/iio/adc/da9150-gpadc.txt
+- da9150-charger: See Documentation/devicetree/bindings/power/da9150-charger.txt
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
+		gpadc: da9150-gpadc {
+			...
+		};
+
+		da9150-charger {
+			...
+		};
+	};
--
1.9.3

