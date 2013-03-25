Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab3CYKMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:12:01 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48991 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398Ab3CYKL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:11:58 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: arvind.chauhan@arm.com, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd.bergmann@linaro.org, linux@arm.linux.org.uk,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 0/9] ARM: CPUFreq: Move drivers arch/arm/ -> drivers/cpufreq
Date: Mon, 25 Mar 2013 15:41:31 +0530
Message-Id: <cover.1364205812.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
X-OriginalArrivalTime: 25 Mar 2013 10:11:53.0672 (UTC) FILETIME=[2C830480:01CE2941]
X-MC-Unique: 113032510115612501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r2PAH4Ws026870

Hi,

This patchset tries to move all CPUFreq drivers for ARM platforms from arch/arm
to drivers/cpufreq directory.

This series is dependent (rebased of) on following patches:

http://www.spinics.net/lists/arm-kernel/msg232540.html
https://lkml.org/lkml/2013/3/24/151

I want this series to go through Rafael's tree due to dependencies and so want
Ack's by respective maintainers.

These are applied here for people looking to test them:

http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/cpufreq-move-drivers

Viresh Kumar (9):
  cpufreq: ARM: Arrange drivers in alphabetical order
  cpufreq: tegra: Move driver to drivers/cpufreq
  cpufreq: davinci: move cpufreq driver to drivers/cpufreq
  cpufreq: imx: move cpufreq driver to drivers/cpufreq
  cpufreq: integrator: move cpufreq driver to drivers/cpufreq
  cpufreq: pxa3xx: move cpufreq driver to drivers/cpufreq
  cpufreq: pxa2xx: move cpufreq driver to drivers/cpufreq
  cpufreq: s3c24xx: move cpufreq driver to drivers/cpufreq
  cpufreq: sa11x0: move cpufreq driver to drivers/cpufreq

 arch/arm/Kconfig                                   |  79 ---------
 arch/arm/mach-davinci/Makefile                     |   1 -
 arch/arm/mach-imx/Makefile                         |   1 -
 arch/arm/mach-imx/mxc.h                            |   6 +-
 arch/arm/mach-integrator/Makefile                  |   1 -
 arch/arm/mach-pxa/Makefile                         |   6 -
 arch/arm/mach-pxa/include/mach/generic.h           |   1 +
 arch/arm/mach-s3c24xx/Kconfig                      |  66 +++----
 arch/arm/mach-s3c24xx/Makefile                     |   6 -
 arch/arm/mach-s3c24xx/{ => include/mach}/s3c2412.h |   0
 arch/arm/mach-s3c24xx/iotiming-s3c2412.c           |   2 +-
 arch/arm/mach-sa1100/Kconfig                       |  26 +--
 arch/arm/mach-sa1100/Makefile                      |   3 -
 arch/arm/mach-sa1100/include/mach/generic.h        |   1 +
 arch/arm/mach-tegra/Makefile                       |   1 -
 arch/arm/plat-samsung/include/plat/cpu-freq-core.h |  10 +-
 arch/arm/plat-samsung/include/plat/cpu-freq.h      |   6 +-
 drivers/cpufreq/Kconfig.arm                        | 191 +++++++++++++++------
 drivers/cpufreq/Makefile                           |  24 ++-
 .../cpufreq.c => drivers/cpufreq/davinci-cpufreq.c |   2 -
 .../cpufreq.c => drivers/cpufreq/imx-cpufreq.c     |   7 +-
 .../cpu.c => drivers/cpufreq/integrator-cpufreq.c  |   2 -
 .../cpufreq/pxa2xx-cpufreq.c                       |   2 -
 .../cpufreq/pxa3xx-cpufreq.c                       |   5 +-
 .../cpufreq/s3c2410-cpufreq.c                      |   0
 .../cpufreq/s3c2412-cpufreq.c                      |   3 +-
 .../cpufreq/s3c2440-cpufreq.c                      |   0
 .../cpufreq/s3c24xx-cpufreq-debugfs.c              |   0
 .../cpufreq.c => drivers/cpufreq/s3c24xx-cpufreq.c |   0
 .../cpufreq/sa1100-cpufreq.c                       |   3 +-
 .../cpufreq/sa1110-cpufreq.c                       |   3 +-
 .../cpu-tegra.c => drivers/cpufreq/tegra-cpufreq.c |   2 -
 include/linux/cpufreq/imx.h                        |  10 ++
 33 files changed, 223 insertions(+), 247 deletions(-)
 create mode 100644 arch/arm/mach-pxa/include/mach/generic.h
 rename arch/arm/mach-s3c24xx/{ => include/mach}/s3c2412.h (100%)
 create mode 100644 arch/arm/mach-sa1100/include/mach/generic.h
 rename arch/arm/mach-davinci/cpufreq.c => drivers/cpufreq/davinci-cpufreq.c (99%)
 rename arch/arm/mach-imx/cpufreq.c => drivers/cpufreq/imx-cpufreq.c (99%)
 rename arch/arm/mach-integrator/cpu.c => drivers/cpufreq/integrator-cpufreq.c (99%)
 rename arch/arm/mach-pxa/cpufreq-pxa2xx.c => drivers/cpufreq/pxa2xx-cpufreq.c (99%)
 rename arch/arm/mach-pxa/cpufreq-pxa3xx.c => drivers/cpufreq/pxa3xx-cpufreq.c (98%)
 rename arch/arm/mach-s3c24xx/cpufreq-s3c2410.c => drivers/cpufreq/s3c2410-cpufreq.c (100%)
 rename arch/arm/mach-s3c24xx/cpufreq-s3c2412.c => drivers/cpufreq/s3c2412-cpufreq.c (99%)
 rename arch/arm/mach-s3c24xx/cpufreq-s3c2440.c => drivers/cpufreq/s3c2440-cpufreq.c (100%)
 rename arch/arm/mach-s3c24xx/cpufreq-debugfs.c => drivers/cpufreq/s3c24xx-cpufreq-debugfs.c (100%)
 rename arch/arm/mach-s3c24xx/cpufreq.c => drivers/cpufreq/s3c24xx-cpufreq.c (100%)
 rename arch/arm/mach-sa1100/cpu-sa1100.c => drivers/cpufreq/sa1100-cpufreq.c (99%)
 rename arch/arm/mach-sa1100/cpu-sa1110.c => drivers/cpufreq/sa1110-cpufreq.c (99%)
 rename arch/arm/mach-tegra/cpu-tegra.c => drivers/cpufreq/tegra-cpufreq.c (99%)
 create mode 100644 include/linux/cpufreq/imx.h

-- 
1.7.12.rc2.18.g61b472e


