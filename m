Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760350Ab3DDMzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:55:12 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:48174 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760061Ab3DDMzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:55:10 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 00/18] For-3.10: CPUFreq: Move drivers to drivers/cpufreq
Date: Thu,  4 Apr 2013 18:24:08 +0530
Message-Id: <cover.1365079581.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

These are all the remaining patches i have for 3.10. All of them have received
Acks from their maintainers leaving powerpc ones. I have got an additional patch
for powerpc (18) this time, it was the only driver left out of drivers/cpufreq.

Please consider them for applying to your bleeding-edge or linux-next.

-------------x--------------x-------------

This patchset targets towards moving all platform specific cpufreq drivers to
drivers/cpufreq. This will lead to better consolidation code in future too.

All ARM and powerpc patches are compile tested by me.

Changes since earlier version:
- Additional patch 18/18

Viresh Kumar (18):
  cpufreq: ARM: Arrange drivers in alphabetical order
  cpufreq: tegra: Move driver to drivers/cpufreq
  cpufreq: davinci: move cpufreq driver to drivers/cpufreq
  cpufreq: pxa3xx: move cpufreq driver to drivers/cpufreq
  cpufreq: pxa2xx: move cpufreq driver to drivers/cpufreq
  cpufreq: integrator: move cpufreq driver to drivers/cpufreq
  cpufreq: s3c24xx: move cpufreq driver to drivers/cpufreq
  cpufreq: sa11x0: move cpufreq driver to drivers/cpufreq
  cpufreq: AVR32: move cpufreq driver to drivers/cpufreq
  cpufreq: blackfin: move cpufreq driver to drivers/cpufreq
  cpufreq: cris: move cpufreq driver to drivers/cpufreq
  cpufreq: ia64: move cpufreq driver to drivers/cpufreq
  cpufreq: mips: move cpufreq driver to drivers/cpufreq
  cpufreq: sh: move cpufreq driver to drivers/cpufreq
  cpufreq: unicore2: move cpufreq driver to drivers/cpufreq
  cpufreq: sparc: move cpufreq driver to drivers/cpufreq
  cpufreq: powerpc: move cpufreq driver to drivers/cpufreq
  cpufreq: powerpc/platforms/cell: move cpufreq driver to
    drivers/cpufreq

 arch/arm/Kconfig                                   |  72 --------
 arch/arm/mach-davinci/Makefile                     |   1 -
 arch/arm/mach-integrator/Makefile                  |   1 -
 arch/arm/mach-pxa/Makefile                         |   6 -
 arch/arm/mach-pxa/include/mach/generic.h           |   1 +
 arch/arm/mach-s3c24xx/Kconfig                      |  66 +++-----
 arch/arm/mach-s3c24xx/Makefile                     |   6 -
 arch/arm/mach-s3c24xx/{ => include/mach}/s3c2412.h |   0
 arch/arm/mach-s3c24xx/iotiming-s3c2412.c           |   2 +-
 arch/arm/mach-sa1100/Kconfig                       |  26 +--
 arch/arm/mach-sa1100/Makefile                      |   3 -
 arch/arm/mach-sa1100/include/mach/generic.h        |   1 +
 arch/arm/mach-tegra/Makefile                       |   1 -
 arch/arm/plat-samsung/include/plat/cpu-freq-core.h |  10 +-
 arch/arm/plat-samsung/include/plat/cpu-freq.h      |   6 +-
 arch/avr32/Kconfig                                 |  13 --
 arch/avr32/configs/atngw100_defconfig              |   2 +-
 arch/avr32/configs/atngw100_evklcd100_defconfig    |   2 +-
 arch/avr32/configs/atngw100_evklcd101_defconfig    |   2 +-
 arch/avr32/configs/atngw100_mrmt_defconfig         |   2 +-
 arch/avr32/configs/atngw100mkii_defconfig          |   2 +-
 .../avr32/configs/atngw100mkii_evklcd100_defconfig |   2 +-
 .../avr32/configs/atngw100mkii_evklcd101_defconfig |   2 +-
 arch/avr32/configs/atstk1002_defconfig             |   2 +-
 arch/avr32/configs/atstk1003_defconfig             |   2 +-
 arch/avr32/configs/atstk1004_defconfig             |   2 +-
 arch/avr32/configs/atstk1006_defconfig             |   2 +-
 arch/avr32/configs/favr-32_defconfig               |   2 +-
 arch/avr32/configs/hammerhead_defconfig            |   2 +-
 arch/avr32/configs/mimc200_defconfig               |   2 +-
 arch/avr32/mach-at32ap/Makefile                    |   1 -
 arch/blackfin/mach-common/Makefile                 |   1 -
 arch/cris/arch-v32/mach-a3/Makefile                |   1 -
 arch/cris/arch-v32/mach-fs/Makefile                |   1 -
 arch/ia64/Kconfig                                  |   6 +-
 arch/ia64/kernel/Makefile                          |   1 -
 arch/ia64/kernel/cpufreq/Kconfig                   |  29 ----
 arch/ia64/kernel/cpufreq/Makefile                  |   2 -
 arch/mips/Kconfig                                  |   9 +-
 arch/mips/kernel/Makefile                          |   2 -
 arch/mips/kernel/cpufreq/Kconfig                   |  41 -----
 arch/mips/kernel/cpufreq/Makefile                  |   5 -
 arch/powerpc/platforms/Kconfig                     |  31 ----
 arch/powerpc/platforms/cell/Kconfig                |  26 +--
 arch/powerpc/platforms/cell/Makefile               |   3 -
 arch/powerpc/platforms/pasemi/Makefile             |   1 -
 arch/powerpc/platforms/powermac/Makefile           |   2 -
 arch/sh/Kconfig                                    |  18 --
 arch/sh/kernel/Makefile                            |   1 -
 arch/sparc/Kconfig                                 |  23 ---
 arch/sparc/kernel/Makefile                         |   3 -
 arch/unicore32/kernel/Makefile                     |   1 -
 drivers/cpufreq/Kconfig                            |  89 ++++++++++
 drivers/cpufreq/Kconfig.arm                        | 184 ++++++++++++++-------
 drivers/cpufreq/Kconfig.powerpc                    |  44 +++++
 drivers/cpufreq/Makefile                           |  42 ++++-
 .../cpufreq.c => drivers/cpufreq/at32ap-cpufreq.c  |   0
 .../cpufreq/blackfin-cpufreq.c                     |   0
 .../cpufreq/cris-artpec3-cpufreq.c                 |   0
 .../cpufreq/cris-etraxfs-cpufreq.c                 |   0
 .../cpufreq.c => drivers/cpufreq/davinci-cpufreq.c |   2 -
 .../cpufreq/ia64-acpi-cpufreq.c                    |   1 -
 .../cpu.c => drivers/cpufreq/integrator-cpufreq.c  |   2 -
 .../kernel => drivers}/cpufreq/loongson2_cpufreq.c |   0
 .../cpufreq.c => drivers/cpufreq/pasemi-cpufreq.c  |   0
 .../cpufreq/pmac32-cpufreq.c                       |   0
 .../cpufreq/pmac64-cpufreq.c                       |   0
 .../cpufreq/ppc_cbe_cpufreq.c                      |   2 +-
 .../cpufreq/ppc_cbe_cpufreq_pervasive.c            |   3 +-
 .../cpufreq/ppc_cbe_cpufreq_pmi.c                  |   3 +-
 .../cpufreq/pxa2xx-cpufreq.c                       |   2 -
 .../cpufreq/pxa3xx-cpufreq.c                       |   5 +-
 .../cpufreq/s3c2410-cpufreq.c                      |   0
 .../cpufreq/s3c2412-cpufreq.c                      |   3 +-
 .../cpufreq/s3c2440-cpufreq.c                      |   0
 .../cpufreq/s3c24xx-cpufreq-debugfs.c              |   0
 .../cpufreq.c => drivers/cpufreq/s3c24xx-cpufreq.c |   0
 .../cpufreq/sa1100-cpufreq.c                       |   3 +-
 .../cpufreq/sa1110-cpufreq.c                       |   3 +-
 .../cpufreq.c => drivers/cpufreq/sh-cpufreq.c      |   2 -
 .../cpufreq/sparc-us2e-cpufreq.c                   |   0
 .../cpufreq/sparc-us3-cpufreq.c                    |   0
 .../cpu-tegra.c => drivers/cpufreq/tegra-cpufreq.c |   2 -
 .../cpufreq/unicore2-cpufreq.c                     |   2 +-
 .../linux/ppc_cbe_cpufreq.h                        |   4 +-
 85 files changed, 385 insertions(+), 464 deletions(-)
 create mode 100644 arch/arm/mach-pxa/include/mach/generic.h
 rename arch/arm/mach-s3c24xx/{ => include/mach}/s3c2412.h (100%)
 create mode 100644 arch/arm/mach-sa1100/include/mach/generic.h
 delete mode 100644 arch/ia64/kernel/cpufreq/Kconfig
 delete mode 100644 arch/ia64/kernel/cpufreq/Makefile
 delete mode 100644 arch/mips/kernel/cpufreq/Kconfig
 delete mode 100644 arch/mips/kernel/cpufreq/Makefile
 rename arch/avr32/mach-at32ap/cpufreq.c => drivers/cpufreq/at32ap-cpufreq.c (100%)
 rename arch/blackfin/mach-common/cpufreq.c => drivers/cpufreq/blackfin-cpufreq.c (100%)
 rename arch/cris/arch-v32/mach-a3/cpufreq.c => drivers/cpufreq/cris-artpec3-cpufreq.c (100%)
 rename arch/cris/arch-v32/mach-fs/cpufreq.c => drivers/cpufreq/cris-etraxfs-cpufreq.c (100%)
 rename arch/arm/mach-davinci/cpufreq.c => drivers/cpufreq/davinci-cpufreq.c (99%)
 rename arch/ia64/kernel/cpufreq/acpi-cpufreq.c => drivers/cpufreq/ia64-acpi-cpufreq.c (99%)
 rename arch/arm/mach-integrator/cpu.c => drivers/cpufreq/integrator-cpufreq.c (99%)
 rename {arch/mips/kernel => drivers}/cpufreq/loongson2_cpufreq.c (100%)
 rename arch/powerpc/platforms/pasemi/cpufreq.c => drivers/cpufreq/pasemi-cpufreq.c (100%)
 rename arch/powerpc/platforms/powermac/cpufreq_32.c => drivers/cpufreq/pmac32-cpufreq.c (100%)
 rename arch/powerpc/platforms/powermac/cpufreq_64.c => drivers/cpufreq/pmac64-cpufreq.c (100%)
 rename arch/powerpc/platforms/cell/cbe_cpufreq.c => drivers/cpufreq/ppc_cbe_cpufreq.c (99%)
 rename arch/powerpc/platforms/cell/cbe_cpufreq_pervasive.c => drivers/cpufreq/ppc_cbe_cpufreq_pervasive.c (98%)
 rename arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c => drivers/cpufreq/ppc_cbe_cpufreq_pmi.c (99%)
 rename arch/arm/mach-pxa/cpufreq-pxa2xx.c => drivers/cpufreq/pxa2xx-cpufreq.c (99%)
 rename arch/arm/mach-pxa/cpufreq-pxa3xx.c => drivers/cpufreq/pxa3xx-cpufreq.c (98%)
 rename arch/arm/mach-s3c24xx/cpufreq-s3c2410.c => drivers/cpufreq/s3c2410-cpufreq.c (100%)
 rename arch/arm/mach-s3c24xx/cpufreq-s3c2412.c => drivers/cpufreq/s3c2412-cpufreq.c (99%)
 rename arch/arm/mach-s3c24xx/cpufreq-s3c2440.c => drivers/cpufreq/s3c2440-cpufreq.c (100%)
 rename arch/arm/mach-s3c24xx/cpufreq-debugfs.c => drivers/cpufreq/s3c24xx-cpufreq-debugfs.c (100%)
 rename arch/arm/mach-s3c24xx/cpufreq.c => drivers/cpufreq/s3c24xx-cpufreq.c (100%)
 rename arch/arm/mach-sa1100/cpu-sa1100.c => drivers/cpufreq/sa1100-cpufreq.c (99%)
 rename arch/arm/mach-sa1100/cpu-sa1110.c => drivers/cpufreq/sa1110-cpufreq.c (99%)
 rename arch/sh/kernel/cpufreq.c => drivers/cpufreq/sh-cpufreq.c (99%)
 rename arch/sparc/kernel/us2e_cpufreq.c => drivers/cpufreq/sparc-us2e-cpufreq.c (100%)
 rename arch/sparc/kernel/us3_cpufreq.c => drivers/cpufreq/sparc-us3-cpufreq.c (100%)
 rename arch/arm/mach-tegra/cpu-tegra.c => drivers/cpufreq/tegra-cpufreq.c (99%)
 rename arch/unicore32/kernel/cpu-ucv2.c => drivers/cpufreq/unicore2-cpufreq.c (96%)
 rename arch/powerpc/platforms/cell/cbe_cpufreq.h => include/linux/ppc_cbe_cpufreq.h (82%)

-- 
1.7.12.rc2.18.g61b472e

