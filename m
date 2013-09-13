Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab3IMM7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 08:59:51 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:52454 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab3IMM7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 08:59:48 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 0/2] cpufreq: fix transition_ongoing count for powernow-k8
Date: Fri, 13 Sep 2013 18:29:37 +0530
Message-Id: <cover.1379062834.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has been running in my mind since few days... That we have fixed cpufreq
core and all other drivers for transition serialization but what about
powernow-k8? It is somewhat special (even more than exynos5440).. It queues a
work from ->target() and may or maynot send notifications at all..

Finally I have got a solution now (detailed logs in the patch)..
These must go with following patchset:

https://lkml.org/lkml/2013/9/12/173

Compile tested only..

Viresh Kumar (2):
  cpufreq: Create cpufreq_transition_complete()
  cpufreq: powernow-k8: mark freq transition complete on error cases

 drivers/cpufreq/cpufreq.c     | 25 ++++++++++++-----------
 drivers/cpufreq/powernow-k8.c | 47 +++++++++++++++++++++++++++++++------------
 include/linux/cpufreq.h       |  7 +++++++
 3 files changed, 54 insertions(+), 25 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

