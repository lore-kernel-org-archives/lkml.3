Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaJ0LKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 07:10:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57614 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbaJ0LK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 07:10:27 -0400
From: Vignesh R <vigneshr@ti.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jan Kardell <jan.kardell@telliq.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Brad Griffis <bgriffis@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-iio@vger.kernel.org>,
        <linux-input@vger.kernel.org>, Vignesh R <vigneshr@ti.com>
Subject: [PATCH 3/4] arm: boot: dts: am335x-evm: Make charge delay a DT parameter for tsc
Date: Mon, 27 Oct 2014 16:38:30 +0530
Message-ID: <1414408111-2631-4-git-send-email-vigneshr@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414408111-2631-1-git-send-email-vigneshr@ti.com>
References: <1414408111-2631-1-git-send-email-vigneshr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The charge delay value is by default 0xB000. But it can be set to lower
values on some boards as long as false pen-ups are avoided. Lowering the
value increases the sampling rate (though current sampling rate is
sufficient for tsc operation). Hence charge delay has been made a DT
parameter.

Signed-off-by: Vignesh R <vigneshr@ti.com>
---
 .../devicetree/bindings/input/touchscreen/ti-tsc-adc.txt    | 13 +++++++++++++
 arch/arm/boot/dts/am335x-evm.dts                            |  1 +
 2 files changed, 14 insertions(+)

diff --git a/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt b/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
index 878549ba814d..ac62769e70e4 100644
--- a/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
+++ b/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
@@ -28,6 +28,18 @@ Required properties:
 	ti,adc-channels: List of analog inputs available for ADC.
 			 AIN0 = 0, AIN1 = 1 and so on till AIN7 = 7.
 
+Optional properties:
+- child "tsc"
+	ti,charge-delay: Length of touch screen charge delay step in terms of
+			 ADC clock cycles. Charge delay value should be large in order
+			 to avoid false pen-up events. This value affects the overall
+			 sampling speed hence need to be kept as low as possible while
+			 avoiding false pen-up event. Start from a lower value say 0x400
+			 and increase value until false pen-up events are avoided. The
+			 pen-up detection happens immediately after the charge step
+			 so this does in fact function as a hardware knob for adjusting
+			 the amount of "settling time".
+
 Example:
 	tscadc: tscadc@44e0d000 {
 		compatible = "ti,am3359-tscadc";
@@ -36,6 +48,7 @@ Example:
 			ti,x-plate-resistance = <200>;
 			ti,coordiante-readouts = <5>;
 			ti,wire-config = <0x00 0x11 0x22 0x33>;
+			ti,charge-delay = <0xB000>;
 		};
 
 		adc {
diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index e2156a583de7..80be0462298b 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -641,6 +641,7 @@
 		ti,x-plate-resistance = <200>;
 		ti,coordinate-readouts = <5>;
 		ti,wire-config = <0x00 0x11 0x22 0x33>;
+		ti,charge-delay = <0xB000>;
 	};
 
 	adc {
-- 
1.9.1

