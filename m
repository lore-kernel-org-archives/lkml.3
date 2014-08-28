Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965758AbaH1KzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 06:55:07 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.108]:45423 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934503AbaH1KzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 06:55:04 -0400
X-Greylist: delayed 377 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Aug 2014 06:55:03 EDT
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-14.tower-194.messagelabs.com!1409222923!16965964!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <cover.1409145187.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Thu, 28 Aug 2014 11:48:33 +0100
Subject: [PATCH v2 0/7] Add initial support for DA9150 Charger & Fuel-Gauge IC
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>, <linux-iio@vger.kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
CC: <linux-kernel@vger.kernel.org>, <support.opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds initial support for the Dialog DA9150 Integrated Charger &
Fuel-Gauge IC. The device also provides GPIO and GPADC functionality.

In this patch set the following is provided:
 - MFD Core support and DT bindings documentation.
 - IIO GPADC support and DT bindings documentation.
 - Power Supply Charger support and DT bindings documentation.
 - Update to MAINTAINERS file to add DA9150 files to Dialog support list.

To keep patch submission from being too large, support for GPIO and Fuel-Gauge
will come after initial support patches are accepted.

This patch set is baselined against the v3.17-rc2 kernel version.


Changes in v2:
 - Drop devicetree prefix patch as this is being dealt with separately.
 - IIO framework fix patch removed from set, has already been accepted/merged.
 - Use __ instead of _ for protecting #ifdefs in headers.
 - Moved private data & definitions to source files and remove unwanted headers.
 - Bug fix to EXPORT_SYMBOL for common functions in MFD core used by
   sub-devices, so they can be correctly built as kernel modules.
 - Removed unnecessary channels from GPADC IIO driver to simplify code.
 - For GPADC IIO driver, VBAT reading now provides scale and offset values as it
   is a linear scale.
 - GPADC read code refactored to make it tidier.
 - Remove use of flag to indicate GPADC availability. IIO framework should
   indicate need to defer if it's not yet instantiated.
 - Unwanted comments removed.
 - Removed conditional shutdown of device (Charger/MFD) as this is not needed.
 - Removed AC type supply from charger as device cannot differentiate. Now just
   uses USB supply type.
 - Removed use of invalid-tbat flag from platform data as it doesn't really add
   anything to the driver except forcing battery present status.
 - Bug fix for checking of usb_phy validity in Charger probe() function.
 - Addition of common IRQ release function to allow sub-devices to explicitly
   tidy up IRQs when devm clean up is too late.
 - Improved tidy up of resources in charger.
 - Fix location of IIO GPADC related devicetree binding document so it now
   resides correctly under 'adc' directory.
 - Add update to MAINTAINERS file to include these files in Dialog support list.

Adam Thomson (7):
  mfd: Add support for DA9150 combined charger & fuel-gauge device
  mfd: da9150: Add DT binding documentation for core
  iio: Add support for DA9150 GPADC
  iio: da9150: Add DT binding documentation for GPADC
  power: Add support for DA9150 Charger
  power: da9150: Add DT binding documentation for charger
  MAINTAINERS: Include DA9150 files in Dialog Semiconductor support
    list.

 .../devicetree/bindings/iio/adc/da9150-gpadc.txt   |   16 +
 Documentation/devicetree/bindings/mfd/da9150.txt   |   41 +
 .../devicetree/bindings/power/da9150-charger.txt   |   26 +
 MAINTAINERS                                        |    4 +
 drivers/iio/adc/Kconfig                            |    9 +
 drivers/iio/adc/Makefile                           |    1 +
 drivers/iio/adc/da9150-gpadc.c                     |  430 ++++++++
 drivers/mfd/Kconfig                                |   12 +
 drivers/mfd/Makefile                               |    2 +
 drivers/mfd/da9150-core.c                          |  332 ++++++
 drivers/mfd/da9150-i2c.c                           |  176 +++
 drivers/power/Kconfig                              |   12 +
 drivers/power/Makefile                             |    1 +
 drivers/power/da9150-charger.c                     |  715 ++++++++++++
 include/linux/mfd/da9150/core.h                    |   80 ++
 include/linux/mfd/da9150/pdata.h                   |   21 +
 include/linux/mfd/da9150/registers.h               | 1153 ++++++++++++++++++++
 17 files changed, 3031 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iio/adc/da9150-gpadc.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/da9150.txt
 create mode 100644 Documentation/devicetree/bindings/power/da9150-charger.txt
 create mode 100644 drivers/iio/adc/da9150-gpadc.c
 create mode 100644 drivers/mfd/da9150-core.c
 create mode 100644 drivers/mfd/da9150-i2c.c
 create mode 100644 drivers/power/da9150-charger.c
 create mode 100644 include/linux/mfd/da9150/core.h
 create mode 100644 include/linux/mfd/da9150/pdata.h
 create mode 100644 include/linux/mfd/da9150/registers.h

--
1.9.3

