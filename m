Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151AbaHVOqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:46:39 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.110]:39946 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756497AbaHVOqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:46:36 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-4.tower-194.messagelabs.com!1408718789!19265476!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201408221446.s7MEkNVF001775@swsrvapps-01.diasemi.com>
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Date: Fri, 22 Aug 2014 15:26:55 +0100
Subject: [RESEND PATCH V2] devicetree: Dialog Semiconductor consolidate
 existing vendor prefixes to standardise on
 'dlg'
To: Lee Jones <lee.jones@linaro.org>
CC: Andrew Lunn <andrew@lunn.ch>, Arnaud Ebalard <arno@natisbad.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jonathan Cameron <jic23@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        LINUX ARM KERNEL <linux-arm-kernel@lists.infradead.org>,
        LINUX KERNEL <linux-kernel@vger.kernel.org>,
        LINUX SH <linux-sh@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Mark Brown <broonie@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin Fuzzey <mfuzzey@parkeon.com>, Pawel Moll <pawel.moll@arm.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Silvio F <silvio.fricke@gmail.com>, Simon Horman <horms@verge.net.au>,
        Support Opensource <support.opensource@diasemi.com>,
        Thierry Reding <thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Steve Twiss <stwiss.opensource@diasemi.com>

This patch series updates the device tree vendor prefix for
Dialog Semiconductor.

Various methods are currently used throughout the kernel: 'diasemi',
'dialog' and 'dlg'. Others have also been suggested.

This patch set aims to consolidate the usage of the vendor prefix to
use a common standard. The prefix 'dlg' is used.

Acked-by: Simon Horman <horms+renesas@verge.net.au>
Acked-by: Rob Herring <robh@kernel.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Shawn Guo <shawn.guo@freescale.com>


Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>

---
Checks performed with linux-next/next-20140715/scripts/checkpatch.pl
 trivial-devices.txt       total: 0 errors, 0 warnings, 89 lines checked
 da9210.txt                total: 0 errors, 0 warnings, 21 lines checked
 vendor-prefixes.txt       total: 0 errors, 0 warnings, 149 lines checked
 imx53-smd.dts             total: 0 errors, 2 warnings, 279 lines checked
 imx6qdl-phytec-pfla02.dtsi total: 0 errors, 2 warnings, 357 lines checked
 r8a7790-lager.dts         total: 0 errors, 3 warnings, 403 lines checked
 r8a7791-koelsch.dts       total: 0 errors, 4 warnings, 461 lines checked
 da9055-core.c             total: 0 errors, 0 warnings, 428 lines checked

Hi Lee,

This is a resend according to requests for e-mail reformatting and removal
of '[]' in From: and Signed-off-by: tags. There are no patch alterations
from RFC V2.

I have got the Ack for the two remaining files r8a7790-lager.dts and
r8a7791-koelsch.dts because of the previous request for SHMobile to Ack
their part of the patch.
- http://www.spinics.net/lists/arm-kernel/msg349289.html
- https://lkml.org/lkml/2014/6/11/273

I think this is it. But, if I am missing anything or there are problems, can
I get a quick explanation in the reply so I can fix it and move forwards
please?

In full:
Acked-by the following people so far:

- Simon Horman
  https://lkml.org/lkml/2014/7/29/767

- Rob Herring
  http://www.spinics.net/lists/arm-kernel/msg349289.html

- Lee Jones
  For the MFD changes:
  http://www.spinics.net/lists/arm-kernel/msg349457.html

- Shawn Guo
  arch/arm/boot/dts/imx53-smd.dts                    |  2 +-
  arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi       |  2 +-
  http://www.spinics.net/lists/arm-kernel/msg349398.html

Here is my working for justifying this change:

./arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
	Has the following entry:
	compatible = "dialog,da9063";
	However the DA9063 driver does not support device tree yet so
	it would be safe to rename this.

