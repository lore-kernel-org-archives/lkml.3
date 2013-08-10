Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab3HJGrt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 02:47:49 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:57590 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588Ab3HJGrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 02:47:45 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, "David S. Miller" <davem@davemloft.net>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        John Crispin <blogic@openwrt.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-cris-kernel@axis.com,
        linux-sh@vger.kernel.org, Mikael Starvik <starvik@axis.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, Shawn Guo <shawn.guo@linaro.org>,
        sparclinux@vger.kernel.org, spear-devel@list.st.com,
        Stephen Warren <swarren@nvidia.com>, Steven Miao <realmz6@gmail.com>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 00/44] cpufreq: define generic routines for cpufreq drivers: for 3.13
Date: Sat, 10 Aug 2013 12:13:56 +0530
Message-Id: <cover.1376116344.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the CPUFreq drivers do similar things in .exit() and .verify() routines
and .attr. So its better if we have generic routines for them which can be used
by cpufreq drivers then.

This patchset first fixes all existing drivers to do
cpufreq_frequency_table_put_attr() corresponding to
cpufreq_frequency_table_get_attr() and then create generic routines which will
be used by most of the cpufreq drivers.

This is rebased on Rafael's bleeding edge + some more cleanup work that I posted
earlier:

https://lkml.org/lkml/2013/8/8/263

This patchset and its dependencies are pushed here:

https://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/for-v3.13

@Rafael: You would be very happy to see the changelog :)
 49 files changed, 287 insertions(+), 1215 deletions(-)

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: John Crispin <blogic@openwrt.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-cris-kernel@axis.com
Cc: linux-sh@vger.kernel.org
Cc: Mikael Starvik <starvik@axis.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: sparclinux@vger.kernel.org
Cc: spear-devel@list.st.com
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Steven Miao <realmz6@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>

