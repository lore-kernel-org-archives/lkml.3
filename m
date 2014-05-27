Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbaE0LwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 07:52:22 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:48416 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaE0LwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 07:52:18 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        inderpal.s@samsung.com, nm@ti.com, chander.kashyap@linaro.org,
        pavel@ucw.cz, len.brown@intel.com, sudeep.holla@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH V4 0/8] driver/core: cpu: initialize opp table
Date: Tue, 27 May 2014 17:20:49 +0530
Message-Id: <cover.1401191054.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers expecting CPU's OPPs from device tree initialize OPP table themselves by
calling of_init_opp_table() and there is nothing driver specific in that. They
all do it in the same redundant way.

It would be better if we can get rid of redundancy by initializing CPU OPPs from
CPU core code for all CPUs (that have a "operating-points" property defined in
their node).

This patchset callsl of_init_opp_table() directly from register_cpu() right
after CPU device is registered. Later patches updates existing cpufreq drivers
which were calling of_init_opp_table() directly.

V3->V4:
- Remove of_init_cpu_opp_table() and use of_init_opp_table() instead after
  adding more print messages to it.
- Drop a rather unrelated patch which was getting rid of dependency on thermal
  for cpufreq-cpu0. Will be sent separately.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Sudeep Holla <sudeep.holla@arm.com>

Viresh Kumar (8):
  opp: of_init_opp_table(): return -ENOSYS when feature isn't
    implemented
  opp: call of_node_{get|put}() from of_init_opp_table()
  opp: Enhance debug messages in of_init_opp_table()
  driver/core: cpu: initialize opp table
  cpufreq: arm_big_little: don't initialize opp table
  cpufreq: imx6q: don't initialize opp table
  cpufreq: cpufreq-cpu0: don't initialize opp table
  cpufreq: exynos5440: don't initialize opp table

 arch/arm/mach-imx/mach-imx6q.c       | 36 ++++++++----------------------------
 drivers/base/cpu.c                   | 11 +++++++----
 drivers/base/power/opp.c             | 11 ++++++++++-
 drivers/cpufreq/arm_big_little.c     | 12 +++++++-----
 drivers/cpufreq/arm_big_little_dt.c  | 18 ------------------
 drivers/cpufreq/cpufreq-cpu0.c       |  6 ------
 drivers/cpufreq/exynos5440-cpufreq.c |  6 ------
 drivers/cpufreq/imx6q-cpufreq.c      | 20 +-------------------
 include/linux/pm_opp.h               |  2 +-
 9 files changed, 34 insertions(+), 88 deletions(-)

-- 
2.0.0.rc2

