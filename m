Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275Ab3FXNKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 09:10:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:25371 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab3FXNKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 09:10:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,928,1363158000"; 
   d="scan'208";a="321686284"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 00/15] perf tools: some fixes and tweaks
Date: Mon, 24 Jun 2013 16:15:57 +0300
Message-Id: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here are some fixes and tweaks to perf tools.


Adrian Hunter (15):
      perf tools: remove unused parameter
      perf tools: fix missing tool parameter
      perf tools: fix missing 'finished_round'
      perf tools: fix parse_events_terms() segfault on error path
      perf tools: fix new_term() missing free on error path
      perf tools: fix parse_events_terms() freeing local variable on error path
      perf tools: add const specifier to perf_pmu__find name parameter
      perf tools: tidy duplicated munmap code
      perf tools: validate perf event header size
      perf tools: add debug prints
      perf tools: fix symbol_conf.nr_events
      perf tools: allow non-matching sample types
      perf tools: struct thread has a tid not a pid
      perf tools: add pid to struct thread
      perf tools: fix ppid in thread__fork()

 tools/perf/builtin-inject.c    |  40 ++++++-------
 tools/perf/builtin-kmem.c      |   2 +-
 tools/perf/builtin-sched.c     |  12 ++--
 tools/perf/builtin-trace.c     |   4 +-
 tools/perf/ui/browsers/hists.c |   6 +-
 tools/perf/util/event.c        |   2 +-
 tools/perf/util/event.h        |   6 ++
 tools/perf/util/evlist.c       | 128 ++++++++++++++++++++++++++++++++++-------
 tools/perf/util/evlist.h       |   3 +
 tools/perf/util/evsel.c        |  93 ++++++++++++++++++++++++++++++
 tools/perf/util/evsel.h        |   4 ++
 tools/perf/util/header.c       |   8 ++-
 tools/perf/util/header.h       |   6 +-
 tools/perf/util/machine.c      |  57 +++++++++++++-----
 tools/perf/util/machine.h      |   8 ++-
 tools/perf/util/parse-events.c |   4 +-
 tools/perf/util/pmu.c          |  17 +++---
 tools/perf/util/pmu.h          |   2 +-
 tools/perf/util/session.c      |  25 ++++----
 tools/perf/util/sort.c         |   6 +-
 tools/perf/util/thread.c       |  11 ++--
 tools/perf/util/thread.h       |   5 +-
 tools/perf/util/tool.h         |   9 ++-
 23 files changed, 348 insertions(+), 110 deletions(-)


Regards
Adrian
