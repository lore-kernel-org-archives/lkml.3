Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaEUNSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 09:18:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbaEUNNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 09:13:00 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Lentine <mlentine@google.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [GIT PULL 00/22] perf/core improvements and fixes
Date: Wed, 21 May 2014 15:12:22 +0200
Message-Id: <1400677964-25160-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Ingo,
please consider pulling

thanks,
jirka


The following changes since commit 6480c56130ba073df84d57d61062ec4118b10bbe:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/core (2014-05-20 08:36:09 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-core-for-mingo

for you to fetch changes up to eca8183699964579ca8a0b8d116bd1f4da0136f7:

  perf tools: Add automatic remapping of Android libraries (2014-05-21 15:03:25 +0200)

----------------------------------------------------------------
perf/core improvements and fixes:

. Android related fixes for pager and map dso resolving (Michael Lentine)

. Add -F option for specifying output fields (Namhyung Kim)

Signed-off-by: Jiri Olsa <jolsa@kernel.org>

----------------------------------------------------------------
Michael Lentine (2):
      perf tools: Add cat as fallback pager
      perf tools: Add automatic remapping of Android libraries

Namhyung Kim (20):
      perf tools: Add ->cmp(), ->collapse() and ->sort() to perf_hpp_fmt
      perf tools: Convert sort entries to hpp formats
      perf tools: Use hpp formats to sort hist entries
      perf tools: Support event grouping in hpp ->sort()
      perf tools: Use hpp formats to sort final output
      perf tools: Consolidate output field handling to hpp format routines
      perf ui: Get rid of callback from __hpp__fmt()
      perf tools: Allow hpp fields to be sort keys
      perf tools: Consolidate management of default sort orders
      perf tools: Call perf_hpp__init() before setting up GUI browsers
      perf report: Add -F option to specify output fields
      perf tools: Add ->sort() member to struct sort_entry
      perf report/tui: Fix a bug when --fields/sort is given
      perf top: Add --fields option to specify output fields
      perf tools: Skip elided sort entries
      perf hists: Reset width of output fields with header length
      perf tools: Get rid of obsolete hist_entry__sort_list
      perf tools: Introduce reset_output_field()
      perf tests: Factor out print_hists_*()
      perf tests: Add a testcase for histogram output sorting

 tools/perf/Documentation/perf-diff.txt   |   5 +-
 tools/perf/Documentation/perf-report.txt |  19 +
 tools/perf/Documentation/perf-top.txt    |  14 +-
 tools/perf/Makefile.perf                 |   1 +
 tools/perf/builtin-diff.c                |   7 +-
 tools/perf/builtin-report.c              |  41 +-
 tools/perf/builtin-top.c                 |  20 +-
 tools/perf/tests/builtin-test.c          |   4 +
 tools/perf/tests/hists_common.c          |  57 +++
 tools/perf/tests/hists_common.h          |   3 +
 tools/perf/tests/hists_filter.c          |  38 +-
 tools/perf/tests/hists_link.c            |  30 +-
 tools/perf/tests/hists_output.c          | 618 +++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h                 |   1 +
 tools/perf/ui/browsers/hists.c           | 104 +++---
 tools/perf/ui/gtk/hists.c                |  41 +-
 tools/perf/ui/hist.c                     | 244 +++++++++---
 tools/perf/ui/setup.c                    |   2 -
 tools/perf/ui/stdio/hist.c               |  79 ++--
 tools/perf/util/hist.c                   |  83 ++---
 tools/perf/util/hist.h                   |  27 +-
 tools/perf/util/map.c                    |  95 ++++-
 tools/perf/util/pager.c                  |  12 +-
 tools/perf/util/sort.c                   | 436 ++++++++++++++++++++--
 tools/perf/util/sort.h                   |   6 +
 25 files changed, 1601 insertions(+), 386 deletions(-)
 create mode 100644 tools/perf/tests/hists_output.c
