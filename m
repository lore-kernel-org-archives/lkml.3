Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab3IZKaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 06:30:46 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:55014 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab3IZKao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 06:30:44 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        nicolas.pitre@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 0/4] CPUFreq stats: Bug fixes
Date: Thu, 26 Sep 2013 15:59:50 +0530
Message-Id: <cover.1380190886.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

I know you asked me not to send any more patches before the earlier ones get
into kernel. I got to this as Nicolas Pitre required to send few CPUFreq patches
for ARM's big LITTLE In-Kernel-Switcher. And within linaro we have hacked these
bugs in a bad way..

Because of his dependency I am forced to send these.. These aren't introduced
recently and so they can be included in 3.13.

There are several problems/bugs in cpufreq-stats specially with cpufreq drivers
as modules and suspend/resume path. These are mentioned well in changelogs.

These are tested over my thinkpad (acpi-cpufreq) in following way:
[1] offline+online all CPUs except boot cpu in a while loop
[2] then do suspend resume
[3] repeat [1] and [2] several times.

No issues found..

Also tested on my exynos board:
- Added cpufreq_unregister/register while loop in exynos-cpufreq.c so that we
  continuously register/unregister driver... Stats were working fine now..
- Compile cpufreq-stats as module and insert/remove it several times after
  removing above hack (as that doesn't let linux boot :) )..

@Srivatsa: You also have fairly good idea of cpufreq now, so please give some
time to review this :)

@Nico: Can you remove the hacky code from IKS tree and test these instead to see
if we still have any issues?

--
viresh

Viresh Kumar (4):
  cpufreq: stats: handle cpufreq_unregister_driver() and suspend/resume
    properly
  cpufreq: stats: remove hotplug notifiers
  cpufreq: stats: free table and remove sysfs entry in a single routine
  cpufreq: stats: create sysfs entries when cpufreq_stats is a module

 drivers/cpufreq/cpufreq.c       |   5 ++
 drivers/cpufreq/cpufreq_stats.c | 109 ++++++++++++++++++----------------------
 include/linux/cpufreq.h         |   2 +
 3 files changed, 55 insertions(+), 61 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