./arch/arm/boot/dts/imx53-smd.dts
	Has the following entry:
	compatible = "dialog,da9053", "dialog,da9052";
	However, the existing driver files for DA9053 define a different
	compatible string with the "dlg" prefix. See the entries below.
	None of these would have allowed the "dialog" prefix.
	{ .compatible = "dlg,da9052", .data = &da9052_i2c_id[0] },
	{ .compatible = "dlg,da9053-aa", .data = &da9052_i2c_id[1] },
	{ .compatible = "dlg,da9053-ba", .data = &da9052_i2c_id[2] },
	{ .compatible = "dlg,da9053-bb", .data = &da9052_i2c_id[3] },
	{ .compatible = "dlg,da9053-bc", .data = &da9052_i2c_id[4] },
	In this particular case the change for DA9053 did not match up
	with the expected compatibility strings and therefore I have
	retained the more general "dlg,da9053" because I do not know
	which silicon variant (-aa, -ba, -bb, or -bc) is the correct
	one to use.

./devicetree/bindings/i2c/trivial-devices.txt
	Has the following entry:
	dialog,da9053  DA9053: flexible system level PMIC with multicore support
	Instead of depreciating this "dialog" line am just replacing it
	with a "dlg" because the existing driver DA9053 does not support
	the dialog keyword.

./drivers/mfd/da9055-core.c
	Has the following entries for the mfd cells 
		.of_compatible = "dialog,da9055-gpio", etc...
	In this case, the driver does not actually pass in any platform data
	to any of the mfd cells and so they are not actually used
	yet in the driver. Nobody else references this information
	so they can safely be changed.

./devicetree/bindings/regulator/da9210.txt
	Has the following two entries in the binding file:
	- compatible:	must be "diasemi,da9210"
	compatible = "diasemi,da9210";
	However the DA9210 driver does not support device tree.

./arch/arm/boot/dts/r8a7790-lager.dts
./arch/arm/boot/dts/r8a7791-koelsch.dts
	These two files have the following entries:
	compatible = "diasemi,da9210";
	These both reference the "diasemi,da9210" but the device
	driver does not support device tree

The remaining files in the kernel I have found correctly references
the driver files compatibility information and so did not need to
be changed.

./devicetree/bindings/mfd/da9052-i2c.txt
	- compatible : Should be "dlg,da9052", "dlg,da9053-aa",
		 "dlg,da9053-ab", or "dlg,da9053-bb"

./devicetree/bindings/mfd/da9055.txt
	compatible = "dlg,da9055-pmic";

./arch/arm/boot/dts/imx53-voipac-dmm-668.dtsi
	compatible = "dlg,da9053-aa", "dlg,da9052";

./arch/arm/boot/dts/imx53-qsb.dts
	compatible = "dlg,da9053-aa", "dlg,da9052";

./devicetree/bindings/sound/da9055.txt
	- compatible: "dlg,da9055-codec"
	compatible = "dlg,da9055-codec";


This e-mail is in response to the previous threads here:
https://lkml.org/lkml/2014/6/11/262
http://comments.gmane.org/gmane.linux.ports.arm.kernel/341358

Changes since RFC V1
- addition of changes to DTS files referencing "diasemi,da9210"
   arch/arm/boot/dts/r8a7790-lager.dts
   arch/arm/boot/dts/r8a7791-koelsch.dts

Changes to e-mail content (no patch changes) since RFC V2
- reformatted e-mail according to comments
  http://www.spinics.net/lists/arm-kernel/msg349289.html
  http://www.spinics.net/lists/arm-kernel/msg349809.html

This RFC V2 resend does not answer the response to RFC V1
from Mark Brown:
http://www.spinics.net/lists/arm-kernel/msg347615.html

This patch applies against linux-next and next-20140715 

Regards,
Steve Twiss, Dialog Semiconductor Ltd.



 .../devicetree/bindings/i2c/trivial-devices.txt    |    2 +-
 .../devicetree/bindings/regulator/da9210.txt       |    4 +--
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 arch/arm/boot/dts/imx53-smd.dts                    |    2 +-
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi       |    2 +-
 arch/arm/boot/dts/r8a7790-lager.dts                |    2 +-
 arch/arm/boot/dts/r8a7791-koelsch.dts              |    2 +-
 drivers/mfd/da9055-core.c                          |   26 ++++++++++----------
 8 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
