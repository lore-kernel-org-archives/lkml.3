Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733AbaBAGST (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 01:18:19 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:44082 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbaBAGRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 01:17:43 -0500
From: Matt Ranostay <mranostay@gmail.com>
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: matt.porter@linaro.org, koen@dominion.thruhere.net,
        pantelis.antoniou@gmail.com, Matt Ranostay <mranostay@gmail.com>
Subject: [PATCH v3 3/3] iio:as3935: Add DT binding docs for AS3935 driver
Date: Fri, 31 Jan 2014 22:17:42 -0800
Message-Id: <1391235462-32453-3-git-send-email-mranostay@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391235462-32453-1-git-send-email-mranostay@gmail.com>
References: <1391235462-32453-1-git-send-email-mranostay@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document compatible string, required and optional DT properties for
AS3935 chipset driver.

Signed-off-by: Matt Ranostay <mranostay@gmail.com>
---
 .../devicetree/bindings/iio/distance/as3935.txt    | 25 ++++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iio/distance/as3935.txt

diff --git a/Documentation/devicetree/bindings/iio/distance/as3935.txt b/Documentation/devicetree/bindings/iio/distance/as3935.txt
new file mode 100644
index 0000000..409b48b
--- /dev/null
+++ b/Documentation/devicetree/bindings/iio/distance/as3935.txt
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
+	  Range of 0 to 120 pF, 8pF steps. This will require using the calibration
+	  data from the manufacturer.
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

