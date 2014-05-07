Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbaEGCxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 22:53:48 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55822 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751721AbaEGCxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 22:53:46 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>, wim@iguana.be, dbaryshkov@gmail.com,
        dwmw2@infradead.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-sunxi@googlegroups.com,
        linux@roeck-us.net, Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 0/6] ARM: sunxi: Machine code cleanup
Date: Tue,  6 May 2014 21:44:18 -0500
Message-Id: <1399430664-29091-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This serie moves the restart code out of the mach-sunxi directory to
either the watchdog driver or to a new driver in drivers/power/reset.

Since the reset code was pretty much all the code left in the
mach-sunxi directory for all the SoCs but the A31, the only thing left
into mach-sunxi are empty machine definition.

Thanks, Maxime

Changes from v1:
  - Left the minimal machines instead of removing them
  - Changed the context pointer in the watchdog driver to just a
    global base address

Maxime Ripard (6):
  wdt: sunxi: Move restart code to the watchdog driver
  power: reset: Add Allwinner A31 reset code
  ARM: sunxi: Remove reset code from the platform
  ARM: sunxi: Remove init_machine callback
  ARM: sunxi: Add A31 reset driver to sunxi_defconfig
  ARM: multi_v7: Add Allwinner reset drivers to multi_v7_defconfig

 arch/arm/configs/multi_v7_defconfig |   2 +
 arch/arm/configs/sunxi_defconfig    |   3 +
 arch/arm/mach-sunxi/sunxi.c         | 107 ------------------------------------
 drivers/power/reset/Kconfig         |   7 +++
 drivers/power/reset/Makefile        |   1 +
 drivers/power/reset/sun6i-reboot.c  |  85 ++++++++++++++++++++++++++++
 drivers/watchdog/sunxi_wdt.c        |  29 ++++++++++
 7 files changed, 127 insertions(+), 107 deletions(-)
 create mode 100644 drivers/power/reset/sun6i-reboot.c

-- 
1.9.1

