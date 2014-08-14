Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbaHNIlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:41:00 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:53119 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaHNIkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:40:55 -0400
Date: Thu, 14 Aug 2014 10:40:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Alex Snast <asnast@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Minchan Kim <minchan@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Naohiro Aota <naota@elisp.net>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/41] perf/core improvements and fixes
Message-ID: <20140814084049.GA7089@gmail.com>
References: <1407970107-24540-1-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407970107-24540-1-git-send-email-acme@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling, more to come! :-)
> 
> - Arnaldo
> 
> The following changes since commit ddcd0973fe02aad3d4bdc59dd0f1db90f51105a9:
> 
>   perf/x86/uncore: Rename IvyTown to IvyBridge-EP (2014-08-13 07:51:18 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo
> 
> for you to fetch changes up to 1c65056c547141a0cb52fb8e6056f63524d2bbf2:
> 
>   perf evlist: Add perf_evlist__enable_event_idx() (2014-08-13 19:23:48 -0300)
> 
> ----------------------------------------------------------------
> perf/probe fixes and improvements:
> 
> User visible changes:
> 
> . Do not show +/- callchain expansion when there are no childs (top/report) (Namhyung Kim)
> 
> . Fix -z and add respective 'z' hotkey to zero samples before refresh
>   in 'perf top' (Namhyung Kim)
> 
> . Capability probing fixes, improving the detection of
>   kernel features for non-priviledged users (Adrian Hunter)
> 
> . Add beautifier for mremap flags param in 'trace' (Alex Snast)
> 
> . Fix --list and --del options to show events when just uprobes is
>   enabled (Masami Hiramatsu)
> 
> . perf script: Allow callchains if any event samples them
> 
> . Don't look for kernel idle symbols in all DSOs in 'perf top' (Arnaldo Carvalho de Melo)
> 
> . Add cpu_startup_entry to the list of kernel idle symbols (Arnaldo Carvalho de Melo)
> 
> . 'perf top' terminal output fixes (Jiri Olsa)
> 
> . Fix stdin handling for 'perf kvm stat live' (Jiri Olsa)
> 
> . Fix missing label symbols (Adrian Hunter)
> 
> . Don't demangle C++ parameters and such by default, only in
>   --verbose mode (Namhyung Kim)
> 
> . Set proper sort__mode for the branch option (Naohiro Aota)
> 
> . Check recorded kernel version when finding vmlinux (Namhyung Kim)
> 
> Developer Stuff:
> 
> . More prep work for intel PT (Adrian Hunter)
> 
> . Fix possible memory leaks (Namhyung Kim)
> 
> . Fix a memory leak in vmlinux_path__init() (Namhyung Kim)
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Adrian Hunter (14):
>       perf tools: Fix CLOEXEC probe for perf_event_paranoid == 2
>       perf tools: Fix one of the probe events to exclude kernel
>       perf tools: Fix probing the kernel API with cpu-wide events
>       perf tools: Prefer to use a cpu-wide event for probing CLOEXEC
>       perf symbols: Fix missing label symbols
>       perf evlist: Add 'system_wide' option
>       perf evlist: Add perf_evlist__set_tracking_event()
>       perf session: Add perf_session__peek_event()
>       perf script: Allow callchains if any event samples them
>       perf script python: Add helpers for calling Python objects
>       perf tools: Identify which comms are from exec
>       perf machine: Add machine__thread_exec_comm()
>       perf tools: Add flags and insn_len to struct sample
>       perf evlist: Add perf_evlist__enable_event_idx()
> 
> Alex Snast (1):
>       perf trace: Add beautifier for mremap flags param
> 
> Arnaldo Carvalho de Melo (2):
>       perf top: Don't look for kernel idle symbols in all DSOs
>       perf tools: Add cpu_startup_entry to the list of kernel idle symbols
> 
> Jiri Olsa (4):
>       perf top: Join the display thread on exit
>       perf tools: Introduce set_term_quiet_input helper function
>       perf top: Setup signals for terminal output
>       perf kvm: Fix stdin handling for 'kvm stat live' command
> 
> Masami Hiramatsu (2):
>       perf probe: Fix --list option to show events only with uprobe events
>       perf probe: Fix --del option to delete events only with uprobe events
> 
> Namhyung Kim (17):
>       perf script: Fix possible memory leaks
>       perf symbols: Fix a memory leak in vmlinux_path__init()
>       perf annotate: Move session handling out of __cmd_annotate()
>       perf buildid-cache: Move session handling into cmd_buildid_cache()
>       perf inject: Move session handling out of __cmd_inject()
>       perf kmem: Move session handling out of __cmd_kmem()
>       perf kvm: Move call to symbol__init() after creating session
>       perf lock: Move call to symbol__init() after creating session
>       perf sched: Move call to symbol__init() after creating session
>       perf script: Move call to symbol__init() after creating session
>       perf timechart: Move call to symbol__init() after creating session
>       perf trace: Move call to symbol__init() after creating session
>       perf tools: Check recorded kernel version when finding vmlinux
>       perf hists browser: Fix a small callchain display bug
>       perf top: Fix -z option behavior
>       perf top: Handle 'z' key for toggle zeroing samples in TUI
>       perf symbols: Don't demangle parameters and such by default
> 
> naota@elisp.net (1):
>       perf report: Set proper sort__mode for the branch option
> 
>  tools/perf/builtin-annotate.c                      |  75 +++++++-------
>  tools/perf/builtin-buildid-cache.c                 |  37 ++++---
>  tools/perf/builtin-diff.c                          |   2 +-
>  tools/perf/builtin-inject.c                        |  31 +++---
>  tools/perf/builtin-kmem.c                          |  49 +++++----
>  tools/perf/builtin-kvm.c                           |  24 ++---
>  tools/perf/builtin-lock.c                          |   3 +-
>  tools/perf/builtin-mem.c                           |   2 +-
>  tools/perf/builtin-record.c                        |   2 +-
>  tools/perf/builtin-report.c                        |   4 +-
>  tools/perf/builtin-sched.c                         |   3 +-
>  tools/perf/builtin-script.c                        |  57 +++++++----
>  tools/perf/builtin-timechart.c                     |   4 +-
>  tools/perf/builtin-top.c                           |  59 ++++++++---
>  tools/perf/builtin-trace.c                         |  34 +++++-
>  tools/perf/tests/builtin-test.c                    |   2 +-
>  tools/perf/ui/browsers/hists.c                     |  13 ++-
>  tools/perf/util/cloexec.c                          |  23 ++++-
>  tools/perf/util/comm.c                             |   7 +-
>  tools/perf/util/comm.h                             |   6 +-
>  tools/perf/util/event.h                            |   2 +
>  tools/perf/util/evlist.c                           | 109 ++++++++++++++++++--
>  tools/perf/util/evlist.h                           |   5 +
>  tools/perf/util/evsel.c                            |  34 ++++--
>  tools/perf/util/evsel.h                            |   2 +
>  tools/perf/util/hist.c                             |  22 ++++
>  tools/perf/util/hist.h                             |   1 +
>  tools/perf/util/machine.c                          |  30 +++++-
>  tools/perf/util/machine.h                          |   4 +
>  tools/perf/util/probe-event.c                      |  98 ++++++++++++------
>  tools/perf/util/record.c                           |  40 ++++++--
>  .../util/scripting-engines/trace-event-python.c    | 114 +++++++++------------
>  tools/perf/util/session.c                          |  79 +++++++++++++-
>  tools/perf/util/session.h                          |   5 +
>  tools/perf/util/symbol-elf.c                       |   9 +-
>  tools/perf/util/symbol.c                           |  31 ++++--
>  tools/perf/util/symbol.h                           |   4 +-
>  tools/perf/util/thread.c                           |  24 ++++-
>  tools/perf/util/thread.h                           |  10 +-
>  tools/perf/util/util.c                             |  13 +++
>  tools/perf/util/util.h                             |   2 +
>  41 files changed, 770 insertions(+), 305 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
