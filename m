Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbaJWKq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 06:46:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:19432 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbaJWKqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 06:46:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,774,1406617200"; 
   d="scan'208";a="594445823"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 00/16] perf tools: Intel PT preparation continued
Date: Thu, 23 Oct 2014 13:45:08 +0300
Message-Id: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here are the remaining Intel PT preparation patches.  They are
all patches that have been posted before, although "perf tools:
Do not attempt to run perf-read-vdso32 if it wasn't built" wasn't
sent as a separate email.

With regard to "32-bit compatibility VDSOs", you may recall that
Ingo had a problem getting "sh: perf-read-vdso32: command not found".
That message is inevitable when using popen to run perf-read-vdso32
and perf-read-vdso32 cannot be found.  At least with the patch
"perf tools: Do not attempt to run perf-read-vdso32 if it wasn't built"
one reason for the message is eliminated.

It would be nice to target 3.19 for Intel PT, but there are still the
real patches of which there are about 48.


Adrian Hunter (16):
      perf tools: Add id index
      perf pmu: Let pmu's with no events show up on perf list
      perf session: Add perf_session__deliver_synth_event()
      perf tools: Add a thread stack for synthesizing call chains
      perf tools: Add facility to export data in database-friendly way
      perf tools: Extend Python script interface to export data in a database-friendly way
      perf tools: Add Python script to export to postgresql
      perf tools: Add branch type to db export
      perf tools: Add branch_type and in_tx to Python export
      perf tools: Enhance the thread stack to output call/return data
      perf tools: Add call information to the database export API
      perf tools: Add call information to Python export
      perf tools: Defer export of comms that were not 'set'
      perf tools: Build programs to copy 32-bit compatibility VDSOs
      perf tools: Add support for 32-bit compatibility VDSOs
      perf tools: Do not attempt to run perf-read-vdso32 if it wasn't built

 tools/perf/Makefile.perf                           |  42 +-
 tools/perf/builtin-inject.c                        |   1 +
 tools/perf/config/Makefile                         |  29 +-
 tools/perf/config/Makefile.arch                    |   8 +
 tools/perf/config/feature-checks/Makefile          |  10 +-
 tools/perf/config/feature-checks/test-compile.c    |   4 +
 tools/perf/perf-read-vdso.c                        |  34 +
 .../scripts/python/bin/export-to-postgresql-record |   8 +
 .../scripts/python/bin/export-to-postgresql-report |  29 +
 tools/perf/scripts/python/export-to-postgresql.py  | 444 +++++++++++++
 tools/perf/util/comm.h                             |   1 +
 tools/perf/util/db-export.c                        | 426 +++++++++++++
 tools/perf/util/db-export.h                        | 107 ++++
 tools/perf/util/dso.h                              |   1 +
 tools/perf/util/event.c                            |   1 +
 tools/perf/util/event.h                            |  41 ++
 tools/perf/util/evlist.c                           |  26 +-
 tools/perf/util/evsel.h                            |   4 +
 tools/perf/util/find-vdso-map.c                    |  30 +
 tools/perf/util/machine.h                          |   1 +
 tools/perf/util/pmu.c                              |  13 +-
 tools/perf/util/pmu.h                              |   1 +
 .../util/scripting-engines/trace-event-python.c    | 395 +++++++++++-
 tools/perf/util/session.c                          | 136 ++++
 tools/perf/util/session.h                          |  15 +
 tools/perf/util/symbol.h                           |   1 +
 tools/perf/util/thread-stack.c                     | 690 +++++++++++++++++++++
 tools/perf/util/thread-stack.h                     |  79 +++
 tools/perf/util/thread.c                           |   3 +
 tools/perf/util/thread.h                           |   4 +
 tools/perf/util/tool.h                             |   3 +-
 tools/perf/util/vdso.c                             | 217 ++++++-
 tools/perf/util/vdso.h                             |   4 +-
 33 files changed, 2760 insertions(+), 48 deletions(-)
 create mode 100644 tools/perf/config/feature-checks/test-compile.c
 create mode 100644 tools/perf/perf-read-vdso.c
 create mode 100644 tools/perf/scripts/python/bin/export-to-postgresql-record
 create mode 100644 tools/perf/scripts/python/bin/export-to-postgresql-report
 create mode 100644 tools/perf/scripts/python/export-to-postgresql.py
 create mode 100644 tools/perf/util/db-export.c
 create mode 100644 tools/perf/util/db-export.h
 create mode 100644 tools/perf/util/find-vdso-map.c
 create mode 100644 tools/perf/util/thread-stack.c
 create mode 100644 tools/perf/util/thread-stack.h


Regards
Adrian
