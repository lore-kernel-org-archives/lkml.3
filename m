Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206AbaGOWsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:48:07 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43282 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbaGOWsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 18:48:02 -0400
From: Saravana Kannan <skannan@codeaurora.org>
To: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Todd Poynor <toddpoynor@google.com>,
        "Srivatsa S . Bhat" <srivatsa@mit.edu>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Saravana Kannan" <skannan@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH v3 0/2] Simplify hotplug/suspend handling
Date: Tue, 15 Jul 2014 15:47:51 -0700
Message-Id: <1405464473-3916-1-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1405052287-4744-1-git-send-email-skannan@codeaurora.org>
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

Saravana Kannan (2):
  cpufreq: Don't destroy/realloc policy/sysfs on hotplug/suspend
  cpufreq: Simplify and fix mutual exclusion with hotplug

 drivers/cpufreq/cpufreq.c | 432 ++++++++++++++--------------------------------
 1 file changed, 127 insertions(+), 305 deletions(-)

-- 
1.8.2.1

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
