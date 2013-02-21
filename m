Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab3BUVM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 16:12:58 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:63926 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab3BUVMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 16:12:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 04/09] arm-soc: driver specific changes
Date: Thu, 21 Feb 2013 21:12:24 +0000
Message-Id: <1361481149-27559-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361481149-27559-1-git-send-email-arnd@arndb.de>
References: <1361481149-27559-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:WQXlyP/IQEq1gh8zP89ECDp8j6efIF31CqWfmCWC0zy
 jCeGqhQIbMp2eCVuto4rvPk132VwtA/MYUoskAedZ2hHvfMmXr
 Dvz6A0QGJrfd6wH282T8dwyeNL343JogSxcvfRS1P4TXwxy+yR
 J1MDISGk+SCcgg6xSwTfEtISJyfhrdq4oRm0pyE8HVCzgWrCfY
 +8FOsIY8KGNHicDz1c8GhAsXgX31cTxM20HIP169axth4V6lJ7
 VuT6IDStbO8Id0pJXXhYTc/eS1l7qSXhT2nTfPDrHOMs6jXJHq
 ZXVfG5E8NZHvZtm/PcizBYljl60WbYMRD1B13o/k6eP5AmSynn
 hBL7AjjY4wewbP35UlXyrRRGZIx9YE77gjWKTCH9s
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 949db153b6466c6f7cad5a427ecea94985927311:

  Linux 3.8-rc5 (2013-01-25 11:57:28 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/drivers

for you to fetch changes up to b6a03d0492dedb5c10b8a5708ee92e04b0590c07:

  Merge tag 'omap-for-v3.9/gpmc-signed' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into next/drivers (2013-02-05 14:03:45 -0800)

----------------------------------------------------------------

arm-soc: driver specific changes

* Updates to the ux500 cpufreq code
* Moving the u300 DMA controller driver to drivers/dma
* Moving versatile express drivers out of arch/arm for sharing with arch/arm64
* Device tree bindings for the OMAP General Purpose Memory Controller

There is a simple conflict in drivers/cpufreq/dbx500-cpufreq.c, because
the mach/id.h header and the cpu_is_u8500_family() function in it are
now gone.

----------------------------------------------------------------

Catalin Marinas (1):
      arm: Move sp810.h to include/linux/amba/

Daniel Mack (5):
      ARM: OMAP: gpmc: don't create devices from initcall on DT
      mtd: omap-nand: pass device_node in platform data
      ARM: OMAP: gpmc-nand: drop __init annotation
      ARM: OMAP: gpmc: enable hwecc for AM33xx SoCs
      ARM: OMAP: gpmc: add DT bindings for GPMC timings and NAND

Ezequiel Garcia (4):
      ARM: OMAP2+: gpmc: Remove unneeded of_node_put()
      mtd: omap-onenand: pass device_node in platform data
      ARM: OMAP2+: gpmc-onenand: drop __init annotation
      ARM: OMAP2+: gpmc: add DT bindings for OneNAND

Fabio Baltieri (2):
      clocksource: nomadik-mtu: support timer-based delay
      cpufreq: db8500: set CPUFREQ_CONST_LOOPS

Jon Hunter (1):
      ARM: OMAP2+: Prevent potential crash if GPMC probe fails

Jonas Aaberg (1):
      cpufreq: dbx500: Minor code cleanup

Lee Jones (3):
      cpufreq: Give driver used for dbx500 family a more generic name
      mfd: db8500: Update cpufreq device name
      cpufreq: dbx500: Update file header

Linus Walleij (8):
      dma: coh901318: create a proper platform data file
      dma: coh901318: push platform data into driver
      dma: coh901318: remove hardcoded target addresses
      dma: coh901318: skip hard-coded addresses
      dma: coh901318: push header down into the DMA subsystem
      dma: coh901318: push definitions into driver
      dma: coh901318: merge header files
      dma: coh901318: cut down on platform data abstraction

Olof Johansson (5):
      Merge tag 'ux500-cpufreq-for-arm-soc' of git://git.kernel.org/.../linusw/linux-stericsson into next/drivers
      Merge branch 'depends/cleanup' into next/drivers
      Merge tag 'coh901318-for-arm-soc' of http://git.kernel.org/.../linusw/linux-stericsson into next/drivers
      Merge tag 'vexpress/drivers-for-3.9' of git://git.linaro.org/people/pawelmoll/linux into next/drivers
      Merge tag 'omap-for-v3.9/gpmc-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/drivers

Philip Avinash (1):
      ARM: OMAP2+: gpmc: Add device tree documentation for elm handle

Ulf Hansson (1):
      cpufreq: dbx500: Move clk_get to probe

 Documentation/devicetree/bindings/bus/ti-gpmc.txt  |   84 ++
 .../devicetree/bindings/mtd/gpmc-nand.txt          |   80 ++
 .../devicetree/bindings/mtd/gpmc-onenand.txt       |   43 +
 arch/arm/arm-soc-for-next-contents.txt             |   13 +-
 arch/arm/mach-omap2/gpmc-nand.c                    |   15 +-
 arch/arm/mach-omap2/gpmc-onenand.c                 |    2 +-
 arch/arm/mach-omap2/gpmc.c                         |  232 +++-
 arch/arm/mach-u300/core.c                          | 1087 +---------------
 arch/arm/mach-u300/dma_channels.h                  |   60 -
 arch/arm/mach-u300/include/mach/coh901318.h        |  267 ----
 arch/arm/mach-u300/spi.c                           |    3 +-
 arch/arm/plat-spear/restart.c                      |    2 +-
 drivers/clk/versatile/clk-vexpress.c               |    3 +-
 drivers/clocksource/nomadik-mtu.c                  |   11 +
 drivers/cpufreq/Makefile                           |    2 +-
 .../cpufreq/{db8500-cpufreq.c => dbx500-cpufreq.c} |  101 +-
 drivers/dma/coh901318.c                            | 1302 +++++++++++++++++++-
 drivers/dma/{coh901318_lli.h => coh901318.h}       |   35 +-
 drivers/dma/coh901318_lli.c                        |    4 +-
 drivers/mfd/db8500-prcmu.c                         |    4 +-
 drivers/mtd/nand/omap2.c                           |    4 +-
 drivers/mtd/onenand/omap2.c                        |    4 +-
 .../asm/hardware => include/linux/amba}/sp810.h    |    0
 include/linux/platform_data/dma-coh901318.h        |   72 ++
 include/linux/platform_data/mtd-nand-omap2.h       |    4 +-
 include/linux/platform_data/mtd-onenand-omap2.h    |    3 +
 26 files changed, 1892 insertions(+), 1545 deletions(-)
