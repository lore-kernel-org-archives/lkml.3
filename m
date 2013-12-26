Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab3LZVfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 16:35:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:4162 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab3LZVe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 16:34:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,557,1384329600"; 
   d="scan'208";a="456166453"
From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
To: cgroups@vger.kernel.org, x86@kernel.org, tj@kernel.org
Cc: linux-kernel@vger.kernel.org, peter.p.waskiewicz.jr@intel.com
Subject: [RFC PATCH 0/3] x86: Add Cache QoS Monitoring (CQM) support
Date: Thu, 26 Dec 2013 13:34:36 -0800
Message-Id: <1388093679-26952-1-git-send-email-peter.p.waskiewicz.jr@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RFC: This is a work-in-progress patchset.  Looking for general
feedback on the approach and design of this changeset, especially
since this is adding a new cgroup subsystem to present the data
from this CPU feature.

This patchset adds support for the new Cache QoS Monitoring (CQM)
feature found in future Intel Xeon processors.

CQM allows a process, or set of processes, to be tracked by the CPU
to determine the cache usage of that task group.  Using this data
from the CPU, software can be written to extract this data and
report cache usage and occupancy for a particular process, or
group of processes.

More information about Cache QoS Monitoring can be found in the
Intel (R) x86 Architecture Software Developer Manual, section 17.14.

This series is also laying the framework for additional Platform
QoS features in future Intel Xeon processors.

The CPU features themselves are relatively straight-forward, but
the presentation of the data is less straight-forward.  Since this
tracks cache usage and occupancy per process (by swapping Resource
Monitor IDs, or RMIDs, when processes are rescheduled), perf would
not be a good fit for this data, which does not report on a
per-process level.  Therefore, a new cgroup subsystem, cacheqos, has
been added.  This operates very similarly to the cpu and cpuacct
cgroup subsystems, where tasks can be grouped into sub-leaves of the
root-level cgroup.

Peter P Waskiewicz Jr (3):
      x86: Add support for Cache QoS Monitoring (CQM) detection
      x86: Add Cache QoS Monitoring support to x86 perf uncore
      cgroup: Add new cacheqos cgroup subsys to support Cache QoS Monitoring
