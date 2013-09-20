Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab3ITMIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 08:08:47 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13411 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab3ITMIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 08:08:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 20 Sep 2013 05:05:19 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lee.jones@linaro.org>, <sameo@linux.intel.com>, <broonie@kernel.org>,
        <linus.walleij@linaro.org>, <akpm@linux-foundation.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <rtc-linux@googlegroups.com>, <rob.herring@calxeda.com>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <swarren@wwwdotorg.org>,
        <rob@landley.net>, <ijc+devicetree@hellion.org.uk>,
        <grant.likely@linaro.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 0/5] Add AMS AS3722 mfd, GPIO, regulator and RTC driver
Date: Fri, 20 Sep 2013 18:00:09 +0530
Message-ID: <1379680214-9143-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series add the driver support for AMS AS3722 PMIC. The driver includes
MFD, GPIO, regulator and RTC.

Changes from V1:
- Remove compatible string from DT for subnode.
- Add macro in regmap.h for definign range.
- Nit cleanups in driver and use module_i2c_driver/module_platform_driver.
- Use linear_range and added regulator_map_* on regulators.
- Move OC configuration to regulator_current limit setting.
- Get rid of clk32k out configuration from RTC. Will add clock driver.


Laxman Dewangan (5):
  regmap: add helper macro to set min/max range of register
  mfd: add support for AMS AS3722 PMIC
  gpio: add support for AMS AS3722 gpio driver
  regulator: as3722: add regulator driver for AMS AS3722
  drivers/rtc/rtc-as3722: add RTC driver

 .../devicetree/bindings/gpio/gpio-as3722.txt       |   62 ++
 Documentation/devicetree/bindings/mfd/as3722.txt   |   47 +
 .../bindings/regulator/as3722-regulator.txt        |   91 ++
 drivers/gpio/Kconfig                               |    6 +
 drivers/gpio/Makefile                              |    1 +
 drivers/gpio/gpio-as3722.c                         |  435 ++++++++++
 drivers/mfd/Kconfig                                |   12 +
 drivers/mfd/Makefile                               |    1 +
 drivers/mfd/as3722.c                               |  448 ++++++++++
 drivers/regulator/Kconfig                          |    8 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/as3722-regulator.c               |  917 ++++++++++++++++++++
 drivers/rtc/Kconfig                                |   10 +
 drivers/rtc/Makefile                               |    1 +
 drivers/rtc/rtc-as3722.c                           |  296 +++++++
 include/linux/mfd/as3722.h                         |  423 +++++++++
 include/linux/regmap.h                             |    2 +
 17 files changed, 2761 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-as3722.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/as3722.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/as3722-regulator.txt
 create mode 100644 drivers/gpio/gpio-as3722.c
 create mode 100644 drivers/mfd/as3722.c
 create mode 100644 drivers/regulator/as3722-regulator.c
 create mode 100644 drivers/rtc/rtc-as3722.c
 create mode 100644 include/linux/mfd/as3722.h

