Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab3GAIjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:39:44 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:54694 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab3GAIjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:39:43 -0400
MIME-Version: 1.0
Date: Mon, 1 Jul 2013 10:39:42 +0200
Message-ID: <CACRpkdaLGwXYrtGDOEbYukL0y4QidR3E1i8CBx4jT++EykJhZg@mail.gmail.com>
Subject: [GIT PULL] GPIO changes for v3.11
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is a batch of GPIO changes for v3.11. I have agreed with Grant to take
care of the pull requests for this development cycle.

No special things are happening in the GPIO tree this time (nice with some
calm) and I have been extra careful to do regression builds and it's well
boiled in -next.

Please pull them in!

Yours,
Linus Walleij


The following changes since commit e4aa937ec75df0eea0bee03bffa3303ad36c986b:

  Linux 3.10-rc3 (2013-05-26 16:00:47 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-for-v3.11-1

for you to fetch changes up to 038f0babc98a16211959010d7cd48b4a14f108cc:

  Gpio/trivial: replace numeric with standard PM state macros
(2013-06-30 01:37:07 +0200)

----------------------------------------------------------------
GPIO changes for the v3.11 development cycle:
- Incremental development for the Langwell (Atom SoC),
  Xilinx, ICH and RCAR drivers.
- Cleanups from Jingoo Han, Axel Lin, Wei Jongjun,
  Wolfram Sang, Tushar Behera, Sachin Kamat and Yijing Wang.

----------------------------------------------------------------
Alexandre Courbot (1):
      MAINTAINERS: add linux-gpio mailing list

Andy Shevchenko (6):
      gpio-langwell: initialize lock before usage
      gpio-langwell: do not use direct access to iomapped memory
      gpio-langwell: use managed functions pcim_* and devm_*
      gpio-langwell: amend error messages
      gpio-langwell: drop away explicit casting
      gpio-langwell: remove Withney point support

Arnd Bergmann (1):
      gpio/omap: omap_gpio_init_context stub must be inline

Axel Lin (2):
      gpio: stmpe: Staticize non-exported symbols
      gpio: max7300: Fix trivial typo in Kconfig help text

Jingoo Han (7):
      gpio: langwell: remove unnecessary platform_set_drvdata()
      gpio: lynxpoint: remove unnecessary platform_set_drvdata()
      gpio: rdc321x: remove unnecessary platform_set_drvdata()
      gpio: stmpe: remove unnecessary platform_set_drvdata()
      gpio: tc3589x: remove unnecessary platform_set_drvdata()
      gpio: timberdale: remove unnecessary platform_set_drvdata()
      gpio: vx855: remove unnecessary platform_set_drvdata()

Magnus Damm (1):
      gpio-rcar: Use OUTDT when reading GPIOs configured as output

Michal Simek (6):
      GPIO: xilinx: Simplify driver probe function
      GPIO: xilinx: Add support for dual channel
      GPIO: xilinx: Use __raw_readl/__raw_writel IO functions
      GPIO: xilinx: Use BIT macro
      DT: Add documentation for gpio-xilinx
      GPIO: xilinx: Enable driver for Xilinx zynq

Nikolay Balandin (1):
      gpio: sx150x: convert to use devm_* functions

Sachin Kamat (2):
      gpio-sta2x11: Fix potential NULL pointer dereference
      gpio: grgpio: Staticize local symbols

Stephen Boyd (1):
      gpio: msm-v1: Remove errant __devinit to fix compile

Tushar Behera (2):
      gpio_msm: Convert to use devm_ioremap_resource
      gpio-sta2x11: Convert to use devm_ioremap_resource

Vincent Donnefort (1):
      gpio: ich: add GPO_BLINK support

Wei Yongjun (1):
      gpio-ml-ioh: fix error return code in ioh_gpio_probe()

Wolfram Sang (1):
      gpio: devres: make comments proper

Yijing Wang (1):
      Gpio/trivial: replace numeric with standard PM state macros

Zhangfei Gao (1):
      gpiolib: remove warnning of allocations with IRQs disabled

 .../devicetree/bindings/gpio/gpio-xilinx.txt       |  48 ++++++
 MAINTAINERS                                        |   1 +
 drivers/gpio/Kconfig                               |   4 +-
 drivers/gpio/devres.c                              |  14 +-
 drivers/gpio/gpio-bt8xx.c                          |   2 +-
 drivers/gpio/gpio-grgpio.c                         |   6 +-
 drivers/gpio/gpio-ich.c                            |   8 +-
 drivers/gpio/gpio-langwell.c                       | 164 ++++-----------------
 drivers/gpio/gpio-lynxpoint.c                      |   1 -
 drivers/gpio/gpio-ml-ioh.c                         |   1 +
 drivers/gpio/gpio-msm-v1.c                         |  14 +-
 drivers/gpio/gpio-omap.c                           |   2 +-
 drivers/gpio/gpio-rcar.c                           |   9 +-
 drivers/gpio/gpio-rdc321x.c                        |   7 +-
 drivers/gpio/gpio-sta2x11.c                        |   6 +-
 drivers/gpio/gpio-stmpe.c                          |   7 +-
 drivers/gpio/gpio-sx150x.c                         |  18 +--
 drivers/gpio/gpio-tc3589x.c                        |   1 -
 drivers/gpio/gpio-timberdale.c                     |   2 -
 drivers/gpio/gpio-vx855.c                          |   2 -
 drivers/gpio/gpio-xilinx.c                         | 144 ++++++++++++++----
 drivers/gpio/gpiolib.c                             |   8 +-
 22 files changed, 248 insertions(+), 221 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-xilinx.txt
