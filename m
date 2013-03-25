Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab3CYQzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 12:55:04 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:37497 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758086Ab3CYQzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 12:55:01 -0400
X-Greylist: delayed 91492 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Mar 2013 12:55:01 EDT
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: arvind.chauhan@arm.com, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd.bergmann@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 0/9] CPUFreq: Move drivers to drivers/cpufreq - Part 2
Date: Mon, 25 Mar 2013 22:24:36 +0530
Message-Id: <cover.1364229828.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the second patchset toward migrating all cpufreq drivers to
drivers/cpufreq (Earlier one was for ARM drivers).

These are all applied here:

http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/cpufreq-move-drivers

They aren't tested, not even compilation.

Viresh Kumar (9):
  AVR32: cpufreq:  move cpufreq driver to drivers/cpufreq
  blackfin: cpufreq:  move cpufreq driver to drivers/cpufreq
  cris: cpufreq:  move cpufreq driver to drivers/cpufreq
  ia64: cpufreq:  move cpufreq driver to drivers/cpufreq
  mips: cpufreq:  move cpufreq driver to drivers/cpufreq
  sh: cpufreq:  move cpufreq driver to drivers/cpufreq
  unicore2: cpufreq:  move cpufreq driver to drivers/cpufreq
  spark: cpufreq:  move cpufreq driver to drivers/cpufreq
  powerpc: cpufreq:  move cpufreq driver to drivers/cpufreq

 arch/avr32/Kconfig                                 | 13 ----
 arch/avr32/configs/atngw100_defconfig              |  2 +-
 arch/avr32/configs/atngw100_evklcd100_defconfig    |  2 +-
 arch/avr32/configs/atngw100_evklcd101_defconfig    |  2 +-
 arch/avr32/configs/atngw100_mrmt_defconfig         |  2 +-
 arch/avr32/configs/atngw100mkii_defconfig          |  2 +-
 .../avr32/configs/atngw100mkii_evklcd100_defconfig |  2 +-
 .../avr32/configs/atngw100mkii_evklcd101_defconfig |  2 +-
 arch/avr32/configs/atstk1002_defconfig             |  2 +-
 arch/avr32/configs/atstk1003_defconfig             |  2 +-
 arch/avr32/configs/atstk1004_defconfig             |  2 +-
 arch/avr32/configs/atstk1006_defconfig             |  2 +-
 arch/avr32/configs/favr-32_defconfig               |  2 +-
 arch/avr32/configs/hammerhead_defconfig            |  2 +-
 arch/avr32/configs/mimc200_defconfig               |  2 +-
 arch/avr32/mach-at32ap/Makefile                    |  1 -
 arch/blackfin/mach-common/Makefile                 |  1 -
 arch/cris/arch-v32/mach-a3/Makefile                |  1 -
 arch/cris/arch-v32/mach-fs/Makefile                |  1 -
 arch/ia64/Kconfig                                  |  5 +-
 arch/ia64/kernel/Makefile                          |  1 -
 arch/ia64/kernel/cpufreq/Kconfig                   | 29 -------
 arch/ia64/kernel/cpufreq/Makefile                  |  2 -
 arch/mips/Kconfig                                  |  9 ++-
 arch/mips/kernel/Makefile                          |  2 -
 arch/mips/kernel/cpufreq/Kconfig                   | 41 ----------
 arch/mips/kernel/cpufreq/Makefile                  |  5 --
 arch/powerpc/platforms/Kconfig                     | 31 --------
 arch/powerpc/platforms/pasemi/Makefile             |  1 -
 arch/powerpc/platforms/powermac/Makefile           |  2 -
 arch/sh/Kconfig                                    | 18 -----
 arch/sh/kernel/Makefile                            |  1 -
 arch/sparc/Kconfig                                 | 23 ------
 arch/sparc/kernel/Makefile                         |  3 -
 arch/unicore32/kernel/Makefile                     |  1 -
 drivers/cpufreq/Kconfig                            | 89 ++++++++++++++++++++++
 drivers/cpufreq/Kconfig.powerpc                    | 26 +++++++
 drivers/cpufreq/Makefile                           | 16 ++++
 .../cpufreq.c => drivers/cpufreq/at32ap-cpufreq.c  |  0
 .../cpufreq/blackfin-cpufreq.c                     |  0
 .../cpufreq/cris-artpec3-cpufreq.c                 |  0
 .../cpufreq/cris-etraxfs-cpufreq.c                 |  0
 .../cpufreq/ia64-acpi-cpufreq.c                    |  1 -
 .../kernel => drivers}/cpufreq/loongson2_cpufreq.c |  0
 .../cpufreq.c => drivers/cpufreq/pasemi-cpufreq.c  |  0
 .../cpufreq/pmac32-cpufreq.c                       |  0
 .../cpufreq/pmac64-cpufreq.c                       |  0
 .../cpufreq.c => drivers/cpufreq/sh-cpufreq.c      |  2 -
 .../cpufreq/spark-us2e-cpufreq.c                   |  0
 .../cpufreq/spark-us3-cpufreq.c                    |  0
 .../cpufreq/unicore2-cpufreq.c                     |  2 +-
 51 files changed, 156 insertions(+), 199 deletions(-)
 delete mode 100644 arch/ia64/kernel/cpufreq/Kconfig
 delete mode 100644 arch/ia64/kernel/cpufreq/Makefile
 delete mode 100644 arch/mips/kernel/cpufreq/Kconfig
 delete mode 100644 arch/mips/kernel/cpufreq/Makefile
 rename arch/avr32/mach-at32ap/cpufreq.c => drivers/cpufreq/at32ap-cpufreq.c (100%)
 rename arch/blackfin/mach-common/cpufreq.c => drivers/cpufreq/blackfin-cpufreq.c (100%)
 rename arch/cris/arch-v32/mach-a3/cpufreq.c => drivers/cpufreq/cris-artpec3-cpufreq.c (100%)
 rename arch/cris/arch-v32/mach-fs/cpufreq.c => drivers/cpufreq/cris-etraxfs-cpufreq.c (100%)
 rename arch/ia64/kernel/cpufreq/acpi-cpufreq.c => drivers/cpufreq/ia64-acpi-cpufreq.c (99%)
 rename {arch/mips/kernel => drivers}/cpufreq/loongson2_cpufreq.c (100%)
 rename arch/powerpc/platforms/pasemi/cpufreq.c => drivers/cpufreq/pasemi-cpufreq.c (100%)
 rename arch/powerpc/platforms/powermac/cpufreq_32.c => drivers/cpufreq/pmac32-cpufreq.c (100%)
 rename arch/powerpc/platforms/powermac/cpufreq_64.c => drivers/cpufreq/pmac64-cpufreq.c (100%)
 rename arch/sh/kernel/cpufreq.c => drivers/cpufreq/sh-cpufreq.c (99%)
 rename arch/sparc/kernel/us2e_cpufreq.c => drivers/cpufreq/spark-us2e-cpufreq.c (100%)
 rename arch/sparc/kernel/us3_cpufreq.c => drivers/cpufreq/spark-us3-cpufreq.c (100%)
 rename arch/unicore32/kernel/cpu-ucv2.c => drivers/cpufreq/unicore2-cpufreq.c (96%)

-- 
1.7.12.rc2.18.g61b472e

