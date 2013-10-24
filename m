Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab3JXGwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 02:52:45 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:50448 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab3JXGwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 02:52:43 -0400
Date: Thu, 24 Oct 2013 08:52:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hitoshi Mitake <h.mitake@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/16] perf/core improvements and fixes
Message-ID: <20131024065239.GA24888@gmail.com>
References: <1382561895-8237-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382561895-8237-1-git-send-email-acme@infradead.org>
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
> The following changes since commit aa30a2e03a453aad9fd96c3f2d4a82c3497674e5:
> 
>   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2013-10-23 09:45:50 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to c1fb5651bb40f9efaf32d280f39e06df7e352673:
> 
>   perf tools: Show progress on histogram collapsing (2013-10-23 15:48:24 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> . Show progress on histogram collapsing, that can take a long time, from
>   Namhyung Kim.
> 
> . Support "$vars" meta argument syntax for local variables, allowing
>   asking for all possible variables at a given probe point to be
>   collected when it hits, from Masami Hiramatsu.
> 
> . Address the root cause of that 'perf sched' stack initialization build
>   slowdown, by programmatically setting a big array after moving the
>   global variable back to the stack. Fix from Adrian Hunter.
> 
> . Do not repipe attributes to a perf.data file in 'perf inject',
>   fix from Adrian Hunter
> 
> . Change the procps visible command-name of invididual benchmark tests
>   plus cleanups, from Ingo Molnar.
> 
> . Do not accept parse_tag_value() overflow, fix from Adrian Hunter.
> 
> . Validate that mmap_pages is not too big. From Adrian Hunter.
> 
> . Fix non-debug build, from Adrian Hunter
> 
> . Clarify the "sample parsing" test entry.
> 
> . Consider PERF_SAMPLE_TRANSACTION in the "sample parsing" test.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Adrian Hunter (7):
>       perf sched: Make struct perf_sched sched a local variable
>       perf sched: Optimize build time
>       perf script: Make perf_script a local variable
>       perf inject: Do not repipe attributes to a perf.data file
>       perf tools: Do not accept parse_tag_value() overflow
>       perf evlist: Validate that mmap_pages is not too big
>       perf tools: Fix non-debug build
> 
> Arnaldo Carvalho de Melo (5):
>       perf test: Clarify the "sample parsing" test entry
>       perf test: Consider PERF_SAMPLE_TRANSACTION in the "sample parsing" test
>       perf tools: Stop using 'self' in some more places
>       perf ui: Rename ui_progress to ui_progress_ops
>       perf ui progress: Per progress bar state
> 
> Ingo Molnar (1):
>       perf bench: Change the procps visible command-name of invididual benchmark tests plus cleanups
> 
> Masami Hiramatsu (2):
>       perf probe: Support "$vars" meta argument syntax for local variables
>       perf probe: Find fentry mcount fuzzed parameter location
> 
> Namhyung Kim (1):
>       perf tools: Show progress on histogram collapsing
> 
>  tools/perf/Makefile.perf          |   1 +
>  tools/perf/builtin-annotate.c     |   6 +-
>  tools/perf/builtin-bench.c        | 239 +++++++++++++++++++-------------------
>  tools/perf/builtin-diff.c         |   7 +-
>  tools/perf/builtin-inject.c       |  27 +++--
>  tools/perf/builtin-report.c       |  24 ++--
>  tools/perf/builtin-sched.c        |  44 +++----
>  tools/perf/builtin-script.c       |  40 ++++---
>  tools/perf/builtin-top.c          |   4 +-
>  tools/perf/config/Makefile        |   4 +
>  tools/perf/tests/hists_link.c     |   2 +-
>  tools/perf/tests/sample-parsing.c |   4 +-
>  tools/perf/ui/gtk/gtk.h           |   2 +-
>  tools/perf/ui/gtk/progress.c      |  20 ++--
>  tools/perf/ui/gtk/setup.c         |   2 +-
>  tools/perf/ui/progress.c          |  32 +++--
>  tools/perf/ui/progress.h          |  19 +--
>  tools/perf/ui/tui/progress.c      |  15 +--
>  tools/perf/ui/tui/setup.c         |   3 +-
>  tools/perf/ui/tui/tui.h           |   6 +
>  tools/perf/util/build-id.c        |   6 +-
>  tools/perf/util/evlist.c          |  14 ++-
>  tools/perf/util/hist.c            |  23 ++--
>  tools/perf/util/hist.h            |   3 +-
>  tools/perf/util/probe-event.c     |   1 -
>  tools/perf/util/probe-finder.c    | 133 ++++++++++++++++++---
>  tools/perf/util/probe-finder.h    |   1 +
>  tools/perf/util/session.c         |  24 ++--
>  tools/perf/util/sort.c            | 124 ++++++++++----------
>  tools/perf/util/strfilter.c       |  46 ++++----
>  tools/perf/util/thread.c          |  72 ++++++------
>  tools/perf/util/util.c            |   2 +
>  32 files changed, 560 insertions(+), 390 deletions(-)
>  create mode 100644 tools/perf/ui/tui/tui.h

Pulled, thanks Arnaldo!

	Ingo
