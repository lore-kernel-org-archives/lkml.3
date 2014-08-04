Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251AbaHDQSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:18:03 -0400
Received: from mail.kernel.org ([198.145.19.201]:38658 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaHDQSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:18:01 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        kvm@vger.kernel.org, Mark Salter <msalter@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Minchan Kim <minchan@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Ilsche <thomas.ilsche@tu-dresden.de>,
        William Cohen <wcohen@redhat.com>,
        Yann Droneaud <ydroneaud@opteya.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/33] perf/core improvements and fixes
Date: Mon,  4 Aug 2014 13:17:11 -0300
Message-Id: <1407169064-25625-1-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Mostly fixes plus some refactoring work, more to come as I process
Adrian Hunter big patch set and other that missed this pull request.

	Please consider pulling,

- Arnaldo

The following changes since commit f9b9f812235d53f774a083e88a5a23b517a69752:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/core (2014-07-30 14:51:06 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo

for you to fetch changes up to 55b7e5fcf4782335c1ee5b4a2076697527c36407:

  perf tools: Default to python version 2 (2014-08-04 12:21:37 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

User visible:

. Show better error message in case we fail to open counters due to EBUSY error,
  for instance, when oprofile is running. (Jiri Olsa)

. Honour -w in the report tools (report, top), allowing to specify the widths
  for the histogram entries columns. (Namhyung Kim)

. Don't run workload if not told to, as happens when the user has no
  permission for profiling and even then the specified workload ends
  up running (Arnaldo Carvalho de Melo)

. Do not ignore mmap events in 'perf kmem report'. This tool was using
  the kernel mmaps in the running machine instead of processing the mmap
  records from the perf.data file. (Namhyung Kim)

. Properly show submicrosecond times in 'perf kvm stat' (Christian Borntraeger)

. Allow the user to disable time stamps in 'perf record' (Andi Kleen)

. Make sure --symfs usage includes the path separator (Arnaldo Carvalho de Melo)

Developer Stuff:

. Fix arm64 build error (Mark Salter)

. Fix make PYTHON override (Namhyung Kim)

. Rename ordered_samples to ordered_events and allow setting a queue
  size for ordering events (Jiri Olsa)

. Default to python version 2 (Thomas Ilsche)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Andi Kleen (1):
      perf record: Allow the user to disable time stamps

Arnaldo Carvalho de Melo (2):
      perf evlist: Don't run workload if not told to
      perf symbols: Make sure --symfs usage includes the path separator

Christian Borntraeger (1):
      perf kvm stat: Properly show submicrosecond times

Jiri Olsa (18):
      perf tools: Rename ordered_samples bool to ordered_events
      perf tools: Rename ordered_samples struct to ordered_events
      perf tools: Rename ordered_events members
      perf tools: Add ordered_events__(new|delete) interface
      perf tools: Factor ordered_events__flush to be more generic
      perf tools: Limit ordered events queue size
      perf tools: Flush ordered events in case of allocation failure
      perf tools: Make perf_session__deliver_event global
      perf tools: Create ordered-events object
      perf tools: Use list_move in ordered_events_delete function
      perf tools: Add ordered_events__init function
      perf tools: Add ordered_events__free function
      perf tools: Add perf_config_u64 function
      perf tools: Add report.queue-size config file option
      perf tools: Add debug prints for ordered events queue
      perf tools: Allow out of order messages in forced flush
      perf tools: Show better error message in case we fail to open counters due to EBUSY error
      perf tools: Fix PERF_FLAG_FD_CLOEXEC flag probing event type open counters due to EBUSY error

Mark Salter (1):
      perf tools: Fix arm64 build error

Namhyung Kim (9):
      perf kmem: Do not ignore mmap events
      perf tools: Fix make PYTHON override
      perf tools: Left-align output contents
      perf tools: Make __hpp__fmt() receive an additional len argument
      perf tools: Save column length in perf_hpp_fmt
      perf report: Honor column width setting
      perf top: Add -w option for setting column width
      perf tools: Add name field into perf_hpp_fmt
      perf tools: Fix column alignment when headers aren't shown on TUI

Thomas Ilsche (1):
      perf tools: Default to python version 2

 tools/perf/Documentation/perf-report.txt  |   2 +-
 tools/perf/Documentation/perf-top.txt     |   6 +
 tools/perf/Makefile.perf                  |   2 +
 tools/perf/arch/arm64/include/perf_regs.h |   2 +
 tools/perf/builtin-annotate.c             |   2 +-
 tools/perf/builtin-diff.c                 |   2 +-
 tools/perf/builtin-inject.c               |   2 +-
 tools/perf/builtin-kmem.c                 |   7 +-
 tools/perf/builtin-kvm.c                  |  16 +-
 tools/perf/builtin-lock.c                 |   2 +-
 tools/perf/builtin-mem.c                  |   2 +-
 tools/perf/builtin-record.c               |   1 +
 tools/perf/builtin-report.c               |  15 +-
 tools/perf/builtin-sched.c                |   2 +-
 tools/perf/builtin-script.c               |   2 +-
 tools/perf/builtin-timechart.c            |   2 +-
 tools/perf/builtin-top.c                  |   3 +
 tools/perf/builtin-trace.c                |   2 +-
 tools/perf/config/Makefile                |  40 +++--
 tools/perf/config/feature-checks/Makefile |  18 +-
 tools/perf/ui/browsers/hists.c            |  31 ++--
 tools/perf/ui/gtk/hists.c                 |  18 +-
 tools/perf/ui/hist.c                      | 280 ++++++++++++++++++------------
 tools/perf/ui/stdio/hist.c                |   4 +-
 tools/perf/util/annotate.c                |   9 +-
 tools/perf/util/cache.h                   |   1 +
 tools/perf/util/cloexec.c                 |   6 +-
 tools/perf/util/color.c                   |  16 ++
 tools/perf/util/color.h                   |   1 +
 tools/perf/util/config.c                  |  24 +++
 tools/perf/util/debug.c                   |  36 +++-
 tools/perf/util/debug.h                   |   8 +
 tools/perf/util/dso.c                     |  28 ++-
 tools/perf/util/evlist.c                  |  20 ++-
 tools/perf/util/evsel.c                   |  15 +-
 tools/perf/util/hist.h                    |  17 +-
 tools/perf/util/ordered-events.c          | 245 ++++++++++++++++++++++++++
 tools/perf/util/ordered-events.h          |  51 ++++++
 tools/perf/util/session.c                 | 219 +++++------------------
 tools/perf/util/session.h                 |  25 +--
 tools/perf/util/sort.c                    |  58 ++++---
 tools/perf/util/symbol.c                  |   3 +-
 tools/perf/util/symbol.h                  |   9 +
 tools/perf/util/tool.h                    |   2 +-
 tools/perf/util/util.c                    |  36 ++++
 tools/perf/util/util.h                    |  17 ++
 46 files changed, 869 insertions(+), 440 deletions(-)
 create mode 100644 tools/perf/util/ordered-events.c
 create mode 100644 tools/perf/util/ordered-events.h