Viresh Kumar (44):
  cpufreq: arm_big_little: call cpufreq_frequency_table_put_attr()
  cpufreq: blackfin: call cpufreq_frequency_table_put_attr()
  cpufreq: exynos: call cpufreq_frequency_table_put_attr()
  cpufreq: loongson2: call cpufreq_frequency_table_put_attr()
  cpufreq: omap: call cpufreq_frequency_table_put_attr()
  cpufreq: pxa: call cpufreq_frequency_table_put_attr()
  cpufreq: sparc: call cpufreq_frequency_table_put_attr()
  cpufreq: define generic .attr, .exit() and .verify() routines
  cpufreq: acpi: Use generic cpufreq routines
  cpufreq: arm_big_little: Use generic cpufreq routines
  cpufreq: at32ap: Use generic cpufreq routines
  cpufreq: blackfin: Use generic cpufreq routines
  cpufreq: cpu0: Use generic cpufreq routines
  cpufreq: cris: Use generic cpufreq routines
  cpufreq: davinci: Use generic cpufreq routines
  cpufreq: dbx500: Use generic cpufreq routines
  cpufreq: e_powersaver: Use generic cpufreq routines
  cpufreq: elanfreq: Use generic cpufreq routines
  cpufreq: exynos: Use generic cpufreq routines
  cpufreq: ia64-acpi: Use generic cpufreq routines
  cpufreq: imx6q: Use generic cpufreq routines
  cpufreq: kirkwood: Use generic cpufreq routines
  cpufreq: longhaul: Use generic cpufreq routines
  cpufreq: loongson2: Use generic cpufreq routines
  cpufreq: maple: Use generic cpufreq routines
  cpufreq: omap: Use generic cpufreq routines
  cpufreq: p4-clockmod: Use generic cpufreq routines
  cpufreq: pasemi: Use generic cpufreq routines
  cpufreq: pcc: Use generic cpufreq routines
  cpufreq: pmac: Use generic cpufreq routines
  cpufreq: powernow: Use generic cpufreq routines
  cpufreq: ppc-corenet: Use generic cpufreq routines
  cpufreq: ppc_cbe: Use generic cpufreq routines
  cpufreq: pxa: Use generic cpufreq routines
  cpufreq: s3cx4xx: Use generic cpufreq routines
  cpufreq: s5pv210: Use generic cpufreq routines
  cpufreq: sc520: Use generic cpufreq routines
  cpufreq: sh: Use generic cpufreq routines
  cpufreq: sparc: Use generic cpufreq routines
  cpufreq: spear: Use generic cpufreq routines
  cpufreq: speedstep: Use generic cpufreq routines
  cpufreq: tegra: Use generic cpufreq routines
  cpufreq: unicore2: Use generic cpufreq routines
  cpufreq: pass suitable index instead of freq to
    cpufreq_driver->target()

 drivers/cpufreq/acpi-cpufreq.c         | 30 ++++---------------
 drivers/cpufreq/arm_big_little.c       | 34 +++++-----------------
 drivers/cpufreq/at32ap-cpufreq.c       | 12 +-------
 drivers/cpufreq/blackfin-cpufreq.c     | 29 ++++---------------
 drivers/cpufreq/cpufreq-cpu0.c         | 37 +++---------------------
 drivers/cpufreq/cpufreq.c              | 30 +++++++++++++++++--
 drivers/cpufreq/cris-artpec3-cpufreq.c | 41 ++++----------------------
 drivers/cpufreq/cris-etraxfs-cpufreq.c | 38 ++++--------------------
 drivers/cpufreq/davinci-cpufreq.c      | 30 ++++---------------
 drivers/cpufreq/dbx500-cpufreq.c       | 27 +++--------------
 drivers/cpufreq/e_powersaver.c         | 28 +++---------------
 drivers/cpufreq/elanfreq.c             | 53 ++++------------------------------
 drivers/cpufreq/exynos-cpufreq.c       | 40 ++++---------------------
 drivers/cpufreq/exynos5440-cpufreq.c   | 18 +++---------
 drivers/cpufreq/freq_table.c           | 20 +++++++++++++
 drivers/cpufreq/ia64-acpi-cpufreq.c    | 41 +++-----------------------
 drivers/cpufreq/imx6q-cpufreq.c        | 38 ++++--------------------
 drivers/cpufreq/kirkwood-cpufreq.c     | 40 ++++---------------------
 drivers/cpufreq/longhaul.c             | 34 +++-------------------
 drivers/cpufreq/loongson2_cpufreq.c    | 34 +++++-----------------
 drivers/cpufreq/maple-cpufreq.c        | 28 ++++--------------
 drivers/cpufreq/omap-cpufreq.c         | 44 ++++------------------------
 drivers/cpufreq/p4-clockmod.c          | 37 ++++--------------------
 drivers/cpufreq/pasemi-cpufreq.c       | 23 ++-------------
 drivers/cpufreq/pcc-cpufreq.c          |  9 +-----
 drivers/cpufreq/pmac32-cpufreq.c       | 23 +++------------
 drivers/cpufreq/pmac64-cpufreq.c       | 28 ++++--------------
 drivers/cpufreq/powernow-k6.c          | 32 +++-----------------
 drivers/cpufreq/powernow-k7.c          | 36 +++++------------------
 drivers/cpufreq/powernow-k8.c          | 36 +++++------------------
 drivers/cpufreq/ppc-corenet-cpufreq.c  | 30 ++++---------------
 drivers/cpufreq/ppc_cbe_cpufreq.c      | 24 ++-------------
 drivers/cpufreq/pxa2xx-cpufreq.c       | 29 ++-----------------
 drivers/cpufreq/pxa3xx-cpufreq.c       | 21 +++-----------
 drivers/cpufreq/s3c2416-cpufreq.c      | 48 ++++++++++--------------------
 drivers/cpufreq/s3c24xx-cpufreq.c      | 37 +++---------------------
 drivers/cpufreq/s3c64xx-cpufreq.c      | 25 +++-------------
 drivers/cpufreq/s5pv210-cpufreq.c      | 24 ++-------------
 drivers/cpufreq/sc520_freq.c           | 43 ++++-----------------------
 drivers/cpufreq/sh-cpufreq.c           |  7 +----
 drivers/cpufreq/sparc-us2e-cpufreq.c   | 23 ++++-----------
 drivers/cpufreq/sparc-us3-cpufreq.c    | 25 ++++------------
 drivers/cpufreq/spear-cpufreq.c        | 32 ++++----------------
 drivers/cpufreq/speedstep-centrino.c   | 42 +++++----------------------
 drivers/cpufreq/speedstep-ich.c        | 48 +++++-------------------------
 drivers/cpufreq/speedstep-smi.c        | 46 +++++------------------------
 drivers/cpufreq/tegra-cpufreq.c        | 22 +++-----------
 drivers/cpufreq/unicore2-cpufreq.c     | 16 +---------
 include/linux/cpufreq.h                | 10 ++++++-
 49 files changed, 287 insertions(+), 1215 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

