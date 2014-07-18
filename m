Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbaGRERs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:17:48 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39906 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaGRERq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:17:46 -0400
Date: Fri, 18 Jul 2014 06:17:40 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        Joseph Schuchart <joseph.schuchart@tu-dresden.de>,
        Namhyung Kim <namhyung@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Ilsche <thomas.ilsche@tu-dresden.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL 00/33] perf/core improvements and fixes
Message-ID: <20140718041739.GA19662@gmail.com>
References: <1405613555-23380-1-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405613555-23380-1-git-send-email-acme@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling,
> 
> - Arnaldo
> 
> The following changes since commit ff2ebe46e15bd49d52b9c2f3fc77f3a9d94eac7b:
> 
>   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/core (2014-07-16 13:48:13 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo
> 
> for you to fetch changes up to 0b437860818dc717f6a9e8a5089223a8414f5fff:
> 
>   perf tools: Allow TSC conversion on any arch (2014-07-17 12:59:00 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> User visible:
> 
> o Support S/390 in 'perf kvm stat' (Alexander Yarygin)
> 
> Developer Stuff:
> 
> o Various fixes and prep work related to supporting Intel PT (Adrian Hunter)
> 
> o Introduce multiple debug variables control (Jiri Olsa)
> 
> o Add callchain and additional sample information for python scripts (Joseph Schuchart)
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Adrian Hunter (21):
>       perf machine: Fix the value used for unknown pids
>       perf script: Display PERF_RECORD_MISC_COMM_EXEC flag
>       perf record: Select comm_exec flag if supported
>       perf tools: Fix missing kernel map load
>       perf symbols: Fix missing GNU IFUNC symbols
>       perf inject: Fix build id injection
>       perf callchain: Fix appending a callchain from a previous sample
>       perf buildid-cache: Apply force option to copying kcore
>       perf symbols: Record whether a dso is 64-bit
>       perf symbols: Do not attempt to read data from kallsyms
>       perf symbols: Add ability to iterate over a dso's symbols
>       perf session: Flag if the event stream is entirely in memory
>       perf evlist: Pass mmap parameters in a struct
>       perf tools: Add feature test for __sync_val_compare_and_swap
>       perf tools: Add option macro OPT_CALLBACK_OPTARG
>       perf evsel: Add 'no_aux_samples' option
>       perf evsel: Add 'immediate' option
>       perf machine: Fix map groups of threads with unknown pids
>       perf thread: Allow deletion of a thread with no map groups
>       perf machine: Fix leak of 'struct thread' on error path
>       perf tools: Allow TSC conversion on any arch
> 
> Alexander Yarygin (4):
>       perf kvm: Use defines of kvm events
>       perf kvm: Move arch specific code into arch/
>       perf kvm: Add skip_event() for --duration option
>       perf kvm: Add stat support on s390
> 
> Jiri Olsa (5):
>       perf tools: Remove verbose from functions prototypes
>       perf tools: Move pr_* debug macros into debug object
>       perf tools: Factor eprintf to allow different debug variables
>       perf tools: Add --debug optionto set debug variable
>       perf tools: Remove needless getopt.h includes
> 
> Joseph Schuchart (3):
>       perf script: Add missing calls to Py_DECREF for return values
>       perf script: Add callchain to generic and tracepoint events
>       perf script: Provide additional sample information on generic events
> 
>  arch/s390/include/uapi/asm/Kbuild                  |   1 +
>  arch/s390/include/uapi/asm/kvm_perf.h              |  25 ++
>  arch/x86/include/uapi/asm/Kbuild                   |   1 +
>  arch/x86/include/uapi/asm/kvm_perf.h               |  16 +
>  tools/perf/Documentation/perf-kvm.txt              |  16 +-
>  tools/perf/Documentation/perf.txt                  |  10 +-
>  tools/perf/MANIFEST                                |   3 +
>  tools/perf/Makefile.perf                           |   3 +
>  tools/perf/arch/s390/Makefile                      |   2 +
>  tools/perf/arch/s390/util/kvm-stat.c               | 105 ++++++
>  tools/perf/arch/x86/Makefile                       |   1 +
>  tools/perf/arch/x86/tests/dwarf-unwind.c           |   1 +
>  tools/perf/arch/x86/util/kvm-stat.c                | 156 +++++++++
>  tools/perf/arch/x86/util/tsc.c                     |  22 +-
>  tools/perf/arch/x86/util/tsc.h                     |   3 -
>  tools/perf/arch/x86/util/unwind-libunwind.c        |   1 +
>  tools/perf/builtin-buildid-cache.c                 |   8 +-
>  tools/perf/builtin-evlist.c                        |   1 +
>  tools/perf/builtin-help.c                          |   1 +
>  tools/perf/builtin-inject.c                        |   3 +
>  tools/perf/builtin-kvm.c                           | 384 ++++++---------------
>  tools/perf/builtin-sched.c                         |  12 +-
>  tools/perf/builtin-timechart.c                     |   1 +
>  tools/perf/config/Makefile                         |   6 +
>  tools/perf/config/feature-checks/Makefile          |   4 +
>  tools/perf/config/feature-checks/test-all.c        |   5 +
>  .../feature-checks/test-sync-compare-and-swap.c    |  14 +
>  tools/perf/perf.c                                  |  13 +-
>  .../python/Perf-Trace-Util/lib/Perf/Trace/Core.py  |   3 +-
>  tools/perf/scripts/python/check-perf-trace.py      |   4 +-
>  .../perf/scripts/python/failed-syscalls-by-pid.py  |   2 +-
>  tools/perf/scripts/python/futex-contention.py      |   4 +-
>  tools/perf/scripts/python/net_dropmonitor.py       |   2 +-
>  tools/perf/scripts/python/netdev-times.py          |  26 +-
>  tools/perf/scripts/python/sched-migration.py       |  41 ++-
>  tools/perf/scripts/python/sctop.py                 |   2 +-
>  tools/perf/scripts/python/syscall-counts-by-pid.py |   2 +-
>  tools/perf/scripts/python/syscall-counts.py        |   2 +-
>  tools/perf/tests/dso-data.c                        |   1 +
>  tools/perf/tests/evsel-roundtrip-name.c            |   1 +
>  tools/perf/tests/evsel-tp-sched.c                  |   1 +
>  tools/perf/tests/open-syscall-tp-fields.c          |   1 +
>  tools/perf/tests/parse-events.c                    |   1 +
>  tools/perf/tests/parse-no-sample-id-all.c          |   1 +
>  tools/perf/tests/perf-time-to-tsc.c                |   3 +-
>  tools/perf/tests/sample-parsing.c                  |   1 +
>  tools/perf/tests/thread-mg-share.c                 |   1 +
>  tools/perf/ui/stdio/hist.c                         |   2 +-
>  tools/perf/util/callchain.c                        |   2 +-
>  tools/perf/util/data.c                             |   1 +
>  tools/perf/util/debug.c                            |  56 ++-
>  tools/perf/util/debug.h                            |  22 ++
>  tools/perf/util/dso.c                              |   1 +
>  tools/perf/util/dso.h                              |   1 +
>  tools/perf/util/event.c                            |  10 +-
>  tools/perf/util/evlist.c                           |  46 +--
>  tools/perf/util/evsel.c                            |  14 +-
>  tools/perf/util/evsel.h                            |   2 +
>  tools/perf/util/include/linux/kernel.h             |  21 --
>  tools/perf/util/kvm-stat.h                         | 140 ++++++++
>  tools/perf/util/machine.c                          |  63 +++-
>  tools/perf/util/map.c                              |  38 +-
>  tools/perf/util/map.h                              |  10 +-
>  tools/perf/util/parse-options.h                    |   5 +
>  tools/perf/util/probe-finder.c                     |   1 -
>  tools/perf/util/pstack.c                           |   1 +
>  tools/perf/util/python.c                           |   4 +-
>  tools/perf/util/record.c                           |  18 +-
>  .../perf/util/scripting-engines/trace-event-perl.c |   1 +
>  .../util/scripting-engines/trace-event-python.c    | 140 +++++++-
>  tools/perf/util/session.c                          |  14 +-
>  tools/perf/util/session.h                          |   3 +
>  tools/perf/util/symbol-elf.c                       |   6 +-
>  tools/perf/util/symbol-minimal.c                   |  22 ++
>  tools/perf/util/symbol.c                           |  20 +-
>  tools/perf/util/symbol.h                           |   4 +
>  tools/perf/util/thread.c                           |  12 +-
>  tools/perf/util/trace-event-info.c                 |   1 +
>  tools/perf/util/trace-event-read.c                 |   2 +-
>  tools/perf/util/tsc.c                              |  25 ++
>  tools/perf/util/tsc.h                              |  11 +
>  tools/perf/util/unwind-libdw.c                     |   1 +
>  tools/perf/util/unwind-libunwind.c                 |   1 +
>  tools/perf/util/util.c                             |   1 +
>  tools/perf/util/vdso.c                             |   1 +
>  85 files changed, 1170 insertions(+), 470 deletions(-)
>  create mode 100644 arch/s390/include/uapi/asm/kvm_perf.h
>  create mode 100644 arch/x86/include/uapi/asm/kvm_perf.h
>  create mode 100644 tools/perf/arch/s390/util/kvm-stat.c
>  create mode 100644 tools/perf/arch/x86/util/kvm-stat.c
>  create mode 100644 tools/perf/config/feature-checks/test-sync-compare-and-swap.c
>  create mode 100644 tools/perf/util/kvm-stat.h
>  create mode 100644 tools/perf/util/tsc.c
>  create mode 100644 tools/perf/util/tsc.h

Pulled, thanks a lot Arnaldo!

	Ingo
