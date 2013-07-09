Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab3GIBj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 21:39:58 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:65409 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab3GIBj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 21:39:57 -0400
Date: Mon, 8 Jul 2013 18:39:52 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] battery-2.6.git
Message-ID: <20130709013952.GA10069@teo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please pull battery-2.6 git tree to receive changes prepared for the v3.11
release. This time there is nothing exciting in there, just assorted fixes
and cleanups.

Thanks!

Anton


The following changes since commit d683b96b072dc4680fc74964eca77e6a23d1fa6e:

  Linux 3.10-rc4 (2013-06-02 17:11:17 +0900)

are available in the git repository at:

  git://git.infradead.org/battery-2.6.git tags/for-v3.11

for you to fetch changes up to 5a6c2208455f25b3e6f939adc2da59aa00d4806e:

  charger-manager: Fix regulator_get() return check (2013-06-28 18:37:03 -0700)

----------------------------------------------------------------
Andrew Chew (1):
      tps65090-charger: Fix AC detect

Anton Vorontsov (2):
      MAINTAINERS: Update email address for Anton Vorontsov
      power_supply: Move of_node out of the #ifdef CONFIG_OF

Axel Lin (3):
      pm2301_charger: Fix NULL pointer dereference
      pm2301_charger: Return error if create_singlethread_workqueue fails
      generic-adc-battery: Fix checking if none of the channels are supported

Jingoo Han (10):
      88pm860x_battery: Remove unnecessary platform_set_drvdata()
      88pm860x_charger: Remove unnecessary platform_set_drvdata()
      ab8500_bm: Remove unnecessary platform_set_drvdata()
      bq27x00_battery: Remove unnecessary platform_set_drvdata()
      gpio-charger: Remove unnecessary platform_set_drvdata()
      jz4740-battery: Remove unnecessary platform_set_drvdata()
      rx51_battery: Remove unnecessary platform_set_drvdata()
      twl4030_charger: Remove unnecessary platform_set_drvdata()
      power: Use platform_{get,set}_drvdata()
      power_supply: Replace strict_strtoul() with kstrtoul()

Joe Perches (1):
      charger-manager: Add missing newlines, fix a couple of typos, add pr_fmt

Jonghwa Lee (2):
      charger-manager: Fix a bug when it unregisters notifier block of extcon
      charger-manager: Fix regulator_get() return check

Kees Cook (1):
      charger-manager: Ensure event is not used as format string

Kim, Milo (1):
      lp8727_charger: Support the device tree feature

Pawel Moll (1):
      power/reset: Make the vexpress driver optional on arm and arm64

Rhyland Klein (3):
      power_supply: Add of_node_put to fix refcount
      sbs-battery: Add dt to power_supply struct
      tps65090-charger: Add dt node to power_supply

 .../bindings/power_supply/lp8727_charger.txt       |  44 +++++++
 MAINTAINERS                                        |   8 +-
 drivers/power/88pm860x_battery.c                   |   1 -
 drivers/power/88pm860x_charger.c                   |   1 -
 drivers/power/ab8500_btemp.c                       |   1 -
 drivers/power/ab8500_charger.c                     |   2 -
 drivers/power/ab8500_fg.c                          |   7 +-
 drivers/power/abx500_chargalg.c                    |   1 -
 drivers/power/bq27x00_battery.c                    |   2 -
 drivers/power/charger-manager.c                    | 146 +++++++++------------
 drivers/power/generic-adc-battery.c                |   4 +-
 drivers/power/gpio-charger.c                       |   2 -
 drivers/power/intel_mid_battery.c                  |   2 +-
 drivers/power/jz4740-battery.c                     |   4 +-
 drivers/power/lp8727_charger.c                     |  68 ++++++++++
 drivers/power/pcf50633-charger.c                   |   8 +-
 drivers/power/pm2301_charger.c                     |  11 +-
 drivers/power/power_supply_core.c                  |   4 +
 drivers/power/reset/Kconfig                        |   3 +-
 drivers/power/rx51_battery.c                       |   5 +-
 drivers/power/sbs-battery.c                        |   1 +
 drivers/power/tps65090-charger.c                   |  40 +++++-
 drivers/power/twl4030_charger.c                    |   2 -
 include/linux/power_supply.h                       |   4 +-
 24 files changed, 241 insertions(+), 130 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_supply/lp8727_charger.txt
