Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbaEEDkJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 23:40:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35283 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752561AbaEEDkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 23:40:07 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>, wim@iguana.be, dbaryshkov@gmail.com,
        dwmw2@infradead.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 0/6] ARM: sunxi: Machine code cleanup
Date: Sun,  4 May 2014 22:07:58 -0500
Message-Id: <1399259284-6282-1-git-send-email-maxime.ripard@free-electrons.com>
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

