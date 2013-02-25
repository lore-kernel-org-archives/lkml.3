Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759630Ab3BYCCE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 21:02:04 -0500
Received: from mga14.intel.com ([143.182.124.37]:23370 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759559Ab3BYCB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 21:01:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,730,1355126400"; 
   d="scan'208";a="205839710"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        andi@firstfloor.org, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V3 0/7] perf, x86: Haswell LBR call stack support
Date: Mon, 25 Feb 2013 10:01:20 +0800
Message-Id: <1361757687-5415-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.11.7
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
 2. Exception handing such as setjmp/longjmp will have calls/returns not
    match
 3. Pushing different return address onto the stack will have calls/returns
    not match

These patches are based upon Andi's linux-misc hsw/pmu5

Available from
    https://github.com/ukernel/linux.git hws/pmu5

Regards
Yan, Zheng

---
Changes since v1
 - not expose PERF_SAMPLE_BRANCH_CALL_STACK to user space
 - save/restore LBR stack on context switch for all sampling branch modes
 - reduce lbr_sel_map size

Changes since v2
 - only enable LBR call stack when user requests sampling user callchain