index 37803eb..a02b8a1 100644
--- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
+++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
@@ -44,7 +44,7 @@ dallas,ds1775		Tiny Digital Thermometer and Thermostat
 dallas,ds3232		Extremely Accurate I²C RTC with Integrated Crystal and SRAM
 dallas,ds4510		CPU Supervisor with Nonvolatile Memory and Programmable I/O
 dallas,ds75		Digital Thermometer and Thermostat
-dialog,da9053		DA9053: flexible system level PMIC with multicore support
+dlg,da9053		DA9053: flexible system level PMIC with multicore support
 epson,rx8025		High-Stability. I2C-Bus INTERFACE REAL TIME CLOCK MODULE
 epson,rx8581		I2C-BUS INTERFACE REAL TIME CLOCK MODULE
 fsl,mag3110		MAG3110: Xtrinsic High Accuracy, 3D Magnetometer
diff --git a/Documentation/devicetree/bindings/regulator/da9210.txt b/Documentation/devicetree/bindings/regulator/da9210.txt
index f120f22..3297c53 100644
--- a/Documentation/devicetree/bindings/regulator/da9210.txt
+++ b/Documentation/devicetree/bindings/regulator/da9210.txt
@@ -2,7 +2,7 @@
 
 Required properties:
 
-- compatible:	must be "diasemi,da9210"
+- compatible:	must be "dlg,da9210"
 - reg:		the i2c slave address of the regulator. It should be 0x68.
 
 Any standard regulator properties can be used to configure the single da9210
@@ -11,7 +11,7 @@ DCDC.
 Example:
 
 	da9210@68 {
-		compatible = "diasemi,da9210";
+		compatible = "dlg,da9210";
 		reg = <0x68>;
 
 		regulator-min-microvolt = <900000>;
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 5d27e5a..35a833e 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -37,6 +37,7 @@ dallas	Maxim Integrated Products (formerly Dallas Semiconductor)
 davicom	DAVICOM Semiconductor, Inc.
 denx	Denx Software Engineering
 digi	Digi International Inc.
+dlg	Dialog Semiconductor
 dlink	D-Link Corporation
 dmo	Data Modul AG
 ebv	EBV Elektronik
diff --git a/arch/arm/boot/dts/imx53-smd.dts b/arch/arm/boot/dts/imx53-smd.dts
index 5ec1590..1d32557 100644
--- a/arch/arm/boot/dts/imx53-smd.dts
+++ b/arch/arm/boot/dts/imx53-smd.dts
@@ -265,7 +265,7 @@
 	};
 
 	pmic: dialog@48 {
-		compatible = "dialog,da9053", "dialog,da9052";
+		compatible = "dlg,da9053", "dlg,da9052";
 		reg = <0x48>;
 	};
 };
