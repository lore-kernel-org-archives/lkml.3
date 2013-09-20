Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab3ITFPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 01:15:34 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:37639 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab3ITFPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 01:15:32 -0400
Date: Fri, 20 Sep 2013 07:15:28 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Borislav Petkov <bp@suse.de>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vinson Lee <vlee@freedesktop.org>, Vinson Lee <vlee@twitter.com>,
        yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/9] perf/urgent fixes
Message-ID: <20130920051528.GA5930@gmail.com>
References: <1379616032-13061-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379616032-13061-1-git-send-email-acme@infradead.org>
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
> The following changes since commit a8e0108cac181a7b141dacaa99ea52efaf9b5f07:
> 
>   perf: Fix UAPI export of PERF_EVENT_IOC_ID (2013-09-18 11:29:07 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to ce7eebe5c3deef8e19c177c24ee75843256e69ca:
> 
>   tools lib lk: Uninclude linux/magic.h in debugfs.c (2013-09-19 15:08:53 -0300)
> 
> ----------------------------------------------------------------
> perf/urgent fixes:
> 
> . Check for SIGINT in more loops, allowing tools such as 'perf report' to
>   react faster to control+C.
> 
> . Fix objdump line parsing offset validation in the annotate code,
>   from Adrian Hunter.
> 
> . Fix buildid cache handling of kallsyms with kcore, from Adrian Hunter.
> 
> . Fix compile with libelf without get_phdrnum, from Adrian Hunter.
> 
> . Sharpen the libaudit dependencies test, refusing to build with older
>   libraries that doesn't have all the functions used by 'perf trace", fix
>   from Ingo Molnar.
> 
> . Fill in new definitions for madvise()/mmap() flags to fix the build in
>   older systems, from Ingo Molnar.
> 
> . Fix old GCC build error in older systems in the kallsyms parsing code in
>   trace-event-parse.c, from Ingo Molnar.
> 
> . Ignore DWARF declaration tags, allowing, for instance, that the
> 
>     $ perf probe -L getname
> 
>   command succeeds in showing the source code for the 'getname' kernel
>   function, telling in which lines probes can be inserted, fix from
>   Masami Hiramatsu.
> 
> . Fix linux/magic.h related build breakage in some systems, fix from
>   Vinson Lee.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Adrian Hunter (3):
>       perf annotate: Fix objdump line parsing offset validation
>       perf tools: Fix buildid cache handling of kallsyms with kcore
>       perf tools: Fix compile with libelf without get_phdrnum
> 
> Arnaldo Carvalho de Melo (1):
>       perf session: Check for SIGINT in more loops
> 
> Ingo Molnar (3):
>       perf tools: Sharpen the libaudit dependencies test
>       perf tools: Fill in new definitions for madvise()/mmap() flags
>       perf tools: Fix old GCC build error in trace-event-parse.c:parse_proc_kallsyms()
> 
> Masami Hiramatsu (1):
>       perf probe: Fix finder to find lines of given function
> 
> Vinson Lee (1):
>       tools lib lk: Uninclude linux/magic.h in debugfs.c
> 
>  tools/lib/lk/debugfs.c              |  1 -
>  tools/perf/builtin-inject.c         |  2 --
>  tools/perf/builtin-report.c         |  5 +++--
>  tools/perf/builtin-script.c         |  2 --
>  tools/perf/builtin-trace.c          | 17 +++++++++++++++
>  tools/perf/config/Makefile          |  3 +++
>  tools/perf/config/feature-tests.mak | 10 +++++++++
>  tools/perf/util/annotate.c          |  2 +-
>  tools/perf/util/dwarf-aux.c         | 19 +++++++++++++++++
>  tools/perf/util/dwarf-aux.h         |  3 +++
>  tools/perf/util/header.c            | 41 +++++++++++++++++++++++++------------
>  tools/perf/util/hist.c              |  2 ++
>  tools/perf/util/probe-finder.c      | 12 +++++------
>  tools/perf/util/session.c           |  9 ++++++--
>  tools/perf/util/session.h           |  4 ++++
>  tools/perf/util/symbol-elf.c        | 16 +++++++++++++++
>  tools/perf/util/trace-event-parse.c |  2 +-
>  17 files changed, 119 insertions(+), 31 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
