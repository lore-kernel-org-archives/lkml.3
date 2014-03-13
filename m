Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbaCMRgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 13:36:23 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:52365 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbaCMRgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 13:36:22 -0400
From: dirk.brandewie@gmail.com
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, rjw@rjwysocki.net, patrick.marlier@gmail.com,
        dirk.brandewie@gmail.com, Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH 0/2] Add exit_prepare callback to the cpufreq_driver interface.
Date: Thu, 13 Mar 2014 10:36:06 -0700
Message-Id: <1394732168-12638-1-git-send-email-dirk.j.brandewie@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

Some drivers (intel_pstate) need to modify state on a core before it
is completely offline.  The ->exit() callback is executed during the
CPU_POST_DEAD phase of the cpu offline process which is too late to
change the state of the core.

Patch 1 adds an optional callback function to the cpufreq_driver
interface which is called by the core during the CPU_DOWN_PREPARE
phase of cpu offline in __cpufreq_remove_dev_prepare().

Patch 2 changes intel_pstate to use the ->exit_prepare callback to do
its cleanup during cpu offline. 

Dirk Brandewie (2):
  cpufreq: Add exit_prepare callback to cpufreq_driver interface
  intel_pstate: Set core to min P state during core offline

 Documentation/cpu-freq/cpu-drivers.txt |  8 +++++++-
 drivers/cpufreq/cpufreq.c              |  3 +++
 drivers/cpufreq/intel_pstate.c         | 20 +++++++++++++-------
 include/linux/cpufreq.h                |  1 +
 4 files changed, 24 insertions(+), 8 deletions(-)

-- 
1.8.3.1

