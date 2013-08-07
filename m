Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933890Ab3HGXH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 19:07:57 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:58669 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933540Ab3HGXH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 19:07:56 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Olof Johansson <olof@lixom.net>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for 3.11-rc5
Date: Wed, 07 Aug 2013 16:07:52 -0700
Message-ID: <87bo59ksl3.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I'm stepping in to help Olof in arm-soc land while Arnd is away for a
bit.  Please consider the fixes below for -rc5, Thanks.

Kevin


The following changes since commit 5ae90d8e467e625e447000cb4335c4db973b1095:

  Linux 3.11-rc3 (2013-07-28 20:53:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to 1154f858ab5cd3c5facde7cb9ac31c889eb780a8:

  MAINTAINERS: add TI Keystone ARM platform (2013-08-07 10:30:29 -0700)

----------------------------------------------------------------
ARM: SoC fixes for v3.11-rc

- MSM: GPIO fixes (includes old code removal)
- OMAP: earlyprintk regression, AM33xx cpgmac PM regression
- OMAP5: urgent fix for potentially harmful voltage regulator values
- Renesas: gpio-keys fix, fix SD card detection, fix shdma calculation error
- STi: critical SMP boot fix
- tegra: DTS fix for usb-phy
- a couple MAINTAINERS updates

----------------------------------------------------------------
Afzal Mohammed (2):
      ARM: OMAP2+: hwmod: rt address space index for DT
      ARM: OMAP2+: hwmod: AM335x: fix cpgmac address space

Kuninori Morimoto (2):
      ARM: shmobile: armadillo800eva: Don't request GPIO 166 in board code
      shdma: fixup sh_dmae_get_partial() calculation error

Linus Walleij (1):
      MAINTAINERS: delete Srinidhi from ux500

Lucas Stach (1):
      ARM: tegra: enable ULPI phy on Colibri T20

Nishanth Menon (3):
      ARM: dts: omap5-uevm: document regulator signals used on the actual board
      ARM: dts: omap5-uevm: fix regulator configurations mandatory for SoC
      ARM: dts: omap5-uevm: update optional/unused regulator configurations

Olof Johansson (4):
      Merge tag 'msm-3.11-fix1' of git://git.kernel.org/.../davidb/linux-msm into fixes
      Merge tag 'omap-for-v3.11/fixes-omap5' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'for-v3.11-rc/omap-fixes-b' of git://git.kernel.org/.../pjw/omap-pending into fixes
      Merge tag 'renesas-fixes2-for-v3.11' of git://git.kernel.org/.../horms/renesas into fixes

Rajendra Nayak (3):
      ARM: OMAP2+: hwmod: Fix a crash in _setup_reset() with DEBUG_LL
      ARM: OMAP2+: Avoid idling memory controllers with no drivers
      ARM: OMAP2+: Sync hwmod state with the pm_runtime and omap_device state

Rohit Vaswani (2):
      ARM: msm: dts: Fix the gpio register address for msm8960
      ARM: msm: Consolidate gpiomux for older architectures

Santosh Shilimkar (1):
      MAINTAINERS: add TI Keystone ARM platform

Sergei Shtylyov (1):
      ARM: shmobile: BOCK-W: fix SDHI0 PFC settings

Simon Horman (1):
      ARM: shmobile: lager: do not annotate gpio_buttons as __initdata

Srinivas Kandagatla (2):
      ARM: STi: Fix cpu nodes with correct device_type.
      ARM: STi: remove sti_secondary_start from INIT section.

 MAINTAINERS                                        |  7 +-
 arch/arm/boot/dts/msm8960-cdp.dts                  |  4 +-
 arch/arm/boot/dts/omap5-uevm.dts                   | 78 ++++++++++++++--------
 arch/arm/boot/dts/stih41x.dtsi                     |  2 +
 arch/arm/boot/dts/tegra20-colibri-512.dtsi         |  1 +
 arch/arm/mach-msm/Kconfig                          |  3 +-
 arch/arm/mach-msm/gpiomux-v1.c                     | 33 ---------
 arch/arm/mach-msm/gpiomux.h                        | 10 ---
 arch/arm/mach-omap2/omap_device.c                  | 18 +++++
 arch/arm/mach-omap2/omap_hwmod.c                   |  2 +-
 arch/arm/mach-omap2/omap_hwmod.h                   | 50 ++++++++++++++
 arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c |  6 +-
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c         |  3 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |  9 +--
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |  5 +-
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c         |  3 +-
 arch/arm/mach-omap2/serial.c                       | 11 ---
 arch/arm/mach-shmobile/board-armadillo800eva.c     |  3 -
 arch/arm/mach-shmobile/board-bockw.c               |  8 ++-
 arch/arm/mach-shmobile/board-lager.c               |  2 +-
 arch/arm/mach-sti/headsmp.S                        |  2 -
 drivers/dma/sh/shdma.c                             |  4 +-
 22 files changed, 154 insertions(+), 110 deletions(-)
 delete mode 100644 arch/arm/mach-msm/gpiomux-v1.c
