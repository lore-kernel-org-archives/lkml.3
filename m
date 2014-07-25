Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760763AbaGYPhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:37:24 -0400
Received: from mail.kernel.org ([198.145.19.201]:34849 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbaGYPhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:37:22 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/27] perf/core improvements and fixes
Date: Fri, 25 Jul 2014 12:36:42 -0300
Message-Id: <1406302629-11790-1-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 2336ebc32676df5b794acfe0c980583ec6c05f34:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/core (2014-07-18 12:19:20 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo

for you to fetch changes up to dcabb507fd3a2b19aed6b4068e2a954f5fd8de45:

  perf record: Store PERF_RECORD_FINISHED_ROUND only for nonempty rounds (2014-07-25 12:17:36 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

Developer stuff:

o More prep work to support Intel PT: (Adrian Hunter)
  - Polishing 'script' BTS output
  - 'inject' can specify --kallsym
  - VDSO is per machine, not a global var
  - Expose data addr lookup functions previously private to 'script'
  - Large mmap fixes in events processing

o Fix build on gcc 4.4.7 (Arnaldo Carvalho de Melo)

o Event ordering fixes (Jiri Olsa)

o Include standard stringify macros in power pc code (Sukadev Bhattiprolu)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Adrian Hunter (22):
      perf tools: Fix incorrect fd error comparison
      perf tools: Fix jump label always changing during tracing
      perf script: Improve srcline display for BTS
      perf script: Do not print dangling '=>' for BTS
      perf tools: Record whether a dso has data
      perf tools: Add dso__data_status_seen()
      perf tools: Add dsos__hit_all()
      perf tools: Add cpu to struct thread
      perf machine: Add ability to record the current tid for each cpu
      perf tools: Move rdtsc() function
      perf tools: Add dso__data_size()
      perf tools: Pass machine to vdso__dso_findnew()
      perf session: Add ability to 'skip' a non-piped event stream
      perf session: Add ability to skip 4GiB or more
      perf tools: Group VDSO global variables into a structure
      perf machine: Fix the lifetime of the VDSO temporary file
      perf tools: Add vdso__new()
      perf tools: Separate the VDSO map name from the VDSO dso name
      perf tools: Add dso__type()
      perf tools: Add thread parameter to vdso__dso_findnew()
      perf tools: Expose 'addr' functions so they can be reused
      perf inject: Add --kallsyms parameter

Arnaldo Carvalho de Melo (1):
      perf tools: Fix build on gcc 4.4.7

Jiri Olsa (3):
      perf session: Fix accounting of ordered samples queue
      perf record: Always force PERF_RECORD_FINISHED_ROUND event
      perf record: Store PERF_RECORD_FINISHED_ROUND only for nonempty rounds

Sukadev Bhattiprolu (1):
      perf powerpc: Include util/util.h and remove stringify macros

 tools/perf/Documentation/perf-inject.txt |  3 +
 tools/perf/arch/powerpc/util/header.c    |  4 +-
 tools/perf/arch/x86/util/tsc.c           |  9 +++
 tools/perf/builtin-inject.c              |  2 +
 tools/perf/builtin-record.c              |  7 ++-
 tools/perf/builtin-script.c              | 60 +++++++-------------
 tools/perf/builtin-trace.c               |  2 +-
 tools/perf/tests/perf-time-to-tsc.c      |  9 ---
 tools/perf/util/cloexec.c                |  9 ++-
 tools/perf/util/dso.c                    | 70 ++++++++++++++++++++---
 tools/perf/util/dso.h                    | 25 +++++++++
 tools/perf/util/event.c                  | 42 ++++++++++++++
 tools/perf/util/event.h                  | 10 ++++
 tools/perf/util/header.c                 | 51 +++++++++++++++--
 tools/perf/util/header.h                 |  2 +
 tools/perf/util/machine.c                | 58 +++++++++++++++++--
 tools/perf/util/machine.h                |  8 +++
 tools/perf/util/map.c                    |  9 +--
 tools/perf/util/map.h                    |  5 +-
 tools/perf/util/session.c                | 25 +++++----
 tools/perf/util/symbol-elf.c             | 35 +++++++++++-
 tools/perf/util/symbol-minimal.c         | 21 +++++++
 tools/perf/util/symbol.h                 |  2 +
 tools/perf/util/thread.c                 |  1 +
 tools/perf/util/thread.h                 |  1 +
 tools/perf/util/tsc.c                    |  5 ++
 tools/perf/util/tsc.h                    |  1 +
 tools/perf/util/vdso.c                   | 96 +++++++++++++++++++++++++-------
 tools/perf/util/vdso.h                   | 13 ++++-
 29 files changed, 470 insertions(+), 115 deletions(-)
