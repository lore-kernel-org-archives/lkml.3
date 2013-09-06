Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786Ab3IFTM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 15:12:59 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:36359 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab3IFTM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 15:12:56 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 1/5] ARM: SoC low-priority fixes for 3.12
Date: Fri,  6 Sep 2013 12:10:01 -0700
Message-Id: <1378494605-14990-2-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
In-Reply-To: <1378494605-14990-1-git-send-email-olof@lixom.net>
References: <1378494605-14990-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This branch contains a handful of fixes for various platforms that
weren't serious enough to be included in late 3.11-rc releases. Most of
them are for minor cleanups and cosmetic fixes.

There's also a bit of code removal here, one board file removal for
clps711x, and removal of some legacy device creation on OMAP2+.


Conflicts: None

----------------------------------------------------------------

The following changes since commit 4de9ad9bc08b4953fc03336ad38908496e2f8826:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-nc-for-linus

for you to fetch changes up to 2bbc31ef2b398d17016c6438016cc76913990950:

  Merge tag 'omap-for-v3.12/fixes-non-critical-signed' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into next/fixes-non-critical


----------------------------------------------------------------

Alexander Shiyan (4):
      ARM: clps711x: Remove the special name for the syscon driver
      ARM: clps711x: Drop fortunet board support
      ARM: clps711x: autcpu12: Remove incorrect config checking
      ARM: clps711x: edb7211: Remove extra iotable_init() call

Chen Baozi (1):
      ARM: OMAP2+: fix wrong address when loading PRM_FRAC_INCREMENTOR_DENUMERATOR_RELOAD

Chen Gang (2):
      ARM: OMAP2: remove useless variable 'ret'
      ARM: OMAP2: use 'int' instead of 'unsigned' for variable 'gpmc_irq_start'

Ezequiel Garcia (1):
      ARM: OMAP2: Use a consistent AM33XX SoC option description

Guennadi Liakhovetski (1):
      ARM: shmobile: armadillo800eva-reference: fix compiler warning

Kevin Hilman (1):
      Merge tag 'keystone-fixes-non-critical' of git://git.kernel.org/.../ssantosh/linux-keystone into next/fixes-non-critical

Laurent Pinchart (1):
      ARM: shmobile: r8a7740: Fix TPU clock name

Magnus Damm (1):
      ARM: shmobile: Update romImage to relocate appended DTB

Matus Ujhelyi (1):
      ARM: OMAP2+: am33xx-restart: trigger warm reset on omap2+ boards

Olof Johansson (5):
      Merge tag 'renesas-fixes-for-v3.12' of git://git.kernel.org/.../horms/renesas into next/fixes-non-critical
      Merge tag 'fixes-non-3.12' of git://git.infradead.org/linux-mvebu into next/fixes-non-critical
      Merge tag 'renesas-fixes2-for-v3.12' of git://git.kernel.org/.../horms/renesas into next/fixes-non-critical
      Merge tag 'fixes-non-3.12-2' of git://git.infradead.org/linux-mvebu into next/fixes-non-critical
      Merge tag 'omap-for-v3.12/fixes-non-critical-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/fixes-non-critical

Paul Bolle (1):
      ARM: keystone: drop useless HAVE_SCHED_CLOCK

Peter Ujfalusi (1):
      ARM: OMAP2+: Remove legacy device creation for McPDM and DMIC

Santosh Shilimkar (4):
      ARM: Keystone: No need to preserve r12 across smc call
      ARM: keystone: Drop the un-necessary dsb from keystone_cpu_smc()
      ARM: keystone: use #include to include skeleton.dtsi
      ARM: Keystone: Convert device tree file to use IRQ defines

Sebastian Hesselbarth (1):
      ARM: dove: fix missing __init section of dove_mpp_gpio_mode

Stepan Moskovchenko (1):
      ARM: dts: Fix memory node in skeleton64.dtsi

Sudeep KarkadaNagesha (1):
      ARM: keystone: remove redundant smp_init_cpus definition

Tetsuyuki Kobayashi (3):
      ARM: shmobile: fix compile error when CONFIG_THUMB2_KERNEL=y
      ARM: shmobile: Force ARM mode to compile reset vector for secondary CPUs
      ARM: shmobile: Insert align directives before 4 bytes data

Wei Yongjun (1):
      ARM: OMAP: dma: fix error return code in omap_system_dma_probe()


 arch/arm/boot/compressed/head-shmobile.S        | 43 +++++++++-
 arch/arm/boot/dts/keystone.dts                  | 29 ++++---
 arch/arm/boot/dts/skeleton64.dtsi               |  2 +-
 arch/arm/mach-clps711x/Kconfig                  |  3 -
 arch/arm/mach-clps711x/Makefile                 |  1 -
 arch/arm/mach-clps711x/board-autcpu12.c         |  6 +-
 arch/arm/mach-clps711x/board-edb7211.c          | 17 +---
 arch/arm/mach-clps711x/board-fortunet.c         | 85 --------------------
 arch/arm/mach-clps711x/devices.c                |  2 +-
 arch/arm/mach-dove/mpp.c                        |  2 +-
 arch/arm/mach-keystone/Kconfig                  |  1 -
 arch/arm/mach-keystone/platsmp.c                |  1 -
 arch/arm/mach-keystone/smc.S                    |  5 +-
 arch/arm/mach-omap2/Kconfig                     |  2 +-
 arch/arm/mach-omap2/am33xx-restart.c            |  4 +-
 arch/arm/mach-omap2/board-am3517crane.c         |  2 -
 arch/arm/mach-omap2/devices.c                   | 40 ---------
 arch/arm/mach-omap2/gpmc.c                      |  2 +-
 arch/arm/mach-omap2/timer.c                     |  2 +-
 .../board-armadillo800eva-reference.c           |  4 +-
 arch/arm/mach-shmobile/clock-r8a7740.c          |  2 +-
 arch/arm/mach-shmobile/headsmp-scu.S            |  4 +-
 arch/arm/mach-shmobile/headsmp.S                |  6 +-
 arch/arm/mach-shmobile/include/mach/zboot.h     |  2 -
 arch/arm/mach-shmobile/sleep-sh7372.S           |  2 +
 arch/arm/plat-omap/dma.c                        |  1 +
 drivers/mfd/syscon.c                            |  3 -
 27 files changed, 83 insertions(+), 190 deletions(-)
 delete mode 100644 arch/arm/mach-clps711x/board-fortunet.c
