Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822Ab3EGQCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 12:02:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58643 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758536Ab3EGQCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 12:02:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL] ARM: arm-soc platform updates for 3.10, part 3
Date: Tue,  7 May 2013 18:02:11 +0200
Message-Id: <1367942534-2934003-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367942534-2934003-1-git-send-email-arnd@arndb.de>
References: <1367942534-2934003-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:O5qm6qdM93qKKMCqNWYaf7pTiO7sWvoPuZ2k214ULtI
 CXngApBZz3X8Z6gNK737C2Bl+XpmpBBMe+rqvXzdSAbbvHzFRx
 KcIMtHjEFVT6yoZR12FtPXU5obasUuzQvevE/QixGgGWDSUubC
 hz6zmHoJ7KDqKd3yM7/lowPJFqpzqBHXWdbHeHT4vxjQBubi7t
 0rhlbBke3o6tZDTbZItVOAVg4X0votX7zLjkctKx+gMBt34Fys
 CfUtCmMyw1StpPy6Ny0sKrkc/HO8Cq2UmAgCJ99jG5kf5kGncg
 CekvfoZ2j3m6tfYdhCOHLyyL3cSpAwDRHUWAPqNPu10MLQPe4a
 EVYt4sfEDfH94jwyza8y+8TiFlZ+qD9OBoZ2PPrlX
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the third and smallest of the SoC specific updates.
Changes include:

* SMP support for the Xilinx zynq platform
* Smaller imx changes
* LPAE support for mvebu
* Moving the orion5x, kirkwood, dove and mvebu platforms
  to a common "mbus" driver for their internal devices.

It would be good to get feedback on the location of the "mbus"
driver. Since this is used on multiple platforms may potentially
get shared with other architectures (powerpc and arm64), it
was moved to drivers/bus/. We expect other similar drivers to
get moved to the same place in order to avoid creating more
top-level directories under drivers/ or cluttering up the
messy drivers/misc/ even more.

Conflicts:
 - drivers/gpio/gpio-pl061.c had a trivial add/add conflict that
   got resolved in two different ways, both of which are ok.


-------------------------------------------------------------

The following changes since commit

   48f934c Merge tag 'soc-for-linus-2' into for-next

are available in the git repository at

   git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/soc-for-linus-3

you to fetch changes up to

   5c5f042 ARM: imx: reset_controller may be disabled

-------------------------------------------------------------

Anson Huang (3):
      ARM: imx: enable anatop suspend/resume
      ARM: imx: enable periphery well bias for suspend
      ARM: imx: enable RBC to support anatop LPM mode

Arnd Bergmann (6):
      Merge branch 'zynq/core-smp' of git://git.xilinx.com/linux-xlnx into next/soc2
      Merge branch 'gic/cleanup' into next/soc2
      Merge tag 'renesas-soc-r8a7779-for-v3.10' of git://git.kernel.org/.../horms/renesas into next/soc2
      Merge tag 'renesas-soc-r8a7778-for-v3.10' of git://git.kernel.org/.../horms/renesas into next/soc2
      ARM: imx: reset_controller may be disabled
      Merge tag 'soc-for-linus-3' into for-next

Fabio Estevam (3):
      ARM: mach-imx: anatop: Include "common.h"
      ARM: imx_v6_v7_defconfig: Select CONFIG_PERF_EVENTS
      ARM: imx_v4_v5_defconfig: Add CONFIG_GPIO_SYSFS

Gregory CLEMENT (1):
      ARM: mvebu: Limit the DMA zone when LPAE is selected

Gwenhael Goavec-Merou (1):
      ARM: imx1: mm: add call to mxc_device_init

Jason Cooper (2):
      Merge tag 'tags/cleanup_for_v3.10' into mvebu/soc
      Merge tag 'tags/drivers_for_v3.10' into mvebu/soc

Kuninori Morimoto (2):
      ARM: shmobile: r8a7779: add each clocks ratio on comment area
      sh-pfc: r8a7779: tidyup intc_irq3_b typo

Lior Amsalem (1):
      ARM: mvebu: Align the internal registers virtual base to support LPAE

Markus Pargmann (1):
      ARM: imx27, imx5: Add kconfig selects for cpufreq-cpu0

Martin Fuzzey (1):
      ARM: i.MX53 Add the cko1, cko2 clock outputs.

Michal Simek (7):
      arm: zynq: Load scu baseaddress at run time
      arm: zynq: Move slcr initialization to separate file
      arm: zynq: Add support for system reset
      arm: zynq: Get rid of xilinx function prefix
      arm: zynq: Add smp_twd timer
      arm: zynq: Add smp support
      arm: zynq: Add hotplug support

Neil Greatorex (1):
      bus: mvebu-mbus: Restore checking for coherency fabric hardware

