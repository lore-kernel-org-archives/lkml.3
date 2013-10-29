Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab3J2IKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:10:31 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:51420 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab3J2IK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:10:27 -0400
Date: Tue, 29 Oct 2013 09:10:23 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Zhouyi Zhou <yizhouzhou@ict.ac.cn>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/4] perf/urgent fixes
Message-ID: <20131029081023.GA16557@gmail.com>
References: <1382987801-21896-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382987801-21896-1-git-send-email-acme@infradead.org>
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
> The following changes since commit d17cccbea95933a2ab3e260fab128f5128c9371f:
> 
>   Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2013-10-28 15:56:50 +0100)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to 8e50d384cc1d5afd2989cf0f7093756ed7164eb2:
> 
>   perf tools: Fixup mmap event consumption (2013-10-28 16:06:00 -0300)
> 
> ----------------------------------------------------------------
> perf/urgent fixes:
> 
> . Add color overhead for stdio output buffer, which fixes
>   --stdio output being chopped up on the hot (red) entries,
>   fix from Jiri Olsa.
> 
> . Get 'perf record -g -a sleep 1' working again, removing the
>   need for -- separating perf options from the workload, restoring
>   ages old behaviour, fix from Jiri Olsa.
>   More patches allowing ~/.perfconfig setting up of default
>   callchain collecting method ("fp" or "dwarf") left for next
>   merge window.
> 
> . Fixup mmap event consumption, where we were acking the
>   consumption by writing the tail before actually accessing
>   the event, which could lead to using overwritten records
>   in things like 'perf record --call-graph'.  from Zhouyi Zhou.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Jiri Olsa (3):
>       perf hists: Add color overhead for stdio output buffer
>       perf record: Split -g and --call-graph
>       perf top: Split -G and --call-graph
> 
> Zhouyi Zhou (1):
>       perf tools: Fixup mmap event consumption
> 
>  tools/perf/Documentation/perf-record.txt  | 14 +++++-
>  tools/perf/Documentation/perf-top.txt     | 18 +++-----
>  tools/perf/builtin-kvm.c                  |  7 +++
>  tools/perf/builtin-record.c               | 73 +++++++++++++++++++++----------
>  tools/perf/builtin-top.c                  | 33 ++++++++------
>  tools/perf/builtin-trace.c                |  8 ++--
>  tools/perf/tests/code-reading.c           |  1 +
>  tools/perf/tests/keep-tracking.c          |  1 +
>  tools/perf/tests/mmap-basic.c             |  1 +
>  tools/perf/tests/open-syscall-tp-fields.c |  4 +-
>  tools/perf/tests/perf-record.c            |  2 +
>  tools/perf/tests/perf-time-to-tsc.c       |  4 +-
>  tools/perf/tests/sw-clock.c               |  4 +-
>  tools/perf/tests/task-exit.c              |  6 +--
>  tools/perf/ui/stdio/hist.c                |  9 ++--
>  tools/perf/util/callchain.h               |  3 ++
>  tools/perf/util/evlist.c                  | 13 ++++--
>  tools/perf/util/evlist.h                  |  2 +
>  tools/perf/util/hist.h                    | 13 ++++++
>  tools/perf/util/python.c                  |  2 +
>  20 files changed, 151 insertions(+), 67 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
