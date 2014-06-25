Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbaFYStZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:49:25 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:53624 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbaFYStX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:49:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, shawn.guo@freescale.com,
        kgene.kim@samsung.com, jason@lakedaemon.net, galak@codeaurora.org,
        nicolas.ferre@atmel.com, maxime.coquelin@st.com
Subject: ARM: SoC fixes
Date: Wed, 25 Jun 2014 20:48:29 +0200
Message-ID: <6894576.0h2zQsBMRF@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:b549IJlcRyjsAjnGhw/oe2+W9W9zXtgqH3gZmIf/e0S
 tMXSVQQyzsCFn1bdJtR58zoHTotoRmph2IYkDIvktGPi0JBIwS
 hfWKl9da9VLQFBZ0TA7SUjZOOkdwuAe7Tul22R1gZSoC9Q1q+X
 MlcwWm1ppPKQoW2N9T3IPtmaqwY4VFSN4g9z81mrR6ynaVBmR1
 Qu0kftKnCthow4rRIGYTa3WcJAUx8tcwIy/EoPz8evjtz9gZbk
 uCADb87wY++e59uDJWKsEt3fvExplrf9CCfvaJjjrcz/PUZm9A
 4ZzgGpCkO5cMO6lUDaT1viE+pgaMl0LDqLu+0ZYaw3eAk7xhjJ
 MD4znsz+HRGXTAi9yl78=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 21278aeafbfacfd62b3e613525f0c694a029dac1:

  ARM: use menuconfig for sub-arch menus (2014-06-17 17:09:48 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to 6c9d16178870315846faa1f59697b801e3fe0531:

  Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into fixes (2014-06-25 20:27:15 +0200)

----------------------------------------------------------------

ARM: SoC fixes for 3.16

A new set of bug fixes for 3.16, containing patches for seven platforms:

at91:
    - drivers/misc fix for Kconfig PWM symbol
    - correction of several values in DT after conversion to CCF
    - fix at91sam9261/at91sam9261ek mistake in slow crystal vs. slow RC osc

imx:
    - Use GPIO for card CD/WP on imx51-babbage and eukrea-mbimxsd51,
      because controller base CD/WP is not working in esdhc driver due to
      runtime PM support
    - A couple of random ventana gw5xxx board fixes
    - Add IMX_IPUV3_CORE back to defconfig, which gets lost when moving
      IPUv3 driver out of staging tree
    - Fix enet/fec clock selection on imx6sl
    - Fix display node on imx53-m53evk board
    - A couple of Cubox-i updates from Russell, which were omitted from
      the merge window due to dependency

integrator:
    - fix an OF-related regression against 3.15

mvebu:
    - mvebu (v7)
       - Fix broken SoC ID detection
       - Select ARM_CPU_SUSPEND for v7
       - Remove armada38x compatible string (no users yet)
       - Enable Dove SoC in mvebu_v7_defconfig
    - kirkwood
       - Fix phy-connection-type on GuruPlug board

qcom:
    - enable gsbi driver in defconfig
    - fix section mismatch warning in serial driver

samsung:
    - use WFI macro in platform_do_lowpower because exynos cpuhotplug
      includes a hardcoded WFI instruction and it causes compile error
      in Thumb-2 mode.
    - fix GIC reg sizes for exynos4 SoCs
    - remove reset timer counter value during boot and resume for mct
      to fix a big jump in printk timestamps
    - fix pm code to check cortex-A9 for another exynos SoCs
    - don't rely on firmware's secondary_cpu_start for mcpm

sti:
    - Ethernet clocks were wrongly defined for STiH415/416 platforms
    - STiH416 B2020 revision E DTS file name contained uppercase, change to
      lowercase.

----------------------------------------------------------------
Abhilash Kesavan (1):
      ARM: EXYNOS: fix pm code to check for cortex A9 rather than the SoC

Alexandre Belloni (5):
      ARM: at91/dt: sam9x5: correct PLLA ICPLL and OUT values
      ARM: at91/dt: sam9n12: correct PLLA ICPLL and OUT values
      ARM: at91/dt: sam9261: correctly define mainck
      ARM: at91/dt: define sam9261ek slow crystal frequency
      ARM: at91/dt: sam9261: remove slow RC osc

Arnd Bergmann (5):
      Merge tag 'sti-fixes-for-v3.16-rc1' of git://git.stlinux.com/devel/kernel/linux-sti into fixes
      Merge tag 'samsung-fixes-1' of git://git.kernel.org/.../kgene/linux-samsung into fixes
      Merge tag 'imx-fixes-3.16' of git://git.kernel.org/.../shawnguo/linux into fixes
      Merge tag 'mvebu-fixes-3.16' of git://git.infradead.org/linux-mvebu into fixes
      Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into fixes

Chirantan Ekbote (1):
      clocksource: exynos_mct: Don't reset the counter during boot and resume

Denis Carikli (1):
      ARM: dts: imx51-eukrea-mbimxsd51-baseboard: unbreak esdhc.

Doug Anderson (1):
      ARM: EXYNOS: Don't rely on firmware's secondary_cpu_start for mcpm

Ezequiel Garcia (2):
      ARM: mvebu: enable Dove SoC in mvebu_v7_defconfig
      ARM: mvebu: Fix broken SoC ID detection

Fabio Estevam (1):
      ARM: imx_v6_v7_defconfig: Enable CONFIG_IMX_IPUV3_CORE

Fugang Duan (2):
      ARM: imx6sl: add missing enet clock for imx6sl
      ARM: dts: imx6sl: correct the fec ipg clock source

Gregory CLEMENT (1):
      ARM: mvebu: Fix the improper use of the compatible string armada38x using a wildcard

Kumar Gala (1):
      tty: serial: msm: Fix section mismatch warning

Lee Jones (1):
      ARM: stih41x: Rename stih416-b2020-revE.dts to stih416-b2020e.dts

Leela Krishna Amudala (1):
      ARM: EXYNOS: Use wfi macro in platform_do_lowpower

Linus Walleij (1):
      ARM: integrator: fix OF-related regression

Marek Vasut (2):
      ARM: dts: mx5: Fix IPU port node placement
      ARM: dts: mx5: Move the display out of soc {} node

Nicolas Ferre (1):
      misc: atmel_pwm: fix Kconfig symbols

Peter Griffin (1):
      ARM: STi: DT: Properly define sti-ethclk & stmmaceth for stih415/6

Philipp Zabel (1):
      ARM: dts: imx6qdl-gw5xxx: Fix Linear Technology vendor prefix

Russell King (2):
      ARM: dts: cubox-i: add support for PWM-driven front panel LED
      ARM: dts: hummingboard/cubox-i: move usb otg configuration to platform level

Sascha Hauer (1):
      ARM: dts: imx51-babbage: Fix esdhc setup

Sebastian Hesselbarth (1):
      ARM: dts: kirkwood: fix phy-connection-type for Guruplug

Srinivas Kandagatla (1):
      ARM: multi_v7_defconfig: Add QCOM GSBI driver

Thomas Petazzoni (1):
      ARM: mvebu: select ARM_CPU_SUSPEND for Marvell EBU v7 platforms

Tim Harvey (2):
      ARM: dts: imx6: ventana: fix include typo
      ARM: dts: imx6: ventana: correct gw52xx sgtl5000 clock source

Tomasz Figa (1):
      ARM: dts: fix reg sizes of GIC for exynos4

 .../devicetree/bindings/arm/armada-38x.txt         | 14 ++++++--
 arch/arm/boot/dts/Makefile                         |  2 +-
 arch/arm/boot/dts/armada-380.dtsi                  |  2 +-
 arch/arm/boot/dts/armada-385-db.dts                |  2 +-
 arch/arm/boot/dts/armada-385-rd.dts                |  2 +-
 arch/arm/boot/dts/armada-385.dtsi                  |  2 +-
 arch/arm/boot/dts/armada-38x.dtsi                  |  2 +-
 arch/arm/boot/dts/at91sam9261.dtsi                 | 21 ++++--------
 arch/arm/boot/dts/at91sam9261ek.dts                |  4 +++
 arch/arm/boot/dts/at91sam9n12.dtsi                 |  4 +--
 arch/arm/boot/dts/at91sam9x5.dtsi                  |  4 +--
 arch/arm/boot/dts/exynos4.dtsi                     |  2 +-
 arch/arm/boot/dts/imx51-babbage.dts                | 10 +++---
 .../boot/dts/imx51-eukrea-mbimxsd51-baseboard.dts  |  4 +--
 arch/arm/boot/dts/imx53-m53evk.dts                 | 40 ++++++++++------------
 arch/arm/boot/dts/imx6dl-hummingboard.dts          | 10 ++++++
 arch/arm/boot/dts/imx6q-gw51xx.dts                 |  2 +-
 arch/arm/boot/dts/imx6qdl-cubox-i.dtsi             | 27 +++++++++++++++
 arch/arm/boot/dts/imx6qdl-gw51xx.dtsi              |  2 +-
 arch/arm/boot/dts/imx6qdl-gw52xx.dtsi              |  4 +--
 arch/arm/boot/dts/imx6qdl-gw53xx.dtsi              |  2 +-
 arch/arm/boot/dts/imx6qdl-microsom.dtsi            | 13 -------
 arch/arm/boot/dts/imx6sl.dtsi                      |  2 +-
 .../arm/boot/dts/kirkwood-guruplug-server-plus.dts |  4 +--
 arch/arm/boot/dts/stih415.dtsi                     |  8 ++---
 .../{stih416-b2020-revE.dts => stih416-b2020e.dts} |  0
 arch/arm/boot/dts/stih416.dtsi                     |  8 ++---
 arch/arm/configs/imx_v6_v7_defconfig               |  1 +
 arch/arm/configs/multi_v7_defconfig                |  1 +
 arch/arm/configs/mvebu_v7_defconfig                |  2 ++
 arch/arm/mach-exynos/hotplug.c                     |  8 +----
 arch/arm/mach-exynos/mcpm-exynos.c                 | 11 +++---
 arch/arm/mach-exynos/pm.c                          | 15 ++++----
 arch/arm/mach-imx/clk-imx6sl.c                     |  1 +
 arch/arm/mach-integrator/integrator_ap.c           | 26 ++++----------
 arch/arm/mach-integrator/integrator_cp.c           | 23 ++++---------
 arch/arm/mach-mvebu/Kconfig                        |  2 ++
 drivers/clocksource/exynos_mct.c                   |  9 ++---
 drivers/misc/Kconfig                               |  2 +-
 drivers/tty/serial/msm_serial.c                    |  2 +-
 include/dt-bindings/clock/imx6sl-clock.h           |  3 +-
 include/dt-bindings/clock/stih415-clks.h           |  1 +
 include/dt-bindings/clock/stih416-clks.h           |  1 +
 43 files changed, 158 insertions(+), 147 deletions(-)

