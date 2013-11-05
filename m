Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab3KEULU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 15:11:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38835 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab3KEUKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 15:10:18 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Stephane Eranian <eranian@google.com>
Subject: [GIT PULL 00/10] perf/core improvements and fixes
Date: Tue,  5 Nov 2013 17:09:51 -0300
Message-Id: <1383682201-19399-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 87968f94fbea47df334502a0db645833ce8a848b:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2013-11-04 21:14:04 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 316c7136f8bad924609163b9b115f68d59a68c82:

  perf tools: Finish the removal of 'self' arguments (2013-11-05 15:32:36 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

. Check maximum frequency rate for record/top, emitting better error
  messages, from Jiri Olsa.

. Disable live kvm command if timerfd is not supported, from David Ahern.

. Add usage to 'perf list', from David Ahern.

. Fix detection of non-core features, from David Ahern.

. Consolidate __hists__add_*entry(), cleanup from Namhyung Kim.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (2):
      perf fs: Rename NAME_find_mountpoint() to NAME__mountpoint()
      perf tools: Finish the removal of 'self' arguments

David Ahern (4):
      perf kvm: Disable live command if timerfd is not supported
      tools/perf/build: Fix detection of non-core features
      perf list: Remove a level of indentation
      perf list: Add usage

Jiri Olsa (3):
      perf tools: Factor sysfs code into generic fs object
      perf fs: Add procfs support
      perf tools: Check maximum frequency rate for record/top

Namhyung Kim (1):
      perf hists: Consolidate __hists__add_*entry()

 tools/perf/Makefile.perf                           |   4 +-
 tools/perf/builtin-annotate.c                      |   2 +-
 tools/perf/builtin-diff.c                          |   3 +-
 tools/perf/builtin-kvm.c                           |  12 ++
 tools/perf/builtin-list.c                          |  84 ++++++++------
 tools/perf/builtin-record.c                        |  15 +--
 tools/perf/builtin-report.c                        |  16 ++-
 tools/perf/builtin-top.c                           |  20 +---
 tools/perf/config/Makefile                         |  17 ++-
 tools/perf/config/feature-checks/Makefile          |   6 +-
 tools/perf/config/feature-checks/test-all.c        |   5 +
 tools/perf/config/feature-checks/test-timerfd.c    |  18 +++
 .../perf/scripts/python/Perf-Trace-Util/Context.c  |   6 +-
 tools/perf/tests/hists_link.c                      |   6 +-
 tools/perf/tests/parse-events.c                    |   6 +-
 tools/perf/ui/browser.h                            |  32 +++---
 tools/perf/ui/browsers/hists.c                     |   2 +-
 tools/perf/ui/browsers/map.c                       |  40 +++----
 tools/perf/ui/browsers/map.h                       |   2 +-
 tools/perf/ui/browsers/scripts.c                   |   8 +-
 tools/perf/ui/stdio/hist.c                         |  14 +--
 tools/perf/util/build-id.h                         |   3 +-
 tools/perf/util/cpumap.c                           |   6 +-
 tools/perf/util/event.c                            |   6 +-
 tools/perf/util/event.h                            |   3 +-
 tools/perf/util/evlist.h                           |   3 +-
 tools/perf/util/fs.c                               | 119 ++++++++++++++++++++
 tools/perf/util/fs.h                               |   7 ++
 tools/perf/util/hist.c                             |  75 ++-----------
 tools/perf/util/hist.h                             |  51 +++------
 tools/perf/util/include/linux/magic.h              |   4 +
 tools/perf/util/pmu.c                              |  17 +--
 tools/perf/util/probe-finder.c                     | 113 +++++++++----------
 tools/perf/util/probe-finder.h                     |  10 +-
 tools/perf/util/pstack.h                           |  10 +-
 tools/perf/util/python-ext-sources                 |   2 +-
 tools/perf/util/record.c                           |  71 ++++++++++++
 tools/perf/util/session.c                          | 121 ++++++++++-----------
 tools/perf/util/session.h                          |  27 ++---
 tools/perf/util/sort.h                             |   2 +-
 tools/perf/util/strfilter.c                        |  32 +++---
 tools/perf/util/strfilter.h                        |  12 +-
 tools/perf/util/sysfs.c                            |  60 ----------
 tools/perf/util/sysfs.h                            |   6 -
 tools/perf/util/thread.h                           |  10 +-
 45 files changed, 591 insertions(+), 497 deletions(-)
 create mode 100644 tools/perf/config/feature-checks/test-timerfd.c
 create mode 100644 tools/perf/util/fs.c
 create mode 100644 tools/perf/util/fs.h
 delete mode 100644 tools/perf/util/sysfs.c
 delete mode 100644 tools/perf/util/sysfs.h
