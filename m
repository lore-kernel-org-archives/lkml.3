Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965876AbaH1K4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 06:56:35 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:51169 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965551AbaH1K4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 06:56:32 -0400
From: Gyungoh Yoo <gyungoh@gmail.com>
X-Google-Original-From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: jason@lakedaemon.net, linux@roeck-us.net, broonie@linaro.org,
        arno@natisbad.org, peterhuewe@gmx.de, andrew@lunn.ch,
        jgunthorpe@obsidianresearch.com, hs@denx.de, mfuzzey@parkeon.com,
        jack.yoo@skyworksinc.com, florian.vaussard@epfl.ch,
        heiko.stuebner@bqreaders.com, thierry.reding@gmail.com,
        silvio.fricke@gmail.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/7] Adding SKY81452 MFD device tree bindings document
Date: Thu, 28 Aug 2014 19:56:19 +0900
Message-Id: <1409223379-23508-1-git-send-email-jack.yoo@skyworksinc.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409222307-23225-1-git-send-email-jack.yoo@skyworksinc.com>
References: <1409222307-23225-1-git-send-email-jack.yoo@skyworksinc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:
Added 'reg' attribute for I2C address in device tree documents

---
 .../devicetree/bindings/i2c/trivial-devices.txt    |  1 +
 Documentation/devicetree/bindings/mfd/sky81452.txt | 32 ++++++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.txt        |  1 +
 3 files changed, 34 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/sky81452.txt

diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
index 6af570e..ff77879 100644
--- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
+++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
@@ -78,6 +78,7 @@ ramtron,24c64		i2c serial eeprom  (24cxx)
 ricoh,rs5c372a		I2C bus SERIAL INTERFACE REAL-TIME CLOCK IC
 samsung,24ad0xd1	S524AD0XF1 (128K/256K-bit Serial EEPROM for Low Power)
 sii,s35390a		2-wire CMOS real-time clock
+skyworks,sky81452	Skyworks SKY81452: Six-Channel White LED Driver with Touch Panel Bias Supply
 st-micro,24c256		i2c serial eeprom  (24cxx)
 stm,m41t00		Serial Access TIMEKEEPER
 stm,m41t62		Serial real-time clock (RTC) with alarm
diff --git a/Documentation/devicetree/bindings/mfd/sky81452.txt b/Documentation/devicetree/bindings/mfd/sky81452.txt
new file mode 100644
index 0000000..d61904a
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/sky81452.txt
@@ -0,0 +1,32 @@
+SKY81452 bindings
+
+Required properties:
+- compatible	: Must be "skyworks,sky81452"
+- reg		: I2C slave address
+
+Required child nodes:
+- backlight	: container node for backlight following the binding
+		in video/backlight/sky81452-backlight.txt
+- regulator	: container node for regulators following the binding
+		in regulator/sky81452-regulator.txt
+
+Example:
+
+	sky81452@2c {
+		compatible = "skyworks,sky81452";
+		reg = <0x2c>;
+
+		backlight {
+			compatible = "skyworks,sky81452-backlight";
+			name = "pwm-backlight";
+			enable = <0x3F>;
+			ignore-pwm;
+		};
+
+		regulator {
+			compatible = "skyworks,sky81452-regulator";
+			regulator-name = "touch_en";
+			regulator-min-microvolt = <4500000>;
+			regulator-max-microvolt = <8000000>;
+		};
+	};
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index ac7269f..c755978 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -125,6 +125,7 @@ silabs	Silicon Laboratories
 simtek
 sii	Seiko Instruments, Inc.
 sirf	SiRF Technology, Inc.
+skyworks	Skyworks Solutions, Inc.
 smsc	Standard Microsystems Corporation
 snps 	Synopsys, Inc.
 solidrun	SolidRun
-- 
1.9.1

