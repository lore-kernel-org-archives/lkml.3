Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaLSWS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 17:18:29 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:7480 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbaLSWSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 17:18:25 -0500
X-IronPort-AV: E=Sophos;i="5.07,609,1413270000"; 
   d="scan'208";a="53509600"
From: Jonathan Richardson <jonathar@broadcom.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
CC: Ray Jui <rjui@broadcom.com>, Jonathan Richardson <jonathar@broadcom.com>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>,
        "Joe Perches" <joe@perches.com>
Subject: [PATCH v2 2/2] Input: touchscreen-iproc: add device tree bindings
Date: Fri, 19 Dec 2014 14:17:50 -0800
Message-ID: <1419027470-7969-3-git-send-email-jonathar@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1419027470-7969-1-git-send-email-jonathar@broadcom.com>
References: <Jonathan Richardson <jonathar@broadcom.com>
 <1419027470-7969-1-git-send-email-jonathar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documents the touchscreen device tree binding for Broadcom iProc family
of SoCs.

Reviewed-by: Scott Branden <sbranden@broadcom.com>
Tested-by: Scott Branden <sbranden@broadcom.com>
Signed-off-by: Jonathan Richardson <jonathar@broadcom.com>
---
 .../input/touchscreen/brcm,iproc-touchscreen.txt   |   70 ++++++++++++++++++++
 1 file changed, 70 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/brcm,iproc-touchscreen.txt

diff --git a/Documentation/devicetree/bindings/input/touchscreen/brcm,iproc-touchscreen.txt b/Documentation/devicetree/bindings/input/touchscreen/brcm,iproc-touchscreen.txt
new file mode 100644
index 0000000..eb28822
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/touchscreen/brcm,iproc-touchscreen.txt
@@ -0,0 +1,70 @@
+* Broadcom's IPROC Touchscreen Controller
+
+Required properties:
+- compatible: must be "brcm,iproc-touchscreen"
+- reg: physical base address of the controller and length of memory mapped
+  region.
+- clocks:  The clock provided by the SOC to driver the tsc
+- clock-name:  name for the clock
+- interrupts: The touchscreen controller's interrupt
+
+Optional properties:
+- scanning_period: Time between scans. Each step is 1024 us.  Valid 1-256.
+- debounce_timeout: Each step is 512 us.  Valid 0-255
+- settling_timeout: The settling duration (in ms) is the amount of time
+                    the tsc waits to allow the voltage to settle after
+                    turning on the drivers in detection mode.
+                    Valid values: 0-11
+                    0 =  0.008 ms
+                    1 =  0.01 ms
+                    2 =  0.02 ms
+                    3 =  0.04 ms
+                    4 =  0.08 ms
+                    5 =  0.16 ms
+                    6 =  0.32 ms
+                    7 =  0.64 ms
+                    8 =  1.28 ms
+                    9 =  2.56 ms
+                   10 =  5.12 ms
+                   11 = 10.24 ms
+- touch_timeout: The continuous number of scan periods in which touch is
+                not detected before the controller returns to idle state.
+                Valid values 0-255.
+- average_data: Number of data samples which are averaged before a final
+                data point is placed into the FIFO
+                Valid values 0-7
+                0 =   1 sample
+                1 =   2 samples
+                2 =   4 samples
+                3 =   8 samples
+                4 =  16 samples
+                5 =  32 samples
+                6 =  64 samples
+                7 = 128 samples
+- fifo_threshold: Interrupt is generated whenever the number of fifo
+                entries exceeds this value
+                Valid values 0-31
+- ts-rotation: Touch screen controller and display panel orientation angle.
+		0 = Tsc x_min y_min placed at LCD x_min y_min. None
+		1 = Tsc x_min y_max placed at LCD x_min y_min. 90 degrees
+		2 = Tsc x_max y_max placed at LCD x_min y_min. 180 degrees
+		3 = Tsc x_max y_min placed at LCD x_min y_min. 270 degrees
+Example:
+
+	touchscreen: tsc@0x180A6000 {
+		compatible = "brcm,iproc-touchscreen";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg = <0x180A6000 0x40>;
+		clocks = <&adc_clk>;
+		clock-names = "tsc_clk";
+		interrupts = <GIC_SPI 164 IRQ_TYPE_LEVEL_HIGH>;
+
+		scanning_period = <5>;
+		debounce_timeout = <40>;
+		settling_timeout = <7>;
+		touch_timeout = <10>;
+		average_data = <5>;
+		fifo_threshold = <1>;
+		ts-rotation = <2>;
+	};
-- 
1.7.9.5

