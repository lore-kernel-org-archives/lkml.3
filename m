Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab3JVHfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 03:35:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:37221 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab3JVHfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 03:35:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="310958120"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 00/14] perf tools: fixes and tweaks
Date: Tue, 22 Oct 2013 10:34:04 +0300
Message-Id: <1382427258-17495-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here are some fixes and tweaks (version 2) for perf tools.

Changes in V2:

	perf tools: Fix non-debug build
		New patch
	perf evsel: Add a debug print if perf_event_open fails
		Unchanged
	perf script: Make perf_script a local variable
		Split from "perf script: Set up output options for in-stream attributes"
	perf script: Set up output options for in-stream attributes
		Split out "perf script: Make perf_script a local variable"
	perf inject: Do not repipe attributes to a perf.data file
		Unchanged
	perf tools: Fix 32-bit cross build
		Pass only EXTRA_CFLAGS
	perf tools: Fix libunwind build and feature detection for 32-bit build
		Add Jiri's Ack
	perf evlist: Add a debug print if event buffer mmap fails
		Add errno
	perf tools: Allow non-matching sample types
		Suppress compatible sample types for trace tool
	perf sched: Make struct perf_sched sched a local variable
		New patch
	perf sched: Fix optimized build time
		New patch
	perf tools: Do not accept parse_tag_value() overflow
		New patch
	perf tools: Validate that mmap_pages is not too big
		New patch

	Patches dropped because they have been applied:
		perf evsel: Add missing 'mmap2' from debug print
		perf record: Improve write_output error message
		perf evsel: Add missing decrement in id sample parsing
		perf session: Add missing sample flush for piped events
		perf session: Add missing members to perf_event__attr_swap()
		perf evlist: Fix 32-bit build error
		perf tools: Fix test_on_exit for 32-bit build
		perf tools: Fix bench/numa.c for 32-bit build
		perf tools: fix perf_evlist__mmap comments
		perf tools: factor out duplicated evlist mmap code
		perf script: print addr by default for BTS


Adrian Hunter (14):
      perf tools: Fix non-debug build
      perf evsel: Add a debug print if perf_event_open fails
      perf script: Make perf_script a local variable
      perf script: Set up output options for in-stream attributes
      perf inject: Do not repipe attributes to a perf.data file
      perf tools: Fix 32-bit cross build
      perf tools: Fix libunwind build and feature detection for 32-bit build
      perf evlist: Add a debug print if event buffer mmap fails
      perf record: Add an option to force per-cpu mmaps
      perf tools: Allow non-matching sample types
      perf sched: Make struct perf_sched sched a local variable
      perf sched: Fix optimized build time
      perf tools: Do not accept parse_tag_value() overflow
      perf tools: Validate that mmap_pages is not too big

 tools/perf/Documentation/perf-record.txt  |   6 ++
 tools/perf/Makefile.perf                  |   2 +-
 tools/perf/builtin-inject.c               |   5 ++
 tools/perf/builtin-record.c               |   2 +
 tools/perf/builtin-sched.c                |  44 +++++++------
 tools/perf/builtin-script.c               | 102 +++++++++++++++++++++---------
 tools/perf/builtin-trace.c                |   1 +
 tools/perf/config/Makefile                |  12 +++-
 tools/perf/config/feature-checks/Makefile |   6 +-
 tools/perf/perf.h                         |   1 +
 tools/perf/util/event.h                   |  16 +++++
 tools/perf/util/evlist.c                  |  45 +++++++++++--
 tools/perf/util/evlist.h                  |   1 +
 tools/perf/util/evsel.c                   |   6 +-
 tools/perf/util/record.c                  |   5 +-
 tools/perf/util/target.h                  |   1 +
 tools/perf/util/util.c                    |   2 +
 17 files changed, 190 insertions(+), 67 deletions(-)


Regards
Adrian

