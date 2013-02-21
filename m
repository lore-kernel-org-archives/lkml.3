Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab3BUVOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 16:14:04 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:58133 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354Ab3BUVNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 16:13:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 03/09] arm-soc: pin muxing for sh-mobile
Date: Thu, 21 Feb 2013 21:12:23 +0000
Message-Id: <1361481149-27559-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361481149-27559-1-git-send-email-arnd@arndb.de>
References: <1361481149-27559-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:NEe7hb1uKAdwhRf5iu/2QG3QuwCY3KRziynFCnelrnL
 0PxD8hpxFmNiuFwM0csn4v0FyOJV+rGwPmKFZ6q6hHwNJlGlKc
 ysfLSwyxBYCuNiRxIPSTPNXqCXzJBLNtrDLMVhbzeAARofLFz1
 /OFrwDH0u9zQmLRk8lZZYLEYyUou6SEBGYGpkl/aqKk1x2sKm5
 cuyVvctwBWvc0qrHd/hjnx94n9Y43NvyluR8Ci8cOAyruMNhhP
 KgkFqzD9+gCCjOrz+l6qiIzIln+tw/HKvzMB6gDqdgxLitUWXd
 xepF+KOVCfW1hmoJ+Z5IkoXZEe9edyv20TSGALL3Z3V7Wgl921
 WxgM+K0l1lqU3isTCOZKACNQ06bSJNu4Fj6k/P9RH
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 949db153b6466c6f7cad5a427ecea94985927311:

  Linux 3.8-rc5 (2013-01-25 11:57:28 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/sh-pinmux

for you to fetch changes up to 62508a5d25e355cc19c3ade3c3b7dddc6d326cc5:

  Merge tag 'renesas-pinmux2-for-v3.9' of git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas into next/sh-pinmux (2013-02-16 11:27:19 +0100)

----------------------------------------------------------------

arm-soc: pin muxing for sh-mobile

This is another cleanup series, containing the move of the Renesas
SH-Mobile pin controller code from arch/arm/mach-shmobile over to the
generic pinctrl subsystem, changing it over to the common interfaces in
the process.

Based on agreement between Olof, Paul Mundt, Linus Walleij and Simon,
we're merging this large branch of pinctrl conversion through arm-soc,
even though it contains the corresponding conversions for arch/sh. Main
reason for this is tight dependencies (that will now mostly be broken)
between the arch/sh and mach-shmobile implementations.

There will be more of this in 3.10 to do device-tree bindings, but this
is the initial conversion.

----------------------------------------------------------------

Arnd Bergmann (2):
      Merge tag 'renesas-pinmux2-for-v3.9' of git://git.kernel.org/.../horms/renesas into next/sh-pinmux
      Merge branch 'next/sh-pinmux' into for-next

Laurent Pinchart (80):
      sh: sh7264: Rename CRX0CRX1 mark to match GPIO names
      sh: sh7269: Rename CRX0CRX1(CRX2) marks to match GPIO names
      sh: sh7723: Rename GPIO_FN_SIUOSPD to GPIO_FN_SIUAOSPD
      sh: sh7757: Fix GPIO_FN_ET0_MDIO and GPIO_FN_ET1_MDIO GPIO entries
      sh: sh7786: Fix port E, G and J GPIOs
      sh: sh7786: Fix last GPIO index
      sh: shx3: Fix last GPIO index
      sh-pfc: Split platform data from the sh_pfc structure
      sh-pfc: Move private definitions and declarations to private header
      sh-pfc: Merge PFC core and pinctrl
      sh-pfc: Merge PFC core and gpio
      sh-pfc: Move platform device and driver to the core
      sh-pfc: Use devm_kzalloc()
      sh-pfc: Use devm_ioremap_nocache()
      sh-pfc: Let the compiler decide whether to inline functions
      sh-pfc: Remove check for impossible error condition
      sh-pfc: Sort headers alphabetically
      sh-pfc: Use sh_pfc_ namespace prefix through the whole driver
      sh-pfc: Split platform device and platform driver registration
      sh-pfc: Support passing resources through platform device
      ARM: shmobile: Select PINCTRL
      ARM: shmobile: r8a7740: Register PFC platform device
      ARM: shmobile: r8a7779: Register PFC platform device
      ARM: shmobile: sh7372: Register PFC platform device
      ARM: shmobile: sh73a0: Register PFC platform device
      ARM: shmobile: r8a7740: Add pin control resources
      ARM: shmobile: sh7372: Add pin control resources
      ARM: shmobile: sh73a0: Add pin control resources
      sh: Add PFC platform device registration helper function
      sh: sh7203: Register PFC platform device
      sh: sh7264: Register PFC platform device
      sh: sh7269: Register PFC platform device
      sh: sh7720: Register PFC platform device
      sh: sh7722: Register PFC platform device
      sh: sh7723: Register PFC platform device
      sh: sh7724: Register PFC platform device
      sh: sh7734: Register PFC platform device
      sh: sh7757: Register PFC platform device
      sh: sh7785: Register PFC platform device
      sh: sh7786: Register PFC platform device
      sh: shx3: Register PFC platform device
      sh-pfc: Remove platform device registration
      sh-pfc: Remove unused resource and num_resources platform data fields
      sh-pfc: Move driver from drivers/sh/ to drivers/pinctrl/
      sh-pfc: Support pinmux info in driver data instead of platform data
      sh-pfc: Add r8a7740 pinmux support
      sh-pfc: Add r8a7779 pinmux support
      sh-pfc: Add sh7372 pinmux support
      sh-pfc: Add sh73a0 pinmux support
      sh-pfc: Add sh7203 pinmux support
      sh-pfc: Add sh7264 pinmux support
      sh-pfc: Add sh7269 pinmux support
      sh-pfc: Add sh7720 pinmux support
      sh-pfc: Add sh7722 pinmux support
      sh-pfc: Add sh7723 pinmux support
      sh-pfc: Add sh7724 pinmux support
      sh-pfc: Add sh7734 pinmux support
      sh-pfc: Add sh7757 pinmux support
      sh-pfc: Add sh7785 pinmux support
      sh-pfc: Add sh7786 pinmux support
      sh-pfc: Add shx3 pinmux support
      ARM: shmobile: r8a7740: Use driver-provided pinmux info
      ARM: shmobile: r8a7779: Use driver-provided pinmux info
      ARM: shmobile: sh7372: Use driver-provided pinmux info
      ARM: shmobile: sh73a0: Use driver-provided pinmux info
      sh: sh7203: pinmux: Use driver-provided pinmux info
      sh: sh7264: pinmux: Use driver-provided pinmux info
      sh: sh7269: pinmux: Use driver-provided pinmux info
      sh: sh7720: pinmux: Use driver-provided pinmux info
      sh: sh7722: pinmux: Use driver-provided pinmux info
      sh: sh7723: pinmux: Use driver-provided pinmux info
      sh: sh7724: pinmux: Use driver-provided pinmux info
      sh: sh7734: pinmux: Use driver-provided pinmux info
      sh: sh7757: pinmux: Use driver-provided pinmux info
      sh: sh7785: pinmux: Use driver-provided pinmux info
      sh: sh7786: pinmux: Use driver-provided pinmux info
      sh: shx3: pinmux: Use driver-provided pinmux info
      sh: Remove unused sh_pfc_register_info() function
      sh-pfc: Remove pinmux_info definition
      sh-pfc: Move sh_pfc.h from include/linux/ to driver directory

Magnus Damm (1):
      sh-pfc: sh_pfc_probe() sizeof() fix

Olof Johansson (1):
      Merge branch 'pfc' of git://git.kernel.org/.../horms/renesas into next/sh-pinmux

 arch/arm/Kconfig                                   |    1 +
 arch/arm/arm-soc-for-next-contents.txt             |   20 +-
 arch/arm/mach-shmobile/Makefile                    |    8 -
 arch/arm/mach-shmobile/setup-r8a7740.c             |   26 +
 arch/arm/mach-shmobile/setup-r8a7779.c             |   25 +
 arch/arm/mach-shmobile/setup-sh7372.c              |   26 +
 arch/arm/mach-shmobile/setup-sh73a0.c              |   25 +
 arch/sh/Kconfig                                    |   12 +
 arch/sh/include/asm/gpio.h                         |    2 +-
 arch/sh/include/cpu-common/cpu/pfc.h               |   26 +
 arch/sh/include/cpu-sh4/cpu/sh7723.h               |    2 +-
 arch/sh/include/cpu-sh4/cpu/sh7786.h               |    8 +-
 arch/sh/kernel/cpu/Makefile                        |    2 +-
 arch/sh/kernel/cpu/pfc.c                           |   33 +
 arch/sh/kernel/cpu/sh2a/pinmux-sh7203.c            | 1582 +----------
 arch/sh/kernel/cpu/sh2a/pinmux-sh7264.c            | 2121 +--------------
 arch/sh/kernel/cpu/sh2a/pinmux-sh7269.c            | 2823 +------------------
 arch/sh/kernel/cpu/sh3/pinmux-sh7720.c             | 1226 +--------
 arch/sh/kernel/cpu/sh4a/pinmux-sh7722.c            | 1778 +-----------
 arch/sh/kernel/cpu/sh4a/pinmux-sh7723.c            | 1893 +------------
 arch/sh/kernel/cpu/sh4a/pinmux-sh7724.c            | 2210 +--------------
 arch/sh/kernel/cpu/sh4a/pinmux-sh7734.c            | 2470 +----------------
 arch/sh/kernel/cpu/sh4a/pinmux-sh7757.c            | 2267 +---------------
 arch/sh/kernel/cpu/sh4a/pinmux-sh7785.c            | 1294 +--------
 arch/sh/kernel/cpu/sh4a/pinmux-sh7786.c            |  822 +-----
 arch/sh/kernel/cpu/sh4a/pinmux-shx3.c              |  573 +---
 drivers/pinctrl/Kconfig                            |    2 +-
 drivers/pinctrl/Makefile                           |    2 +
 drivers/pinctrl/sh-pfc/Kconfig                     |  116 +
 drivers/pinctrl/sh-pfc/Makefile                    |   21 +
 drivers/pinctrl/sh-pfc/core.c                      |  635 +++++
 drivers/pinctrl/sh-pfc/core.h                      |   72 +
 drivers/pinctrl/sh-pfc/gpio.c                      |  178 ++
 .../pinctrl/sh-pfc}/pfc-r8a7740.c                  |   11 +-
 .../pinctrl/sh-pfc}/pfc-r8a7779.c                  |   29 +-
 drivers/pinctrl/sh-pfc/pfc-sh7203.c                | 1592 +++++++++++
 drivers/pinctrl/sh-pfc/pfc-sh7264.c                | 2131 +++++++++++++++
 drivers/pinctrl/sh-pfc/pfc-sh7269.c                | 2834 ++++++++++++++++++++
 .../pinctrl/sh-pfc}/pfc-sh7372.c                   |   11 +-
 .../pinctrl/sh-pfc}/pfc-sh73a0.c                   |   11 +-
 drivers/pinctrl/sh-pfc/pfc-sh7720.c                | 1236 +++++++++
 drivers/pinctrl/sh-pfc/pfc-sh7722.c                | 1779 ++++++++++++
 drivers/pinctrl/sh-pfc/pfc-sh7723.c                | 1903 +++++++++++++
 drivers/pinctrl/sh-pfc/pfc-sh7724.c                | 2225 +++++++++++++++
 drivers/pinctrl/sh-pfc/pfc-sh7734.c                | 2475 +++++++++++++++++
 drivers/pinctrl/sh-pfc/pfc-sh7757.c                | 2282 ++++++++++++++++
 drivers/pinctrl/sh-pfc/pfc-sh7785.c                | 1304 +++++++++
 drivers/pinctrl/sh-pfc/pfc-sh7786.c                |  837 ++++++
 drivers/pinctrl/sh-pfc/pfc-shx3.c                  |  582 ++++
 drivers/{sh/pfc => pinctrl/sh-pfc}/pinctrl.c       |  164 +-
 {include/linux => drivers/pinctrl/sh-pfc}/sh_pfc.h |   43 +-
 drivers/sh/Kconfig                                 |    1 -
 drivers/sh/Makefile                                |    1 -
 drivers/sh/pfc/Kconfig                             |   26 -
 drivers/sh/pfc/Makefile                            |    3 -
 drivers/sh/pfc/core.c                              |  572 ----
 drivers/sh/pfc/gpio.c                              |  240 --
 57 files changed, 22494 insertions(+), 22099 deletions(-)
