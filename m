Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab3BFRCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:02:37 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:42186 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab3BFRCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:02:35 -0500
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 0/5] Add P state driver for Intel Core Processors
Date: Wed,  6 Feb 2013 09:02:07 -0800
Message-Id: <1360170133-5066-1-git-send-email-dirk.brandewie@gmail.com>
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
processor

Changes since last version:
Dropped unneeded patches.

Rebased on bleeding edge 1071b3b

Patch 1:
    updated per Viresh's comments, added his ack.

Patch 2:
    updated description to be more informative and move the check as
    to whether the scaling driver implements target() to only effect
    whether cpufreq_out_of_sync() is called

Patch 3:
    Added Viresh's Ack

Patch 4:
    Upadted to not use unneeded local variable


Dirk Brandewie (5):
  cpufreq: Retrieve current frequency from scaling drivers with
    internal governors
  cpufreq: Only call cpufreq_out_of_sync() with drivers that implement
    cpufreq_driver.target()
  cpufreq: Do not track governor name for scaling drivers with internal
    governors.
  cpufreq_stats: do not remove sysfs files if frequency table is not
    present
  cpufreq/x86: Add P-state driver for sandy bridge.

 drivers/cpufreq/Kconfig.x86     |   18 +
 drivers/cpufreq/Makefile        |    1 +
 drivers/cpufreq/cpufreq.c       |   13 +-
 drivers/cpufreq/cpufreq_stats.c |    4 +
 drivers/cpufreq/intel_pstate.c  |  829 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 862 insertions(+), 3 deletions(-)
 create mode 100644 drivers/cpufreq/intel_pstate.c

-- 
1.7.7.6

