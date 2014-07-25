Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbaGYBHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 21:07:46 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34408 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbaGYBHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 21:07:42 -0400
From: Saravana Kannan <skannan@codeaurora.org>
To: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Todd Poynor <toddpoynor@google.com>,
        "Srivatsa S . Bhat" <srivatsa@mit.edu>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Saravana Kannan" <skannan@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH v4 0/5] Simplify hotplug/suspend handling
Date: Thu, 24 Jul 2014 18:07:23 -0700
Message-Id: <1406250448-470-1-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1405464473-3916-1-git-send-email-skannan@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Series of patchs to simplify policy/sysfs/kobj/locking handling across
suspend/resume

The following have been tested so far on a 2x2 cluster environment:
- Boot with 2 cpus and no cpufreq driver.
- mod probe driver and see cpufreq sysfs files show up only for the 1st cluster.
- Online the rest of the 2 CPUs and have files show up correctly.
- rmmod the driver and see the files go away.
- modprobe again (or back and forth multiples times) and see it work.
- suspend/resume works as expected.
- When a cluster is offline, all read/writes to its sysfs files return an error

v4
- Split it up into smaller patches
- Will handle physical CPU removal correctly
- Fixed earlier mistake of deleting code under !recover_policy
- Dropped some code refactor that reuses a lot of code between add/remove
- Dropped fix for exiting hotplug race with cpufreq driver probe/rmmod
- Dropped changes will come later once this series is acked.


Saravana Kannan (5):
  cpufreq: Don't wait for CPU to going offline to restart governor
  cpufreq: Keep track of which CPU owns the kobj/sysfs nodes separately
  cpufreq: Don't destroy/realloc policy/sysfs on hotplug/suspend
  cpufreq: Properly handle physical CPU hot-add/hot-remove
  cpufreq: Delete dead code related to policy save/restore

 drivers/cpufreq/cpufreq.c | 238 ++++++++++++++++++----------------------------
 include/linux/cpufreq.h   |   1 +
 2 files changed, 93 insertions(+), 146 deletions(-)

-- 
1.8.2.1

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
