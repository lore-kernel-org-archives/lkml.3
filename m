Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab3GMPij (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 11:38:39 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:60511 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab3GMPih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 11:38:37 -0400
Date: Sat, 13 Jul 2013 08:38:36 -0700
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for -rc1
Message-ID: <20130713153836.GA13431@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's the first set of fixes for SoC platforms. You'll see a trivial
merge conflict due to the same bug being fixed through our tree and
another (with a newline difference), but it was near the bottom of the
branch and I didn't think it was worth rebasing away.


-Olof

The following changes since commit ddcf6600b133697adbafd96e080818bdc0dfd028:

  Merge tag 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging (2013-07-03 19:56:35 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to d4e1c7ef46e9b02dbf691da0c84d653f88670213:

  arm: multi_v7_defconfig: Tweaks for omap and sunxi (2013-07-12 23:45:33 -0700)

----------------------------------------------------------------
ARM: SoC fixes for 3.11-rc

This is our first set of fixes from arm-soc for 3.11.
 - A handful of build and warning fixes from Arnd
 - A collection of OMAP fixes
 - defconfig updates to make the default configs more useful for real use
   (and testing) out of the box on hardware.

And a couple of other small fixes. Some of these have been recently
applied but it's normally how we deal with fixes, with less bake time
in -next needed.

----------------------------------------------------------------
Afzal Mohammed (1):
      ARM: OMAP2+: timer: initialize before using oh_name

Arnd Bergmann (8):
      Merge tag 'renesas-fixes-for-v3.11' of git://git.kernel.org/.../horms/renesas into fixes
      ARM: omap5: omap5 has SCU and TWD
      ARM: zynq: use DT_MACHINE_START
      ARM: OMAP: build mach-omap code only if needed
      ARM: sti: move DEBUG_STI_UART into alphabetical order
      ARM: OMAP: omap_common_late_init may be unused
      ARM: ixp4xx: avoid circular header dependency
      ARM: exynos: select PM_GENERIC_DOMAINS only when used

Eduardo Valentin (2):
      ARM: OMAP2+: omap2plus_defconfig: enable TI bandgap driver
      ARM: OMAP2+: omap2plus_defconfig: enable DRA752 thermal support by default

Enric Balletbo i Serra (1):
      ARM: OMAP3: igep0020: Set DSS pins in correct mux mode.

Fabio Baltieri (2):
      ARM: ux500: select WATCHDOG and MUSB for ux500
      ARM: ux500: select SND_SOC_UX500 for ux500

Joel Fernandes (1):
      ARM: OMAP2+: Enable TI_EDMA in omap2plus_defconfig

Lee Jones (1):
      ARM: ux500: Enable HIGHMEM in the u8500 defconfig

Linus Walleij (1):
      ARM: ux500: update defconfig base

Magnus Damm (1):
      ARM: shmobile: emev2 GIO3 resource fix

Nishanth Menon (2):
      ARM: OMAP4: sleep: build OMAP4 specific functions only for OMAP4
      ARM: scu: provide inline dummy functions when SCU is not present

Olof Johansson (5):
      ARM: Make multi_v7_defconfig usable on hardware
      ARM: omap2: add select of TI_PRIV_EDMA
      Merge tag 'omap-for-v3.11/fixes-for-merge-window' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'ux500-defconfig-for-arm-soc' of git://git.kernel.org/.../linusw/linux-stericsson into fixes
      arm: multi_v7_defconfig: Tweaks for omap and sunxi

Paul Bolle (1):
      ARM: OMAP2+: Remove obsolete Makefile line

Pavel Machek (1):
      ARM: OMAP2+: N900: enable N900-specific drivers even if device tree is enabled

Santosh Shilimkar (1):
      ARM: OMAP5: Enable Cortex A15 errata 798181

Stephen Warren (1):
      ARM: tegra: fix VBUS regulator GPIO polarity in DT

Takanari Hayama (1):
      ARM: shmobile: r8a73a4: Fix resources for SCIFB0

Thomas Meyer (1):
      ARM: OMAP2+: Cocci spatch "ptr_ret.spatch"

Tom Rini (1):
      ARM: OMAP2+: omap2plus_defconfig: Enable appended DTB support

Ulf Hansson (1):
      ARM: ux500: Update MMC configs for u8500 defconfig

Vincent Stehlé (1):
      arm: multi_v7_defconfig: add i.MX options and NFS root

Wei Yongjun (1):
      ARM: OMAP2+: devices: remove duplicated include from devices.c

 arch/arm/Kconfig.debug                    |  20 ++--
 arch/arm/boot/dts/tegra20-seaboard.dts    |   1 +
 arch/arm/boot/dts/tegra20-trimslice.dts   |   1 +
 arch/arm/boot/dts/tegra20-whistler.dts    |   2 +
 arch/arm/configs/multi_v7_defconfig       | 133 ++++++++++++++++++++------
 arch/arm/configs/omap2plus_defconfig      |  19 ++++
 arch/arm/configs/u8500_defconfig          |  44 +++++----
 arch/arm/include/asm/smp_scu.h            |  13 ++-
 arch/arm/mach-exynos/Kconfig              |   2 +-
 arch/arm/mach-ixp4xx/dsmg600-setup.c      |   2 +
 arch/arm/mach-ixp4xx/include/mach/timex.h |   2 +-
 arch/arm/mach-ixp4xx/omixp-setup.c        |   2 +
 arch/arm/mach-omap2/Kconfig               | 153 +++++++++++++++---------------
 arch/arm/mach-omap2/Makefile              |   4 -
 arch/arm/mach-omap2/board-igep0020.c      |  31 ++++++
 arch/arm/mach-omap2/board-rx51-video.c    |   2 +-
 arch/arm/mach-omap2/devices.c             |   5 +-
 arch/arm/mach-omap2/fb.c                  |   5 +-
 arch/arm/mach-omap2/gpmc.c                |   2 +-
 arch/arm/mach-omap2/io.c                  |   2 +-
 arch/arm/mach-omap2/pmu.c                 |   5 +-
 arch/arm/mach-omap2/sleep44xx.S           |   6 +-
 arch/arm/mach-omap2/timer.c               |   2 +-
 arch/arm/mach-shmobile/setup-emev2.c      |   8 +-
 arch/arm/mach-shmobile/setup-r8a73a4.c    |   2 +-
 arch/arm/mach-zynq/common.c               |   2 +-
 sound/soc/omap/rx51.c                     |   2 +-
 27 files changed, 311 insertions(+), 161 deletions(-)
