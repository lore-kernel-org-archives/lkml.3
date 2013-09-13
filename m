Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab3IMNDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:03:07 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34252 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748Ab3IMNDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:03:03 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 000/228] CPUFreq: cleanup stuff for 3.13
Date: Fri, 13 Sep 2013 18:29:06 +0530
Message-Id: <cover.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my biggest patchset ever and it might not happen again in my entire
career. I hope I haven't screwed up here :)

CPUFreq cleanup patches are ready to hit linux-next (I hope it doesn't turn out
into horror stories, where it broke all possible architectures where Linux runs
:))

Most of these are build tested only, Also done by: Fengguang Wu's build bot.

All of these were sent separately in smaller patchsets earlier and now merged
together as a single set. Some parts are reviewed by platform maintainers and
their Acks are included in the patches (Sorry if I missed any)..

These are rebased over today's pm/linux-next:
f74a274 Merge branch 'pm-cpufreq-next' into linux-next

with following patches over it, which I expect to get into Rafael's tree before
these:
	cpufreq: use correct values of cpus in __cpufreq_remove_dev_finish()
	cpufreq: distinguish drivers that do asynchronous notifications
	cpufreq: make sure frequency transitions are serialized
	cpufreq: Create cpufreq_transition_complete()
	cpufreq: powernow-k8: mark freq transition complete on error cases

There are few new patches here which haven't been sent yet and only came out
after discussions with Maintainers about their platforms:
	cpufreq: loongson2: use cpufreq_generic_init() routine
	cpufreq: davinci: use cpufreq_generic_init() routine
	cpufreq: cris: use cpufreq_generic_init() routine
	cpufreq: omap: use cpufreq_generic_init() routine

As suggested by Rafael earlier, he might not apply all at once and will give
people some chance to test sets one by one.. So, first set now, next one after
few days. So, I am marking different sets with patch numbers to make it easier
for Rafael.

- Patch 1->8: Generic cleanup of cpufreq core (First batch)
- Patch 9->54: Mostly about cpufreq_table_validate_and_show() helper (First batch)
- Patch 55->89: New generic routines for cpufreq drivers (First/Second batch)
- Patch 90->126: About calling cpufreq_driver->get() from core (First/Second batch)
- Patch 127->146: Generic init() routine (First/Second batch)
- Patch 147->180: Light weight ->target() routine (Third batch)
- Patch 181->211: Call notifiers from core instead of target() (Third/Fourth batch)
- Patch 212->228: Generic get() (Fifth batch)

As suggested by Amit here, Linaro may try to test linux-next with these patches
on Linaro's board farm (Mostly ARM and X86)..

https://lkml.org/lkml/2013/9/11/346

--
viresh

Hans-Christian Egtvedt (1):
  cpufreq: at32ap: add frequency table

