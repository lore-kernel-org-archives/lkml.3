Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205AbaELJ1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:27:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbaELJ1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:27:40 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Bernhard Rosenkraenzer <Bernhard.Rosenkranzer@linaro.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Dongsheng <yangds.fnst@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Irina Tirdea <irina.tirdea@intel.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [GIT PULL 0/6] perf/core improvements and fixes
Date: Mon, 12 May 2014 11:27:07 +0200
Message-Id: <1399886833-15472-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Ingo,
please consider pulling

thanks,
jirka


The following changes since commit 3e46d21285577a8c9e4c37f9b1002e567c440b28:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/core (2014-05-05 19:37:51 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-core-for-mingo

for you to fetch changes up to 13ce34df11833482cd698331fdbb3f8ced06340d:

  perf tools: Use tid for finding thread (2014-05-12 11:09:50 +0200)

----------------------------------------------------------------
perf/core improvements and fixes:

. Propagate exit status of a command line workload for
  record command (Namhyung Kim)

. Use tid for finding thread (Namhyung Kim)

. Clarify the output of perf sched map plus small sched
  command fixies (Dongsheng Yang)

Signed-off-by: Jiri Olsa <jolsa@kernel.org>

----------------------------------------------------------------
Dongsheng (3):
      perf tools: Add missing event for perf sched record.
      perf tools: Adapt the TASK_STATE_TO_CHAR_STR to new value in kernel space.
      perf tools: Clarify the output of perf sched map.

Namhyung Kim (3):
      perf record: Propagate exit status of a command line workload
      perf tools: Get rid of on_exit() feature test
      perf tools: Use tid for finding thread

 tools/perf/builtin-inject.c                     |   2 +-
 tools/perf/builtin-kmem.c                       |   2 +-
 tools/perf/builtin-record.c                     | 158 +++++++++---------------
 tools/perf/builtin-sched.c                      |  38 +++---
 tools/perf/config/Makefile                      |   8 --
 tools/perf/config/feature-checks/Makefile       |   4 -
 tools/perf/config/feature-checks/test-all.c     |   5 -
 tools/perf/config/feature-checks/test-on-exit.c |  16 ---
 tools/perf/tests/code-reading.c                 |   2 +-
 tools/perf/tests/hists_filter.c                 |   1 +
 tools/perf/tests/hists_link.c                   |   2 +
 tools/perf/util/build-id.c                      |   2 +-
 tools/perf/util/event.c                         |   2 +-
 13 files changed, 90 insertions(+), 152 deletions(-)
 delete mode 100644 tools/perf/config/feature-checks/test-on-exit.c
