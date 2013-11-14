Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab3KNU0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 15:26:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36322 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080Ab3KNUZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 15:25:32 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Azat Khuzhin <a3at.mail@gmail.com>, Bill Gray <bgray@redhat.com>,
        David Ahern <dsahern@gmail.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Joe Mario <jmario@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Fowles <rfowles@redhat.com>, stable@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, v.karpov@samsung.com,
        Waiman Long <Waiman.Long@hp.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/10] perf/core improvements and fixes
Date: Thu, 14 Nov 2013 17:25:05 -0300
Message-Id: <1384460715-23198-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Hi Ingo,

	Please consider pulling, done on top of tip/perf/urgent.

- Arnaldo

The following changes since commit e310718d0e83aeb9969264dc577c45db16d9104d:

  tools/perf/build: Fix feature-libunwind-debug-frame handling (2013-11-14 18:00:45 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 539e6bb71e350541105e67e3d6c31392d9da25ef:

  perf record: Add an option to force per-cpu mmaps (2013-11-14 16:10:27 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

. Synthesize anon MMAP records again, fix from Don Zickus.

. Add an option in 'perf record' to force per-cpu mmaps, from Adrian Hunter.

. Limit max callchain using max_stack on DWARF unwinding too.

. Fix segfault in the UI browser caused by off by one handling END key.

. Add '--demangle'/'--no-demangle' to perf probe, so that we can overcome
  current limitations in handling C++ symbols, from Azat Khuzhin .

. Tweak 'perf trace' summary output, from Pekka Enberg.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Adrian Hunter (1):
      perf record: Add an option to force per-cpu mmaps

Arnaldo Carvalho de Melo (4):
      perf tools: Use perf_evlist__{first,last}, perf_evsel__next
      perf evsel: Introduce perf_evsel__prev() method
      perf symbols: Limit max callchain using max_stack on DWARF unwinding too
      perf ui browser: Fix segfault caused by off by one handling END key

Azat Khuzhin (1):
      perf probe: Add '--demangle'/'--no-demangle'

Davidlohr Bueso (1):
      perf tools: Remove trivial extra semincolon

Don Zickus (1):
      perf tools: Synthesize anon MMAP records again

Ingo Molnar (1):
      perf top: Add missing newline if the 'uid' is invalid

Pekka Enberg (1):
      perf trace: Tweak summary output

 tools/perf/Documentation/perf-record.txt |  6 ++++++
 tools/perf/builtin-probe.c               |  2 ++
 tools/perf/builtin-record.c              |  2 ++
 tools/perf/builtin-top.c                 |  4 ++--
 tools/perf/builtin-trace.c               | 10 +++++-----
 tools/perf/tests/parse-events.c          |  3 +--
 tools/perf/ui/browser.c                  |  4 ++--
 tools/perf/ui/browsers/hists.c           | 11 +++++------
 tools/perf/util/event.c                  |  6 ++++--
 tools/perf/util/evlist.c                 |  6 ++++--
 tools/perf/util/evsel.c                  |  4 ++--
 tools/perf/util/evsel.h                  |  5 +++++
 tools/perf/util/machine.c                |  2 +-
 tools/perf/util/target.h                 |  1 +
 tools/perf/util/unwind.c                 |  9 +++++----
 tools/perf/util/unwind.h                 |  5 +++--
 16 files changed, 50 insertions(+), 30 deletions(-)