Olof Johansson (6):
      Merge tag 'renesas-soc2-for-v3.10' of git://git.kernel.org/.../horms/renesas into next/soc2
      Merge tag 'renesas-pinmux2-for-v3.10' of git://git.kernel.org/.../horms/renesas into next/soc2
      Merge tag 'renesas-pinmux-fixes-for-v3.10' of git://git.kernel.org/.../horms/renesas into next/soc2
      Merge tag 'renesas-soc-r8a7790-for-v3.10' of git://git.kernel.org/.../horms/renesas into next/soc2
      Merge tag 'imx-soc-3.10' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/soc2
      Merge tag 'soc_for_v3.10' of git://git.infradead.org/users/jcooper/linux into next/soc2

Philipp Zabel (14):
      ARM i.MX53: Add GPU clocks to clock tree
      ARM i.MX6q: export imx6q_revision
      ARM i.MX: Add imx_clk_divider_flags and imx_clk_mux_flags
      ARM i.MX53: fix ldb di divider and selector clocks
      ARM i.MX6q: fix ldb di divider and selector clocks
      ARM i.MX6q: Add audio/video PLL post dividers for i.MX6q rev 1.1
      ARM i.MX6q: set the LDB serial clock parent to the video PLL
      ARM i.MX6q: Add GPU, VPU, IPU, and OpenVG resets to System Reset Controller (SRC)
      staging: drm/imx: Use SRC to reset IPU
      ARM i.MX5: Remove tve_sel clock from i.MX53 clock tree
      ARM i.MX53: Remove unused tve_gate clkdev entry
      ARM i.MX53: make tve_ext_sel propagate rate change to PLL
      ARM i.MX53: tve_di clock is not part of the CCM, but of TVE
      ARM i.MX53: set CLK_SET_RATE_PARENT flag on the tve_ext_sel clock

Sascha Hauer (1):
      ARM: i.MX5: Add PATA and SRTC clocks

Sergei Shtylyov (1):
      ARM: shmobile: R8A7779: add Ether support

Shawn Guo (6):
      Merge tag 'imx-fixes-3.9-5' into imx/soc
      Merge tag 'imx-cleanup-3.10' into imx/soc
      Merge remote-tracking branch 'pza/reset/for_v3.10' into imx/soc
      ARM: imx: do not use regmap_read for ANADIG_DIGPROG
      ARM: imx: add initial imx6dl support
      ARM: imx: do not bring up unavailable cores

Simon Guinot (1):
      ARM: Orion: add dbg_show function to gpio-orion driver

