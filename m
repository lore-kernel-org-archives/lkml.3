Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbaJOJ4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 05:56:46 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:58993 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaJOJ4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 05:56:44 -0400
Date: Wed, 15 Oct 2014 11:56:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Borislav Petkov <bp@suse.de>, Chuck Ebbert <cebbert.lkml@gmail.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Douglas Hatch <doug.hatch@hp.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Milian Wolff <mail@milianw.de>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Scott J Norton <scott.norton@hp.com>,
        Stephane Eranian <eranian@google.com>,
        Waiman Long <Waiman.Long@hp.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/24] perf/core improvements and fixes
Message-ID: <20141015095638.GA26625@gmail.com>
References: <1413320673-5784-1-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413320673-5784-1-git-send-email-acme@kernel.org>
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
> The following changes since commit cc6cd47e7395bc05c5077009808b820633eb3f18:
> 
>   perf/x86: Tone down kernel messages when the PMU check fails in a virtual environment (2014-10-03 06:04:41 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo
> 
> for you to fetch changes up to 2c241bd35e6f626ad6f867dcf9fefdc2315f125f:
> 
>   perf symbols: Make sym->end be the first address after the symbol range (2014-10-14 17:50:58 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> Infrastructure:
> 
> . Do not include a struct hists per perf_evsel, untangling the histogram code
>   from perf_evsel, to pave the way for exporting a minimalistic
>   tools/lib/api/perf/ library usable by tools/perf and initially by the rasd
>   daemon being developed by Borislav Petkov, Robert Richter and Jean Pihet.
>   (Arnaldo Carvalho de Melo)
> 
> . Make perf_evlist__open(evlist, NULL, NULL), i.e. without cpu and thread
>   maps mean syswide monitoring, reducing the boilerplate for tools that
>   only want system wide mode. (Arnaldo Carvalho de Melo)
> 
> . Fix off-by-one bugs in map->end handling (Stephane Eranian)
> 
> . Fix off-by-one bug in maps__find(), also related to map->end handling (Namhyung Kim)
> 
> . Make struct symbol->end be the first addr after the symbol range, to make it
>   match the convention used for struct map->end. (Arnaldo Carvalho de Melo)
> 
> . Fix perf_evlist__add_pollfd() error handling in 'perf kvm stat live' (Jiri Olsa)
> 
> . Fix python test build by moving callchain_param to an object linked into the
>   python binding (Jiri Olsa)
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (18):
>       perf sched: Stop updating hists stats, not used
>       perf script: Stop updating hists stats, not used
>       perf evsel: Add hists helper
>       perf session: Don't count per evsel events
>       perf tools: Move events_stats struct to event.h
>       perf ui browsers: Add missing include
>       perf session: Remove last reference to hists struct
>       perf evsel: Subclassing
>       perf callchain: Move the callchain_param extern to callchain.h
>       perf tools: Remove hists from evsel
>       perf thread_map: Create dummy constructor out of open coded equivalent
>       perf evlist: Check that there is a thread_map when preparing a workload
>       perf evlist: Default to syswide target when no thread/cpu maps set
>       perf evsel: Add missing 'target' struct forward declaration
>       perf evsel: Make some exit routines static
>       perf machine: Add missing dsos->root rbtree root initialization
>       perf symbols: Fix map->end fixup
>       perf symbols: Make sym->end be the first address after the symbol range
> 
> Jiri Olsa (4):
>       perf kvm stat live: Fix perf_evlist__add_pollfd error handling
>       perf kvm stat live: Use perf_evlist__add_pollfd return fd position
>       perf kvm stat live: Use fdarray object instead of pollfd
>       perf callchain: Move callchain_param to util object in to fix python test
> 
> Namhyung Kim (1):
>       perf tools: Fixup off-by-one comparision in maps__find
> 
> Stephane Eranian (1):
>       perf tools: fix off-by-one error in maps
> 
>  tools/perf/builtin-annotate.c                      | 14 +++--
>  tools/perf/builtin-diff.c                          | 21 ++++---
>  tools/perf/builtin-kvm.c                           | 22 +++----
>  tools/perf/builtin-record.c                        |  1 +
>  tools/perf/builtin-report.c                        | 24 ++++---
>  tools/perf/builtin-sched.c                         |  3 -
>  tools/perf/builtin-script.c                        |  1 -
>  tools/perf/builtin-top.c                           | 60 ++++++++++--------
>  tools/perf/tests/builtin-test.c                    |  5 ++
>  tools/perf/tests/hists_cumulate.c                  |  8 +--
>  tools/perf/tests/hists_filter.c                    | 23 +++----
>  tools/perf/tests/hists_link.c                      | 23 ++++---
>  tools/perf/tests/hists_output.c                    | 20 +++---
>  tools/perf/ui/browsers/header.c                    |  1 +
>  tools/perf/ui/browsers/hists.c                     | 20 +++---
>  tools/perf/ui/gtk/hists.c                          |  2 +-
>  tools/perf/util/annotate.c                         |  8 +--
>  tools/perf/util/callchain.h                        |  2 +
>  tools/perf/util/event.h                            | 26 ++++++++
>  tools/perf/util/evlist.c                           | 48 +++++++++++++-
>  tools/perf/util/evsel.c                            | 66 ++++++++++++++-----
>  tools/perf/util/evsel.h                            | 14 ++---
>  tools/perf/util/hist.c                             | 73 +++++++++++++++++-----
>  tools/perf/util/hist.h                             | 49 +++++++--------
>  tools/perf/util/machine.c                          | 10 ++-
>  tools/perf/util/map.c                              |  8 +--
>  .../util/scripting-engines/trace-event-python.c    |  1 +
>  tools/perf/util/session.c                          | 23 -------
>  tools/perf/util/session.h                          |  1 -
>  tools/perf/util/sort.c                             |  4 +-
>  tools/perf/util/symbol.c                           |  8 +--
>  tools/perf/util/symbol.h                           |  2 +-
>  tools/perf/util/thread_map.c                       | 21 ++++---
>  tools/perf/util/thread_map.h                       |  1 +
>  tools/perf/util/util.c                             |  8 +++
>  35 files changed, 392 insertions(+), 229 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
