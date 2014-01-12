Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbaALQlw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 11:41:52 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:49297 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaALQlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 11:41:49 -0500
Date: Sun, 12 Jan 2014 17:41:45 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>, Arun Sharma <asharma@fb.com>,
        Chunwei Chen <tuxoko@gmail.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        "David A. Long" <dave.long@linaro.org>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Oleg Nesterov <oleg@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, stable@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, systemtap@sourceware.org,
        yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/49] perf/core improvements and fixes
Message-ID: <20140112164145.GB21054@gmail.com>
References: <1388177225-17349-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388177225-17349-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> 
> Hi Ingo,
> 
> 	This one has the 34 out of 35 patches from the previous pull req, removing
> the 'perf stat' one about not printing stats for workloads we failed to start, that
> requires more thinking and introduced a regression.
> 
> 	I'm suppressing those first 34 patches, they are unchanged from last pull
> req.
> 
> 	Please consider pulling, the next one probably will be in 2014 :-)
> 
> Best Regards and happy holidays!
> 
> - Arnaldo
> 
> The following changes since commit fa6e8e5f7cbf85f364ebd5a90525dbbe9de2083b:
> 
>   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2013-12-18 14:07:26 +0100)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to 74cf249d5cf7de84c88cca69a2f13b13d500ff94:
> 
>   perf tools: Use zfree to help detect use after free bugs (2013-12-27 17:08:19 -0300)
> 
> ----------------------------------------------------------------
> User visible changes:
> 
> Improvements:
> 
> . Support showing source code, asking for variables to be collected
>   at probe time and other 'perf probe' operations that use DWARF information.
> 
>   This supports only binaries with debugging information at this time, detached
>   debuginfo (aka debuginfo packages) support should come in later patches.
>   (Masami Hiramatsu)
> 
> . Add a perf.data file header window in the 'perf report' TUI, associated
>   with the 'i' hotkey, providing a counterpart to the --header option in the
>   stdio UI. (Namhyung Kim)
> 
> . Guest related improvements to 'perf kvm', including allowing to
>   specify a directory with guest specific /proc information. (Dongsheng Yang)
> 
> . Print session information only if --stdio is given (Namhyung Kim)
> 
> Developer stuff:
> 
> Fixes:
> 
> . Get rid of a duplicate va_end() in error reporting (Namhyung Kim)
> 
> . If a hist entry doesn't have symbol information, compare it with its
>   address. Affects upcoming new feature (--cumulate) (Namhyung Kim)
> 
> Improvements:
> 
> . Make libtraceevent install target quieter (Jiri Olsa)
> 
> . Make tests/make output more compact (Jiri Olsa)
> 
> . Ignore generated files in feature-checks (Chunwei Chen)
> 
> New APIs:
> 
> . Introduce pevent_filter_strerror() in libtraceevent, similar in
>   purpose to libc's strerror() function. (Namhyung Kim)
> 
> Refactorings:
> 
> . Use perf_data_file methods to write output file in 'record' and
>   'inject' (Jiri Olsa)
> 
> . Use pr_*() functions where applicable in 'report' (Namhyumg Kim)
> 
> . Add 'machine' 'addr_location' struct to have full picture (machine,
>   thread, map, symbol, addr) for a (partially) resolved address, reducing
>   function signatures (Arnaldo Carvalho de Melo)
> 
> . Reduce code duplication in the histogram entry creation/insertion. (Arnaldo Carvalho de Melo)
> 
> . Auto allocate annotation histogram data structures, (Arnaldo Carvalho de Melo)
> 
> . No need to test against NULL before calling free, also set
>   freed memory in struct pointers to NULL, to help fixing use after
>   free bugs. (Arnaldo Carvalho de Melo>
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (19):
>       perf annotate: Auto allocate symbol per addr hist buckets
>       perf hists: Leave symbol addr hist bucket auto alloc to symbol layer
>       perf annotate: Add inc_samples method to addr_map_symbol
>       perf top: Use hist_entry__inc_addr_sample
>       perf annotate: Adopt methods from hists
>       perf annotate: Make symbol__inc_addr_samples private
>       perf report: Introduce helpers for processing callchains
>       perf record: Simplify perf_record__write
>       perf record: Rename 'perf_record' to plain 'record'
>       perf tools: Rename 'perf_record_opts' to 'record_opts
>       perf report: Rename 'perf_report' to 'report'
>       perf ui browser: Remove misplaced __maybe_unused
>       perf scripting python: Shorten function signatures
>       perf scripting perl: Shorten function signatures
>       perf mem: Remove unused parameter from dump_raw_samples()
>       perf symbols: Add 'machine' member to struct addr_location
>       perf tools: No need to test against NULL before calling free()
>       perf tools: Introduce zfree
>       perf tools: Use zfree to help detect use after free bugs
> 
> Chunwei Chen (1):
>       perf config: Ignore generated files in feature-checks
> 
> Dongsheng Yang (6):
>       perf kvm: Fix kvm report without guestmount.
>       perf tools: Add support for PERF_RECORD_MISC_GUEST_USER in thread__find_addr_map().
>       perf tools: Find the proc info under machine->root_dir.
>       perf tools: Set event->header.misc to PERF_RECORD_MISC_GUEST_USER if machine is guest.
>       perf tools: Use machine->pid for tgid if machine is guest.
>       perf tools: Do not synthesize the treads of default guest.
> 
> Jiri Olsa (11):
>       perf inject: Handle output file via perf_data_file object
>       perf record: Use perf_data_file__write for output file
>       perf tests: Factor make install tests
>       perf tools: Making QUIET_(CLEAN|INSTAL) variables global
>       tools lib traceevent: Remove print_app_build variable
>       tools lib traceevent: Use global QUIET_CC build output
>       tools lib traceevent: Add global QUIET_CC_FPIC build output
>       tools lib traceevent: Use global QUIET_LINK build output
>       tools lib traceevent: Use global QUIET_INSTALL build output
>       tools lib traceevent: Use global QUIET_CLEAN build output
>       tools lib traceevent: Use global 'O' processing code
> 
> Masami Hiramatsu (2):
>       perf probe: Expand given path to absolute path
>       perf probe: Support basic dwarf-based operations on uprobe events
> 
> Namhyung Kim (10):
>       perf sort: Compare addresses if no symbol info
>       perf sort: Do not compare dso again
>       perf hists: Do not pass period and weight to add_hist_entry()
>       tools lib traceevent: Introduce pevent_filter_strerror()
>       perf tools: Get rid of a duplicate va_end() in error reporting routine
>       perf report: Use pr_*() functions where applicable
>       perf report: Print session information only if --stdio is given
>       perf ui/tui: Protect windows by ui__lock
>       perf ui/tui: Split help message for perf top and report
>       perf ui/tui: Implement header window
> 
>  tools/lib/traceevent/Makefile                      |  85 +++----
>  tools/lib/traceevent/event-parse.c                 |  17 +-
>  tools/lib/traceevent/event-parse.h                 |   7 +-
>  tools/lib/traceevent/parse-filter.c                |  98 ++++----
>  tools/perf/Makefile.perf                           |   1 +
>  tools/perf/arch/common.c                           |   3 +-
>  tools/perf/builtin-annotate.c                      |  13 +-
>  tools/perf/builtin-diff.c                          |   2 +-
>  tools/perf/builtin-inject.c                        |  65 +++---
>  tools/perf/builtin-kvm.c                           |   6 +-
>  tools/perf/builtin-mem.c                           |   5 +-
>  tools/perf/builtin-probe.c                         |  17 +-
>  tools/perf/builtin-record.c                        |  94 ++++----
>  tools/perf/builtin-report.c                        | 259 +++++++--------------
>  tools/perf/builtin-sched.c                         |   2 +-
>  tools/perf/builtin-script.c                        |  22 +-
>  tools/perf/builtin-stat.c                          |   6 +-
>  tools/perf/builtin-timechart.c                     |   3 +-
>  tools/perf/builtin-top.c                           |  23 +-
>  tools/perf/builtin-trace.c                         |  14 +-
>  tools/perf/config/Makefile                         |   6 +-
>  tools/perf/config/feature-checks/.gitignore        |   2 +
>  tools/perf/config/feature-checks/Makefile          | 110 ++++-----
>  tools/perf/config/utilities.mak                    |   7 -
>  tools/perf/perf.h                                  |   2 +-
>  tools/perf/tests/code-reading.c                    |   2 +-
>  tools/perf/tests/keep-tracking.c                   |   2 +-
>  tools/perf/tests/make                              |  38 ++-
>  tools/perf/tests/open-syscall-tp-fields.c          |   2 +-
>  tools/perf/tests/perf-record.c                     |   2 +-
>  tools/perf/tests/perf-time-to-tsc.c                |   2 +-
>  tools/perf/ui/browser.c                            |   8 +-
>  tools/perf/ui/browser.h                            |   2 +
>  tools/perf/ui/browsers/header.c                    | 127 ++++++++++
>  tools/perf/ui/browsers/hists.c                     |  63 +++--
>  tools/perf/ui/browsers/scripts.c                   |   3 +-
>  tools/perf/ui/gtk/util.c                           |   3 +-
>  tools/perf/ui/stdio/hist.c                         |   2 +-
>  tools/perf/ui/tui/util.c                           |  19 +-
>  tools/perf/util/alias.c                            |   6 +-
>  tools/perf/util/annotate.c                         |  73 ++++--
>  tools/perf/util/annotate.h                         |   9 +-
>  tools/perf/util/callchain.h                        |   2 +-
>  tools/perf/util/cgroup.c                           |   2 +-
>  tools/perf/util/comm.c                             |   2 +-
>  tools/perf/util/debug.c                            |   1 -
>  tools/perf/util/dso.c                              |   9 +-
>  tools/perf/util/event.c                            |  45 ++--
>  tools/perf/util/evlist.c                           |   9 +-
>  tools/perf/util/evlist.h                           |   7 +-
>  tools/perf/util/evsel.c                            |  17 +-
>  tools/perf/util/evsel.h                            |   4 +-
>  tools/perf/util/header.c                           |  15 +-
>  tools/perf/util/help.c                             |   7 +-
>  tools/perf/util/hist.c                             |  27 +--
>  tools/perf/util/hist.h                             |   3 -
>  tools/perf/util/machine.c                          |  12 +-
>  tools/perf/util/parse-events.c                     |   8 +-
>  tools/perf/util/pmu.c                              |   2 +-
>  tools/perf/util/probe-event.c                      | 234 +++++++++++++------
>  tools/perf/util/probe-event.h                      |   1 +
>  tools/perf/util/probe-finder.c                     |  33 +--
>  tools/perf/util/record.c                           |   9 +-
>  .../perf/util/scripting-engines/trace-event-perl.c |  22 +-
>  .../util/scripting-engines/trace-event-python.c    |  28 +--
>  tools/perf/util/session.c                          |  33 +--
>  tools/perf/util/session.h                          |   2 +-
>  tools/perf/util/sort.c                             |  22 +-
>  tools/perf/util/srcline.c                          |   6 +-
>  tools/perf/util/strbuf.c                           |   2 +-
>  tools/perf/util/strfilter.c                        |   2 +-
>  tools/perf/util/string.c                           |   2 +-
>  tools/perf/util/strlist.c                          |   3 +-
>  tools/perf/util/svghelper.c                        |   5 +-
>  tools/perf/util/symbol-elf.c                       |   2 +-
>  tools/perf/util/symbol-minimal.c                   |   3 +-
>  tools/perf/util/symbol.c                           |  11 +-
>  tools/perf/util/symbol.h                           |   1 +
>  tools/perf/util/thread_map.c                       |  20 +-
>  tools/perf/util/top.c                              |   2 +-
>  tools/perf/util/top.h                              |   2 +-
>  tools/perf/util/trace-event-info.c                 |  10 +-
>  tools/perf/util/trace-event-scripting.c            |   3 +-
>  tools/perf/util/trace-event.h                      |   1 -
>  tools/perf/util/util.h                             |   2 +
>  tools/perf/util/values.c                           |  14 +-
>  tools/scripts/Makefile.include                     |   4 +
>  87 files changed, 1001 insertions(+), 882 deletions(-)
>  create mode 100644 tools/perf/config/feature-checks/.gitignore
>  create mode 100644 tools/perf/ui/browsers/header.c

Pulled, thanks a lot Arnaldo!

	Ingo
