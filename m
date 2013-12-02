Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab3LBFwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 00:52:46 -0500
Received: from mail-qe0-f45.google.com ([209.85.128.45]:42889 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab3LBFwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 00:52:41 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, nm@ti.com, swarren@wwwdotorg.org,
        kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, tianyu.lan@intel.com,
        jhbird.choi@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V4 0/6] cpufreq: suspend early/resume late: dpm_{suspend|resume}()
Date: Mon,  2 Dec 2013 11:22:30 +0530
Message-Id: <cover.1385962528.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset moves cpufreq callbacks to dpm_{suspend|resume}() from
dpm_{suspend|resume}_noirq() for handling suspend/resume of cpufreq governors
and core. This is required for early suspend and late resume of governors as
there are drivers which want to change cpu frequency before suspending governors
and they want to do it before devices get suspended, as some of them might be
required to change frequency.

Following patch is already pushed for v3.13 as it was required for fixing some
bugs in there. And the remaining was decided to be pushed for v3.14.

commit 5a87182aa21d6d5d306840feab9321818dd3e2a3
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Wed Nov 27 09:09:42 2013 +0530

    cpufreq: suspend governors on system suspend/hibernate

This is already tested by few people and so incorporating their Tested-by as
well.

For: v3.14.

Viresh Kumar (6):
  cpufreq: suspend governors from dpm_{suspend|resume}()
  cpufreq: call driver's suspend/resume for each policy
  cpufreq: Implement cpufreq_generic_suspend()
  cpufreq: exynos: Use cpufreq_generic_suspend()
  cpufreq: s5pv210: Use cpufreq_generic_suspend()
  cpufreq: Tegra: Use cpufreq_generic_suspend()

 drivers/base/power/main.c         |   6 +-
 drivers/cpufreq/cpufreq.c         | 137 ++++++++++++++++----------------------
 drivers/cpufreq/exynos-cpufreq.c  |  96 ++------------------------
 drivers/cpufreq/s5pv210-cpufreq.c |  49 +-------------
 drivers/cpufreq/tegra-cpufreq.c   |  46 ++-----------
 include/linux/cpufreq.h           |   3 +
 6 files changed, 79 insertions(+), 258 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

