Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbaKYNWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:22:25 -0500
Received: from mail.kernel.org ([198.145.19.201]:35517 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbaKYNWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:22:23 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/12] perf/core improvements and fixes
Date: Tue, 25 Nov 2014 10:21:58 -0300
Message-Id: <1416921730-5063-1-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 4e6e311e596eadba30d4f56f64eae7d45611a01c:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2014-11-20 08:32:01 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo

for you to fetch changes up to 1d9e446b91e182055d874fbb30150aad479a4981:

  perf tools: Add snapshot format file parsing (2014-11-24 18:03:51 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

User visible:

- Callchain improvements from Andi Kleen including:
  * Enable printing the srcline in the history
  * Make get_srcline fall back to sym+offset

- Allow to force redirect pr_debug to stderr. (Andi Kleen)

- TUI hist_entry browser fixes, including showing missing overhead
  value for first level callchain. Detected comparing the output of
  --stdio/--gui (that matched) with --tui, that had this problem. (Namhyung Kim)

- Fix segfault due to invalid kernel dso access (Namhyung Kim)

Infrastructure:

- Move bfd_demangle stubbing to its only user (Arnaldo Carvalho de Melo)

- 'perf stat' refactorings, moving stuff from it to evsel.c to use in
  per-pkg/snapshot format changes (Jiri Olsa)

- Add per-pkg format file parsing (Matt Fleming)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Andi Kleen (3):
      perf callchain: Enable printing the srcline in the history
      perf callchain: Make get_srcline fall back to sym+offset
      perf tools: Allow to force redirect pr_debug to stderr.

Arnaldo Carvalho de Melo (1):
      perf symbols: Move bfd_demangle stubbing to its only user

Jiri Olsa (4):
      perf evsel: Introduce perf_evsel__compute_deltas function
      perf evsel: Introduce perf_counts_values__scale function
      perf evsel: Introduce perf_evsel__read_cb function
      perf tools: Add snapshot format file parsing

Matt Fleming (1):
      perf tools: Add per-pkg format file parsing

Namhyung Kim (3):
      perf hists browser: Print overhead percent value for first-level callchain
      perf tools: Collapse first level callchain entry if it has sibling
      perf tools: Fix segfault due to invalid kernel dso access

 tools/perf/ui/browsers/hists.c | 25 +++++++++++---
 tools/perf/util/annotate.c     |  2 +-
 tools/perf/util/callchain.c    | 12 ++++++-
 tools/perf/util/callchain.h    |  1 +
 tools/perf/util/debug.c        |  4 ++-
 tools/perf/util/evsel.c        | 72 +++++++++++++++++++++++-----------------
 tools/perf/util/evsel.h        | 15 +++++++++
 tools/perf/util/machine.c      |  4 +--
 tools/perf/util/map.c          |  2 +-
 tools/perf/util/parse-events.c |  2 ++
 tools/perf/util/pmu.c          | 74 +++++++++++++++++++++++++++++++++++-------
 tools/perf/util/pmu.h          |  4 +++
 tools/perf/util/sort.c         |  6 ++--
 tools/perf/util/srcline.c      | 15 +++++++--
 tools/perf/util/symbol-elf.c   | 21 ++++++++++++
 tools/perf/util/symbol.h       | 21 ------------
 tools/perf/util/util.h         |  4 ++-
 17 files changed, 205 insertions(+), 79 deletions(-)
