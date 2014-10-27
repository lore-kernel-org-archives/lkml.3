Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaJ0NvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:51:04 -0400
Received: from mga03.intel.com ([134.134.136.65]:17592 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294AbaJ0NvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:51:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,796,1406617200"; 
   d="scan'208";a="626225420"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 0/9] perf tools: Intel PT preparation continued
Date: Mon, 27 Oct 2014 15:49:21 +0200
Message-Id: <1414417770-18602-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here are the remaining Intel PT preparation patches, re-based
on your current tree.

Changes:

      perf tools: Add id index
		Added more explanation to commit messsage

      perf tools: Add a thread stack for synthesizing call chains
		Added out-of-memory warnings
		Improved thread_stack__pop() loop


Adrian Hunter (9):
      perf tools: Add id index
      perf session: Add perf_session__deliver_synth_event()
      perf tools: Add a thread stack for synthesizing call chains
      perf tools: Add branch type to db export
      perf tools: Add branch_type and in_tx to Python export
      perf tools: Enhance the thread stack to output call/return data
      perf tools: Add call information to the database export API
      perf tools: Add call information to Python export
      perf tools: Defer export of comms that were not 'set'

 tools/perf/Makefile.perf                           |   2 +
 tools/perf/builtin-inject.c                        |   1 +
 .../scripts/python/bin/export-to-postgresql-report |  15 +-
 tools/perf/scripts/python/export-to-postgresql.py  |  98 ++-
 tools/perf/util/db-export.c                        | 162 ++++-
 tools/perf/util/db-export.h                        |  21 +
 tools/perf/util/event.c                            |   1 +
 tools/perf/util/event.h                            |  41 ++
 tools/perf/util/evlist.c                           |  26 +-
 tools/perf/util/evsel.h                            |   3 +
 .../util/scripting-engines/trace-event-python.c    | 118 +++-
 tools/perf/util/session.c                          | 136 ++++
 tools/perf/util/session.h                          |  15 +
 tools/perf/util/thread-stack.c                     | 696 +++++++++++++++++++++
 tools/perf/util/thread-stack.h                     |  79 +++
 tools/perf/util/thread.c                           |   3 +
 tools/perf/util/thread.h                           |   3 +
 tools/perf/util/tool.h                             |   3 +-
 18 files changed, 1402 insertions(+), 21 deletions(-)
 create mode 100644 tools/perf/util/thread-stack.c
 create mode 100644 tools/perf/util/thread-stack.h


Regards
Adrian
