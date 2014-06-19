Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965356AbaFSVOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:14:08 -0400
Received: from mail.kernel.org ([198.145.19.201]:34056 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965188AbaFSVOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:14:06 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/11] perf/core improvements and fixes
Date: Thu, 19 Jun 2014 18:13:42 -0300
Message-Id: <1403212433-2714-1-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please conseider pulling,

- Arnaldo

The following changes since commit a10d60c08cc3bbea9195e2b36440f557373623eb:

  sh, perf: Use common PMU interrupt disabled code (2014-06-19 19:37:51 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo

for you to fetch changes up to ecdac96899e3db3f428e4d2e978f25e3f8d35a6c:

  perf bench sched-messaging: Drop barf() (2014-06-19 16:13:17 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

User visible:

. Add --repeat global option to 'perf bench' to be used in benchmarks
  such as the existing 'futex' one, that was modified to use it instead
  of a local option. (Davidlohr Bueso)

. Fix fd -> pathname resolution in 'trace', be it using /proc or
  a vfs_getname probe point. (Arnaldo Carvalho de Melo)

. Add suggestion of how to set perf_event_paranoid sysctl, to help
  non-root users trying tools like 'trace' to get a working environment.
  (Arnaldo Carvalho de Melo)

Fixes:

. Fix memory leak in the 'sched-messaging' perf bench test. (Davidlohr Bueso)

. The -o and -n 'perf bench mem' options are mutually exclusive, emit error
  when both are specified. (Davidlohr Bueso)

. Fix scrollbar refresh row index in the ui browser, problem exposed now
  that headers will be added and will be allowed to be switched on/off.
  (Jiri Olsa)

Cleanups:

. Remove needless reassignments in 'trace' (Arnaldo Carvalho de Melo)

. Cache the is_exit syscall test in 'trace) (Arnaldo Carvalho de Melo)

. No need to reimplement err() in 'perf bench sched-messaging', drop barf().
  (Davidlohr Bueso).

. Remove ev_name argument from perf_evsel__hists_browse, can be obtained
  from the other parameters. (Jiri Olsa)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (4):
      perf trace: Fix up fd -> pathname resolution
      perf evlist: Add suggestion of how to set perf_event_paranoid sysctl
      perf trace: Remove needless reassignments
      perf trace: Cache the is_exit syscall test

Davidlohr Bueso (5):
      perf bench sched-messaging: Plug memleak
      perf bench: Add --repeat option
      perf bench futex: Use global --repeat option
      perf bench mem: The -o and -n options are mutually exclusive
      perf bench sched-messaging: Drop barf()

Jiri Olsa (2):
      perf hists browser: Remove ev_name argument from perf_evsel__hists_browse
      perf ui browser: Fix scrollbar refresh row index

 tools/perf/Documentation/perf-bench.txt |  4 +++
 tools/perf/bench/bench.h                |  1 +
 tools/perf/bench/futex-requeue.c        | 10 +------
 tools/perf/bench/futex-wake.c           | 12 ++-------
 tools/perf/bench/mem-memcpy.c           |  5 ++++
 tools/perf/bench/mem-memset.c           |  5 ++++
 tools/perf/bench/sched-messaging.c      | 47 +++++++++++++++------------------
 tools/perf/builtin-bench.c              |  7 +++++
 tools/perf/builtin-trace.c              | 12 ++++-----
 tools/perf/ui/browser.c                 |  2 +-
 tools/perf/ui/browsers/hists.c          | 25 ++++++++----------
 tools/perf/util/evlist.c                |  5 ++--
 12 files changed, 67 insertions(+), 68 deletions(-)
