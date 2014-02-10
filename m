Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbaBJE2Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 23:28:16 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:40832 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaBJE1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 23:27:40 -0500
From: Matt Ranostay <mranostay@gmail.com>
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: matt.porter@linaro.org, pantelis.antoniou@gmail.com,
        Matt Ranostay <mranostay@gmail.com>
Subject: [PATCH v6 1/2] iio:as3935: Add DT binding docs for AS3935 driver
Date: Sun,  9 Feb 2014 20:27:30 -0800
Message-Id: <1392006451-7818-2-git-send-email-mranostay@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392006451-7818-1-git-send-email-mranostay@gmail.com>
References: <1392006451-7818-1-git-send-email-mranostay@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document compatible string, required and optional DT properties for
AS3935 chipset driver.

Signed-off-by: Matt Ranostay <mranostay@gmail.com>
---
 .../devicetree/bindings/iio/proximity/as3935.txt   | 27 ++++++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.txt        |  1 +
 2 files changed, 28 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iio/proximity/as3935.txt

diff --git a/Documentation/devicetree/bindings/iio/proximity/as3935.txt b/Documentation/devicetree/bindings/iio/proximity/as3935.txt
new file mode 100644
index 0000000..0453254
--- /dev/null
+++ b/Documentation/devicetree/bindings/iio/proximity/as3935.txt
@@ -0,0 +1,27 @@
+Austrian Microsystems AS3935 Franklin lightning sensor device driver
+
+Required properties:
+	- compatible: must be "ams,as3935"
+	- reg: SPI chip select number for the device
+	- spi-cpha: SPI Mode 1. Refer to spi/spi-bus.txt for generic SPI
+	slave node bindings.
+	- interrupt-parent : should be the phandle for the interrupt controller
+	- interrupts : interrupt mapping
+
+	Refer to interrupt-controller/interrupts.txt for generic
+	interrupt client node bindings.
+
+Optional properties:
+	- ams,tune-cap: Calibration tuning capacitor stepping value 0 - 120pF.
+	  This will require using the calibration data from the manufacturer.
+
+Example:
+
+as3935@0 {
+	compatible = "ams,as3935";
+	reg = <0>;
+	spi-cpha;
+	interrupt-parent = <&gpio1>;
+	interrupts = <16 1>;
+	ams,tune-cap = <80>;
+};
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index e9d19e2..03e50ff 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -11,6 +11,7 @@ ak	Asahi Kasei Corp.
 allwinner	Allwinner Technology Co., Ltd.
 altr	Altera Corp.
 amcc	Applied Micro Circuits Corporation (APM, formally AMCC)
+ams	AMS AG
 amstaos	AMS-Taos Inc.
 apm	Applied Micro Circuits Corporation (APM)
 arm	ARM Ltd.
-- 
1.8.3.2

