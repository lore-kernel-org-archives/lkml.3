Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759821Ab3HNNco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:32:44 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:57710 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758275Ab3HNNcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:32:41 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, "David S. Miller" <davem@davemloft.net>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        John Crispin <blogic@openwrt.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-cris-kernel@axis.com,
        linux-sh@vger.kernel.org, Mikael Starvik <starvik@axis.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, Shawn Guo <shawn.guo@linaro.org>,
        spear-devel@list.st.com, Stephen Warren <swarren@nvidia.com>,
        Steven Miao <realmz6@gmail.com>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 00/37] CPUFreq: set policy->cur in cpufreq core instead of
Date: Wed, 14 Aug 2013 19:01:49 +0530
Message-Id: <cover.1376486713.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Almost all drivers set policy->cur with current cpu frequency in their ->init()
part. This can be done for all of them at core level and so they wouldn't need
to do it.

This patchset adds supporting code in cpufreq core for calling get() after we have
called init() for a policy. Also fixes all drivers accordingly.

These drivers were still doing some stuff which isn't required and was done by
core already. And that is cleaned as well.

This is Fourth part of my cleanup work for CPUFreq, first three are (And
obviously its rebased over them):

1: cpufreq: Introduce cpufreq_table_validate_and_show()
https://lkml.org/lkml/2013/8/8/263

2: cpufreq: define generic routines for cpufreq drivers
https://lkml.org/lkml/2013/8/10/48

3. CPUFreq: Implement light weight ->target(): for 3.13
https://lkml.org/lkml/2013/8/13/349

All these are pushed here:
https://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/for-v3.13

--
viresh

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: John Crispin <blogic@openwrt.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-cris-kernel@axis.com
Cc: linux-sh@vger.kernel.org
Cc: Mikael Starvik <starvik@axis.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: spear-devel@list.st.com
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Steven Miao <realmz6@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>

