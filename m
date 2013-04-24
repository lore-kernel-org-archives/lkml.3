Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab3DXUul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 16:50:41 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:45777 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757633Ab3DXUuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 16:50:37 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH v2 00/11] Renesas TPU PWM support
Date: Wed, 24 Apr 2013 22:50:05 +0200
Message-Id: <1366836616-21475-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is the second version of the Renesas TPU PWM unit support patches. The
patch series deprecates and removes the leds-renesas-tpu driver in favor of a
combination of leds-pwm and pwm-rmob. As an added bonus patches 9/11 and 10/11
remove function GPIOs support from the sh73a0 platform. Along with the other
PFC-related patches recently posted on the list, mach-shmobile is now free of
function GPIOs. We still need volunteer(s) to migrate arch/sh.

I've tested the code on Armadillo only as I don't have access to a kota2
board. This is why I've added backlight support to Armadillo as part of this
set.

The patches are based on a merge of "[PATCH 00/37] Fully migrate r8a7740 to
pinctrl", "[PATCH 0/4] sh73a0: Expose the PFC-controller SDHI power gate as a
regulator" and "[PATCH] sh-pfc: r8a7740: Add bias (pull-up/down) pinconf
support". I've pushed them to

	git://linuxtv.org/pinchartl/fbdev.git pinmux/3.9/tpu

Changes compared to v1:

- Renamed the pwm-rmob driver to pwm-renesas-tpu, as TPU units are found in
  Renesas SH-Mobile, R-Mobile and R-Car SoCs.
- Added TPU clock and pin groups for r8a7790.

Laurent Pinchart (11):
  sh-pfc: sh73a0: Add TPU pin groups and functions
  sh-pfc: r8a7740: Add TPU pin groups and functions
  sh-pfc: r8a7790: Add TPU pin groups and functions
  pwm: Add Renesas TPU PWM driver
  ARM: mach-shmobile: clock-r8a7740: add TPU PWM support
  ARM: mach-shmobile: clock-r8a7790: add TPU PWM support
  ARM: mach-shmobile: armadillo800eva: Add backlight support
  ARM: mach-shmobile: kota2: Use leds-pwm + pwm-rmob
  sh-pfc: sh73a0: Remove function GPIOs
  ARM: shmobile: sh73a0: Remove all GPIOs
  leds: Remove leds-renesas-tpu driver

 arch/arm/mach-shmobile/board-armadillo800eva.c |  51 ++-
 arch/arm/mach-shmobile/board-kota2.c           | 178 +++++---
 arch/arm/mach-shmobile/clock-r8a7740.c         |   4 +-
 arch/arm/mach-shmobile/clock-r8a7790.c         |  11 +-
 arch/arm/mach-shmobile/clock-sh73a0.c          |   8 +-
 arch/arm/mach-shmobile/include/mach/sh73a0.h   | 373 +--------------
 drivers/leds/Kconfig                           |  12 -
 drivers/leds/Makefile                          |   1 -
 drivers/leds/leds-renesas-tpu.c                | 336 --------------
 drivers/pinctrl/sh-pfc/pfc-r8a7740.c           |  50 ++
 drivers/pinctrl/sh-pfc/pfc-r8a7790.c           |  41 ++
 drivers/pinctrl/sh-pfc/pfc-sh73a0.c            | 608 +++++++++----------------
 drivers/pwm/Kconfig                            |   7 +
 drivers/pwm/Makefile                           |   1 +
 drivers/pwm/pwm-renesas-tpu.c                  | 462 +++++++++++++++++++
 include/linux/platform_data/leds-renesas-tpu.h |  14 -
 include/linux/platform_data/pwm-renesas-tpu.h  |  18 +
 17 files changed, 963 insertions(+), 1212 deletions(-)
 delete mode 100644 drivers/leds/leds-renesas-tpu.c
 create mode 100644 drivers/pwm/pwm-renesas-tpu.c
 delete mode 100644 include/linux/platform_data/leds-renesas-tpu.h
 create mode 100644 include/linux/platform_data/pwm-renesas-tpu.h

-- 
Regards,

Laurent Pinchart

