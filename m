Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab3JVObH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:31:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53935 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab3JVO27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:28:59 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Scott J Norton <scott.norton@hp.com>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Waiman Long <Waiman.Long@hp.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/26] perf/core improvements and fixes
Date: Tue, 22 Oct 2013 11:28:08 -0300
Message-Id: <1382452114-1243-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 1ff9ecf797e398b9937d9da4c2236f4140b96339:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2013-10-15 11:55:46 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 5dbb6e81d85e55ee2b4cf523c1738e16f63e5400:

  perf top: Add --max-stack option to limit callchain stack scan (2013-10-21 17:36:25 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

. Convert callchain children list to rbtree, greatly reducing the time
  taken for callchain processing, from Namhyung Kim.

. Add --max-stack option to limit callchain stack scan in 'top' and 'report',
  improving callchain processing when reducing the stack depth is an option,
  from Waiman Long.

. Compare dso's also when comparing symbols, to avoid grouping together
  symbols with the same name but on different DSOs, fix from Namhyung Kim.

. 'perf trace' now can can use a 'perf probe' wannabe tracepoint to hook into
  the userspace -> kernel pathname copy so that it can map fds to pathnames
  without reading /proc/pid/fd/ symlinks.

. 'perf trace' now emits hints as to why tracing is not possible, helping the
  user to setup the system to allow tracing in the desired permission
  granularity, telling if the problem is due to debugfs not being mounted or
  with not enough permission for !root, /proc/sys/kernel/perf_event_paranoit
  value, etc.

. Add missing 'mmap2' in evsel debug print, from Adrian Hunter.

. Add missing decrement in id sample parsing, not a fix per se, just to
  avoid a problem whem somebody adds another field, from Adrian Hunter.

. Improve write_output error message in 'perf record', from Adrian Hunter.

. Add missing sample flush for piped events, fix from Adrian Hunter.

. Add missing members to perf_event__attr_swap(), fix from Adrian Hunter.

. Assorted fixes for 32-bit build, from Adrian Hunter

. Print addr by default for BTS in 'perf script', from Adrian Juntmer

. Separating data file properties from session, code reorganization from
  Jiri Olsa.

. Show error in 'perf list' if tracepoints not available, from Pekka Enberg.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Adrian Hunter (11):
      perf evsel: Add missing 'mmap2' from debug print
      perf evsel: Add missing decrement in id sample parsing
      perf record: Improve write_output error message
      perf session: Add missing sample flush for piped events
      perf session: Add missing members to perf_event__attr_swap()
      perf evlist: Fix 32-bit build error
      perf tools: Fix test_on_exit for 32-bit build
      perf tools: Fix bench/numa.c for 32-bit build
      perf evlist: Fix perf_evlist__mmap comments
      perf evlist: Factor out duplicated mmap code
      perf script: Print addr by default for BTS

Arnaldo Carvalho de Melo (7):
      perf scripting perl: Fix build error on Fedora 12
      perf trace: Split fd -> pathname array handling
      perf trace: Use vfs_getname hook if available
      perf trace: Improve event processing exit
      perf evlist: Introduce perf_evlist__strerror_tp method
      perf tools: Introduce filename__read_int helper
      perf trace: Improve messages related to /proc/sys/kernel/perf_event_paranoid

Jiri Olsa (3):
      perf tools: Add data object to handle perf data file
      perf tools: Add perf_data_file__open interface to data object
      perf session: Separating data file properties from session

Namhyung Kim (2):
      perf callchain: Convert children list to rbtree
      perf tools: Compare dso's also when comparing symbols

Pekka Enberg (1):
      perf list: Show error if tracepoints not available

Waiman Long (2):
      perf report: Add --max-stack option to limit callchain stack scan
      perf top: Add --max-stack option to limit callchain stack scan

 tools/perf/Documentation/perf-report.txt           |   8 +
 tools/perf/Documentation/perf-top.txt              |   8 +
 tools/perf/Documentation/perf-trace.txt            |   4 +
 tools/perf/Makefile.perf                           |   1 +
 tools/perf/bench/numa.c                            |   4 +-
 tools/perf/builtin-annotate.c                      |  11 +-
 tools/perf/builtin-buildid-cache.c                 |   8 +-
 tools/perf/builtin-buildid-list.c                  |  11 +-
 tools/perf/builtin-diff.c                          |  19 +-
 tools/perf/builtin-evlist.c                        |   7 +-
 tools/perf/builtin-inject.c                        |   7 +-
 tools/perf/builtin-kmem.c                          |   7 +-
 tools/perf/builtin-kvm.c                           |  13 +-
 tools/perf/builtin-lock.c                          |   7 +-
 tools/perf/builtin-mem.c                           |   9 +-
 tools/perf/builtin-record.c                        |  80 +++------
 tools/perf/builtin-report.c                        |  40 +++--
 tools/perf/builtin-sched.c                         |   6 +-
 tools/perf/builtin-script.c                        |  21 ++-
 tools/perf/builtin-timechart.c                     |  10 +-
 tools/perf/builtin-top.c                           |  16 +-
 tools/perf/builtin-trace.c                         | 196 +++++++++++++--------
 tools/perf/config/feature-checks/test-on-exit.c    |   1 +
 tools/perf/perf.h                                  |   1 -
 tools/perf/util/callchain.c                        | 147 ++++++++++++----
 tools/perf/util/callchain.h                        |  11 +-
 tools/perf/util/data.c                             | 120 +++++++++++++
 tools/perf/util/data.h                             |  48 +++++
 tools/perf/util/evlist.c                           | 159 +++++++++++------
 tools/perf/util/evlist.h                           |   3 +
 tools/perf/util/evsel.c                            |   2 +
 tools/perf/util/header.c                           |  22 ++-
 tools/perf/util/machine.c                          |  14 +-
 tools/perf/util/machine.h                          |   3 +-
 tools/perf/util/parse-events.c                     |   4 +-
 .../perf/util/scripting-engines/trace-event-perl.c |   2 +-
 tools/perf/util/session.c                          | 139 ++++++---------
 tools/perf/util/session.h                          |  11 +-
 tools/perf/util/sort.c                             |  10 ++
 tools/perf/util/top.h                              |   1 +
 tools/perf/util/util.c                             |  17 ++
 tools/perf/util/util.h                             |   2 +
 42 files changed, 834 insertions(+), 376 deletions(-)
 create mode 100644 tools/perf/util/data.c
 create mode 100644 tools/perf/util/data.h
