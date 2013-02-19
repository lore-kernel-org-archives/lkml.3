Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab3BSHNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 02:13:09 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:58830 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab3BSHNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 02:13:06 -0500
Date: Mon, 18 Feb 2013 23:09:19 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] battery-2.6.git
Message-ID: <20130219070918.GA27706@lizard.sbx00618.mountca.wayport.net>
Reply-To: cbouatmailru@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Here is a battery/power_supply queue for v3.9. There are two tags:
for-v3.9 and for-v3.9-merged. The second one is exactly the same as the
first one, except that in the -merged tag I merged v3.8 back into battery
tree to fix some conflicts so that you wouldn't need to do it.

Highlights (included in tag message):

- Four new drivers:

  o goldfish_battery:
    This is Android Emulator battery driver. Originally from Google, but
    Intel folks reshaped it for mainline;

  o pm2301_charger:
    A new driver for ST-Ericsson 2301 Power Management chip, uses AB8500
    battery management core;

  o qnap-poweroff:
    The driver adds poweroff functionality for QNAP NAS boxes;

  o restart-poweroff:
    A generic driver that implements 'power off by restarting'. The actual
    poweroff functionality is implemented through a bootloader, so Linux'
    task is just to restart the box. The driver is useful on Buffalo
    Linkstation LS-XHL and LS-CHLv2 boards. Andrew Lunn worked on
    submitting the driver (as well as qnap-poweroff above).

- A lot of fixes for ab8500 drivers. This is a part of efforts of syncing
  internal ST-Ericsson development tree with the mainline. Lee Jones @
  Linaro worked on compilation and reshaping these series;

- New health properties for the power supplies: "Watchdog timer expire"
  and "Safety timer expire";

- As usual, a bunch of fixes/cleanups here and there.

Please pull.

Thanks!


The following changes since commit 19f949f52599ba7c3f67a5897ac6be14bfcb1200:

  Linux 3.8 (2013-02-18 15:58:34 -0800)

are available in the git repository at:

  git://git.infradead.org/battery-2.6.git tags/for-v3.9-merged

for you to fetch changes up to 845e37e009281b63fe15348f37bd7f815ea65da0:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux (2013-02-18 22:55:13 -0800)

----------------------------------------------------------------
Andrew Lunn (3):
      power/reset: Add a new driver to turn QNAP board power off
      power/reset: Add a new driver implementing 'power off by restarting'
      qnap-poweroff: Fix license string

Anton Vorontsov (4):
      Merge branch 'for-anton' of git://git.linaro.org/people/ljones/linux-3.0-ux500
      Merge branch 'ab8500-from-Rajanikanth'
      Merge branch 'tb-power-2' of git://git.linaro.org/people/ljones/linux-3.0-ux500
      Merge git://git.kernel.org/.../torvalds/linux

Chanwoo Choi (1):
      charger-manager: Split _probe funtion to make the code more clean

Dan Carpenter (2):
      lp8727_charger: Small cleanup in naming
      generic-adc-battery: Fix forever loop in gab_remove()

Devendra Naga (1):
      max17040_battery: Use devm_kzalloc

Evgeny Romanov (1):
      ds2782_battery: Add power_supply_changed() calls for proper uevent support

Hakan Berg (5):
      ab8500_btemp: Ignore false btemp low interrupt
      ab8500_bm: Adds support for Car/Travel Adapters
      ab8500_btemp: Remove superfluous BTEMP thermal comp
      ab8500_fg: Added support for BATT_OVV
      ab8500-fg: Adjust for RF bursts voltage drops

Heiko Carstens (1):
      goldfish_battery: Add missing GENERIC_HARDIRQS dependency

Henrik Sölver (1):
      ab8500-charger: AB workaround for invalid charger

Johan Bjornstedt (2):
      ab8500_charger: Charger current step-up/down
      ab8500_bm: Skip first CCEOC irq for instant current

Jonas Aaberg (5):
      ab8500_btemp: Detect battery type in workqueue
      ab8500_fg: Replace msleep() with usleep_range() for greater accuracy
      ab8500_charger: Handle gpadc errors
      ab8500-bm: Flush all work queues before suspending
      ab8500-charger: Do not touch VBUSOVV bits

Julia Lawall (1):
      88pm860x_battery: Eliminate possible references to released resources

Kalle Komierowski (1):
      ab8500_fg: Don't clear the CCMuxOffset bit

Kim, Milo (4):
      MAINTAINERS: Add LP8727 charger driver entry
      MAINTAINERS: Add LP8788 MFD driver entry
      lp8788-charger: Fix a parent device in _probe()
      lp8788-charger: Fix a parent device in kernel messages

Lee Jones (19):
      ab8500_btemp: Fix crazy tabbing implementation
      ab8500-bmdata: Re-jiggle bmdevs_of_probe to be more succinct
      ab8500_bm: Rename battery management platform data to something more logical
      ab8500_bm: Always send platform specific battery information via pdata
      ab8500_btemp: Reorder obtainment of platform specific battery management data
      ab8500_charger: Reorder obtainment of platform specific battery management data
      ab8500_fg: Reorder obtainment of platform specific battery management data
      abx500_chargalg: Reorder obtainment of platform specific battery management data
      ab8500_bm: Make the battery Device Tree node reference less cryptic
      ab8500_charger: Detect charger removal
      ab8500_btemp: Allign battery temperature resolution with the framework
      ab8500_fg: Remove pointless round_jiffies() call
      ab8500-charger: Kick watchdog
      ab8500-chargalg: Update battery health on safety timer exp
      pm2301: Move all configuration and emum structs out to a header file
      ab8500-chargalg: Only root should have write permission on sysfs file
      abx500-chargalg: Add new sysfs interface to get current charge status
      pm2301: LPN mode control support
      ab8500-bm: Remove individual [charger|btemp|fg|chargalg] pdata structures

