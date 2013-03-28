Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270Ab3C1REF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:04:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36393 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042Ab3C1RC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:02:59 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Naohiro Aota <naota@elisp.net>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        William Cohen <wcohen@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 00/36] perf/core improvements and fixes
Date: Thu, 28 Mar 2013 14:02:00 -0300
Message-Id: <1364490156-32064-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Hi Ingo,

	Please consider pulling,

Best regards,

- Arnaldo

The following changes since commit 0a11953851213fd1d3eebcb68b4a537d458c70c2:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2013-03-21 11:06:12 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 065bbefdc72a6c85ef43a91222f146f1ca44362d:

  perf map browser: Exit just on well known key presses (2013-03-28 11:47:17 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

. Revert "perf sched: Handle PERF_RECORD_EXIT events" to get 'perf sched lat'
  back working.

. We don't use Newt anymore, just plain libslang.

. Kill a bunch of die() calls, from Namhyung Kim.

. Add --no-demangle to report/top, from Namhyung Kim.

. Fix dependency of the python binding wrt libtraceevent, from Naohiro Aota.

. Introduce per core aggregation in 'perf stat', from Stephane Eranian.

. Add memory profiling via PEBS, from Stephane Eranian.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Andi Kleen (3):
      perf/x86: Support CPU specific sysfs events
      perf/core: Add weighted samples
      perf tools: Add support for weight v7 (modified)

Arnaldo Carvalho de Melo (5):
      Revert "perf sched: Handle PERF_RECORD_EXIT events"
      perf tools: Convert needless static variable to local
      perf map browser: Use ui_browser__input_window()
      perf tools: Remove dependency on libnewt
      perf map browser: Exit just on well known key presses

Namhyung Kim (12):
      perf tools: Get rid of redundant _FILE_OFFSET_BITS definition
      perf tools: Let get_tracing_file() return NULL to indicate failure.
      perf tools: Get rid of malloc_or_die() in trace-event-info.c
      perf tools: Get rid of write_or_die() from trace-event-info.c
      perf tools: Get rid of die() calls from trace-event-info.c
      perf tools: Handle failure case in trace_report()
      perf tools: Get rid of malloc_or_die() in trace-event-read.c
      perf tools: Get rid of read_or_die() in trace-event-read.c
      perf tools: Get rid of die() calls in trace-data-read.c
      perf tools: Cleanup calc_data_size logic
      perf report: Add --no-demangle option
      perf tools: Fix output of symbol_daddr offset

Naohiro Aota (1):
      perf python: Fix dependency for python/perf.so

Stephane Eranian (15):
      perf stat: Refactor aggregation code
      perf stat: Rename --aggr-socket to --per-socket
      perf stat: Add per-core aggregation
      perf/x86: Improve sysfs event mapping with event string
      perf/x86: Add flags to event constraints
      perf: Add generic memory sampling interface
      perf/x86: Add memory profiling via PEBS Load Latency
      perf/x86: Export PEBS load latency threshold register to sysfs
      perf/x86: Add support for PEBS Precise Store
      perf: Add PERF_RECORD_MISC_MMAP_DATA to RECORD_MMAP
      perf tools: Add mem access sampling core support
      perf record: Add support for mem access profiling
      perf report: Add support for mem access profiling
      perf tools: Add new mem command for memory access profiling
      perf machine: Detect data vs. text mappings

 arch/x86/include/uapi/asm/msr-index.h         |   1 +
 arch/x86/kernel/cpu/perf_event.c              |  61 +++-
 arch/x86/kernel/cpu/perf_event.h              |  56 +++-
 arch/x86/kernel/cpu/perf_event_intel.c        |  35 ++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c     | 182 ++++++++++-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |   2 +-
 include/linux/perf_event.h                    |   6 +
 include/uapi/linux/perf_event.h               |  71 ++++-
 kernel/events/core.c                          |  15 +
 tools/perf/Documentation/perf-mem.txt         |  48 +++
 tools/perf/Documentation/perf-record.txt      |   6 +
 tools/perf/Documentation/perf-report.txt      |   6 +-
 tools/perf/Documentation/perf-stat.txt        |  10 +-
 tools/perf/Documentation/perf-top.txt         |   2 +-
 tools/perf/Makefile                           |  23 +-
 tools/perf/builtin-annotate.c                 |   2 +-
 tools/perf/builtin-diff.c                     |   7 +-
 tools/perf/builtin-mem.c                      | 242 +++++++++++++++
 tools/perf/builtin-record.c                   |   4 +-
 tools/perf/builtin-report.c                   | 147 ++++++++-
 tools/perf/builtin-sched.c                    |   1 -
 tools/perf/builtin-stat.c                     | 236 +++++++++------
 tools/perf/builtin-top.c                      |   5 +-
 tools/perf/builtin.h                          |   1 +
 tools/perf/command-list.txt                   |   1 +
 tools/perf/config/feature-tests.mak           |  12 +-
 tools/perf/perf.c                             |   4 +-
 tools/perf/perf.h                             |   1 +
 tools/perf/tests/hists_link.c                 |   4 +-
 tools/perf/ui/browser.c                       |   9 +-
 tools/perf/ui/browser.h                       |   1 +
 tools/perf/ui/browsers/annotate.c             |   1 -
 tools/perf/ui/browsers/hists.c                |   1 -
 tools/perf/ui/browsers/map.c                  |  60 ++--
 tools/perf/ui/browsers/scripts.c              |   1 -
 tools/perf/ui/tui/setup.c                     |  21 +-
 tools/perf/ui/ui.h                            |   2 +-
 tools/perf/util/annotate.h                    |   2 +-
 tools/perf/util/cpumap.c                      |  86 +++++-
 tools/perf/util/cpumap.h                      |  12 +
 tools/perf/util/event.h                       |   9 +
 tools/perf/util/evsel.c                       |  19 ++
 tools/perf/util/header.c                      |  11 +-
 tools/perf/util/hist.c                        | 110 ++++++-
 tools/perf/util/hist.h                        |  23 +-
 tools/perf/util/machine.c                     |  42 ++-
 tools/perf/util/machine.h                     |   3 +
 tools/perf/util/session.c                     |   8 +-
 tools/perf/util/sort.c                        | 414 +++++++++++++++++++++++++-
 tools/perf/util/sort.h                        |  12 +-
 tools/perf/util/symbol-elf.c                  |   9 +-
 tools/perf/util/symbol.c                      |   1 +
 tools/perf/util/symbol.h                      |   9 +-
 tools/perf/util/trace-event-info.c            | 347 ++++++++++++++-------
 tools/perf/util/trace-event-read.c            | 272 +++++++++++------
 tools/perf/util/trace-event.h                 |   2 +-
 tools/perf/util/util.h                        |   2 -
 57 files changed, 2217 insertions(+), 463 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-mem.txt
 create mode 100644 tools/perf/builtin-mem.c
