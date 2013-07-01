Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab3GAHXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 03:23:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:6666 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab3GAHXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 03:23:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,972,1363158000"; 
   d="scan'208";a="362388499"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        andi@firstfloor.org, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v2 0/7] perf, x86: Haswell LBR call stack support
Date: Mon,  1 Jul 2013 15:23:00 +0800
Message-Id: <1372663387-11754-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

Haswell has a new feature that utilizes the existing Last Branch Record
facility to record call chains. When the feature is enabled, function
call will be collected as normal, but as return instructions are executed
the last captured branch record is popped from the on-chip LBR registers.
The LBR call stack facility can help perf to get call chains of progam
without frame pointer. When perf tool requests PERF_SAMPLE_CALLCHAIN +
PERF_SAMPLE_BRANCH_USER, this feature is dynamically enabled by default.
This feature can be disabled/enabled through an attribute file in the cpu
pmu sysfs directory.

The LBR call stack has following known limitations
 1. Zero length calls are not filtered out by hardware
 2. Exception handing such as setjmp/longjmp will have calls/returns
    not match
 3. Pushing different return address onto the stack will have
    calls/returns not match

These patches are based upon tip/perf/core

Regards
Yan, Zheng
---
Changes since v1
 - more comments for why FREEZE_LBRS_ON_PMI does not work
 - don't save/restore LBR during context switches if LBR are used by
   CPU events
 - change mode of /sys/devices/cpu/lbr_callstack to 0644
