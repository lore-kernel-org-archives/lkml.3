Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab3KLUuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 15:50:24 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:63170 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690Ab3KLUuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 15:50:14 -0500
Date: Tue, 12 Nov 2013 21:50:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/13] perf/core improvements and fixes
Message-ID: <20131112205010.GA25913@gmail.com>
References: <1384289178-31374-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384289178-31374-1-git-send-email-acme@infradead.org>
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
> The following changes since commit 67c1e4a53b17894e6a24f95057cc374c4be051cb:
> 
>   perf tests: Use lower sample_freq in sw clock event period test (2013-11-11 16:43:34 -0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to 0497a9ebaf7ae4d573497b3e053ad4c3d5c9921d:
> 
>   tools lib traceevent: Add direct access to dynamic arrays (2013-11-12 17:23:44 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> . Add summary only option to 'perf trace', suppressing the decoding of
>   events, from David Ahern
> 
> . 'perf trace --summary' formatting simplifications, from Pekka Emberg.
> 
> . Beautify fifth argument of mmap() as fd, in 'perf trace', from Namhyung Kim.
> 
> . Fix segfault on perf trace -i perf.data, from Namhyung Kim.
> 
> . Fix segfault with --no-mmap-pages, from David Ahern.
> 
> . Round mmap pages to power 2, from David Ahern.
> 
> . Add direct access to dynamic arrays in libtraceevent, from Steven Rostedt.
> 
> . Handle throttle events in 'object code reading' test, fix from Adrian Hunter.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Adrian Hunter (2):
>       perf tests: Compensate lower sample freq with longer test loop
>       perf tests: Handle throttle events in 'object code reading' test
> 
> Arnaldo Carvalho de Melo (1):
>       perf target: Shorten perf_target__ to target__
> 
> David Ahern (4):
>       perf trace: Add summary only option
>       perf record: Fix segfault with --no-mmap-pages
>       perf evlist: Round mmap pages to power 2 - v2
>       perf evlist: Refactor mmap_pages parsing
> 
> Namhyung Kim (3):
>       perf trace: Beautify fifth argument of mmap() as fd
>       perf trace: Separate tp syscall field caching into init routine to be reused
>       perf trace: Fix segfault on perf trace -i perf.data
> 
> Pekka Enberg (2):
>       perf trace: Change syscall summary duration order
>       perf trace: Simplify '--summary' output
> 
> Steven Rostedt (1):
>       tools lib traceevent: Add direct access to dynamic arrays
> 
>  tools/lib/traceevent/event-parse.c      |  13 ++++
>  tools/perf/Documentation/perf-trace.txt |  10 ++-
>  tools/perf/builtin-kvm.c                |   6 +-
>  tools/perf/builtin-record.c             |  14 ++--
>  tools/perf/builtin-stat.c               |  21 +++---
>  tools/perf/builtin-top.c                |  14 ++--
>  tools/perf/builtin-trace.c              | 121 +++++++++++++++++++-------------
>  tools/perf/perf.h                       |   2 +-
>  tools/perf/tests/code-reading.c         |  15 +++-
>  tools/perf/tests/sw-clock.c             |   2 +-
>  tools/perf/tests/task-exit.c            |   2 +-
>  tools/perf/util/evlist.c                |  64 ++++++++++-------
>  tools/perf/util/evlist.h                |   5 +-
>  tools/perf/util/evsel.c                 |   9 ++-
>  tools/perf/util/evsel.h                 |   3 +-
>  tools/perf/util/machine.c               |   6 +-
>  tools/perf/util/machine.h               |   4 +-
>  tools/perf/util/target.c                |  54 +++++++-------
>  tools/perf/util/target.h                |  44 ++++++------
>  tools/perf/util/top.c                   |   2 +-
>  20 files changed, 236 insertions(+), 175 deletions(-)

Pulled, including yesterday's bits as well - thanks a lot Arnaldo!

	Ingo
