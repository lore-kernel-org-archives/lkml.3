Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab3KSTIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 14:08:25 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:3472 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521Ab3KSTIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 14:08:20 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Markus Mayer" <markus.mayer@linaro.org>
To: "Wim Van Sebroeck" <wim@iguana.be>, "Guenter Roeck" <linux@roeck-us.net>,
        "Christian Daudt" <bcm@fixthebug.org>
cc: "Linaro Patches" <patches@linaro.org>,
        "Matt Porter" <matt.porter@linaro.org>,
        "One Thousand Gnomes" <gnomes@lxorguk.ukuu.org.uk>,
        "Linux Watchdog List" <linux-watchdog@vger.kernel.org>,
        "ARM Kernel List" <linux-arm-kernel@lists.infradead.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Markus Mayer" <markus.mayer@linaro.org>
Subject: [PATCH v4 0/2] watchdog: bcm281xx: Watchdog Driver
Date: Tue, 19 Nov 2013 11:07:52 -0800
Message-ID: <1384888074-19696-1-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
X-WSS-ID: 7E95696E1SC9380506-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is version 4 of the watchdog driver for the BCM281xx family of mobile
SoCs.

Changes since version 3:
- Removed #include <linux/miscdevice.h>
- Added Reviewed-by:/Acked-by: Guenter Roeck

Changes since version 2:

- BCM_KONA_WDT_NAME: "bcm-kona-wdt" -> "bcm_kona_wdt"
- Don't initialize static variable
- Removed '{'/'}' from single-line statements
- busy_count retains the maximum loop count of the longest loop rather
  than an over-all maximum
- Use seq_puts() in lieu of seq_printf() in 2 locations
- Removed error message after devm_kzalloc()
- Added MODULE_ALIAS

Changes since version 1:

- Added module name to "help" section in Kconfig A few cosmetic code
- simplifications and fixes Removed most dev_info() calls and changed the
- remaining ones to dev_dbg() Renamed SECWDOG_WD_LOAD_FLAG_MASK to
- SECWDOG_WD_LOAD_FLAG Added some comments to secure_register_read() and
- struct bcm_kona_wdt Added delay to secure_register_read() Reduced maximum
- retry loop from 10000 to 1000 Introduced "busy_count" variable to count
- how often secure_register_read() gets stalled; this is available through
- debugfs Simplified secure_register_read() to return -ETIMEDOUT rather than
- using a variable parameter to indicate a timeout error Got rid of all uses
- of -EAGAIN Fixed return value check for debugfs_create_dir() Simplified
- bcm_kona_wdt_debugfs_init() by getting rid of goto Created new generic
- function bcm_kona_wdt_ctrl_reg_modify() The following functions now use
- bcm_kona_wdt_ctrl_reg_modify():
    - bcm_kona_wdt_set_resolution_reg() bcm_kona_wdt_set_timeout_reg()
    - bcm_kona_wdt_stop()
- Made bcm_kona_wdt_set_timeout_reg() more generic, so bcm_kona_wdt_start()
  can use it Removed MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR)

Markus Mayer (2):
  watchdog: bcm281xx: Watchdog Driver
  ARM: bcm281xx: watchdog configuration

 arch/arm/configs/bcm_defconfig  |    3 +
 drivers/watchdog/Kconfig        |   22 +++
 drivers/watchdog/Makefile       |    1 +
 drivers/watchdog/bcm_kona_wdt.c |  365 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 391 insertions(+)
 create mode 100644 drivers/watchdog/bcm_kona_wdt.c

-- 
1.7.9.5


