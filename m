Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322Ab3BFVvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:51:49 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:48394 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab3BFVvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:51:48 -0500
Date: Wed, 6 Feb 2013 22:51:41 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andi Kleen <andi@firstfloor.org>, Andrew Jones <drjones@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Feng Tang <feng.tang@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Joe Perches <joe@perches.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/17] perf/core improvements and fixes
Message-ID: <20130206215141.GA28460@gmail.com>
References: <1360187059-12661-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360187059-12661-1-git-send-email-acme@infradead.org>
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
> The following changes since commit 0fbdad078a70ed72248c3d30fe32e45e83be00d1:
> 
>   perf/x86: Allow for architecture specific RDPMC indexes (2013-02-06 19:45:24 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to 88fd2b6a76264e9e14463f532caae09d82a53207:
> 
>   perf python: Link with sysfs.o (2013-02-06 18:09:28 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes
> 
> . Check for flex and bison before continuing building, from Borislav Petkov.
> 
> . Make event_copy local to mmaps, fixing buffer wrap around problems, from
>   David Ahern.
> 
> . Add option for runtime switching perf data file in perf report, just press
>   's' and a menu with the valid files found in the current directory will be
>   presented, from Feng Tang.
> 
> . Add support to display whole group data for raw columns, from Jiri Olsa.
> 
> . Fix SIGALRM and pipe read race for the rwtop perl script. from Jiri Olsa.
> 
> . Fix perf_evsel::exclude_GH handling and add a test to catch regressions, from
>   Jiri Olsa.
> 
> . Error checking fixes, from Namhyung Kim.
> 
> . Fix calloc argument ordering, from Paul Gortmaker.
> 
> . Fix set event list leader, from Stephane Eranian.
> 
> . Add per processor socket count aggregation in perf stat, from Stephane Eranian.
> 
> . Fix perf python binding breakage.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (2):
>       perf evlist: Pass the event_group info via perf_attr_details
>       perf python: Link with sysfs.o
> 
> Borislav Petkov (1):
>       perf tools: Check for flex and bison before continuing building
> 
> David Ahern (1):
>       perf evlist: Make event_copy local to mmaps
> 
> Feng Tang (2):
>       perf hists browser: Add option for runtime switching perf data file
>       perf report: Enable the runtime switching of perf data file
> 
> Jiri Olsa (4):
>       perf hists browser: Add support to display whole group data for raw columns
>       perf perl scripts: Fix SIGALRM and pipe read race for rwtop
>       perf tools: Fix perf_evsel::exclude_GH handling
>       perf tests: Adding automated parsing tests for group :GH modifiers
> 
> Namhyung Kim (3):
>       perf sort: Drop ip_[lr] arguments from _sort__sym_cmp()
>       perf sort: Make setup_sorting returns an error code
>       perf sort: Check return value of strdup()
> 
> Paul Gortmaker (1):
>       perf tools: Fix calloc argument ordering
> 
> Stephane Eranian (3):
>       perf evlist: Fix set event list leader
>       perf tools: Add cpu_map processor socket level functions
>       perf stat: Add per processor socket count aggregation
> 
>  tools/perf/Documentation/perf-stat.txt |   9 +-
>  tools/perf/Makefile                    |  13 ++-
>  tools/perf/builtin-annotate.c          |   3 +-
>  tools/perf/builtin-diff.c              |   4 +-
>  tools/perf/builtin-evlist.c            |   4 +-
>  tools/perf/builtin-report.c            |  41 +++++---
>  tools/perf/builtin-stat.c              | 126 +++++++++++++++++++++--
>  tools/perf/builtin-top.c               |   3 +-
>  tools/perf/perf.h                      |  26 -----
>  tools/perf/scripts/perl/rwtop.pl       |   6 +-
>  tools/perf/tests/hists_link.c          |   3 +-
>  tools/perf/tests/parse-events.c        | 178 ++++++++++++++++++++++++++++++++-
>  tools/perf/ui/browsers/hists.c         | 112 ++++++++++++++++++++-
>  tools/perf/ui/hist.c                   |  53 +++++-----
>  tools/perf/ui/keysyms.h                |   1 +
>  tools/perf/util/callchain.c            |   2 +-
>  tools/perf/util/cpumap.c               |  54 ++++++++++
>  tools/perf/util/cpumap.h               |   9 ++
>  tools/perf/util/evlist.c               |   7 +-
>  tools/perf/util/evlist.h               |  29 +++++-
>  tools/perf/util/evsel.c                |   2 +-
>  tools/perf/util/evsel.h                |   1 +
>  tools/perf/util/header.c               |   4 +-
>  tools/perf/util/parse-events.c         |   8 --
>  tools/perf/util/python-ext-sources     |   1 +
>  tools/perf/util/sort.c                 |  38 ++++---
>  tools/perf/util/sort.h                 |   2 +-
>  27 files changed, 611 insertions(+), 128 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
