Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab3JCP5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:57:05 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:40330 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab3JCP5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:57:02 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, daniel.lezcano@linaro.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 00/16] CPUIdle: Minor cleanups for 3.13
Date: Thu,  3 Oct 2013 21:26:39 +0530
Message-Id: <cover.1380815504.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

These are V2 of my CPUIdle cleanup series.. Few patches are dropped as they
required further modifications. Last one is rewritten as suggested by Daniel.
Most of them are already Acked by Daniel.

Viresh Kumar (16):
  cpuidle: fix indentation of cpumask
  cpuidle: Fix comments in cpuidle core
  cpuidle: make __cpuidle_get_cpu_driver() inline
  cpuidle: make __cpuidle_device_init() return void
  cpuidle: make __cpuidle_driver_init() return void
  cpuidle: rearrange code in __cpuidle_driver_init()
  cpuidle: rearrange __cpuidle_register_device() to keep minimal exit
    points
  cpuidle: merge two if() statements for checking error cases
  cpuidle: reduce code duplication inside cpuidle_idle_call()
  cpuidle: replace multiline statements with single line in
    cpuidle_idle_call()
  cpuidle: call cpuidle_get_driver() from after taking
    cpuidle_driver_lock
  cpuidle: use drv instead of cpuidle_driver in show_current_driver()
  cpuidle: free all state kobjects from cpuidle_free_state_kobj()
  cpuidle: don't calculate time-diff if entered_state < 0
  cpuidle: don't call poll_idle_init() for every cpu
  cpuidle: remove cpuidle_unregister_governor()

 Documentation/cpuidle/governor.txt |  1 -
 drivers/cpuidle/coupled.c          |  2 +-
 drivers/cpuidle/cpuidle.c          | 95 ++++++++++----------------------------
 drivers/cpuidle/driver.c           | 69 ++++++++++++++++++++-------
 drivers/cpuidle/governor.c         | 43 -----------------
 drivers/cpuidle/sysfs.c            | 30 ++++++------
 include/linux/cpuidle.h            |  8 +---
 7 files changed, 94 insertions(+), 154 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

