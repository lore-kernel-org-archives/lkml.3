Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab3EFKm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 06:42:57 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:46421 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab3EFKmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 06:42:55 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 6 May 2013 11:42:34 +0100
X-Google-Sender-Auth: 7DHuzdmM81Oe3Uh6dMali9FwA7c
Message-ID: <CACxGe6vX0s_y1O9qBPceji1BxQbPMoRs15gy_XG71aQ9vUQeZw@mail.gmail.com>
Subject: [git-pull] v2 gpio changes for v3.10
To: Linus Walleij <linus.walleij@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Regardless of you being pissed at me for the last pull request and not
wanting to take anything from me this cycle, I'm sending this anyway.
It's been build tested on several architectures and all of these
commits were in linux-next before the merge window opened. I pealed
off the top two commits to get rid of the incorrectly applied UCB1400 patch
that broke allmodconfig. I have *not* rebased.

g.


The following changes since commit e97f9b5277afeabb54892ebc6f68500098467ba1:

  gpio/gpio-ich: fix ichx_gpio_check_available() return what callers
expect (2013-03-02 13:20:21 +0000)

are available in the git repository at:

  git://git.secretlab.ca/git/linux tags/gpio-for-linus

for you to fetch changes up to 08ffb2229fafc2c3a696b325a74bf4198d6b91d7:

  gpio: grgpio: Add irq support (2013-04-26 08:52:38 +0200)

----------------------------------------------------------------
GPIO changes for Linux 3.10

The usual selection of bug fixes and driver updates for GPIO. Nothing
really stands out except the addition of the GRGPIO driver and some
enhacements to ACPI support

----------------------------------------------------------------
Alexander Shiyan (1):
      GPIO: gpio-generic: remove kfree() from bgpio_remove call

Andreas Larsson (3):
      gpio: gpio-generic: Add 16 and 32 bit big endian byte order support
      gpio: grgpio: Add device driver for GRGPIO cores
      gpio: grgpio: Add irq support

Axel Lin (3):
      gpio: viperboard: Remove duplicate code to set gpio->gpiob_val
      gpio: samsung: Add terminating entry for exynos_pinctrl_ids
      gpio: lpc32xx: Fix off-by-one valid range checking for bank

Christophe Leroy (1):
      MAX7301 GPIO: Do not force SPI speed when using OF Platform

Darren Hart (1):
      gpio-sch: Allow for more than 8 lines in the resume well

Jean Delvare (1):
      gpio-ich: Check for pin availability at request time

Jingoo Han (9):
      gpio: adp5520: use devm_kzalloc()
      gpio: max7300: use devm_kzalloc()
      gpio: max7301: use devm_kzalloc()
      gpio: max732x: use devm_kzalloc()
      gpio: mc33880: use devm_kzalloc()
      gpio: pcf857x: use devm_kzalloc()
      gpio: mc33880: use dev_err() instead of printk()
      gpio: 74x164: use spi_get_drvdata() and spi_set_drvdata()
      gpio: mc33880: use spi_get_drvdata() and spi_set_drvdata()

Jon Hunter (5):
      gpio/omap: convert gpio irq domain to linear mapping
      gpio/omap: warn if bank is not enabled on setting irq type
      gpio/omap: free irq domain in probe() failure paths
      gpio/omap: optimise interrupt service routine
      gpio/omap: force restore if context loss is not detectable

Lars Poeschel (1):
      gpio: mcp23s08: convert driver to DT

Laurent Navet (10):
      gpio: gpiolib-of.c: fix checkpatch error
      gpio: gpio-mvebu.c: fix checkpatch errors
      gpio: gpio-omap.c: fix checkpatch error
      gpio: gpio-pca953x.c: fix checkpatch error
      gpio: gpio-pxa.c: fix checkpatch errors
      gpio: gpio-sch.c: fix checkpatch error
      gpio: gpio-stp-xway.c: fix checkpatch error
      gpio: gpio-tc3589x.c: fix checkpatch errors
      gpio: gpio-timberdale.c: fix checkpatch error
      gpio: gpio-tps65910.c: fix checkpatch error

