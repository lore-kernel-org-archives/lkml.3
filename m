Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbaGLV4w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 17:56:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbaGLV4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 17:56:46 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/4] perf tools: Add support for more debug variables
Date: Sat, 12 Jul 2014 23:56:24 +0200
Message-Id: <1405202188-5029-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding support for more debug variables and --debug option
as a way to setup debug variables. Starting with support
for verbose, more will come.

It's possible to use it now with report command:
  $ perf report --debug verbose
  $ perf report --debug verbose=2

I need this for ordered events object debug outputs.

thanks,
jirka


---
Jiri Olsa (4):
      perf tools: Remove verbose from functions prototypes
      perf tools: Move pr_* debug macros into debug object
      perf tools: Factor eprintf to allow different debug variables
      perf tools: Add --debug optionto set debug variable

 tools/perf/Documentation/perf-report.txt             |  6 ++++++
 tools/perf/arch/x86/tests/dwarf-unwind.c             |  1 +
 tools/perf/arch/x86/util/unwind-libunwind.c          |  1 +
 tools/perf/builtin-evlist.c                          |  1 +
 tools/perf/builtin-help.c                            |  1 +
 tools/perf/builtin-report.c                          |  2 ++
 tools/perf/builtin-timechart.c                       |  1 +
 tools/perf/tests/dso-data.c                          |  1 +
 tools/perf/tests/evsel-roundtrip-name.c              |  1 +
 tools/perf/tests/evsel-tp-sched.c                    |  1 +
 tools/perf/tests/open-syscall-tp-fields.c            |  1 +
 tools/perf/tests/parse-events.c                      |  1 +
 tools/perf/tests/parse-no-sample-id-all.c            |  1 +
 tools/perf/tests/sample-parsing.c                    |  1 +
 tools/perf/tests/thread-mg-share.c                   |  1 +
 tools/perf/ui/stdio/hist.c                           |  2 +-
 tools/perf/util/data.c                               |  1 +
 tools/perf/util/debug.c                              | 57 ++++++++++++++++++++++++++++++++++++++++++++++------
 tools/perf/util/debug.h                              | 23 +++++++++++++++++++++
 tools/perf/util/include/linux/kernel.h               | 21 -------------------
 tools/perf/util/map.c                                | 24 +++++++++++-----------
 tools/perf/util/map.h                                |  9 ++++-----
 tools/perf/util/probe-finder.c                       |  1 -
 tools/perf/util/pstack.c                             |  1 +
 tools/perf/util/python.c                             |  4 ++--
 tools/perf/util/scripting-engines/trace-event-perl.c |  1 +
 tools/perf/util/thread.c                             |  4 ++--
 tools/perf/util/trace-event-info.c                   |  1 +
 tools/perf/util/trace-event-read.c                   |  2 +-
 tools/perf/util/unwind-libunwind.c                   |  1 +
 tools/perf/util/util.c                               |  1 +
 tools/perf/util/vdso.c                               |  1 +
 32 files changed, 124 insertions(+), 51 deletions(-)
