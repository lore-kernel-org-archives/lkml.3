Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaKUSTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:19:44 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23664 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaKUSTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:19:40 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-27-546f823b17dd
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH v2 2/5] sensorhub: Add sensorhub bindings
Date: Fri, 21 Nov 2014 19:19:14 +0100
Message-id: <1416593957-19788-3-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416593957-19788-1-git-send-email-k.wrona@samsung.com>
References: <1416593957-19788-1-git-send-email-k.wrona@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAJMWRmVeSWpSXmKPExsVy+t/xa7rWTfkhBsuvM1v8nXSM3WLjjPWs
	Fg+aVjFZnFq2n8nibNMbdot5R96xWFzeNYfNgd3j969JjB6bVnWyefRtWcXo8XmTXABLFJdN
	SmpOZllqkb5dAlfG2sU3GAvOClTs+KHbwPiAt4uRk0NCwERi7sb5TBC2mMSFe+vZuhi5OIQE
	ljJKfN9/nx3C6WOSOHjuAwtIFZuAukTzjsXMIAkRgUZGiZuL+9lAEswCHYwSi9q5QGxhAUuJ
	1t9/wcayCKhK3Nq6BqyGV8BZYsqrI0A2B9A6BYk5k2xAwpwCLhLtM5eBlQgBlVy9voN9AiPv
	AkaGVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghofR1B+PSY1aHGAU4GJV4eC/Myg0RYk0s
	K67MPcQowcGsJMJbLpwfIsSbklhZlVqUH19UmpNafIiRiYNTqoHRrd/upf6zZ5tyYzdsz8nS
	eDn9wcQbV9cox30xmGHcEPtEoUuBy55ZPlu3y4Df8ETeoVCzZt3JiSsUWzU7O5UtDZnWfZw/
	4U/qn4pF/hKZqzVmuaodeKn21N6Fa4uXfuXsy/pmO//t3pL7dHHbgaTpFlEzLYPW8z/gvrdK
	+cCtf675/k+SRVuUWIozEg21mIuKEwGP/OzlAwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sensorhub bindings for sensorhub on Galaxy Gear 2.

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

