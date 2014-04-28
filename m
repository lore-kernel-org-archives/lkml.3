Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbaD1Moo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 08:44:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755564AbaD1Moj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 08:44:39 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [GIT PULL  0/7] perf/core improvements and fixes
Date: Mon, 28 Apr 2014 13:59:58 +0200
Message-Id: <1398686405-31951-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Ingo,
please consider pulling

thanks,
jirka


The following changes since commit 2933d7813d8618f18632a7dc7f4e7f1f7d17383a:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/core (2014-04-25 10:04:46 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-core-for-mingo

for you to fetch changes up to fabf01238289e9ae009499594fc54642f5802a24:

  perf tests: Add map groups sharing with thread object test (2014-04-28 13:43:40 +0200)

----------------------------------------------------------------
perf/core improvements and fixes:

. Add a test case for hists filtering (Namhyung Kim)

. Share map_groups among threads of the same group (Arnaldo Carvalho de Melo, Jiri Olsa)

Signed-off-by: Jiri Olsa <jolsa@kernel.org>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (2):
      perf tools: Allocate thread map_groups's dynamically
      perf tools: Reference count map_groups objects

Jiri Olsa (3):
      perf tests: Add thread maps lookup automated tests
      perf tools: Share map_groups among threads of the same group
      perf tests: Add map groups sharing with thread object test

Namhyung Kim (2):
      perf tests: Factor out fake_setup_machine()
      perf tests: Add a test case for hists filtering

 tools/perf/Makefile.perf                 |   4 +
 tools/perf/arch/x86/tests/dwarf-unwind.c |   2 +-
 tools/perf/perf.h                        |   6 +
 tools/perf/tests/builtin-test.c          |  12 ++
 tools/perf/tests/hists_common.c          | 148 +++++++++++++++
 tools/perf/tests/hists_common.h          |  44 +++++
 tools/perf/tests/hists_filter.c          | 315 +++++++++++++++++++++++++++++++
 tools/perf/tests/hists_link.c            | 141 +-------------
 tools/perf/tests/mmap-thread-lookup.c    | 233 +++++++++++++++++++++++
 tools/perf/tests/tests.h                 |   3 +
 tools/perf/tests/thread-mg-share.c       |  90 +++++++++
 tools/perf/ui/stdio/hist.c               |   2 +-
 tools/perf/util/event.c                  |   2 +-
 tools/perf/util/machine.c                |  11 ++
 tools/perf/util/map.c                    |  23 +++
 tools/perf/util/map.h                    |  12 ++
 tools/perf/util/thread.c                 |  52 +++--
 tools/perf/util/thread.h                 |   3 +-
 18 files changed, 948 insertions(+), 155 deletions(-)
 create mode 100644 tools/perf/tests/hists_common.c
 create mode 100644 tools/perf/tests/hists_common.h
 create mode 100644 tools/perf/tests/hists_filter.c
 create mode 100644 tools/perf/tests/mmap-thread-lookup.c
 create mode 100644 tools/perf/tests/thread-mg-share.c
