Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759121Ab3EGR0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 13:26:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53209 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310Ab3EGR0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 13:26:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 1/5] ARM: arm-soc platform updates for 3.10, part 2
Date: Tue,  7 May 2013 19:26:10 +0200
Message-Id: <1367947574-2934383-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367947574-2934383-1-git-send-email-arnd@arndb.de>
References: <1367947574-2934383-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:eHek3DJmGRfh6k6DN2VfKiMtVs1+7Mdc0+0+YdURucM
 S71iFsaVQLrj1XAlH60PcPrddubo5jxwwNzOnBa/PpdLFj4iXB
 KRvhG+WS3TeuzdPK75Zq9j+U9oyexCd8PTVfjIMx+BsxQRFd89
 A6nVMgZgq8p4+y5Fk9zKvS7tNAHQkGIC5pXng/atEu6OVxeVAw
 BOuEdOtwAI9OoGhceFWO+IcYh8NcuorUczG1htQeJs/C1c5OtU
 YSsRnHxBI3sfd3QhIkQQ/xXnl2zBYZVJdDGXGYTIHoIbV3xpKD
 dj4J0vJedTEEOUKAmH7vUdaj3XLgbtj+hSM92s/PsXqXGjE1lh
 Ep/Y47O+Q1oKrCy9IBS7wRwAC0fv1K/5OU22VQfh0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are all for Renesas shmobile, and depend on the earlier
pinctrl updates. Remarkably, this adds support for three new SoCs:
r8a73a4, r8a73a4 and r8a7778. The bulk of the code added for these is
for pinctrl (using the new subsystem) and for clocks (not yet using the
common clock subsystem). The latter will have to get converted in one
of the upcoming releases, but shmobile is not ready for that yet.

The series also contains Renesas shmobile board changes, adding one
board file for each of the three new SoCs.  These boards are using a
mix of classic and device-tree based probing, as there is still a lot of
infrastructure in shmobile that has not been converted to DT yet. Once
those are resolved to the degree that no board specific setup code is
needed, they can get folded into the respective SoC setup files.

Conflicts:
- A line added in board-armadillo800eva.c conflicts with a
  changed line.


-------------------------------------------------------------

The following changes since commit

   150a8dc Merge tag 'boards-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc

are available in the git repository at

   git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/soc-for-linus-2

you to fetch changes up to

   9251c6c Merge tag 'renesas-boards-lager-for-v3.10' of git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas into next/boards2


-------------------------------------------------------------

Arnd Bergmann (3):
      Merge tag 'renesas-defconfig-bockw-for-v3.10' of git://git.kernel.org/.../horms/renesas into next/boards2
      Merge tag 'renesas-boards-bockw-for-v3.10' of git://git.kernel.org/.../horms/renesas into next/boards2
      Merge tag 'soc-for-linus-2' into for-next

Bastian Hecht (1):
      ARM: shmobile: r8a7740: Migrate from INTC to GIC

Guennadi Liakhovetski (9):
      ARM: shmobile: sh73a0: wait for completion when kicking the clock
      ARM: shmobile: sh73a0: add irqpin DT nodes
      ARM: shmobile: sh73a0: add a TWD clock
      ARM: shmobile: kzm9g-reference: add ethernet support
      ARM: shmobile: mackerel: SDHI resources do not have to be numbered
      ARM: shmobile: mackerel: remove OCR masks, where regulators are used
      ARM: shmobile: mackerel: switch SDHI and MMCIF interfaces to slot-gpio
      ARM: shmobile: mackerel: add interrupt names for SDHI0
      ARM: shmobile: mackerel: clean up MMCIF vs. SDHI1 selection

Kuninori Morimoto (21):
      ARM: shmobile: add R8A7778 basis support
      ARM: shmobile: r8a7778 SCIF support
      ARM: shmobile: r8a73a4: add thermal driver support
      ARM: shmobile: sh73a0: remove DIV4_ZT* clocks
      ARM: shmobile: sh7372: remove DIV4_ZT* clocks
      ARM: shmobile: add struct clk_ratio and fixed ratio clock macro
      ARM: shmobile: sh7372: use fixed ratio clock
      ARM: shmobile: sh73a0: use fixed ratio clock
      ARM: shmobile: r8a7740: tidyup comment/implementation mismatch
      ARM: shmobile: r8a7740: use fixed ratio clock
      ARM: shmobile: r8a7779: remove DIV4 clocks and use fixed ratio clock
      ARM: shmobile: sh7372: move global functions to sh7372.h
      ARM: shmobile: sh73a0: move global functions to sh73a0.h
      ARM: shmobile: r8a7740: move global functions to r8a7740.h
      ARM: shmobile: r8a7779: move global functions to r8a7779.h
      ARM: shmobile: add R-Car M1A Bock-W platform support
      ARM: shmobile: r8a7778: remove pointless PLATFORM_INFO()
      ARM: shmobile: r8a7778: add r8a7778_init_irq_extpin()
      ARM: shmobile: bockw: enable SMSC ethernet on defconfig
      ARM: shmobile: bockw: add SMSC ethernet support
      ARM: shmobile: bockw: enable network settings on bootargs

