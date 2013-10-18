Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab3JROAK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:00:10 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:34231 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab3JROAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:00:08 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 Resend 00/34] CPUFreq Cleanup Part III
Date: Fri, 18 Oct 2013 19:29:23 +0530
Message-Id: <cover.1382104514.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Part II is already in your linux-next branch, I am sending Part III for
inclusion in bleeding-edge.

This is oriented around a light weight ->target_index() routine. CPUFreq
notifications would be moved to CPUFreq core in the next patchset that I will
send, as you suggested not to merge multiple series together.. Although both of
them are oriented towards a light weight ->target_index() routine.

This is rebased over your bleeding-edge branch + "cpufreq: create per policy
rwsem instead of per CPU cpu_policy_rwsem"..

Thanks.

Viresh Kumar (34):
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

 Documentation/cpu-freq/cpu-drivers.txt | 27 ++++++++++------
 Documentation/cpu-freq/governors.txt   |  4 +--
 arch/arm/mach-sa1100/generic.c         | 20 ------------
 arch/arm/mach-sa1100/generic.h         |  2 --
 drivers/cpufreq/acpi-cpufreq.c         | 21 ++++---------
 drivers/cpufreq/arm_big_little.c       | 17 +++-------
 drivers/cpufreq/at32ap-cpufreq.c       | 23 +++-----------
 drivers/cpufreq/blackfin-cpufreq.c     | 17 +++-------
 drivers/cpufreq/cpufreq-cpu0.c         | 17 ++--------
 drivers/cpufreq/cpufreq.c              | 57 +++++++++++++++++++++++++++-------
 drivers/cpufreq/cris-artpec3-cpufreq.c | 18 ++---------
 drivers/cpufreq/cris-etraxfs-cpufreq.c | 17 ++--------
 drivers/cpufreq/davinci-cpufreq.c      | 16 ++--------
 drivers/cpufreq/dbx500-cpufreq.c       | 16 ++--------
 drivers/cpufreq/e_powersaver.c         | 17 ++--------
 drivers/cpufreq/elanfreq.c             | 34 ++------------------
 drivers/cpufreq/exynos-cpufreq.c       | 21 ++-----------
 drivers/cpufreq/exynos5440-cpufreq.c   | 21 +++----------
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
 drivers/cpufreq/speedstep-centrino.c   | 27 +++++-----------
 drivers/cpufreq/speedstep-ich.c        | 24 ++++----------
 drivers/cpufreq/speedstep-smi.c        | 20 +++---------
 drivers/cpufreq/tegra-cpufreq.c        | 12 ++-----
 include/linux/cpufreq.h                |  4 ++-
 50 files changed, 242 insertions(+), 759 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

