Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab3IKF3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:29:31 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:40180 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab3IKF32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 01:29:28 -0400
Date: Tue, 10 Sep 2013 22:24:45 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] battery-2.6.git
Message-ID: <20130911052445.GA8508@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please pull battery-2.6 git tree to receive changes prepared for the v3.12
release. Here is what we have:

New drivers:

- APM X-Gene system reboot driver by Feng Kan and Loc Ho (APM).

- Qualcomm MSM reboot/poweroff driver by Abhimanyu Kapur (Codeaurora).

- Texas Instruments BQ24190 charger driver by Mark A. Greer (Animal Creek
  Technologies).

- Texas Instruments TWL4030 MADC battery driver by Lukas Märdian and Marek
  Belisko (Golden Delicious Computers). The driver is used on Freerunner
  GTA04 phones.

Highlighted fixes and improvements:

- Suspend/wakeup logic improvements: power supply objects will block
  system suspend until all power supply events are processed. Thanks to
  Zoran Markovic (Linaro), Arve Hjonnevag and Todd Poynor (Google).

Thanks!

Anton


The following changes since commit c095ba7224d8edc71dcef0d655911399a8bd4a3f:

  Linux 3.11-rc4 (2013-08-04 13:46:46 -0700)

are available in the git repository at:

  git://git.infradead.org/battery-2.6.git tags/for-v3.12

for you to fetch changes up to db15e6312efd537e2deb2cbad110c23f98704a3c:

  rx51_battery: Fix channel number when reading adc value (2013-08-30 17:49:15 -0700)

----------------------------------------------------------------
Abhimanyu Kapur (1):
      power: reset: Add msm restart support

Andrea Adami (2):
      power supply: collie_battery: Convert to use dev_pm_ops
      power_supply: tosa_battery: Get rid of irq_to_gpio usage

Anton Vorontsov (1):
      bq24190_charger: Workaround SS definition problem on i386 builds

Dan Carpenter (1):
      ab8500-charger: We print an unintended error message

Jingoo Han (1):
      power_supply: Replace strict_strtol() with kstrtol()

Kevin Hilman (1):
      MAINTAINERS: drivers/power: add entry for SmartReflex AVS drivers

Libo Chen (1):
      max8925_power: Fix missing of_node_put

Loc Ho (1):
      power: Add APM X-Gene system reboot driver

Marek Belisko (3):
      rx51_battery: Replace hardcoded channels values.
      power: Add twl4030_madc battery driver.
      rx51_battery: Fix channel number when reading adc value

Mark A. Greer (1):
      bq24190_charger: Add support for TI BQ24190 Battery Charger

Paul Gortmaker (1):
      power_supply: Make goldfish_battery depend on GOLDFISH || COMPILE_TEST

Pawel Moll (1):
      vexpress-poweroff: Should depend on the required infrastructure

Peter Ujfalusi (1):
      twl4030-charger: Fix compiler warning with regulator_enable()

Zoran Markovic (1):
      power_supply: Prevent suspend until power supply events are processed

 .../bindings/power_supply/msm-poweroff.txt         |   17 +
 MAINTAINERS                                        |    8 +
 drivers/power/Kconfig                              |   15 +-
 drivers/power/Makefile                             |    2 +
 drivers/power/ab8500_charger.c                     |    1 +
 drivers/power/bq24190_charger.c                    | 1549 ++++++++++++++++++++
 drivers/power/collie_battery.c                     |    2 +-
 drivers/power/max8925_power.c                      |    1 +
 drivers/power/power_supply_core.c                  |   38 +-
 drivers/power/power_supply_sysfs.c                 |    2 +-
 drivers/power/reset/Kconfig                        |   15 +-
 drivers/power/reset/Makefile                       |    2 +
 drivers/power/reset/msm-poweroff.c                 |   73 +
 drivers/power/reset/xgene-reboot.c                 |  103 ++
 drivers/power/rx51_battery.c                       |   14 +-
 drivers/power/tosa_battery.c                       |    2 +-
 drivers/power/twl4030_charger.c                    |    7 +-
 drivers/power/twl4030_madc_battery.c               |  245 ++++
 include/linux/power/bq24190_charger.h              |   16 +
 include/linux/power/twl4030_madc_battery.h         |   39 +
 include/linux/power_supply.h                       |    3 +
 21 files changed, 2137 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_supply/msm-poweroff.txt
 create mode 100644 drivers/power/bq24190_charger.c
 create mode 100644 drivers/power/reset/msm-poweroff.c
 create mode 100644 drivers/power/reset/xgene-reboot.c
 create mode 100644 drivers/power/twl4030_madc_battery.c
 create mode 100644 include/linux/power/bq24190_charger.h
 create mode 100644 include/linux/power/twl4030_madc_battery.h
