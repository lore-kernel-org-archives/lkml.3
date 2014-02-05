Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbaBEDPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 22:15:00 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:54287 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaBEDO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 22:14:57 -0500
From: Matt Ranostay <mranostay@gmail.com>
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: matt.porter@linaro.org, pantelis.antoniou@gmail.com,
        Matt Ranostay <mranostay@gmail.com>
Subject: [PATCH v4 1/2] iio:as3935: Add DT binding docs for AS3935 driver
Date: Tue,  4 Feb 2014 19:14:55 -0800
Message-Id: <1391570096-2932-1-git-send-email-mranostay@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document compatible string, required and optional DT properties for
AS3935 chipset driver.

Signed-off-by: Matt Ranostay <mranostay@gmail.com>
---
 .../devicetree/bindings/iio/proximity/as3935.txt   | 25 ++++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iio/proximity/as3935.txt

diff --git a/Documentation/devicetree/bindings/iio/proximity/as3935.txt b/Documentation/devicetree/bindings/iio/proximity/as3935.txt
new file mode 100644
index 0000000..7e117cd
--- /dev/null
+++ b/Documentation/devicetree/bindings/iio/proximity/as3935.txt
@@ -0,0 +1,25 @@
+Austrian Microsystems AS3935 Franklin lightning sensor device driver
+
+Required properties:
+	- compatible: must be "ams,as3935"
+	- reg: SPI chip select number for the device
+	- spi-cpha: SPI Mode 1
+  	- interrupt-parent : should be the phandle for the interrupt controller
+	- interrupts : interrupt mapping for GPIO IRQ
+
+Optional properties:
+	- ams,tune-cap: Calibration tuning capacitor stepping value 0 - 15.
+	  Range of 0 to 120 pF, 8pF steps. This will require using the
+	  calibration data from the manufacturer.
+
+
+Example:
+
+as3935@0 {
+	compatible = "ams,as3935";
+	reg = <0>;
+	spi-cpha;
+	interrupt-parent = <&gpio1>;
+	interrupts = <16 1>;
+	ams,tune-cap = /bits/ 8 <10>;
+};
-- 
1.8.3.2

