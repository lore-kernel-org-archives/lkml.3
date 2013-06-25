Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab3FYIr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:47:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:47567 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414Ab3FYIrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:47:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,935,1363158000"; 
   d="scan'208";a="359143392"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        andi@firstfloor.org, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 0/7] perf, x86: Haswell LBR call stack support
Date: Tue, 25 Jun 2013 16:47:12 +0800
Message-Id: <1372150039-15151-1-git-send-email-zheng.z.yan@intel.com>
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
 2. Exception handing such as setjmp/longjmp will have calls/returns not
    match
 3. Pushing different return address onto the stack will have calls/returns
    not match

These patches are based upon tip/perf/core

Regards
Yan, Zheng
