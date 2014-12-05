Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaLET4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:56:13 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32403 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaLET4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:56:09 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-51-54820dd61a15
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>, Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH v3 2/5] iio: sensorhub: Add sensorhub bindings
Date: Fri, 05 Dec 2014 20:54:47 +0100
Message-id: <1417809290-9662-3-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417809290-9662-1-git-send-email-k.wrona@samsung.com>
References: <1417809290-9662-1-git-send-email-k.wrona@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNJMWRmVeSWpSXmKPExsVy+t/xK7rXeJtCDOZvFLfYOGM9q8WDplVM
	FqeW7Wey2PX/DbPF2aY37Bbzjrxjsbi8aw6bxZ51W5gcODx2zrrL7vHhY5zHplWdbB59W1Yx
	enzeJBfAGsVlk5Kak1mWWqRvl8CV0bztD2PBNMGKT9dfsjUwLuTrYuTkkBAwkfg4YzYThC0m
	ceHeerYuRi4OIYGljBI9N/ezQjh9TBJz9/1hBaliE1CXaN6xmBkkISLQwijx4ucusCpmgTWM
	EmfOTmAHqRIWsJO4/W45WAeLgKrEoX+r2UBsXgEniY37LwLVcADtU5CYM8kGJMwp4Cxx7dsM
	sDOEgEqeHfvFPIGRdwEjwypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkAD7soNx8TGrQ4wC
	HIxKPLwXrBtDhFgTy4orcw8xSnAwK4nwJs8GCvGmJFZWpRblxxeV5qQWH2Jk4uCUamDMXyqr
	0FnsHftM9dAxu0eqSz6/6GWUZzZP/jw99678hIwlT+4oPF0+88K/3Sov4h89fbtddOon6dV/
	NZZnhD1NPTu18fAMK7P6vQ0etz7UMu3W9mzbVFV2Zfob/8AdmmaKP55NfzVJ47uWWB/b8q0/
	bpT7epaa/uqo3Cf48+bk2RvC+uJNboXrK7EUZyQaajEXFScCACd2KC8OAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sensorhub bindings for sensorhub on Galaxy Gear 2.

Change-Id: I4ee25aef33c21a4662de230841de9a8684f2c26b
Signed-off-by: Karol Wrona <k.wrona@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/iio/sensorhub.txt          |   46 ++++++++++++++++++++
 1 file changed, 46 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iio/sensorhub.txt

diff --git a/Documentation/devicetree/bindings/iio/sensorhub.txt b/Documentation/devicetree/bindings/iio/sensorhub.txt
new file mode 100644
index 0000000..2aca0c3
--- /dev/null
+++ b/Documentation/devicetree/bindings/iio/sensorhub.txt
@@ -0,0 +1,46 @@
+Samsung Sensorhub driver
+
+Sensorhub is a MCU which manages several sensors and also plays the role
+of a virtual sensor device.
+
+Required properties:
+- compatible: "samsung,sensorhub-rinato" or "samsung,sensorhub-thermostat"
+- spi-max-frequency: max SPI clock frequency
+- interrupt-parent: interrupt parent
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

