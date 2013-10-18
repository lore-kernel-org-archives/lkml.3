Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab3JRMa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:30:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:48657 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912Ab3JRMa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:30:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,522,1378882800"; 
   d="scan'208";a="394936360"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 00/19] perf tools: fixes and tweaks
Date: Fri, 18 Oct 2013 15:28:57 +0300
Message-Id: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here are some fixes and tweaks for perf tools.


Adrian Hunter (19):
      perf evsel: Add missing 'mmap2' from debug print
      perf evsel: Add a debug print if perf_event_open fails
      perf record: Improve write_output error message
      perf evsel: Add missing decrement in id sample parsing
      perf session: Add missing sample flush for piped events
      perf session: Add missing members to perf_event__attr_swap()
      perf script: Set up output options for in-stream attributes
      perf inject: Do not repipe attributes to a perf.data file
      perf tools: Fix 32-bit cross build
      perf evlist: Fix 32-bit build error
      perf tools: Fix test_on_exit for 32-bit build
      perf tools: Fix bench/numa.c for 32-bit build
      perf tools: Fix libunwind build and feature detection for 32-bit build
      perf evlist: Add a debug print if event buffer mmap fails
      perf tools: fix perf_evlist__mmap comments
      perf tools: factor out duplicated evlist mmap code
      perf script: print addr by default for BTS
      perf record: add an option to force per-cpu mmaps
      perf tools: allow non-matching sample types

 tools/perf/Documentation/perf-record.txt        |   6 ++
 tools/perf/Makefile.perf                        |   2 +-
 tools/perf/bench/numa.c                         |   4 +-
 tools/perf/builtin-inject.c                     |   5 +
 tools/perf/builtin-record.c                     |   4 +-
 tools/perf/builtin-script.c                     | 106 ++++++++++++++------
 tools/perf/config/Makefile                      |   8 +-
 tools/perf/config/feature-checks/Makefile       |   6 +-
 tools/perf/config/feature-checks/test-on-exit.c |   1 +
 tools/perf/util/event.h                         |  16 +++
 tools/perf/util/evlist.c                        | 126 ++++++++++++++----------
 tools/perf/util/evlist.h                        |   1 +
 tools/perf/util/evsel.c                         |   8 +-
 tools/perf/util/record.c                        |   5 +-
 tools/perf/util/session.c                       |  11 ++-
 tools/perf/util/target.h                        |   1 +
 16 files changed, 211 insertions(+), 99 deletions(-)


Regards
Adrian

