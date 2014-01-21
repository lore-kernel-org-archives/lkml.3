Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbaAURy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 12:54:28 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:53140 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360AbaAURyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 12:54:25 -0500
Date: Tue, 21 Jan 2014 21:54:20 +0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>
Subject: [GIT PULL] battery-2.6.git
Message-ID: <20140121175420.GA16802@anuminas.rup.mentorg.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

I'm picking up power supply maintainership from Anton Vorontov. Could
you please pull battery-2.6 git tree changes prepared for the v3.14
release.

The following changes since commit 93353e8088057dd988362e6cae727af43734b494:

  max17042_battery: Fix build errors caused by missing REGMAP_I2C config (2013-12-01 14:25:03 -0800)

are available in the git repository at:

  git://git.infradead.org/battery-2.6.git tags/for-v3.14

for you to fetch changes up to 573189354b7c97cd2256b87cf083ee435584594e:

  MAINTAINERS: Pick up power supply maintainership (2014-01-21 03:33:09 +0400)

----------------------------------------------------------------
Highlights:

- Power supply notifier

- Several drivers gained DT support

- Added Maxim 14577 driver

- Change of maintainer

----------------------------------------------------------------
Anton Vorontsov (1):
      charger-manager: of_cm_parse_desc() should be static

Dmitry Eremin-Solenikov (2):
      gpio-charger: Support wakeup events
      MAINTAINERS: Pick up power supply maintainership

Jonghwa Lee (3):
      charger-manager: Modify the way of checking battery's temperature
      charger-manager: Support deivce tree in charger manager driver
      max17042_battery: Add IRQF_ONESHOT flag to use default irq handler

Krzysztof Kozlowski (1):
      power_supply: Add charger support for Maxim 14577

Laxman Dewangan (2):
      mfd: AS3722: Add dt node properties for system power controller
      power: reset: Add as3722 power-off driver

Pali Rohár (2):
      power_supply: Add power_supply notifier
      bq2415x_charger: Use power_supply notifier for automode

Sebastian Reichel (4):
      power_supply: Add power_supply_get_by_phandle
      bq2415x_charger: Add DT support
      isp1704_charger: Add DT support
      dt: Binding documentation for isp1704 charger

 Documentation/devicetree/bindings/mfd/as3722.txt   |  11 +
 .../devicetree/bindings/power/isp1704.txt          |  17 ++
 .../bindings/power_supply/charger-manager.txt      |  81 ++++++
 MAINTAINERS                                        |   2 +-
 drivers/power/Kconfig                              |   7 +
 drivers/power/Makefile                             |   1 +
 drivers/power/bq2415x_charger.c                    | 121 ++++++--
 drivers/power/charger-manager.c                    | 299 +++++++++++++++++---
 drivers/power/gpio-charger.c                       |  19 +-
 drivers/power/isp1704_charger.c                    |  54 +++-
 drivers/power/max14577_charger.c                   | 311 +++++++++++++++++++++
 drivers/power/max17042_battery.c                   |   6 +-
 drivers/power/power_supply_core.c                  |  44 +++
 drivers/power/reset/Kconfig                        |   6 +
 drivers/power/reset/Makefile                       |   1 +
 drivers/power/reset/as3722-poweroff.c              |  96 +++++++
 include/linux/power/bq2415x_charger.h              |  48 +---
 include/linux/power/charger-manager.h              |  34 ++-
 include/linux/power/isp1704_charger.h              |   1 +
 include/linux/power_supply.h                       |  16 ++
 20 files changed, 1043 insertions(+), 132 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/isp1704.txt
 create mode 100644 Documentation/devicetree/bindings/power_supply/charger-manager.txt
 create mode 100644 drivers/power/max14577_charger.c
 create mode 100644 drivers/power/reset/as3722-poweroff.c
