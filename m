Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab3IKFqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:46:47 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:39447 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab3IKFqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 01:46:46 -0400
Date: Wed, 11 Sep 2013 07:46:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/5] perf/urgent fixes
Message-ID: <20130911054638.GA15395@gmail.com>
References: <1378836722-31326-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378836722-31326-1-git-send-email-acme@infradead.org>
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
> The following changes since commit 72f4a11d2fb16792f5e5107922652366194cfd66:
> 
>   Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2013-09-06 14:08:08 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to e08eedca944bd6419c9441012e98e7af14ebd175:
> 
>   perf: Fix up MMAP2 buffer space reservation (2013-09-10 10:42:20 -0300)
> 
> ----------------------------------------------------------------
> perf/urgent fixes:
> 
> . Handle perf.data files with no tracepoints in 'perf trace', fixing a
>   segfault.
> 
> . Fix up MMAP2 buffer space reservation, a problem that was caught via
>   'perf test' consistency tests.
> 
> . Add attr->mmap2 support in the tools, a patch that should've been merged
>   together with the kernel counterpart:
> 
>     13d7a24 "perf: Add attr->mmap2 attribute to an event".
> 
>   Merging it allowed us to catch the MMAP buffer space reservation problem via
>   'perf test'. From Stephane Eranian.
> 
> . Make sure we can find PERF_SAMPLE_ID in the variable part of PERF_RECORD_
>   ring buffer records in 'perf kvm', where direct manipulation of sample_type
>   was being done.
> 
>   Fixed by making use of the perf_evlist__set_sample_bit() helper and by
>   setting the evlist->id_pos in perf_evlist__open(), from Adrian Hunter.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Adrian Hunter (2):
>       perf evlist: Fix id pos in perf_evlist__open()
>       perf kvm: Fix sample_type manipulation
> 
> Arnaldo Carvalho de Melo (2):
>       perf trace: Handle perf.data files with no tracepoints
>       perf: Fix up MMAP2 buffer space reservation
> 
> Stephane Eranian (1):
>       perf tools: Add attr->mmap2 support
> 
>  kernel/events/core.c           |  1 +
>  tools/perf/builtin-annotate.c  |  1 +
>  tools/perf/builtin-inject.c    | 15 ++++++++++
>  tools/perf/builtin-kvm.c       | 18 ++++++------
>  tools/perf/builtin-mem.c       |  1 +
>  tools/perf/builtin-report.c    |  1 +
>  tools/perf/builtin-script.c    |  1 +
>  tools/perf/tests/perf-record.c | 15 +++++++---
>  tools/perf/util/build-id.c     |  1 +
>  tools/perf/util/event.c        | 56 ++++++++++++++++++++++++++++--------
>  tools/perf/util/event.h        | 19 ++++++++++++
>  tools/perf/util/evlist.c       | 12 ++++++++
>  tools/perf/util/evsel.c        |  5 ++--
>  tools/perf/util/header.c       |  3 ++
>  tools/perf/util/machine.c      | 53 +++++++++++++++++++++++++++++++++-
>  tools/perf/util/machine.h      |  1 +
>  tools/perf/util/map.c          |  8 +++++-
>  tools/perf/util/map.h          |  8 ++++--
>  tools/perf/util/session.c      | 65 ++++++++++++++++++++----------------------
>  tools/perf/util/tool.h         |  1 +
>  20 files changed, 220 insertions(+), 65 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
