Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab3HUOmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:42:43 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:49791 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab3HUOml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:42:41 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 00/14] cpufreq: create & use cpufreq_generic_init() routine
Date: Wed, 21 Aug 2013 20:12:19 +0530
Message-Id: <cover.1377093938.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many CPUFreq drivers for SMP system (where all cores share same clock lines), do
similar stuff in their ->init() part.

This patch creates a generic routine in cpufreq core which can be used by these
so that we can remove some redundant code. And later part of patchset makes
other drivers use this infrastructure.

Many drivers which weren't setting policy->cpus haven't been updated as they
might have separate clocks for CPUs and setting all CPUs in policy->cpus may
corrupt them..

This is Sixth part of my cleanup work for CPUFreq, first five are (And
obviously its rebased over them):

1: cpufreq: Introduce cpufreq_table_validate_and_show()
https://lkml.org/lkml/2013/8/8/263

2: cpufreq: define generic routines for cpufreq drivers
https://lkml.org/lkml/2013/8/10/48

3. CPUFreq: Implement light weight ->target(): for 3.13
https://lkml.org/lkml/2013/8/13/349

4. CPUFreq: set policy->cur in cpufreq core instead of drivers
https://lkml.org/lkml/2013/8/14/288

5. CPUFreq: Move freq change notifications out of drivers
https://lkml.org/lkml/2013/8/15/506

All these are pushed here:
https://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/for-v3.13

Viresh Kumar (14):
  cpufreq: create cpufreq_generic_init() routine
  cpufreq: cpu0: use cpufreq_generic_init() routine
  cpufreq: dbx500: use cpufreq_generic_init() routine
  cpufreq: exynos: use cpufreq_generic_init() routine
  cpufreq: imx6q: use cpufreq_generic_init() routine
  cpufreq: kirkwood: use cpufreq_generic_init() routine
  cpufreq: maple: use cpufreq_generic_init() routine
  cpufreq: pasemi: use cpufreq_generic_init() routine
  cpufreq: pmac64: use cpufreq_generic_init() routine
  cpufreq: s3c: use cpufreq_generic_init() routine
  cpufreq: s5pv210: use cpufreq_generic_init() routine
  cpufreq: sa11x0: use cpufreq_generic_init() routine
  cpufreq: spear: use cpufreq_generic_init() routine
  cpufreq: tegra: use cpufreq_generic_init() routine

 drivers/cpufreq/cpufreq-cpu0.c       | 19 +------------------
 drivers/cpufreq/cpufreq.c            | 31 +++++++++++++++++++++++++++++++
 drivers/cpufreq/dbx500-cpufreq.c     | 21 +--------------------
 drivers/cpufreq/exynos-cpufreq.c     |  7 +------
 drivers/cpufreq/exynos5440-cpufreq.c | 14 ++------------
 drivers/cpufreq/imx6q-cpufreq.c      | 13 +------------
 drivers/cpufreq/kirkwood-cpufreq.c   |  5 +----
 drivers/cpufreq/maple-cpufreq.c      |  9 +--------
 drivers/cpufreq/pasemi-cpufreq.c     |  9 +--------
 drivers/cpufreq/pmac64-cpufreq.c     |  9 +--------
 drivers/cpufreq/s3c2416-cpufreq.c    |  6 ++----
 drivers/cpufreq/s3c24xx-cpufreq.c    | 13 +------------
 drivers/cpufreq/s3c64xx-cpufreq.c    |  5 ++---
 drivers/cpufreq/s5pv210-cpufreq.c    |  4 +---
 drivers/cpufreq/sa1100-cpufreq.c     |  6 +-----
 drivers/cpufreq/sa1110-cpufreq.c     |  6 +-----
 drivers/cpufreq/spear-cpufreq.c      | 14 ++------------
 drivers/cpufreq/tegra-cpufreq.c      | 14 +++++++++-----
 include/linux/cpufreq.h              |  3 +++
 19 files changed, 63 insertions(+), 145 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

