Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbaGPUEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:04:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbaGPUEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:04:06 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Yann Droneaud <ydroneaud@opteya.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [GIT PULL 00/13] perf/core improvements and fixes
Date: Wed, 16 Jul 2014 22:02:36 +0200
Message-Id: <1405540969-18975-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Ingo,
please consider pulling

thanks,
jirka


The following changes since commit ff2ebe46e15bd49d52b9c2f3fc77f3a9d94eac7b:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/core (2014-07-16 13:48:13 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-core-for-mingo

for you to fetch changes up to 5ce0a7940a89ad7028dfada935b0cc64d307ea3f:

  perf tools: Add a --no-desc flag to perf list (2014-07-16 21:35:07 +0200)

----------------------------------------------------------------
perf/core improvements and fixes:

. Add support for full Intel event lists (Andi Kleen)

. Update attr test with PERF_FLAG_FD_CLOEXEC flag (Jiri Olsa)

. Enable close-on-exec flag on perf file descriptor (Yann Droneaud)

Signed-off-by: Jiri Olsa <jolsa@kernel.org>

----------------------------------------------------------------
Andi Kleen (11):
      perf tools: Add jsmn `jasmine' JSON parser
      perf tools: Add support for text descriptions of events and alias add
      perf tools: Update perf list to output descriptions
      perf tools: Allow events with dot
      perf tools: Add support for reading JSON event files
      perf tools: Automatically look for event file name for cpu
      perf tools: Add perf download to download event files
      perf tools: Query terminal width and use in perf list
      perf tools: Add a new pmu interface to iterate over all events
      perf tests: Add test case for alias and JSON parsing
      perf tools: Add a --no-desc flag to perf list

Jiri Olsa (1):
      perf tests: Update attr test with PERF_FLAG_FD_CLOEXEC flag

Yann Droneaud (1):
      perf tools: Enable close-on-exec flag on perf file descriptor

 tools/perf/Documentation/perf-download.txt |  31 +++
 tools/perf/Documentation/perf-list.txt     |  29 ++-
 tools/perf/Documentation/perf-record.txt   |   8 +-
 tools/perf/Documentation/perf-stat.txt     |   8 +-
 tools/perf/Makefile.perf                   |  13 +-
 tools/perf/arch/x86/util/header.c          |  19 +-
 tools/perf/bench/mem-memcpy.c              |   4 +-
 tools/perf/bench/mem-memset.c              |   4 +-
 tools/perf/builtin-list.c                  |  16 +-
 tools/perf/builtin-record.c                |   3 +
 tools/perf/builtin-sched.c                 |   4 +-
 tools/perf/builtin-stat.c                  |   2 +
 tools/perf/perf-download.sh                |  56 ++++++
 tools/perf/tests/aliases.c                 |  58 ++++++
 tools/perf/tests/attr/base-record          |   3 +-
 tools/perf/tests/attr/base-stat            |   3 +-
 tools/perf/tests/bp_signal.c               |   4 +-
 tools/perf/tests/bp_signal_overflow.c      |   4 +-
 tools/perf/tests/builtin-test.c            |   4 +
 tools/perf/tests/rdpmc.c                   |   4 +-
 tools/perf/tests/tests.h                   |   1 +
 tools/perf/util/cache.h                    |   1 +
 tools/perf/util/cloexec.c                  |  57 ++++++
 tools/perf/util/cloexec.h                  |   6 +
 tools/perf/util/evsel.c                    |  12 +-
 tools/perf/util/jevents.c                  | 286 ++++++++++++++++++++++++++
 tools/perf/util/jevents.h                  |   9 +
 tools/perf/util/jsmn.c                     | 313 +++++++++++++++++++++++++++++
 tools/perf/util/jsmn.h                     |  67 ++++++
 tools/perf/util/json.c                     | 155 ++++++++++++++
 tools/perf/util/json.h                     |  13 ++
 tools/perf/util/pager.c                    |  15 ++
 tools/perf/util/parse-events.c             |   4 +-
 tools/perf/util/parse-events.h             |   2 +-
 tools/perf/util/parse-events.l             |   3 +-
 tools/perf/util/pmu.c                      | 153 +++++++++++---
 tools/perf/util/pmu.h                      |   6 +-
 tools/perf/util/record.c                   |   9 +-
 38 files changed, 1324 insertions(+), 65 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-download.txt
 create mode 100755 tools/perf/perf-download.sh
 create mode 100644 tools/perf/tests/aliases.c
 create mode 100644 tools/perf/util/cloexec.c
 create mode 100644 tools/perf/util/cloexec.h
 create mode 100644 tools/perf/util/jevents.c
 create mode 100644 tools/perf/util/jevents.h
 create mode 100644 tools/perf/util/jsmn.c
 create mode 100644 tools/perf/util/jsmn.h
 create mode 100644 tools/perf/util/json.c
 create mode 100644 tools/perf/util/json.h
