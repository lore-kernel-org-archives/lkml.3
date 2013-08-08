Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab3HHNs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:48:56 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:42180 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858Ab3HHNsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:48:54 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 00/35] cpufreq: Introduce cpufreq_table_validate_and_show()
Date: Thu,  8 Aug 2013 19:18:02 +0530
Message-Id: <cover.1375964117.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is actually part of a bigger patchset which will change declaration of
cpufreq_driver->target() to include index instead of target_freq and relation
and hence cpufreq drivers wouldn't require to cpufreq_frequency_table_target()
anymore.

Almost every cpufreq driver is required to validate its frequency table with:
cpufreq_frequency_table_cpuinfo() and then expose it to cpufreq core with:
cpufreq_frequency_table_get_attr().

This patch creates another helper routine cpufreq_table_validate_and_show() that
will do both these steps in a single call and will return 0 for success, error
otherwise.

This also fixes potential bugs in cpufreq drivers where people have called
cpufreq_frequency_table_get_attr() before calling
cpufreq_frequency_table_cpuinfo(), as the later may fail.

Viresh Kumar (35):
  cpufreq: Add new helper cpufreq_table_validate_and_show()
  cpufreq: pxa: call cpufreq_frequency_table_get_attr()
  cpufreq: s3cx4xx: call cpufreq_frequency_table_get_attr()
  cpufreq: sparc: call cpufreq_frequency_table_get_attr()
  cpufreq: acpi-cpufreq: use cpufreq_table_validate_and_show()
  cpufreq: arm_big_little: use cpufreq_table_validate_and_show()
  cpufreq: blackfin: use cpufreq_table_validate_and_show()
  cpufreq: cpufreq-cpu0: use cpufreq_table_validate_and_show()
  cpufreq: cris: use cpufreq_table_validate_and_show()
  cpufreq: davinci: use cpufreq_table_validate_and_show()
  cpufreq: dbx500: use cpufreq_table_validate_and_show()
  cpufreq: e_powersaver: use cpufreq_table_validate_and_show()
  cpufreq: elanfreq: use cpufreq_table_validate_and_show()
  cpufreq: exynos: use cpufreq_table_validate_and_show()
  cpufreq: ia64-acpi: use cpufreq_table_validate_and_show()
  cpufreq: imx6q: use cpufreq_table_validate_and_show()
  cpufreq: kirkwood: use cpufreq_table_validate_and_show()
  cpufreq: longhaul: use cpufreq_table_validate_and_show()
  cpufreq: loongson2: use cpufreq_table_validate_and_show()
  cpufreq: maple: use cpufreq_table_validate_and_show()
  cpufreq: omap: use cpufreq_table_validate_and_show()
  cpufreq: p4-clockmod: use cpufreq_table_validate_and_show()
  cpufreq: pasemi: use cpufreq_table_validate_and_show()
  cpufreq: pmac: use cpufreq_table_validate_and_show()
  cpufreq: powernow: use cpufreq_table_validate_and_show()
  cpufreq: ppc: use cpufreq_table_validate_and_show()
  cpufreq: pxa: use cpufreq_table_validate_and_show()
  cpufreq: s3cx4xx: use cpufreq_table_validate_and_show()
  cpufreq: s5pv210: use cpufreq_table_validate_and_show()
  cpufreq: sc520: use cpufreq_table_validate_and_show()
  cpufreq: sh: use cpufreq_table_validate_and_show()
  cpufreq: sparc: use cpufreq_table_validate_and_show()
  cpufreq: spear: use cpufreq_table_validate_and_show()
  cpufreq: speedstep: use cpufreq_table_validate_and_show()
  cpufreq: tegra: use cpufreq_table_validate_and_show()

 drivers/cpufreq/acpi-cpufreq.c         |  4 +---
 drivers/cpufreq/arm_big_little.c       |  4 +---
 drivers/cpufreq/blackfin-cpufreq.c     |  3 +--
 drivers/cpufreq/cpufreq-cpu0.c         |  4 +---
 drivers/cpufreq/cris-artpec3-cpufreq.c | 10 +---------
 drivers/cpufreq/cris-etraxfs-cpufreq.c | 10 +---------
 drivers/cpufreq/davinci-cpufreq.c      |  6 ++----
 drivers/cpufreq/dbx500-cpufreq.c       |  6 ++----
 drivers/cpufreq/e_powersaver.c         |  3 +--
 drivers/cpufreq/elanfreq.c             |  8 +-------
 drivers/cpufreq/exynos-cpufreq.c       |  4 +---
 drivers/cpufreq/exynos5440-cpufreq.c   |  4 +---
 drivers/cpufreq/freq_table.c           | 12 ++++++++++++
 drivers/cpufreq/ia64-acpi-cpufreq.c    |  4 +---
 drivers/cpufreq/imx6q-cpufreq.c        |  3 +--
 drivers/cpufreq/kirkwood-cpufreq.c     | 10 +---------
 drivers/cpufreq/longhaul.c             |  8 +-------
 drivers/cpufreq/loongson2_cpufreq.c    |  5 +----
 drivers/cpufreq/maple-cpufreq.c        |  4 +---
 drivers/cpufreq/omap-cpufreq.c         |  4 +---
 drivers/cpufreq/p4-clockmod.c          |  3 +--
 drivers/cpufreq/pasemi-cpufreq.c       |  4 +---
 drivers/cpufreq/pmac32-cpufreq.c       |  3 +--
 drivers/cpufreq/pmac64-cpufreq.c       |  4 +---
 drivers/cpufreq/powernow-k6.c          |  9 +--------
 drivers/cpufreq/powernow-k7.c          |  4 +---
 drivers/cpufreq/powernow-k8.c          |  4 +---
 drivers/cpufreq/ppc-corenet-cpufreq.c  |  3 +--
 drivers/cpufreq/ppc_cbe_cpufreq.c      |  4 +---
 drivers/cpufreq/pxa2xx-cpufreq.c       |  8 +++++---
 drivers/cpufreq/pxa3xx-cpufreq.c       |  2 +-
 drivers/cpufreq/s3c2416-cpufreq.c      |  4 +---
 drivers/cpufreq/s3c24xx-cpufreq.c      |  2 +-
 drivers/cpufreq/s3c64xx-cpufreq.c      |  2 +-
 drivers/cpufreq/s5pv210-cpufreq.c      |  4 +---
 drivers/cpufreq/sc520_freq.c           |  9 +--------
 drivers/cpufreq/sh-cpufreq.c           |  6 +++---
 drivers/cpufreq/sparc-us2e-cpufreq.c   |  2 +-
 drivers/cpufreq/sparc-us3-cpufreq.c    |  2 +-
 drivers/cpufreq/spear-cpufreq.c        |  5 ++---
 drivers/cpufreq/speedstep-centrino.c   | 10 +---------
 drivers/cpufreq/speedstep-ich.c        |  9 +--------
 drivers/cpufreq/speedstep-smi.c        |  8 +-------
 drivers/cpufreq/tegra-cpufreq.c        |  4 +---
 include/linux/cpufreq.h                |  2 ++
 45 files changed, 66 insertions(+), 167 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

