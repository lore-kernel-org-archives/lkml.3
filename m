Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbaJ3GgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:36:05 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56922 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaJ3GgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:36:03 -0400
Date: Thu, 30 Oct 2014 07:35:57 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Anton Blanchard <anton@au1.ibm.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>, Jiri Olsa <jolsa@redhat.com>,
        Li Zefan <lizefan@huawei.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Waiman Long <Waiman.Long@hp.com>, Wang Nan <wangnan0@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/25] perf/core improvements
Message-ID: <20141030063557.GB29004@gmail.com>
References: <1414591597-2763-1-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414591597-2763-1-git-send-email-acme@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling, as suggested, this is done on top
> of my last +perf-urgent-for-mingo tag.
> 
> - Arnaldo
> 
> The following changes since commit 4cdcc33db2f0455f297b4e14e434ba311ec5ca06:
> 
>   perf probe: Trivial typo fix for --demangle (2014-10-29 10:30:18 -0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo
> 
> for you to fetch changes up to a293829df788ae96a174b315010d4b56a10e5114:
> 
>   perf session: Add perf_session__deliver_synth_event() (2014-10-29 11:36:15 -0200)
> 
> ----------------------------------------------------------------
> perf/core improvements:
> 
> User visible:
> 
> * Don't open the DWARF info multiple times, keeping instead a dwfl handle
>   in struct dso, greatly speeding up 'perf report' on powerpc. (Sukadev Bhattiprolu)
> 
> * Introduce PARSE_OPT_DISABLED option flag and use it to avoid showing
>   undersired options in tools that provides frontends to 'perf record', like
>   sched, kvm, etc (Namhyung Kim)
> 
> Infrastructure:
> 
> * More Intel PT work, including a facility to export sample data (comms,
>   threads, symbol names, etc) in a database friendly way, with an script to use
>   this to create a postgresql database. (Adrian Hunter)
> 
> * Use make sure that thread->mg->machine points to the machine where
>   the thread exists (it was being set only for the kmaps kernel modules
>   case, do it as well for the mmaps) and use it to shorten function
>   signatures (Arnaldo Carvalho de Melo)
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Adrian Hunter (9):
>       perf pmu: Let pmu's with no events show up on perf list
>       perf tools: Build programs to copy 32-bit compatibility
>       perf tools: Add support for 32-bit compatibility VDSOs
>       perf tools: Do not attempt to run perf-read-vdso32 if it wasn't built
>       perf tools: Add facility to export data in database-friendly way
>       perf scripting python: Extend interface to export data in a database-friendly way
>       perf script: Add Python script to export to postgresql
>       perf tools: Add id index
>       perf session: Add perf_session__deliver_synth_event()
> 
> Arnaldo Carvalho de Melo (8):
>       perf tools: Set thread->mg.machine in all places
>       perf tools: A thread's machine can be found via thread->mg->machine
>       perf thread: Adopt resolve_callchain method from machine
>       perf callchains: Use thread->mg->machine
>       perf tests: Remove misplaced __maybe_unused
>       perf tests: Use thread->mg->machine
>       perf pmu: Add proper error handling to print_pmu_events()
>       perf tools: Use evlist__for_each in a few remaining places
> 
> Masami Hiramatsu (1):
>       perf probe: Add --quiet option to suppress output result message
> 
> Namhyung Kim (5):
>       perf tools: Add PARSE_OPT_DISABLED flag
>       perf tools: Export usage string and option table of perf record
>       perf kvm: Print kvm specific --help output
>       perf tools: Add support for exclusive option
>       perf probe: Use PARSE_OPT_EXCLUSIVE flag
> 
> Sukadev Bhattiprolu (1):
>       perf tools powerpc: Cache the DWARF debug info
> 
> Wang Nan (1):
>       perf tools: Ensure return negative value when write header error
> 
>  tools/perf/Makefile.perf                           |  40 ++-
>  tools/perf/arch/powerpc/util/skip-callchain-idx.c  |  38 ++-
>  tools/perf/builtin-inject.c                        |   4 +-
>  tools/perf/builtin-kvm.c                           |  25 ++
>  tools/perf/builtin-probe.c                         |  65 ++--
>  tools/perf/builtin-record.c                        |   7 +-
>  tools/perf/builtin-script.c                        |   8 +-
>  tools/perf/builtin-timechart.c                     |   9 +-
>  tools/perf/builtin-trace.c                         |   6 +-
>  tools/perf/config/Makefile                         |  29 +-
>  tools/perf/config/Makefile.arch                    |   8 +
>  tools/perf/config/feature-checks/Makefile          |  10 +-
>  tools/perf/config/feature-checks/test-compile.c    |   4 +
>  tools/perf/perf-read-vdso.c                        |  34 ++
>  tools/perf/perf.h                                  |   3 +
>  .../scripts/python/bin/export-to-postgresql-record |   8 +
>  .../scripts/python/bin/export-to-postgresql-report |  24 ++
>  tools/perf/scripts/python/export-to-postgresql.py  | 360 +++++++++++++++++++++
>  tools/perf/tests/code-reading.c                    |  13 +-
>  tools/perf/tests/dwarf-unwind.c                    |  18 +-
>  tools/perf/tests/hists_filter.c                    |   2 +-
>  tools/perf/tests/mmap-thread-lookup.c              |   2 +-
>  tools/perf/util/build-id.c                         |   3 +-
>  tools/perf/util/callchain.c                        |   4 +-
>  tools/perf/util/callchain.h                        |   6 +-
>  tools/perf/util/comm.h                             |   4 +
>  tools/perf/util/db-export.c                        | 270 ++++++++++++++++
>  tools/perf/util/db-export.h                        |  86 +++++
>  tools/perf/util/dso.h                              |   6 +
>  tools/perf/util/event.c                            |  20 +-
>  tools/perf/util/event.h                            |  16 +-
>  tools/perf/util/evlist.c                           |  28 +-
>  tools/perf/util/evsel.h                            |   5 +
>  tools/perf/util/find-vdso-map.c                    |  30 ++
>  tools/perf/util/header.c                           |   7 +-
>  tools/perf/util/machine.c                          |  55 ++--
>  tools/perf/util/machine.h                          |  17 +-
>  tools/perf/util/map.c                              |   8 +-
>  tools/perf/util/map.h                              |   4 +-
>  tools/perf/util/parse-options.c                    |  78 ++++-
>  tools/perf/util/parse-options.h                    |   4 +
>  tools/perf/util/pmu.c                              |  41 ++-
>  tools/perf/util/pmu.h                              |   1 +
>  tools/perf/util/probe-event.c                      |  18 +-
>  .../util/scripting-engines/trace-event-python.c    | 292 ++++++++++++++++-
>  tools/perf/util/session.c                          | 141 +++++++-
>  tools/perf/util/session.h                          |  15 +
>  tools/perf/util/thread.c                           |   6 +-
>  tools/perf/util/thread.h                           |   6 +-
>  tools/perf/util/tool.h                             |   3 +-
>  tools/perf/util/unwind-libdw.c                     |   8 +-
>  tools/perf/util/unwind-libunwind.c                 |  17 +-
>  tools/perf/util/unwind.h                           |   2 -
>  tools/perf/util/vdso.c                             | 217 +++++++++++--
>  tools/perf/util/vdso.h                             |   4 +-
>  55 files changed, 1873 insertions(+), 266 deletions(-)
>  create mode 100644 tools/perf/config/feature-checks/test-compile.c
>  create mode 100644 tools/perf/perf-read-vdso.c
>  create mode 100644 tools/perf/scripts/python/bin/export-to-postgresql-record
>  create mode 100644 tools/perf/scripts/python/bin/export-to-postgresql-report
>  create mode 100644 tools/perf/scripts/python/export-to-postgresql.py
>  create mode 100644 tools/perf/util/db-export.c
>  create mode 100644 tools/perf/util/db-export.h
>  create mode 100644 tools/perf/util/find-vdso-map.c

Pulled, thanks a lot Arnaldo!

	Ingo
