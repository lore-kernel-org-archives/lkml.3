Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbaESGR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 02:17:58 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:36586 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaESGR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 02:17:56 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        inderpal.s@samsung.com, pavel@ucw.cz, nm@ti.com,
        chander.kashyap@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Shawn Guo <shawn.guo@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 0/5] CPUFreq: Initialize CPU's OPP tables from core
Date: Mon, 19 May 2014 11:47:20 +0530
Message-Id: <cover.1400480033.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All drivers expecting CPU's OPPs from device tree initialize OPP table using
of_init_opp_table() and there is nothing driver specific in that. They all do it
in the same way adding to code redundancy.

It would be better if we can get rid of code redundancy by initializing CPU OPPs
from core code for all CPUs that have a "operating-points" property defined in
their node.

First patch initializes OPPs as soon as CPU device is registered in
register_cpu(). Following patches get rid of these calls from individual drivers
which are currently initializing OPPs.

The idea was initially discussed here: https://lkml.org/lkml/2014/5/17/123

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Sudeep Holla <sudeep.holla@arm.com>

Viresh Kumar (5):
  driver/core: cpu: initialize opp table
  cpufreq: arm_big_little: don't initialize opp table
  cpufreq: imx6q: don't initialize opp table
  cpufreq: cpufreq-cpu0: don't initialize opp table
  cpufreq: exynos5440: don't initialize opp table

 arch/arm/mach-imx/mach-imx6q.c       | 36 ++++++++----------------------------
 drivers/base/cpu.c                   | 14 ++++++++++++--
 drivers/cpufreq/arm_big_little.c     | 12 +++++++-----
 drivers/cpufreq/arm_big_little_dt.c  | 18 ------------------
 drivers/cpufreq/cpufreq-cpu0.c       |  6 ------
 drivers/cpufreq/exynos5440-cpufreq.c |  6 ------
 drivers/cpufreq/imx6q-cpufreq.c      | 20 +-------------------
 7 files changed, 28 insertions(+), 84 deletions(-)

-- 
2.0.0.rc2

