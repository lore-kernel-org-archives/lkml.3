Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbaLIVYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:24:13 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:54806 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbaLIVYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:24:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 2/9] ARM: SoC cleanup on mach-at91 for 3.19
Date: Tue, 09 Dec 2014 22:23:54 +0100
Message-ID: <7004548.0btfAVyUzv@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <4491193.a6KEQb1tZH@wuerfel>
References: <4491193.a6KEQb1tZH@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:tAWmbLPnoXo7ZcMvWw4K2ZoyAnMVKMjWthLZqUwQ00u/rpTOHRo
 KA3L3qAhG81sOgb5iYPVIYTbhYDuLUUv4fjl1Og/ErYqFMdfEKtZNqfjXAs/syv/quhDQb+
 OEPG671R7f5lxiM5Q75+6K2x2557+ECyAMBaEQP25Mxtxe+bKYgdn5VB6fwL96Rg2i/YiN0
 57KZ4CxItezzs6/rUVHVQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit cac7f2429872d3733dc3f9915857b1691da2eb2f:

  Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/at91-cleanup-for-linus

for you to fetch changes up to ba62a8593d15f3f353acdc8ab32c18dd40a275bb:

  ARM: at91: remove unused board.h file (2014-12-03 14:16:07 +0100)

----------------------------------------------------------------
ARM: SoC cleanup on mach-at91 for 3.19

On Atmel AT91, the conversion to device tree is now considered complete,
and all machines that were not already converted in 3.18 are assumed to
be unused and dropped by the maintainer.

All remaining board files that were written in C are dropped, and the
ancient at91x40 sub-platform (based on an MMU-less ARM7) is removed
altogether.  Cleaning up the last pieces was great fun, so I took the
time to do some of the coding myself and removed several hundred code
lines that ended up unused after the board files were done.

There are still a couple of AT91 specific device drivers that are not
converted to DT (CF, USB-OTG) and currently not working, and the platform
itself is not "multiplatform"-enabled, but both issues are going to be
taken care of in the 3.20 cycle.

This is split out from the other cleanups purely based on the size
of the branch.

----------------------------------------------------------------
Alexandre Belloni (2):
      ARM: at91: remove CONFIG_MACH_SAMA5_DT
      ARM: at91: move sdramc/ddrsdr header to include/soc/at91

Arnd Bergmann (6):
      ARM: at91/Kconfig: select board files automatically
      ARM: at91: cleanup initilisation code by removing dead code
      ARM: at91: remove old AT91-specific drivers
      ARM: at91: at91rm9200 ST initialization is now DT only
      ARM: at91/clocksource: remove !DT PIT initializations
      ARM: at91: remove unused board.h file

Boris Brezillon (1):
      ARM: at91: remove useless init_time for DT-only SoCs

Nicolas Ferre (23):
      ARM: at91: remove no-MMU at91x40 support
      ARM: at91: remove at91sam9g45/9m10 legacy board support
      ARM: at91: remove at91sam9rl legacy board support
      ARM: at91: remove unused CONFIG_ARCH_AT91SAM9G45 option
      ARM: at91/at91sam9g45: remove useless header file
      ARM: at91: remove at91sam9263 legacy board support
      ARM: at91: remove at91sam9260/at91sam9g20 legacy boards files
      ARM: at91: remove at91sam9260/at91sam9g20 legacy board support
      ARM: at91/Kconfig: remove unused config options
      ARM: at91: remove at91sam9261/at91sam9g10 legacy board support
      ARM: at91/Kconfig: remove useless fbdev Kconfig options
      ARM: at91: remove at91rm9200 legacy boards files
      ARM: at91: remove at91rm9200 legacy board support
      ARM: at91: switch configuration option to SOC_AT91RM9200
      ARM: at91/Kconfig: remove ARCH_AT91RM9200 option for drivers
      ARM: at91: always USE_OF from now on
      ARM: at91/trivial: update Kconfig comment to mention SAMA5
      ARM: at91: remove all !DT related configuration options
      ARM: at91: remove clock data in at91sam9n12.c and at91sam9x5.c files
      ARM: at91: remove old at91-specific clock driver
      ARM: at91: remove legacy IRQ driver and related code
      ARM: at91: remove unused IRQ function declarations
      ARM: at91: remove unneeded header files

