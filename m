Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab3FKNpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 09:45:44 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:35331 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab3FKNpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 09:45:41 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH v3 0/5] Renesas TPU PWM support
Date: Tue, 11 Jun 2013 15:45:39 +0200
Message-Id: <1370958344-19470-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the third version of the Renesas TPU PWM unit support patches. The
patch series deprecates and removes the leds-renesas-tpu driver in favor of a
combination of leds-pwm and pwm-renesas-tpu. As an added bonus patch 4/5
removes function GPIOs support from the sh73a0 platform. mach-shmobile is now
free of function GPIOs. We still need volunteer(s) to migrate arch/sh.

I believe I've addressed most comments received in response to v2, with the
exception of channel allocation at .request() time for which I haven't received
any answer to my questions. That will hopefully not be a showstopper.

I've tested the code on Armadillo only as I don't have access to a kota2
board. This is why I've added backlight support to Armadillo as part of this
set.

The patches are based on Simon's renesas-next-20130611v2 tag. I've pushed them
to

        git://linuxtv.org/pinchartl/fbdev.git pinmux/3.10/tpu

Given the risk of conflicts on arch/arm/mach-shmobile it would probably be
easier to merge the set through Simon's tree. Thierry, would you be fine with
that ?

Changes since v2:

- Dropped SH Mobile arch patches that have already been merged
- Replaced active_low pdata field with pwm_polarity
- Replaced TPU_PWM_ID with pwm_lookup's
- Set the platform_driver .owner field
- Replaced devm_ioremap_nocache() with devm_ioremap_resource()
- Added a .set_polarity() implementation
- Use kernel block comment style
- Don't enable/disable the clock around clk_get_rate()
- Removed duplicate sanity checks in the .config() operation

Changes since v1:

- Renamed the pwm-rmob driver to pwm-renesas-tpu, as TPU units are found in
  Renesas SH-Mobile, R-Mobile and R-Car SoCs.
- Added TPU clock and pin groups for r8a7790.

Laurent Pinchart (5):
  pwm: Add Renesas TPU PWM driver
  ARM: mach-shmobile: armadillo800eva: Add backlight support
  ARM: mach-shmobile: kota2: Use leds-pwm + pwm-rmob
  ARM: shmobile: sh73a0: Remove all GPIOs
  leds: Remove leds-renesas-tpu driver

 arch/arm/mach-shmobile/board-armadillo800eva.c |  55 ++-
 arch/arm/mach-shmobile/board-kota2.c           | 183 ++++++----
 arch/arm/mach-shmobile/clock-sh73a0.c          |   8 +-
 arch/arm/mach-shmobile/include/mach/sh73a0.h   | 373 +------------------
 drivers/leds/Kconfig                           |  12 -
 drivers/leds/Makefile                          |   1 -
 drivers/leds/leds-renesas-tpu.c                | 337 -----------------
 drivers/pwm/Kconfig                            |  10 +
 drivers/pwm/Makefile                           |   1 +
 drivers/pwm/pwm-renesas-tpu.c                  | 485 +++++++++++++++++++++++++
 include/linux/platform_data/leds-renesas-tpu.h |  14 -
 include/linux/platform_data/pwm-renesas-tpu.h  |  17 +
 12 files changed, 681 insertions(+), 815 deletions(-)
 delete mode 100644 drivers/leds/leds-renesas-tpu.c
 create mode 100644 drivers/pwm/pwm-renesas-tpu.c
 delete mode 100644 include/linux/platform_data/leds-renesas-tpu.h
 create mode 100644 include/linux/platform_data/pwm-renesas-tpu.h

-- 
Regards,

Laurent Pinchart

