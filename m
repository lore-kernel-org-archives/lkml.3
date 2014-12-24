Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbaLXHGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:06:12 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33131 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbaLXHF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:05:56 -0500
From: Vignesh R <vigneshr@ti.com>
To: Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Brad Griffis <bgriffis@ti.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Jan Kardell <jan.kardell@telliq.com>, Felipe Balbi <balbi@ti.com>,
        Wolfram Sang <wsa@the-dreams.de>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-iio@vger.kernel.org>,
        <linux-input@vger.kernel.org>, Vignesh R <vigneshr@ti.com>
Subject: [PATCH v5 4/6] ARM: dts: AM335x: Make charge delay a DT parameter for TSC
Date: Wed, 24 Dec 2014 12:33:37 +0530
Message-ID: <1419404619-10744-5-git-send-email-vigneshr@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419404619-10744-1-git-send-email-vigneshr@ti.com>
References: <1419404619-10744-1-git-send-email-vigneshr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The charge delay value is by default 0x400. But it can be set to lower
values on some boards, as long as false pen-ups are avoided. Lowering the
value increases the sampling rate (though current sampling rate is
sufficient for TSC operation). In some boards, the value has to be
increased to avoid false pen-up events. Hence, charge delay has been
made a DT parameter.

Signed-off-by: Vignesh R <vigneshr@ti.com>
---
v4:
 - Set charge delay to 0x400 as default. Most devices function normally
   at this value

 .../devicetree/bindings/input/touchscreen/ti-tsc-adc.txt  | 15 +++++++++++++++
 arch/arm/boot/dts/am335x-evm.dts                          |  1 +
 2 files changed, 16 insertions(+)

diff --git a/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt b/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
index 878549ba814d..6df5028a4ad3 100644
--- a/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
+++ b/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
@@ -28,6 +28,20 @@ Required properties:
 	ti,adc-channels: List of analog inputs available for ADC.
 			 AIN0 = 0, AIN1 = 1 and so on till AIN7 = 7.
 
+Optional properties:
+- child "tsc"
+	ti,charge-delay: Length of touch screen charge delay step in terms of
+			 ADC clock cycles. Charge delay value should be large
+			 in order to avoid false pen-up events. This value
+			 affects the overall sampling speed, hence need to be
+			 kept as low as possible, while avoiding false pen-up
+			 event. Start from a lower value, say 0x400, and
+			 increase value until false pen-up events are avoided.
+			 The pen-up detection happens immediately after the
+			 charge step, so this does in fact function as a
+			 hardware knob for adjusting the amount of "settling
+			 time".
+
 Example:
 	tscadc: tscadc@44e0d000 {
 		compatible = "ti,am3359-tscadc";
@@ -36,6 +50,7 @@ Example:
 			ti,x-plate-resistance = <200>;
 			ti,coordiante-readouts = <5>;
 			ti,wire-config = <0x00 0x11 0x22 0x33>;
+			ti,charge-delay = <0x400>;
 		};
 
 		adc {
diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index 54f118c08db8..66342515df20 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -648,6 +648,7 @@
 		ti,x-plate-resistance = <200>;
 		ti,coordinate-readouts = <5>;
 		ti,wire-config = <0x00 0x11 0x22 0x33>;
+		ti,charge-delay = <0x400>;
 	};
 
 	adc {
-- 
1.9.1

