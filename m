Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870AbaLBANQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 19:13:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:6237 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812AbaLBANN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 19:13:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,497,1413270000"; 
   d="scan'208";a="616952913"
From: "David E. Box" <david.e.box@linux.intel.com>
To: wsa@the-dreams.de
Cc: jdelvare@suse.de, arnd@arndb.de, maxime.ripard@free-electrons.com,
        dianders@chromium.org, u.kleine-koenig@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com,
        boris.brezillon@free-electrons.com, andrew@lunn.ch, sjg@chromium.org,
        markus.mayer@linaro.org, jacob.jun.pan@linux.intel.com,
        max.schwarz@online.de, mika.westerberg@linux.intel.com,
        skuribay@pobox.com, Romain.Baeriswyl@abilis.com, wenkai.du@intel.com,
        chiau.ee.chew@intel.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: [PATCH V3 0/2] i2c-designware: Baytrail bus locking driver
Date: Mon,  1 Dec 2014 16:09:31 -0800
Message-Id: <1417478973-25522-1-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411497626-7984-1-git-send-email-david.e.box@linux.intel.com>
References: <1411497626-7984-1-git-send-email-david.e.box@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Select Intel Baytrail platforms support PMIC's whose i2c bus may be controlled
exclusively by platform hardware. This patch set adds support for i2c bus
locking to the designware core and provides a driver module for managing
the lock on these platforms. Since the lock on these systems isn't enumerable
outside of the i2c platform driver, the locking functions are assigned at
compile time.

V2:     Moved semaphore detection out of dw platform driver
        Replaced function pointers with defined acquire/release functions in dw
                core. This helps elliminate the ifdefery in the dw platform driver.
        Use new has_hw_lock flag to check if the lock exists on a given bus.
        Use new pm_runtime_disabled flag to conditionally turnoff runtime pm
                in the dw platform driver.

V3:	Split lock support and driver into separate patches
	Change module build to bool. Platforms running without this driver cannot
		perform critical functions such as charging. Futhermore attempts by
		other drivers to access the i2c bus without a lock will hang the
		platform.
	Replaced has_hw_lock flag with acquire/release function pointers.
	Replaced acquire/release ifdef code with single i2c_dw_eval_lock_support()
		test for cleaner (if still undesireable) compile time scalability.
		Future Intel platforms will however continue to use the Baytrail
		driver.

David E. Box (2):
  i2c-designware: Add i2c bus locking support
  i2c-designware: Add Intel Baytrail PMIC I2C bus support

 drivers/i2c/busses/Kconfig                   |  12 +++
 drivers/i2c/busses/Makefile                  |   1 +
 drivers/i2c/busses/i2c-designware-baytrail.c | 155 +++++++++++++++++++++++++++
 drivers/i2c/busses/i2c-designware-core.c     |  11 ++
 drivers/i2c/busses/i2c-designware-core.h     |  12 +++
 drivers/i2c/busses/i2c-designware-platdrv.c  |  18 +++-
 6 files changed, 204 insertions(+), 5 deletions(-)
 create mode 100644 drivers/i2c/busses/i2c-designware-baytrail.c

-- 
1.9.1

