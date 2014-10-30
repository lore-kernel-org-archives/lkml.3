Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760444AbaJ3OLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:11:21 -0400
Received: from mga14.intel.com ([192.55.52.115]:24875 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760254AbaJ3OLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:11:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="408517836"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 0/7] perf tools: Add a thread stack for synthesizing call chains
Date: Thu, 30 Oct 2014 16:09:41 +0200
Message-Id: <1414678188-14946-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here are the thread stack patches again.  Please let me
know if you want more explanation.

Changes:

	perf tools: Add a thread stack for synthesizing call chains
		Added some error returns
		Renamed PERF_FLAGS_ to PERF_IP_FLAGS_

	perf tools: Enhance the thread stack to output call/return data
		Expanded commit message
		Added more comments


Adrian Hunter (7):
      perf tools: Add a thread stack for synthesizing call chains
      perf tools: Add branch type to db export
      perf tools: Add branch_type and in_tx to Python export
      perf tools: Enhance the thread stack to output call/return data
      perf tools: Add call information to the database export API
      perf tools: Add call information to Python export
      perf tools: Defer export of comms that were not 'set'

 tools/perf/Makefile.perf                           |   2 +
 .../scripts/python/bin/export-to-postgresql-report |  15 +-
 tools/perf/scripts/python/export-to-postgresql.py  |  98 ++-
 tools/perf/util/db-export.c                        | 162 ++++-
 tools/perf/util/db-export.h                        |  21 +
 tools/perf/util/event.h                            |  26 +
 .../util/scripting-engines/trace-event-python.c    | 118 +++-
 tools/perf/util/thread-stack.c                     | 747 +++++++++++++++++++++
 tools/perf/util/thread-stack.h                     | 111 +++
 tools/perf/util/thread.c                           |   3 +
 tools/perf/util/thread.h                           |   3 +
 11 files changed, 1289 insertions(+), 17 deletions(-)
 create mode 100644 tools/perf/util/thread-stack.c
 create mode 100644 tools/perf/util/thread-stack.h


Regards
Adrian