Viresh Kumar (227):
  cpufreq: Remove extra blank line
  cpufreq: don't break string in print statements
  cpufreq: remove __cpufreq_remove_dev()
  cpufreq: Optimize cpufreq_frequency_table_verify()
  cpufreq: rename __cpufreq_set_policy() as cpufreq_set_policy()
  cpufreq: rewrite cpufreq_driver->flags using shift operator
  cpufreq: use cpufreq_driver->flags to mark
    CPUFREQ_HAVE_GOVERNOR_PER_POLICY
  cpufreq: add new routine cpufreq_verify_within_cpu_limits()
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
  cpufreq: sa11x0: Expose frequency table
  cpufreq: sa11x0: let cpufreq core initialize struct policy fields
  cpufreq: sc520: use cpufreq_table_validate_and_show()
  cpufreq: sh: use cpufreq_table_validate_and_show()
  cpufreq: sparc: use cpufreq_table_validate_and_show()
  cpufreq: spear: use cpufreq_table_validate_and_show()
  cpufreq: speedstep: use cpufreq_table_validate_and_show()
  cpufreq: tegra: use cpufreq_table_validate_and_show()
  cpufreq: tegra: fix implementation of ->exit()
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
  cpufreq: pmac: Use generic cpufreq routines
  cpufreq: powernow: Use generic cpufreq routines
  cpufreq: ppc-corenet: Use generic cpufreq routines
  cpufreq: ppc_cbe: Use generic cpufreq routines
  cpufreq: pxa: Use generic cpufreq routines
  cpufreq: s3cx4xx: Use generic cpufreq routines
  cpufreq: s5pv210: Use generic cpufreq routines
  cpufreq: sa11x0: Use generic cpufreq routines
  cpufreq: sc520: Use generic cpufreq routines
  cpufreq: sh: Use generic cpufreq routines
  cpufreq: sparc: Use generic cpufreq routines
  cpufreq: spear: Use generic cpufreq routines
  cpufreq: speedstep: Use generic cpufreq routines
  cpufreq: tegra: Use generic cpufreq routines
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
  cpufreq: create cpufreq_generic_init() routine
  cpufreq: remove CONFIG_CPU_FREQ_TABLE
  cpufreq: cpu0: use cpufreq_generic_init() routine
  cpufreq: cris: use cpufreq_generic_init() routine
  cpufreq: davinci: use cpufreq_generic_init() routine
  cpufreq: dbx500: use cpufreq_generic_init() routine
  cpufreq: exynos: use cpufreq_generic_init() routine
  cpufreq: imx6q: use cpufreq_generic_init() routine
  cpufreq: kirkwood: use cpufreq_generic_init() routine
  cpufreq: loongson2: use cpufreq_generic_init() routine
  cpufreq: maple: use cpufreq_generic_init() routine
  cpufreq: omap: use cpufreq_generic_init() routine
  cpufreq: pasemi: use cpufreq_generic_init() routine
  cpufreq: pmac32: use cpufreq_generic_init() routine
  cpufreq: pmac64: use cpufreq_generic_init() routine
  cpufreq: s3c: use cpufreq_generic_init() routine
  cpufreq: s5pv210: use cpufreq_generic_init() routine
  cpufreq: sa11x0: use cpufreq_generic_init() routine
  cpufreq: spear: use cpufreq_generic_init() routine
  cpufreq: tegra: use cpufreq_generic_init() routine
  cpufreq: Implement light weight ->target_index() routine
  cpufreq: acpi: Convert to light weight ->target_index() routine
  cpufreq: arm_big_little: Convert to light weight ->target_index()
    routine
  cpufreq: at32ap: Convert to light weight ->target_index() routine
  cpufreq: blackfin: Convert to light weight ->target_index() routine
  cpufreq: cpu0: Convert to light weight ->target_index() routine
  cpufreq: cris: Convert to light weight ->target_index() routine
  cpufreq: davinci: Convert to light weight ->target_index() routine
  cpufreq: dbx500: Convert to light weight ->target_index() routine
  cpufreq: e_powersaver: Convert to light weight ->target_index()
    routine
  cpufreq: elanfreq: Convert to light weight ->target_index() routine
  cpufreq: exynos: Convert to light weight ->target_index() routine
  cpufreq: ia64: Convert to light weight ->target_index() routine
  cpufreq: imx6q: Convert to light weight ->target_index() routine
  cpufreq: kirkwood: Convert to light weight ->target_index() routine
  cpufreq: longhaul: Convert to light weight ->target_index() routine
  cpufreq: loongson2: Convert to light weight ->target_index() routine
  cpufreq: maple: Convert to light weight ->target_index() routine
  cpufreq: omap: Convert to light weight ->target_index() routine
  cpufreq: p4: Convert to light weight ->target_index() routine
  cpufreq: pasemi: Convert to light weight ->target_index() routine
  cpufreq: pmac32: Convert to light weight ->target_index() routine
  cpufreq: powernow: Convert to light weight ->target_index() routine
  cpufreq: ppc: Convert to light weight ->target_index() routine
  cpufreq: pxa: Convert to light weight ->target_index() routine
  cpufreq: s3c2416: Convert to light weight ->target_index() routine
  cpufreq: s3c64xx: Convert to light weight ->target_index() routine
  cpufreq: s5pv210: Convert to light weight ->target_index() routine
  cpufreq: sa11x0: Convert to light weight ->target_index() routine
  cpufreq: sc520: Convert to light weight ->target_index() routine
  cpufreq: sparc: Convert to light weight ->target_index() routine
  cpufreq: SPEAr: Convert to light weight ->target_index() routine
  cpufreq: speedstep: Convert to light weight ->target_index() routine
  cpufreq: tegra: Convert to light weight ->target_index() routine
  cpufreq: move freq change notifications to cpufreq core
  cpufreq: acpi: remove calls to cpufreq_notify_transition()
  cpufreq: arm_big_little: remove calls to cpufreq_notify_transition()
  cpufreq: at32ap: remove calls to cpufreq_notify_transition()
  cpufreq: blackfin: remove calls to cpufreq_notify_transition()
  cpufreq: cpu0: remove calls to cpufreq_notify_transition()
  cpufreq: cris: remove calls to cpufreq_notify_transition()
  cpufreq: davinci: remove calls to cpufreq_notify_transition()
  cpufreq: dbx500: remove calls to cpufreq_notify_transition()
  cpufreq: e_powersaver: remove calls to cpufreq_notify_transition()
  cpufreq: elanfreq: remove calls to cpufreq_notify_transition()
  cpufreq: exynos: remove calls to cpufreq_notify_transition()
  cpufreq: ia64-acpi: remove calls to cpufreq_notify_transition()
  cpufreq: imx6q: remove calls to cpufreq_notify_transition()
  cpufreq: kirkwood: remove calls to cpufreq_notify_transition()
  cpufreq: loongson2: remove calls to cpufreq_notify_transition()
  cpufreq: maple: remove calls to cpufreq_notify_transition()
  cpufreq: omap: remove calls to cpufreq_notify_transition()
  cpufreq: p4-clockmod: remove calls to cpufreq_notify_transition()
  cpufreq: pasemi: remove calls to cpufreq_notify_transition()
  cpufreq: pmac: remove calls to cpufreq_notify_transition()
  cpufreq: ppc: remove calls to cpufreq_notify_transition()
  cpufreq: pxa: remove calls to cpufreq_notify_transition()
  cpufreq: s3c: remove calls to cpufreq_notify_transition()
  cpufreq: s5pv210: remove calls to cpufreq_notify_transition()
  cpufreq: sa11x0: remove calls to cpufreq_notify_transition()
  cpufreq: sc520: remove calls to cpufreq_notify_transition()
  cpufreq: sparc: remove calls to cpufreq_notify_transition()
  cpufreq: SPEAr: remove calls to cpufreq_notify_transition()
  cpufreq: speedstep: remove calls to cpufreq_notify_transition()
  cpufreq: tegra: remove calls to cpufreq_notify_transition()
  cpufreq: tegra: remove target_cpu_speed[] array
  cpufreq: create cpufreq_generic_get() routine
  cpufreq: arm_big_little: use cpufreq_generic_get() routine
  cpufreq: at32ap: use cpufreq_generic_get() routine
  cpufreq: cpu0: use cpufreq_generic_get() routine
  cpufreq: davinci: use cpufreq_generic_get() routine
  cpufreq: dbx500: use cpufreq_generic_get() routine
  cpufreq: exynos: use cpufreq_generic_get() routine
  cpufreq: imx6q: use cpufreq_generic_get() routine
  cpufreq: loongson2: use cpufreq_generic_get() routine
  cpufreq: omap: use cpufreq_generic_get() routine
  cpufreq: ppc: use cpufreq_generic_get() routine
  cpufreq: s3c: use cpufreq_generic_get() routine
  cpufreq: s5pv210: use cpufreq_generic_get() routine
  cpufreq: spear: use cpufreq_generic_get() routine
  cpufreq: tegra: use cpufreq_generic_get() routine
  cpufreq: unicore2: use cpufreq_generic_get() routine

 Documentation/cpu-freq/cpu-drivers.txt |  27 ++--
 Documentation/cpu-freq/governors.txt   |   4 +-
 arch/arm/mach-davinci/Kconfig          |   1 -
 arch/arm/mach-pxa/Kconfig              |   3 -
 arch/arm/mach-sa1100/generic.c         |  81 +++---------
 arch/arm/mach-sa1100/generic.h         |   4 +-
 arch/arm/mach-ux500/Kconfig            |   1 -
 arch/blackfin/Kconfig                  |   1 -
 arch/cris/Kconfig                      |   2 -
 drivers/cpufreq/Kconfig                |  11 --
 drivers/cpufreq/Kconfig.arm            |  11 --
 drivers/cpufreq/Kconfig.powerpc        |   6 -
 drivers/cpufreq/Kconfig.x86            |  13 --
 drivers/cpufreq/Makefile               |   5 +-
 drivers/cpufreq/acpi-cpufreq.c         |  45 ++-----
 drivers/cpufreq/arm_big_little.c       |  75 ++----------
 drivers/cpufreq/at32ap-cpufreq.c       | 119 +++++++++---------
 drivers/cpufreq/blackfin-cpufreq.c     |  54 ++------
 drivers/cpufreq/cpufreq-cpu0.c         | 103 +++-------------
 drivers/cpufreq/cpufreq-nforce2.c      |   5 +-
 drivers/cpufreq/cpufreq.c              | 217 +++++++++++++++++++++++++--------
 drivers/cpufreq/cpufreq_governor.h     |   5 +-
 drivers/cpufreq/cris-artpec3-cpufreq.c |  64 +---------
 drivers/cpufreq/cris-etraxfs-cpufreq.c |  61 +--------
 drivers/cpufreq/davinci-cpufreq.c      |  87 +++----------
 drivers/cpufreq/dbx500-cpufreq.c       |  97 ++-------------
 drivers/cpufreq/e_powersaver.c         |  59 ++-------
 drivers/cpufreq/elanfreq.c             |  88 ++-----------
 drivers/cpufreq/exynos-cpufreq.c       |  93 +++-----------
 drivers/cpufreq/exynos5440-cpufreq.c   |  84 ++++---------
 drivers/cpufreq/freq_table.c           |  59 ++++++---
 drivers/cpufreq/gx-suspmod.c           |   5 +-
 drivers/cpufreq/ia64-acpi-cpufreq.c    |  71 +----------
 drivers/cpufreq/imx6q-cpufreq.c        |  99 ++++-----------
 drivers/cpufreq/integrator-cpufreq.c   |  14 +--
 drivers/cpufreq/intel_pstate.c         |   4 +-
 drivers/cpufreq/kirkwood-cpufreq.c     | 107 ++++------------
 drivers/cpufreq/longhaul.c             |  45 +------
 drivers/cpufreq/longrun.c              |   4 +-
 drivers/cpufreq/loongson2_cpufreq.c    |  72 ++---------
 drivers/cpufreq/maple-cpufreq.c        |  56 +--------
 drivers/cpufreq/omap-cpufreq.c         | 158 ++++++------------------
 drivers/cpufreq/p4-clockmod.c          |  53 ++------
 drivers/cpufreq/pasemi-cpufreq.c       |  51 +-------
 drivers/cpufreq/pcc-cpufreq.c          |  10 +-
 drivers/cpufreq/pmac32-cpufreq.c       |  53 ++------
 drivers/cpufreq/pmac64-cpufreq.c       |  57 +--------
 drivers/cpufreq/powernow-k6.c          |  67 ++--------
 drivers/cpufreq/powernow-k7.c          |  42 ++-----
 drivers/cpufreq/powernow-k8.c          |  53 ++------
 drivers/cpufreq/ppc-corenet-cpufreq.c  |  69 ++---------
 drivers/cpufreq/ppc_cbe_cpufreq.c      |  50 +-------
 drivers/cpufreq/pxa2xx-cpufreq.c       |  70 +++--------
 drivers/cpufreq/pxa3xx-cpufreq.c       |  46 ++-----
 drivers/cpufreq/s3c2416-cpufreq.c      |  67 ++--------
 drivers/cpufreq/s3c24xx-cpufreq.c      |  37 +-----
 drivers/cpufreq/s3c64xx-cpufreq.c      | 108 +++++-----------
 drivers/cpufreq/s5pv210-cpufreq.c      | 105 ++++------------
 drivers/cpufreq/sa1100-cpufreq.c       |  49 ++------
 drivers/cpufreq/sa1110-cpufreq.c       |  46 ++-----
 drivers/cpufreq/sc520_freq.c           |  64 +---------
 drivers/cpufreq/sh-cpufreq.c           |  22 +---
 drivers/cpufreq/sparc-us2e-cpufreq.c   |  42 ++-----
 drivers/cpufreq/sparc-us3-cpufreq.c    |  44 ++-----
 drivers/cpufreq/spear-cpufreq.c        |  72 ++---------
 drivers/cpufreq/speedstep-centrino.c   |  81 ++----------
 drivers/cpufreq/speedstep-ich.c        |  85 ++-----------
 drivers/cpufreq/speedstep-smi.c        |  76 ++----------
 drivers/cpufreq/tegra-cpufreq.c        | 114 ++++-------------
 drivers/cpufreq/unicore2-cpufreq.c     |  26 ++--
 drivers/thermal/Kconfig                |   1 -
 include/linux/cpufreq.h                |  59 ++++++---
 72 files changed, 922 insertions(+), 2917 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

