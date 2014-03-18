Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbaCRIY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:24:59 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:42391 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbaCRIY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:24:56 -0400
Date: Tue, 18 Mar 2014 09:24:52 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Darren Hart <dvhart@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Low <jason.low2@hp.com>, Jiri Olsa <jolsa@redhat.com>,
        Joe Mario <jmario@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Scott J Norton <scott.norton@hp.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Waiman Long <Waiman.Long@hp.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/16] perf/core improvements and fixes
Message-ID: <20140318082452.GC28634@gmail.com>
References: <1394832610-17818-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394832610-17818-1-git-send-email-acme@infradead.org>
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
> The following changes since commit 81827ed8d85e892311965dc9ec4120b2b2e745bd:
> 
>   perf/x86/uncore: Fix missing end markers for SNB/IVB/HSW IMC PMU (2014-03-14 09:25:25 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to d75e6097ef1f7669deb500fbbdf53cfe524f1b53:
> 
>   perf machine: Factor machine__find_thread to take tid argument (2014-03-14 18:08:42 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> User visible:
> 
> . Add several futex 'perf bench' microbenchmarks (Davidlohr Bueso)
> 
> . Speed up thread map generation (Don Zickus)
> 
> . Fix synthesizing mmaps for threads (Don Zickus)
> 
> . Fix invalid output on event group stdio report  (Namhyung Kim)
> 
> . Introduce 'perf kvm --list-cmds' command line option for use by
>   scripts (Ramkumar Ramachandra)
> 
> Documentation:
> 
> . Clarify load-latency information in the 'perf mem' docs (Andi Kleen)
> 
> . Clarify x86 register naming in 'perf probe' docs (Andi Kleen)
> 
> Refactorigns:
> 
> . hists browser refactorings to reuse code accross UIs (Namhyung Kim)
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Andi Kleen (2):
>       perf mem: Clarify load-latency in documentation
>       perf probe: Clarify x86 register naming for perf probe
> 
> Arnaldo Carvalho de Melo (1):
>       perf symbols: Introduce thread__find_cpumode_addr_location
> 
> Davidlohr Bueso (3):
>       perf bench: Add futex-hash microbenchmark
>       perf bench: Add futex-wake microbenchmark
>       perf bench: Add futex-requeue microbenchmark
> 
> Don Zickus (3):
>       perf tools: Fix synthesizing mmaps for threads
>       perf session: Change header.misc dump from decimal to hex
>       perf tools: Speed up thread map generation
> 
> Jiri Olsa (1):
>       perf machine: Factor machine__find_thread to take tid argument
> 
> Namhyung Kim (5):
>       perf ui/stdio: Fix invalid output on event group report
>       perf ui/gtk: Reuse generic __hpp__fmt() code
>       perf ui/hists: Pass struct hpp to print functions
>       perf ui/tui: Reuse generic __hpp__fmt() code
>       perf ui hists: Pass evsel to hpp->header/width functions explicitly
> 
> Ramkumar Ramachandra (1):
>       perf kvm: introduce --list-cmds for use by scripts
> 
>  tools/perf/Documentation/perf-mem.txt   |   4 +
>  tools/perf/Documentation/perf-probe.txt |   2 +
>  tools/perf/Makefile.perf                |   3 +
>  tools/perf/bench/bench.h                |   3 +
>  tools/perf/bench/futex-hash.c           | 212 ++++++++++++++++++++++++++++++++
>  tools/perf/bench/futex-requeue.c        | 211 +++++++++++++++++++++++++++++++
>  tools/perf/bench/futex-wake.c           | 201 ++++++++++++++++++++++++++++++
>  tools/perf/bench/futex.h                |  71 +++++++++++
>  tools/perf/builtin-bench.c              |  12 +-
>  tools/perf/builtin-diff.c               |   7 +-
>  tools/perf/builtin-kvm.c                |  12 +-
>  tools/perf/perf-completion.sh           |   2 +-
>  tools/perf/perf.h                       |   6 +
>  tools/perf/tests/dwarf-unwind.c         |   2 +-
>  tools/perf/ui/browsers/hists.c          | 122 ++++++------------
>  tools/perf/ui/gtk/hists.c               |  78 ++----------
>  tools/perf/ui/hist.c                    | 138 +++++++++++++++------
>  tools/perf/ui/stdio/hist.c              |  11 +-
>  tools/perf/util/event.c                 | 156 ++++++++++++++---------
>  tools/perf/util/hist.h                  |  20 ++-
>  tools/perf/util/machine.c               |  46 +++----
>  tools/perf/util/machine.h               |   3 +-
>  tools/perf/util/parse-options.c         |  37 +++++-
>  tools/perf/util/parse-options.h         |   8 +-
>  tools/perf/util/session.c               |   2 +-
>  tools/perf/util/thread.c                |  21 ++++
>  tools/perf/util/thread.h                |   5 +
>  27 files changed, 1094 insertions(+), 301 deletions(-)
>  create mode 100644 tools/perf/bench/futex-hash.c
>  create mode 100644 tools/perf/bench/futex-requeue.c
>  create mode 100644 tools/perf/bench/futex-wake.c
>  create mode 100644 tools/perf/bench/futex.h

Pulled, thanks a lot Arnaldo!

	Ingo
