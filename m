Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbbAUPtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:49:10 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.174]:23410 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754163AbbAUPq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:46:58 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-8.tower-38.messagelabs.com!1421855208!8566094!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.12.5; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <ddb604ae2579aec0786afad0f3d0a7c5543031d9.1421854282.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1421854282.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1421854282.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Wed, 21 Jan 2015 15:46:43 +0000
Subject: [PATCH v6 2/7] mfd: da9150: Add DT binding documentation for core
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        <linux-iio@vger.kernel.org>, Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
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
 Documentation/devicetree/bindings/mfd/da9150.txt | 43 ++++++++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/da9150.txt

diff --git a/Documentation/devicetree/bindings/mfd/da9150.txt b/Documentation/devicetree/bindings/mfd/da9150.txt
new file mode 100644
index 0000000..d0588ea
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/da9150.txt
@@ -0,0 +1,43 @@
+Dialog Semiconductor DA9150 Combined Charger/Fuel-Gauge MFD bindings
+
+DA9150 consists of a group of sub-devices:
+
+Device			 Description
+------			 -----------
+da9150-gpadc		: General Purpose ADC
+da9150-charger		: Battery Charger
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
+  (See Documentation/devicetree/bindings/interrupt-controller/interrupts.txt for
+   further information relating to interrupt properties)
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

