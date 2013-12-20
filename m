Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab3LTTKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:10:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38570 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab3LTTJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:09:38 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>, Arun Sharma <asharma@fb.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/35] perf/core improvements and fixes
Date: Fri, 20 Dec 2013 16:08:35 -0300
Message-Id: <1387566550-3524-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Hi Ingo,

	Please consider pulling,

Best regards,

- Arnaldo

The following changes since commit fa6e8e5f7cbf85f364ebd5a90525dbbe9de2083b:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2013-12-18 14:07:26 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to a419e512731892c3e7e661cd96e7f7d6a7acdc91:

  perf stat: Do not show stats if workload fails (2013-12-20 13:37:50 -0300)

----------------------------------------------------------------
User visible changes:

Improvements:

. Do not show stats if workload fails in 'stat' (David Ahern)

. Print session information only if --stdio is given (Namhyung Kim)

Developer stuff:

Fixes:

. Get rid of a duplicate va_end() in error reporting (Namhyung Kim)

. If a hist entry doesn't have symbol information, compare it with its
  address. Affects upcoming new feature (--cumulate) (Namhyung Kim)

Improvements:

. Make libtraceevent install target quieter (Jiri Olsa)

. Make tests/make output more compact (Jiri Olsa)

New APIs:

. Introduce pevent_filter_strerror() in libtraceevent, similar in
  purpose to libc's strerror() function. (Namhyung Kim)

Refactorings:

. Use perf_data_file methods to write output file in 'record' and
  'inject' (Jiri Olsa)

. Use pr_*() functions where applicable in 'report' (Namhyumg Kim)

. Add 'machine' 'addr_location' struct to have full picture (machine,
  thread, map, symbol, addr) for a (partially) resolved address, reducing
  function signatures (Arnaldo Carvalho de Melo)

. Reduce code duplication in the histogram entry creation/insertion. (Arnaldo Carvalho de Melo)

. Auto allocate annotation histogram data structures, (Arnaldo Carvalho de Melo)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (16):
      perf annotate: Auto allocate symbol per addr hist buckets
      perf hists: Leave symbol addr hist bucket auto alloc to symbol layer
      perf annotate: Add inc_samples method to addr_map_symbol
      perf top: Use hist_entry__inc_addr_sample
      perf annotate: Adopt methods from hists
      perf annotate: Make symbol__inc_addr_samples private
      perf report: Introduce helpers for processing callchains
      perf record: Simplify perf_record__write
      perf record: Rename 'perf_record' to plain 'record'
      perf tools: Rename 'perf_record_opts' to 'record_opts
      perf report: Rename 'perf_report' to 'report'
      perf ui browser: Remove misplaced __maybe_unused
      perf scripting python: Shorten function signatures
      perf scripting perl: Shorten function signatures
      perf mem: Remove unused parameter from dump_raw_samples()
      perf symbols: Add 'machine' member to struct addr_location

David Ahern (1):
      perf stat: Do not show stats if workload fails

Jiri Olsa (11):
      perf inject: Handle output file via perf_data_file object
      perf record: Use perf_data_file__write for output file
      perf tests: Factor make install tests
      perf tools: Making QUIET_(CLEAN|INSTAL) variables global
      tools lib traceevent: Remove print_app_build variable
      tools lib traceevent: Use global QUIET_CC build output
      tools lib traceevent: Add global QUIET_CC_FPIC build output
      tools lib traceevent: Use global QUIET_LINK build output
      tools lib traceevent: Use global QUIET_INSTALL build output
      tools lib traceevent: Use global QUIET_CLEAN build output
      tools lib traceevent: Use global 'O' processing code

Namhyung Kim (7):
      perf sort: Compare addresses if no symbol info
      perf sort: Do not compare dso again
      perf hists: Do not pass period and weight to add_hist_entry()
      tools lib traceevent: Introduce pevent_filter_strerror()
      perf tools: Get rid of a duplicate va_end() in error reporting routine
      perf report: Use pr_*() functions where applicable
      perf report: Print session information only if --stdio is given

 tools/lib/traceevent/Makefile                      |  85 +++----
 tools/lib/traceevent/event-parse.c                 |  17 +-
 tools/lib/traceevent/event-parse.h                 |   7 +-
 tools/lib/traceevent/parse-filter.c                |  98 ++++----
 tools/perf/builtin-annotate.c                      |  10 +-
 tools/perf/builtin-inject.c                        |  65 +++---
 tools/perf/builtin-kvm.c                           |   2 +-
 tools/perf/builtin-mem.c                           |   5 +-
 tools/perf/builtin-record.c                        |  94 ++++----
 tools/perf/builtin-report.c                        | 259 +++++++--------------
 tools/perf/builtin-script.c                        |  16 +-
 tools/perf/builtin-stat.c                          |  11 +-
 tools/perf/builtin-top.c                           |  23 +-
 tools/perf/builtin-trace.c                         |   2 +-
 tools/perf/config/utilities.mak                    |   7 -
 tools/perf/perf.h                                  |   2 +-
 tools/perf/tests/code-reading.c                    |   2 +-
 tools/perf/tests/keep-tracking.c                   |   2 +-
 tools/perf/tests/make                              |  38 ++-
 tools/perf/tests/open-syscall-tp-fields.c          |   2 +-
 tools/perf/tests/perf-record.c                     |   2 +-
 tools/perf/tests/perf-time-to-tsc.c                |   2 +-
 tools/perf/ui/browser.c                            |   2 +-
 tools/perf/util/annotate.c                         |  41 +++-
 tools/perf/util/annotate.h                         |   9 +-
 tools/perf/util/callchain.h                        |   2 +-
 tools/perf/util/debug.c                            |   1 -
 tools/perf/util/event.c                            |   1 +
 tools/perf/util/evlist.h                           |   7 +-
 tools/perf/util/evsel.c                            |   3 +-
 tools/perf/util/evsel.h                            |   4 +-
 tools/perf/util/hist.c                             |  21 +-
 tools/perf/util/hist.h                             |   3 -
 tools/perf/util/record.c                           |   9 +-
 .../perf/util/scripting-engines/trace-event-perl.c |  19 +-
 .../util/scripting-engines/trace-event-python.c    |  25 +-
 tools/perf/util/session.c                          |   4 +-
 tools/perf/util/session.h                          |   2 +-
 tools/perf/util/sort.c                             |  22 +-
 tools/perf/util/symbol.h                           |   1 +
 tools/perf/util/top.c                              |   2 +-
 tools/perf/util/top.h                              |   2 +-
 tools/perf/util/trace-event-scripting.c            |   3 +-
 tools/perf/util/trace-event.h                      |   1 -
 tools/scripts/Makefile.include                     |   4 +
 45 files changed, 415 insertions(+), 524 deletions(-)
