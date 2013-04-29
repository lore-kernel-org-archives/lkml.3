Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808Ab3D2MqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 08:46:18 -0400
Received: from mail-ia0-f179.google.com ([209.85.210.179]:58886 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956Ab3D2MqQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 08:46:16 -0400
MIME-Version: 1.0
Date: Mon, 29 Apr 2013 14:46:15 +0200
Message-ID: <CACRpkda24BTJ5i5sqGP5F90pd26n0QvAo0y+O6J-3i=AeCzGpg@mail.gmail.com>
Subject: [GIT PULL] pinctrl bulk changes for v3.10
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is the bulk of pin control changes for v3.10. Most of the description
is in the tag. I merged in v3.9-rc5 at one point to get the fixes in so I had
a testable baseline, I guess that is normal.

Please pull it in!

Yours,
Linus Walleij


The following changes since commit 07961ac7c0ee8b546658717034fe692fd12eefa9:

  Linux 3.9-rc5 (2013-03-31 15:12:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-for-v3.10

for you to fetch changes up to 42fed7ba44e4e8c1fb27b28ad14490cb1daff3c7:

  pinctrl: move subsystem mutex to pinctrl_dev struct (2013-04-26
17:01:35 +0200)

----------------------------------------------------------------
These are the pinctrl changes for v3.10:
- Patrice Chotard contributed a new configuration debugfs interface
  and reintroduced fine-grained locking into the core: instead of
  having a "big pinctrl lock" we have a per-controller lock and
  specialized locks for the global controller and pinctrl handle
  lists.
- Haoijan Zhuang deleted all the PXA and MMP2 pinctrl drivers and
  replaced them with pinctrl-single (which is also used by other SoCs)
  so we are gaining consolidation. The platform particulars now come
  in through the device tree.
- Haoijan also added support for generic pin config into the
  pinctrl-single driver which is another big consolidation win.
- Finally also GPIO ranges are now supported by the pinctrl-single
  driver.
- Tomasz Figa contributed a new Samsung S3C pinctrl driver, bringing
  more of the older Samsung platforms under the pinctrl umbrella and
  out of arch/arm.
- Maxime Ripard contributed new Allwinner A10/A13 drivers.
- Sachin Kamat, Wei Yongjun and Axel Lin did a lot of cleanups.

----------------------------------------------------------------
Axel Lin (4):
      pinctrl: abx500: Add terminating entry for of_device_id table
      pinctrl: single: Fix build error
      gpio: pl061: Add pl061_gpio_free()
      pinctrl: coh901: Fix error checking in u300_gpio_to_irq

David Woodhouse (1):
      pinctrl: mvebu: prevent walking off the end of group array

Emilio López (1):
      pinctrl: sunxi: add clock support

Gabriel Fernandez (1):
      pinctrl/nomadik: add device tree bindings for db8540

Haojian Zhuang (12):
      gpio: add gpio offset in gpio range cells property
      gpio: pl061: support irqdomain
      pinctrl: check pinctrl ready for gpio range
      gpio: pl061: bind pinctrl by gpio request
      pinctrl: single: create new gpio function range
      pinctrl: generic: dump pin configuration
      pinctrl: single: set function mask as optional
      pinctrl: single: support generic pinconf
      document: devicetree: bind pinconf with pin single
      pinctrl: single: correct argument for pinconf
      pinctrl: remove pxa pinctrl driver
      pinctrl: core: add dependence of GPIOLIB

Jingoo Han (1):
      pinctrl: core: use devres_release() instead of devres_destroy()

Lad, Prabhakar (1):
      pinctrl: pinctrl-single: add missing double quote

Laurent Meunier (2):
      pinctrl/pinconfig: add debug interface
      pinctrl/pinconfig: fix misplaced goto

Laurent Pinchart (1):
      pinctrl: Declare operation structures as const

Linus Walleij (3):
      pinctrl: document the "GPIO mode" pitfall
      pinctrl/pinconf: partial revert of pin config debugfs
      Merge tag 'v3.9-rc5' into devel

Maxime Ripard (3):
      pinctrl: sunxi: Add Allwinner A10 pin functions
      pinctrl: sunxi: Add Allwinner A13 pin functions
      pinctrl: sunxi: Rename wemac functions to emac

Patrice CHOTARD (1):
      pinctrl: abx500: fix issue when no pdata

Patrice Chotard (3):
      pinctrl/abx500: fix ab8505 alternate function
      pinctrl/abx500: fix ab9540 alternate function
      pinctrl: move subsystem mutex to pinctrl_dev struct

Richard Genoud (9):
      pinctrl: fix typo in header
      pinctrl: create pinctrl_free_setting function
      pinctrl: disable and free setting in select_state in case of error
      pinctrl: re-enable old state in case of error in pinctrl_select_state
      pinctrl: use dev_info instead of pr_info in pinctrl_select_state_locked
      pinctrl: remove superfluous optimization in pinctrl_select_state_locked
      pinctrl: pinctrl_select_state: set the old_state back on error
      pinctrl: select_state: don't call pinctrl_free_setting on error
      pinctrl: simplify the re-enable old state code in pinctrl_select_state

Sachin Kamat (13):
      pinctrl: pinctrl-nomadik-stn8815: Fix checkpatch error
      pinctrl/nomadik-db8500: Fix checkpatch errors
      pinctrl/nomadik: Fix checkpatch errors
      pinctrl: at91: Remove duplicate const
      pinctrl: at91: Fix checkpatch errors
      pinctrl: generic: Make 'conf_items' static
      pinctrl: generic: Fix checkpatch errors
      pinctrl: coh901: Fix checkpatch error
      pinctrl: abx500: Staticize some symbols
      pinctrl: ab8500: Staticize some symbols
      pinctrl: ab9540: Staticize some symbols
      pinctrl: ab8540: Staticize some symbols
      pinctrl: ab8505: Staticize some symbols

Thomas Abraham (2):
      pinctrl: exynos5440: fix probe failure due to missing pin-list
in config nodes
      pinctrl: exynos5440: add gpio interrupt support

Tomasz Figa (7):
      pinctrl: samsung: Protect bank registers with a spinlock
      pinctrl: samsung: Include pinctrl-exynos driver data conditionally
      pinctrl: samsung: Split pin bank description into two structures
      pinctrl: samsung: Remove hardcoded register offsets
      pinctrl: samsung: Handle banks with two configuration registers
      pinctrl: Add pinctrl-s3c64xx driver
      pinctrl: s3c64xx: Fix build error caused by undefined chained_irq_enter

Wei Yongjun (2):
      pinctrl: exynos5440: fix invalid use of sizeof in
exynos5440_pinctrl_probe()
      pinctrl: sirf: using for_each_set_bit to simplify the code

 Documentation/devicetree/bindings/gpio/gpio.txt    |    6 +-
 .../devicetree/bindings/pinctrl/pinctrl-single.txt |  109 ++-
 .../bindings/pinctrl/samsung-pinctrl.txt           |    3 +
 Documentation/pinctrl.txt                          |  112 +++
 arch/arm/boot/dts/spear1310.dtsi                   |    4 +-
 arch/arm/boot/dts/spear1340.dtsi                   |    4 +-
 arch/arm/boot/dts/spear310.dtsi                    |    4 +-
 arch/arm/boot/dts/spear320.dtsi                    |    4 +-
 drivers/gpio/gpio-pl061.c                          |  125 ++-
 drivers/gpio/gpiolib-of.c                          |   15 +-
 drivers/pinctrl/Kconfig                            |   25 +-
 drivers/pinctrl/Makefile                           |    5 +-
 drivers/pinctrl/core.c                             |  359 ++++---
 drivers/pinctrl/core.h                             |    8 +-
 drivers/pinctrl/devicetree.c                       |   19 +-
 drivers/pinctrl/mvebu/pinctrl-mvebu.c              |   39 +-
 drivers/pinctrl/pinconf-generic.c                  |   20 +-
 drivers/pinctrl/pinconf.c                          |  335 ++++---
 drivers/pinctrl/pinconf.h                          |    8 +
 drivers/pinctrl/pinctrl-ab8500.c                   |    5 +-
 drivers/pinctrl/pinctrl-ab8505.c                   |    7 +-
 drivers/pinctrl/pinctrl-ab8540.c                   |    5 +-
 drivers/pinctrl/pinctrl-ab9540.c                   |    7 +-
 drivers/pinctrl/pinctrl-abx500.c                   |   18 +-
 drivers/pinctrl/pinctrl-at91.c                     |   27 +-
 drivers/pinctrl/pinctrl-bcm2835.c                  |    6 +-
 drivers/pinctrl/pinctrl-coh901.c                   |    9 +-
 drivers/pinctrl/pinctrl-exynos.c                   |   36 +-
 drivers/pinctrl/pinctrl-exynos.h                   |   16 +-
 drivers/pinctrl/pinctrl-exynos5440.c               |  159 +++-
 drivers/pinctrl/pinctrl-falcon.c                   |    2 +-
 drivers/pinctrl/pinctrl-imx.c                      |    6 +-
 drivers/pinctrl/pinctrl-lantiq.c                   |    4 +-
 drivers/pinctrl/pinctrl-mmp2.c                     |  722 --------------
 drivers/pinctrl/pinctrl-mxs.c                      |    6 +-
 drivers/pinctrl/pinctrl-nomadik-db8500.c           |    4 +-
 drivers/pinctrl/pinctrl-nomadik-stn8815.c          |    2 +-
 drivers/pinctrl/pinctrl-nomadik.c                  |   16 +-
 drivers/pinctrl/pinctrl-pxa168.c                   |  651 -------------
 drivers/pinctrl/pinctrl-pxa3xx.c                   |  227 -----
 drivers/pinctrl/pinctrl-pxa3xx.h                   |  262 -----
 drivers/pinctrl/pinctrl-pxa910.c                   | 1007 --------------------
 drivers/pinctrl/pinctrl-s3c64xx.c                  |  816 ++++++++++++++++
 drivers/pinctrl/pinctrl-samsung.c                  |  105 +-
 drivers/pinctrl/pinctrl-samsung.h                  |   42 +-
 drivers/pinctrl/pinctrl-single.c                   |  515 +++++++++-
 drivers/pinctrl/pinctrl-sirf.c                     |   14 +-
 drivers/pinctrl/pinctrl-sunxi.c                    |  986 ++++++++++++++-----
 drivers/pinctrl/pinctrl-tegra.c                    |    6 +-
 drivers/pinctrl/pinctrl-u300.c                     |    6 +-
 drivers/pinctrl/pinctrl-xway.c                     |    2 +-
 drivers/pinctrl/pinmux.c                           |    8 +-
 drivers/pinctrl/spear/pinctrl-spear.c              |    4 +-
 include/linux/pinctrl/pinconf.h                    |    6 +
 include/linux/pinctrl/pinctrl.h                    |    6 +-
 55 files changed, 3228 insertions(+), 3696 deletions(-)
 delete mode 100644 drivers/pinctrl/pinctrl-mmp2.c
 delete mode 100644 drivers/pinctrl/pinctrl-pxa168.c
 delete mode 100644 drivers/pinctrl/pinctrl-pxa3xx.c
 delete mode 100644 drivers/pinctrl/pinctrl-pxa3xx.h
 delete mode 100644 drivers/pinctrl/pinctrl-pxa910.c
 create mode 100644 drivers/pinctrl/pinctrl-s3c64xx.c
