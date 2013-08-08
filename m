Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965257Ab3HHL00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 07:26:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:35773 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965220Ab3HHL0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 07:26:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,838,1367996400"; 
   d="scan'208";a="383802769"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 0/8] perf tools: add symbol filter to struct machine
Date: Thu,  8 Aug 2013 14:32:19 +0300
Message-Id: <1375961547-30267-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here are some patches that add symbol filter to struct machine as
we briefly discussed on irc.

The first patch puts the symbol filter on both struct machine and
struct machines so that guest machines added later inherit the same
symbol filter.

The next 4 patches change the tools to set the machines symbol filter.

The final 3 patches remove symbol filter as a parameter in some cases
where it is redundant.


Adrian Hunter (8):
      perf tools: add symbol filter to struct machine
      perf top: set the machines symbol filter
      perf report: set the machines symbol filter
      perf mem: remove unused symbol filter member
      perf annotate: set the machines symbol filter
      perf tools: remove filter parameter of perf_event__preprocess_sample()
      perf tools: remove filter parameter of thread__find_addr_location()
      perf tools: remove filter parameter of thread__find_addr_map()

 tools/perf/builtin-annotate.c   |  5 +++--
 tools/perf/builtin-diff.c       |  2 +-
 tools/perf/builtin-inject.c     |  2 +-
 tools/perf/builtin-mem.c        |  4 +---
 tools/perf/builtin-report.c     |  7 +++----
 tools/perf/builtin-script.c     |  6 +++---
 tools/perf/builtin-top.c        |  5 +++--
 tools/perf/tests/code-reading.c |  2 +-
 tools/perf/tests/hists_link.c   |  4 ++--
 tools/perf/util/build-id.c      |  2 +-
 tools/perf/util/event.c         | 20 ++++++++++----------
 tools/perf/util/event.h         |  3 +--
 tools/perf/util/machine.c       | 28 ++++++++++++++++++++++++----
 tools/perf/util/machine.h       |  5 +++++
 tools/perf/util/session.c       |  3 +--
 tools/perf/util/thread.h        |  5 ++---
 tools/perf/util/unwind.c        |  6 +++---
 17 files changed, 65 insertions(+), 44 deletions(-)


Regards
Adrian
