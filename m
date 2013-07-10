Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab3GJHJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 03:09:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59727 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab3GJHJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 03:09:47 -0400
From: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
To: <tony@atomide.com>, <gg@slimlogic.co.uk>, <peter.ujfalusi@ti.com>,
        <kishon@ti.com>, <benoit.cousson@linaro.org>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <sameo@linux.intel.com>, <ch.naveen@samsung.com>, <milo.kim@ti.com>,
        <poeschel@lemonage.de>, <balajitk@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>
Subject: [PATCH v2 0/2] TWL6030, TWL6032 GPADC driver
Date: Wed, 10 Jul 2013 10:08:52 +0300
Message-ID: <1373440134-30118-1-git-send-email-oleksandr.kozaruk@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is version 2 - the driver put in drivers/iio, and
converted using iio facilities as suggested by Graeme.

TWL603[02] GPADC is used to measure battery voltage,
battery temperature, battery presence ID, and could
be used to measure twl603[02] die temperature.
This is used on TI blaze, blaze tablet platforms.

The TWL6030/TWL6032 is a PMIC that has a GPADC with 17/19
channels respectively. Some channels have current
source and are used for measuring voltage drop
on resistive load for detecting battery ID resistance,
or measuring voltage drop on NTC resistors for external
temperature measurements, other channels measure voltage,
(i.e. battery voltage), and have inbuilt voltage dividers,
thus, capable to scale voltage. Some channels are dedicated
for measuring die temperature.

Some channels could be calibrated in 2 points, having
offsets from ideal values in trim registers.

The difference between GPADC in TWL6030 and TWL6032:
- 10 bit vs 12 bit ADC;
- 17 vs 19 channels;
- channels have different purpose(i. e. battery voltage
  channel 8 vs channel 18);
- trim values are interpreted differently.

The driver exports function returning converted value for
requested channels.

Sysfs entries are added to start and read conversion result
in millivolts for chosen channel.

The driver is derived from git://git.omapzoom.org/kernel/omap.git
The original driver's authors and contributors are Balaji T K,
Graeme Gregory, Ambresh K, Girish S Ghongdemath.

The changes to the original driver:
- device tree adaptation;
- drop ioctl support - never been used;
- unified measurement method for both devices;
- get rid of "if (device == X)" code style to data driven;
- drop polling end of conversion and use interrupt instead;
- iio framework is used

Tested with on blaze tablet 2 with OMAP4430(twl6030), and
OMAP4470(twl6032) SOMs.

The patches were tested against 3.10-rc7

Oleksandr Kozaruk (2):
  ARM: dts: twl: Add GPADC data to device tree
  iio: twl6030-gpadc: TWL6030, TWL6032 GPADC driver

 arch/arm/boot/dts/twl6030.dtsi  |    6 +
 drivers/iio/adc/Kconfig         |    8 +
 drivers/iio/adc/Makefile        |    1 +
 drivers/iio/adc/twl6030-gpadc.c | 1019 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 1034 insertions(+)
 create mode 100644 drivers/iio/adc/twl6030-gpadc.c

-- 
1.7.9.5

