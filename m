Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab3KKUXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:23:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43950 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab3KKUWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:22:52 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>, Bill Gray <bgray@redhat.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Joe Mario <jmario@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>,
        Patrick Palka <patrick@parcs.ath.cx>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Fowles <rfowles@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/10] perf/core improvements and fixes
Date: Mon, 11 Nov 2013 17:22:23 -0300
Message-Id: <1384201353-23863-1-git-send-email-acme@infradead.org>
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

The following changes since commit caea6cf52139116e43e615d87fcbf9823e197fdf:

  Merge branch 'uprobes/core' of git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc into perf/core (2013-11-11 09:44:16 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 67c1e4a53b17894e6a24f95057cc374c4be051cb:

  perf tests: Use lower sample_freq in sw clock event period test (2013-11-11 16:43:34 -0300)

----------------------------------------------------------------
perf/core improvements and fixes.

. Prevent condition that all sort keys are elided, fix from Namhyung Kim.

. Synthesize non-exec MMAP records when --data used, allowing the resolution of
  data addresses to symbols (global variables, etc).

. Don't force a refresh during progress update in the TUI, greatly reducing
  startup costs, fix from Patrick Palka.

. Fix sw clock event period test wrt not checking if using > max_sample_freq.

. Code cleanups by David Ahern and Adrian Hunter.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Adrian Hunter (1):
      perf record: Use correct return type for write()

Arnaldo Carvalho de Melo (6):
      perf evsel: Remove idx parm from constructor
      perf record: Synthesize non-exec MMAP records when --data used
      perf machine: Introduce synthesize_threads method out of open coded equivalent
      perf machine: Simplify synthesize_threads method
      perf tests: Check return of perf_evlist__open sw clock event period test
      perf tests: Use lower sample_freq in sw clock event period test

David Ahern (1):
      perf record: Move existing write_output into helper function

Namhyung Kim (1):
      perf tools: Prevent condition that all sort keys are elided

Patrick Palka (1):
      perf ui tui progress: Don't force a refresh during progress update

 tools/perf/builtin-kvm.c                  | 14 ++-------
 tools/perf/builtin-record.c               | 21 ++++++-------
 tools/perf/builtin-top.c                  | 10 ++-----
 tools/perf/builtin-trace.c                | 24 +++++----------
 tools/perf/tests/code-reading.c           |  2 +-
 tools/perf/tests/evsel-tp-sched.c         |  4 +--
 tools/perf/tests/mmap-basic.c             |  2 +-
 tools/perf/tests/open-syscall-all-cpus.c  |  2 +-
 tools/perf/tests/open-syscall-tp-fields.c |  2 +-
 tools/perf/tests/open-syscall.c           |  2 +-
 tools/perf/tests/sw-clock.c               | 13 ++++++--
 tools/perf/ui/tui/progress.c              |  3 +-
 tools/perf/util/event.c                   | 50 ++++++++++++++++++-------------
 tools/perf/util/event.h                   |  4 +--
 tools/perf/util/evlist.c                  |  9 +++---
 tools/perf/util/evsel.c                   |  4 +--
 tools/perf/util/evsel.h                   | 15 ++++++++--
 tools/perf/util/header.c                  |  4 +--
 tools/perf/util/machine.c                 | 12 ++++++++
 tools/perf/util/machine.h                 | 12 ++++++++
 tools/perf/util/parse-events.c            |  6 ++--
 tools/perf/util/sort.c                    | 13 ++++++++
 22 files changed, 133 insertions(+), 95 deletions(-)
