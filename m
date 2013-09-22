Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab3IVBVc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 21:21:32 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:45614 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab3IVBVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 21:21:23 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, daniel.lezcano@linaro.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 00/21] CPUIdle: Minor cleanups for 3.13
Date: Sun, 22 Sep 2013 06:50:52 +0530
Message-Id: <cover.1379779777.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael/Daniel,

This is a small cleanup patchset for CPUIdle which can go in 3.13 if it looks
okay to you guys..

Mostly trivial patches but few are doing good/significant changes. Tested on my
thinkpad with suspend/resume and didn't found any broken stuff with it.

I a not very sure about this patch (As I don't know about all aspects of CPUIdle
framework):
  cpuidle: don't call poll_idle_init() for every cpu

--
viresh

Viresh Kumar (21):
  cpuidle: fix indentation of cpumask
  cpuidle: Fix comments in cpuidle core
  cpuidle: make __cpuidle_get_cpu_driver() inline
  cpuidle: make __cpuidle_device_init() return void
  cpuidle: make __cpuidle_driver_init() return void
  cpuidle: rearrange code in __cpuidle_driver_init()
  cpuidle: rearrange __cpuidle_register_device() to keep minimal exit
    points
  cpuidle: use cpuidle_disabled() instead of "off"
  cpuidle: merge two if() statements for checking error cases
  cpuidle: reduce code duplication inside cpuidle_idle_call()
  cpuidle: replace multiline statements with single line in
    cpuidle_idle_call()
  cpuidle: call cpuidle_get_driver() from after taking
    cpuidle_driver_lock
  cpuidle: use drv instead of cpuidle_driver in show_current_driver()
  cpuidle: coupled: don't compare cpu masks unnecessarily
  cpuidle: free all state kobjects from cpuidle_free_state_kobj()
  cpuidle: avoid unnecessary kzalloc/free of struct cpuidle_device_kobj
  cpuidle: avoid unnecessary kzalloc/free of struct cpuidle_driver_kobj
  cpuidle: don't call poll_idle_init() for every cpu
  cpuidle: create list of registered drivers
  cpuidle: don't calculate time-diff if entered_state == 0
  cpuidle: change governor from within cpuidle_replace_governor()

 drivers/cpuidle/coupled.c  |   9 +--
 drivers/cpuidle/cpuidle.c  |  95 +++++++------------------
 drivers/cpuidle/driver.c   | 171 ++++++++++++++++++++-------------------------
 drivers/cpuidle/governor.c |  24 +++----
 drivers/cpuidle/sysfs.c    |  74 +++++++-------------
 include/linux/cpuidle.h    |  25 +++++--
 6 files changed, 161 insertions(+), 237 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

