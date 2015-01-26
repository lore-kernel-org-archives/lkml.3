Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144AbbAZRri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:47:38 -0500
Received: from mail.kernel.org ([198.145.29.136]:52581 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334AbbAZRre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:47:34 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Haren Myneni <hbabu@us.ibm.com>, Jiri Olsa <jolsa@redhat.com>,
        Joe Mario <jmario@redhat.com>, Kan Liang <kan.liang@intel.com>,
        linuxppc-dev@lists.ozlabs.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Michael Ellerman <mpe@ellerman.id.au>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Richard Fowles <rfowles@redhat.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/26] perf/core improvements and fixes
Date: Mon, 26 Jan 2015 14:47:03 -0300
Message-Id: <1422294449-12735-1-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling, it has my latest perf/urgent pull content,
please let me know if you don't want it to be submitted like that, i.e. if
you have any problems with my latest perf/urgent pull request and I'll try
to address it ASAP.

- Arnaldo

The following changes since commit 25dd9171f51c482eb7c4dc8618766ae733756e2d:

  perf probe: Fix probing kretprobes (2015-01-21 10:06:24 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo

for you to fetch changes up to 3d199b5be53348bef84883013c484b414adf0a2e:

  tools lib traceevent: Add support for IP address formats (2015-01-26 12:04:41 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

User visible:

- Enable sampling loads and stores simultaneously in 'perf mem' (Stephane Eranian)

- 'perf diff' output improvements (Namhyung Kim)

- Fix error reporting for evsel pgfault constructor (Arnaldo Carvalho de Melo)

Infrastructure:

- Move debugfs sterrno like method to tools/lib/ so that it may be used by
  other tools, as 'perf probe' will be soon (Arnaldo Carvalho de Melo)

- Introduce function fro deleting/removing hist_entry to avoid code duplication
  (Arnaldo Carvalho de Melo)

- Support parsing parameterized events (Cody P Schafer)

- Add support for IP address formats in libtraceevent (David Ahern)

- Fix typo in sample-parsing.c 'perf test' entry (Rasmus Villemoes)

- Remove some unused functions from color.c (Rickard Strandqvist)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (9):
      perf mem: Move the mem_operations global to struct perf_mem
      perf tools: Remove EOL whitespaces
      perf hists: Rename hist_entry__free to __delete
      perf hists: Introduce function for deleting/removing hist_entry
      tools lib fs: Adopt debugfs open strerrno method
      tools lib fs: Pass filename to debugfs__strerror_open
      perf trace: Fix error reporting for evsel pgfault constructor
      tools lib fs debugfs: Introduce debugfs__strerror_open_tp
      tools lib fs debugfs: Check if debugfs is mounted when handling ENOENT

Cody P Schafer (4):
      perf tools: Support parsing parameterized events
      perf tools: Extend format_alias() to include event parameters
      perf Documentation: Add event parameters
      perf tools: Document parameterized and symbolic events

David Ahern (1):
      tools lib traceevent: Add support for IP address formats

Namhyung Kim (9):
      perf report: Get rid of report__inc_stat()
      perf tools: Allow use of an exclusive option more than once
      perf diff: Get rid of hists__compute_resort()
      perf diff: Print diff result more precisely
      perf diff: Introduce fmt_to_data_file() helper
      perf tools: Pass struct perf_hpp_fmt to its callbacks
      perf diff: Fix output ordering to honor next column
      perf diff: Fix -o/--order option behavior
      perf ui/tui: Show fatal error message only if exists

Rasmus Villemoes (1):
      perf tests: Fix typo in sample-parsing.c

Rickard Strandqvist (1):
      perf tools: Remove some unused functions from color.c

Stephane Eranian (1):
      perf mem: Enable sampling loads and stores simultaneously

 .../testing/sysfs-bus-event_source-devices-events  |   6 +
 tools/lib/api/fs/debugfs.c                         |  43 +++
 tools/lib/api/fs/debugfs.h                         |   3 +
 tools/lib/traceevent/event-parse.c                 | 328 +++++++++++++++++++++
 tools/perf/Documentation/perf-buildid-cache.txt    |   2 +-
 tools/perf/Documentation/perf-list.txt             |  13 +
 tools/perf/Documentation/perf-mem.txt              |   9 +-
 tools/perf/Documentation/perf-record.txt           |  12 +
 tools/perf/Documentation/perf-script.txt           |  28 +-
 tools/perf/Documentation/perf-stat.txt             |  20 +-
 tools/perf/builtin-buildid-cache.c                 |   4 +-
 tools/perf/builtin-diff.c                          | 248 ++++++++++------
 tools/perf/builtin-mem.c                           | 131 ++++++--
 tools/perf/builtin-report.c                        |  16 +-
 tools/perf/builtin-stat.c                          |   2 +-
 tools/perf/builtin-top.c                           |   2 +-
 tools/perf/builtin-trace.c                         | 106 ++++---
 tools/perf/tests/attr.py                           |   1 -
 tools/perf/tests/hists_cumulate.c                  |   2 +-
 tools/perf/tests/hists_output.c                    |   2 +-
 tools/perf/tests/make                              |   1 -
 tools/perf/tests/parse-events.c                    |   2 +-
 tools/perf/tests/sample-parsing.c                  |   2 +-
 tools/perf/ui/browsers/annotate.c                  |   3 +-
 tools/perf/ui/hist.c                               |  12 +-
 tools/perf/ui/progress.h                           |   4 +-
 tools/perf/ui/tui/helpline.c                       |   3 +
 tools/perf/ui/tui/setup.c                          |   3 +-
 tools/perf/util/annotate.c                         |   2 +-
 tools/perf/util/color.c                            | 126 --------
 tools/perf/util/color.h                            |   2 -
 tools/perf/util/evlist.c                           |  27 --
 tools/perf/util/evlist.h                           |   1 -
 tools/perf/util/hist.c                             |  48 ++-
 tools/perf/util/hist.h                             |  11 +-
 tools/perf/util/parse-events.c                     |   6 +-
 tools/perf/util/parse-events.h                     |   1 +
 tools/perf/util/parse-options.c                    |   2 +-
 tools/perf/util/pmu.c                              | 102 ++++++-
 tools/perf/util/python.c                           |   2 +-
 .../util/scripting-engines/trace-event-python.c    |   2 +-
 tools/perf/util/session.c                          |   2 +-
 tools/perf/util/sort.c                             |  37 ++-
 tools/perf/util/symbol.c                           |   2 +-
 44 files changed, 950 insertions(+), 431 deletions(-)
