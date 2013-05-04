Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab3EDHqz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 03:46:55 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:55413 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789Ab3EDHq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 03:46:26 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 2/4] ARM: arm-soc pinctrl changes for Renesas for 3.10
Date: Sat,  4 May 2013 00:42:46 -0700
Message-Id: <1367653368-25291-3-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
In-Reply-To: <1367653368-25291-1-git-send-email-olof@lixom.net>
References: <1367653368-25291-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is yet another driver change, which is split out just because
of its size. As already in 3.9, a lot of changes are going on here,
as the shmobile platform gets converted from its own pin control
API to the generic drivers/pinctrl subsystem.

Based on agreements with Paul Mundt, we are merging the sh-arch-side
changes here as well.


Conflicts:

arch/arm/mach-shmobile/board-armadillo800eva.c:
Change/remove conflict. Remove.

----------------------------------------------------------------

The following changes since commit 01e34577d8840a5f46693b6231eb6f5a334bb1ae:

  Merge branch 'next/drivers' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/renesas-pinctrl-for-linus

for you to fetch changes up to cb3daf580a6bd798580d274a164e63a598d165c5:

  Merge tag 'renesas-pinmux-for-v3.10' of git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas into next/renesas-pinctrl

----------------------------------------------------------------

Arnd Bergmann (1):
      Merge tag 'renesas-pinmux-for-v3.10' of git://git.kernel.org/.../horms/renesas into next/renesas-pinctrl

Guennadi Liakhovetski (5):
      sh-pfc: Fix a typo and simplify a definition on sh73a0
      ARM: shmobile: sh73a0: Support sparse GPIO numbers
      sh-pfc: sh7372: Add SDHCI and MMCIF pin groups and functions
      sh-pfc: sh73a0: Add SDHI and MMCIF pin groups and functions
      sh-pfc: r8a7740: Add SDHI and MMCIF pin groups and functions

