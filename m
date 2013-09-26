Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab3IZIcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:32:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:31130 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886Ab3IZI2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:28:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,983,1371106800"; 
   d="scan'208";a="401278439"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [RFC PATCH 0/7] perf, x86: Reduce lbr_sel_map size
Date: Thu, 26 Sep 2013 16:28:06 +0800
Message-Id: <1380184093-8838-1-git-send-email-zheng.z.yan@intel.com>
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

The main change since previous patch series is:
 Patch 3 introduces PMU context switch callback, and uses the callback to
 unify the flush branch stack codeo.

 Patch 4 uses the context switch callback to save/restore the LBR stack.

Regards
Yan, Zheng
