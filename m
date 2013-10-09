Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab3JIMEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 08:04:25 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10420 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757299Ab3JIMEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 08:04:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 09 Oct 2013 05:04:22 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lee.jones@linaro.org>, <sameo@linux.intel.com>, <broonie@kernel.org>,
        <linus.walleij@linaro.org>, <akpm@linux-foundation.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <rtc-linux@googlegroups.com>, <rob.herring@calxeda.com>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <swarren@wwwdotorg.org>,
        <rob@landley.net>, <ijc+devicetree@hellion.org.uk>,
        <grant.likely@linaro.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V5 0/3] Add AMS AS3722 mfd, pincontrol and RTC driver.
Date: Wed, 9 Oct 2013 17:59:18 +0530
Message-ID: <1381321761-8898-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series add the driver support for AMS AS3722 PMIC. The driver includes MFD, pincontrol and GPIO, regulator and RTC.

Changes from V1: 
- Remove compatible string from DT for subnode.
- Add macro in regmap.h for definign range.
- Nit cleanups in driver and use module_i2c_driver/module_platform_driver.
- Use linear_range and added regulator_map_* on regulators.
- Move OC configuration to regulator_current limit setting.
- Get rid of clk32k out configuration from RTC. Will add clock driver.

Changes from V2: 
- Drop the already applied patches on V2 series
        regmap: add helper macro to set min/max range of register
        regulator: as3722: add regulator driver for AMS AS3722
- Move the GPIo driver to pincontrol driver to expose the pin configuration
  through pincontrol.
- rewrite the DT binding of the mfd.

Changes from V3:
- Change AMS to ams
- combine DT of regulator, pincontrol to the mfd.
- Taken care of Lee's nits feedback.

Changes from V4:
- Rephrased the DT binding document.
- Add header for dt-binding macros.

Laxman Dewangan (3):
  mfd: add support for ams AS3722 PMIC
  pincntrl: add support for ams AS3722 pin control driver
  drivers/rtc/rtc-as3722: add RTC driver

 Documentation/devicetree/bindings/mfd/as3722.txt |  194 +++++++
 drivers/mfd/Kconfig                              |   12 +
 drivers/mfd/Makefile                             |    1 +
 drivers/mfd/as3722.c                             |  449 +++++++++++++++
 drivers/pinctrl/Kconfig                          |   11 +
 drivers/pinctrl/Makefile                         |    1 +
 drivers/pinctrl/pinctrl-as3722.c                 |  630 ++++++++++++++++++++++
 drivers/rtc/Kconfig                              |   10 +
 drivers/rtc/Makefile                             |    1 +
 drivers/rtc/rtc-as3722.c                         |  296 ++++++++++
 include/dt-bindings/mfd/as3722.h                 |   52 ++
 include/linux/mfd/as3722.h                       |  423 +++++++++++++++
 12 files changed, 2080 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/as3722.txt
 create mode 100644 drivers/mfd/as3722.c
 create mode 100644 drivers/pinctrl/pinctrl-as3722.c
 create mode 100644 drivers/rtc/rtc-as3722.c
 create mode 100644 include/dt-bindings/mfd/as3722.h
 create mode 100644 include/linux/mfd/as3722.h

