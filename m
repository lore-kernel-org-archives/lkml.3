Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab3DAM6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 08:58:11 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:38164 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736Ab3DAM6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 08:58:08 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 0/9] CPUFreq Updates & Fixes for 3.10
Date: Mon,  1 Apr 2013 18:27:40 +0530
Message-Id: <cover.1364820620.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

These are fixes and updates that are sent and reviewed as separate patchsets
earlier. They are all now combined as part of a single patchset for you to apply
in your linux-next branch.

All have got reviews earlier and got fixups mailed and applied.

The remaining patches: "Move Cpufreq drivers to drivers/cpufreq" are awaiting
few more Acks before I send them to you.

I wanted to have another patch as part of this patchset, but I am awaiting Ack
for it:
tools: cpufreq: Fix cpufreq-info print messages for affected[related]_cpus

That can be applied separately once it receives an Ack.

Thanks
Viresh

Viresh Kumar (9):
  cpufreq: cpu0: Fix mistake in Documentation example
  cpufreq: Documentation: Fix cpufreq_frequency_table name
  cpufreq: cpufreq-cpu0: No need to check cpu number in init()
  cpufreq: cpufreq-cpu0: Call CPUFREQ_POSTCHANGE notifier for failure
    cases too
  cpufreq: Notify all policy->cpus in cpufreq_notify_transition()
  cpufreq: Don't check if cpu is online/offline for cpufreq callbacks
  cpufreq: drivers: don't check range of target freq in .target()
  cpufreq: drivers: Remove unnecessary assignments of policy-> members
  cpufreq: ARM big LITTLE: Add generic cpufreq driver and its DT glue

 Documentation/cpu-freq/cpu-drivers.txt             |   9 +-
 .../bindings/cpufreq/arm_big_little_dt.txt         |  65 +++++
 .../devicetree/bindings/cpufreq/cpufreq-cpu0.txt   |   2 +-
 MAINTAINERS                                        |  11 +
 arch/arm/mach-davinci/cpufreq.c                    |  33 +--
 arch/arm/mach-imx/cpufreq.c                        |   8 +-
 arch/arm/mach-integrator/cpu.c                     |   6 +-
 arch/arm/mach-pxa/cpufreq-pxa2xx.c                 |   5 +-
 arch/arm/mach-pxa/cpufreq-pxa3xx.c                 |   5 +-
 arch/arm/mach-s3c24xx/cpufreq.c                    |   8 +-
 arch/arm/mach-sa1100/cpu-sa1100.c                  |   5 +-
 arch/arm/mach-sa1100/cpu-sa1110.c                  |   5 +-
 arch/arm/mach-tegra/cpu-tegra.c                    |  15 +-
 arch/avr32/mach-at32ap/cpufreq.c                   |   5 +-
 arch/blackfin/mach-common/cpufreq.c                |  79 +++---
 arch/cris/arch-v32/mach-a3/cpufreq.c               |  20 +-
 arch/cris/arch-v32/mach-fs/cpufreq.c               |  17 +-
 arch/ia64/kernel/cpufreq/acpi-cpufreq.c            |  22 +-
 arch/mips/kernel/cpufreq/loongson2_cpufreq.c       |  11 +-
 arch/powerpc/platforms/cell/cbe_cpufreq.c          |   5 +-
 arch/powerpc/platforms/pasemi/cpufreq.c            |   5 +-
 arch/powerpc/platforms/powermac/cpufreq_32.c       |  14 +-
 arch/powerpc/platforms/powermac/cpufreq_64.c       |   5 +-
 arch/sh/kernel/cpufreq.c                           |  20 +-
 arch/sparc/kernel/us2e_cpufreq.c                   |  19 +-
 arch/sparc/kernel/us3_cpufreq.c                    |  19 +-
 arch/unicore32/kernel/cpu-ucv2.c                   |   5 +-
 drivers/cpufreq/Kconfig.arm                        |  12 +
 drivers/cpufreq/Makefile                           |   5 +
 drivers/cpufreq/acpi-cpufreq.c                     |  11 +-
 drivers/cpufreq/arm_big_little.c                   | 282 +++++++++++++++++++++
 drivers/cpufreq/arm_big_little.h                   |  40 +++
 drivers/cpufreq/arm_big_little_dt.c                |  92 +++++++
 drivers/cpufreq/cpufreq-cpu0.c                     |  28 +-
 drivers/cpufreq/cpufreq-nforce2.c                  |  11 +-
 drivers/cpufreq/cpufreq.c                          |  45 ++--
 drivers/cpufreq/dbx500-cpufreq.c                   |  12 +-
 drivers/cpufreq/e_powersaver.c                     |  11 +-
 drivers/cpufreq/elanfreq.c                         |  10 +-
 drivers/cpufreq/exynos-cpufreq.c                   |   7 +-
 drivers/cpufreq/gx-suspmod.c                       |  11 +-
 drivers/cpufreq/imx6q-cpufreq.c                    |  12 +-
 drivers/cpufreq/kirkwood-cpufreq.c                 |  10 +-
 drivers/cpufreq/longhaul.c                         |  18 +-
 drivers/cpufreq/maple-cpufreq.c                    |   5 +-
 drivers/cpufreq/omap-cpufreq.c                     |  15 +-
 drivers/cpufreq/p4-clockmod.c                      |  13 +-
 drivers/cpufreq/pcc-cpufreq.c                      |   5 +-
 drivers/cpufreq/powernow-k6.c                      |  12 +-
 drivers/cpufreq/powernow-k7.c                      |  10 +-
 drivers/cpufreq/powernow-k8.c                      |  19 +-
 drivers/cpufreq/s3c2416-cpufreq.c                  |   5 +-
 drivers/cpufreq/s3c64xx-cpufreq.c                  |   7 +-
 drivers/cpufreq/s5pv210-cpufreq.c                  |   5 +-
 drivers/cpufreq/sc520_freq.c                       |  10 +-
 drivers/cpufreq/spear-cpufreq.c                    |   7 +-
 drivers/cpufreq/speedstep-centrino.c               |  28 +-
 drivers/cpufreq/speedstep-ich.c                    |  12 +-
 drivers/cpufreq/speedstep-smi.c                    |   5 +-
 include/linux/cpufreq.h                            |   4 +-
 60 files changed, 773 insertions(+), 429 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/cpufreq/arm_big_little_dt.txt
 create mode 100644 drivers/cpufreq/arm_big_little.c
 create mode 100644 drivers/cpufreq/arm_big_little.h
 create mode 100644 drivers/cpufreq/arm_big_little_dt.c

-- 
1.7.12.rc2.18.g61b472e