Olof Johansson (1):
      ARM: at91: fix build breakage due to legacy board removals

 MAINTAINERS                                        |    1 +
 arch/arm/Kconfig                                   |    5 +-
 arch/arm/configs/at91rm9200_defconfig              |  161 --
 arch/arm/configs/at91sam9260_9g20_defconfig        |  145 --
 arch/arm/configs/at91sam9261_9g10_defconfig        |  147 --
 arch/arm/configs/at91sam9263_defconfig             |  151 --
 arch/arm/configs/at91sam9g45_defconfig             |  175 --
 arch/arm/configs/at91sam9rl_defconfig              |   92 -
 arch/arm/configs/at91x40_defconfig                 |   48 -
 arch/arm/configs/sama5_defconfig                   |    1 -
 arch/arm/mach-at91/Kconfig                         |   72 +-
 arch/arm/mach-at91/Kconfig.non_dt                  |  344 ----
 arch/arm/mach-at91/Makefile                        |   67 +-
 arch/arm/mach-at91/Makefile.boot                   |    6 -
 arch/arm/mach-at91/at91_aic.h                      |   99 -
 arch/arm/mach-at91/at91_tc.h                       |  146 --
 arch/arm/mach-at91/at91rm9200.c                    |  341 ----
 arch/arm/mach-at91/at91rm9200_devices.c            | 1212 -------------
 arch/arm/mach-at91/at91rm9200_time.c               |   23 -
 arch/arm/mach-at91/at91sam9260.c                   |  397 ----
 arch/arm/mach-at91/at91sam9260_devices.c           | 1364 --------------
 arch/arm/mach-at91/at91sam9261.c                   |  375 ----
 arch/arm/mach-at91/at91sam9261_devices.c           | 1098 -----------
 arch/arm/mach-at91/at91sam9263.c                   |  399 ----
 arch/arm/mach-at91/at91sam9263_devices.c           | 1538 ----------------
 arch/arm/mach-at91/at91sam9g45.c                   |  455 -----
 arch/arm/mach-at91/at91sam9g45_devices.c           | 1915 --------------------
 arch/arm/mach-at91/at91sam9n12.c                   |  213 +--
 arch/arm/mach-at91/at91sam9rl.c                    |  377 ----
 arch/arm/mach-at91/at91sam9rl_devices.c            | 1260 -------------
 arch/arm/mach-at91/at91sam9x5.c                    |  311 +---
 arch/arm/mach-at91/at91x40.c                       |   93 -
 arch/arm/mach-at91/at91x40_time.c                  |   85 -
 arch/arm/mach-at91/board-1arm.c                    |   99 -
 arch/arm/mach-at91/board-afeb-9260v1.c             |  223 ---
 arch/arm/mach-at91/board-cam60.c                   |  199 --
 arch/arm/mach-at91/board-carmeva.c                 |  167 --
 arch/arm/mach-at91/board-cpu9krea.c                |  386 ----
 arch/arm/mach-at91/board-cpuat91.c                 |  189 --
 arch/arm/mach-at91/board-csb337.c                  |  260 ---
 arch/arm/mach-at91/board-csb637.c                  |  142 --
 arch/arm/mach-at91/board-dt-rm9200.c               |    3 -
 arch/arm/mach-at91/board-dt-sam9.c                 |    2 -
 arch/arm/mach-at91/board-dt-sama5.c                |    1 -
 arch/arm/mach-at91/board-eb01.c                    |   52 -
 arch/arm/mach-at91/board-eb9200.c                  |  126 --
 arch/arm/mach-at91/board-ecbat91.c                 |  191 --
 arch/arm/mach-at91/board-eco920.c                  |  160 --
 arch/arm/mach-at91/board-flexibity.c               |  171 --
 arch/arm/mach-at91/board-gsia18s.c                 |  585 ------
 arch/arm/mach-at91/board-kafa.c                    |  113 --
 arch/arm/mach-at91/board-kb9202.c                  |  159 --
 arch/arm/mach-at91/board-pcontrol-g20.c            |  228 ---
 arch/arm/mach-at91/board-picotux200.c              |  129 --
 arch/arm/mach-at91/board-rm9200ek.c                |  196 --
 arch/arm/mach-at91/board-sam9-l9260.c              |  230 ---
 arch/arm/mach-at91/board-sam9260ek.c               |  354 ----
 arch/arm/mach-at91/board-sam9261ek.c               |  623 -------
 arch/arm/mach-at91/board-sam9263ek.c               |  493 -----
 arch/arm/mach-at91/board-sam9g20ek.c               |  429 -----
 arch/arm/mach-at91/board-sam9m10g45ek.c            |  527 ------
 arch/arm/mach-at91/board-sam9rlek.c                |  333 ----
 arch/arm/mach-at91/board-snapper9260.c             |  191 --
 arch/arm/mach-at91/board-stamp9g20.c               |  294 ---
 arch/arm/mach-at91/board-yl-9200.c                 |  597 ------
 arch/arm/mach-at91/board.h                         |  127 --
 arch/arm/mach-at91/clock.c                         |  977 ----------
 arch/arm/mach-at91/clock.h                         |   49 -
 arch/arm/mach-at91/generic.h                       |   53 -
 arch/arm/mach-at91/gpio.c                          |  982 ----------
 arch/arm/mach-at91/gpio.h                          |  214 ---
 arch/arm/mach-at91/gsia18s.h                       |   33 -
 arch/arm/mach-at91/include/mach/at91_dbgu.h        |    3 -
 arch/arm/mach-at91/include/mach/at91_ramc.h        |    6 +-
 arch/arm/mach-at91/include/mach/at91x40.h          |   60 -
 arch/arm/mach-at91/include/mach/cpu.h              |    1 -
 arch/arm/mach-at91/include/mach/hardware.h         |   10 -
 arch/arm/mach-at91/include/mach/uncompress.h       |    7 -
 arch/arm/mach-at91/irq.c                           |  296 ---
 arch/arm/mach-at91/leds.c                          |   56 -
 arch/arm/mach-at91/pm.c                            |   33 +-
 arch/arm/mach-at91/pm.h                            |    1 -
 arch/arm/mach-at91/setup.c                         |   67 -
 arch/arm/mach-at91/soc.h                           |    6 -
 arch/arm/mach-at91/stamp9g20.h                     |    7 -
 drivers/clocksource/timer-atmel-pit.c              |   32 -
 drivers/misc/Kconfig                               |    2 +-
 drivers/net/ethernet/cadence/Kconfig               |    2 +-
 drivers/power/reset/at91-reset.c                   |    4 +-
 drivers/rtc/Kconfig                                |    6 +-
 drivers/video/backlight/Kconfig                    |    1 -
 drivers/video/fbdev/Kconfig                        |   17 -
 drivers/watchdog/Kconfig                           |    4 +-
 .../mach => include/soc/at91}/at91rm9200_sdramc.h  |    0
 .../mach => include/soc/at91}/at91sam9_ddrsdr.h    |    0
 .../mach => include/soc/at91}/at91sam9_sdramc.h    |    0
 96 files changed, 34 insertions(+), 23990 deletions(-)
 delete mode 100644 arch/arm/configs/at91rm9200_defconfig
 delete mode 100644 arch/arm/configs/at91sam9260_9g20_defconfig
 delete mode 100644 arch/arm/configs/at91sam9261_9g10_defconfig
 delete mode 100644 arch/arm/configs/at91sam9263_defconfig
 delete mode 100644 arch/arm/configs/at91sam9g45_defconfig
 delete mode 100644 arch/arm/configs/at91sam9rl_defconfig
 delete mode 100644 arch/arm/configs/at91x40_defconfig
 delete mode 100644 arch/arm/mach-at91/Kconfig.non_dt
 delete mode 100644 arch/arm/mach-at91/at91_aic.h
 delete mode 100644 arch/arm/mach-at91/at91_tc.h
 delete mode 100644 arch/arm/mach-at91/at91rm9200_devices.c
 delete mode 100644 arch/arm/mach-at91/at91sam9260_devices.c
 delete mode 100644 arch/arm/mach-at91/at91sam9261_devices.c
 delete mode 100644 arch/arm/mach-at91/at91sam9263_devices.c
 delete mode 100644 arch/arm/mach-at91/at91sam9g45_devices.c
 delete mode 100644 arch/arm/mach-at91/at91sam9rl_devices.c
 delete mode 100644 arch/arm/mach-at91/at91x40.c
 delete mode 100644 arch/arm/mach-at91/at91x40_time.c
 delete mode 100644 arch/arm/mach-at91/board-1arm.c
 delete mode 100644 arch/arm/mach-at91/board-afeb-9260v1.c
 delete mode 100644 arch/arm/mach-at91/board-cam60.c
 delete mode 100644 arch/arm/mach-at91/board-carmeva.c
 delete mode 100644 arch/arm/mach-at91/board-cpu9krea.c
 delete mode 100644 arch/arm/mach-at91/board-cpuat91.c
 delete mode 100644 arch/arm/mach-at91/board-csb337.c
 delete mode 100644 arch/arm/mach-at91/board-csb637.c
 delete mode 100644 arch/arm/mach-at91/board-eb01.c
 delete mode 100644 arch/arm/mach-at91/board-eb9200.c
 delete mode 100644 arch/arm/mach-at91/board-ecbat91.c
 delete mode 100644 arch/arm/mach-at91/board-eco920.c
 delete mode 100644 arch/arm/mach-at91/board-flexibity.c
 delete mode 100644 arch/arm/mach-at91/board-gsia18s.c
 delete mode 100644 arch/arm/mach-at91/board-kafa.c
 delete mode 100644 arch/arm/mach-at91/board-kb9202.c
 delete mode 100644 arch/arm/mach-at91/board-pcontrol-g20.c
 delete mode 100644 arch/arm/mach-at91/board-picotux200.c
 delete mode 100644 arch/arm/mach-at91/board-rm9200ek.c
 delete mode 100644 arch/arm/mach-at91/board-sam9-l9260.c
 delete mode 100644 arch/arm/mach-at91/board-sam9260ek.c
 delete mode 100644 arch/arm/mach-at91/board-sam9261ek.c
 delete mode 100644 arch/arm/mach-at91/board-sam9263ek.c
 delete mode 100644 arch/arm/mach-at91/board-sam9g20ek.c
 delete mode 100644 arch/arm/mach-at91/board-sam9m10g45ek.c
 delete mode 100644 arch/arm/mach-at91/board-sam9rlek.c
 delete mode 100644 arch/arm/mach-at91/board-snapper9260.c
 delete mode 100644 arch/arm/mach-at91/board-stamp9g20.c
 delete mode 100644 arch/arm/mach-at91/board-yl-9200.c
 delete mode 100644 arch/arm/mach-at91/board.h
 delete mode 100644 arch/arm/mach-at91/clock.c
 delete mode 100644 arch/arm/mach-at91/clock.h
 delete mode 100644 arch/arm/mach-at91/gpio.c
 delete mode 100644 arch/arm/mach-at91/gpio.h
 delete mode 100644 arch/arm/mach-at91/gsia18s.h
 delete mode 100644 arch/arm/mach-at91/include/mach/at91x40.h
 delete mode 100644 arch/arm/mach-at91/irq.c
 delete mode 100644 arch/arm/mach-at91/leds.c
 delete mode 100644 arch/arm/mach-at91/stamp9g20.h
 rename {arch/arm/mach-at91/include/mach => include/soc/at91}/at91rm9200_sdramc.h (100%)
 rename {arch/arm/mach-at91/include/mach => include/soc/at91}/at91sam9_ddrsdr.h (100%)
 rename {arch/arm/mach-at91/include/mach => include/soc/at91}/at91sam9_sdramc.h (100%)

