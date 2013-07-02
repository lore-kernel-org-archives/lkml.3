Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab3GBXJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 19:09:11 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:59149 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab3GBXJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 19:09:09 -0400
MIME-Version: 1.0
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 2 Jul 2013 16:08:47 -0700
Message-ID: <CAK5ve-Kyvscow4FJk1wcVypwEaJTo-rPaTrbBc_mXkyOB6aj5A@mail.gmail.com>
Subject: [GIT PULL] leds: updates for 3.11
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

LED subsystem updates for 3.11:
 - lp55xx device tree updates
 - mc13xxx driver updates
 - some clean up

So please consider the following changes since commit
7d132055814ef17a6c7b69f342244c410a5e000f:

  Linux 3.10-rc6 (2013-06-15 11:51:07 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git for-next

for you to fetch changes up to cf3b1c2ba362ecea5b8e07d370233e25f3d6366d:

  leds: mc13783: Fix "uninitialized variable" warning (2013-07-02
08:44:02 -0700)

----------------------------------------------------------------
Alexander Shiyan (3):
      leds: leds-mc13783: Prepare driver to support MC13892 LEDs
      leds: leds-mc13783: Add MC13892 LED support
      leds: mc13783: Fix "uninitialized variable" warning

Axel Lin (3):
      leds: lp5521: Properly setup of_device_id table
      leds: lp5523: Properly setup of_device_id table
      leds: lp5562: Properly setup of_device_id table

Dan Carpenter (1):
      leds: renesas-tpu: cleanup a small type issue

Fabio Estevam (1):
      leds: leds-gpio: Let device core handle pinctrl

Jingoo Han (5):
      leds: atmel-pwm: remove unnecessary platform_set_drvdata()
      leds: leds-gpio: remove unnecessary platform_set_drvdata()
      leds: leds-mc13783: remove unnecessary platform_set_drvdata()
      leds: leds-ns2: remove unnecessary platform_set_drvdata()
      leds: use platform_{get,set}_drvdata()

Kim, Milo (2):
      leds: lp55xx: support dynamic channel settings in the device
tree structure
      leds: lp5562: support the device tree feature

Linus Walleij (1):
      leds: lp55xx: add support for Device Tree bindings

Shuah Khan (1):
      leds: Convert led class driver from legacy pm ops to dev_pm_ops

 .../devicetree/bindings/leds/leds-lp55xx.txt       | 147 +++++++
 arch/arm/mach-imx/mach-mx31moboard.c               |   9 +-
 drivers/leds/Kconfig                               |   6 +-
 drivers/leds/led-class.c                           |  10 +-
 drivers/leds/leds-88pm860x.c                       |   2 +-
 drivers/leds/leds-atmel-pwm.c                      |   1 -
 drivers/leds/leds-gpio.c                           |   8 -
 drivers/leds/leds-lp5521.c                         |  28 +-
 drivers/leds/leds-lp5523.c                         |  28 +-
 drivers/leds/leds-lp5562.c                         |  28 +-
 drivers/leds/leds-lp55xx-common.c                  |  45 ++
 drivers/leds/leds-lp55xx-common.h                  |   4 +
 drivers/leds/leds-mc13783.c                        | 467 ++++++++++-----------
 drivers/leds/leds-ns2.c                            |   2 -
 drivers/leds/leds-renesas-tpu.c                    |   8 +-
 drivers/leds/leds-sunfire.c                        |   4 +-
 drivers/leds/leds-wm831x-status.c                  |   2 +-
 include/linux/mfd/mc13xxx.h                        | 100 ++---
 18 files changed, 553 insertions(+), 346 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-lp55xx.txt
