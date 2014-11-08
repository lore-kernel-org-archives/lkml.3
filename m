Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbaKHOOC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 09:14:02 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58085 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbaKHONz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 09:13:55 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-ce-545e25202ad2
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH 2/5] sensorhub: Add sensorhub bindings
Date: Sat, 08 Nov 2014 15:13:13 +0100
Message-id: <1415455996-20871-3-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1415455996-20871-1-git-send-email-k.wrona@samsung.com>
References: <1415455996-20871-1-git-send-email-k.wrona@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPJMWRmVeSWpSXmKPExsVy+t/xK7oKqnEhBsdfs1v8nXSM3WLjjPWs
	Fg+aVjFZnFq2n8nibNMbdot5R96xWFzeNYfNgd3j969JjB6bVnWyefRtWcXo8XmTXABLFJdN
	SmpOZllqkb5dAlfGta1HGAuaBSu2HVzJ0sA4ma+LkZNDQsBEYvWZrUwQtpjEhXvr2UBsIYGl
	jBJrVzt2MXIB2X1MEicuPWQBSbAJqEs071jMDJIQEWhklLi5uB+sg1mgg1FiUTtXFyMHh7CA
	mcS9y/YgYRYBVYntC66DLeAVcJa4+LyDCaREQkBBYs4kG5Awp4CLxKm5O5kg9jpLfJnzg3kC
	I+8CRoZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCGB9HUH49JjVocYBTgYlXh4X0yKDRFi
	TSwrrsw9xCjBwawkwtt7HijEm5JYWZValB9fVJqTWnyIkYmDU6qBMc1p57L3c5cGJJ0NS9j9
	lXVOQe2UWrfWXYHJne87f0v1PJMR3qRQkXb0B98Vjv2amzyWeU17LFEb5Bop9j0nwOKKx+Ov
	2+Y1iszNnH+zZj7ThSWfi3XW7Fvj08HzPXlN0jFW5Xt/X74Vcnz7Zb7LVZ2Ux5ctJW8n/235
	8Ub1YJ2wX3LPpHvh8UosxRmJhlrMRcWJALCuJS0CAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sensorhub bindings for sensorhub on Galaxy Gear 2.

Change-Id: I4ee25aef33c21a4662de230841de9a8684f2c26b
Signed-off-by: Karol Wrona <k.wrona@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/misc/sensorhub.txt         |   46 ++++++++++++++++++++
 1 file changed, 46 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/misc/sensorhub.txt

diff --git a/Documentation/devicetree/bindings/misc/sensorhub.txt b/Documentation/devicetree/bindings/misc/sensorhub.txt
new file mode 100644
index 0000000..088bf32
--- /dev/null
+++ b/Documentation/devicetree/bindings/misc/sensorhub.txt
@@ -0,0 +1,46 @@
+Samsung Sensorhub driver
+
+Sensorhub is MCU which manages several sensors and also play the role
+of virtual sensor device.
+
+Required properties:
+- compatible: "samsung,sensorhub-rinato" or "samsung,sensorhub-thermostat"
+- spi-max-frequency: max SPI clock frequency
+- interrupt-parent
+- interrupts: communication interrupt
+- ap-mcu-gpio: [out] ap to sensorhub line - used during communication
+- mcu-ap-gpio: [in] sensorhub to ap - used during communication
+- mcu-reset: [out] sensorhub reset
+
+Optional properties:
+- sensor's nodes:
+  compatible = "samsung,mpu6500-accel"
+  compatible = "samsung,mpu6500-gyro"
+  compatible = "samsung,adpd142"
+
+Sensor compatibles are used to match proper sensor driver to real sensor on
+the board. The firmware does not give such information, so it helps to specify
+some sensors properties. Sensors have "samsung" prefixes because frequently
+they will not have much in common with sensors used without sensorhub because
+it can do some data processing.
+
+Example:
+
+	shub_spi: shub {
+		compatible = "samsung,sensorhub-rinato";
+		spi-max-frequency = <5000000>;
+		interrupt-parent = <&gpx0>;
+		interrupts = <2 0>;
+		ap-mcu-gpio = <&gpx0 0 0>;
+		mcu-ap-gpio = <&gpx0 4 0>;
+		mcu-reset = <&gpx0 5 0>;
+		sensor@0 {
+			compatible = "samsung,mpu6500-accel";
+		};
+		sensor@1 {
+			compatible = "samsung,mpu6500-gyro";
+		};
+		sensor@2 {
+			compatible = "samsung,adpd142";
+		};
+	};
-- 
1.7.9.5

