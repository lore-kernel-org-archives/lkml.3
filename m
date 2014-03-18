Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458AbaCRV0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:26:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44465 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbaCRV01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:26:27 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Joe Mario <jmario@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/13] perf/core improvements and fixes
Date: Tue, 18 Mar 2014 18:25:52 -0300
Message-Id: <1395177965-8879-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 0afd2d51029961281572d02545c7bde1b3f4292c:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2014-03-18 09:23:09 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to a51e87cb5a0fbebee15a3373d951dbf6f59a76c2:

  perf tools: Remove unused simple_strtoul() function (2014-03-18 18:17:07 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

User visible:

. Fixup header alignment in 'perf sched latency' output (Ramkumar Ramachandra)

. Fix off-by-one error in 'perf timechart record' argv handling (Ramkumar Ramachandra)

. Print the evsel name in the annotate stdio output, prep to fix support
  outputting annotation for multiple events, not just for the first one
  (Arnaldo Carvalho de Melo)

Internals:

. Use tid in mmap/mmap2 events to find maps (Don Zickus)

. Record the reason for filtering an address_location (Namhyung Kim)

. Apply all filters to an addr_location (Namhyung Kim)

. Merge al->filtered with hist_entry->filtered in report/hists (Namhyung Kim)

. Fix memory leak when synthesizing thread records (Namhyung Kim)

. Use ui__has_annotation() in 'report' (Namhyung Kim)

Cleanups:

. Remove unused thread__find_map function (Jiri Olsa)

. Remove unused simple_strtoul() function (Ramkumar Ramachandra)

Documentation:

. Update function names in debug messages (Ramkumar Ramachandra)

. Update some code references in design.txt (Ramkumar Ramachandra)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (1):
      perf annotate: Print the evsel name in the stdio output

Don Zickus (1):
      perf tools: Use tid in mmap/mmap2 events to find maps

Jiri Olsa (1):
      perf tools: Remove thread__find_map function

Namhyung Kim (5):
      perf symbols: Record the reason for filtering an address_location
      perf symbols: Apply all filters to an addr_location
      perf report: Merge al->filtered with hist_entry->filtered
      perf tools: Fix memory leak when synthesizing thread records
      perf report: Use ui__has_annotation()

Ramkumar Ramachandra (5):
      perf timechart: Fix off-by-one error in 'record' argv handling
      perf sched: Fixup header alignment in 'latency' output
      perf evsel: Update function names in debug messages
      perf tools: Update some code references in design.txt
      perf tools: Remove unused simple_strtoul() function

 tools/perf/builtin-report.c            |  4 ++--
 tools/perf/builtin-sched.c             | 10 +++++-----
 tools/perf/builtin-timechart.c         |  4 ++--
 tools/perf/design.txt                  | 12 ++++++------
 tools/perf/tests/hists_link.c          |  1 +
 tools/perf/util/annotate.c             | 14 +++++++++-----
 tools/perf/util/event.c                | 34 +++++++++++++++++-----------------
 tools/perf/util/evsel.c                |  4 ++--
 tools/perf/util/hist.c                 |  9 +--------
 tools/perf/util/hist.h                 |  9 +++++++++
 tools/perf/util/include/linux/kernel.h |  6 ------
 tools/perf/util/machine.c              |  6 +++---
 tools/perf/util/symbol.h               |  2 +-
 tools/perf/util/thread.h               |  6 ------
 14 files changed, 58 insertions(+), 63 deletions(-)
