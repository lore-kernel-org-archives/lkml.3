Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211AbaFLLyY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 07:54:24 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:43743 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739AbaFLLyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:54:23 -0400
Date: Thu, 12 Jun 2014 13:54:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Javi Merino <javi.merino@arm.com>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL 00/15] perf/core improvements and fixes
Message-ID: <20140612115417.GA26661@gmail.com>
References: <1402344150-14860-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402344150-14860-1-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@kernel.org> wrote:

> 
> hi Ingo,
> please consider pulling
> 
> thanks,
> jirka
> 
> 
> The following changes since commit 82b897782d10fcc4930c9d4a15b175348fdd2871:
> 
>   perf: Differentiate exec() and non-exec() comm events (2014-06-06 07:56:22 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-core-for-mingo
> 
> for you to fetch changes up to a2609f3b0c582d6aaa8f69a61a0eea6c7a98d291:
> 
>   perf tools: Support spark lines in perf stat (2014-06-09 13:34:50 +0200)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> . Bitmask handling and plugin updates (Steven Rostedt)
> 
> . Fix pipe check regression in attr event callback (Jiri Olsa)
> 
> . Prettify the tags/TAGS/cscope targets output (Jiri Olsa)
> 
> . Print array argument as string (Namhyung Kim)
> 
> . Pass protection and flags bits through mmap2 interface (Peter Zijlstra)
> 
> . Update perf tool mmap2 interface with protection and flag bits (Don Zickus)
> 
> . Re-enable mmap interface (Don Zickus)
> 
> . Add mem-mode documentation to report command (Don Zickus)
> 
> . Add sort on dcacheline (Don Zickus)
> 
> . Support spark lines in perf stat (Andi Kleen)
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> 
> ----------------------------------------------------------------
> Andi Kleen (1):
>       perf tools: Support spark lines in perf stat
> 
> Don Zickus (6):
>       perf tools: Update mmap2 interface with protection and flag bits
>       Revert "perf: Disable PERF_RECORD_MMAP2 support"
>       perf report: Add mem-mode documentation to report command
>       perf tools: Add cpumode to struct hist_entry
>       perf tools: Add support to dynamically get cacheline size
>       perf tools: Add dcacheline sort
> 
> Jiri Olsa (2):
>       perf tools: Fix pipe check regression in attr event callback
>       perf tools: Prettify the tags/TAGS/cscope targets output
> 
> Namhyung Kim (1):
>       perf script/python: Print array argument as string
> 
> Peter Zijlstra (1):
>       perf: Pass protection and flags bits through mmap2 interface
> 
> Steven Rostedt (1):
>       tools lib traceevent: Add options to plugins
> 
> Steven Rostedt (Red Hat) (3):
>       tools lib traceevent: Add flag to not load event plugins
>       tools lib traceevent: Add options to function plugin
>       tools lib traceevent: Added support for __get_bitmask() macro
> 
>  include/uapi/linux/perf_event.h                    |   1 +
>  kernel/events/core.c                               |  37 +++-
>  tools/lib/traceevent/event-parse.c                 | 113 ++++++++++++
>  tools/lib/traceevent/event-parse.h                 |  25 ++-
>  tools/lib/traceevent/event-plugin.c                | 203 ++++++++++++++++++++-
>  tools/lib/traceevent/plugin_function.c             |  43 ++++-
>  tools/perf/Documentation/perf-report.txt           |  23 +++
>  tools/perf/Documentation/perf-stat.txt             |   4 +
>  tools/perf/Makefile.perf                           |   7 +-
>  tools/perf/builtin-inject.c                        |   2 +-
>  tools/perf/builtin-stat.c                          |  12 ++
>  tools/perf/perf.c                                  |   1 +
>  tools/perf/tests/dwarf-unwind.c                    |   2 +-
>  tools/perf/util/event.c                            |  57 ++++--
>  tools/perf/util/event.h                            |   2 +
>  tools/perf/util/evsel.c                            |   1 +
>  tools/perf/util/hist.c                             |   9 +-
>  tools/perf/util/hist.h                             |   1 +
>  tools/perf/util/machine.c                          |   4 +-
>  tools/perf/util/map.c                              |   4 +-
>  tools/perf/util/map.h                              |   4 +-
>  .../perf/util/scripting-engines/trace-event-perl.c |   1 +
>  .../util/scripting-engines/trace-event-python.c    |   2 +
>  tools/perf/util/sort.c                             | 107 +++++++++++
>  tools/perf/util/sort.h                             |   2 +
>  tools/perf/util/spark.c                            |  31 ++++
>  tools/perf/util/spark.h                            |   4 +
>  tools/perf/util/stat.c                             |  34 ++++
>  tools/perf/util/stat.h                             |  10 +
>  tools/perf/util/util.c                             |   1 +
>  tools/perf/util/util.h                             |   1 +
>  31 files changed, 707 insertions(+), 41 deletions(-)
>  create mode 100644 tools/perf/util/spark.c
>  create mode 100644 tools/perf/util/spark.h

Pulled, thanks a lot Jiri!

	Ingo
