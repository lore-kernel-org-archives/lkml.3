Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab3J2N0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 09:26:21 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:49345 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab3J2N0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 09:26:19 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 Resend 0/2] CPUFreq Cleanup Part IV
Date: Tue, 29 Oct 2013 18:56:05 +0530
Message-Id: <cover.1383052613.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

Thanks for applying all earlier patches for v3.13. There are only few left after
this patchset, i.e. only set with these changes: "create cpufreq_generic_get()
routine"..

This patchset moves cpufreq-notifications to core and make ->target_index()
routines really light weight and gets rid of a lot of redundant code.

It is already reviewed/Acked/Tested by few people and so should be stable
enough.

See if you can still get these for 3.13..

Viresh Kumar (2):
  cpufreq: distinguish drivers that do asynchronous notifications
  cpufreq: move freq change notifications to cpufreq core

 drivers/cpufreq/acpi-cpufreq.c         | 14 ++-------
 drivers/cpufreq/arm_big_little.c       | 25 ++--------------
 drivers/cpufreq/at32ap-cpufreq.c       | 22 ++++++--------
 drivers/cpufreq/blackfin-cpufreq.c     | 22 +++++---------
 drivers/cpufreq/cpufreq-cpu0.c         | 33 ++++++++-------------
 drivers/cpufreq/cpufreq.c              | 40 +++++++++++++++++++++++--
 drivers/cpufreq/cris-artpec3-cpufreq.c |  8 -----
 drivers/cpufreq/cris-etraxfs-cpufreq.c |  8 -----
 drivers/cpufreq/davinci-cpufreq.c      | 30 +++++++------------
 drivers/cpufreq/dbx500-cpufreq.c       | 22 +-------------
 drivers/cpufreq/e_powersaver.c         | 23 ++-------------
 drivers/cpufreq/elanfreq.c             | 13 --------
 drivers/cpufreq/exynos-cpufreq.c       | 28 +++++-------------
 drivers/cpufreq/exynos5440-cpufreq.c   |  2 +-
 drivers/cpufreq/ia64-acpi-cpufreq.c    | 19 ------------
 drivers/cpufreq/imx6q-cpufreq.c        | 37 ++++++++++-------------
 drivers/cpufreq/kirkwood-cpufreq.c     | 54 +++++++++++++---------------------
 drivers/cpufreq/loongson2_cpufreq.c    | 16 ----------
 drivers/cpufreq/maple-cpufreq.c        | 18 +-----------
 drivers/cpufreq/omap-cpufreq.c         | 38 ++++++++----------------
 drivers/cpufreq/p4-clockmod.c          | 10 -------
 drivers/cpufreq/pasemi-cpufreq.c       | 14 +--------
 drivers/cpufreq/pmac32-cpufreq.c       | 20 +++----------
 drivers/cpufreq/pmac64-cpufreq.c       | 18 +-----------
 drivers/cpufreq/powernow-k8.c          |  1 +
 drivers/cpufreq/ppc-corenet-cpufreq.c  | 19 +-----------
 drivers/cpufreq/ppc_cbe_cpufreq.c      | 19 +-----------
 drivers/cpufreq/pxa2xx-cpufreq.c       | 27 ++++-------------
 drivers/cpufreq/pxa3xx-cpufreq.c       | 12 --------
 drivers/cpufreq/s3c2416-cpufreq.c      | 21 +++----------
 drivers/cpufreq/s3c64xx-cpufreq.c      | 48 ++++++++++--------------------
 drivers/cpufreq/s5pv210-cpufreq.c      | 16 ++++------
 drivers/cpufreq/sa1100-cpufreq.c       | 17 ++++-------
 drivers/cpufreq/sa1110-cpufreq.c       | 12 ++------
 drivers/cpufreq/sc520_freq.c           | 11 -------
 drivers/cpufreq/sparc-us2e-cpufreq.c   |  7 -----
 drivers/cpufreq/sparc-us3-cpufreq.c    |  7 -----
 drivers/cpufreq/spear-cpufreq.c        | 13 +-------
 drivers/cpufreq/speedstep-centrino.c   | 21 +------------
 drivers/cpufreq/speedstep-ich.c        |  9 ------
 drivers/cpufreq/speedstep-smi.c        |  7 -----
 drivers/cpufreq/tegra-cpufreq.c        | 25 ++++------------
 include/linux/cpufreq.h                |  7 +++++
 43 files changed, 205 insertions(+), 628 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

