Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab3LPNyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 08:54:09 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:63180 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab3LPNyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 08:54:07 -0500
Date: Mon, 16 Dec 2013 14:54:01 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/20] perf/core improvements and fixes
Message-ID: <20131216135401.GA3393@gmail.com>
References: <1386947526-7118-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386947526-7118-1-git-send-email-acme@infradead.org>
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
> The following changes since commit c7f2e3cd6c1f4932ccc4135d050eae3f7c7aef63:
> 
>   perf: Optimize ring-buffer write by depending on control dependencies (2013-12-11 15:53:22 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to 41e12e580a7b0c151199f927193548b84d3e874c:
> 
>   tools lib traceevent: Refactor pevent_filter_match() to get rid of die() (2013-12-13 10:30:22 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> Fixes:
> 
> . Fix inverted error verification bug in thread__fork, from David Ahern.
> 
> New features:
> 
> . Shell completion for 'perf kvm', from Ramkumar Ramachandra.
> 
> Refactorings:
> 
> . Get rid of panic() like calls in libtraceevent, from Namyung Kim.
> 
> . Start carving out symbol parsing routines from perf, just moving routines to
>   topic files in tools/lib/symbol/, tools that want to use it need to integrate
>   it directly, i.e. no tools/lib/symbol/Makefile is provided.
> 
> . Assorted refactoring patches, moving code around and adding
>   utility evlist methods that will be used in the IPT patchset,
>   from Adrian Hunter.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Adrian Hunter (5):
>       perf tools: Add perf_event_paranoid()
>       perf header: Allow header->data_offset to be predetermined
>       perf evlist: Add can_select_event() method
>       perf tools: Move mem_bswap32/64 to util.c
>       perf evlist: Add perf_evlist__to_front()
> 
> Arnaldo Carvalho de Melo (1):
>       tools lib symbol: Start carving out symbol parsing routines from perf
> 
> David Ahern (1):
>       perf tools: Fix inverted error verification bug in thread__fork
> 
> Namhyung Kim (12):
>       tools lib traceevent: Get rid of malloc_or_die() in show_error()
>       tools lib traceevent: Get rid of die in add_filter_type()
>       tools lib traceevent: Get rid of malloc_or_die() allocate_arg()
>       tools lib traceevent: Get rid of malloc_or_die() in read_token()
>       tools lib traceevent: Get rid of malloc_or_die() in find_event()
>       tools lib traceevent: Get rid of die() in add_right()
>       tools lib traceevent: Make add_left() return pevent_errno
>       tools lib traceevent: Get rid of die() in reparent_op_arg()
>       tools lib traceevent: Refactor create_arg_item()
>       tools lib traceevent: Refactor process_filter()
>       tools lib traceevent: Make pevent_filter_add_filter_str() return pevent_errno
>       tools lib traceevent: Refactor pevent_filter_match() to get rid of die()
> 
> Ramkumar Ramachandra (1):
>       perf completion: Complete 'perf kvm'
> 
>  tools/lib/symbol/kallsyms.c         |  58 +++++
>  tools/lib/symbol/kallsyms.h         |  24 ++
>  tools/lib/traceevent/event-parse.h  |  43 ++-
>  tools/lib/traceevent/parse-filter.c | 507 ++++++++++++++++++++++--------------
>  tools/perf/MANIFEST                 |   2 +
>  tools/perf/Makefile.perf            |   5 +
>  tools/perf/perf-completion.sh       |   4 +
>  tools/perf/util/event.c             |   1 +
>  tools/perf/util/evlist.c            |  20 +-
>  tools/perf/util/evlist.h            |   5 +
>  tools/perf/util/header.c            |   3 +-
>  tools/perf/util/machine.c           |   1 +
>  tools/perf/util/record.c            |  37 +++
>  tools/perf/util/session.c           |  21 --
>  tools/perf/util/session.h           |   2 -
>  tools/perf/util/symbol-elf.c        |   1 +
>  tools/perf/util/symbol.c            |  69 +----
>  tools/perf/util/symbol.h            |   3 -
>  tools/perf/util/thread.c            |   2 +-
>  tools/perf/util/util.c              |  41 +++
>  tools/perf/util/util.h              |   4 +
>  21 files changed, 550 insertions(+), 303 deletions(-)
>  create mode 100644 tools/lib/symbol/kallsyms.c
>  create mode 100644 tools/lib/symbol/kallsyms.h

Pulled, thanks a lot Arnaldo!

	Ingo
