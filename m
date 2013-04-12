Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab3DLNQB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 09:16:01 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:22974 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab3DLNPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 09:15:03 -0400
Message-Id: <201304121307.r3CD7tDi011782@latitude>
From: Anthony Olech <anthony.olech.opensource@diasemi.com>
Date: Fri, 12 Apr 2013 14:05:29 +0100
Subject: [NEW DRIVER V4 0/7] DA9058 PMIC - please comment on this new driver
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Andrew Jones <drjones@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Eric Andersson <eric.andersson@unixphere.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Liam Girdwood <lrg@ti.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-iio@vger.kernel.org
Cc: linux-input@vger.kernel.org
Cc: lm-sensors@lm-sensors.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Michael Krufky <mkrufky@kernellabs.com>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: rtc-linux@googlegroups.com
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Steven Toth <stoth@kernellabs.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is submission attempt number 4 to have this driver included in
the linux kernel source tree. This is the driver for the Dialog DA9058.

The DA9058 is a low power Power Management Integrated Circuit with extra
functionality. It is a Multi Function Device controlled only from an I2C
bus whose components can raise an interrupt request on a single IRQ line.

The driver for the DA9058 consists of a core (i2c) device driver that
instantiates the individual component device drivers for:

adc - 5 ADC channels
gpio - 2 available pins
onkey - 1 device
regulator - 4 BUCKS, 19 LDO and 3 fixed
rtc - low power clock
hwmon - 5 monitored voltages/temperatures

All the above seven component device drivers depend on the 'core'
component driver, which is number one in the patch series.

This driver has been tested on a Samsung SMDK6410 connected to a Dialog
DA9058 Evaluation Board via one GPIO and a 3-wire I2C connection.

All the components can be builtin to the kernel or compiled as modules.
As far as I can tell, all the latest APIs both for the core driver and
all the component drivers have been adhered to, but if I have missed
something please let me know.

Many thanks,
Anthony Olech, Dialog Semiconductor Ltd.

Tony Olech (at Home) (7):
  DA9058 MFD core driver
  DA9058 ADC driver
  DA9058 ONKEY driver
  DA9058 RTC driver
  DA9058 GPIO driver
  DA9058 HWMON driver
  DA9058 REGULATOR driver

 Documentation/hwmon/da9058           |   38 ++
 drivers/gpio/Kconfig                 |   12 +
 drivers/gpio/Makefile                |    1 +
 drivers/gpio/gpio-da9058.c           |  377 ++++++++++++++
 drivers/hwmon/Kconfig                |   10 +
 drivers/hwmon/Makefile               |    3 +-
 drivers/hwmon/da9058-hwmon.c         |  341 +++++++++++++
 drivers/iio/adc/Kconfig              |   14 +
 drivers/iio/adc/Makefile             |    1 +
 drivers/iio/adc/da9058-adc.c         |  397 +++++++++++++++
 drivers/input/misc/Kconfig           |   10 +
 drivers/input/misc/Makefile          |    1 +
 drivers/input/misc/da9058_onkey.c    |  177 +++++++
 drivers/mfd/Kconfig                  |   18 +
 drivers/mfd/Makefile                 |    3 +
 drivers/mfd/da9058-core.c            |   74 +++
 drivers/mfd/da9058-i2c.c             |   97 ++++
 drivers/mfd/da9058-info.c            |  929 ++++++++++++++++++++++++++++++++++
 drivers/mfd/da9058-irq.c             |   57 +++
 drivers/regulator/Kconfig            |   11 +
 drivers/regulator/Makefile           |    1 +
 drivers/regulator/da9058-regulator.c |  228 +++++++++
 drivers/rtc/Kconfig                  |   10 +
 drivers/rtc/Makefile                 |    1 +
 drivers/rtc/rtc-da9058.c             |  458 +++++++++++++++++
 include/linux/mfd/da9058/bat.h       |   33 ++
 include/linux/mfd/da9058/codec.h     |   22 +
 include/linux/mfd/da9058/conf.h      |   22 +
 include/linux/mfd/da9058/core.h      |   66 +++
 include/linux/mfd/da9058/gpio.h      |   19 +
 include/linux/mfd/da9058/hwmon.h     |   33 ++
 include/linux/mfd/da9058/i2c.h       |   22 +
 include/linux/mfd/da9058/irq.h       |   50 ++
 include/linux/mfd/da9058/onkey.h     |   17 +
 include/linux/mfd/da9058/pdata.h     |   30 ++
 include/linux/mfd/da9058/registers.h |  480 ++++++++++++++++++
 include/linux/mfd/da9058/regulator.h |   33 ++
 include/linux/mfd/da9058/rtc.h       |   17 +
 38 files changed, 4112 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/hwmon/da9058
 create mode 100644 drivers/gpio/gpio-da9058.c
 create mode 100644 drivers/hwmon/da9058-hwmon.c
 create mode 100644 drivers/iio/adc/da9058-adc.c
 create mode 100644 drivers/input/misc/da9058_onkey.c
 create mode 100644 drivers/mfd/da9058-core.c
 create mode 100644 drivers/mfd/da9058-i2c.c
 create mode 100644 drivers/mfd/da9058-info.c
 create mode 100644 drivers/mfd/da9058-irq.c
 create mode 100644 drivers/regulator/da9058-regulator.c
 create mode 100644 drivers/rtc/rtc-da9058.c
 create mode 100644 include/linux/mfd/da9058/bat.h
 create mode 100644 include/linux/mfd/da9058/codec.h
 create mode 100644 include/linux/mfd/da9058/conf.h
 create mode 100644 include/linux/mfd/da9058/core.h
 create mode 100644 include/linux/mfd/da9058/gpio.h
 create mode 100644 include/linux/mfd/da9058/hwmon.h
 create mode 100644 include/linux/mfd/da9058/i2c.h
 create mode 100644 include/linux/mfd/da9058/irq.h
 create mode 100644 include/linux/mfd/da9058/onkey.h
 create mode 100644 include/linux/mfd/da9058/pdata.h
 create mode 100644 include/linux/mfd/da9058/registers.h
 create mode 100644 include/linux/mfd/da9058/regulator.h
 create mode 100644 include/linux/mfd/da9058/rtc.h

-- 
end-of-patch for NEW DRIVER V4

