Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab3BASpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 13:45:55 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:42076 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab3BASpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 13:45:54 -0500
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 0/6] Add P state driver for Intel Core Processors
Date: Fri,  1 Feb 2013 10:45:34 -0800
Message-Id: <1359744343-18690-1-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

This driver implements a scaling driver with an internal governor for
Intel Core processors.  The driver follows the same model as the
Transmeta scaling driver (longrun.c) and implements the setpolicy()
instead of target().  Scaling drivers that implement setpolicy() are
assmuned to implement internal governors by the cpufreq core. All the
logic for selecting the current P state is contained within the driver
no external governor is used by the cpufreq core.

At the moment only Intel SandyBridge processors are supported. As
testing on SandyBridge+ processors is completed support will be added
to the driver.

New sysfs files for controlling P state selection have been added to
/sys/devices/system/cpu/intel_pstate/
      max_perf_pct: limits the maximum P state that will be requested by
      the driver stated as a percentage of the avail performance.
    
      min_perf_pct: limits the minimum P state that will be  requested by
      the driver stated as a percentage of the avail performance.
    
      no_turbo: limits the driver to selecting P states below the turbo
      frequency range.

The units for these for these files are purposely abstract and stated
in terms of available performance and not frequency.  In idea that
frequency can be set to a single frequency is a fiction for Intel Core
processors. Even if the scaling driver selects a single P state the
actual frequency the processor will run at is selected by the
processor itself.

Based on v3.8-rc5.
Patches 1-5:
     Fix issues related to scaling drivers that implement the
     setpolicy() interface instead of target() when CONFIG_SMP and
     CONFIG_HOTPLUG_CPU are set.

Patch 6:
     The driver and associated config glue.

Dirk Brandewie (6):
  cpufreq: Retrieve current frequency from scaling drivers with
    internal governors
  cpufreq: Only query drivers that implement cpufreq_driver.target()
  cpufreq: Do not track governor name for scaling drivers with internal
    governors.
  cpufreq_stats: Do not track policies without associated governors.
  cpufreq: balance out cpufreq_cpu_{get,put} for scaling drivers using
    setpolicy
  cpufreq/x86: Add P-state driver for sandy bridge.

 drivers/cpufreq/Kconfig.x86     |   18 +
 drivers/cpufreq/Makefile        |    1 +
 drivers/cpufreq/cpufreq.c       |   43 ++-
 drivers/cpufreq/cpufreq_stats.c |    4 +-
 drivers/cpufreq/intel_pstate.c  |  830 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 880 insertions(+), 16 deletions(-)
 create mode 100644 drivers/cpufreq/intel_pstate.c

-- 
1.7.7.6

