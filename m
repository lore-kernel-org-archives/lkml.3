Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab3DBP05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:26:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65279 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437Ab3DBP04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:26:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] arm-soc fixes for 3.9-rc5
Date: Tue, 2 Apr 2013 15:26:48 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304021526.48872.arnd@arndb.de>
X-Provags-ID: V02:K0:+PiMfr/wLs8UYmsD7E1v0jIXUbW8qhFUxYTG2YrVz7b
 qhaNxUqgc7wPryQKmSqX7j3Fx3CG5/BwuNuva7ABOcWCnSUDgi
 mkTuKjJhoNiJZiIZJFNEnaGF1tsLt0Dtj92LBwxXlTd8V+vmpt
 YBKrvo0POm8wX7M7vMWbFbApMbTWK8pgvhMQF4yFabMZ+R6UJK
 bxJpS+P76oio1cOXr686qr8sz6DsLwi/GhGRQiYuIoI23RsMEF
 eWptt2JlKCLvbww1HNRTb4qVoo00WGMN4c324jqKp/qsc7Ar5v
 WuNbfMJA8Gw0D+M6YTA0rKUBxNItfpxYSUu9ZKlrqhfWzrijB1
 qHRZU+1yjPVhRe3ldKzQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 8bb9660418e05bb1845ac1a2428444d78e322cc7:

  Linux 3.9-rc4 (2013-03-23 16:52:44 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes

for you to fetch changes up to 06d1d8c85700884940346f20d10b3a22c331b5e9:

  Merge tag 'v3.9-rc1_cns3xxx_fixes' of git://git.infradead.org/users/cbou/linux-cns3xxx into fixes (2013-04-02 16:09:45 +0200)

----------------------------------------------------------------

arm-soc: bug fixes for 3.9-rc5

After a quiet set of fixes for 3.9-rc4, a lot of people woke up and sent
urgent fixes for 3.9. I pushed back on a number of them that got
deferred to 3.10, but these are the ones that seemed important.

Regression in 3.9:

- Multiple regressions in OMAP2+ clock cleanup
- SH-Mobile frame buffer bug fix that merged here because of maintainer MIA
- ux500 prcmu changes broke DT booting
- MMCI duplicated regulator setup on ux500
- New ux500 clock driver broke ethernet on snowball
- Local interrupt driver for mvebu broke ethernet
- MVEBU GPIO driver did not get set up right on Orion DT
- incorrect interrupt number on Orion crypto for DT

Long-standing bugs, including candidates for stable:

- Kirkwood MMC needs to disable invalid card detect pins
- MV SDIO pinmux was wrong on Mirabox
- GoFlex Net board file needs to set NAND chip delay
- MSM timer restart race
- ep93xx early debug code broke in 3.7
- i.MX CPU hotplug race
- Incorrect clock setup for OMAP1 USB
- Workaround for bad clock setup by some old OMAP4 boot loaders
- Static I/O mappings on cns3xxx since 3.2

----------------------------------------------------------------
Aaro Koskinen (1):
      ARM: OMAP1: fix USB host on 1710

Alexander Clouter (2):
      arm: orion5x: fix orion5x.dtsi gpio parameters
      arm: orion5x: correct IRQ used in dtsi for mv_cesa

Arnd Bergmann (8):
      Merge tag 'msm-fix-3.9' of git://git.kernel.org/.../davidb/linux-msm into fixes
      Merge tag 'renesas-fbdev-fixes-for-v3.9' of git://git.kernel.org/.../horms/renesas into fixes
      Merge tag 'omap-for-v3.9-rc3/fixes-signed' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'ux500-fixes-for-v3.9' of git://git.kernel.org/.../linusw/linux-stericsson into fixes
      Merge tag 'imx-fixes-3.9-4' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge tag 'ep93xx-fixes-for-3.9-rc5' of git://github.com/RyanMallon/linux-ep93xx into fixes
      Merge tag 'mvebu_fixes_for_v3.9_round2' of git://git.infradead.org/users/jcooper/linux into fixes
      Merge tag 'v3.9-rc1_cns3xxx_fixes' of git://git.infradead.org/users/cbou/linux-cns3xxx into fixes

Eric Hutter (1):
      ARM: kirkwood: Fix chip-delay for GoFlex Net

Grazvydas Ignotas (1):
      ARM: OMAP3: hwmod data: keep MIDLEMODE in force-standby for musb

Gregory CLEMENT (1):
      arm: mvebu: Use local interrupt only for the timer 0

H Hartley Sweeten (1):
      ARM: ep93xx: Fix wait for UART FIFO to be empty

Jon Hunter (1):
      ARM: OMAP4: clock data: lock USB DPLL on boot

Kuninori Morimoto (1):
      fbdev: sh_mobile_lcdc: fixup B side hsync adjust settings

Lee Jones (3):
      ARM: ux500: Apply the TCPM and TCDM locations and sizes to dbx5x0 DT
      ARM: ux500: Stop passing ios_handler() as an MMCI power controlling call-back
      ARM: ux500: Enable the clock controlling Ethernet on Snowball

Mac Lin (1):
      ARM: cns3xxx: fix mapping of private memory region

Paul Walmsley (1):
      ARM: OMAP4: PM: fix PM regression introduced by recent clock cleanup

Rajendra Nayak (1):
      ARM: OMAP: clocks: Delay clk inits atleast until slab is initialized

Ryan Press (1):
      arm: mvebu: Fix pinctrl for Armada 370 Mirabox SDIO port.

Sebastian Hesselbarth (1):
      ARM: Kirkwood: fix unused mvsdio gpio pins

Shawn Guo (2):
      ARM: imx: add dependency check for DEBUG_IMX_UART_PORT
      ARM: imx: fix sync issue between imx_cpu_die and imx_cpu_kill

Stephen Boyd (1):
      ARM: msm: Stop counting before reprogramming clockevent

Tony Lindgren (1):
      Merge tag 'omap-fixes-a-for-3.9-rc' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.9-rc3/fixes

 arch/arm/Kconfig.debug                         |  1 +
 arch/arm/boot/dts/armada-370-mirabox.dts       |  2 +-
 arch/arm/boot/dts/armada-370.dtsi              |  6 ++++++
 arch/arm/boot/dts/dbx5x0.dtsi                  |  4 ++--
 arch/arm/boot/dts/kirkwood-goflexnet.dts       |  1 +
 arch/arm/boot/dts/orion5x.dtsi                 |  9 +++++++--
 arch/arm/mach-cns3xxx/core.c                   | 16 +++-------------
 arch/arm/mach-cns3xxx/include/mach/cns3xxx.h   | 16 ++++++++--------
 arch/arm/mach-ep93xx/include/mach/uncompress.h | 10 +++++++---
 arch/arm/mach-imx/common.h                     |  2 ++
 arch/arm/mach-imx/hotplug.c                    | 12 ++++++++++++
 arch/arm/mach-imx/src.c                        | 12 ++++++++++++
 arch/arm/mach-kirkwood/guruplug-setup.c        |  2 ++
 arch/arm/mach-kirkwood/openrd-setup.c          |  1 +
 arch/arm/mach-kirkwood/rd88f6281-setup.c       |  1 +
 arch/arm/mach-msm/timer.c                      |  5 ++++-
 arch/arm/mach-mvebu/irq-armada-370-xp.c        |  8 +++++---
 arch/arm/mach-omap1/clock_data.c               | 12 +-----------
 arch/arm/mach-omap2/cclock44xx_data.c          | 20 ++++++++++++++++++++
 arch/arm/mach-omap2/common.h                   |  3 +++
 arch/arm/mach-omap2/io.c                       | 18 ++++++++++++------
 arch/arm/mach-omap2/omap_hwmod.c               |  7 +++++--
 arch/arm/mach-omap2/omap_hwmod.h               |  9 +++++++--
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c     |  7 ++++++-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c     |  6 ++++++
 arch/arm/mach-omap2/timer.c                    |  4 ++++
 arch/arm/mach-ux500/board-mop500-sdi.c         |  1 -
 arch/arm/mach-ux500/board-mop500.c             | 12 ++++++++++++
 arch/arm/mach-ux500/board-mop500.h             |  1 +
 arch/arm/mach-ux500/cpu-db8500.c               |  5 +++--
 drivers/video/sh_mobile_lcdcfb.c               |  1 +
 31 files changed, 156 insertions(+), 58 deletions(-)
