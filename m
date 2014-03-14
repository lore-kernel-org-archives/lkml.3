Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbaCNVEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 17:04:10 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:48921 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904AbaCNVEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 17:04:07 -0400
From: dirk.brandewie@gmail.com
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, rjw@rjwysocki.net, patrick.marlier@gmail.com,
        dirk.brandewie@gmail.com, Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH v2 0/2] Add exit_prepare callback to the cpufreq_driver interface.
Date: Fri, 14 Mar 2014 14:03:55 -0700
Message-Id: <1394831037-15553-1-git-send-email-dirk.j.brandewie@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <16035918.jZXKnQ3yiq@vostro.rjw.lan>
References: <16035918.jZXKnQ3yiq@vostro.rjw.lan>
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

Patch 2 changes intel_pstate to use the ->stop callback to do
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

