Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab3A3NAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 08:00:22 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:65346 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab3A3NAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:00:20 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, swarren@wwwdotorg.org,
        linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        mathieu.poirier@linaro.org, Joseph Lo <josephl@nvidia.com>,
        linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH v7 0/5] cpufreq: handle SW coordinated CPUs
Date: Wed, 30 Jan 2013 13:59:59 +0100
Message-Id: <1359550803-18577-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rafael,

this is the v7 for the cpufreq SW coordinated CPU bug fix, developed
after the discussion with Viresh about some issues that appeared after
the merge of both mine and his patches.

Changes from v6:

* Dropped the cpu hotplug patch, as it was solving part of problem
addressed by Viresh patch:

dbcb634 cpufreq: Notify governors when cpus are hot-[un]plugged

but was behaving erratically when both patches were applied together.

* In the initial patch, cleaned up cpufreq_governor_dbs and
dbs_timer_{init,exit} to remove non necessary variables and special case
initialization, as the additional data provided on that code was not
necessary since v6.  The code is a bit cleaner now.

Would you consider replacing my patches currently on your pm-cpufreq-next
branch with this series?  There should not be any conflicts with existing
patches.  Let me know if you prefer incremental patches instead.

Thanks,
Fabio

Fabio Baltieri (3):
  cpufreq: ondemand: call dbs_check_cpu only when necessary
  cpufreq: conservative: call dbs_check_cpu only when necessary
  cpufreq: ondemand: use all CPUs in update_sampling_rate

Rickard Andersson (1):
  cpufreq: handle SW coordinated CPUs

 drivers/cpufreq/cpufreq_conservative.c | 46 ++++++++++++++++++++++---
 drivers/cpufreq/cpufreq_governor.c     | 34 ++++++++++++++-----
 drivers/cpufreq/cpufreq_governor.h     |  2 ++
 drivers/cpufreq/cpufreq_ondemand.c     | 62 +++++++++++++++++++++++++++-------
 4 files changed, 119 insertions(+), 25 deletions(-)

-- 
1.7.12.1

