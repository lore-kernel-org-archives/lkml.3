Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab3HLRt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:49:29 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:51243 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab3HLRtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:49:24 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, "David S. Miller" <davem@davemloft.net>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        John Crispin <blogic@openwrt.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-cris-kernel@axis.com,
        Mikael Starvik <starvik@axis.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, Shawn Guo <shawn.guo@linaro.org>,
        sparclinux@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Steven Miao <realmz6@gmail.com>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 00/31] CPUFreq: Implement light weight ->target(): for 3.13
Date: Mon, 12 Aug 2013 23:18:36 +0530
Message-Id: <cover.1376329128.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently prototype of cpufreq_drivers target routines is:

int target(struct cpufreq_policy *policy, unsigned int target_freq,
	unsigned int relation);

And most of the drivers call cpufreq_frequency_table_target() to get a valid
index of their frequency table which is closest to the target_freq. And they
don't use target_freq and relation after it.

So, it makes sense to just do this work in cpufreq core before calling
cpufreq_frequency_table_target() and simply pass index instead. But this can be
done only with drivers which expose their frequency table with cpufreq core. For
others we need to stick with the old prototype of target() until those drivers
are converted to expose frequency tables.

So, in order not to break those special drivers first patch renames ->target() to
->target_old() and the following patches will define the new prototype and
convert existing drivers one by one.

There are 12 drivers after this patchset which still use the heavy weight
version, i.e. target_old() and 39 drivers have adopted this new approach.

Once those 12 drivers are also moved to use .target(), .target_old() will be
removed completely.

This is part 3 of my generic cpufreq cleanup stuff.. First two are posted here
and this one is rebased of them:

1: cpufreq: Introduce cpufreq_table_validate_and_show()
https://lkml.org/lkml/2013/8/8/263

2: cpufreq: define generic routines for cpufreq drivers
https://lkml.org/lkml/2013/8/10/48

After this patchset this is the diffstat for 107 patches:
 54 files changed, 357 insertions(+), 1411 deletions(-)

All these are pushed here:
https://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/for-v3.13

--
viresh

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: John Crispin <blogic@openwrt.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-cris-kernel@axis.com
Cc: Mikael Starvik <starvik@axis.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: sparclinux@vger.kernel.org
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Steven Miao <realmz6@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>

