Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab3GRKgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:36:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:56267 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754638Ab3GRKgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:36:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,692,1367996400"; 
   d="scan'208";a="347700550"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V8 00/15] perf tools: some fixes and tweaks
Date: Thu, 18 Jul 2013 13:42:42 +0300
Message-Id: <1374144177-24762-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here are some fixes and tweaks to perf tools (version 8).

Changes in V8:
	perf tools: add debug prints
		Fixed Python link errors
	perf tools: move perf_evlist__config() to a new source file
		New Patch to avoid Python link errors
	perf tools: add support for PERF_SAMPLE_IDENTFIER
		Adjustments due to patch above

Changes in V7:
	perf: Update perf_event_type documentation
		Proposed new patch from Peter Zijlstra
	perf: make events stream always parsable
		Adjustments due to patch above
	perf tools: tidy up sample parsing overflow checking
		Change to a single overflow function
		Amend comment
	perf tools: add a function to calculate sample event size
		New patch
	perf tools: add a sample parsing test
		Amended to use sample event size calculation

Changes in V6:
	Some checkpatch fixes

	perf: make events stream always parsable
		Add sample format comments

Changes in V5:
	Re-based to Arnaldo's tree and dropped already applied patches:
		perf tools: remove unused parameter
		perf tools: fix missing tool parameter
		perf tools: fix missing 'finished_round'
		perf tools: fix parse_events_terms() segfault on error path
		perf tools: fix new_term() missing free on error path
		perf tools: add const specifier to perf_pmu__find name parameter
		perf tools: tidy duplicated munmap code
		perf tools: validate perf event header size

	perf tools: add debug prints
		Changed to perf_event_attr__fprintf()
	perf tools: add pid to struct thread
		Always set the pid, even if a pid is already set
	perf tools: change machine__findnew_thread() to set thread pid
		Replaces: perf tools: change "machine" functions to set thread pid
	perf tools: add support for PERF_SAMPLE_IDENTFIER
		Only use PERF_SAMPLE_IDENTFIER if sample types are different
	perf tools: expand perf_event__synthesize_sample()
		New patch in preparation of a sample parsing test
	perf tools: add a sample parsing test
		New patch

Changes in V4:
	I added kernel support for matching sample types via
	PERF_SAMPLE_IDENTIFIER.  perf tools support for that required
	first fixing some other things.

	perf tools: fix parse_events_terms() freeing local variable on error path
		Dropped - covered by David Ahern
	perf tools: struct thread has a tid not a pid
		Added ack by David Ahern
	perf tools: add pid to struct thread
		Remove unused function
	perf tools: fix missing increment in sample parsing
		New patch
	perf tools: tidy up sample parsing overflow checking
		New patch
	perf tools: remove unnecessary callchain validation
		New patch
	perf tools: remove references to struct ip_event
		New patch
	perf tools: move struct ip_event
		New patch
	perf: make events stream always parsable
		New patch
	perf tools: add support for PERF_SAMPLE_IDENTFIER
		New patch

Changes in V3:
	perf tools: add pid to struct thread
		Split into 2 patches
	perf tools: fix ppid in thread__fork()
		Dropped for now

Changes in V2:
	perf tools: fix missing tool parameter
		Fixed one extra occurrence
	perf tools: fix parse_events_terms() freeing local variable on error path
		Made "freeing" code into a new function
	perf tools: validate perf event header size
		Corrected byte-swapping
	perf tools: allow non-matching sample types
		Added comments
		Fixed id_pos calculation
		id_pos/is_pos updated whenever sample_type changes
		Removed perf_evlist__sample_type()
		Added __perf_evlist__combined_sample_type()
		Added perf_evlist__combined_sample_type()
		Added perf_evlist__make_sample_types_compatible()
	Added ack's to patches acked by Jiri Olsa


Adrian Hunter (14):
      perf tools: add debug prints
      perf tools: allow non-matching sample types
      perf tools: add pid to struct thread
      perf tools: change machine__findnew_thread() to set thread pid
      perf tools: tidy up sample parsing overflow checking
      perf tools: remove unnecessary callchain validation
      perf tools: remove references to struct ip_event
      perf tools: move struct ip_event
      perf: make events stream always parsable
      perf tools: move perf_evlist__config() to a new source file
      perf tools: add support for PERF_SAMPLE_IDENTFIER
      perf tools: expand perf_event__synthesize_sample()
      perf tools: add a function to calculate sample event size
      perf tools: add a sample parsing test

Peter Zijlstra (1):
      perf: Update perf_event_type documentation

 include/uapi/linux/perf_event.h   |  46 ++++-
 kernel/events/core.c              |  42 ++--
 tools/perf/Makefile               |   2 +
 tools/perf/builtin-inject.c       |   7 +-
 tools/perf/builtin-kmem.c         |   3 +-
 tools/perf/builtin-kvm.c          |   3 +-
 tools/perf/builtin-lock.c         |   3 +-
 tools/perf/builtin-mem.c          |   2 +-
 tools/perf/builtin-report.c       |   2 +-
 tools/perf/builtin-sched.c        |  17 +-
 tools/perf/builtin-script.c       |   3 +-
 tools/perf/builtin-top.c          |  11 +-
 tools/perf/builtin-trace.c        |  12 +-
 tools/perf/tests/builtin-test.c   |   4 +
 tools/perf/tests/hists_link.c     |  30 ++-
 tools/perf/tests/mmap-basic.c     |   2 +-
 tools/perf/tests/sample-parsing.c | 263 +++++++++++++++++++++++++
 tools/perf/tests/tests.h          |   1 +
 tools/perf/util/build-id.c        |  11 +-
 tools/perf/util/callchain.c       |   8 -
 tools/perf/util/callchain.h       |   5 -
 tools/perf/util/event.c           |   5 +-
 tools/perf/util/event.h           |  33 ++--
 tools/perf/util/evlist.c          | 146 ++++++++++++--
 tools/perf/util/evlist.h          |  10 +-
 tools/perf/util/evsel.c           | 404 +++++++++++++++++++++++++++++++++-----
 tools/perf/util/evsel.h           |  13 +-
 tools/perf/util/machine.c         |  37 ++--
 tools/perf/util/machine.h         |   3 +-
 tools/perf/util/python.c          |  20 ++
 tools/perf/util/record.c          | 111 +++++++++++
 tools/perf/util/session.c         |  36 +---
 tools/perf/util/thread.c          |   3 +-
 tools/perf/util/thread.h          |   3 +-
 34 files changed, 1109 insertions(+), 192 deletions(-)
 create mode 100644 tools/perf/tests/sample-parsing.c
 create mode 100644 tools/perf/util/record.c

Regards
Adrian
