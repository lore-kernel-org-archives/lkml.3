Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaGJLqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:46:48 -0400
Received: from sauhun.de ([89.238.76.85]:57075 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbaGJLqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:46:46 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Wolfram Sang <wsa@the-dreams.de>,
        adi-buildroot-devel@lists.sourceforge.net,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH 00/16] i2c: drop class based instantiaion for selected drivers
Date: Thu, 10 Jul 2014 13:46:20 +0200
Message-Id: <1404992799-3705-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers were flagged to remove class based instantiation soon to improve
boot-up time. Originally, I was planning for a longer deprecation time so users
could switch over to some other kind of instantiation. However, the demand for
the speed up is high enough and class based instantiation is used rarely, so
the removal takes place now. To make up for the deprecation time, another
warning is added to the i2c core pointing out that the behaviour has now
changed:

+	/* Warn that the adapter lost class based instantiation */
+	if (adapter->class == I2C_CLASS_DEPRECATED) {
+		dev_dbg(&adapter->dev,
+			"This adapter dropped support for I2C classes and "
+			"won't auto-detect %s devices anymore. If you need it, check "
+			"'Documentation/i2c/instantiating-devices' for alternatives.\n",
+			driver->driver.name);
+		return 0;
+	}

A branch can be found here (with two other cleanups -> driver removals):
git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/deprecate_stuff

I hope this meets all the needs. Please comment, ack, test...

Thanks,

   Wolfram


Wolfram Sang (16):
  i2c: add debug info when class instantiation was dropped
  i2c: i2c-at91: Drop class based scanning to improve bootup time
  i2c: i2c-bcm2835: Drop class based scanning to improve bootup time
  i2c: i2c-bfin-twi: Drop class based scanning to improve bootup time
  i2c: i2c-davinci: Drop class based scanning to improve bootup time
  i2c: i2c-designware-platdrv: Drop class based scanning to improve
    bootup time
  i2c: i2c-mv64xxx: Drop class based scanning to improve bootup time
  i2c: i2c-nomadik: Drop class based scanning to improve bootup time
  i2c: i2c-ocores: Drop class based scanning to improve bootup time
  i2c: i2c-omap: Drop class based scanning to improve bootup time
  i2c: i2c-rcar: Drop class based scanning to improve bootup time
  i2c: i2c-s3c2410: Drop class based scanning to improve bootup time
  i2c: i2c-sirf: Drop class based scanning to improve bootup time
  i2c: i2c-stu300: Drop class based scanning to improve bootup time
  i2c: i2c-tegra: Drop class based scanning to improve bootup time
  i2c: i2c-xiic: Drop class based scanning to improve bootup time

 drivers/i2c/busses/i2c-at91.c               |  2 +-
 drivers/i2c/busses/i2c-bcm2835.c            |  2 +-
 drivers/i2c/busses/i2c-bfin-twi.c           |  2 +-
 drivers/i2c/busses/i2c-davinci.c            |  2 +-
 drivers/i2c/busses/i2c-designware-platdrv.c |  2 +-
 drivers/i2c/busses/i2c-mv64xxx.c            |  2 +-
 drivers/i2c/busses/i2c-nomadik.c            |  8 ++++----
 drivers/i2c/busses/i2c-ocores.c             | 12 ++++++------
 drivers/i2c/busses/i2c-omap.c               |  2 +-
 drivers/i2c/busses/i2c-rcar.c               | 14 +++++++-------
 drivers/i2c/busses/i2c-s3c2410.c            |  8 ++++----
 drivers/i2c/busses/i2c-sirf.c               |  2 +-
 drivers/i2c/busses/i2c-stu300.c             |  2 +-
 drivers/i2c/busses/i2c-tegra.c              |  2 +-
 drivers/i2c/busses/i2c-xiic.c               | 12 ++++++------
 drivers/i2c/i2c-core.c                      | 10 ++++++++++
 16 files changed, 47 insertions(+), 37 deletions(-)

-- 
2.0.0

