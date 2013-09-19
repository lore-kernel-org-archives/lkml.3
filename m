Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab3ISTs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 15:48:28 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:38509 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab3ISTs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 15:48:26 -0400
Date: Thu, 19 Sep 2013 12:47:52 -0700
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, computersforpeace@gmail.com,
        David.Woodhouse@intel.com
Subject: [GIT PULL] ARM: SoC fixes for 3.12-rc
Message-ID: <20130919194752.GA19975@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to 660e1c2f47f51f5b03ea7f63fa11f000e0240bda:

  Merge tag 'omap-for-v3.12/fixes-dt-signed' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into fixes (2013-09-18 14:01:39 -0700)

----------------------------------------------------------------

ARM: SoC fixes for 3.12-rc

A set of fixes for ARM platforms for 3.12. Among them:

- A fix for build breakage in the MTD subsystem for some PXA devices.
  David Woodhouse has this patch in his for-next branch but has not been
  responding to our requests to send it up so here it is.
  I should have amended the commit message to describe the build failure for
  CONFIG_OF=n setups, but forgot and now it's down in the stack of commits.

- Added device-tree for the BeagleBone Black. Turns out people have been
  using the older "regualar" bone DT for the newer boards, and there's
  risk of damaging hardware that way.

- Misc DT and regular fixes for OMAP.

- Fix to make the ST-Ericsson "snowball" boards boot with
  multi_v7_defconfig, and enable one of the ST-E reference boards on the
  same config.

- Kconfig cleanup for u300 to hide submenus when the platform isn't
  enabled.

- Enable ARM_ATAG_DTB_COMPAT to let firmware override command
  line when booting with an appended devicetree on non-DT-enabled
  firmware (needed to boot snowball).

----------------------------------------------------------------
Andrea Adami (1):
      ARM: sa1100: collie.c: fall back to jedec_probe flash detection

Anoop Thomas Mathew (1):
      ARM: OMAP4 SMP: Corrected a typo fucntions to functions

Arnaud Patard (1):
      ARM: imx51.dtsi: fix PATA device clock

Enric Balletbo i Serra (1):
      ARM: dts: igep00x0: Add pinmux configuration for MCBSP2

Ezequiel Garcia (1):
      mtd: nand: pxa3xx: Remove unneeded ifdef CONFIG_OF

Fabio Estevam (2):
      ARM: mach-imx: clk-imx51-imx53: Fix 'spdif1_pred' clock registration
      ARM: mach-omap2: gpmc: Fix warning when CONFIG_ARM_LPAE=y

Felipe Balbi (2):
      ARM: dts: OMAP5: fix reg property size
      ARM: dts: OMAP5: fix ocp2scp DTS data

Gwenhael Goavec-Merou (1):
      ARM: imx27.dtsi: fix CSPI PER clock id

Huang Shijie (1):
      ARM: dts: imx6q: fix the wrong offset of the Pad Mux register

Jason Liu (1):
      ARM: imx: i.mx6d/q: disable the double linefill feature of PL310

Jingoo Han (1):
      mailbox: remove unnecessary platform_set_drvdata()

Koen Kooi (1):
      ARM: dts: am335x-bone*: add DT for BeagleBone Black

Linus Walleij (3):
      ARM: ux500: disable outer cache debug
      ARM: u300: hide submenus
      ARM: multi_v7: add HREFv60 to multi_v7 defconfig

Olof Johansson (4):
      ARM: multi_v7_defconfig: enable ARM_ATAG_DTB_COMPAT
      Merge tag 'imx-fixes-3.12' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge tag 'omap-for-v3.12/fixes-signed' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'omap-for-v3.12/fixes-dt-signed' of git://git.kernel.org/.../tmlind/linux-omap into fixes

Phil Carmody (1):
      ARM: OMAP2+: mux: fix trivial typo in name

Robert Nelson (1):
      ARM: dts: omap3-beagle-xm: fix string error in compatible property

Shawn Guo (1):
      ARM: imx: initialize clk_init_data.flags for clk-fixup-mux

Tony Lindgren (4):
      ARM: dts: Fix muxing and regulator for wl12xx on the SDIO bus for pandaboard
      ARM: dts: Fix muxing and regulator for wl12xx on the SDIO bus for blaze
      ARM: OMAP4: Fix clock_get error for GPMC during boot
      Merge tag 'for_3.12-rc2/dts_signed' of git://git.kernel.org/.../bcousson/linux-omap-dt into omap-for-v3.12/fixes-dt

Vladimir Murzin (1):
      ARM: OMAP4: cpuidle: fix: call cpu_cluster_pm_exit conditionally

Wei Yongjun (1):
      ARM: OMAP: fix return value check in omap_device_build_from_dt()

 arch/arm/boot/dts/Makefile                |   1 +
 arch/arm/boot/dts/am335x-bone-common.dtsi | 262 ++++++++++++++++++++++++++++++
 arch/arm/boot/dts/am335x-bone.dts         | 256 +----------------------------
 arch/arm/boot/dts/am335x-boneblack.dts    |  17 ++
 arch/arm/boot/dts/imx27.dtsi              |   6 +-
 arch/arm/boot/dts/imx51.dtsi              |   2 +-
 arch/arm/boot/dts/imx6q-pinfunc.h         |   4 +-
 arch/arm/boot/dts/omap3-beagle-xm.dts     |   2 +-
 arch/arm/boot/dts/omap3-igep.dtsi         |  14 ++
 arch/arm/boot/dts/omap4-panda-common.dtsi |  46 +++++-
 arch/arm/boot/dts/omap4-sdp.dts           |  39 ++++-
 arch/arm/boot/dts/omap5.dtsi              |   7 +-
 arch/arm/configs/multi_v7_defconfig       |   2 +
 arch/arm/mach-imx/clk-fixup-mux.c         |   1 +
 arch/arm/mach-imx/clk-imx51-imx53.c       |   2 +-
 arch/arm/mach-imx/system.c                |  11 ++
 arch/arm/mach-omap2/cclock44xx_data.c     |   2 +-
 arch/arm/mach-omap2/cpuidle44xx.c         |   2 +-
 arch/arm/mach-omap2/gpmc.c                |   4 +-
 arch/arm/mach-omap2/mux34xx.c             |   2 +-
 arch/arm/mach-omap2/omap-smp.c            |   2 +-
 arch/arm/mach-omap2/omap_device.c         |   2 +-
 arch/arm/mach-sa1100/collie.c             |   2 +-
 arch/arm/mach-u300/Kconfig                |  10 +-
 arch/arm/mach-ux500/cache-l2x0.c          |   1 +
 drivers/mailbox/mailbox-omap2.c           |   1 -
 drivers/mtd/nand/pxa3xx_nand.c            |   7 -
 27 files changed, 418 insertions(+), 289 deletions(-)
 create mode 100644 arch/arm/boot/dts/am335x-bone-common.dtsi
 create mode 100644 arch/arm/boot/dts/am335x-boneblack.dts