Laurent Pinchart (136):
      sh-pfc: Declare operation structures as const
      sh-pfc: Don't define the per-device pinctrl struct instances as global
      sh-pfc: Drop the sh_pfc_pinctrl spinlock
      sh-pfc: Don't take the sh_pfc spinlock in sh_pfc_map_gpios()
      sh-pfc: Use GPIO_FN instead of PINMUX_GPIO where possible
      sh-pfc: Replace first_gpio and last_gpio with nr_gpios
      sh-pfc: Replace SoC info data and mark ranges with a number of pins
      sh-pfc: Remove unused sh_pfc_soc_info reserved_id field
      sh-pfc: Initialize pinmux_gpio flags statically
      sh-pfc: Make struct pinmux_gpio enum_id field const
      sh-pfc: Shrink the pinctrl GPIO range to include real GPIOs only
      sh-pfc: Don't needlessly check GPIO type in sh_gpio_free()
      sh-pfc: Split pins and functions definition tables
      sh-pfc: Split pins and functions into separate gpio_chip instances
      sh-pfc: Rename struct pinmux_pin to struct sh_pfc_pin
      sh-pfc: Look up IRQ table entries by GPIO number
      sh-pfc: Share the PORT_10_REV, PORT_32 and PORT_32_REV definitions
      sh-pfc: Use pinmux identifiers in the pin muxing API
      sh-pfc: Simplify the sh_pfc_gpio_is_pin() logic
      sh-pfc: Add function to retrieve a pin instance from its pin number
      sh-pfc: Replace pinctrl_add_gpio_range() with gpiochip_add_pin_range()
      sh-pfc: Add support for sparse pin numbers
      ARM: shmobile: ap4-evb: Replace GPIO_PORTx enum with GPIO port numbers
      ARM: shmobile: armadillo: Replace GPIO_PORTx enum with GPIO port numbers
      ARM: shmobile: bonito: Replace GPIO_PORTx enum with GPIO port numbers
      ARM: shmobile: mackerel: Replace GPIO_PORTx enum with GPIO port numbers
      sh-pfc: Expose real groups and functions in pinctrl/pinmux operations
      sh: sh7203: Add pin control resources
      sh: sh7264: Add pin control resources
      sh: sh7269: Add pin control resources
      sh: sh7720: Add pin control resources
      sh: sh7722: Add pin control resources
      sh: sh7723: Add pin control resources
      sh: sh7724: Add pin control resources
      sh: sh7757: Add pin control resources
      sh: sh7785: Add pin control resources
      sh: sh7786: Add pin control resources
      sh: shx3: Add pin control resources
      sh-pfc: Move GPIO registers access functions to gpio.c
      sh-pfc: Don't map data registers individually
      sh-pfc: Drop unused support for 1:1 physical to virtual memory mappings
      sh-pfc: Don't modify pinmux_data_reg SoC data
      sh-pfc: Don't modify sh_pfc_pin SoC data
      sh-pfc: Remove configuration dry-run and free
      sh-pfc: Constify all SoC data
      sh-pfc: Use proper error codes
      sh-pfc: Implement generic pinconf support
      sh-pfc: Merge sh_pfc_reconfig_pin() into sh_pfc_gpio_set_direction()
      sh-pfc: Clean up pin configuration type handling
      sh-pfc: Convert message printing from pr_* to dev_*
      sh-pfc: Return an error if a pin doesn't support the requested direction
      sh-pfc: sh73a0: Add bias (pull-up/down) pinconf support
      sh-pfc: sh73a0: Add LCD and LCD2 pin groups and functions
      sh-pfc: sh73a0: Add SCIFA and SCIFB pin groups and functions
      sh-pfc: sh73a0: Add I2C2 and I2C3 pin groups and functions
      sh-pfc: sh73a0: Add FSI pin groups and functions
      sh-pfc: sh73a0: Add KEYSC pin groups and functions
      sh-pfc: sh73a0: Add BSC pin groups and functions
      sh-pfc: sh73a0: Add USB pin groups and functions
      sh-pfc: sh73a0: Add IrDA pin groups and functions
      sh-pfc: r8a7740: Add LCDC0 and LCDC1 pin groups and functions
      sh-pfc: r8a7779: Add DU pin groups and functions
      sh-pfc: r8a7779: Add SDHI and MMCIF pin groups and functions
      sh-pfc: r8a7779: Add SCIF pin groups and functions
      sh-pfc: r8a7779: Add HSPI pin groups and functions
      sh-pfc: r8a7779: Add USB0 and USB1 PENC pinmux support
      sh-pfc: r8a7779: Add USB pin groups and functions
      sh-pfc: r8a7779: Add LBSC pin groups and functions
      sh-pfc: r8a7779: Add INTC pin groups and functions
      ARM: shmobile: ag5evm: Register pinctrl mappings for SCIF
      ARM: shmobile: ag5evm: Register pinctrl mappings for I2C
      ARM: shmobile: ag5evm: Register pinctrl mappings for FSI
      ARM: shmobile: ag5evm: Register pinctrl mappings for SDHI and MMCIF
      ARM: shmobile: ag5evm: Register pinctrl mappings for KEYSC
      ARM: shmobile: ag5evm: Register pinctrl mappings for IrDA
      ARM: shmobile: ap4evb: Register pinctrl mappings for SDHI and MMCIF
      ARM: shmobile: armadillo800eva: Register pinctrl mappings for LCDC0
      ARM: shmobile: armadillo800eva: Register pinctrl mappings for SDHI and MMCIF
      ARM: shmobile: bonito: Register pinctrl mappings for LCDC0
      ARM: shmobile: kota2: Register pinctrl mappings for SCIF
      ARM: shmobile: kota2: Register pinctrl mappings for SDHI and MMCIF
      ARM: shmobile: kota2: Register pinctrl mappings for KEYSC
      ARM: shmobile: kota2: Register pinctrl mappings for BSC
      ARM: shmobile: kzm9g: Register pinctrl mappings for LCD
      ARM: shmobile: kzm9g: Register pinctrl mappings for SCIF
      ARM: shmobile: kzm9g: Register pinctrl mappings for I2C
      ARM: shmobile: kzm9g: Register pinctrl mappings for FSI
      ARM: shmobile: kzm9g: Register pinctrl mappings for SDHI and MMCIF
      ARM: shmobile: kzm9g: Register pinctrl mappings for BSC
      ARM: shmobile: kzm9g: Register pinctrl mappings for USB
      ARM: shmobile: mackerel: Register pinctrl mappings for SDHI and MMCIF
      ARM: shmobile: marzen: Register pinctrl mappings for SDHI and MMCIF
      ARM: shmobile: marzen: Register pinctrl mappings for SCIF
      ARM: shmobile: marzen: Register pinctrl mappings for HSPI
      ARM: shmobile: marzen: Register pinctrl mappings for USB
      ARM: shmobile: marzen: Register pinctrl mappings for LBSC
      ARM: shmobile: marzen: Register pinctrl mappings for INTC
      sh-pfc: sh7372: Remove SDHI and MMCIF function GPIOS
      sh-pfc: sh73a0: Remove LCD and LCD2 function GPIOS
      sh-pfc: sh73a0: Remove SCIFA and SCIFB function GPIOS
      sh-pfc: sh73a0: Remove I2C function GPIOS
      sh-pfc: sh73a0: Remove FSI function GPIOS
      sh-pfc: sh73a0: Remove pull-up function GPIOS
      sh-pfc: sh73a0: Remove KEYSC function GPIOS
      sh-pfc: sh73a0: Remove BSC function GPIOS
      sh-pfc: sh73a0: Remove USB function GPIOS
      sh-pfc: sh73a0: Remove IrDA function GPIOS
      sh-pfc: r8a7740: Remove LCD0 and LCD1 function GPIOS
      sh-pfc: r8a7740: Remove SDHI and MMCIF function GPIOS
      sh-pfc: r8a7779: Remove DU1_DOTCLKOUT1 GPIO
      sh-pfc: r8a7779: Remove SDHI and MMCIF function GPIOS
      sh-pfc: r8a7779: Remove SCIF function GPIOS
      sh-pfc: r8a7779: Remove HSPI function GPIOS
      sh-pfc: r8a7779: Remove USB function GPIOS
      sh-pfc: r8a7779: Remove LBSC function GPIOS
      sh-pfc: r8a7779: Remove INTC function GPIOS
      ARM: shmobile: sh7372: Remove SDHI and MMCIF function GPIOs
      ARM: shmobile: sh73a0: Remove LCDC and LCDC2 function GPIOs
      ARM: shmobile: sh73a0: Remove SCIFA and SCIFB function GPIOs
      ARM: shmobile: sh73a0: Remove I2C function GPIOs
      ARM: shmobile: sh73a0: Remove FSI function GPIOs
      ARM: shmobile: sh73a0: Remove pull-up function GPIOS
      ARM: shmobile: sh73a0: Remove KEYSC function GPIOs
      ARM: shmobile: sh73a0: Remove BSC function GPIOs
      ARM: shmobile: sh73a0: Remove USB function GPIOs
      ARM: shmobile: sh73a0: Remove IrDA function GPIOs
      ARM: shmobile: r8a7740: Remove LCD0 and LCD1 function GPIOs
      ARM: shmobile: r8a7740: Remove SDHI and MMCIF function GPIOs
      ARM: shmobile: r8a7779: Remove DU1_DOTCLKOUT1 GPIO
      ARM: shmobile: r8a7779: Remove DU function GPIOs
      ARM: shmobile: r8a7779: Remove SDHI and MMCIF function GPIOs
      ARM: shmobile: r8a7779: Remove SCIF function GPIOs
      ARM: shmobile: r8a7779: Remove HSPI function GPIOs
      ARM: shmobile: r8a7779: Remove USB function GPIOs
      ARM: shmobile: r8a7779: Remove LBSC function GPIOs
      ARM: shmobile: r8a7779: Remove INTC function GPIOs

