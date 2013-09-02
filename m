Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194Ab3IBU6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 16:58:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48858 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759025Ab3IBU4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 16:56:51 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/10] perf/core improvements and fixes
Date: Mon,  2 Sep 2013 17:56:23 -0300
Message-Id: <1378155393-7993-1-git-send-email-acme@infradead.org>
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

The following changes since commit 7bfb7e6bdd906f11ee9e751b3fec4f4fc728e818:

  perf: Convert kmalloc_node(...GFP_ZERO...) to kzalloc_node() (2013-09-02 08:42:49 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 31cd3855c98119cae287b761d8d2e75018714c5d:

  perf trace: Tell arg formatters the arg index (2013-09-02 16:40:40 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

. 'perf trace' arg formatting improvements to allow masking arguments
  in syscalls such as futex and open, where the some arguments are
  ignored and thus should not be printed depending on other args.

. Beautify futex open, openat, open_by_handle_at, lseek and futex syscalls.

. Add dummy software event to use when wanting just to keep receiving
  PERF_RECORD_{MMAP,COMM,etc}, add test for it, from Adrian Hunter.

. Fix symbol offset computation for some dsos in 'perf script', from David Ahern.

. Skip unsupported hardware events in 'perf list', from Namhyung Kim.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Adrian Hunter (3):
      perf: Add a dummy software event to keep tracking
      perf tools: Add support for PERF_COUNT_SW_DUMMY
      perf tests: Add 'keep tracking' test

Arnaldo Carvalho de Melo (5):
      perf trace: Allow syscall arg formatters to mask args
      perf trace: Add beautifier for futex 'operation' parm
      perf trace: Add beautifier for lseek's whence arg
      perf trace: Add beautifier for open's flags arg
      perf trace: Tell arg formatters the arg index

David Ahern (1):
      perf tools: Fix symbol offset computation for some dsos

Namhyung Kim (1):
      perf list: Skip unsupported events

 include/uapi/linux/perf_event.h  |   1 +
 tools/perf/Makefile              |   1 +
 tools/perf/builtin-trace.c       | 180 ++++++++++++++++++++++++++++++++++++---
 tools/perf/tests/builtin-test.c  |   4 +
 tools/perf/tests/keep-tracking.c | 154 +++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h         |   1 +
 tools/perf/util/evlist.c         |  42 ++++++++-
 tools/perf/util/evlist.h         |   5 ++
 tools/perf/util/evsel.c          |   1 +
 tools/perf/util/parse-events.c   |  45 +++++++++-
 tools/perf/util/parse-events.l   |   1 +
 tools/perf/util/python.c         |   1 +
 tools/perf/util/session.c        |   1 +
 tools/perf/util/symbol.c         |   5 +-
 14 files changed, 424 insertions(+), 18 deletions(-)
 create mode 100644 tools/perf/tests/keep-tracking.c
