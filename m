Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab3A3Ort (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 09:47:49 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54457
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755312Ab3A3Orq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 09:47:46 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hugh Dickins <hughd@google.com>, Jiri Olsa <jolsa@redhat.com>,
        linuxppc-dev@ozlabs.org, Mel Gorman <mgorman@suse.de>,
        Michael Ellerman <ellerman@au1.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thomas Jarosch <thomas.jarosch@intra2net.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/21] perf/core improvements and fixes
Date: Wed, 30 Jan 2013 11:46:41 -0300
Message-Id: <1359557222-17547-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling.

	Namhyung, Jiri, the 'group report' patches are at acme/perf/group,
will send a pull req later if it survives further testing.

- Arnaldo

The following changes since commit a2d28d0c198b65fac28ea6212f5f8edc77b29c27:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2013-01-25 11:34:00 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 5809fde040de2afa477a6c593ce2e8fd2c11d9d3:

  perf header: Fix double fclose() on do_write(fd, xxx) failure (2013-01-30 10:40:44 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

. Fix some leaks in exit paths.

. Use memdup where applicable

. Remove some die() calls, allowing callers to handle exit paths
  gracefully.

. Correct typo in tools Makefile, fix from Borislav Petkov.

. Add 'perf bench numa mem' NUMA performance measurement suite, from Ingo Molnar.

. Handle dynamic array's element size properly, fix from Jiri Olsa.

. Fix memory leaks on evsel->counts, from Namhyung Kim.

. Make numa benchmark optional, allowing the build in machines where required
  numa libraries are not present, fix from Peter Hurley.

. Add interval printing in 'perf stat', from Stephane Eranian.

. Fix compile warnings in tests/attr.c, from Sukadev Bhattiprolu.

. Fix double free, pclose instead of fclose, leaks and double fclose errors
  found with the cppcheck tool, from Thomas Jarosch.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (8):
      perf tools: Stop using 'self' in strlist
      perf tools: Stop using 'self' in map.[ch]
      perf tools: Use memdup in map__clone
      perf kmem: Use memdup()
      perf header: Stop using die() calls when processing tracing data
      perf ui browser: Free browser->helpline() on ui_browser__hide()
      perf tests: Call machine__exit in the vmlinux matches kallsyms test
      perf tests: Fix leaks on PERF_RECORD_* test

Borislav Petkov (1):
      tools: Correct typo in tools Makefile

Ingo Molnar (1):
      perf: Add 'perf bench numa mem' NUMA performance measurement suite

Jiri Olsa (1):
      tools lib traceevent: Handle dynamic array's element size properly

Namhyung Kim (1):
      perf evsel: Fix memory leaks on evsel->counts

Peter Hurley (1):
      perf tools: Make numa benchmark optional

Stephane Eranian (2):
      perf evsel: Add prev_raw_count field
      perf stat: Add interval printing

Sukadev Bhattiprolu (1):
      perf tools, powerpc: Fix compile warnings in tests/attr.c

Thomas Jarosch (5):
      perf tools: Fix possible double free on error
      perf sort: Use pclose() instead of fclose() on pipe stream
      perf tools: Fix memory leak on error
      perf header: Fix memory leak for the "Not caching a kptr_restrict'ed /proc/kallsyms" case
      perf header: Fix double fclose() on do_write(fd, xxx) failure

 tools/Makefile                           |    2 +-
 tools/lib/traceevent/event-parse.c       |   39 +-
 tools/perf/Documentation/perf-stat.txt   |    4 +
 tools/perf/Makefile                      |   13 +
 tools/perf/arch/common.c                 |    1 +
 tools/perf/bench/bench.h                 |    1 +
 tools/perf/bench/numa.c                  | 1731 ++++++++++++++++++++++++++++++
 tools/perf/builtin-bench.c               |   17 +
 tools/perf/builtin-kmem.c                |    6 +-
 tools/perf/builtin-stat.c                |  158 ++-
 tools/perf/config/feature-tests.mak      |   11 +
 tools/perf/tests/attr.c                  |    5 +
 tools/perf/tests/open-syscall-all-cpus.c |    1 +
 tools/perf/tests/perf-record.c           |   12 +-
 tools/perf/tests/vmlinux-kallsyms.c      |    4 +-
 tools/perf/ui/browser.c                  |    2 +
 tools/perf/util/event.c                  |    4 +-
 tools/perf/util/evsel.c                  |   31 +
 tools/perf/util/evsel.h                  |    2 +
 tools/perf/util/header.c                 |   25 +-
 tools/perf/util/map.c                    |  118 +-
 tools/perf/util/map.h                    |   24 +-
 tools/perf/util/sort.c                   |    7 +-
 tools/perf/util/strlist.c                |   54 +-
 tools/perf/util/strlist.h                |   42 +-
 25 files changed, 2154 insertions(+), 160 deletions(-)
 create mode 100644 tools/perf/bench/numa.c
