Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbaHKFWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:22:30 -0400
Received: from mga14.intel.com ([192.55.52.115]:49669 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317AbaHKFW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:22:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,839,1400050800"; 
   d="scan'208";a="574809653"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v3 00/23] perf: Add infrastructure and support for Intel PT
Date: Mon, 11 Aug 2014 08:19:29 +0300
Message-Id: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter and all,

Here's a new version of PT support patchset, this time including PT and
BTS drivers and a few more tweaks to the core. I still left out some bits
like core dump support for now. Tooling support is not included in this
series so that it's easier to review the kernel bits, I suppose it's best
to send it separately, since it's quite a huge patchset of its own.

Alexander Shishkin (22):
  perf: Add data_{offset,size} to user_page
  perf: Support high-order allocations for AUX space
  perf: Add a capability for AUX_NO_SG pmus to do software double
    buffering
  perf: Add a pmu capability for "exclusive" events
  perf: Redirect output from inherited events to parents
  perf: Add api for pmus to write to AUX space
  perf: Add AUX record
  perf: Support overwrite mode for AUX area
  perf: Add wakeup watermark control to AUX area
  perf: Add itrace_config to the event attribute
  perf: add ITRACE_START record to indicate that tracing has started
  x86: Add Intel Processor Trace (INTEL_PT) cpu feature detection
  x86: perf: Intel PT and LBR/BTS are mutually exclusive
  x86: perf: intel_pt: Intel PT PMU driver
  x86: perf: intel_bts: Add BTS PMU driver
  perf: Add rb_{alloc,free}_kernel api
  perf: Add a helper to copy AUX data in the kernel
  perf: Add a helper for looking up pmus by type
  perf: itrace: Infrastructure for sampling instruction flow traces
  perf: Allocate ring buffers for inherited per-task kernel events
  perf: itrace: Allow itrace sampling for multiple events
  perf: itrace: Allow sampling of inherited events

Peter Zijlstra (1):
  perf: Add AUX area to ring buffer for raw data streams

 arch/x86/include/asm/cpufeature.h          |   1 +
 arch/x86/include/uapi/asm/msr-index.h      |  18 +
 arch/x86/kernel/cpu/Makefile               |   1 +
 arch/x86/kernel/cpu/intel_pt.h             | 129 ++++
 arch/x86/kernel/cpu/perf_event.h           |  14 +
 arch/x86/kernel/cpu/perf_event_intel.c     |  14 +-
 arch/x86/kernel/cpu/perf_event_intel_bts.c | 496 +++++++++++++++
 arch/x86/kernel/cpu/perf_event_intel_ds.c  |  11 +-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |   9 +-
 arch/x86/kernel/cpu/perf_event_intel_pt.c  | 952 +++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/scattered.c            |   1 +
 include/linux/itrace.h                     |  45 ++
 include/linux/perf_event.h                 |  61 +-
 include/uapi/linux/perf_event.h            |  69 ++-
 kernel/events/Makefile                     |   2 +-
 kernel/events/core.c                       | 348 +++++++++--
 kernel/events/internal.h                   |  54 ++
 kernel/events/itrace.c                     | 234 +++++++
 kernel/events/ring_buffer.c                | 313 +++++++++-
 19 files changed, 2724 insertions(+), 48 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/intel_pt.h
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_bts.c
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_pt.c
 create mode 100644 include/linux/itrace.h
 create mode 100644 kernel/events/itrace.c

-- 
2.1.0.rc1

