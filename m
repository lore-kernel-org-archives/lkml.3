Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab3B1W4C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 17:56:02 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:48129 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab3B1WzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 17:55:10 -0500
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 2/3] arm-soc: late OMAP changes
Date: Thu, 28 Feb 2013 14:54:51 -0800
Message-Id: <1362092093-4839-3-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
In-Reply-To: <1362092093-4839-1-git-send-email-olof@lixom.net>
References: <1362092093-4839-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This branch contains changes for OMAP that came in late during the release
staging, close to when the merge window opened.

It contains, among other things:

- OMAP PM fixes and some patches for audio device integration
- OMAP clock fixes related to common clock conversion
- A set of patches cleaning up WFI entry and blocking.
- A set of fixes and IP block support for PM on TI AM33xx SoCs (Beaglebone, etc)
- A set of smaller fixes and cleanups around AM33xx restart and revision
detection, as well as removal of some dead code (CONFIG_32K_TIMER_HZ)

----------------------------------------------------------------

The following changes since commit 1b4d123a8d9c42208e03e615ae64ef076f66309e:

  Merge branch 'late/dt' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/late-omap

for you to fetch changes up to 55ccb1a8b4c14c086427fd6b7272448fbd0c4449:

  ARM: omap2: include linux/errno.h in hwmod_reset

----------------------------------------------------------------

Afzal Mohammed (3):
      ARM: OMAP2+: dpll: am335x - avoid freqsel
      ARM: OMAP2+: clock data: add DEFINE_STRUCT_CLK_FLAGS helper
      ARM: OMAP AM33XX: clock data: SET_RATE_PARENT in lcd path

AnilKumar Ch (1):
      ARM: OMAP2: AM33XX: id: Add support for AM335x PG2.0

Arnd Bergmann (1):
      ARM: omap2: include linux/errno.h in hwmod_reset

Hebbar Gururaja (2):
      ARM: OMAP2+: AM33xx: hwmod: add missing HWMOD_NO_IDLEST flags
      ARM: OMAP2: am33xx-hwmod: Fix "register offset NULL check" bug

Jean-Sebastien A. Beaudry (1):
      ARM: OMAP2+: AM33xx: Add SoC specific restart hook

Laurent Pinchart (2):
      ARM: OMAP3: clock: Back-propagate rate change from cam_mclk to dpll4_m5
      omap3isp: Set cam_mclk rate directly

Olof Johansson (5):
      Merge tag 'omap-for-v3.9/soc-signed' of git://git.kernel.org/.../tmlind/linux-omap into late/omap
      Merge tag 'omap-for-v3.9/am33xx-signed' of git://git.kernel.org/.../tmlind/linux-omap into late/omap
      Merge tag 'omap-for-v3.9/pm-wfi-take2-signed-v2' of git://git.kernel.org/.../tmlind/linux-omap into late/omap
      Merge tag 'omap-for-v3.9/clock-signed' of git://git.kernel.org/.../tmlind/linux-omap into late/omap
      Merge tag 'omap-for-v3.9/pm-omap4-signed' of git://git.kernel.org/.../tmlind/linux-omap into late/omap

Paul Walmsley (10):
      ARM: OMAP2xxx: PM: enter WFI via inline asm if CORE stays active
      ARM: OMAP2+: hwmod: add support for blocking WFI when a device is active
      ARM: OMAP2420: hwmod data/PM: use hwmod to block WFI when I2C active
      ARM: OMAP AM3517/05: hwmod data: block WFI when EMAC active
      Merge branch 'clock_misc_devel_a_3.9', remote-tracking branch 'remotes/pinchart/omap3isp/clock' into clock_devel_a_3.9
      ARM: OMAP2+: hwmod: add enable_preprogram hook
      ASoC: TI AESS: add autogating-enable function, callable from architecture code
      ARM: OMAP4+: AESS: enable internal auto-gating during initial setup
      Merge branches 'sg_aess_reset_devel_3.9' and 'omap4_pm_fixes_a_3.9' into omap4_prcm_devel_a_3.9
      ARM: OMAP2+: fix some omap_device_build() calls that aren't compiled by default

Philip Avinash (2):
      ARM: OMAP: AM33xx hwmod: Corrects PWM subsystem HWMOD entries
      ARM: OMAP: AM33xx hwmod: Add parent-child relationship for PWM subsystem

Rajendra Nayak (2):
      ARM: OMAP4: PM: Warn users about usage of older bootloaders
      ARM: OMAP4: clock data: Add missing clkdm association for dpll_usb

