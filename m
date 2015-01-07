Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348AbbAGC7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:59:33 -0500
Received: from mail-yh0-f48.google.com ([209.85.213.48]:53623 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758525AbbAGC7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:59:10 -0500
From: Walter Lozano <walter@vanguardiasur.com.ar>
To: michael.hennerich@analog.com, dmitry.torokhov@gmail.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Walter Lozano <walter@vanguardiasur.com.ar>
Subject: [PATCH 2/2] Input: adxl34x - add device tree documentation
Date: Tue,  6 Jan 2015 23:58:57 -0300
Message-Id: <1420599537-28740-2-git-send-email-walter@vanguardiasur.com.ar>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1420599537-28740-1-git-send-email-walter@vanguardiasur.com.ar>
References: <1420599537-28740-1-git-send-email-walter@vanguardiasur.com.ar>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a basic documentation regarding the device tree
bindings of adxl34x digital accelerometer.

Signed-off-by: Walter Lozano <walter@vanguardiasur.com.ar>
---
 .../devicetree/bindings/input/adxl34x.txt          |   53 ++++++++++++++++++++
 1 file changed, 53 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/adxl34x.txt

diff --git a/Documentation/devicetree/bindings/input/adxl34x.txt b/Documentation/devicetree/bindings/input/adxl34x.txt
new file mode 100644
index 0000000..0774f7e
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/adxl34x.txt
@@ -0,0 +1,53 @@
+Device Tree bindings for adxl34x digital accelerometer, both spi and i2c.
+
+Depending on the interface this node should be a child of a spi or i2c bus.
+
+Required properties:
+- compatible: "adxl34x"
+- reg: SPI/I2C device address
+- interrupt-parent: a phandle for the interrupt controller
+- interrupts: interrupt to which the chip is connected
+
+Optional parameters:
+Please refer to include/linux/input/adxl34x.h for specific info. If the value
+is not specified the driver will use its default.
+
+- adi,tap-axis-control: u8 default 0
+- adi,tap-threshold: u8 default 35
+- adi,tap-duration: u8 default 3
+- adi,tap-latency: u8 default 20
+- adi,tap-window: u8 default 20
+- adi,act-axis-control: u8 default 0xFF
+- adi,activity-threshold: u8 default 6
+- adi,inactivity-threshold: u8 default 4
+- adi,inactivity-time: u8 default 3
+- adi,free-fall-threshold: u8 default 8
+- adi,free-fall-time: u8 default 20
+- adi,data-rate: u8 default 8
+- adi,data-range: u8 default 4
+- adi,low-power-mode: u8 defaut 0
+- adi,power-mode: u8 default 0x30
+- adi,fifo-mode: u8 default 2
+- adi,watermark: u8 default 0
+- adi,use-int2: u8
+- adi,orientation-enable: u8 default 0
+- adi,deadzone-angle: u8 default 0
+- divisor-length: u8 default 0
+
+Example
+
+&i2c1 {
+	status = "okay";
+
+	accel1: accelerometer@53 {
+		compatible = "adxl34x";
+		reg = <0x53>;
+
+		interrupt-parent = <&portc>;
+		interrupts = <3 2>;
+
+		adi,inactivity-time = /bits/ 8 <6>;
+		adi,data-range = /bits/ 8 <1>;
+	};
+};
+
-- 
1.7.10.4

