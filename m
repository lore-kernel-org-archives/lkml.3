Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281AbaFQPdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:33:50 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:54569 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932999AbaFQPdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:33:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org
Subject: ARM: SoC bug fixes
Date: Tue, 17 Jun 2014 17:33:45 +0200
Message-ID: <6661934.qBJd3kAAeu@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:krWbl5cAvNlDCi72kh7ilXnC0ea0iyOj5mKWN5ZXLeH
 9YaD3eWOuIx2IjVhT5+4F1jyLy08d671gsA6e+OkHPsoLomudP
 ovzaxqAJ41K4zr1NShToaU9xTYuaPanqj6bJrnGP6i8LeLNn0w
 OhwIH4RFN4ZnyTA/fClkjbCT5xrCs2xACQ57PUadHmdAiMlaM5
 8sL8dL4SPmQuz7AVot2i0BS46gxWqemqiP6Nur6Y87Mzh64nyK
 albd8yJvoojzkB7FW4R9u6z8gDI/JaSpydC7CuShxOG53RrHxH
 jlL7F7NwY54vA3GxexSyDW39WVxCUd+CiDDA76Zwf3gZ6M90qL
 t7aw4GLCnHXJd2XAxYlw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 2dc24b0d0636349d403ae803bbad0c84f6c2ea57:

  Merge tag 'soc2-for-3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc (2014-06-11 11:03:24 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to 21278aeafbfacfd62b3e613525f0c694a029dac1:

  ARM: use menuconfig for sub-arch menus (2014-06-17 17:09:48 +0200)

----------------------------------------------------------------
ARM: SoC fixes for 3.16

A first set of bug fixes that didn't make it for the merge window, and
two Kconfig cleanups that still make sense at this point. Unfortunately,
one of the two cleanups caused an unintended change in the original
version, so we had to revert one part of it and do some more testing
to ensure the rest is really fine. There was also a last-minute
rebase of the patches to remove another bad commit.

----------------------------------------------------------------
Arnd Bergmann (5):
      ARM: omap2: fix am43xx dependency on l2x0 cache
      ARM: keystone requires ARM_PATCH_PHYS_VIRT
      bus/arm-cci: add dependency on OF && CPU_V7
      remoteproc: da8xx: don't select CMA on no-MMU
      ARM: samsung: make SAMSUNG_DMADEV optional

Dan Carpenter (1):
      misc: vexpress: fix error handling vexpress_syscfg_regmap_init()

Ezequiel Garcia (2):
      ARM: dts: Specify the NAND ECC scheme explicitly on Armada 375 DB board
      ARM: dts: Specify the NAND ECC scheme explicitly on Armada 385 DB board

Jason Cooper (1):
      ARM: mvebu: DT: fix OpenBlocks AX3-4 RAM size

Linus Walleij (1):
      ARM: integrator: fix section mismatch problem

Olof Johansson (1):
      ARM: exynos: move sysram info to exynos.c

Rob Herring (2):
      ARM: exynos: cleanup kconfig option display
      ARM: use menuconfig for sub-arch menus

Sachin Kamat (1):
      ARM: EXYNOS: Fix compilation warning

Stephen Boyd (1):
      ARM: Remove ARCH_HAS_CPUFREQ config option

Stephen Warren (1):
      ARM: multi_v7_defconfig: re-enable SDHCI drivers

 arch/arm/Kconfig                                 | 20 +--------------
 arch/arm/boot/dts/armada-375-db.dts              |  2 ++
 arch/arm/boot/dts/armada-385-db.dts              |  2 ++
 arch/arm/boot/dts/armada-xp-openbl	ocks-ax3-4.dts |  2 +-
 arch/arm/configs/multi_v7_defconfig              |  1 +
 arch/arm/configs/omap2plus_defconfig             |  1 +
 arch/arm/mach-bcm/Kconfig                        |  7 +++---
 arch/arm/mach-berlin/Kconfig                     |  6 +----
 arch/arm/mach-cns3xxx/Kconfig                    |  7 +++---
 arch/arm/mach-davinci/Kconfig                    |  1 -
 arch/arm/mach-exynos/Kconfig                     |  7 +-----
 arch/arm/mach-exynos/common.h                    |  1 +
 arch/arm/mach-exynos/exynos.c                    | 31 +++++++++++++++++++++++-
 arch/arm/mach-exynos/platsmp.c                   | 26 ++------------------
 arch/arm/mach-highbank/Kconfig                   |  1 -
 arch/arm/mach-imx/Kconfig                        | 10 +++-----
 arch/arm/mach-integrator/Kconfig                 |  2 +-
 arch/arm/mach-integrator/impd1.c                 | 12 ++++++++-
 arch/arm/mach-keystone/Kconfig                   |  1 +
 arch/arm/mach-moxart/Kconfig                     |  2 +-
 arch/arm/mach-mvebu/Kconfig                      |  7 +-----
 arch/arm/mach-nomadik/Kconfig                    |  4 +--
 arch/arm/mach-omap2/Kconfig                      |  7 ++++--
 arch/arm/mach-omap2/common.h                     |  7 ++++++
 arch/arm/mach-prima2/Kconfig                     |  6 ++---
 arch/arm/mach-qcom/Kconfig                       |  6 +----
 arch/arm/mach-s3c24xx/Kconfig                    |  2 +-
 arch/arm/mach-s3c64xx/Kconfig                    |  4 +--
 arch/arm/mach-s5p64x0/Kconfig                    |  6 +++--
 arch/arm/mach-s5pc100/Kconfig                    |  3 ++-
 arch/arm/mach-s5pv210/Kconfig                    |  3 ++-
 arch/arm/mach-shmobile/Kconfig                   |  6 ++---
 arch/arm/mach-spear/Kconfig                      |  1 -
 arch/arm/mach-sti/Kconfig                        |  2 +-
 arch/arm/mach-tegra/Kconfig                      |  8 +++---
 arch/arm/mach-u300/Kconfig                       |  6 +----
 arch/arm/mach-ux500/Kconfig                      |  7 +-----
 arch/arm/mach-vexpress/Kconfig                   |  8 +++---
 arch/arm/mach-vt8500/Kconfig                     |  1 -
 arch/arm/mach-zynq/Kconfig                       |  1 -
 arch/arm/plat-samsung/Kconfig                    | 28 ++++++---------------
 drivers/bus/Kconfig                              |  2 +-
 drivers/misc/vexpress-syscfg.c                   | 12 ++++++---
 drivers/remoteproc/Kconfig                       |  2 +-
 44 files changed, 123 insertions(+), 158 deletions(-)

