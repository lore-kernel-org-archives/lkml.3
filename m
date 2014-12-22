Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbaLVPaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 10:30:23 -0500
Received: from mail.kernel.org ([198.145.19.201]:53876 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754863AbaLVPaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 10:30:21 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Joe Mario <jmario@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Richard Fowles <rfowles@redhat.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Stephane Eranian <eranian@google.com>
Subject: [GIT PULL 00/10] perf/core improvements and fixes
Date: Mon, 22 Dec 2014 12:29:59 -0300
Message-Id: <1419262209-9464-1-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit ac931f87a647ca156f65a4c00e7297165e4fa2d8:

  perf: Fix building warning on ARM 32 (2014-12-19 13:09:43 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo

for you to fetch changes up to e51679f54467febc6e9f1091c0ac8c31b54d59a1:

  perf tools: Remove some unused functions from color.c (2014-12-22 11:55:09 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

User visible:

- Enable sampling loads and stores simultaneously by default
  in 'perf mem' (Stephane Eranian)

- Show progress bar in more places while doing histogram processing
  in the hists browser (Namhyung Kim)

- Print backtrace symbols when segfault occurs in 'report' (Namhyung Kim)

Infrastructure:

- Consistency and code duplication elimination fixes in the
  hists code (Arnaldo Carvalho de Melo)

- Append callchains only when requested (Namhyung Kim)

- Remove some unused functions from color.c (Rickard Strandqvist)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (4):
      perf mem: Move the mem_operations global to struct perf_mem
      perf tools: Remove EOL whitespaces
      perf hists: Rename hist_entry__free to __delete
      perf hists: Introduce function for deleting/removing hist_entry

Namhyung Kim (4):
      perf report: Get rid of report__inc_stat()
      perf report: Show progress bar for output resorting
      perf ui/tui: Print backtrace symbols when segfault occurs
      perf callchain: Append callchains only when requested

Rickard Strandqvist (1):
      perf tools: Remove some unused functions from color.c

Stephane Eranian (1):
      perf mem: Enable sampling loads and stores simultaneously

 tools/perf/Documentation/perf-buildid-cache.txt    |   2 +-
 tools/perf/Documentation/perf-mem.txt              |   9 +-
 tools/perf/Documentation/perf-script.txt           |  28 ++---
 tools/perf/builtin-annotate.c                      |   2 +-
 tools/perf/builtin-buildid-cache.c                 |   4 +-
 tools/perf/builtin-diff.c                          |   4 +-
 tools/perf/builtin-mem.c                           | 131 ++++++++++++++++-----
 tools/perf/builtin-report.c                        |  40 ++++---
 tools/perf/builtin-stat.c                          |   2 +-
 tools/perf/builtin-top.c                           |   6 +-
 tools/perf/builtin-trace.c                         |  80 ++++++-------
 tools/perf/tests/attr.py                           |   1 -
 tools/perf/tests/hists_cumulate.c                  |   4 +-
 tools/perf/tests/hists_filter.c                    |   2 +-
 tools/perf/tests/hists_output.c                    |  12 +-
 tools/perf/tests/make                              |   1 -
 tools/perf/tests/parse-events.c                    |   2 +-
 tools/perf/ui/browsers/annotate.c                  |   3 +-
 tools/perf/ui/progress.h                           |   4 +-
 tools/perf/ui/tui/setup.c                          |  26 +++-
 tools/perf/util/annotate.c                         |   2 +-
 tools/perf/util/color.c                            | 126 --------------------
 tools/perf/util/color.h                            |   2 -
 tools/perf/util/hist.c                             |  59 ++++++----
 tools/perf/util/hist.h                             |   4 +-
 tools/perf/util/parse-events.c                     |   6 +-
 tools/perf/util/python.c                           |   2 +-
 .../util/scripting-engines/trace-event-python.c    |   2 +-
 tools/perf/util/session.c                          |   2 +-
 tools/perf/util/symbol.c                           |   2 +-
 30 files changed, 278 insertions(+), 292 deletions(-)
