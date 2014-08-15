Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaHOQuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:50:19 -0400
Received: from mail.kernel.org ([198.145.19.201]:44601 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbaHOQuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:50:16 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alex Converse <aconverse@google.com>, Andi Kleen <ak@linux.intel.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Arun Sharma <asharma@fb.com>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Elliott Hughes <enh@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Haren Myneni <hbabu@us.ibm.com>, Jiri Olsa <jolsa@redhat.com>,
        linuxppc-dev@lists.ozlabs.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Naohiro Aota <naota@elisp.net>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Stephane Eranian <eranian@google.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/18] perf/core improvements and fixes
Date: Fri, 15 Aug 2014 13:49:45 -0300
Message-Id: <1408121403-11919-1-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit f373da34282560c60f0c197690eecb1b2dc49fc0:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2014-08-14 10:38:40 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo

for you to fetch changes up to 759e612bf96627b64fcafe4174b3f6f2dedf2c0d:

  perf stat: Use strerror_r instead of strerror (2014-08-15 13:08:40 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

User visible:

. Warn user to rebuild target with debuginfo in 'perf probe' (Masami Hiramatsu)

. Don't truncate Intel style addresses in 'annotate'. (Alex Converse)

Developer stuff:

. Annotate PMU related list_head members with type info. (Cody P Schafer)

. Add the triplet used for arm64 by Android (Elliott Hughes)

. Replace thread unsafe strerror() with strerror_r() accross the
  whole tools/perf/ tree (Masami Hiramatsu)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Alex Converse (1):
      perf annotate: Don't truncate Intel style addresses

Cody P Schafer (1):
      perf tools: Annotate PMU related list_head members with type info

Elliott Hughes (1):
      perf tools: Add arm64 triplets

Masami Hiramatsu (14):
      perf probe: Warn user to rebuild target with debuginfo
      perf probe: Don't use strerror if strlist__add failed
      perf: Use strerror_r instead of strerror
      perf probe: Make error messages thread-safe
      perf util: Replace strerror with strerror_r for thread-safety
      perf top: Use strerror_r instead of strerror
      perf trace: Use strerror_r instead of strerror
      perf record: Use strerror_r instead of strerror
      perf test: Use strerror_r instead of strerror
      perf sched: Use strerror_r instead of strerror
      perf buildid-cache: Use strerror_r instead of strerror
      perf kvm: Use strerror_r instead of strerror
      perf help: Use strerror_r instead of strerror
      perf stat: Use strerror_r instead of strerror

Namhyung Kim (1):
      perf report: Relax -g option parsing not to limit the option order

 tools/perf/arch/common.c                  |  9 +++
 tools/perf/builtin-buildid-cache.c        |  7 ++-
 tools/perf/builtin-help.c                 | 20 +++++--
 tools/perf/builtin-kvm.c                  |  7 ++-
 tools/perf/builtin-probe.c                |  5 +-
 tools/perf/builtin-record.c               |  7 ++-
 tools/perf/builtin-sched.c                |  4 +-
 tools/perf/builtin-stat.c                 |  2 +-
 tools/perf/builtin-top.c                  |  2 +-
 tools/perf/builtin-trace.c                |  6 +-
 tools/perf/perf.c                         | 10 +++-
 tools/perf/tests/builtin-test.c           |  4 +-
 tools/perf/tests/mmap-basic.c             |  7 ++-
 tools/perf/tests/open-syscall-all-cpus.c  |  5 +-
 tools/perf/tests/open-syscall-tp-fields.c |  7 ++-
 tools/perf/tests/open-syscall.c           |  3 +-
 tools/perf/tests/perf-record.c            | 13 +++--
 tools/perf/tests/rdpmc.c                  |  6 +-
 tools/perf/tests/sw-clock.c               |  6 +-
 tools/perf/tests/task-exit.c              |  6 +-
 tools/perf/util/annotate.c                | 12 +++-
 tools/perf/util/callchain.c               | 95 +++++++++++++------------------
 tools/perf/util/cloexec.c                 |  6 +-
 tools/perf/util/data.c                    |  8 ++-
 tools/perf/util/debug.h                   |  3 +
 tools/perf/util/dso.c                     |  8 ++-
 tools/perf/util/evlist.c                  |  2 +-
 tools/perf/util/evsel.c                   |  7 ++-
 tools/perf/util/parse-events.c            |  5 +-
 tools/perf/util/pmu.c                     |  4 +-
 tools/perf/util/pmu.h                     |  6 +-
 tools/perf/util/probe-event.c             | 75 +++++++++++++-----------
 tools/perf/util/probe-finder.c            |  7 ++-
 tools/perf/util/run-command.c             |  9 ++-
 tools/perf/util/util.c                    |  5 +-
 35 files changed, 234 insertions(+), 154 deletions(-)