Simon Horman (2):
      Merge branch 'devel' of git://git.kernel.org/.../linusw/linux-pinctrl into pinmux
      Merge branch 'fixes' of git://git.kernel.org/.../linusw/linux-pinctrl into pinmux-base

Wei Yongjun (1):
      sh-pfc: Fix return value check in sh_pfc_register_pinctrl()


 arch/arm/mach-shmobile/board-ag5evm.c          |  172 +-
 arch/arm/mach-shmobile/board-ap4evb.c          |   91 +-
 arch/arm/mach-shmobile/board-armadillo800eva.c |  158 +-
 arch/arm/mach-shmobile/board-bonito.c          |   52 +-
 arch/arm/mach-shmobile/board-kota2.c           |  208 +-
 arch/arm/mach-shmobile/board-kzm9g.c           |  152 +-
 arch/arm/mach-shmobile/board-mackerel.c        |  102 +-
 arch/arm/mach-shmobile/board-marzen.c          |   75 +-
 arch/arm/mach-shmobile/include/mach/r8a7740.h  |   74 -
 arch/arm/mach-shmobile/include/mach/r8a7779.h  |  324 ++-
 arch/arm/mach-shmobile/include/mach/sh7372.h   |   29 -
 arch/arm/mach-shmobile/include/mach/sh73a0.h   |  363 +--
 arch/sh/kernel/cpu/sh2a/pinmux-sh7203.c        |   13 +-
 arch/sh/kernel/cpu/sh2a/pinmux-sh7264.c        |   13 +-
 arch/sh/kernel/cpu/sh2a/pinmux-sh7269.c        |   11 +-
 arch/sh/kernel/cpu/sh3/pinmux-sh7720.c         |   14 +-
 arch/sh/kernel/cpu/sh4a/pinmux-sh7722.c        |   14 +-
 arch/sh/kernel/cpu/sh4a/pinmux-sh7723.c        |   14 +-
 arch/sh/kernel/cpu/sh4a/pinmux-sh7724.c        |   13 +-
 arch/sh/kernel/cpu/sh4a/pinmux-sh7757.c        |   13 +-
 arch/sh/kernel/cpu/sh4a/pinmux-sh7785.c        |   14 +-
 arch/sh/kernel/cpu/sh4a/pinmux-sh7786.c        |   14 +-
 arch/sh/kernel/cpu/sh4a/pinmux-shx3.c          |   17 +-
 drivers/pinctrl/sh-pfc/Kconfig                 |    1 +
 drivers/pinctrl/sh-pfc/core.c                  |  261 +-
 drivers/pinctrl/sh-pfc/core.h                  |   54 +-
 drivers/pinctrl/sh-pfc/gpio.c                  |  363 ++-
 drivers/pinctrl/sh-pfc/pfc-r8a7740.c           |  694 ++++-
 drivers/pinctrl/sh-pfc/pfc-r8a7779.c           | 1648 ++++++++++--
 drivers/pinctrl/sh-pfc/pfc-sh7203.c            |  488 ++--
 drivers/pinctrl/sh-pfc/pfc-sh7264.c            |  460 ++--
 drivers/pinctrl/sh-pfc/pfc-sh7269.c            |  624 ++---
 drivers/pinctrl/sh-pfc/pfc-sh7372.c            |  323 ++-
 drivers/pinctrl/sh-pfc/pfc-sh73a0.c            | 2656 +++++++++++++------
 drivers/pinctrl/sh-pfc/pfc-sh7720.c            |  333 +--
 drivers/pinctrl/sh-pfc/pfc-sh7722.c            |  480 ++--
 drivers/pinctrl/sh-pfc/pfc-sh7723.c            |  642 ++---
 drivers/pinctrl/sh-pfc/pfc-sh7724.c            |  638 ++---
 drivers/pinctrl/sh-pfc/pfc-sh7734.c            |   55 +-
 drivers/pinctrl/sh-pfc/pfc-sh7757.c            |  620 ++---
 drivers/pinctrl/sh-pfc/pfc-sh7785.c            |  354 +--
 drivers/pinctrl/sh-pfc/pfc-sh7786.c            |  296 ++-
 drivers/pinctrl/sh-pfc/pfc-shx3.c              |  148 +-
 drivers/pinctrl/sh-pfc/pinctrl.c               |  484 ++--
 drivers/pinctrl/sh-pfc/sh_pfc.h                |  135 +-
 45 files changed, 8367 insertions(+), 5340 deletions(-)
