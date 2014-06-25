Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbaFYImy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 04:42:54 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:58306 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263AbaFYImv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 04:42:51 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net, sboyd@codeaurora.org, shawn.guo@linaro.org
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        mturquette@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, spk.linux@gmail.com,
        thomas.ab@samsung.com, nm@ti.com, t.figa@samsung.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 0/2] cpufreq: cpu0: Extend support beyond CPU0
Date: Wed, 25 Jun 2014 14:12:27 +0530
Message-Id: <cover.1403684824.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Boyd sent few patches today around a new cpufreq driver for Qualcomm's
Krait SoC: https://lkml.org/lkml/2014/6/24/918.

Krait couldn't use existing cpufreq-cpu0 driver as it doesn't have support for
SoC's with multiple clusters or SoC's which don't share clock line for all CPUs.
And I thought about trying updating cpu0 driver to see if we can get rid of this
limitation easily and use it for Krait as well.

It took me longer than I thought, around 4 hours to get this working on my dual
A15 exynos board.

First patch adds some space for driver specific data in 'struct cpufreq_policy'
and second one updates cpufreq-cpu0..

@Stephen: Can you please test this on Krait and see if it works?

Pushed here:
Rebased over rc2:
git://git.linaro.org/people/viresh.kumar/linux.git cpufreq/cpu0-krait

For guys looking to test on exynos, rebased over linux-next + some patches from
Thomas Abraham to use cpufreq-cpu0 for exynos:
git://git.linaro.org/people/viresh.kumar/linux.git cpufreq/cpu0-exynos


In case this is acceptable and bug free, next step would be to get cpufreq-cpu0
renamed a bit as its not about CPU0 anymore. Any suggestions on that would be
great :), cpufreq_generic.c ?

Thanks.

Viresh Kumar (2):
  cpufreq: Add support for per-policy driver data
  cpufreq: cpu0: Extend support beyond CPU0

 .../devicetree/bindings/cpufreq/cpufreq-cpu0.txt   |   8 +-
 drivers/cpufreq/Kconfig                            |   5 +-
 drivers/cpufreq/cpufreq-cpu0.c                     | 280 +++++++++++++--------
 include/linux/cpufreq.h                            |   3 +
 4 files changed, 193 insertions(+), 103 deletions(-)

-- 
2.0.0.rc2

