Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab3IETnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 15:43:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59293 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889Ab3IETm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 15:42:57 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Kyle McMartin <kyle@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/6] perf/urgent fixes
Date: Thu,  5 Sep 2013 16:42:37 -0300
Message-Id: <1378410163-2606-1-git-send-email-acme@infradead.org>
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

The following changes since commit 816434ec4a674fcdb3c2221a6dffdc8f34020550:

  Merge branch 'x86-spinlocks-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2013-09-04 11:55:10 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo

for you to fetch changes up to 526fd8d4f770d18e99680ff87965e16bb8f1d806:

  perf session: Separate progress bar update when processing events (2013-09-05 16:19:02 -0300)

----------------------------------------------------------------
perf/urgent fixes:

. Fix parsing with no sample_id_all bit set, this regression prevents perf
  from reading old perf.data files generated in systems where
  perf_event_attr.sample_id_all isn't available, from Adrian Hunter.

. Add signal checking to the inner 'perf trace' event processing loop, allowing
  faster response to control+C.

. Fix formatting of long symbol names removing the hardcoding of a buffer
  size used to format histogram entries, which was truncating the lines.

. Separate progress bar update when processing events, reducing potentially big
  overhead in not needed TUI progress bar screen updates, from Jiri Olsa.

. Fix 'perf trace' build in architectures where MAP_32BIT is not defined, from
  Kyle McMartin.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Adrian Hunter (2):
      perf tools: Add test for parsing with no sample_id_all bit
      perf evlist: Fix parsing with no sample_id_all bit set

Arnaldo Carvalho de Melo (2):
      perf trace: Check control+C more often
      perf hists: Fix formatting of long symbol names

Jiri Olsa (1):
      perf session: Separate progress bar update when processing events

Kyle McMartin (1):
      perf trace: Check if MAP_32BIT is defined

 tools/perf/Makefile                       |   3 +-
 tools/perf/builtin-trace.c                |   5 ++
 tools/perf/tests/builtin-test.c           |   4 ++
 tools/perf/tests/parse-no-sample-id-all.c | 108 ++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h                  |   1 +
 tools/perf/ui/stdio/hist.c                |  23 +++++--
 tools/perf/util/evlist.c                  |   9 ++-
 tools/perf/util/session.c                 |   3 +-
 8 files changed, 146 insertions(+), 10 deletions(-)
 create mode 100644 tools/perf/tests/parse-no-sample-id-all.c
