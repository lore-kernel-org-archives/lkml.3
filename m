Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab3IZI6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:58:22 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46685 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab3IZI6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:58:13 -0400
X-AuditID: 9c93016f-b7bc8ae000004e6e-bf-5243f722437c
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHSET 0/8] perf tools: Fix scalability problem on callchain merging (v4)
Date: Thu, 26 Sep 2013 17:58:02 +0900
Message-Id: <1380185890-25758-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a new version of callchain improvement patchset.  I found and
fixed bugs in the previous version.  I verified that it produced
exactly same output before and after applying rbtree conversion patch
(#1).  However after Frederic's new comm infrastructure patches are
applied it'd be little different.

The patches are on 'perf/callchain-v4' branch in my tree

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Please test!

Thanks,
Namhyung


Frederic Weisbecker (4):
  perf tools: Use an accessor to read thread comm
  perf tools: Add time argument on comm setting
  perf tools: Add new comm infrastructure
  perf tools: Compare hists comm by addresses

Namhyung Kim (4):
  perf callchain: Convert children list to rbtree
  perf ui/progress: Add new helper functions for progress bar
  perf tools: Show progress on histogram collapsing
  perf tools: Get current comm instead of last one

 tools/perf/Makefile                                |   2 +
 tools/perf/builtin-annotate.c                      |   2 +-
 tools/perf/builtin-diff.c                          |   2 +-
 tools/perf/builtin-kmem.c                          |   2 +-
 tools/perf/builtin-lock.c                          |   2 +-
 tools/perf/builtin-report.c                        |  10 +-
 tools/perf/builtin-sched.c                         |  16 +--
 tools/perf/builtin-script.c                        |   6 +-
 tools/perf/builtin-top.c                           |   6 +-
 tools/perf/builtin-trace.c                         |  17 +--
 tools/perf/tests/code-reading.c                    |   2 +-
 tools/perf/tests/hists_link.c                      |   8 +-
 tools/perf/ui/browsers/hists.c                     |  10 +-
 tools/perf/ui/progress.c                           |  18 +++
 tools/perf/ui/progress.h                           |  10 ++
 tools/perf/util/callchain.c                        | 147 ++++++++++++++++-----
 tools/perf/util/callchain.h                        |  11 +-
 tools/perf/util/comm.c                             | 121 +++++++++++++++++
 tools/perf/util/comm.h                             |  21 +++
 tools/perf/util/event.c                            |  32 ++---
 tools/perf/util/hist.c                             |   8 +-
 tools/perf/util/hist.h                             |   3 +-
 tools/perf/util/machine.c                          |  39 +++---
 tools/perf/util/machine.h                          |  21 ++-
 .../perf/util/scripting-engines/trace-event-perl.c |   2 +-
 .../util/scripting-engines/trace-event-python.c    |   4 +-
 tools/perf/util/session.c                          |  26 ++--
 tools/perf/util/sort.c                             |  19 ++-
 tools/perf/util/sort.h                             |   1 +
 tools/perf/util/thread.c                           | 103 +++++++++++----
 tools/perf/util/thread.h                           |  10 +-
 31 files changed, 504 insertions(+), 177 deletions(-)
 create mode 100644 tools/perf/util/comm.c
 create mode 100644 tools/perf/util/comm.h

-- 
1.7.11.7

