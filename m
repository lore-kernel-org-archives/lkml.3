Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbbAOJQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 04:16:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:21784 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbbAOJQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 04:16:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,402,1418112000"; 
   d="scan'208";a="670290666"
From: "David E. Box" <david.e.box@linux.intel.com>
To: wsa@the-dreams.de
Cc: jdelvare@suse.de, arnd@arndb.de, maxime.ripard@free-electrons.com,
        dianders@chromium.org, david.e.box@linux.intel.com,
        u.kleine-koenig@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com,
        boris.brezillon@free-electrons.com, maxime.coquelin@st.com,
        andrew@lunn.ch, sjg@chromium.org, markus.mayer@linaro.org,
        ch.naveen@samsung.com, jacob.jun.pan@linux.intel.com,
        max.schwarz@online.de, mika.westerberg@linux.intel.com,
        skuribay@pobox.com, Romain.Baeriswyl@abilis.com, wenkai.du@intel.com,
        christian.ruppert@abilis.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: [PATCH V4 0/2] i2c-designware: Add Intel Baytrail pmic i2c bus support
Date: Thu, 15 Jan 2015 01:12:15 -0800
Message-Id: <1421313137-1613-1-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417478973-25522-1-git-send-email-david.e.box@linux.intel.com>
References: <1417478973-25522-1-git-send-email-david.e.box@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V4:	- Added bus lock to i2c_dw_init() as suggested by Jarrko Nikula
	  <jarkko.nikula@linux.intel.com>. Addresses infrequent hang that was
	  seen occuring during probe.
	- Added label in i2c_dw_xfer() to bypass unnecessary lock release when
	  acquire fails. Suggested by Mika.
	- Changed make to build driver as composite addition to
	  i2c-designware-platform. Driver can be module or built-in following
	  the platform driver selection. Tested as both.
	- Added EPROBE_DEFER return to baytrail definition of i2c_dw_eval_lock()
	  to defer probe if iosf_mbi driver (required for acquring bus lock) is
	  not available.

V3:	- Split lock support and driver into separate patches
	- Change module build to bool. Platforms running without this driver
	  cannot perform critical functions such as charging. Furthermore attempts
	  by other drivers to access the i2c bus without a lock will hang the
	  platform.
	- Replaced has_hw_lock flag with acquire/release function pointers.
	- Replaced acquire/release ifdef code with single
	  i2c_dw_eval_lock_support() test for cleaner (if still undesirable)
	  compile time scalability. Future Intel platforms will however continue
	  to use the Baytrail driver.

V2:	- Moved semaphore detection out of dw platform driver
	- Replaced function pointers with defined acquire/release functions in
	  dw core. This helps eliminate the ifdefery in the dw platform driver.
	- Use new has_hw_lock flag to check if the lock exists on a given bus.
	- Use new pm_runtime_disabled flag to conditionally turnoff runtime pm
	  in the dw platform driver.

David E. Box (2):
  i2c-designware: Add i2c bus locking support
  i2c-designware: Add Intel Baytrail PMIC I2C bus support

 drivers/i2c/busses/Kconfig                   |  11 ++
 drivers/i2c/busses/Makefile                  |   1 +
 drivers/i2c/busses/i2c-designware-baytrail.c | 160 +++++++++++++++++++++++++++
 drivers/i2c/busses/i2c-designware-core.c     |  26 +++++
 drivers/i2c/busses/i2c-designware-core.h     |  12 ++
 drivers/i2c/busses/i2c-designware-platdrv.c  |  20 +++-
 6 files changed, 225 insertions(+), 5 deletions(-)
 create mode 100644 drivers/i2c/busses/i2c-designware-baytrail.c

-- 
1.9.1