Magnus Damm (2):
      gpio/em: Add Device Tree support
      gpio: em: Make use of devm functions

Mathias Nyman (1):
      gpio-lynxpoint: Add X86 dependency and io-port handling header.

Mika Westerberg (2):
      gpio/gpio-ich: make ichx_gpio_check_available() return a pure
boolean value
      gpiolib-acpi: introduce acpi_get_gpio_by_index() helper

Nikolay Balandin (1):
      Add TI TCA9554 to supported devices table

Rafael J. Wysocki (1):
      gpio / ACPI: Handle ACPI events in accordance with the spec

Sachin Kamat (1):
      gpio/vt8500: Convert to devm_ioremap_resource()

Simon Guinot (1):
      gpio: mvebu: add dbg_show function

Stephen Warren (1):
      gpio/tegra: assume CONFIG_OF

Tarun Kanti DebBarma (1):
      gpio/omap: remove extra context restores in *_runtime_resume()

 Documentation/acpi/enumeration.txt                 |  32 +-
 .../devicetree/bindings/gpio/gpio-grgpio.txt       |  26 ++
 .../devicetree/bindings/gpio/gpio-mcp23s08.txt     |  47 ++
 .../devicetree/bindings/gpio/gpio-omap.txt         |   7 +-
 drivers/gpio/Kconfig                               |  11 +-
 drivers/gpio/Makefile                              |   1 +
 drivers/gpio/gpio-74x164.c                         |   8 +-
 drivers/gpio/gpio-adp5520.c                        |   4 +-
 drivers/gpio/gpio-em.c                             |  94 ++--
 drivers/gpio/gpio-generic.c                        |  62 ++-
 drivers/gpio/gpio-grgpio.c                         | 505 +++++++++++++++++++++
 drivers/gpio/gpio-ich.c                            |  17 +-
 drivers/gpio/gpio-lpc32xx.c                        |   2 +-
 drivers/gpio/gpio-lynxpoint.c                      |   1 +
 drivers/gpio/gpio-max7300.c                        |   4 +-
 drivers/gpio/gpio-max7301.c                        |   7 +-
 drivers/gpio/gpio-max732x.c                        |   5 +-
 drivers/gpio/gpio-mc33880.c                        |  19 +-
 drivers/gpio/gpio-mcp23s08.c                       | 137 ++++--
 drivers/gpio/gpio-mvebu.c                          |  85 +++-
 drivers/gpio/gpio-omap.c                           | 116 ++---
 drivers/gpio/gpio-pca953x.c                        |   3 +-
 drivers/gpio/gpio-pcf857x.c                        |   8 +-
 drivers/gpio/gpio-pxa.c                            |   4 +-
 drivers/gpio/gpio-samsung.c                        |   1 +
 drivers/gpio/gpio-sch.c                            | 111 +++--
 drivers/gpio/gpio-stp-xway.c                       |   2 +-
 drivers/gpio/gpio-tc3589x.c                        |   8 +-
 drivers/gpio/gpio-tegra.c                          |  11 +-
 drivers/gpio/gpio-timberdale.c                     |   3 +-
 drivers/gpio/gpio-tps65910.c                       |   2 +-
 drivers/gpio/gpio-viperboard.c                     |   4 -
 drivers/gpio/gpio-vt8500.c                         |   8 +-
 drivers/gpio/gpiolib-acpi.c                        | 217 ++++++++-
 drivers/gpio/gpiolib-of.c                          |   2 +-
 include/linux/acpi_gpio.h                          |  19 +
 include/linux/basic_mmio_gpio.h                    |   1 +
 37 files changed, 1296 insertions(+), 298 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-grgpio.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
 create mode 100644 drivers/gpio/gpio-grgpio.c


--
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
