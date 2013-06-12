Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671Ab3FLRLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:11:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:44696 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244Ab3FLRLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:11:51 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, "Patil, Rachna" <rachna@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH 13/21] arm: am33xx: add TSC/ADC mfd device support
Date: Wed, 12 Jun 2013 18:58:14 +0200
Message-Id: <1371056302-12714-14-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1371056302-12714-1-git-send-email-bigeasy@linutronix.de>
References: <1371056302-12714-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Patil, Rachna" <rachna@ti.com>

Add support for core multifunctional device along
with its clients touchscreen and ADC.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
Signed-off-by: Patil, Rachna <rachna@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/arm/boot/dts/am335x-evm.dts |   14 ++++++++++++++
 arch/arm/boot/dts/am33xx.dtsi    |   18 ++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index 0423298..26fea97 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -244,3 +244,17 @@
 &cpsw_emac1 {
 	phy_id = <&davinci_mdio>, <1>;
 };
+
+&tscadc {
+	status = "okay";
+	tsc {
+		ti,wires = <4>;
+		ti,x-plate-resistance = <200>;
+		ti,coordiante-readouts = <5>;
+		ti,wire-config = <0x00 0x11 0x22 0x33>;
+	};
+
+	adc {
+		ti,adc-channels = <4>;
+	};
+};
diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 1460d9b..4ad7797 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -404,6 +404,24 @@
 			ti,hwmods = "wkup_m3";
 		};
 
+		tscadc: tscadc@44e0d000 {
+			compatible = "ti,am3359-tscadc";
+			reg = <0x44e0d000 0x1000>;
+			interrupt-parent = <&intc>;
+			interrupts = <16>;
+			ti,hwmods = "adc_tsc";
+			status = "disabled";
+
+			tsc {
+				compatible = "ti,am3359-tsc";
+			};
+			am335x_adc: adc {
+				#io-channel-cells = <1>;
+				compatible = "ti,am3359-adc";
+			};
+
+		};
+
 		gpmc: gpmc@50000000 {
 			compatible = "ti,am3352-gpmc";
 			ti,hwmods = "gpmc";
-- 
1.7.10.4

