Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab3BDLjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:39:11 -0500
Received: from mail-da0-f54.google.com ([209.85.210.54]:53405 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab3BDLjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:39:08 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 0/4] CPUFreq: Implement per policy instances of governors
Date: Mon,  4 Feb 2013 17:08:50 +0530
Message-Id: <cover.1359976493.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, there can't be multiple instances of single governor_type. If we have
a multi-package system, where we have multiple instances of struct policy (per
package), we can't have multiple instances of same governor. i.e. We can't have
multiple instances of ondemand governor for multiple packages.

Governors directory in sysfs is created at /sys/devices/system/cpu/cpufreq/
governor-name/. Which again reflects that there can be only one instance of a
governor_type in the system.

This is a bottleneck for multicluster system, where we want different packages
to use same governor type, but with different tunables.

This patchset is inclined towards fixing this issue.

Viresh Kumar (4):
  cpufreq: Don't check cpu_online(policy->cpu)
  cpufreq: stats: Get rid of CPUFREQ_STATDEVICE_ATTR
  cpufreq: Add per policy governor-init/exit infrastructure
  cpufreq: governor: Implement per policy instances of governors

 drivers/cpufreq/cpufreq.c              |  41 ++++---
 drivers/cpufreq/cpufreq_conservative.c | 142 +++++++++++++----------
 drivers/cpufreq/cpufreq_governor.c     | 140 +++++++++++++---------
 drivers/cpufreq/cpufreq_governor.h     |  42 ++++---
 drivers/cpufreq/cpufreq_ondemand.c     | 205 +++++++++++++++++++--------------
 drivers/cpufreq/cpufreq_stats.c        |  18 +--
 drivers/cpufreq/cpufreq_userspace.c    |   2 -
 drivers/cpufreq/freq_table.c           |   6 -
 include/linux/cpufreq.h                |  26 +----
 9 files changed, 346 insertions(+), 276 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

