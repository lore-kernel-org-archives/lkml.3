Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab3GHBou (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 21:44:50 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56181 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab3GHBot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 21:44:49 -0400
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH RFC 0/3] voltage scaling via clock rate-change notifiers
Date: Sun,  7 Jul 2013 18:44:25 -0700
Message-Id: <1373247868-21444-1-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scaling regulator voltage as a function of clock frequency is a common
power saving technique. It is often referred to as dynamic voltage &
frequency scaling (DVFS). The common clock framework has clock
rate-change notifier (pre & post) which provide a convenient hook for
scaling voltage whenever clk_set_rate is called.

The first patch in the series provides helper functions for drivers that
wish to scale voltage through the clock rate-change notifiers. The
approach taken is that the driver does not care about the details of the
OPP table, nor does it care about handling the voltage regulator
directly. The driver only has a pointer to the struct clk object; the
other details are hidden in the helper functions.

The second patch provides a CPUfreq-centric helper, built on top of the
first one. This is primarly to help with the struct
cpufreq_frequency_table bits and latency calculation.

The final patch in the series converts the cpufreq-cpu0 driver to use
these functions. Other cpufreq drivers can be converted later.

There are not many cases of DVFS usage in the kernel; vendors often keep
these out-of-tree. By providing a common approach using the clock rate
change notifiers this series hopes to consolidate code across drivers
and encourage vendors to upstream their DVFS bits.

Mike Turquette (3):
  clk: notifier handler for dynamic voltage scaling
  clk: cpufreq helper for voltage scaling
  cpufreq: cpufreq-cpu0: clk rate-change notifiers

 drivers/clk/Makefile               |   1 +
 drivers/clk/clk-voltage-notifier.c | 206 +++++++++++++++++++++++++++++++++++++
 drivers/cpufreq/cpufreq-cpu0.c     | 125 ++++------------------
 include/linux/clk.h                |  13 ++-
 4 files changed, 241 insertions(+), 104 deletions(-)
 create mode 100644 drivers/clk/clk-voltage-notifier.c

-- 
1.8.1.2

