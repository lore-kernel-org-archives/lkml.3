Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab3KRCI6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 21:08:58 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:51946 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab3KRCIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 21:08:51 -0500
Date: Sun, 17 Nov 2013 18:08:47 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] battery-2.6.git
Message-ID: <20131118020847.GA13578@teo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please pull battery-2.6 git tree to receive changes prepared for the v3.13
release. Highlights:

- A new driver for TI BQ24735 Battery Chargers, courtesy of NVidia.

- Device tree bindings for TWL4030 chips.

- Random fixes and cleanups.

Thank you,

Anton


The following changes since commit 61e6cfa80de5760bbe406f4e815b7739205754d2:

  Linux 3.12-rc5 (2013-10-13 15:41:28 -0700)

are available in the git repository at:

  git://git.infradead.org/battery-2.6.git tags/for-v3.13

for you to fetch changes up to c8024234c20eaf7b163cc4dbd963cb9cd03a4ff1:

  pm2301-charger: Remove unneeded NULL checks (2013-11-12 22:36:34 -0800)

----------------------------------------------------------------
Alexandre Belloni (1):
      bq2415x_charger: Fix max battery regulation voltage

Anton Vorontsov (1):
      power_supply: Fix documentation for TEMP_*ALERT* properties

Dan Carpenter (1):
      pm2301-charger: Remove unneeded NULL checks

Darbha Sriharsha (1):
      power_supply: Add support for bq24735 charger

Jonghwa Lee (2):
      charger-manager : Replace kzalloc to devm_kzalloc and remove uneccessary code
      max17042_battery: Support regmap to access device's registers

Manish Badarkhe (2):
      tps65090-charger: Use "IS_ENABLED(CONFIG_OF)" for DT code
      max17042_battery: Use SIMPLE_DEV_PM_OPS

NeilBrown (1):
      twl4030_charger: Add devicetree support

Pali Rohár (1):
      isp1704_charger: Fix driver to work with changes introduced in v3.5

Sachin Kamat (4):
      ab8500-charger: Check return value of regulator_enable
      ab8500-charger: Remove redundant break
      pm2301-charger: Check return value of regulator_enable
      pm2301-charger: Staticize pm2xxx_charger_die_therm_mngt

Wei Yongjun (1):
      tps65090-charger: Drop devm_free_irq of devm_ allocated irq

 .../devicetree/bindings/power/twl-charger.txt      |  20 +
 .../bindings/power_supply/ti,bq24735.txt           |  32 ++
 Documentation/power/power_supply_class.txt         |   8 +-
 arch/arm/boot/dts/twl4030.dtsi                     |   6 +
 drivers/power/Kconfig                              |   6 +
 drivers/power/Makefile                             |   1 +
 drivers/power/ab8500_charger.c                     |  17 +-
 drivers/power/bq2415x_charger.c                    |   6 +-
 drivers/power/bq24735-charger.c                    | 419 +++++++++++++++++++++
 drivers/power/charger-manager.c                    |  85 ++---
 drivers/power/isp1704_charger.c                    |  91 ++---
 drivers/power/max17042_battery.c                   | 373 +++++++++---------
 drivers/power/pm2301_charger.c                     |  27 +-
 drivers/power/tps65090-charger.c                   |  30 +-
 drivers/power/twl4030_charger.c                    |  47 ++-
 include/linux/power/bq24735-charger.h              |  39 ++
 16 files changed, 852 insertions(+), 355 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/twl-charger.txt
 create mode 100644 Documentation/devicetree/bindings/power_supply/ti,bq24735.txt
 create mode 100644 drivers/power/bq24735-charger.c
 create mode 100644 include/linux/power/bq24735-charger.h
