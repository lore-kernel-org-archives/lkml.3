Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaHZQxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 12:53:37 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.152]:38715 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752344AbaHZQxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 12:53:35 -0400
X-Env-Sender: Andreas.Werner@men.de
X-Msg-Ref: server-14.tower-180.messagelabs.com!1409072012!39771021!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Tue, 26 Aug 2014 18:53:33 +0200
Date: Tue, 26 Aug 2014 19:45:24 +0200
From: Andreas Werner <andreas.werner@men.de>
To: <linux-kernel@vger.kernel.org>
CC: <sameo@linux.intel.com>, <lee.jones@linaro.org>, <wim@iguana.be>,
        <linux-watchdog@vger.kernel.org>, <cooloney@gmail.com>,
        <rpurdie@rpsys.net>, <linux-leds@vger.kernel.org>, <jdelvare@suse.de>,
        <linux@roeck-us.net>, <lm-sensors@lm-sensors.org>,
        <johannes.thumshirn@men.de>
Subject: [PATCH v5 0/4] Introduce MEN 14F021P00 BMC driver series
Message-ID: <cover.1409074255.git.andreas.werner@men.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.1.1.171]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set add support for the MEN 14F021P00 Board Management called BMC.

The BMC is a PIC Mikrocontroller which assembled on almost all of our
3U Compact PCI CPU board and a few Box PCs.
main part of the BMC is to start and monitor the board, but there are a
lot more features which can be accessed using an I2C Host interface

Features supported in this Patchset:
        - Watchdog
        - LEDs
        - HWMON

The Patchset includes a MFD Core driver, Watchdog, hwmon  and LEDs driver.

Changes in v5:
	- fixed I2C dependency in MFD Kconfig
	- added correct error handling in update function of the hwmon slave
	  (Use of ERR_PTR)
	- add ATTRIBUTE_GROUP Macro in hwmon slave
	  and deleted platform_set_drvdata

Changes in v4:
        - fixed some style issues
        - fixed GPL license version
        - added hwmon voltage monitoring slave driver

Changes in v3:
        - deleted i2c_smbus wrapper functions and use native one
        - some cosmentics and variable renaming to be more clear
        - renamed "leave production" mode to "exit production mode"

Changes in v2:
        - changed i2c_smbus_read wrapper function to return both, value
          and error.
        - moved "leave production mode" from Watchdog driver to mfd core.
        - fixed some return values in the watchdog driver to return the original
          error value instead of -EIO.


Andreas Werner (4):
  drivers/mfd/menf21bmc: introduce MEN 14F021P00 BMC MFD Core driver
  drivers/watchdog/menf21bmc_wdt: introduce MEN 14F021P00 BMC Watchdog
    driver
  drivers/leds/leds-menf21bmc: introduce MEN 14F021P00 BMC LED driver
  drivers/hwmon/menf21bmc_hwmon: introduce MEN14F021P00 BMC HWMON driver

 Documentation/hwmon/menf21bmc    |  49 +++++++++
 drivers/hwmon/Kconfig            |   7 ++
 drivers/hwmon/Makefile           |   1 +
 drivers/hwmon/menf21bmc_hwmon.c  | 230 +++++++++++++++++++++++++++++++++++++++
 drivers/leds/Kconfig             |   6 +
 drivers/leds/Makefile            |   1 +
 drivers/leds/leds-menf21bmc.c    | 131 ++++++++++++++++++++++
 drivers/mfd/Kconfig              |  12 ++
 drivers/mfd/Makefile             |   1 +
 drivers/mfd/menf21bmc.c          | 132 ++++++++++++++++++++++
 drivers/watchdog/Kconfig         |   7 ++
 drivers/watchdog/Makefile        |   1 +
 drivers/watchdog/menf21bmc_wdt.c | 203 ++++++++++++++++++++++++++++++++++
 13 files changed, 781 insertions(+)
 create mode 100644 Documentation/hwmon/menf21bmc
 create mode 100644 drivers/hwmon/menf21bmc_hwmon.c
 create mode 100644 drivers/leds/leds-menf21bmc.c
 create mode 100644 drivers/mfd/menf21bmc.c
 create mode 100644 drivers/watchdog/menf21bmc_wdt.c

-- 
2.0.4