Loic Pallardy (2):
      pm2301: Remove volt_now & curr_now properties
      pm2301: Update watchdog for pm2xxx support

Marcus Cooper (3):
      ab8500_bm: Recharge condition not optimal for battery
      ab8500_charger: Remove unused defines
      ab8500_charger: Adds support for legacy USB chargers

Martin Bergström (1):
      ab8500-fg: Go to INIT_RECOVERY when charger removed

Michal Hocko (1):
      da9030_battery: Include notifier.h

Michel JAOUEN (2):
      pm2301: Provide u9540 support for the pm2301 charger
      ab8500-btemp: Adaptation to AB8505 and AB9540 platforms

Mike Lockwood (1):
      power: Add battery driver for goldfish emulator

NeilBrown (1):
      bq27x00_battery: Fix bugs introduced with BQ27425 support

Nickolai Zeldovich (1):
      da9052-battery: Avoid out-of-range array access

Nicolas Guion (1):
      ab8500-charger: Add support for autopower on AB8505 and AB9540

Olivier Clergeaud (1):
      pm2301: Clean-up PM2301 interrupt management

Paer-Olof Haakansson (3):
      ab8500_charger: Rename the power_loss function
      ab8500_fg: Overflow in current calculation
      u8500-charger: Delay for USB enumeration

Pali Rohár (2):
      bq27x00_battery: Fix reporting battery temperature
      bq2415x_charger: Add support for offline and 100mA mode

Rajanikanth H.V (4):
      ab8500: remove explicit handling of battery type
      ab8500: Remove initial "UNKNOWN" battery-type string assignment
      ab8500: Promote ab8500_fg probe before ab8500_btemp probe
      ab8500_btemp: Demote initcall sequence

Rajkumar Kasirajan (2):
      pm2301: Enable vbat low monitoring
      ab8500-fg: Use correct battery charge full design

Ramakrishna Pallala (1):
      power_supply: Add watchdog and safety timer expiries under PROP_HEALTH_*

Rickard Andersson (1):
      ab8500_fg: Balance IRQ enable

Sachin Kamat (4):
      bq2415x_charger: Remove unneeded version.h inclusion
      bq2415x_charger: Use module_i2c_driver
      bq2415x_charger: Use devm_kzalloc()
      ab8500_charger: Use devm_regulator_get API

Tejun Heo (1):
      charger_manager: Don't use [delayed_]work_pending()

Thierry Reding (1):
      power/reset: Remove newly introduced __dev* annotations

pender01 (1):
      ab8500_fg: Round capacity output

 .../bindings/power_supply/qnap-poweroff.txt     |   13 +
 .../bindings/power_supply/restart-poweroff.txt  |    8 +
 MAINTAINERS                                     |   16 +
 drivers/mfd/ab8500-core.c                       |   14 +-
 drivers/power/88pm860x_battery.c                |   13 +-
 drivers/power/Kconfig                           |   14 +
 drivers/power/Makefile                          |    4 +-
 drivers/power/ab8500_bmdata.c                   |  524 ++++----
 drivers/power/ab8500_btemp.c                    |  192 +--
 drivers/power/ab8500_charger.c                  | 1067 ++++++++++++----
 drivers/power/ab8500_fg.c                       |  447 +++++--
 drivers/power/abx500_chargalg.c                 |  204 ++--
 drivers/power/bq2415x_charger.c                 |   54 +-
 drivers/power/bq27x00_battery.c                 |   12 +-
 drivers/power/charger-manager.c                 |  310 +++--
 drivers/power/da9030_battery.c                  |    1 +
 drivers/power/da9052-battery.c                  |    2 +-
 drivers/power/ds2782_battery.c                  |   69 ++
 drivers/power/generic-adc-battery.c             |   16 +-
 drivers/power/goldfish_battery.c                |  236 ++++
 drivers/power/lp8727_charger.c                  |    8 +-
 drivers/power/lp8788-charger.c                  |   17 +-
 drivers/power/max17040_battery.c                |    4 +-
 drivers/power/pm2301_charger.c                  | 1088 +++++++++++++++++
 drivers/power/pm2301_charger.h                  |  513 ++++++++
 drivers/power/power_supply_sysfs.c              |    3 +-
 drivers/power/reset/Kconfig                     |   17 +
 drivers/power/reset/Makefile                    |    2 +
 drivers/power/reset/qnap-poweroff.c             |  116 ++
 drivers/power/reset/restart-poweroff.c          |   65 +
 include/linux/mfd/abx500.h                      |   15 +-
 include/linux/mfd/abx500/ab8500-bm.h            |   26 +-
 include/linux/mfd/abx500/ab8500.h               |   24 +
 include/linux/mfd/abx500/ux500_chargalg.h       |    5 +
 include/linux/pm2301_charger.h                  |   61 +
 include/linux/power/bq2415x_charger.h           |    3 +-
 include/linux/power_supply.h                    |    2 +
 37 files changed, 4197 insertions(+), 988 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_supply/qnap-poweroff.txt
 create mode 100644 Documentation/devicetree/bindings/power_supply/restart-poweroff.txt
 create mode 100644 drivers/power/goldfish_battery.c
 create mode 100644 drivers/power/pm2301_charger.c
 create mode 100644 drivers/power/pm2301_charger.h
 create mode 100644 drivers/power/reset/qnap-poweroff.c
 create mode 100644 drivers/power/reset/restart-poweroff.c
 create mode 100644 include/linux/pm2301_charger.h