Thomas Petazzoni (8):
      bus: introduce an Marvell EBU MBus driver
      bus: mvebu: fix mistake in PCIe window target attribute for Kirkwood
      arm: mach-mvebu: convert to use mvebu-mbus driver
      arm: mach-kirkwood: convert to use mvebu-mbus driver
      arm: mach-dove: convert to use mvebu-mbus driver
      arm: mach-orion5x: convert to use mvebu-mbus driver
      arm: mach-mv78xx0: convert to use the mvebu-mbus driver
      arm: plat-orion: remove addr-map code

 .../devicetree/bindings/clock/imx5-clock.txt       |  14 +-
 .../devicetree/bindings/clock/imx6q-clock.txt      |   3 +
 .../devicetree/bindings/reset/fsl,imx-src.txt      |  49 ++
 .../bindings/staging/imx-drm/fsl-imx-drm.txt       |   3 +
 arch/arm/Kconfig                                   |   4 +
 arch/arm/Kconfig.debug                             |   4 +-
 arch/arm/boot/dts/armada-370-xp.dtsi               |   5 -
 arch/arm/boot/dts/zynq-7000.dtsi                   |   7 +
 arch/arm/configs/imx_v4_v5_defconfig               |   1 +
 arch/arm/configs/imx_v6_v7_defconfig               |   1 +
 arch/arm/include/debug/mvebu.S                     |   2 +-
 arch/arm/mach-dove/Makefile                        |   2 +-
 arch/arm/mach-dove/addr-map.c                      | 125 ---
 arch/arm/mach-dove/board-dt.c                      |   2 +-
 arch/arm/mach-dove/common.c                        |  39 +-
 arch/arm/mach-dove/common.h                        |   2 +-
 arch/arm/mach-dove/include/mach/dove.h             |   5 +
 arch/arm/mach-imx/Kconfig                          |  10 +-
 arch/arm/mach-imx/Makefile                         |   1 +
 arch/arm/mach-imx/anatop.c                         | 103 +++
 arch/arm/mach-imx/clk-imx51-imx53.c                |  75 +-
 arch/arm/mach-imx/clk-imx6q.c                      | 126 ++-
 arch/arm/mach-imx/clk.h                            |  17 +
 arch/arm/mach-imx/common.h                         |  10 +-
 arch/arm/mach-imx/gpc.c                            |  23 +-
 arch/arm/mach-imx/mach-imx6q.c                     |  74 +-
 arch/arm/mach-imx/mm-imx1.c                        |   2 +
 arch/arm/mach-imx/mxc.h                            |  11 +
 arch/arm/mach-imx/platsmp.c                        |   4 +-
 arch/arm/mach-imx/pm-imx6q.c                       |   4 +-
 arch/arm/mach-imx/src.c                            |  66 ++
 arch/arm/mach-kirkwood/Makefile                    |   2 +-
 arch/arm/mach-kirkwood/addr-map.c                  |  91 ---
 arch/arm/mach-kirkwood/board-dt.c                  |   2 +-
 arch/arm/mach-kirkwood/common.c                    |  38 +-
 arch/arm/mach-kirkwood/common.h                    |   2 +-
 arch/arm/mach-kirkwood/include/mach/kirkwood.h     |   7 +-
 arch/arm/mach-kirkwood/pcie.c                      |   1 -
 arch/arm/mach-mv78xx0/Makefile                     |   2 +-
 arch/arm/mach-mv78xx0/addr-map.c                   |  93 ---
 arch/arm/mach-mv78xx0/common.c                     |  10 +-
 arch/arm/mach-mv78xx0/include/mach/mv78xx0.h       |   9 +-
 arch/arm/mach-mv78xx0/pcie.c                       |  21 +-
 arch/arm/mach-mvebu/Kconfig                        |   2 +
 arch/arm/mach-mvebu/Makefile                       |   2 +-
 arch/arm/mach-mvebu/addr-map.c                     | 137 ----
 arch/arm/mach-mvebu/armada-370-xp.c                |  18 +
 arch/arm/mach-mvebu/armada-370-xp.h                |   8 +-
 arch/arm/mach-mvebu/platsmp.c                      |   2 +
 arch/arm/mach-orion5x/Makefile                     |   2 +-
 arch/arm/mach-orion5x/addr-map.c                   | 155 ----
 arch/arm/mach-orion5x/board-dt.c                   |   2 +-
 arch/arm/mach-orion5x/common.c                     |  49 +-
 arch/arm/mach-orion5x/common.h                     |  13 +-
 arch/arm/mach-orion5x/d2net-setup.c                |   4 +-
 arch/arm/mach-orion5x/db88f5281-setup.c            |  13 +-
 arch/arm/mach-orion5x/dns323-setup.c               |   3 +-
 arch/arm/mach-orion5x/edmini_v2-setup.c            |   4 +-
 arch/arm/mach-orion5x/include/mach/orion5x.h       |   6 +-
 arch/arm/mach-orion5x/kurobox_pro-setup.c          |   8 +-
 arch/arm/mach-orion5x/ls-chl-setup.c               |   4 +-
 arch/arm/mach-orion5x/ls_hgl-setup.c               |   4 +-
 arch/arm/mach-orion5x/lsmini-setup.c               |   4 +-
 arch/arm/mach-orion5x/mss2-setup.c                 |   3 +-
 arch/arm/mach-orion5x/mv2120-setup.c               |   3 +-
 arch/arm/mach-orion5x/net2big-setup.c              |   4 +-
 arch/arm/mach-orion5x/pci.c                        |   7 +-
 arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c       |   4 +-
 arch/arm/mach-orion5x/rd88f5181l-ge-setup.c        |   4 +-
 arch/arm/mach-orion5x/rd88f5182-setup.c            |   7 +-
 arch/arm/mach-orion5x/terastation_pro2-setup.c     |   4 +-
 arch/arm/mach-orion5x/ts209-setup.c                |   4 +-
 arch/arm/mach-orion5x/ts409-setup.c                |   4 +-
 arch/arm/mach-orion5x/wnr854t-setup.c              |   4 +-
 arch/arm/mach-orion5x/wrt350n-v2-setup.c           |   4 +-
 arch/arm/mach-shmobile/clock-r8a7779.c             |  23 +-
 arch/arm/mach-shmobile/include/mach/r8a7779.h      |   2 +
 arch/arm/mach-shmobile/setup-r8a7779.c             |  23 +-
 arch/arm/mach-zynq/Kconfig                         |   1 +
 arch/arm/mach-zynq/Makefile                        |   6 +-
 arch/arm/mach-zynq/common.c                        |  67 +-
 arch/arm/mach-zynq/common.h                        |  20 +
 arch/arm/mach-zynq/headsmp.S                       |  24 +
 arch/arm/mach-zynq/hotplug.c                       | 104 +++
 arch/arm/mach-zynq/platsmp.c                       | 136 ++++
 arch/arm/mach-zynq/slcr.c                          | 125 +++
 arch/arm/plat-orion/Makefile                       |   6 -
 arch/arm/plat-orion/addr-map.c                     | 178 -----
 arch/arm/plat-orion/gpio.c                         |  59 ++
 drivers/bus/Kconfig                                |   7 +
 drivers/bus/Makefile                               |   1 +
 drivers/bus/mvebu-mbus.c                           | 870 +++++++++++++++++++++
 drivers/gpio/gpio-pl061.c                          |   2 +-
 drivers/pinctrl/sh-pfc/pfc-r8a7779.c               |   2 +-
 drivers/staging/imx-drm/ipu-v3/ipu-common.c        |  12 +-
 include/linux/mbus.h                               |  27 +-
 96 files changed, 2257 insertions(+), 1002 deletions(-)
