Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703Ab3BWCVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 21:21:30 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:55899 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583Ab3BWCV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 21:21:26 -0500
MIME-Version: 1.0
From: Bryan Wu <cooloney@gmail.com>
Date: Fri, 22 Feb 2013 18:21:03 -0800
Message-ID: <CAK5ve-KwbsJGHkrZsM453yCRKT1STYLpckKHV0M0BDYSRjUejw@mail.gmail.com>
Subject: [GIT PULL] LED subsystem update for v3.9
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 88b62b915b0b7e25870eb0604ed9a92ba4bfc9f7:

  Linux 3.8-rc6 (2013-02-01 12:08:14 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git for-next

for you to fetch changes up to 4b07c5d5123f76487c61cf9dc3f987d0b8c88a94:

  leds: leds-sunfire: use dev_err()/pr_err() instead of printk()
(2013-02-06 16:00:43 -0800)

----------------------------------------------------------------
Axel Lin (5):
      leds: pca9532: Convert to devm_input_allocate_device()
      leds: lm3530: Ensure drvdata->enable has correct status if
regulator_disable fails
      leds: renesas-tpu: Improve the readability to pick the lowest
acceptable rate
      leds: tca6507: Use of_get_child_count()
      leds: 88pm860x: Add missing of_node_put()

Jingoo Han (6):
      leds: lm355x: rename devAttr to avoid CamelCase
      leds: lm3642: rename devAttr to avoid CamelCase
      leds: pca9532: fix suspect code indent for conditional statements
      leds: leds-ss4200: use DEFINE_PCI_DEVICE_TABLE
      leds: wm831x: add missing const
      leds: leds-sunfire: use dev_err()/pr_err() instead of printk()

Kim, Milo (1):
      leds-lp8788: fix a parent device in _probe()

Marek Belisko (2):
      leds/tca6507: Add support for devicetree.
      leds/tca6507: DT: Add documentation for tca6507 devicetree bindings.

Milo(Woogyom) Kim (39):
      leds-lp55xx: clean up init_device() in lp5521/5523
      leds-lp55xx: clean up deinit_device() in lp5521/5523
      leds-lp55xx: clean up init leds in lp5521/5523
      leds-lp55xx: clean up deinit leds in lp5521/5523
      leds-lp55xx: add device reset function in lp5521/5523
      leds-lp55xx: do chip specific configuration on device init
      leds-lp55xx: add new common driver for lp5521/5523
      leds-lp55xx: replace name of data structure
      leds-lp55xx: use common lp55xx data structure in _probe()
      leds-lp5521: clean up lp5521_configure()
      leds-lp5523: clean up lp5523_configure()
      leds-lp55xx: use lp55xx common init function - platform data
      leds-lp55xx: use lp55xx common init function - reset
      leds-lp55xx: use lp55xx common init function - detect
      leds-lp55xx: use lp55xx common init function - post int
      leds-lp55xx: clean up init function
      leds-lp55xx: use lp55xx common deinit function
      leds-lp55xx: use lp55xx common led registration function
      leds-lp55xx: use lp55xx_init_led() common function
      leds-lp55xx: use lp55xx_set_brightness()
      leds-lp55xx: provide common LED current setting
      leds-lp55xx: use lp55xx_unregister_leds()
      leds-lp55xx: fix error condition in lp55xx_register_leds()
      leds-lp55xx: add new lp55xx_register_sysfs() for the firmware interface
      leds-lp55xx: support firmware interface
      leds-lp5521: use generic firmware interface
      leds-lp5523: use generic firmware interface
      leds-lp55xx: support device specific attributes
      leds-lp55xx: use common device attribute driver function
      leds-lp55xx: code refactoring on selftest function
      leds-lp55xx: add new function for removing device attribtues
      leds-lp55xx: clean up _remove()
      leds-lp55xx: clean up unused data and functions
      leds-lp55xx: clean up definitions
      leds-lp55xx: clean up headers
      leds-lp5521/5523: use new lp55xx common header
      leds-lp5521/5523: add author and copyright description
      leds-lp55xx: fix problem on removing LED attributes
      Documentation: leds: update LP55xx family devices

Peter Ujfalusi (8):
      leds: leds-pwm: Convert to use devm_get_pwm
      leds: leds-pwm: Preparing the driver for device tree support
      pwm: Correct parameter name in header for *pwm_get() functions
      pwm: core: Rename of_pwm_request() to of_pwm_get() and export it
      pwm: Add devm_of_pwm_get() as exported API for users
      leds: leds-pwm: Simplify cleanup code
      leds: leds-pwm: Add device tree bindings
      leds: leds-pwm: make it depend on PWM and not HAVE_PWM

 .../devicetree/bindings/leds/leds-pwm.txt          |   48 +
 Documentation/devicetree/bindings/leds/tca6507.txt |   33 +
 Documentation/leds/00-INDEX                        |    2 +
 Documentation/leds/leds-lp5521.txt                 |   63 +-
 Documentation/leds/leds-lp5523.txt                 |   27 +-
 Documentation/leds/leds-lp55xx.txt                 |  118 +++
 arch/arm/mach-omap2/board-rx51-peripherals.c       |    8 +-
 arch/arm/mach-ux500/board-mop500.c                 |   14 +-
 drivers/leds/Kconfig                               |   12 +-
 drivers/leds/Makefile                              |    1 +
 drivers/leds/leds-88pm860x.c                       |    5 +-
 drivers/leds/leds-lm3530.c                         |   58 +-
 drivers/leds/leds-lm355x.c                         |    2 +-
 drivers/leds/leds-lm3642.c                         |    4 +-
 drivers/leds/leds-lp5521.c                         |  944 +++++-------------
 drivers/leds/leds-lp5523.c                         | 1050 +++++---------------
 drivers/leds/leds-lp55xx-common.c                  |  523 ++++++++++
 drivers/leds/leds-lp55xx-common.h                  |  134 +++
 drivers/leds/leds-lp8788.c                         |    9 +-
 drivers/leds/leds-pca9532.c                        |    6 +-
 drivers/leds/leds-pwm.c                            |  152 ++-
 drivers/leds/leds-renesas-tpu.c                    |   12 +-
 drivers/leds/leds-ss4200.c                         |    3 +-
 drivers/leds/leds-sunfire.c                        |   19 +-
 drivers/leds/leds-tca6507.c                        |   72 +-
 drivers/leds/leds-wm831x-status.c                  |    2 +-
 drivers/pwm/core.c                                 |   38 +-
 include/linux/leds-lp5521.h                        |   73 --
 include/linux/leds-lp5523.h                        |   49 -
 include/linux/leds_pwm.h                           |    2 +-
 include/linux/platform_data/leds-lp55xx.h          |   87 ++
 include/linux/pwm.h                                |   20 +-
 32 files changed, 1803 insertions(+), 1787 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-pwm.txt
 create mode 100644 Documentation/devicetree/bindings/leds/tca6507.txt
 create mode 100644 Documentation/leds/leds-lp55xx.txt
 create mode 100644 drivers/leds/leds-lp55xx-common.c
 create mode 100644 drivers/leds/leds-lp55xx-common.h
 delete mode 100644 include/linux/leds-lp5521.h
 delete mode 100644 include/linux/leds-lp5523.h
 create mode 100644 include/linux/platform_data/leds-lp55xx.h
