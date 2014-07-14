Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbaGNVrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 17:47:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757320AbaGNVrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 17:47:07 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCHv2 0/4] perf tools: Add support for more debug variables
Date: Mon, 14 Jul 2014 23:46:46 +0200
Message-Id: <1405374411-29012-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding support for more debug variables and --debug option
as a way to setup debug variables. Starting with support
for verbose, more will come.

It's possible to use it now with report command:
  $ perf --debug verbose   ...
  $ perf --debug verbose=2 ...

I need this for ordered events object debug outputs.

v2 changes:
  - renaming variable_t to debug_variable (Namhyung)
  - separated getopt.h includes removal changes (Namhyung)
  - making --debug option global as perf command option (Arnaldo)

thanks,
jirka


---
Jiri Olsa (5):
      perf tools: Remove verbose from functions prototypes
      perf tools: Move pr_* debug macros into debug object
      perf tools: Factor eprintf to allow different debug variables
      perf tools: Add --debug optionto set debug variable
      perf tools: Remove getopt.h includes

 tools/perf/Documentation/perf-report.txt             |  6 ++++++
 tools/perf/Documentation/perf.txt                    | 10 +++++++++-
 tools/perf/arch/x86/tests/dwarf-unwind.c             |  1 +
 tools/perf/arch/x86/util/unwind-libunwind.c          |  1 +
 tools/perf/builtin-evlist.c                          |  1 +
 tools/perf/builtin-help.c                            |  1 +
 tools/perf/builtin-timechart.c                       |  1 +
 tools/perf/perf.c                                    | 13 +++++++++++-
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
 tools/perf/util/debug.c                              | 56 ++++++++++++++++++++++++++++++++++++++++++++++------
 tools/perf/util/debug.h                              | 22 +++++++++++++++++++++
 tools/perf/util/include/linux/kernel.h               | 21 --------------------
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
 33 files changed, 141 insertions(+), 53 deletions(-)
