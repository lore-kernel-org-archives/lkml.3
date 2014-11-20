Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaKTHd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:33:59 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:42253 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaKTHd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:33:57 -0500
Date: Thu, 20 Nov 2014 08:33:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Aravinda Prasad <aravinda@linux.vnet.ibm.com>,
        Borislav Petkov <bp@suse.de>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Kan Liang <kan.liang@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Oleg Nesterov <oleg@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@iki.fi>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, systemtap@sourceware.org,
        Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        WANG Chao <chaowang@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/16] perf/core improvements and fixes
Message-ID: <20141120073351.GA498@gmail.com>
References: <1416413016-19110-1-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416413016-19110-1-git-send-email-acme@kernel.org>
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
> The following changes since commit 2565711fb7d7c28e0cd93c8971b520d1b10b857c:
> 
>   perf: Improve the perf_sample_data struct layout (2014-11-16 11:42:04 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo
> 
> for you to fetch changes up to a84808083688d82d7f1e5786ccf5df0ff7d448cb:
> 
>   perf tools: Only override the default :tid comm entry (2014-11-19 12:37:26 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> User visible fixes:
> 
> - Fallback to kallsyms when using the minimal 'ELF' loader (Arnaldo Carvalho de Melo)
> 
> - Fix annotation with kcore (Adrian Hunter)
> 
> - Fix up srcline histogram key formatting (Arnaldo Carvalho de Melo)
> 
> - Add missing handler for PERF_RECORD_MMAP2 events in 'perf diff' (Kan Liang)
> 
> User visible changes/new features:
> 
> - Only print base source file for srcline histogram sort key (Andi Kleen)
> 
> - Support source line numbers in annotate using a hotkey (Andi Kleen)
> 
> Infrastructure:
> 
> - Do not poll events that use the system_wide flag (Adrian Hunter)
> 
> - Add perf-read-vdso32 and perf-read-vdsox32 to .gitignore (Adrian Hunter)
> 
>   perf tools: Only override the default :tid comm entry (Adrian Hunter)
> 
> - Factor out adding new call chain entries (Andi Kleen)
> 
> - Use al.addr to set up call chain (Andi Kleen)
> 
> - Use a common function to resolve symbol or name (Andi Kleen)
> 
> - Fix ftrace:function event recording (Jiri Olsa)
> 
> - Move disable_buildid_cache() to util/build-id.c (Namhyung Kim)
> 
> - Clean up libelf feature support code (Namhyung Kim)
> 
> - fix typo in python 'perf test' (WANG Chao)
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Adrian Hunter (4):
>       perf tools: Fix annotation with kcore
>       perf evlist: Do not poll events that use the system_wide flag
>       perf tools: Add perf-read-vdso32 and perf-read-vdsox32 to .gitignore
>       perf tools: Only override the default :tid comm entry
> 
> Andi Kleen (5):
>       perf callchain: Factor out adding new call chain entries
>       perf callchain: Use al.addr to set up call chain
>       perf callchain: Use a common function to resolve symbol or name
>       perf tools: Only print base source file for srcline
>       perf annotate: Support source line numbers in annotate
> 
> Arnaldo Carvalho de Melo (2):
>       perf symbols: Fallback to kallsyms when using the minimal 'ELF' loader
>       perf hists: Fix up srcline histogram key formatting
> 
> Jiri Olsa (1):
>       perf evsel: Fix ftrace:function event recording
> 
> Kan Liang (1):
>       perf diff: Add missing handler for PERF_RECORD_MMAP2 events
> 
> Namhyung Kim (2):
>       perf build-id: Move disable_buildid_cache() to util/build-id.c
>       perf tools: Clean up libelf feature support code
> 
> WANG Chao (1):
>       perf test: fix typo in python test
> 
>  tools/perf/.gitignore             |  2 ++
>  tools/perf/Makefile.perf          |  2 --
>  tools/perf/builtin-diff.c         |  1 +
>  tools/perf/config/Makefile        |  5 ++--
>  tools/perf/tests/builtin-test.c   |  2 +-
>  tools/perf/ui/browsers/annotate.c | 13 +++++++++-
>  tools/perf/ui/browsers/hists.c    | 17 -------------
>  tools/perf/ui/gtk/hists.c         | 11 +--------
>  tools/perf/ui/stdio/hist.c        | 23 +++++++-----------
>  tools/perf/util/annotate.c        | 32 ++++++++++++++++++++----
>  tools/perf/util/annotate.h        |  1 +
>  tools/perf/util/build-id.c        | 11 +++++++++
>  tools/perf/util/build-id.h        |  1 +
>  tools/perf/util/callchain.c       | 19 +++++++++++++++
>  tools/perf/util/callchain.h       |  3 +++
>  tools/perf/util/evlist.c          | 10 +++++++-
>  tools/perf/util/evsel.c           |  8 ++++++
>  tools/perf/util/header.c          | 10 +-------
>  tools/perf/util/machine.c         | 51 ++++++++++++++++++++++++---------------
>  tools/perf/util/sort.c            |  2 +-
>  tools/perf/util/srcline.c         |  2 +-
>  tools/perf/util/symbol-minimal.c  |  1 -
>  tools/perf/util/thread.c          |  5 ++--
>  tools/perf/util/util.h            |  1 -
>  24 files changed, 145 insertions(+), 88 deletions(-)

Pulled into tip:perf/core, thanks a lot Arnaldo!

	Ingo
