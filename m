Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbaAPIgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 03:36:13 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:62877 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaAPIgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 03:36:10 -0500
Date: Thu, 16 Jan 2014 09:36:04 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Will Deacon <will.deacon@arm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/13] perf/core improvements and fixes
Message-ID: <20140116083604.GB6077@gmail.com>
References: <1389817991-8145-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389817991-8145-1-git-send-email-acme@infradead.org>
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
> The following changes since commit 197749981e539c1eb5863f417de6dd4e2c02b76c:
> 
>   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2014-01-14 17:25:12 +0100)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to 0e9e79a13ab9d56b86db6538305babc23b1445cc:
> 
>   tools lib traceevent: fix pointer-integer size mismatch (2014-01-15 17:04:38 -0300)
> 
> ----------------------------------------------------------------
> Changes in user visible interfaces:
> 
> . Rename 'record's --no-delay option to --no-buffering, better reflecting its
>   purpose and freeing up '--delay' to take the place of '--initial-delay', so that
>   'record' and 'stat' are consistent.
> 
> Refactorings:
> 
> . Get rid of die() and friends (good riddance!) in libtraceevent (Namhyung Kim)
> 
> Developer stuff:
> 
> . Fix cross build problems related to pkgconfig and CROSS_COMPILE not being
>   propagated to the feature tests, leading to features being tested in the
>   host and then being enabled on the target. (Mark Rutland)
> 
> . Fix pointer-integer size mismatch in some libtraceevent plugins (Mark Rutland)
> 
> . Fix build error due to zfree() cast (Namhyung Kim)
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (2):
>       perf record: Rename --no-delay to --no-buffering
>       perf record: Rename --initial-delay to --delay
> 
> Mark Rutland (2):
>       perf: tools: Fix cross building
>       tools lib traceevent: fix pointer-integer size mismatch
> 
> Namhyung Kim (9):
>       perf tools: Fix build error due to zfree() cast
>       tools lib traceevent: Add state member to struct trace_seq
>       tools lib traceevent: Check return value of realloc()
>       tools lib traceevent: Get rid of malloc_or_die() in trace_seq_init()
>       tools lib traceevent: Get rid of die() finally!!
>       tools lib traceevent: Make plugin unload function receive pevent
>       perf tools: Remove symbol_conf.use_callchain check
>       perf tools: Factor out sample__resolve_callchain()
>       perf hists: Convert hist entry functions to use struct he_stat
> 
>  tools/lib/traceevent/Makefile             |  2 +-
>  tools/lib/traceevent/event-parse.h        | 14 +++++--
>  tools/lib/traceevent/event-plugin.c       |  4 +-
>  tools/lib/traceevent/event-utils.h        |  4 --
>  tools/lib/traceevent/parse-utils.c        | 44 --------------------
>  tools/lib/traceevent/plugin_cfg80211.c    |  2 +-
>  tools/lib/traceevent/plugin_function.c    |  2 +-
>  tools/lib/traceevent/plugin_scsi.c        |  2 +-
>  tools/lib/traceevent/trace-seq.c          | 67 ++++++++++++++++++++++++-------
>  tools/perf/Documentation/perf-record.txt  |  6 +--
>  tools/perf/Makefile.perf                  |  1 +
>  tools/perf/builtin-record.c               |  4 +-
>  tools/perf/builtin-report.c               | 24 ++---------
>  tools/perf/builtin-top.c                  | 22 ++++------
>  tools/perf/builtin-trace.c                |  2 +-
>  tools/perf/config/Makefile                |  6 +--
>  tools/perf/config/feature-checks/Makefile |  9 +++--
>  tools/perf/perf.h                         |  2 +-
>  tools/perf/tests/open-syscall-tp-fields.c |  8 ++--
>  tools/perf/tests/perf-record.c            |  6 +--
>  tools/perf/util/callchain.c               | 23 +++++++++++
>  tools/perf/util/callchain.h               |  6 +++
>  tools/perf/util/evsel.c                   |  2 +-
>  tools/perf/util/hist.c                    | 22 +++++-----
>  tools/perf/util/machine.c                 |  2 -
>  tools/perf/util/srcline.c                 |  4 +-
>  tools/perf/util/strlist.c                 |  2 +-
>  tools/perf/util/trace-event.c             |  2 +-
>  28 files changed, 147 insertions(+), 147 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
