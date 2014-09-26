Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbaIZUT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:19:58 -0400
Received: from mail.kernel.org ([198.145.19.201]:52620 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205AbaIZUT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:19:57 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Milian Wolff <mail@milianw.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>,
        Pranith Kumar <bobby.prani@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Taeung Song <treeze.taeung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/10] perf/core improvements and fixes
Date: Fri, 26 Sep 2014 17:19:37 -0300
Message-Id: <1411762787-26113-1-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling.

- Arnaldo

The following changes since commit cf8102f64c8d23f0bd4af0659bbd94d0c1d8d1c7:

  Merge tag 'perf-fdarray-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2014-09-26 11:12:46 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo

for you to fetch changes up to 49757c9cc7887bc79f742eb8aacf16e464ca5f0b:

  perf tools: Fix line number in the config file error message (2014-09-26 12:45:23 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

User visible:

o Restore "--callchain graph" output, broken in recent cset to end
  up being the same as "fractal" (Namhyung Kim)

o Allow profiling when kptr_restrict == 1 for non root users,
  kernel samples will just remain unresolved (Andi Kleen)

o Allow configuring default options for callchains in config file (Namhyung Kim)

o Fix line number in the config file error message (Jiri Olsa)

o Fix --per-core on multi socket systems (Andi Kleen)

Cleanups:

o Use ACCESS_ONCE() instead of volatile cast. (Pranith Kumar)

o Modify error code for when perf_session__new() fails (Taeung Song)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Andi Kleen (2):
      perf stat: Fix --per-core on multi socket systems
      perf tools: Fix perf record as non root with kptr_restrict == 1

Jiri Olsa (1):
      perf tools: Fix line number in the config file error message

Namhyung Kim (5):
      perf hists browser: Fix callchain print bug on TUI
      perf tools: Move callchain config from record_opts to callchain_param
      perf callchain: Move some parser functions to callchain.c
      perf tools: Introduce perf_callchain_config()
      perf tools: Convert {record,top}.call-graph option to call-graph.record-mode

Pranith Kumar (1):
      perf tools: Use ACCESS_ONCE() instead of volatile cast

Taeung Song (1):
      perf tools: Modify error code for when perf_session__new() fails

 tools/perf/builtin-annotate.c  |   2 +-
 tools/perf/builtin-diff.c      |   2 +-
 tools/perf/builtin-evlist.c    |   2 +-
 tools/perf/builtin-inject.c    |   2 +-
 tools/perf/builtin-kmem.c      |   2 +-
 tools/perf/builtin-kvm.c       |   4 +-
 tools/perf/builtin-lock.c      |   2 +-
 tools/perf/builtin-mem.c       |   2 +-
 tools/perf/builtin-record.c    | 119 ++++---------------------
 tools/perf/builtin-report.c    |   2 +-
 tools/perf/builtin-script.c    |   2 +-
 tools/perf/builtin-stat.c      |   9 +-
 tools/perf/builtin-timechart.c |   2 +-
 tools/perf/builtin-top.c       |   6 +-
 tools/perf/builtin-trace.c     |   2 +-
 tools/perf/perf.h              |   3 -
 tools/perf/ui/browsers/hists.c |   3 -
 tools/perf/util/callchain.c    | 193 +++++++++++++++++++++++++++++++++++++----
 tools/perf/util/callchain.h    |   6 +-
 tools/perf/util/config.c       |  16 +++-
 tools/perf/util/event.c        |   8 +-
 tools/perf/util/evsel.c        |  11 ++-
 tools/perf/util/session.c      |   2 +-
 tools/perf/util/session.h      |   2 +-
 24 files changed, 241 insertions(+), 163 deletions(-)
