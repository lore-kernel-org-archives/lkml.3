Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539AbaHVQ3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:29:42 -0400
Received: from mail.kernel.org ([198.145.19.201]:33586 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932293AbaHVQ3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:29:41 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Joe Mario <jmario@redhat.com>, Michael Ellerman <michaele@au1.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/16] perf/core improvements and fixes
Date: Fri, 22 Aug 2014 13:29:12 -0300
Message-Id: <1408724968-3441-1-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit af924aa35129edf338ebc8da6a4eae08cf7cb297:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2014-08-18 10:14:43 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo

for you to fetch changes up to 141da74d2eff8de134c5a5ffaf2800a8a1b27517:

  perf hists browser: Consolidate callchain print functions in TUI (2014-08-22 13:12:15 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

User visible:

o Don't try to find DSOs in SYSV maps (Don Zickus)

o Fallback to MAP__FUNCTION if daddr maps are NULL,
  i.e. addresses get looked upon more maps (Don Zickus)

o Kernel fix to properly handle exited tasks, by returning POLLHUP values
  on perf event file descriptors. Tooling changes will come next, but were
  tested with this kernel fix. (Jiri Olsa)

o Add +field argument support for --field option, so that one can add
  fields to the default list of fields to show, i.e. now one can just do:

   perf report --fields +pid

  And the pid will appear in addition to the default fields. (Jiri Olsa)

Developer stuff:

o More Intel PT prep stuff, including:
  - Add a 'perf test' for tracking with sched_switch
  - Add 'flush' callback to scripting API

o hists browser (used in top and report) refactorings, getting rid of unused
  variables and reducing source code size by handling similar cases in a
  fewer functions (Namhyung Kim).

o Explicitly include util/debug.h for powerpc, was being indirectly included,
  broke the build when some change made it stop being included. (Sukadev
  Bhattiprolu)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Adrian Hunter (4):
      perf tests: Add a test for tracking with sched_switch
      perf scripting: Add 'flush' callback to scripting API
      perf machine: Rename machine__get_kernel_start_addr() method
      perf tools: Add machine__kernel_ip()

Don Zickus (2):
      perf symbols: Don't try to find DSOs in SYSV maps
      perf machine: Fallback to MAP__FUNCTION if daddr maps are NULL

Jiri Olsa (4):
      perf: Fix perf_poll to return proper POLLHUP value
      perf: Add PERF_EVENT_STATE_EXIT state for events with exited task
      perf top: Use set_term_quiet() instead of open coded equivalent
      perf tools: Add +field argument support for --field option

Namhyung Kim (5):
      perf hists browser: Get rid of unused 'remaining' variable
      perf hists browser: Fix children overhead dump
      perf hists browser: Factor out hist_browser__show_callchain_entry()
      perf hists browser: Cleanup callchain print functions
      perf hists browser: Consolidate callchain print functions in TUI

Sukadev Bhattiprolu (1):
      perf tools powerpc: Explicitly include util/debug.h

 include/linux/perf_event.h                         |   1 +
 kernel/events/core.c                               |  12 +-
 tools/perf/Makefile.perf                           |   1 +
 tools/perf/arch/powerpc/util/skip-callchain-idx.c  |   1 +
 tools/perf/builtin-script.c                        |  13 +
 tools/perf/builtin-top.c                           |   9 +-
 tools/perf/tests/builtin-test.c                    |   4 +
 tools/perf/tests/switch-tracking.c                 | 572 +++++++++++++++++++++
 tools/perf/tests/tests.h                           |   1 +
 tools/perf/ui/browsers/hists.c                     | 343 +++++-------
 tools/perf/ui/hist.c                               |   6 +-
 tools/perf/util/event.c                            |   6 +-
 tools/perf/util/machine.c                          |  41 +-
 tools/perf/util/machine.h                          |  17 +
 tools/perf/util/map.c                              |   1 +
 .../perf/util/scripting-engines/trace-event-perl.c |   6 +
 .../util/scripting-engines/trace-event-python.c    |   6 +
 tools/perf/util/sort.c                             |  24 +-
 tools/perf/util/sort.h                             |   1 +
 tools/perf/util/trace-event-scripting.c            |   7 +
 tools/perf/util/trace-event.h                      |   1 +
 21 files changed, 827 insertions(+), 246 deletions(-)
 create mode 100644 tools/perf/tests/switch-tracking.c