diff --git a/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi b/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
index 2694aa8..0e50bb0 100644
--- a/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
@@ -83,7 +83,7 @@
 	};
 
 	pmic@58 {
-		compatible = "dialog,da9063";
+		compatible = "dlg,da9063";
 		reg = <0x58>;
 		interrupt-parent = <&gpio4>;
 		interrupts = <17 0x8>; /* active-low GPIO4_17 */
diff --git a/arch/arm/boot/dts/r8a7790-lager.dts b/arch/arm/boot/dts/r8a7790-lager.dts
index 856b423..e3db105 100644
--- a/arch/arm/boot/dts/r8a7790-lager.dts
+++ b/arch/arm/boot/dts/r8a7790-lager.dts
@@ -374,7 +374,7 @@
 	status = "okay";
 
 	vdd_dvfs: regulator@68 {
-		compatible = "diasemi,da9210";
+		compatible = "dlg,da9210";
 		reg = <0x68>;
 
 		regulator-min-microvolt = <1000000>;
diff --git a/arch/arm/boot/dts/r8a7791-koelsch.dts b/arch/arm/boot/dts/r8a7791-koelsch.dts
index 23486c0..33b9532 100644
--- a/arch/arm/boot/dts/r8a7791-koelsch.dts
+++ b/arch/arm/boot/dts/r8a7791-koelsch.dts
@@ -426,7 +426,7 @@
 	clock-frequency = <100000>;
 
 	vdd_dvfs: regulator@68 {
-		compatible = "diasemi,da9210";
+		compatible = "dlg,da9210";
 		reg = <0x68>;
 
 		regulator-min-microvolt = <1000000>;
diff --git a/drivers/mfd/da9055-core.c b/drivers/mfd/da9055-core.c
index caf8dcf..b4d920c 100644
--- a/drivers/mfd/da9055-core.c
+++ b/drivers/mfd/da9055-core.c
@@ -296,73 +296,73 @@ static struct resource da9055_ld05_6_resource = {
 
 static const struct mfd_cell da9055_devs[] = {
 	{
-		.of_compatible = "dialog,da9055-gpio",
+		.of_compatible = "dlg,da9055-gpio",
 		.name = "da9055-gpio",
 	},
 	{
-		.of_compatible = "dialog,da9055-regulator",
+		.of_compatible = "dlg,da9055-regulator",
 		.name = "da9055-regulator",
 		.id = 1,
 	},
 	{
-		.of_compatible = "dialog,da9055-regulator",
+		.of_compatible = "dlg,da9055-regulator",
 		.name = "da9055-regulator",
 		.id = 2,
 	},
 	{
-		.of_compatible = "dialog,da9055-regulator",
+		.of_compatible = "dlg,da9055-regulator",
 		.name = "da9055-regulator",
 		.id = 3,
 	},
 	{
-		.of_compatible = "dialog,da9055-regulator",
+		.of_compatible = "dlg,da9055-regulator",
 		.name = "da9055-regulator",
 		.id = 4,
 	},
 	{
-		.of_compatible = "dialog,da9055-regulator",
+		.of_compatible = "dlg,da9055-regulator",
 		.name = "da9055-regulator",
 		.id = 5,
 	},
 	{
-		.of_compatible = "dialog,da9055-regulator",
+		.of_compatible = "dlg,da9055-regulator",
 		.name = "da9055-regulator",
 		.id = 6,
 	},
 	{
-		.of_compatible = "dialog,da9055-regulator",
+		.of_compatible = "dlg,da9055-regulator",
 		.name = "da9055-regulator",
 		.id = 7,
 		.resources = &da9055_ld05_6_resource,
 		.num_resources = 1,
 	},
 	{
-		.of_compatible = "dialog,da9055-regulator",
+		.of_compatible = "dlg,da9055-regulator",
 		.name = "da9055-regulator",
 		.resources = &da9055_ld05_6_resource,
 		.num_resources = 1,
 		.id = 8,
 	},
 	{
-		.of_compatible = "dialog,da9055-onkey",
+		.of_compatible = "dlg,da9055-onkey",
 		.name = "da9055-onkey",
 		.resources = &da9055_onkey_resource,
 		.num_resources = 1,
 	},
 	{
-		.of_compatible = "dialog,da9055-rtc",
+		.of_compatible = "dlg,da9055-rtc",
 		.name = "da9055-rtc",
 		.resources = da9055_rtc_resource,
 		.num_resources = ARRAY_SIZE(da9055_rtc_resource),
 	},
 	{
-		.of_compatible = "dialog,da9055-hwmon",
+		.of_compatible = "dlg,da9055-hwmon",
 		.name = "da9055-hwmon",
 		.resources = &da9055_hwmon_resource,
 		.num_resources = 1,
 	},
 	{
-		.of_compatible = "dialog,da9055-watchdog",
+		.of_compatible = "dlg,da9055-watchdog",
 		.name = "da9055-watchdog",
 	},
 };
-- 
end-of-patch for RESEND PATCH RFC V2

