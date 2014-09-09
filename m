Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429AbaIIJbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:31:49 -0400
Received: from demumfd001.nsn-inter.net ([93.183.12.32]:38556 "EHLO
	demumfd001.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405AbaIIJbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:31:46 -0400
Date: Tue, 9 Sep 2014 13:34:56 +0300
From: Matti Vaittinen <matti.vaittinen@nsn.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux@roeck-us.net" <linux@roeck-us.net>
Cc: a.zummo@towertech.it, "jic23@kernel.org" <jic23@kernel.org>,
        "arno@natisbad.org" <arno@natisbad.org>,
        jgunthorpe@obsidianresearch.com, san@rosetechnology.dk, hs@denx.de,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Sverdlin Alexander <alexander.sverdlin@nsn.com>
Subject: [PATCH v4 1/2] Documentation: dt-bindings: trickle charger dt
 binding document for ds1339
Message-ID: <20140909103449.GA32724@fi-ourus-dhcp00977.emea.nsn-net.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 2502
X-purgate-ID: 151667::1410255040-00002A30-B3B018D7/0/0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation: dt-bindings: trickle charger dt binding document for ds1339

Some DS13XX devices have "trickle chargers". Introduce a device tree binding
for the resistor and diode configuration for enabling trickle charger.


Signed-off-by: Matti Vaittinen <matti.vaittinen@nsn.com>
---

    Delta to v3:
        - Splitted documentation to own patch
        - Changed diode property to trickle-diode-enable

 .../devicetree/bindings/i2c/trivial-devices.txt        |  1 -
 .../devicetree/bindings/rtc/dallas,ds1339.txt          | 18 ++++++++++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/rtc/dallas,ds1339.txt

diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
index 6af570e..e9206a4 100644
--- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
+++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
@@ -35,7 +35,6 @@ catalyst,24c32		i2c serial eeprom
 cirrus,cs42l51		Cirrus Logic CS42L51 audio codec
 dallas,ds1307		64 x 8, Serial, I2C Real-Time Clock
 dallas,ds1338		I2C RTC with 56-Byte NV RAM
-dallas,ds1339		I2C Serial Real-Time Clock
 dallas,ds1340		I2C RTC with Trickle Charger
 dallas,ds1374		I2C, 32-Bit Binary Counter Watchdog RTC with Trickle Charger and Reset Input/Output
 dallas,ds1631		High-Precision Digital Thermometer
diff --git a/Documentation/devicetree/bindings/rtc/dallas,ds1339.txt b/Documentation/devicetree/bindings/rtc/dallas,ds1339.txt
new file mode 100644
index 0000000..fba65b2
--- /dev/null
+++ b/Documentation/devicetree/bindings/rtc/dallas,ds1339.txt
@@ -0,0 +1,18 @@
+* Dallas DS1339		I2C Serial Real-Time Clock
+
+Required properties:
+- compatible: Should contain "dallas,ds1339".
+- reg: I2C address for chip
+
+Optional properties:
+- trickle-resistor-ohms : Selected resistor for trickle charger
+	Values usable for ds1339 are 250, 2000, 4000
+	Should be given if trickle charger should be enabled
+- trickle-diode-enable : Use internal trickle charger diode
+	Should be given if internal trickle charger diode should be enabled
+Example:
+	ds1339: rtc@68 {
+		compatible = "dallas,ds1339";
+		trickle-resistor-ohms = <250>;
+		reg = <0x68>;
+	};
-- 
1.8.3.1


-- 
=============================================

Matti Vaittinen
Senile SW Specialist
FINLAND 

~~ When things go utterly wrong vim users can always type :help! ~~

