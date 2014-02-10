Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbaBJKKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:10:44 -0500
Received: from sauhun.de ([89.238.76.85]:38533 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714AbaBJKE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:04:28 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        adi-buildroot-devel@lists.sourceforge.net,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH 00/17] i2c: deprecate class based instantiation for embedded I2C drivers
Date: Mon, 10 Feb 2014 11:03:54 +0100
Message-Id: <1392026654-5343-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With I2C, class based instantiation means if a master driver has e.g.
I2C_CLASS_HWMON set, all slave drivers with this class will try to probe a
device using an array of possible addresses and some heuristics. That creates
traffic and needs time, even when nothing is connected. This mechanism is
needed when you do not have another method to describe the slaves. Embedded I2C
drivers do not need class based instantiation, since there is i2c_board_info or
devicetree description. Some drivers have the class flags set, though, and it
has spread further over the years. We can't remove the flags directly, because
there might be users out there relying on this feature. So, we add a
deprecation warning if a device is instantiated via class attributes. After
giving some time to switch over, we can then finally remove the class flags and
gain boot time.

Patch 1 adds some missing documentation. Patch 2 adds the deprecation feature.
Patches 3+4 are tested on hardware I need. Patches 5-17 are suggestions for
drivers I think could benefit from that. For those, acks are needed before I
will apply them to my tree. If you use a different driver which can also
benefit from this, just send a patch adding the new DEPRECATED flag.

The series can also be found here:

git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/deprecated_class

Thanks,

   Wolfram


Wolfram Sang (17):
  Documentation: i2c: describe devicetree method for instantiating
    devices
  i2c: add deprecation warning for class based instantiation
  i2c: i2c-omap: deprecate class based instantiation
  i2c: i2c-at91: deprecate class based instantiation
  i2c: i2c-bcm2835: deprecate class based instantiation
  i2c: i2c-bfin-twi: deprecate class based instantiation
  i2c: i2c-davinci: deprecate class based instantiation
  i2c: i2c-designware-platdrv: deprecate class based instantiation
  i2c: i2c-mv64xxx: deprecate class based instantiation
  i2c: i2c-nomadik: deprecate class based instantiation
  i2c: i2c-ocores: deprecate class based instantiation
  i2c: i2c-rcar: deprecate class based instantiation
  i2c: i2c-s3c2410: deprecate class based instantiation
  i2c: i2c-sirf: deprecate class based instantiation
  i2c: i2c-stu300: deprecate class based instantiation
  i2c: i2c-tegra: deprecate class based instantiation
  i2c: i2c-xiic: deprecate class based instantiation

 Documentation/i2c/instantiating-devices     | 34 +++++++++++++++++++++++++++--
 drivers/i2c/busses/i2c-at91.c               |  2 +-
 drivers/i2c/busses/i2c-bcm2835.c            |  2 +-
 drivers/i2c/busses/i2c-bfin-twi.c           |  2 +-
 drivers/i2c/busses/i2c-davinci.c            |  2 +-
 drivers/i2c/busses/i2c-designware-platdrv.c |  2 +-
 drivers/i2c/busses/i2c-mv64xxx.c            |  2 +-
 drivers/i2c/busses/i2c-nomadik.c            |  2 +-
 drivers/i2c/busses/i2c-ocores.c             |  2 +-
 drivers/i2c/busses/i2c-omap.c               |  2 +-
 drivers/i2c/busses/i2c-rcar.c               |  2 +-
 drivers/i2c/busses/i2c-s3c2410.c            |  2 +-
 drivers/i2c/busses/i2c-sirf.c               |  2 +-
 drivers/i2c/busses/i2c-stu300.c             |  2 +-
 drivers/i2c/busses/i2c-tegra.c              |  2 +-
 drivers/i2c/busses/i2c-xiic.c               |  2 +-
 drivers/i2c/i2c-core.c                      |  7 ++++++
 include/linux/i2c.h                         |  1 +
 18 files changed, 55 insertions(+), 17 deletions(-)

-- 
1.8.5.1

