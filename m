Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab3K3Mpc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:45:32 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:43404 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab3K3Mp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:45:26 -0500
Date: Sat, 30 Nov 2013 13:45:21 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>, Chia-I Wu <olvaffe@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        linaro-kernel@lists.linaro.org, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, patches@linaro.org,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Will Deacon <will.deacon@arm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 00/32 v3] perf/core improvements and fixes
Message-ID: <20131130124521.GA12143@gmail.com>
References: <1385667660-14159-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385667660-14159-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> 
> Hi Ingo,
> 
> 	Ingo, this is the 3rd try, this time removing the last two patches in
> the series, from Jean, till we get the problems I found and the one reported by
> Jiri sorted out.
> 
> 	Jiri told me the problem exhibits when one doesn't have libunwind devel
> files installed.
> 
> 	At some point we're considering using things like the 'mock' tool to
> do the tools/perf/tests/ builds tests with all possible development packages
> combos to detect these kinds of problems earlier.
> 
> 	Please consider applying,
> 
> Best Regards,
> 
> - Arnaldo
> 
> The following changes since commit 65661f96d3b32f4b28fef26d21be81d7e173b965:
> 
>   perf/x86: Add RAPL hrtimer support (2013-11-27 15:31:23 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to 26286141a43251bed548349efbf60b61f1c433e8:
> 
>   perf tools: Fix tags/TAGS targets rebuilding (2013-11-27 16:47:14 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> . Make per-cpu mmaps the default in 'perf record', from Adrian Hunter.
> 
> . Default -t/--thread 'perf record' option to no inheritance,
>   from Adrian Hunter.
> 
> . Make 'perf top -g' refer to callchains, for consistency with other tools,
>   from David Ahern.
> 
> . Skip ignored symbols while printing callchain, from David Ahern.
> 
> . Print callchains and symbols if they exist in 'perf script',
>   from David Ahern.
> 
> . Remove thread summary coloring in 'perf trace', from Pekka Enberg.
> 
> . zsh completion support, from Ramkumar Ramachandra.
> 
> . 'perf timechart' improvements, including backtrace support,
>   from Stanislav Fomichev.
> 
> . Fix using kcore files stored in the buildid cache when doing report/annotate
>   in non-live sessions, from Adrian Hunter
> 
> . Minor 'timechart' cleanups.
> 
> . Fix tags/TAGS targets rebuilding, from Jiri Olsa.
> 
> . Add options to show comm, fork, exit and mmap PERF_RECORD_ events in
>   'perf script', from Namhyung Kim.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Adrian Hunter (5):
>       perf record: Make per-cpu mmaps the default.
>       perf tools: Allow '--inherit' as the negation of '--no-inherit'
>       perf tools: Add option macro OPT_BOOLEAN_SET
>       perf record: Default -t option to no inheritance
>       perf symbols: Fix not finding kcore in buildid cache
> 
> Arnaldo Carvalho de Melo (2):
>       perf timechart: Remove some needless struct forward declarations
>       perf timechart: Remove misplaced __maybe_unused
> 
> David Ahern (6):
>       perf top: Make -g refer to callchains
>       perf evsel: Skip ignored symbols while printing callchain
>       perf symbols: Move idle syms check from top to generic function
>       perf thread: Move comm_list check into function
>       perf tools: Export setup_list
>       perf script: Print callchains and symbols if they exist
> 
> Jiri Olsa (1):
>       perf tools: Fix tags/TAGS targets rebuilding
> 
> Namhyung Kim (3):
>       perf script: Move evname print code to process_event()
>       perf script: Print comm, fork and exit events also
>       perf script: Print mmap[2] events also
> 
> Pekka Enberg (1):
>       perf trace: Remove thread summary coloring
> 
> Ramkumar Ramachandra (5):
>       perf completion: Introduce a layer of indirection
>       perf completion: Factor out compgen stuff
>       perf completion: Factor out call to __ltrim_colon_completions
>       perf completion: Introduce zsh support
>       perf completion: Rename file to reflect zsh support
> 
> Stanislav Fomichev (8):
>       perf timechart: Always try to print at least 15 tasks
>       perf timechart: Add option to limit number of tasks
>       perf timechart: Use proc_num to implement --power-only
>       perf timechart: Add support for displaying only tasks related data
>       perf timechart: Group figures and add title with details
>       perf timechart: Add support for -P and -T in timechart recording
>       perf timechart: Add backtrace support
>       perf timechart: dynamically determine event fields offset
> 
> Steven Rostedt (1):
>       tools lib traceevent: Use helper trace-seq in print functions like kernel does
> 
>  tools/lib/traceevent/event-parse.c                 |   7 +-
>  tools/perf/Documentation/perf-record.txt           |  12 +-
>  tools/perf/Documentation/perf-script.txt           |   6 +
>  tools/perf/Documentation/perf-timechart.txt        |  26 +-
>  tools/perf/Documentation/perf-top.txt              |   5 +-
>  tools/perf/Makefile                                |   7 +-
>  tools/perf/Makefile.perf                           |   4 +-
>  tools/perf/builtin-record.c                        |  13 +-
>  tools/perf/builtin-script.c                        | 209 ++++++++++-
>  tools/perf/builtin-timechart.c                     | 418 ++++++++++++++-------
>  tools/perf/builtin-top.c                           |  29 +-
>  tools/perf/builtin-trace.c                         |  13 +-
>  tools/perf/{bash_completion => perf-completion.sh} | 100 ++++-
>  tools/perf/perf.h                                  |   1 +
>  tools/perf/tests/attr/test-record-no-inherit       |   2 +-
>  tools/perf/util/event.c                            |   3 +-
>  tools/perf/util/evlist.c                           |   6 +-
>  tools/perf/util/evsel.c                            |   5 +-
>  tools/perf/util/parse-options.c                    |  21 ++
>  tools/perf/util/parse-options.h                    |   8 +
>  tools/perf/util/session.c                          |  10 +-
>  tools/perf/util/svghelper.c                        |  77 +++-
>  tools/perf/util/svghelper.h                        |  11 +-
>  tools/perf/util/symbol.c                           |  41 +-
>  tools/perf/util/symbol.h                           |   4 +
>  tools/perf/util/target.c                           |  11 +-
>  tools/perf/util/target.h                           |   4 +-
>  tools/perf/util/thread.h                           |  12 +
>  28 files changed, 831 insertions(+), 234 deletions(-)
>  rename tools/perf/{bash_completion => perf-completion.sh} (65%)

Pulled, thanks a lot Arnaldo!

	Ingo
