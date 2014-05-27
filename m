Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaE0INQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:13:16 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.149]:28991 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752916AbaE0INK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:13:10 -0400
X-Env-Sender: Andreas.Werner@men.de
X-Msg-Ref: server-7.tower-178.messagelabs.com!1401178385!28065610!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Tue, 27 May 2014 10:13:06 +0200
Date: Tue, 27 May 2014 11:05:37 +0200
From: Andreas Werner <andreas.werner@men.de>
To: <linux-kernel@vger.kernel.org>
CC: <sameo@linux.intel.com>, <lee.jones@linaro.org>, <wim@iguana.be>,
        <linux-watchdog@vger.kernel.org>, <cooloney@gmail.com>,
        <rpurdie@rpsys.net>, <linux-leds@vger.kernel.org>,
        <johannes.thumshirn@men.de>, <andreas.werner@men.de>
Subject: [PATCH v2 0/3] Introduce MEN 14F02100 BMC driver series
Message-ID: <cover.1401181010.git.andreas.werner@men.de>
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
The main part of the BMC is to start and monitor the board, but there are a
lot more features which can be accessed using an I2C Host interface

Features supported in this Patchset:
        - Watchdog
        - LEDs

The Patchset includes a MFD Core driver, Watchdog and LEDs driver.


Changes in v2:
	- changed i2c_smbus_read wrapper function to return both, value
	  and error.
	- moved "leave production mode" from Watchdog driver to mfd core.
	- fixed some return values in the watchdog driver to return the original
	  error value instead of -EIO.

Andreas Werner (3):
  drivers/mfd/menf21bmc: introduce MEN 14F021P00 BMC MFD Core driver
  drivers/watchdog/menf21bmc_wd: introduce MEN 14F021P00 BMC Watchdog
    driver
  drivers/leds/leds-menf21bmc: introduce MEN 14F021P00 BMC LED driver

 drivers/leds/Kconfig            |   6 ++
 drivers/leds/Makefile           |   2 +-
 drivers/leds/leds-menf21bmc.c   | 136 +++++++++++++++++++++++++
 drivers/mfd/Kconfig             |  12 +++
 drivers/mfd/Makefile            |   1 +
 drivers/mfd/menf21bmc.c         | 220 ++++++++++++++++++++++++++++++++++++++++
 drivers/watchdog/Kconfig        |   7 ++
 drivers/watchdog/Makefile       |   1 +
 drivers/watchdog/menf21bmc_wd.c | 217 +++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/menf21bmc.h   |  31 ++++++
 10 files changed, 632 insertions(+), 1 deletion(-)
 create mode 100644 drivers/leds/leds-menf21bmc.c
 create mode 100644 drivers/mfd/menf21bmc.c
 create mode 100644 drivers/watchdog/menf21bmc_wd.c
 create mode 100644 include/linux/mfd/menf21bmc.h

-- 
1.9.3

