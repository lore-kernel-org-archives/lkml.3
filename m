Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbaEERmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:42:10 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:56848 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbaEERmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:42:05 -0400
Date: Mon, 5 May 2014 19:41:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Sasha Levin <sasha.levin@oracle.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [GIT PULL 01/12] perf/core improvements and fixes
Message-ID: <20140505174159.GA7324@gmail.com>
References: <1399311348-28152-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399311348-28152-1-git-send-email-jolsa@kernel.org>
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
> The following changes since commit 3617660e4e1618a888a2e3a4067224534302cb33:
> 
>   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/core (2014-05-01 08:24:59 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-core-for-mingo
> 
> for you to fetch changes up to 73a31b7c6a85e2f033524058bad5bce900e4f2ed:
> 
>   perf tools: Move ACCESS_ONCE from perf.h header (2014-05-05 17:49:07 +0200)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> . Cleanups for perf.h header (Jiri Olsa)
> 
> . Consolidate types.h and export.h within tools (Borislav Petkov)
> 
> ----------------------------------------------------------------
> Borislav Petkov (2):
>       tools: Unify export.h
>       tools: Consolidate types.h
> 
> Jiri Olsa (10):
>       perf tools: Remove MAX_COUNTERS define from perf.h
>       perf tools: Remove unlikely define from perf.h
>       perf tools: Remove min define from perf.h
>       perf tools: Remove asmlinkage define from perf.h
>       perf tools: Remove PR_TASK_PERF_EVENTS_* from perf.h
>       perf tools: Move sample data structures from perf.h
>       perf tools: Move perf_call_graph_mode enum from perf.h
>       perf tools: Move syscall and arch specific defines from perf.h
>       perf tools: Move sys_perf_event_open function from perf.h
>       perf tools: Move ACCESS_ONCE from perf.h header
> 
>  tools/include/linux/compiler.h                     |   2 +
>  tools/{virtio => include}/linux/export.h           |   5 +
>  .../lockdep/uinclude => include}/linux/types.h     |  29 ++-
>  tools/lib/lockdep/Makefile                         |   2 +-
>  tools/lib/lockdep/uinclude/linux/export.h          |   7 -
>  tools/perf/MANIFEST                                |   2 +
>  tools/perf/Makefile.perf                           |   5 +-
>  tools/perf/arch/x86/include/perf_regs.h            |   2 +-
>  tools/perf/arch/x86/util/tsc.c                     |   2 +-
>  tools/perf/arch/x86/util/tsc.h                     |   2 +-
>  tools/perf/perf-sys.h                              | 190 +++++++++++++++
>  tools/perf/perf.h                                  | 254 +--------------------
>  tools/perf/tests/attr.c                            |   7 -
>  tools/perf/tests/code-reading.c                    |   3 +-
>  tools/perf/tests/dso-data.c                        |   2 +-
>  tools/perf/tests/dwarf-unwind.c                    |   2 +-
>  tools/perf/tests/keep-tracking.c                   |   2 +-
>  tools/perf/tests/parse-no-sample-id-all.c          |   2 +-
>  tools/perf/tests/perf-time-to-tsc.c                |   3 +-
>  tools/perf/tests/rdpmc.c                           |   2 +-
>  tools/perf/tests/sample-parsing.c                  |   2 +-
>  tools/perf/ui/browser.h                            |   4 +-
>  tools/perf/ui/progress.h                           |   2 +-
>  tools/perf/util/annotate.h                         |   2 +-
>  tools/perf/util/build-id.h                         |   2 +-
>  tools/perf/util/callchain.h                        |   7 +
>  tools/perf/util/dso.h                              |   2 +-
>  tools/perf/util/event.h                            |  24 ++
>  tools/perf/util/evsel.h                            |   4 +-
>  tools/perf/util/header.h                           |   4 +-
>  tools/perf/util/include/linux/bitmap.h             |   3 +
>  tools/perf/util/include/linux/export.h             |   6 -
>  tools/perf/util/include/linux/list.h               |   1 +
>  tools/perf/util/include/linux/types.h              |  29 ---
>  tools/perf/util/map.h                              |   2 +-
>  tools/perf/util/parse-events.h                     |   3 +-
>  tools/perf/util/parse-events.y                     |   2 +-
>  tools/perf/util/perf_regs.h                        |   2 +-
>  tools/perf/util/pmu.h                              |   2 +-
>  tools/perf/util/stat.h                             |   2 +-
>  tools/perf/util/svghelper.c                        |   2 +-
>  tools/perf/util/svghelper.h                        |   2 +-
>  tools/perf/util/symbol.h                           |   1 +
>  tools/perf/util/top.h                              |   2 +-
>  tools/perf/util/types.h                            |  19 --
>  tools/perf/util/unwind-libdw.c                     |   2 +-
>  tools/perf/util/unwind.h                           |   2 +-
>  tools/perf/util/util.h                             |   2 +-
>  tools/perf/util/values.h                           |   2 +-
>  tools/virtio/Makefile                              |   2 +-
>  tools/virtio/linux/kernel.h                        |   7 -
>  tools/virtio/linux/types.h                         |  28 ---
>  52 files changed, 304 insertions(+), 397 deletions(-)
>  rename tools/{virtio => include}/linux/export.h (70%)
>  rename tools/{lib/lockdep/uinclude => include}/linux/types.h (63%)
>  delete mode 100644 tools/lib/lockdep/uinclude/linux/export.h
>  create mode 100644 tools/perf/perf-sys.h
>  delete mode 100644 tools/perf/util/include/linux/export.h
>  delete mode 100644 tools/perf/util/include/linux/types.h
>  delete mode 100644 tools/perf/util/types.h
>  delete mode 100644 tools/virtio/linux/types.h

Pulled, thanks a lot Jiri!

	Ingo
