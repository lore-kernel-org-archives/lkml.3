Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab3H0IRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:17:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:14789 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305Ab3H0IRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:17:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,966,1367996400"; 
   d="scan'208";a="352104835"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V13 00/12] perf tools: some fixes and tweaks
Date: Tue, 27 Aug 2013 11:23:02 +0300
Message-Id: <1377591794-30553-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here are some fixes and tweaks to perf tools (version 13).

Changes in V13:
	perf tools: allow non-matching sample types
		Moved to be the last patch
	perf tools: add pid to struct thread
		Dropped since its been applied
	perf tools: add support for PERF_SAMPLE_IDENTFIER
		Subsumed most of 'perf tools: allow non-matching sample types'

Changes in V12:
	perf tools: re-implement debug print function for linking python/perf.so
		Dropped since its been applied
	perf tools: add debug prints
		Dropped since its been applied
	perf tools: allow non-matching sample types
		Do not call perf_evlist__set_id_pos() when adding events other than the first
		Do not use matching_sample_types
	perf: make events stream always parsable
		Added Peter's missing Ack
		Added Stephane's Tested-by
	perf tools: add missing 'abi' member to 'struct regs_dump'
		Added Jiri's Ack

Changes in V11:
	perf tools: re-implement debug print function for linking python/perf.so
		New patch split from "perf tools: add debug prints"
	perf tools: add debug prints
		Changed to use graph_dotted_line
		Moved python/link changes to separate patch
		Added Namhyung's Ack
	perf tools: change machine__findnew_thread() to set thread pid
		Added explanation of main thread lookup to commit message
	perf tools: tidy up sample parsing overflow checking
		Added Jiri's Ack
	perf tools: remove unnecessary callchain validation
		Added Namhyung's Ack
	perf tools: remove references to struct ip_event
		Added Namhyung's Ack
	perf tools: move perf_evlist__config() to a new source file
		Added Namhyung's Ack
	perf tools: add missing 'abi' member to 'struct regs_dump'
		New patch
	perf tools: expand perf_event__synthesize_sample()
		Adjusted for new 'abi' member of 'struct regs_dump'
	perf tools: add a function to calculate sample event size
		Adjusted for new 'abi' member of 'struct regs_dump'
	perf tools: add a sample parsing test
		Adjusted for new 'abi' member of 'struct regs_dump'

Changes in V10:
	Re-based on:
		perf/core branch of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git
		commit 207353be1574027c151609a31167ac5919a056c8: perf tools: Remove filter parameter of thread__find_addr_map()

	perf tools: add debug prints
		Changed to use macros
	perf tools: add pid to struct thread
		Added David's Ack
	perf tools: change machine__findnew_thread() to set thread pid
		Added David's Ack
	perf tools: remove references to struct ip_event
		Also remove from hists_link.c
	perf tools: move struct ip_event
		Dropped since it is covered by "perf tools: remove references to struct ip_event"
	perf tools: add a sample parsing test
		Fix missing sample comparison for PERF_SAMPLE_READ

Changes in V9:
	perf: Update perf_event_type documentation
		Dropped since its been applied
	perf tools: tidy up sample parsing overflow checking
		Changed to use a single overflow function
		Updated for PERF_SAMPLE_READ
	perf: make events stream always parsable
		Added more about sample parsing to the commit message
	perf tools: add support for PERF_SAMPLE_IDENTFIER
		When selecting PERF_SAMPLE_IDENTFIER, ensure PERF_SAMPLE_ID
		is deselected
	perf tools: expand perf_event__synthesize_sample()
		Updated for PERF_SAMPLE_READ
	perf tools: add a function to calculate sample event size
		Updated for PERF_SAMPLE_READ
	perf tools: add a sample parsing test
		Updated for PERF_SAMPLE_READ

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


Adrian Hunter (12):
      perf tools: change machine__findnew_thread() to set thread pid
      perf tools: tidy up sample parsing overflow checking
      perf tools: remove unnecessary callchain validation
      perf tools: remove references to struct ip_event
      perf: make events stream always parsable
      perf tools: move perf_evlist__config() to a new source file
      perf tools: add support for PERF_SAMPLE_IDENTFIER
      perf tools: add missing 'abi' member to 'struct regs_dump'
      perf tools: expand perf_event__synthesize_sample()
      perf tools: add a function to calculate sample event size
      perf tools: add a sample parsing test
      perf tools: allow non-matching sample types

 include/uapi/linux/perf_event.h   |  27 ++-
 kernel/events/core.c              |  11 +-
 tools/perf/Makefile               |   2 +
 tools/perf/builtin-inject.c       |   8 +-
 tools/perf/builtin-kmem.c         |   3 +-
 tools/perf/builtin-kvm.c          |   2 +-
 tools/perf/builtin-lock.c         |   3 +-
 tools/perf/builtin-mem.c          |   2 +-
 tools/perf/builtin-report.c       |   2 +-
 tools/perf/builtin-sched.c        |  20 +-
 tools/perf/builtin-script.c       |   3 +-
 tools/perf/builtin-top.c          |  11 +-
 tools/perf/builtin-trace.c        |  10 +-
 tools/perf/tests/builtin-test.c   |   4 +
 tools/perf/tests/code-reading.c   |   4 +-
 tools/perf/tests/hists_link.c     |  23 +--
 tools/perf/tests/mmap-basic.c     |   2 +-
 tools/perf/tests/sample-parsing.c | 316 +++++++++++++++++++++++++++++
 tools/perf/tests/tests.h          |   1 +
 tools/perf/util/build-id.c        |  11 +-
 tools/perf/util/callchain.c       |   8 -
 tools/perf/util/callchain.h       |   5 -
 tools/perf/util/event.c           |   5 +-
 tools/perf/util/event.h           |  34 ++--
 tools/perf/util/evlist.c          | 142 ++++++++++---
 tools/perf/util/evlist.h          |   9 +-
 tools/perf/util/evsel.c           | 405 +++++++++++++++++++++++++++++++++-----
 tools/perf/util/evsel.h           |  14 +-
 tools/perf/util/machine.c         |  22 ++-
 tools/perf/util/machine.h         |   3 +-
 tools/perf/util/record.c          | 111 +++++++++++
 tools/perf/util/session.c         |  32 +--
 32 files changed, 1066 insertions(+), 189 deletions(-)
 create mode 100644 tools/perf/tests/sample-parsing.c
 create mode 100644 tools/perf/util/record.c


Regards
Adrian