Laurent Pinchart (14):
      sh-pfc: Fix compiler warning when BUG()
      sh: sh7269: Fix compilation by adding missing includes
      sh-pfc: r8a7779: Remove function GPIOs
      sh-pfc: r8a7779: Don't use GPIO enum entries
      ARM: shmobile: r8a7779: Remove all GPIOs
      gpio-rcar: Add pinctrl support
      ARM: shmobile: marzen: Add GPIO LEDs
      sh-pfc: Make function GPIOs support optional
      sh-pfc: Make GPIO support optional
      sh-pfc: Skip gpiochip registration when no GPIO resource is found
      sh-pfc: Configure pins as GPIOs at request time when handled externally
      ARM: shmobile: r8a7779: Register GPIO devices
      sh-pfc: r8a7779: Remove GPIO data
      sh-pfc: r8a7779: Split DU input and output pixel clocks

Magnus Damm (30):
      ARM: shmobile: Initial r8a73a4 SoC support V3
      ARM: shmobile: r8a73a4 SCIF support V3
      ARM: shmobile: r8a73a4 IRQC support V2
      ARM: shmobile: r8a73a4 PFC support
      ARM: shmobile: Disallow PINCTRL without GPIOLIB
      ARM: shmobile: Initial r8a7790 SoC support
      ARM: shmobile: r8a7790 SCIF support
      ARM: shmobile: r8a7790 IRQC support
      ARM: shmobile: r8a7790 PFC support
      gpio: Renesas R-Car GPIO driver V3
      sh-pfc: Add r8a73a4 pinmux support
      sh-pfc: r8a73a4: Support sparse GPIO numbers
      sh-pfc: r8a73a4: GPIO IRQ support
      sh-pfc: r8a73a4: Add bias (pull-up/down) pinconf support
      sh-pfc: r8a73a4: Add SCIF pin groups and functions
      sh-pfc: r8a73a4: Add IRQC pin groups and functions
      sh-pfc: r8a73a4: Remove SCIF function GPIOS
      sh-pfc: r8a73a4: Remove IRQC function GPIOS
      ARM: shmobile: r8a73a4: Remove SCIF function GPIOs
      ARM: shmobile: r8a73a4: Remove IRQC function GPIOs
      sh-pfc: r8a73a4: Remove function GPIOs
      ARM: shmobile: r8a73a4: Remove all GPIO enums
      sh-pfc: r8a73a4: Remove unused GPIO bias data
      ARM: shmobile: APE6EVM base support
      ARM: shmobile: APE6EVM PFC support
      ARM: shmobile: APE6EVM LAN9220 support
      ARM: shmobile: Initial r8a7790 Lager board support
      ARM: shmobile: Add second I/O range for r8a7790 PFC
      ARM: shmobile: force enable of r8a7790 arch timer
      ARM: shmobile: use r8a7790 timer setup code on Lager

Olof Johansson (2):
      Merge tag 'renesas-boards3-for-v3.10' of git://git.kernel.org/.../horms/renesas into next/boards2
      Merge tag 'renesas-boards-lager-for-v3.10' of git://git.kernel.org/.../horms/renesas into next/boards2

Sergei Shtylyov (1):
      ARM: shmobile: R8A7778: add Ether support

Simon Horman (5):
      Merge tag 'renesas-intc-external-irq2-for-v3.10' into soc-base
      Merge branch 'soc' into pinmux-base
      Merge tag 'renesas-pinmux2-for-v3.10' into boards-base
      Merge branch 'soc-r8a7778' into boards-bockw-base
      Merge branch 'soc-r8a7790' into boards-lager

