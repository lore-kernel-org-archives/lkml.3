Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab3LRKNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:13:36 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:37749 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3LRKNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:13:30 -0500
Date: Wed, 18 Dec 2013 11:13:23 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Robert Richter <rric@kernel.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/10] perf/core improvements and refactorings
Message-ID: <20131218101323.GA20360@gmail.com>
References: <1387313531-14629-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387313531-14629-1-git-send-email-acme@infradead.org>
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
> Regards,
> 
> - Arnaldo
> 
> The following changes since commit b283d2f3b74bc98174e8453c0be41dfcda3cae1b:
> 
>   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2013-12-16 14:52:03 +0100)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to f23b24f1bf90b56cfaeb2a1c9b77c46efe8916a6:
> 
>   tools lib traceevent: Get rid of die() in some string conversion functions (2013-12-17 16:51:49 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and refactorings:
> 
> New features:
> 
> . In perf timechart:
> 	- Add backtrace support to CPU info
> 	. Print pid along the name
> 	. Add support for CPU topology
> 	. Add new option --highlight'ing threads, be it by name or,
> 	  if a numeric value is provided, that run more than given duration.
>   From Stanislav Fomichev.
> 
> Refactorings:
> 
> . Rename some struct DSO binary_type related members and methods,
>   to clarify its purpose and need for differentiation from symtab_type,
>   i.e. one is about the files .text, CFI, etc, i.e. its binary contents,
>   and the other is about where the symbol table came from.
> 
> . Convert to new topic libraries, starting with an API one (sysfs, debugfs,
>   etc), renaming liblk in the process, from Borislav Petkov.
> 
> . Get rid of some more panic() like error handling in libtraceevent,
>   from Namhyung Kim.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (3):
>       perf symbols: Remove needless static binary_type array
>       perf symbols: Clarify method to get DSO binary_type filename
>       perf symbols: Use consistent name for the DSO binary type member
> 
> Borislav Petkov (1):
>       tools/: Convert to new topic libraries
> 
> Namhyung Kim (1):
>       tools lib traceevent: Get rid of die() in some string conversion functions
> 
> Stanislav Fomichev (5):
>       perf timechart: Add backtrace support to CPU info
>       perf timechart: Print pid along the name
>       perf timechart: Get number of CPUs from perf header
>       perf timechart: Add support for topology
>       perf timechart: Add --highlight option
> 
>  tools/Makefile                              |  12 +--
>  tools/lib/{lk => api}/Makefile              |  18 ++--
>  tools/lib/{lk => api/fs}/debugfs.c          |   0
>  tools/lib/{lk => api/fs}/debugfs.h          |   6 +-
>  tools/lib/traceevent/parse-filter.c         |  67 ++++--------
>  tools/perf/Documentation/perf-timechart.txt |  16 +++
>  tools/perf/Makefile.perf                    |  33 +++---
>  tools/perf/builtin-kvm.c                    |   2 +-
>  tools/perf/builtin-probe.c                  |   2 +-
>  tools/perf/builtin-timechart.c              |  79 ++++++++++++--
>  tools/perf/perf.c                           |   2 +-
>  tools/perf/tests/parse-events.c             |   2 +-
>  tools/perf/util/dso.c                       |  24 ++---
>  tools/perf/util/dso.h                       |  14 +--
>  tools/perf/util/evlist.c                    |   2 +-
>  tools/perf/util/evsel.c                     |   2 +-
>  tools/perf/util/parse-events.c              |   2 +-
>  tools/perf/util/probe-event.c               |   2 +-
>  tools/perf/util/setup.py                    |   4 +-
>  tools/perf/util/svghelper.c                 | 159 ++++++++++++++++++++++++++--
>  tools/perf/util/svghelper.h                 |   6 +-
>  tools/perf/util/symbol.c                    |  12 +--
>  tools/perf/util/trace-event-info.c          |   2 +-
>  tools/perf/util/util.h                      |   2 +-
>  tools/vm/Makefile                           |  14 +--
>  tools/vm/page-types.c                       |   2 +-
>  26 files changed, 344 insertions(+), 142 deletions(-)
>  rename tools/lib/{lk => api}/Makefile (66%)
>  rename tools/lib/{lk => api/fs}/debugfs.c (100%)
>  rename tools/lib/{lk => api/fs}/debugfs.h (86%)

Pulled, thanks Arnaldo!

While testing this I noticed that the trace-plugins related build 
system messages spam, which I reported a week ago, is still there:

comet:~/tip/tools/perf> make install
  BUILD:   Doing 'make -j12' parallel build
  SUBDIR   Documentation
  INSTALL  Documentation-man
  INSTALL  GTK UI
  SUBDIR   /fast/mingo/tip/tools/lib/traceevent/
  INSTALL  plugin_jbd2.so
  INSTALL  binaries
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

It needlessly dominates the output while it should be just a single 
line, like all the other entries:

  INSTALL  binaries
  INSTALL  trace_plugins
  INSTALL  libexec

Thanks,

	Ingo
