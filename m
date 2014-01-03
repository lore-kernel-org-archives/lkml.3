Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaACUfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 15:35:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:18616 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785AbaACUfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 15:35:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,599,1384329600"; 
   d="scan'208";a="459776367"
From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Cc: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] x86: Add Cache QoS Monitoring (CQM) support
Date: Fri,  3 Jan 2014 12:34:41 -0800
Message-Id: <1388781285-18067-1-git-send-email-peter.p.waskiewicz.jr@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Peter P Waskiewicz Jr (4):
      x86: Add support for Cache QoS Monitoring (CQM) detection
      x86: Add Cache QoS Monitoring support to x86 perf uncore
      cgroup: Add new cacheqos cgroup subsys to support Cache QoS Monitoring
      Documentation: Add documentation for cacheqos cgroup