Santosh Shilimkar (2):
      ARM: OMAP2+: Get rid of custom OMAP_32K_TIMER_HZ
      ARM: OMAP2+: PM: Fix the dt return condition in pm_late_init()

Sebastien Guiriec (2):
      ARM: OMAP4: hwmod data: Update AESS data with memory bank area
      ARM: OMAP4: hwmod data: Enable AESS hwmod device

Tony Lindgren (6):
      Merge tag 'omap-devel-a-for-3.9' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.9/am33xx
      Merge tag 'omap-devel-e-for-3.9' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.9/clock
      Merge tag 'omap-for-v3.9/pm-signed' into omap-for-v3.9/pm-wfi-take2
      Merge tag 'omap-devel-b-for-3.9' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.9/pm-wfi-take2
      Merge tag 'omap-devel-d2-for-3.9' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.9/pm-omap4
      Merge branch 'omap-for-v3.9/pm-fix' into omap-for-v3.9/pm-wfi-take2

Vaibhav Bedia (8):
      ARM: OMAP2+: AM33XX: CM: Get rid of unnecessary header inclusions
      ARM: OMAP2+: AM33XX: CM/PRM: Use __ASSEMBLER__ macros in header files
      ARM: OMAP2+: AM33XX: hwmod: Register OCMC RAM hwmod
      ARM: OMAP2+: AM33XX: hwmod: Update TPTC0 hwmod with the right flags
      ARM: OMAP2+: AM33XX: hwmod: Fixup cpgmac0 hwmod entry
      ARM: OMAP2+: AM33XX: hwmod: Update the WKUP-M3 hwmod with reset status bit
      ARM: OMAP2+: AM33XX: Update the hardreset API
      ARM: DTS: AM33XX: Add nodes for OCMC RAM and WKUP-M3


 arch/arm/Kconfig                           |   1 -
 arch/arm/boot/dts/am33xx.dtsi              |  14 +
 arch/arm/mach-omap2/Makefile               |   3 +-
 arch/arm/mach-omap2/am33xx-restart.c       |  34 ++
 arch/arm/mach-omap2/am35xx-emac.c          |   3 +-
 arch/arm/mach-omap2/board-generic.c        |   1 +
 arch/arm/mach-omap2/cclock33xx_data.c      |  10 +-
 arch/arm/mach-omap2/cclock3xxx_data.c      |  10 +-
 arch/arm/mach-omap2/cclock44xx_data.c      |  13 +-
 arch/arm/mach-omap2/clock.h                |  11 +
 arch/arm/mach-omap2/cm33xx.c               |   3 -
 arch/arm/mach-omap2/cm33xx.h               |   9 +-
 arch/arm/mach-omap2/common.h               |   8 +
 arch/arm/mach-omap2/devices.c              |   2 +-
 arch/arm/mach-omap2/dpll3xxx.c             |   5 +-
 arch/arm/mach-omap2/id.c                   |  14 +-
 arch/arm/mach-omap2/omap_hwmod.c           |  23 +-
 arch/arm/mach-omap2/omap_hwmod.h           |   8 +
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c | 443 +++++++++++++++---------
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |   7 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |  51 ++-
 arch/arm/mach-omap2/omap_hwmod_reset.c     |  53 +++
 arch/arm/mach-omap2/pm.c                   |  20 +-
 arch/arm/mach-omap2/pm24xx.c               |  12 +-
 arch/arm/mach-omap2/pm44xx.c               |  21 +-
 arch/arm/mach-omap2/prm33xx.c              |  11 +-
 arch/arm/mach-omap2/prm33xx.h              |   4 +-
 arch/arm/mach-omap2/sleep24xx.S            |  19 -
 arch/arm/mach-omap2/soc.h                  |   1 +
 arch/arm/mach-omap2/sr_device.c            |   2 +-
 arch/arm/plat-omap/Kconfig                 |   9 -
 arch/arm/plat-omap/include/plat/timex.h    |   8 -
 drivers/media/platform/omap3isp/isp.c      |  18 +-
 drivers/media/platform/omap3isp/isp.h      |   8 +-
 include/sound/aess.h                       |  53 +++
 35 files changed, 633 insertions(+), 279 deletions(-)
 create mode 100644 arch/arm/mach-omap2/am33xx-restart.c
 create mode 100644 arch/arm/mach-omap2/omap_hwmod_reset.c
 create mode 100644 include/sound/aess.h
