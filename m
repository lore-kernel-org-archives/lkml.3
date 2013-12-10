Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab3LJLIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 06:08:11 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:54629 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab3LJLIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 06:08:05 -0500
Date: Tue, 10 Dec 2013 12:07:59 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Ben Cheng <bccheng@google.com>,
        David Ahern <dsahern@gmail.com>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/21] perf/core improvements and fixes
Message-ID: <20131210110759.GA26659@gmail.com>
References: <1386617830-18926-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386617830-18926-1-git-send-email-acme@infradead.org>
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
> Best Regards,
> 
> -Arnaldo
> 
> The following changes since commit 6d65894bc028d0342829ea1e64c9e9efad571124:
> 
>   tools lib traceevent: Update kvm plugin with is_writable_pte helper (2013-12-04 15:38:14 -0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to e993d10caeb6dca690dbaf86e1981ba240d1414a:
> 
>   perf symbols: fix bug in usage of the basename() function (2013-12-09 15:41:59 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> . Add an option in 'perf script' to print the source line number, from Adrian Hunter
> 
> . Fix symoff printing in callchains in 'perf script', from Adrian Hunter.
> 
> . Assorted mmap_pages handling fixes, from Adrian Hunter.
> 
> . Fix summary percentage when processing files in 'perf trace', fom David Ahern.
> 
> . Handle old kernels where the "raw_syscalls" tracepoints were called plan "syscalls",
>   in 'perf trace', from David Ahern.
> 
> . Several man pages typo fixes from Dongsheng Yang.
> 
> . Add '-v' option to 'perf kvm', from Dongsheng Yang.
> 
> . Make perf kvm diff support --guestmount, from Dongsheng Yang.
> 
> . Get rid of several die() calls in libtraceevent, from Namhyung Kim.
> 
> . Use basename() in a more robust way, to avoid problems related to different
>   system library implementations for that function, from Stephane Eranian.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Adrian Hunter (6):
>       perf script: Fix symoff printing in callchains
>       perf script: Add an option to print the source line number
>       perf record: Fix display of incorrect mmap pages
>       perf evlist: Remove unnecessary parentheses
>       perf evlist: Fix max mmap_pages
>       perf evlist: Fix mmap pages rounding to power of 2
> 
> David Ahern (2):
>       perf trace: Add support for syscalls vs raw_syscalls
>       perf trace: Fix summary percentage when processing files
> 
> Dongsheng Yang (6):
>       perf kvm: Introduce option -v for perf kvm command.
>       perf kvm: Fix bug in 'stat report'
>       perf archive: Remove duplicated 'runs' in man page
>       perf annotate: Fix typo
>       perf kvm: Move code to generate filename for perf-kvm to function.
>       perf kvm: Make perf kvm diff support --guestmount.
> 
> Namhyung Kim (5):
>       tools lib traceevent: Get rid of malloc_or_die() in pevent_filter_alloc()
>       tools lib traceevent: Get rid of malloc_or_die() in add_event()
>       tools lib traceevent: Get rid of die() in create_arg_item()
>       tools lib traceevent: Get rid of malloc_or_die() in pevent_filter_add_filter_str()
>       tools lib traceevent: Get rid of die() in pevent_filter_clear_trivial()
> 
> Stephane Eranian (1):
>       perf symbols: fix bug in usage of the basename() function
> 
> Steven Rostedt (1):
>       tools lib traceevent: Report better error message on bad function args
> 
>  tools/lib/traceevent/event-parse.c        | 28 +++++++++------
>  tools/lib/traceevent/event-parse.h        |  2 +-
>  tools/lib/traceevent/parse-filter.c       | 57 ++++++++++++++++++++++++-------
>  tools/perf/Documentation/perf-archive.txt |  6 ++--
>  tools/perf/Documentation/perf-kvm.txt     |  7 ++--
>  tools/perf/Documentation/perf-script.txt  |  2 +-
>  tools/perf/builtin-annotate.c             |  2 +-
>  tools/perf/builtin-diff.c                 |  3 +-
>  tools/perf/builtin-kvm.c                  | 11 +++---
>  tools/perf/builtin-record.c               |  2 +-
>  tools/perf/builtin-script.c               | 10 ++++++
>  tools/perf/builtin-trace.c                | 32 +++++++++++++++--
>  tools/perf/util/dso.c                     | 29 +++++++++++++++-
>  tools/perf/util/evlist.c                  | 10 +++---
>  tools/perf/util/map.c                     | 17 +++++++++
>  tools/perf/util/map.h                     |  2 ++
>  tools/perf/util/session.c                 | 15 +++++++-
>  tools/perf/util/session.h                 |  1 +
>  tools/perf/util/util.c                    | 14 ++++++++
>  tools/perf/util/util.h                    | 14 ++++++++
>  20 files changed, 214 insertions(+), 50 deletions(-)

Pulled, thanks Arnaldo!

There's one detail I noticed about the recent trace-plugin changes:

comet:~/tip/tools/perf> make install
  BUILD:   Doing 'make -j12' parallel build
  SUBDIR   Documentation
  INSTALL  Documentation-man
  INSTALL  GTK UI
  SUBDIR   /home/mingo/tip/tools/lib/traceevent/
  INSTALL  binaries
  INSTALL  plugin_jbd2.so
  INSTALL  plugin_hrtimer.so
  INSTALL  plugin_kmem.so
  INSTALL  plugin_kvm.so
  INSTALL  plugin_mac80211.so
  INSTALL  plugin_sched_switch.so
  INSTALL  plugin_function.so
  INSTALL  plugin_xen.so
  INSTALL  plugin_scsi.so
  INSTALL  plugin_cfg80211.so
  INSTALL  libexec
  INSTALL  perf-archive
  INSTALL  perl-scripts
  INSTALL  python-scripts
  INSTALL  perf_completion-script
  INSTALL  tests

those plugin installs are way too verbose, they should really be in a 
single summarized line, only saying something like:

  INSTALL  plugins

Just like we already sum up 'binaries', 'libexec', 'tests', etc.

Thanks,

	Ingo
