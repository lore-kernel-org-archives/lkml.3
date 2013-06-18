Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033Ab3FRVNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:13:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:63230 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449Ab3FRVNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:13:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,891,1363158000"; 
   d="scan'208";a="331744348"
From: Kevin Strasser <kevin.strasser@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Kevin Strasser <kevin.strasser@linux.intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Michael Brunner <mibru@gmx.de>, Chris Healy <chealy@imsco-us.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dirk Hohndel <Dirk.Hohndel@intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-i2c@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: [PATCH v2 0/4] Kontron PLD drivers
Date: Tue, 18 Jun 2013 14:04:25 -0700
Message-Id: <1371589469-32700-1-git-send-email-kevin.strasser@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mfd changes since v1:
- Use a mutex instead of spinlock
- Poll for hardware mutex without timeout
- Restructure mfd cell structs, only call mfd_add_devices once
- Drop pointless BUG_ONs
- EXPORT_SYMBOL -> EXPORT_SYMBOL_GPL
- kempld_*_mutex_set_index -> kempld_*_mutex
- Removed kempld_try_get_mutex
- Drop last_index
- Remove EFT code
- Drop unused includes
- Use devm_ioport_map
- Restructure to get rid of forward function prototypes
- Renamed module parameter force_ident -> force_device_id
- Dropped force_unlock module parameter
- Formatting fixes

i2c changes since v1:
- Always disable bus during suspend,
- Detect was_active in probe
- Remove i2c-kempld.h
- Clean up register definitions
- Use the correct device for printing
- Set default bus frequency to 100kHz
- Drop irq support
- Drop now1 driver
- Remove i2c-mux code
- Clean up includes
- Use devm_kzalloc
- Formatting fixes

gpio changes since v1:
- Change label from kempld-gpio -> gpio-kempld
- Drop unnecessary include seq_file.h
- Register and value parameters to kempld_get_bit and kempld_bitop are now u8
- Status variable in kempld_bitop is now u8
- Fix kempld_gpio_pincount(). hweight16 doesn't work, but __ffs does
- Drop interrupt support
- Drop gpio-kempld.h
- Use helper functions for bit and read operations
- Use generic DEBUG_FS code
- Use devm_kzalloc
- Get gpio_base from platform data
- Drop all module parameters
- Use module_platform_driver
- Drop unused includes
- Include device.h instead of slab.h for devm_kzalloc
- Some cleanup here and there

watchdog changes since v1:
- Use watchdog framework
- Allocate stages statically
- Drop now1 driver
- Use devm_kzalloc
- Change default timeout to 30 seconds
- Drop unused includes
- General formatting cleanup

Kevin Strasser (4):
  mfd: Kontron PLD mfd driver
  i2c: Kontron PLD i2c bus driver
  gpio: Kontron PLD gpio driver
  watchdog: Kontron PLD watchdog timer driver

 drivers/gpio/Kconfig            |   12 +
 drivers/gpio/Makefile           |    1 +
 drivers/gpio/gpio-kempld.c      |  225 ++++++++++++++
 drivers/i2c/busses/Kconfig      |   10 +
 drivers/i2c/busses/Makefile     |    1 +
 drivers/i2c/busses/i2c-kempld.c |  410 +++++++++++++++++++++++++
 drivers/mfd/Kconfig             |   21 ++
 drivers/mfd/Makefile            |    1 +
 drivers/mfd/kempld-core.c       |  642 +++++++++++++++++++++++++++++++++++++++
 drivers/watchdog/Kconfig        |   11 +
 drivers/watchdog/Makefile       |    1 +
 drivers/watchdog/kempld_wdt.c   |  580 +++++++++++++++++++++++++++++++++++
 include/linux/mfd/kempld.h      |  125 ++++++++
 13 files changed, 2040 insertions(+)
 create mode 100644 drivers/gpio/gpio-kempld.c
 create mode 100644 drivers/i2c/busses/i2c-kempld.c
 create mode 100644 drivers/mfd/kempld-core.c
 create mode 100644 drivers/watchdog/kempld_wdt.c
 create mode 100644 include/linux/mfd/kempld.h

-- 
1.7.9.5

