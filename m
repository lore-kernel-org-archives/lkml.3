Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab3BSM6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 07:58:33 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:43999 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab3BSM6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 07:58:31 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 19 Feb 2013 12:58:10 +0000
X-Google-Sender-Auth: o4RKtFaVsKzMmv5ofgQK0RRJ1e4
Message-ID: <CACxGe6ty2SwkTcbZKWP2nP3t1R_JV1aG17dJjfyVXaJON0crKQ@mail.gmail.com>
Subject: [GIT PULL] devicetree for v3.9
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Description of changes below and in tag. Please pull.

g.

The following changes since commit 88b62b915b0b7e25870eb0604ed9a92ba4bfc9f7:

  Linux 3.8-rc6 (2013-02-01 12:08:14 +1100)

are available in the git repository at:

  git://git.secretlab.ca/git/linux tags/dt-for-linus

for you to fetch changes up to 02bbde7849e68e193cefaa1885fe0df0f03c9fcd:

  Revert "of: use platform_device_add" (2013-02-17 20:03:27 +0000)

----------------------------------------------------------------
Device tree changes for v3.9

All around device tree changes destined for v3.8. Aside from the
documentation updates the highlights in this branch include:
- Kbuild changes for using CPP with .dts files
- locking fix from preempt_rt patchset
- include DT alias names in device uevent
- Selftest bugfixes and improvements
- New function for counting phandles stanzas in a property
- constify argument to of_node_full_name()
- Various bug fixes

This tree did also contain a commit to use platform_device_add instead
of open-coding the device add code, but it caused problems with amba
devices and needed to be reverted.

----------------------------------------------------------------
Ajay Kumar (1):
      of/exynos_g2d: Add Bindings for exynos G2D driver

Alexander Shiyan (1):
      of: Add vendor prefix for Cirrus Logic

Grant Likely (11):
      powerpc/5200: Fix size to request_mem_region() call
      of: use platform_device_add
      devicetree: Move NS2 LEDs binding into LEDs directory
      Merge branch 'robherring/for-next' from
git://sources.calxeda.com/kernel/linux.git
      Merge branch 'for-next' from git://sources.calxeda.com/kernel/linux.git
      of/selftest: Fix GPIOs selftest to cover the 7th case
      of/selftest: Use selftest() macro throughout
      of/base: Clean up exit paths for of_parse_phandle_with_args()
      of: Create function for counting number of phandles in a property
      gpio: Make of_count_named_gpios() use new of_count_phandle_with_args()
      Revert "of: use platform_device_add"

Guennadi Liakhovetski (1):
      DT: add vendor prefixes for Renesas and Toshiba

Masanari Iida (1):
      documentation/devicetree: Fix typos

Sachin Kamat (1):
      documentation/devicetree: Fix a typo in exynos-dw-mshc.txt

Simon Glass (1):
      input: Extend matrix-keypad device tree binding

Steffen Trumtrar (1):
      of: add 'const' to of_node_full_name parameter

Stepan Moskovchenko (1):
      of: Output devicetree alias names in uevent

Stephen Warren (3):
      kbuild: create a rule to run the pre-processor on *.dts files
      of: fix recursive locking in of_get_next_available_child()
      kbuild: limit dtc+cpp include path

Thomas Abraham (1):
      of: fix incorrect return value of of_find_matching_node_and_match()

Thomas Gleixner (2):
      OF: Fixup resursive locking code paths
      OF: convert devtree lock from rw_lock to raw spinlock

 .../devicetree/bindings/arm/atmel-aic.txt          |    2 +-
 Documentation/devicetree/bindings/arm/gic.txt      |    4 +-
 .../devicetree/bindings/arm/omap/omap.txt          |    6 +-
 .../devicetree/bindings/drm/exynos/g2d.txt         |   22 ++
 .../devicetree/bindings/input/lpc32xx-key.txt      |    9 +-
 .../devicetree/bindings/input/matrix-keymap.txt    |    8 +
 .../devicetree/bindings/input/omap-keypad.txt      |   13 +-
 .../devicetree/bindings/input/tca8418_keypad.txt   |    6 +-
 .../bindings/{gpio => leds}/leds-ns2.txt           |    0
 .../devicetree/bindings/mips/cavium/dma-engine.txt |    2 +-
 .../devicetree/bindings/mmc/exynos-dw-mshc.txt     |    8 +-
 .../devicetree/bindings/mmc/samsung-sdhci.txt      |    2 +-
 .../devicetree/bindings/powerpc/fsl/srio.txt       |    4 +-
 .../bindings/regulator/tps62360-regulator.txt      |    4 +-
 Documentation/devicetree/bindings/rtc/s3c-rtc.txt  |    2 +-
 .../devicetree/bindings/vendor-prefixes.txt        |    3 +
 .../devicetree/bindings/watchdog/samsung-wdt.txt   |    2 +-
 Documentation/kbuild/makefiles.txt                 |   23 ++
 arch/powerpc/sysdev/bestcomm/bestcomm.c            |    2 +-
 arch/sparc/kernel/prom_common.c                    |    4 +-
 drivers/gpio/gpiolib-of.c                          |   35 ---
 drivers/hwmon/gpio-fan.c                           |    4 +-
 drivers/input/keyboard/matrix_keypad.c             |    8 +-
 drivers/net/phy/mdio-mux-gpio.c                    |    4 +-
 drivers/of/base.c                                  |  303 +++++++++++++-------
 drivers/of/device.c                                |   13 +
 drivers/of/of_private.h                            |   36 +++
 drivers/of/selftest.c                              |   54 ++--
 drivers/spi/spi-fsl-spi.c                          |    4 +-
 drivers/spi/spi-oc-tiny.c                          |    8 +-
 drivers/spi/spi-ppc4xx.c                           |    4 +-
 drivers/spi/spi.c                                  |    5 +-
 include/linux/of.h                                 |   13 +-
 include/linux/of_gpio.h                            |   40 +--
 scripts/Makefile.lib                               |   14 +
 35 files changed, 444 insertions(+), 227 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/drm/exynos/g2d.txt
 rename Documentation/devicetree/bindings/{gpio => leds}/leds-ns2.txt (100%)
 create mode 100644 drivers/of/of_private.h


--
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
