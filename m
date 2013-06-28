Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab3F1NQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:16:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:53810 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab3F1NQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:16:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,958,1363158000"; 
   d="scan'208";a="361090079"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 0/5] perf: add two new features
Date: Fri, 28 Jun 2013 16:22:16 +0300
Message-Id: <1372425741-1676-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Please consider these two new perf features:
      x86: add ability to calculate TSC from perf sample timestamps
      perf: add 'keep tracking' flag to PERF_EVENT_IOC_DISABLE

This is also a minor fix:
      perf: fix broken union in perf_event_mmap_page

And tests in perf tools:
      perf tools: add test for converting perf time to/from TSC
      perf tools: add 'keep tracking' test


Adrian Hunter (5):
      perf: fix broken union in perf_event_mmap_page
      x86: add ability to calculate TSC from perf sample timestamps
      perf tools: add test for converting perf time to/from TSC
      perf: add 'keep tracking' flag to PERF_EVENT_IOC_DISABLE
      perf tools: add 'keep tracking' test

 arch/x86/include/asm/tsc.h          |   1 +
 arch/x86/kernel/cpu/perf_event.c    |   6 ++
 arch/x86/kernel/tsc.c               |   6 ++
 include/linux/perf_event.h          |   1 +
 include/uapi/linux/perf_event.h     |  29 +++++-
 kernel/events/core.c                |  21 ++++-
 tools/perf/Makefile                 |   4 +
 tools/perf/arch/x86/Makefile        |   2 +
 tools/perf/arch/x86/util/tsc.c      |  59 ++++++++++++
 tools/perf/arch/x86/util/tsc.h      |  20 ++++
 tools/perf/tests/builtin-test.c     |  10 ++
 tools/perf/tests/keep-tracking.c    | 168 ++++++++++++++++++++++++++++++++++
 tools/perf/tests/perf-time-to-tsc.c | 177 ++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h            |   2 +
 tools/perf/util/evlist.c            |  32 +++++++
 tools/perf/util/evlist.h            |   5 +
 16 files changed, 537 insertions(+), 6 deletions(-)
 create mode 100644 tools/perf/arch/x86/util/tsc.c
 create mode 100644 tools/perf/arch/x86/util/tsc.h
 create mode 100644 tools/perf/tests/keep-tracking.c
 create mode 100644 tools/perf/tests/perf-time-to-tsc.c


Regards
Adrian

