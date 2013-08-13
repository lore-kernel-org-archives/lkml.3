Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129Ab3HMNcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:32:41 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:63515 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757836Ab3HMNch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:32:37 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        John Crispin <blogic@openwrt.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-cris-kernel@axis.com,
        Mikael Starvik <starvik@axis.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, Shawn Guo <shawn.guo@linaro.org>,
        sparclinux@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Steven Miao <realmz6@gmail.com>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH V2 00/35] CPUFreq: Implement light weight ->target(): for 3.13
Date: Tue, 13 Aug 2013 19:01:40 +0530
Message-Id: <cover.1376392602.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <a>
References: <a>
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

There are 7 drivers after this patchset which still use the heavy weight
version, i.e. target() and 44 drivers have adopted this new approach, i.e.
target_index().

Once those 7 drivers are also moved to use .target_index(), .target() will be
removed completely.

This is part 3 of my generic cpufreq cleanup stuff.. First two are posted here
and this one is rebased of them:

1: cpufreq: Introduce cpufreq_table_validate_and_show()
https://lkml.org/lkml/2013/8/8/263

2: cpufreq: define generic routines for cpufreq drivers
https://lkml.org/lkml/2013/8/10/48

All these are pushed here:
https://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/for-v3.13

V1->V2:
------
- Must be less ugly this time :)
- new interface is named as target_index() instead of target()
- old interface is kept as target() instead of target_old()
- few more drivers got converted to use this infrastructure (5)
- Documentation updates
- CONFIG_CPU_FREQ_TABLE removed completely as core depends on it now

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
Cc: Mikael Starvik <starvik@axis.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: sparclinux@vger.kernel.org
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Steven Miao <realmz6@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>

