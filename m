Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab3ARKsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 05:48:19 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51509 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754950Ab3ARKsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 05:48:13 -0500
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
Subject: [PATCH v3 8/8] arm/dts: AM335x-evm: Add TSC/ADC MFD device support
Date: Fri, 18 Jan 2013 16:18:59 +0530
Message-ID: <1e33c3c4ac95fad513bf2785a5acff7a5f56d4b0.1358502134.git.rachna@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1358502134.git.rachna@ti.com>
References: <cover.1358502134.git.rachna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Patil, Rachna" <rachna@ti.com>

Add support for core multifunctional device along
with its clients touchscreen and ADC.

Signed-off-by: Patil, Rachna <rachna@ti.com>
---
 arch/arm/boot/dts/am335x-evm.dts |   13 +++++++++++++
 arch/arm/boot/dts/am33xx.dtsi    |    8 ++++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index d649644..ea28476 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -244,3 +244,16 @@
 &cpsw_emac1 {
 	phy_id = <&davinci_mdio>, <1>;
 };
+
+&tscadc {
+	tsc {
+		wires = <4>;
+		x-plate-resistance = <200>;
+		steps-to-configure = <5>;
+		wire-config = <0x00 0x11 0x22 0x33>;
+	};
+
+	adc {
+		adc-channels = <4>;
+	};
+};
diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index c2f14e8..211ec42 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -385,5 +385,13 @@
 				mac-address = [ 00 00 00 00 00 00 ];
 			};
 		};
+
+		tscadc: tscadc@44e0d000 {
+			compatible = "ti,ti-tscadc";
+			reg = <0x44e0d000 0x1000>;
+			interrupt-parent = <&intc>;
+			interrupts = <16>;
+			ti,hwmods = "adc_tsc";
+		};
 	};
 };
-- 
1.7.9.5

