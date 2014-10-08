Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbaJHU1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:27:11 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:52388 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbaJHU1J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:27:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 2/7] ARM: SoC cleanups for 3.18
Date: Wed, 08 Oct 2014 22:26:35 +0200
Message-ID: <5163761.5tLiYXxRSq@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1922034.HH2lvbiFi0@wuerfel>
References: <1922034.HH2lvbiFi0@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:ivKIeatLg8FVx7gzt3h5mdBLv0lPhddZVfj6O/YiUWd
 RRQ0+Qj9V46R2tyzalTQDhTwptHtSXHEaBDcXe5E72RltWR+3w
 Fr2k9pp+C3et1HrLRPyyHbrQfxYKR7ZUV1RYVEzd4ejJ8LAg3v
 aqT/n4Lu1FGjkgQP9/MnWuiNyr3JLx+nLEphP1gh2F6ti1pFN1
 Ody3xxFb1j3/Ij6bO1kPHxpr8BWZihARrFxeOnxtwzYdfS7wWz
 iw/v1XRsQhueMOlJSUZ4tqxEH2PqNRwLLwRodRORASOal5qXbT
 99v+wJh72EsIQlzI2l9th/xb1o9tWgGxuLegC0y1+gVM+5cqfg
 gV+VyTg0pOdTl7oY8i04=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 69e273c0b0a3c337a521d083374c918dc52c666f:

  Linux 3.17-rc3 (2014-08-31 18:23:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/cleanup-for-linus

for you to fetch changes up to 05301fe7de11dac87638f1728f8ee8b31bc1cf31:

  Merge tag 'at91-soc' of git://github.com/at91linux/linux-at91 into next/cleanup (2014-09-26 00:12:30 +0200)

----------------------------------------------------------------
ARM: SoC cleanups for 3.18

This time around, the cleanup branch contains mostly code removal. A number
of board files for at91, imx and msm have become obsolete because of the
DT conversion and are now ready to be removed. The OMAP platform has
traditionally had its own DMA engine abstraction and as this is being
phased out, a lot of the original code is now unused and can be removed
as well.

S3C24xx can be simplified now that the restart code is a proper device
driver.

Finally, a number of cleanups in shmobile are done to prepare for
the addition of new code in other branches.

----------------------------------------------------------------
Alexander Shiyan (4):
      ARM: i.MX: Remove mach-cpuimx27sd board file
      ARM: i.MX: Remove Phytec i.MX27 PCM038/PCM970 board files
      ARM: i.MX: Remove i.MX1 ADS board support
      ARM: clps711x: Switch CLPS711X subarch to use clk and clocksource driver

Alexander Stein (1):
      ARM: imx: iomux: Do not export symbol without public declaration

Arnd Bergmann (8):
      Merge tag 'msm-cleanup-for-arm-soc' of git://git.kernel.org/.../linusw/linux-stericsson into next/cleanup
      Merge tag 'renesas-kconfig-cleanups-for-v3.18' of git://git.kernel.org/.../horms/renesas into next/cleanup
      Merge tag 'at91-cleanup' of git://github.com/at91linux/linux-at91 into next/cleanup
      Merge tag 'at91-cleanup2' of git://github.com/at91linux/linux-at91 into next/cleanup
      Merge tag 'renesas-pm-cleanups-for-v3.18' of git://git.kernel.org/.../horms/renesas into next/cleanup
      Merge tag 'samsung-cleanup' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge tag 'cleanup-for-v3.18' of git://git.kernel.org/.../tmlind/linux-omap into next/cleanup
      Merge tag 'at91-soc' of git://github.com/at91linux/linux-at91 into next/cleanup

Boris BREZILLON (4):
      ARM: at91: introduce OLD_IRQ_AT91 Kconfig option
      ARM: at91: enclose at91_aic_xx calls in IS_ENABLED(CONFIG_OLD_IRQ_AT91) blocks
      ARM: at91: make use of the new AIC driver for dt enabled boards
      ARM: at91: remove old irq material

Fabio Estevam (1):
      ARM: imx: Remove mach-mxt_td60 board file

Gaël PORTAY (4):
      ARM: at91/tclib: prefer using of devm_* functions
      ARM: at91/tclib: move initialization from alloc to probe
      ARM: at91/tclib: mask interruptions at shutdown and probe
      clocksource: tcb_clksrc: sanitize IRQ request

Geert Uytterhoeven (6):
      ARM: shmobile: r8a7791 is now called "R-Car M2-W"
      ARM: shmobile: mackerel: Make domain_devices[] static __initdata
      ARM: shmobile: sh7372: Make domain_devices[] static __initdata
      ARM: shmobile: r8a7740: Use rmobile_add_devices_to_domains()
      ARM: shmobile: r8a7740: Clean up pm domain table
      ARM: shmobile: armadillo800eva legacy: Use rmobile_add_devices_to_domains()

Georgi Djakov (1):
      ARM: msm: Update the references to DEBUG_MSM_UARTx

Heiko Stuebner (1):
      ARM: S3C24XX: remove separate restart code

Joe Perches (2):
      ARM: orion5x: Convert pr_warning to pr_warn
      arm: mach-omap2: Convert pr_warning to pr_warn

Josef Holzmayr (1):
      ARM: at91: Remove the support for the RSI EWS board

Krzysztof Kozlowski (1):
      ARM: EXYNOS: Do not calculate boot address twice

Kukjin Kim (1):
      ARM: S5PV210: move <mach/regs-clock.h> into mach-s5pv210/

Linus Walleij (2):
      ARM: msm: delete dangling mahimahi board file
      ARM: msm: remove reference to MSM_SERIAL_DEBUGGER

Magnus Damm (8):
      ARM: shmobile: Introduce a Kconfig entry for R-Mobile
      ARM: shmobile: Introduce a Kconfig entry for R-Car Gen1
      ARM: shmobile: Introduce a Kconfig entry for R-Car Gen2
      ARM: shmobile: Cleanup pm-rcar.o build using Kconfig
      ARM: shmobile: Cleanup pm-rmobile.o build using Kconfig
      ARM: shmobile: Only select PM_RMOBILE for legacy case
      ARM: shmobile: Consolidate Legacy CPU_V7 Kconfig
      ARM: shmobile: Consolidate Legacy SH_CLK_CPG Kconfig

Maxime Ripard (1):
      ARM: sunxi: Remove sun4i reboot code from mach directory

Nicolas Ferre (1):
      ARM: at91: remove board file for Acme Systems Fox G20

Olof Johansson (2):
      Merge tag 'mvebu-soc-3.18' of git://git.infradead.org/linux-mvebu into next/cleanup
      Merge tag 'imx-cleanup-3.18' of git://git.kernel.org/.../shawnguo/linux into next/cleanup

Shawn Guo (1):
      ARM: imx: remove imx_scu_standby_enable()

Tony Lindgren (1):
      ARM: OMAP: Remove unused pieces of legacy DMA API

Uwe Kleine-Koenig (1):
      ARM: EXYNOS: remove unused <mach/memory.h>

Xiubo Li (1):
      ARM: dts: vf610-twr: remove useless property for sound card.

 arch/arm/Kconfig                                   |   2 +
 arch/arm/boot/dts/vf610-twr.dts                    |   1 -
 arch/arm/configs/imx_v4_v5_defconfig               |   5 -
 arch/arm/mach-at91/Kconfig                         |  17 +-
 arch/arm/mach-at91/Kconfig.non_dt                  |  18 +-
 arch/arm/mach-at91/Makefile                        |   5 +-
 arch/arm/mach-at91/board-dt-rm9200.c               |  13 -
 arch/arm/mach-at91/board-dt-sam9.c                 |  13 -
 arch/arm/mach-at91/board-dt-sama5.c                |  13 -
 arch/arm/mach-at91/board-foxg20.c                  | 272 --------
 arch/arm/mach-at91/board-rsi-ews.c                 | 232 -------
 arch/arm/mach-at91/irq.c                           | 270 +-------
 arch/arm/mach-at91/pm.c                            |  32 +-
 arch/arm/mach-at91/setup.c                         |   3 +-
 arch/arm/mach-clps711x/common.c                    | 138 +---
 arch/arm/mach-clps711x/common.h                    |   5 +
 arch/arm/mach-exynos/include/mach/memory.h         |  26 -
 arch/arm/mach-exynos/platsmp.c                     |   4 +-
 arch/arm/mach-imx/Kconfig                          | 103 ---
 arch/arm/mach-imx/Makefile                         |   6 -
 arch/arm/mach-imx/board-pcm038.h                   |  36 -
 arch/arm/mach-imx/common.h                         |   2 -
 arch/arm/mach-imx/cpuidle-imx6q.c                  |   4 -
 arch/arm/mach-imx/eukrea-baseboards.h              |  10 +-
 arch/arm/mach-imx/eukrea_mbimx27-baseboard.c       | 351 ----------
 arch/arm/mach-imx/iomux-imx31.c                    |   7 -
 arch/arm/mach-imx/iomux-v1.c                       |   2 -
 arch/arm/mach-imx/iomux-v3.c                       |   2 -
 arch/arm/mach-imx/mach-cpuimx27.c                  | 321 ---------
 arch/arm/mach-imx/mach-mx1ads.c                    | 154 -----
 arch/arm/mach-imx/mach-mxt_td60.c                  | 273 --------
 arch/arm/mach-imx/mach-pcm038.c                    | 358 ----------
 arch/arm/mach-imx/pcm970-baseboard.c               | 231 -------
 arch/arm/mach-imx/platsmp.c                        |  10 -
 arch/arm/mach-msm/board-mahimahi.c                 |  83 ---
 arch/arm/mach-msm/board-msm7x30.c                  |   2 +-
 arch/arm/mach-msm/board-trout-gpio.c               |   2 +-
 arch/arm/mach-msm/board-trout.c                    |   2 +-
 arch/arm/mach-msm/io.c                             |   6 +-
 arch/arm/mach-omap2/display.c                      |   2 +-
 arch/arm/mach-omap2/hdq1w.c                        |   4 +-
 arch/arm/mach-omap2/i2c.c                          |   2 +-
 arch/arm/mach-omap2/msdi.c                         |   4 +-
 arch/arm/mach-omap2/mux.c                          |   2 +-
 arch/arm/mach-omap2/omap_hwmod.c                   |  26 +-
 arch/arm/mach-omap2/pdata-quirks.c                 |   4 +-
 arch/arm/mach-omap2/pm34xx.c                       |   2 +-
 arch/arm/mach-omap2/smartreflex-class3.c           |   4 +-
 arch/arm/mach-omap2/sr_device.c                    |   2 +-
 arch/arm/mach-omap2/vc.c                           |   2 +-
 arch/arm/mach-omap2/voltage.c                      |  22 +-
 arch/arm/mach-omap2/wd_timer.c                     |   4 +-
 arch/arm/mach-orion5x/dns323-setup.c               |   8 +-
 arch/arm/mach-orion5x/terastation_pro2-setup.c     |   2 +-
 arch/arm/mach-orion5x/ts209-setup.c                |   2 +-
 arch/arm/mach-orion5x/ts409-setup.c                |   2 +-
 arch/arm/mach-orion5x/ts78xx-setup.c               |   4 +-
 arch/arm/mach-s3c24xx/Kconfig                      |   2 -
 arch/arm/mach-s3c24xx/common.c                     |   4 -
 arch/arm/mach-s3c24xx/common.h                     |   5 -
 .../mach-s3c24xx/include/mach/regs-s3c2443-clock.h |   2 -
 arch/arm/mach-s3c24xx/mach-amlm5900.c              |   1 -
 arch/arm/mach-s3c24xx/mach-anubis.c                |   1 -
 arch/arm/mach-s3c24xx/mach-at2440evb.c             |   1 -
 arch/arm/mach-s3c24xx/mach-bast.c                  |   1 -
 arch/arm/mach-s3c24xx/mach-gta02.c                 |   1 -
 arch/arm/mach-s3c24xx/mach-h1940.c                 |   1 -
 arch/arm/mach-s3c24xx/mach-jive.c                  |   1 -
 arch/arm/mach-s3c24xx/mach-mini2440.c              |   1 -
 arch/arm/mach-s3c24xx/mach-n30.c                   |   2 -
 arch/arm/mach-s3c24xx/mach-nexcoder.c              |   1 -
 arch/arm/mach-s3c24xx/mach-osiris.c                |   1 -
 arch/arm/mach-s3c24xx/mach-otom.c                  |   1 -
 arch/arm/mach-s3c24xx/mach-qt2410.c                |   1 -
 arch/arm/mach-s3c24xx/mach-rx1950.c                |   1 -
 arch/arm/mach-s3c24xx/mach-rx3715.c                |   1 -
 arch/arm/mach-s3c24xx/mach-s3c2416-dt.c            |   1 -
 arch/arm/mach-s3c24xx/mach-smdk2410.c              |   1 -
 arch/arm/mach-s3c24xx/mach-smdk2413.c              |   3 -
 arch/arm/mach-s3c24xx/mach-smdk2416.c              |   1 -
 arch/arm/mach-s3c24xx/mach-smdk2440.c              |   1 -
 arch/arm/mach-s3c24xx/mach-smdk2443.c              |   1 -
 arch/arm/mach-s3c24xx/mach-tct_hammer.c            |   1 -
 arch/arm/mach-s3c24xx/mach-vr1000.c                |   1 -
 arch/arm/mach-s3c24xx/mach-vstms.c                 |   1 -
 arch/arm/mach-s3c24xx/s3c2410.c                    |  13 -
 arch/arm/mach-s3c24xx/s3c2412.c                    |  23 -
 arch/arm/mach-s3c24xx/s3c2416.c                    |   8 -
 arch/arm/mach-s3c24xx/s3c2443.c                    |   8 -
 arch/arm/mach-s3c24xx/s3c244x.c                    |  12 -
 arch/arm/mach-s5pv210/pm.c                         |   3 +-
 .../mach-s5pv210/{include/mach => }/regs-clock.h   |   3 +-
 arch/arm/mach-s5pv210/s5pv210.c                    |   2 +-
 arch/arm/mach-shmobile/Kconfig                     |  77 ++-
 arch/arm/mach-shmobile/Makefile                    |  30 +-
 arch/arm/mach-shmobile/board-armadillo800eva.c     |   8 +-
 arch/arm/mach-shmobile/board-mackerel.c            |   2 +-
 arch/arm/mach-shmobile/pm-r8a7740.c                |  10 +-
 arch/arm/mach-shmobile/pm-rcar.c                   |   4 -
 arch/arm/mach-shmobile/pm-rmobile.c                |   2 -
 arch/arm/mach-shmobile/pm-rmobile.h                |   4 +-
 arch/arm/mach-shmobile/setup-r8a7740.c             |  26 +-
 arch/arm/mach-shmobile/setup-sh7372.c              |   2 +-
 arch/arm/mach-sunxi/sunxi.c                        |  76 ---
 arch/arm/plat-omap/dma.c                           | 737 +--------------------
 drivers/clocksource/tcb_clksrc.c                   |  15 +-
 drivers/misc/atmel_tclib.c                         | 101 ++-
 drivers/pwm/pwm-atmel-tcb.c                        |   2 +-
 include/linux/atmel_tc.h                           |  13 +-
 include/linux/omap-dma.h                           |  37 --
 110 files changed, 261 insertions(+), 4129 deletions(-)
 delete mode 100644 arch/arm/mach-at91/board-foxg20.c
 delete mode 100644 arch/arm/mach-at91/board-rsi-ews.c
 delete mode 100644 arch/arm/mach-exynos/include/mach/memory.h
 delete mode 100644 arch/arm/mach-imx/board-pcm038.h
 delete mode 100644 arch/arm/mach-imx/eukrea_mbimx27-baseboard.c
 delete mode 100644 arch/arm/mach-imx/mach-cpuimx27.c
 delete mode 100644 arch/arm/mach-imx/mach-mx1ads.c
 delete mode 100644 arch/arm/mach-imx/mach-mxt_td60.c
 delete mode 100644 arch/arm/mach-imx/mach-pcm038.c
 delete mode 100644 arch/arm/mach-imx/pcm970-baseboard.c
 delete mode 100644 arch/arm/mach-msm/board-mahimahi.c
 rename arch/arm/mach-s5pv210/{include/mach => }/regs-clock.h (99%)

