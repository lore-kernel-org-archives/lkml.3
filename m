Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564Ab3DSRJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 13:09:21 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:49893 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab3DSRJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 13:09:18 -0400
Message-Id: <201304191708.r3JH8BEu017809@latitude>
From: Anthony Olech <anthony.olech.opensource@diasemi.com>
Date: Fri, 19 Apr 2013 17:56:29 +0100
Subject: [NEW DRIVER V6 0/7] DA9058 PMIC - please comment on this new driver
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
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>
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

This is submission attempt number 6 to have this driver included in
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

All the above six component device drivers depend on the 'core'
component driver, which is number one in the patch series.

Each component driver for the Dialog DA9058 will follow as an e-mail
patch relative to 

This driver has been tested on a Samsung SMDK6410 connected to a Dialog
DA9058 Evaluation Board via one GPIO and a 3-wire I2C connection.

All the components can be builtin to the kernel or compiled as modules.
As far as I can tell, all the latest APIs both for the core driver and
all the component drivers have been adhered to, but if I have missed
something please let me know.

In a clean check out of next-20130419 in linux-next, each patch has been
applied individually and the final result has been built successfully.

Many thanks,
Anthony Olech, Dialog Semiconductor Ltd.

Tony Olech (at Home) (7):
  drivers/mfd: DA9058 MFD core driver
  drivers/iio/adc: DA9058 ADC driver
  drivers/input/misc: DA9058 ONKEY driver
  drivers/rtc: DA9058 RTC driver
  drivers/gpio: DA9058 GPIO driver
  drivers/hwmon: DA9058 HWMON driver
  drivers/regulator: DA9058 REGULATOR driver

 Documentation/hwmon/da9058           |   38 ++
 drivers/gpio/Kconfig                 |   12 +
 drivers/gpio/Makefile                |    1 +
 drivers/gpio/gpio-da9058.c           |  376 ++++++++++++++
 drivers/hwmon/Kconfig                |   10 +
 drivers/hwmon/Makefile               |    3 +-
 drivers/hwmon/da9058-hwmon.c         |  330 ++++++++++++
 drivers/iio/adc/Kconfig              |   12 +
 drivers/iio/adc/Makefile             |    1 +
 drivers/iio/adc/da9058-adc.c         |  396 ++++++++++++++
 drivers/input/misc/Kconfig           |   10 +
 drivers/input/misc/Makefile          |    1 +
 drivers/input/misc/da9058_onkey.c    |  173 +++++++
 drivers/mfd/Kconfig                  |   17 +
 drivers/mfd/Makefile                 |    3 +
 drivers/mfd/da9058-core.c            |   73 +++
 drivers/mfd/da9058-i2c.c             |   96 ++++
 drivers/mfd/da9058-info.c            |  939 ++++++++++++++++++++++++++++++++++
 drivers/mfd/da9058-irq.c             |   56 ++
 drivers/regulator/Kconfig            |   11 +
 drivers/regulator/Makefile           |    1 +
 drivers/regulator/da9058-regulator.c |  199 +++++++
 drivers/rtc/Kconfig                  |   10 +
 drivers/rtc/Makefile                 |    1 +
 drivers/rtc/rtc-da9058.c             |  448 ++++++++++++++++
 include/linux/mfd/da9058/adc.h       |   18 +
 include/linux/mfd/da9058/bat.h       |   33 ++
 include/linux/mfd/da9058/codec.h     |   22 +
 include/linux/mfd/da9058/conf.h      |   22 +
 include/linux/mfd/da9058/core.h      |   66 +++
 include/linux/mfd/da9058/gpio.h      |   19 +
 include/linux/mfd/da9058/hwmon.h     |   32 ++
 include/linux/mfd/da9058/i2c.h       |   22 +
 include/linux/mfd/da9058/irq.h       |   50 ++
 include/linux/mfd/da9058/onkey.h     |   17 +
 include/linux/mfd/da9058/pdata.h     |   30 ++
 include/linux/mfd/da9058/registers.h |  480 +++++++++++++++++
 include/linux/mfd/da9058/regulator.h |   26 +
 include/linux/mfd/da9058/rtc.h       |   17 +
 39 files changed, 4070 insertions(+), 1 deletion(-)
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
 create mode 100644 include/linux/mfd/da9058/adc.h
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
end-of-patch for NEW DRIVER V6