Viresh Kumar (31):
  cpufreq: rename ->target() as ->target_old()
  cpufreq: Implement light weight ->target() routine
  cpufreq: acpi: Covert to light weight ->target() routine
  cpufreq: arm_big_little: Covert to light weight ->target() routine
  cpufreq: blackfin: Covert to light weight ->target() routine
  cpufreq: cpu0: Covert to light weight ->target() routine
  cpufreq: cris: Covert to light weight ->target() routine
  cpufreq: davinci: Covert to light weight ->target() routine
  cpufreq: dbx500: Covert to light weight ->target() routine
  cpufreq: e_powersaver: Covert to light weight ->target() routine
  cpufreq: elanfreq: Covert to light weight ->target() routine
  cpufreq: exynos: Covert to light weight ->target() routine
  cpufreq: ia64: Covert to light weight ->target() routine
  cpufreq: imx6q: Covert to light weight ->target() routine
  cpufreq: kirkwood: Covert to light weight ->target() routine
  cpufreq: longhaul: Covert to light weight ->target() routine
  cpufreq: loongson2: Covert to light weight ->target() routine
  cpufreq: maple: Covert to light weight ->target() routine
  cpufreq: omap: Covert to light weight ->target() routine
  cpufreq: p4: Covert to light weight ->target() routine
  cpufreq: pasemi: Covert to light weight ->target() routine
  cpufreq: pmac32: Covert to light weight ->target() routine
  cpufreq: powernow: Covert to light weight ->target() routine
  cpufreq: ppc: Covert to light weight ->target() routine
  cpufreq: pxa: Covert to light weight ->target() routine
  cpufreq: s3c64xx: Covert to light weight ->target() routine
  cpufreq: sc520: Covert to light weight ->target() routine
  cpufreq: sparc: Covert to light weight ->target() routine
  cpufreq: SPEAr: Covert to light weight ->target() routine
  cpufreq: speedstep: Covert to light weight ->target() routine
  cpufreq: tegra: Covert to light weight ->target() routine

 drivers/cpufreq/acpi-cpufreq.c         | 19 +++--------
 drivers/cpufreq/arm_big_little.c       | 15 +++------
 drivers/cpufreq/at32ap-cpufreq.c       |  2 +-
 drivers/cpufreq/blackfin-cpufreq.c     | 15 ++-------
 drivers/cpufreq/cpufreq-cpu0.c         | 15 +--------
 drivers/cpufreq/cpufreq-nforce2.c      |  2 +-
 drivers/cpufreq/cpufreq.c              | 59 ++++++++++++++++++++++++++--------
 drivers/cpufreq/cris-artpec3-cpufreq.c | 16 +--------
 drivers/cpufreq/cris-etraxfs-cpufreq.c | 15 +--------
 drivers/cpufreq/davinci-cpufreq.c      | 14 ++------
 drivers/cpufreq/dbx500-cpufreq.c       | 14 ++------
 drivers/cpufreq/e_powersaver.c         | 15 ++-------
 drivers/cpufreq/elanfreq.c             | 32 ++----------------
 drivers/cpufreq/exynos-cpufreq.c       | 19 ++---------
 drivers/cpufreq/exynos5440-cpufreq.c   | 11 ++-----
 drivers/cpufreq/gx-suspmod.c           |  2 +-
 drivers/cpufreq/ia64-acpi-cpufreq.c    | 19 ++---------
 drivers/cpufreq/imx6q-cpufreq.c        | 15 +--------
 drivers/cpufreq/integrator-cpufreq.c   |  2 +-
 drivers/cpufreq/kirkwood-cpufreq.c     | 17 ++--------
 drivers/cpufreq/longhaul.c             | 11 +------
 drivers/cpufreq/loongson2_cpufreq.c    | 19 +++--------
 drivers/cpufreq/maple-cpufreq.c        | 14 ++------
 drivers/cpufreq/omap-cpufreq.c         | 29 ++---------------
 drivers/cpufreq/p4-clockmod.c          | 16 ++-------
 drivers/cpufreq/pasemi-cpufreq.c       | 10 +-----
 drivers/cpufreq/pcc-cpufreq.c          |  2 +-
 drivers/cpufreq/pmac32-cpufreq.c       | 10 ++----
 drivers/cpufreq/pmac64-cpufreq.c       | 15 ++-------
 drivers/cpufreq/powernow-k6.c          | 33 +++----------------
 drivers/cpufreq/powernow-k7.c          | 20 ++----------
 drivers/cpufreq/powernow-k8.c          | 22 ++++---------
 drivers/cpufreq/ppc-corenet-cpufreq.c  | 13 ++------
 drivers/cpufreq/ppc_cbe_cpufreq.c      | 10 +-----
 drivers/cpufreq/pxa2xx-cpufreq.c       | 11 +------
 drivers/cpufreq/pxa3xx-cpufreq.c       | 15 ++-------
 drivers/cpufreq/s3c2416-cpufreq.c      |  2 +-
 drivers/cpufreq/s3c24xx-cpufreq.c      |  2 +-
 drivers/cpufreq/s3c64xx-cpufreq.c      | 16 ++-------
 drivers/cpufreq/s5pv210-cpufreq.c      |  2 +-
 drivers/cpufreq/sa1100-cpufreq.c       |  2 +-
 drivers/cpufreq/sa1110-cpufreq.c       |  2 +-
 drivers/cpufreq/sc520_freq.c           | 17 +---------
 drivers/cpufreq/sh-cpufreq.c           |  2 +-
 drivers/cpufreq/sparc-us2e-cpufreq.c   | 19 ++---------
 drivers/cpufreq/sparc-us3-cpufreq.c    | 21 ++----------
 drivers/cpufreq/spear-cpufreq.c        | 10 ++----
 drivers/cpufreq/speedstep-centrino.c   | 24 ++++----------
 drivers/cpufreq/speedstep-ich.c        | 22 +++----------
 drivers/cpufreq/speedstep-smi.c        | 18 +++--------
 drivers/cpufreq/tegra-cpufreq.c        | 10 ++----
 drivers/cpufreq/unicore2-cpufreq.c     |  2 +-
 include/linux/cpufreq.h                |  4 ++-
 53 files changed, 161 insertions(+), 582 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

