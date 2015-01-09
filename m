Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbbAIJzK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 04:55:10 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:55695 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611AbbAIJzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 04:55:04 -0500
From: "pi-cheng.chen" <pi-cheng.chen@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: "pi-cheng.chen" <pi-cheng.chen@linaro.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>, linaro-kernel@lists.linaro.org,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>
Subject: [PATCH 0/2] cpufreq: add cpufreq driver for Mediatek MT8173 SoC
Date: Fri,  9 Jan 2015 17:54:49 +0800
Message-Id: <1420797291-15972-1-git-send-email-pi-cheng.chen@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MT8173 is a ARMv8 based SoC with 2 CA53 + 2 CA57 cores and 2 clusters.
All CPUs in a single cluster share the same power and clock domain. This
series tries to add cpufreq driver support for MT8173 SoC by using DT
based cpufreq driver.

Currently the DT based cpufreq driver is missing some way to check which
CPUs share clocks. In the 1st patch, CPU clock/power domain information is
added to the platform_data of cpufreq-dt so that cpufreq-dt driver could
check which CPUs share clock/power.

When doing DVFS on MT8173 SoC, 2 rules should be followed to make sure the
SoC works properly:
1. When doing frequency scaling of CPUs, the clock source should be switched
   to another PLL, then switched back to the orignal until it's stable.
2. When doing voltage scaling of CA57 cluster, Vproc and Vsram need to be
   controlled concurrently and 2 limitations should be followed:
   a. Vsram > Vproc
   b. Vsram - Vproc < 200 mV

To address these needs, we use cpufreq-dt but do voltage scaling in the
cpufreq notifier.

pi-cheng.chen (2):
  cpufreq-dt: check CPU clock/power domain during initializing
  cpufreq: add cpufreq driver for Mediatek MT8173 SoC

 drivers/cpufreq/Kconfig.arm      |   6 +
 drivers/cpufreq/Makefile         |   1 +
 drivers/cpufreq/cpufreq-dt.c     |  15 ++
 drivers/cpufreq/mt8173-cpufreq.c | 459 +++++++++++++++++++++++++++++++++++++++
 include/linux/cpufreq-dt.h       |   6 +
 5 files changed, 487 insertions(+)
 create mode 100644 drivers/cpufreq/mt8173-cpufreq.c

-- 
1.9.1

