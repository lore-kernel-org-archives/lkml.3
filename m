Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbaDWPH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:07:26 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58603 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757545AbaDWPHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:07:12 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>, wim@iguana.be, dbaryshkov@gmail.com,
        dwmw2@infradead.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 0/5] ARM: sunxi: Machine code cleanup
Date: Wed, 23 Apr 2014 17:04:31 +0200
Message-Id: <1398265476-29373-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This serie moves the restart code out of the mach-sunxi directory to
either the watchdog driver or to a new driver in drivers/power/reset.

Since the reset code was pretty much all the code left in the
mach-sunxi directory for all the SoCs but the A31, we also can remove
the whole machine definitions, and use the generic machine.

Thanks,
Maxime

Maxime Ripard (5):
  wdt: sunxi: Move restart code to the watchdog driver
  power: reset: Add Allwinner A31 reset code
  ARM: sunxi: Select restart drivers
  ARM: sunxi: Remove reset code from the platform
  ARM: sunxi: Remove sun4i and sun7i machine definitions

 arch/arm/mach-sunxi/Kconfig        |   4 ++
 arch/arm/mach-sunxi/sunxi.c        | 127 -------------------------------------
 drivers/power/reset/Kconfig        |   7 ++
 drivers/power/reset/Makefile       |   1 +
 drivers/power/reset/sun6i-reboot.c |  85 +++++++++++++++++++++++++
 drivers/watchdog/sunxi_wdt.c       |  33 ++++++++++
 6 files changed, 130 insertions(+), 127 deletions(-)
 create mode 100644 drivers/power/reset/sun6i-reboot.c

-- 
1.9.1