Takashi YOSHII (2):
      ARM: shmobile: r8a73a4 SoC 64-bit DT support
      ARM: shmobile: r8a7790 SoC 64-bit DT support

 arch/arm/Kconfig                               |    2 +-
 arch/arm/boot/dts/Makefile                     |    3 +
 arch/arm/boot/dts/r8a73a4-ape6evm.dts          |   52 +
 arch/arm/boot/dts/r8a73a4.dtsi                 |   94 +
 arch/arm/boot/dts/r8a7778-bockw.dts            |   32 +
 arch/arm/boot/dts/r8a7778.dtsi                 |   35 +
 arch/arm/boot/dts/r8a7790-lager.dts            |   31 +
 arch/arm/boot/dts/r8a7790.dtsi                 |   63 +
 arch/arm/boot/dts/sh73a0-kzm9g-reference.dts   |   13 +
 arch/arm/boot/dts/sh73a0.dtsi                  |   81 +
 arch/arm/configs/bockw_defconfig               |   94 +
 arch/arm/mach-shmobile/Kconfig                 |   48 +-
 arch/arm/mach-shmobile/Makefile                |    6 +
 arch/arm/mach-shmobile/board-ape6evm.c         |   94 +
 arch/arm/mach-shmobile/board-armadillo800eva.c |   35 +-
 arch/arm/mach-shmobile/board-bockw.c           |   81 +
 arch/arm/mach-shmobile/board-lager.c           |   46 +
 arch/arm/mach-shmobile/board-mackerel.c        |  111 +-
 arch/arm/mach-shmobile/board-marzen.c          |   32 +
 arch/arm/mach-shmobile/clock-r8a73a4.c         |  115 ++
 arch/arm/mach-shmobile/clock-r8a7740.c         |  114 +-
 arch/arm/mach-shmobile/clock-r8a7778.c         |  107 +
 arch/arm/mach-shmobile/clock-r8a7779.c         |  196 +-
 arch/arm/mach-shmobile/clock-r8a7790.c         |   93 +
 arch/arm/mach-shmobile/clock-sh7372.c          |   50 +-
 arch/arm/mach-shmobile/clock-sh73a0.c          |  115 +-
 arch/arm/mach-shmobile/clock.c                 |   13 +
 arch/arm/mach-shmobile/include/mach/clock.h    |   39 +
 arch/arm/mach-shmobile/include/mach/common.h   |   54 -
 arch/arm/mach-shmobile/include/mach/r8a73a4.h  |    8 +
 arch/arm/mach-shmobile/include/mach/r8a7740.h  |    9 +
 arch/arm/mach-shmobile/include/mach/r8a7778.h  |   32 +
 arch/arm/mach-shmobile/include/mach/r8a7779.h  |  330 +--
 arch/arm/mach-shmobile/include/mach/r8a7790.h  |    9 +
 arch/arm/mach-shmobile/include/mach/sh7372.h   |   12 +
 arch/arm/mach-shmobile/include/mach/sh73a0.h   |   15 +
 arch/arm/mach-shmobile/intc-r8a7740.c          |  641 +-----
 arch/arm/mach-shmobile/setup-r8a73a4.c         |  202 ++
 arch/arm/mach-shmobile/setup-r8a7740.c         |  192 +-
 arch/arm/mach-shmobile/setup-r8a7778.c         |  244 +++
 arch/arm/mach-shmobile/setup-r8a7779.c         |   58 +-
 arch/arm/mach-shmobile/setup-r8a7790.c         |  150 ++
 arch/sh/kernel/cpu/sh2a/pinmux-sh7269.c        |    2 +
 drivers/gpio/Kconfig                           |    6 +
 drivers/gpio/Makefile                          |    1 +
 drivers/gpio/gpio-rcar.c                       |  396 ++++
 drivers/pinctrl/sh-pfc/Kconfig                 |    5 +
 drivers/pinctrl/sh-pfc/Makefile                |    1 +
 drivers/pinctrl/sh-pfc/core.c                  |   41 +-
 drivers/pinctrl/sh-pfc/core.h                  |    1 +
 drivers/pinctrl/sh-pfc/gpio.c                  |   45 +-
 drivers/pinctrl/sh-pfc/pfc-r8a73a4.c           | 2587 ++++++++++++++++++++++++
 drivers/pinctrl/sh-pfc/pfc-r8a7740.c           |   64 +-
 drivers/pinctrl/sh-pfc/pfc-r8a7779.c           |  479 +----
 drivers/pinctrl/sh-pfc/pinctrl.c               |   11 +
 include/linux/platform_data/gpio-rcar.h        |   26 +
 56 files changed, 5588 insertions(+), 1828 deletions(-)
