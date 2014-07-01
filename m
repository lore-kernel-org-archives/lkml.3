Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405AbaGAJgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 05:36:37 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33633 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932219AbaGAJfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 05:35:21 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 00/14] AT91: PIT: Cleanups and move to drivers/clocksource
Date: Tue,  1 Jul 2014 11:33:13 +0200
Message-Id: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This series cleans up the PIT driver in order for it to not depend on
anything in mach-at91 anymore, and in the end move it out of
mach-at91.

Along the way, these patches also do a bit of cleanup.

This has been tested on a G45-EK without DT and an Xplained with DT.

Thanks,
Maxime

Changes from v1:
  - Changed Kconfig option to ATMEL_PIT
  - Used DIV_ROUND_CLOSEST to compute the pit rate

Maxime Ripard (14):
  AT91: PIT: Follow the general coding rules
  AT91: generic.h: Add include safe guards
  AT91: PIT: Use DIV_ROUND_CLOSEST to compute the cycles
  AT91: PIT: Use of_have_populated_dt instead of CONFIG_OF
  AT91: PIT: Rework probe functions
  AT91: dt: Remove init_time definitions
  AT91: PIT: Use consistent exit path in probe
  AT91: PIT: Use pr_fmt
  AT91: PIT: use request_irq instead of setup_irq
  AT91: PIT: (Almost) remove the global variables
  AT91: soc: Add init_time callback
  AT91: Convert the boards to the init_time callback
  AT91: PIT: Convert to an early_platform_device
  AT91: PIT: Move the driver to drivers/clocksource

 arch/arm/mach-at91/Kconfig              |   5 -
 arch/arm/mach-at91/Makefile             |   1 -
 arch/arm/mach-at91/at91sam9260.c        |  34 +++-
 arch/arm/mach-at91/at91sam9261.c        |  34 +++-
 arch/arm/mach-at91/at91sam9263.c        |  34 +++-
 arch/arm/mach-at91/at91sam926x_time.c   | 294 ------------------------------
 arch/arm/mach-at91/at91sam9g45.c        |  35 +++-
 arch/arm/mach-at91/at91sam9rl.c         |  34 +++-
 arch/arm/mach-at91/board-afeb-9260v1.c  |   2 +-
 arch/arm/mach-at91/board-cam60.c        |   2 +-
 arch/arm/mach-at91/board-cpu9krea.c     |   2 +-
 arch/arm/mach-at91/board-dt-sam9.c      |  10 --
 arch/arm/mach-at91/board-dt-sama5.c     |   9 -
 arch/arm/mach-at91/board-flexibity.c    |   2 +-
 arch/arm/mach-at91/board-foxg20.c       |   2 +-
 arch/arm/mach-at91/board-gsia18s.c      |   2 +-
 arch/arm/mach-at91/board-pcontrol-g20.c |   2 +-
 arch/arm/mach-at91/board-sam9-l9260.c   |   2 +-
 arch/arm/mach-at91/board-sam9260ek.c    |   2 +-
 arch/arm/mach-at91/board-sam9261ek.c    |   4 +-
 arch/arm/mach-at91/board-sam9263ek.c    |   2 +-
 arch/arm/mach-at91/board-sam9g20ek.c    |   4 +-
 arch/arm/mach-at91/board-sam9m10g45ek.c |   2 +-
 arch/arm/mach-at91/board-sam9rlek.c     |   2 +-
 arch/arm/mach-at91/board-snapper9260.c  |   2 +-
 arch/arm/mach-at91/board-stamp9g20.c    |   4 +-
 arch/arm/mach-at91/generic.h            |   8 +-
 arch/arm/mach-at91/setup.c              |   5 +
 arch/arm/mach-at91/soc.h                |   1 +
 drivers/clocksource/Kconfig             |   4 +
 drivers/clocksource/Makefile            |   1 +
 drivers/clocksource/timer-atmel-pit.c   | 304 ++++++++++++++++++++++++++++++++
 32 files changed, 506 insertions(+), 345 deletions(-)
 delete mode 100644 arch/arm/mach-at91/at91sam926x_time.c
 create mode 100644 drivers/clocksource/timer-atmel-pit.c

-- 
2.0.0

