Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab3KANv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:51:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:23727 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592Ab3KANvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:51:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="402156897"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V3 00/11] perf tools: fixes and tweaks
Date: Fri,  1 Nov 2013 15:51:28 +0200
Message-Id: <1383313899-15987-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here are some fixes and tweaks (version 3) for perf tools.

Changes in V3:
	perf evsel: Always use perf_evsel__set_sample_bit()
		New patch
	perf evsel: Add missing overflow check
		New patch
	perf test: Update "sample parsing" test for PERF_SAMPLE_TRANSACTION
		New patch
	perf evsel: Add missing PERF_SAMPLE_TRANSACTION
		New patch

	Patches dropped because they have been applied:
		perf tools: Fix non-debug build
		perf inject: Do not repipe attributes to a perf.data file

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


Adrian Hunter (11):
      perf evsel: Add a debug print if perf_event_open fails
      perf script: Set up output options for in-stream attributes
      perf tools: Fix 32-bit cross build
      perf tools: Fix libunwind build and feature detection for 32-bit build
      perf evlist: Add a debug print if event buffer mmap fails
      perf record: Add an option to force per-cpu mmaps
      perf evsel: Always use perf_evsel__set_sample_bit()
      perf evsel: Add missing overflow check
      perf test: Update "sample parsing" test for PERF_SAMPLE_TRANSACTION
      perf evsel: Add missing PERF_SAMPLE_TRANSACTION
      perf tools: Allow non-matching sample types

 tools/perf/Documentation/perf-record.txt  |  6 +++
 tools/perf/Makefile.perf                  |  2 +-
 tools/perf/builtin-record.c               |  2 +
 tools/perf/builtin-script.c               | 64 +++++++++++++++++++++++--------
 tools/perf/builtin-trace.c                |  1 +
 tools/perf/config/Makefile                |  8 ++--
 tools/perf/config/feature-checks/Makefile |  6 +--
 tools/perf/perf.h                         |  1 +
 tools/perf/tests/sample-parsing.c         |  7 +++-
 tools/perf/util/event.h                   | 16 ++++++++
 tools/perf/util/evlist.c                  | 31 ++++++++++++++-
 tools/perf/util/evlist.h                  |  1 +
 tools/perf/util/evsel.c                   | 21 +++++++---
 tools/perf/util/record.c                  |  5 ++-
 tools/perf/util/target.h                  |  1 +
 15 files changed, 141 insertions(+), 31 deletions(-)


Regards
Adrian

