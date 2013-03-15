Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab3COHoM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 03:44:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:17377 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab3COHoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 03:44:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,849,1355126400"; 
   d="scan'208";a="302628343"
Date: Fri, 15 Mar 2013 08:43:19 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, Roger Quadros <rogerq@ti.com>
Subject: [GIT] [3.9] MFD fixes
Message-ID: <20130315074319.GA17807@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the first batch of MFD fixes for 3.9.

With this one we have:

- An ab8500 build failure fix.
- An ab8500 device tree parsing fix.
- A fix for twl4030_madc remove routine to work properly (when built-in).
- A fix for properly registering palmas interrupt handler.
- A fix for omap-usb init routine to actually write into the hostconfig
  register.
- A couple of warning fixes for ab8500-gpadc and tps65912.

Thanks in advance for pulling them in.

The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-fixes.git tags/mfd-fixes-3.9-1

for you to fetch changes up to 037154105e3767324db7c34bf8f540a12cb61d70:

  mfd: twl4030-madc: Remove __exit_p annotation (2013-03-15 07:42:22 +0100)

----------------------------------------------------------------
Arnd Bergmann (2):
      mfd: ab8500: Kill "reg" property from binding
      mfd: twl4030-madc: Remove __exit_p annotation

Axel Lin (2):
      mfd: Make AB8500_CORE select POWER_SUPPLY to fix build error
      mfd: ab8500-gpadc: Complain if we fail to enable vtvout LDO

Laxman Dewangan (1):
      mfd: palmas: Provide irq flags through DT/platform data

Mark Brown (3):
      mfd: tps65912: Declare and use tps65912_irq_exit()
      mfd: twl4030-audio: Fix argument type for twl4030_audio_disable_resource()
      mfd: wm831x: Don't forward declare enum wm831x_auxadc

Roger Quadros (1):
      mfd: omap-usb-host: Actually update hostconfig

 Documentation/devicetree/bindings/mfd/ab8500.txt |    6 +---
 arch/arm/boot/dts/dbx5x0.dtsi                    |    3 +-
 arch/arm/boot/dts/href.dtsi                      |    2 +-
 arch/arm/boot/dts/hrefv60plus.dts                |    2 +-
 arch/arm/boot/dts/snowball.dts                   |    2 +-
 drivers/mfd/Kconfig                              |    1 +
 drivers/mfd/ab8500-gpadc.c                       |   17 +++++++---
 drivers/mfd/omap-usb-host.c                      |    6 ++--
 drivers/mfd/palmas.c                             |   36 ++++++++++++++++++++--
 drivers/mfd/tps65912-core.c                      |    1 +
 drivers/mfd/twl4030-audio.c                      |    2 +-
 drivers/mfd/twl4030-madc.c                       |    2 +-
 include/linux/mfd/palmas.h                       |    1 +
 include/linux/mfd/tps65912.h                     |    1 +
 include/linux/mfd/wm831x/auxadc.h                |    2 ++
 include/linux/mfd/wm831x/core.h                  |    2 +-
 16 files changed, 63 insertions(+), 23 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
