Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab3CUKIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 06:08:46 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:38327 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab3CUKIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 06:08:44 -0400
Date: Thu, 21 Mar 2013 11:08:38 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@suse.de>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Frederik Deweerdt <frederik.deweerdt@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Olsa <jolsa@redhat.com>,
        liguang <lig.fnst@cn.fujitsu.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/54] perf/core improvements and fixes
Message-ID: <20130321100838.GB15175@gmail.com>
References: <1363623939-10748-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363623939-10748-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> 
> Hi Ingo,
> 
> 	Please consider pulling,
> 
> - Arnaldo
> 
> The following changes since commit d1398ccfec56e54010476efd6a316427d29045a6:
> 
>   perf tools: Fix LIBNUMA build with glibc 2.12 and older. (2013-03-14 08:06:21 -0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to bc96b361cbf90e61d2665b1305cd2c4ac1fd9cfc:
> 
>   perf tests: Add a test case for checking sw clock event frequency (2013-03-18 11:43:16 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> . Honor parallel jobs, fix from Borislav Petkov
> 
> . Introduce tools/lib/lk library, initially just removing duplication
>   among tools/perf and tools/vm. from Borislav Petkov
> 
> . Fix build on non-glibc systems due to libio.h absence, from Cody P Schafer.
> 
> . Remove some perf_session and tracing dead code, from David Ahern.
> 
> . Introduce perf stat --repeat forever, from Frederik Deweerdt.
> 
> . Add perf test entries for checking --cpu in record and stat, from Jiri Olsa.
> 
> . Add perf test entries for checking breakpoint overflow signal handler issues,
>   from Jiri Olsa.
> 
> . Add perf test entry for for checking number of EXIT events, from Namhyung Kim.
> 
> . Simplify some perf_evlist methods and to allow 'stat' to share code with
>   'record' and 'trace'.
> 
> . Remove dead code in related to libtraceevent integration, from Namhyung Kim.
> 
> . Event group view for 'annotate' in --stdio, --tui and --gtk, from Namhyung Kim.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (1):
>       perf stat: Introduce evlist methods to allocate/free the stats
> 
> Borislav Petkov (7):
>       perf tools: Remove a write-only variable in the debugfs code
>       perf tools: Honor parallel jobs
>       perf tools: Correct Makefile.include
>       perf tools: Introduce tools/lib/lk library
>       perf tools: Extract perf-specific stuff from debugfs.c
>       tools/vm: Switch to liblk library
>       tools lib lk: Fix _FORTIFY_SOURCE builds
> 
> Cody P Schafer (1):
>       perf tools: Fix build on non-glibc systems due to libio.h absence
> 
> David Ahern (3):
>       perf tools: Remove unused tracing functions
>       perf session: Remove unused perf_session__remove_thread method
>       perf machine: Move machine__remove_thread and make static
> 
> Frederik Deweerdt (1):
>       perf stat: Introduce --repeat forever
> 
> Jiri Olsa (6):
>       perf tests: Make attr script verbose friendly
>       perf tests: Make attr script test event cpu
>       perf tests: Add attr record -C cpu test
>       perf tests: Add attr stat -C cpu test
>       perf tests: Test breakpoint overflow signal handler
>       perf tests: Test breakpoint overflow signal handler counts
> 
> Namhyung Kim (33):
>       perf evlist: Remove cpus and threads arguments from perf_evlist__new()
>       perf evlist: Use cpu_map__nr() helper
>       perf evlist: Add thread_map__nr() helper
>       perf evlist: Pass struct perf_target to perf_evlist__prepare_workload()
>       perf evlist: Do not pass struct record_opts to perf_evlist__prepare_workload()
>       perf evlist: Add want_signal parameter to perf_evlist__prepare_workload()
>       perf stat: Use perf_evlist__prepare/start_workload()
>       perf annotate: Pass evsel instead of evidx on annotation functions
>       perf annotate: Add a comment on the symbol__parse_objdump_line()
>       perf annotate: Factor out disasm__calc_percent()
>       perf annotate: Cleanup disasm__calc_percent()
>       perf annotate: Add basic support to event group view
>       perf evsel: Introduce perf_evsel__is_group_event() helper
>       perf annotate: Factor out struct source_line_percent
>       perf annotate: Support event group view for --print-line
>       perf annotate browser: Make browser_disasm_line->percent an array
>       perf annotate browser: Use disasm__calc_percent()
>       perf annotate/gtk: Support event group view on GTK
>       perf annotate browser: Support event group view on TUI
>       perf trace: Get rid of a duplicate code
>       perf tools: Remove unused trace_read_data function
>       perf tools: Remove unused struct definitions
>       perf tools: Remove unnecessary calc_data_size variable
>       perf tools: Remove unused macro definitions
>       perf tools: Remove duplicated page_size definition
>       perf evsel: Cleanup perf_evsel__exit()
>       perf evlist: Introduce perf_evlist__close()
>       perf trace: Free evlist resources properly on return path
>       perf record: Fixup return path of cmd_record()
>       perf tests: Fixup return path of open-syscall-tp-fields test case
>       perf tests: Fixup return path of perf record test case
>       perf test: Add test case for checking number of EXIT events
>       perf tests: Add a test case for checking sw clock event frequency
> 
> Wei Yongjun (1):
>       perf report: Remove duplicated include
> 
> liguang (1):
>       perf tools: Sort command-list.txt alphabetically
> 
>  Makefile                                   |   4 +-
>  tools/Makefile                             |  16 +-
>  tools/lib/lk/Makefile                      |  35 ++++
>  tools/{perf/util => lib/lk}/debugfs.c      |  49 ++----
>  tools/lib/lk/debugfs.h                     |  29 ++++
>  tools/perf/Documentation/perf-annotate.txt |   3 +
>  tools/perf/Documentation/perf-stat.txt     |   2 +-
>  tools/perf/MANIFEST                        |   1 +
>  tools/perf/Makefile                        |  38 ++++-
>  tools/perf/arch/arm/util/dwarf-regs.c      |   5 +-
>  tools/perf/arch/powerpc/util/dwarf-regs.c  |   5 +-
>  tools/perf/arch/s390/util/dwarf-regs.c     |   2 +-
>  tools/perf/arch/sh/util/dwarf-regs.c       |   2 +-
>  tools/perf/arch/sparc/util/dwarf-regs.c    |   2 +-
>  tools/perf/arch/x86/util/dwarf-regs.c      |   2 +-
>  tools/perf/builtin-annotate.c              |  23 ++-
>  tools/perf/builtin-kvm.c                   |   2 +-
>  tools/perf/builtin-probe.c                 |   2 +-
>  tools/perf/builtin-record.c                |  11 +-
>  tools/perf/builtin-report.c                |   3 +-
>  tools/perf/builtin-stat.c                  | 164 +++++++++---------
>  tools/perf/builtin-top.c                   |   4 +-
>  tools/perf/builtin-trace.c                 |  28 +--
>  tools/perf/command-list.txt                |  14 +-
>  tools/perf/perf.c                          |   8 +-
>  tools/perf/tests/attr.c                    |   9 +-
>  tools/perf/tests/attr.py                   |   5 +-
>  tools/perf/tests/attr/base-record          |   1 +
>  tools/perf/tests/attr/base-stat            |   1 +
>  tools/perf/tests/attr/test-record-C0       |  13 ++
>  tools/perf/tests/attr/test-stat-C0         |   9 +
>  tools/perf/tests/bp_signal.c               | 186 ++++++++++++++++++++
>  tools/perf/tests/bp_signal_overflow.c      | 126 ++++++++++++++
>  tools/perf/tests/builtin-test.c            |  16 ++
>  tools/perf/tests/evsel-roundtrip-name.c    |   4 +-
>  tools/perf/tests/hists_link.c              |   2 +-
>  tools/perf/tests/mmap-basic.c              |   4 +-
>  tools/perf/tests/open-syscall-tp-fields.c  |  10 +-
>  tools/perf/tests/parse-events.c            |   4 +-
>  tools/perf/tests/perf-record.c             |   9 +-
>  tools/perf/tests/sw-clock.c                | 119 +++++++++++++
>  tools/perf/tests/task-exit.c               | 123 ++++++++++++++
>  tools/perf/tests/tests.h                   |   4 +
>  tools/perf/ui/browsers/annotate.c          | 157 ++++++++++-------
>  tools/perf/ui/browsers/hists.c             |   6 +-
>  tools/perf/ui/gtk/annotate.c               |  26 ++-
>  tools/perf/ui/gtk/hists.c                  |   7 +-
>  tools/perf/ui/hist.c                       |   7 +-
>  tools/perf/util/annotate.c                 | 262 ++++++++++++++++++++++-------
>  tools/perf/util/annotate.h                 |  49 +++---
>  tools/perf/util/debugfs.h                  |  12 --
>  tools/perf/util/evlist.c                   |  73 ++++----
>  tools/perf/util/evlist.h                   |   9 +-
>  tools/perf/util/evsel.c                    |  13 +-
>  tools/perf/util/evsel.h                    |  25 +++
>  tools/perf/util/header.c                   |   4 +-
>  tools/perf/util/hist.h                     |   5 +-
>  tools/perf/util/machine.c                  |  22 +--
>  tools/perf/util/machine.h                  |   1 -
>  tools/perf/util/parse-events.c             |   2 +-
>  tools/perf/util/probe-event.c              |   2 +-
>  tools/perf/util/python-ext-sources         |   1 -
>  tools/perf/util/session.c                  |  12 --
>  tools/perf/util/session.h                  |   1 -
>  tools/perf/util/setup.py                   |   3 +-
>  tools/perf/util/thread_map.h               |   5 +
>  tools/perf/util/trace-event-info.c         |  33 +---
>  tools/perf/util/trace-event-parse.c        |  37 ----
>  tools/perf/util/trace-event-read.c         | 201 ----------------------
>  tools/perf/util/trace-event.h              |   4 -
>  tools/perf/util/util.c                     |  27 +++
>  tools/perf/util/util.h                     |   7 +-
>  tools/scripts/Makefile.include             |   6 +-
>  tools/vm/Makefile                          |  17 +-
>  tools/vm/page-types.c                      |  85 +---------
>  75 files changed, 1432 insertions(+), 788 deletions(-)
>  create mode 100644 tools/lib/lk/Makefile
>  rename tools/{perf/util => lib/lk}/debugfs.c (68%)
>  create mode 100644 tools/lib/lk/debugfs.h
>  create mode 100644 tools/perf/tests/attr/test-record-C0
>  create mode 100644 tools/perf/tests/attr/test-stat-C0
>  create mode 100644 tools/perf/tests/bp_signal.c
>  create mode 100644 tools/perf/tests/bp_signal_overflow.c
>  create mode 100644 tools/perf/tests/sw-clock.c
>  create mode 100644 tools/perf/tests/task-exit.c
>  delete mode 100644 tools/perf/util/debugfs.h

Pulled, thanks a lot Arnaldo!

There was a merge conflict in tools/Makefile, I resolved it - please 
double check I did it right.

On a related note, we still have these commits in tip:perf/x86:

 a4a607086d86 perf/x86: Mark nhm_events_attrsas static
 fc7d3e64651e perf/x86: Fix type to address build warning
 59e1a00ac0e4 perf: Add PERF_RECORD_MISC_MMAP_DATA to RECORD_MMAP
 6c538c1cc9f0 perf/x86: Add support for PEBS Precise Store
 5a54b18a9e9c perf/x86: Export PEBS load latency threshold register to sysfs
 66172a094e52 perf/x86: Add memory profiling via PEBS Load Latency
 4b18e27234ad perf: Add generic memory sampling interface
 648865900cd6 perf/core: Add weighted samples
 1a4e0aca7416 perf/x86: Add flags to event constraints
 5256a7d63866 perf/x86: Improve sysfs event mapping with event string
 4c38cd7b6641 perf/x86: Support CPU specific sysfs events

... which merged fine originally but they now conflict with ongoing 
tooling changes and are bitrotting quickly with every new perf/core
pull I do. Would be nice to resolve this problem.

Thanks,

	Ingo
