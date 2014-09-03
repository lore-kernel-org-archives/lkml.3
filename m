Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359AbaICO50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 10:57:26 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52616 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801AbaICO4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 10:56:35 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-53-54072c1fb0a4
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <k.wrona@samsung.com>
Subject: [RFC/PATCH 3/6] sensorhub: Add sensorhub bindings
Date: Wed, 03 Sep 2014 16:55:47 +0200
Message-id: <1409756150-30889-4-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1409756150-30889-1-git-send-email-k.wrona@samsung.com>
References: <1409756150-30889-1-git-send-email-k.wrona@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIJMWRmVeSWpSXmKPExsVy+t/xa7ryOuwhBudPq1v8nXSM3WLjjPWs
	Fg+aVjFZnFq2n8nibNMbdot5R96xWFzeNYfNgd3j969JjB6bVnWyefRtWcXo8XmTXABLFJdN
	SmpOZllqkb5dAlfGx3uXWAteC1as3LKNtYHxLF8XIyeHhICJxItLqxkhbDGJC/fWs3UxcnEI
	CSxllPg45REzhNPHJNH27hErSBWbgLpE847FYAkRgUZGiZuL+9lAEswCHYwSi9q5QGxhASuJ
	Rcf+M4HYLAKqEtt2LQZr5hVwluiZeBpoHQfQOgWJOZNsQMKcAi4Sa08+AisXAipZsWct4wRG
	3gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQoLpyw7GxcesDjEKcDAq8fAWqLGFCLEm
	lhVX5h5ilOBgVhLhXSPNHiLEm5JYWZValB9fVJqTWnyIkYmDU6qBUYPNWaem9mSx3IeK3cU6
	M4WW/Jth5hh3jjstklXOa3dqW7mszeGHP7N1zSwU0jrYZj0OP6W3zEh36fu1qcv3Ka08/ivH
	JKx9xsnqBQvFu3Tk9BWnXeZYuPfApPny17xObG6vvvDxWkuEk8CiF2IC7jFL9mpGs13bNrM1
	WLBW+Un/0shN6neClFiKMxINtZiLihMB1YjGjQQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sensorhub bindings for sensorhub on Galaxy Gear 2.

Signed-off-by: Karol Wrona <k.wrona@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/misc/sensorhub.txt         |   51 ++++++++++++++++++++
 1 file changed, 51 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/misc/sensorhub.txt

diff --git a/Documentation/devicetree/bindings/misc/sensorhub.txt b/Documentation/devicetree/bindings/misc/sensorhub.txt
new file mode 100644
index 0000000..b43c2b7
--- /dev/null
+++ b/Documentation/devicetree/bindings/misc/sensorhub.txt
@@ -0,0 +1,50 @@
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
+- ap-mcu-int: [out] ap to sensorhub line - used during communication
+- mcu-ap-int: [in] sensorhub to ap - used during communication
+- mcu-reset: [out] sensorhub reset
+- mag-table: magnitude table
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
+		compatible = "samsung,rinato-ssp-spi";
+		spi-max-frequency = <5000000>;
+		interrupt-parent = <&gpx0>;
+		interrupts = <2 0>;
+		ap-mcu-int = <&gpx0 0 0>;
+		mcu-ap-int = <&gpx0 4 0>;
+		mcu-reset = <&gpx0 5 0>;
+		mag-table = /bits/ 8 <110 85 171 71 203 195 0 67
+				208 56 175 244 206 213 0 92 250 0
+				55 48 189 252 171 243 13 45 250>;
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

