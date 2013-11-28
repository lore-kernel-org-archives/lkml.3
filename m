Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab3K1OVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:21:05 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:34521 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab3K1OVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:21:02 -0500
MIME-Version: 1.0
Date: Thu, 28 Nov 2013 15:21:01 +0100
Message-ID: <CACRpkdaU3EYjJ64XrmnSvmkjtV1_QT1fc21E75Jx-UzC3vjBPg@mail.gmail.com>
Subject: [GIT PULL] GPIO fixes for v3.13-rcN series
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here us a bunch of patches for the v3.13 series. Most important stuff
is related to fixes and documentation for the new GPIO descriptor API.
If the diffstat is scary you'll notice most of it is to Documentation/*

The rest is described in the signed tag as usual.

Please pull this in!

Yours,
Linus Walleij


The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-v3.13-2

for you to fetch changes up to e2f0b00560729c47f39b2bc624eb93d82dc0e3e8:

  gpio: bcm281xx: Fix return value of bcm_kona_gpio_get() (2013-11-27
15:01:03 +0100)

----------------------------------------------------------------
GPIO fixes for the v3.13 series:

- A big slew of documentation for the gpiod transition that
  happened in the merge window, no semantic effect, but we should
  provide proper documentation with the new API.

- Fix flags related to the new API.

- Fix to the find_chip_by_name() lookup function related to the
  new API.

- Fix of_find_gpio() when not using device tree.

- Bug fix for the TB10x direction setting.

- Error path fixes from Dan Carpenter.

- Nasty IRQdomain bug relating to taking an unitialized spinlock.

- Minor fixes here and there.

----------------------------------------------------------------
Alexandre Courbot (4):
      Documentation: gpiolib: document new interface
      gpiolib: fix find_chip_by_name()
      gpiolib: use dedicated flags for GPIO properties
      gpiolib: fix of_find_gpio() when OF not defined

Axel Lin (2):
      gpio: tb10x: Set output value before setting direction to output
      gpio: ucb1400: Add MODULE_ALIAS

Dan Carpenter (3):
      gpio: mvebu: make mvchip->irqbase signed for error handling
      gpio: msm: make msm_gpio.summary_irq signed for error handling
      gpio: rcar: NULL dereference on error in probe()

Linus Walleij (1):
      gpio: pl061: move irqdomain initialization

Markus Mayer (1):
      gpio: bcm281xx: Fix return value of bcm_kona_gpio_get()

Michal Nazarewicz (1):
      gpio: fix memory leak in error path

 Documentation/gpio/board.txt                     | 115 +++++++++++++
 Documentation/gpio/consumer.txt                  | 197 +++++++++++++++++++++++
 Documentation/gpio/driver.txt                    |  75 +++++++++
 Documentation/{gpio.txt => gpio/gpio-legacy.txt} |   0
 Documentation/gpio/gpio.txt                      | 119 ++++++++++++++
 Documentation/gpio/sysfs.txt                     | 155 ++++++++++++++++++
 drivers/gpio/gpio-bcm-kona.c                     |   2 +-
 drivers/gpio/gpio-msm-v2.c                       |   2 +-
 drivers/gpio/gpio-mvebu.c                        |   2 +-
 drivers/gpio/gpio-pl061.c                        |  10 +-
 drivers/gpio/gpio-rcar.c                         |   2 +-
 drivers/gpio/gpio-tb10x.c                        |   1 +
 drivers/gpio/gpio-ucb1400.c                      |   1 +
 drivers/gpio/gpiolib.c                           |  58 ++++---
 include/linux/gpio/driver.h                      |  11 +-
 15 files changed, 713 insertions(+), 37 deletions(-)
 create mode 100644 Documentation/gpio/board.txt
 create mode 100644 Documentation/gpio/consumer.txt
 create mode 100644 Documentation/gpio/driver.txt
 rename Documentation/{gpio.txt => gpio/gpio-legacy.txt} (100%)
 create mode 100644 Documentation/gpio/gpio.txt
 create mode 100644 Documentation/gpio/sysfs.txt
