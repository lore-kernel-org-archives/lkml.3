Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab3KIRjo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 12:39:44 -0500
Received: from mic92-1-81-57-185-249.fbx.proxad.net ([81.57.185.249]:59738
	"EHLO smtp.natisbad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab3KIRjl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 12:39:41 -0500
X-Hashcash: 1:20:131109:linux@roeck-us.net::Qpa67nzkiqThVCkX:0000000000000000000000000000000000000000000CJnf
X-Hashcash: 1:20:131109:khali@linux-fr.org::6oDPOWcdX/tNo4li:00000000000000000000000000000000000000000005L52
X-Hashcash: 1:20:131109:rob.herring@calxeda.com::YIT2nvIQPL9oYEZg:000000000000000000000000000000000000002N0v
X-Hashcash: 1:20:131109:pawel.moll@arm.com::PCUHdas6/IFSU9YK:00000000000000000000000000000000000000000005flU
X-Hashcash: 1:20:131109:mark.rutland@arm.com::mdQ2RNdaxnndsJRf:000000000000000000000000000000000000000008C/A
X-Hashcash: 1:20:131109:swarren@wwwdotorg.org::Nq5Qk5fUI9bOcE1V:00000000000000000000000000000000000000004164
X-Hashcash: 1:20:131109:ijc+devicetree@hellion.org.uk::+jzjzg4citGUg5kV:000000000000000000000000000000000AgR
X-Hashcash: 1:20:131109:rob@landley.net::hRTBeq5/LPY2NOf5:000L16
X-Hashcash: 1:20:131109:grant.likely@linaro.org::PyRtrcONOQKRFNUk:000000000000000000000000000000000000001p8w
X-Hashcash: 1:20:131109:linus.walleij@linaro.org::lrJeq2vAniuMODSP:00000000000000000000000000000000000008hxc
X-Hashcash: 1:20:131109:arnd@arndb.de::ZW9gvbdyLUdBFIpJ:0000FEIL
X-Hashcash: 1:20:131109:devicetree@vger.kernel.org::u0bx7EPp7Ha/0muw:0000000000000000000000000000000000018wI
X-Hashcash: 1:20:131109:linux-doc@vger.kernel.org::T73GEmGonve25+PQ:0000000000000000000000000000000000002OIU
X-Hashcash: 1:20:131109:linux-kernel@vger.kernel.org::y9hJckrfJHygSogU:0000000000000000000000000000000000vgM
X-Hashcash: 1:20:131109:lm-sensors@lm-sensors.org::icuCAHQbAzDN/W1c:0000000000000000000000000000000000001Z50
From: arno@natisbad.org (Arnaud Ebalard)
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jean Delvare <khali@linux-fr.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: [PATCH] hwmon: add support for GMT G751 chip in lm75 driver
X-PGP-Key-URL: http://natisbad.org/arno@natisbad.org.asc
X-Fingerprint: D3A5 B68A 839B 38A5 815A 781B B77C 0748 A7AE 341B
Date: Sat, 09 Nov 2013 18:39:14 +0100
Message-ID: <87bo1th3ul.fsf@natisbad.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This was tested on a NETGEAR ReadyNAS 2120 device (Marvell Armada XP
based board, via DT).

Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
---
Hi Guenter,

As a side note, I removed the hunk that was present in previous patch to
add gmt to the list of DT vendor prefixes because I noticed someone had
taken care: https://lkml.org/lkml/2013/9/12/365

For the records, here is what I get on my NAS with the attached patch:

root@thin:/sys# sensors
g762-i2c-0-3e
Adapter: mv64xxx_i2c adapter
fan1:        5461 RPM  (div = 1)

g762-i2c-0-48
Adapter: mv64xxx_i2c adapter
fan1:        5461 RPM  (div = 1)

g762-i2c-0-49
Adapter: mv64xxx_i2c adapter
fan1:        5461 RPM  (div = 1)

g751-i2c-0-4c
Adapter: mv64xxx_i2c adapter
temp1:        +30.5°C  (high = +80.0°C, hyst = +75.0°C)

armada_thermal-virtual-0
Adapter: Virtual device
temp1:        +34.2°C

root@thin:/sys/bus/i2c/drivers/lm75/0-004c# ls
driver  modalias  subsystem    temp1_max       uevent
hwmon   name      temp1_input  temp1_max_hyst

root@thin:/sys/bus/i2c/drivers/lm75/0-004c# dmesg | grep lm
[  120.960471] lm75 0-004c: hwmon3: sensor 'g751'


just by adding the following to the .dts:

	g751: g751@4c {
		compatible = "gmt,g751";
		reg = <0x4c>;
	};

Do not hesitate to tell me if I missed something.

Cheers,

a+

 Documentation/devicetree/bindings/i2c/trivial-devices.txt | 1 +
 drivers/hwmon/Kconfig                                     | 1 +
 drivers/hwmon/lm75.c                                      | 3 +++
 3 files changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
index ad6a738..c98e5a2 100644
--- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
+++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
@@ -35,6 +35,7 @@ fsl,mc13892		MC13892: Power Management Integrated Circuit (PMIC) for i.MX35/51
 fsl,mma8450		MMA8450Q: Xtrinsic Low-power, 3-axis Xtrinsic Accelerometer
 fsl,mpr121		MPR121: Proximity Capacitive Touch Sensor Controller
 fsl,sgtl5000		SGTL5000: Ultra Low-Power Audio Codec
+gmt,g751		G751: Digital Temperature Sensor and Thermal Watchdog with Two-Wire Interface
 infineon,slb9635tt	Infineon SLB9635 (Soft-) I2C TPM (old protocol, max 100khz)
 infineon,slb9645tt	Infineon SLB9645 I2C TPM (new protocol, max 400khz)
 maxim,ds1050		5 Bit Programmable, Pulse-Width Modulator
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index b3ab9d4..52d548f 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -656,6 +656,7 @@ config SENSORS_LM75
 
 		- Analog Devices ADT75
 		- Dallas Semiconductor DS75, DS1775 and DS7505
+		- Global Mixed-mode Technology (GMT) G751
 		- Maxim MAX6625 and MAX6626
 		- Microchip MCP980x
 		- National Semiconductor LM75, LM75A
diff --git a/drivers/hwmon/lm75.c b/drivers/hwmon/lm75.c
index c03b490..7e3ef13 100644
--- a/drivers/hwmon/lm75.c
+++ b/drivers/hwmon/lm75.c
@@ -39,6 +39,7 @@ enum lm75_type {		/* keep sorted in alphabetical order */
 	ds1775,
 	ds75,
 	ds7505,
+	g751,
 	lm75,
 	lm75a,
 	max6625,
@@ -208,6 +209,7 @@ lm75_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		data->resolution = 12;
 		data->sample_time = HZ / 4;
 		break;
+	case g751:
 	case lm75:
 	case lm75a:
 		data->resolution = 9;
@@ -296,6 +298,7 @@ static const struct i2c_device_id lm75_ids[] = {
 	{ "ds1775", ds1775, },
 	{ "ds75", ds75, },
 	{ "ds7505", ds7505, },
+	{ "g751", g751, },
 	{ "lm75", lm75, },
 	{ "lm75a", lm75a, },
 	{ "max6625", max6625, },
-- 
1.8.4.rc3

