Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab3A3GbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 01:31:06 -0500
Received: from mga14.intel.com ([143.182.124.37]:12699 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab3A3GbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 01:31:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,565,1355126400"; 
   d="scan'208";a="196543095"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        namhyung@kernel.org, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 0/7] perf, x86: Haswell LBR call stack support
Date: Wed, 30 Jan 2013 14:30:50 +0800
Message-Id: <1359527457-6837-1-git-send-email-zheng.z.yan@intel.com>
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

The patch series depends on Andi's "Basic perf PMU support for Haswell v1" 

Available from
    https://github.com/ukernel/linux.git hws/pmu4

Regards
Yan, Zheng
