Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbaKQIdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 03:33:49 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:50675 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaKQIdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 03:33:47 -0500
From: gyungoh@gmail.com
X-Google-Original-From: jack.yoo@skyworksinc.com
To: sameo@linux.intel.com, lee.jones@linaro.org, jg1.han@samsung.com,
        cooloney@gmail.com, broonie@kernel.org, lgirdwood@gmail.com
Cc: jack.yoo@skyworksinc.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Subject: [RESUBMIT PATCH v7 0/9] Add Skyworks SKY81452 device drivers
Date: Mon, 17 Nov 2014 17:33:01 +0900
Message-Id: <1416213190-20935-1-git-send-email-jack.yoo@skyworksinc.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gyungoh Yoo <jack.yoo@skyworksinc.com>

This patch set includes regulator and backlight driver for SKY81452.
Also it includes documents for device tree and module.
The initial version of sky81452-regulator was applied. Fo this, incremental
patches are included.

v7:
Modified licensing text to GPLv2
Splitted Kconfig renaming from DT patch

v6:
Added new line character at the end of line of dev_err()

v5:
Changed DT for regulator : 'lout' node should be defined under 'regulator'
Removed compatible string from sky81452-regulator driver
Modified sky81452-regulator to return EINVAL when of_node is NULL
Move sky81452-backlight.h to include/linux/platform_data

v4:
Removed MODULE_VERSION()
Modified license to GPLv2
Removed calling to backlight_device_unregister() in sky81452-backlight

v3:
Cleaned-up DBG messages
Cleaned-up DT
Fixed the backlight name from 'sky81452-bl' to 'sky81452-backlight'
Assigned mfd_cell.of_compatible for binding device node
Modified error messages
Modified sky81452-regulator to return ENODATA when of_node is NULL

v2:
Split the patches for each sub-system
Added 'reg' attribute for I2C address in device tree documents
Added 'compatible' attribute in child drivers
Renamed CONFIG_SKY81452 to CONFIG_MFD_SKY81452
Changed the dependency from I2C=y to I2C, for CONFIG_MFD_SKY81452
Added message for exception or errors.
Added vendor prefix for Skyworks Solutions, Inc.
Add SKY81452 to the Trivial Devices list

Gyungoh Yoo (9):
  mfd: Add support for Skyworks SKY81452 driver
  backlight: Add support Skyworks SKY81452 backlight driver
  devicetree: mfd: Add new SKY81452 mfd binding
  devicetree: backlight: Add new SKY81452 backlight binding
  devicetree: Add vendor prefix for Skyworks Solutions, Inc.
  devicetree: i2c: Add SKY81452 to the Trivial Devices list
  regulator: sky81452: Modify Device Tree structure
  devicetree: regulator: sky81452: Modify Device Tree structure
  regulator: sky81452: Modify dependent Kconfig symbol

 .../devicetree/bindings/i2c/trivial-devices.txt    |   1 +
 Documentation/devicetree/bindings/mfd/sky81452.txt |  33 ++
 .../bindings/regulator/sky81452-regulator.txt      |  10 +-
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 .../video/backlight/sky81452-backlight.txt         |  24 ++
 drivers/mfd/Kconfig                                |  12 +
 drivers/mfd/Makefile                               |   1 +
 drivers/mfd/sky81452.c                             | 108 +++++++
 drivers/regulator/Kconfig                          |   2 +-
 drivers/regulator/sky81452-regulator.c             |  34 +-
 drivers/video/backlight/Kconfig                    |  10 +
 drivers/video/backlight/Makefile                   |   1 +
 drivers/video/backlight/sky81452-backlight.c       | 343 +++++++++++++++++++++
 include/linux/mfd/sky81452.h                       |  31 ++
 include/linux/platform_data/sky81452-backlight.h   |  46 +++
 15 files changed, 639 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/sky81452.txt
 create mode 100644 Documentation/devicetree/bindings/video/backlight/sky81452-backlight.txt
 create mode 100644 drivers/mfd/sky81452.c
 create mode 100644 drivers/video/backlight/sky81452-backlight.c
 create mode 100644 include/linux/mfd/sky81452.h
 create mode 100644 include/linux/platform_data/sky81452-backlight.h

-- 
1.9.1

