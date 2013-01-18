Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab3ARKri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 05:47:38 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50141 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab3ARKrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 05:47:35 -0500
From: "Patil, Rachna" <rachna@ti.com>
To: <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-iio@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Rob Herring <rob.herring@calxeda.com>,
        Jonathan Cameron <jic23@cam.ac.uk>, Tony Lindgren <tony@atomide.com>,
        Benit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        "Patil, Rachna" <rachna@ti.com>
Subject: [PATCH v3 4/8] MFD: ti_am335x_tscadc: add device tree binding information
Date: Fri, 18 Jan 2013 16:18:14 +0530
Message-ID: <daf18b4779ac3c6b69b1e7e2d1a4abd18b13fee5.1358502134.git.rachna@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1358502134.git.rachna@ti.com>
References: <cover.1358502134.git.rachna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Patil, Rachna" <rachna@ti.com>

Signed-off-by: Patil, Rachna <rachna@ti.com>
---
 .../devicetree/bindings/mfd/ti_am335x_tscadc.txt   |   35 ++++++++++++++++++++
 1 file changed, 35 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/ti_am335x_tscadc.txt

diff --git a/Documentation/devicetree/bindings/mfd/ti_am335x_tscadc.txt b/Documentation/devicetree/bindings/mfd/ti_am335x_tscadc.txt
new file mode 100644
index 0000000..c13c492
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/ti_am335x_tscadc.txt
@@ -0,0 +1,35 @@
+Texas Instruments - TSC / ADC multi-functional device
+
+ti_tscadc is a multi-function device with touchscreen and ADC on chip.
+This document describes the binding for mfd device.
+
+Required properties:
+- compatible: "ti,ti-tscadc"
+- reg: Specifies the address of MFD block
+- interrupts: IRQ line connected to the main SoC
+- interrupt-parent: The parent interrupt controller
+
+Optional properties:
+- ti,hwmods: Hardware information related to TSC/ADC MFD device
+
+Example:
+
+	tscadc: tscadc@44e0d000 {
+		compatible = "ti,ti-tscadc";
+		reg = <0x44e0d000 0x1000>;
+
+		interrupt-parent = <&intc>;
+		interrupts = <16>;
+		ti,hwmods = "adc_tsc";
+
+		tsc {
+			wires = <4>;
+			x-plate-resistance = <200>;
+			steps-to-configure = <5>;
+			wire-config = <0x00 0x11 0x22 0x33>;
+		};
+
+		adc {
+			adc-channels = <4>;
+		};
+	};
-- 
1.7.9.5