Viresh Kumar (37):
  cpufreq: call cpufreq_driver->get() after calling ->init()
  cpufreq: acpi: don't initialize part of policy that is set by core
    too
  cpufreq: arm_big_little: don't initialize part of policy that is set
    by core too
  cpufreq: at32ap: don't initialize part of policy that is set by core
    too
  cpufreq: blackfin: don't initialize part of policy that is set by
    core too
  cpufreq: cpu0: don't initialize part of policy that is set by core
    too
  cpufreq: nforce2: don't initialize part of policy that is set by core
    too
  cpufreq: cris: don't initialize part of policy that is set by core
    too
  cpufreq: davinci: don't initialize part of policy that is set by core
    too
  cpufreq: dbx500: don't initialize part of policy that is set by core
    too
  cpufreq: e_powersaver: don't initialize part of policy that is set by
    core too
  cpufreq: elanfreq: don't initialize part of policy that is set by
    core too
  cpufreq: exynos: don't initialize part of policy that is set by core
    too
  cpufreq: gx: don't initialize part of policy that is set by core too
  cpufreq: ia64-acpi: don't initialize part of policy that is set by
    core too
  cpufreq: imx6q: don't initialize part of policy that is set by core
    too
  cpufreq: integrator: don't initialize part of policy that is set by
    core too
  cpufreq: kirkwood: don't initialize part of policy that is set by
    core too
  cpufreq: longhaul: don't initialize part of policy that is set by
    core too
  cpufreq: loongson2: don't initialize part of policy that is set by
    core too
  cpufreq: maple: don't initialize part of policy that is set by core
    too
  cpufreq: omap: don't initialize part of policy that is set by core
    too
  cpufreq: p4: don't initialize part of policy that is set by core too
  cpufreq: pcc: don't initialize part of policy that is set by core too
  cpufreq: pmac: don't initialize part of policy that is set by core
    too
  cpufreq: powernow: don't initialize part of policy that is set by
    core too
  cpufreq: ppc: don't initialize part of policy that is set by core too
  cpufreq: pxa: don't initialize part of policy that is set by core too
  cpufreq: s3c: don't initialize part of policy that is set by core too
  cpufreq: s5pv210: don't initialize part of policy that is set by core
    too
  cpufreq: sa11x0: don't initialize part of policy that is set by core
    too
  cpufreq: sc520_freq: don't initialize part of policy that is set by
    core too
  cpufreq: sh: don't initialize part of policy that is set by core too
  cpufreq: spear: don't initialize part of policy that is set by core
    too
  cpufreq: speedstep: don't initialize part of policy that is set by
    core too
  cpufreq: tegra: don't initialize part of policy that is set by core
    too
  cpufreq: unicore2: don't initialize part of policy that is set by
    core too

 drivers/cpufreq/acpi-cpufreq.c         |  1 -
 drivers/cpufreq/arm_big_little.c       |  2 --
 drivers/cpufreq/at32ap-cpufreq.c       | 12 ++++--------
 drivers/cpufreq/blackfin-cpufreq.c     |  1 -
 drivers/cpufreq/cpufreq-cpu0.c         |  1 -
 drivers/cpufreq/cpufreq-nforce2.c      |  1 -
 drivers/cpufreq/cpufreq.c              | 11 +++++++++++
 drivers/cpufreq/cris-artpec3-cpufreq.c |  1 -
 drivers/cpufreq/cris-etraxfs-cpufreq.c |  1 -
 drivers/cpufreq/davinci-cpufreq.c      |  2 --
 drivers/cpufreq/dbx500-cpufreq.c       |  5 -----
 drivers/cpufreq/e_powersaver.c         |  1 -
 drivers/cpufreq/elanfreq.c             |  1 -
 drivers/cpufreq/exynos-cpufreq.c       |  2 --
 drivers/cpufreq/exynos5440-cpufreq.c   |  1 -
 drivers/cpufreq/gx-suspmod.c           |  5 +----
 drivers/cpufreq/ia64-acpi-cpufreq.c    |  1 -
 drivers/cpufreq/imx6q-cpufreq.c        |  1 -
 drivers/cpufreq/integrator-cpufreq.c   |  5 ++---
 drivers/cpufreq/kirkwood-cpufreq.c     |  1 -
 drivers/cpufreq/longhaul.c             |  1 -
 drivers/cpufreq/loongson2_cpufreq.c    |  2 --
 drivers/cpufreq/maple-cpufreq.c        |  1 -
 drivers/cpufreq/omap-cpufreq.c         |  4 ----
 drivers/cpufreq/p4-clockmod.c          |  1 -
 drivers/cpufreq/pcc-cpufreq.c          |  7 -------
 drivers/cpufreq/pmac32-cpufreq.c       |  1 -
 drivers/cpufreq/pmac64-cpufreq.c       |  1 -
 drivers/cpufreq/powernow-k6.c          |  1 -
 drivers/cpufreq/powernow-k7.c          |  2 --
 drivers/cpufreq/powernow-k8.c          |  3 ---
 drivers/cpufreq/ppc-corenet-cpufreq.c  |  2 --
 drivers/cpufreq/pxa2xx-cpufreq.c       |  2 --
 drivers/cpufreq/pxa3xx-cpufreq.c       |  7 +++----
 drivers/cpufreq/s3c2416-cpufreq.c      |  2 --
 drivers/cpufreq/s3c24xx-cpufreq.c      |  5 -----
 drivers/cpufreq/s3c64xx-cpufreq.c      |  2 --
 drivers/cpufreq/s5pv210-cpufreq.c      |  2 --
 drivers/cpufreq/sa1100-cpufreq.c       |  1 -
 drivers/cpufreq/sa1110-cpufreq.c       |  1 -
 drivers/cpufreq/sc520_freq.c           |  1 -
 drivers/cpufreq/sh-cpufreq.c           |  2 --
 drivers/cpufreq/spear-cpufreq.c        |  2 --
 drivers/cpufreq/speedstep-centrino.c   |  5 -----
 drivers/cpufreq/speedstep-ich.c        | 15 +--------------
 drivers/cpufreq/speedstep-smi.c        | 13 -------------
 drivers/cpufreq/tegra-cpufreq.c        |  3 +--
 drivers/cpufreq/unicore2-cpufreq.c     |  1 -
 48 files changed, 23 insertions(+), 123 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