Viresh Kumar (35):
  cpufreq: Implement light weight ->target_index() routine
  cpufreq: remove CONFIG_CPU_FREQ_TABLE
  cpufreq: acpi: Covert to light weight ->target_index() routine
  cpufreq: arm_big_little: Covert to light weight ->target_index()
    routine
  cpufreq: at32ap: Covert to light weight ->target_index() routine
  cpufreq: blackfin: Covert to light weight ->target_index() routine
  cpufreq: cpu0: Covert to light weight ->target_index() routine
  cpufreq: cris: Covert to light weight ->target_index() routine
  cpufreq: davinci: Covert to light weight ->target_index() routine
  cpufreq: dbx500: Covert to light weight ->target_index() routine
  cpufreq: e_powersaver: Covert to light weight ->target_index()
    routine
  cpufreq: elanfreq: Covert to light weight ->target_index() routine
  cpufreq: exynos: Covert to light weight ->target_index() routine
  cpufreq: ia64: Covert to light weight ->target_index() routine
  cpufreq: imx6q: Covert to light weight ->target_index() routine
  cpufreq: kirkwood: Covert to light weight ->target_index() routine
  cpufreq: longhaul: Covert to light weight ->target_index() routine
  cpufreq: loongson2: Covert to light weight ->target_index() routine
  cpufreq: maple: Covert to light weight ->target_index() routine
  cpufreq: omap: Covert to light weight ->target_index() routine
  cpufreq: p4: Covert to light weight ->target_index() routine
  cpufreq: pasemi: Covert to light weight ->target_index() routine
  cpufreq: pmac32: Covert to light weight ->target_index() routine
  cpufreq: powernow: Covert to light weight ->target_index() routine
  cpufreq: ppc: Covert to light weight ->target_index() routine
  cpufreq: pxa: Covert to light weight ->target_index() routine
  cpufreq: s3c2416: Covert to light weight ->target_index() routine
  cpufreq: s3c64xx: Covert to light weight ->target_index() routine
  cpufreq: s5pv210: Covert to light weight ->target_index() routine
  cpufreq: sa11x0: Covert to light weight ->target_index() routine
  cpufreq: sc520: Covert to light weight ->target_index() routine
  cpufreq: sparc: Covert to light weight ->target_index() routine
  cpufreq: SPEAr: Covert to light weight ->target_index() routine
  cpufreq: speedstep: Covert to light weight ->target_index() routine
  cpufreq: tegra: Covert to light weight ->target_index() routine

 Documentation/cpu-freq/cpu-drivers.txt | 27 ++++++++++------
 Documentation/cpu-freq/governors.txt   |  4 +--
 arch/arm/mach-davinci/Kconfig          |  1 -
 arch/arm/mach-pxa/Kconfig              |  3 --
 arch/arm/mach-sa1100/generic.c         | 20 ------------
 arch/arm/mach-sa1100/generic.h         |  2 --
 arch/arm/mach-ux500/Kconfig            |  1 -
 arch/blackfin/Kconfig                  |  1 -
 arch/cris/Kconfig                      |  2 --
 drivers/cpufreq/Kconfig                | 11 -------
 drivers/cpufreq/Kconfig.arm            | 11 -------
 drivers/cpufreq/Kconfig.powerpc        |  6 ----
 drivers/cpufreq/Kconfig.x86            | 13 --------
 drivers/cpufreq/Makefile               |  5 +--
 drivers/cpufreq/acpi-cpufreq.c         | 21 ++++---------
 drivers/cpufreq/arm_big_little.c       | 17 +++-------
 drivers/cpufreq/at32ap-cpufreq.c       | 23 +++-----------
 drivers/cpufreq/blackfin-cpufreq.c     | 17 +++-------
 drivers/cpufreq/cpufreq-cpu0.c         | 17 ++--------
 drivers/cpufreq/cpufreq.c              | 57 ++++++++++++++++++++++++++--------
 drivers/cpufreq/cris-artpec3-cpufreq.c | 18 ++---------
 drivers/cpufreq/cris-etraxfs-cpufreq.c | 17 ++--------
 drivers/cpufreq/davinci-cpufreq.c      | 16 ++--------
 drivers/cpufreq/dbx500-cpufreq.c       | 16 ++--------
 drivers/cpufreq/e_powersaver.c         | 17 ++--------
 drivers/cpufreq/elanfreq.c             | 34 ++------------------
 drivers/cpufreq/exynos-cpufreq.c       | 21 ++-----------
 drivers/cpufreq/exynos5440-cpufreq.c   | 13 ++------
 drivers/cpufreq/ia64-acpi-cpufreq.c    | 21 ++-----------
 drivers/cpufreq/imx6q-cpufreq.c        | 17 ++--------
 drivers/cpufreq/kirkwood-cpufreq.c     | 19 ++----------
 drivers/cpufreq/longhaul.c             | 13 ++------
 drivers/cpufreq/loongson2_cpufreq.c    | 21 +++----------
 drivers/cpufreq/maple-cpufreq.c        | 16 +++-------
 drivers/cpufreq/omap-cpufreq.c         | 31 ++----------------
 drivers/cpufreq/p4-clockmod.c          | 18 +++--------
 drivers/cpufreq/pasemi-cpufreq.c       | 12 ++-----
 drivers/cpufreq/pmac32-cpufreq.c       | 12 ++-----
 drivers/cpufreq/pmac64-cpufreq.c       | 17 +++-------
 drivers/cpufreq/powernow-k6.c          | 35 +++------------------
 drivers/cpufreq/powernow-k7.c          | 22 +++----------
 drivers/cpufreq/powernow-k8.c          | 24 +++++---------
 drivers/cpufreq/ppc-corenet-cpufreq.c  | 15 +++------
 drivers/cpufreq/ppc_cbe_cpufreq.c      | 12 ++-----
 drivers/cpufreq/pxa2xx-cpufreq.c       | 13 ++------
 drivers/cpufreq/pxa3xx-cpufreq.c       | 17 ++--------
 drivers/cpufreq/s3c2416-cpufreq.c      | 17 +++-------
 drivers/cpufreq/s3c64xx-cpufreq.c      | 18 +++--------
 drivers/cpufreq/s5pv210-cpufreq.c      | 54 +++++++++-----------------------
 drivers/cpufreq/sa1100-cpufreq.c       | 24 +++-----------
 drivers/cpufreq/sa1110-cpufreq.c       | 26 +++-------------
 drivers/cpufreq/sc520_freq.c           | 19 ++----------
 drivers/cpufreq/sparc-us2e-cpufreq.c   | 21 ++-----------
 drivers/cpufreq/sparc-us3-cpufreq.c    | 23 ++------------
 drivers/cpufreq/spear-cpufreq.c        | 12 +++----
 drivers/cpufreq/speedstep-centrino.c   | 26 +++++-----------
 drivers/cpufreq/speedstep-ich.c        | 24 ++++----------
 drivers/cpufreq/speedstep-smi.c        | 20 +++---------
 drivers/cpufreq/tegra-cpufreq.c        | 12 ++-----
 drivers/thermal/Kconfig                |  1 -
 include/linux/cpufreq.h                |  4 ++-
 61 files changed, 238 insertions(+), 809 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

